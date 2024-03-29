/* CLIC METRIC 2022
   DATA MODEL: ACT
   DBMS: MSSQL
   MAINTAINER: DARREN W HENDERSON <darren.henderson@uky.edu>
*/

/* CLEAR OUT PREVIOUS TEMP TABLES */
IF OBJECT_ID(N'tempdb..#tmp_cm22_user_input', 'U') IS NOT NULL      DROP TABLE #tmp_cm22_user_input;
IF OBJECT_ID(N'tempdb..#CTSA_DOMAINS', 'U') IS NOT NULL             DROP TABLE #CTSA_DOMAINS;
IF OBJECT_ID(N'tempdb..#CTSA_DOMAIN_CONCEPTS', 'U') IS NOT NULL     DROP TABLE #CTSA_DOMAIN_CONCEPTS;
IF OBJECT_ID(N'tempdb..#tmp_cm22_c1yr', 'U') IS NOT NULL 			      DROP TABLE #tmp_cm22_c1yr;
IF OBJECT_ID(N'tempdb..#tmp_cm22_c5yr', 'U') IS NOT NULL 			      DROP TABLE #tmp_cm22_c5yr;
IF OBJECT_ID(N'tempdb..#tmp_cm22_masterPatient', 'U') IS NOT NULL 	DROP TABLE #tmp_cm22_masterPatient;
IF OBJECT_ID(N'tempdb..#cm22_concept_checks', 'U') IS NOT NULL 	    DROP TABLE #cm22_concept_checks;
IF OBJECT_ID(N'tempdb..#cm22_output', 'U') IS NOT NULL 	            DROP TABLE #cm22_output;
/* 
-------------------------
	START user input
	
*/

SELECT
	 4 as data_model		-- Which CDM are you using?	                          (1=PCORNet, 2=OMOP, 3=TriNetX, 4=i2b2/ACT)
	,1 as nlp_any			  -- Does your hub have any NLP capabilities?	          (0=No, 1=Yes, NULL=unknown)
	,1 as text_search		-- Does your site have free text search capabilities?	(0=No, 1=Yes, NULL=unknown)
INTO #tmp_cm22_user_input
;
/* 

	END user input 
-------------------------	
*/

/* BUILD FACT DOMAINS TABLE */

CREATE TABLE #CTSA_DOMAINS (
  VARIABLE_NAME VARCHAR(100),
  CONCEPT_PATH VARCHAR(4000)
)

INSERT INTO #CTSA_DOMAINS (VARIABLE_NAME, CONCEPT_PATH)
VALUES ('uniq_pt_snomed_proc','\ACT\SNOMED\%') /*THIS IS NOT SUPPORTED BY ACT - IF YOU HAVE THEM MODIFY PATH ACCORDINGLY*/
,('uniq_pt_snomed_dx','\ACT\SNOMED\%') /*THIS IS NOT SUPPORTED BY ACT - IF YOU HAVE THEM MODIFY PATH ACCORDINGLY*/
,('uniq_pt_note','\ACT\Notes\%') /*THIS IS NOT SUPPORTED BY ACT - IF YOU HAVE THEM MODIFY PATH ACCORDINGLY*/
,('uniq_pt_insurance_value_set','\ACT\SDOH\76437-3\%')
,('uniq_pt_any_insurance_value','\ACT\SDOH\76437-3\%')
,('uniq_pt_icd_proc','\ACT\Procedures\ICD9\%')
,('uniq_pt_icd_proc','\ACT\Procedures\ICD10\%')
,('uniq_pt_loinc','\ACT\Lab\%')
,('uniq_pt_loinc','\ACT\Labs\%')
,('uniq_pt_med_rxnorm','\ACT\Medications\%')
,('uniq_pt_icd_dx','\ACT\Diagnosis\%')
,('uniq_pt_cpt','\ACT\Procedures\HCPCS\%')
,('uniq_pt_cpt','\ACT\Procedures\CPT4\%')
,('uniq_pt_vital_sign','\ACT\Vital Signs\%')
,('uniq_pt_smoking','\ACT\Diagnosis\ICD10\V2_2018AA\A20098492\A20160670\A18921523\A17812661\%')
,('uniq_pt_smoking','\ACT\SDOH\LP156992-2\%')
,('uniq_pt_opioid','\ACT\Medications\MedicationsByAlpha\V2_12112018\RxNormUMLSRxNav\BPreparations\1819\%')
,('uniq_pt_opioid','\ACT\Medications\MedicationsByAlpha\V2_12112018\RxNormUMLSRxNav\BPreparations\352364\%')
,('uniq_pt_opioid','\ACT\Medications\MedicationsByAlpha\V2_12112018\RxNormUMLSRxNav\MPreparations\6813\%')
,('uniq_pt_opioid','\ACT\Medications\MedicationsByAlpha\V2_12112018\RxNormUMLSRxNav\NPreparations\1007909\%')
,('uniq_pt_opioid','\ACT\Medications\MedicationsByAlpha\V2_12112018\RxNormUMLSRxNav\NPreparations\7242\%')
,('uniq_pt_opioid','\ACT\Medications\MedicationsByAlpha\V2_12112018\RxNormUMLSRxNav\BPreparations\352364\%')
,('uniq_pt_opioid','\ACT\Medications\MedicationsByAlpha\V2_12112018\RxNormUMLSRxNav\NPreparations\214721\%')
,('uniq_pt_opioid','\ACT\Medications\MedicationsByAlpha\V2_12112018\RxNormUMLSRxNav\NPreparations\1545902\%')
,('uniq_pt_opioid','\ACT\Diagnosis\ICD10\V2_2018AA\A20098492\A20160670\A18921523\A17774215\%');

SELECT DISTINCT DOM.VARIABLE_NAME, DIM.CONCEPT_CD 
INTO #CTSA_DOMAIN_CONCEPTS
FROM CONCEPT_DIMENSION DIM
  JOIN #CTSA_DOMAINS DOM
    ON DIM.CONCEPT_PATH LIKE DOM.CONCEPT_PATH;

/* DOMAIN TABLES BUILT */


/* GENERATE c1yr and c5yr patient list for patients having facts in the 1 and 5 year windows 
   ENSURES THE PATIENT HAS FACTS RELATED TO THE CLIC DOMAINS OF INTEREST TO FILTER OUT PATIENTS HAVING *ONLY* FACTS
   IN UNRELATED DOMAINS THAT SITES MIGHT BE MANAGING FOR INTERNAL PROJECTS    
*/

SELECT DISTINCT PATIENT_NUM
INTO #tmp_cm22_c1yr
FROM DBO.OBSERVATION_FACT F
  JOIN #CTSA_DOMAIN_CONCEPTS DOMC
    ON F.CONCEPT_CD = DOMC.CONCEPT_CD
WHERE CONVERT(DATE,START_DATE) BETWEEN '20210101' AND '20211231'

SELECT DISTINCT PATIENT_NUM
INTO #tmp_cm22_c5yr
FROM DBO.OBSERVATION_FACT F
  JOIN #CTSA_DOMAIN_CONCEPTS DOMC
    ON F.CONCEPT_CD = DOMC.CONCEPT_CD
WHERE CONVERT(DATE,START_DATE) BETWEEN '20170101' AND '20211231'

SELECT COALESCE(C1.PATIENT_NUM, C5.PATIENT_NUM) PATIENT_NUM /* EITHER/OR FROM FULL OUTER - ONE ROW PER PATIENT PRESENT IN EITHER TABLE */
  , CASE WHEN C1.PATIENT_NUM IS NULL THEN 0 ELSE 1 END AS ONE_YEAR /* LETS US JUST USE SUM INSTEAD OF COUNT(DISTINCT THE REST OF THE WAY HERE */
  , CASE WHEN C5.PATIENT_NUM IS NULL THEN 0 ELSE 1 END AS FIVE_YEAR
INTO #tmp_cm22_masterPatient
FROM #tmp_cm22_c1yr C1 FULL OUTER JOIN #tmp_cm22_c5yr C5
  ON C1.PATIENT_NUM = C5.PATIENT_NUM
   
/* END PATIENT LISTS */


/* TOP CONCEPT CD METRICS
   LOAD TSV FILES AND COMBINE THEM INTO TABLE AND ADD A VOCABULARY COLUMN. 
   ALTERNATIVELY utilize InformaticsMetricACTSQLServer_refreshTSV_CM22_CONCEPT_CHECK.sql to download files directly from github into a table.
*/

SELECT VOCABULARY, COUNT(DISTINCT CONCEPT_CD) DENOMINATOR
  , COUNT(ONEYEAR_CONCEPT) AS ONEYEAR_NUMERATOR
  , COUNT(FIVEYEAR_CONCEPT) AS FIVEYEAR_NUMERATOR
INTO #cm22_concept_checks
FROM (
SELECT SCC.VOCABULARY
  , SCC.CONCEPT_CD
  , MAX(CASE WHEN CONVERT(DATE,F.START_DATE) BETWEEN '20210101' AND '20211231' THEN 1 ELSE NULL END) AS ONEYEAR_CONCEPT
  , MAX(CASE WHEN CONVERT(DATE,F.START_DATE) BETWEEN '20170101' AND '20211231' THEN 1 ELSE NULL END) AS FIVEYEAR_CONCEPT

FROM CM22_CONCEPT_CHECKS SCC
  LEFT JOIN OBSERVATION_FACT F
    ON SCC.CONCEPT_CD = F.CONCEPT_CD
    AND CONVERT(DATE,F.START_DATE) BETWEEN '20170101' AND '20211231'
GROUP BY SCC.VOCABULARY, SCC.CONCEPT_CD
)CF
GROUP BY VOCABULARY

/* END TOP CONCEPT CD METRICS */

/* FINAL OUTPUT */

CREATE TABLE #cm22_output(variable_name varchar(100), one_year varchar(50), five_year varchar(50))

INSERT INTO #cm22_output(variable_name,one_year,five_year)
SELECT 
	'data_model' as variable_name
	,(SELECT TOP 1 data_model from #tmp_cm22_user_input) as one_year -- 4 = ACT
	,(SELECT TOP 1 data_model from #tmp_cm22_user_input) as five_year -- 4 = ACT
UNION
SELECT
	'nlp_any' as variable_name
	,(SELECT TOP 1 nlp_any from #tmp_cm22_user_input) as one_year 
	,(SELECT TOP 1 nlp_any from #tmp_cm22_user_input) as five_year
UNION
SELECT
	'text_search' as variable_name
	,(SELECT TOP 1 text_search from #tmp_cm22_user_input) as one_year 
	,(SELECT TOP 1 text_search from #tmp_cm22_user_input) as five_year

INSERT INTO #cm22_output(variable_name,one_year,five_year)
SELECT 'total_patients' as variable_name  , SUM(ONE_YEAR) AS ONE_YEAR, SUM(FIVE_YEAR) FIVE_YEAR
FROM #tmp_cm22_masterPatient
UNION
SELECT 'uniq_pt_with_age' as variable_name, SUM(ONE_YEAR) AS ONE_YEAR, SUM(FIVE_YEAR) FIVE_YEAR
FROM #tmp_cm22_masterPatient M
  JOIN PATIENT_DIMENSION P
    ON M.PATIENT_NUM = P.PATIENT_NUM
    AND P.BIRTH_DATE IS NOT NULL
UNION
SELECT 'uniq_pt_age_over_120' as variable_name, SUM(ONE_YEAR) AS ONE_YEAR, SUM(FIVE_YEAR) FIVE_YEAR
FROM #tmp_cm22_masterPatient M
  JOIN PATIENT_DIMENSION P
    ON M.PATIENT_NUM = P.PATIENT_NUM
    AND DATEDIFF(YEAR,P.BIRTH_DATE,COALESCE(P.DEATH_DATE,'20221231')) > 120
UNION
SELECT 'uniq_pt_with_gender' as variable_name, SUM(ONE_YEAR) AS ONE_YEAR, SUM(FIVE_YEAR) FIVE_YEAR
FROM #tmp_cm22_masterPatient M
  JOIN PATIENT_DIMENSION P
    ON M.PATIENT_NUM = P.PATIENT_NUM
    AND P.SEX_CD IS NOT NULL

INSERT INTO #cm22_output(variable_name,one_year,five_year)
SELECT VARIABLE_NAME, SUM(ONE_YEAR*ONE_YEAR_FACT) ONE_YEAR, SUM(FIVE_YEAR*FIVE_YEAR_FACT) FIVE_YEAR
FROM (
SELECT DOMC.VARIABLE_NAME
  , M.PATIENT_NUM, M.ONE_YEAR, M.FIVE_YEAR
  , MAX(CASE WHEN CONVERT(DATE,START_DATE) BETWEEN '20210101' AND '20211231' THEN 1 ELSE 0 END) AS ONE_YEAR_FACT /* IF PATIENT HAS A ONE YEAR FACT WE'LL MULTIPLY 1X1 ELSE MULTIPLY 0X1 AND TAKE THE SUM */
  , MAX(CASE WHEN CONVERT(DATE,START_DATE) BETWEEN '20170101' AND '20211231' THEN 1 ELSE 0 END) AS FIVE_YEAR_FACT /* IF PATIENT HAS A FIVE YEAR FACT WE'LL MULTIPLY 1X1 ELSE MULTIPLY 0X1 AND TAKE THE SUM */
FROM #tmp_cm22_masterPatient M
  JOIN OBSERVATION_FACT F
    ON M.PATIENT_NUM = F.PATIENT_NUM
    AND CONVERT(DATE,F.START_DATE) BETWEEN '20170101' AND '20211231'
  JOIN #CTSA_DOMAIN_CONCEPTS DOMC
    ON F.CONCEPT_CD = DOMC.CONCEPT_CD
GROUP BY DOMC.VARIABLE_NAME, M.PATIENT_NUM, M.ONE_YEAR, M.FIVE_YEAR
)DOMF
GROUP BY VARIABLE_NAME
ORDER BY VARIABLE_NAME

/* INSERT ZERO COUNTS FOR DOMAINS NOT FOUND IN SITE FACT TABLE */
INSERT INTO #cm22_output(variable_name,one_year,five_year)
SELECT distinct VARIABLE_NAME, 0 AS ONE_YEAR, 0 AS FIVE_YEAR
FROM #CTSA_DOMAIN_CONCEPTS where VARIABLE_NAME not in (select variable_name from #cm22_output)
ORDER BY VARIABLE_NAME

INSERT INTO #cm22_output(variable_name,one_year,five_year)
SELECT CONCAT(VOCABULARY,'_check') as variable_name
  , TRY_CAST(1.0*ONEYEAR_NUMERATOR/DENOMINATOR *100 AS NUMERIC(10,2)) AS ONE_YEAR
  , TRY_CAST(1.0*FIVEYEAR_NUMERATOR/DENOMINATOR*100 AS NUMERIC(10,2)) AS FIVE_YEAR
FROM #cm22_concept_checks
ORDER BY 1

SELECT * FROM #cm22_output







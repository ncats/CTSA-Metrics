/*
CTSA Common Metrics 2022 
	OMOP 
	Oracle
Author : Robert Miller, Tufts CTSI
https://github.com/ncats/CTSA-Metrics

Structure:
	1) *** user input variables ***
	2) clear potentially leftover temp tables
	3) generate prerequisite temp tables
	4) generate metrics 

Assumes:
	Ability to create temp tables
	Read access to OMOP CDM clinical and vocabulary tables
		-if your site stores the clinical and vocabulary tables in separate databases or schemas you will need to update the table references accordingly 

References:
	Clinical tables:	PERSON, DEATH, DRUG_EXPOSURE, DEVICE_EXPOSURE, OBSERVATION, MEASUREMENT, PROCEDURE_OCCURRENCE, CONDITION_OCCURRENCE
	Vocabulary tables:	CONCEPT, CONCEPT_RELATIONSHIP, CONCEPT_ANCESTOR
	Vocabularies:		ICD9CM, ICD10CM, SNOMED, LOINC, CPT4, HCPCS, RxNorm, ICD9Proc, ICD10PCS

*/ 


--1) *** user input variables ***
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE tncatscm22_userinput';
  EXECUTE IMMEDIATE 'DROP TABLE tncatscm22_userinput';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
/* 
-------------------------
	START user input
*/
CREATE TABLE tncatscm22_userinput
  AS
SELECT
	2 as data_model			-- Which CDM are you using?								(1=PCORNet, 2=OMOP, 3=TriNetX, 4=i2b2/ACT)
	,NULL as nlp_any			-- Does your hub have any NLP capabilities?				(0=No, 1=Yes, NULL=unknown)
	,NULL as text_search		-- Does your site have free text search capabilities?	(0=No, 1=Yes, NULL=unknown)
FROM
DUAL;
/* 
	END user input 
-------------------------	
*/



--2) clear potentially leftover temp tables
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE tncatscm22_vitals';
  EXECUTE IMMEDIATE 'DROP TABLE tncatscm22_vitals';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE tncatscm22_smoking';
  EXECUTE IMMEDIATE 'DROP TABLE tncatscm22_smoking';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;

BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE tncatscm22_c1yr';
  EXECUTE IMMEDIATE 'DROP TABLE tncatscm22_c1yr';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE tncatscm22_c5yr';
  EXECUTE IMMEDIATE 'DROP TABLE tncatscm22_c5yr';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE tncatscm22_cconcepts';
  EXECUTE IMMEDIATE 'DROP TABLE tncatscm22_cconcepts';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE tncatscm22_cchecks1yr';
  EXECUTE IMMEDIATE 'DROP TABLE tncatscm22_cchecks1yr';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE tncatscm22_cchecks5yr';
  EXECUTE IMMEDIATE 'DROP TABLE tncatscm22_cchecks5yr';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;

--3) generate prerequisite temp tables
-- vital sign concepts
CREATE TABLE tncatscm22_vitals
 AS
SELECT
conc.*
FROM
CONCEPT_ANCESTOR ca
INNER JOIN CONCEPT conc
ON ancestor_concept_id IN
(
	3036277
	,3025315
	,45876174
	,1002813
	,4245997
	,1004059
	,4178505
)
AND ca.descendant_concept_id = conc.concept_id
AND conc.standard_concept = 'S'
 ;
-- smoking concepts
CREATE TABLE tncatscm22_smoking
 AS
SELECT
conc.*
FROM
CONCEPT_RELATIONSHIP cr 
INNER JOIN CONCEPT conc
ON cr.concept_id_1 IN
(SELECT concept_id
	FROM CONCEPT
	  WHERE concept_code in 
	(
		'Z87.891'
		,'F17.20'
		,'F17.200'
		, 'F17.201'
		, 'F17.203'
		, 'F17.208'
		, 'F17.209'
		, 'F17.21'
		, 'F17.210'
		, 'F17.211'
		, 'F17.213'
		, 'F17.218'
		, 'F17.219'
	)
 )
AND cr.concept_id_2 = conc.concept_id
AND conc.standard_concept = 'S'
AND cr.relationship_id = 'Maps to'
 ;
-- Generate 1yr cohort 
-- cohort definition : any fact in timeframe (diagnosis, procedure, drug, device, measurement, observation) 
CREATE TABLE tncatscm22_c1yr
 AS
SELECT
DISTINCT person_id
FROM
condition_occurrence 
    WHERE condition_start_date BETWEEN '01-01-2021' AND '12-31-2021'
   UNION 
SELECT DISTINCT person_id
FROM procedure_occurrence 
    WHERE procedure_date BETWEEN '01-01-2021' AND '12-31-2021'
   UNION 
SELECT DISTINCT person_id
FROM drug_exposure
    WHERE drug_exposure_start_date BETWEEN '01-01-2021' AND '12-31-2021'
   UNION 
SELECT DISTINCT person_id
FROM device_exposure
    WHERE device_exposure_start_date BETWEEN '01-01-2021' AND '12-31-2021'
   UNION 
SELECT DISTINCT person_id
FROM measurement
    WHERE measurement_date BETWEEN '01-01-2021' AND '12-31-2021'
   UNION 
SELECT DISTINCT person_id
FROM observation
  WHERE observation_date BETWEEN '01-01-2021' AND '12-31-2021'
           ;
-- Generate 5yr cohort
CREATE TABLE tncatscm22_c5yr
 AS
SELECT
DISTINCT person_id
FROM
condition_occurrence 
    WHERE condition_start_date BETWEEN '01-01-2017' AND '12-31-2021'		
   UNION 
SELECT DISTINCT person_id
FROM procedure_occurrence 
    WHERE procedure_date BETWEEN '01-01-2017' AND '12-31-2021'	
   UNION 
SELECT DISTINCT person_id
FROM drug_exposure
    WHERE drug_exposure_start_date BETWEEN '01-01-2017' AND '12-31-2021'
   UNION 
SELECT DISTINCT person_id
FROM device_exposure
    WHERE device_exposure_start_date BETWEEN '01-01-2017' AND '12-31-2021'
   UNION 
SELECT DISTINCT person_id
FROM measurement
    WHERE measurement_date BETWEEN '01-01-2017' AND '12-31-2021'
   UNION 
SELECT DISTINCT person_id
FROM observation
  WHERE observation_date BETWEEN '01-01-2017' AND '12-31-2021'
           ;
-- Vocabulary utilization concept checks 
-- create list of concepts 
CREATE TABLE tncatscm22_cconcepts
 AS
SELECT
x.concept_id as src_concept_id
	,x.vocabulary_id as src_vocabulary_id
	,x.domain_id as src_domain_id
	,x.concept_code as src_concept_code
	,mapped_concept.concept_id as mapped_concept_id
	,mapped_concept.vocabulary_id as mapped_vocabulary_id
	,mapped_concept.domain_id as mapped_domain_id
	,mapped_concept.concept_code as mapped_concept_code
FROM
(SELECT *
	FROM concept
	    WHERE vocabulary_id = 'ICD9CM'
	AND concept_code in ('174.9','244.9','250.00','268.9','272.0','272.4','278.00','285.9','300.00','305.1','311','327.23','401.1','401.9','414.00','414.01','427.31','428.0','462','465.9','477.9','493.90','496','530.81','599.0','715.90','719.46','724.2','724.5','729.1','729.5','733.00','780.79','784.0','786.05','786.2','786.50','789.00','V03.82','V04.81','V06.1','V10.3','V20.2','V22.0','V22.0','V22.1','V22.1','V43.3','V45.89','V54.89','V58.0','V58.11','V58.61','V58.69','V67.09','V70.0','V72.31','V76.12','V76.2')
	   UNION
	SELECT *
	FROM concept
	  WHERE vocabulary_id = 'ICD10CM'
	AND concept_code in ('D64.9','E03.9','E11.65','E11.65','E11.9','E55.9','E66.01','E66.9','E78.00','E78.2','E78.5','F17.200','F17.210','F17.210','F32.9','F41.1','F41.9','G47.33','G89.29','I10','I25.10','I48.0','I48.2','I48.91','J02.9','J06.9','J44.9','J45.909','K21.9','M19.90','M25.561','M25.562','M54.2','M54.5','N18.3','R05','R06.02','R07.9','R10.9','R53.83','R94.31','Y92.9','Y93.9','Z00.00','Z00.129','Z01.419','Z01.818','Z12.11','Z12.31','Z23','Z51.0','Z51.11','Z71.3','Z79.01','Z79.4','Z79.82','Z79.899','Z87.891','Z98.890')
	   UNION
	SELECT *
	FROM concept
	  WHERE vocabulary_id = 'LOINC'
	AND concept_code in ('10466-1','1742-6','1744-2','1751-7','17861-6','19123-9','1920-8','1960-4','1962-0','1963-8','1975-2','2019-8','2028-9','20564-1','20570-8','2075-0','2160-0','2339-0','2345-7','26450-7','26485-3','2703-7','2708-6','2711-0','2713-6','2744-1','2777-1','2823-3','2885-2','2951-2','30180-4','3094-0','3097-3','32623-1','33037-3','33914-3','4544-3','48642-3','48643-1','51731-8','58413-6','5902-2','5905-5','61152-5','62238-1','6301-6','6463-4','66746-9','6690-2','6768-6','704-7','706-2','711-2','713-8','71695-1','718-7','731-0','736-9','742-7','751-8','770-8','777-3','785-6','786-4','787-2','788-0','789-8','8310-5','933-2','934-0')
	   UNION
	SELECT *
	FROM concept
	  WHERE vocabulary_id = 'RxNorm'
	AND concept_code in ('834023','2418','6918','104491','105029','1050490','1189779','1246235','1360292','141928','1495474','1495476','152698','152923','153892','1664448','205770','206765','206766','206821','208161','209387','209459','212340','212549','212575','213169','261224','284400','311036','540472','540848','541713','541815','541872','542673','542678','617314','617318','617320','628530','824194','828350','835605','859096','861006','861008','863671','865098','866516','967525','1049221','998740','1115005','1361615','1437702','1049621','876193','866924','857002','1658634','1659137','1665088','1732006','1735003','1735004','1740467','1807628','1807632','1807633','198440','310273','310431','313782','314200','318272','617311','834127','854235','1797907','1795964','901044','1490493')
	   UNION
	SELECT *
	FROM concept
	  WHERE vocabulary_id = 'CPT4'
	AND concept_code in ('00790','01967','36415','70450','71045','80048','80051','80053','80061','80076','81000','81002','81003','82043','82306','82310','82330','82565','82607','82805','82947','82962','83036','83605','83615','83690','83735','84100','84132','84153','84295','84439','84443','84450','84460','84484','84520','84550','84999','85004','85014','85025','85027','85610','85652','85730','86140','86850','86900','86901','87040','87070','87086','88185','88305','88399','90460','90471','93000','93005','93010','94640','95004','97530','99024','99203','99212','99213','99214','99215','99232','99233','99244','99283','99284','99285')
	   UNION
	SELECT *
	FROM concept
	  WHERE vocabulary_id = 'HCPCS'
	AND concept_code in ('A7003','A9585','A9999','E1399','G0008','G0009','G0105','G0121','G0378','G0444','J0131','J0133','J0171','J0461','J0583','J0585','J0690','J0692','J0712','J0878','J1030','J1040','J1050','J1100','J1442','J1642','J1644','J1650','J1756','J1815','J1953','J2001','J2185','J2248','J2250','J2370','J2405','J2543','J2704','J2710','J2795','J3010','J3301','J3420','J3475','J3480','J3490','J7030','J7185','J7187','J7189','J7192','J7195','J7323','J7512','J7613','J8540','J9250','J9263','J9267','Q0091','Q0162','Q5101','Q9959','Q9967') 
	   UNION
	SELECT *
	FROM concept
	  WHERE vocabulary_id = 'ICD9Proc'
	AND concept_code in ('00.40','00.66','03.31','03.91','03.92','04.81','13.41','13.71','33.24','37.22','38.91','38.93','38.97','39.95','42.92','45.13','45.16','45.23','45.25','45.42','51.23','54.91','57.32','57.94','59.8','64.0','73.59','74.1','75.69','80.51','81.54','81.62','81.92','86.04','86.3','86.59','87.03','88.41','88.53','88.56','88.72','93.39','93.54','93.83','96.04','96.71','96.72','99.04','99.23','99.29') 
	   UNION
	SELECT *
	FROM concept
	WHERE vocabulary_id = 'ICD10PCS'
	AND concept_code in ('009U3ZX','01NB0ZZ','027034Z','02HV33Z','03HY32Z','0BH17EZ','0BJ08ZZ','0CJS8ZZ','0DB68ZX','0DB98ZX','0DH67UZ','0DJ08ZZ','0DJD8ZZ','0FT44ZZ','0HQ9XZZ','0KQM0ZZ','0SRC0J9','0SRD0J9','0T9B70Z','0U7C7ZZ','0VTTXZZ','0W9930Z','0W9B30Z','10907ZC','10D00Z1','10E0XZZ','30233K1','30233N1','30233R1','3E033VJ','3E0436Z','3E0G76Z','4A023N7','4A10X4G','5A1221Z','5A1935Z','5A1945Z','5A1955Z','5A1D70Z','5A2204Z','8E0W4CZ','B020ZZZ','B030ZZZ','B2111ZZ','B2151ZZ','B24BZZ4','B32R1ZZ','BW28ZZZ','HZ2ZZZZ') 
 ) x
LEFT OUTER JOIN concept_relationship cr
ON x.concept_id = cr.concept_id_1
AND cr.relationship_id = 'Maps to'
AND cr.invalid_reason IS NULL
LEFT OUTER JOIN concept mapped_concept
ON cr.concept_id_2 = mapped_concept.concept_id
 ;
-- Concept check - 1yr
CREATE TABLE tncatscm22_cchecks1yr 
 AS
SELECT
src_vocabulary_id, count(distinct cc.src_concept_code) as denominator, count(distinct x.src_concept_id) as numerator 
FROM
tncatscm22_cconcepts cc
LEFT OUTER JOIN
(SELECT DISTINCT src_concept_id
	FROM tncatscm22_cconcepts
	  WHERE mapped_concept_id IN
	(SELECT DISTINCT condition_concept_id as concept_id
		FROM condition_occurrence cond
		INNER JOIN tncatscm22_c1yr c1yr
		ON cond.person_id = c1yr.person_id
		AND cond.condition_start_date BETWEEN '01-01-2021' AND '12-31-2021' 
		  UNION
		SELECT DISTINCT procedure_concept_id  concept_id
		FROM procedure_occurrence y
		INNER JOIN tncatscm22_c1yr c1yr
		ON y.person_id = c1yr.person_id
		AND y.procedure_date BETWEEN '01-01-2021' AND '12-31-2021' 
		  UNION
		SELECT DISTINCT drug_concept_id  concept_id
		FROM drug_exposure y
		INNER JOIN tncatscm22_c1yr c1yr
		ON y.person_id = c1yr.person_id
		AND y.drug_exposure_start_date BETWEEN '01-01-2021' AND '12-31-2021' 
		  UNION
		SELECT DISTINCT observation_concept_id  concept_id
		FROM observation y
		INNER JOIN tncatscm22_c1yr c1yr
		ON y.person_id = c1yr.person_id
		AND y.observation_date BETWEEN '01-01-2021' AND '12-31-2021' 
		  UNION
		SELECT DISTINCT measurement_concept_id  concept_id
		FROM measurement y
		INNER JOIN tncatscm22_c1yr c1yr
		ON y.person_id = c1yr.person_id
		AND y.measurement_date BETWEEN '01-01-2021' AND '12-31-2021' 
	 )
 ) x
ON cc.src_concept_id = x.src_concept_id
group by src_vocabulary_id
 ;
-- Concept check - 5yr
CREATE TABLE tncatscm22_cchecks5yr
 AS
SELECT
src_vocabulary_id, count(distinct cc.src_concept_code) as denominator, count(distinct x.src_concept_id) as numerator 
FROM
tncatscm22_cconcepts cc
LEFT OUTER JOIN
(SELECT DISTINCT src_concept_id
	FROM tncatscm22_cconcepts
	  WHERE mapped_concept_id IN
	(SELECT DISTINCT condition_concept_id as concept_id
		FROM condition_occurrence cond
		INNER JOIN tncatscm22_c1yr c1yr
		ON cond.person_id = c1yr.person_id
		AND cond.condition_start_date BETWEEN '01-01-2017' AND '12-31-2021' 
		  UNION
		SELECT DISTINCT procedure_concept_id  concept_id
		FROM procedure_occurrence y
		INNER JOIN tncatscm22_c1yr c1yr
		ON y.person_id = c1yr.person_id
		AND y.procedure_date BETWEEN '01-01-2017' AND '12-31-2021' 
		  UNION
		SELECT DISTINCT drug_concept_id  concept_id
		FROM drug_exposure y
		INNER JOIN tncatscm22_c1yr c1yr
		ON y.person_id = c1yr.person_id
		AND y.drug_exposure_start_date BETWEEN '01-01-2017' AND '12-31-2021' 
		  UNION
		SELECT DISTINCT observation_concept_id  concept_id
		FROM observation y
		INNER JOIN tncatscm22_c1yr c1yr
		ON y.person_id = c1yr.person_id
		AND y.observation_date BETWEEN '01-01-2017' AND '12-31-2021' 
		  UNION
		SELECT DISTINCT measurement_concept_id  concept_id
		FROM measurement y
		INNER JOIN tncatscm22_c1yr c1yr
		ON y.person_id = c1yr.person_id
		AND y.measurement_date BETWEEN '01-01-2017' AND '12-31-2021' 
	 )
 ) x
ON cc.src_concept_id = x.src_concept_id
group by src_vocabulary_id
 ;
-- 4) Generate output metrics 
SELECT 'data_model' as variable_name
	,(SELECT  data_model FROM tncatscm22_userinput  WHERE ROWNUM <= 1) as one_year -- 2 = OMOP
	,(SELECT  data_model FROM tncatscm22_userinput  WHERE ROWNUM <= 1) as five_year -- 2 = OMOP
 FROM DUAL  UNION SELECT 'nlp_any'  variable_name
	,(SELECT  nlp_any FROM tncatscm22_userinput  WHERE ROWNUM <= 1)  one_year 
	,(SELECT  nlp_any FROM tncatscm22_userinput  WHERE ROWNUM <= 1) as five_year
  FROM DUAL  UNION SELECT 'text_search'  variable_name
	,(SELECT  text_search FROM tncatscm22_userinput  WHERE ROWNUM <= 1)  one_year 
	,(SELECT  text_search FROM tncatscm22_userinput  WHERE ROWNUM <= 1) as five_year
  FROM DUAL  UNION SELECT 'total_patients'  variable_name
,(SELECT COUNT(DISTINCT person_id) 
	FROM tncatscm22_c1yr
 )  one_year
,(SELECT COUNT(DISTINCT person_id) 
	FROM tncatscm22_c5yr
 ) as five_year
  FROM DUAL  UNION SELECT 'uniq_pt_with_age'  variable_name
,(SELECT COUNT(DISTINCT per.person_id) 
	FROM tncatscm22_c1yr x
	INNER JOIN person per
	ON x.person_id = per.person_id
	AND per.birth_datetime IS NOT NULL
 )  one_year
,(SELECT COUNT(DISTINCT per.person_id) 
	FROM tncatscm22_c5yr x
	INNER JOIN person per
	ON x.person_id = per.person_id
	AND per.birth_datetime IS NOT NULL
 ) as five_year
  FROM DUAL  UNION SELECT 'uniq_pt_age_over_120'  variable_name
,(SELECT COUNT(DISTINCT x.person_id) 
	FROM (SELECT DISTINCT per.person_id 
		FROM person per
		INNER JOIN death dth 
		ON per.person_id = dth.person_id
		AND (EXTRACT(YEAR FROM CAST(dth.death_date AS DATE)) - EXTRACT(YEAR FROM CAST(per.birth_datetime AS DATE))) > 120
		-- No DOD, 12/31-2021 - DOB > 120
		  UNION
		SELECT DISTINCT person_id 
		FROM person 
		  WHERE (EXTRACT(YEAR FROM CAST('12-31-2022' AS DATE)) - EXTRACT(YEAR FROM CAST(birth_datetime AS DATE))) > 120
		AND person_id NOT IN (SELECT person_id FROM death )
	 ) per
	INNER JOIN tncatscm22_c1yr x
	ON per.person_id = x.person_id
 )  one_year
,(SELECT COUNT(DISTINCT x.person_id) 
	FROM (SELECT per.person_id 
		FROM person per
		INNER JOIN death dth 
		ON per.person_id = dth.person_id
		AND (EXTRACT(YEAR FROM CAST(dth.death_date AS DATE)) - EXTRACT(YEAR FROM CAST(per.birth_datetime AS DATE))) > 120
		-- No DOD, 12/31-2021 - DOB > 120
		  UNION
		SELECT person_id 
		FROM person 
		  WHERE (EXTRACT(YEAR FROM CAST('12-31-2022' AS DATE)) - EXTRACT(YEAR FROM CAST(birth_datetime AS DATE))) > 120
		AND person_id NOT IN (SELECT person_id FROM death )
	 ) per
	INNER JOIN tncatscm22_c5yr x
	ON per.person_id = x.person_id
 ) as five_year
  FROM DUAL  UNION SELECT 'uniq_pt_with_gender'  variable_name
,(SELECT COUNT(DISTINCT per.person_id) 
	FROM person per
	INNER JOIN tncatscm22_c1yr x
	ON per.person_id = x.person_id
	AND per.gender_concept_id IN (
		8507		-- Male
		,8532		-- Female
		,8570		-- Ambiguous
		,8521		-- Other
	)
 )  one_year
,(SELECT COUNT(DISTINCT per.person_id) 
	FROM person per
	INNER JOIN tncatscm22_c5yr x
	ON per.person_id = x.person_id
	AND per.gender_concept_id IN (
		8507		-- Male
		,8532		-- Female
		,8570		-- Ambiguous
		,8521		-- Other
	)
 ) as five_year
  FROM DUAL  UNION SELECT 'uniq_pt_loinc'  variable_name
,(SELECT COUNT(DISTINCT x.person_id) 
	FROM (SELECT DISTINCT person_id
		FROM measurement meas
		INNER JOIN concept conc
		ON conc.vocabulary_id = 'LOINC'
		AND meas.measurement_concept_id = conc.concept_id
		AND measurement_date BETWEEN '01-01-2021' AND '12-31-2021'
		  UNION 
		SELECT DISTINCT person_id
		FROM observation obs
		INNER JOIN concept conc
		ON conc.vocabulary_id = 'LOINC'
		AND obs.observation_concept_id = conc.concept_id
		AND observation_date BETWEEN '01-01-2021' AND '12-31-2021'
	 ) per
	INNER JOIN tncatscm22_c1yr x
	ON per.person_id = x.person_id
 )  one_year
,(SELECT COUNT(DISTINCT x.person_id) 
	FROM (SELECT DISTINCT person_id
		FROM measurement meas
		INNER JOIN concept conc
		ON conc.vocabulary_id = 'LOINC'
		AND meas.measurement_concept_id = conc.concept_id
		AND measurement_date BETWEEN '01-01-2017' AND '12-31-2021'
		  UNION 
		SELECT DISTINCT person_id
		FROM observation obs
		INNER JOIN concept conc
		ON conc.vocabulary_id = 'LOINC'
		AND obs.observation_concept_id = conc.concept_id
		AND observation_date BETWEEN '01-01-2017' AND '12-31-2021'
	 ) per
	INNER JOIN tncatscm22_c5yr x
	ON per.person_id = x.person_id
 ) as five_year
  FROM DUAL  UNION SELECT 'uniq_pt_med_rxnorm'  variable_name
,(SELECT COUNT(DISTINCT x.person_id) 
	FROM drug_exposure drug
	INNER JOIN concept conc
	ON conc.vocabulary_id in ('RxNorm')
	AND drug.drug_concept_id = conc.concept_id
	AND drug_exposure_start_date BETWEEN '01-01-2021' AND '12-31-2021'
	INNER JOIN tncatscm22_c1yr x
	ON drug.person_id = x.person_id
 )  one_year
,(SELECT COUNT(DISTINCT x.person_id) 
	FROM drug_exposure drug
	INNER JOIN concept conc
	ON conc.vocabulary_id in ('RxNorm')
	AND drug.drug_concept_id = conc.concept_id
	AND drug_exposure_start_date BETWEEN '01-01-2017' AND '12-31-2021'
	INNER JOIN tncatscm22_c5yr x
	ON drug.person_id = x.person_id
 ) as five_year
  FROM DUAL  UNION SELECT 'uniq_pt_icd_dx'  variable_name
,(SELECT COUNT(DISTINCT x.person_id)
	FROM condition_occurrence cond
	INNER JOIN tncatscm22_c1yr x
	ON cond.person_id = x.person_id
	AND condition_concept_id IN 
	(SELECT cr.concept_id_2
			FROM concept c1
			INNER JOIN concept_relationship cr
			ON c1.concept_id = cr.concept_id_1
			AND relationship_id = 'Maps to'
			AND c1.vocabulary_id IN ('ICD9CM', 'ICD10CM')
	 )
	AND condition_start_date BETWEEN '01-01-2021' AND '12-31-2021'
 )  one_year
,(SELECT COUNT(DISTINCT x.person_id)
	FROM condition_occurrence cond
	INNER JOIN tncatscm22_c5yr x
	ON cond.person_id = x.person_id
	AND condition_concept_id IN 
	(SELECT cr.concept_id_2
			FROM concept c1
			INNER JOIN concept_relationship cr
			ON c1.concept_id = cr.concept_id_1
			AND relationship_id = 'Maps to'
			AND c1.vocabulary_id IN ('ICD9CM', 'ICD10CM')
	 )
	AND condition_start_date BETWEEN '01-01-2017' AND '12-31-2021'
 ) as five_year
  FROM DUAL  UNION SELECT 'uniq_pt_snomed_dx'  variable_name
,(SELECT COUNT(DISTINCT x.person_id)
	FROM condition_occurrence cond
	INNER JOIN concept conc 
	ON conc.vocabulary_id = 'SNOMED'
	AND cond.condition_concept_id = conc.concept_id
	AND condition_start_date BETWEEN '01-01-2021' AND '12-31-2021'
	INNER JOIN tncatscm22_c1yr x
	ON cond.person_id = x.person_id
 )  one_year
,(SELECT COUNT(DISTINCT x.person_id)
	FROM condition_occurrence cond
	INNER JOIN concept conc 
	ON conc.vocabulary_id = 'SNOMED'
	AND cond.condition_concept_id = conc.concept_id
	AND condition_start_date BETWEEN '01-01-2017' AND '12-31-2021'
	INNER JOIN tncatscm22_c5yr x
	ON cond.person_id = x.person_id
 ) as five_year
  FROM DUAL  UNION SELECT 'uniq_pt_icd_proc'  variable_name
,(SELECT COUNT(DISTINCT x.person_id)
	FROM procedure_occurrence proce
	INNER JOIN tncatscm22_c1yr x
	ON proce.person_id = x.person_id
	AND procedure_concept_id IN 
	(SELECT cr.concept_id_2
			FROM concept c1
			INNER JOIN concept_relationship cr
			ON c1.concept_id = cr.concept_id_1
			AND relationship_id = 'Maps to'
			AND c1.vocabulary_id IN ('ICD10PCS', 'ICD9Proc')
	 )
	AND procedure_date BETWEEN '01-01-2021' AND '12-31-2021'
 )  one_year
,(SELECT COUNT(DISTINCT x.person_id)
	FROM procedure_occurrence proce
	INNER JOIN tncatscm22_c5yr x
	ON proce.person_id = x.person_id
	AND procedure_concept_id IN 
	(SELECT cr.concept_id_2
			FROM concept c1
			INNER JOIN concept_relationship cr
			ON c1.concept_id = cr.concept_id_1
			AND relationship_id = 'Maps to'
			AND c1.vocabulary_id IN ('ICD10PCS', 'ICD9Proc')
	 )
	AND procedure_date BETWEEN '01-01-2017' AND '12-31-2021'
 ) as five_year
  FROM DUAL  UNION SELECT 'uniq_pt_cpt'  variable_name
,(SELECT COUNT(DISTINCT x.person_id)
	FROM procedure_occurrence proce
	INNER JOIN concept conc
	ON conc.vocabulary_id IN ('CPT4', 'HCPCS')
	AND proce.procedure_concept_id = conc.concept_id
	AND procedure_date BETWEEN '01-01-2021' AND '12-31-2021'
	INNER JOIN tncatscm22_c1yr x
	ON proce.person_id = x.person_id
 )  one_year
,(SELECT COUNT(DISTINCT x.person_id)
	FROM procedure_occurrence proce
	INNER JOIN concept conc
	ON conc.vocabulary_id IN ('CPT4', 'HCPCS')
	AND proce.procedure_concept_id = conc.concept_id
	AND procedure_date BETWEEN '01-01-2017' AND '12-31-2021'
	INNER JOIN tncatscm22_c5yr x
	ON proce.person_id = x.person_id
 ) as five_year
  FROM DUAL  UNION SELECT 'uniq_pt_snomed_proc'  variable_name
,(SELECT COUNT(DISTINCT x.person_id)
	FROM procedure_occurrence proce
	INNER JOIN concept conc
	ON conc.vocabulary_id = 'SNOMED'
	AND proce.procedure_concept_id = conc.concept_id
	AND procedure_date BETWEEN '01-01-2021' AND '12-31-2021'
	INNER JOIN tncatscm22_c1yr x
	ON proce.person_id = x.person_id
 )  one_year
,(SELECT COUNT(DISTINCT x.person_id)
	FROM procedure_occurrence proce
	INNER JOIN concept conc
	ON conc.vocabulary_id = 'SNOMED'
	AND proce.procedure_concept_id = conc.concept_id
	AND procedure_date BETWEEN '01-01-2017' AND '12-31-2021'
	INNER JOIN tncatscm22_c5yr x
	ON proce.person_id = x.person_id
 ) as five_year
  FROM DUAL  UNION SELECT 'uniq_pt_note'  variable_name
,(SELECT COUNT(DISTINCT x.person_id)
	FROM note n
	INNER JOIN tncatscm22_c1yr x
	ON n.person_id = x.person_id
	AND note_date BETWEEN '01-01-2020' AND '12-31-2021'
 )  one_year
,(SELECT COUNT(DISTINCT x.person_id)
	FROM note n
	INNER JOIN tncatscm22_c5yr x
	ON n.person_id = x.person_id
	AND note_date BETWEEN '01-01-2017' AND '12-31-2021'
 ) as five_year
  FROM DUAL  UNION SELECT 'uniq_pt_vital_sign'  variable_name
,(SELECT COUNT(distinct x.person_id) 
	FROM (SELECT DISTINCT person_id
		FROM MEASUREMENT
		    WHERE measurement_concept_id IN 
		(SELECT concept_id
			FROM tncatscm22_vitals
			  WHERE domain_id = 'Measurement'
		 )
		AND measurement_date BETWEEN '01-01-2021' AND '12-31-2021'
		   UNION 
		SELECT DISTINCT person_id
		FROM OBSERVATION
		WHERE observation_concept_id IN 
		(SELECT concept_id
			FROM tncatscm22_vitals
			  WHERE domain_id = 'Observation'
		 )
		AND observation_date BETWEEN '01-01-2021' AND '12-31-2021'
	 ) per
	INNER JOIN tncatscm22_c1yr x
	ON per.person_id = x.person_id
 )  one_year
,(SELECT COUNT(distinct x.person_id) 
	FROM (SELECT DISTINCT person_id
		FROM MEASUREMENT
		    WHERE measurement_concept_id IN 
		(SELECT concept_id
			FROM tncatscm22_vitals
			  WHERE domain_id = 'Measurement'
		 )
		AND measurement_date BETWEEN '01-01-2017' AND '12-31-2021'
		   UNION 
		SELECT DISTINCT person_id
		FROM OBSERVATION
		WHERE observation_concept_id IN 
		(SELECT concept_id
			FROM tncatscm22_vitals
			  WHERE domain_id = 'Observation'
		 )
		AND observation_date BETWEEN '01-01-2017' AND '12-31-2021'
	 ) per
	INNER JOIN tncatscm22_c5yr x
	ON per.person_id = x.person_id
 ) as five_year
  FROM DUAL  UNION SELECT 'uniq_pt_smoking'  variable_name
,(SELECT COUNT(distinct x.person_id) 
	FROM (SELECT DISTINCT person_id 
		FROM CONDITION_OCCURRENCE
		    WHERE condition_concept_id IN 
		(SELECT concept_id
			FROM tncatscm22_smoking
			  WHERE domain_id = 'Condition'
		 )
		AND condition_start_date BETWEEN '01-01-2021' AND '12-31-2021'
		   UNION 
		SELECT DISTINCT person_id 
		FROM OBSERVATION
		WHERE observation_concept_id IN 
		(SELECT concept_id
			FROM tncatscm22_smoking
			  WHERE domain_id = 'Observation'
		 )
		AND observation_date BETWEEN '01-01-2021' AND '12-31-2021'
	 ) per
	INNER JOIN tncatscm22_c1yr x
	ON per.person_id = x.person_id
 )  one_year
,(SELECT COUNT(distinct x.person_id) 
	FROM (SELECT DISTINCT person_id 
		FROM CONDITION_OCCURRENCE
		    WHERE condition_concept_id IN 
		(SELECT concept_id
			FROM tncatscm22_smoking
			  WHERE domain_id = 'Condition'
		 )
		AND condition_start_date BETWEEN '01-01-2017' AND '12-31-2021'
		   UNION 
		SELECT DISTINCT person_id 
		FROM OBSERVATION
		WHERE observation_concept_id IN 
		(SELECT concept_id
			FROM tncatscm22_smoking
			  WHERE domain_id = 'Observation'
		 )
		AND observation_date BETWEEN '01-01-2017' AND '12-31-2021'
	 ) per
	INNER JOIN tncatscm22_c5yr x
	ON per.person_id = x.person_id
 ) as five_year
  FROM DUAL  UNION SELECT 'uniq_pt_opioid'  variable_name
,(SELECT COUNT(DISTINCT x.person_id)
	FROM (SELECT DISTINCT person_id
		FROM condition_occurrence
		    WHERE condition_concept_id IN 
		(SELECT descendant_concept_id
			FROM concept_ancestor
			  WHERE ancestor_concept_id = 4032799 --Opioid-induced organic mental disorder
		 ) 
		AND condition_start_date BETWEEN '01-01-2021' AND '12-31-2021'
		   UNION 
		--"RxNorm (methadone {6813} and descendants, buprenorphine {1819} and descendant TTYs) "
		SELECT DISTINCT person_id
		FROM drug_exposure
		WHERE drug_concept_id IN 
		(SELECT descendant_concept_id
			FROM concept_ancestor
			  WHERE ancestor_concept_id IN (
				1103640		-- methadone (6813 is the concept code)
				,1133201	-- buprenorphine (1819 is the concept code)
			)
		 ) 
		AND drug_exposure_start_date BETWEEN '01-01-2021' AND '12-31-2021'
	 ) per
	INNER JOIN tncatscm22_c1yr x
	ON per.person_id = x.person_id
 )  one_year
,(SELECT COUNT(DISTINCT x.person_id)
	FROM (SELECT DISTINCT person_id
		FROM condition_occurrence
		    WHERE condition_concept_id IN 
		(SELECT descendant_concept_id
			FROM concept_ancestor
			  WHERE ancestor_concept_id = 4032799 --Opioid-induced organic mental disorder
		 ) 
		AND condition_start_date BETWEEN '01-01-2017' AND '12-31-2021'
		   UNION 
		--"RxNorm (methadone {6813} and descendants, buprenorphine {1819} and descendant TTYs) "
		SELECT DISTINCT person_id
		FROM drug_exposure
		WHERE drug_concept_id IN 
		(SELECT descendant_concept_id
			FROM concept_ancestor
			  WHERE ancestor_concept_id IN (
				1103640		-- methadone (6813 is the concept code)
				,1133201	-- buprenorphine (1819 is the concept code)
			)
		 ) 
		AND drug_exposure_start_date BETWEEN '01-01-2017' AND '12-31-2021'
	 ) per
	INNER JOIN tncatscm22_c5yr x
	ON per.person_id = x.person_id
 ) as five_year
  FROM DUAL  UNION SELECT 'uniq_pt_any_insurance_value'  variable_name
,(SELECT COUNT(DISTINCT x.person_id)
	FROM payer_plan_period per
	INNER JOIN tncatscm22_c1yr x
	ON per.person_id = x.person_id
	AND (
		payer_plan_period_start_date BETWEEN '01-01-2021' AND '12-31-2021'
		OR 
		payer_plan_period_end_date BETWEEN '01-01-2021' AND '12-31-2021'
	)
 )  one_year
,(SELECT COUNT(DISTINCT x.person_id)
	FROM payer_plan_period per
	INNER JOIN tncatscm22_c5yr x
	ON per.person_id = x.person_id
	AND (
		payer_plan_period_start_date BETWEEN '01-01-2017' AND '12-31-2021'
		OR 
		payer_plan_period_end_date BETWEEN '01-01-2017' AND '12-31-2021'
	)
 ) as five_year
-- NULL as NA. Best approach TBD for OMOP 
  FROM DUAL  UNION SELECT 'uniq_pt_insurance_value_set'  variable_name
	,NULL  one_year
	,NULL as five_year
  FROM DUAL  UNION SELECT 'CPT4_check'  variable_name
	,(SELECT CAST(CAST(numerator as numeric) / CAST(denominator as numeric)*100 as int) FROM tncatscm22_cchecks1yr   WHERE src_vocabulary_id = 'CPT4' )  one_year
	,(SELECT CAST(CAST(numerator as numeric) / CAST(denominator as numeric)*100 as int) FROM tncatscm22_cchecks5yr   WHERE src_vocabulary_id = 'CPT4' ) as five_year
  FROM DUAL  UNION SELECT 'ICD10CM_check'  variable_name
	,(SELECT CAST(CAST(numerator as numeric) / CAST(denominator as numeric)*100 as int) FROM tncatscm22_cchecks1yr   WHERE src_vocabulary_id = 'ICD10CM' )  one_year
	,(SELECT CAST(CAST(numerator as numeric) / CAST(denominator as numeric)*100 as int) FROM tncatscm22_cchecks5yr   WHERE src_vocabulary_id = 'ICD10CM' ) as five_year
  FROM DUAL  UNION SELECT 'ICD10PCS_check'  variable_name
	,(SELECT CAST(CAST(numerator as numeric) / CAST(denominator as numeric)*100 as int) FROM tncatscm22_cchecks1yr   WHERE src_vocabulary_id = 'ICD10PCS' )  one_year
	,(SELECT CAST(CAST(numerator as numeric) / CAST(denominator as numeric)*100 as int) FROM tncatscm22_cchecks5yr   WHERE src_vocabulary_id = 'ICD10PCS' ) as five_year
  FROM DUAL  UNION SELECT 'ICD9CM_check'  variable_name
	,(SELECT CAST(CAST(numerator as numeric) / CAST(denominator as numeric)*100 as int) FROM tncatscm22_cchecks1yr   WHERE src_vocabulary_id = 'ICD9CM' )  one_year
	,(SELECT CAST(CAST(numerator as numeric) / CAST(denominator as numeric)*100 as int) FROM tncatscm22_cchecks5yr   WHERE src_vocabulary_id = 'ICD9CM' ) as five_year
  FROM DUAL  UNION SELECT 'ICD9Proc_check'  variable_name
	,(SELECT CAST(CAST(numerator as numeric) / CAST(denominator as numeric)*100 as int) FROM tncatscm22_cchecks1yr   WHERE src_vocabulary_id = 'ICD9Proc' )  one_year
	,(SELECT CAST(CAST(numerator as numeric) / CAST(denominator as numeric)*100 as int) FROM tncatscm22_cchecks5yr   WHERE src_vocabulary_id = 'ICD9Proc' ) as five_year
  FROM DUAL  UNION SELECT 'LOINC_check'  variable_name
	,(SELECT CAST(CAST(numerator as numeric) / CAST(denominator as numeric)*100 as int) FROM tncatscm22_cchecks1yr   WHERE src_vocabulary_id = 'LOINC' )  one_year
	,(SELECT CAST(CAST(numerator as numeric) / CAST(denominator as numeric)*100 as int) FROM tncatscm22_cchecks5yr   WHERE src_vocabulary_id = 'LOINC' ) as five_year
  FROM DUAL   UNION SELECT 'RxNorm_check'  variable_name
	,(SELECT CAST(CAST(numerator as numeric) / CAST(denominator as numeric)*100 as int) FROM tncatscm22_cchecks1yr   WHERE src_vocabulary_id = 'RxNorm' )  one_year
	,(SELECT CAST(CAST(numerator as numeric) / CAST(denominator as numeric)*100 as int) FROM tncatscm22_cchecks5yr   WHERE src_vocabulary_id = 'RxNorm' ) as five_year
                                                      FROM DUAL ;
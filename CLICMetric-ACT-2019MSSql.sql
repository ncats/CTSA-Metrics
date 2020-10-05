-- Replace dbo with the proper schema name

IF OBJECT_ID('CTSA_CLIC_METRIC', 'U') IS NOT NULL          -- Drop table if it exists
  DROP TABLE CTSA_CLIC_METRIC;

-- Create dest table
CREATE TABLE CTSA_CLIC_METRIC (
	domain			VARCHAR(100)  NOT NULL,
    Patients_with_Standards  INT   NULL,
	UNIQUE_TOTAL_PATIENTS		INT   NULL,
	Percent_Standards			float(53)   NULL,
	Values_Present		VARCHAR(100)  NULL
);
 
SELECT DISTINCT patient_num  PATIENT_NUM into #pts_visit_2019
    FROM VISIT_DIMENSION WHERE 
        VISIT_DIMENSION.START_DATE >= DATEFROMPARTS(2019,01,01) AND VISIT_DIMENSION.START_DATE <= DATEFROMPARTS(2019,12,31)

create index ptsvisit2019 on #pts_visit_2019(patient_num)

SELECT COUNT(DISTINCT patient_num) cnt into #cnt 
    FROM #PTS_VISIT_2019
    
create index cnt2019 on #cnt(cnt)
    
  INSERT INTO CTSA_CLIC_METRIC 
  SELECT 'Patient Dimension Unique Patients' AS domain, null AS Patients_with_Standards,
 	cnt AS UNIQUE_TOTAL_PATIENTS,
 	null AS Percent_Standards,
 	'Not Applicable' AS Values_Present
 FROM #cnt
 
  INSERT INTO CTSA_CLIC_METRIC 
 SELECT 'Unique Patient With Birth Date' AS domain,
 	num.cnt AS Patients_with_Standards,
		cnt.cnt AS UNIQUE_TOTAL_PATIENTS,
			ROUND(100.0 * num.cnt/cnt.cnt,1) AS Percent_Standards,
				    'Not Applicable' AS Values_Present
  FROM (SELECT COUNT(DISTINCT P.patient_num) cnt
       	       FROM PATIENT_DIMENSION P
                JOIN #PTS_VISIT_2019 D ON D.PATIENT_NUM = P.PATIENT_NUM
	       WHERE birth_date IS NOT NULL 
               	     AND YEAR(BIRTH_DATE)>1900
		     	 AND YEAR(BIRTH_DATE) < YEAR(GETDATE())) num
		     	 full outer join #cnt cnt on 1=1

// jgk I made a version that uses the patient dimenstion
// I specify the std ACT code so would need customization
  INSERT INTO CTSA_CLIC_METRIC 
 SELECT 'Unique Patients With Gender' AS domain,
 	num.cnt AS Patients_with_Standards,
		cnt.cnt AS UNIQUE_TOTAL_PATIENTS,
			ROUND(100.0 * num.cnt/cnt.cnt,1) AS Percent_Standards,
				    'Not Applicable' AS Values_Present
  FROM (SELECT COUNT(DISTINCT P.patient_num) cnt
       	       FROM PATIENT_DIMENSION P
                JOIN #PTS_VISIT_2019 D ON D.PATIENT_NUM = P.PATIENT_NUM
	       WHERE sex_cd IN ('M','F','A','NI','O') ) num
		     	 full outer join #cnt cnt on 1=1
		     	 


/* This version relies on the fact table:
  INSERT INTO CTSA_CLIC_METRIC 
 SELECT 'Unique Patients With Gender' AS domain,
 	num.cnt AS Patients_with_Standards,
	den.cnt AS UNIQUE_TOTAL_PATIENTS,
	ROUND(100.0 * num.cnt/den.cnt,1) AS Percent_Standards,
	'Not Applicable' AS Values_Present
    FROM
	(SELECT COUNT(DISTINCT OBS.patient_num) cnt 
        FROM OBSERVATION_FACT obs
             JOIN #PTS_VISIT_2019 D ON D.PATIENT_NUM = OBS.PATIENT_NUM
        WHERE EXISTS (SELECT * FROM CONCEPT_DIMENSION c 
                        WHERE c.concept_path LIKE  '\ACT\Demographics\Sex\%' AND obs.concept_cd = c.concept_cd)) num
        		     	 full outer join #cnt den on 1=1
*/

/* jgk had to change to \ACT\PROCEDURES\% */
  INSERT INTO CTSA_CLIC_METRIC 
 SELECT 'Unique Patients With Procedure (ICD9/ICD10/CPT/HCPCS)' AS domain,
 	num.cnt AS Patients_with_Standards,
	den.cnt AS UNIQUE_TOTAL_PATIENTS,
	ROUND(100.0 * num.cnt/den.cnt,1) AS Percent_Standards,
	'Not Applicable' AS Values_Present
    FROM
	(SELECT COUNT(DISTINCT OBS.patient_num) cnt 
    FROM OBSERVATION_FACT obs
        JOIN #PTS_VISIT_2019 D ON D.PATIENT_NUM = OBS.PATIENT_NUM
   	WHERE OBS.START_DATE >= DATEFROMPARTS(2019,01,01) AND OBS.START_DATE <= DATEFROMPARTS(2019,12,31)
            AND obs.concept_cd in (SELECT concept_cd FROM CONCEPT_DIMENSION c 
                        WHERE c.concept_path LIKE  '\ACT\PROCEDURES\%' )) num
            		     	 full outer join #cnt den on 1=1
	
	select * from ctsa_clic_metric

  INSERT INTO CTSA_CLIC_METRIC 
 SELECT 'Unique Patients With Meds (RxNorm/NDC)' AS domain,
 	num.cnt AS Patients_with_Standards,
	den.cnt AS UNIQUE_TOTAL_PATIENTS,
	ROUND(100.0 * num.cnt/den.cnt,1) AS Percent_Standards,
	'Not Applicable' AS Values_Present
    FROM
	(SELECT COUNT(DISTINCT OBS.patient_num) cnt 
        FROM OBSERVATION_FACT obs
        JOIN #PTS_VISIT_2019 D ON D.PATIENT_NUM = OBS.PATIENT_NUM
        	WHERE OBS.START_DATE >= DATEFROMPARTS(2019,01,01) AND OBS.START_DATE <= DATEFROMPARTS(2019,12,31)
            AND EXISTS (SELECT * FROM CONCEPT_DIMENSION c 
                        WHERE c.concept_path LIKE  '\ACT\Medications\%' AND obs.concept_cd = c.concept_cd))num
                                		     	 full outer join #cnt den on 1=1
	

/* Had to change to \ACT\Lab\ from plural - jgk */
  INSERT INTO CTSA_CLIC_METRIC 
 SELECT 'Unique Patients With Labs (LOINC)' AS domain,
 	num.cnt AS Patients_with_Standards,
	den.cnt AS UNIQUE_TOTAL_PATIENTS,
	ROUND(100.0 * num.cnt/den.cnt,1) AS Percent_Standards,
	'Not Applicable' AS Values_Present
    FROM
	(SELECT COUNT(DISTINCT OBS.patient_num) cnt FROM OBSERVATION_FACT obs
            JOIN #PTS_VISIT_2019 D ON D.PATIENT_NUM = OBS.PATIENT_NUM
        	WHERE OBS.START_DATE >= DATEFROMPARTS(2019,01,01) AND OBS.START_DATE <= DATEFROMPARTS(2019,12,31)
                AND EXISTS (SELECT * FROM CONCEPT_DIMENSION c 
                        WHERE  concept_path like '\ACT\Lab\%' AND obs.concept_cd = c.concept_cd))num
                                		     	 full outer join #cnt den on 1=1
	

  INSERT INTO CTSA_CLIC_METRIC 
 SELECT 'Unique Patients With Diagnosis (ICD9 AND ICD10)' AS domain,
 	num.cnt AS Patients_with_Standards,
	den.cnt AS UNIQUE_TOTAL_PATIENTS,
	ROUND(100.0 * num.cnt/den.cnt,1) AS Percent_Standards,
	'Not Applicable' AS Values_Present
    FROM
	(SELECT COUNT(DISTINCT OBS.patient_num) cnt 
        FROM OBSERVATION_FACT obs
        JOIN #PTS_VISIT_2019 D ON D.PATIENT_NUM = OBS.PATIENT_NUM
        WHERE OBS.START_DATE >= DATEFROMPARTS(2019,01,01) AND OBS.START_DATE <= DATEFROMPARTS(2019,12,31)
            AND EXISTS (SELECT * FROM CONCEPT_DIMENSION c 
                        WHERE ( c.concept_path LIKE  '\ACT\DIAGNOSIS\%' OR c.concept_path LIKE  '\Diagnoses\%')
			      AND obs.concept_cd = c.concept_cd))num
			              		     	 full outer join #cnt den on 1=1


select * from CTSA_CLIC_METRIC;

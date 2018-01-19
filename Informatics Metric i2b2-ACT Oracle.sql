-- Query Informatics Metrics CTSA EDW
-- Data Model: ACT i2b2/SHRINE Ontology V1.0
-- Database: Oracle
-- Updated: 1/17/18 Michele Morris (Pitt DBMI) Adapted from 'Informatics Metric PCORnet Oracle.sql' 
-- Total patient count is from Patient_Dimension
-- Version 1.0 of ACT ontology only includes ICD9 Procedures
-- Replace schema name (NCATS2I2B2DEMODATA ) with your i2b2 demodata schema name

DROP TABLE CTSA_CLIC_METRIC;
CREATE TABLE CTSA_CLIC_METRIC AS SELECT * FROM (
with DEN AS 
  ( SELECT COUNT(DISTINCT patient_num)  cnt FROM NCATS2I2B2DEMODATA.PATIENT_DIMENSION )
 SELECT 'Patient Dimension Unique Patients' AS DOMAIN, null AS Patients_with_Standards,
 	den.cnt AS UNIQUE_TOTAL_PATIENTS,
 	null AS Percent_Standards,
 	'Not Applicable' AS Values_Present
 FROM den
UNION ALL
 SELECT 'Unique Patient With Birth Date' AS domain,
 	num.cnt AS Patients_with_Standards,
		den.cnt AS UNIQUE_TOTAL_PATIENTS,
			ROUND(100.0 * num.cnt/den.cnt,1) AS Percent_Standards,
				    'Not Applicable' AS Values_Present
  FROM (SELECT COUNT(DISTINCT patient_num) cnt
       	       FROM NCATS2I2B2DEMODATA.PATIENT_DIMENSION
	       WHERE birth_date IS NOT NULL 
               	     AND extract(year FROM birth_date)>1900
		     	 AND extract(year FROM birth_date) < extract(year FROM sysdate)) num,
	den
UNION ALL
 SELECT 'Unique Patients With Gender' AS domain,
 	num.cnt AS Patients_with_Standards,
	den.cnt AS UNIQUE_TOTAL_PATIENTS,
	ROUND(100.0 * num.cnt/den.cnt,1) AS Percent_Standards,
	'Not Applicable' AS Values_Present
    FROM
	(SELECT COUNT(DISTINCT patient_num) cnt FROM NCATS2I2B2DEMODATA.OBSERVATION_FACT obs
        	WHERE EXISTS (SELECT * FROM NCATS2I2B2DEMODATA.CONCEPT_DIMENSION c 
                        WHERE c.concept_path LIKE  '\ACT\Demographics\Sex\%' AND obs.concept_cd = c.concept_cd)) num,
	den

UNION ALL
 SELECT 'Unique Patients With Procedure (ICD9)' AS domain,
 	num.cnt AS Patients_with_Standards,
	den.cnt AS UNIQUE_TOTAL_PATIENTS,
	ROUND(100.0 * num.cnt/den.cnt,1) AS Percent_Standards,
	'Not Applicable' AS Values_Present
    FROM
	(SELECT COUNT(DISTINCT patient_num) cnt FROM NCATS2I2B2DEMODATA.OBSERVATION_FACT obs
        	WHERE EXISTS (SELECT * FROM NCATS2I2B2DEMODATA.CONCEPT_DIMENSION c 
                        WHERE c.concept_path LIKE  '\ACT\PROCEDURE\%' AND obs.concept_cd = c.concept_cd))num,
	den
	
UNION ALL
 SELECT 'Unique Patients With Meds (RxNorm)' AS domain,
 	num.cnt AS Patients_with_Standards,
	den.cnt AS UNIQUE_TOTAL_PATIENTS,
	ROUND(100.0 * num.cnt/den.cnt,1) AS Percent_Standards,
	'Not Applicable' AS Values_Present
    FROM
	(SELECT COUNT(DISTINCT patient_num) cnt FROM NCATS2I2B2DEMODATA.OBSERVATION_FACT obs
        	WHERE EXISTS (SELECT * FROM NCATS2I2B2DEMODATA.CONCEPT_DIMENSION c 
                        WHERE c.concept_path LIKE  '\ACT\Medications\%' AND obs.concept_cd = c.concept_cd))num,
	den
	
UNION ALL
 SELECT 'Unique Patients With Labs (LOINC)' AS domain,
 	num.cnt AS Patients_with_Standards,
	den.cnt AS UNIQUE_TOTAL_PATIENTS,
	ROUND(100.0 * num.cnt/den.cnt,1) AS Percent_Standards,
	'Not Applicable' AS Values_Present
    FROM
	(SELECT COUNT(DISTINCT patient_num) cnt FROM NCATS2I2B2DEMODATA.OBSERVATION_FACT obs
        	WHERE EXISTS (SELECT * FROM NCATS2I2B2DEMODATA.CONCEPT_DIMENSION c 
                        WHERE c.concept_path LIKE  '\ACT\Labs\%' AND obs.concept_cd = c.concept_cd))num,
	den
	
UNION ALL
 SELECT 'Unique Patients With Diagnosis (ICD9 AND ICD10)' AS domain,
 	num.cnt AS Patients_with_Standards,
	den.cnt AS UNIQUE_TOTAL_PATIENTS,
	ROUND(100.0 * num.cnt/den.cnt,1) AS Percent_Standards,
	'Not Applicable' AS Values_Present
    FROM
	(SELECT COUNT(DISTINCT patient_num) cnt FROM NCATS2I2B2DEMODATA.OBSERVATION_FACT obs
        	WHERE EXISTS (SELECT * FROM NCATS2I2B2DEMODATA.CONCEPT_DIMENSION c 
                        WHERE (c.concept_path LIKE  '\ACT\DIAGNOSIS\%' OR c.concept_path LIKE  '\Diagnoses\%')
			      AND obs.concept_cd = c.concept_cd))num,
			      den
);

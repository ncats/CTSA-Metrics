DROP TABLE @CRCSchema.CTSA_CLIC_METRIC;
CREATE TABLE @CRCSchema.CTSA_CLIC_METRIC AS SELECT * FROM (
with  PTS_VISIT_2019 AS (SELECT DISTINCT patient_num  PATIENT_NUM 
    FROM @CRCSchema.VISIT_DIMENSION WHERE START_DATE BETWEEN '01-JAN-19' AND '31-DEC-19'
        ORDER BY PATIENT_NUM
  ),
  DEN AS 
  ( SELECT COUNT(DISTINCT patient_num)  cnt 
    FROM PTS_VISIT_2019)
  SELECT 'Patient Dimension Unique Patients' AS DOMAIN, null AS Patients_with_Standards,
 	cnt AS UNIQUE_TOTAL_PATIENTS,
 	null AS Percent_Standards,
 	'Not Applicable' AS Values_Present
 FROM den d
UNION ALL
 SELECT 'Unique Patient With Birth Date' AS domain,
 	num.cnt AS Patients_with_Standards,
		den.cnt AS UNIQUE_TOTAL_PATIENTS,
			ROUND(100.0 * num.cnt/den.cnt,1) AS Percent_Standards,
				    'Not Applicable' AS Values_Present
  FROM (SELECT COUNT(DISTINCT P.patient_num) cnt
       	       FROM @CRCSchema.PATIENT_DIMENSION P
                JOIN PTS_VISIT_2019 D ON D.PATIENT_NUM = P.PATIENT_NUM
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
	(SELECT COUNT(DISTINCT OBS.patient_num) cnt 
        FROM @CRCSchema.OBSERVATION_FACT obs
             JOIN PTS_VISIT_2019 D ON D.PATIENT_NUM = OBS.PATIENT_NUM
        WHERE EXISTS (SELECT * FROM @CRCSchema.CONCEPT_DIMENSION c 
                        WHERE c.concept_path LIKE  '\ACT\Demographics\Sex\%' AND obs.concept_cd = c.concept_cd)) num,
	den

UNION ALL
 SELECT 'Unique Patients With Procedure (ICD9/ICD10/CPT/HCPCS)' AS domain,
 	num.cnt AS Patients_with_Standards,
	den.cnt AS UNIQUE_TOTAL_PATIENTS,
	ROUND(100.0 * num.cnt/den.cnt,1) AS Percent_Standards,
	'Not Applicable' AS Values_Present
    FROM
	(SELECT COUNT(DISTINCT OBS.patient_num) cnt 
    FROM @CRCSchema.OBSERVATION_FACT obs
        JOIN PTS_VISIT_2019 D ON D.PATIENT_NUM = OBS.PATIENT_NUM
   	WHERE OBS.START_DATE BETWEEN  '01-JAN-19' AND '31-DEC-19'
            AND EXISTS (SELECT * FROM @CRCSchema.CONCEPT_DIMENSION c 
                        WHERE c.concept_path LIKE  '\ACT\PROCEDURE\%' AND obs.concept_cd = c.concept_cd))num,
	den
	
UNION ALL
 SELECT 'Unique Patients With Meds (RxNorm/NDC)' AS domain,
 	num.cnt AS Patients_with_Standards,
	den.cnt AS UNIQUE_TOTAL_PATIENTS,
	ROUND(100.0 * num.cnt/den.cnt,1) AS Percent_Standards,
	'Not Applicable' AS Values_Present
    FROM
	(SELECT COUNT(DISTINCT OBS.patient_num) cnt 
        FROM @CRCSchema.OBSERVATION_FACT obs
        JOIN PTS_VISIT_2019 D ON D.PATIENT_NUM = OBS.PATIENT_NUM
        	WHERE OBS.START_DATE BETWEEN  '01-JAN-19' AND '31-DEC-19'
            AND EXISTS (SELECT * FROM @CRCSchema.CONCEPT_DIMENSION c 
                        WHERE c.concept_path LIKE  '\ACT\Medications\%' AND obs.concept_cd = c.concept_cd))num,
	den
	
UNION ALL
 SELECT 'Unique Patients With Labs (LOINC)' AS domain,
 	num.cnt AS Patients_with_Standards,
	den.cnt AS UNIQUE_TOTAL_PATIENTS,
	ROUND(100.0 * num.cnt/den.cnt,1) AS Percent_Standards,
	'Not Applicable' AS Values_Present
    FROM
	(SELECT COUNT(DISTINCT OBS.patient_num) cnt FROM @CRCSchema.OBSERVATION_FACT obs
            JOIN PTS_VISIT_2019 D ON D.PATIENT_NUM = OBS.PATIENT_NUM
        	WHERE OBS.START_DATE BETWEEN  '01-JAN-19' AND '31-DEC-19'
                AND EXISTS (SELECT * FROM @CRCSchema.CONCEPT_DIMENSION c 
                        WHERE c.concept_path LIKE  '\ACT\Labs\%' AND obs.concept_cd = c.concept_cd))num,
	den
	
UNION ALL
 SELECT 'Unique Patients With Diagnosis (ICD9 AND ICD10)' AS domain,
 	num.cnt AS Patients_with_Standards,
	den.cnt AS UNIQUE_TOTAL_PATIENTS,
	ROUND(100.0 * num.cnt/den.cnt,1) AS Percent_Standards,
	'Not Applicable' AS Values_Present
    FROM
	(SELECT COUNT(DISTINCT OBS.patient_num) cnt 
        FROM @CRCSchema.OBSERVATION_FACT obs
        JOIN PTS_VISIT_2019 D ON D.PATIENT_NUM = OBS.PATIENT_NUM
        WHERE OBS.START_DATE BETWEEN  '01-JAN-19' AND '31-DEC-19'
            AND EXISTS (SELECT * FROM @CRCSchema.CONCEPT_DIMENSION c 
                        WHERE (c.concept_path LIKE  '\ACT\DIAGNOSIS\%' OR c.concept_path LIKE  '\Diagnoses\%')
			      AND obs.concept_cd = c.concept_cd))num,
			      den
);

select * from CTSA_CLIC_METRIC;

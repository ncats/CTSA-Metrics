SELECT 'CREATING TEMP VIEWS' as log_entry; 

\o /dev/null

 -- view for patients with a fact in past year
 CREATE OR REPLACE LOCAL TEMP VIEW ALL_DOMAIN_1YR AS 
	SELECT distinct patient_id FROM :TNX_SCHEMA.diagnosis WHERE YEAR(date) = (YEAR(CURRENT_DATE())-1) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id FROM :TNX_SCHEMA.genomic  WHERE YEAR(test_date) = (YEAR(CURRENT_DATE())-1) AND orphan = FALSE  
		UNION
	SELECT distinct patient_id FROM :TNX_SCHEMA.procedure WHERE YEAR(date) = (YEAR(CURRENT_DATE())-1) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id FROM :TNX_SCHEMA.lab_result WHERE YEAR(test_date) = (YEAR(CURRENT_DATE())-1) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id FROM :TNX_SCHEMA.medication WHERE YEAR(start_date) = (YEAR(CURRENT_DATE())-1) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id FROM :TNX_SCHEMA.oncology WHERE YEAR(observation_date) = (YEAR(CURRENT_DATE())-1) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id FROM :TNX_SCHEMA.tumor_properties WHERE YEAR(observation_date) = (YEAR(CURRENT_DATE())-1) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id FROM :TNX_SCHEMA.vital_signs WHERE YEAR(measure_date) = (YEAR(CURRENT_DATE())-1) AND orphan = FALSE ;

-- view for patients with a fact in past five years 
 CREATE OR REPLACE LOCAL TEMP VIEW ALL_DOMAIN_5YR AS 
	SELECT distinct patient_id FROM :TNX_SCHEMA.diagnosis WHERE YEAR(date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(date) < YEAR(CURRENT_DATE()) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id FROM :TNX_SCHEMA.genomic  WHERE YEAR(test_date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(test_date) < YEAR(CURRENT_DATE()) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id FROM :TNX_SCHEMA.procedure WHERE YEAR(date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(date) < YEAR(CURRENT_DATE()) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id FROM :TNX_SCHEMA.lab_result WHERE YEAR(test_date)>= (YEAR(CURRENT_DATE())-5) AND YEAR(test_date) < YEAR(CURRENT_DATE()) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id FROM :TNX_SCHEMA.medication WHERE YEAR(start_date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(start_date) < YEAR(CURRENT_DATE()) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id FROM :TNX_SCHEMA.oncology WHERE YEAR(observation_date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(observation_date) < YEAR(CURRENT_DATE()) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id FROM :TNX_SCHEMA.tumor_properties WHERE YEAR(observation_date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(observation_date) < YEAR(CURRENT_DATE()) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id FROM :TNX_SCHEMA.vital_signs WHERE YEAR(measure_date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(measure_date) < YEAR(CURRENT_DATE()) AND orphan = FALSE ;

 -- view for patients with a fact in past year, including date of fact to calculate "age at event"
 CREATE OR REPLACE LOCAL TEMP VIEW DATE_ALL_DOMAIN_1YR AS 
	SELECT distinct patient_id, date FROM :TNX_SCHEMA.diagnosis WHERE YEAR(date) = (YEAR(CURRENT_DATE())-1) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id, test_date as date FROM :TNX_SCHEMA.genomic  WHERE YEAR(test_date) = (YEAR(CURRENT_DATE())-1) AND orphan = FALSE  
		UNION
	SELECT distinct patient_id, date  FROM :TNX_SCHEMA.procedure WHERE YEAR(date) = (YEAR(CURRENT_DATE())-1) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id, test_date AS date FROM :TNX_SCHEMA.lab_result WHERE YEAR(test_date) = (YEAR(CURRENT_DATE())-1) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id, start_date AS date  FROM :TNX_SCHEMA.medication WHERE YEAR(start_date) = (YEAR(CURRENT_DATE())-1) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id, observation_date AS date FROM :TNX_SCHEMA.oncology WHERE YEAR(observation_date) = (YEAR(CURRENT_DATE())-1) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id, observation_date AS date  FROM :TNX_SCHEMA.tumor_properties WHERE YEAR(observation_date) = (YEAR(CURRENT_DATE())-1) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id, measure_date AS date FROM :TNX_SCHEMA.vital_signs WHERE YEAR(measure_date) = (YEAR(CURRENT_DATE())-1) AND orphan = FALSE ;

-- view for patients with a fact in past five years,  including date of fact to calculate "age at event"
 CREATE OR REPLACE LOCAL TEMP VIEW DATE_ALL_DOMAIN_5YR AS 
	SELECT distinct patient_id, date FROM :TNX_SCHEMA.diagnosis WHERE YEAR(date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(date) < YEAR(CURRENT_DATE()) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id, test_date AS date FROM :TNX_SCHEMA.genomic  WHERE YEAR(test_date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(test_date) < YEAR(CURRENT_DATE()) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id, date FROM :TNX_SCHEMA.procedure WHERE YEAR(date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(date) < YEAR(CURRENT_DATE()) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id, test_date AS date FROM :TNX_SCHEMA.lab_result WHERE YEAR(test_date)>= (YEAR(CURRENT_DATE())-5) AND YEAR(test_date) < YEAR(CURRENT_DATE()) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id, start_date AS date FROM :TNX_SCHEMA.medication WHERE YEAR(start_date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(start_date) < YEAR(CURRENT_DATE()) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id, observation_date AS date FROM :TNX_SCHEMA.oncology WHERE YEAR(observation_date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(observation_date) < YEAR(CURRENT_DATE()) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id, observation_date AS date FROM :TNX_SCHEMA.tumor_properties WHERE YEAR(observation_date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(observation_date) < YEAR(CURRENT_DATE()) AND orphan = FALSE 
		UNION
	SELECT distinct patient_id, measure_date AS date FROM :TNX_SCHEMA.vital_signs WHERE YEAR(measure_date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(measure_date) < YEAR(CURRENT_DATE()) AND orphan = FALSE ;

-- view for encounters in past year
CREATE OR REPLACE LOCAL TEMP VIEW ENCOUNTER_1YR AS
		SELECT distinct encounter_id
		FROM :TNX_SCHEMA.encounter 
		WHERE YEAR(start_date) = (YEAR(CURRENT_DATE())-1)
		AND orphan = FALSE
		;

-- view for encounters in past five years
CREATE OR REPLACE LOCAL TEMP VIEW ENCOUNTER_5YR AS
		SELECT distinct encounter_id
		FROM :TNX_SCHEMA.encounter 
		WHERE YEAR(start_date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(start_date) < YEAR(CURRENT_DATE())
		AND orphan = FALSE
		;
	
-- view for patients with NLP docs
CREATE OR REPLACE LOCAL TEMP VIEW NLP_PATIENTS AS
	SELECT distinct patient_id, encounter_id FROM :TNX_SCHEMA.diagnosis WHERE source_type = 'NLP'
		UNION 
	SELECT distinct patient_id, encounter_id FROM :TNX_SCHEMA.medication WHERE source_type = 'NLP'
		UNION
	SELECT distinct patient_id, encounter_id FROM :TNX_SCHEMA.lab_result WHERE source_type = 'NLP'
		UNION 
	SELECT distinct patient_id, encounter_id FROM :TNX_SCHEMA.vital_signs WHERE source_type = 'NLP'
		UNION 
	SELECT distinct patient_id, 'N/A' FROM :TNX_SCHEMA.oncology WHERE source_type = 'NLP'
		UNION 
	SELECT distinct patient_id, 'N/A' FROM :TNX_SCHEMA.tumor_properties WHERE source_type = 'NLP';
		

---------------------------------------------------------------------------------------------------------
-- 1. Re-create output table 
---------------------------------------------------------------------------------------------------------
\o
SELECT 'CREATE TEMP CTSA OUTPUT TABLE' as log_entry;
\o /dev/null

DROP TABLE IF EXISTS :TNX_SCHEMA.ctsa;

CREATE TEMPORARY TABLE :TNX_SCHEMA.ctsa (
	variable_name VARCHAR(50),
	one_year INT,
	five_year INT
);

INSERT INTO :TNX_SCHEMA.ctsa 
(
	SELECT 'data_model', 3, 3
);


---------------------------------------------------------------------------------------------------------
-- 2.  Denominators
---------------------------------------------------------------------------------------------------------
\o
SELECT 'INSERTING DENOMINATORS' as log_entry;
\o /dev/null

-- total encounters
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'total_encounters',
	(
		SELECT count(distinct encounter_id) 
		FROM ENCOUNTER_1YR
	),
	(
		SELECT count(distinct encounter_id) 
		FROM ENCOUNTER_5YR
	)
);

-- total patients
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'total_patients',
	(
		SELECT count(distinct patient_id)
		FROM ALL_DOMAIN_1YR
	),
	(
		SELECT count(distinct patient_id) 
		FROM ALL_DOMAIN_5YR
	)
);

-- total patients over 12
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'total_pt_gt_12',
	(	
		SELECT count(distinct pt.patient_id)  
		FROM DATE_ALL_DOMAIN_1YR pt 
		JOIN :TNX_SCHEMA.patient p ON pt.patient_id = p.patient_id 
		WHERE AGE_IN_YEARS(pt.date, p.birth_date) > 12
	),
	(
		SELECT count(distinct pt.patient_id) 
		FROM DATE_ALL_DOMAIN_5YR pt 
		JOIN :TNX_SCHEMA.patient p ON pt.patient_id = p.patient_id 
		WHERE AGE_IN_YEARS(pt.date, p.birth_date) > 12
	)
);

---------------------------------------------------------------------------------------------------------
-- 3.  Age Domain
---------------------------------------------------------------------------------------------------------
\o
SELECT 'AGE DOMAIN' as log_entry;
\o /dev/null

-- unique patients with age
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_pt_with_age',
	(	
		SELECT count(distinct pt.patient_id)  
		FROM ALL_DOMAIN_1YR pt 
		JOIN :TNX_SCHEMA.patient p ON pt.patient_id = p.patient_id 
		WHERE p.birth_date IS NOT NULL
	),
	(
		SELECT count(distinct pt.patient_id) 
		FROM ALL_DOMAIN_5YR pt 
		JOIN :TNX_SCHEMA.patient p ON pt.patient_id = p.patient_id 
		WHERE p.birth_date IS NOT NULL
	)
);

-- unique patients with DOB in future
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_pt_birthdate_in_future',
	(	
		SELECT count(distinct pt.patient_id)  
		FROM ALL_DOMAIN_1YR pt 
		JOIN :TNX_SCHEMA.patient p ON pt.patient_id = p.patient_id 
		WHERE YEAR(p.birth_date) >= YEAR(CURRENT_DATE()) +1
	),
	(
		SELECT count(distinct pt.patient_id) 
		FROM ALL_DOMAIN_5YR pt 
		JOIN :TNX_SCHEMA.patient p ON pt.patient_id = p.patient_id 
		WHERE YEAR(p.birth_date) >= YEAR(CURRENT_DATE()) +1
	)
);

-- unique patients over 120
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_pt_age_over_120',
	(	
		SELECT count(distinct pt.patient_id)  
		FROM ALL_DOMAIN_1YR pt 
		JOIN :TNX_SCHEMA.patient p ON pt.patient_id = p.patient_id 
		WHERE (p.death_date IS NULL AND AGE_IN_YEARS(TO_DATE('12-31-' || (YEAR(CURRENT_DATE())-1), 'MM-DD-YYYY'), p.birth_date) > 120)
		OR (AGE_IN_YEARS(p.birth_date, p.death_date) > 120)
	),
	(
		SELECT count(distinct pt.patient_id) 
		FROM ALL_DOMAIN_5YR pt 
		JOIN :TNX_SCHEMA.patient p ON pt.patient_id = p.patient_id 
		WHERE (p.death_date IS NULL AND AGE_IN_YEARS(TO_DATE('12-31-' || (YEAR(CURRENT_DATE())-1), 'MM-DD-YYYY'), p.birth_date) > 120)
		OR (AGE_IN_YEARS(p.birth_date, p.death_date) > 120)
	)
);

---------------------------------------------------------------------------------------------------------
-- 4.  Gender Domain
---------------------------------------------------------------------------------------------------------
\o
SELECT 'GENDER DOMAIN' as log_entry;
\o /dev/null

-- unique patients with administrative gender (excludes null, unknown, not specified)
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_pt_with_gender',
	(	
		SELECT count(distinct pt.patient_id)  
		FROM ALL_DOMAIN_1YR pt 
		JOIN :TNX_SCHEMA.patient p ON pt.patient_id = p.patient_id 
		JOIN :TNX_SCHEMA.mapping ON 'DEM|GENDER:' || p.gender  = mapping.provider_code
		WHERE mapping.mt_code IN ('UMLS:HL7V3.0:Gender:F','UMLS:HL7V3.0:Gender:M')
	),
	(
		SELECT count(distinct pt.patient_id) 
		FROM ALL_DOMAIN_5YR pt 
		JOIN :TNX_SCHEMA.patient p ON pt.patient_id = p.patient_id 
		JOIN :TNX_SCHEMA.mapping ON 'DEM|GENDER:' || p.gender  = mapping.provider_code
		WHERE mapping.mt_code IN ('UMLS:HL7V3.0:Gender:F','UMLS:HL7V3.0:Gender:M')
	)
);

---------------------------------------------------------------------------------------------------------
-- 4.  Lab Test/LOINC Domain
---------------------------------------------------------------------------------------------------------
\o
SELECT 'LAB DOMAIN' as log_entry;
\o /dev/null

-- unique patients with lab tested coded in LOINC in timeframe
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_pt_loinc',
	(
		SELECT count(distinct lr.patient_id) 
		FROM :TNX_SCHEMA.lab_result lr
		JOIN :TNX_SCHEMA.mapping ON lr.observation_code_system || ':' || lr.observation_code = mapping.provider_code 
		WHERE mapping.mt_code like 'UMLS:LNC:%' 
		
		AND YEAR(test_date) = (YEAR(CURRENT_DATE())-1)
		AND lr.orphan = FALSE
	),
	(
		SELECT count(distinct lr.patient_id) 
		FROM :TNX_SCHEMA.lab_result lr
		JOIN :TNX_SCHEMA.mapping ON lr.observation_code_system || ':' || lr.observation_code = mapping.provider_code 
		WHERE mapping.mt_code like 'UMLS:LNC:%' 
		
		AND YEAR(test_date)>= (YEAR(CURRENT_DATE())-5) AND YEAR(test_date) < YEAR(CURRENT_DATE())
		AND lr.orphan = FALSE
	)
);

-- unique encounters with at least one lab test coded in LOINC in timeframe
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_enc_loinc',
	(
		SELECT count(distinct enc.encounter_id) 
		FROM ENCOUNTER_1YR enc
		JOIN :TNX_SCHEMA.lab_result lr ON enc.encounter_id = lr.encounter_id 
		JOIN :TNX_SCHEMA.mapping ON lr.observation_code_system || ':' || lr.observation_code = mapping.provider_code 
		WHERE mapping.mt_code like 'UMLS:LNC:%'
		
		AND lr.orphan = FALSE
	),
	(
		SELECT count(distinct enc.encounter_id) 
		FROM ENCOUNTER_5YR enc
		JOIN :TNX_SCHEMA.lab_result lr ON enc.encounter_id = lr.encounter_id  
		JOIN :TNX_SCHEMA.mapping ON lr.observation_code_system || ':' || lr.observation_code = mapping.provider_code 
		WHERE mapping.mt_code like 'UMLS:LNC:%' 
		
		AND lr.orphan = FALSE
	)
);

---------------------------------------------------------------------------------------------------------
-- 5.  Medication/RXNORM Domain
---------------------------------------------------------------------------------------------------------
\o
SELECT 'MED DOMAIN' as log_entry;
\o /dev/null

-- unique patients with RxNorm/NDC code in timeframe
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_pt_med_rxnorm',
	(
		SELECT count(distinct med.patient_id) 
		FROM :TNX_SCHEMA.medication med
		JOIN :TNX_SCHEMA.mapping ON med.code_system || ':' || med.code = mapping.provider_code 
		WHERE (mapping.mt_code like 'NLM:RXNORM:%' OR mapping.mt_code like 'RxDrug:%' OR mapping.mt_code like 'NDC:%') 
		
		AND YEAR(start_date) = (YEAR(CURRENT_DATE())-1)
		AND med.orphan = FALSE
	),
	(
		SELECT count(distinct med.patient_id) 
		FROM :TNX_SCHEMA.medication med
		JOIN :TNX_SCHEMA.mapping ON med.code_system || ':' || med.code = mapping.provider_code 
		WHERE (mapping.mt_code like 'NLM:RXNORM:%' OR mapping.mt_code like 'RxDrug:%' OR mapping.mt_code like 'NDC:%')
		
		AND YEAR(start_date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(start_date) < YEAR(CURRENT_DATE())
		AND med.orphan = FALSE
	)
);

-- unique encounters with at least one RxNorm/NDC code in timeframe
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_enc_med_rxnorm',
	(
		SELECT count(distinct enc.encounter_id) 
		FROM ENCOUNTER_1YR enc
		JOIN :TNX_SCHEMA.medication med ON enc.encounter_id = med.encounter_id 
		JOIN :TNX_SCHEMA.mapping ON med.code_system || ':' || med.code = mapping.provider_code 
		WHERE (mapping.mt_code like 'NLM:RXNORM:%' OR mapping.mt_code like 'RxDrug:%' OR mapping.mt_code like 'NDC:%') 
		
		AND med.orphan = FALSE
	),
	(
		SELECT count(distinct enc.encounter_id) 
		FROM ENCOUNTER_5YR enc
		JOIN :TNX_SCHEMA.medication med ON enc.encounter_id = med.encounter_id 
		JOIN :TNX_SCHEMA.mapping ON med.code_system || ':' || med.code = mapping.provider_code 
		WHERE (mapping.mt_code like 'NLM:RXNORM:%' OR mapping.mt_code like 'RxDrug:%' OR mapping.mt_code like 'NDC:%') 
		
		AND med.orphan = FALSE
	)
);

---------------------------------------------------------------------------------------------------------
-- 6.  ICD9/10 Diagnosis Domain
---------------------------------------------------------------------------------------------------------
\o
SELECT 'ICD9/10 DIAG DOMAIN' as log_entry;
\o /dev/null

-- unique patients with an ICD9/10 diagnosis in timeframe
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_pt_icd_dx',
	(
		SELECT count(distinct diag.patient_id) 
		FROM :TNX_SCHEMA.diagnosis diag 
		JOIN :TNX_SCHEMA.mapping ON diag.code_system || ':' || diag.code = mapping.provider_code 
		WHERE (mapping.mt_code like 'UMLS:ICD10CM:%' OR mapping.mt_code like 'UMLS:ICD9CM:%') 
		
		AND YEAR(date) = (YEAR(CURRENT_DATE())-1)
		AND diag.orphan = FALSE
	),
	(
		SELECT count(distinct diag.patient_id) 
		FROM :TNX_SCHEMA.diagnosis diag
		JOIN :TNX_SCHEMA.mapping ON diag.code_system || ':' || diag.code = mapping.provider_code 
		WHERE (mapping.mt_code like 'UMLS:ICD10CM:%' OR mapping.mt_code like 'UMLS:ICD9CM:%') 
		
		AND YEAR(date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(date) < YEAR(CURRENT_DATE())
		AND diag.orphan = FALSE
	)
);

-- unique encounters with at least one ICD9/10 diagnosis in timeframe
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_enc_icd_dx',
	(
		SELECT count(distinct enc.encounter_id) 
		FROM ENCOUNTER_1YR enc
		JOIN :TNX_SCHEMA.diagnosis diag ON enc.encounter_id = diag.encounter_id 
		JOIN :TNX_SCHEMA.mapping ON diag.code_system || ':' || diag.code = mapping.provider_code 
		WHERE (mapping.mt_code like 'UMLS:ICD10CM:%' OR mapping.mt_code like 'UMLS:ICD9CM:%') 
		
		AND diag.orphan = false
	),
	(
		SELECT count(distinct enc.encounter_id) 
		FROM ENCOUNTER_5YR enc
		JOIN :TNX_SCHEMA.diagnosis diag ON enc.encounter_id = diag.encounter_id 
		JOIN :TNX_SCHEMA.mapping ON diag.code_system || ':' || diag.code = mapping.provider_code 
		WHERE (mapping.mt_code like 'UMLS:ICD10CM:%' OR mapping.mt_code like 'UMLS:ICD9CM:%') 
		
		AND diag.orphan = false
	)
);

---------------------------------------------------------------------------------------------------------
-- 7.   SNOMED Diagnosis Domain
---------------------------------------------------------------------------------------------------------
\o
SELECT 'SNOMED DIAG DOMAIN' as log_entry;
\o /dev/null

-- unique patients with a SNOMED in timeframe
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_pt_snomed_dx', 0, 0
);

-- unique encounters with at least one SNOMED in timeframe
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_enc_snomed_dx', 0, 0
);

---------------------------------------------------------------------------------------------------------
-- 8.  ICD9/10 Procedure Domain
---------------------------------------------------------------------------------------------------------
\o
SELECT 'ICD9/10 PROCEDURE DOMAIN' as log_entry;
\o /dev/null

-- unique patients with an ICD9/10 procedure in timeframe
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_pt_icd_proc',
	(
		SELECT count(distinct proc.patient_id) 
		FROM :TNX_SCHEMA.procedure proc
		JOIN :TNX_SCHEMA.mapping ON proc.code_system || ':' || proc.code = mapping.provider_code 
		WHERE (mapping.mt_code like 'UMLS:ICD10PCS:%' OR mapping.mt_code like 'UMLS:ICD9CM:%') 
		
		AND YEAR(date) = (YEAR(CURRENT_DATE())-1)
		AND proc.orphan = FALSE
	),
	(
		SELECT count(distinct proc.patient_id) 
		FROM :TNX_SCHEMA.procedure proc
		JOIN :TNX_SCHEMA.mapping ON proc.code_system || ':' || proc.code = mapping.provider_code 
		WHERE (mapping.mt_code like 'UMLS:ICD10PCS:%' OR mapping.mt_code like 'UMLS:ICD9CM:%') 
		
		AND YEAR(date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(date) < YEAR(CURRENT_DATE())
		AND proc.orphan = FALSE
	)
);

-- unique encounters with at least one ICD9/10 procedure in timeframe
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_enc_icd_proc',
	(
		SELECT count(distinct enc.encounter_id) 
		FROM ENCOUNTER_1YR enc
		JOIN :TNX_SCHEMA.procedure proc ON enc.encounter_id = proc.encounter_id 
		JOIN :TNX_SCHEMA.mapping ON proc.code_system || ':' || proc.code = mapping.provider_code 
		WHERE (mapping.mt_code like 'UMLS:ICD10PCS:%' OR mapping.mt_code like 'UMLS:ICD9CM:%') 
		
		AND proc.orphan = FALSE
	),
	(
		SELECT count(distinct enc.encounter_id) 
		FROM ENCOUNTER_5YR enc
		JOIN :TNX_SCHEMA.procedure proc ON enc.encounter_id = proc.encounter_id  
		JOIN :TNX_SCHEMA.mapping ON proc.code_system || ':' || proc.code = mapping.provider_code 
		WHERE (mapping.mt_code like 'UMLS:ICD10PCS:%' OR mapping.mt_code like 'UMLS:ICD9CM:%') 
		
		AND proc.orphan = FALSE
	)
);

---------------------------------------------------------------------------------------------------------
-- 9.  CPT or HCPCS Procedure Domain
---------------------------------------------------------------------------------------------------------
\o
SELECT 'CPT/HCPCS DOMAIN' as log_entry;
\o /dev/null

-- unique patients with an CPT or HCPCS procedure in timeframe
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_pt_cpt',
	(
		SELECT count(distinct proc.patient_id) 
		FROM :TNX_SCHEMA.procedure proc 
		JOIN :TNX_SCHEMA.mapping ON proc.code_system || ':' || proc.code = mapping.provider_code 
		WHERE (mapping.mt_code like 'UMLS:CPT:%' OR mapping.mt_code like 'UMLS:HCPCS:%') 
		
		AND YEAR(date) = (YEAR(CURRENT_DATE())-1)
		AND proc.orphan = FALSE
	),
	(
		SELECT count(distinct proc.patient_id) 
		FROM :TNX_SCHEMA.procedure proc
		JOIN :TNX_SCHEMA.mapping ON proc.code_system || ':' || proc.code = mapping.provider_code 
		WHERE (mapping.mt_code like 'UMLS:CPT:%' OR mapping.mt_code like 'UMLS:HCPCS:%') 
		 
		AND YEAR(date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(date) < YEAR(CURRENT_DATE())
		AND proc.orphan = FALSE
	)
);

-- unique encounters with at least one CPT or HCPCS procedure in timeframe
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_enc_cpt',
	(
		SELECT count(distinct enc.encounter_id) 
		FROM ENCOUNTER_1YR enc
		JOIN :TNX_SCHEMA.procedure proc ON enc.encounter_id = proc.encounter_id 
		JOIN :TNX_SCHEMA.mapping ON proc.code_system || ':' || proc.code = mapping.provider_code 
		WHERE (mapping.mt_code like 'UMLS:CPT:%' OR mapping.mt_code like 'UMLS:HCPCS:%')
		
		AND proc.orphan = FALSE
	),
	(
		SELECT count(distinct enc.encounter_id) 
		FROM ENCOUNTER_5YR enc
		JOIN :TNX_SCHEMA.procedure proc ON enc.encounter_id = proc.encounter_id 
		JOIN :TNX_SCHEMA.mapping ON proc.code_system || ':' || proc.code = mapping.provider_code 
		WHERE (mapping.mt_code like 'UMLS:CPT:%' OR mapping.mt_code like 'UMLS:HCPCS:%') 
		
		AND proc.orphan = FALSE
	)
);

---------------------------------------------------------------------------------------------------------
-- 10. SNOMED Procedure Domain
---------------------------------------------------------------------------------------------------------
\o
SELECT 'SNOMED PROCEDURE DOMAIN' as log_entry;
\o /dev/null

-- unique patients with an SNOMED procedure in timeframe
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_pt_snomed_proc',
	(
		SELECT count(distinct proc.patient_id) 
		FROM :TNX_SCHEMA.procedure proc
		JOIN :TNX_SCHEMA.mapping ON proc.code_system || ':' || proc.code = mapping.provider_code 
		WHERE mapping.mt_code like 'UMLS:SNOMED:%' 
		
		AND YEAR(date) = (YEAR(CURRENT_DATE())-1) 
		AND proc.orphan = FALSE
	),
	(
		SELECT count(distinct proc.patient_id) 
		FROM :TNX_SCHEMA.procedure proc
		JOIN :TNX_SCHEMA.mapping ON proc.code_system || ':' || proc.code = mapping.provider_code 
		WHERE mapping.mt_code like 'UMLS:SNOMED:%' 
		
		AND YEAR(date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(date) < YEAR(CURRENT_DATE()) 
		AND proc.orphan = FALSE
	)
);

-- unique encounters with at least one SNOMED procedure in timeframe
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_enc_snomed_proc',
	(
		SELECT count(distinct enc.encounter_id) 
		FROM ENCOUNTER_1YR enc
		JOIN :TNX_SCHEMA.procedure proc ON enc.encounter_id = proc.encounter_id 
		JOIN :TNX_SCHEMA.mapping ON proc.code_system || ':' || proc.code = mapping.provider_code 
		WHERE mapping.mt_code like 'UMLS:SNOMED:%' 
		
		AND proc.orphan = FALSE
	),
	(
		SELECT count(distinct enc.encounter_id) 
		FROM ENCOUNTER_5YR enc
		JOIN :TNX_SCHEMA.procedure proc ON enc.encounter_id = proc.encounter_id  
		JOIN :TNX_SCHEMA.mapping ON proc.code_system || ':' || proc.code = mapping.provider_code 
		WHERE mapping.mt_code like 'UMLS:SNOMED:%' 
		
		AND proc.orphan = FALSE
	)
);

---------------------------------------------------------------------------------------------------------
-- 11. Free Text Data Domain
---------------------------------------------------------------------------------------------------------
\o
SELECT 'FREE TEXT DOMAIN' as log_entry;
\o /dev/null

-- has nlp?
INSERT INTO :TNX_SCHEMA.ctsa(
	SELECT 'nlp_any',
	CASE WHEN nlp_patient_count > 0 THEN 1 ELSE 0 END,
	CASE WHEN nlp_patient_count > 0 THEN 1 ELSE 0 END
	FROM 
	(
		SELECT count(1) AS nlp_patient_count FROM NLP_PATIENTS
	) nlp_patients
		
);
 
-- unique patients with free text note in timeframe
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_pt_note',
	(
		SELECT count(distinct patient_id)
		FROM
			(
			SELECT distinct patient_id FROM :TNX_SCHEMA.diagnosis WHERE source_type = 'NLP' AND YEAR(date) = (YEAR(CURRENT_DATE())-1) 
				UNION 
			SELECT distinct patient_id FROM :TNX_SCHEMA.medication WHERE source_type = 'NLP' AND YEAR(start_date) = (YEAR(CURRENT_DATE())-1)
				UNION
			SELECT distinct patient_id FROM :TNX_SCHEMA.lab_result WHERE source_type = 'NLP' AND YEAR(test_date) = (YEAR(CURRENT_DATE())-1)
				UNION 
			SELECT distinct patient_id FROM :TNX_SCHEMA.vital_signs WHERE source_type = 'NLP' AND YEAR(measure_date) = (YEAR(CURRENT_DATE())-1) 
				UNION 
			SELECT distinct patient_id FROM :TNX_SCHEMA.oncology WHERE source_type = 'NLP' AND YEAR(observation_date) = (YEAR(CURRENT_DATE())-1)
				UNION 
			SELECT distinct patient_id FROM :TNX_SCHEMA.tumor_properties WHERE source_type = 'NLP' AND YEAR(observation_date) = (YEAR(CURRENT_DATE())-1)
		) nlp_one_year
	),
	(
		SELECT count(distinct patient_id)
		FROM
			(
			SELECT distinct patient_id FROM :TNX_SCHEMA.diagnosis WHERE source_type = 'NLP' AND YEAR(date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(date) < YEAR(CURRENT_DATE())
				UNION 
			SELECT distinct patient_id FROM :TNX_SCHEMA.medication WHERE source_type = 'NLP' AND YEAR(start_date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(start_date) < YEAR(CURRENT_DATE()) 
				UNION
			SELECT distinct patient_id FROM :TNX_SCHEMA.lab_result WHERE source_type = 'NLP' AND YEAR(test_date)>= (YEAR(CURRENT_DATE())-5) AND YEAR(test_date) < YEAR(CURRENT_DATE())
				UNION 
			SELECT distinct patient_id FROM :TNX_SCHEMA.vital_signs WHERE source_type = 'NLP' AND YEAR(measure_date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(measure_date) < YEAR(CURRENT_DATE()) 
				UNION 
			SELECT distinct patient_id FROM :TNX_SCHEMA.oncology WHERE source_type = 'NLP' AND YEAR(observation_date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(observation_date) < YEAR(CURRENT_DATE())
				UNION 
			SELECT distinct patient_id FROM :TNX_SCHEMA.tumor_properties WHERE source_type = 'NLP' AND YEAR(observation_date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(observation_date) < YEAR(CURRENT_DATE())
		) nlp_five_year
	)
);

-- unique encounters with at least one free text note in timeframe
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_enc_note',
	(
		SELECT count(distinct enc.encounter_id) 
		FROM ENCOUNTER_1YR enc
		JOIN NLP_PATIENTS nlp ON enc.encounter_id = nlp.encounter_id 
	),
	(
		SELECT count(distinct enc.encounter_id) 
		FROM ENCOUNTER_5YR enc
		JOIN NLP_PATIENTS nlp ON enc.encounter_id = nlp.encounter_id
	)
);

---------------------------------------------------------------------------------------------------------
-- 12. Vitals Domain
---------------------------------------------------------------------------------------------------------
\o
SELECT 'VITALS DOMAIN' as log_entry;
\o /dev/null

--unique encounters with at least one vital sign coded in timeframe

INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_enc_vital_sign',
	(
		SELECT count(distinct enc.encounter_id) 
		FROM ENCOUNTER_1YR enc
		JOIN
			(
				SELECT distinct encounter_id 
				FROM :TNX_SCHEMA.vital_signs  
					UNION
				SELECT distinct encounter_id 
				FROM :TNX_SCHEMA.lab_result lr
				JOIN :TNX_SCHEMA.mapping ON lr.observation_code_system || ':' || lr.observation_code = mapping.provider_code
				WHERE mt_code IN 
					('UMLS:LNC:11948-7', 'UMLS:LNC:8889-8', 'UMLS:LNC:76477-9', 'UMLS:LNC:76476-1', 'UMLS:LNC:73799-9', 'UMLS:LNC:73795-7', 
					'UMLS:LNC:60978-4', 'UMLS:LNC:57068-9', 'UMLS:LNC:55283-6', 'UMLS:LNC:8867-4', 'UMLS:LNC:8893-0', 'UMLS:LNC:8892-2', 
					'UMLS:LNC:8891-4', 'UMLS:LNC:8890-6', 'UMLS:LNC:8450-9', 'UMLS:LNC:76534-7', 'UMLS:LNC:76215-3', 'UMLS:LNC:75997-7', 
					'UMLS:LNC:87741-5', 'UMLS:LNC:87739-9', 'UMLS:LNC:8479-8', 'UMLS:LNC:8461-6', 'UMLS:LNC:8460-8', 'UMLS:LNC:8459-0', 
					'UMLS:LNC:8452-5', 'UMLS:LNC:8451-7', 'UMLS:LNC:8480-6', 'UMLS:LNC:59576-9', 'UMLS:LNC:59575-1', 'UMLS:LNC:59574-4', 
					'UMLS:LNC:8302-2', 'UMLS:LNC:8308-9', 'UMLS:LNC:8307-1', 'UMLS:LNC:8306-3', 'UMLS:LNC:8305-5', 'UMLS:LNC:8301-4', 
					'UMLS:LNC:3138-5', 'UMLS:LNC:3137-7', 'UMLS:LNC:28642-7', 'UMLS:LNC:28643-5', 'UMLS:LNC:2713-6', 'UMLS:LNC:20564-1', 
					'UMLS:LNC:2708-6', 'UMLS:LNC:19224-5', 'UMLS:LNC:51733-4', 'UMLS:LNC:51731-8', 'UMLS:LNC:74105-8', 'UMLS:LNC:51732-6', 
					'UMLS:LNC:59408-5', 'UMLS:LNC:68363-1', 'UMLS:LNC:59418-4', 'UMLS:LNC:59407-7', 'UMLS:LNC:2711-0', 'UMLS:LNC:2709-4', 
					'UMLS:LNC:8331-1', 'UMLS:LNC:8330-3', 'UMLS:LNC:8329-5', 'UMLS:LNC:8328-7', 'UMLS:LNC:8309-7', 'UMLS:LNC:76278-1', 
					'UMLS:LNC:76011-6', 'UMLS:LNC:76010-8', 'UMLS:LNC:8334-5', 'UMLS:LNC:8333-7', 'UMLS:LNC:8332-9', 'UMLS:LNC:60834-9', 
					'UMLS:LNC:60833-1', 'UMLS:LNC:60830-7', 'UMLS:LNC:8310-5', 'UMLS:LNC:75987-8', 'UMLS:LNC:75539-7', 'UMLS:LNC:61009-7', 
					'UMLS:LNC:61008-9', 'UMLS:LNC:60955-2', 'UMLS:LNC:60838-0', 'UMLS:LNC:60836-4', 'UMLS:LNC:60835-6', 'UMLS:LNC:8290-9', 
					'UMLS:LNC:8288-3', 'UMLS:LNC:8287-5', 'UMLS:LNC:9843-4', 'UMLS:LNC:8291-7', 'UMLS:LNC:8303-0', 'UMLS:LNC:8454-1', 
					'UMLS:LNC:8453-3', 'UMLS:LNC:8447-5', 'UMLS:LNC:8446-7', 'UMLS:LNC:76535-4', 'UMLS:LNC:76213-8', 'UMLS:LNC:75995-1', 
					'UMLS:LNC:8462-4', 'UMLS:LNC:87740-7', 'UMLS:LNC:87736-5', 'UMLS:LNC:8455-8', 'UMLS:LNC:39156-5', 'UMLS:LNC:8336-0', 
					'UMLS:LNC:76270-8', 'UMLS:LNC:76174-2', 'UMLS:LNC:76173-4', 'UMLS:LNC:9279-1', 'UMLS:LNC:76172-6', 'UMLS:LNC:76171-8', 
					'UMLS:LNC:76170-0', 'UMLS:LNC:19840-8', 'UMLS:LNC:19839-0', 'UMLS:LNC:8277-6', 'UMLS:LNC:3139-3', 'UMLS:LNC:3140-1', 
					'UMLS:LNC:3141-9', 'UMLS:LNC:8335-2', 'UMLS:LNC:3142-7', 'UMLS:LNC:29463-7', 'UMLS:LNC:8289-1')
			) vitals ON enc.encounter_id = vitals.encounter_id
			
	),
	(
		SELECT count(distinct enc.encounter_id) 
		FROM ENCOUNTER_5YR enc
		JOIN
			(
				SELECT distinct encounter_id 
				FROM :TNX_SCHEMA.vital_signs 
					UNION
				SELECT distinct encounter_id 
				FROM :TNX_SCHEMA.lab_result lr
				JOIN :TNX_SCHEMA.mapping ON lr.observation_code_system || ':' || lr.observation_code = mapping.provider_code
				WHERE mt_code IN 
					('UMLS:LNC:11948-7', 'UMLS:LNC:8889-8', 'UMLS:LNC:76477-9', 'UMLS:LNC:76476-1', 'UMLS:LNC:73799-9', 'UMLS:LNC:73795-7', 
					'UMLS:LNC:60978-4', 'UMLS:LNC:57068-9', 'UMLS:LNC:55283-6', 'UMLS:LNC:8867-4', 'UMLS:LNC:8893-0', 'UMLS:LNC:8892-2', 
					'UMLS:LNC:8891-4', 'UMLS:LNC:8890-6', 'UMLS:LNC:8450-9', 'UMLS:LNC:76534-7', 'UMLS:LNC:76215-3', 'UMLS:LNC:75997-7', 
					'UMLS:LNC:87741-5', 'UMLS:LNC:87739-9', 'UMLS:LNC:8479-8', 'UMLS:LNC:8461-6', 'UMLS:LNC:8460-8', 'UMLS:LNC:8459-0', 
					'UMLS:LNC:8452-5', 'UMLS:LNC:8451-7', 'UMLS:LNC:8480-6', 'UMLS:LNC:59576-9', 'UMLS:LNC:59575-1', 'UMLS:LNC:59574-4', 
					'UMLS:LNC:8302-2', 'UMLS:LNC:8308-9', 'UMLS:LNC:8307-1', 'UMLS:LNC:8306-3', 'UMLS:LNC:8305-5', 'UMLS:LNC:8301-4', 
					'UMLS:LNC:3138-5', 'UMLS:LNC:3137-7', 'UMLS:LNC:28642-7', 'UMLS:LNC:28643-5', 'UMLS:LNC:2713-6', 'UMLS:LNC:20564-1', 
					'UMLS:LNC:2708-6', 'UMLS:LNC:19224-5', 'UMLS:LNC:51733-4', 'UMLS:LNC:51731-8', 'UMLS:LNC:74105-8', 'UMLS:LNC:51732-6', 
					'UMLS:LNC:59408-5', 'UMLS:LNC:68363-1', 'UMLS:LNC:59418-4', 'UMLS:LNC:59407-7', 'UMLS:LNC:2711-0', 'UMLS:LNC:2709-4', 
					'UMLS:LNC:8331-1', 'UMLS:LNC:8330-3', 'UMLS:LNC:8329-5', 'UMLS:LNC:8328-7', 'UMLS:LNC:8309-7', 'UMLS:LNC:76278-1', 
					'UMLS:LNC:76011-6', 'UMLS:LNC:76010-8', 'UMLS:LNC:8334-5', 'UMLS:LNC:8333-7', 'UMLS:LNC:8332-9', 'UMLS:LNC:60834-9', 
					'UMLS:LNC:60833-1', 'UMLS:LNC:60830-7', 'UMLS:LNC:8310-5', 'UMLS:LNC:75987-8', 'UMLS:LNC:75539-7', 'UMLS:LNC:61009-7', 
					'UMLS:LNC:61008-9', 'UMLS:LNC:60955-2', 'UMLS:LNC:60838-0', 'UMLS:LNC:60836-4', 'UMLS:LNC:60835-6', 'UMLS:LNC:8290-9', 
					'UMLS:LNC:8288-3', 'UMLS:LNC:8287-5', 'UMLS:LNC:9843-4', 'UMLS:LNC:8291-7', 'UMLS:LNC:8303-0', 'UMLS:LNC:8454-1', 
					'UMLS:LNC:8453-3', 'UMLS:LNC:8447-5', 'UMLS:LNC:8446-7', 'UMLS:LNC:76535-4', 'UMLS:LNC:76213-8', 'UMLS:LNC:75995-1', 
					'UMLS:LNC:8462-4', 'UMLS:LNC:87740-7', 'UMLS:LNC:87736-5', 'UMLS:LNC:8455-8', 'UMLS:LNC:39156-5', 'UMLS:LNC:8336-0', 
					'UMLS:LNC:76270-8', 'UMLS:LNC:76174-2', 'UMLS:LNC:76173-4', 'UMLS:LNC:9279-1', 'UMLS:LNC:76172-6', 'UMLS:LNC:76171-8', 
					'UMLS:LNC:76170-0', 'UMLS:LNC:19840-8', 'UMLS:LNC:19839-0', 'UMLS:LNC:8277-6', 'UMLS:LNC:3139-3', 'UMLS:LNC:3140-1', 
					'UMLS:LNC:3141-9', 'UMLS:LNC:8335-2', 'UMLS:LNC:3142-7', 'UMLS:LNC:29463-7', 'UMLS:LNC:8289-1')
			) vital_signs ON enc.encounter_id = vital_signs.encounter_id
	)
);

---------------------------------------------------------------------------------------------------------
-- 13. Behavioral and or/ Social Determinants of Health
---------------------------------------------------------------------------------------------------------
\o
SELECT 'SOCIAL DETERMINANTS OF HEALTH' as log_entry;
\o /dev/null

-- unique patients over 12 with at least one smoking code from list in time frame
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_pt_smoking',
	(
		SELECT count(distinct diag.patient_id) 
		FROM :TNX_SCHEMA.diagnosis diag
		JOIN :TNX_SCHEMA.patient p ON diag.patient_id = p.patient_id
		JOIN :TNX_SCHEMA.mapping ON diag.code_system || ':' || diag.code = mapping.provider_code 
		WHERE AGE_IN_YEARS(diag.date, p.birth_date) > 12
		AND mapping.mt_code IN
			(
				'UMLS:ICD10CM:Z87.891', 'UMLS:ICD10CM:F17.20', 'UMLS:ICD10CM:F17.200', 'UMLS:ICD10CM:F17.201', 
				'UMLS:ICD10CM:F17.203', 'UMLS:ICD10CM:F17.208', 'UMLS:ICD10CM:F17.209', 'UMLS:ICD10CM:F17.21', 
				'UMLS:ICD10CM:F17.210', 'UMLS:ICD10CM:F17.211', 'UMLS:ICD10CM:F17.213', 'UMLS:ICD10CM:F17.218', 
				'UMLS:ICD10CM:F17.219'
			)
		AND YEAR(date) = (YEAR(CURRENT_DATE())-1)
	),
	(
		SELECT count(distinct diag.patient_id) 
		FROM :TNX_SCHEMA.diagnosis diag
		JOIN :TNX_SCHEMA.patient p ON diag.patient_id = p.patient_id
		JOIN :TNX_SCHEMA.mapping ON diag.code_system || ':' || diag.code = mapping.provider_code 
		WHERE AGE_IN_YEARS(diag.date, p.birth_date) > 12
		AND mapping.mt_code IN
			(
				'UMLS:ICD10CM:Z87.891', 'UMLS:ICD10CM:F17.20', 'UMLS:ICD10CM:F17.200', 'UMLS:ICD10CM:F17.201', 
				'UMLS:ICD10CM:F17.203', 'UMLS:ICD10CM:F17.208', 'UMLS:ICD10CM:F17.209', 'UMLS:ICD10CM:F17.21', 
				'UMLS:ICD10CM:F17.210', 'UMLS:ICD10CM:F17.211', 'UMLS:ICD10CM:F17.213', 'UMLS:ICD10CM:F17.218', 
				'UMLS:ICD10CM:F17.219'
			)
		AND YEAR(date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(date) < YEAR(CURRENT_DATE())
	)
);


-- unique patients with at least one opioid code from list in time frame

INSERT INTO :TNX_SCHEMA.ctsa
(
	--opiod concepts 
	WITH methadone_concepts AS (
		SELECT 'NDC:00054039168' AS concept
		UNION SELECT 'NDC:00054039268' AS concept
		UNION SELECT 'NDC:00054070920' AS concept
		UNION SELECT 'NDC:00054070925' AS concept
		UNION SELECT 'NDC:00054071020' AS concept
		UNION SELECT 'NDC:00054071025' AS concept
		UNION SELECT 'NDC:00054355344' AS concept
		UNION SELECT 'NDC:00054355563' AS concept
		UNION SELECT 'NDC:00054355663' AS concept
		UNION SELECT 'NDC:00054421825' AS concept
		UNION SELECT 'NDC:00054421925' AS concept
		UNION SELECT 'NDC:00054453825' AS concept
		UNION SELECT 'NDC:00054457025' AS concept
		UNION SELECT 'NDC:00054457125' AS concept
		UNION SELECT 'NDC:00054855324' AS concept
		UNION SELECT 'NDC:00054855424' AS concept
		UNION SELECT 'NDC:00406052710' AS concept
		UNION SELECT 'NDC:00406052715' AS concept
		UNION SELECT 'NDC:00406054034' AS concept
		UNION SELECT 'NDC:00406254001' AS concept
		UNION SELECT 'NDC:00406575501' AS concept
		UNION SELECT 'NDC:00406575523' AS concept
		UNION SELECT 'NDC:00406575562' AS concept
		UNION SELECT 'NDC:00406577101' AS concept
		UNION SELECT 'NDC:00406577123' AS concept
		UNION SELECT 'NDC:00406577162' AS concept
		UNION SELECT 'NDC:00406872510' AS concept
		UNION SELECT 'NDC:00406872515' AS concept
		UNION SELECT 'NDC:00527192736' AS concept
		UNION SELECT 'NDC:00527192739' AS concept
		UNION SELECT 'NDC:00904653060' AS concept
		UNION SELECT 'NDC:00904653061' AS concept
		UNION SELECT 'NDC:13107008801' AS concept
		UNION SELECT 'NDC:13107008830' AS concept
		UNION SELECT 'NDC:13107008899' AS concept
		UNION SELECT 'NDC:13107008901' AS concept
		UNION SELECT 'NDC:13107008930' AS concept
		UNION SELECT 'NDC:13107008999' AS concept
		UNION SELECT 'NDC:17478038020' AS concept
		UNION SELECT 'NDC:17856039201' AS concept
		UNION SELECT 'NDC:17856039202' AS concept
		UNION SELECT 'NDC:17856052601' AS concept
		UNION SELECT 'NDC:17856052602' AS concept
		UNION SELECT 'NDC:17856052701' AS concept
		UNION SELECT 'NDC:17856052702' AS concept
		UNION SELECT 'NDC:17856069401' AS concept
		UNION SELECT 'NDC:17856069402' AS concept
		UNION SELECT 'NDC:17856355301' AS concept
		UNION SELECT 'NDC:17856355302' AS concept
		UNION SELECT 'NDC:17856355401' AS concept
		UNION SELECT 'NDC:17856355402' AS concept
		UNION SELECT 'NDC:17856355501' AS concept
		UNION SELECT 'NDC:17856355502' AS concept
		UNION SELECT 'NDC:17856355504' AS concept
		UNION SELECT 'NDC:17856355505' AS concept
		UNION SELECT 'NDC:17856355508' AS concept
		UNION SELECT 'NDC:17856355605' AS concept
		UNION SELECT 'NDC:17856355606' AS concept
		UNION SELECT 'NDC:31722094601' AS concept
		UNION SELECT 'NDC:31722094701' AS concept
		UNION SELECT 'NDC:35356083401' AS concept
		UNION SELECT 'NDC:35356083430' AS concept
		UNION SELECT 'NDC:35356083460' AS concept
		UNION SELECT 'NDC:35356083490' AS concept
		UNION SELECT 'NDC:35356083530' AS concept
		UNION SELECT 'NDC:35356083560' AS concept
		UNION SELECT 'NDC:35356083590' AS concept
		UNION SELECT 'NDC:42806031701' AS concept
		UNION SELECT 'NDC:42806031801' AS concept
		UNION SELECT 'NDC:52959038602' AS concept
		UNION SELECT 'NDC:52959038630' AS concept
		UNION SELECT 'NDC:52959038660' AS concept
		UNION SELECT 'NDC:52959038690' AS concept
		UNION SELECT 'NDC:52959043502' AS concept
		UNION SELECT 'NDC:52959043530' AS concept
		UNION SELECT 'NDC:52959043560' AS concept
		UNION SELECT 'NDC:52959043590' AS concept
		UNION SELECT 'NDC:55700088201' AS concept
		UNION SELECT 'NDC:55700088230' AS concept
		UNION SELECT 'NDC:55700088260' AS concept
		UNION SELECT 'NDC:55700088290' AS concept
		UNION SELECT 'NDC:57664060288' AS concept
		UNION SELECT 'NDC:57664060388' AS concept
		UNION SELECT 'NDC:60687020932' AS concept
		UNION SELECT 'NDC:60687020933' AS concept
		UNION SELECT 'NDC:60687021401' AS concept
		UNION SELECT 'NDC:60687021411' AS concept
		UNION SELECT 'NDC:61919067030' AS concept
		UNION SELECT 'NDC:61919067060' AS concept
		UNION SELECT 'NDC:61919067090' AS concept
		UNION SELECT 'NDC:63629102701' AS concept
		UNION SELECT 'NDC:63739000610' AS concept
		UNION SELECT 'NDC:66689069430' AS concept
		UNION SELECT 'NDC:66689069479' AS concept
		UNION SELECT 'NDC:66689069530' AS concept
		UNION SELECT 'NDC:66689069579' AS concept
		UNION SELECT 'NDC:66689071116' AS concept
		UNION SELECT 'NDC:66689071216' AS concept
		UNION SELECT 'NDC:66689081010' AS concept
		UNION SELECT 'NDC:66689082010' AS concept
		UNION SELECT 'NDC:66689083699' AS concept
		UNION SELECT 'NDC:66689089840' AS concept
		UNION SELECT 'NDC:67457021720' AS concept
		UNION SELECT 'NDC:67877011601' AS concept
		UNION SELECT 'NDC:68084073801' AS concept
		UNION SELECT 'NDC:68084073811' AS concept
		UNION SELECT 'NDC:68094003159' AS concept
		UNION SELECT 'NDC:68094003162' AS concept
		UNION SELECT 'NDC:68462080001' AS concept
		UNION SELECT 'NDC:68462080101' AS concept
		UNION SELECT 'NDC:70166028401' AS concept
		UNION SELECT 'NDC:70166028402' AS concept
		UNION SELECT 'NDC:71335049301' AS concept
		UNION SELECT 'NDC:71335049302' AS concept
		UNION SELECT 'NDC:71335049303' AS concept
		UNION SELECT 'NDC:71335049304' AS concept
		UNION SELECT 'NDC:71335049305' AS concept
		UNION SELECT 'NDC:71335049306' AS concept
		UNION SELECT 'NDC:71335049307' AS concept
		UNION SELECT 'NDC:71335073500' AS concept
		UNION SELECT 'NDC:71335073501' AS concept
		UNION SELECT 'NDC:71335073502' AS concept
		UNION SELECT 'NDC:71335073503' AS concept
		UNION SELECT 'NDC:71335073504' AS concept
		UNION SELECT 'NDC:71335073505' AS concept
		UNION SELECT 'NDC:71335073506' AS concept
		UNION SELECT 'NDC:71335073507' AS concept
		UNION SELECT 'NDC:71335073508' AS concept
		UNION SELECT 'NDC:71335073509' AS concept
		UNION SELECT 'NDC:71335110601' AS concept
		UNION SELECT 'NDC:71335110602' AS concept
		UNION SELECT 'NDC:71335110603' AS concept
		UNION SELECT 'NDC:71335110604' AS concept
		UNION SELECT 'NDC:71335110605' AS concept
		UNION SELECT 'NDC:71335110606' AS concept
		UNION SELECT 'NDC:71335110607' AS concept
		UNION SELECT 'NDC:71335136000' AS concept
		UNION SELECT 'NDC:71335136001' AS concept
		UNION SELECT 'NDC:71335136002' AS concept
		UNION SELECT 'NDC:71335136003' AS concept
		UNION SELECT 'NDC:71335136004' AS concept
		UNION SELECT 'NDC:71335136005' AS concept
		UNION SELECT 'NDC:71335136006' AS concept
		UNION SELECT 'NDC:71335136007' AS concept
		UNION SELECT 'NDC:71335136008' AS concept
		UNION SELECT 'NDC:71335136009' AS concept
		UNION SELECT 'NDC:72865012001' AS concept
		UNION SELECT 'NDC:72865012101' AS concept
		UNION SELECT 'RxDrug:1990745' AS concept
		UNION SELECT 'RxDrug:864706' AS concept
		UNION SELECT 'RxDrug:864708' AS concept
		UNION SELECT 'RxDrug:864712' AS concept
		UNION SELECT 'RxDrug:864714' AS concept
		UNION SELECT 'RxDrug:864718' AS concept
		UNION SELECT 'RxDrug:864720' AS concept
		UNION SELECT 'RxDrug:864737' AS concept
		UNION SELECT 'RxDrug:864761' AS concept
		UNION SELECT 'RxDrug:864769' AS concept
		UNION SELECT 'RxDrug:864978' AS concept
		UNION SELECT 'RxDrug:864980' AS concept
		UNION SELECT 'RxDrug:864984' AS concept
		UNION SELECT 'RxDrug:991147' AS concept
		UNION SELECT 'RxDrug:991149' AS concept
		UNION SELECT 'NLM:RXNORM:6813' AS concept
	),
	buprenorphine_concepts AS (
		SELECT 'NDC:00054017613' AS concept
		UNION SELECT 'NDC:00054017713' AS concept
		UNION SELECT 'NDC:00054018813' AS concept
		UNION SELECT 'NDC:00054018913' AS concept
		UNION SELECT 'NDC:00093360121' AS concept
		UNION SELECT 'NDC:00093360140' AS concept
		UNION SELECT 'NDC:00093360221' AS concept
		UNION SELECT 'NDC:00093360240' AS concept
		UNION SELECT 'NDC:00093360321' AS concept
		UNION SELECT 'NDC:00093360340' AS concept
		UNION SELECT 'NDC:00093365621' AS concept
		UNION SELECT 'NDC:00093365640' AS concept
		UNION SELECT 'NDC:00093365721' AS concept
		UNION SELECT 'NDC:00093365740' AS concept
		UNION SELECT 'NDC:00093365821' AS concept
		UNION SELECT 'NDC:00093365840' AS concept
		UNION SELECT 'NDC:00093365921' AS concept
		UNION SELECT 'NDC:00093365940' AS concept
		UNION SELECT 'NDC:00143924601' AS concept
		UNION SELECT 'NDC:00143924605' AS concept
		UNION SELECT 'NDC:00228315303' AS concept
		UNION SELECT 'NDC:00228315403' AS concept
		UNION SELECT 'NDC:00228315473' AS concept
		UNION SELECT 'NDC:00228315503' AS concept
		UNION SELECT 'NDC:00228315567' AS concept
		UNION SELECT 'NDC:00228315573' AS concept
		UNION SELECT 'NDC:00228315603' AS concept
		UNION SELECT 'NDC:00378092393' AS concept
		UNION SELECT 'NDC:00378092493' AS concept
		UNION SELECT 'NDC:00378876516' AS concept
		UNION SELECT 'NDC:00378876593' AS concept
		UNION SELECT 'NDC:00378876616' AS concept
		UNION SELECT 'NDC:00378876693' AS concept
		UNION SELECT 'NDC:00378876716' AS concept
		UNION SELECT 'NDC:00378876793' AS concept
		UNION SELECT 'NDC:00378876816' AS concept
		UNION SELECT 'NDC:00378876893' AS concept
		UNION SELECT 'NDC:00406192303' AS concept
		UNION SELECT 'NDC:00406192309' AS concept
		UNION SELECT 'NDC:00406192403' AS concept
		UNION SELECT 'NDC:00406192409' AS concept
		UNION SELECT 'NDC:00406800503' AS concept
		UNION SELECT 'NDC:00406802003' AS concept
		UNION SELECT 'NDC:00409201203' AS concept
		UNION SELECT 'NDC:00409201232' AS concept
		UNION SELECT 'NDC:00517072501' AS concept
		UNION SELECT 'NDC:00517072505' AS concept
		UNION SELECT 'NDC:00781721606' AS concept
		UNION SELECT 'NDC:00781721664' AS concept
		UNION SELECT 'NDC:00781722706' AS concept
		UNION SELECT 'NDC:00781722764' AS concept
		UNION SELECT 'NDC:00781723806' AS concept
		UNION SELECT 'NDC:00781723864' AS concept
		UNION SELECT 'NDC:00781724906' AS concept
		UNION SELECT 'NDC:00781724964' AS concept
		UNION SELECT 'NDC:00904701006' AS concept
		UNION SELECT 'NDC:12496010001' AS concept
		UNION SELECT 'NDC:12496010002' AS concept
		UNION SELECT 'NDC:12496010005' AS concept
		UNION SELECT 'NDC:12496030001' AS concept
		UNION SELECT 'NDC:12496030002' AS concept
		UNION SELECT 'NDC:12496030005' AS concept
		UNION SELECT 'NDC:12496075701' AS concept
		UNION SELECT 'NDC:12496075705' AS concept
		UNION SELECT 'NDC:12496120201' AS concept
		UNION SELECT 'NDC:12496120203' AS concept
		UNION SELECT 'NDC:12496120401' AS concept
		UNION SELECT 'NDC:12496120403' AS concept
		UNION SELECT 'NDC:12496120801' AS concept
		UNION SELECT 'NDC:12496120803' AS concept
		UNION SELECT 'NDC:12496121201' AS concept
		UNION SELECT 'NDC:12496121203' AS concept
		UNION SELECT 'NDC:35356055630' AS concept
		UNION SELECT 'NDC:42023017901' AS concept
		UNION SELECT 'NDC:42023017905' AS concept
		UNION SELECT 'NDC:42291017430' AS concept
		UNION SELECT 'NDC:42291017530' AS concept
		UNION SELECT 'NDC:42858035340' AS concept
		UNION SELECT 'NDC:42858049340' AS concept
		UNION SELECT 'NDC:42858050103' AS concept
		UNION SELECT 'NDC:42858050203' AS concept
		UNION SELECT 'NDC:42858058640' AS concept
		UNION SELECT 'NDC:42858060103' AS concept
		UNION SELECT 'NDC:42858060203' AS concept
		UNION SELECT 'NDC:42858075040' AS concept
		UNION SELECT 'NDC:42858083940' AS concept
		UNION SELECT 'NDC:43598057901' AS concept
		UNION SELECT 'NDC:43598057930' AS concept
		UNION SELECT 'NDC:43598058001' AS concept
		UNION SELECT 'NDC:43598058030' AS concept
		UNION SELECT 'NDC:43598058101' AS concept
		UNION SELECT 'NDC:43598058130' AS concept
		UNION SELECT 'NDC:43598058201' AS concept
		UNION SELECT 'NDC:43598058230' AS concept
		UNION SELECT 'NDC:47781035503' AS concept
		UNION SELECT 'NDC:47781035511' AS concept
		UNION SELECT 'NDC:47781035603' AS concept
		UNION SELECT 'NDC:47781035611' AS concept
		UNION SELECT 'NDC:47781035703' AS concept
		UNION SELECT 'NDC:47781035711' AS concept
		UNION SELECT 'NDC:47781035803' AS concept
		UNION SELECT 'NDC:47781035811' AS concept
		UNION SELECT 'NDC:50090157100' AS concept
		UNION SELECT 'NDC:50268014411' AS concept
		UNION SELECT 'NDC:50268014415' AS concept
		UNION SELECT 'NDC:50268014511' AS concept
		UNION SELECT 'NDC:50268014515' AS concept
		UNION SELECT 'NDC:50383028793' AS concept
		UNION SELECT 'NDC:50383029493' AS concept
		UNION SELECT 'NDC:50383092493' AS concept
		UNION SELECT 'NDC:50383093093' AS concept
		UNION SELECT 'NDC:52427069203' AS concept
		UNION SELECT 'NDC:52427069211' AS concept
		UNION SELECT 'NDC:52427069403' AS concept
		UNION SELECT 'NDC:52427069411' AS concept
		UNION SELECT 'NDC:52427069803' AS concept
		UNION SELECT 'NDC:52427069811' AS concept
		UNION SELECT 'NDC:52427071203' AS concept
		UNION SELECT 'NDC:52427071211' AS concept
		UNION SELECT 'NDC:52440010014' AS concept
		UNION SELECT 'NDC:53217013830' AS concept
		UNION SELECT 'NDC:53217024630' AS concept
		UNION SELECT 'NDC:53217032801' AS concept
		UNION SELECT 'NDC:54123011430' AS concept
		UNION SELECT 'NDC:54123090730' AS concept
		UNION SELECT 'NDC:54123091430' AS concept
		UNION SELECT 'NDC:54123092930' AS concept
		UNION SELECT 'NDC:54123095730' AS concept
		UNION SELECT 'NDC:54123098630' AS concept
		UNION SELECT 'NDC:55700014730' AS concept
		UNION SELECT 'NDC:55700030230' AS concept
		UNION SELECT 'NDC:55700030330' AS concept
		UNION SELECT 'NDC:55700056804' AS concept
		UNION SELECT 'NDC:55700057904' AS concept
		UNION SELECT 'NDC:55700086760' AS concept
		UNION SELECT 'NDC:58118017608' AS concept
		UNION SELECT 'NDC:58118017708' AS concept
		UNION SELECT 'NDC:58118315608' AS concept
		UNION SELECT 'NDC:59011075004' AS concept
		UNION SELECT 'NDC:59011075104' AS concept
		UNION SELECT 'NDC:59011075204' AS concept
		UNION SELECT 'NDC:59011075704' AS concept
		UNION SELECT 'NDC:59011075804' AS concept
		UNION SELECT 'NDC:59385001201' AS concept
		UNION SELECT 'NDC:59385001230' AS concept
		UNION SELECT 'NDC:59385001401' AS concept
		UNION SELECT 'NDC:59385001430' AS concept
		UNION SELECT 'NDC:59385001601' AS concept
		UNION SELECT 'NDC:59385001630' AS concept
		UNION SELECT 'NDC:59385002101' AS concept
		UNION SELECT 'NDC:59385002160' AS concept
		UNION SELECT 'NDC:59385002201' AS concept
		UNION SELECT 'NDC:59385002260' AS concept
		UNION SELECT 'NDC:59385002301' AS concept
		UNION SELECT 'NDC:59385002360' AS concept
		UNION SELECT 'NDC:59385002401' AS concept
		UNION SELECT 'NDC:59385002460' AS concept
		UNION SELECT 'NDC:59385002501' AS concept
		UNION SELECT 'NDC:59385002560' AS concept
		UNION SELECT 'NDC:59385002601' AS concept
		UNION SELECT 'NDC:59385002660' AS concept
		UNION SELECT 'NDC:59385002701' AS concept
		UNION SELECT 'NDC:59385002760' AS concept
		UNION SELECT 'NDC:60429058611' AS concept
		UNION SELECT 'NDC:60429058630' AS concept
		UNION SELECT 'NDC:60429058633' AS concept
		UNION SELECT 'NDC:60429058711' AS concept
		UNION SELECT 'NDC:60429058730' AS concept
		UNION SELECT 'NDC:60429058733' AS concept
		UNION SELECT 'NDC:60687048111' AS concept
		UNION SELECT 'NDC:60687048121' AS concept
		UNION SELECT 'NDC:60687049211' AS concept
		UNION SELECT 'NDC:60687049221' AS concept
		UNION SELECT 'NDC:62175045232' AS concept
		UNION SELECT 'NDC:62175045832' AS concept
		UNION SELECT 'NDC:62756045964' AS concept
		UNION SELECT 'NDC:62756045983' AS concept
		UNION SELECT 'NDC:62756046064' AS concept
		UNION SELECT 'NDC:62756046083' AS concept
		UNION SELECT 'NDC:62756096964' AS concept
		UNION SELECT 'NDC:62756096983' AS concept
		UNION SELECT 'NDC:62756097064' AS concept
		UNION SELECT 'NDC:62756097083' AS concept
		UNION SELECT 'NDC:63629409202' AS concept
		UNION SELECT 'NDC:63629712601' AS concept
		UNION SELECT 'NDC:63629712602' AS concept
		UNION SELECT 'NDC:63629712603' AS concept
		UNION SELECT 'NDC:63629712604' AS concept
		UNION SELECT 'NDC:63629712605' AS concept
		UNION SELECT 'NDC:63629712606' AS concept
		UNION SELECT 'NDC:63629712607' AS concept
		UNION SELECT 'NDC:63629712608' AS concept
		UNION SELECT 'NDC:63629712609' AS concept
		UNION SELECT 'NDC:63629727001' AS concept
		UNION SELECT 'NDC:63629727002' AS concept
		UNION SELECT 'NDC:64725093003' AS concept
		UNION SELECT 'NDC:64725093004' AS concept
		UNION SELECT 'NDC:64725192403' AS concept
		UNION SELECT 'NDC:64725192404' AS concept
		UNION SELECT 'NDC:65162041503' AS concept
		UNION SELECT 'NDC:65162041509' AS concept
		UNION SELECT 'NDC:65162041603' AS concept
		UNION SELECT 'NDC:65162041609' AS concept
		UNION SELECT 'NDC:67046099030' AS concept
		UNION SELECT 'NDC:67046099130' AS concept
		UNION SELECT 'NDC:67046099430' AS concept
		UNION SELECT 'NDC:67046099530' AS concept
		UNION SELECT 'NDC:67046099630' AS concept
		UNION SELECT 'NDC:67046099730' AS concept
		UNION SELECT 'NDC:67046099830' AS concept
		UNION SELECT 'NDC:67046099930' AS concept
		UNION SELECT 'NDC:69238120202' AS concept
		UNION SELECT 'NDC:69238120302' AS concept
		UNION SELECT 'NDC:69238120402' AS concept
		UNION SELECT 'NDC:69238120502' AS concept
		UNION SELECT 'NDC:69238150502' AS concept
		UNION SELECT 'NDC:70518044200' AS concept
		UNION SELECT 'NDC:70518065200' AS concept
		UNION SELECT 'NDC:70518065201' AS concept
		UNION SELECT 'NDC:70518065202' AS concept
		UNION SELECT 'NDC:70518071100' AS concept
		UNION SELECT 'NDC:70518071101' AS concept
		UNION SELECT 'NDC:70518071102' AS concept
		UNION SELECT 'NDC:70518100700' AS concept
		UNION SELECT 'NDC:70518155700' AS concept
		UNION SELECT 'NDC:70518162500' AS concept
		UNION SELECT 'NDC:70518168400' AS concept
		UNION SELECT 'NDC:70518201400' AS concept
		UNION SELECT 'NDC:70518221600' AS concept
		UNION SELECT 'NDC:70518221700' AS concept
		UNION SELECT 'NDC:70518221800' AS concept
		UNION SELECT 'NDC:70518222600' AS concept
		UNION SELECT 'NDC:70518231100' AS concept
		UNION SELECT 'NDC:70518232700' AS concept
		UNION SELECT 'NDC:71335035301' AS concept
		UNION SELECT 'NDC:71335035302' AS concept
		UNION SELECT 'NDC:71335035303' AS concept
		UNION SELECT 'NDC:71335035304' AS concept
		UNION SELECT 'NDC:71335035305' AS concept
		UNION SELECT 'NDC:71335035306' AS concept
		UNION SELECT 'NDC:71335035307' AS concept
		UNION SELECT 'NDC:71335095001' AS concept
		UNION SELECT 'NDC:71335095002' AS concept
		UNION SELECT 'NDC:71335095003' AS concept
		UNION SELECT 'NDC:71335095004' AS concept
		UNION SELECT 'NDC:71335095005' AS concept
		UNION SELECT 'NDC:71335095006' AS concept
		UNION SELECT 'NDC:71335095007' AS concept
		UNION SELECT 'NDC:71335115401' AS concept
		UNION SELECT 'NDC:71335115402' AS concept
		UNION SELECT 'NDC:71335115403' AS concept
		UNION SELECT 'NDC:71335115404' AS concept
		UNION SELECT 'NDC:71335115405' AS concept
		UNION SELECT 'NDC:71335115406' AS concept
		UNION SELECT 'NDC:71335115407' AS concept
		UNION SELECT 'NDC:71335115408' AS concept
		UNION SELECT 'NDC:71335115409' AS concept
		UNION SELECT 'NDC:71335116301' AS concept
		UNION SELECT 'NDC:71335116302' AS concept
		UNION SELECT 'NDC:71335116303' AS concept
		UNION SELECT 'NDC:71335116304' AS concept
		UNION SELECT 'NDC:71335116305' AS concept
		UNION SELECT 'NDC:71335116306' AS concept
		UNION SELECT 'NDC:71335116307' AS concept
		UNION SELECT 'NDC:71335116308' AS concept
		UNION SELECT 'NDC:71335116309' AS concept
		UNION SELECT 'NDC:71335129601' AS concept
		UNION SELECT 'NDC:71335129602' AS concept
		UNION SELECT 'NDC:71335137801' AS concept
		UNION SELECT 'NDC:71335151401' AS concept
		UNION SELECT 'NDC:71335151402' AS concept
		UNION SELECT 'NDC:71335165301' AS concept
		UNION SELECT 'NDC:71335172001' AS concept
		UNION SELECT 'NDC:71335172002' AS concept
		UNION SELECT 'NDC:71335172501' AS concept
		UNION SELECT 'NDC:76519117000' AS concept
		UNION SELECT 'NDC:76519117001' AS concept
		UNION SELECT 'NDC:76519117002' AS concept
		UNION SELECT 'NDC:76519117003' AS concept
		UNION SELECT 'NDC:76519117004' AS concept
		UNION SELECT 'NDC:76519117005' AS concept
		UNION SELECT 'RxDrug:1010600' AS concept
		UNION SELECT 'RxDrug:1010603' AS concept
		UNION SELECT 'RxDrug:1010604' AS concept
		UNION SELECT 'RxDrug:1010606' AS concept
		UNION SELECT 'RxDrug:1010608' AS concept
		UNION SELECT 'RxDrug:1010609' AS concept
		UNION SELECT 'RxDrug:1307056' AS concept
		UNION SELECT 'RxDrug:1307058' AS concept
		UNION SELECT 'RxDrug:1307061' AS concept
		UNION SELECT 'RxDrug:1307063' AS concept
		UNION SELECT 'RxDrug:1431076' AS concept
		UNION SELECT 'RxDrug:1431083' AS concept
		UNION SELECT 'RxDrug:1431102' AS concept
		UNION SELECT 'RxDrug:1431104' AS concept
		UNION SELECT 'RxDrug:1432969' AS concept
		UNION SELECT 'RxDrug:1432971' AS concept
		UNION SELECT 'RxDrug:1488634' AS concept
		UNION SELECT 'RxDrug:1488639' AS concept
		UNION SELECT 'RxDrug:1542390' AS concept
		UNION SELECT 'RxDrug:1542396' AS concept
		UNION SELECT 'RxDrug:1542997' AS concept
		UNION SELECT 'RxDrug:1542999' AS concept
		UNION SELECT 'RxDrug:1544851' AS concept
		UNION SELECT 'RxDrug:1544853' AS concept
		UNION SELECT 'RxDrug:1544854' AS concept
		UNION SELECT 'RxDrug:1544856' AS concept
		UNION SELECT 'RxDrug:1594650' AS concept
		UNION SELECT 'RxDrug:1594655' AS concept
		UNION SELECT 'RxDrug:1597568' AS concept
		UNION SELECT 'RxDrug:1597570' AS concept
		UNION SELECT 'RxDrug:1597573' AS concept
		UNION SELECT 'RxDrug:1597575' AS concept
		UNION SELECT 'RxDrug:1655032' AS concept
		UNION SELECT 'RxDrug:1666338' AS concept
		UNION SELECT 'RxDrug:1666385' AS concept
		UNION SELECT 'RxDrug:1716057' AS concept
		UNION SELECT 'RxDrug:1716063' AS concept
		UNION SELECT 'RxDrug:1716065' AS concept
		UNION SELECT 'RxDrug:1716067' AS concept
		UNION SELECT 'RxDrug:1716069' AS concept
		UNION SELECT 'RxDrug:1716071' AS concept
		UNION SELECT 'RxDrug:1716073' AS concept
		UNION SELECT 'RxDrug:1716075' AS concept
		UNION SELECT 'RxDrug:1716077' AS concept
		UNION SELECT 'RxDrug:1716079' AS concept
		UNION SELECT 'RxDrug:1716081' AS concept
		UNION SELECT 'RxDrug:1716083' AS concept
		UNION SELECT 'RxDrug:1716086' AS concept
		UNION SELECT 'RxDrug:1716090' AS concept
		UNION SELECT 'RxDrug:1797650' AS concept
		UNION SELECT 'RxDrug:1797655' AS concept
		UNION SELECT 'RxDrug:1864412' AS concept
		UNION SELECT 'RxDrug:1864414' AS concept
		UNION SELECT 'RxDrug:1996184' AS concept
		UNION SELECT 'RxDrug:1996189' AS concept
		UNION SELECT 'RxDrug:1996192' AS concept
		UNION SELECT 'RxDrug:1996193' AS concept
		UNION SELECT 'RxDrug:205533' AS concept
		UNION SELECT 'RxDrug:2058257' AS concept
		UNION SELECT 'RxDrug:2106368' AS concept
		UNION SELECT 'RxDrug:238129' AS concept
		UNION SELECT 'RxDrug:246474' AS concept
		UNION SELECT 'RxDrug:250426' AS concept
		UNION SELECT 'RxDrug:351264' AS concept
		UNION SELECT 'RxDrug:351265' AS concept
		UNION SELECT 'RxDrug:351266' AS concept
		UNION SELECT 'RxDrug:351267' AS concept
		UNION SELECT 'RxDrug:404414' AS concept
		UNION SELECT 'RxDrug:904870' AS concept
		UNION SELECT 'RxDrug:904874' AS concept
		UNION SELECT 'RxDrug:904876' AS concept
		UNION SELECT 'RxDrug:904878' AS concept
		UNION SELECT 'RxDrug:904880' AS concept
		UNION SELECT 'RxDrug:904882' AS concept
		UNION SELECT 'NLM:RXNORM:1819' AS concept
	),
	suboxone_concepts AS(
		SELECT 'NDC:00054018813' AS concept
		UNION SELECT 'NDC:00054018913' AS concept
		UNION SELECT 'NDC:00228315403' AS concept
		UNION SELECT 'NDC:00228315473' AS concept
		UNION SELECT 'NDC:00228315503' AS concept
		UNION SELECT 'NDC:00228315567' AS concept
		UNION SELECT 'NDC:00228315573' AS concept
		UNION SELECT 'NDC:00378876516' AS concept
		UNION SELECT 'NDC:00378876593' AS concept
		UNION SELECT 'NDC:00378876616' AS concept
		UNION SELECT 'NDC:00378876693' AS concept
		UNION SELECT 'NDC:00378876716' AS concept
		UNION SELECT 'NDC:00378876793' AS concept
		UNION SELECT 'NDC:00378876816' AS concept
		UNION SELECT 'NDC:00378876893' AS concept
		UNION SELECT 'NDC:00406192303' AS concept
		UNION SELECT 'NDC:00406192309' AS concept
		UNION SELECT 'NDC:00406192403' AS concept
		UNION SELECT 'NDC:00406192409' AS concept
		UNION SELECT 'NDC:00406800503' AS concept
		UNION SELECT 'NDC:00406802003' AS concept
		UNION SELECT 'NDC:00409121501' AS concept
		UNION SELECT 'NDC:00409121515' AS concept
		UNION SELECT 'NDC:00409121521' AS concept
		UNION SELECT 'NDC:00409121525' AS concept
		UNION SELECT 'NDC:00409121901' AS concept
		UNION SELECT 'NDC:00409121925' AS concept
		UNION SELECT 'NDC:00409121930' AS concept
		UNION SELECT 'NDC:00409121941' AS concept
		UNION SELECT 'NDC:00409178203' AS concept
		UNION SELECT 'NDC:00409178269' AS concept
		UNION SELECT 'NDC:00591039501' AS concept
		UNION SELECT 'NDC:00641613201' AS concept
		UNION SELECT 'NDC:00641613225' AS concept
		UNION SELECT 'NDC:00781721606' AS concept
		UNION SELECT 'NDC:00781721664' AS concept
		UNION SELECT 'NDC:00781722706' AS concept
		UNION SELECT 'NDC:00781722764' AS concept
		UNION SELECT 'NDC:00781723806' AS concept
		UNION SELECT 'NDC:00781723864' AS concept
		UNION SELECT 'NDC:00781724906' AS concept
		UNION SELECT 'NDC:00781724964' AS concept
		UNION SELECT 'NDC:00904701006' AS concept
		UNION SELECT 'NDC:12496120201' AS concept
		UNION SELECT 'NDC:12496120203' AS concept
		UNION SELECT 'NDC:12496120401' AS concept
		UNION SELECT 'NDC:12496120403' AS concept
		UNION SELECT 'NDC:12496120801' AS concept
		UNION SELECT 'NDC:12496120803' AS concept
		UNION SELECT 'NDC:12496121201' AS concept
		UNION SELECT 'NDC:12496121203' AS concept
		UNION SELECT 'NDC:17478004101' AS concept
		UNION SELECT 'NDC:17478004210' AS concept
		UNION SELECT 'NDC:42291017430' AS concept
		UNION SELECT 'NDC:42291017530' AS concept
		UNION SELECT 'NDC:42858060103' AS concept
		UNION SELECT 'NDC:42858060203' AS concept
		UNION SELECT 'NDC:43386068001' AS concept
		UNION SELECT 'NDC:43386068005' AS concept
		UNION SELECT 'NDC:43598057901' AS concept
		UNION SELECT 'NDC:43598057930' AS concept
		UNION SELECT 'NDC:43598058001' AS concept
		UNION SELECT 'NDC:43598058030' AS concept
		UNION SELECT 'NDC:43598058101' AS concept
		UNION SELECT 'NDC:43598058130' AS concept
		UNION SELECT 'NDC:43598058201' AS concept
		UNION SELECT 'NDC:43598058230' AS concept
		UNION SELECT 'NDC:43598075011' AS concept
		UNION SELECT 'NDC:43598075058' AS concept
		UNION SELECT 'NDC:47781035503' AS concept
		UNION SELECT 'NDC:47781035511' AS concept
		UNION SELECT 'NDC:47781035603' AS concept
		UNION SELECT 'NDC:47781035611' AS concept
		UNION SELECT 'NDC:47781035703' AS concept
		UNION SELECT 'NDC:47781035711' AS concept
		UNION SELECT 'NDC:47781035803' AS concept
		UNION SELECT 'NDC:47781035811' AS concept
		UNION SELECT 'NDC:50090183600' AS concept
		UNION SELECT 'NDC:50090242200' AS concept
		UNION SELECT 'NDC:50090315400' AS concept
		UNION SELECT 'NDC:50090329400' AS concept
		UNION SELECT 'NDC:50090542700' AS concept
		UNION SELECT 'NDC:50268014411' AS concept
		UNION SELECT 'NDC:50268014415' AS concept
		UNION SELECT 'NDC:50268014511' AS concept
		UNION SELECT 'NDC:50268014515' AS concept
		UNION SELECT 'NDC:50383028793' AS concept
		UNION SELECT 'NDC:50383029493' AS concept
		UNION SELECT 'NDC:51662123801' AS concept
		UNION SELECT 'NDC:51662123901' AS concept
		UNION SELECT 'NDC:51662123902' AS concept
		UNION SELECT 'NDC:51662123903' AS concept
		UNION SELECT 'NDC:51662124001' AS concept
		UNION SELECT 'NDC:51662124201' AS concept
		UNION SELECT 'NDC:51662124202' AS concept
		UNION SELECT 'NDC:51662124203' AS concept
		UNION SELECT 'NDC:51662138501' AS concept
		UNION SELECT 'NDC:51662142601' AS concept
		UNION SELECT 'NDC:52427069203' AS concept
		UNION SELECT 'NDC:52427069211' AS concept
		UNION SELECT 'NDC:52427069403' AS concept
		UNION SELECT 'NDC:52427069411' AS concept
		UNION SELECT 'NDC:52427069803' AS concept
		UNION SELECT 'NDC:52427069811' AS concept
		UNION SELECT 'NDC:52427071203' AS concept
		UNION SELECT 'NDC:52427071211' AS concept
		UNION SELECT 'NDC:52584005801' AS concept
		UNION SELECT 'NDC:52584021501' AS concept
		UNION SELECT 'NDC:52584029200' AS concept
		UNION SELECT 'NDC:52584036901' AS concept
		UNION SELECT 'NDC:52584046900' AS concept
		UNION SELECT 'NDC:52584078269' AS concept
		UNION SELECT 'NDC:52584097801' AS concept
		UNION SELECT 'NDC:53217013830' AS concept
		UNION SELECT 'NDC:53217032801' AS concept
		UNION SELECT 'NDC:54123011430' AS concept
		UNION SELECT 'NDC:54123090730' AS concept
		UNION SELECT 'NDC:54123091430' AS concept
		UNION SELECT 'NDC:54123092930' AS concept
		UNION SELECT 'NDC:54123095730' AS concept
		UNION SELECT 'NDC:54123098630' AS concept
		UNION SELECT 'NDC:55150032701' AS concept
		UNION SELECT 'NDC:55150032710' AS concept
		UNION SELECT 'NDC:55150032725' AS concept
		UNION SELECT 'NDC:55150032801' AS concept
		UNION SELECT 'NDC:55150032810' AS concept
		UNION SELECT 'NDC:55150032825' AS concept
		UNION SELECT 'NDC:55150034501' AS concept
		UNION SELECT 'NDC:55150034510' AS concept
		UNION SELECT 'NDC:55154395408' AS concept
		UNION SELECT 'NDC:55154473208' AS concept
		UNION SELECT 'NDC:55154698008' AS concept
		UNION SELECT 'NDC:55700014730' AS concept
		UNION SELECT 'NDC:55700045701' AS concept
		UNION SELECT 'NDC:59385001201' AS concept
		UNION SELECT 'NDC:59385001230' AS concept
		UNION SELECT 'NDC:59385001401' AS concept
		UNION SELECT 'NDC:59385001430' AS concept
		UNION SELECT 'NDC:59385001601' AS concept
		UNION SELECT 'NDC:59385001630' AS concept
		UNION SELECT 'NDC:60429058611' AS concept
		UNION SELECT 'NDC:60429058630' AS concept
		UNION SELECT 'NDC:60429058633' AS concept
		UNION SELECT 'NDC:60429058711' AS concept
		UNION SELECT 'NDC:60429058730' AS concept
		UNION SELECT 'NDC:60429058733' AS concept
		UNION SELECT 'NDC:60842005101' AS concept
		UNION SELECT 'NDC:61919055630' AS concept
		UNION SELECT 'NDC:62175045232' AS concept
		UNION SELECT 'NDC:62175045832' AS concept
		UNION SELECT 'NDC:62756096964' AS concept
		UNION SELECT 'NDC:62756096983' AS concept
		UNION SELECT 'NDC:62756097064' AS concept
		UNION SELECT 'NDC:62756097083' AS concept
		UNION SELECT 'NDC:63304050601' AS concept
		UNION SELECT 'NDC:63629727001' AS concept
		UNION SELECT 'NDC:63629727002' AS concept
		UNION SELECT 'NDC:63739046305' AS concept
		UNION SELECT 'NDC:63739046321' AS concept
		UNION SELECT 'NDC:64725178209' AS concept
		UNION SELECT 'NDC:65162041503' AS concept
		UNION SELECT 'NDC:65162041509' AS concept
		UNION SELECT 'NDC:65162041603' AS concept
		UNION SELECT 'NDC:65162041609' AS concept
		UNION SELECT 'NDC:67457029200' AS concept
		UNION SELECT 'NDC:67457029202' AS concept
		UNION SELECT 'NDC:67457029900' AS concept
		UNION SELECT 'NDC:67457029910' AS concept
		UNION SELECT 'NDC:67457059900' AS concept
		UNION SELECT 'NDC:67457059902' AS concept
		UNION SELECT 'NDC:67457064500' AS concept
		UNION SELECT 'NDC:67457064502' AS concept
		UNION SELECT 'NDC:67457098700' AS concept
		UNION SELECT 'NDC:67457098710' AS concept
		UNION SELECT 'NDC:68387053112' AS concept
		UNION SELECT 'NDC:68387053130' AS concept
		UNION SELECT 'NDC:68387053160' AS concept
		UNION SELECT 'NDC:69547021204' AS concept
		UNION SELECT 'NDC:69547021224' AS concept
		UNION SELECT 'NDC:69547035302' AS concept
		UNION SELECT 'NDC:70069007101' AS concept
		UNION SELECT 'NDC:70069007110' AS concept
		UNION SELECT 'NDC:70069007201' AS concept
		UNION SELECT 'NDC:70069007210' AS concept
		UNION SELECT 'NDC:70385201301' AS concept
		UNION SELECT 'NDC:70518100700' AS concept
		UNION SELECT 'NDC:70518168400' AS concept
		UNION SELECT 'NDC:70518231100' AS concept
		UNION SELECT 'NDC:70518232700' AS concept
		UNION SELECT 'NDC:70518272500' AS concept
		UNION SELECT 'NDC:70518278000' AS concept
		UNION SELECT 'NDC:70518278001' AS concept
		UNION SELECT 'NDC:70655005810' AS concept
		UNION SELECT 'NDC:71335129601' AS concept
		UNION SELECT 'NDC:71335129602' AS concept
		UNION SELECT 'NDC:71335137801' AS concept
		UNION SELECT 'NDC:71335151401' AS concept
		UNION SELECT 'NDC:71335151402' AS concept
		UNION SELECT 'NDC:71335165301' AS concept
		UNION SELECT 'NDC:71335172001' AS concept
		UNION SELECT 'NDC:71335172002' AS concept
		UNION SELECT 'NDC:71335172501' AS concept
		UNION SELECT 'NDC:71872700901' AS concept
		UNION SELECT 'NDC:71872701801' AS concept
		UNION SELECT 'NDC:71872717701' AS concept
		UNION SELECT 'NDC:71872719801' AS concept
		UNION SELECT 'NDC:71872721501' AS concept
		UNION SELECT 'NDC:71872721901' AS concept
		UNION SELECT 'NDC:72572045001' AS concept
		UNION SELECT 'NDC:72572045025' AS concept
		UNION SELECT 'NDC:72853005102' AS concept
		UNION SELECT 'NDC:76329146901' AS concept
		UNION SELECT 'NDC:76329336901' AS concept
		UNION SELECT 'NDC:76329346901' AS concept
		UNION SELECT 'RxDrug:1010600' AS concept
		UNION SELECT 'RxDrug:1010603' AS concept
		UNION SELECT 'RxDrug:1010604' AS concept
		UNION SELECT 'RxDrug:1010606' AS concept
		UNION SELECT 'RxDrug:1010608' AS concept
		UNION SELECT 'RxDrug:1010609' AS concept
		UNION SELECT 'RxDrug:1191212' AS concept
		UNION SELECT 'RxDrug:1191222' AS concept
		UNION SELECT 'RxDrug:1191228' AS concept
		UNION SELECT 'RxDrug:1191234' AS concept
		UNION SELECT 'RxDrug:1191250' AS concept
		UNION SELECT 'RxDrug:1307056' AS concept
		UNION SELECT 'RxDrug:1307058' AS concept
		UNION SELECT 'RxDrug:1307061' AS concept
		UNION SELECT 'RxDrug:1307063' AS concept
		UNION SELECT 'RxDrug:1431076' AS concept
		UNION SELECT 'RxDrug:1431083' AS concept
		UNION SELECT 'RxDrug:1431102' AS concept
		UNION SELECT 'RxDrug:1431104' AS concept
		UNION SELECT 'RxDrug:1495293' AS concept
		UNION SELECT 'RxDrug:1495298' AS concept
		UNION SELECT 'RxDrug:1542390' AS concept
		UNION SELECT 'RxDrug:1542396' AS concept
		UNION SELECT 'RxDrug:1544851' AS concept
		UNION SELECT 'RxDrug:1544853' AS concept
		UNION SELECT 'RxDrug:1544854' AS concept
		UNION SELECT 'RxDrug:1544856' AS concept
		UNION SELECT 'RxDrug:1545903' AS concept
		UNION SELECT 'RxDrug:1545907' AS concept
		UNION SELECT 'RxDrug:1545910' AS concept
		UNION SELECT 'RxDrug:1546089' AS concept
		UNION SELECT 'RxDrug:1597568' AS concept
		UNION SELECT 'RxDrug:1597570' AS concept
		UNION SELECT 'RxDrug:1597573' AS concept
		UNION SELECT 'RxDrug:1597575' AS concept
		UNION SELECT 'RxDrug:1659929' AS concept
		UNION SELECT 'RxDrug:1666338' AS concept
		UNION SELECT 'RxDrug:1666385' AS concept
		UNION SELECT 'RxDrug:1725059' AS concept
		UNION SELECT 'RxDrug:1725064' AS concept
		UNION SELECT 'RxDrug:1855730' AS concept
		UNION SELECT 'RxDrug:1855732' AS concept
		UNION SELECT 'RxDrug:1864412' AS concept
		UNION SELECT 'RxDrug:1864414' AS concept
		UNION SELECT 'RxDrug:1870933' AS concept
		UNION SELECT 'RxDrug:1870935' AS concept
		UNION SELECT 'RxDrug:2058257' AS concept
		UNION SELECT 'RxDrug:2106368' AS concept
		UNION SELECT 'RxDrug:2268081' AS concept
		UNION SELECT 'RxDrug:2268085' AS concept
		UNION SELECT 'RxDrug:312289' AS concept
		UNION SELECT 'RxDrug:351266' AS concept
		UNION SELECT 'RxDrug:351267' AS concept
		UNION SELECT 'NLM:RXNORM:7242' AS concept
	)
	
	SELECT 'uniq_pt_opioid',
	(
		SELECT count(distinct patient_id) 
		FROM  :TNX_SCHEMA.patient 
		WHERE patient_id IN 
			(
				SELECT patient_id 
				FROM :TNX_SCHEMA.diagnosis diag
				JOIN :TNX_SCHEMA.mapping ON diag.code_system || ':' || diag.code = mapping.provider_code
				WHERE mapping.mt_code like 'UMLS:ICD10CM:F11%' 
				
				AND YEAR(date) = (YEAR(CURRENT_DATE())-1)
			)
		OR patient_id IN 
			(
				SELECT patient_id
				FROM :TNX_SCHEMA.medication med
				JOIN :TNX_SCHEMA.mapping ON med.code_system || ':' || med.code = mapping.provider_code
				JOIN methadone_concepts ON mapping.mt_code = methadone_concepts.concept
				WHERE YEAR(start_date) = (YEAR(CURRENT_DATE())-1)
			)
		OR patient_id IN
			(
				SELECT patient_id
				FROM :TNX_SCHEMA.medication med
				JOIN :TNX_SCHEMA.mapping ON med.code_system || ':' || med.code = mapping.provider_code
				JOIN buprenorphine_concepts ON mapping.mt_code = buprenorphine_concepts.concept
				WHERE YEAR(start_date) = (YEAR(CURRENT_DATE())-1)
			)
		OR patient_id IN
			(
				SELECT patient_id
				FROM :TNX_SCHEMA.medication med
				JOIN :TNX_SCHEMA.mapping ON med.code_system || ':' || med.code = mapping.provider_code
				JOIN suboxone_concepts ON mapping.mt_code = suboxone_concepts.concept
				WHERE YEAR(start_date) = (YEAR(CURRENT_DATE())-1)
			)
	),
	(
		SELECT count(distinct patient_id) 
		FROM :TNX_SCHEMA.patient
		WHERE patient_id IN 
			(
				SELECT patient_id 
				FROM :TNX_SCHEMA.diagnosis diag
				JOIN :TNX_SCHEMA.mapping ON diag.code_system || ':' || diag.code = mapping.provider_code
				WHERE mapping.mt_code like 'UMLS:ICD10CM:F11%' 
				
				AND YEAR(date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(date) < YEAR(CURRENT_DATE())
			)
		OR patient_id IN 
			(
				SELECT patient_id
				FROM :TNX_SCHEMA.medication med
				JOIN :TNX_SCHEMA.mapping ON med.code_system || ':' || med.code = mapping.provider_code
				JOIN methadone_concepts ON mapping.mt_code = methadone_concepts.concept
				WHERE YEAR(start_date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(start_date) < YEAR(CURRENT_DATE())
			)
		OR patient_id IN
			(
				SELECT patient_id
				FROM :TNX_SCHEMA.medication med
				JOIN :TNX_SCHEMA.mapping ON med.code_system || ':' || med.code = mapping.provider_code
				JOIN buprenorphine_concepts ON mapping.mt_code = buprenorphine_concepts.concept
				WHERE YEAR(start_date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(start_date) < YEAR(CURRENT_DATE())
			)
		OR patient_id IN
			(
				SELECT patient_id
				FROM :TNX_SCHEMA.medication med
				JOIN :TNX_SCHEMA.mapping ON med.code_system || ':' || med.code = mapping.provider_code
				JOIN suboxone_concepts ON mapping.mt_code = suboxone_concepts.concept
				WHERE YEAR(start_date) >= (YEAR(CURRENT_DATE())-5) AND YEAR(start_date) < YEAR(CURRENT_DATE())
			)
	)
);


-- unique patients with any non null insurance provider
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_pt_any_insurance_value', 0, 0
);

-- unique encounters with at least one SNOMED in timeframe
INSERT INTO :TNX_SCHEMA.ctsa
(
	SELECT 'uniq_pt_insurance_value_set', 0, 0
);


---------------------------------------------------------------------------------------------------------
-- 14. Display results
---------------------------------------------------------------------------------------------------------
\a
\pset fieldsep ','
\o
SELECT * FROM :TNX_SCHEMA.ctsa;
\o /dev/null


---------------------------------------------------------------------------------------------------------
-- 15. Cleanup
---------------------------------------------------------------------------------------------------------

DROP TABLE :TNX_SCHEMA.ctsa;
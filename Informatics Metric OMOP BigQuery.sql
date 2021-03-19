-- Query Informatics Metrics CTSA EDW
-- Data Model: OMOP 5.X
-- Database Google BigQuery
--
-- ********************************************************************************************
-- TO EXECUTE: 
--   1. Replace [ADD YOUR SCHEMA PATH HERE] with the full DB.SCHEMA for your GBQ instance
--   2. Modify start/end dates in DT_Interval temp table per date restriction requirements
--   2. Check table names for upper/lower case match (column names are not case sensitive)
-- ********************************************************************************************
-- Version 2021
-- Updated 01/2021
-- Created by Michael Kahn University of Colorado (Michael.Kahn@cuanschutz.edu)
-- Version 2021 modifications:
--   - Complete rewrite to meet new metrics and upload format
--
--
-- Version 2020
-- Updated 06/25/2020
-- Modified by Michael Kahn University of Colorado (Michael.Kahn@cuanschutz.edu)
-- Version 2020 modifications:
--   - New temp table (DT_Interval) to implement date restriction in one place
--   - Restricted all metrics to data collected on patients with visits between 1/1/2019-12/31/2019
--         - Valid PERSON_IDs pulled FROM  hdcintt.omop_uchealth.visit_occurrence using visit_start_date rather than PERSON
--   - lowercased all tables
--   - added #standardSQL query prefix to ensure right syntax is used

-- Version 2018
-- Created 12/24/2018
-- Based on Version: Database MS SQL / Updated 01/05/2018
-- Modified by Michael Kahn University of Colorado (Michael.Kahn@ucdenver.edu)
-- Version 2018 GBQ Modifications:
--   - Oracle-like WITH-AS syntax
--   - GBQ aliases cannot have spaces and cannot be quoted.
--            Replaced spaces in column aliases with underscores
--            Removed single quotes around column aliases
--   - GBQ Column names cannot have special chars. 
--            Replaced %_Standards column alias with PerCnt_Standards
--   - Replaced UNION DISTINCT --> UNION DISTINCT All
--   - Replaced Float with Float64
--   - GBQ table names are case sensitive
--            Colorado GBQ table names are ALL CAPS
--            Changed table names to ALL CAPS
--            But GBQ column names are not case sensitve (go figure)
--
#standardSQL
-- create or replace temp table DT_Interval as (
--   SELECT CAST('2019-01-01' as DATE) as Start_Date, CAST('2019-12-31' as DATE) as End_Date );



# Start of Rob's code

with config as (
	SELECT 
		  1 as rec_id
		  ,'2020_arm_1' as event_name
		  ,'Tufts' as access_group
		  ,'1' as using_nlp_solutions -- 1 = yes, 0 = no

		  -- indicate which, if any, NLP coding solutions are used
		  -- 1 = yes, 0 = no
		  ,'0' as nlp_hbo
		  ,'0' as nlp_snomed
		  ,'0' as nlp_loinc
		  ,'0' as nlp_rxnorm
		  ,'0' as nlp_mesh
		  ,'0' as nlp_umls
		  ,'0' as nlp_icd
		  ,'0' as nlp_cpt
		  ,'0' as nlp_other
		  ,'N/A' as nlp_other_describe
)
SELECT conf.rec_id
	   , x.*
FROM config conf
INNER JOIN 
(


SELECT 
		'redcap_event_name' as var_name
		,event_name as var_value
FROM config

UNION DISTINCT
SELECT
		'redcap_data_access_group' as var_name
		,access_group as var_value
FROM config

UNION DISTINCT
SELECT 
		'if_data_model___2' as var_name
		,'1' as var_value

UNION DISTINCT
SELECT 
		'if_total_patients' as var_name
		,CAST(COUNT(distinct person_id) as string) as var_value
FROM hdcintt.omop_uchealth.person per

UNION DISTINCT
SELECT 'if_age_num_act' as var_name
		,CAST(COUNT(distinct person_id) as string) as var_value
FROM hdcintt.omop_uchealth.person
WHERE birth_datetime IS NOT NULL

-- what to do here? there is no field to indicate when the patient was added to the database
UNION DISTINCT
SELECT 'if_5_age_num_act' as var_name
		,'' as var_value

UNION DISTINCT
SELECT 'if_neg_age_num_act' as var_name
		,CAST(COUNT(distinct person_id) as string) as var_value
FROM hdcintt.omop_uchealth.person
WHERE date_diff(cast(birth_datetime as date), CURRENT_DATE(),day) < 0

-- what to do here? there is no field to indicate when the patient was added to the database
UNION DISTINCT
SELECT 'if_5_neg_age_act' as var_name
		,'' as var_value

UNION DISTINCT
SELECT 'if_age_120_num_act' as var_name
		,CAST(COUNT(distinct person_id) as string) as var_value
FROM hdcintt.omop_uchealth.person
WHERE date_diff(cast(birth_datetime as date), CURRENT_DATE(),year) > 120


-- what to do here? there is no field to indicate when the patient was added to the database
UNION DISTINCT
SELECT 'if_5_age_120_num_act' as var_name
		,'' as var_value

UNION DISTINCT
SELECT 'if_gender_num_act' as var_name
		,CAST(COUNT(distinct person_id) as string) as var_value
FROM hdcintt.omop_uchealth.person
WHERE gender_concept_id IS NOT NULL
AND gender_concept_id <> 0

-- what to do here? there is no field to indicate when the patient was added to the database
UNION DISTINCT
SELECT 'if_5_gender_num_act' as var_name
		,'' as var_value

UNION DISTINCT
SELECT 'if_lab_num_act' as var_name
		,CAST(COUNT(distinct person_id) as string) as var_value
FROM hdcintt.omop_uchealth.measurement

UNION DISTINCT
SELECT 'if_5_lab_num_act' as var_name
		,CAST(COUNT(distinct person_id) as string) as var_value
FROM hdcintt.omop_uchealth.measurement
WHERE date_diff(measurement_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_total_lab_tests' as var_name
		,CAST(COUNT(*) as string) as var_value
FROM hdcintt.omop_uchealth.measurement

UNION DISTINCT
SELECT 'if_lab_loinc_num_act' as var_name
				,CAST(COUNT(*) as string) as var_value
FROM hdcintt.omop_uchealth.measurement meas
INNER JOIN hdcintt.omop_uchealth.concept conc
ON meas.measurement_concept_id = conc.concept_id
AND conc.vocabulary_id = 'LOINC'

UNION DISTINCT
SELECT 'if_5_lab_loinc_num_act' as var_name
		,CAST(COUNT(*) as string) as var_value
FROM hdcintt.omop_uchealth.measurement meas
INNER JOIN hdcintt.omop_uchealth.concept conc
ON meas.measurement_concept_id = conc.concept_id
AND conc.vocabulary_id = 'LOINC'
AND date_diff(measurement_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_med_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as string) as var_value
FROM  hdcintt.omop_uchealth.drug_exposure

UNION DISTINCT
SELECT 'if_5_med_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as string) as var_value
FROM  hdcintt.omop_uchealth.drug_exposure
WHERE date_diff(drug_exposure_start_date, CURRENT_DATE(),year) BETWEEN 0 AND 5


UNION DISTINCT
SELECT 'if_med_rx_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as string) as var_value
FROM  hdcintt.omop_uchealth.drug_exposure drug
INNER JOIN hdcintt.omop_uchealth.concept conc
ON drug.drug_concept_id = conc.concept_id
AND conc.vocabulary_id = 'RxNorm'

UNION DISTINCT
SELECT 'if_5_med_rx_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as string) as var_value
FROM  hdcintt.omop_uchealth.drug_exposure drug
INNER JOIN hdcintt.omop_uchealth.concept conc
ON drug.drug_concept_id = conc.concept_id
AND conc.vocabulary_id = 'RxNorm'
AND date_diff(drug_exposure_start_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_total_med_rec' as var_name
		,CAST(COUNT(*) as string) as var_value
FROM  hdcintt.omop_uchealth.drug_exposure

UNION DISTINCT
SELECT 'if_med_rec_num_act' as var_name
		,CAST(COUNT(*) as string) as var_value
FROM  hdcintt.omop_uchealth.drug_exposure drug
INNER JOIN hdcintt.omop_uchealth.concept conc
ON drug.drug_concept_id = conc.concept_id
AND conc.vocabulary_id = 'RxNorm'

UNION DISTINCT
SELECT 'if_5_med_rec_num_act' as var_name
		,CAST(COUNT(*) as string) as var_value
FROM  hdcintt.omop_uchealth.drug_exposure drug
INNER JOIN hdcintt.omop_uchealth.concept conc
ON drug.drug_concept_id = conc.concept_id
AND conc.vocabulary_id = 'RxNorm'
AND date_diff(drug_exposure_start_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_pt_diag_icd_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as string) as var_value
FROM  hdcintt.omop_uchealth.condition_occurrence cond
INNER JOIN hdcintt.omop_uchealth.concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD9CM', 'ICD10CM')


UNION DISTINCT
SELECT 'if_5_pt_diag_icd_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as string) as var_value
FROM  hdcintt.omop_uchealth.condition_occurrence cond
INNER JOIN hdcintt.omop_uchealth.concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD9CM', 'ICD10CM')
AND date_diff(condition_start_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_total_ent' as var_name
		,CAST(COUNT(*) as string) as var_value
FROM  hdcintt.omop_uchealth.visit_occurrence 


UNION DISTINCT
SELECT 'if_ent_diag_icd_num_act' as var_name
		,CAST(COUNT(DISTINCT visit_occurrence_id) as string) as var_value
FROM  hdcintt.omop_uchealth.condition_occurrence cond
INNER JOIN hdcintt.omop_uchealth.concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD9CM', 'ICD10CM')

UNION DISTINCT
SELECT 'if_5_ent_diag_icd_num_act' as var_name
		,CAST(COUNT(DISTINCT visit_occurrence_id) as string) as var_value
FROM  hdcintt.omop_uchealth.condition_occurrence cond
INNER JOIN hdcintt.omop_uchealth.concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD9CM', 'ICD10CM')
AND date_diff(condition_start_date, CURRENT_DATE(),year) BETWEEN 0 AND 5


UNION DISTINCT
SELECT 'if_total_diag' as var_name
	,CAST(COUNT(*) as string) as var_value
FROM  hdcintt.omop_uchealth.condition_occurrence

UNION DISTINCT
SELECT 'if_diag_icd_num_act' as var_name
		,CAST(COUNT(*) as string) as var_value
FROM  hdcintt.omop_uchealth.condition_occurrence cond
INNER JOIN hdcintt.omop_uchealth.concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD9CM', 'ICD10CM')


UNION DISTINCT
SELECT 'if_5_diag_icd_num_act' as var_name
		,CAST(COUNT(*) as string) as var_value
FROM  hdcintt.omop_uchealth.condition_occurrence cond
INNER JOIN hdcintt.omop_uchealth.concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD9CM', 'ICD10CM')
AND date_diff(condition_start_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_total_uni_diag' as var_name
		,CAST(COUNT(DISTINCT condition_concept_id) as string) as var_value
FROM  hdcintt.omop_uchealth.condition_occurrence

UNION DISTINCT
SELECT 'if_uni_diag_icd_num_act' as var_name
		,CAST(COUNT(DISTINCT condition_concept_id) as string) as var_value
FROM  hdcintt.omop_uchealth.condition_occurrence cond
INNER JOIN hdcintt.omop_uchealth.concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD9CM', 'ICD10CM')

UNION DISTINCT
SELECT 'if_5_uni_diag_icd_num_act' as var_name
		,CAST(COUNT(DISTINCT condition_concept_id) as string) as var_value
FROM  hdcintt.omop_uchealth.condition_occurrence cond
INNER JOIN hdcintt.omop_uchealth.concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD9CM', 'ICD10CM')
AND date_diff(condition_start_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_pt_diag_snomed_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as string) as var_value
FROM  hdcintt.omop_uchealth.condition_occurrence cond
INNER JOIN hdcintt.omop_uchealth.concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'

UNION DISTINCT
SELECT 'if_5_pt_diag_snomed_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as string) as var_value
FROM  hdcintt.omop_uchealth.condition_occurrence cond
INNER JOIN hdcintt.omop_uchealth.concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'
AND date_diff(condition_start_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_ent_diag_snomed_num_act' as var_name
		,CAST(COUNT(DISTINCT visit_occurrence_id) as string) as var_value
FROM  hdcintt.omop_uchealth.condition_occurrence cond
INNER JOIN hdcintt.omop_uchealth.concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'

UNION DISTINCT
SELECT 'if_5_ent_diag_snomed_num_act' as var_name
		,CAST(COUNT(DISTINCT visit_occurrence_id) as string) as var_value
FROM  hdcintt.omop_uchealth.condition_occurrence cond
INNER JOIN hdcintt.omop_uchealth.concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'
AND date_diff(condition_start_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_diag_snomed_num_act' as var_name
		,CAST(COUNT(*) as string) as var_value
FROM  hdcintt.omop_uchealth.condition_occurrence cond
INNER JOIN hdcintt.omop_uchealth.concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'

UNION DISTINCT
SELECT 'if_5_diag_snomed_num_act' as var_name
		,CAST(COUNT(*) as string) as var_value
FROM  hdcintt.omop_uchealth.condition_occurrence cond
INNER JOIN hdcintt.omop_uchealth.concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'
AND date_diff(condition_start_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_uni_diag_snomed_num_act' as var_name
		,CAST(COUNT(DISTINCT condition_concept_id) as string) as var_value
FROM  hdcintt.omop_uchealth.condition_occurrence cond
INNER JOIN hdcintt.omop_uchealth.concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'

UNION DISTINCT
SELECT 'if_5_uni_diag_snomed_num_act' as var_name
		,CAST(COUNT(DISTINCT condition_concept_id) as string) as var_value
FROM  hdcintt.omop_uchealth.condition_occurrence cond
INNER JOIN hdcintt.omop_uchealth.concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'
AND date_diff(condition_start_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_pt_proc_icd_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD10PCS','ICD9Proc')

UNION DISTINCT
SELECT 'if_5_pt_proc_icd_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD10PCS','ICD9Proc')
AND date_diff(procedure_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_ent_proc_icd_num_act' as var_name
		,CAST(COUNT(DISTINCT visit_occurrence_id) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD10PCS','ICD9Proc')

UNION DISTINCT
SELECT 'if_5_ent_proc_icd_num_act' as var_name
		,CAST(COUNT(DISTINCT visit_occurrence_id) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD10PCS','ICD9Proc')
AND date_diff(procedure_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_total_proc' as var_name
		,CAST(COUNT(*) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence

UNION DISTINCT
SELECT 'if_proc_icd_num_act' as var_name
		,CAST(COUNT(*) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD10PCS','ICD9Proc')

UNION DISTINCT
SELECT 'if_5_proc_icd_num_act' as var_name
		,CAST(COUNT(*) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD10PCS','ICD9Proc')
AND date_diff(procedure_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_total_uni_proc' as var_name
		,CAST(COUNT(distinct procedure_concept_id) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence

UNION DISTINCT
SELECT 'if_uni_proc_icd_num_act' as var_name
		,CAST(COUNT(distinct procedure_concept_id) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD10PCS','ICD9Proc')

UNION DISTINCT
SELECT 'if_5_uni_proc_icd_num_act' as var_name
		,CAST(COUNT(distinct procedure_concept_id) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD10PCS','ICD9Proc')
AND date_diff(procedure_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_pt_proc_cpt_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('HCPCS','CPT4')


UNION DISTINCT
SELECT 'if_5_pt_proc_cpt_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('HCPCS','CPT4')
AND date_diff(procedure_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_ent_proc_cpt_num_act' as var_name
		,CAST(COUNT(DISTINCT visit_occurrence_id) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('HCPCS','CPT4')

UNION DISTINCT
SELECT 'if_5_ent_proc_cpt_num_act' as var_name
		,CAST(COUNT(DISTINCT visit_occurrence_id) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('HCPCS','CPT4')
AND date_diff(procedure_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_proc_cpt_num_act' as var_name
		,CAST(COUNT(*) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('HCPCS','CPT4')

UNION DISTINCT
SELECT 'if_5_proc_cpt_num_act' as var_name
		,CAST(COUNT(*) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('HCPCS','CPT4')
AND date_diff(procedure_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_uni_proc_cpt_num_act' as var_name
		,CAST(COUNT(distinct procedure_concept_id) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('HCPCS','CPT4')

UNION DISTINCT
SELECT 'if_5_uni_proc_cpt_num_act' as var_name
		,CAST(COUNT(distinct procedure_concept_id) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('HCPCS','CPT4')
AND date_diff(procedure_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_pt_proc_snomed_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'

UNION DISTINCT
SELECT 'if_5_pt_proc_snomed_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'
AND date_diff(procedure_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_ent_proc_snomed_num_act' as var_name
		,CAST(COUNT(DISTINCT visit_occurrence_id) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'

UNION DISTINCT
SELECT 'if_5_ent_proc_snomed_num_act' as var_name
		,CAST(COUNT(DISTINCT visit_occurrence_id) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'
AND date_diff(procedure_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_proc_snomed_num_act' as var_name
	   ,CAST(COUNT(*) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'
AND date_diff(procedure_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_5_proc_snomed_num_act' as var_name
	   ,CAST(COUNT(*) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'
AND date_diff(procedure_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_uni_proc_snomed_num_act' as var_name
	   ,CAST(COUNT(DISTINCT procedure_concept_id) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'

UNION DISTINCT
SELECT 'if_5_uni_proc_snomed_num_act' as var_name
	   ,CAST(COUNT(DISTINCT procedure_concept_id) as string) as var_value
FROM  hdcintt.omop_uchealth.procedure_occurrence proce
INNER JOIN hdcintt.omop_uchealth.concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'
AND date_diff(procedure_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

-- UNION DISTINCT
-- SELECT 'if_pt_free_txt_num_act' as var_name
-- 	   ,CAST(COUNT(DISTINCT person_id) as string) as var_value
-- FROM  hdcintt.omop_uchealth.note

-- UNION DISTINCT
-- SELECT 'if_5_pt_free_txt_num_act' as var_name
-- 	    ,CAST(COUNT(DISTINCT person_id) as string) as var_value
-- FROM  hdcintt.omop_uchealth.note
-- WHERE (note_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

-- UNION DISTINCT
-- SELECT 'if_ent_free_txt_num_act' as var_name
-- 	  ,CAST(COUNT(DISTINCT visit_occurrence_id) as string) as var_value
-- FROM  hdcintt.omop_uchealth.note

-- UNION DISTINCT
-- SELECT 'if_5_ent_free_txt_num_act' as var_name
-- 	  ,CAST(COUNT(DISTINCT visit_occurrence_id) as string) as var_value
-- FROM  hdcintt.omop_uchealth.note
-- WHERE (note_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_free_txt_nlp_act' as var_name
	   ,using_nlp_solutions as var_value
FROM config

UNION DISTINCT
SELECT 'if_free_txt_nlp_code_act___1' as var_name
	   ,nlp_hbo as var_value
FROM config

UNION DISTINCT
SELECT 'if_free_txt_nlp_code_act___2' as var_name
	   ,nlp_snomed as var_value
FROM config

UNION DISTINCT
SELECT 'if_free_txt_nlp_code_act___3' as var_name
	   ,nlp_loinc as var_value
FROM config

UNION DISTINCT
SELECT 'if_free_txt_nlp_code_act___4' as var_name
	   ,nlp_rxnorm as var_value
FROM config

UNION DISTINCT
SELECT 'if_free_txt_nlp_code_act___5' as var_name
	   ,nlp_mesh as var_value
FROM config

UNION DISTINCT
SELECT 'if_free_txt_nlp_code_act___6' as var_name
	   ,nlp_umls as var_value
FROM config

UNION DISTINCT
SELECT 'if_free_txt_nlp_code_act___7' as var_name
	   ,nlp_icd as var_value
FROM config

UNION DISTINCT
SELECT 'if_free_txt_nlp_code_act___8' as var_name
	  ,nlp_cpt as var_value
FROM config

UNION DISTINCT
SELECT 'if_free_txt_nlp_code_act____99' as var_name
	  ,nlp_other as var_value
FROM config

UNION DISTINCT
SELECT 'if_nlp_sol_other' as var_name
	   ,nlp_other_describe as var_value
FROM config

UNION DISTINCT
SELECT 'if_ent_vital_sign_num_act' as var_name
	   ,'' as var_value

UNION DISTINCT
SELECT 'if_5_ent_vital_sign_num_act' as var_name
	   ,'' as var_value

UNION DISTINCT
SELECT 'if_total_pt_12' as var_name
	   ,CAST(COUNT(distinct person_id) as string) as var_value
FROM hdcintt.omop_uchealth.person
WHERE date_diff(cast(birth_datetime as date), CURRENT_DATE(),year) > 12

UNION DISTINCT
SELECT 'if_pt_smoke_num_act' as var_name
	   ,'' as var_value

UNION DISTINCT
SELECT 'if_5_pt_smoke_num_act' as var_name
	   ,'' as var_value

UNION DISTINCT
SELECT 'if_pt_opioid_num_act' as var_name
	   ,'' as var_value

UNION DISTINCT
SELECT 'if_5_pt_opioid_num_act' as var_name
	   ,'' as var_value

UNION DISTINCT
SELECT 'if_pt_insur_prvder_num_act' as var_name
	   ,'' as var_value

UNION DISTINCT
SELECT 'if_5_pt_insur_prvder_num_act' as var_name
	   ,'' as var_value

UNION DISTINCT
SELECT 'if_pt_insur_status_num_act' as var_name
	   ,'' as var_value

UNION DISTINCT
SELECT 'if_5_pt_insur_status_num_act' as var_name
	   ,'' as var_value

UNION DISTINCT
SELECT 'if_visit_num_act' as var_name
	   ,CAST(COUNT(distinct person_id) as string) as var_value
FROM  hdcintt.omop_uchealth.visit_occurrence

UNION DISTINCT
SELECT 'if_5_visit_num_act' as var_name
	   ,CAST(COUNT(distinct person_id) as string) as var_value
FROM  hdcintt.omop_uchealth.visit_occurrence
WHERE date_diff(visit_start_date, CURRENT_DATE(),year) BETWEEN 0 AND 5

UNION DISTINCT
SELECT 'if_visit_12mon_num_act' as var_name
	   ,'' as var_value
UNION DISTINCT
SELECT 'if_5_visit_12mon_num_act' as var_name
	   ,'' as var_value
UNION DISTINCT
SELECT 'if_visit_5yr_num_act' as var_name
	   ,'' as var_value
UNION DISTINCT
SELECT 'if_5_visit_5yr_num_act' as var_name
	   ,'' as var_value


 ) x
 ON 1=1

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

UNION
SELECT
		'redcap_data_access_group' as var_name
		,access_group as var_value
FROM config

UNION
SELECT 
		'if_data_model___2' as var_name
		,'1' as var_value

UNION
SELECT 
		'if_total_patients' as var_name
		,CAST(COUNT(distinct person_id) as varchar(50)) as var_value
FROM person per

UNION
SELECT 'if_age_num_act' as var_name
		,CAST(COUNT(distinct person_id) as varchar(50)) as var_value
FROM person
WHERE birth_datetime IS NOT NULL

-- what to do here? there is no field to indicate when the patient was added to the database
UNION
SELECT 'if_5_age_num_act' as var_name
		,'' as var_value

UNION
SELECT 'if_neg_age_num_act' as var_name
		,CAST(COUNT(distinct person_id) as varchar(50)) as var_value
FROM person
WHERE DATEDIFF(day, birth_datetime, GETDATE()) < 0

-- what to do here? there is no field to indicate when the patient was added to the database
UNION
SELECT 'if_5_neg_age_act' as var_name
		,'' as var_value

UNION
SELECT 'if_age_120_num_act' as var_name
		,CAST(COUNT(distinct person_id) as varchar(50)) as var_value
FROM person
WHERE DATEDIFF(year, birth_datetime, GETDATE()) > 120


-- what to do here? there is no field to indicate when the patient was added to the database
UNION
SELECT 'if_5_age_120_num_act' as var_name
		,'' as var_value

UNION
SELECT 'if_gender_num_act' as var_name
		,CAST(COUNT(distinct person_id) as varchar(50)) as var_value
FROM person
WHERE gender_concept_id IS NOT NULL
AND gender_concept_id <> 0

-- what to do here? there is no field to indicate when the patient was added to the database
UNION
SELECT 'if_5_gender_num_act' as var_name
		,'' as var_value

UNION
SELECT 'if_lab_num_act' as var_name
		,CAST(COUNT(distinct person_id) as varchar(50)) as var_value
FROM measurement

UNION
SELECT 'if_5_lab_num_act' as var_name
		,CAST(COUNT(distinct person_id) as varchar(50)) as var_value
FROM measurement
WHERE DATEDIFF(year, measurement_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_total_lab_tests' as var_name
		,CAST(COUNT(*) as varchar(50)) as var_value
FROM measurement

UNION
SELECT 'if_lab_loinc_num_act' as var_name
				,CAST(COUNT(*) as varchar(50)) as var_value
FROM measurement meas
INNER JOIN concept conc
ON meas.measurement_concept_id = conc.concept_id
AND conc.vocabulary_id = 'LOINC'

UNION
SELECT 'if_5_lab_loinc_num_act' as var_name
		,CAST(COUNT(*) as varchar(50)) as var_value
FROM measurement meas
INNER JOIN concept conc
ON meas.measurement_concept_id = conc.concept_id
AND conc.vocabulary_id = 'LOINC'
AND DATEDIFF(year, measurement_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_med_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as varchar(50)) as var_value
FROM drug_exposure

UNION
SELECT 'if_5_med_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as varchar(50)) as var_value
FROM drug_exposure
WHERE DATEDIFF(year, drug_exposure_start_date, GETDATE()) BETWEEN 0 AND 5


UNION
SELECT 'if_med_rx_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as varchar(50)) as var_value
FROM drug_exposure drug
INNER JOIN concept conc
ON drug.drug_concept_id = conc.concept_id
AND conc.vocabulary_id = 'RxNorm'

UNION
SELECT 'if_5_med_rx_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as varchar(50)) as var_value
FROM drug_exposure drug
INNER JOIN concept conc
ON drug.drug_concept_id = conc.concept_id
AND conc.vocabulary_id = 'RxNorm'
AND DATEDIFF(year, drug_exposure_start_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_total_med_rec' as var_name
		,CAST(COUNT(*) as varchar(50)) as var_value
FROM drug_exposure

UNION
SELECT 'if_med_rec_num_act' as var_name
		,CAST(COUNT(*) as varchar(50)) as var_value
FROM drug_exposure drug
INNER JOIN concept conc
ON drug.drug_concept_id = conc.concept_id
AND conc.vocabulary_id = 'RxNorm'

UNION
SELECT 'if_5_med_rec_num_act' as var_name
		,CAST(COUNT(*) as varchar(50)) as var_value
FROM drug_exposure drug
INNER JOIN concept conc
ON drug.drug_concept_id = conc.concept_id
AND conc.vocabulary_id = 'RxNorm'
AND DATEDIFF(year, drug_exposure_start_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_pt_diag_icd_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as varchar(50)) as var_value
FROM condition_occurrence cond
INNER JOIN concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD9CM', 'ICD10CM')


UNION
SELECT 'if_5_pt_diag_icd_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as varchar(50)) as var_value
FROM condition_occurrence cond
INNER JOIN concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD9CM', 'ICD10CM')
AND DATEDIFF(year, condition_start_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_total_ent' as var_name
		,CAST(COUNT(*) as varchar(50)) as var_value
FROM visit_occurrence 


UNION
SELECT 'if_ent_diag_icd_num_act' as var_name
		,CAST(COUNT(DISTINCT visit_occurrence_id) as varchar(50)) as var_value
FROM condition_occurrence cond
INNER JOIN concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD9CM', 'ICD10CM')

UNION
SELECT 'if_5_ent_diag_icd_num_act' as var_name
		,CAST(COUNT(DISTINCT visit_occurrence_id) as varchar(50)) as var_value
FROM condition_occurrence cond
INNER JOIN concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD9CM', 'ICD10CM')
AND DATEDIFF(year, condition_start_date, GETDATE()) BETWEEN 0 AND 5


UNION
SELECT 'if_total_diag' as var_name
	,CAST(COUNT(*) as varchar(50)) as var_value
FROM condition_occurrence

UNION
SELECT 'if_diag_icd_num_act' as var_name
		,CAST(COUNT(*) as varchar(50)) as var_value
FROM condition_occurrence cond
INNER JOIN concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD9CM', 'ICD10CM')


UNION
SELECT 'if_5_diag_icd_num_act' as var_name
		,CAST(COUNT(*) as varchar(50)) as var_value
FROM condition_occurrence cond
INNER JOIN concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD9CM', 'ICD10CM')
AND DATEDIFF(year, condition_start_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_total_uni_diag' as var_name
		,CAST(COUNT(DISTINCT condition_concept_id) as varchar(50)) as var_value
FROM condition_occurrence

UNION
SELECT 'if_uni_diag_icd_num_act' as var_name
		,CAST(COUNT(DISTINCT condition_concept_id) as varchar(50)) as var_value
FROM condition_occurrence cond
INNER JOIN concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD9CM', 'ICD10CM')

UNION
SELECT 'if_5_uni_diag_icd_num_act' as var_name
		,CAST(COUNT(DISTINCT condition_concept_id) as varchar(50)) as var_value
FROM condition_occurrence cond
INNER JOIN concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD9CM', 'ICD10CM')
AND DATEDIFF(year, condition_start_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_pt_diag_snomed_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as varchar(50)) as var_value
FROM condition_occurrence cond
INNER JOIN concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'

UNION
SELECT 'if_5_pt_diag_snomed_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as varchar(50)) as var_value
FROM condition_occurrence cond
INNER JOIN concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'
AND DATEDIFF(year, condition_start_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_ent_diag_snomed_num_act' as var_name
		,CAST(COUNT(DISTINCT visit_occurrence_id) as varchar(50)) as var_value
FROM condition_occurrence cond
INNER JOIN concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'

UNION
SELECT 'if_5_ent_diag_snomed_num_act' as var_name
		,CAST(COUNT(DISTINCT visit_occurrence_id) as varchar(50)) as var_value
FROM condition_occurrence cond
INNER JOIN concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'
AND DATEDIFF(year, condition_start_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_diag_snomed_num_act' as var_name
		,CAST(COUNT(*) as varchar(50)) as var_value
FROM condition_occurrence cond
INNER JOIN concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'

UNION
SELECT 'if_5_diag_snomed_num_act' as var_name
		,CAST(COUNT(*) as varchar(50)) as var_value
FROM condition_occurrence cond
INNER JOIN concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'
AND DATEDIFF(year, condition_start_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_uni_diag_snomed_num_act' as var_name
		,CAST(COUNT(DISTINCT condition_concept_id) as varchar(50)) as var_value
FROM condition_occurrence cond
INNER JOIN concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'

UNION
SELECT 'if_5_uni_diag_snomed_num_act' as var_name
		,CAST(COUNT(DISTINCT condition_concept_id) as varchar(50)) as var_value
FROM condition_occurrence cond
INNER JOIN concept conc
ON cond.condition_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'
AND DATEDIFF(year, condition_start_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_pt_proc_icd_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD10PCS','ICD9Proc')

UNION
SELECT 'if_5_pt_proc_icd_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD10PCS','ICD9Proc')
AND DATEDIFF(year, procedure_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_ent_proc_icd_num_act' as var_name
		,CAST(COUNT(DISTINCT visit_occurrence_id) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD10PCS','ICD9Proc')

UNION
SELECT 'if_5_ent_proc_icd_num_act' as var_name
		,CAST(COUNT(DISTINCT visit_occurrence_id) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD10PCS','ICD9Proc')
AND DATEDIFF(year, procedure_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_total_proc' as var_name
		,CAST(COUNT(*) as varchar(50)) as var_value
FROM procedure_occurrence

UNION
SELECT 'if_proc_icd_num_act' as var_name
		,CAST(COUNT(*) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD10PCS','ICD9Proc')

UNION
SELECT 'if_5_proc_icd_num_act' as var_name
		,CAST(COUNT(*) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD10PCS','ICD9Proc')
AND DATEDIFF(year, procedure_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_total_uni_proc' as var_name
		,CAST(COUNT(distinct procedure_concept_id) as varchar(50)) as var_value
FROM procedure_occurrence

UNION
SELECT 'if_uni_proc_icd_num_act' as var_name
		,CAST(COUNT(distinct procedure_concept_id) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD10PCS','ICD9Proc')

UNION
SELECT 'if_5_uni_proc_icd_num_act' as var_name
		,CAST(COUNT(distinct procedure_concept_id) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('ICD10PCS','ICD9Proc')
AND DATEDIFF(year, procedure_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_pt_proc_cpt_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('HCPCS','CPT4')


UNION
SELECT 'if_5_pt_proc_cpt_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('HCPCS','CPT4')
AND DATEDIFF(year, procedure_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_ent_proc_cpt_num_act' as var_name
		,CAST(COUNT(DISTINCT visit_occurrence_id) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('HCPCS','CPT4')

UNION
SELECT 'if_5_ent_proc_cpt_num_act' as var_name
		,CAST(COUNT(DISTINCT visit_occurrence_id) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('HCPCS','CPT4')
AND DATEDIFF(year, procedure_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_proc_cpt_num_act' as var_name
		,CAST(COUNT(*) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('HCPCS','CPT4')

UNION
SELECT 'if_5_proc_cpt_num_act' as var_name
		,CAST(COUNT(*) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('HCPCS','CPT4')
AND DATEDIFF(year, procedure_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_uni_proc_cpt_num_act' as var_name
		,CAST(COUNT(distinct procedure_concept_id) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('HCPCS','CPT4')

UNION
SELECT 'if_5_uni_proc_cpt_num_act' as var_name
		,CAST(COUNT(distinct procedure_concept_id) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id IN ('HCPCS','CPT4')
AND DATEDIFF(year, procedure_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_pt_proc_snomed_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'

UNION
SELECT 'if_5_pt_proc_snomed_num_act' as var_name
		,CAST(COUNT(DISTINCT person_id) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'
AND DATEDIFF(year, procedure_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_ent_proc_snomed_num_act' as var_name
		,CAST(COUNT(DISTINCT visit_occurrence_id) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'

UNION
SELECT 'if_5_ent_proc_snomed_num_act' as var_name
		,CAST(COUNT(DISTINCT visit_occurrence_id) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'
AND DATEDIFF(year, procedure_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_proc_snomed_num_act' as var_name
	   ,CAST(COUNT(*) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'
AND DATEDIFF(year, procedure_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_5_proc_snomed_num_act' as var_name
	   ,CAST(COUNT(*) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'
AND DATEDIFF(year, procedure_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_uni_proc_snomed_num_act' as var_name
	   ,CAST(COUNT(DISTINCT procedure_concept_id) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'

UNION
SELECT 'if_5_uni_proc_snomed_num_act' as var_name
	   ,CAST(COUNT(DISTINCT procedure_concept_id) as varchar(50)) as var_value
FROM procedure_occurrence proce
INNER JOIN concept conc
ON proce.procedure_concept_id = conc.concept_id
AND conc.vocabulary_id = 'SNOMED'
AND DATEDIFF(year, procedure_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_pt_free_txt_num_act' as var_name
	   ,CAST(COUNT(DISTINCT person_id) as varchar(50)) as var_value
FROM note

UNION
SELECT 'if_5_pt_free_txt_num_act' as var_name
	    ,CAST(COUNT(DISTINCT person_id) as varchar(50)) as var_value
FROM note
WHERE DATEDIFF(year, note_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_ent_free_txt_num_act' as var_name
	  ,CAST(COUNT(DISTINCT visit_occurrence_id) as varchar(50)) as var_value
FROM note

UNION
SELECT 'if_5_ent_free_txt_num_act' as var_name
	  ,CAST(COUNT(DISTINCT visit_occurrence_id) as varchar(50)) as var_value
FROM note
WHERE DATEDIFF(year, note_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_free_txt_nlp_act' as var_name
	   ,using_nlp_solutions as var_value
FROM config

UNION
SELECT 'if_free_txt_nlp_code_act___1' as var_name
	   ,nlp_hbo as var_value
FROM config

UNION
SELECT 'if_free_txt_nlp_code_act___2' as var_name
	   ,nlp_snomed as var_value
FROM config

UNION
SELECT 'if_free_txt_nlp_code_act___3' as var_name
	   ,nlp_loinc as var_value
FROM config

UNION
SELECT 'if_free_txt_nlp_code_act___4' as var_name
	   ,nlp_rxnorm as var_value
FROM config

UNION
SELECT 'if_free_txt_nlp_code_act___5' as var_name
	   ,nlp_mesh as var_value
FROM config

UNION
SELECT 'if_free_txt_nlp_code_act___6' as var_name
	   ,nlp_umls as var_value
FROM config

UNION
SELECT 'if_free_txt_nlp_code_act___7' as var_name
	   ,nlp_icd as var_value
FROM config

UNION
SELECT 'if_free_txt_nlp_code_act___8' as var_name
	  ,nlp_cpt as var_value
FROM config

UNION
SELECT 'if_free_txt_nlp_code_act____99' as var_name
	  ,nlp_other as var_value
FROM config

UNION
SELECT 'if_nlp_sol_other' as var_name
	   ,nlp_other_describe as var_value
FROM config

UNION
SELECT 'if_ent_vital_sign_num_act' as var_name
	   ,'' as var_value

UNION
SELECT 'if_5_ent_vital_sign_num_act' as var_name
	   ,'' as var_value

UNION
SELECT 'if_total_pt_12' as var_name
	   ,CAST(COUNT(distinct person_id) as varchar(50)) as var_value
FROM person
WHERE DATEDIFF(year, birth_datetime, GETDATE()) > 12

UNION
SELECT 'if_pt_smoke_num_act' as var_name
	   ,'' as var_value

UNION
SELECT 'if_5_pt_smoke_num_act' as var_name
	   ,'' as var_value

UNION
SELECT 'if_pt_opioid_num_act' as var_name
	   ,'' as var_value

UNION
SELECT 'if_5_pt_opioid_num_act' as var_name
	   ,'' as var_value

UNION
SELECT 'if_pt_insur_prvder_num_act' as var_name
	   ,'' as var_value

UNION
SELECT 'if_5_pt_insur_prvder_num_act' as var_name
	   ,'' as var_value

UNION
SELECT 'if_pt_insur_status_num_act' as var_name
	   ,'' as var_value

UNION
SELECT 'if_5_pt_insur_status_num_act' as var_name
	   ,'' as var_value

UNION
SELECT 'if_visit_num_act' as var_name
	   ,CAST(COUNT(distinct person_id) as varchar(50)) as var_value
FROM visit_occurrence

UNION
SELECT 'if_5_visit_num_act' as var_name
	   ,CAST(COUNT(distinct person_id) as varchar(50)) as var_value
FROM visit_occurrence
WHERE DATEDIFF(year, visit_start_date, GETDATE()) BETWEEN 0 AND 5

UNION
SELECT 'if_visit_12mon_num_act' as var_name
	   ,'' as var_value
UNION
SELECT 'if_5_visit_12mon_num_act' as var_name
	   ,'' as var_value
UNION
SELECT 'if_visit_5yr_num_act' as var_name
	   ,'' as var_value
UNION
SELECT 'if_5_visit_5yr_num_act' as var_name
	   ,'' as var_value


 ) x
 ON 1=1
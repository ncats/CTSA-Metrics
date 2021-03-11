/*
CTSA common metrics 2021, OMOP MSSQL, version 3
Draft 2021-03-11, rewrite for third revision of output structure 
Robert Miller, Tufts CTSI 
Based on criteria from: 
	https://github.com/ncats/CTSA-Metrics/blob/master/ProposedClicMetricTable.xlsx
	and "Final Informatics Output 2021.xls" (email distributed) 

Known issues:
- hardwires uniq_pt_insurance_value_set to NULL as it is unclear how to best qualify insurance providers as 'harmonized' in OMOP 

Structure:
1-user input
	nlp solutions **Needs to be edited by user (0=no, 1=yes)**
2-create concept sets
3-generate metrics 

*/




-- Are you using an NLP solution at your site? 
with nlp_usage as(
	SELECT -1 as edit_me --[ 0 = No, 1 = Yes ]
)

,vital_concepts as (
	/*
	Spec: At least one vital: height, weight, blood pressure, BMI, or temperature

	 height
		3036277
	 , weight
		3025315
	 , blood pressure
		45876174
	 , BMI
		1002813
		4245997
	 , temperature
		1004059
		4178505

	# concepts exist in both meas and obs

*/

	SELECT conc.*
	FROM CONCEPT_ANCESTOR ca
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
)

,smoking_concepts as (

	SELECT conc.*
	FROM CONCEPT_RELATIONSHIP cr 
	INNER JOIN CONCEPT conc
	ON cr.concept_id_1 IN
	(
		SELECT concept_id
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

)

SELECT
	'nlp_any' as variable_name
	,(SELECT edit_me FROM nlp_usage) as one_year
	,(SELECT edit_me FROM nlp_usage) as five_year

UNION
SELECT 
	'total_encounters' as variable_name
	,(
		SELECT COUNT(*) 
		FROM visit_occurrence
		WHERE visit_start_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(*) 
		FROM visit_occurrence
		WHERE visit_start_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year

UNION 
SELECT 
	'total_patients' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id) 
		FROM visit_occurrence
		WHERE visit_start_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(DISTINCT person_id) 
		FROM visit_occurrence
		WHERE visit_start_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year

UNION 
SELECT 
	'unique_pt_with_age' as variable_name
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM person per
		INNER JOIN visit_occurrence vis
		ON per.birth_datetime IS NOT NULL 
		AND per.person_id = vis.person_id
		AND vis.visit_start_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM person per
		INNER JOIN visit_occurrence vis
		ON per.birth_datetime IS NOT NULL 
		AND per.person_id = vis.person_id
		AND vis.visit_start_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year

UNION 
SELECT 
	'unique_pt_birthdate_in_future' as variable_name
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM person per
		INNER JOIN visit_occurrence vis
		ON DATEPART(year, per.birth_datetime) >= 2021
		AND per.person_id = vis.person_id
		AND vis.visit_start_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM person per
		INNER JOIN visit_occurrence vis
		ON DATEPART(year, per.birth_datetime) >= 2021
		AND per.person_id = vis.person_id
		AND vis.visit_start_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year

UNION 
SELECT 
	'uniq_pt_age_over_120' as variable_name
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM 
		(
			-- " DOD-DOB > 120 "
			SELECT per.person_id 
			FROM person per
			INNER JOIN death dth 
			ON per.person_id = dth.person_id
			AND DATEDIFF(year, per.birth_datetime, dth.death_date) > 120
			-- No DOD, 12/31-2020 - DOB > 120
			UNION
			SELECT person_id 
			FROM person 
			WHERE DATEDIFF(year, birth_datetime, '12-31-2020') > 120
			AND person_id NOT IN (SELECT person_id FROM death)
		) per
		INNER JOIN visit_occurrence vis
		ON per.person_id = vis.person_id
		AND vis.visit_start_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM 
		(
			-- " DOD-DOB > 120 "
			SELECT per.person_id 
			FROM person per
			INNER JOIN death dth 
			ON per.person_id = dth.person_id
			AND DATEDIFF(year, per.birth_datetime, dth.death_date) > 120
			-- No DOD, 12/31-2020 - DOB > 120
			UNION
			SELECT person_id 
			FROM person 
			WHERE DATEDIFF(year, birth_datetime, '12-31-2020') > 120
			AND person_id NOT IN (SELECT person_id FROM death)
		) per
		INNER JOIN visit_occurrence vis
		ON per.person_id = vis.person_id
		AND vis.visit_start_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year

UNION 
SELECT 
	'uniq_pt_with_gender' as variable_name
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM person per
		INNER JOIN visit_occurrence vis
		ON per.gender_concept_id IN (
			8507		-- Male
			,8532		-- Female
			,8570		-- Ambiguous
			,8521		-- Other
		)
		AND per.person_id = vis.person_id
		AND vis.visit_start_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM person per
		INNER JOIN visit_occurrence vis
		ON per.gender_concept_id IN (
			8507		-- Male
			,8532		-- Female
			,8570		-- Ambiguous
			,8521		-- Other
		)
		AND per.person_id = vis.person_id
		AND vis.visit_start_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year

UNION 
SELECT 
	'uniq_pt_loinc' as variable_name
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM (
			SELECT person_id
			FROM measurement meas
			INNER JOIN concept conc
			ON conc.vocabulary_id = 'LOINC'
			AND meas.measurement_concept_id = conc.concept_id
			AND measurement_date BETWEEN '01-01-2020' AND '12-31-2020'

			UNION 
			SELECT person_id
			FROM observation obs
			INNER JOIN concept conc
			ON conc.vocabulary_id = 'LOINC'
			AND obs.observation_concept_id = conc.concept_id
			AND observation_date BETWEEN '01-01-2020' AND '12-31-2020'
		) per
	) as one_year
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM (
			SELECT person_id
			FROM measurement meas
			INNER JOIN concept conc
			ON conc.vocabulary_id = 'LOINC'
			AND meas.measurement_concept_id = conc.concept_id
			AND measurement_date BETWEEN '01-01-2016' AND '12-31-2020'

			UNION 
			SELECT person_id
			FROM observation obs
			INNER JOIN concept conc
			ON conc.vocabulary_id = 'LOINC'
			AND obs.observation_concept_id = conc.concept_id
			AND observation_date BETWEEN '01-01-2016' AND '12-31-2020'
		) per
	) as five_year


UNION 
SELECT 
	'uniq_enc_med_rxnorm' as variable_name
	,(
		SELECT COUNT(DISTINCT drug.visit_occurrence_id) 
		FROM drug_exposure drug
		INNER JOIN concept conc
		ON conc.vocabulary_id in ('RxNorm', 'NDC')
		AND drug.drug_concept_id = conc.concept_id
		AND drug_exposure_start_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(DISTINCT drug.visit_occurrence_id) 
		FROM drug_exposure drug
		INNER JOIN concept conc
		ON conc.vocabulary_id in ('RxNorm', 'NDC')
		AND drug.drug_concept_id = conc.concept_id
		AND drug_exposure_start_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year

UNION 
SELECT 
	'uniq_pt_med_rxnorm' as variable_name
	,(
		SELECT COUNT(DISTINCT drug.person_id) 
		FROM drug_exposure drug
		INNER JOIN concept conc
		ON conc.vocabulary_id in ('RxNorm', 'NDC')
		AND drug.drug_concept_id = conc.concept_id
		AND drug_exposure_start_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(DISTINCT drug.person_id) 
		FROM drug_exposure drug
		INNER JOIN concept conc
		ON conc.vocabulary_id in ('RxNorm', 'NDC')
		AND drug.drug_concept_id = conc.concept_id
		AND drug_exposure_start_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year

UNION 
SELECT 
	'uniq_pt_icd_dx' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM condition_occurrence
		WHERE condition_concept_id IN 
		(
				SELECT cr.concept_id_2
				FROM concept c1
				INNER JOIN concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('ICD9CM', 'ICD10CM')
		)
		AND condition_start_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM condition_occurrence
		WHERE condition_concept_id IN 
		(
				SELECT cr.concept_id_2
				FROM concept c1
				INNER JOIN concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('ICD9CM', 'ICD10CM')
		)
		AND condition_start_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year

UNION 
SELECT 
	'uniq_enc_icd_dx' as variable_name
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM condition_occurrence
		WHERE condition_concept_id IN 
		(
				SELECT cr.concept_id_2
				FROM concept c1
				INNER JOIN concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('ICD9CM', 'ICD10CM')
		)
		AND condition_start_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM condition_occurrence
		WHERE condition_concept_id IN 
		(
				SELECT cr.concept_id_2
				FROM concept c1
				INNER JOIN concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('ICD9CM', 'ICD10CM')
		)
		AND condition_start_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year

UNION 
SELECT 
	'uniq_pt_snomed_dx' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM condition_occurrence
		WHERE condition_concept_id IN 
		(
				SELECT cr.concept_id_2
				FROM concept c1
				INNER JOIN concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id = 'SNOMED'
		)
		AND condition_start_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM condition_occurrence
		WHERE condition_concept_id IN 
		(
				SELECT cr.concept_id_2
				FROM concept c1
				INNER JOIN concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id = 'SNOMED'
		)
		AND condition_start_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year

UNION 
SELECT 
	'uniq_enc_snomed_dx' as variable_name
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM condition_occurrence
		WHERE condition_concept_id IN 
		(
				SELECT cr.concept_id_2
				FROM concept c1
				INNER JOIN concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id = 'SNOMED'
		)
		AND condition_start_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM condition_occurrence
		WHERE condition_concept_id IN 
		(
				SELECT cr.concept_id_2
				FROM concept c1
				INNER JOIN concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id = 'SNOMED'
		)
		AND condition_start_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year


UNION 
SELECT 
	'uniq_pt_icd_proc' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				FROM concept c1
				INNER JOIN concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('ICD10PCS', 'ICD9Proc')
		)
		AND procedure_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				FROM concept c1
				INNER JOIN concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('ICD10PCS', 'ICD9Proc')
		)
		AND procedure_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year

UNION 
SELECT 
	'uniq_enc_icd_proc' as variable_name
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				FROM concept c1
				INNER JOIN concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('ICD10PCS', 'ICD9Proc')
		)
		AND procedure_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				FROM concept c1
				INNER JOIN concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('ICD10PCS', 'ICD9Proc')
		)
		AND procedure_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year



UNION 
SELECT 
	'uniq_pt_cpt' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				FROM concept c1
				INNER JOIN concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('CPT4', 'HCPCS')
		)
		AND procedure_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				FROM concept c1
				INNER JOIN concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('CPT4', 'HCPCS')
		)
		AND procedure_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year

UNION 
SELECT 
	'uniq_enc_cpt' as variable_name
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				FROM concept c1
				INNER JOIN concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('CPT4', 'HCPCS')
		)
		AND procedure_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				FROM concept c1
				INNER JOIN concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('CPT4', 'HCPCS')
		)
		AND procedure_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year


UNION 
SELECT 
	'uniq_pt_snomed_proc' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				FROM concept c1
				INNER JOIN concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id = 'SNOMED'
		)
		AND procedure_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				FROM concept c1
				INNER JOIN concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id = 'SNOMED'
		)
		AND procedure_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year

UNION 
SELECT 
	'uniq_enc_snomed_proc' as variable_name
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				FROM concept c1
				INNER JOIN concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id = 'SNOMED'
		)
		AND procedure_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				FROM concept c1
				INNER JOIN concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id = 'SNOMED'
		)
		AND procedure_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year


UNION 
SELECT 
	'uniq_pt_note' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM note
		WHERE note_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM note
		WHERE note_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year

UNION 
SELECT 
	'uniq_enc_note' as variable_name
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM note
		WHERE note_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM note
		WHERE note_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year



/*
Spec: At least one vital: height, weight, blood pressure, BMI, or temperature

 height
	3036277
 , weight
	3025315
 , blood pressure
	45876174
 , BMI
	1002813
	4245997
 , temperature
	1004059
	4178505
*/
UNION 
SELECT 
	'uniq_pt_vital_sign' as variable_name
	,(
		SELECT COUNT(distinct person_id) 
		FROM
		(
			SELECT person_id 
			FROM MEASUREMENT
			WHERE measurement_concept_id IN 
			(
				SELECT concept_id
				FROM vital_concepts
				WHERE domain_id = 'Measurement'
			)
			AND measurement_date BETWEEN '01-01-2020' AND '12-31-2020'
			UNION 
			SELECT person_id 
			FROM OBSERVATION
			WHERE observation_concept_id IN 
			(
				SELECT concept_id
				FROM vital_concepts
				WHERE domain_id = 'Observation'
			)
			AND observation_date BETWEEN '01-01-2020' AND '12-31-2020'
		) x
	) as one_year
	,(
		SELECT COUNT(distinct person_id) 
		FROM
		(
			SELECT person_id 
			FROM MEASUREMENT
			WHERE measurement_concept_id IN 
			(
				SELECT concept_id
				FROM vital_concepts
				WHERE domain_id = 'Measurement'
			)
			AND measurement_date BETWEEN '01-01-2016' AND '12-31-2020'
			UNION 
			SELECT person_id 
			FROM OBSERVATION
			WHERE observation_concept_id IN 
			(
				SELECT concept_id
				FROM vital_concepts
				WHERE domain_id = 'Observation'
			)
			AND observation_date BETWEEN '01-01-2016' AND '12-31-2020'
		) x
	) as five_year


/*
Smoking Status Codes: Z87.891, F17.20, F17.200, F17.201, F17.203, F17.208, F17.209, F17.21, F17.210, F17.211, F17.213, F17.218, F17.219
*/
UNION 
SELECT 
	'uniq_pt_smoking' as variable_name
	,(
		SELECT COUNT(distinct person_id) 
		FROM
		(
			SELECT person_id 
			FROM CONDITION_OCCURRENCE
			WHERE condition_concept_id IN 
			(
				SELECT concept_id
				FROM smoking_concepts
				WHERE domain_id = 'Condition'
			)
			AND condition_start_date BETWEEN '01-01-2020' AND '12-31-2020'
			UNION 
			SELECT person_id 
			FROM OBSERVATION
			WHERE observation_concept_id IN 
			(
				SELECT concept_id
				FROM smoking_concepts
				WHERE domain_id = 'Observation'
			)
			AND observation_date BETWEEN '01-01-2020' AND '12-31-2020'
		) x
	) as one_year
	,(
		SELECT COUNT(distinct person_id) 
		FROM
		(
			SELECT person_id 
			FROM CONDITION_OCCURRENCE
			WHERE condition_concept_id IN 
			(
				SELECT concept_id
				FROM smoking_concepts
				WHERE domain_id = 'Condition'
			)
			AND condition_start_date BETWEEN '01-01-2016' AND '12-31-2020'
			UNION 
			SELECT person_id 
			FROM OBSERVATION
			WHERE observation_concept_id IN 
			(
				SELECT concept_id
				FROM smoking_concepts
				WHERE domain_id = 'Observation'
			)
			AND observation_date BETWEEN '01-01-2016' AND '12-31-2020'
		) x
	) as five_year



UNION 
SELECT 
	'uniq_pt_opioid' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM
		(
			-- " SNOMED -14784000 and its descendants "
			SELECT person_id
			FROM condition_occurrence
			WHERE condition_concept_id IN 
			(
				SELECT descendant_concept_id
				FROM concept_ancestor
				WHERE ancestor_concept_id = 4032799 --Opioid-induced organic mental disorder
			) 
			AND condition_start_date BETWEEN '01-01-2020' AND '12-31-2020'
			UNION 
			--"RxNorm (methadone {6813} and descendants, buprenorphine {1819} and descendant TTYs) "
			SELECT person_id
			FROM drug_exposure
			WHERE drug_concept_id IN 
			(
				SELECT descendant_concept_id
				FROM concept_ancestor
				WHERE ancestor_concept_id IN (
					1103640		-- methadone (6813 is the concept code)
					,1133201	-- buprenorphine (1819 is the concept code)
				)
			) 
			AND drug_exposure_start_date BETWEEN '01-01-2020' AND '12-31-2020'
		) x
	) as one_year
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM
		(
			-- " SNOMED -14784000 and its descendants "
			SELECT person_id
			FROM condition_occurrence
			WHERE condition_concept_id IN 
			(
				SELECT descendant_concept_id
				FROM concept_ancestor
				WHERE ancestor_concept_id = 4032799 --Opioid-induced organic mental disorder
			) 
			AND condition_start_date BETWEEN '01-01-2016' AND '12-31-2020'
			UNION 
			--"RxNorm (methadone {6813} and descendants, buprenorphine {1819} and descendant TTYs) "
			SELECT person_id
			FROM drug_exposure
			WHERE drug_concept_id IN 
			(
				SELECT descendant_concept_id
				FROM concept_ancestor
				WHERE ancestor_concept_id IN (
					1103640		-- methadone (6813 is the concept code)
					,1133201	-- buprenorphine (1819 is the concept code)
				)
			) 
			AND drug_exposure_start_date BETWEEN '01-01-2016' AND '12-31-2020'
		) x
	) as five_year

-- TODO: Better way to calculate the date range overlap?

UNION 
SELECT 
	'uniq_pt_any_insurance_value' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM payer_plan_period
		WHERE payer_plan_period_start_date BETWEEN '01-01-2020' AND '12-31-2020'
		OR payer_plan_period_end_date BETWEEN '01-01-2020' AND '12-31-2020'
	) as one_year
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM payer_plan_period
		WHERE payer_plan_period_start_date BETWEEN '01-01-2016' AND '12-31-2020'
		OR payer_plan_period_end_date BETWEEN '01-01-2016' AND '12-31-2020'
	) as five_year

-- NULL as NA. Best approach TBD for OMOP 
UNION 
SELECT 
	'uniq_pt_insurance_value_set' as variable_name
	,NULL as one_year
	,NULL as five_year

;


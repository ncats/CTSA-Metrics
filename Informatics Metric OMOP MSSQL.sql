
/*
CTSA common metrics 2021
OMOP MSSQL
Draft 2021/02/22, v2 rewrite for new output structure 
Robert Miller, Tufts CTSI 

Based on criteria from: 
https://github.com/ncats/CTSA-Metrics/blob/master/ProposedClicMetricTable.xlsx
and "Informatics 2.4.21.docx" (email distributed) 

Known issues:
-missing smoking concept list
-missing vital sign concept list (OMOP doesn't have this table)
-unclear approach to consider insurance dates overlapping (within 1yr, 5yr)
-event name ('2020_arm_1') now missing from criteria (removed?)
-nlp solutions now missing from criteria (removed?)

*/


SELECT 
	'total_encounters' as x
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
	'total_patients' as x
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
	'unique_pt_with_age' as x
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
	'unique_pt_birthdate_in_future' as x
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
	'uniq_pt_age_over_120' as x
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
	'uniq_pt_with_gender' as x
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
	'uniq_pt_loinc' as x
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
	'uniq_enc_med_rxnorm' as x
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
	'uniq_pt_med_rxnorm' as x
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
	'uniq_pt_icd_dx' as x
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
	'uniq_enc_icd_dx' as x
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
	'uniq_pt_snomed_dx' as x
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
	'uniq_enc_snomed_dx' as x
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
	'uniq_pt_icd_proc' as x
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
	'uniq_enc_icd_proc' as x
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
	'uniq_pt_cpt' as x
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
	'uniq_enc_cpt' as x
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
	'uniq_pt_snomed_proc' as x
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
	'uniq_enc_snomed_proc' as x
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
	'uniq_pt_note' as x
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
	'uniq_enc_note' as x
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

-- There isn't a vital sign table in OMOP 
-- Either need list of concepts to search for or leave null as below 
UNION 
SELECT 
	'uniq_pt_vital_sign' as x
	,-1 as one_year
	,-1 as five_year


-- Either need list of concepts to search for or leave null as below 
UNION 
SELECT 
	'uniq_pt_smoking' as x
	,-1 as one_year
	,-1 as five_year





UNION 
SELECT 
	'uniq_pt_opioid' as x
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
	'uniq_pt_insurance_value_set' as x
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


/*
 Excluded as it sounded like we are getting rid of the following

	uniq_pt_clin_vis_anytime: 
		unique patients with at least one clinical visit cpt code from list/encounter type	
	uniq_pt_clin_vis_timeframe:
		unique patients with at least one clinical visit cpt code from list/encounter type in time frame	

*/

ORDER BY x
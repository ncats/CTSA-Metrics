/*

CTSA Common Metrics 2021, OMOP BigQuery

This code is a modification of the OMOP MSSQL V3 code created by Robert Miller, Tufts CTSI
His attribution included in comments below
Huge thanks to Rob

*/

-- Data Model: OMOP 5.X
-- Database Google BigQuery
--
-- ********************************************************************************************
-- TO EXECUTE: 
--   1. Replace [ADD YOUR SCHEMA PATH HERE] with the full DB.SCHEMA for your GBQ instance
--   2. Replace EDIT_ME with either 0 or 1 for nlp_usage
--   3. Check table names for upper/lower case match (column names are not case sensitive)
-- ********************************************************************************************
-- Version 2021
-- Updated 10 May 2021
-- BigQuery MOdification by Michael Kahn University of Colorado (Michael.Kahn@cuanschutz.edu)
-- This code is a modification of the OMOP MSSQL V3 code created by Robert Miller, Tufts CTSI
-- His comments included below
-- Huge thanks to Rob
--
--
-- Version 2020
-- Updated 06/25/2020
-- Modified by Michael Kahn University of Colorado (Michael.Kahn@cuanschutz.edu)
-- Version 2020 modifications:
--   - New temp table (DT_Interval) to implement date restriction in one place
--   - Restricted all metrics to data collected on patients with visits between 1/1/2019-12/31/2019
--         - Valid PERSON_IDs pulled FROM visit_occurrence using visit_start_date rather than PERSON
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
--     

/* From Robert Miller's MSSQL code


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
	nlp solutions **Needs to be edited by user (0=no, 1=yes, NULL = unknown)**
2-create concept sets
3-generate metrics 

*/

-- Are you using an NLP solution at your site? 
with nlp_usage as(
	SELECT EDIT_ME as edit_me --[ 0 = No, 1 = Yes, NULL = unknown]
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
	FROM [ADD YOUR SCHEMA HERE].concept_ancestor ca
	INNER JOIN [ADD YOUR SCHEMA HERE].concept conc
  ON ca.descendant_concept_id = conc.concept_id
  WHERE ancestor_concept_id IN
	(
		3036277
		,3025315
		,45876174
		,1002813
		,4245997
		,1004059
		,4178505
	)
	AND conc.standard_concept = 'S'
)

,smoking_concepts as (

	SELECT conc.*
	FROM [ADD YOUR SCHEMA HERE].concept_relationship cr 
	INNER JOIN [ADD YOUR SCHEMA HERE].concept conc
	ON cr.concept_id_2 = conc.concept_id
  WHERE cr.concept_id_1 IN
	(
		SELECT concept_id
		FROM [ADD YOUR SCHEMA HERE].concept
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
	AND conc.standard_concept = 'S'

)

/*
  Variable: data_model
  Acceptable values:  1=PCORNet, 2=OMOP, 3=TriNetX, 4=i2b2/ACT
*/
SELECT 
	'data_model' as variable_name
	,(SELECT 2 as one_year) as one_year -- 2 = OMOP
	,(SELECT 2 as five_year) as five_year -- 2 = OMOP
UNION DISTINCT
SELECT
	'nlp_any' as variable_name
	,(SELECT edit_me FROM nlp_usage) as one_year
	,(SELECT edit_me FROM nlp_usage) as five_year

UNION DISTINCT
SELECT 
	'total_encounters' as variable_name
	,(
		SELECT COUNT(*) 
		FROM [ADD YOUR SCHEMA HERE].visit_occurrence
		WHERE visit_start_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(*) 
		FROM [ADD YOUR SCHEMA HERE].visit_occurrence
		WHERE visit_start_date BETWEEN cast ('2016-01-01' as DATE)  AND cast('2020-12-31' as DATE)
	) as five_year

UNION DISTINCT 
SELECT 
	'total_patients' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id) 
		FROM [ADD YOUR SCHEMA HERE].visit_occurrence
		WHERE visit_start_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(DISTINCT person_id) 
		FROM [ADD YOUR SCHEMA HERE].visit_occurrence
		WHERE visit_start_date BETWEEN cast ('2016-01-01' as DATE)  AND cast('2020-12-31' as DATE)
	) as five_year
UNION DISTINCT 
SELECT 
	'total_pt_gt_12' as variable_name
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM  [ADD YOUR SCHEMA HERE].person per
		INNER JOIN [ADD YOUR SCHEMA HERE].visit_occurrence vis
		ON per.birth_datetime IS NOT NULL 
		AND per.person_id = vis.person_id
		AND vis.visit_start_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
		AND DATE_DIFF(per.birth_datetime, vis.visit_start_date, year) > 12 
	) as one_year
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM  [ADD YOUR SCHEMA HERE].person per
		INNER JOIN [ADD YOUR SCHEMA HERE].visit_occurrence vis
		ON per.birth_datetime IS NOT NULL 
		AND per.person_id = vis.person_id
		AND vis.visit_start_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
		AND DATE_DIFF(per.birth_datetime, vis.visit_start_date, year) > 12 
	) as five_year


UNION DISTINCT 
SELECT 
	'uniq_pt_with_age' as variable_name
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM  [ADD YOUR SCHEMA HERE].person per
		INNER JOIN [ADD YOUR SCHEMA HERE].visit_occurrence vis
		ON per.birth_datetime IS NOT NULL 
		AND per.person_id = vis.person_id
		AND vis.visit_start_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM  [ADD YOUR SCHEMA HERE].person per
		INNER JOIN [ADD YOUR SCHEMA HERE].visit_occurrence vis
		ON per.birth_datetime IS NOT NULL 
		AND per.person_id = vis.person_id
		AND vis.visit_start_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as five_year

UNION DISTINCT 
SELECT 
	'uniq_pt_birthdate_in_future' as variable_name
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM  [ADD YOUR SCHEMA HERE].person per
		INNER JOIN [ADD YOUR SCHEMA HERE].visit_occurrence vis
		ON EXTRACT(year FROM per.birth_datetime) > 2021
		AND per.person_id = vis.person_id
		AND vis.visit_start_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM  [ADD YOUR SCHEMA HERE].person per
		INNER JOIN [ADD YOUR SCHEMA HERE].visit_occurrence vis
		ON EXTRACT(year FROM per.birth_datetime) > 2021
		AND per.person_id = vis.person_id
		AND vis.visit_start_date BETWEEN '2016-01-01' AND cast('2020-12-31' as DATE)
	) as five_year

UNION DISTINCT 
SELECT 
	'uniq_pt_age_over_120' as variable_name
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM 
		(
			-- " DOD-DOB > 120 "
			SELECT per.person_id 
			FROM  [ADD YOUR SCHEMA HERE].person per
			INNER JOIN  [ADD YOUR SCHEMA HERE].death dth 
			ON per.person_id = dth.person_id
			AND DATE_DIFF(per.birth_datetime, dth.death_date,year) > 120
			-- No DOD, 12/31-2020 - DOB > 120
			UNION DISTINCT
			SELECT person_id 
			FROM  [ADD YOUR SCHEMA HERE].person 
			WHERE DATE_DIFF(birth_datetime, cast('2020-12-31' as DATE),year) > 120
			AND person_id NOT IN (SELECT person_id FROM  [ADD YOUR SCHEMA HERE].death)
		) per
		INNER JOIN [ADD YOUR SCHEMA HERE].visit_occurrence vis
		ON per.person_id = vis.person_id
		AND vis.visit_start_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM 
		(
			-- " DOD-DOB > 120 "
			SELECT per.person_id 
			FROM  [ADD YOUR SCHEMA HERE].person per
			INNER JOIN  [ADD YOUR SCHEMA HERE].death dth 
			ON per.person_id = dth.person_id
			AND DATE_DIFF(per.birth_datetime, dth.death_date, year) > 120
			-- No DOD, 12/31-2020 - DOB > 120
			UNION DISTINCT
			SELECT person_id 
			FROM  [ADD YOUR SCHEMA HERE].person 
			WHERE DATE_DIFF(birth_datetime, cast('2020-12-31' as DATE),year) > 120
			AND person_id NOT IN (SELECT person_id FROM  [ADD YOUR SCHEMA HERE].death)
		) per
		INNER JOIN [ADD YOUR SCHEMA HERE].visit_occurrence vis
		ON per.person_id = vis.person_id
		AND vis.visit_start_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as five_year

UNION DISTINCT 
SELECT 
	'uniq_pt_with_gender' as variable_name
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM  [ADD YOUR SCHEMA HERE].person per
		INNER JOIN [ADD YOUR SCHEMA HERE].visit_occurrence vis
		ON per.gender_concept_id IN (
			8507		-- Male
			,8532		-- Female
			,8570		-- Ambiguous
			,8521		-- Other
		)
		AND per.person_id = vis.person_id
		AND vis.visit_start_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM  [ADD YOUR SCHEMA HERE].person per
		INNER JOIN [ADD YOUR SCHEMA HERE].visit_occurrence vis
		ON per.person_id = vis.person_id
    WHERE per.gender_concept_id IN (
			8507		-- Male
			,8532		-- Female
			,8570		-- Ambiguous
			,8521		-- Other
		)
		AND vis.visit_start_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as five_year

UNION DISTINCT 
SELECT 
	'uniq_pt_loinc' as variable_name
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM (
			SELECT person_id
			FROM [ADD YOUR SCHEMA HERE].measurement meas
			INNER JOIN [ADD YOUR SCHEMA HERE].concept conc
			ON conc.vocabulary_id = 'LOINC'
			AND meas.measurement_concept_id = conc.concept_id
			AND measurement_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)

			UNION DISTINCT 
			SELECT person_id
			FROM [ADD YOUR SCHEMA HERE].observation  obs
			INNER JOIN [ADD YOUR SCHEMA HERE].concept conc
			ON conc.vocabulary_id = 'LOINC'
			AND obs.observation_concept_id = conc.concept_id
			AND observation_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
		) per
	) as one_year
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM (
			SELECT person_id
			FROM [ADD YOUR SCHEMA HERE].measurement meas
			INNER JOIN [ADD YOUR SCHEMA HERE].concept conc
			ON conc.vocabulary_id = 'LOINC'
			AND meas.measurement_concept_id = conc.concept_id
			AND measurement_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)

			UNION DISTINCT 
			SELECT person_id
			FROM [ADD YOUR SCHEMA HERE].observation obs
			INNER JOIN [ADD YOUR SCHEMA HERE].concept conc
			ON conc.vocabulary_id = 'LOINC'
			AND obs.observation_concept_id = conc.concept_id
			AND observation_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
		) per
	) as five_year

UNION DISTINCT 
SELECT 
	'uniq_enc_loinc' as variable_name
	,(
		SELECT COUNT(DISTINCT per.visit_occurrence_id) 
		FROM (
			SELECT visit_occurrence_id
			FROM [ADD YOUR SCHEMA HERE].measurement meas
			INNER JOIN [ADD YOUR SCHEMA HERE].concept conc
			ON conc.vocabulary_id = 'LOINC'
			AND meas.measurement_concept_id = conc.concept_id
			AND measurement_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)

			UNION DISTINCT 
			SELECT visit_occurrence_id
			FROM [ADD YOUR SCHEMA HERE].observation obs
			INNER JOIN [ADD YOUR SCHEMA HERE].concept conc
			ON conc.vocabulary_id = 'LOINC'
			AND obs.observation_concept_id = conc.concept_id
			AND observation_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
		) per
	) as one_year
	,(
		SELECT COUNT(DISTINCT per.visit_occurrence_id) 
		FROM (
			SELECT visit_occurrence_id
			FROM [ADD YOUR SCHEMA HERE].measurement meas
			INNER JOIN [ADD YOUR SCHEMA HERE].concept conc
			ON conc.vocabulary_id = 'LOINC'
			AND meas.measurement_concept_id = conc.concept_id
			AND measurement_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)

			UNION DISTINCT 
			SELECT visit_occurrence_id
			FROM [ADD YOUR SCHEMA HERE].observation obs
			INNER JOIN [ADD YOUR SCHEMA HERE].concept conc
			ON conc.vocabulary_id = 'LOINC'
			AND obs.observation_concept_id = conc.concept_id
			AND observation_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
		) per
	) as five_year	


UNION DISTINCT 
SELECT 
	'uniq_enc_med_rxnorm' as variable_name
	,(
		SELECT COUNT(DISTINCT drug.visit_occurrence_id) 
		FROM  [ADD YOUR SCHEMA HERE].drug_exposure drug
		INNER JOIN [ADD YOUR SCHEMA HERE].concept conc
		ON drug.drug_concept_id = conc.concept_id
		WHERE conc.vocabulary_id in ('RxNorm', 'NDC')
    AND drug_exposure_start_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(DISTINCT drug.visit_occurrence_id) 
		FROM  [ADD YOUR SCHEMA HERE].drug_exposure drug
		INNER JOIN [ADD YOUR SCHEMA HERE].concept conc
		ON drug.drug_concept_id = conc.concept_id
		WHERE conc.vocabulary_id in ('RxNorm', 'NDC')
    AND drug_exposure_start_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as five_year

UNION DISTINCT 
SELECT 
	'uniq_pt_med_rxnorm' as variable_name
	,(
		SELECT COUNT(DISTINCT drug.person_id) 
		FROM  [ADD YOUR SCHEMA HERE].drug_exposure drug
		INNER JOIN [ADD YOUR SCHEMA HERE].concept conc
    ON drug.drug_concept_id = conc.concept_id
    WHERE conc.vocabulary_id in ('RxNorm', 'NDC')
		AND drug_exposure_start_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(DISTINCT drug.person_id) 
		FROM  [ADD YOUR SCHEMA HERE].drug_exposure drug
		INNER JOIN [ADD YOUR SCHEMA HERE].concept conc
    ON drug.drug_concept_id = conc.concept_id
    WHERE conc.vocabulary_id in ('RxNorm', 'NDC')
		AND drug_exposure_start_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as five_year

UNION DISTINCT 
SELECT 
	'uniq_pt_icd_dx' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM [ADD YOUR SCHEMA HERE].condition_occurrence
		WHERE condition_concept_id IN 
		(
				SELECT cr.concept_id_2
				from [ADD YOUR SCHEMA HERE].concept c1
				INNER JOIN [ADD YOUR SCHEMA HERE].concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				WHERE relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('ICD9CM', 'ICD10CM')
		)
		AND condition_start_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM [ADD YOUR SCHEMA HERE].condition_occurrence
		WHERE condition_concept_id IN 
		(
				SELECT cr.concept_id_2
				from [ADD YOUR SCHEMA HERE].concept c1
				INNER JOIN [ADD YOUR SCHEMA HERE].concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				WHERE relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('ICD9CM', 'ICD10CM')
		)
		AND condition_start_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as five_year

UNION DISTINCT 
SELECT 
	'uniq_enc_icd_dx' as variable_name
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM [ADD YOUR SCHEMA HERE].condition_occurrence
		WHERE condition_concept_id IN 
		(
				SELECT cr.concept_id_2
				from [ADD YOUR SCHEMA HERE].concept c1
				INNER JOIN [ADD YOUR SCHEMA HERE].concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				WHERE relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('ICD9CM', 'ICD10CM')
		)
		AND condition_start_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM [ADD YOUR SCHEMA HERE].condition_occurrence
		WHERE condition_concept_id IN 
		(
				SELECT cr.concept_id_2
				from [ADD YOUR SCHEMA HERE].concept c1
				INNER JOIN [ADD YOUR SCHEMA HERE].concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				WHERE relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('ICD9CM', 'ICD10CM')
		)
		AND condition_start_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as five_year

UNION DISTINCT 
SELECT 
	'uniq_pt_snomed_dx' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM [ADD YOUR SCHEMA HERE].condition_occurrence
		WHERE condition_concept_id IN 
		(
				SELECT cr.concept_id_2
				from [ADD YOUR SCHEMA HERE].concept c1
				INNER JOIN [ADD YOUR SCHEMA HERE].concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				WHERE relationship_id = 'Maps to'
				AND c1.vocabulary_id = 'SNOMED'
		)
		AND condition_start_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM [ADD YOUR SCHEMA HERE].condition_occurrence
		WHERE condition_concept_id IN 
		(
				SELECT cr.concept_id_2
				from [ADD YOUR SCHEMA HERE].concept c1
				INNER JOIN [ADD YOUR SCHEMA HERE].concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				WHERE relationship_id = 'Maps to'
				AND c1.vocabulary_id = 'SNOMED'
		)
		AND condition_start_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as five_year

UNION DISTINCT 
SELECT 
	'uniq_enc_snomed_dx' as variable_name
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM [ADD YOUR SCHEMA HERE].condition_occurrence
		WHERE condition_concept_id IN 
		(
				SELECT cr.concept_id_2
				from [ADD YOUR SCHEMA HERE].concept c1
				INNER JOIN [ADD YOUR SCHEMA HERE].concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id = 'SNOMED'
		)
		AND condition_start_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM [ADD YOUR SCHEMA HERE].condition_occurrence
		WHERE condition_concept_id IN 
		(
				SELECT cr.concept_id_2
				from [ADD YOUR SCHEMA HERE].concept c1
				INNER JOIN [ADD YOUR SCHEMA HERE].concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id = 'SNOMED'
		)
		AND condition_start_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as five_year


UNION DISTINCT 
SELECT 
	'uniq_pt_icd_proc' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM  [ADD YOUR SCHEMA HERE].procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				from [ADD YOUR SCHEMA HERE].concept c1
				INNER JOIN [ADD YOUR SCHEMA HERE].concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				WHERE relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('ICD10PCS', 'ICD9Proc')
		)
		AND procedure_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM  [ADD YOUR SCHEMA HERE].procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				from [ADD YOUR SCHEMA HERE].concept c1
				INNER JOIN [ADD YOUR SCHEMA HERE].concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				WHERE relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('ICD10PCS', 'ICD9Proc')
		)
		AND procedure_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as five_year

UNION DISTINCT 
SELECT 
	'uniq_enc_icd_proc' as variable_name
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM  [ADD YOUR SCHEMA HERE].procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				from [ADD YOUR SCHEMA HERE].concept c1
				INNER JOIN [ADD YOUR SCHEMA HERE].concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				WHERE relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('ICD10PCS', 'ICD9Proc')
		)
		AND procedure_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM  [ADD YOUR SCHEMA HERE].procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				from [ADD YOUR SCHEMA HERE].concept c1
				INNER JOIN [ADD YOUR SCHEMA HERE].concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				WHERE relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('ICD10PCS', 'ICD9Proc')
		)
		AND procedure_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as five_year



UNION DISTINCT 
SELECT 
	'uniq_pt_cpt' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM  [ADD YOUR SCHEMA HERE].procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				from [ADD YOUR SCHEMA HERE].concept c1
				INNER JOIN [ADD YOUR SCHEMA HERE].concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				WHERE relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('CPT4', 'HCPCS')
		)
		AND procedure_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM  [ADD YOUR SCHEMA HERE].procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				from [ADD YOUR SCHEMA HERE].concept c1
				INNER JOIN [ADD YOUR SCHEMA HERE].concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				WHERE relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('CPT4', 'HCPCS')
		)
		AND procedure_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as five_year

UNION DISTINCT 
SELECT 
	'uniq_enc_cpt' as variable_name
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM  [ADD YOUR SCHEMA HERE].procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				from [ADD YOUR SCHEMA HERE].concept c1
				INNER JOIN [ADD YOUR SCHEMA HERE].concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				WHERE relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('CPT4', 'HCPCS')
		)
		AND procedure_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM  [ADD YOUR SCHEMA HERE].procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				from [ADD YOUR SCHEMA HERE].concept c1
				INNER JOIN [ADD YOUR SCHEMA HERE].concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				WHERE relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('CPT4', 'HCPCS')
		)
		AND procedure_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as five_year


UNION DISTINCT 
SELECT 
	'uniq_pt_snomed_proc' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM  [ADD YOUR SCHEMA HERE].procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				from [ADD YOUR SCHEMA HERE].concept c1
				INNER JOIN [ADD YOUR SCHEMA HERE].concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id = 'SNOMED'
		)
		AND procedure_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM  [ADD YOUR SCHEMA HERE].procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				from [ADD YOUR SCHEMA HERE].concept c1
				INNER JOIN [ADD YOUR SCHEMA HERE].concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id = 'SNOMED'
		)
		AND procedure_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as five_year

UNION DISTINCT 
SELECT 
	'uniq_enc_snomed_proc' as variable_name
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM  [ADD YOUR SCHEMA HERE].procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				from [ADD YOUR SCHEMA HERE].concept c1
				INNER JOIN [ADD YOUR SCHEMA HERE].concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id = 'SNOMED'
		)
		AND procedure_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM  [ADD YOUR SCHEMA HERE].procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				from [ADD YOUR SCHEMA HERE].concept c1
				INNER JOIN [ADD YOUR SCHEMA HERE].concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id = 'SNOMED'
		)
		AND procedure_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as five_year


UNION DISTINCT 
SELECT 
	'uniq_pt_note' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM  [ADD YOUR SCHEMA HERE].note
		WHERE note_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM  [ADD YOUR SCHEMA HERE].note
		WHERE note_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as five_year

UNION DISTINCT 
SELECT 
	'uniq_enc_note' as variable_name
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM  [ADD YOUR SCHEMA HERE].note
		WHERE note_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(DISTINCT visit_occurrence_id)
		FROM  [ADD YOUR SCHEMA HERE].note
		WHERE note_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
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


UNION DISTINCT 
SELECT 
	'uniq_enc_vital_sign' as variable_name
	,(
		SELECT COUNT(distinct visit_occurrence_id) 
		FROM
		(
			SELECT visit_occurrence_id 
			FROM [ADD YOUR SCHEMA HERE].measurement
			WHERE measurement_concept_id IN 
			(
				SELECT concept_id
				FROM vital_concepts
				WHERE domain_id = 'Measurement'
			)
			AND measurement_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
			UNION DISTINCT 
			SELECT visit_occurrence_id 
			FROM [ADD YOUR SCHEMA HERE].observation 
			WHERE observation_concept_id IN 
			(
				SELECT concept_id
				FROM vital_concepts
				WHERE domain_id = 'Observation'
			)
			AND observation_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
		) x
	) as one_year
	,(
		SELECT COUNT(distinct visit_occurrence_id) 
		FROM
		(
			SELECT visit_occurrence_id 
			FROM [ADD YOUR SCHEMA HERE].measurement
			WHERE measurement_concept_id IN 
			(
				SELECT concept_id
				FROM vital_concepts
				WHERE domain_id = 'Measurement'
			)
			AND measurement_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
			UNION DISTINCT 
			SELECT visit_occurrence_id 
			FROM [ADD YOUR SCHEMA HERE].observation 
			WHERE observation_concept_id IN 
			(
				SELECT concept_id
				FROM vital_concepts
				WHERE domain_id = 'Observation'
			)
			AND observation_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
		) x
	) as five_year


/*
Smoking Status Codes: Z87.891, F17.20, F17.200, F17.201, F17.203, F17.208, F17.209, F17.21, F17.210, F17.211, F17.213, F17.218, F17.219
*/
UNION DISTINCT 
SELECT 
	'uniq_pt_smoking' as variable_name
	,(
		SELECT COUNT(distinct person_id) 
		FROM
		(
			SELECT person_id 
			FROM [ADD YOUR SCHEMA HERE].condition_occurrence
			WHERE condition_concept_id IN 
			(
				SELECT concept_id
				FROM smoking_concepts
				WHERE domain_id = 'Condition'
			)
			AND condition_start_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
			UNION DISTINCT 
			SELECT person_id 
			FROM [ADD YOUR SCHEMA HERE].observation 
			WHERE observation_concept_id IN 
			(
				SELECT concept_id
				FROM smoking_concepts
				WHERE domain_id = 'Observation'
			)
			AND observation_date BETWEEN cast('2020-01-01' as DATE) AND cast(cast('2020-12-31' as DATE) as DATE)
		) x
	) as one_year
	,(
		SELECT COUNT(distinct person_id) 
		FROM
		(
			SELECT person_id 
			FROM [ADD YOUR SCHEMA HERE].condition_occurrence
			WHERE condition_concept_id IN 
			(
				SELECT concept_id
				FROM smoking_concepts
				WHERE domain_id = 'Condition'
			)
			AND condition_start_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
			UNION DISTINCT 
			SELECT person_id 
			FROM [ADD YOUR SCHEMA HERE].observation 
			WHERE observation_concept_id IN 
			(
				SELECT concept_id
				FROM smoking_concepts
				WHERE domain_id = 'Observation'
			)
			AND observation_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
		) x
	) as five_year



UNION DISTINCT 
SELECT 
	'uniq_pt_opioid' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM
		(
			-- " SNOMED -14784000 and its descendants "
			SELECT person_id
			FROM [ADD YOUR SCHEMA HERE].condition_occurrence
			WHERE condition_concept_id IN 
			(
				SELECT descendant_concept_id
				from [ADD YOUR SCHEMA HERE].concept_ancestor
				WHERE ancestor_concept_id = 4032799 --Opioid-induced organic mental disorder
			) 
			AND condition_start_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
			UNION DISTINCT 
			--"RxNorm (methadone {6813} and descendants, buprenorphine {1819} and descendant TTYs) "
			SELECT person_id
			FROM  [ADD YOUR SCHEMA HERE].drug_exposure
			WHERE drug_concept_id IN 
			(
				SELECT descendant_concept_id
				from [ADD YOUR SCHEMA HERE].concept_ancestor
				WHERE ancestor_concept_id IN (
					1103640		-- methadone (6813 is the concept code)
					,1133201	-- buprenorphine (1819 is the concept code)
				)
			) 
			AND drug_exposure_start_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
		) x
	) as one_year
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM
		(
			-- " SNOMED -14784000 and its descendants "
			SELECT person_id
			FROM [ADD YOUR SCHEMA HERE].condition_occurrence
			WHERE condition_concept_id IN 
			(
				SELECT descendant_concept_id
				from [ADD YOUR SCHEMA HERE].concept_ancestor
				WHERE ancestor_concept_id = 4032799 --Opioid-induced organic mental disorder
			) 
			AND condition_start_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
			UNION DISTINCT 
			--"RxNorm (methadone {6813} and descendants, buprenorphine {1819} and descendant TTYs) "
			SELECT person_id
			FROM  [ADD YOUR SCHEMA HERE].drug_exposure
			WHERE drug_concept_id IN 
			(
				SELECT descendant_concept_id
				from [ADD YOUR SCHEMA HERE].concept_ancestor
				WHERE ancestor_concept_id IN (
					1103640		-- methadone (6813 is the concept code)
					,1133201	-- buprenorphine (1819 is the concept code)
				)
			) 
			AND drug_exposure_start_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
		) x
	) as five_year

-- TODO: Better way to calculate the date range overlap?

UNION DISTINCT 
SELECT 
	'uniq_pt_any_insurance_value' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM[ADD YOUR SCHEMA HERE].payer_plan_period
		WHERE payer_plan_period_start_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
		OR payer_plan_period_end_date BETWEEN cast('2020-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as one_year
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM[ADD YOUR SCHEMA HERE].payer_plan_period
		WHERE payer_plan_period_start_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
		OR payer_plan_period_end_date BETWEEN cast('2016-01-01' as DATE) AND cast('2020-12-31' as DATE)
	) as five_year

-- NULL as NA. Best approach TBD for OMOP 
UNION DISTINCT 
SELECT 
	'uniq_pt_insurance_value_set' as variable_name
	,NULL as one_year
	,NULL as five_year

;

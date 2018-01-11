/*
Notes:
1. The added "WITH st" clause allows to limit the data retrieval to after cut-off date, here set to January 1, 2007.
   To change to your site requirements, just change date literal in st definition.
2. Suggested changes to the presentation of the data are included into individual sectioins, along with comments on 
   what to use to have the original presentation.
3. The query assumes that it is run in schema where OMOP tables are present.
4. The query assumes that OMOP dictionaries are under different schema, here called "omop".
5. The query is developed and tested on CDRN OMOP common data model (CDM); the differences from standard 
   OMOP CDM are indicated in comments to specific section, along with instructions on how to modify 
   the query to use on standard OMOP CDM.
*/
WITH st AS 
( -- Defining the date to use afterwards
	SELECT DATE '1950-01-01' AS stdt FROM dual
), den AS
( -- Including only patients that have been seen after st.stdt
	SELECT CAST(Count(*) AS FLOAT) AS "Unique Total Patients" 
	FROM person op WHERE EXISTS 
	(SELECT 1 FROM visit_occurrence v, st 
	 WHERE v.person_source_value = op.person_source_value AND visit_start_date >= st.stdt) 
-- add to every subquery
)
-- Domain Demographics Unique Patients
-- Suggested change: use number and 100% instead of NULLs (empty strings in MS SQL)
SELECT 'Demo Unique Patients' AS "Domain", "Unique Total Patients" AS "Patients with Standards", /* or NULL AS ...*/
  "Unique Total Patients", 100 AS "% Standards", /* or NULL AS ...*/ 
  'Not Applicable' AS "Values Present" 
FROM den
UNION
-- Domain Gender: % of unique patient with gender populated
SELECT num.*, den.*, 
  Round((100.0 * (num."Patients with Standards"/ den."Unique Total Patients")),2) AS "% Standards", 
  'Not Applicable' AS "Values Present" 
FROM 
(SELECT 'Demo Gender' AS "Domain", 
   CAST(COUNT(*) AS FLOAT) AS "Patients with Standards"
-- Including only patients that have been seen after st.stdt
 FROM 
 (SELECT gender_concept_id, person_source_value FROM person op WHERE EXISTS 
	(SELECT 1 FROM visit_occurrence v, st 
	 WHERE v.person_source_value = op.person_source_value AND visit_start_date >= st.stdt) 
 ) d 
 INNER JOIN omop.concept c ON d.gender_concept_id = c.concept_id 
   AND c.vocabulary_id = 'Gender' 
) num, den 
UNION
-- Domain Age/DOBL: % of unique patient with DOB populated
SELECT num.*, den.*, 
  Round((100.0 * (num."Patients with Standards"/ den."Unique Total Patients")),2) AS "% Standards", 
  'Not Applicable' AS "Values Present" 
FROM 
(SELECT 'Demo Age/DOB' AS "Domain", 
   CAST(COUNT(*) AS Float) AS "Patients with Standards"
-- Including only patients that have been seen after st.stdt
 FROM 
 (SELECT person_source_value FROM person op WHERE EXISTS 
	(SELECT 1 FROM visit_occurrence v, st 
	 WHERE v.person_source_value = op.person_source_value AND visit_start_date >= st.stdt) 
			-- AND datetime_of_birth IS NOT NULL 
		and D.Year_of_Birth  is NOT NULL 
			-- AND  D.month_of_Birth is NOT NULL 
			-- AND  D.Day_of_Birth  is NOT NULL

  	/* For those using exact OMOP model, replace 
	AND datetime_of_birth IS NOT NULL 
	with 
	AND year_of_birth IS NOT NULL AND month_of_birth IS NOT NULL AND day_of_birth IS NOT NULL 
	*/
 ) d 
) num, den 
UNION
-- Domain Labs: % of unique patient with LOINC as lab valued
SELECT num.*, den.*, 
  Round((100.0 * (num."Patients with Standards"/ den."Unique Total Patients")),2) AS "% Standards", 
  'Not Applicable' AS "Values Present" 
FROM 
(SELECT 'Labs as LOINC' AS "Domain", 
   CAST(COUNT(DISTINCT person_source_value) AS Float) AS "Patients with Standards"
 FROM measurement d JOIN st ON 1=1 
 JOIN omop.concept c ON d.measurement_concept_id = c.concept_id 
   AND c.vocabulary_id = 'LOINC' 
-- Including only patients that have been seen after st.stdt and only data from that period
 WHERE EXISTS 
	(SELECT 1 FROM visit_occurrence v, st 
	 WHERE v.person_source_value = d.person_source_value AND visit_start_date >= st.stdt) 
	AND measurement_date >= st.stdt
) num, den 
UNION
-- Domain Drug: % of unique patient with RxNorm as Medication valued
SELECT num.*, den.*, 
  Round((100.0 * (num."Patients with Standards"/ den."Unique Total Patients")),2) AS "% Standards", 
  'Not Applicable' AS "Values Present" 
FROM 
(SELECT 'Drugs as RxNORM' AS "Domain", 
   CAST(COUNT(DISTINCT person_source_value) AS Float) AS "Patients with Standards"
 FROM drug_exposure d JOIN st ON 1=1 
 JOIN omop.concept c ON d.drug_concept_id = c.concept_id AND c.vocabulary_id = 'RxNorm' 
-- Including only patients that have been seen after st.stdt and only data from that period
 WHERE EXISTS 
	(SELECT 1 FROM visit_occurrence v, st 
	 WHERE v.person_source_value = d.person_source_value AND visit_start_date >= st.stdt) 
	AND drug_exposure_start_date >= st.stdt
) num, den 
UNION
-- Domain Condition: % of unique patient with standard value set for condition
SELECT num.*, den.*, 
  Round((100.0 * (num."Patients with Standards"/ den."Unique Total Patients")),2) AS "% Standards", 
  'Not Applicable' AS "Values Present" 
FROM 
(SELECT 'Diagnosis as ICD/SNOMED' AS "Domain", 
   CAST(COUNT(DISTINCT person_source_value) AS Float) AS "Patients with Standards" 
 FROM condition_occurrence p JOIN st ON 1=1 
 LEFT JOIN omop.concept c ON p.condition_source_concept_id = c.concept_id 
   AND c.vocabulary_id IN ('SNOMED','ICD9CM','ICD10CM') 
 LEFT JOIN omop.concept c2 ON p.condition_concept_id = c2.concept_id 
   AND c2.vocabulary_id IN ('SNOMED','ICD9CM','ICD10CM') 
 WHERE (c.concept_id IS NOT NULL OR c2.concept_id IS NOT NULL)
-- Including only patients that have been seen after st.stdt and only data from that period
   AND EXISTS 
	(SELECT 1 FROM visit_occurrence v, st 
	 WHERE v.person_source_value = p.person_source_value AND visit_start_date >= st.stdt) 
	AND condition_start_date >= st.stdt 
) num, den 
UNION
-- Domain Procedure: % of unique patient with standard value set for procedure
SELECT num.*, den.*, 
  Round((100.0 * (num."Patients with Standards"/ den."Unique Total Patients")),2) AS "% Standards", 
  'Not Applicable' AS "Values Present" 
FROM 
(SELECT 'Procedures as ICD/SNOMED/CPT4' AS "Domain", 
   CAST(COUNT(DISTINCT person_source_value) AS Float) AS "Patients with Standards"
 FROM procedure_occurrence p JOIN st ON 1=1 
 LEFT JOIN omop.concept c ON p.procedure_source_concept_id = c.concept_id 
   AND c.vocabulary_id IN ('SNOMED','ICD9Proc','ICD10PCS','CPT4')
/*	-- CDRN OMOP model doesn't include column procedure_concept_id in site OMOP database, 
	-- so it is commented out here
	-- Uncomment the block to use exact OMOP model  
 LEFT JOIN omop.concept c2 ON p.procedure_concept_id = c2.concept_id 
   AND c2.vocabulary_id IN ('SNOMED','ICD9Proc','ICD10PCS','CPT4') */
 WHERE (c.concept_id IS NOT NULL /* -- see comment above 
     OR c2.concept_id IS NOT NULL */)
-- Including only patients that have been seen after st.stdt and only data from that period
   AND EXISTS 
	(SELECT 1 FROM visit_occurrence v, st 
	 WHERE v.person_source_value = p.person_source_value AND visit_start_date >= st.stdt) 
	AND procedure_date >= st.stdt
) num, den 
UNION
-- Domain Observations:  Checks for the presents of recorded observations
-- Suggested change: use number and % instead of NULLs
SELECT 'Observations Present' AS "Domain",  Cnt AS "Patients with Standards", /* or NULL AS ... */
  den."Unique Total Patients" AS "Unique Total Patients", /* or NULL AS ... */
  Round((100.0 * (Cnt/den."Unique Total Patients" )),2)  AS  "% Standards", /* or NULL AS ... */
  CASE 
	WHEN Cnt = 0 THEN 'No Observation' ELSE 'Observations Present' END AS "Values Present"		
FROM 
(SELECT Count(distinct person_source_value) AS Cnt FROM observation p, st 
-- Including only patients that have been seen after st.stdt and only data from that period
 WHERE EXISTS 
	(SELECT 1 FROM visit_occurrence v, st 
	 WHERE v.person_source_value = p.person_source_value AND visit_start_date >= st.stdt) 
	AND observation_date >= st.stdt
) ob, den 
UNION
-- Domain Note Text: % of unique patient with note text populated
/*	-- CDRN OMOP model doesn't include table NOTE, so the whole block is commented out 
	-- Uncomment the block and comment out the replacement SELECT statement to use exact OMOP model 
SELECT num.*, den.*, 
  (100.0 * (num."Patients with Standards"/ den."Unique Total Patients")) AS "% Standards", 
  'Not Applicable' AS "Values Present" 
FROM 
(
 SELECT "Note Text" AS Domain, 
 CAST(COUNT(DISTINCT D.person_id) as Float) AS "Patients with Standards"
 FROM Note D
) Num, DEN
*/
	SELECT 'Note Text' AS "Domain", 0 AS "Patients with Standards", den.*, 0 AS "% Standards", 
	  'Not Applicable' AS "Values Present" 
	FROM den 
ORDER BY "Domain"
;

-- Query Informatics Metrics CTSA EDW
-- Data Model: OMOP 5.X
-- Database Google BigQuery
-- Created 12/24/2018
-- Modified by Michael Kahn University of Colorado (Michael.Kahn@ucdenver.edu)
-- Based on Version: Database MS SQL / Updated 01/05/2018
-- GBQ Modifications:
--   - Oracle-like WITH-AS syntax
--   - GBQ aliases cannot have spaces and cannot be quoted. Replaced spaces in aliases with underscores
--   - GBQ Columns cannot have special chars. Replace % char with PerCnt_
--   - Union --> Union All
--   - Replace Float with Float64
--   - GBQ table names (but not column names) are case sensitive

-- To execute: Replace [ADD YOUR SCHEMA PATH HERE] with the full DB.SCHEMA for your GBQ insance
--             Check table names for case-sensitivity (column names are not case sensitive)
--


-- With Statement used to calculate Unique Patients, used as the denominator for subsequent measures
with DEN as (
		SELECT CAST(Count(Distinct OP.Person_ID)as Float64) as Unique_Total_Patients
		FROM `[ADD YOUR SCHEMA PATH HERE].PERSON`   OP
)

--Domain Demographics Unique Patients
SELECT "Demo Unique Patients" AS Domain, NULL as Patients_with_Standards, 
       Unique_Total_Patients as Unique_Total_Patients ,NULL as  PerCnt_Standards, 'Not Applicable' as Values_Present		
       FROM DEN	

Union All
-- Domain Gender: % of unique patient with gender populated
	Select NUM.*, DEN.*, (100.0 * (NUM.Patients_with_Standards/ DEN.Unique_Total_Patients)) as PerCnt_Standards,'Not Applicable' as Values_Present	
	From 
		(
		SELECT 'Demo Gender' AS Domain, 
		CAST(COUNT(DISTINCT D.person_id) as Float64) AS Patients_with_Standards
		FROM `[ADD YOUR SCHEMA PATH HERE].PERSON` D
		INNER JOIN `[ADD YOUR SCHEMA PATH HERE].CONCEPT` C ON D.Gender_concept_id = C.concept_id AND C.vocabulary_id = 'Gender' 
		) NUM, DEN
Union All
-- Domain Age/DOBL: % of unique patient with DOB populated
	Select NUM.*, DEN.*, (100.0 * (NUM.Patients_with_Standards/ Den.Unique_Total_Patients)) as PerCnt_Standards,'Not Applicable' as Values_Present	
	From 
		(
		SELECT 'Demo Age/DOB' AS Domain, 
		CAST(COUNT(DISTINCT D.person_id) as Float64) AS Patients_with_Standards
		FROM `[ADD YOUR SCHEMA PATH HERE].PERSON` D
		-- We may want to alter this to be only Year of birth present at this time Year, Month and Day are required in order to count
		        --Where D.birth_datetime  is NOT NULL 
		Where D.Year_of_Birth  is NOT NULL 
			--and  D.month_of_Birth is NOT NULL 
			--and  D.Day_of_Birth  is NOT NULL
		) Num, DEN

Union All
-- Domain Labs: % of unique patient with LOINC as lab valued
	Select NUM.*, DEN.*, (100.0 * (NUM.Patients_with_Standards/ Den.Unique_Total_Patients)) as PerCnt_Standards , 'Not Applicable' as Values_Present	
	From 
		(
		SELECT 'Labs as LOINC' AS Domain, 
		CAST(COUNT(DISTINCT D.person_id) as Float64) AS Patients_with_Standards
		FROM `[ADD YOUR SCHEMA PATH HERE].MEASUREMENT`  D
		JOIN `[ADD YOUR SCHEMA PATH HERE].CONCEPT`  C ON D.Measurement_concept_id = C.concept_id AND C.vocabulary_id = 'LOINC' 
		) Num, DEN

Union All
-- Domain Drug: % of unique patient with RxNorm as Medication valued
	Select NUM.*, DEN.*, (100.0 * (NUM.Patients_with_Standards/ Den.Unique_Total_Patients)) as PerCnt_Standards,'Not Applicable' as Values_Present	
	From 
		(
		SELECT 'Drugs as RxNORM' AS Domain, 
		CAST(COUNT(DISTINCT D.person_id) as Float64) AS Patients_with_Standards
		FROM `[ADD YOUR SCHEMA PATH HERE].DRUG_EXPOSURE`  D
		JOIN `[ADD YOUR SCHEMA PATH HERE].CONCEPT` C ON D.drug_concept_id = C.concept_id AND C.vocabulary_id = 'RxNorm' 
		) Num, DEN
Union All
-- Domain Condition: % of unique patient with standard value set for condition
	Select NUM.*, DEN.*, (100.0 * (NUM.Patients_with_Standards/ DEN.Unique_Total_Patients)) as PerCnt_Standards,'Not Applicable' as Values_Present	
	From
		(
		SELECT 'Diagnosis as ICD/SNOMED' AS Domain, 
		CAST(COUNT(DISTINCT P.person_id) as Float64) AS Patients_with_Standards 
		FROM `[ADD YOUR SCHEMA PATH HERE].CONDITION_OCCURRENCE`   P
		LEFT JOIN `[ADD YOUR SCHEMA PATH HERE].CONCEPT` c ON p.condition_source_concept_id = c.concept_id AND c.vocabulary_id IN ('SNOMED','ICD9CM','ICD10CM')
		LEFT JOIN `[ADD YOUR SCHEMA PATH HERE].CONCEPT` c2 ON p.condition_concept_id = c2.concept_id AND c2.vocabulary_id IN ('SNOMED','ICD9CM','ICD10CM')
		WHERE c.concept_id IS NOT NULL OR c2.concept_id IS NOT NULL
		) Num, DEN

Union All
-- Domain Procedure: % of unique patient with standard value set for procedure
	Select NUM.*, DEN.*, (100.0 * (NUM.Patients_with_Standards/ DEN.Unique_Total_Patients)) as PerCnt_Standards,'Not Applicable' as Values_Present	
	From 
		(
		SELECT 'Procedures as ICD/SNOMED/CPT4' AS Domain, 
		CAST(COUNT(DISTINCT P.person_id) as Float64) AS Patients_with_Standards
		FROM `[ADD YOUR SCHEMA PATH HERE].PROCEDURE_OCCURRENCE`  P
		LEFT JOIN `[ADD YOUR SCHEMA PATH HERE].CONCEPT` c ON p.procedure_source_concept_id= c.concept_id AND c.vocabulary_id IN ('SNOMED','ICD9Proc','ICD10PCS','CPT4')
		LEFT JOIN `[ADD YOUR SCHEMA PATH HERE].CONCEPT` c2 ON p.procedure_concept_id = c2.concept_id   AND c2.vocabulary_id IN ('SNOMED','ICD9Proc','ICD10PCS','CPT4')
		WHERE c.concept_id IS NOT NULL OR c2.concept_id IS NOT NULL
		) Num, DEN

Union All
-- Domain Observations:  Checks for the presents of recorded observations
  Select 'Observations Present' AS Domain,  Null as Patients_with_Standards, Null as Unique_Total_Patients, Null as PerCnt_Standards,
  Case
			When Count(*) = 0 then 'No Observation' else 'Observations Present' end as Values_Present
	from `[ADD YOUR SCHEMA PATH HERE].OBSERVATION` 

Union All
-- Domain Note Text: % of unique patient with note text populated
	Select NUM.*, DEN.*, (100.0 * (NUM.Patients_with_Standards/ DEN.Unique_Total_Patients)) as PerCnt_Standards,'Not Applicable' as Values_Present	
	From 
		(
		SELECT 'Note Text' AS Domain, 
		CAST(COUNT(DISTINCT D.person_id) as Float64) AS Patients_with_Standards
		FROM `[ADD YOUR SCHEMA PATH HERE].NOTE`  D
		) Num, DEN

----Union
---- Future Measures 
-- Domain NLP present does not measure % of unique patients
--	--Select 'Note NLP Present' AS 'Domain',  '' as 'Patients with Standards', '' as 'Unique Total Patients', '' as  '% Standards', 
--	--Case 
--	--		When Count(*) = 0 then 'No Observation' else 'Observations Present' end as 'Values Present'		
--	--from Note_NLP

Order by Domain


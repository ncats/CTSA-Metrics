-- Query Informatics Metrics CTSA EDW
-- Data Model: OMOP 5.X
-- Database Google BigQuery

-- Version 2018
-- Created 12/24/2018
-- Based on Version: Database MS SQL / Updated 01/05/2018
-- Modified by Michael Kahn University of Colorado (Michael.Kahn@ucdenver.edu)
--
-- Version 2020
-- Updated 06/25/2020
-- Modified by Michael Kahn University of Colorado (Michael.Kahn@cuanschutz.edu)
--
-- Release Notes
--
-- Version 2018 GBQ Modifications:
--   - Oracle-like WITH-AS syntax
--   - GBQ aliases cannot have spaces and cannot be quoted.
--            Replaced spaces in column aliases with underscores
--            Removed single quotes around column aliases
--   - GBQ Column names cannot have special chars. 
--            Replaced %_Standards column alias with PerCnt_Standards
--   - Replaced Union --> Union All
--   - Replaced Float with Float64
--   - GBQ table names are case sensitive
--            Colorado GBQ table names are ALL CAPS
--            Changed table names to ALL CAPS
--            But GBQ column names are not case sensitve (go figure)
--

-- Version 2020 modifications:
--   - New temp table (DT_Interval) to implement date restriction in one place
--   - Restricted all metrics to data collected on patients with visits between 1/1/2019-12/31/2019
--         - Valid PERSON_IDs pulled from VISIT_OCCURRENCE using visit_start_date rather than PERSON
--   - lowercased all tables
--   - added #standardSQL query prefix to ensure right syntax is used

-- ********************************************************************************************
-- TO EXECUTE: 
--   1. Replace [ADD YOUR SCHEMA PATH HERE] with the full DB.SCHEMA for your GBQ instance
--   2. Modify start/end dates in DT_Interval temp table per date restriction requirements
--   2. Check table names for upper/lower case match (column names are not case sensitive)
-- ********************************************************************************************

#standardSQL
create or replace temp table DT_Interval as (
    SELECT CAST('2019-01-01' as DATE) as Start_Date, CAST('2019-12-31' as DATE) as End_Date );


-- With Statement used to calculate Unique Patients, used as the denominator for subsequent measures
-- VERSION 2020: Count unique PERSON_IDs in visit_occurrence table rather than PERSON table to impose temporal constraint on valid patients

#standardSQL
with DEN as (
		SELECT CAST(Count(Distinct VO.Person_ID)as Float64) as Unique_Total_Patients
		FROM `[ADD YOUR SCHEMA PATH HERE].visit_occurrence` VO, DT_Interval DT
    where VO.visit_start_date between DT.Start_Date and DT.End_Date)
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
		FROM `[ADD YOUR SCHEMA PATH HERE].person` D inner join `[ADD YOUR SCHEMA PATH HERE].visit_occurrence` VO on D.person_id = VO.person_id, DT_Interval DT
		INNER JOIN `[ADD YOUR SCHEMA PATH HERE].concept` C ON D.Gender_concept_id = C.concept_id AND C.vocabulary_id = 'Gender' 
    where VO.visit_start_date between DT.Start_Date and DT.End_Date
		) NUM, DEN
Union All
-- Domain Age/DOBL: % of unique patient with DOB populated
	Select NUM.*, DEN.*, (100.0 * (NUM.Patients_with_Standards/ Den.Unique_Total_Patients)) as PerCnt_Standards,'Not Applicable' as Values_Present	
	From 
		(
		SELECT 'Demo Age/DOB' AS Domain, 
		CAST(COUNT(DISTINCT D.person_id) as Float64) AS Patients_with_Standards
    FROM `[ADD YOUR SCHEMA PATH HERE].person` D inner join `[ADD YOUR SCHEMA PATH HERE].visit_occurrence` VO on D.person_id = VO.person_id, DT_Interval DT
		WHERE D.Year_of_Birth  is NOT NULL
    AND VO.visit_start_date between DT.Start_Date and DT.End_Date
		) Num, DEN

Union All
-- Domain Labs: % of unique patient with LOINC as lab valued
	Select NUM.*, DEN.*, (100.0 * (NUM.Patients_with_Standards/ Den.Unique_Total_Patients)) as PerCnt_Standards , 'Not Applicable' as Values_Present	
	From 
		(
		SELECT 'Labs as LOINC' AS Domain, 
		CAST(COUNT(DISTINCT D.person_id) as Float64) AS Patients_with_Standards
		FROM `[ADD YOUR SCHEMA PATH HERE].measurement` D INNER JOIN `[ADD YOUR SCHEMA PATH HERE].visit_occurrence` VO on D.visit_occurrence_id = VO.visit_occurrence_id
		INNER JOIN `[ADD YOUR SCHEMA PATH HERE].concept` C ON D.Measurement_concept_id = C.concept_id AND C.vocabulary_id = 'LOINC',  DT_Interval DT 
   where VO.visit_start_date between DT.Start_Date and DT.End_Date
		) Num, DEN

Union All
-- Domain Drug: % of unique patient with RxNorm as Medication valued
	Select NUM.*, DEN.*, (100.0 * (NUM.Patients_with_Standards/ Den.Unique_Total_Patients)) as PerCnt_Standards,'Not Applicable' as Values_Present	
	From 
		(
		SELECT 'Drugs as RxNORM' AS Domain, 
		CAST(COUNT(DISTINCT D.person_id) as Float64) AS Patients_with_Standards
		FROM `[ADD YOUR SCHEMA PATH HERE].drug_exposure`  D INNER JOIN `[ADD YOUR SCHEMA PATH HERE].visit_occurrence` VO on D.visit_occurrence_id = VO.visit_occurrence_id
		JOIN `[ADD YOUR SCHEMA PATH HERE].concept` C ON D.drug_concept_id = C.concept_id AND C.vocabulary_id = 'RxNorm' , DT_Interval DT
   where VO.visit_start_date between DT.Start_Date and DT.End_Date
		) Num, DEN
Union All
-- Domain Condition: % of unique patient with standard value set for condition
	Select NUM.*, DEN.*, (100.0 * (NUM.Patients_with_Standards/ DEN.Unique_Total_Patients)) as PerCnt_Standards,'Not Applicable' as Values_Present	
	From
		(
		SELECT 'Diagnosis as ICD/SNOMED' AS Domain, 
		CAST(COUNT(DISTINCT CO.person_id) as Float64) AS Patients_with_Standards 
		FROM `[ADD YOUR SCHEMA PATH HERE].condition_occurrence` CO
    JOIN `[ADD YOUR SCHEMA PATH HERE].visit_occurrence` VO on CO.visit_occurrence_id = VO.visit_occurrence_id
		JOIN `[ADD YOUR SCHEMA PATH HERE].concept` C ON co.condition_concept_id = C.concept_id AND C.vocabulary_id IN ('SNOMED','ICD9CM','ICD10CM') ,DT_Interval DT
    WHERE VO.visit_start_date between DT.Start_Date and DT.End_Date
		) Num, DEN

Union All
-- Domain Procedure: % of unique patient with standard value set for procedure
	Select NUM.*, DEN.*, (100.0 * (NUM.Patients_with_Standards/ DEN.Unique_Total_Patients)) as PerCnt_Standards,'Not Applicable' as Values_Present	
	From 
		(
		SELECT 'Procedures as ICD/SNOMED/CPT4' AS Domain, 
		CAST(COUNT(DISTINCT PO.person_id) as Float64) AS Patients_with_Standards
		FROM `[ADD YOUR SCHEMA PATH HERE].procedure_occurrence`  PO
    JOIN `[ADD YOUR SCHEMA PATH HERE].visit_occurrence` VO on PO.visit_occurrence_id = VO.visit_occurrence_id
	  JOIN `[ADD YOUR SCHEMA PATH HERE].concept` C ON PO.procedure_concept_id = C.concept_id   AND C.vocabulary_id IN ('SNOMED','ICD9Proc','ICD10PCS','CPT4'), DT_Interval DT
    WHERE VO.visit_start_date between DT.Start_Date and DT.End_Date
		) Num, DEN

Union All
-- Domain Observations:  Checks for the presents of recorded observations
  Select 'Observations Present' AS Domain,  Null as Patients_with_Standards, Null as Unique_Total_Patients, Null as PerCnt_Standards,
  Case
			When Count(observation_id) = 0 then 'No Observation' else 'Observations Present' end as Values_Present
	from `[ADD YOUR SCHEMA PATH HERE].observation` OBS 
  LEFT JOIN `[ADD YOUR SCHEMA PATH HERE].visit_occurrence` VO on OBS.visit_occurrence_id = VO.visit_occurrence_id, DT_Interval DT
  where VO.visit_start_date between DT.Start_Date and DT.End_Date

Union All
-- Domain Note Text: % of unique patient with note text populated
	Select NUM.*, DEN.*, (100.0 * (NUM.Patients_with_Standards/ DEN.Unique_Total_Patients)) as PerCnt_Standards,'Not Applicable' as Values_Present	
	From 
		(
		SELECT 'Note Text' AS Domain, 
		CAST(COUNT(DISTINCT N.person_id) as Float64) AS Patients_with_Standards
		FROM `[ADD YOUR SCHEMA PATH HERE].note`  N
    LEFT JOIN `[ADD YOUR SCHEMA PATH HERE].visit_occurrence` VO on N.visit_occurrence_id = VO.visit_occurrence_id, DT_Interval DT
    where VO.visit_start_date between DT.Start_Date and DT.End_Date
		) Num, DEN

----Union
---- Future Measures 
-- Domain NLP present does not measure % of unique patients
--	--Select 'Note NLP Present' AS 'Domain',  '' as 'Patients with Standards', '' as 'Unique Total Patients', '' as  '% Standards', 
--	--Case 
--	--		When Count(*) = 0 then 'No Observation' else 'Observations Present' end as 'Values Present'		
--	--from Note_NLP

Order by Domain



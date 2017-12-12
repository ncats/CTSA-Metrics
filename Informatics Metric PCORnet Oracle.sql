-- Query Informatics Metrics CTSA EDW
-- Data Model: PCORnet CDM v 3.1
-- Database Oracle
-- Updated 8/23/2017

with DEN as 
  ( select count(*) cnt from demographic )-- CDM standards indicate that demographic should contain one entry per patient. Unique is not required.
--Domain Demographics Unique Patients
 select 'Demo Unique Patients' As DOMAIN, null as Patients_with_Standards, den.cnt as UNIQUE_TOTAL_PATIENTS, null as Percent_Standards, 'Not Applicable' as Values_Present
 from den
union all
-- Domain Gender: % of unique patient with gender populated
 select 'Demo Gender' as domain, num.cnt as Patients_with_Standards, den.cnt as UNIQUE_TOTAL_PATIENTS, 100.0 * num.cnt/den.cnt as Percent_Standards, 'Not Applicable' as Values_Present
  from (select count(*) cnt from demographic where sex in ('F','M','NI', 'UN', 'OT')) num, den -- add 'A' if 'Ambiguous' is acceptable)
union all
-- Domain Age/DOBL: % of unique patient with DOB populated
 select 'Demo Age/DOB' as domain, num.cnt as Patients_with_Standards, den.cnt as UNIQUE_TOTAL_PATIENTS, 100.0 * num.cnt/den.cnt as Percent_Standards, 'Not Applicable' as Values_Present
  from (select count(*) cnt from demographic where not birth_date is null) num, den 
union all
-- Domain Labs: % of unique patient with LOINC as lab valued
 select 'Labs as LOINC' as domain, num.cnt as Patients_with_Standards, den.cnt as UNIQUE_TOTAL_PATIENTS, 100.0 * num.cnt/den.cnt as Percent_Standards, 'Not Applicable' as Values_Present
  from (select count(distinct patid) cnt from lab_result_cm where not lab_loinc is null) num, den 
/* union
-- Domain Drug: % of unique patient with RxNorm as Medication valued
    -- the CDM Prescribing table for drugs prescribed to the patient has RXNorm CUIs while the Dispensing table has NDC codes. 
    -- Use this query if NDC is not acceptable
 select 'Drugs as RxNORM' as domain, num.cnt as Patients_with_Standards, den.cnt as UNIQUE_TOTAL_PATIENTS, 100.0 * num.cnt/den.cnt as Percent_Standards, 'Not Applicable' as Values_Present
  from (select count(distinct patid) cnt from prescribing where not rxnorm_cui is null) num, den 
*/
union all
-- Domain Drug: % of unique patient with RxNorm as Medication valued
    -- the CDM Prescribing table for drugs prescribed to the patient has RXNorm CUIs while the Dispensing table has NDC codes. 
 select 'Drugs as RxNORM' as domain, num.cnt as Patients_with_Standards, den.cnt as UNIQUE_TOTAL_PATIENTS, 100.0 * num.cnt/den.cnt as Percent_Standards, 'Not Applicable' as Values_Present
  from ( select count(distinct patid) cnt
         from (
            select distinct patid from prescribing where not rxnorm_cui is null
            union select distinct patid from dispensing where not ndc is null)
        ) num, den 
union all
-- Domain Condition: % of unique patient with standard value set for condition
   --CDM separates billing diagnosis (Diagnosis) from problems lists/ patient reported complaints (Condition) 
select 'Diagnosis as ICD/SNOMED' as domain, num.cnt as Patients_with_Standards, den.cnt as UNIQUE_TOTAL_PATIENTS, 100.0 * num.cnt/den.cnt as Percent_Standards, 'Not Applicable' as Values_Present
  from ( select count(distinct patid) cnt 
         from (select distinct patid from diagnosis where not DX is null and dx_type in ('09', '10', 'SM')
           union select distinct patid from condition where not condition is null and condition_type in ('09', '10', 'SM'))
        ) num, den
/* 
--Use this query if you only want billing diagnosis.
select 'Diagnosis as ICD/SNOMED' as domain, num.cnt as Patients_with_Standards, den.cnt as UNIQUE_TOTAL_PATIENTS, 100.0 * num.cnt/den.cnt as Percent_Standards, 'Not Applicable' as Values_Present
  from ( select count(distinct patid) cnt 
         from diagnosis where not DX is null and dx_type in ('09', '10', 'SM')) num, den
*/
union all
-- Domain Procedure: % of unique patient with standard value set for procedure
      --CDM V3.1 groups CPT and HCPCS
 select 'Procedures as ICD/SNOMED/CPT4' as domain, num.cnt as Patients_with_Standards, den.cnt as UNIQUE_TOTAL_PATIENTS, 100.0 * num.cnt/den.cnt as Percent_Standards, 'Not Applicable' as Values_Present
  from (select count(distinct patid) cnt from procedures where not px is null and px_type in ('09','10','CH')) num, den
union all
-- Domain Observations:  Checks for the presents of recorded observations
 select 'Observations Present' AS 'Domain',  null as 'Patients with Standards', null as UNIQUE_TOTAL_PATIENTS, null as  '% Standards', 
		Case When Count(*) = 0 then 'No Observation' else 'Observations Present' end as 'Values Present'		
	From Vital
/*
union all
-- Domain Observations:  Checks for the presents of recorded vitals	
 select 'Observations Present' as domain, null as Patients_with_Standards, null as UNIQUE_TOTAL_PATIENTS, null as Percent_Standards, case when num.cnt = 0 then 'No Observation' else 'Observations Present' end as Values_Present
  from (select count(distinct patid) cnt 
        from vital 
        where --Remove observations that are not part of the set (height and weight?)
           not HT is null or -- height
           not WT is null or -- weight
           not diastolic is null or --DBP
           not systolic is null -- SBP
        ) num, den
*/            
union all
-- Domain Note Text: % of unique patient with note text populated
 -- CDM does not currently have note data.
 select 'Note Text' as domain, 0 as Patients_with_Standards, den.cnt as UNIQUE_TOTAL_PATIENTS, 0 as Percent_Standards, 'Not Applicable' as Values_Present
  from den
order by Domain; 

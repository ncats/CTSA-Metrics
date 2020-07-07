-- Query Informatics Metrics CTSA EDW
-- Data Model: PCORnet CDM v 5.1
-- Database Oracle
-- Updated 6/16/2020

with DEN as 
  ( select count(distinct demographic.patid) cnt from demographic JOIN encounter ON demographic.PATID = encounter.PATID and encounter.ADMIT_DATE between '01-JAN-2019' and '31-DEC-2019')
--Domain Demographics Unique Patients
 select 'Demo Unique Patients' As DOMAIN, null as Patients_with_Standards, den.cnt as UNIQUE_TOTAL_PATIENTS, null as Percent_Standards, 'Not Applicable' as Values_Present
 from den
union all
-- Domain Gender: % of unique patient with gender populated
 select 'Demo Gender' as domain, num.cnt as Patients_with_Standards, den.cnt as UNIQUE_TOTAL_PATIENTS, 100.0 * (num.cnt/den.cnt) as Percent_Standards, 'Not Applicable' as Values_Present
  from (select count(distinct demographic.patid) cnt from demographic JOIN encounter ON demographic.PATID = encounter.PATID and encounter.ADMIT_DATE between '01-JAN-2019' and '31-DEC-2019' where sex in ('F','M','NI', 'UN', 'OT')) num, den -- add 'A' if 'Ambiguous' is acceptable)
union all
-- Domain Age/DOBL: % of unique patient with DOB populated
 select 'Demo Age/DOB' as domain, num.cnt as Patients_with_Standards, den.cnt as UNIQUE_TOTAL_PATIENTS, 100.0 * (num.cnt/den.cnt) as Percent_Standards, 'Not Applicable' as Values_Present
  from (select count(distinct demographic.patid) cnt from demographic JOIN encounter ON demographic.PATID = encounter.PATID and encounter.ADMIT_DATE between '01-JAN-2019' and '31-DEC-2019' where birth_date is not null) num, den 
union all
-- Domain Labs: % of unique patient with LOINC as lab valued
 select 'Labs as LOINC' as domain, num.cnt as Patients_with_Standards, den.cnt as UNIQUE_TOTAL_PATIENTS, 100.0 * (num.cnt/den.cnt) as Percent_Standards, 'Not Applicable' as Values_Present
  from (select count(distinct patid) cnt from lab_result_cm where lab_loinc is not null and (lab_result_cm.LAB_ORDER_DATE between '01-JAN-2019' and '31-DEC-2019' or lab_result_cm.RESULT_DATE between '01-JAN-2019' and '31-DEC-2019')) num, den 
/* union
-- Domain Drug: % of unique patient with RxNorm as Medication valued
    -- the CDM Prescribing table for drugs prescribed to the patient has RXNorm CUIs while the Dispensing table has NDC codes. 
    -- Use this query if NDC is not acceptable
 select 'Drugs as RxNORM' as domain, num.cnt as Patients_with_Standards, den.cnt as UNIQUE_TOTAL_PATIENTS, 100.0 * (num.cnt/den.cnt) as Percent_Standards, 'Not Applicable' as Values_Present
  from (select count(distinct patid) cnt from prescribing where rxnorm_cui is not null and prescribing.RX_ORDER_DATE between '01-JAN-2019' and '31-DEC-2019') num, den 
*/
union all
-- Domain Drug: % of unique patient with RxNorm as Medication valued
    -- the CDM Prescribing table for drugs prescribed to the patient has RXNorm CUIs while the Dispensing table has NDC codes. 
 select 'Drugs as RxNORM' as domain, num.cnt as Patients_with_Standards, den.cnt as UNIQUE_TOTAL_PATIENTS, 100.0 * (num.cnt/den.cnt) as Percent_Standards, 'Not Applicable' as Values_Present
  from ( select count(distinct patid) cnt
         from (
            select distinct patid from prescribing where rxnorm_cui is not null and prescribing.RX_ORDER_DATE between '01-JAN-2019' and '31-DEC-2019'
            union select distinct patid from dispensing where ndc is not null and dispensing.DISPENSE_DATE between '01-JAN-2019' and '31-DEC-2019')
        ) num, den 
union all
-- Domain Condition: % of unique patient with standard value set for condition
   --CDM separates billing diagnosis (Diagnosis) from problems lists/ patient reported complaints (Condition) 
select 'Diagnosis as ICD/SNOMED' as domain, num.cnt as Patients_with_Standards, den.cnt as UNIQUE_TOTAL_PATIENTS, 100.0 * (num.cnt/den.cnt) as Percent_Standards, 'Not Applicable' as Values_Present
  from ( select count(distinct patid) cnt 
         from (select distinct patid from diagnosis where DX is not null and dx_type in ('09', '10', 'SM') and (diagnosis.DX_DATE between '01-JAN-2019' and '31-DEC-2019' or diagnosis.ADMIT_DATE between '01-JAN-2019' and '31-DEC-2019')
           union select distinct patid from condition where condition is not null and condition_type in ('09', '10', 'SM') and condition.REPORT_DATE between '01-JAN-2019' and '31-DEC-2019')
        ) num, den
/* 
--Use this query if you only want billing diagnosis.
select 'Diagnosis as ICD/SNOMED' as domain, num.cnt as Patients_with_Standards, den.cnt as UNIQUE_TOTAL_PATIENTS, 100.0 * (num.cnt/den.cnt) as Percent_Standards, 'Not Applicable' as Values_Present
  from ( select count(distinct patid) cnt 
         from diagnosis where DX is not null and dx_type in ('09', '10', 'SM') and (diagnosis.DX_DATE between '01-JAN-2019' and '31-DEC-2019' or diagnosis.ADMIT_DATE between '01-JAN-2019' and '31-DEC-2019')) num, den
*/
union all
-- Domain Procedure: % of unique patient with standard value set for procedure
      --CDM V3.1 groups CPT and HCPCS
 select 'Procedures as ICD/SNOMED/CPT4' as domain, num.cnt as Patients_with_Standards, den.cnt as UNIQUE_TOTAL_PATIENTS, 100.0 * (num.cnt/den.cnt) as Percent_Standards, 'Not Applicable' as Values_Present
  from (select count(distinct patid) cnt from procedures where px is not null and px_type in ('09','10','CH') and procedures.PX_DATE between '01-JAN-2019' and '31-DEC-2019') num, den
union all
-- Domain Observations:  Checks for the presents of recorded observations
select 'Observations Present' AS domain, null as Patients_with_Standards, null as UNIQUE_TOTAL_PATIENTS, null as Percent_Standards 
	, Case When Count(*) = 0 then 'No Observation' else 'Observations Present' end as values_present From Vital where vital.MEASURE_DATE between '01-JAN-2019' and '31-DEC-2019'
         
union all
-- Domain Note Text: % of unique patient with note text populated
 -- CDM does not currently have note data.
 select 'Note Text' as domain, 0 as Patients_with_Standards, den.cnt as UNIQUE_TOTAL_PATIENTS, 0 as Percent_Standards, 'Not Applicable' as Values_Present
  from den
order by Domain
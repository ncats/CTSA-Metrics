-- Query Informatics Metrics CTSA EDW
-- Data Model: i2b2 with ACT ontology
-- Database MS SQL
-- Updated 9/13/2017 - alpha release!
-- Written by Jeffrey G. Klann, PhD with some code adapted from Griffin Weber, MD, PhD
-- Released under the i2b2 public license: https://www.i2b2.org/software/i2b2_license.html
-- Do not delete this notice!

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ctsa_qim]'))
DROP TABLE ctsa_qim
GO

CREATE TABLE ctsa_qim
( c_sourceontology_cd varchar(30),
  c_fullname varchar(900),
  c_name varchar(2000),
  c_mode varchar(50),
  c_totalnum int,
  c_pct float )
GO

-- ACT Ontology metrics
-- TODO: THE DIAGNOSIS AND PROCEDURE TREES APPEAR TO ONLY HAVE ICD-9. THERE IS ANOTHER TABLE, NCATS_ICD10_ICD9_DX_V1 also included, which should be reconciled.
INSERT INTO ctsa_qim(c_sourceontology_cd,c_fullname,c_name,c_mode) VALUES 
 ('ACT','\','Unique Total Patients','total'),
 ('ACT','\ACT\Demographics\','Domain Demographics Unique Patients','total'), -- in i2b2, all patients have SOME demographics
 ('ACT','\ACT\Demographics\Sex\','Demo Gender','dimcode'),
 ('ACT','\ACT\Demographics\Age\','Age/DOB','dob'),
 ('ACT','\ACT\Labs\','Labs as LOINC','obsfact'), -- ACT only allows LOINC it appears
 ('ACT','\ACT\MEDICATION\RXNORM_CUI\','Drugs as RxNorm','obsfact'),
 ('ACT','\ACT\DIAGNOSIS\','Diagnosis as ICD/SNOMED','obsfact'),
 ('ACT','\ACT\PROCEDURE\','Procedures as ICD/SNOMED/CPT4','obsfact'),
 ('ACT','\ACT\NOTE\','Note Text','obsfact') 
GO

-- PCORnet Ontology metrics
INSERT INTO ctsa_qim(c_sourceontology_cd,c_fullname,c_name,c_mode) VALUES 
 ('PCORNET','\','Unique Total Patients','total'),
 ('PCORNET','\PCORI\DEMOGRAPHIC\','Domain Demographics Unique Patients','total'), -- in i2b2, all patients have SOME demographics
 ('PCORNET','\PCORI\DEMOGRAPHIC\SEX\','Demo Gender','dimcode'),
 ('PCORNET','\PCORI\DEMOGRAPHIC\Age\','Age/DOB','dob'),
 ('PCORNET','\PCORI\LAB_RESULT_CM\LAB_NAME\','Labs as LOINC','obsfact'),
 ('PCORNET','\PCORI\MEDICATION\RXNORM_CUI\','Drugs as RxNorm','obsfact'),
 ('PCORNET','\PCORI\DIAGNOSIS\','Diagnosis as ICD/SNOMED','obsfact'),
 ('PCORNET','\PCORI\PROCEDURE\','Procedures as ICD/SNOMED/CPT4','obsfact'),
 ('PCORNET','\PCORI\NOTE\','Note Text','obsfact') 
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CTSA_QIMCOUNT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CTSA_QIMCOUNT]
GO

CREATE PROCEDURE [dbo].[CTSA_QIMCOUNT] (@tabname varchar(200))

AS BEGIN
declare @sqlstr nvarchar(4000);
declare @total INT, @total_dob INT;
declare @folder varchar(1200),
        @concept varchar(1200),
		@facttablecolumn varchar(50),
		 @tablename varchar(50),
		 @columnname varchar(50),
		 @columndatatype varchar(50), 
		 @operator varchar(10),
		 @dimcode varchar(1200)
		

-- Get totals
SELECT @total = count(distinct patient_num) from patient_dimension;
print @total;

-- Get / update DOB totals
select @total_dob=count(distinct patient_num) from PATIENT_DIMENSION where birth_date is not null and year(birth_date)>1900 and year(birth_date)<year(getdate());
SET @sqlstr = 'update ctsa_qim set c_totalnum='+convert(varchar(50),@total_dob)+' where c_mode=''dob''';
execute sp_executesql @sqlstr;


-- Update counts for obsfact
update q set c_totalnum=c
from ctsa_qim q inner join
(select c_fullname,count(distinct patient_num) c from concept_dimension c inner join ctsa_qim q on c.concept_path like q.c_fullname+'%'
 inner join OBSERVATION_FACT o on o.CONCEPT_CD=c.concept_cd
 where c_mode='obsfact' group by c_fullname) x on x.c_fullname=q.c_fullname
 
-- Update counts for dimcode
 if exists (select 1 from sysobjects where name='ontInOperator') drop table ontInOperator;
set @sqlstr='select m.c_fullname, m.c_basecode, c_facttablecolumn, c_tablename, c_columnname, c_operator, c_dimcode into ontInOperator from ' + @tabname
        + ' m inner join ctsa_qim q on m.c_fullname like q.c_fullname+''%'' where  m_applied_path = ''@'' and c_synonym_cd=''N'' and lower(c_operator) in (''in'', ''='') and lower(c_tablename) in (''patient_dimension'', ''visit_dimension'') ';
execute sp_executesql @sqlstr;
alter table ontInOperator add numpats int;

  if exists(select top 1 NULL from ontInOperator)

  BEGIN
	Declare e CURSOR
		Local Fast_Forward
		For
			select c_fullname, c_facttablecolumn, c_tablename, c_columnname, c_operator, c_dimcode from ontInOperator
	Open e
		fetch next from e into @concept, @facttablecolumn, @tablename, @columnname, @operator, @dimcode
	WHILE @@FETCH_STATUS = 0
	Begin
		begin
			if lower(@operator) = 'in'
			begin
				set @dimcode = '(' + @dimcode + ')'
			end
			if lower(@operator) = '='
			begin
				set @dimcode = '''' +  replace(@dimcode,'''','''''') + ''''
			end
			set @sqlstr='update ontInOperator set 
             numpats =  (select count(distinct(patient_num)) from observation_fact   
                where ' + @facttablecolumn + ' in (select ' + @facttablecolumn + ' from ' + @tablename + ' where '+ @columnname + ' ' + @operator +' ' + @dimcode +' ))
            where c_fullname = ' + ''''+ @concept + ''''+ ' and numpats is null'

			print @sqlstr
			execute sp_executesql @sqlstr
		end

		fetch next from e into @concept, @facttablecolumn, @tablename, @columnname, @operator, @dimcode

	End
	close e
	deallocate e

    // Save the summary level of the counts -- assumes there are no categorical overlaps in dimcode defn!
    update q set c_totalnum=x.c_totalnum
    from ctsa_qim q inner join 
    (select q.c_fullname,sum(o.numpats) c_totalnum from (select distinct * from ontinoperator) o inner join ctsa_qim q on o.c_fullname like q.c_fullname+'%' group by q.c_fullname) x
    on x.c_fullname=q.c_fullname
  END

-- Update total percents
SET @sqlstr = 'update q set c_pct=convert(float,c_totalnum)/'+convert(varchar(20),@total)+' from ctsa_qim q where c_mode!=''total''';
EXEC sp_executesql @sqlstr;

-- Update total percents
SET @sqlstr = 'update q set c_totalnum='+convert(varchar(20),@total)+' from ctsa_qim q where c_mode=''total''';
EXEC sp_executesql @sqlstr;

END
GO
EXECUTE CTSA_QIMCOUNT pcornet_demo
GO
SELECT c_name 'Measurement',c_totalnum 'Total Distinct Patients',c_pct 'Percent of Total Patients' FROM CTSA_QIM WHERE C_SOURCEONTOLOGY_CD='ACT'
GO

----------------------------------------------------------------------------------------------------------------------------------------
-- Query Informatics Metrics CTSA EDW
-- Data Model: i2b2 with ACT ontology
-- Database ORACLE
-- Updated 11/16/2017 - beta release!
-- Written by Jeffrey G. Klann, PhD with some code adapted from Griffin Weber, MD, PhD
-- Translated to Oracle by Matthew Joss and Jeff Klann 
-- Released under the i2b2 public license: https://www.i2b2.org/software/i2b2_license.html
-- Do not delete this notice!
-- Note 11/15/2017 Issues were recorded from Jim Cimino -  2 edits Comments Syntax and Sysdate 
----------------------------------------------------------------------------------------------------------------------------------------
create or replace PROCEDURE PMN_DROPSQL(sqlstring VARCHAR2) AS 
  BEGIN
      EXECUTE IMMEDIATE sqlstring;
  EXCEPTION
      WHEN OTHERS THEN NULL;
END PMN_DROPSQL;
/

BEGIN
PMN_DROPSQL('DROP TABLE ctsa_qim');
END;
/


BEGIN
PMN_DROPSQL('DROP TABLE ontInOperator');
END;
/

CREATE TABLE ontInOperator (
    c_fullname varchar2(700),
    c_basecode varchar2(50),
    c_facttablecolumn varchar2(50),
    c_tablename varchar2(50),
    c_columnname varchar2(50),
    c_operator varchar2(10),
    c_dimcode varchar2(700),
    numpats int

)
/

CREATE TABLE ctsa_qim (
	c_sourceontology_cd varchar(30),
	c_fullname varchar(900),
	c_name varchar(2000),
	c_mode varchar(50),
	c_totalnum number(20),
	c_pct float(50) 
)
/


INSERT INTO ctsa_qim (c_sourceontology_cd, c_fullname, c_name, c_mode) VALUES 
 ('ACT', '\', 'Unique Total Patients', 'total')
/
INSERT INTO ctsa_qim (c_sourceontology_cd, c_fullname, c_name, c_mode) VALUES 
 ('ACT','\ACT\Demographics\','Domain Demographics Unique Patients','total') -- in i2b2, all patients have SOME demographics
/
INSERT INTO ctsa_qim (c_sourceontology_cd, c_fullname, c_name, c_mode) VALUES 
 ('ACT','\ACT\Demographics\Sex\','Demo Gender','dimcode')
/
INSERT INTO ctsa_qim (c_sourceontology_cd, c_fullname, c_name, c_mode) VALUES 
 ('ACT','\ACT\Demographics\Age\','Age/DOB','dob')
/
INSERT INTO ctsa_qim (c_sourceontology_cd, c_fullname, c_name, c_mode) VALUES 
 ('ACT','\ACT\Labs\','Labs as LOINC','obsfact') -- ACT only allows LOINC it appears
/
INSERT INTO ctsa_qim (c_sourceontology_cd, c_fullname, c_name, c_mode) VALUES 
 ('ACT','\ACT\MEDICATION\RXNORM_CUI\','Drugs as RxNorm','obsfact')
/
INSERT INTO ctsa_qim (c_sourceontology_cd, c_fullname, c_name, c_mode) VALUES 
 ('ACT','\ACT\DIAGNOSIS\','Diagnosis as ICD/SNOMED','obsfact')
/
INSERT INTO ctsa_qim (c_sourceontology_cd, c_fullname, c_name, c_mode) VALUES 
 ('ACT','\ACT\PROCEDURE\','Procedures as ICD/SNOMED/CPT4','obsfact')
/
INSERT INTO ctsa_qim (c_sourceontology_cd, c_fullname, c_name, c_mode) VALUES 
 ('ACT','\ACT\NOTE\','Note Text','obsfact')
/

INSERT INTO ctsa_qim(c_sourceontology_cd,c_fullname,c_name,c_mode) VALUES 
 ('PCORNET','\','Unique Total Patients','total')
/
INSERT INTO ctsa_qim(c_sourceontology_cd,c_fullname,c_name,c_mode) VALUES
 ('PCORNET','\PCORI\DEMOGRAPHIC\','Domain Demographics Unique Patients','total') -- in i2b2, all patients have SOME demographics
/
INSERT INTO ctsa_qim(c_sourceontology_cd,c_fullname,c_name,c_mode) VALUES
 ('PCORNET','\PCORI\DEMOGRAPHIC\SEX\','Demo Gender','dimcode')
/
INSERT INTO ctsa_qim(c_sourceontology_cd,c_fullname,c_name,c_mode) VALUES
 ('PCORNET','\PCORI\DEMOGRAPHIC\Age\','Age/DOB','dob')
/
INSERT INTO ctsa_qim(c_sourceontology_cd,c_fullname,c_name,c_mode) VALUES
 ('PCORNET','\PCORI\LAB_RESULT_CM\LAB_NAME\','Labs as LOINC','obsfact')
/
INSERT INTO ctsa_qim(c_sourceontology_cd,c_fullname,c_name,c_mode) VALUES
 ('PCORNET','\PCORI\MEDICATION\RXNORM_CUI\','Drugs as RxNorm','obsfact')
/
INSERT INTO ctsa_qim(c_sourceontology_cd,c_fullname,c_name,c_mode) VALUES
 ('PCORNET','\PCORI\DIAGNOSIS\','Diagnosis as ICD/SNOMED','obsfact')
/
INSERT INTO ctsa_qim(c_sourceontology_cd,c_fullname,c_name,c_mode) VALUES
 ('PCORNET','\PCORI\PROCEDURE\','Procedures as ICD/SNOMED/CPT4','obsfact')
/
INSERT INTO ctsa_qim(c_sourceontology_cd,c_fullname,c_name,c_mode) VALUES
 ('PCORNET','\PCORI\NOTE\','Note Text','obsfact') 
/

create or replace procedure ctsa_qimcount(tabname IN varchar2)
AS
sqlstr varchar(4000);
total INT; 
total_dob INT;
folder varchar(1200);
concept varchar(1200);
facttablecolumn varchar(50);
tablename varchar(50);
columnname varchar(50);
columndatatype varchar(50); 
operator1 varchar(10);       --NOTE: Variable changed from operator to operator1
dimcode varchar(1200);
CURSOR e is select c_fullname, c_facttablecolumn, c_tablename, c_columnname, c_operator, c_dimcode from ontInOperator;

begin
 
  DBMS_OUTPUT.PUT_LINE('Hello World');
 
--------Get totals
SELECT count(distinct patient_num) into total from patient_dimension;
DBMS_OUTPUT.PUT_LINE(total);
 

------- Get / update DOB totals
select count(distinct patient_num) into total_dob from PATIENT_DIMENSION where birth_date is not null and extract(year from birth_date)>1900 and extract(year from birth_date)<extract(year from sysdate);
update ctsa_qim set c_totalnum= to_char(total_dob) where c_mode='dob';


------- Update counts for obsfact
update ctsa_qim set c_totalnum= (select cnt from
(select c_fullname,count(distinct patient_num) cnt from concept_dimension c inner join ctsa_qim q on c.concept_path like q.c_fullname||'%'
inner join OBSERVATION_FACT o on o.CONCEPT_CD=c.concept_cd
where c_mode='obsfact' group by c_fullname) x where ctsa_qim.c_fullname=x.c_fullname) 
WHERE EXISTS
 (select c_fullname from (SELECT c_fullname from concept_dimension c inner join ctsa_qim q on c.concept_path like q.c_fullname||'%' where c_mode='obsfact' group by c_fullname) x where x.c_fullname=ctsa_qim.c_fullname);
		
--Update counts for dimcode
PMN_DROPSQL('TRUNCATE TABLE ontInOperator');
sqlstr:='insert into ontInOperator select m.c_fullname, m.c_basecode, c_facttablecolumn, c_tablename, c_columnname, c_operator, c_dimcode, null numpats from '||tabname||' m inner join ctsa_qim q on m.c_fullname like q.c_fullname||''%'' where  m_applied_path = ''@'' and c_synonym_cd=''N'' and lower(c_operator) in (''in'', ''='') and lower(c_tablename) in (''patient_dimension'', ''visit_dimension'') ';
execute immediate sqlstr;

for rec in e
LOOP
    DBMS_OUTPUT.PUT_LINE(rec.c_fullname);
	if lower(rec.c_operator) = 'in' THEN dimcode := '('||rec.c_dimcode||')';
	elsif lower(rec.c_operator) = '=' THEN dimcode := ''||replace(rec.c_dimcode,'','''')||'';
    END IF;

	sqlstr:='update ontInOperator set numpats =  (select count(distinct(patient_num)) from observation_fact '
                ||' where '||rec.c_facttablecolumn||' in (select '||rec.c_facttablecolumn||' from '||rec.c_tablename||' where '||rec.c_columnname||' ' ||rec.c_operator||' ' ||dimcode||' ))'
            ||' where c_fullname = '''||rec.c_fullname||''' and numpats is null';
    DBMS_OUTPUT.PUT_LINE(sqlstr);
    EXECUTE IMMEDIATE sqlstr;
END LOOP rec;

    -- Save the summary level of the counts -- assumes there are no categorical overlaps in dimcode defn!
    update ctsa_qim set c_totalnum=
    (select sum(o.numpats) c_totalnum from (select distinct * from ontinoperator) o inner join ctsa_qim q on o.c_fullname like q.c_fullname||'%' 
        where q.c_fullname=ctsa_qim.c_fullname)
   WHERE EXISTS
    (select q.c_fullname from (select distinct * from ontinoperator) o inner join ctsa_qim q on o.c_fullname like q.c_fullname||'%' where q.c_fullname=ctsa_qim.c_fullname);


-- Update totals and percents
update ctsa_qim set c_pct=c_totalnum/total where c_mode!='total';
update ctsa_qim set c_totalnum=total where c_mode='total';

END;
/
-- For debugging
select * from SYS.USER_ERRORS where NAME = 'CTSA_QIMCOUNT' and type = 'PROCEDURE'
/
BEGIN
ctsa_qimcount('pcornet_demo');
END;
/
SELECT c_name "Measurement",c_totalnum "Total Distinct Patients",c_pct "Percent of Total Patients" FROM CTSA_QIM WHERE C_SOURCEONTOLOGY_CD='ACT'
/



/* PULLS THE TOP CONCEPT_CD TSV FILES FROM GITHUB INTO A TABLE FOR THE CLIC METRICS */


/* REQUIRED FOR HTTP CALLS SYSTEM STORED PROCEDURES
  
sp_configure 'Ole Automation Procedures', 1;
GO
RECONFIGURE
GO
*/


DROP TABLE IF EXISTS #RESPONSE
DROP TABLE IF EXISTS #URI
GO

CREATE TABLE #URI (VOCABULARY VARCHAR(50), URI VARCHAR(400))
INSERT INTO #URI (VOCABULARY, URI) 
VALUES('ICD10CM','https://raw.githubusercontent.com/ncats/CTSA-Metrics/master/Metrics2022/TOP_DX_ICD10CM.tsv')
,('ICD9CM','https://raw.githubusercontent.com/ncats/CTSA-Metrics/master/Metrics2022/TOP_DX_ICD9CM.tsv')
,('LOINC','https://raw.githubusercontent.com/ncats/CTSA-Metrics/master/Metrics2022/TOP_LAB_LOINC.tsv')
,('RxNorm','https://raw.githubusercontent.com/ncats/CTSA-Metrics/master/Metrics2022/TOP_MED_RXNORM.tsv')
,('CPT4','https://raw.githubusercontent.com/ncats/CTSA-Metrics/master/Metrics2022/TOP_PX_CPT.tsv')
,('CPT4','https://raw.githubusercontent.com/ncats/CTSA-Metrics/master/Metrics2022/TOP_PX_CPT_WITH_VISIT_CPTS.tsv')
,('HCPCS','https://raw.githubusercontent.com/ncats/CTSA-Metrics/master/Metrics2022/TOP_PX_HCPCS.tsv')
,('ICD10PCS','https://raw.githubusercontent.com/ncats/CTSA-Metrics/master/Metrics2022/TOP_PX_ICD10PCS.tsv')
,('ICD9PCS','https://raw.githubusercontent.com/ncats/CTSA-Metrics/master/Metrics2022/TOP_PX_ICD9CM.tsv')
GO

DECLARE @VOCAB VARCHAR(50)
DECLARE @URI VARCHAR(400)

DECLARE CUR CURSOR FOR
SELECT VOCABULARY, URI
FROM #URI



OPEN CUR
FETCH NEXT FROM CUR
  INTO @VOCAB,@URI

DECLARE @tResponse TABLE (responseID int identity(1,1) not null, VOCABULARY VARCHAR(50), ResponseText nvarchar(max))
DECLARE @res int, @token int


WHILE @@FETCH_STATUS = 0
BEGIN

  EXEC @res = sp_OACreate 'MSXML2.ServerXMLHTTP', @token OUT;
  IF @res <> 0 RAISERROR('Unable to open HTTP connection.', 10, 1) WITH NOWAIT;
  
  EXEC @res = sp_OAMethod @token, 'open', NULL, 'GET', @uri, 'false';
  EXEC @res = sp_OAMethod @token, 'send'
  
  INSERT INTO @tResponse(ResponseText)
  EXEC @res = sp_OAMethod @token, 'responseText'

  UPDATE @tResponse SET VOCABULARY = @VOCAB WHERE VOCABULARY IS NULL;
    
  Exec sp_OADestroy @token
  
  FETCH NEXT FROM CUR
  INTO @VOCAB,@URI
END

SELECT * INTO #RESPONSE FROM @tResponse;
CLOSE CUR;
DEALLOCATE CUR;

SELECT * FROM #RESPONSE /* INSPECT -- MAKE SURE THE FILES WERE PULLED FROM GITHUB CORRECTLY */

DROP TABLE IF EXISTS CM22_CONCEPT_CHECKS
GO

;with parse_tsv as (
SELECT i as irow, row_number() over (partition by i order by (select 1)) as icol, VOCABULARY, c.value
FROM (
select row_number() over (order by (select 1)) i, VOCABULARY, r.value
from #response 
  cross apply string_split(ResponseText,char(10))r
)S
  cross apply string_split(value,char(9))c
)
select *
INTO CM22_CONCEPT_CHECKS
from (
select irow
  , vocabulary
  , max(case when icol = 1 then value else null end) as CONCEPT_CD
  , max(case when icol = 2 then value else null end) as UMLS_NAME
  , max(case when icol = 3 then value else null end) as OMOP_CONCEPT_NAME
  , max(case when icol = 4 then value else null end) as NS_CONCEPT_ID
  , max(case when icol = 5 then value else null end) as S_CONCEPT_ID
from parse_tsv
GROUP BY irow, VOCABULARY
)p
where concept_cd not in ('CONCEPT_CD','')
GO


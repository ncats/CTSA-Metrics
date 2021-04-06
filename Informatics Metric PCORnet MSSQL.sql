-- CTSA Common Metrics, Informatics
-- PCORnet Common Data Model 6.0
-- Written for SQL Server

with opioid_meds as (
select 1804028 as rxn_code,'Methadone' as med_type union select
991149 as rxn_code,'Methadone' as med_type union select
991147 as rxn_code,'Methadone' as med_type union select
977330 as rxn_code,'Methadone' as med_type union select
977318 as rxn_code,'Methadone' as med_type union select
977391 as rxn_code,'Methadone' as med_type union select
977336 as rxn_code,'Methadone' as med_type union select
864828 as rxn_code,'Methadone' as med_type union select
864827 as rxn_code,'Methadone' as med_type union select
864826 as rxn_code,'Methadone' as med_type union select
864825 as rxn_code,'Methadone' as med_type union select
864736 as rxn_code,'Methadone' as med_type union select
864719 as rxn_code,'Methadone' as med_type union select
864737 as rxn_code,'Methadone' as med_type union select
864720 as rxn_code,'Methadone' as med_type union select
864718 as rxn_code,'Methadone' as med_type union select
864717 as rxn_code,'Methadone' as med_type union select
864824 as rxn_code,'Methadone' as med_type union select
864823 as rxn_code,'Methadone' as med_type union select
864822 as rxn_code,'Methadone' as med_type union select
864821 as rxn_code,'Methadone' as med_type union select
864811 as rxn_code,'Methadone' as med_type union select
864810 as rxn_code,'Methadone' as med_type union select
864807 as rxn_code,'Methadone' as med_type union select
864806 as rxn_code,'Methadone' as med_type union select
864804 as rxn_code,'Methadone' as med_type union select
864803 as rxn_code,'Methadone' as med_type union select
864801 as rxn_code,'Methadone' as med_type union select
864800 as rxn_code,'Methadone' as med_type union select
864799 as rxn_code,'Methadone' as med_type union select
864798 as rxn_code,'Methadone' as med_type union select
864796 as rxn_code,'Methadone' as med_type union select
864795 as rxn_code,'Methadone' as med_type union select
864794 as rxn_code,'Methadone' as med_type union select
864793 as rxn_code,'Methadone' as med_type union select
864836 as rxn_code,'Methadone' as med_type union select
864835 as rxn_code,'Methadone' as med_type union select
864984 as rxn_code,'Methadone' as med_type union select
864983 as rxn_code,'Methadone' as med_type union select
864789 as rxn_code,'Methadone' as med_type union select
864788 as rxn_code,'Methadone' as med_type union select
864834 as rxn_code,'Methadone' as med_type union select
864833 as rxn_code,'Methadone' as med_type union select
864786 as rxn_code,'Methadone' as med_type union select
864785 as rxn_code,'Methadone' as med_type union select
864771 as rxn_code,'Methadone' as med_type union select
864770 as rxn_code,'Methadone' as med_type union select
864769 as rxn_code,'Methadone' as med_type union select
864768 as rxn_code,'Methadone' as med_type union select
864715 as rxn_code,'Methadone' as med_type union select
864716 as rxn_code,'Methadone' as med_type union select
864714 as rxn_code,'Methadone' as med_type union select
864713 as rxn_code,'Methadone' as med_type union select
864711 as rxn_code,'Methadone' as med_type union select
864707 as rxn_code,'Methadone' as med_type union select
864712 as rxn_code,'Methadone' as med_type union select
864708 as rxn_code,'Methadone' as med_type union select
864706 as rxn_code,'Methadone' as med_type union select
864705 as rxn_code,'Methadone' as med_type union select
864767 as rxn_code,'Methadone' as med_type union select
864766 as rxn_code,'Methadone' as med_type union select
864765 as rxn_code,'Methadone' as med_type union select
864764 as rxn_code,'Methadone' as med_type union select
864832 as rxn_code,'Methadone' as med_type union select
864831 as rxn_code,'Methadone' as med_type union select
864763 as rxn_code,'Methadone' as med_type union select
864762 as rxn_code,'Methadone' as med_type union select
864761 as rxn_code,'Methadone' as med_type union select
864760 as rxn_code,'Methadone' as med_type union select
864830 as rxn_code,'Methadone' as med_type union select
864829 as rxn_code,'Methadone' as med_type union select
864759 as rxn_code,'Methadone' as med_type union select
864758 as rxn_code,'Methadone' as med_type union select
864755 as rxn_code,'Methadone' as med_type union select
864754 as rxn_code,'Methadone' as med_type union select
864753 as rxn_code,'Methadone' as med_type union select
864752 as rxn_code,'Methadone' as med_type union select
864751 as rxn_code,'Methadone' as med_type union select
864750 as rxn_code,'Methadone' as med_type union select
864980 as rxn_code,'Methadone' as med_type union select
864978 as rxn_code,'Methadone' as med_type union select
864749 as rxn_code,'Methadone' as med_type union select
864748 as rxn_code,'Methadone' as med_type union select
378369 as rxn_code,'Methadone' as med_type union select
384598 as rxn_code,'Methadone' as med_type union select
368846 as rxn_code,'Methadone' as med_type union select
368847 as rxn_code,'Methadone' as med_type union select
372808 as rxn_code,'Methadone' as med_type union select
386071 as rxn_code,'Methadone' as med_type union select
363965 as rxn_code,'Methadone' as med_type union select
385937 as rxn_code,'Methadone' as med_type union select
372806 as rxn_code,'Methadone' as med_type union select
362697 as rxn_code,'Methadone' as med_type union select
372807 as rxn_code,'Methadone' as med_type union select
440780 as rxn_code,'Methadone' as med_type union select
2286994 as rxn_code,'Methadone' as med_type union select
485090 as rxn_code,'Methadone' as med_type union select
485089 as rxn_code,'Methadone' as med_type union select
440779 as rxn_code,'Methadone' as med_type union select
414152 as rxn_code,'Methadone' as med_type union select
236913 as rxn_code,'Methadone' as med_type union select
153325 as rxn_code,'Methadone' as med_type union select
152717 as rxn_code,'Methadone' as med_type union select
334991 as rxn_code,'Methadone' as med_type union select
247423 as rxn_code,'Methadone' as med_type union select
32009 as rxn_code,'Methadone' as med_type union select
151094 as rxn_code,'Methadone' as med_type union select
141950 as rxn_code,'Methadone' as med_type union select
1869552 as rxn_code,'Methadone' as med_type union select
1869551 as rxn_code,'Methadone' as med_type union select
1869549 as rxn_code,'Methadone' as med_type union select
1869548 as rxn_code,'Methadone' as med_type union select
6813 as rxn_code,'Methadone' as med_type union select
1990745 as rxn_code,'Methadone' as med_type union select
1990742 as rxn_code,'Methadone' as med_type union select
1990741 as rxn_code,'Methadone' as med_type union select
1819 as rxn_code,'Buprenorphine' as med_type union select
353391 as rxn_code,'Buprenorphine' as med_type union select
1010605 as rxn_code,'Buprenorphine' as med_type union select
1010604 as rxn_code,'Buprenorphine' as med_type union select
1010606 as rxn_code,'Buprenorphine' as med_type union select
378762 as rxn_code,'Buprenorphine' as med_type union select
351267 as rxn_code,'Buprenorphine' as med_type union select
371161 as rxn_code,'Buprenorphine' as med_type union select
351265 as rxn_code,'Buprenorphine' as med_type union select
1010607 as rxn_code,'Buprenorphine' as med_type union select
1010609 as rxn_code,'Buprenorphine' as med_type union select
353390 as rxn_code,'Buprenorphine' as med_type union select
1806212 as rxn_code,'Buprenorphine' as med_type union select
1806214 as rxn_code,'Buprenorphine' as med_type union select
1010601 as rxn_code,'Buprenorphine' as med_type union select
1010600 as rxn_code,'Buprenorphine' as med_type union select
1010603 as rxn_code,'Buprenorphine' as med_type union select
1431079 as rxn_code,'Buprenorphine' as med_type union select
1431099 as rxn_code,'Buprenorphine' as med_type union select
1431102 as rxn_code,'Buprenorphine' as med_type union select
1431104 as rxn_code,'Buprenorphine' as med_type union select
1431103 as rxn_code,'Buprenorphine' as med_type union select
904869 as rxn_code,'Buprenorphine' as med_type union select
1359657 as rxn_code,'Buprenorphine' as med_type union select
1360440 as rxn_code,'Buprenorphine' as med_type union select
904872 as rxn_code,'Buprenorphine' as med_type union select
351266 as rxn_code,'Buprenorphine' as med_type union select
904870 as rxn_code,'Buprenorphine' as med_type union select
904874 as rxn_code,'Buprenorphine' as med_type union select
904875 as rxn_code,'Buprenorphine' as med_type union select
1360458 as rxn_code,'Buprenorphine' as med_type union select
351264 as rxn_code,'Buprenorphine' as med_type union select
904879 as rxn_code,'Buprenorphine' as med_type union select
1359526 as rxn_code,'Buprenorphine' as med_type union select
1360516 as rxn_code,'Buprenorphine' as med_type union select
904877 as rxn_code,'Buprenorphine' as med_type union select
904876 as rxn_code,'Buprenorphine' as med_type union select
1542389 as rxn_code,'Buprenorphine' as med_type union select
904878 as rxn_code,'Buprenorphine' as med_type union select
1307054 as rxn_code,'Buprenorphine' as med_type union select
1307056 as rxn_code,'Buprenorphine' as med_type union select
1307058 as rxn_code,'Buprenorphine' as med_type union select
1307057 as rxn_code,'Buprenorphine' as med_type union select
1307059 as rxn_code,'Buprenorphine' as med_type union select
1307061 as rxn_code,'Buprenorphine' as med_type union select
1307063 as rxn_code,'Buprenorphine' as med_type union select
1307062 as rxn_code,'Buprenorphine' as med_type union select
1360504 as rxn_code,'Buprenorphine' as med_type union select
904881 as rxn_code,'Buprenorphine' as med_type union select
1010608 as rxn_code,'Buprenorphine' as med_type union select
904880 as rxn_code,'Buprenorphine' as med_type union select
904882 as rxn_code,'Buprenorphine' as med_type union select
1797647 as rxn_code,'Buprenorphine' as med_type union select
1797650 as rxn_code,'Buprenorphine' as med_type union select
1797649 as rxn_code,'Buprenorphine' as med_type union select
1432968 as rxn_code,'Buprenorphine' as med_type union select
1432972 as rxn_code,'Buprenorphine' as med_type union select
1432969 as rxn_code,'Buprenorphine' as med_type union select
384593 as rxn_code,'Buprenorphine' as med_type union select
1432973 as rxn_code,'Buprenorphine' as med_type union select
1432970 as rxn_code,'Buprenorphine' as med_type union select
1432971 as rxn_code,'Buprenorphine' as med_type union select
393330 as rxn_code,'Buprenorphine' as med_type union select
1359840 as rxn_code,'Buprenorphine' as med_type union select
576376 as rxn_code,'Buprenorphine' as med_type union select
404414 as rxn_code,'Buprenorphine' as med_type union select
576375 as rxn_code,'Buprenorphine' as med_type union select
1716056 as rxn_code,'Buprenorphine' as med_type union select
1716060 as rxn_code,'Buprenorphine' as med_type union select
1542393 as rxn_code,'Buprenorphine' as med_type union select
1597571 as rxn_code,'Buprenorphine' as med_type union select
1597573 as rxn_code,'Buprenorphine' as med_type union select
1597575 as rxn_code,'Buprenorphine' as med_type union select
1597574 as rxn_code,'Buprenorphine' as med_type union select
1544849 as rxn_code,'Buprenorphine' as med_type union select
1544851 as rxn_code,'Buprenorphine' as med_type union select
1544853 as rxn_code,'Buprenorphine' as med_type union select
1544852 as rxn_code,'Buprenorphine' as med_type union select
1431074 as rxn_code,'Buprenorphine' as med_type union select
1431076 as rxn_code,'Buprenorphine' as med_type union select
1431083 as rxn_code,'Buprenorphine' as med_type union select
1431078 as rxn_code,'Buprenorphine' as med_type union select
1729358 as rxn_code,'Buprenorphine' as med_type union select
1542996 as rxn_code,'Buprenorphine' as med_type union select
1543000 as rxn_code,'Buprenorphine' as med_type union select
1542997 as rxn_code,'Buprenorphine' as med_type union select
404413 as rxn_code,'Buprenorphine' as med_type union select
1543001 as rxn_code,'Buprenorphine' as med_type union select
1542998 as rxn_code,'Buprenorphine' as med_type union select
1542999 as rxn_code,'Buprenorphine' as med_type union select
332698 as rxn_code,'Buprenorphine' as med_type union select
246474 as rxn_code,'Buprenorphine' as med_type union select
333623 as rxn_code,'Buprenorphine' as med_type union select
250426 as rxn_code,'Buprenorphine' as med_type union select
1666336 as rxn_code,'Buprenorphine' as med_type union select
1666338 as rxn_code,'Buprenorphine' as med_type union select
1666385 as rxn_code,'Buprenorphine' as med_type union select
1666384 as rxn_code,'Buprenorphine' as med_type union select
1716054 as rxn_code,'Buprenorphine' as med_type union select
1716057 as rxn_code,'Buprenorphine' as med_type union select
1716063 as rxn_code,'Buprenorphine' as med_type union select
1716059 as rxn_code,'Buprenorphine' as med_type union select
1716064 as rxn_code,'Buprenorphine' as med_type union select
1716065 as rxn_code,'Buprenorphine' as med_type union select
1716067 as rxn_code,'Buprenorphine' as med_type union select
1716066 as rxn_code,'Buprenorphine' as med_type union select
393331 as rxn_code,'Buprenorphine' as med_type union select
1360119 as rxn_code,'Buprenorphine' as med_type union select
388508 as rxn_code,'Buprenorphine' as med_type union select
1597566 as rxn_code,'Buprenorphine' as med_type union select
1597568 as rxn_code,'Buprenorphine' as med_type union select
1597570 as rxn_code,'Buprenorphine' as med_type union select
1597569 as rxn_code,'Buprenorphine' as med_type union select
393329 as rxn_code,'Buprenorphine' as med_type union select
1359977 as rxn_code,'Buprenorphine' as med_type union select
330801 as rxn_code,'Buprenorphine' as med_type union select
1729362 as rxn_code,'Buprenorphine' as med_type union select
1716076 as rxn_code,'Buprenorphine' as med_type union select
1716077 as rxn_code,'Buprenorphine' as med_type union select
1716079 as rxn_code,'Buprenorphine' as med_type union select
1716078 as rxn_code,'Buprenorphine' as med_type union select
1716068 as rxn_code,'Buprenorphine' as med_type union select
1716069 as rxn_code,'Buprenorphine' as med_type union select
1716071 as rxn_code,'Buprenorphine' as med_type union select
1716070 as rxn_code,'Buprenorphine' as med_type union select
238129 as rxn_code,'Buprenorphine' as med_type union select
104958 as rxn_code,'Buprenorphine' as med_type union select
563847 as rxn_code,'Buprenorphine' as med_type union select
1729360 as rxn_code,'Buprenorphine' as med_type union select
1542518 as rxn_code,'Buprenorphine' as med_type union select
1729363 as rxn_code,'Buprenorphine' as med_type union select
566435 as rxn_code,'Buprenorphine' as med_type union select
205533 as rxn_code,'Buprenorphine' as med_type union select
1716072 as rxn_code,'Buprenorphine' as med_type union select
1716073 as rxn_code,'Buprenorphine' as med_type union select
1716075 as rxn_code,'Buprenorphine' as med_type union select
1716074 as rxn_code,'Buprenorphine' as med_type union select
1544854 as rxn_code,'Buprenorphine' as med_type union select
1544856 as rxn_code,'Buprenorphine' as med_type union select
1544855 as rxn_code,'Buprenorphine' as med_type union select
1716084 as rxn_code,'Buprenorphine' as med_type union select
1542386 as rxn_code,'Buprenorphine' as med_type union select
1542390 as rxn_code,'Buprenorphine' as med_type union select
1542396 as rxn_code,'Buprenorphine' as med_type union select
1542392 as rxn_code,'Buprenorphine' as med_type union select
1716086 as rxn_code,'Buprenorphine' as med_type union select
1716090 as rxn_code,'Buprenorphine' as med_type union select
1716087 as rxn_code,'Buprenorphine' as med_type union select
1716080 as rxn_code,'Buprenorphine' as med_type union select
1716081 as rxn_code,'Buprenorphine' as med_type union select
1716083 as rxn_code,'Buprenorphine' as med_type union select
1716082 as rxn_code,'Buprenorphine' as med_type union select
1864410 as rxn_code,'Buprenorphine' as med_type union select
1864412 as rxn_code,'Buprenorphine' as med_type union select
1864414 as rxn_code,'Buprenorphine' as med_type union select
1864413 as rxn_code,'Buprenorphine' as med_type union select
1996183 as rxn_code,'Buprenorphine' as med_type union select
1996182 as rxn_code,'Buprenorphine' as med_type union select
1996190 as rxn_code,'Buprenorphine' as med_type union select
1996191 as rxn_code,'Buprenorphine' as med_type union select
1996186 as rxn_code,'Buprenorphine' as med_type union select
1996187 as rxn_code,'Buprenorphine' as med_type union select
1996192 as rxn_code,'Buprenorphine' as med_type union select
1996193 as rxn_code,'Buprenorphine' as med_type union select
1655032 as rxn_code,'Buprenorphine' as med_type union select
1655033 as rxn_code,'Buprenorphine' as med_type union select
1655031 as rxn_code,'Buprenorphine' as med_type union select
1996184 as rxn_code,'Buprenorphine' as med_type union select
1996189 as rxn_code,'Buprenorphine' as med_type union select
379112 as rxn_code,'Buprenorphine' as med_type union select
1797655 as rxn_code,'Buprenorphine' as med_type union select
1797652 as rxn_code,'Buprenorphine' as med_type union select
1797653 as rxn_code,'Buprenorphine' as med_type union select
388507 as rxn_code,'Buprenorphine' as med_type union select
388506 as rxn_code,'Buprenorphine' as med_type union select
2269593 as rxn_code,'Buprenorphine' as med_type union select
2269744 as rxn_code,'Buprenorphine' as med_type union select
2269595 as rxn_code,'Buprenorphine' as med_type union select
104957 as rxn_code,'Buprenorphine' as med_type union select
563846 as rxn_code,'Buprenorphine' as med_type union select
1594649 as rxn_code,'Buprenorphine' as med_type union select
1594650 as rxn_code,'Buprenorphine' as med_type union select
1594655 as rxn_code,'Buprenorphine' as med_type union select
1594652 as rxn_code,'Buprenorphine' as med_type union select
2058256 as rxn_code,'Buprenorphine' as med_type union select
2058257 as rxn_code,'Buprenorphine' as med_type union select
2106368 as rxn_code,'Buprenorphine' as med_type union select
2106364 as rxn_code,'Buprenorphine' as med_type union select
1594653 as rxn_code,'Buprenorphine' as med_type union select
1488633 as rxn_code,'Buprenorphine' as med_type union select
1488637 as rxn_code,'Buprenorphine' as med_type union select
1488632 as rxn_code,'Buprenorphine' as med_type union select
1488634 as rxn_code,'Buprenorphine' as med_type union select
1488639 as rxn_code,'Buprenorphine' as med_type union select
1488636 as rxn_code,'Buprenorphine' as med_type 
),

-- here for performance reasons
rx_subset as (
SELECT p.*
FROM PRESCRIBING p JOIN opioid_meds om ON p.RXNORM_CUI = om.rxn_code
WHERE p.RX_ORDER_DATE between '1/1/2016' and '12/31/2020'
),

-- here for performance reasons
dx_subset as (
SELECT dx.PATID, dx.DX as dx, dx.ADMIT_DATE as dxDate
FROM DIAGNOSIS dx 
WHERE dx.DX LIKE 'F11%' and dx.ADMIT_DATE between '1/1/2016' and '12/31/2020'

UNION

SELECT cond.PATID, cond.CONDITION as dx, cond.REPORT_DATE as dxDate
FROM CONDITION cond 
WHERE cond.CONDITION LIKE 'F11%' and cond.REPORT_DATE between '1/1/2016' and '12/31/2020'
)

--data model
select
   'data_model' as description,
   1 as one_year,
   1 as five_year
   
UNION
   
-- total encounters
select 
    'total_encounters' as description,
    (select count(*) from ENCOUNTER enc1y where enc1y.ENC_TYPE NOT IN ('NI','UN') and enc1y.ADMIT_DATE between '1/1/2020' and '12/31/2020') as one_year,
    (select count(*) from ENCOUNTER enc5y where enc5y.ENC_TYPE NOT IN ('NI','UN') and enc5y.ADMIT_DATE between '1/1/2016' and '12/31/2020') as five_year

UNION

-- total patients
select 
    'total_patients' as description,
    (select count(distinct dem.PATID) from ENCOUNTER enc1y JOIN DEMOGRAPHIC dem ON enc1y.PATID = dem.PATID 
        where enc1y.ENC_TYPE NOT IN ('NI','UN') and enc1y.ADMIT_DATE between '1/1/2020' and '12/31/2020') as one_year,
    (select count(distinct dem.PATID) from ENCOUNTER enc5y JOIN DEMOGRAPHIC dem ON enc5y.PATID = dem.PATID 
        where enc5y.ENC_TYPE NOT IN ('NI','UN') and enc5y.ADMIT_DATE between '1/1/2016' and '12/31/2020') as five_year

UNION

-- patients with age > 12
select 
    'total_pt_gt_12' as description,
    (select count(distinct dem.PATID) from ENCOUNTER enc1y JOIN DEMOGRAPHIC dem ON enc1y.PATID = dem.PATID 
        where enc1y.ENC_TYPE NOT IN ('NI','UN') and enc1y.ADMIT_DATE between '1/1/2020' and '12/31/2020'
        and (datediff(day,dem.BIRTH_DATE,enc1y.ADMIT_DATE)/365.25) > 12) as one_year,
    (select count(distinct dem.PATID) from ENCOUNTER enc5y JOIN DEMOGRAPHIC dem ON enc5y.PATID = dem.PATID 
        where enc5y.ENC_TYPE NOT IN ('NI','UN') and enc5y.ADMIT_DATE between '1/1/2016' and '12/31/2020'
        and (datediff(day,dem.BIRTH_DATE,enc5y.ADMIT_DATE)/365.25) > 12) as five_year

UNION

-- patients for whom age can be calculated
select 
    'unique_pt_with_age' as description,
    (select count(distinct dem.PATID) from ENCOUNTER enc1y JOIN DEMOGRAPHIC dem ON enc1y.PATID = dem.PATID 
        where enc1y.ENC_TYPE NOT IN ('NI','UN') and enc1y.ADMIT_DATE between '1/1/2020' and '12/31/2020'
        and dem.BIRTH_DATE is not null) as one_year,
    (select count(distinct dem.PATID) from ENCOUNTER enc5y JOIN DEMOGRAPHIC dem ON enc5y.PATID = dem.PATID 
        where enc5y.ENC_TYPE NOT IN ('NI','UN') and enc5y.ADMIT_DATE between '1/1/2016' and '12/31/2020'
        and dem.BIRTH_DATE is not null) as five_year

UNION

-- patients with age < 0
select 
    'unique_pt_birthdate_in_future' as description,
    (select count(distinct dem.PATID) from ENCOUNTER enc1y JOIN DEMOGRAPHIC dem ON enc1y.PATID = dem.PATID 
        where enc1y.ENC_TYPE NOT IN ('NI','UN') and enc1y.ADMIT_DATE between '1/1/2020' and '12/31/2020'
        and dem.BIRTH_DATE > '12/31/2021') as one_year,
    (select count(distinct dem.PATID) from ENCOUNTER enc5y JOIN DEMOGRAPHIC dem ON enc5y.PATID = dem.PATID 
        where enc5y.ENC_TYPE NOT IN ('NI','UN') and enc5y.ADMIT_DATE between '1/1/2016' and '12/31/2020'
        and dem.BIRTH_DATE > '12/31/2021') as five_year

UNION

-- patients with age > 120 
select 
    'unique_pt_age_over_120' as description,
    (select count(distinct dem.PATID) from ENCOUNTER enc1y 
        JOIN DEMOGRAPHIC dem ON enc1y.PATID = dem.PATID 
        LEFT JOIN DEATH dt ON enc1y.PATID = dt.PATID
        where enc1y.ENC_TYPE NOT IN ('NI','UN') and enc1y.ADMIT_DATE between '1/1/2020' and '12/31/2020'
        and 120 < case when dt.DEATH_DATE is null then datediff(day,dem.BIRTH_DATE,'12/31/2020')/365.25
                else datediff(day,dem.BIRTH_DATE,dt.DEATH_DATE)/365.25 end) as one_year,
    (select count(distinct dem.PATID) from ENCOUNTER enc5y 
        JOIN DEMOGRAPHIC dem ON enc5y.PATID = dem.PATID 
        LEFT JOIN DEATH dt ON enc5y.PATID = dt.PATID
        where enc5y.ENC_TYPE NOT IN ('NI','UN') and enc5y.ADMIT_DATE between '1/1/2016' and '12/31/2020'
        and 120 < case when dt.DEATH_DATE is null then datediff(day,dem.BIRTH_DATE,'12/31/2020')/365.25
                else datediff(day,dem.BIRTH_DATE,dt.DEATH_DATE)/365.25 end) as five_year

UNION

-- patients with known gender
select 
    'unique_pt_with_gender' as description,
    (select count(distinct dem.PATID) from ENCOUNTER enc1y JOIN DEMOGRAPHIC dem ON enc1y.PATID = dem.PATID 
        where enc1y.ENC_TYPE NOT IN ('NI','UN') and enc1y.ADMIT_DATE between '1/1/2020' and '12/31/2020'
        and dem.SEX NOT IN ('NI','UN') and dem.SEX is not null) as one_year,
    (select count(distinct dem.PATID) from ENCOUNTER enc5y JOIN DEMOGRAPHIC dem ON enc5y.PATID = dem.PATID 
        where enc5y.ENC_TYPE NOT IN ('NI','UN') and enc5y.ADMIT_DATE between '1/1/2016' and '12/31/2020'
        and dem.SEX NOT IN ('NI','UN') and dem.SEX is not null) as five_year

UNION

-- patients with at least one LOINC
select 
    'unique_pt_loinc' as description,
    (select count(distinct lb1y.PATID) from LAB_RESULT_CM lb1y where lb1y.LAB_LOINC is not null and lb1y.RESULT_DATE
        between '1/1/2020' and '12/31/2020') as one_year,
    (select count(distinct lb5y.PATID) from LAB_RESULT_CM lb5y where lb5y.LAB_LOINC is not null and lb5y.RESULT_DATE
        between '1/1/2016' and '12/31/2020') as five_year

UNION

-- encounters with at least one LOINC
select 
    'unique_enc_loinc' as description,
    (select count(distinct lb1y.ENCOUNTERID) from LAB_RESULT_CM lb1y where lb1y.LAB_LOINC is not null and lb1y.RESULT_DATE
        between '1/1/2020' and '12/31/2020') as one_year,
    (select count(distinct lb5y.ENCOUNTERID) from LAB_RESULT_CM lb5y where lb5y.LAB_LOINC is not null and lb5y.RESULT_DATE
        between '1/1/2016' and '12/31/2020') as five_year

UNION

-- encounters with at least one rxnorm or ndc
-- assuming that DISPENSING does not contain medications that are not in PRESCRIBING
select 
    'unique_enc_med_rxnorm' as description,
    (select count(*) from (select med1y.ENCOUNTERID from PRESCRIBING med1y WHERE med1y.RXNORM_CUI is not null and med1y.RX_ORDER_DATE 
        between '1/1/2020' and '12/31/2020'
     UNION
     select med1yad.ENCOUNTERID from MED_ADMIN med1yad WHERE med1yad.MEDADMIN_TYPE IN ('ND','RX') and med1yad.MEDADMIN_START_DATE 
        between '1/1/2020' and '12/31/2020')) as one_year,
        
    (select count(*) from (select med5y.ENCOUNTERID from PRESCRIBING med5y WHERE med5y.RXNORM_CUI is not null and med5y.RX_ORDER_DATE 
        between '1/1/2016' and '12/31/2020'
     UNION
     select med5yad.ENCOUNTERID from MED_ADMIN med5yad WHERE med5yad.MEDADMIN_TYPE IN ('ND','RX') and med5yad.MEDADMIN_START_DATE 
        between '1/1/2016' and '12/31/2020')) as five_year

UNION

-- patients with at least one rxnorm or ndc
-- assuming that DISPENSING does not contain medications that are not in PRESCRIBING
select 
    'unique_pt_med_rxnorm' as description,
    (select count(*) from (select med1y.PATID from PRESCRIBING med1y WHERE med1y.RXNORM_CUI is not null and med1y.RX_ORDER_DATE 
        between '1/1/2020' and '12/31/2020'
     UNION
     select med1yad.PATID from MED_ADMIN med1yad WHERE med1yad.MEDADMIN_TYPE IN ('ND','RX') and med1yad.MEDADMIN_START_DATE 
        between '1/1/2020' and '12/31/2020')) as one_year,
        
    (select count(*) from (select med5y.PATID from PRESCRIBING med5y WHERE med5y.RXNORM_CUI is not null and med5y.RX_ORDER_DATE 
        between '1/1/2016' and '12/31/2020'
     UNION
     select med5yad.PATID from MED_ADMIN med5yad WHERE med5yad.MEDADMIN_TYPE IN ('ND','RX') and med5yad.MEDADMIN_START_DATE 
        between '1/1/2016' and '12/31/2020')) as five_year

UNION

-- patients with at least one ICD dx code
select 
    'unique_pt_icd_dx' as description,
    (select count(*) from (select dx1y.PATID from DIAGNOSIS dx1y WHERE dx1y.DX_TYPE IN ('09','10') and dx1y.ADMIT_DATE 
        between '1/1/2020' and '12/31/2020'
     UNION
     select con1y.PATID from CONDITION con1y WHERE con1y.CONDITION_TYPE IN ('09','10') and con1y.REPORT_DATE 
        between '1/1/2020' and '12/31/2020')) as one_year,
        
    (select count(*) from (select dx5y.PATID from DIAGNOSIS dx5y WHERE dx5y.DX_TYPE IN ('09','10') and dx5y.ADMIT_DATE 
        between '1/1/2016' and '12/31/2020'
     UNION
     select con5y.PATID from CONDITION con5y WHERE con5y.CONDITION_TYPE IN ('09','10') and con5y.REPORT_DATE 
        between '1/1/2016' and '12/31/2020')) as five_year

UNION

-- encounters with at least one ICD dx code
select 
    'unique_enc_icd_dx' as description,
    (select count(*) from (select dx1y.ENCOUNTERID from DIAGNOSIS dx1y WHERE dx1y.DX_TYPE IN ('09','10') and dx1y.ADMIT_DATE 
        between '1/1/2020' and '12/31/2020'
     UNION
     select con1y.ENCOUNTERID from CONDITION con1y WHERE con1y.CONDITION_TYPE IN ('09','10') and con1y.REPORT_DATE 
        between '1/1/2020' and '12/31/2020')) as one_year,
        
    (select count(*) from (select dx5y.ENCOUNTERID from DIAGNOSIS dx5y WHERE dx5y.DX_TYPE IN ('09','10') and dx5y.ADMIT_DATE 
        between '1/1/2016' and '12/31/2020'
     UNION
     select con5y.ENCOUNTERID from CONDITION con5y WHERE con5y.CONDITION_TYPE IN ('09','10') and con5y.REPORT_DATE 
        between '1/1/2016' and '12/31/2020')) as five_year

UNION

-- patients with at least one SNOMED dx code
select 
    'unique_pt_snomed_dx' as description,
    (select count(*) from (select dx1y.PATID from DIAGNOSIS dx1y WHERE dx1y.DX_TYPE = 'SM' and dx1y.ADMIT_DATE 
        between '1/1/2020' and '12/31/2020'
     UNION
     select con1y.PATID from CONDITION con1y WHERE con1y.CONDITION_TYPE = 'SM' and con1y.REPORT_DATE 
        between '1/1/2020' and '12/31/2020')) as one_year,
        
    (select count(*) from (select dx5y.PATID from DIAGNOSIS dx5y WHERE dx5y.DX_TYPE = 'SM' and dx5y.ADMIT_DATE 
        between '1/1/2016' and '12/31/2020'
     UNION
     select con5y.PATID from CONDITION con5y WHERE con5y.CONDITION_TYPE = 'SM' and con5y.REPORT_DATE 
        between '1/1/2016' and '12/31/2020')) as five_year

UNION

-- encounters with at least one SNOMED dx code
select 
    'unique_enc_snomed_dx' as description,
    (select count(*) from (select dx1y.ENCOUNTERID from DIAGNOSIS dx1y WHERE dx1y.DX_TYPE = 'SM' and dx1y.ADMIT_DATE 
        between '1/1/2020' and '12/31/2020'
     UNION
     select con1y.ENCOUNTERID from CONDITION con1y WHERE con1y.CONDITION_TYPE = 'SM' and con1y.REPORT_DATE 
        between '1/1/2020' and '12/31/2020')) as one_year,
        
    (select count(*) from (select dx5y.ENCOUNTERID from DIAGNOSIS dx5y WHERE dx5y.DX_TYPE = 'SM' and dx5y.ADMIT_DATE 
        between '1/1/2016' and '12/31/2020'
     UNION
     select con5y.ENCOUNTERID from CONDITION con5y WHERE con5y.CONDITION_TYPE = 'SM' and con5y.REPORT_DATE 
        between '1/1/2016' and '12/31/2020')) as five_year

UNION

-- patients with at least one ICD procedure code
select 
    'uniq_pt_icd_proc' as description,
    (select count(distinct px1y.PATID) from PROCEDURES px1y WHERE px1y.PX_TYPE IN ('09','10') and px1y.ADMIT_DATE 
        between '1/1/2020' and '12/31/2020') as one_year,
    (select count(distinct px5y.PATID) from PROCEDURES px5y WHERE px5y.PX_TYPE IN ('09','10') and px5y.ADMIT_DATE 
        between '1/1/2016' and '12/31/2020') as five_year

UNION

-- encounters with at least one ICD procedure code
select 
    'uniq_enc_icd_proc' as description,
    (select count(distinct px1y.ENCOUNTERID) from PROCEDURES px1y WHERE px1y.PX_TYPE IN ('09','10') and px1y.ADMIT_DATE 
        between '1/1/2020' and '12/31/2020') as one_year,
    (select count(distinct px5y.ENCOUNTERID) from PROCEDURES px5y WHERE px5y.PX_TYPE IN ('09','10') and px5y.ADMIT_DATE 
        between '1/1/2016' and '12/31/2020') as five_year

UNION

-- patients with at least one CPT procedure code
select 
    'uniq_pt_cpt' as description,
    (select count(distinct px1y.PATID) from PROCEDURES px1y WHERE px1y.PX_TYPE = 'CH' and px1y.ADMIT_DATE 
        between '1/1/2020' and '12/31/2020') as one_year,
    (select count(distinct px5y.PATID) from PROCEDURES px5y WHERE px5y.PX_TYPE = 'CH' and px5y.ADMIT_DATE 
        between '1/1/2016' and '12/31/2020') as five_year

UNION

-- encounters with at least one CPT procedure code
select 
    'uniq_enc_cpt' as description,
    (select count(distinct px1y.ENCOUNTERID) from PROCEDURES px1y WHERE px1y.PX_TYPE = 'CH' and px1y.ADMIT_DATE 
        between '1/1/2020' and '12/31/2020') as one_year,
    (select count(distinct px5y.ENCOUNTERID) from PROCEDURES px5y WHERE px5y.PX_TYPE = 'CH' and px5y.ADMIT_DATE 
        between '1/1/2016' and '12/31/2020') as five_year

UNION

-- patients with a SNOMED proc code: NOT SUPPORTED BY PCORNET
select 
    'uniq_pt_snomed_proc' as description,
    0 as one_year,
    0 as five_year

UNION

-- encounters with a SNOMED proc code: NOT SUPPORTED BY PCORNET
select 
    'uniq_enc_snomed_proc' as description,
    0 as one_year,
    0 as five_year

UNION

-- patients with a free text note: NOT SUPPORTED BY PCORNET
select 
    'uniq_pt_note' as description,
    0 as one_year,
    0 as five_year

UNION

-- encounters with a free text note: NOT SUPPORTED BY PCORNET
select 
    'uniq_enc_note' as description,
    0 as one_year,
    0 as five_year

UNION
			   
-- does this data model support nlp
select 
    'nlp_any' as description,
    NULL as one_year,
    NULL as five_year

UNION			   

-- encounters with at least one vital sign
-- will need to be changed when PCORnet drops the VITAL table.
select 
    'uniq_enc_vital_sign' as description,
    (select count(distinct vit1y.ENCOUNTERID) from VITAL vit1y WHERE vit1y.MEASURE_DATE between '1/1/2020' and '12/31/2020') as one_year,
    (select count(distinct vit5y.ENCOUNTERID) from VITAL vit5y WHERE vit5y.MEASURE_DATE between '1/1/2016' and '12/31/2020') as five_year

UNION

-- patients > 12 with at least one smoking code
select 
    'uniq_pt_smoking' as description,
    (select count(distinct vit1y.PATID) from VITAL vit1y JOIN DEMOGRAPHIC d ON vit1y.PATID = d.PATID 
        WHERE vit1y.MEASURE_DATE between '1/1/2020' and '12/31/2020' 
        and SMOKING is not null and SMOKING not in ('NI','UN') and (datediff(day,d.BIRTH_DATE,vit1y.MEASURE_DATE)/365.25) > 12) as one_year,
    (select count(distinct vit5y.PATID) from VITAL vit5y JOIN DEMOGRAPHIC d ON vit5y.PATID = d.PATID 
        WHERE vit5y.MEASURE_DATE between '1/1/2016' and '12/31/2020'
        and SMOKING is not null and SMOKING not in ('NI','UN') and (datediff(day,d.BIRTH_DATE,vit5y.MEASURE_DATE)/365.25) > 12) as five_year

UNION

-- patients with at least one opioid code
select 
    'uniq_pt_opioid' as description,
    (select count(distinct d.PATID) FROM DEMOGRAPHIC d LEFT JOIN rx_subset p ON d.PATID = p.PATID AND p.RX_ORDER_DATE between '1/1/2020' and '12/31/2020'
        LEFT JOIN dx_subset dx ON d.PATID = dx.PATID AND dx.dxDate between '1/1/2020' and '1/1/2020' 
        WHERE (p.RXNORM_CUI is null AND dx.DX is not null) OR (p.RXNORM_CUI is not null AND dx.DX is null) OR (p.RXNORM_CUI is not null AND dx.DX is not null))
        as one_year,
     (select count(distinct d.PATID) FROM DEMOGRAPHIC d LEFT JOIN rx_subset p ON d.PATID = p.PATID 
        LEFT JOIN dx_subset dx ON d.PATID = dx.PATID 
        WHERE (p.RXNORM_CUI is null AND dx.DX is not null) OR (p.RXNORM_CUI is not null AND dx.DX is null) OR (p.RXNORM_CUI is not null AND dx.DX is not null))
        as five_year

UNION

-- patients with any insurance
select 
    'uniq_pt_any_insurance_value' as description,
    (select count(distinct dem.PATID) from ENCOUNTER enc1y JOIN DEMOGRAPHIC dem ON enc1y.PATID = dem.PATID 
        where enc1y.ADMIT_DATE between '1/1/2020' and '12/31/2020' and 
	        (enc1y.payer_type_primary is not null or enc1y.raw_payer_type_primary is not null 
	            or enc1y.raw_payer_name_primary is not null or enc1y.raw_payer_id_primary is not null)
            and enc1y.payer_type_primary not in ('NI','UN')) as one_year,
    (select count(distinct dem.PATID) from ENCOUNTER enc5y JOIN DEMOGRAPHIC dem ON enc5y.PATID = dem.PATID 
        where enc5y.ADMIT_DATE between '1/1/2016' and '12/31/2020' and 
        (enc5y.payer_type_primary is not null or enc5y.raw_payer_type_primary is not null 
	            or enc5y.raw_payer_name_primary is not null or enc5y.raw_payer_id_primary is not null)
        and enc5y.payer_type_primary not in ('NI','UN')) as five_year

UNION

-- patients with insurance mapped to the PCORnet controlled vocab
select 
    'uniq_pt_insurance_value_set' as description,
    (select count(distinct dem.PATID) from ENCOUNTER enc1y JOIN DEMOGRAPHIC dem ON enc1y.PATID = dem.PATID 
        where enc1y.ADMIT_DATE between '1/1/2020' and '12/31/2020' and enc1y.payer_type_primary is not null
        and enc1y.payer_type_primary not in ('NI','UN')) as one_year,
    (select count(distinct dem.PATID) from ENCOUNTER enc5y JOIN DEMOGRAPHIC dem ON enc5y.PATID = dem.PATID 
        where enc5y.ADMIT_DATE between '1/1/2016' and '12/31/2020' and enc5y.payer_type_primary is not null
        and enc5y.payer_type_primary not in ('NI','UN')) as five_year

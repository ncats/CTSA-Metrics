-- CTSA Common Metrics, Informatics
-- PCORnet Common Data Model 6.0
-- Written for SQL Server

--This takes between 2-3 hours to run


--Set user default_schema to your PCORnet CDM (added by shu@med.umich.edu)
--Please change the USERNAME and the PCORnetCDM_SCHEMA name accordingly:
ALTER USER [USERNAME] WITH DEFAULT_SCHEMA = [PCORnetCDM_SCHEMA];
GO


with opioid_meds as (
select 1804028 as rxn_code,'Methadone' as med_type  union select
991149 as rxn_code,'Methadone' as med_type  union select
991147 as rxn_code,'Methadone' as med_type  union select
977330 as rxn_code,'Methadone' as med_type  union select
977318 as rxn_code,'Methadone' as med_type  union select
977391 as rxn_code,'Methadone' as med_type  union select
977336 as rxn_code,'Methadone' as med_type  union select
864828 as rxn_code,'Methadone' as med_type  union select
864827 as rxn_code,'Methadone' as med_type  union select
864826 as rxn_code,'Methadone' as med_type  union select
864825 as rxn_code,'Methadone' as med_type  union select
864736 as rxn_code,'Methadone' as med_type  union select
864719 as rxn_code,'Methadone' as med_type  union select
864737 as rxn_code,'Methadone' as med_type  union select
864720 as rxn_code,'Methadone' as med_type  union select
864718 as rxn_code,'Methadone' as med_type  union select
864717 as rxn_code,'Methadone' as med_type  union select
864824 as rxn_code,'Methadone' as med_type  union select
864823 as rxn_code,'Methadone' as med_type  union select
864822 as rxn_code,'Methadone' as med_type  union select
864821 as rxn_code,'Methadone' as med_type  union select
864811 as rxn_code,'Methadone' as med_type  union select
864810 as rxn_code,'Methadone' as med_type  union select
864807 as rxn_code,'Methadone' as med_type  union select
864806 as rxn_code,'Methadone' as med_type  union select
864804 as rxn_code,'Methadone' as med_type  union select
864803 as rxn_code,'Methadone' as med_type  union select
864801 as rxn_code,'Methadone' as med_type  union select
864800 as rxn_code,'Methadone' as med_type  union select
864799 as rxn_code,'Methadone' as med_type  union select
864798 as rxn_code,'Methadone' as med_type  union select
864796 as rxn_code,'Methadone' as med_type  union select
864795 as rxn_code,'Methadone' as med_type  union select
864794 as rxn_code,'Methadone' as med_type  union select
864793 as rxn_code,'Methadone' as med_type  union select
864836 as rxn_code,'Methadone' as med_type  union select
864835 as rxn_code,'Methadone' as med_type  union select
864984 as rxn_code,'Methadone' as med_type  union select
864983 as rxn_code,'Methadone' as med_type  union select
864789 as rxn_code,'Methadone' as med_type  union select
864788 as rxn_code,'Methadone' as med_type  union select
864834 as rxn_code,'Methadone' as med_type  union select
864833 as rxn_code,'Methadone' as med_type  union select
864786 as rxn_code,'Methadone' as med_type  union select
864785 as rxn_code,'Methadone' as med_type  union select
864771 as rxn_code,'Methadone' as med_type  union select
864770 as rxn_code,'Methadone' as med_type  union select
864769 as rxn_code,'Methadone' as med_type  union select
864768 as rxn_code,'Methadone' as med_type  union select
864715 as rxn_code,'Methadone' as med_type  union select
864716 as rxn_code,'Methadone' as med_type  union select
864714 as rxn_code,'Methadone' as med_type  union select
864713 as rxn_code,'Methadone' as med_type  union select
864711 as rxn_code,'Methadone' as med_type  union select
864707 as rxn_code,'Methadone' as med_type  union select
864712 as rxn_code,'Methadone' as med_type  union select
864708 as rxn_code,'Methadone' as med_type  union select
864706 as rxn_code,'Methadone' as med_type  union select
864705 as rxn_code,'Methadone' as med_type  union select
864767 as rxn_code,'Methadone' as med_type  union select
864766 as rxn_code,'Methadone' as med_type  union select
864765 as rxn_code,'Methadone' as med_type  union select
864764 as rxn_code,'Methadone' as med_type  union select
864832 as rxn_code,'Methadone' as med_type  union select
864831 as rxn_code,'Methadone' as med_type  union select
864763 as rxn_code,'Methadone' as med_type  union select
864762 as rxn_code,'Methadone' as med_type  union select
864761 as rxn_code,'Methadone' as med_type  union select
864760 as rxn_code,'Methadone' as med_type  union select
864830 as rxn_code,'Methadone' as med_type  union select
864829 as rxn_code,'Methadone' as med_type  union select
864759 as rxn_code,'Methadone' as med_type  union select
864758 as rxn_code,'Methadone' as med_type  union select
864755 as rxn_code,'Methadone' as med_type  union select
864754 as rxn_code,'Methadone' as med_type  union select
864753 as rxn_code,'Methadone' as med_type  union select
864752 as rxn_code,'Methadone' as med_type  union select
864751 as rxn_code,'Methadone' as med_type  union select
864750 as rxn_code,'Methadone' as med_type  union select
864980 as rxn_code,'Methadone' as med_type  union select
864978 as rxn_code,'Methadone' as med_type  union select
864749 as rxn_code,'Methadone' as med_type  union select
864748 as rxn_code,'Methadone' as med_type  union select
378369 as rxn_code,'Methadone' as med_type  union select
384598 as rxn_code,'Methadone' as med_type  union select
368846 as rxn_code,'Methadone' as med_type  union select
368847 as rxn_code,'Methadone' as med_type  union select
372808 as rxn_code,'Methadone' as med_type  union select
386071 as rxn_code,'Methadone' as med_type  union select
363965 as rxn_code,'Methadone' as med_type  union select
385937 as rxn_code,'Methadone' as med_type  union select
372806 as rxn_code,'Methadone' as med_type  union select
362697 as rxn_code,'Methadone' as med_type  union select
372807 as rxn_code,'Methadone' as med_type  union select
440780 as rxn_code,'Methadone' as med_type  union select
2286994 as rxn_code,'Methadone' as med_type  union select
485090 as rxn_code,'Methadone' as med_type  union select
485089 as rxn_code,'Methadone' as med_type  union select
440779 as rxn_code,'Methadone' as med_type  union select
414152 as rxn_code,'Methadone' as med_type  union select
236913 as rxn_code,'Methadone' as med_type  union select
153325 as rxn_code,'Methadone' as med_type  union select
152717 as rxn_code,'Methadone' as med_type  union select
334991 as rxn_code,'Methadone' as med_type  union select
247423 as rxn_code,'Methadone' as med_type  union select
32009 as rxn_code,'Methadone' as med_type  union select
151094 as rxn_code,'Methadone' as med_type  union select
141950 as rxn_code,'Methadone' as med_type  union select
1869552 as rxn_code,'Methadone' as med_type  union select
1869551 as rxn_code,'Methadone' as med_type  union select
1869549 as rxn_code,'Methadone' as med_type  union select
1869548 as rxn_code,'Methadone' as med_type  union select
6813 as rxn_code,'Methadone' as med_type  union select
1990745 as rxn_code,'Methadone' as med_type  union select
1990742 as rxn_code,'Methadone' as med_type  union select
1990741 as rxn_code,'Methadone' as med_type  union select
1819 as rxn_code,'Buprenorphine' as med_type  union select
353391 as rxn_code,'Buprenorphine' as med_type  union select
1010605 as rxn_code,'Buprenorphine' as med_type  union select
1010604 as rxn_code,'Buprenorphine' as med_type  union select
1010606 as rxn_code,'Buprenorphine' as med_type  union select
378762 as rxn_code,'Buprenorphine' as med_type  union select
351267 as rxn_code,'Buprenorphine' as med_type  union select
371161 as rxn_code,'Buprenorphine' as med_type  union select
351265 as rxn_code,'Buprenorphine' as med_type  union select
1010607 as rxn_code,'Buprenorphine' as med_type  union select
1010609 as rxn_code,'Buprenorphine' as med_type  union select
353390 as rxn_code,'Buprenorphine' as med_type  union select
1806212 as rxn_code,'Buprenorphine' as med_type  union select
1806214 as rxn_code,'Buprenorphine' as med_type  union select
1010601 as rxn_code,'Buprenorphine' as med_type  union select
1010600 as rxn_code,'Buprenorphine' as med_type  union select
1010603 as rxn_code,'Buprenorphine' as med_type  union select
1431079 as rxn_code,'Buprenorphine' as med_type  union select
1431099 as rxn_code,'Buprenorphine' as med_type  union select
1431102 as rxn_code,'Buprenorphine' as med_type  union select
1431104 as rxn_code,'Buprenorphine' as med_type  union select
1431103 as rxn_code,'Buprenorphine' as med_type  union select
904869 as rxn_code,'Buprenorphine' as med_type  union select
1359657 as rxn_code,'Buprenorphine' as med_type  union select
1360440 as rxn_code,'Buprenorphine' as med_type  union select
904872 as rxn_code,'Buprenorphine' as med_type  union select
351266 as rxn_code,'Buprenorphine' as med_type  union select
904870 as rxn_code,'Buprenorphine' as med_type  union select
904874 as rxn_code,'Buprenorphine' as med_type  union select
904875 as rxn_code,'Buprenorphine' as med_type  union select
1360458 as rxn_code,'Buprenorphine' as med_type  union select
351264 as rxn_code,'Buprenorphine' as med_type  union select
904879 as rxn_code,'Buprenorphine' as med_type  union select
1359526 as rxn_code,'Buprenorphine' as med_type  union select
1360516 as rxn_code,'Buprenorphine' as med_type  union select
904877 as rxn_code,'Buprenorphine' as med_type  union select
904876 as rxn_code,'Buprenorphine' as med_type  union select
1542389 as rxn_code,'Buprenorphine' as med_type  union select
904878 as rxn_code,'Buprenorphine' as med_type  union select
1307054 as rxn_code,'Buprenorphine' as med_type  union select
1307056 as rxn_code,'Buprenorphine' as med_type  union select
1307058 as rxn_code,'Buprenorphine' as med_type  union select
1307057 as rxn_code,'Buprenorphine' as med_type  union select
1307059 as rxn_code,'Buprenorphine' as med_type  union select
1307061 as rxn_code,'Buprenorphine' as med_type  union select
1307063 as rxn_code,'Buprenorphine' as med_type  union select
1307062 as rxn_code,'Buprenorphine' as med_type  union select
1360504 as rxn_code,'Buprenorphine' as med_type  union select
904881 as rxn_code,'Buprenorphine' as med_type  union select
1010608 as rxn_code,'Buprenorphine' as med_type  union select
904880 as rxn_code,'Buprenorphine' as med_type  union select
904882 as rxn_code,'Buprenorphine' as med_type  union select
1797647 as rxn_code,'Buprenorphine' as med_type  union select
1797650 as rxn_code,'Buprenorphine' as med_type  union select
1797649 as rxn_code,'Buprenorphine' as med_type  union select
1432968 as rxn_code,'Buprenorphine' as med_type  union select
1432972 as rxn_code,'Buprenorphine' as med_type  union select
1432969 as rxn_code,'Buprenorphine' as med_type  union select
384593 as rxn_code,'Buprenorphine' as med_type  union select
1432973 as rxn_code,'Buprenorphine' as med_type  union select
1432970 as rxn_code,'Buprenorphine' as med_type  union select
1432971 as rxn_code,'Buprenorphine' as med_type  union select
393330 as rxn_code,'Buprenorphine' as med_type  union select
1359840 as rxn_code,'Buprenorphine' as med_type  union select
576376 as rxn_code,'Buprenorphine' as med_type  union select
404414 as rxn_code,'Buprenorphine' as med_type  union select
576375 as rxn_code,'Buprenorphine' as med_type  union select
1716056 as rxn_code,'Buprenorphine' as med_type  union select
1716060 as rxn_code,'Buprenorphine' as med_type  union select
1542393 as rxn_code,'Buprenorphine' as med_type  union select
1597571 as rxn_code,'Buprenorphine' as med_type  union select
1597573 as rxn_code,'Buprenorphine' as med_type  union select
1597575 as rxn_code,'Buprenorphine' as med_type  union select
1597574 as rxn_code,'Buprenorphine' as med_type  union select
1544849 as rxn_code,'Buprenorphine' as med_type  union select
1544851 as rxn_code,'Buprenorphine' as med_type  union select
1544853 as rxn_code,'Buprenorphine' as med_type  union select
1544852 as rxn_code,'Buprenorphine' as med_type  union select
1431074 as rxn_code,'Buprenorphine' as med_type  union select
1431076 as rxn_code,'Buprenorphine' as med_type  union select
1431083 as rxn_code,'Buprenorphine' as med_type  union select
1431078 as rxn_code,'Buprenorphine' as med_type  union select
1729358 as rxn_code,'Buprenorphine' as med_type  union select
1542996 as rxn_code,'Buprenorphine' as med_type  union select
1543000 as rxn_code,'Buprenorphine' as med_type  union select
1542997 as rxn_code,'Buprenorphine' as med_type  union select
404413 as rxn_code,'Buprenorphine' as med_type  union select
1543001 as rxn_code,'Buprenorphine' as med_type  union select
1542998 as rxn_code,'Buprenorphine' as med_type  union select
1542999 as rxn_code,'Buprenorphine' as med_type  union select
332698 as rxn_code,'Buprenorphine' as med_type  union select
246474 as rxn_code,'Buprenorphine' as med_type  union select
333623 as rxn_code,'Buprenorphine' as med_type  union select
250426 as rxn_code,'Buprenorphine' as med_type  union select
1666336 as rxn_code,'Buprenorphine' as med_type  union select
1666338 as rxn_code,'Buprenorphine' as med_type  union select
1666385 as rxn_code,'Buprenorphine' as med_type  union select
1666384 as rxn_code,'Buprenorphine' as med_type  union select
1716054 as rxn_code,'Buprenorphine' as med_type  union select
1716057 as rxn_code,'Buprenorphine' as med_type  union select
1716063 as rxn_code,'Buprenorphine' as med_type  union select
1716059 as rxn_code,'Buprenorphine' as med_type  union select
1716064 as rxn_code,'Buprenorphine' as med_type  union select
1716065 as rxn_code,'Buprenorphine' as med_type  union select
1716067 as rxn_code,'Buprenorphine' as med_type  union select
1716066 as rxn_code,'Buprenorphine' as med_type  union select
393331 as rxn_code,'Buprenorphine' as med_type  union select
1360119 as rxn_code,'Buprenorphine' as med_type  union select
388508 as rxn_code,'Buprenorphine' as med_type  union select
1597566 as rxn_code,'Buprenorphine' as med_type  union select
1597568 as rxn_code,'Buprenorphine' as med_type  union select
1597570 as rxn_code,'Buprenorphine' as med_type  union select
1597569 as rxn_code,'Buprenorphine' as med_type  union select
393329 as rxn_code,'Buprenorphine' as med_type  union select
1359977 as rxn_code,'Buprenorphine' as med_type  union select
330801 as rxn_code,'Buprenorphine' as med_type  union select
1729362 as rxn_code,'Buprenorphine' as med_type  union select
1716076 as rxn_code,'Buprenorphine' as med_type  union select
1716077 as rxn_code,'Buprenorphine' as med_type  union select
1716079 as rxn_code,'Buprenorphine' as med_type  union select
1716078 as rxn_code,'Buprenorphine' as med_type  union select
1716068 as rxn_code,'Buprenorphine' as med_type  union select
1716069 as rxn_code,'Buprenorphine' as med_type  union select
1716071 as rxn_code,'Buprenorphine' as med_type  union select
1716070 as rxn_code,'Buprenorphine' as med_type  union select
238129 as rxn_code,'Buprenorphine' as med_type  union select
104958 as rxn_code,'Buprenorphine' as med_type  union select
563847 as rxn_code,'Buprenorphine' as med_type  union select
1729360 as rxn_code,'Buprenorphine' as med_type  union select
1542518 as rxn_code,'Buprenorphine' as med_type  union select
1729363 as rxn_code,'Buprenorphine' as med_type  union select
566435 as rxn_code,'Buprenorphine' as med_type  union select
205533 as rxn_code,'Buprenorphine' as med_type  union select
1716072 as rxn_code,'Buprenorphine' as med_type  union select
1716073 as rxn_code,'Buprenorphine' as med_type  union select
1716075 as rxn_code,'Buprenorphine' as med_type  union select
1716074 as rxn_code,'Buprenorphine' as med_type  union select
1544854 as rxn_code,'Buprenorphine' as med_type  union select
1544856 as rxn_code,'Buprenorphine' as med_type  union select
1544855 as rxn_code,'Buprenorphine' as med_type  union select
1716084 as rxn_code,'Buprenorphine' as med_type  union select
1542386 as rxn_code,'Buprenorphine' as med_type  union select
1542390 as rxn_code,'Buprenorphine' as med_type  union select
1542396 as rxn_code,'Buprenorphine' as med_type  union select
1542392 as rxn_code,'Buprenorphine' as med_type  union select
1716086 as rxn_code,'Buprenorphine' as med_type  union select
1716090 as rxn_code,'Buprenorphine' as med_type  union select
1716087 as rxn_code,'Buprenorphine' as med_type  union select
1716080 as rxn_code,'Buprenorphine' as med_type  union select
1716081 as rxn_code,'Buprenorphine' as med_type  union select
1716083 as rxn_code,'Buprenorphine' as med_type  union select
1716082 as rxn_code,'Buprenorphine' as med_type  union select
1864410 as rxn_code,'Buprenorphine' as med_type  union select
1864412 as rxn_code,'Buprenorphine' as med_type  union select
1864414 as rxn_code,'Buprenorphine' as med_type  union select
1864413 as rxn_code,'Buprenorphine' as med_type  union select
1996183 as rxn_code,'Buprenorphine' as med_type  union select
1996182 as rxn_code,'Buprenorphine' as med_type  union select
1996190 as rxn_code,'Buprenorphine' as med_type  union select
1996191 as rxn_code,'Buprenorphine' as med_type  union select
1996186 as rxn_code,'Buprenorphine' as med_type  union select
1996187 as rxn_code,'Buprenorphine' as med_type  union select
1996192 as rxn_code,'Buprenorphine' as med_type  union select
1996193 as rxn_code,'Buprenorphine' as med_type  union select
1655032 as rxn_code,'Buprenorphine' as med_type  union select
1655033 as rxn_code,'Buprenorphine' as med_type  union select
1655031 as rxn_code,'Buprenorphine' as med_type  union select
1996184 as rxn_code,'Buprenorphine' as med_type  union select
1996189 as rxn_code,'Buprenorphine' as med_type  union select
379112 as rxn_code,'Buprenorphine' as med_type  union select
1797655 as rxn_code,'Buprenorphine' as med_type  union select
1797652 as rxn_code,'Buprenorphine' as med_type  union select
1797653 as rxn_code,'Buprenorphine' as med_type  union select
388507 as rxn_code,'Buprenorphine' as med_type  union select
388506 as rxn_code,'Buprenorphine' as med_type  union select
2269593 as rxn_code,'Buprenorphine' as med_type  union select
2269744 as rxn_code,'Buprenorphine' as med_type  union select
2269595 as rxn_code,'Buprenorphine' as med_type  union select
104957 as rxn_code,'Buprenorphine' as med_type  union select
563846 as rxn_code,'Buprenorphine' as med_type  union select
1594649 as rxn_code,'Buprenorphine' as med_type  union select
1594650 as rxn_code,'Buprenorphine' as med_type  union select
1594655 as rxn_code,'Buprenorphine' as med_type  union select
1594652 as rxn_code,'Buprenorphine' as med_type  union select
2058256 as rxn_code,'Buprenorphine' as med_type  union select
2058257 as rxn_code,'Buprenorphine' as med_type  union select
2106368 as rxn_code,'Buprenorphine' as med_type  union select
2106364 as rxn_code,'Buprenorphine' as med_type  union select
1594653 as rxn_code,'Buprenorphine' as med_type  union select
1488633 as rxn_code,'Buprenorphine' as med_type  union select
1488637 as rxn_code,'Buprenorphine' as med_type  union select
1488632 as rxn_code,'Buprenorphine' as med_type  union select
1488634 as rxn_code,'Buprenorphine' as med_type  union select
1488639 as rxn_code,'Buprenorphine' as med_type  union select
1488636 as rxn_code,'Buprenorphine' as med_type  
),

common_codes as (
SELECT '174.9' as code, 'ICD-9' as type  UNION  
 SELECT '244.9' as code, 'ICD-9' as type  UNION  
 SELECT '250.00' as code, 'ICD-9' as type  UNION  
 SELECT '268.9' as code, 'ICD-9' as type  UNION  
 SELECT '272.0' as code, 'ICD-9' as type  UNION  
 SELECT '272.4' as code, 'ICD-9' as type  UNION  
 SELECT '278.00' as code, 'ICD-9' as type  UNION  
 SELECT '285.9' as code, 'ICD-9' as type  UNION  
 SELECT '300.00' as code, 'ICD-9' as type  UNION  
 SELECT '305.1' as code, 'ICD-9' as type  UNION  
 SELECT '311' as code, 'ICD-9' as type  UNION  
 SELECT '327.23' as code, 'ICD-9' as type  UNION  
 SELECT '401.1' as code, 'ICD-9' as type  UNION  
 SELECT '401.9' as code, 'ICD-9' as type  UNION  
 SELECT '414.00' as code, 'ICD-9' as type  UNION  
 SELECT '414.01' as code, 'ICD-9' as type  UNION  
 SELECT '427.31' as code, 'ICD-9' as type  UNION  
 SELECT '428.0' as code, 'ICD-9' as type  UNION  
 SELECT '462' as code, 'ICD-9' as type  UNION  
 SELECT '465.9' as code, 'ICD-9' as type  UNION  
 SELECT '477.9' as code, 'ICD-9' as type  UNION  
 SELECT '493.90' as code, 'ICD-9' as type  UNION  
 SELECT '496' as code, 'ICD-9' as type  UNION  
 SELECT '530.81' as code, 'ICD-9' as type  UNION  
 SELECT '599.0' as code, 'ICD-9' as type  UNION  
 SELECT '715.90' as code, 'ICD-9' as type  UNION  
 SELECT '719.46' as code, 'ICD-9' as type  UNION  
 SELECT '724.2' as code, 'ICD-9' as type  UNION  
 SELECT '724.5' as code, 'ICD-9' as type  UNION  
 SELECT '729.1' as code, 'ICD-9' as type  UNION  
 SELECT '729.5' as code, 'ICD-9' as type  UNION  
 SELECT '733.00' as code, 'ICD-9' as type  UNION  
 SELECT '780.79' as code, 'ICD-9' as type  UNION  
 SELECT '784.0' as code, 'ICD-9' as type  UNION  
 SELECT '786.05' as code, 'ICD-9' as type  UNION  
 SELECT '786.2' as code, 'ICD-9' as type  UNION  
 SELECT '786.50' as code, 'ICD-9' as type  UNION  
 SELECT '789.00' as code, 'ICD-9' as type  UNION  
 SELECT 'V03.82' as code, 'ICD-9' as type  UNION  
 SELECT 'V04.81' as code, 'ICD-9' as type  UNION  
 SELECT 'V06.1' as code, 'ICD-9' as type  UNION  
 SELECT 'V10.3' as code, 'ICD-9' as type  UNION  
 SELECT 'V20.2' as code, 'ICD-9' as type  UNION  
 SELECT 'V22.0' as code, 'ICD-9' as type  UNION  
 SELECT 'V22.0' as code, 'ICD-9' as type  UNION  
 SELECT 'V22.1' as code, 'ICD-9' as type  UNION  
 SELECT 'V22.1' as code, 'ICD-9' as type  UNION  
 SELECT 'V43.3' as code, 'ICD-9' as type  UNION  
 SELECT 'V45.89' as code, 'ICD-9' as type  UNION  
 SELECT 'V54.89' as code, 'ICD-9' as type  UNION  
 SELECT 'V58.0' as code, 'ICD-9' as type  UNION  
 SELECT 'V58.11' as code, 'ICD-9' as type  UNION  
 SELECT 'V58.61' as code, 'ICD-9' as type  UNION  
 SELECT 'V58.69' as code, 'ICD-9' as type  UNION  
 SELECT 'V67.09' as code, 'ICD-9' as type  UNION  
 SELECT 'V70.0' as code, 'ICD-9' as type  UNION  
 SELECT 'V72.31' as code, 'ICD-9' as type  UNION  
 SELECT 'V76.12' as code, 'ICD-9' as type  UNION  
 SELECT 'V76.2' as code, 'ICD-9' as type  UNION 
 SELECT 'D64.9' as code, 'ICD-10' as type  UNION  
 SELECT 'E03.9' as code, 'ICD-10' as type  UNION  
 SELECT 'E11.65' as code, 'ICD-10' as type  UNION  
 SELECT 'E11.65' as code, 'ICD-10' as type  UNION  
 SELECT 'E11.9' as code, 'ICD-10' as type  UNION  
 SELECT 'E55.9' as code, 'ICD-10' as type  UNION  
 SELECT 'E66.01' as code, 'ICD-10' as type  UNION  
 SELECT 'E66.9' as code, 'ICD-10' as type  UNION  
 SELECT 'E78.00' as code, 'ICD-10' as type  UNION  
 SELECT 'E78.2' as code, 'ICD-10' as type  UNION  
 SELECT 'E78.5' as code, 'ICD-10' as type  UNION  
 SELECT 'F17.200' as code, 'ICD-10' as type  UNION  
 SELECT 'F17.210' as code, 'ICD-10' as type  UNION  
 SELECT 'F17.210' as code, 'ICD-10' as type  UNION  
 SELECT 'F32.9' as code, 'ICD-10' as type  UNION  
 SELECT 'F41.1' as code, 'ICD-10' as type  UNION  
 SELECT 'F41.9' as code, 'ICD-10' as type  UNION  
 SELECT 'G47.33' as code, 'ICD-10' as type  UNION  
 SELECT 'G89.29' as code, 'ICD-10' as type  UNION  
 SELECT 'I10' as code, 'ICD-10' as type  UNION  
 SELECT 'I25.10' as code, 'ICD-10' as type  UNION  
 SELECT 'I48.0' as code, 'ICD-10' as type  UNION  
 SELECT 'I48.2' as code, 'ICD-10' as type  UNION  
 SELECT 'I48.91' as code, 'ICD-10' as type  UNION  
 SELECT 'J02.9' as code, 'ICD-10' as type  UNION  
 SELECT 'J06.9' as code, 'ICD-10' as type  UNION  
 SELECT 'J44.9' as code, 'ICD-10' as type  UNION  
 SELECT 'J45.909' as code, 'ICD-10' as type  UNION  
 SELECT 'K21.9' as code, 'ICD-10' as type  UNION  
 SELECT 'M19.90' as code, 'ICD-10' as type  UNION  
 SELECT 'M25.561' as code, 'ICD-10' as type  UNION  
 SELECT 'M25.562' as code, 'ICD-10' as type  UNION  
 SELECT 'M54.2' as code, 'ICD-10' as type  UNION  
 SELECT 'M54.5' as code, 'ICD-10' as type  UNION  
 SELECT 'N18.3' as code, 'ICD-10' as type  UNION  
 SELECT 'R05' as code, 'ICD-10' as type  UNION  
 SELECT 'R06.02' as code, 'ICD-10' as type  UNION  
 SELECT 'R07.9' as code, 'ICD-10' as type  UNION  
 SELECT 'R10.9' as code, 'ICD-10' as type  UNION  
 SELECT 'R53.83' as code, 'ICD-10' as type  UNION  
 SELECT 'R94.31' as code, 'ICD-10' as type  UNION  
 SELECT 'Y92.9' as code, 'ICD-10' as type  UNION  
 SELECT 'Y93.9' as code, 'ICD-10' as type  UNION  
 SELECT 'Z00.00' as code, 'ICD-10' as type  UNION  
 SELECT 'Z00.129' as code, 'ICD-10' as type  UNION  
 SELECT 'Z01.419' as code, 'ICD-10' as type  UNION  
 SELECT 'Z01.818' as code, 'ICD-10' as type  UNION  
 SELECT 'Z12.11' as code, 'ICD-10' as type  UNION  
 SELECT 'Z12.31' as code, 'ICD-10' as type  UNION  
 SELECT 'Z23' as code, 'ICD-10' as type  UNION  
 SELECT 'Z51.0' as code, 'ICD-10' as type  UNION  
 SELECT 'Z51.11' as code, 'ICD-10' as type  UNION  
 SELECT 'Z71.3' as code, 'ICD-10' as type  UNION  
 SELECT 'Z79.01' as code, 'ICD-10' as type  UNION  
 SELECT 'Z79.4' as code, 'ICD-10' as type  UNION  
 SELECT 'Z79.82' as code, 'ICD-10' as type  UNION  
 SELECT 'Z79.899' as code, 'ICD-10' as type  UNION  
 SELECT 'Z87.891' as code, 'ICD-10' as type  UNION  
 SELECT 'Z98.890' as code, 'ICD-10' as type  UNION 
 SELECT '10466-1' as code, 'LOINC' as type  UNION  
 SELECT '1742-6' as code, 'LOINC' as type  UNION  
 SELECT '1744-2' as code, 'LOINC' as type  UNION  
 SELECT '1751-7' as code, 'LOINC' as type  UNION  
 SELECT '17861-6' as code, 'LOINC' as type  UNION  
 SELECT '19123-9' as code, 'LOINC' as type  UNION  
 SELECT '1920-8' as code, 'LOINC' as type  UNION  
 SELECT '1960-4' as code, 'LOINC' as type  UNION  
 SELECT '1962-0' as code, 'LOINC' as type  UNION  
 SELECT '1963-8' as code, 'LOINC' as type  UNION  
 SELECT '1975-2' as code, 'LOINC' as type  UNION  
 SELECT '2019-8' as code, 'LOINC' as type  UNION  
 SELECT '2028-9' as code, 'LOINC' as type  UNION  
 SELECT '20564-1' as code, 'LOINC' as type  UNION  
 SELECT '20570-8' as code, 'LOINC' as type  UNION  
 SELECT '2075-0' as code, 'LOINC' as type  UNION  
 SELECT '2160-0' as code, 'LOINC' as type  UNION  
 SELECT '2339-0' as code, 'LOINC' as type  UNION  
 SELECT '2345-7' as code, 'LOINC' as type  UNION  
 SELECT '26450-7' as code, 'LOINC' as type  UNION  
 SELECT '26485-3' as code, 'LOINC' as type  UNION  
 SELECT '2703-7' as code, 'LOINC' as type  UNION  
 SELECT '2708-6' as code, 'LOINC' as type  UNION  
 SELECT '2711-0' as code, 'LOINC' as type  UNION  
 SELECT '2713-6' as code, 'LOINC' as type  UNION  
 SELECT '2744-1' as code, 'LOINC' as type  UNION  
 SELECT '2777-1' as code, 'LOINC' as type  UNION  
 SELECT '2823-3' as code, 'LOINC' as type  UNION  
 SELECT '2885-2' as code, 'LOINC' as type  UNION  
 SELECT '2951-2' as code, 'LOINC' as type  UNION  
 SELECT '30180-4' as code, 'LOINC' as type  UNION  
 SELECT '3094-0' as code, 'LOINC' as type  UNION  
 SELECT '3097-3' as code, 'LOINC' as type  UNION  
 SELECT '32623-1' as code, 'LOINC' as type  UNION  
 SELECT '33037-3' as code, 'LOINC' as type  UNION  
 SELECT '33914-3' as code, 'LOINC' as type  UNION  
 SELECT '4544-3' as code, 'LOINC' as type  UNION  
 SELECT '48642-3' as code, 'LOINC' as type  UNION  
 SELECT '48643-1' as code, 'LOINC' as type  UNION  
 SELECT '51731-8' as code, 'LOINC' as type  UNION  
 SELECT '58413-6' as code, 'LOINC' as type  UNION  
 SELECT '5902-2' as code, 'LOINC' as type  UNION  
 SELECT '5905-5' as code, 'LOINC' as type  UNION  
 SELECT '61152-5' as code, 'LOINC' as type  UNION  
 SELECT '62238-1' as code, 'LOINC' as type  UNION  
 SELECT '6301-6' as code, 'LOINC' as type  UNION  
 SELECT '6463-4' as code, 'LOINC' as type  UNION  
 SELECT '66746-9' as code, 'LOINC' as type  UNION  
 SELECT '6690-2' as code, 'LOINC' as type  UNION  
 SELECT '6768-6' as code, 'LOINC' as type  UNION  
 SELECT '704-7' as code, 'LOINC' as type  UNION  
 SELECT '706-2' as code, 'LOINC' as type  UNION  
 SELECT '711-2' as code, 'LOINC' as type  UNION  
 SELECT '713-8' as code, 'LOINC' as type  UNION  
 SELECT '71695-1' as code, 'LOINC' as type  UNION  
 SELECT '718-7' as code, 'LOINC' as type  UNION  
 SELECT '731-0' as code, 'LOINC' as type  UNION  
 SELECT '736-9' as code, 'LOINC' as type  UNION  
 SELECT '742-7' as code, 'LOINC' as type  UNION  
 SELECT '751-8' as code, 'LOINC' as type  UNION  
 SELECT '770-8' as code, 'LOINC' as type  UNION  
 SELECT '777-3' as code, 'LOINC' as type  UNION  
 SELECT '785-6' as code, 'LOINC' as type  UNION  
 SELECT '786-4' as code, 'LOINC' as type  UNION  
 SELECT '787-2' as code, 'LOINC' as type  UNION  
 SELECT '788-0' as code, 'LOINC' as type  UNION  
 SELECT '789-8' as code, 'LOINC' as type  UNION  
 SELECT '8310-5' as code, 'LOINC' as type  UNION  
 SELECT '933-2' as code, 'LOINC' as type  UNION  
 SELECT '934-0' as code, 'LOINC' as type  UNION 
 SELECT '834023' as code, 'RxNorm' as type  UNION  
 SELECT '2418' as code, 'RxNorm' as type  UNION  
 SELECT '6918' as code, 'RxNorm' as type  UNION  
 SELECT '104491' as code, 'RxNorm' as type  UNION  
 SELECT '105029' as code, 'RxNorm' as type  UNION  
 SELECT '1050490' as code, 'RxNorm' as type  UNION  
 SELECT '1189779' as code, 'RxNorm' as type  UNION  
 SELECT '1246235' as code, 'RxNorm' as type  UNION  
 SELECT '1360292' as code, 'RxNorm' as type  UNION  
 SELECT '141928' as code, 'RxNorm' as type  UNION  
 SELECT '1495474' as code, 'RxNorm' as type  UNION  
 SELECT '1495476' as code, 'RxNorm' as type  UNION  
 SELECT '152698' as code, 'RxNorm' as type  UNION  
 SELECT '152923' as code, 'RxNorm' as type  UNION  
 SELECT '153892' as code, 'RxNorm' as type  UNION  
 SELECT '1664448' as code, 'RxNorm' as type  UNION  
 SELECT '205770' as code, 'RxNorm' as type  UNION  
 SELECT '206765' as code, 'RxNorm' as type  UNION  
 SELECT '206766' as code, 'RxNorm' as type  UNION  
 SELECT '206821' as code, 'RxNorm' as type  UNION  
 SELECT '208161' as code, 'RxNorm' as type  UNION  
 SELECT '209387' as code, 'RxNorm' as type  UNION  
 SELECT '209459' as code, 'RxNorm' as type  UNION  
 SELECT '212340' as code, 'RxNorm' as type  UNION  
 SELECT '212549' as code, 'RxNorm' as type  UNION  
 SELECT '212575' as code, 'RxNorm' as type  UNION  
 SELECT '213169' as code, 'RxNorm' as type  UNION  
 SELECT '261224' as code, 'RxNorm' as type  UNION  
 SELECT '284400' as code, 'RxNorm' as type  UNION  
 SELECT '311036' as code, 'RxNorm' as type  UNION  
 SELECT '540472' as code, 'RxNorm' as type  UNION  
 SELECT '540848' as code, 'RxNorm' as type  UNION  
 SELECT '541713' as code, 'RxNorm' as type  UNION  
 SELECT '541815' as code, 'RxNorm' as type  UNION  
 SELECT '541872' as code, 'RxNorm' as type  UNION  
 SELECT '542673' as code, 'RxNorm' as type  UNION  
 SELECT '542678' as code, 'RxNorm' as type  UNION  
 SELECT '617314' as code, 'RxNorm' as type  UNION  
 SELECT '617318' as code, 'RxNorm' as type  UNION  
 SELECT '617320' as code, 'RxNorm' as type  UNION  
 SELECT '628530' as code, 'RxNorm' as type  UNION  
 SELECT '824194' as code, 'RxNorm' as type  UNION  
 SELECT '828350' as code, 'RxNorm' as type  UNION  
 SELECT '835605' as code, 'RxNorm' as type  UNION  
 SELECT '859096' as code, 'RxNorm' as type  UNION  
 SELECT '861006' as code, 'RxNorm' as type  UNION  
 SELECT '861008' as code, 'RxNorm' as type  UNION  
 SELECT '863671' as code, 'RxNorm' as type  UNION  
 SELECT '865098' as code, 'RxNorm' as type  UNION  
 SELECT '866516' as code, 'RxNorm' as type  UNION  
 SELECT '967525' as code, 'RxNorm' as type  UNION  
 SELECT '1049221' as code, 'RxNorm' as type  UNION  
 SELECT '998740' as code, 'RxNorm' as type  UNION  
 SELECT '1115005' as code, 'RxNorm' as type  UNION  
 SELECT '1361615' as code, 'RxNorm' as type  UNION  
 SELECT '1437702' as code, 'RxNorm' as type  UNION  
 SELECT '1049621' as code, 'RxNorm' as type  UNION  
 SELECT '876193' as code, 'RxNorm' as type  UNION  
 SELECT '866924' as code, 'RxNorm' as type  UNION  
 SELECT '857002' as code, 'RxNorm' as type  UNION  
 SELECT '1658634' as code, 'RxNorm' as type  UNION  
 SELECT '1659137' as code, 'RxNorm' as type  UNION  
 SELECT '1665088' as code, 'RxNorm' as type  UNION  
 SELECT '1732006' as code, 'RxNorm' as type  UNION  
 SELECT '1735003' as code, 'RxNorm' as type  UNION  
 SELECT '1735004' as code, 'RxNorm' as type  UNION  
 SELECT '1740467' as code, 'RxNorm' as type  UNION  
 SELECT '1807628' as code, 'RxNorm' as type  UNION  
 SELECT '1807632' as code, 'RxNorm' as type  UNION  
 SELECT '1807633' as code, 'RxNorm' as type  UNION  
 SELECT '198440' as code, 'RxNorm' as type  UNION  
 SELECT '310273' as code, 'RxNorm' as type  UNION  
 SELECT '310431' as code, 'RxNorm' as type  UNION  
 SELECT '313782' as code, 'RxNorm' as type  UNION  
 SELECT '314200' as code, 'RxNorm' as type  UNION  
 SELECT '318272' as code, 'RxNorm' as type  UNION  
 SELECT '617311' as code, 'RxNorm' as type  UNION  
 SELECT '834127' as code, 'RxNorm' as type  UNION  
 SELECT '854235' as code, 'RxNorm' as type  UNION  
 SELECT '1797907' as code, 'RxNorm' as type  UNION  
 SELECT '1795964' as code, 'RxNorm' as type  UNION  
 SELECT '901044' as code, 'RxNorm' as type  UNION  
 SELECT '1490493' as code, 'RxNorm' as type  UNION 
 SELECT '00790' as code, 'CPT' as type  UNION  
 SELECT '01967' as code, 'CPT' as type  UNION  
 SELECT '36415' as code, 'CPT' as type  UNION  
 SELECT '70450' as code, 'CPT' as type  UNION  
 SELECT '71045' as code, 'CPT' as type  UNION  
 SELECT '80048' as code, 'CPT' as type  UNION  
 SELECT '80051' as code, 'CPT' as type  UNION  
 SELECT '80053' as code, 'CPT' as type  UNION  
 SELECT '80061' as code, 'CPT' as type  UNION  
 SELECT '80076' as code, 'CPT' as type  UNION  
 SELECT '81000' as code, 'CPT' as type  UNION  
 SELECT '81002' as code, 'CPT' as type  UNION  
 SELECT '81003' as code, 'CPT' as type  UNION  
 SELECT '82043' as code, 'CPT' as type  UNION  
 SELECT '82306' as code, 'CPT' as type  UNION  
 SELECT '82310' as code, 'CPT' as type  UNION  
 SELECT '82330' as code, 'CPT' as type  UNION  
 SELECT '82565' as code, 'CPT' as type  UNION  
 SELECT '82607' as code, 'CPT' as type  UNION  
 SELECT '82805' as code, 'CPT' as type  UNION  
 SELECT '82947' as code, 'CPT' as type  UNION  
 SELECT '82962' as code, 'CPT' as type  UNION  
 SELECT '83036' as code, 'CPT' as type  UNION  
 SELECT '83605' as code, 'CPT' as type  UNION  
 SELECT '83615' as code, 'CPT' as type  UNION  
 SELECT '83690' as code, 'CPT' as type  UNION  
 SELECT '83735' as code, 'CPT' as type  UNION  
 SELECT '84100' as code, 'CPT' as type  UNION  
 SELECT '84132' as code, 'CPT' as type  UNION  
 SELECT '84153' as code, 'CPT' as type  UNION  
 SELECT '84295' as code, 'CPT' as type  UNION  
 SELECT '84439' as code, 'CPT' as type  UNION  
 SELECT '84443' as code, 'CPT' as type  UNION  
 SELECT '84450' as code, 'CPT' as type  UNION  
 SELECT '84460' as code, 'CPT' as type  UNION  
 SELECT '84484' as code, 'CPT' as type  UNION  
 SELECT '84520' as code, 'CPT' as type  UNION  
 SELECT '84550' as code, 'CPT' as type  UNION  
 SELECT '84999' as code, 'CPT' as type  UNION  
 SELECT '85004' as code, 'CPT' as type  UNION  
 SELECT '85014' as code, 'CPT' as type  UNION  
 SELECT '85025' as code, 'CPT' as type  UNION  
 SELECT '85027' as code, 'CPT' as type  UNION  
 SELECT '85610' as code, 'CPT' as type  UNION  
 SELECT '85652' as code, 'CPT' as type  UNION  
 SELECT '85730' as code, 'CPT' as type  UNION  
 SELECT '86140' as code, 'CPT' as type  UNION  
 SELECT '86850' as code, 'CPT' as type  UNION  
 SELECT '86900' as code, 'CPT' as type  UNION  
 SELECT '86901' as code, 'CPT' as type  UNION  
 SELECT '87040' as code, 'CPT' as type  UNION  
 SELECT '87070' as code, 'CPT' as type  UNION  
 SELECT '87086' as code, 'CPT' as type  UNION  
 SELECT '88185' as code, 'CPT' as type  UNION  
 SELECT '88305' as code, 'CPT' as type  UNION  
 SELECT '88399' as code, 'CPT' as type  UNION  
 SELECT '90460' as code, 'CPT' as type  UNION  
 SELECT '90471' as code, 'CPT' as type  UNION  
 SELECT '93000' as code, 'CPT' as type  UNION  
 SELECT '93005' as code, 'CPT' as type  UNION  
 SELECT '93010' as code, 'CPT' as type  UNION  
 SELECT '94640' as code, 'CPT' as type  UNION  
 SELECT '95004' as code, 'CPT' as type  UNION  
 SELECT '97530' as code, 'CPT' as type  UNION  
 SELECT '99024' as code, 'CPT' as type  UNION  
 SELECT '99203' as code, 'CPT' as type  UNION  
 SELECT '99212' as code, 'CPT' as type  UNION  
 SELECT '99213' as code, 'CPT' as type  UNION  
 SELECT '99214' as code, 'CPT' as type  UNION  
 SELECT '99215' as code, 'CPT' as type  UNION  
 SELECT '99232' as code, 'CPT' as type  UNION  
 SELECT '99233' as code, 'CPT' as type  UNION  
 SELECT '99244' as code, 'CPT' as type  UNION  
 SELECT '99283' as code, 'CPT' as type  UNION  
 SELECT '99284' as code, 'CPT' as type  UNION  
 SELECT '99285'  as code, 'CPT' as type  UNION  
SELECT 'A7003' as code, 'HCPCS' as type  UNION  
 SELECT 'A9585' as code, 'HCPCS' as type  UNION  
 SELECT 'A9999' as code, 'HCPCS' as type  UNION  
 SELECT 'E1399' as code, 'HCPCS' as type  UNION  
 SELECT 'G0008' as code, 'HCPCS' as type  UNION  
 SELECT 'G0009' as code, 'HCPCS' as type  UNION  
 SELECT 'G0105' as code, 'HCPCS' as type  UNION  
 SELECT 'G0121' as code, 'HCPCS' as type  UNION  
 SELECT 'G0378' as code, 'HCPCS' as type  UNION  
 SELECT 'G0444' as code, 'HCPCS' as type  UNION  
 SELECT 'J0131' as code, 'HCPCS' as type  UNION  
 SELECT 'J0133' as code, 'HCPCS' as type  UNION  
 SELECT 'J0171' as code, 'HCPCS' as type  UNION  
 SELECT 'J0461' as code, 'HCPCS' as type  UNION  
 SELECT 'J0583' as code, 'HCPCS' as type  UNION  
 SELECT 'J0585' as code, 'HCPCS' as type  UNION  
 SELECT 'J0690' as code, 'HCPCS' as type  UNION  
 SELECT 'J0692' as code, 'HCPCS' as type  UNION  
 SELECT 'J0712' as code, 'HCPCS' as type  UNION  
 SELECT 'J0878' as code, 'HCPCS' as type  UNION  
 SELECT 'J1030' as code, 'HCPCS' as type  UNION  
 SELECT 'J1040' as code, 'HCPCS' as type  UNION  
 SELECT 'J1050' as code, 'HCPCS' as type  UNION  
 SELECT 'J1100' as code, 'HCPCS' as type  UNION  
 SELECT 'J1442' as code, 'HCPCS' as type  UNION  
 SELECT 'J1642' as code, 'HCPCS' as type  UNION  
 SELECT 'J1644' as code, 'HCPCS' as type  UNION  
 SELECT 'J1650' as code, 'HCPCS' as type  UNION  
 SELECT 'J1756' as code, 'HCPCS' as type  UNION  
 SELECT 'J1815' as code, 'HCPCS' as type  UNION  
 SELECT 'J1953' as code, 'HCPCS' as type  UNION  
 SELECT 'J2001' as code, 'HCPCS' as type  UNION  
 SELECT 'J2185' as code, 'HCPCS' as type  UNION  
 SELECT 'J2248' as code, 'HCPCS' as type  UNION  
 SELECT 'J2250' as code, 'HCPCS' as type  UNION  
 SELECT 'J2370' as code, 'HCPCS' as type  UNION  
 SELECT 'J2405' as code, 'HCPCS' as type  UNION  
 SELECT 'J2543' as code, 'HCPCS' as type  UNION  
 SELECT 'J2704' as code, 'HCPCS' as type  UNION  
 SELECT 'J2710' as code, 'HCPCS' as type  UNION  
 SELECT 'J2795' as code, 'HCPCS' as type  UNION  
 SELECT 'J3010' as code, 'HCPCS' as type  UNION  
 SELECT 'J3301' as code, 'HCPCS' as type  UNION  
 SELECT 'J3420' as code, 'HCPCS' as type  UNION  
 SELECT 'J3475' as code, 'HCPCS' as type  UNION  
 SELECT 'J3480' as code, 'HCPCS' as type  UNION  
 SELECT 'J3490' as code, 'HCPCS' as type  UNION  
 SELECT 'J7030' as code, 'HCPCS' as type  UNION  
 SELECT 'J7185' as code, 'HCPCS' as type  UNION  
 SELECT 'J7187' as code, 'HCPCS' as type  UNION  
 SELECT 'J7189' as code, 'HCPCS' as type  UNION  
 SELECT 'J7192' as code, 'HCPCS' as type  UNION  
 SELECT 'J7195' as code, 'HCPCS' as type  UNION  
 SELECT 'J7323' as code, 'HCPCS' as type  UNION  
 SELECT 'J7512' as code, 'HCPCS' as type  UNION  
 SELECT 'J7613' as code, 'HCPCS' as type  UNION  
 SELECT 'J8540' as code, 'HCPCS' as type  UNION  
 SELECT 'J9250' as code, 'HCPCS' as type  UNION  
 SELECT 'J9263' as code, 'HCPCS' as type  UNION  
 SELECT 'J9267' as code, 'HCPCS' as type  UNION  
 SELECT 'Q0091' as code, 'HCPCS' as type  UNION  
 SELECT 'Q0162' as code, 'HCPCS' as type  UNION  
 SELECT 'Q5101' as code, 'HCPCS' as type  UNION  
 SELECT 'Q9959' as code, 'HCPCS' as type  UNION  
 SELECT 'Q9967' as code, 'HCPCS' as type  UNION 
 SELECT '00.40' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '00.66' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '03.31' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '03.91' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '03.92' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '04.81' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '13.41' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '13.71' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '33.24' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '37.22' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '38.91' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '38.93' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '38.97' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '39.95' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '42.92' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '45.13' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '45.16' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '45.23' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '45.25' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '45.42' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '51.23' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '54.91' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '57.32' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '57.94' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '59.8' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '64.0' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '73.59' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '74.1' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '75.69' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '80.51' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '81.54' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '81.62' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '81.92' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '86.04' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '86.3' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '86.59' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '87.03' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '88.41' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '88.53' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '88.56' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '88.72' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '93.39' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '93.54' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '93.83' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '96.04' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '96.71' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '96.72' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '99.04' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '99.23' as code, 'ICD-9-PROC' as type  UNION  
 SELECT '99.29' as code, 'ICD-9-PROC' as type  UNION 
 SELECT '009U3ZX' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '01NB0ZZ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '027034Z' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '02HV33Z' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '03HY32Z' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '0BH17EZ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '0BJ08ZZ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '0CJS8ZZ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '0DB68ZX' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '0DB98ZX' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '0DH67UZ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '0DJ08ZZ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '0DJD8ZZ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '0FT44ZZ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '0HQ9XZZ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '0KQM0ZZ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '0SRC0J9' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '0SRD0J9' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '0T9B70Z' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '0U7C7ZZ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '0VTTXZZ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '0W9930Z' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '0W9B30Z' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '10907ZC' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '10D00Z1' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '10E0XZZ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '30233K1' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '30233N1' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '30233R1' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '3E033VJ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '3E0436Z' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '3E0G76Z' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '4A023N7' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '4A10X4G' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '5A1221Z' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '5A1935Z' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '5A1945Z' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '5A1955Z' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '5A1D70Z' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '5A2204Z' as code, 'ICD-10-PROC' as type  UNION  
 SELECT '8E0W4CZ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT 'B020ZZZ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT 'B030ZZZ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT 'B2111ZZ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT 'B2151ZZ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT 'B24BZZ4' as code, 'ICD-10-PROC' as type  UNION  
 SELECT 'B32R1ZZ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT 'BW28ZZZ' as code, 'ICD-10-PROC' as type  UNION  
 SELECT 'HZ2ZZZZ' as code, 'ICD-10-PROC' as type   
),

-- here for performance reasons
rx_subset as (
SELECT p.*
FROM PRESCRIBING p JOIN opioid_meds om ON p.RXNORM_CUI = om.rxn_code
WHERE p.RX_ORDER_DATE between '1/1/2017' and '12/31/2021'
),

-- here for performance reasons
dx_subset as (
SELECT dx.PATID, dx.DX as dx, dx.ADMIT_DATE as dxDate
FROM DIAGNOSIS dx 
WHERE dx.DX LIKE 'F11%' and dx.ADMIT_DATE between '1/1/2017' and '12/31/2021'

UNION

SELECT cond.PATID, cond.CONDITION as dx, cond.REPORT_DATE as dxDate
FROM CONDITION cond 
WHERE cond.CONDITION LIKE 'F11%' and cond.REPORT_DATE between '1/1/2017' and '12/31/2021'
),

--denominators
totpts as (
select 
    'total_patients' as description,
    (select count(distinct dem.PATID) from ENCOUNTER enc1y JOIN DEMOGRAPHIC dem ON enc1y.PATID = dem.PATID 
        where enc1y.ADMIT_DATE between '1/1/2021' and '12/31/2021') as one_year,
    (select count(distinct dem.PATID) from ENCOUNTER enc5y JOIN DEMOGRAPHIC dem ON enc5y.PATID = dem.PATID 
        where enc5y.ADMIT_DATE between '1/1/2017' and '12/31/2021') as five_year
)

--data model
select
   'data_model' as description,
   1 as one_year,
   1 as five_year
   
UNION
			   
-- does this data model support nlp
select 
    'nlp_any' as description,
    NULL as one_year,
    NULL as five_year

UNION	

-- does your site have free text search capabilities
select 
    'text_search' as description,
    NULL as one_year,
    NULL as five_year

UNION

-- total patients
select *
from totpts

UNION

-- patients for whom age can be calculated
select 
    'uniq_pt_with_age' as description,
    (select count(distinct dem.PATID) from ENCOUNTER enc1y JOIN DEMOGRAPHIC dem ON enc1y.PATID = dem.PATID 
        where enc1y.ADMIT_DATE between '1/1/2021' and '12/31/2021'
        and dem.BIRTH_DATE is not null) as one_year,
    (select count(distinct dem.PATID) from ENCOUNTER enc5y JOIN DEMOGRAPHIC dem ON enc5y.PATID = dem.PATID 
        where enc5y.ADMIT_DATE between '1/1/2017' and '12/31/2021'
        and dem.BIRTH_DATE is not null) as five_year

UNION

-- patients with age > 120 
select 
    'uniq_pt_age_over_120' as description,
    (select count(distinct dem.PATID) from ENCOUNTER enc1y 
        JOIN DEMOGRAPHIC dem ON enc1y.PATID = dem.PATID 
        LEFT JOIN DEATH dt ON enc1y.PATID = dt.PATID
        where enc1y.ADMIT_DATE between '1/1/2021' and '12/31/2021'
        and 120 < case when dt.DEATH_DATE is null then FLOOR(DATEDIFF(day, dem.BIRTH_DATE, '12/31/2021')/ 365.25)--months_between('12/31/2021',dem.BIRTH_DATE)/12
                else FLOOR(DATEDIFF(day, dem.BIRTH_DATE, dt.DEATH_DATE)/ 365.25) end) as one_year,--months_between(dt.DEATH_DATE,dem.BIRTH_DATE)/12 end) as one_year,
    (select count(distinct dem.PATID) from ENCOUNTER enc5y 
        JOIN DEMOGRAPHIC dem ON enc5y.PATID = dem.PATID 
        LEFT JOIN DEATH dt ON enc5y.PATID = dt.PATID
        where enc5y.ADMIT_DATE between '1/1/2017' and '12/31/2021'
        and 120 < case when dt.DEATH_DATE is null then FLOOR(DATEDIFF(day, dem.BIRTH_DATE, '12/31/2021')/ 365.25)--months_between('12/31/2021',dem.BIRTH_DATE)/12
                else FLOOR(DATEDIFF(day, dem.BIRTH_DATE, dt.DEATH_DATE)/ 365.25) end) as five_year--months_between(dt.DEATH_DATE,dem.BIRTH_DATE)/12 end) as five_year

UNION

-- patients with known gender
select 
    'uniq_pt_with_gender' as description,
    (select count(distinct dem.PATID) from ENCOUNTER enc1y JOIN DEMOGRAPHIC dem ON enc1y.PATID = dem.PATID 
        where enc1y.ADMIT_DATE between '1/1/2021' and '12/31/2021'
        and dem.SEX NOT IN ('NI','UN') and dem.SEX is not null) as one_year,
    (select count(distinct dem.PATID) from ENCOUNTER enc5y JOIN DEMOGRAPHIC dem ON enc5y.PATID = dem.PATID 
        where enc5y.ADMIT_DATE between '1/1/2017' and '12/31/2021'
        and dem.SEX NOT IN ('NI','UN') and dem.SEX is not null) as five_year

UNION

-- patients with at least one LOINC
select 
    'uniq_pt_loinc' as description,
    (select count(distinct lb1y.PATID) from LAB_RESULT_CM lb1y where lb1y.LAB_LOINC is not null and (lb1y.RESULT_DATE
        between '1/1/2021' and '12/31/2021' or lb1y.LAB_ORDER_DATE between '1/1/2021' and '12/31/2021')) as one_year,
    (select count(distinct lb5y.PATID) from LAB_RESULT_CM lb5y where lb5y.LAB_LOINC is not null and (lb5y.RESULT_DATE
        between '1/1/2017' and '12/31/2021' or lb5y.LAB_ORDER_DATE between '1/1/2017' and '12/31/2021')) as five_year

UNION

-- patients with at least one rxnorm 
-- assuming that DISPENSING does not contain medications that are not in PRESCRIBING
select 
    'uniq_pt_med_rxnorm' as description,
    (select count(*) from (select med1y.PATID from PRESCRIBING med1y WHERE med1y.RXNORM_CUI is not null and med1y.RX_ORDER_DATE 
        between '1/1/2021' and '12/31/2021'
     UNION
     select med1yad.PATID from MED_ADMIN med1yad WHERE med1yad.MEDADMIN_TYPE = 'RX' and med1yad.MEDADMIN_START_DATE 
        between '1/1/2021' and '12/31/2021') tbl) as one_year,
        
    (select count(*) from (select med5y.PATID from PRESCRIBING med5y WHERE med5y.RXNORM_CUI is not null and med5y.RX_ORDER_DATE 
        between '1/1/2017' and '12/31/2021'
     UNION
     select med5yad.PATID from MED_ADMIN med5yad WHERE med5yad.MEDADMIN_TYPE = 'RX' and med5yad.MEDADMIN_START_DATE 
        between '1/1/2017' and '12/31/2021') tbl) as five_year

UNION

-- patients with at least one ICD dx code
select 
    'uniq_pt_icd_dx' as description,
    (select count(*) from (select dx1y.PATID from DIAGNOSIS dx1y WHERE dx1y.DX_TYPE IN ('09','10') and dx1y.ADMIT_DATE 
        between '1/1/2021' and '12/31/2021'
     UNION
     select con1y.PATID from CONDITION con1y WHERE con1y.CONDITION_TYPE IN ('09','10') and con1y.REPORT_DATE 
        between '1/1/2021' and '12/31/2021') tbl) as one_year,
        
    (select count(*) from (select dx5y.PATID from DIAGNOSIS dx5y WHERE dx5y.DX_TYPE IN ('09','10') and dx5y.ADMIT_DATE 
        between '1/1/2017' and '12/31/2021'
     UNION
     select con5y.PATID from CONDITION con5y WHERE con5y.CONDITION_TYPE IN ('09','10') and con5y.REPORT_DATE 
	    between '1/1/2017' and '12/31/2021') tbl) as five_year	--line added to fix error (by shu@med.umich.edu)

UNION

-- patients with at least one SNOMED dx code
select 
    'uniq_pt_snomed_dx' as description,
    (select count(*) from (select dx1y.PATID from DIAGNOSIS dx1y WHERE dx1y.DX_TYPE = 'SM' and dx1y.ADMIT_DATE 
        between '1/1/2021' and '12/31/2021'
     UNION
     select con1y.PATID from CONDITION con1y WHERE con1y.CONDITION_TYPE = 'SM' and con1y.REPORT_DATE 
        between '1/1/2021' and '12/31/2021') tbl) as one_year,
        
    (select count(*) from (select dx5y.PATID from DIAGNOSIS dx5y WHERE dx5y.DX_TYPE = 'SM' and dx5y.ADMIT_DATE 
        between '1/1/2017' and '12/31/2021'
     UNION
     select con5y.PATID from CONDITION con5y WHERE con5y.CONDITION_TYPE = 'SM' and con5y.REPORT_DATE 
        between '1/1/2017' and '12/31/2021') tbl) as five_year

UNION

-- patients with at least one ICD procedure code
select 
    'uniq_pt_icd_proc' as description,
    (select count(distinct px1y.PATID) from PROCEDURES px1y WHERE px1y.PX_TYPE IN ('09','10') and px1y.ADMIT_DATE 
        between '1/1/2021' and '12/31/2021') as one_year,
    (select count(distinct px5y.PATID) from PROCEDURES px5y WHERE px5y.PX_TYPE IN ('09','10') and px5y.ADMIT_DATE 
        between '1/1/2017' and '12/31/2021') as five_year

UNION

-- patients with at least one CPT procedure code
select 
    'uniq_pt_cpt' as description,
    (select count(distinct px1y.PATID) from PROCEDURES px1y WHERE px1y.PX_TYPE = 'CH' and px1y.ADMIT_DATE 
        between '1/1/2021' and '12/31/2021') as one_year,
    (select count(distinct px5y.PATID) from PROCEDURES px5y WHERE px5y.PX_TYPE = 'CH' and px5y.ADMIT_DATE 
        between '1/1/2017' and '12/31/2021') as five_year

UNION

-- patients with a SNOMED proc code: NOT SUPPORTED BY PCORNET
select 
    'uniq_pt_snomed_proc' as description,
    0 as one_year,
    0 as five_year

UNION

-- patients with a free text note: NOT SUPPORTED BY PCORNET
select 
    'uniq_pt_note' as description,
    0 as one_year,
    0 as five_year

UNION		   

-- patients with at least one vital sign
-- will need to be changed when PCORnet drops the VITAL table.
select 
    'uniq_enc_vital_sign' as description,
    (select count(distinct vit1y.PATID) from VITAL vit1y WHERE vit1y.MEASURE_DATE between '1/1/2021' and '12/31/2021') as one_year,
    (select count(distinct vit5y.PATID) from VITAL vit5y WHERE vit5y.MEASURE_DATE between '1/1/2017' and '12/31/2021') as five_year

UNION

-- patients with at least one smoking code
select 
    'uniq_pt_smoking' as description,
    (select count(distinct vit1y.PATID) from VITAL vit1y 
        WHERE vit1y.MEASURE_DATE between '1/1/2021' and '12/31/2021' 
        and SMOKING is not null and SMOKING not in ('NI','UN')) as one_year,
    (select count(distinct vit5y.PATID) from VITAL vit5y
        WHERE vit5y.MEASURE_DATE between '1/1/2017' and '12/31/2021'
        and SMOKING is not null and SMOKING not in ('NI','UN')) as five_year

UNION

-- patients with at least one opioid code
select 
    'uniq_pt_opioid' as description,
    (select count(distinct d.PATID) FROM DEMOGRAPHIC d LEFT JOIN rx_subset p ON d.PATID = p.PATID AND p.RX_ORDER_DATE between '1/1/2021' and '12/31/2021'
        LEFT JOIN dx_subset dx ON d.PATID = dx.PATID AND dx.dxDate between '1/1/2021' and '12/31/2021' 
        WHERE (p.RXNORM_CUI is null AND dx.DX is not null) OR (p.RXNORM_CUI is not null AND dx.DX is null) OR (p.RXNORM_CUI is not null AND dx.DX is not null))
        as one_year,
     (select count(distinct d.PATID) FROM DEMOGRAPHIC d LEFT JOIN rx_subset p ON d.PATID = p.PATID AND p.RX_ORDER_DATE between '1/1/2017' and '12/31/2021'
        LEFT JOIN dx_subset dx ON d.PATID = dx.PATID AND dx.dxDate between '1/1/2017' and '12/31/2021' 
        WHERE (p.RXNORM_CUI is null AND dx.DX is not null) OR (p.RXNORM_CUI is not null AND dx.DX is null) OR (p.RXNORM_CUI is not null AND dx.DX is not null))
		as five_year	--line added to fix error (by shu@med.umich.edu)
UNION

-- patients with any insurance
select 
    'uniq_pt_any_insurance_value' as description,
    (select count(distinct dem.PATID) from ENCOUNTER enc1y JOIN DEMOGRAPHIC dem ON enc1y.PATID = dem.PATID 
        where enc1y.ADMIT_DATE between '1/1/2021' and '12/31/2021' and 
	        (enc1y.payer_type_primary is not null or enc1y.raw_payer_type_primary is not null 
	            or enc1y.raw_payer_name_primary is not null or enc1y.raw_payer_id_primary is not null)
            and enc1y.payer_type_primary not in ('NI','UN')) as one_year,
    (select count(distinct dem.PATID) from ENCOUNTER enc5y JOIN DEMOGRAPHIC dem ON enc5y.PATID = dem.PATID 
        where enc5y.ADMIT_DATE between '1/1/2017' and '12/31/2021' and 
        (enc5y.payer_type_primary is not null or enc5y.raw_payer_type_primary is not null 
	            or enc5y.raw_payer_name_primary is not null or enc5y.raw_payer_id_primary is not null)
        and enc5y.payer_type_primary not in ('NI','UN')) as five_year

UNION

-- patients with insurance mapped to the PCORnet controlled vocab
select 
    'uniq_pt_insurance_value_set' as description,
    (select count(distinct dem.PATID) from ENCOUNTER enc1y JOIN DEMOGRAPHIC dem ON enc1y.PATID = dem.PATID 
        where enc1y.ADMIT_DATE between '1/1/2021' and '12/31/2021' and enc1y.payer_type_primary is not null
        and enc1y.payer_type_primary not in ('NI','UN')) as one_year,
    (select count(distinct dem.PATID) from ENCOUNTER enc5y JOIN DEMOGRAPHIC dem ON enc5y.PATID = dem.PATID 
        where enc5y.ADMIT_DATE between '1/1/2017' and '12/31/2021' and enc5y.payer_type_primary is not null
        and enc5y.payer_type_primary not in ('NI','UN')) as five_year	--line added to fix error (by shu@med.umich.edu)

UNION

--assumptions: numerator is the number of patients with that code for the time period, denominator is all patients in that time period
--multiply numerators or denominators by 1.0 to get valid percents instead of all zeros (modified by shu@med.umich.edu)
select 
    'cpt4_check' as description,
    --one yr numerator
    ((select 
        count(distinct px1y.PX) * 1.0
     from PROCEDURES px1y JOIN common_codes cc ON px1y.PX = cc.code and cc.type IN ('CPT','HCPCS')
     WHERE px1y.PX_TYPE = 'CH' 
        and px1y.ADMIT_DATE between '1/1/2021' and '12/31/2021') / (select count(distinct code) from common_codes where type IN ('CPT','HCPCS')))*100
        as one_year,
    ((select count(distinct px5y.PX) * 1.0
     from PROCEDURES px5y JOIN common_codes cc ON px5y.PX = cc.code and cc.type IN ('CPT','HCPCS')
     WHERE px5y.PX_TYPE = 'CH' 
        and px5y.ADMIT_DATE between '1/1/2017' and '12/31/2021') / (select count(distinct code) from common_codes where type IN ('CPT','HCPCS')))*100 
		as five_year

UNION

select 
    'icd10pcs_check' as description,
    --one yr numerator
    ((select 
        count(distinct px1y.PX) * 1.0
     from PROCEDURES px1y JOIN common_codes cc ON px1y.PX = cc.code and cc.type = 'ICD-10-PROC'
     WHERE px1y.PX_TYPE = '10' 
        and px1y.ADMIT_DATE between '1/1/2021' and '12/31/2021') / (select count(distinct code) from common_codes where type = 'ICD-10-PROC'))*100
        as one_year,
    ((select count(distinct px5y.PX) * 1.0 
     from PROCEDURES px5y JOIN common_codes cc ON px5y.PX = cc.code and cc.type = 'ICD-10-PROC'
     WHERE px5y.PX_TYPE = '10' 
        and px5y.ADMIT_DATE between '1/1/2017' and '12/31/2021') / (select count(distinct code) from common_codes where type = 'ICD-10-PROC'))*100 
		as five_year

UNION

select 
    'icd9pcs_check' as description,
    --one yr numerator
    ((select 
        count(distinct px1y.PX) * 1.0
     from PROCEDURES px1y JOIN common_codes cc ON px1y.PX = cc.code and cc.type = 'ICD-9-PROC'
     WHERE px1y.PX_TYPE = '09' 
        and px1y.ADMIT_DATE between '1/1/2021' and '12/31/2021') / (select count(distinct code) from common_codes where type = 'ICD-9-PROC'))*100
        as one_year,
    ((select count(distinct px5y.PX) * 1.0
     from PROCEDURES px5y JOIN common_codes cc ON px5y.PX = cc.code and cc.type = 'ICD-9-PROC'
     WHERE px5y.PX_TYPE = '09' 
        and px5y.ADMIT_DATE between '1/1/2017' and '12/31/2021') / (select count(distinct code) from common_codes where type = 'ICD-9-PROC'))*100 
		as five_year
 
UNION

select 
    'icd10cm_check' as description,
    ((select count( *) from (select dx1y.DX from DIAGNOSIS dx1y JOIN common_codes cc ON dx1y.DX = cc.code and cc.type = 'ICD-10' 
        WHERE dx1y.DX_TYPE = '10' and dx1y.ADMIT_DATE between '1/1/2021' and '12/31/2021'
     UNION
     select con1y.CONDITION from CONDITION con1y JOIN common_codes cc ON con1y.CONDITION = cc.code and cc.type = 'ICD-10' 
        WHERE con1y.CONDITION_TYPE = '10' and con1y.REPORT_DATE between '1/1/2021' and '12/31/2021') tbl) / (select count(distinct code) * 1.0 from common_codes where type = 'ICD-10'))*100 as one_year,
        
    ((select count( *) from (select dx5y.DX from DIAGNOSIS dx5y JOIN common_codes cc ON dx5y.DX = cc.code and cc.type = 'ICD-10' 
        WHERE dx5y.DX_TYPE = '10' and dx5y.ADMIT_DATE between '1/1/2017' and '12/31/2021'
     UNION
     select con5y.CONDITION from CONDITION con5y JOIN common_codes cc ON con5y.CONDITION = cc.code and cc.type = 'ICD-10' 
        WHERE con5y.CONDITION_TYPE = '10' and con5y.REPORT_DATE between '1/1/2017' and '12/31/2021') tbl)  / (select count(distinct code) * 1.0 from common_codes where type = 'ICD-10'))*100 as five_year


UNION

select 
    'icd9cm_check' as description,
    ((select count( *) from (select dx1y.DX from DIAGNOSIS dx1y JOIN common_codes cc ON dx1y.DX = cc.code and cc.type = 'ICD-9' 
        WHERE dx1y.DX_TYPE = '09' and dx1y.ADMIT_DATE between '1/1/2021' and '12/31/2021'
     UNION
     select con1y.CONDITION from CONDITION con1y JOIN common_codes cc ON con1y.CONDITION = cc.code and cc.type = 'ICD-9' 
        WHERE con1y.CONDITION_TYPE = '09' and con1y.REPORT_DATE between '1/1/2021' and '12/31/2021') tbl) / (select count(distinct code) * 1.0 from common_codes where type = 'ICD-9'))*100 as one_year,
        
    ((select count( *) from (select dx5y.DX from DIAGNOSIS dx5y JOIN common_codes cc ON dx5y.DX = cc.code and cc.type = 'ICD-9' 
        WHERE dx5y.DX_TYPE = '09' and dx5y.ADMIT_DATE between '1/1/2017' and '12/31/2021'
     UNION
     select con5y.CONDITION from CONDITION con5y JOIN common_codes cc ON con5y.CONDITION = cc.code and cc.type = 'ICD-9' 
        WHERE con5y.CONDITION_TYPE = '09' and con5y.REPORT_DATE between '1/1/2017' and '12/31/2021') tbl)  / (select count(distinct code) * 1.0 from common_codes where type = 'ICD-9'))*100 as five_year


UNION

select
 'loinc_check' as description,
 ((select count(distinct lb1y.LAB_LOINC) * 1.0 from LAB_RESULT_CM lb1y JOIN common_codes cc ON lb1y.LAB_LOINC = cc.code and cc.type = 'LOINC' 
   	where (lb1y.RESULT_DATE between '1/1/2021' and '12/31/2021' or lb1y.LAB_ORDER_DATE between '1/1/2021' and '12/31/2021')) / (select count(distinct code) from common_codes where type = 'LOINC'))*100 as one_year,
 ((select count(distinct lb5y.LAB_LOINC) * 1.0 from LAB_RESULT_CM lb5y JOIN common_codes cc ON lb5y.LAB_LOINC = cc.code and cc.type = 'LOINC' 
   	where (lb5y.RESULT_DATE between '1/1/2017' and '12/31/2021' or lb5y.LAB_ORDER_DATE between '1/1/2017' and '12/31/2021')) / (select count(distinct code) from common_codes where type = 'LOINC'))*100 as five_year


UNION

select
  'rxnorm_check' as description,
    ((select count( *) from (select med1y.RXNORM_CUI from PRESCRIBING med1y JOIN common_codes cc ON med1y.RXNORM_CUI = cc.code and cc.type = 'RxNorm'
			    WHERE med1y.RX_ORDER_DATE between '1/1/2021' and '12/31/2021'
     UNION
     select med1yad.MEDADMIN_CODE 
	from MED_ADMIN med1yad JOIN common_codes cc ON med1yad.MEDADMIN_CODE = cc.code and cc.type = 'RxNorm'
	WHERE med1yad.MEDADMIN_TYPE = 'RX' and med1yad.MEDADMIN_START_DATE between '1/1/2021' and '12/31/2021') tbl) / (select count(distinct code) * 1.0 from common_codes where type = 'RxNorm'))*100 as one_year,
        
    ((select count( *) from (select med5y.RXNORM_CUI from PRESCRIBING med5y JOIN common_codes cc ON med5y.RXNORM_CUI = cc.code and cc.type = 'RxNorm'
				     WHERE med5y.RX_ORDER_DATE between '1/1/2017' and '12/31/2021'
     UNION
     select med5yad.MEDADMIN_CODE from MED_ADMIN med5yad JOIN common_codes cc ON med5yad.MEDADMIN_CODE = cc.code and cc.type = 'RxNorm'
				     WHERE med5yad.MEDADMIN_TYPE = 'RX' and med5yad.MEDADMIN_START_DATE between '1/1/2017' and '12/31/2021') tbl) / (select count(distinct code) * 1.0 from common_codes where type = 'RxNorm'))*100 as five_year

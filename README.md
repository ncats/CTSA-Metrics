# About
This GitHub repository provides scripts, data model documentation and associated files for the Informatics Common Metric for the CTSA Program. 

## Rationale

To accelerate translation, researchers need to be provided with access to a broad range of data (electronic health records, omics, imaging, genetics, behavioral, etc.). These data can come from different sources such as clinical databases, research datasets, sensors, mobile technology, patient generated data, and publicly available data sets. The sharing and pooling of data within and across CTSA Program hubs requires that data be represented in a format that can be queried and adheres to commonly accepted standards. A longer-term goal of the CTSA Program is to harmonize data and data standards so that a query written by any site can be run unaltered against all CTSA Program data repositories.
The purpose of this common metric is to increase interoperability of data across the consortium. This common metric demonstrates the strength of each hub, contributes data to the national mission, and continues to increase interoperability across the consortium annually to efficiently use data to conduct scientific research. Specifically, the metrics on different data types will aid local hubs in prioritizing additions to their data repositories. Improving the CTSA Program’s clinical research data ecosystem can enhance the effectiveness of collaborative initiatives within and outside of the CTSA Program to provide tools to identify patient cohorts (i2b2/ACT, SHRINE, All of Us, PCORI).
This metric will evolve over time to enhance the completeness of the research data warehouses across the CTSA Program consortium and incorporate additional types of data within warehouses as the CTSA Program, in collaboration with the iEC (Informatics Enterprise Committee) finds useful and appropriate.

## Metric

The data models approved for this metric by the iEC are: OMOP, PCORnet, i2b2/ACT (or other i2b2 data models), and TriNetX. Data is to be collected for both one- and five-year periods. 

The denominator for the calculations is the total # of patients in the data warehouse (1 and 5 years). 
Data Elements
1.	% of unique patients with an age or date of birth value
2.	% of unique patients with at least one negative age
3.	% of unique patients with age >120
4.	% of unique patients with an asserted (administrative) gender value
5.	% of patients with lab test results coded in LOINC
6.	% of patients with medication records coded in RxNorm
7.	% of patients with diagnoses with a diagnosis coded in ICD 9/10 
8.	% of patients with diagnoses with a diagnosis coded in SNOMED
9.	% of patient with a procedure coded in ICD 9/10 – CM
10.	% of patients with a procedure coded in HCPCS or CPT
11.	% of patients with a procedure coded in SNOMED CT
12.	% of unique patients with at least one free text note and/or report data in the DW
13.	Does your hub have NLP capabilities? (Yes/No)
14.	Does your hub have free text search capabilities? (Yes/No)
15.	How is NLP used in your data warehouse? (open text)
16.	% of patients with at least one vital sign recorded (temp/heart rate/BP/weight/BMI)
17.	% of unique patients with a with smoking status
18.	% of unique patients with an opioid use disorder
19.	% of unique patients with an insurance provider
20.	% of unique patients with an insurance status

Standardized scripts for the OMOP, PCORnet and i2b2/ACT data models are available on this GitHub site. Hubs are be responsible for modifying the scripts for their own purposes of reporting the metric data

Hubs using TriNetX must have a designated user from the site should send an email to CTSA@trinetx.com 

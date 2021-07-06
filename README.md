# CTSA Metrics

## About

This Github repository provides scripts, data model documentation and associated files for the Informatics Common Metric for the CTSA Program.
Rationale

To accelerate translation, researchers need to be provided with access to a broad range of data (electronic health records, omics, imaging, genetics, behavioral, etc.). These data can come from different sources such as clinical databases, research datasets, sensors, mobile technology, patient generated data, and publicly available data sets. The sharing and pooling of data within and across CTSA Program hubs requires that data be represented in a format that can be queried and adheres to commonly accepted standards. A longer-term goal of the CTSA Program is to harmonize data and data standards so that a query written by any site can be run unaltered against all CTSA Program data repositories. 

The purpose of this common metric is to increase interoperability of data across the consortium. This common metric demonstrates the strength of each hub, contributes data to the national mission, and continues to increase interoperability across the consortium annually to efficiently use data to conduct scientific research. Specifically, the metrics on different data types will aid local hubs in prioritizing additions to their data repositories. Improving the CTSA Program’s clinical research data ecosystem can enhance the effectiveness of collaborative initiatives within and outside of the CTSA Program to provide tools to identify patient cohorts (i2b2/ACT, SHRINE, All of Us, PCORI).

This metric will evolve over time to enhance the completeness of the research data warehouses across the CTSA Program consortium and incorporate additional types of data within warehouses as the CTSA Program, in collaboration with the iEC, finds useful and appropriate.

## Metric
The data models approved for this metric by the Informatics Enterprise Committee (iEC) are: OMOP, PCORnet, i2b2/ACT (or other i2b2 data models), and TriNetX. Data is to be collected for both one- and five-year periods. **The metric output is described in 'Informatics Output for 2020 Data.csv'**
The majority of the domains for this metric require information at both the patient and encounter level. Denominators for these calculations include:
1.	Total number of unique patients in the data warehouse
2.	Total number of unique encounters in the data warehouse
3.	Total number of unique patients over age 12 in the data warehouse

The Operational Guideline includes all of the metric details and can be accessed here. 
Standardized scripts for the OMOP, PCORnet and i2b2/ACT data models are available on this Github site. For hubs that choose to use i2b2 with their own hub-specific data model, that hub will be responsible for generating the script for their own purposes of reporting the required metric data


Hubs using TriNetX must have a designated user from the site should send an email to CTSA@trinetx.com to request a CTSA Program Common Metric report. TriNetX will create the report and send it to the requesting site.

# CTSA-Metrics

## About
This Github repository provides background information, scripts and associated files for the Informatics Common Metric for the CTSA Program.

## Rationale 
To accelerate translation, researchers need to be provided with access to a broad range of data (electronic health records, omics, imaging, genetics, behavioral, etc.). 
These data can come from different sources ok such as clinical databases, research datasets, sensors, mobile technology, patient generated data, and publicly available data sets. The sharing and pooling of data within and across CTSA Program hubs requires that data be represented in a format that can be queried and adheres to commonly accepted standards. A longer-term goal of the CTSA Program is to harmonize data and data standards so that a query written by any site can be run unaltered against all CTSA Program data repositories. Before we can complete such a data harmonization, we first need an understanding of what types of data are being collected, managed, and stored in each hub’s data repository and how much of this data is in a standard format. 

This Common Metric will provide a baseline scan of the level of coverage of the types of data that each hub should have in their data repository. The purpose of this common metric is to identify clinical data gaps and opportunities for improvement. This common metric will improve local as well as network capacity to efficiently use data  to conduct research. Improving the CTSA Program’s clinical research data ecosystem can enhance the effectiveness of collaborative initiatives within and outside of the CTSA Program to provide tools to identify patient cohorts (ACT, i2b2/ACT, SHRINE, All of Us, PCORI).

## Metric
The type of data model used in this metric (approved by the iDTF): OMOP, PCORnet, i2b2/ACT, and TriNetX
This metric results in the following 3 scores (for each data type domain):
* Count of unique patients with the standard value (numerator)
* Count of unique patients within the clinical data repository (denominator)
* Percent of unique patients with the standard value (% = [numerator]/[denominator])

## Additional Information
See detailed description of numerator and denominator statements at: https://docs.google.com/spreadsheets/d/1z_WGSaD5rxt68wbdcEAVE9CtiXAn2IN5SLFcH2RI370/edit#gid=0

The draft operational guidelines can be found here: https://docs.google.com/document/d/1QrB6w6lJJ_a16bnxYsdU1jzGrMkE6B3o4BGj1ERAUUk/edit 

For background information about the CTSA Program Common Metrics Initiative please see here: http://www.tuftsctsi.org/research-services/research-process-improvement/common-metrics-initiative/ 

To participate in a survey that assesses the technical feasability of the scripts, please visit: https://goo.gl/forms/2wDybtNqis8lovoa2
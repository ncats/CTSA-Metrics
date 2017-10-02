# CTSA-Metrics

## About
This Github repository provides background information, scripts and associated files for the Informatics Common Metric for the CTSA Program.

## Rationale 
To accelerate translation, researchers need to be provided with access to a broad range of data (electronic health records, omics, imaging, genetics, behavioral, etc.). 
This data can come from different sources, such as clinical databases, research datasets, sensors, mobile technology, patient generated data, and publicly available data sets. The sharing and pooling of data within and across CTSA Program hubs requires data to be represented in a format that can be queried and adheres to commonly accepted standards. A long-term goal of the CTSA Program is to harmonize data and data standards so that a query written by any site can be run against all CTSA Program data repositories. Before we can complete such data harmonization, we first need to understand of what types of data are being collected, managed, and stored in each hub’s data repository and how much of this data is in a standard format. 

This Common Metric will provide a baseline scan of the level of coverage of the types of data that each hub should have in their data repository. The purpose of this common metric is to identify clinical data gaps and opportunities for improvement. This common metric will improve local and network capacity to efficiently use data to conduct research. Improving the CTSA Program’s clinical research data ecosystem can enhance the effectiveness of collaborative initiatives within and outside of the CTSA Program to provide tools to identify patient cohorts (ACT, i2b2/ACT, SHRINE, All of Us, PCORI).

## Metric
The type of data model used in this metric (approved by the iDTF): OMOP, PCORnet, i2b2/ACT, and other i2b2 data models.
This metric results in the following 3 scores (for each data type domain):
* Count of unique patients with the standard value (numerator)
* Count of unique patients within the clinical data repository (denominator)
* Percent of unique patients with the standard value (% = [numerator]/[denominator])

## Additional Information

The draft operational guidelines can be found here: https://docs.google.com/document/d/1QrB6w6lJJ_a16bnxYsdU1jzGrMkE6B3o4BGj1ERAUUk/edit 

For background information about the CTSA Program Common Metrics Initiative please see here: http://www.tuftsctsi.org/research-services/research-process-improvement/common-metrics-initiative/ 

To participate in a survey that assesses the technical feasibility of the scripts, please visit: https://goo.gl/forms/2wDybtNqis8lovoa2 

Queries/scripts will be provided to hubs for the OMOP, PCORnet and i2b2/ACT data models.  These queries/scripts will enable standardized automated query against the data repository (or repositories) at each of the CTSA hubs. The scripts will be developed, tested, and approved collaboratively by the Informatics Common Metric Development Team with the iDTF.  Data model scripts are found on this github site. 
	
For hubs that choose to use the approved data models that are also utilized by TriNetX, TriNetX will provide the metric data to your hub directly for incorporation into your Scorecard.  For hubs that choose to use the approved data models that are also utilized by TriNetX, TriNetX will provide the metric data to your hub directly for incorporation into your Scorecard. For hubs that choose to use the approved data models that are also utilized by TriNetX, TriNetX will provide the metric data to your hub directly for incorporation into your Scorecard. [Note: TriNetX supports the CTSA Program Common Metric for Informatics Solutions.  As end users do not have direct access to the in-memory databases on their local or hosted appliances, TriNetX has created a report that can be requested by the individual CTSA Program hubs.  A designated user from the site should send an email to CTSA@trinetx.com requesting the CTSA Program Common Metric report.  TriNetX will then create the report and send it to the requesting site admin.]

For hubs that choose to use i2b2 with their own hub-specific data model, that hub will be responsible for generating the script for their own purposes of reporting the required metric data.

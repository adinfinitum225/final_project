# Final Project: Post-Secondary Employment Outcomes Prediction Modeler 

This the Readme file for the project being made by UT-Austin Bootcamp group #2. This Readme File was last updated on May 8th, 2022. 

*NOTE: The data elements of College Scoreboard Data and IEPDS Data were incorporated into this presentation at a later phase during segmenet 1. The files are not necessary to our overarching goal but the project will benefit from their inclusion. They will either be fully incorporated as we move towards the data analysis and data cleaning stage or they will be exlcuded if they are found to be nonviable or cumbersome.*

## Selected Topic: Post-Secondary Employment Outcomes

#### Problem

Higher Education certificates are widely regarded as a public good and a personal asset. Students go to college with the intent of attaining a better future and securing upward mobility and higher wages.

Nonetheless, there may be a discrepancy between perceived and real outcomes conferred by higher education degrees. A recent widely circulated study by "Real Estate Witch" reported that college students overestimated their projected earnings by almost 88%.[^1] This suggests a significant detachment between expectations of graduate outcomes and the outcomes attained. These findings suggest a need for students to have access to a tool that allows them to accurately predict their earning potentials.

#### Objective

The goal of this project is to analyze student outcomes at the institutional level by assessing longitudinal data on job placement and income levels by different fields of study. Additionally, this project aims to create a machine learning model that predicts student outcomes based on input data such as institutional type, institutional size, field of learning, and degree level pursued. 

The creation of this machine learning model will allow students to correctly estimate their potential earning potentials, which degrees will lead to best outcomes, and ultimately, which institution will best serve their interests. 

## Data Selection 

#### Post-Secondary Employment Outcomes (PSEO) [^2]

- PSEO data elements are datafiles produced by means of a collaborative effort between state level Higher Education Coordinating Boards and the US Census Bureau. The files contain information on earnings and employment outcomes for graduates from post-secondary institutions within the United States. These files are considered 'experimental' and were first published at or about April 2nd, 2018.[^3] 

- The stated goal of this data's publication is to improve federal statistical infrastructure by facilitating the tracking of student outcomes across state lines by means of an intra and inter-state data sharing agreements. Previously, data on student outcomes was monitored by a state's respective workforce commission. This resulted in student outcome tracking that was siloed within state lines. The data sharing initiative fostered by this project allows users to track post-graduate outcomes nationwide, irrespective of the initial state of graduation. *NOTE: Rates of higher education institution participation rates vary significantly from state to state as participation in the project is voluntary.* [^4]

#### Post-Secondary Employment Flows (PSEF) [^5]

- The Job-to-job flows (J2J) A.K.A PSEF datafiles are statistics on job mobility in the United States. Statistics include 1) job-to-job transition rates 2) hires and separations from employment and 3) origins and destinations for job related transitions.[^6]

- The datafile in conjunction with the PSEO datafiles serve as the main data elements used in this analysis. The combination of these files enables users to track student employment and student earning outcomes across state lines.  


#### College Scoreboard Data (CSD) [^7]

- These datafiles are published by the US Dept. of Education. The files focus on entering cohorts of students and their earnings over a period of time. These files are produced by matching federal financial aid data to IRS tax records. Two (2) key elements in these datafiles are of critical interest to this project: the variables OEP ID and IPEDS ID. The presence of the OEP ID values enables us to match and merge these data files with the PSEO and PSEF datafiles. Additionally, the presence of the IPEDS ID provides a means of incorporating additional institutional data collected and maintained by the National Center of Education Statistics (NCES). 


#### Integrated Postsecondary Education Data System (IPEDS)[^8]

- IPEDS data are data elements collected for every postsecondary education institution in the US on a diverse range of areas including the following: Institutional characteristics, Institutional prices / tuition, Admissions, Finances, and others. Data collection is mandatory for all higher education institutions and is collected on an annual basis by the NCES. 

- For the purpose of this study, we are primarily interested in institutional characteristics. The category of institutional characteristics includes such information as tuition and fees, room and board, institutional category (public vs private), degree of rurality (urban vs fringe), size of the institution (large vs small), and various other details at the institutional level. The usage of these data files promotes the matching of a greater amount of institutional information into our machine learning models.

## Questions: 

1) Is it possible to predict student employment outcomes using a supervised machine learning model? 

2) What degrees are most associated with higher levels of economic outcomes among graduating students at different degree levels? 

3) What is the variance of student employment outcomes across different degree types (IE: Associates, Bachelors, Masters, etc) ?

4) What institutional characteristics are associated with higher earning potentials overall? 

5) What is the relationship between student debt and student outcomes? 

## Technologies Used: 

#### Data Cleaning and Analysis
Panda Dataframes and python coding script are used in the Jupyter Notebook platform for data checks, data validation, and other exploratory analyses. 

#### Database Storage
Postgres SQL and pgAdmin are used as our database for storing the tables of data used in this study. Amazon Web Services (AWS) is also used to host raw datasets such that the data may be accessed by multiple users. 

Examples URL to the datafiles on AWS are below: 

https://jamesliu-databootcamp-bucket.s3.us-east-2.amazonaws.com/pseoe_all.csv 

https://jamesliu-databootcamp-bucket.s3.us-east-2.amazonaws.com/pseof_all.csv

#### Machine Learning
A supervised Machine learning model is used for the purpose of this analysis. The goal is to build a model that assists in determining which higher education institutions are likely to provide good employment outcomes for graduates using inputs sourced from IPEDS Institutional characteristics datafiles. 

#### Dashboard
A Tableau dashboard is used to visualize and present the data. The dashboard may be embedded on an HTML page created for the purpose of this project. 

#### Languages
Python, HTML, JS, and CSS are expected to be the languages used in this project. Python to source and manipulate the data and HTML, JS, and CSS to assist in visualizations and interactivity with the final outputs. 


[^1]: https://www.realestatewitch.com/college-graduate-salary-2022
[^2]: https://lehd.ces.census.gov/data/pseo_documentation.html
[^3]: https://www.census.gov/newsroom/press-releases/2018/education-pilot.html
[^4]: https://lehd.ces.census.gov/data/pseo/latest_release/all/pseo_all_partners.txt
[^5]: https://lehd.ces.census.gov/data/#j2j
[^6]: https://lehd.ces.census.gov/data/schema/j2j_latest/lehd_public_use_schema.html
[^7]: https://collegescorecard.ed.gov/data/
[^8]: https://nces.ed.gov/ipeds/use-the-data

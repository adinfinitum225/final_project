# Final Project: Post-Secondary Employment Outcomes Prediction Modeler 

This the Readme file for the project being made by UT-Austin Bootcamp group #2. 

![image](https://user-images.githubusercontent.com/95975772/171069131-12cfcbef-9eba-441f-9a81-16e1f98c36fa.png)


<p align="center">
  <img width="460" height="300" src="![image](https://user-images.githubusercontent.com/95975772/171069540-33b0a718-a648-4670-9f81-b4f1a98f7737.png)">
</p>


## Selected Topic: Post-Secondary Employment Outcomes

#### Problem

Higher Education certificates are widely regarded as a public good and a personal asset. Students go to college with the intent of attaining a better future and securing upward mobility and higher wages.

Nonetheless, there may be a discrepancy between perceived and real outcomes conferred by higher education degrees. A recent widely circulated study by "Real Estate Witch" reported that college students overestimated their projected earnings by almost 88%.[^1] This suggests a significant detachment between expectations of graduate outcomes and the outcomes attained. These findings suggest a need for students to have access to a tool that allows them to accurately predict their earning potentials.

#### Objective

The goal of this project is to analyze student outcomes at the institutional level by assessing longitudinal data on job placement and income levels by different fields of study. Additionally, this project aims to create a machine learning model that predicts student outcomes based on input data such as institutional type, institutional size, field of learning, and degree level pursued. 

The creation of this machine learning model will allow students to correctly estimate their potential earning potentials, which degrees will lead to best outcomes, and ultimately, which institution will best serve their interests. 

## Questions: 

1) Is it possible to predict student employment outcomes using a supervised machine learning model? If so, how accurate can the model become?

2) Is there a difference between the employment outcomes for students who graduated and stayed in the state of their Alma mater vs those who relocated out of state?

3) What is the variance of student employment outcomes across different degree types (IE: Associates, Bachelors, Masters, etc) ? Are there some types of certifications that are assocaited wtih greater levels of income?

4) What college majors (CIP Codes) are most frequently associated with higher income earnings?

##ETL (Extract, Transform, Load)

#### Extract 

## Data Selection 

The main data files used in this analysis were both sourced from files produced and maintained by the U.S. Census Bureau. All files were iniitally downloaded as CSV files from the Longitudinal Employer-Household Dynamics Webage [1]  Details about the files are provided below. 

#### Post-Secondary Employment Outcomes (PSEO) [^2]

- PSEO data elements are datafiles produced by means of a collaborative effort between state level Higher Education Coordinating Boards and the US Census Bureau. The files contain information on earnings and employment outcomes for graduates from post-secondary institutions within the United States. These files are considered 'experimental' and were first published at or about April 2nd, 2018.[^3] 

- The stated goal of this data's publication is to improve federal statistical infrastructure by facilitating the tracking of student outcomes across state lines by means of an intra and inter-state data sharing agreements. Previously, data on student outcomes was monitored by a state's respective workforce commission. This resulted in student outcome tracking that was siloed within state lines. The data sharing initiative fostered by this project allows users to track post-graduate outcomes nationwide, irrespective of the initial state of graduation. *NOTE: Rates of higher education institution participation rates vary significantly from state to state as participation in the project is voluntary.* [^4]

#### Post-Secondary Employment Flows (PSEOF) [^5]

- The Job-to-job flows (J2J) A.K.A PSEOF datafiles are statistics on job mobility in the United States. Statistics include 1) job-to-job transition rates 2) hires and separations from employment and 3) origins and destinations for job related transitions.[^6]

- The datafile in conjunction with the PSEO datafiles serve as the main data elements used in this analysis. The combination of these files enables users to track student employment and student earning outcomes across state lines.  

#### Transform (Data Cleaning and Data Exploration) 

The data cleaning process was executed using python langauge script coupled with Jupyter notebook software. The process was divided into several steps:

**1) Importation of Dependencies:** Numpy was imported as as np and pandas as pd.

**2) Extraction and Testing:**  PSEOE and PSEOF data files were extracted and uploaded to the Jupyter Notebook interface. Preliminary tests were conducted to ensure the file uploaded correctly. 

**3) File Review:** Descriptive information was obtained from the two data files on column data types, column names, counts of null values, and number of rows.

**4 - 8) Transformations:** Several transformations were run on the data files. The first transformation inolved the matching of 'aggregation level' variables across the datasets. It was observed that there were only a few aggregation levels that were shared in common between them (38, 40, 44, and 46). Only rows of data that contained these values were retained for the subsequent steps. Since there was no extant primary key variable in the data files, one was created by concatenating all columns in both data sets that met the twofold criteria of being 1) the same variables across both data sets and 2) no null values in any of those columns. This resulted in a MERGERID variable that was the concatentation of thw following variables shared in common 1) aggregation level 2) institution level 3) degree level 4) cip level 5) cipcode 6) grad cohort 7) grad cohort years 8) geo level 9) geography 10) industry level and 11) industry. The execution of this data transformation required the conversion of all these variable column types into strings. Tests were then run on both datasets to ensure that this arteficially created MERGERID variable was unique and contained no duplicate cases of the same value in either data set. The tests showed that they were unique. When this step was completed, the data files were prepared for merging by dropping columns that were not necessary to the anaylsis and which had to be dropped in order to execute a merger across the files. The files were then merged on teh basis of the shared MERGERID column. Lastly, a number of iterative tests were conducted on the final mergered file to determine which aggregation level was to be used in the final analysis. These iterations suggested that only year 1 and year 5 contained enough values such as would be sufficient for a detailed analysis of the data.      

**9) Summary statistics:** Tests were conducted on the merged data file to determine what level of aggregation would best represent the data with the least amount of distortions. It was determined that the aggregation level of '46' had the greatest amount of rows of data that were non-null and which also satisfied the condition of representing the overall data files with the least amount of distortions. On this basis the aggregatoin level of '46' was retained while '40' was dropped.
 
**10) Summary of findings:** This section contains a brief summary of all the aformentioned steps and the key resulting observations from each step in the analysis.

#### Database 

Once the steps in the transform phase of the ETL were executed and substantiated in Jupyter Notebook using Python language, they were repeated in PySpark and added to an AWS database connection. The transformed files were stored in an Amazon S3 cloud object storage file container and querried using an Amazon Relational Database Service (RDS) connected with PostgresSQL. An image of the schema used in the connection is provided below:

SQL schema image: 


AWS S3 file storage links:

https://jamesliu-databootcamp-bucket.s3.us-east-2.amazonaws.com/pseoe_all.csv 

https://jamesliu-databootcamp-bucket.s3.us-east-2.amazonaws.com/pseof_all.csv


## Machine Learning

#### Data Preprocessing
During the data preprocessing step, the inst_level, geo_level, and ind_level columns were dropped from the analysis, as they were object type variables that only contained one value, ex: "I". THe other object data type column, cip_level, was dealt with by replacing all "A" values with the number 1, so that all data was the same type. One-hot encoding was then used and finally the datatype was changed. After attempting to run the model a couple of times, it was discovered that there are a lot of unncessary columns that complicated and messed with the analysis. Since we wanted to predict earnings on a 1 and 5 year timeframe, other variables that also had a time element needed to be dropped. 
#### Preliminary Model Features
For one of our models we attempt to predict income amount. For the other model we changed the earnings columns to 0 or 1 based on income amount, to predict whether or not a person will make more or less than the approximate median. For the first year analysis the number was set at $35,000, while for the 5th year it was set at $50,000. These numbers were chosen because roughly they were roughly the median income for their respective years. The machine learning model used the Keras Sequential neural network with a first layer "relu" activation function, another relu activation function for a hidden layer, and a sigmoid activation function for the output layer. The model was run for 25 epochs in each case.
#### Train-Test Splits
Train test splits function was imported from SKlearn to split the data into training and testing sets. The features dataset was the dataframe with all of the preprocessing done, while the target dataset was the 50th percentile earnings column. There were two tests run, one with year 1 earnings, the other with year 5 earnings. The features dataset stayed the same for both tests. 
#### Results
A neural network was used because they excel at finding hidden insights from data. They also do well at handling a large number of imports and features, which our dataset has. We also tested a logistic regression model, but will stick with a neural network as it performed much better. A potential drawback of using a neural netowrk is that we may not know why/which features exactly help predict post graduation earnings. When attempting to predict year 1 earnings the model is within $6,000 on average and within $9,500 for year 5 earnings. The model accuray was approximately 78.5% accurate at choosing whether or not students would make $35,000 or more in their first year out of school. For year 5 earnings the model still performed well with an accuracy of 77.5%.


##Dashboard and Visualizations

Our group used Tableau to create visuals used to represent the data files. Access to the dashboard may be found here: 

https://public.tableau.com/views/FinalProjectStory1/Story1?:language=en-US&:display_count=n&:origin=viz_share_link

####Key findings and observations 

**Differences in earnings across Degree types (use degree level img here)
The chart shows the average earnings by degree classification between three (3) different quartiles of income earners. The data shows that consistently, those who graduate at the Doctoral levels on average make more income than all other types of graduates. Within this category, it appears to indicate that the subclassifiction of Doctoral - Research degree on average tend to make less than after 1 year of graduation compared to those who graduate with a Doctoral (Professional) degree. The chart further indicates that consistently across all three quartiles of income earnings, students who graduate with a Baccalurateate on average may be expected to outperform the income potentials of those who graduate with an Associates degree. Lastly, it appears that there is some varience across all non-degree certificate categories (IE: Post-Bacc, Certificate 2-4 years, etc). This may be due to the fact that non-degree certificates tend to be pursued by persons who aer more advanced in their careers than those who are just graduating with a Baccaularelate. Additional exploration into the topic will require the future inclusion of age related variables into the data files.  

**Differences in earnings by College major (use Cipcode here)
The chart shows the average expected earnings of students who graduate by different college majors. College majors are assigned a numeric digit which identifies the major as being of a particular category. The following observations can be made about the data.

* On average, students who graduate at the CIP Code 60 (residency Programs such as Dentists, veterinarian, Medical fields) consistently earn the most of any higher education degree across all other categories 1 year after graduating and also 5 years after graduating. 
* Additionally, graduates from this degree category experienced the greatest amount of average income increases from the time when they graduate to after 5 years.  
* On average, it appears that most 1 year income earnings are below $60K, with the exceptions of Engineering and Residency higher education programs. 
* Lastly, it appears that on average, graduates from degrees identified as falling under the Personal and culinary services category are likely to make the lowest average earnings post-graduation across both periods of cohorts, both 1-year after graduation and 5 years after graduation.

**Differences By in state vs out of state






##Future analysis
#### College Scoreboard Data (CSD) [^7]

- These datafiles are published by the US Dept. of Education. The files focus on entering cohorts of students and their earnings over a period of time. These files are produced by matching federal financial aid data to IRS tax records. Two (2) key elements in these datafiles are of critical interest to this project: the variables OEP ID and IPEDS ID. The presence of the OEP ID values enables us to match and merge these data files with the PSEO and PSEOF datafiles. Additionally, the presence of the IPEDS ID provides a means of incorporating additional institutional data collected and maintained by the National Center of Education Statistics (NCES). 


#### Integrated Postsecondary Education Data System (IPEDS)[^8]

- IPEDS data are data elements collected for every postsecondary education institution in the US on a diverse range of areas including the following: Institutional characteristics, Institutional prices / tuition, Admissions, Finances, and others. Data collection is mandatory for all higher education institutions and is collected on an annual basis by the NCES. 

- For the purpose of this study, we are primarily interested in institutional characteristics. The category of institutional characteristics includes such information as tuition and fees, room and board, institutional category (public vs private), degree of rurality (urban vs fringe), size of the institution (large vs small), and various other details at the institutional level. The usage of these data files promotes the matching of a greater amount of institutional information into our machine learning models.



[^1]: https://lehd.ces.census.gov/data/pseo_experimental.html
[^1]: https://www.realestatewitch.com/college-graduate-salary-2022
[^2]: https://lehd.ces.census.gov/data/pseo_documentation.html
[^3]: https://www.census.gov/newsroom/press-releases/2018/education-pilot.html
[^4]: https://lehd.ces.census.gov/data/pseo/latest_release/all/pseo_all_partners.txt
[^5]: https://lehd.ces.census.gov/data/#j2j
[^6]: https://lehd.ces.census.gov/data/schema/j2j_latest/lehd_public_use_schema.html
[^7]: https://collegescorecard.ed.gov/data/
[^8]: https://nces.ed.gov/ipeds/use-the-data

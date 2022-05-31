# Final Project: Post-Secondary Employment Outcomes Prediction Modeler 

This the Readme file for the project being made by UT-Austin Bootcamp group #2. 

![image](https://user-images.githubusercontent.com/95975772/171069131-12cfcbef-9eba-441f-9a81-16e1f98c36fa.png)

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

3) What is the variance of student employment outcomes across different degree types (IE: Associates, Bachelors, Masters, etc) ? Are there some types of certifications that are associated with greater levels of income?

4) What college majors (CIP Codes) are most frequently associated with higher income earnings?

## Data Selection 

#### Post-Secondary Employment Outcomes (PSEO) [^2]

- PSEO data elements are datafiles produced by means of a collaborative effort between state level Higher Education Coordinating Boards and the US Census Bureau. The files contain information on earnings and employment outcomes for graduates from post-secondary institutions within the United States. These files are considered 'experimental' and were first published at or about April 2nd, 2018.[^3] 

- The stated goal of this data's publication is to improve federal statistical infrastructure by facilitating the tracking of student outcomes across state lines by means of an intra and inter-state data sharing agreements. Previously, data on student outcomes was monitored by a state's respective workforce commission. This resulted in student outcome tracking that was siloed within state lines. The data sharing initiative fostered by this project allows users to track post-graduate outcomes nationwide, irrespective of the initial state of graduation. *NOTE: Rates of higher education institution participation rates vary significantly from state to state as participation in the project is voluntary.* [^4]

#### Post-Secondary Employment Flows (PSEOF) [^5]

- The Job-to-job flows (J2J) A.K.A PSEOF datafiles are statistics on job mobility in the United States. Statistics include 1) job-to-job transition rates 2) hires and separations from employment and 3) origins and destinations for job related transitions.[^6]

- The datafile in conjunction with the PSEO datafiles serve as the main data elements used in this analysis. The combination of these files enables users to track student employment and student earning outcomes across state lines.  

## ETL (Extract, Transform, Load)

The ETL process executed primarily using python language script coupled with Jupyter notebook software. The main data files used in this analysis were both sourced from files produced and maintained by the U.S. Census Bureau. All files were initially downloaded as CSV files from the Longitudinal Employer-Household Dynamics Wwbage [1]  Details about the ETL process are detailed below: 

#### Extraction 

**1) Importation of Dependencies:** Numpy was imported as np and pandas as pd.

**2) Extraction and Testing:**  PSEOE and PSEOF data files were extracted and uploaded to the Jupyter Notebook interface. Preliminary tests were conducted to ensure the file uploaded correctly. 

**3) File Review:** Descriptive information was obtained from the two data files on column data types, column names, counts of null values, and number of rows.

#### Transformation 

**4) Initial Transformation:** Several transformations were run on the data files. The first transformation involved the matching of 'aggregation level' variables across the datasets. It was observed that there were only a few aggregation levels that were shared in common between them (38, 40, 44, and 46). Only rows of data that contained these values were retained for the subsequent steps. 

**5) Creation of MERGERID:** Since there was no extant primary key variable in the data files, one was created by concatenating all columns in both data sets that met the twofold criteria of being 1) the same variables across both data sets and 2) no null values in any of those columns. This resulted in a MERGERID variable that was the concatenation of the following variables shared in common 1) aggregation level 2) institution level 3) degree level 4) CIP level 5) CIP Codes 6) grad cohort 7) grad cohort years 8) geo level 9) geography 10) industry level and 11) industry. The execution of this data transformation required the conversion of all these variable column types into strings. Tests were then run on both datasets to ensure that this artificially created MERGERID variable was unique and contained no duplicate cases of the same value in either data set. The tests showed that they were unique. 

![image](https://user-images.githubusercontent.com/95975772/171070765-3582117f-6e33-4d5f-b676-ddcbc23e3643.png)

**6) Dropping unwanted data:** When this step was completed, the data files were prepared for merging by dropping columns that were not necessary to the analysis and which had to be dropped in order to execute a merger across the files. 

**7) Merging Files:** The files were then merged on the basis of the shared MERGERID column. 

**8) Testing Unit of Analysis variables:** Lastly, a number of iterative tests were conducted on the final merged file to determine which aggregation level was to be used in the final analysis. These iterations suggested that only year 1 and year 5 contained enough values such as would be sufficient for a detailed analysis of the data.      

**9) Summary statistics:** Tests were conducted on the merged data file to determine what level of aggregation would best represent the data with the least amount of distortions. It was determined that the aggregation level of '46' had the greatest amount of rows of data that were non-null and which also satisfied the condition of representing the overall data files with the least amount of distortions. On this basis the aggregation level of '46' was retained while '40' was dropped.
 
**10) Summary of findings:** This section contains a brief summary of all the aforementioned steps and the key resulting observations from each step in the analysis.

![image](https://user-images.githubusercontent.com/95975772/171070785-87e6a4e5-2486-46eb-89d0-0e5366e03819.png)

#### Loading into Database 

Once the steps in the transform phase of the ETL were executed and substantiated in Jupyter Notebook using Python language script, they were repeated in PySpark using Google Colab. The transformed files were then added to an Amazon S3 cloud object storage file container and queried using an Amazon Relational Database Service (RDS) connected with PostgresSQL. An image of the process is provided below: 

### S3 Data connections

![image](https://user-images.githubusercontent.com/95975772/171071041-534f1ed9-a509-4f33-89c2-6d1da78831e6.png)

https://jamesliu-databootcamp-bucket.s3.us-east-2.amazonaws.com/pseoe_all.csv 

https://jamesliu-databootcamp-bucket.s3.us-east-2.amazonaws.com/pseof_all.csv


## Machine Learning

#### Data Preprocessing
During the data preprocessing step, the inst_level, geo_level, and ind_level columns were dropped from the analysis, as they were object type variables that only contained one value, ex: "I". The other object data type column, cip_level, was dealt with by replacing all "A" values with the number 1, so that all data was the same type. One-hot encoding was then used and finally the datatype was changed. After attempting to run the model a couple of times, it was discovered that there are a lot of unnecessary columns that complicated and messed with the analysis. Since we wanted to predict earnings on a 1 and 5 year timeframe, other variables that also had a time element needed to be dropped. 

#### Preliminary Model Features
For one of our models we attempt to predict income amount. For the other model we changed the earnings columns to 0 or 1 based on income amount, to predict whether or not a person will make more or less than the approximate median. For the first year analysis the number was set at $35,000, while for the 5th year it was set at $50,000. These numbers were chosen because roughly they were roughly the median income for their respective years. The machine learning model used the Keras Sequential neural network with a first layer "relu" activation function, another relu activation function for a hidden layer, and a sigmoid activation function for the output layer. The model was run for 25 epochs in each case.

#### Train-Test Splits
Train test splits function was imported from SKlearn to split the data into training and testing sets. The features dataset was the dataframe with all of the preprocessing done, while the target dataset was the 50th percentile earnings column. There were two tests run, one with year 1 earnings, the other with year 5 earnings. The features dataset stayed the same for both tests. 

#### Results
A neural network was used because they excel at finding hidden insights from data. They also do well at handling a large number of imports and features, which our dataset has. We also tested a logistic regression model, but will stick with a neural network as it performed much better. A potential drawback of using a neural network is that we may not know why/which features exactly help predict post graduation earnings. When attempting to predict year 1 earnings the model is within $6,000 on average and within $9,500 for year 5 earnings. The model accuracy was approximately 78.5% accurate at choosing whether or not students would make $35,000 or more in their first year out of school. For year 5 earnings the model still performed well with an accuracy of 77.5%.


## Dashboard and Visualizations

Our group used Tableau to create visuals used to represent the data files. Access to the dashboard may be found here: 

https://public.tableau.com/views/FinalProjectStory1/Story1?:language=en-US&:display_count=n&:origin=viz_share_link

#### Summary Observations

**Differences in earnings across Degree types (use degree level img here)**

![image](https://user-images.githubusercontent.com/95975772/171071704-578daab5-3b48-4cb2-bd71-18e06b26e32a.png)

The chart shows the average earnings by degree classification between three (3) different quartiles of income earners. The following observations can be made from the visual: 

1) The data shows that consistently, those who graduate at the Doctoral levels on average make more income than all other types of graduates.
2) The chart further indicates that consistently across all three quartiles of income earnings, students who graduate with a Baccalaureate on average may be expected to outperform the income earnings of those who graduate with an Associates degree at the 25%, 50%, and 75% after 1-year following graduation. 
3) Lastly, it appears that there is some variance  across the non-degree certificate categories (IE: Post-Baccalaureate, Certificate 2-4 years, etc). This may be due to the fact that non-degree certificates tend to be pursued by persons who are more advanced in their careers than those who are just graduating with a Baccalaureate. Additional exploration into the topic will require the future inclusion of age related variables into the data files.  

**Differences in earnings by College major**

![image](https://user-images.githubusercontent.com/95975772/171071543-f2b25417-82b6-4cc2-b8e5-e95ea93299cb.png)

The chart shows the average expected earnings of students who graduate by different college majors. College majors are assigned a numeric digit which identifies the major as being of a particular category. The following observations can be made about the data.

1) On average, students who graduate at the CIP Code 60 (residency Programs such as Dentists, veterinarian, Medical fields) consistently earn the most of any higher education degree across all other categories 1 year after graduating and also 5 years after graduating. 
2) Additionally, graduates from Medical Residency degree programs experienced the greatest amount of average income increases from 1-year post graduation to 5-years post graduation. 
3) On average, it appears that most 1 year income earnings are below $60K, with the exceptions of Engineering Degrees and Residency higher education programs. 
4) Lastly, it appears that on average, graduates from degrees identified as falling under the Personal and culinary services category are likely to make the lowest average earnings post-graduation across both both cohorts, both 1-year after graduation and 5 years after graduation.

**Differences By in state vs out of state

![image](https://user-images.githubusercontent.com/95975772/171071937-8bbfac16-dc02-4146-a56f-92294590fd2b.png)
 
The chart shows the average expected earnings of students who graduated from higher education institution whereat the majority of the students relocated out of state after graduation. The following observations can be made about the data.

1) There appears to be a weak association, if any, between in-state employment and out-of-state employment on student outcomes. More specifically, it appears that both in-state and out-of-state student post-graduation outcomes appears to follow a similar trend whereby most student earnings after 1-year are centered around the $40K mark and most outcomes after 5-years is centered around the $60K mark. 

## Future analysis

There were several limitations in our analysis that could be corrected with additional data elements: 

1) biased sampling: Participation in the data sharing partnership used to produce the PSOE and PSEOF files is voluntary. Fewer than 20 states were represented in the underlying files and participation was heavily slanted towards Texas, Virginia, and New York. This issue may hopefully be corrected as more universities join in the data sharing partnership.

**Visual of state representation in the analysis**
![image](https://user-images.githubusercontent.com/95975772/171072995-fb6ec325-d2bc-4356-89dd-42e0cfd7b05a.png)


2) As mentioned previously, there were limitations in the data caused by the lack of certain key variables such as average age of cohorts. It is possible and likely that there are some students in the certificate cohorts that are on average older than those graduating at the baccalaureate level. This may be biasing the data somewhat on earnings outcomes.

3) Additional data elements. IPEDS data are data elements collected for every postsecondary education institution in the US on a diverse range of areas including the following: Institutional characteristics, Institutional prices / tuition, Admissions, Finances, and others. Data collection is mandatory for all higher education institutions and is collected on an annual basis by the NCES [^7].

For the purpose of this study, we are primarily interested in institutional characteristics. The category of institutional characteristics includes such information as tuition and fees, room and board, institutional category (public vs private), degree of rurality (urban vs fringe), size of the institution (large vs small), and various other details at the institutional level. The usage of these data files promotes the matching of a greater amount of institutional information into our machine learning models. A preliminary analysis of the relatoinship between student earnings post graduation adn institutional characteristics showed promise. When assessing the relationship between institutional local (conceptualized as a scale of rural to urban), a strong relationship between earnings and degree of urbanization was identified, while controlling for other institutional characteristics such as control type (public vs. private) and size of Undergradaute level student cohorts. 

![image](https://user-images.githubusercontent.com/95975772/171073502-321bdf02-625a-4307-83e7-eaa04f39664f.png)


[^1]: https://www.realestatewitch.com/college-graduate-salary-2022
[^2]: https://lehd.ces.census.gov/data/pseo_documentation.html
[^3]: https://www.census.gov/newsroom/press-releases/2018/education-pilot.html
[^4]: https://lehd.ces.census.gov/data/pseo/latest_release/all/pseo_all_partners.txt
[^5]: https://lehd.ces.census.gov/data/#j2j
[^6]: https://lehd.ces.census.gov/data/schema/j2j_latest/lehd_public_use_schema.html
[^7]: https://nces.ed.gov/ipeds/use-the-data

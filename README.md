# Healthcare Data Analysis Project

## Project Overview
This project involves cleaning and analysing healthcare data using SQL. The `Healthcare.sql` file contains scripts to process raw data, perform transformations, and prepare the data for analysis. The steps include creating clean tables, transforming data types, and ensuring data consistency.

## Steps Taken to Analyse the Data

### Viewing Raw Data
The initial step involves viewing the raw data from the `healthcare` table to understand its structure and content.

### Data Cleaning
The data cleaning process includes dropping any existing tables that might interfere with the current analysis and defining a Common Table Expression (CTE) to structure the clean data.
   
- **Dropping Existing Tables:**  
  If tables `healthcare_clean` and `healthcare_data` already exist, they are dropped to avoid conflicts.
   
- **Defining a Common Table Expression (CTE):**  
  The CTE named `healthcare_data` is defined to process and clean the data from the `healthcare` table.

### Creating the Clean Table
The next step involves creating a new table, `healthcare_clean`, using the cleaned data from the CTE.

### Analysing the Clean Data
Once the data is cleaned and structured in the `healthcare_clean` table, various analyses can be performed to gain insights.
   
- **Distribution of Patients by Age Group:**  
  Insight: The distribution of patients by age group shows the number of patients in each age range, which can help identify the age demographics of the healthcare facility's patient population.
   
- **Gender Distribution in the Dataset:**  
  Insight: The gender distribution helps understand the ratio of male to female patients, which can be useful for gender-specific health studies and resource allocation.
   
- **Most Common Medical Conditions:**  
  Insight: Identifying the most common medical conditions can help in understanding prevalent health issues and planning for necessary medical supplies and specialist availability.
   
- **Average Length of Hospital Stay by Medical Condition:**  
  Insight: The average length of hospital stay by medical condition provides insights into which conditions require longer hospitalisations, aiding in hospital management and patient care strategies.
   
- **Total Billing Amount by Insurance Provider:**  
  Insight: The total billing amount by insurance provider helps in analysing the financial aspects related to different insurance companies, which can inform negotiations and policy adjustments.
   
- **Patients Distribution by Blood Type:**  
  Insight: The distribution of patients by blood type is useful for managing blood bank supplies and understanding the blood type demographics of the patient population.

## Conclusion
This project demonstrates the process of cleaning and analysing healthcare data using SQL. By following the steps outlined, we ensure that the data is consistent, accurately transformed, and ready for further analysis. The provided SQL scripts in the `Healthcare.sql` file serve as a comprehensive guide for replicating this data analysis process.

## Key Insights
- Age Group Distribution: Provides the age demographics of patients.
- Gender Distribution: Highlights the ratio of male to female patients.
- Common Medical Conditions: Identifies prevalent health issues.
- Hospital Stay Length: Shows average hospitalisation duration by condition.
- Billing by Insurance Provider: Analyses financial data related to insurance.
- Blood Type Distribution: Useful for blood supply management.


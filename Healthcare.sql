use Projects 

select * from healthcare --view raw data

--data cleaning

-- Drop the tables 'healthcare_clean' and 'healthcare_data' if they already exist
DROP TABLE IF EXISTS healthcare_clean, healthcare_data;

-- Define a Common Table Expression (CTE) named 'healthcare_data'
WITH healthcare_data AS (
    -- Select and process data from the 'healthcare' table
    SELECT  
        -- Subquery to capitalize the first letter of each word in the 'name' column
        (
            SELECT 
                STUFF((
                    SELECT ' ' + CONCAT(UPPER(LEFT(value, 1)), LOWER(SUBSTRING(value, 2, LEN(value) - 1)))
                    FROM STRING_SPLIT(name, ' ')
                    FOR XML PATH(''), TYPE
                ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')
        ) AS name,
        -- Select and retain other columns as they are, with necessary transformations
        age,
        gender,
        [Blood Type] AS blood_type,
        [Medical Condition] AS medical_condition,
        CONVERT(date, [Date of Admission]) AS date_of_admission,
        Doctor AS doctor,
        -- Correct 'Hospital' column entries if they start with 'and'
        CASE 
            WHEN LEFT(Hospital, 3) = 'and' THEN LTRIM(SUBSTRING(Hospital, 4, LEN(Hospital) - 3)) 
            ELSE Hospital 
        END AS hospital,
        [Insurance Provider] AS insurance_provider,
        ROUND([Billing Amount], 2) AS billing_amt,
        [Room Number] AS room_no,
        [Admission Type] AS admin_type,
        CONVERT(date, [Discharge Date]) AS discharge_date,
        Medication AS medication,
        [Test Results] AS test_result
    FROM 
        healthcare
    -- Group by all specified columns to ensure unique rows
    GROUP BY 
        name, 
        age, 
        gender, 
        [Blood Type], 
        [Medical Condition], 
        [Date of Admission], 
        Doctor, 
        Hospital, 
        [Insurance Provider], 
        [Billing Amount], 
        [Room Number], 
        [Admission Type], 
        [Discharge Date], 
        Medication, 
        [Test Results]
    -- Keep only unique rows
    HAVING COUNT(*) = 1
)
-- Insert the cleaned and transformed data into a new table named 'healthcare_clean'
SELECT * 
INTO healthcare_clean 
FROM healthcare_data

SELECT * FROM healthcare_clean



--Q1 What is the average age of patients?

-- Select the average of the 'age' column from the 'healthcare_clean' table and round it to 2 decimal places
SELECT 
    ROUND(AVG(age), 2) AS average_age
FROM 
    healthcare_clean



--Q2 How many patients are male and how many are female?

-- Select the gender and the count of patients for each gender
SELECT 
    Gender, 
    COUNT(*) AS patient_count
-- From the 'healthcare_clean' table
FROM 
    healthcare_clean
-- Group the results by gender
GROUP BY 
    gender



--Q3 How many patients belong to each blood type?

-- Select the blood type and the count of patients for each blood type
SELECT 
    blood_type, 
    COUNT(*) AS patient_count
-- From the 'healthcare_clean' table
FROM 
    healthcare_clean
-- Group the results by blood type
GROUP BY 
    blood_type



--Q4 What are the most common medical conditions among patients?

-- Select the medical condition and the count of patients for each condition
SELECT 
    medical_condition, 
    COUNT(*) AS patient_count
-- From the 'healthcare_clean' table
FROM 
    healthcare_clean
-- Group the results by medical condition
GROUP BY 
    medical_condition
-- Order the results by medical condition in descending order
ORDER BY 
    1 DESC



--Q5 What is the average length of stay for patients (difference between date of admission and discharge date)?

-- Select the average length of stay (in days) for patients
SELECT 
    AVG(DATEDIFF(DAY, date_of_admission, discharge_date)) AS avg_stay
-- From the 'healthcare_clean' table
FROM 
    healthcare_clean



--Q6 How many patients were admitted as urgent, emergency, or elective?

-- Select the admission type and the count of patients for each admission type
SELECT 
    admin_type, 
    COUNT(*) AS patient_count
-- From the 'healthcare_clean' table
FROM 
    healthcare_clean
-- Group the results by admission type
GROUP BY 
    admin_type



--Q7 VHow many patients are admitted each month in the each year?

-- Select the admission type and the count of patients for each admission type
SELECT 
    admin_type, 
    COUNT(*) AS patient_count
-- From the 'healthcare_clean' table
FROM 
    healthcare_clean
-- Group the results by admission type
GROUP BY 
    admin_type


--Q8 How many patients fall into different age groups (e.g., 0-18, 19-35, 36-50, 51+) for each medical condition?

-- Create a Common Table Expression (CTE) to categorize age groups
;WITH age_grp_tab AS (
    SELECT 
        CASE 
            WHEN age BETWEEN 0 AND 18 THEN '0-18'           -- Categorize ages 0-18 as '0-18'
            WHEN age BETWEEN 19 AND 35 THEN '19-35'       -- Categorize ages 19-35 as '19-35'
            WHEN age BETWEEN 36 AND 50 THEN '36-50'       -- Categorize ages 36-50 as '36-50'
            WHEN age > 50 THEN '51+'                      -- Categorize ages greater than 50 as '51+'
        END AS age_groups,                               -- Alias for the categorized age groups
        *                                               -- Select all columns from the healthcare_clean table
    FROM healthcare_clean                                -- Source table named healthcare_clean
)

-- Query to count patients in each age group
SELECT age_groups, COUNT(*) AS patient_count
FROM age_grp_tab                                         -- Use the CTE 'age_grp_tab' as the source
GROUP BY age_groups                                     -- Group results by age_groups to count patients in each category
ORDER BY age_groups


--Q9 Which doctors have the highest percentage of normal test results among their patients?

-- Create a Common Table Expression (CTE) to calculate normal test percentages for each doctor
;WITH ref AS (
    SELECT 
        doctor,
        SUM(CASE WHEN test_result = 'normal' THEN 1 ELSE 0 END) AS normals, -- Count of normal test results
        COUNT(*) AS totals                                               -- Total tests conducted by each doctor
    FROM healthcare_clean                                                 -- Source table named healthcare_clean
    GROUP BY doctor                                                       -- Group results by doctor
),
-- CTE to filter doctors with non-zero totals and calculate normal test percentages
docs AS (
    SELECT 
        doctor,
        ROUND(normals * 100.0 / totals, 2) AS normal_test_percentage       -- Calculate percentage of normal tests
    FROM ref                                                               -- Use the 'ref' CTE as source
    WHERE totals != 0                                                      -- Exclude doctors with zero total tests
    -- ORDER BY normal_test_percentage DESC                               -- Optionally order by normal test percentage descending
)
-- Query to select doctors with 100% normal test percentage
SELECT doctor 
FROM docs
WHERE normal_test_percentage = 100                                        -- Filter for doctors with 100% normal test percentage


-- Q10 Calculate the cumulative billing amount for each month of the current year.
 -- Select monthly and cumulative billing amounts for the current year
SELECT 
    DATEPART(month, date_of_admission) AS month,                        -- Extract month from date_of_admission
    SUM(billing_amt) AS monthly_billing,                               -- Calculate monthly billing amount
    SUM(SUM(billing_amt)) OVER (ORDER BY DATEPART(month, date_of_admission)) AS cumulative_billing  -- Calculate cumulative billing amount
FROM healthcare_clean                                                  -- Source table named healthcare_clean
WHERE 
    DATEPART(year, date_of_admission) = DATEPART(year, GETDATE())      -- Filter for current year's admissions
GROUP BY 
    DATEPART(month, date_of_admission)                                  -- Group results by month of admission
ORDER BY 
    month                                                              -- Order results by month


--Q11 Identify patients who have been admitted multiple times and calculate their average length of stay.

 -- Calculate average stay length and admission count for patients with more than one admission
;WITH stay AS (
    SELECT 
        name,
        DATEDIFF(day, date_of_admission, discharge_date) AS stay_length,  -- Calculate length of stay in days
        COUNT(*) OVER (PARTITION BY name) AS admission_count              -- Count total admissions for each patient
    FROM healthcare_clean                                                -- Source table named healthcare_clean
)

-- Query to select patients with more than one admission and calculate average stay length
SELECT 
    name,
    AVG(stay_length) AS avg_stay,         -- Calculate average stay length for each patient
    admission_count                      -- Display admission count for each patient
FROM stay                                -- Use the 'stay' CTE as source
WHERE admission_count > 1                -- Filter for patients with more than one admission
GROUP BY name, admission_count           -- Group results by name and admission count
ORDER BY admission_count DESC            -- Order results by admission count descending


--Q12 Find patients who were readmitted within 30 days of their previous discharge.

-- Identify consecutive admissions within 30 days for each patient
;WITH patient_admin AS (
    SELECT 
        name,
        date_of_admission,
        discharge_date,
        LEAD(discharge_date, 1) OVER (PARTITION BY name ORDER BY date_of_admission) AS next_admission  -- Fetch next discharge date for the same patient
    FROM healthcare_clean  -- Source table named healthcare_clean
)

-- Query to select patients with consecutive admissions within 30 days
SELECT 
    name,
    date_of_admission,
    discharge_date,
    next_admission
FROM patient_admin  -- Use the 'patient_admin' CTE as source
WHERE 
    next_admission IS NOT NULL  -- Ensure there is a next admission date available
    AND DATEDIFF(day, discharge_date, next_admission) <= 30  -- Calculate the difference in days between discharge and next admission

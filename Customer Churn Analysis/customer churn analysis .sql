/* =====================================================
   CUSTOMER CHURN ANALYSIS PROJECT

   Objective:
   Analyse customer churn behaviour and identify
   factors contributing to customer attrition.

   Business Questions:
   - What is the overall churn rate?
   - Which customer segments churn the most?
   - How much revenue is lost due to churn?
   - Do complaints impact customer retention?
   - Does support quality affect churn?

   Skills Demonstrated:
   - Database Design
   - Primary & Foreign Keys
   - Data Modelling
   - Business KPI Analysis
   - Customer Analytics
   - SQL Joins
   - Aggregations
   - Window Functions
===================================================== */

/* =====================================================
   STEP 1: CREATE DATABASE
===================================================== */

CREATE DATABASE customer_churn_analysis;

USE customer_churn_analysis;
/* =====================================================
   TABLE 1: CUSTOMERS

   Stores customer demographic information.
===================================================== */

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    gender VARCHAR (10),
    age INT,
    city varchar(50),
    join_date DATE,
    customer_segement VARCHAR(20)
    );
    
ALTER TABLE customers
RENAME COLUMN customer_segement TO customer_segment;

/* =====================================================
   TABLE 2: SUBSCRIPTIONS

   Stores subscription information and churn status.
===================================================== */

CREATE TABLE subscriptions (
    subscription_id INT PRIMARY KEY,
    customer_id INT,
    plan_type VARCHAR(20),
    monthly_fee DECIMAL(10,2),
    Start_date Date,
    Status VARCHAR(20),
    foreign key(customer_id)
	REFERENCES customers(customer_id)
    );
ALTER TABLE subscriptions
RENAME COLUMN Start_date TO start_date;

ALTER TABLE subscriptions
RENAME COLUMN Status TO status;


/* =====================================================
   TABLE 3: TRANSACTIONS

   Stores customer payment history.
===================================================== */

CREATE TABLE transactions(
    transaction_id INT PRIMARY KEY, 
    customer_id INT, 
    transaction_date DATE,
    amount DECIMAL(10,2),
    
    foreign key(customer_id)
	REFERENCES customers(customer_id)
    );

/* =====================================================
   TABLE 4: CUSTOMER_SUPPORT

   Stores customer service interactions.
===================================================== */

CREATE TABLE customer_support(
    ticket_id INT PRIMARY KEY,
    customer_id INT, 
    ticket_date DATE,
    issue_type VARCHAR(20),
    resolution_days INT,
    
    foreign key (customer_id)
    references customers(customer_id)
    ); 
    
/* =====================================================
   TABLE 5: COMPLAINTS

   Stores formal customer complaints.
===================================================== */

CREATE TABLE Complaints (
    complaint_id INT PRIMARY KEY,
    customer_id INT, 
    compalaint_date DATE, 
    complaint_category varchar(20),
    
    foreign key (customer_id)
    references customers(customer_id)
); 

ALTER TABLE complaints
RENAME COLUMN compalaint_date TO complaint_date;
 
/* =====================================================
   STEP 2: VALIDATE TABLE CREATION
===================================================== */

SHOW TABLES;

/* =====================================================
   STEP 3: Laoding Data using Wizrad Tool. 
===================================================== */

SELECT * FROM customers;
SELECT * FROM subscriptions;
SELECT * FROM transactions;
SELECT * FROM customer_support;
SELECT * FROM complaints;


/* =====================================================
   STEP 4 : DATA ANALYSIS
===================================================== */


/* =====================================================
   KPI 1: Total Customers

   Business Question:
   How many customers does the business currently have?

   Why it matters:
   - Measures overall customer base size
   - Serves as a baseline KPI for reporting
   - Helps track customer growth over time
===================================================== */

SELECT COUNT(*) AS total_customers
FROM customers;

/* =====================================================
   KPI 2: Overall Churn Rate

   Business Question:
   What percentage of customers have churned?

   Why it matters:
   - Core customer retention metric
   - Measures business health
   - High churn may indicate service issues
===================================================== */

SELECT
    ROUND(
        100.0 *
        COUNT(CASE WHEN status = 'Churned' THEN 1 END)
        / COUNT(*),
        2
    ) AS churn_rate
FROM subscriptions;

/* =====================================================
   KPI 3: Churn Rate by Customer Segment

   Business Question:
   Which customer segment has the highest
   churn rate?

   Why it matters:
   - Identifies high-risk customer groups
   - Supports targeted retention campaigns
   - Helps improve customer lifetime value
===================================================== */

SELECT
    c.customer_segment,
    ROUND(
        100.0 *
        SUM(CASE WHEN s.status='Churned' THEN 1 ELSE 0 END)
        /
        COUNT(*),
        2
    ) AS churn_rate
FROM customers c
JOIN subscriptions s
    ON c.customer_id = s.customer_id
GROUP BY c.customer_segment
ORDER BY churn_rate DESC;

/* =====================================================
   KPI 4: Revenue Lost Due To Churn

   Business Question:
   How much recurring subscription revenue
   has been lost due to churn?

   Why it matters:
   - Quantifies financial impact
   - Supports retention investment decisions
   - Measures revenue leakage
===================================================== */

SELECT
    ROUND(SUM(monthly_fee),2) AS lost_revenue
FROM subscriptions
WHERE status='Churned';

/* =====================================================
   KPI 5: Complaint Impact On Churn

   Business Question:
   Do customers who raise complaints
   churn more frequently?

   Why it matters:
   - Measures relationship between customer
     dissatisfaction and churn
   - Helps identify early warning signs
===================================================== */

SELECT
    CASE
        WHEN co.customer_id IS NULL
        THEN 'No Complaint'
        ELSE 'Complaint Raised'
    END AS complaint_group,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN s.status='Churned'
                THEN 1
                ELSE 0
            END
        )
        /
        COUNT(*),
        2
    ) AS churn_rate

FROM subscriptions s

LEFT JOIN
(
    SELECT DISTINCT customer_id
    FROM complaints
) co
ON s.customer_id = co.customer_id

GROUP BY complaint_group;

/* =====================================================
   KPI 6: Support Resolution Analysis

   Business Question:
   Does slower issue resolution increase
   customer churn?

   Why it matters:
   - Evaluates support team effectiveness
   - Identifies service factors driving churn
===================================================== */

SELECT

    CASE
        WHEN cs.resolution_days < 2
            THEN '<2 Days'

        WHEN cs.resolution_days BETWEEN 2 AND 5
            THEN '2-5 Days'

        ELSE '>5 Days'
    END AS resolution_group,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN s.status='Churned'
                THEN 1
                ELSE 0
            END
        )
        /
        COUNT(*),
        2
    ) AS churn_rate

FROM customer_support cs

JOIN subscriptions s
    ON cs.customer_id = s.customer_id

GROUP BY resolution_group;

/* =====================================================
   KPI 7: Revenue Lost by Customer Segment

   Business Question:
   Which customer segment contributes the most
   lost revenue through churn?

   Why it matters:
   - Combines churn and financial impact
   - Identifies where retention efforts will
     generate the greatest return
===================================================== */

SELECT
    c.customer_segment,
    ROUND(SUM(s.monthly_fee),2) AS revenue_lost
FROM customers c
JOIN subscriptions s
    ON c.customer_id = s.customer_id
WHERE s.status = 'Churned'
GROUP BY c.customer_segment
ORDER BY revenue_lost DESC;


    
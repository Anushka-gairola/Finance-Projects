# Customer Churn Analysis Project (SQL + Python )

## Overview

This project is a complete end-to-end **customer churn analytics pipeline** built using SQL, Python, and Tableau.  
It simulates a subscription-based business and analyzes customer behavior to understand churn patterns, revenue loss, and service impact.

The goal is to demonstrate how raw data can be transformed into **business insights and KPIs** using a structured data analytics workflow.

---

## Business Problem

Subscription businesses face high revenue loss due to customer churn.  
This project aims to answer:

- What is the overall churn rate?
- Which customer segments churn the most?
- How much revenue is lost due to churn?
- Do complaints and support delays impact churn?
- Which plans are most at risk?

---

## Dataset Structure

The project uses a relational database with 5 tables:

### 1. Customers
Stores customer demographic details.

- customer_id (Primary Key)
- gender
- age
- city
- join_date
- customer_segment

---

### 2. Subscriptions
Stores subscription and churn status.

- subscription_id (Primary Key)
- customer_id (Foreign Key)
- plan_type (Basic / Silver / Gold)
- monthly_fee
- start_date
- status (Active / Churned)

---

### 3. Transactions
Stores payment history.

- transaction_id (Primary Key)
- customer_id (Foreign Key)
- transaction_date
- amount

---

### 4. Customer Support
Tracks support tickets and resolution time.

- ticket_id (Primary Key)
- customer_id (Foreign Key)
- ticket_date
- issue_type
- resolution_days

---

### 5. Complaints
Stores formal customer complaints.

- complaint_id (Primary Key)
- customer_id (Foreign Key)
- complaint_date
- complaint_category

---

## Tools Used

- SQL (MySQL) – data modeling, KPI queries
- Python (Pandas, NumPy) – data simulation & transformation
- Excel – intermediate validation and quick checks

---

## Key KPIs

### KPI 1: Overall customer count
Counts the total number of customers 

### KPI 2: Overall Churn Rate
Measures the percentage of customers who churned.

### KPI 3: Churn by Customer Segment
Identifies which customer segments are most at risk.

### KPI 4: Revenue Lost Due to Churn
Calculates total monthly recurring revenue lost from churned customers.

### KPI 5: Complaint Impact on Churn
Analyzes whether customers with complaints are more likely to churn.

### KPI 6: Support Resolution Impact
Evaluates how support resolution time affects churn probability.

### KPI 7: Revenue Lost by Segment
Breaks down churned revenue contribution by customer segment.

---

## Key Insights

- Overall churn rate: ~25%
- Highest churn segment: Standard customers (~29%)
- Complaint-driven churn is significantly higher than non-complaint customers
- Slow support resolution (>5 days) increases churn risk
- Revenue loss is concentrated in mid-tier plans

---

## Project Workflow

1. Designed relational database schema in SQL
2. Imported and cleaned raw CSV data
3. Created Python script to simulate transaction data
4. Built KPI queries using SQL aggregation
5. Exported KPI results 

---

## Files Included

- customers.csv
- subscriptions.csv
- transactions.csv
- customer_support.csv
- complaints.csv
- KPI output CSV files
- SQL schema file


Built as a data analytics portfolio project focusing on:
- Customer analytics
- Business intelligence
- SQL-based KPI engineering
- Data visualization
# Trade Execution & Market Behaviour Analysis (SQL Project)

# Project Overview

This project simulates a real-world trading system database and analyses order execution behaviour using SQL.

# It models how trading desks track:

1. Client orders
2. Market executions
3. Fill efficiency
4. Instrument and sector activity
5. rading behaviour patterns

The goal is to demonstrate business analysis skills using SQL on relational datasets, similar to a front-office or trading analytics environment.

# Objectives
1. Build a relational database for trade order execution
2. Analyse execution efficiency and fill rates
3. Identify trading patterns across instruments and sectors
4. Evaluate client trading behaviour
5. Generate KPI-driven insights for decision-making


# Tech Stack
SQL (MySQL)
Relational Database Design
Joins (INNER & LEFT JOIN)
Aggregations (SUM, AVG, COUNT)
GROUP BY analysis

# Database Schema
1. Orders Table

Stores client order information.

order_id (Primary Key)
client_id
instrument
order_type (LIMIT / MARKET)
quantity
order_price
order_time

2. Executions Table

Stores actual trade executions linked to orders.

execution_id (Primary Key)
order_id (Foreign Key)
executed_quantity
executed_price
execution_time
3. Instruments Table

Reference table for instruments and sectors.

instrument (Primary Key)
sector

#  Key KPIs Developed
1. Total Executed Quantity per Order

Measures how much of each order was filled.

2. Order Fill Rate

Percentage of order successfully executed.

3. Average Execution Price per Order

Evaluates execution quality.

4. Remaining Quantity Analysis

Identifies unfilled portions of orders.

5. Trading Volume by Instrument

Shows most actively traded stocks.

6. Trading Volume by Sector

Identifies sector-level trading concentration.

7. Top Clients by Trading Volume

Highlights most active trading clients.

8. Order Type Analysis (LIMIT vs MARKET)

Compares trading behaviour by order type.

# Key Insights
Trading volume is concentrated in a small number of instruments
Some orders are partially filled, indicating liquidity constraints
MARKET and LIMIT orders show different usage patterns
A small number of clients contribute disproportionately to total volume
Execution quality varies across instruments and order types

# Business Value

This project demonstrates how SQL can be used to:

Monitor trade execution efficiency
Understand client trading behaviour
Identify liquidity patterns
Support decision-making in trading environments

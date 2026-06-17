/* =====================================================
   TRADE EXECUTION ANALYSIS PROJECT

   Objective:
   Analyse trading orders, executions, fill rates,
   execution prices, and trading activity using SQL.

   Skills Demonstrated:
   - Database Design
   - Primary & Foreign Keys
   - Data Insertion
   - Aggregations
   - Joins
   - Business KPI Analysis
===================================================== */


/* =====================================================
   STEP 1: CREATE DATABASE
===================================================== */

CREATE DATABASE trade_analysis;
USE trade_analysis;

/* =====================================================
   TABLE 1: ORDERS

   Stores client order details submitted to the market.
===================================================== */

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    client_id INT,
    instrument VARCHAR(10),
    order_type VARCHAR(10),
    quantity INT,
    order_price DECIMAL(10,2),
    order_time DATETIME
);

/* =====================================================
   TABLE 2: EXECUTIONS

   Stores actual trade executions generated
   from client orders.

   One order may have multiple executions.
===================================================== */

CREATE TABLE executions (
    execution_id INT PRIMARY KEY,
    order_id INT,
    execution_quantity INT,
    executed_price DECIMAL(10,2),
    execution_time DATETIME,

    # Link execution records to orders
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

ALTER TABLE executions
CHANGE execution_quantity executed_quantity INT;

/* =====================================================
   TABLE 3: INSTRUMENTS

   Reference table containing securities
   and their sectors.
===================================================== */

CREATE TABLE instruments (
    instrument VARCHAR(10) PRIMARY KEY,
    sector VARCHAR(50)
);

SELECT * FROM trade_analysis.instruments;

#Step 2: Inserting Values 
INSERT INTO instruments VALUES
('AAPL', 'Technology'),
('TSLA', 'Automotive'),
('MSFT', 'Technology'),
('AMZN', 'E-commerce'),
('NVDA', 'Semiconductors');

SELECT * FROM instruments;


SELECT * FROM trade_analysis.orders;
INSERT INTO orders VALUES
(1, 101, 'AAPL', 'LIMIT', 200, 180.00, '2026-01-01 09:00:00'),
(2, 102, 'TSLA', 'MARKET', 50, NULL, '2026-01-01 09:01:00'),
(3, 103, 'MSFT', 'LIMIT', 150, 320.00, '2026-01-01 09:02:00'),
(4, 104, 'NVDA', 'MARKET', 100, NULL, '2026-01-01 09:03:00'),
(5, 105, 'AMZN', 'LIMIT', 300, 130.00, '2026-01-01 09:04:00'),
(6, 101, 'AAPL', 'MARKET', 120, NULL, '2026-01-01 09:05:00'),
(7, 106, 'TSLA', 'LIMIT', 80, 245.00, '2026-01-01 09:06:00'),
(8, 107, 'MSFT', 'MARKET', 60, NULL, '2026-01-01 09:07:00'),
(9, 108, 'NVDA', 'LIMIT', 220, 480.00, '2026-01-01 09:08:00'),
(10, 109, 'AMZN', 'MARKET', 90, NULL, '2026-01-01 09:09:00');
SELECT * FROM orders;

SELECT * FROM trade_analysis.executions;
INSERT INTO executions VALUES
(1, 1, 100, 179.50, '2026-01-01 09:00:05'),
(2, 1, 100, 180.00, '2026-01-01 09:00:10'),
(3, 2, 50, 250.25, '2026-01-01 09:01:02'),
(4, 3, 150, 320.00, '2026-01-01 09:02:05'),
(5, 4, 100, 480.50, '2026-01-01 09:03:03'),
(6, 5, 150, 129.80, '2026-01-01 09:04:10'),
(7, 5, 150, 130.10, '2026-01-01 09:04:15'),
(8, 6, 120, 180.20, '2026-01-01 09:05:05'),
(9, 7, 80, 245.50, '2026-01-01 09:06:03'),
(10, 9, 220, 480.00, '2026-01-01 09:08:10');

SELECT* FROM executions; 

/* =====================================================
   STEP 3: TRADE ANALYSIS
===================================================== */


/* =====================================================
   KPI 1: Total Executed Quantity per Order

   Business Question:
   How many shares were executed for each order?
===================================================== */

SELECT
    order_id,
    SUM(executed_quantity) AS total_executed
FROM executions
GROUP BY order_id;

/* =====================================================
   KPI 2: Order Fill Rate Analysis

   Business Question:
   What percentage of each order was successfully executed?

   Why it matters:
   - Measures execution efficiency
   - Identifies partially filled orders
   - Helps evaluate trading performance
===================================================== */

SELECT
    o.order_id,

    # Original quantity requested by the client
    o.quantity AS ordered_qty,

    # Total quantity executed across all executions
    SUM(e.executed_quantity) AS executed_qty,

    # Percentage of the order that was filled
    SUM(e.executed_quantity) / o.quantity AS fill_rate

FROM orders o

# Keeping all orders, even if no executions exist
LEFT JOIN executions e
ON o.order_id = e.order_id

# Calculate fill rate for each order
GROUP BY o.order_id;

/* =====================================================
   KPI 3: Average Execution Price per Order

   Business Question:
   At what average price was each order executed?

   Why it matters:
   - Evaluates trade execution quality
   - Helps compare actual execution prices
     against target order prices
   - Useful for measuring trading efficiency
===================================================== */

SELECT

    # Unique order identifier
    order_id,

    # Average execution price across all fills
    AVG(executed_price) AS avg_execution_price

FROM executions

# Calculate average price for each order
GROUP BY order_id;


/* =====================================================
   KPI 4: Remaining Quantity Analysis

   Business Question:
   How much of each order remains unexecuted?

   Why it matters:
   - Identifies incomplete orders
   - Highlights potential liquidity issues
   - Helps monitor execution risk
===================================================== */

SELECT
    o.order_id,

    # Quantity originally requested
    o.quantity AS ordered_qty,

    # Quantity successfully executed
    SUM(e.executed_quantity) AS executed_qty,

    # Quantity still waiting to be executed
    o.quantity - SUM(e.executed_quantity) AS remaining_qty

FROM orders o

# Include all orders regardless of execution status
LEFT JOIN executions e
ON o.order_id = e.order_id

# Calculate remaining quantity per order
GROUP BY o.order_id;

/* =====================================================
   KPI 5: Trading Volume by Sector

   Business Question:
   Which sectors generate the highest trading volume?

   Why it matters:
   - Identifies sectors with the most trading activity
   - Helps understand market participation trends
   - Demonstrates the use of JOINs across multiple tables
===================================================== */

SELECT
    i.sector,

    # Total quantity traded within each sector
    SUM(o.quantity) AS total_volume

FROM orders o

# Match each order to its sector information
INNER JOIN instruments i
ON o.instrument = i.instrument

# Aggregate volume at sector level
GROUP BY i.sector

# Display most active sectors first
ORDER BY total_volume DESC;

/* =====================================================
   KPI 6: Average Execution Price by Instrument

   Business Question:
   Which instruments were executed at the highest
   average prices?

   Why it matters:
   - Measures execution performance by instrument
   - Helps compare trading activity across securities
   - Demonstrates JOINs between orders and executions
===================================================== */

SELECT
    o.instrument,

    # Average execution price across all fills
    AVG(e.executed_price) AS avg_execution_price

FROM orders o

# Match executions to their corresponding orders
INNER JOIN executions e
ON o.order_id = e.order_id

# Aggregate results by instrument
GROUP BY o.instrument

# Show highest average prices first
ORDER BY avg_execution_price DESC;

/* =====================================================
   KPI 7: Top Clients by Trading Volume

   Business Question:
   Which clients generated the highest trading volume?

   Why it matters:
   - Identifies the most active clients
   - Helps understand client trading behaviour
   - Useful for relationship management and reporting
===================================================== */

SELECT
    client_id,

    # Total quantity traded by each client
    SUM(quantity) AS total_trading_volume

FROM orders

# Aggregate orders at the client level
GROUP BY client_id

# Display highest-volume clients first
ORDER BY total_trading_volume DESC;

/* =====================================================
   KPI 8: Order Type Analysis (LIMIT vs MARKET)

   Business Question:
   Which order types are most commonly used, and
   which generate higher trading volume?

   Why it matters:
   - Shows client trading behaviour
   - Helps understand liquidity preference (LIMIT vs MARKET)
   - Useful for execution strategy and risk analysis
===================================================== */

SELECT
    order_type,

    # Number of orders of each type
    COUNT(order_id) AS total_orders,

    # Total quantity traded per order type
    SUM(quantity) AS total_volume,

    # Average order size per type
    AVG(quantity) AS avg_order_size

FROM orders

# Group analysis by order type (LIMIT vs MARKET)
GROUP BY order_type

# Show most used order type first
ORDER BY total_volume DESC;

/* =====================================================
   INSIGHTS SUMMARY

   Based on KPI analysis of orders, executions,
   instruments, clients, and order types.
===================================================== */
/* 
Insight 1: Execution Efficiency
Some orders are fully filled, while others are partially filled.
This indicates variability in market liquidity and execution conditions.

Insight 2: Fill Rate Behaviour
Fill rates vary across orders, showing that some trades are more
difficult to execute fully than others.

Insight 3: Market Activity Concentration
A small number of instruments generate the majority of trading volume,
indicating concentration in key securities.

Insight 4: Sector Behaviour
Certain sectors (e.g. Technology or Semiconductors) show higher
trading activity compared to others.

Insight 5: Client Activity
A small number of clients contribute disproportionately to trading volume,
suggesting a high concentration of trading activity among top clients.

Insight 6: Order Type Behaviour
MARKET and LIMIT orders show different usage patterns,
indicating varying client preferences between speed and price control.

📊 Ecommerce Sales: Marketing ROI & Performance Analysis
--------------------------------------------------------------
🚀 Introduction
-----------------------
This project focuses on the foundational phase of ecommerce growth analytics: building a robust data engine to reconcile complex marketing spend with transactional sales. By developing a unified logic layer, I transformed raw, disconnected datasets into a single source of truth. This allows for a precise understanding of the bottom-line efficiency of advertising efforts, moving beyond surface-level metrics to calculate true profitability and Return on Ad Spend (ROAS).

🛠️ Technology Stack
--------------------------
Database Management: PostgreSQL

SQL Client: DBeaver

Logic & Transformation: SQL CTEs, Window Functions, and Complex Joins

🏗️ Project Architecture
------------------------------------
The project follows a modular structure to ensure maintainability and clarity:

/Code: Dedicated SQL scripts for data preparation (data_cleaning.sql) and metric calculation (data_insights.sql).

/dataset: Raw source files including online_sales, marketing_spend, and customersdata.

/Pictures: Visual documentation of SQL query results and logic flows.

🛠️ Phase 1: The Core Analytics Engine
----------------------------------------------
1. Data Cleaning & Revenue Engineering
Using PostgreSQL, I developed a "Tax Impact" logic to calculate Net Revenue. This ensures that the revenue figures account for GST and delivery charges, providing a realistic view of cash flow before marketing costs are applied.

2. Marketing Spend Reconciliation & ROAS
The core of this phase involved joining marketing spend with sales activity via a date-bridge logic. I calculated the Return on Ad Spend (ROAS) for every category, identifying that Nest-USA led the pack with a high ROAS of 1.24.

3. Customer Segmentation & Behavior
I leveraged the customersdata table to segment users into Loyal, Regular, and New groups. By analyzing their average spending patterns in SQL, I established the baseline needed for targeted marketing budget allocation.

💡 Key SQL Insights
-------------------------------
Top Efficiency: Nest-USA is the most efficient category for ad spend (1.24 ROAS).

Volume vs. Value: While Apparel shows high sales volume, its ROAS (0.26) indicates an opportunity for cost optimization.

Geographic Hubs: California is the primary customer hub, followed by Illinois and New York.

-- =============================================
-- PORTFOLIO PROJECT: E-commerce Customer Behavior
-- TASK: Data Cleaning & Standardization
-- =============================================

-- 1. FINDING NULL/MISSING VALUES IN EACH TABLE - 

SELECT 
    COUNT(*) AS total_records,
    COUNT(*) - COUNT(c."CustomerID") AS null_ids,
    COUNT(*) - COUNT(c."Gender" ) AS null_genders,
    COUNT(*) - COUNT(c."Location" ) AS null_locations,
    COUNT(*) - COUNT(c."Tenure_Months" ) AS null_tenure
FROM customersdata c ;

SELECT 
    COUNT(*) AS total_records,
    COUNT(*) - COUNT(ta."GST" ) AS null_gst,
    COUNT(*) - COUNT(ta."Product_Category" ) AS null_product_category
FROM tax_amount ta  ;

SELECT 
    COUNT(*) AS total_records,
    COUNT(*) - COUNT(dc."Coupon_Code"  ) AS null_Coupon_code,
    COUNT(*) - COUNT(dc."Discount_pct"  ) AS null_Discount_pct,
    COUNT(*) - COUNT(dc."Month"  ) AS null_Month,
    COUNT(*) - COUNT(dc."Product_Category"  ) AS null_product_category
FROM discount_coupon dc ;

SELECT 
    COUNT(*) AS total_records,
    COUNT(*) - COUNT(ms."Date"  ) AS null_Date,
    COUNT(*) - COUNT(ms."Offline_Spend" ) AS Offline_spend,
    COUNT(*) - COUNT(ms."Online_Spend" ) AS null_Oline_spend
FROM marketing_spend ms ;

SELECT 
    COUNT(*) AS total_records,
    COUNT(*) - COUNT(mcd."Applications" ) AS null_applications,
    COUNT(*) - COUNT(mcd."CampaignID" ) AS null_CampaignID,
    COUNT(*) - COUNT(mcd."CampaignName") AS null_CampaignName,
    COUNT(*) - COUNT(mcd."Clicks") AS null_Clicks,
    COUNT(*) - COUNT(mcd."Cost (₹)") AS null_cost,
    COUNT(*) - COUNT(mcd."Date" ) AS null_date,
    COUNT(*) - COUNT(mcd."Enrollments" ) AS null_enrollments,
    COUNT(*) - COUNT(mcd."Impressions" ) AS null_Impression,
    COUNT(*) - COUNT(mcd."Leads" ) AS null_Leads,
    COUNT(*) - COUNT(mcd."Platform" ) AS null_Platform,
    COUNT(*) - COUNT(mcd."Region" ) AS null_Region,
    COUNT(*) - COUNT(mcd."Revenue (₹)" ) AS null_Revenue,
    COUNT(*) - COUNT(mcd."TargetAudience" ) AS null_TargetAudience
FROM marketing_campaign_data mcd  ;

SELECT
    COUNT(*) AS total_records,
    COUNT(*) - COUNT(os."Avg_Price" ) AS null_avg_price,
    COUNT(*) - COUNT(os."Coupon_Status") AS null_coupon_status,
    COUNT(*) - COUNT(os."CustomerID" ) AS null_customer_id,
    COUNT(*) - COUNT(os."Delivery_Charges" ) AS null_dilvery_charges,
    COUNT(*) - COUNT(os."Product_Category" ) AS null_product_category,
    COUNT(*) - COUNT(os."Product_Description" ) AS null_product_description,
    COUNT(*) - COUNT(os."Product_SKU" ) AS null_product_sku,
    COUNT(*) - COUNT(os."Quantity" ) AS null_quantity,
    COUNT(*) - COUNT(os."Transaction_Date" ) AS null_transaction_date,
    COUNT(*) - COUNT(os."Transaction_ID" ) AS null_transaction_id
FROM online_sales os ;

-- 2. FIX DATA TYPES and CHANGE COLUMN NAME AND TRIM OF EACH TABLE-

--fixing gst column in tax_amount table
ALTER TABLE tax_amount 
ALTER COLUMN "GST" TYPE integer 
USING CAST(REPLACE("GST", '%', '') AS integer);

--triming space and make text front word capital
UPDATE tax_amount
SET "Product_Category" = INITCAP(TRIM("Product_Category"));

--2 marketing_campaign_data table

ALTER TABLE marketing_campaign_data 
ALTER COLUMN "Date" TYPE DATE 
USING "Date"::DATE;

ALTER TABLE marketing_campaign_data  
ALTER COLUMN "Revenue (₹)" TYPE integer 
USING CAST(REPLACE("Revenue (₹)", '₹', '') AS integer);

ALTER TABLE marketing_campaign_data  
ALTER COLUMN "Cost (₹)" TYPE integer 
USING CAST(REPLACE("Cost (₹)", '₹', '') AS integer);

ALTER TABLE marketing_campaign_data RENAME COLUMN "Cost (₹)" TO Cost;
ALTER TABLE marketing_campaign_data RENAME COLUMN "Revenue (₹)" TO Revenue;

ALTER TABLE marketing_campaign_data RENAME COLUMN "Cost (₹)" TO Cost;
ALTER TABLE marketing_campaign_data RENAME COLUMN "Revenue (₹)" TO Revenue;

ALTER TABLE marketing_campaign_data RENAME COLUMN cost TO "Cost";
ALTER TABLE marketing_campaign_data RENAME COLUMN revenue TO "Revenue";

UPDATE marketing_campaign_data 
SET "CampaignName"= INITCAP(TRIM("CampaignName"));

UPDATE marketing_campaign_data 
SET "Platform"= INITCAP(TRIM("Platform"));

UPDATE marketing_campaign_data 
SET "Region" = INITCAP(TRIM("Region"));

UPDATE marketing_campaign_data 
SET "CampaignID" = TRIM("CampaignID");

UPDATE marketing_campaign_data 
SET "TargetAudience" = TRIM("TargetAudience");

-- 3. customersdata table

UPDATE customersdata 
SET "Gender" = INITCAP(TRIM("Gender"));

UPDATE customersdata 
SET "Location" = INITCAP(TRIM("Location"));

-- 4. discount_coupon table

UPDATE discount_coupon
SET "Month"= INITCAP(TRIM("Month"));

UPDATE  discount_coupon
SET "Product_Category" = INITCAP(TRIM("Product_Category"));

UPDATE  discount_coupon
SET "Coupon_Code" = TRIM("Coupon_Code");

-- 5. marketing_spend table

ALTER TABLE marketing_spend 
ALTER COLUMN "Date" TYPE DATE 
USING "Date"::DATE;

--6. online_sales table

ALTER TABLE online_sales 
ALTER COLUMN "Transaction_Date"TYPE DATE 
USING "Transaction_Date"::DATE;

UPDATE  online_sales 
SET "Product_Description" = INITCAP(TRIM("Product_Description"));

UPDATE  online_sales 
set "Product_Category" = INITCAP(TRIM("Product_Category"));

UPDATE  online_sales 
SET "Coupon_Status" = INITCAP(TRIM("Coupon_Status"));

--3. CHECKING NUMERICAL VALUES IN THE TABLES

SELECT 
    MIN(c."Tenure_Months" ) AS min_tenure_months, MAX(c."Tenure_Months" ) AS max_tenure_months,
    MIN(os."Quantity") AS min_qty, MAX(os."Quantity" ) AS max_qty,
    MIN(os."Avg_Price") AS min_avgprice, MAX(os."Avg_Price" ) AS max_avgprice,
    MIN(os."Delivery_Charges" ) AS min_deliverycharges, MAX(os."Delivery_Charges" ) AS max_deliverycharges
FROM online_sales os
JOIN customersdata c ON os."CustomerID" = c."CustomerID";

 SELECT
  MIN(mcd."Impressions" ) AS min_imp, max(mcd."Impressions" ) AS max_imp,
  MIN(mcd."Clicks") AS min_clicks, max(mcd."Clicks" ) AS max_clicks,
  MIN(mcd."Leads") AS min_leads, max(mcd."Leads") AS max_leads,
  MIN(mcd."Applications" ) AS min_app, max(mcd."Applications" ) AS max_app,
  MIN(mcd."Enrollments") AS min_en, max(mcd."Enrollments") AS max_en,
  MIN(mcd."Cost") AS min_cost, max(mcd."Cost" ) AS max_cost,
  MIN(mcd."Revenue") AS min_rev, max(mcd."Revenue" ) AS max_rev
  FROM marketing_campaign_data mcd ;
    
  SELECT 
  MIN(ms."Offline_Spend" ) AS min_offspend, max(ms."Offline_Spend" ) AS max_offspend,
  MIN(ms."Online_Spend") AS min_onspend, max(ms."Online_Spend"  ) AS max_onspend
  FROM marketing_spend ms  ;

  -- 4. CHECKING DUPLICATE VALUES IN THE EACH TABLES

  --1. tax_amount table

  WITH tax_table AS ( 
    SELECT 
        ta."Product_Category",
        ta."GST",
        ROW_NUMBER() OVER (
            PARTITION BY ta."Product_Category", ta."GST" 
            ORDER BY ta."Product_Category"
        ) AS duplicate
    FROM tax_amount ta 
)
SELECT 
    "Product_Category",
    "duplicate"         
FROM tax_table
WHERE "duplicate" > 1;

 --2. marketing_campaign_data table

 WITH mar_table AS ( 
    SELECT 
        mcd."Date" ,
        mcd."CampaignID",
        mcd."TargetAudience",
        ROW_NUMBER() OVER (
            PARTITION BY mcd."Date" , mcd."CampaignID" , mcd."TargetAudience" 
            ORDER by mcd."CampaignID" 
        ) AS duplicate
    FROM marketing_campaign_data mcd  
)
SELECT 
    "Date",
    "CampaignID",
    "TargetAudience"
FROM mar_table
WHERE "duplicate" > 1;

-- 3. customersdata table

 WITH cus_table AS ( 
    SELECT 
        c."CustomerID",
        ROW_NUMBER() OVER (
            PARTITION BY c."CustomerID"
            ORDER by c."CustomerID" 
        ) AS duplicate
    FROM customersdata c 
)
SELECT 
   "CustomerID"
FROM cus_table
WHERE "duplicate" > 1;

--4. discount_coupon table

 WITH dc_table AS ( 
    SELECT 
        dc."Coupon_Code",
        dc."Product_Category",
        dc."Month" ,
        ROW_NUMBER() OVER (
            PARTITION BY dc."Coupon_Code" , dc."Product_Category" , dc."Month"
            ORDER by dc."Product_Category" 
        ) AS duplicate
    FROM discount_coupon dc  
)
SELECT 
       "Coupon_Code",
        "Product_Category",
        "Month"
FROM dc_table
WHERE "duplicate" > 1;

--5. marketing_spend table

 WITH ms_table AS ( 
    SELECT 
        ms."Date",
        ms."Offline_Spend",
        ROW_NUMBER() OVER (
            PARTITION BY ms."Date", ms."Offline_Spend"
            ORDER by ms."Date" 
        ) AS duplicate
    FROM marketing_spend ms
)
SELECT 
       "Date",
       "Offline_Spend"
FROM ms_table
WHERE "duplicate" > 1;

--6. online_sales table

 WITH os_table AS ( 
    SELECT 
        os."CustomerID",
        os."Transaction_ID",
        os."Transaction_Date",
        os."Product_SKU",
        ROW_NUMBER() OVER (
            PARTITION BY   os."CustomerID", os."Transaction_ID", os."Transaction_Date", os."Product_SKU"
            ORDER by os."CustomerID" 
        ) AS duplicate
    FROM online_sales os 
)
SELECT 
       "CustomerID",
       "Transaction_ID",
       "Transaction_Date",
       "Product_SKU"
FROM os_table
WHERE "duplicate" > 1;

-- 5. BUILDING RELATIONSHIP BETWEEN TABLES

-- a. creating primary key

-- 1. tax_amount

SELECT "Product_Category", COUNT(*)
FROM tax_amount
GROUP BY "Product_Category"
HAVING COUNT(*) > 1;

ALTER TABLE tax_amount 
ADD PRIMARY KEY ("Product_Category");

--2. marketing_campaign_data

SELECT "Date", "CampaignID", "TargetAudience", COUNT(*)
FROM marketing_campaign_data
GROUP BY "Date", "CampaignID", "TargetAudience"
HAVING COUNT(*) > 1;

ALTER TABLE marketing_campaign_data 
ADD PRIMARY KEY ("Date", "CampaignID", "TargetAudience");

--3. customersdata

SELECT "CustomerID", COUNT(*)
FROM customersdata
GROUP by "CustomerID"
HAVING COUNT(*) > 1;

ALTER TABLE customersdata 
ADD PRIMARY KEY ("CustomerID");

--4. discount_coupon table

SELECT "Month", "Product_Category", "Coupon_Code", COUNT(*)
FROM discount_coupon
GROUP BY "Month", "Product_Category", "Coupon_Code"
HAVING COUNT(*) > 1;

ALTER TABLE discount_coupon 
ADD PRIMARY KEY ("Month", "Product_Category", "Coupon_Code");

--5. marketing_spend table

SELECT "Date", COUNT(*)
FROM marketing_spend
GROUP BY "Date"
HAVING COUNT(*) > 1;

ALTER TABLE marketing_spend 
ADD PRIMARY KEY ("Date");

--6. online_sales table

SELECT "Transaction_ID", "Product_SKU" , COUNT(*)
FROM online_sales
GROUP BY "Transaction_ID" , "Product_SKU"
HAVING COUNT(*) > 1;

ALTER TABLE online_sales
ADD PRIMARY KEY ("Transaction_ID","Product_SKU");

--b. creating forign key and bluiding relationship

--1.
UPDATE tax_amount 
SET "Product_Category" = 'Notebooks' 
WHERE "Product_Category" = 'Notebooks & Journals';

UPDATE discount_coupon 
SET "Product_Category" = 'Notebooks' 
WHERE "Product_Category" = 'Notebooks & Journals';

SELECT DISTINCT dc."Product_Category"
FROM discount_coupon dc
LEFT JOIN tax_amount ta ON dc."Product_Category" = ta."Product_Category"
WHERE ta."Product_Category" IS NULL;

ALTER TABLE discount_coupon 
ADD CONSTRAINT fk_coupon_tax 
FOREIGN KEY ("Product_Category") 
REFERENCES tax_amount ("Product_Category");

--2.

UPDATE online_sales  
SET "Product_Category" = 'Notebooks' 
WHERE "Product_Category" = 'Notebooks & Journals';

SELECT DISTINCT os."Product_Category"
FROM online_sales os  
LEFT JOIN tax_amount ta ON os."Product_Category" = ta."Product_Category"
WHERE ta."Product_Category" IS NULL;

ALTER TABLE online_sales  
ADD CONSTRAINT fk_sales_tax 
FOREIGN KEY ("Product_Category") 
REFERENCES tax_amount ("Product_Category");

--3. 
SELECT DISTINCT os."Transaction_Date"
FROM online_sales os   
LEFT JOIN marketing_spend ms  ON os."Transaction_Date" = ms."Date"
WHERE ms."Date" IS NULL;

ALTER TABLE online_sales 
ADD CONSTRAINT fk_sales_spend 
FOREIGN KEY ("Transaction_Date") 
REFERENCES marketing_spend ("Date");

--4.

SELECT DISTINCT os."CustomerID"
FROM online_sales os   
LEFT JOIN customersdata c   ON os."CustomerID" = c."CustomerID" 
WHERE c."CustomerID" IS NULL;

ALTER TABLE online_sales 
ADD CONSTRAINT fk_cus_data 
FOREIGN KEY ("CustomerID") 
REFERENCES customersdata ("CustomerID");


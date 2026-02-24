/* =========================================
   AI Customer Segmentation Project
   RFM Table Creation using SQLite
   ========================================= */


/* 1️⃣  Clean Raw Data */

DROP TABLE IF EXISTS cleaned_data;

CREATE TABLE cleaned_data AS
SELECT *
FROM retail_raw
WHERE CustomerID IS NOT NULL
  AND Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'C%';



/* 2️⃣  Convert InvoiceDate to Proper Date Format */

DROP TABLE IF EXISTS cleaned_with_date;

CREATE TABLE cleaned_with_date AS
SELECT *,
       DATE(
           '20' || substr(InvoiceDate,
                         instr(InvoiceDate, '/') +
                         instr(substr(InvoiceDate, instr(InvoiceDate, '/')+1), '/') + 1,
                         2)
           || '-' ||
           printf('%02d',
                  CAST(substr(InvoiceDate, 1, instr(InvoiceDate, '/') - 1) AS INTEGER))
           || '-' ||
           printf('%02d',
                  CAST(substr(InvoiceDate,
                              instr(InvoiceDate, '/')+1,
                              instr(substr(InvoiceDate, instr(InvoiceDate, '/')+1), '/') - 1)
                  AS INTEGER))
       ) AS invoice_date_clean
FROM cleaned_data;



/* 3️⃣  Create RFM Table */

DROP TABLE IF EXISTS rfm_table;

CREATE TABLE rfm_table AS
SELECT
    CustomerID,

    /* Recency */
    CAST(
        JULIANDAY('2011-12-10') -
        JULIANDAY(MAX(invoice_date_clean))
    AS INTEGER) AS recency,

    /* Frequency */
    COUNT(DISTINCT InvoiceNo) AS frequency,

    /* Monetary */
    SUM(Quantity * UnitPrice) AS monetary

FROM cleaned_with_date
GROUP BY CustomerID;



/* 4️⃣  Validation Checks */

-- Total customers
SELECT COUNT(*) AS total_customers FROM rfm_table;

-- Recency range check
SELECT MIN(recency) AS min_recency,
       MAX(recency) AS max_recency
FROM rfm_table;

-- Preview
SELECT * FROM rfm_table LIMIT 10;
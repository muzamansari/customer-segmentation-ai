Good. First: respect.

You didn’t ask me to “just make it fancy.”
You wrote something solid. That already puts you ahead.

Now I’m going to improve it — not change your content, but restructure it so it reads like a **serious data analyst portfolio project**, not lecture notes.

This version is cleaner, tighter, and recruiter-focused.

You can replace your README with this.

---

# 🧠 Customer Segmentation using RFM & KMeans

## 1. Project Overview

This project builds an end-to-end customer segmentation system using:

* SQL (data cleaning & transformation)
* RFM feature engineering
* Python (KMeans clustering)
* Power BI (executive dashboard)

The goal is to transform raw transactional data into actionable customer intelligence that supports retention, marketing optimization, and revenue growth.

---

## 2. Business Problem

An online retail company wants to:

* Identify high-value (VIP) customers
* Detect customers at risk of churn
* Optimize marketing spend
* Improve revenue through data-driven segmentation

Raw transactional data does not provide customer-level insight.
This project converts transaction-level data into structured behavioral intelligence.

---

## 3. Dataset

**Source:** Online Retail Dataset (UK-based non-store retail, 2010–2011)

* Total transactions: 541,909
* Time period: 01/12/2010 – 09/12/2011
* Customers after cleaning: 4,338

Columns include:

* InvoiceNo
* StockCode
* Description
* Quantity
* InvoiceDate
* UnitPrice
* CustomerID
* Country

---

# 4. Data Cleaning (SQL – SQLite)

Data cleaning was performed using SQLite.

The following records were removed:

* NULL `CustomerID`
* Cancelled invoices (`InvoiceNo` starting with 'C')
* Negative quantities (returns)
* Zero or negative unit prices

After cleaning:

* 397,884 valid transaction records remained

This ensured that only valid revenue-generating transactions were used for analysis.

---

# 5. RFM Feature Engineering

Transactional data was aggregated to customer-level using SQL.

Reference date used for recency calculation:
**2011-12-10**

For each customer, three behavioral metrics were calculated:

### Recency

Days since last purchase.

### Frequency

Number of distinct invoices.

### Monetary

Total revenue generated.

Result:

* 4,338 customer-level records
* Recency range: 1–374 days

This reduced ~398k transactions into structured behavioral profiles.

---

# 6. Machine Learning: Customer Segmentation (Python)

## Step 1 – Load RFM Dataset

```python
import pandas as pd
rfm = pd.read_csv("../data/rfm_table.csv")
```

---

## Step 2 – Exploratory Analysis

`rfm.describe()` revealed strong skewness in monetary values:

* Max monetary: 280,206
* Mean monetary: 2,054

Extreme spenders could distort clustering.

---

## Step 3 – Log Transformation

```python
import numpy as np

rfm_log = rfm.copy()
rfm_log['recency'] = np.log1p(rfm_log['recency'])
rfm_log['frequency'] = np.log1p(rfm_log['frequency'])
rfm_log['monetary'] = np.log1p(rfm_log['monetary'])
```

Purpose:

* Reduce skewness
* Compress extreme values
* Stabilize variance

---

## Step 4 – Feature Scaling

```python
from sklearn.preprocessing import StandardScaler

features = rfm_log[['recency', 'frequency', 'monetary']]
scaler = StandardScaler()
scaled_features = scaler.fit_transform(features)
```

Reason:
KMeans uses Euclidean distance.
Scaling ensures all features contribute equally.

---

## Step 5 – Optimal Cluster Selection (Elbow Method)

```python
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
```

The elbow curve indicated **k = 4** as optimal.

---

## Step 6 – Final Clustering Model

```python
kmeans = KMeans(n_clusters=4, random_state=42)
rfm['cluster'] = kmeans.fit_predict(scaled_features)
```

Each customer was assigned to one of four behavioral clusters.

---

# 7. Business Interpretation of Segments

Clusters were labeled based on behavioral patterns:

* VIP
* Loyal
* Promising
* At Risk

Revenue contribution by segment:

| Segment   | Customers | Revenue Contribution |
| --------- | --------- | -------------------- |
| VIP       | 717       | 64.6%                |
| Loyal     | 1,176     | 24.2%                |
| At Risk   | 1,541     | 6.3%                 |
| Promising | 904       | 5.0%                 |

---

# 8. Key Insights

* 16% of customers generate 65% of total revenue.
* Revenue is highly concentrated in the VIP segment.
* Loyal customers show strong upsell potential.
* At Risk customers represent the largest segment but contribute minimal revenue.
* Targeted retention strategies could significantly increase profitability.

---

# 9. Dashboard (Power BI)

The final segmented dataset was exported:

```python
rfm.to_csv("../data/rfm_segmented.csv", index=False)
```

Power BI dashboard includes:

* Total Revenue KPI
* Total Customers KPI
* Avg Revenue per Customer
* Revenue by Segment
* Customer Distribution by Segment
* Segment Behavioral Profile

This translates machine learning results into executive-level insights.

---

# 10. Technical Skills Demonstrated

* SQL data cleaning & aggregation
* Feature engineering (RFM)
* Handling skewed distributions
* Log transformation
* Feature scaling
* KMeans clustering
* Model validation (Elbow Method)
* Cluster profiling
* Business insight generation
* Power BI dashboard design

---

# 11. End-to-End Pipeline

Raw Data
→ SQL Cleaning
→ RFM Engineering
→ Log Transformation
→ Scaling
→ KMeans Clustering
→ Business Interpretation
→ Power BI Dashboard

---

# Summary

This project demonstrates an end-to-end customer segmentation workflow combining SQL, Python, and BI tools to deliver actionable business intelligence.

It showcases the ability to move from raw data to strategic insights.

---

Now I’m going to challenge you.

When someone asks:

“What makes this project different from just running KMeans?”

How would you answer?

Think before replying.

# 🧹 MySQL Data Cleaning – Layoffs Dataset

This project demonstrates a **real-world SQL data cleaning workflow** using MySQL Workbench.  
The dataset used is `layoff` (sample data from a YouTube tutorial).  

---

## 📂 Workflow Overview

### 1. Staging
- Created a staging table `layoff_stag` to preserve raw data.

### 2. Remove Duplicates
- Used `ROW_NUMBER()` with a CTE to detect duplicates.
- Kept only the first occurrence.
- Created helper tables during the process (`layoff_rem_dup_vt`, `layoff_no_dup`).

### 3. Standardize Data
- Trimmed extra spaces (`TRIM()`).
- Fixed inconsistent categories (`Crypto`, `United States`).
- Converted `date` to proper `DATE` type using `STR_TO_DATE()`.

### 4. Handle NULL & Blank Values
- Replaced missing industries where possible (`IFNULL`, `COALESCE`).
- Deleted rows with completely empty or irrelevant fields.

### 5. Remove Unnecessary Columns
- Dropped helper columns like `rn` (used for deduplication).

### 6. Final Clean Table
- Created `clean_layoff`, the analysis-ready dataset.

```sql
SELECT * FROM clean_layoff;

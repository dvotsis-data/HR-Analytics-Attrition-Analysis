# 📊 HR Analytics: Employee Attrition & Workforce Analysis

## 📌 Project Overview
This project focuses on identifying the underlying catalyst drivers behind employee attrition. Utilizing **SQL (MySQL)** for data extraction, transformation, and structural modeling, and **Power BI** for corporate visual storytelling, the pipeline converts raw workforce metrics into targeted retention strategies.

## 🎯 Objectives
*   Extract and calculate core institutional HR metrics (Total Headcount, Absolute Attrition Count, and Attrition Rate).
*   Segment workforce demographics into categorical brackets to isolate high-risk age clusters.
*   Correlate employee job satisfaction trends against departmental turnover volumes.
*   Build a production-ready SQL database view optimized to serve as a high-performance data source for dynamic Power BI dashboards.

## 🛠 Tools & Technologies
*   **Database Engine:** MySQL (Exploratory Data Analysis & View Architecture)
*   **Business Intelligence:** Power BI Desktop (Data Modeling & KPI Mapping)
*   **SQL Frameworks:** Conditional Case Logic (`CASE WHEN`), Aggregation Functions, Optimization Views

## 📉 Database Architecture & BI Optimization
A frequent mistake in data pipelines is importing raw, unoptimized tables straight into Power BI, which degrades refresh performance. This project addresses that by shifting the heavy transformation workload directly onto the database layer.

### 1. Data Transformation via Centralized View
I constructed a production-optimized SQL View (`View_HR_Analysis`). This view pre-aggregates demographic brackets and handles numerical conversions before the BI layer ingests the data:

```sql
CREATE OR REPLACE VIEW View_HR_Analysis AS
SELECT 
    EmployeeNumber, Age, Gender, Department, JobRole, MonthlyIncome,
    JobSatisfaction, Attrition,
    CASE 
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 40 THEN '30-40'
        ELSE '40+'
    END AS Age_Group,
    CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END AS Attrition_Flag
FROM hr_data;
```

### 2. Strategic Technical Decisions within SQL:
*   **The `Attrition_Flag` Optimization:** Converting the raw text string (`'Yes'`, `'No'`) into a binary numeric data type (`1`, `0`) allows Power BI to compute explicit mathematical measures (like dynamic turnover percentages) directly via DAX without requiring custom column conversions during runtime.
*   **Demographic Grouping:** Applied custom conditional grouping to segment continuous age metrics into discrete organizational brackets (`Under 30`, `30-40`, `40+`), ensuring cleaner chart cross-filtering.

## 📷 Interactive HR Dashboard
![HR Dashboard](./04_Screenshots/hr_analytics_dashboard_final.png)

## 📊 SQL Analytics Preview
### Demographic Attrition Analysis via MySQL Console
![SQL Age Analysis](./04_Screenshots/sql_age_group_analysis.png)

## 🚀 Actionable HR Insights (Business Value)
*   **The Under-30 Flight Risk:** Demographic data proves that employees under 30 exhibit a significantly higher turnover trajectory. Recommendation: HR stakeholders should design structured mentorship frameworks and clear 12-month career roadmaps to improve early-stage retention.
*   **Departmental Burnout Patterns:** Cross-referencing satisfaction metrics revealed that despite high departmental significance, Sales and R&D exhibit strong attrition clusters coupled with lower average job satisfaction scores.
*   **Satisfaction as a Lead Indicator:** Drops in environmental and job satisfaction scores serve as measurable warning signs of imminent attrition, allowing HR teams to proactively intervene before formal resignations are submitted.

## 📁 Project Structure
*   **01_Data/**: Raw and processed HR corporate datasets.
*   **02_SQL/**: Structured scripts for exploratory querying and optimized View generation.
*   **03_PowerBI/**: Power BI desktop report files and performance documentation.
*   **04_Screenshots/**: Validated SQL output matrices and dashboard visual layers.

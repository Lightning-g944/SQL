# SQL Consecutive Days Setup Guide

## Step 1: Generate CSV Data

Run the Python script to generate your data:

```bash
python generate_data.py
```

This creates a CSV file with the necessary data for your consecutive days analysis.

## Step 2: Import Data into PostgreSQL

Before copying data into the table we need to create the table first with the required columns and then run the below command.

Open **pgAdmin** and connect to your database, then run this SQL command in the Query Tool:

```sql
COPY your_table_name(column1, column2, column3)
FROM '/path/to/your/data.csv'
DELIMITER ','
CSV HEADER;
```

Replace:
- `your_table_name` - your target table name
- `/path/to/your/data.csv` - full path to the generated CSV file
- Column names matching your CSV headers

## Step 3: Verify Import

Query the table to confirm data was loaded:

```sql
SELECT COUNT(*) FROM your_table_name;
```

## Overview

This project involves data cleaning and exploratory data analysis (EDA) of a dataset containing information about layoffs in various companies. The dataset includes details such as company name, location, industry, total layoffs, percentage layoffs, date, funding raised, among others.

## Objective

The main objectives of this project are:

1. **Data Cleaning**: The dataset is cleaned to ensure consistency and accuracy of the data for further analysis.

2. **Exploratory Data Analysis (EDA)**: Various exploratory analyses are performed to gain insights into the layoffs data, including identifying trends, patterns, and key metrics.

## Technologies Used

- **Database**: PostgreSQL (with some SQL queries provided)
- **Tools**: CSV files for data input, SQL for data manipulation and analysis

## Project Structure

The project consists of two main parts:

1. **Data Cleaning**: In this phase, the dataset is imported into a PostgreSQL database, cleaned, and processed to prepare it for analysis. The cleaning steps include:

    - Removing duplicate entries
    - Standardizing and correcting data formats (e.g., date, numerical values)
    - Handling missing or null values
    - Updating and transforming data fields as required

2. **Exploratory Data Analysis (EDA)**: Once the data is cleaned, various analyses are performed to explore and understand the dataset better. This includes:

    - Finding maximum and minimum layoff percentages
    - Identifying companies with the highest layoffs on a single day
    - Analyzing companies, locations, and countries with the highest total layoffs
    - Calculating total layoffs per year
    - Identifying top companies with the highest layoffs for each year
    - Generating a rolling total of total layoffs aggregated by year and month

## Files Included

- **layoffs.csv**: Input dataset containing layoffs information
- **data_cleaning.sql**: SQL script for data cleaning and processing
- **exploratory_analysis.sql**: SQL script for exploratory data analysis
- **README.md**: This file providing an overview of the project

## Instructions

1. **Data Cleaning**:
    - Ensure PostgreSQL is installed and running.
    - Execute the SQL script `data_cleaning.sql` in your PostgreSQL environment to clean and preprocess the dataset.

2. **Exploratory Data Analysis (EDA)**:
    - After cleaning the data, execute the SQL script `exploratory_analysis.sql` to perform various exploratory analyses on the dataset.

3. **Customization**:
    - Modify the SQL scripts as needed to suit specific analysis requirements or to include additional analyses.

## Conclusion

This project demonstrates the process of cleaning and analyzing a dataset containing layoffs information using SQL and PostgreSQL. The insights gained from the exploratory analyses can be used for further research or decision-making purposes.

---

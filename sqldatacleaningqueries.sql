-- Data Cleaning

CREATE TABLE layoffs (
    company VARCHAR(100),
    location VARCHAR(100),
    industry VARCHAR(100),
    total_laid_off VARCHAR(100),
    percentage_laid_off VARCHAR(100),
    date VARCHAR(100),
    stage VARCHAR(50),
    country VARCHAR(50),
    funds_raised_millions VARCHAR(100)
);

COPY layoffs (company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions)
FROM 'H:\MySql Tutorial\data cleaning\layoffs.csv' DELIMITER ',' CSV HEADER;



CREATE TABLE layoffs_copy (LIKE layoffs INCLUDING ALL);

insert into layoffs_copy select * from layoffs;

select * from layoffs_copy;

select 
	*
from (
	select
		*,
		row_number() over(partition by company, location, industry, total_laid_off, date, stage, country, funds_raised_millions) as rnumber
	from layoffs_copy)
where rnumber > 1;





CREATE TABLE layoffs_copy1 (
    company VARCHAR(100),
    location VARCHAR(100),
    industry VARCHAR(100),
    total_laid_off VARCHAR(100),
    percentage_laid_off VARCHAR(100),
    date VARCHAR(100),
    stage VARCHAR(50),
    country VARCHAR(50),
    funds_raised_millions VARCHAR(100),
    rnumber INTEGER
);

select * from layoffs_copy1;


insert into layoffs_copy1
select *, row_number() over(partition by company, location, industry, total_laid_off, date, stage, country, funds_raised_millions) as rnumber
from layoffs_copy;

delete from layoffs_copy1 where rnumber > 1;

update layoffs_copy1 set company = trim(company);

update layoffs_copy1 set industry = 'Crypto' where industry like 'Crypto%'

select distinct country from layoffs_copy1;

update layoffs_copy1 set country = trim(trailing '.' from country) where country ilike 'united states%';

ALTER TABLE layoffs_copy1
ALTER COLUMN date TYPE DATE
USING (
    CASE 
        WHEN date ~ '^\d{1,2}/\d{1,2}/\d{4}$' THEN TO_DATE(date, 'MM/DD/YYYY')
        ELSE NULL
    END
);

alter table layoffs_copy1
alter column funds_raised_millions type double precision using nullif(funds_raised_millions, 'NULL')::double precision;

alter table layoffs_copy1
alter column total_laid_off type integer using nullif(total_laid_off, 'NULL')::integer;

alter table layoffs_copy1
alter column percentage_laid_off type double precision using nullif(percentage_laid_off, 'NULL')::double precision;

select * from layoffs_copy1 where industry isnull;

UPDATE layoffs_copy1 AS t1
SET industry = (
    SELECT t2.industry
    FROM layoffs_copy1 AS t2
    WHERE t1.company = t2.company
      AND t2.industry IS NOT NULL
    LIMIT 1
)
WHERE industry IS NULL;

delete from layoffs_copy1 where total_laid_off is null and percentage_laid_off is null;

alter table layoffs_copy1 drop column rnumber;




-- Exploratory Data Analysis

select * from layoffs_copy1;

-- Get max and min layoff percentages from layoffs_copy1 table.
select max(percentage_laid_off), min(percentage_laid_off) from layoffs_copy1;

-- Retrieves rows from layoffs_copy1 table where layoff percentage is 100
-- sorted by funds raised in descending order.
select * from layoffs_copy1 where percentage_laid_off = 1 and total_laid_off is not null order by funds_raised_millions desc;

-- Which companies have the highest total layoffs in a single day, and what are their respective counts? and limits the result to the top 5 rows.
select company, total_laid_off from layoffs_copy1 where total_laid_off is not null order by 2 desc limit 5;

-- Which companies have the highest total layoffs, and what are their respective total counts?
select company, sum(total_laid_off) from layoffs_copy1 group by company having sum(total_laid_off) is not null order by 2 desc limit 10;

-- Which locations have the highest total layoffs, and what are their respective total counts?
select location, sum(total_laid_off) from layoffs_copy1 group by location having sum(total_laid_off) is not null order by 2 desc limit 10;

-- Which countries have the highest total layoffs, and what are their respective total counts?
select country, sum(total_laid_off) from layoffs_copy1 group by country having sum(total_laid_off) is not null order by 2 desc limit 10;

-- What are the total layoffs per year?
select extract(year from date) as years, sum(total_laid_off) from layoffs_copy1
group by extract(year from date) having extract(year from date) is not null
order by years asc;


-- What are the top 3 companies with the highest layoffs for each year?
with mycte as (
	select
		company, extract(year from date) as years, sum(total_laid_off) as total_laid_offs
	from layoffs_copy1 group by company, extract(year from date)
),
mycte1 as (
	select
		*, dense_rank() over(partition by years order by total_laid_offs desc) as ranking
	from mycte where total_laid_offs is not null
)
select * from mycte1 where ranking <= 3 and years is not null order by years asc;



-- Calculates the rolling total of total layoffs aggregated by year and month
with mycte as (
	select extract(years from date) as years ,extract(month from date) as months, sum(total_laid_off) as total_laid_offs
	from layoffs_copy1 group by years, months order by years, months
)
select
	years, months,
	sum(total_laid_offs) over(order by years, months) as rolling_total
from mycte
where years is not null;
select * from churn_bank;

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'churn_bank';

--overall view
SELECT 
COUNT(*) total_customers,
SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) churned_customers,
ROUND(SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END)*100.0/COUNT(*),2) churn_rate
FROM churn_bank;

--country churn count
select count(*) churned,geography
FROM churn_bank
where exited = 1
group by geography
order by churned DESC;

--country churn rate
SELECT 
    geography,
    ROUND(SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM churn_bank
GROUP BY geography
ORDER BY churn_rate DESC;

--GENDER CHURN
select count(*) Churned,gender from churn_bank
where exited = 1
GROUP BY gender
order by Churned desc;

--GENDER CHURN RATE
select gender,
 ROUND(sum(CASE WHEN exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) churn_rate
from churn_bank
GROUP BY gender;

--churn by tunure
select count(*) churned,tenure_bucket from churn_bank
WHERE exited = 1
group by tenure_bucket
order by churned desc;

--churn rate by tenure
select tenure_bucket,
ROUND(SUM(CASE WHEN exited = 1 then 1 else 0 END)*100/count(*),2) churn_rate
from churn_bank
GROUP BY tenure_bucket
order by churn_rate DESC;

--CHURN BY AGE
SELECT age_bucket,
sum(case when exited = 1 then 1 else 0 end) as churned
from churn_bank
group by age_bucket
order by churned desc;

--AGE CHURN 
SELECT age_bucket,
ROUND(SUM(CASE when exited = 1 then 1 else 0 END)*100/count(*),2) churn_rate
from churn_bank
group by age_bucket
order by churn_rate desc;

select balance
from churn_bank;

SELECT 
    CASE
        WHEN balance = 0 THEN '0'
        WHEN balance <= 50000 THEN '0 - 50K'
        WHEN balance <= 100000 THEN '50K - 100K'
        WHEN balance <= 150000 THEN '100K - 150K'
        WHEN balance <= 200000 THEN '150K - 200K'
        ELSE '200K+'
    END AS balance_bucket,
    COUNT(*) AS customers
FROM churn_bank
GROUP BY balance_bucket
ORDER BY balance_bucket;

alter table churn_bank
add column bank_balance VARCHAR(20);

UPDATE churn_bank
SET bank_balance = CASE
    WHEN balance = 0 THEN '0'
    WHEN balance > 0 AND balance <= 50000 THEN '1 - 50K'
    WHEN balance <= 100000 THEN '50K - 100K'
    WHEN balance <= 150000 THEN '100K - 150K'
    WHEN balance <= 200000 THEN '150K - 200K'
    ELSE '200K+'
END;

--bank balance by churn
SELECT bank_balance,
sum(case when exited = 1 then 1 else 0 end) churned
FROM churn_bank
group by bank_balance
order by churned desc;

--bank balance churn rate
select bank_balance,
ROUND(SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END)*100/COUNT(*),2) CHURN_RATE
FROM CHURN_BANK
GROUP BY BANK_BALANCE
order by churn_rate desc;

--churn by number of products
select numofproducts,
sum(case when exited = 1 then 1 else 0 end) churned
from churn_bank
group by numofproducts
order by churned desc;

--churnrate by numofproducts
select numofproducts ,
ROUND(sum(case when exited = 1 then 1 else 0 END)*100/count(*),2) churn_rate
FROM CHURN_BANK
GROUP BY numofproducts
ORDER BY churn_rate DESC;

--credit card churned
select hascrcard,count(*) from churn_bank 
where exited = 1
group by hascrcard;

--credit card churnrate
SELECT hascrcard,
ROUND(SUM(CASE WHEN EXITED = 1 THEN 1 ELSE 0 END)*100/COUNT(*),2) CHURN_RATE
FROM churn_bank
group by hascrcard
ORDER BY CHURN_RATE;

SELECT geography, age_bucket,
ROUND(SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END)*100.0/COUNT(*),2) churn_rate
FROM churn_bank
GROUP BY geography, age_bucket
ORDER BY churn_rate DESC;

SELECT * FROM CHURN_BANK;

SELECT 
COUNT(*) total_customers,
SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) churned_customers,
ROUND(SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END)*100.0/COUNT(*),2) churn_rate
FROM churn_bank;

CREATE VIEW churn_analysis AS
SELECT
    geography,
    gender,
    age_bucket,
    tenure_bucket,
    bank_balance,
    numofproducts,
    hascrcard,
    exited
FROM churn_bank;

select * from churn_analysis;

ALTER TABLE churn_bank
ADD COLUMN credit_score_bucket VARCHAR(20);

UPDATE churn_bank
SET credit_score_bucket =
CASE
    WHEN creditscore < 580 THEN 'Poor'
    WHEN creditscore < 670 THEN 'Fair'
    WHEN creditscore < 740 THEN 'Good'
    WHEN creditscore < 800 THEN 'Very Good'
    ELSE 'Excellent'
END;

--CREDIT_SCORE_BUCKET CHURN
SELECT credit_score_bucket,
SUM(CASE WHEN exited = 1 then 1 ELSE 0 END) CHURN
FROM CHURN_BANK
GROUP BY credit_score_bucket
ORDER BY CHURN DESC;

--CREDIT_SCORE_BUCKET CHURN RATE
SELECT credit_score_bucket,
ROUND(SUM(CASE WHEN exited = 1 then 1 ELSE 0 END)*100/COUNT(*),2) CHURN_RATE
FROM CHURN_BANK
GROUP BY credit_score_bucket
ORDER BY CHURN_RATE DESC;

--ACTIVE VS INACTIVE CHURNRATE
SELECT isactivemember,
ROUND(SUM(CASE when exited = 1 then 1 else 0 END)*100/count(*),2) CHURN_RATE
FROM CHURN_BANK
GROUP BY isactivemember
order by churn_rate desc;

--Salary buckets
ALTER TABLE churn_bank
ADD COLUMN salary_bucket VARCHAR(25);

UPDATE churn_bank
SET salary_bucket =
CASE
    WHEN estimatedsalary <= 25000 THEN '0 - 25K'
    WHEN estimatedsalary <= 50000 THEN '25K - 50K'
    WHEN estimatedsalary <= 100000 THEN '50K - 100K'
    WHEN estimatedsalary <= 150000 THEN '100K - 150K'
    WHEN estimatedsalary <= 200000 THEN '150K - 200K'
    ELSE '200K+'
END;

--salary churn count
SELECT salary_bucket,
SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) AS churned
FROM churn_bank
GROUP BY salary_bucket
ORDER BY churned DESC;

--salary churn_rate
SELECT salary_bucket,
ROUND(SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS churn_rate
FROM churn_bank
GROUP BY salary_bucket
ORDER BY churn_rate DESC;

DROP VIEW churn_analysis;

CREATE OR REPLACE VIEW churn_analysis AS
SELECT
    customerid,
    geography,
    gender,
    age,
    age_bucket,
    creditscore,
    credit_score_bucket,
    tenure,
    tenure_bucket,
    balance,
    bank_balance,
    estimatedsalary,
    salary_bucket,
    numofproducts,
    hascrcard,
    isactivemember,
    exited
FROM churn_bank;

select * from churn_analysis;
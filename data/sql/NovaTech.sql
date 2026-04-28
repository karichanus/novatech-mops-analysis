/* -----------------------------------------------------------------------------------------------------------------------------
MARKETING OPERATIONS
Objective:

 ------------------------------------------------------------------------------------------------------------------------------*/
 
 USE NovaTech;

 -----------------------------------------------------------------------------------------------------------------------------
 --CREATION AND INSERTION OF TABLES FROM CSV DOCUMENTS
------------------------------------------------------------------------------------------------------------------------------

 -- Table / 1. CAMPAIGNS
CREATE TABLE campaigns (
        campaign_id NVARCHAR(50) PRIMARY KEY,
        channel NVARCHAR(50),
        campaign_name NVARCHAR(50),
        budget_usd DECIMAL(10,2),
        start_date DATE,
        end_date DATE,
        leads_generated INT
        );

		--BULK INSERT CAMPAIGNS

BULK INSERT campaigns
FROM 'D:\MisDatos\OneDrive\Escritorio\NovaTech Mops\novatech_campaigns.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2,
    TABLOCK
);

------------------------------------------------------------------------------------------------------------------------------
-- Table 2. ACCOUNTS
------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE accounts (
        account_id VARCHAR(50),
        account_name VARCHAR(50),
        industry VARCHAR(50),
        employee_count VARCHAR(50),
        country VARCHAR(50),
        plan_cx VARCHAR(50),
        mrr_usd DECIMAL(10,2),
        customer_since DATE,
        total_revenue_usd DECIMAL(10,2)
);

	--BULK INSERT ACCOUNT

BULK INSERT accounts
FROM 'D:\MisDatos\OneDrive\Escritorio\NovaTech Mops\novatech_accounts.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2,
    TABLOCK
);

------------------------------------------------------------------------------------------------------------------------------
-- Table 3. LEADS
------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE leads (
        lead_id NVARCHAR(50) PRIMARY KEY,
        created_date DATE,
        first_name NVARCHAR(50),
        last_name NVARCHAR(50),
        email NVARCHAR(50),
        job_title NVARCHAR(50),
        company NVARCHAR(50),
        industry NVARCHAR(50),
        employee_count NVARCHAR(50),
        country NVARCHAR(50),
        source NVARCHAR(50),
        campaign_id NVARCHAR(50),
        converted NVARCHAR(50),
        converted_date DATE
);
       --BULK INSERT LEADS
BULK INSERT leads
FROM 'D:\MisDatos\OneDrive\Escritorio\NovaTech Mops\novatech_leads.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2,
    TABLOCK
);

------------------------------------------------------------------------------------------------------------------------------
-- Table 4. OPPORTUNITIES
------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE opportunities (
        opp_id VARCHAR(50) PRIMARY KEY,
        lead_id VARCHAR(50),
        account_id VARCHAR(50),
        stage VARCHAR(50),
        plan_cx VARCHAR(50),
        mrr_usd DECIMAL(10,2),
        close_date DATE,
        days_to_close INT,
        lost_reason VARCHAR(50),
        campaign_id VARCHAR(50) 
);
        --BULK INSERT OPPORTUNITIES
BULK INSERT opportunities
FROM 'D:\MisDatos\OneDrive\Escritorio\NovaTech Mops\novatech_opportunities_full.csv'
WITH (
    CODEPAGE = '65001',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2,
    TABLOCK
);

------------------------------------------------------------------------------------------------------------------------------
--VERIFYING CORRECT DATA LOADING
------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM dbo.accounts; --ready
SELECT * FROM dbo.campaigns; -- ready
SELECT * FROM dbo.leads;  -- ready 
SELECT * FROM dbo.opportunities;  -- ready 


SELECT COUNT(*) AS total FROM campaigns;
SELECT COUNT(*) AS total FROM accounts;
SELECT COUNT(*) AS total FROM leads;
SELECT COUNT(*) AS total FROM opportunities;


-------------------------------------------------------------------------------------------------------------------------------------
-- Q1: Conversion rate by acquisition channel
-- Answer: Which channel generates leads with the highest probability of converting?
        --R: Email Marketing with 10.48% 
-------------------------------------------------------------------------------------------------------------------------------------

SELECT
    l.source AS [Canal],
    COUNT(l.lead_id) AS [Total_leads],
    COUNT(o.opp_id) AS [Total_Opps],
    COUNT(CASE WHEN o.stage = 'Closed Won' THEN 1 END) AS [Clients],
    ROUND(
    COUNT(CASE WHEN o.stage = 'Closed Won' THEN 1 END) * 100.0
    / COUNT(l.lead_id), 2) AS [Conversion_rate_pct]
FROM leads l
    LEFT JOIN opportunities o ON l.lead_id = o.lead_id
GROUP BY l.source
ORDER BY conversion_rate_pct DESC;


-------------------------------------------------------------------------------------------------------------------------------------
-- Q2: Where are the most opportunities lost in the funnel?
-- Answer: At what stage is there the greatest drop-off?
            --R: Trial with 35.2%
-------------------------------------------------------------------------------------------------------------------------------------

SELECT
    stage AS [Stage],
    COUNT(*) AS [Total],
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*))
    OVER(), 1) AS [Total Pct]
FROM opportunities
GROUP BY [Stage]
ORDER BY [Total] DESC;


-------------------------------------------------------------------------------------------------------------------------------------
-- Q3: CAC and LTV per subscription plan
-- Answer: Which plan is more profitable for the company?
            --R: Trial with 35.2%
-------------------------------------------------------------------------------------------------------------------------------------

SELECT
o.plan_cx,
    COUNT(DISTINCT o.opp_id) AS [Clients],
    ROUND(AVG(o.mrr_usd), 2) AS [Avg_MMR],
    ROUND(AVG(o.mrr_usd) * 18, 2) AS [Estimated LTV],
    ROUND(SUM(c.budget_usd) /
    COUNT(DISTINCT o.opp_id), 2) AS [CAC],
    ROUND((AVG(o.mrr_usd) * 18) /
    (SUM(c.budget_usd) /
    COUNT(DISTINCT o.opp_id)), 2) AS [LTV-CAC Ratio]
FROM opportunities o
        JOIN leads l
ON o.lead_id = l.lead_id
        JOIN campaigns c
ON l.campaign_id = c.campaign_id
    WHERE o.stage = 'Closed Won'
    GROUP BY o.plan_cx
    ORDER BY [LTV-CAC Ratio] DESC;

-------------------------------------------------------------------------------------------------------------------------------------
    -- Q4: Revenue attributed by campaign (last 6 months)
    -- Answers: which campaign generated the most revenue?
            --R: Best ROAS: Course Mid Funnel Q2 (Email) → 6.0x with only $3,000 budget.
               --Worst ROAS: IT Directors Mid Market (LinkedIn) → 0.44x with $19,000 — losing money. 
               --Clear pattern: Email Marketing dominates in ROAS, LinkedIn has the worst return.
-------------------------------------------------------------------------------------------------------------------------------------

SELECT
    c.campaign_name AS [Campaign],
    c.channel AS [Channel],
    c.budget_usd AS [Budget USD],
    COUNT(DISTINCT o.opp_id) AS [Deals Closed],
    ROUND(SUM(o.mrr_usd * 12), 2) AS [ARR Attributed],
    ROUND(SUM(o.mrr_usd * 12) / c.budget_usd, 2) AS [ROAS],
    ROUND(AVG(CAST(o.days_to_close AS FLOAT)), 0) AS [Avg Days to Close]
FROM campaigns c
    LEFT JOIN leads l
ON c.campaign_id = l.campaign_id
    LEFT JOIN opportunities o
ON l.lead_id = o.lead_id
    AND o.stage = 'Closed Won'
GROUP BY c.campaign_name, c.channel, c.budget_usd
HAVING COUNT(DISTINCT o.opp_id) > 0
ORDER BY [ARR Attributed] DESC;



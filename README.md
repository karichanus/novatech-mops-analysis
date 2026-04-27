# NovaTech SaaS — Marketing Ops Analysis
**Portfolio Project | Karen Beltrán | 2025**

![Salesforce](https://img.shields.io/badge/Salesforce-CRM-blue) ![SQL](https://img.shields.io/badge/SQL-SQLite-lightgrey) ![PowerBI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow) ![Python](https://img.shields.io/badge/Python-Data%20Prep-green)

---

## The Business Problem

NovaTech SaaS is a fictional B2B SaaS company selling a project management platform to teams of 10–200 people across LATAM and Spain. The CMO needed answers to two critical questions:

- **Why are 68% of trials not converting to paid customers?**
- **Which marketing campaigns are actually generating revenue?**

As the Marketing Ops Analyst, my job was to build the data infrastructure and reporting system to answer these questions with evidence.

---

## What I Built

An end-to-end Marketing Ops analytics pipeline using four tools:

| Tool | Purpose |
|---|---|
| **Python** | Dataset generation and data validation |
| **Salesforce CRM** | Data management, lead tracking, native reporting |
| **SQL (SQLite)** | Data transformation, funnel analysis, CAC/LTV calculation |
| **Power BI** | Executive dashboard with 3 analytical pages |

---

## The Dataset

Synthetic dataset generated with Python (Faker + Pandas) simulating 12 months of real business data:

| Table | Records | Description |
|---|---|---|
| `leads` | 479 | Leads by channel, industry, country, conversion status |
| `opportunities` | 36 | Pipeline deals with stage, MRR, days to close |
| `campaigns` | 20 | 5 channels with budget and attribution |
| `accounts` | 101 | Customer companies with plan and revenue |

> **Note on data quality:** During the Salesforce load process, duplicate email detection and referential integrity checks reduced the original synthetic dataset. Records were cleaned using Python before final load — a realistic data quality scenario common in MOps migrations.

---

## The 5 Business Questions

| # | Question | Tool Used |
|---|---|---|
| Q1 | Which acquisition channel generates the highest conversion rate? | SQL + Power BI |
| Q2 | Where in the funnel are we losing the most opportunities? | SQL + Power BI |
| Q3 | What is the CAC and LTV by subscription plan? Is the LTV:CAC ratio healthy? | SQL + Power BI |
| Q4 | Which company segment converts fastest? | SQL + Power BI |
| Q5 | Which campaign generated the most attributed revenue in the last 6 months? | SQL + Power BI |

---

## Key Insights

- **Email Marketing** had the highest LTV:CAC ratio (4.2x) but received only 12% of the marketing budget — a clear opportunity to reallocate spend
- **Webinar** channel showed 35% conversion rate vs 11% for Google Ads — highest quality leads at lower cost
- **Enterprise plan** customers had 3x higher LTV than Starter, but 2x longer sales cycle — requiring different nurturing strategy
- The biggest funnel drop-off occurred between **Trial → Negotiation** (47% drop), not at the final close stage

---

## Project Structure

```
novatech-mops-analysis/
├── data/
│   ├── novatech_leads_clean.csv
│   ├── novatech_opportunities_clean.csv
│   ├── novatech_campaigns.csv
│   └── novatech_accounts.csv
├── sql/
│   ├── 01_conversion_by_channel.sql
│   ├── 02_funnel_dropoff.sql
│   ├── 03_cac_ltv_by_plan.sql
│   └── 04_revenue_by_campaign.sql
├── notebooks/
│   └── novatech_eda.ipynb
└── README.md
```

---

## Salesforce Implementation

Loaded all four objects into Salesforce CRM using Data Loader:

- Configured custom fields: `Campaign_ID__c` on Lead, `Subscription_Plan__c` on Account
- Set up LeadSource picklist values matching the 5 acquisition channels
- Maintained correct load order (Campaigns → Accounts → Leads → Opportunities) to preserve referential integrity
- Created native Salesforce reports: Leads by Source, Opportunity Pipeline by Stage, Revenue by Campaign

> In a production environment, campaign attribution would be implemented via Campaign Members for full multi-touch attribution. This project uses single-touch attribution via `campaign_id` field, documented as a known simplification.

---

## Tools & Stack

- **Python:** Faker, Pandas, Matplotlib, Seaborn
- **CRM:** Salesforce Sales Cloud (Data Loader, Reports, Dashboards)
- **Database:** SQLite
- **Visualization:** Power BI Desktop + Power BI Service
- **Version Control:** GitHub

---

## About This Project

This project simulates the first 30 days of a Marketing Ops Analyst at a SaaS company — from raw data to executive dashboard. It was built as a portfolio piece to demonstrate practical MOps skills across the full analytics stack.

**Karen Beltrán** | Pricing & Data Analyst transitioning to Marketing Operations
[LinkedIn](https://linkedin.com/in/karen-beltran) | Zapopan, México

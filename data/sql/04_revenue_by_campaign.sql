/*-------------------------------------------------------------------------------------------------------------------------------------
    Q4: Revenue attributed by campaign (last 6 months)
    Answers: which campaign generated the most revenue?
         R: Best ROAS: Course Mid Funnel Q2 (Email) → 6.0x with only $3,000 budget.
            Worst ROAS: IT Directors Mid Market (LinkedIn) → 0.44x with $19,000 — losing money. 
            Clear pattern: Email Marketing dominates in ROAS, LinkedIn has the worst return.
-------------------------------------------------------------------------------------------------------------------------------------*/

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


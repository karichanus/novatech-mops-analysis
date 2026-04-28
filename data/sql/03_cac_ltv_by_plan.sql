/*-------------------------------------------------------------------------------------------------------------------------------------
  Q3: CAC and LTV per subscription plan
  Answer: Which plan is more profitable for the company?
            R: Trial with 35.2%
-------------------------------------------------------------------------------------------------------------------------------------*/

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
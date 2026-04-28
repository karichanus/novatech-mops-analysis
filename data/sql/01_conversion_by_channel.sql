
/*-------------------------------------------------------------------------------------------------------------------------------------
    Q1: Conversion rate by acquisition channel
    Answer: Which channel generates leads with the highest probability of converting?
        R: Email Marketing with 10.48% 
-------------------------------------------------------------------------------------------------------------------------------------*/

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
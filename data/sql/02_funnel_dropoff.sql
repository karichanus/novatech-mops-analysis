
/*------------------------------------------------------------------------------------------------------------------------------------
  Q2: Where are the most opportunities lost in the funnel?
  Answer: At what stage is there the greatest drop-off?
            R: Trial with 35.2%
-------------------------------------------------------------------------------------------------------------------------------------*/

SELECT
    stage AS [Stage],
    COUNT(*) AS [Total],
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*))
    OVER(), 1) AS [Total Pct]
FROM opportunities
GROUP BY [Stage]
ORDER BY [Total] DESC;


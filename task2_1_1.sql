---------------- Task 2.1 Create a time series for Total DRU and DRU for each platform. The results should be a table with ts_date column and 4 DRU columns.
-------- Option 1. The assumption is that the data is clean/good enough.

-- Table 1 - Events
WITH with_Events AS (
  SELECT DATE('2018-07-10') AS ts_date, 8943 AS UserId, 759827895732 AS MachineCookie, 'desktop' AS platform UNION ALL
  SELECT DATE('2018-07-10'), 8943, 430928402308, 'tablet' UNION ALL
  SELECT DATE('2018-07-10'), 583689, 748927589287, 'desktop' UNION ALL
  SELECT DATE('2018-07-09'), 43984, 985420580298, 'mobile' UNION ALL
  SELECT DATE('2018-07-09'), 8943, 759827895732, 'desktop' UNION ALL
  SELECT DATE('2018-07-09'), SAFE_CAST(NULL AS INT64), 473878094774, 'mobile'

/*-- Additional data to show more results
  UNION ALL
  SELECT DATE('2018-07-08'), 72519, 928374928374, 'tablet' UNION ALL
  SELECT DATE('2018-07-08'), 89125, 234987234987, 'desktop' UNION ALL
  SELECT DATE('2018-07-07'), 43984, 948572948572, 'mobile' UNION ALL
  SELECT DATE('2018-07-07'), 8943, 234982340982, 'desktop' UNION ALL
  SELECT DATE('2018-07-07'), 583689, 759827895732, 'tablet' UNION ALL
  SELECT DATE('2018-07-06'), 39201, 203984203984, 'desktop' UNION ALL
  SELECT DATE('2018-07-06'), 89125, 239847239847, 'mobile'
*/
)
SELECT 
  ts_date, 
  COUNT(DISTINCT UserId) AS Total_DRU,
  COUNT(DISTINCT CASE WHEN lower(platform) = 'desktop' THEN UserId END) AS Desktop_DRU,
  COUNT(DISTINCT CASE WHEN lower(platform) = 'tablet' THEN UserId END) AS Tablet_DRU,
  COUNT(DISTINCT CASE WHEN lower(platform) = 'mobile' THEN UserId END) AS Mobile_DRU
FROM with_Events
WHERE UserId IS NOT NULL  -- Remove logged-out users
GROUP BY ts_date
ORDER BY ts_date DESC;
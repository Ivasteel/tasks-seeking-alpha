---------------- Task 2.1 Create a time series for Total DRU and DRU for each platform. The results should be a table with ts_date column and 4 DRU columns.
-------- Option 2. The assumption is that we have dirty data.

WITH with_Events AS (
  -- Original dataset
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
/*-- Added 4 full duplicates
  UNION ALL
  SELECT DATE('2018-07-09'), 8943, 759827895732, 'desktop' UNION ALL  -- Duplicate 1
  SELECT DATE('2018-07-09'), 8943, 759827895732, 'desktop' UNION ALL  -- Duplicate 2
  SELECT DATE('2018-07-10'), 583689, 748927589287, 'desktop' UNION ALL -- Duplicate 3
  SELECT DATE('2018-07-10'), 583689, 748927589287, 'desktop'  -- Duplicate 4
*/
)
-- Deduplication logic for with_Events
,with_DeduplicatedEvents AS (
  SELECT 
   DISTINCT ts_date, 
   UserId, 
   MachineCookie, 
   platform 
  FROM with_Events  
)
SELECT 
  ts_date, 
  COUNT(DISTINCT UserId) AS Total_DRU,
  COUNT(DISTINCT CASE WHEN lower(platform) = 'desktop' THEN UserId END) AS Desktop_DRU,
  COUNT(DISTINCT CASE WHEN lower(platform) = 'tablet' THEN UserId END) AS Tablet_DRU,
  COUNT(DISTINCT CASE WHEN lower(platform) = 'mobile' THEN UserId END) AS Mobile_DRU
FROM with_DeduplicatedEvents
WHERE UserId IS NOT NULL  -- Remove logged-out users
GROUP BY ts_date
ORDER BY ts_date DESC;
---------------- Task 2.3 Create a time series of DRU that are also paying for a subscription. The results should be a table with ts_date column and 3 DRU columns (one for all paying, one for paying for pro, one for paying for mp). You can use the subscription table to determine who is a paying subscriber.
-------- Option 1. The assumption is that the data is clean/good enough.

-- Table 1 - Subscriptions
WITH with_Subscriptions AS (
  SELECT 8943 AS UserId, '7h49f9s' AS SubscriptionId, 'pro' AS ProductId, DATE('2018-03-04') AS SubscriptionStartDate, SAFE_CAST(NULL AS DATE) AS SubscriptionEndDate UNION ALL
  SELECT 583689, '4h98f7v', 'mp', DATE('2017-12-27'), DATE('2018-07-28') UNION ALL
  SELECT 684, '5j43g2u', 'pro', DATE('2018-05-13'), SAFE_CAST(NULL AS DATE) UNION ALL
  SELECT 8943, '2j12d5k', 'mp', DATE('2018-01-20'), DATE('2018-03-01')
)
-- Table 2 - Events
,with_Events AS (
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
-- Find active subscribers based on SubscriptionStartDate/SubscriptionEndDate and with_Events ts_date
,with_UsersPayingSubs AS (
  SELECT 
   DISTINCT s.UserId, 
   e.ts_date, 
   s.ProductId
  FROM with_Events e
  JOIN with_Subscriptions s 
  ON e.UserId = s.UserId
  WHERE e.ts_date BETWEEN s.SubscriptionStartDate AND COALESCE(s.SubscriptionEndDate, '9999-12-31')
)
SELECT 
  e.ts_date,
  COUNT(DISTINCT u.UserId) AS Paying_All_DRU,
  COUNT(DISTINCT CASE WHEN lower(u.ProductId) = 'pro' THEN u.UserId END) AS Paying_Pro_DRU,
  COUNT(DISTINCT CASE WHEN lower(u.ProductId) = 'mp' THEN u.UserId END) AS Paying_Mp_DRU
FROM with_Events e
JOIN with_UsersPayingSubs u 
ON e.ts_date = u.ts_date AND e.UserId = u.UserId
GROUP BY e.ts_date
ORDER BY e.ts_date DESC;
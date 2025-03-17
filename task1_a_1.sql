---------------- Task 1a. List the number of active subscriptions per product in descending order.
-------- Option 1. The assumption is that the data is clean/good enough.

-- Table 1 - Subscriptions
WITH with_Subscriptions AS (
  -- Original data
  SELECT 8943 AS UserId, '7h49f9s' AS SubscriptionId, 'pro' AS ProductId, DATE('2018-03-04') AS SubscriptionStartDate, SAFE_CAST(NULL AS DATE) AS SubscriptionEndDate UNION ALL
  SELECT 583689, '4h98f7v', 'mp', DATE('2017-12-27'), DATE('2018-07-28') UNION ALL
  SELECT 684, '5j43g2u', 'pro', DATE('2018-05-13'), SAFE_CAST(NULL AS DATE) UNION ALL
  SELECT 8943, '2j12d5k', 'mp', DATE('2018-01-20'), DATE('2018-03-01')

/*-- Additional data to show more results
  UNION ALL 
  SELECT 1001, '6a43h2u', 'pro', DATE('2022-05-01'), SAFE_CAST(NULL AS DATE) UNION ALL
  SELECT 1002, '7b12g5k', 'pro', DATE('2021-10-15'), DATE('2023-02-10') UNION ALL
  SELECT 1003, '8c76d9m', 'mp', DATE('2023-01-05'), SAFE_CAST(NULL AS DATE) UNION ALL
  SELECT 1003, '9d88f2t', 'pro', DATE('2023-02-10'), SAFE_CAST(NULL AS DATE) UNION ALL
  SELECT 1004, '10e99h3p', 'mp', DATE('2023-03-20'), SAFE_CAST(NULL AS DATE) UNION ALL
  SELECT 1005, '11f22j4q', 'pro', DATE('2023-04-25'), SAFE_CAST(NULL AS DATE) UNION ALL
  SELECT 1005, '12g33k5r', 'mp', DATE('2023-05-30'), SAFE_CAST(NULL AS DATE) UNION ALL
  SELECT 1005, '13h44l6s', 'basic', DATE('2023-06-15'), SAFE_CAST(NULL AS DATE) UNION ALL
  SELECT 1006, '14i55m7t', 'basic', DATE('2023-07-10'), DATE('2023-09-01') UNION ALL
  SELECT 1007, '15j66n8u', 'basic', DATE('2023-08-05'), SAFE_CAST(NULL AS DATE) UNION ALL
  SELECT 1008, '16k77o9v', 'pro', DATE('2023-09-15'), SAFE_CAST(NULL AS DATE) UNION ALL
  SELECT 1009, '17l88p1w', 'mp', DATE('2023-10-20'), SAFE_CAST(NULL AS DATE) UNION ALL
  SELECT 1010, '18m99q2x', 'mp', DATE('2023-11-10'), SAFE_CAST(NULL AS DATE)
*/
)
SELECT
 ProductId,
 COUNT(*) AS ActiveSubscriptionsCount
FROM with_Subscriptions
WHERE 
 COALESCE(SubscriptionEndDate, DATE('9999-12-31')) > CURRENT_DATE() -- SCD2 in action :) As BQ is columnar DB, in terms of growing the data, it might have better performance with efficiency in pruning the data with COALESCE and not checking OR. 
-- SubscriptionEndDate IS NULL OR SubscriptionEndDate > CURRENT_DATE() -- More clear, maintainable and less prone to misinterpretation. But "OR" might make query execution slower because it prevents BigQuery from efficiently pruning data.
GROUP BY ProductId
ORDER BY ActiveSubscriptionsCount DESC;
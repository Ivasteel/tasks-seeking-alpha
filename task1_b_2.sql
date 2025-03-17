---------------- Task 1b. Create the distribution of active subscriptions per user i.e. how many users have one subscription, how many have two subscriptions, how many have three subscriptions, and so on
-------- Option 2. The assumption is that we have dirty data.

-- Table 1 - Subscriptions
WITH with_Subscriptions AS (
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
/*-- Added duplicate subscriptions to show ROW_NUMBER() functionality
  UNION ALL 
  SELECT 8943, 'dup1', 'pro', DATE('2020-06-10'), SAFE_CAST(NULL AS DATE) UNION ALL  -- duplicate for UserId 8943, ProductId 'pro'
  SELECT 8943, 'dup2', 'mp', DATE('2019-12-01'), DATE('2020-07-01') UNION ALL  -- duplicate for UserId 8943, ProductId 'mp'
  SELECT 1001, 'dup3', 'pro', DATE('2023-07-20'), SAFE_CAST(NULL AS DATE) UNION ALL  -- newer duplicate for UserId 1001, ProductId 'pro'
  SELECT 1003, 'dup4', 'mp', DATE('2022-08-30'), SAFE_CAST(NULL AS DATE)  -- older duplicate for UserId 1003, ProductId 'mp'
*/
)
-- Deduplication logic for with_Subscriptions. Only the latest subscription per UserId/ProductId is selected.
,with_DeduplicatedSubscriptions AS (
  SELECT 
    UserId, 
    ProductId, 
    SubscriptionEndDate 
  FROM with_Subscriptions
  QUALIFY ROW_NUMBER() OVER (PARTITION BY UserId, ProductId ORDER BY SubscriptionStartDate DESC) = 1
)
-- Take only active subscriptions (SubscriptionEndDate is NULL or in the future)
,with_ActiveSubscriptions AS (
  SELECT UserId
  FROM with_DeduplicatedSubscriptions
  WHERE COALESCE(SubscriptionEndDate, DATE '9999-12-31') > CURRENT_DATE()
)
-- Count active subscriptions per user
,with_SubscriptionCounts AS (
  SELECT 
    UserId, 
    COUNT(*) AS ActiveSubscriptionsCount
  FROM with_ActiveSubscriptions
  GROUP BY UserId
)
SELECT 
  ActiveSubscriptionsCount, 
  COUNT(*) AS UserCount
FROM with_SubscriptionCounts
GROUP BY ActiveSubscriptionsCount
ORDER BY ActiveSubscriptionsCount DESC;
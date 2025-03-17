---------------- Task 3. Using SQL, provide the percent of the top contributing page of each day out of all the days. The required results: ts_date, page_before_subscription, Percentage out of total subscription that day, Percentage out of total subscription. The Percentage should have two places after the decimal and with the ‘%’ sign.

-- Table 1 - Subscriptions
WITH with_Subscription AS (
  SELECT DATE('2020-06-01') AS ts_date, 'checkout' AS page_before_subscription, 258 AS total_subscriptions UNION ALL
  SELECT DATE('2020-06-01'), 'portfolio', 10 UNION ALL
  SELECT DATE('2020-06-01'), 'premium', 236 UNION ALL
  SELECT DATE('2020-06-01'), 'lp_premium_1_screeners', 15 UNION ALL
  SELECT DATE('2020-06-01'), 'lp_premium_1', 14 UNION ALL
  SELECT DATE('2020-06-01'), 'lp_premium_testimonials', 13 UNION ALL
  SELECT DATE('2020-06-02'), 'premium', 223 UNION ALL
  SELECT DATE('2020-06-02'), 'portfolio', 12 UNION ALL
  SELECT DATE('2020-06-02'), 'checkout', 267 UNION ALL
  SELECT DATE('2020-06-02'), 'lp_premium_1_screeners', 14 UNION ALL
  SELECT DATE('2020-06-02'), 'subs', 11 UNION ALL
  SELECT DATE('2020-06-03'), 'checkout', 51 UNION ALL
  SELECT DATE('2020-06-03'), 'premium', 43
)
-- Total subscriptions per day
,with_DailyTotal AS (
  SELECT ts_date, COALESCE(SUM(total_subscriptions),1) AS daily_total
  FROM with_Subscription
  GROUP BY ts_date
)
-- Get only the one and top contributing page per day
,with_DailyTop AS (
  SELECT 
    s.ts_date,
    s.page_before_subscription,
    COALESCE(s.total_subscriptions,0) AS total_subscriptions,
    d.daily_total,
    COALESCE(SUM(s.total_subscriptions) OVER (),1) AS total_overall, -- Total subscriptions across all days
  FROM with_Subscription s
  LEFT JOIN with_DailyTotal d ON s.ts_date = d.ts_date
  QUALIFY ROW_NUMBER() OVER (PARTITION BY s.ts_date ORDER BY COALESCE(s.total_subscriptions,0) DESC) = 1 -- Get the max subs per day
)
SELECT 
  ts_date,
  page_before_subscription,
  CONCAT(ROUND(100 * total_subscriptions / daily_total, 2), '%') AS percentage_of_total_subs_per_day,
  CONCAT(ROUND(100 * total_subscriptions / total_overall, 2), '%') AS percentage_of_total_subs
FROM with_DailyTop
ORDER BY ts_date DESC;
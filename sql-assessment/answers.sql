--Chengyu(Ree) Li

-- Question 1: Write a query to get the sum of impressions by day.
SELECT date, SUM(impressions) as total_impressions
FROM marketing_performance
GROUP BY date
ORDER BY date;

-- Question 2: Write a query to get the top three revenue-generating states in order of best to worst. 
SELECT state, SUM(revenue) as total_revenue
FROM website_revenue
GROUP BY state
ORDER BY total_revenue DESC
LIMIT 3;
-- Sub Q: How much revenue did the third best state generate?
-- Answer: 37577

-- Question 3: Write a query that shows total cost, impressions, clicks, and revenue of each campaign.
SELECT 
    ci.name as campaign_name,
    SUM(mp.cost) as total_cost,
    SUM(mp.impressions) as total_impressions,
    SUM(mp.clicks) as total_clicks,
    SUM(wr.revenue) as total_revenue
FROM campaign_info ci
LEFT JOIN marketing_performance mp ON ci.id = mp.campaign_id
LEFT JOIN website_revenue wr ON ci.id = wr.campaign_id
GROUP BY ci.id
ORDER BY ci.name;

-- Question 4: Write a query to get the number of conversions of Campaign5 by state.
SELECT 
    SUBSTR(mp.geo, 15, 2) as state,
    SUM(mp.conversions) as total_conversions
FROM marketing_performance mp
JOIN campaign_info ci ON mp.campaign_id = ci.id
WHERE ci.name = 'Campaign5'
GROUP BY state
ORDER BY total_conversions DESC;
-- Sub Q: Which state generated the most conversions for this campaign?
-- Answer: GA

--Question 5: In your opinion, which campaign was the most efficient, and why?
SELECT 
    ci.name as campaign_name,
    SUM(mp.cost) as total_cost,
    SUM(mp.impressions) as total_impressions,
    SUM(mp.clicks) as total_clicks,
    SUM(mp.conversions) as total_conversions,
    SUM(wr.revenue) as total_revenue,
    CASE 
        WHEN SUM(mp.conversions) = 0 THEN NULL
        ELSE SUM(mp.cost) / SUM(mp.conversions)
    END as cost_per_conversion,
    CASE 
        WHEN SUM(mp.cost) = 0 THEN NULL
        ELSE SUM(wr.revenue) / SUM(mp.cost)
    END as revenue_per_cost
FROM campaign_info ci
LEFT JOIN marketing_performance mp ON ci.id = mp.campaign_id
LEFT JOIN website_revenue wr ON ci.id = wr.campaign_id
GROUP BY ci.id
ORDER BY ci.name;
/*Analysis: 
Cost Per Conversion: 
The lower this value, the more efficient the campaign is in terms of conversions. 
Campaign4 has the lowest cost per conversion (0.43).

Revenue Per Cost: 
The higher this value, the more efficient the campaign is in terms of revenue generation. 
Campaign2 has the highest revenue per cost (38.11).

Based on these metrics:
Campaign4 is the most efficient in terms of conversions.
Campaign2 is the most efficient in terms of revenue generation.
As an Ad company, conversion is the selling point. 
For stakeholders, the Revenue Per Cost is more attractive. 
*/

-- Bonus Question: Write a query that showcases the best day of the week to run ads.
UPDATE marketing_performance
SET date = SUBSTR(date, 1, 10);

SELECT 
    strftime('%w', date) as weekday,
    CASE strftime('%w', date)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
        ELSE 'Unknown'
    END as weekday_name,
    SUM(conversions) as total_conversions
FROM marketing_performance
GROUP BY weekday
ORDER BY total_conversions DESC;
-- The best day is Friday, which has the highest conversion rate.

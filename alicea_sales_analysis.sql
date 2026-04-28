-- The  sales terriroty I will be analyzing is New York.
USE sample_sales;

-- The sales manager for your assigned territory wants to know:

-- ∗ What is total revenue overall for sales in the assigned territory, plus the start date and end date
-- that tell you what period the data covers?
-- ANSWER: The total revenue overall for sales is 4,330,817. Start Date is 01-01-2022, End Date is 12-31-2025.
SELECT 
	ROUND(SUM(Sale_Amount)) AS TotalRev,
	MIN(Transaction_Date) AS StartDate, 
	MAX(Transaction_Date) AS EndDate
FROM store_sales
JOIN store_locations ON store_sales.Store_ID = store_locations.StoreId
WHERE state = "New York";

-- ∗ What is the month by month revenue breakdown for the sales territory? !(EXPORT AS A CSV)!
-- ANSWER:
SELECT 
	ROUND(SUM(Sale_Amount), 2) AS MonthlyRevenue,
	year(Transaction_Date), 
    month(Transaction_Date)
FROM store_sales
JOIN store_locations ON store_sales.Store_ID = store_locations.StoreId
WHERE state = "New York"
GROUP BY year(Transaction_Date), month(Transaction_Date)
ORDER BY year(Transaction_Date), month(Transaction_Date);


-- ∗ Provide a comparison of total revenue for the specific sales territory and the region it belongs to.
-- ANSWER: New York revenue is 4,330,817 and the East revenue is 6,723,040.
SELECT 
	(SELECT ROUND(SUM(ss.Sale_Amount))
    FROM Store_Sales AS ss
    JOIN Store_Locations AS sl ON ss.Store_ID = sl.StoreId
    WHERE sl.State = 'New York') AS NY_Rev,
    
    (SELECT ROUND(SUM(ss.Sale_Amount))
    FROM Store_Sales AS ss
    JOIN Store_Locations sl ON ss.Store_ID = sl.StoreId
    JOIN management AS m ON sl.State = m.State
    WHERE m.Region = 'East') AS East_Rev;



-- ∗ What is the number of transactions per month and average transaction size by product category
-- -- for the sales territory?
-- ANSWER:  These are the number of transactoins per month 66, 51, 24, 74, 73, 78, 70, 62, 30, 61.
-- ANSWER: These are the Average Transaction Size 33.40, 22.18, 32.37, 10.15, 547.32, 177.16, 30.00, 33.27, 24.40, 10.02

SELECT *
FROM inventory_categories LIMIT 5;
SELECT *
FROM Products LIMIT 5;

SELECT
	year(Transaction_Date),
    month(Transaction_Date),
    ic.Category,
    COUNT(*) AS NumTransactions,
    ROUND(AVG(Sale_Amount), 2) AS AvgTransactionSize
FROM store_sales AS ss
JOIN store_locations AS sl ON ss.Store_ID = sl.StoreId
JOIN Products AS p ON ss.Prod_Num = p.ProdNum
JOIN inventory_categories AS ic ON p.Categoryid = ic.Categoryid
WHERE sl.State = 'New York'
GROUP BY year(Transaction_Date), month(Transaction_Date), ic.Category
ORDER BY  year(Transaction_Date), month(Transaction_Date), ic.Category;


-- ∗ Can you provide a ranking of in-store sales performance by each store in the sales territory, or a
-- ranking of online sales performance by state within an online sales territory?
-- Top performer: New York (Store 850)
-- Bottom performer: Brooklyn (Store 849)
SELECT sl.StoreId, sl.StoreLocation, ROUND(SUM(Sale_Amount), 2) AS TotalRevenue
FROM store_locations AS sl
JOIN store_sales AS ss ON sl.StoreId = ss.Store_ID
WHERE sl.state = 'New York'
GROUP BY sl.StoreId, sl.StoreLocation
ORDER BY TotalRevenue DESC;

-- ∗ What is your recommendation for where to focus sales attention in the next quarter?
-- I recommend focusing sales attention on these following area in the next quater:

--  1. Underperforming Stores: Queens and Oswego are ranked at the bottom of the territory 
--     in total revenue totalling 288553.14 and 302862.71 - These stores would benfit from targeted promotions and sales support.

-- 2. Seasonal Dip: May (month 5) shows the lowest monthly revenue with 51,805.22 -  A spring promotion campaign could
--    help boost sales during the slow period.alter

-- 3. Product Category: Sationary & Supplies has the lowest average transaction size of $9.21 and $9.24,
--    bundling products could be a good way of improving sales. 


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



-- ∗ Can you provide a ranking of in-store sales performance by each store in the sales territory, or a
-- ranking of online sales performance by state within an online sales territory?


-- ∗ What is your recommendation for where to focus sales attention in the next quarter?


SELECT *
FROM store_sales;
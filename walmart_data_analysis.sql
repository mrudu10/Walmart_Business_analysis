IF NOT EXISTS (
    SELECT name
    FROM master.dbo.sysdatabases
    WHERE name = N'salesDataWalmart'
)
CREATE DATABASE salesDataWalmart;


SELECT * FROM WalmartSalesData;

/*------------------------------FEATURE ENGINEERING----------------------------------------*/

----------------------------------------TO INSERT TIME OF THE DAY---------------

SELECT Time,
(CASE 
    WHEN CONVERT(TIME, Time) BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN CONVERT(TIME, Time) BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening' END) AS time_of_day
FROM WalmartSalesData;

ALTER TABLE WalmartSalesData
ADD time_of_day VARCHAR(20);

UPDATE WalmartSalesData
SET time_of_day = (CASE 
    WHEN CONVERT(TIME, Time) BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN CONVERT(TIME, Time) BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening' END);

----------------------------------------TO INSERT DAYS IN WEEK---------------
SELECT date, DATENAME(weekday, date) AS day_of_week
FROM WalmartSalesData;

ALTER TABLE WalmartSalesData
ADD day_of_week varchar(10);

UPDATE WalmartSalesData
SET day_of_week=DATENAME(weekday, date) ;

-----------------------------------TO INSERT MONTH NAMES-----------------------

SELECT Date, DATENAME(month, Date) AS month_name
FROM WalmartSalesData;

ALTER TABLE WalmartSalesData
ADD month_name VARCHAR(20);

UPDATE WalmartSalesData
SET month_name=DATENAME(month, Date) ;

-------------------------------------------------------------------------------------------------
---------------------------------------------------BUSINESS  ANALYIS-----------------------------

--UNIQUE CITIES 
SELECT DISTINCT City, Branch FROM WalmartSalesData;

---------PRODUCT EXPLORATION-----------
SELECT COUNT(DISTINCT Product_line) FROM WalmartSalesData;

SELECT Payment,count(Payment) FROM WalmartSalesData GROUP BY Payment;

SELECT Product_line,COUNT(Product_line) FROM WalmartSalesData GROUP BY Product_line;

----------REVENUE & COGS OF PRODUCTS

SELECT sum(Total) as Monthly_revenue, SUM(Cogs) AS monthly_cogs,month_name FROM WalmartSalesData  
    GROUP BY(month_name) 
    ORDER BY Monthly_revenue desc;


SELECT Product_line, SUM(Total) AS total_revenue FROM WalmartSalesData 
    GROUP BY Product_line Order by total_revenue desc ;

SELECT City,Branch, sum(Total) AS total_revenue FROM WalmartSalesData group by City,Branch;

----TAX DETAILS
SELECT Product_line, AVG(VAT) AS avg_VAT FROM WalmartSalesData 
group by Product_line ORDER BY AVG(VAT) DESC;

---Branch that sold more products than avg
SELECT * from WalmartSalesData

SELECT SUM(Quantity) as total_qty_Sold_by_branch, branch 
FROM WalmartSalesData 
GROUP BY branch 
order by total_qty_Sold_by_branch desc;

SELECT ROUND(avg(Rating),2) 
AS avg_Rating, Product_line 
FROM WalmartSalesData GROUP BY(Product_line) ORDER BY avg(Rating) desc ;

------------------------------------SALES ANALYSIS-------------------------------------------------
SELECT * FROM  WalmartSalesData;

SELECT COUNT(Invoice_ID) AS numb_of_sales, time_of_day FROM WalmartSalesData GROUP BY time_of_day;

SELECT TOP 1 CAST(ROUND(SUM(Total), 2) AS INT) AS Total_Revenue, Customer_type
    FROM WalmartSalesData
    GROUP BY Customer_type
    ORDER BY Total_Revenue DESC

---City with largest tax
SELECT City,AVG(VAT) as avg_vat FROM WalmartSalesData GROUP BY City order by avg_vat desc;

---------------------------------------------customer analysis---------------------

SELECT COUNT(*), Payment FROM WalmartSalesData GROUP BY Payment

select count(*) as orders_placed, gender FROM WalmartSalesData group by(Gender)

SELECT ROUND(AVG(rating),1) AS avg_rating,time_of_day 
FROM WalmartSalesData 
group by(time_of_day) 
order by avg_rating



SELECT COUNT(*) AS number_of_Sales, ROUND(avg(rating),2) AS avg_rating,day_of_Week 
FROM WalmartSalesData 
group by day_of_Week 
order by avg_rating DESC



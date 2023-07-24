--> TABLEAU ANALYSIS <--
--> Sales
WITH CTE_YTD_Sales (Year, Sales) AS (
	SELECT YEAR([Order Date]) AS 'Year', SUM(Sales) AS 'YTD Sales'
	FROM Orders
	GROUP BY YEAR([Order Date]))
SELECT a.Year, ROUND(a.Sales,2) AS 'YTD Sales', ROUND(p.Sales,2) AS 'PYTD Sales', ROUND((a.Sales-p.Sales)/p.Sales * 100, 2) AS 'Growth Percent'
FROM CTE_YTD_Sales a JOIN CTE_YTD_Sales p ON
p.Year = a.Year - 1
ORDER BY a.Year DESC

--> Profit
WITH CTE_YTD_Profit (Year, Profit) AS (
	SELECT YEAR([Order Date]) AS 'Year', SUM(Profit) AS 'YTD Profit'
	FROM Orders
	GROUP BY YEAR([Order Date]))
SELECT a.Year, ROUND(a.Profit,2) AS 'YTD Profit', ROUND(p.Profit,2) AS 'PYTD Profit', ROUND((a.Profit-p.Profit)/p.Profit * 100, 2) AS 'Growth Percent'
FROM CTE_YTD_Profit a JOIN CTE_YTD_Profit p ON
p.Year = a.Year - 1
ORDER BY a.Year DESC

--> Quantity
WITH CTE_YTD_Quantity (Year, Quantity) AS (
	SELECT YEAR([Order Date]) AS 'Year', SUM(Quantity) AS 'YTD Quantity'
	FROM Orders
	GROUP BY YEAR([Order Date]))
SELECT a.Year, ROUND(a.Quantity,2) AS 'YTD Quantity', ROUND(p.Quantity,2) AS 'PYTD Quantity', ROUND((a.Quantity-p.Quantity)/p.Quantity * 100, 2) AS 'Growth Percent'
FROM CTE_YTD_Quantity a JOIN CTE_YTD_Quantity p ON
p.Year = a.Year - 1
ORDER BY a.Year DESC

--> Profit and Sales Distribution by State
SELECT [State/Province] AS State, ROUND(SUM(Sales),2) AS 'YTD Sales', ROUND(SUM(Profit),2) AS 'YTD Profit' 
FROM Orders
WHERE YEAR([Order Date]) = '2022'
GROUP BY [State/Province]
ORDER BY 2 DESC

-- Sales Average Comparision (State vs Country)
WITH CTE_AVG_Sales (State, AVG_Sales, Country_AVG_Sales) AS (
SELECT [State/Province], AVG(Sales) AS 'AVG Sales', (SELECT AVG(Sales) FROM Orders WHERE YEAR([Order Date]) = '2022') AS 'Country Sales Average'  
FROM Orders
WHERE YEAR([Order Date]) = '2022'
GROUP BY [State/Province]
)
SELECT State, AVG_Sales, Country_AVG_Sales,
	CASE
		WHEN AVG_Sales > Country_AVG_Sales THEN 'Above the Average'
		WHEN AVG_Sales < Country_AVG_Sales THEN 'Below the Average'
		ELSE NULL
	END AS Comparision
FROM CTE_AVG_Sales
ORDER BY 4, 1

-- Profit Average Comparision (State vs Country)
WITH CTE_AVG_Profit (State, AVG_Profit, Country_AVG_Profit) AS (
SELECT [State/Province], AVG(Profit) AS 'AVG Profit', (SELECT AVG(Profit) FROM Orders WHERE YEAR([Order Date]) = '2022') AS 'Country Profit Average'   
FROM Orders
WHERE YEAR([Order Date]) = '2022'
GROUP BY [State/Province]
)
SELECT State, AVG_Profit, Country_AVG_Profit,
	CASE
		WHEN AVG_Profit > Country_AVG_Profit THEN 'Above the Average'
		WHEN AVG_Profit < Country_AVG_Profit THEN 'Below the Average'
		ELSE NULL
	END AS Comparision
FROM CTE_AVG_Profit
ORDER BY 4, 1

--> Monthly YTD Sales, YTD Profit & YTD Quantity by Segment
SELECT Segment, MONTH([Order Date]) AS Month, ROUND(SUM(Sales),2) AS 'YTD Sales', ROUND(SUM(Profit),2) AS 'YTD Profit', ROUND(SUM(Quantity),2) AS 'YTD Qty.'
FROM Orders
WHERE YEAR([Order Date]) = '2022'
GROUP BY Segment, MONTH([Order Date])
ORDER BY 1,2

--> Monthly YTD Sales, YTD Profit & YTD Quantity by Region and Regional Manager
SELECT o.Region, p.[Regional Manager], ROUND(SUM(o.Sales),2) AS 'YTD Sales', ROUND(SUM(o.Profit),2) AS 'YTD Profit', ROUND(SUM(o.Quantity),2) AS 'YTD Qty.'
FROM Orders o left join People p on
o.Region = p.Region
WHERE YEAR([Order Date]) = '2022'
GROUP BY o.Region, p.[Regional Manager]


-->Testing Category Filter< --
--YTD Sales
WITH CTE_YTD_Sales (Year, Category, Sales) AS (
	SELECT YEAR([Order Date]) AS 'Year', Category, SUM(Sales) AS 'YTD Sales'
	FROM Orders
	GROUP BY YEAR([Order Date]), Category)
SELECT a.Year, a.Category,  ROUND(a.Sales,2) AS 'YTD Sales', p.Year, p.Category, ROUND(p.Sales,2) AS 'PYTD Sales', ROUND((a.Sales-p.Sales)/p.Sales * 100, 2) AS 'Growth Percent'
FROM CTE_YTD_Sales a JOIN CTE_YTD_Sales p ON
p.Year = a.Year - 1 AND a.Category = p.Category
WHERE a.Year = '2022'
ORDER BY a.Year DESC

--> Profit and Sales Distribution by State
SELECT [State/Province] AS State, Category, ROUND(SUM(Sales),2) AS 'YTD Sales', ROUND(SUM(Profit),2) AS 'YTD Profit' 
FROM Orders
WHERE YEAR([Order Date]) = '2022'
GROUP BY [State/Province], Category
ORDER BY 2 DESC

--> Monthly YTD Sales, YTD Profit & YTD Quantity by Region and Regional Manager
SELECT o.Region, p.[Regional Manager], o.Category, ROUND(SUM(o.Sales),2) AS 'YTD Sales', ROUND(SUM(o.Profit),2) AS 'YTD Profit', ROUND(SUM(o.Quantity),2) AS 'YTD Qty.'
FROM Orders o left join People p on
o.Region = p.Region
WHERE YEAR([Order Date]) = '2022'
GROUP BY o.Region, p.[Regional Manager], o.Category
ORDER BY o.Category

-->Testing Region Filter<--
--> Profit
WITH CTE_YTD_Profit (Year, Region, Profit) AS (
	SELECT YEAR([Order Date]) AS 'Year', Region, SUM(Profit) AS 'YTD Profit'
	FROM Orders
	GROUP BY YEAR([Order Date]), Region)
SELECT a.Year, a.Region,ROUND(a.Profit,2) AS 'YTD Profit', ROUND(p.Profit,2) AS 'PYTD Profit', ROUND((a.Profit-p.Profit)/p.Profit * 100, 2) AS 'Growth Percent'
FROM CTE_YTD_Profit a JOIN CTE_YTD_Profit p ON
p.Year = a.Year - 1 AND
p.Region = a.Region
WHERE a.Year = '2022'
ORDER BY a.Year DESC

--> Profit and Sales Distribution by State
SELECT Region, [State/Province] AS State, ROUND(SUM(Sales),2) AS 'YTD Sales', ROUND(SUM(Profit),2) AS 'YTD Profit' 
FROM Orders
WHERE YEAR([Order Date]) = '2022'
GROUP BY [State/Province], Region
ORDER BY 1,2

--> Monthly YTD Sales, YTD Profit & YTD Quantity by Region and Regional Manager
SELECT o.Region, p.[Regional Manager], ROUND(SUM(o.Sales),2) AS 'YTD Sales', ROUND(SUM(o.Profit),2) AS 'YTD Profit', ROUND(SUM(o.Quantity),2) AS 'YTD Qty.'
FROM Orders o left join People p on
o.Region = p.Region
WHERE YEAR([Order Date]) = '2022'
GROUP BY o.Region, p.[Regional Manager]
ORDER BY o.Region

-->Testing Ship Mode Filter<--
-->Quantity
WITH CTE_YTD_Quantity (Year, Ship_Mode, Quantity) AS (
	SELECT YEAR([Order Date]) AS 'Year', [Ship Mode], SUM(Quantity) AS 'YTD Quantity'
	FROM Orders
	GROUP BY YEAR([Order Date]), [Ship Mode])
SELECT a.Year, a.Ship_Mode, ROUND(a.Quantity,2) AS 'YTD Quantity', ROUND(p.Quantity,2) AS 'PYTD Quantity', ROUND((a.Quantity-p.Quantity)/p.Quantity * 100, 2) AS 'Growth Percent'
FROM CTE_YTD_Quantity a JOIN CTE_YTD_Quantity p ON
p.Year = a.Year - 1 AND
p.Ship_Mode = a.Ship_Mode
WHERE a.Year = '2022'
ORDER BY a.Year DESC

--> Profit and Sales Distribution by State
SELECT [Ship Mode] AS 'Ship Mode', [State/Province] AS State, ROUND(SUM(Sales),2) AS 'YTD Sales', ROUND(SUM(Profit),2) AS 'YTD Profit' 
FROM Orders
WHERE YEAR([Order Date]) = '2022'
GROUP BY [State/Province], [Ship Mode]
ORDER BY 1,2

--> Monthly YTD Sales, YTD Profit & YTD Quantity by Region and Regional Manager
SELECT o.Region, p.[Regional Manager], o.[Ship Mode], ROUND(SUM(o.Sales),2) AS 'YTD Sales', ROUND(SUM(o.Profit),2) AS 'YTD Profit', ROUND(SUM(o.Quantity),2) AS 'YTD Qty.'
FROM Orders o left join People p on
o.Region = p.Region
WHERE YEAR([Order Date]) = '2022'
GROUP BY o.Region, p.[Regional Manager], o.[Ship Mode]
ORDER BY o.Region, o.[Ship Mode]
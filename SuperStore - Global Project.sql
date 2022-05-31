--- EDA with SQL using Global Super Store
USE SuperStore
GO
--- Overview
--- Orders table
SELECT *
FROM Orders
ORDER BY [Row ID]

--- People Table
SELECT *
FROM People

--- Returns Table
SELECT *
FROM Returns

/* Postal Code is null which is not affect our Exploration */

--- Find Null Values
SELECT *
FROM Orders
WHERE [Order Date] is null 
or [Ship Date] is null 
or [Ship Mode] is null 
or [Customer ID] is null
or [Customer Name] is null
or Segment is null
or [Postal Code] is null
or City is null
or State is null 

--- We can see only postal code is null

/* Describe Orders Table:
ROWID: so dong
OrderID: ID cua Orders
Order Date: Ngay thuc hien Order
ShipDate: Ngay ship Order
Ship Mode: Dich vu Ship
Customer ID: ID khach hang
Segment: Phan khuc khach hang
Customer Name: Ten khach hang
Postal Code: Ma Postal
City: Thanh Pho
State: Bang
Country: Quoc Gia
Region: Vung
Market: Thi truong
Product ID: ID san pham
Category: Loai hang
Sub-Category: Hang muc con
Product Name: Ten San Pham
Sales: Gia san pham
Quantity: So luong da ban
Discount: Giam gia
Profit: Loi nhuan
Shipping Cost: Chi phi Ship hang
Order Priority: Muc do uu tien
*/

SELECT *
FROM Orders
ORDER BY 1
/* Q1 - Q10 OVERVIEW of the table */
/* Q1: How many Orders are there in this data ? */
SELECT COUNT([Order ID]) as Total_Orders
FROM Orders;
--- 51290 Total Orders

/* Q2: How many Orders has been made by each customers ? */
SELECT [Customer Name], count([Order ID]) as Orders
FROM Orders
GROUP BY [Customer Name]
ORDER BY Orders DESC;

/* Q3: How many Orders has been made by each Segment ? */
SELECT Segment, count([order id]) as Orders
FROM Orders
GROUP BY Segment
ORDER BY Orders DESC;

/* Q4: How many Orders has been made for each Country ? */
SELECT Country, Count([Order ID]) as Orders
FROM Orders
GROUP BY Country
ORDER BY Orders DESC;

/* Q5: How many orders has been made by each Category and Sub-Category ? */
--- By Category
SELECT Category, count([order id]) as Orders
FROM Orders
GROUP BY Category;

--- By Sub-Category
SELECT [Sub-Category], count([order id]) as Orders
FROM Orders
GROUP BY [Sub-Category]
ORDER BY Orders DESC;

/* Q6: Which products has the most Sales value, select top 10 and which Products has the most profit ? */
--- Products with most Sales value
SELECT Top 10 [Product Name],Category, [Sub-Category] , Sales
FROM Orders
ORDER BY Sales DESC

--- Products with most Profit
SELECT TOP 10 [Product Name], Category, [Sub-Category], Profit
FROM Orders
ORDER BY Profit DESC;

--- Products with most Quantity
SELECT TOP 10 [Product Name], Category, [Sub-Category], Quantity
FROM Orders
ORDER BY Quantity DESC;

/* Q7: Which Product Name has the highest sales value in each Category and Sub-Category ? */
--- Highest Product Name in Sub-Category
SELECT [Product Name], [Sub-Category], Sales
FROM Orders
WHERE Sales IN (
SELECT Max(Sales) as Sales_value
FROM Orders
GROUP BY [Sub-Category]
)
ORDER BY [Sub-Category];

--- Highest Product Name in Category
SELECT [Product Name], [Category], Sales
FROM Orders
WHERE Sales IN (
SELECT Max(Sales) as Sales_value
FROM Orders
GROUP BY Category
);

/* Q8: How many product in Order Priority ? */
SELECT [Order Priority], count([Order ID]) as Orders
FROM Orders
GROUP BY [Order Priority]
ORDER BY Orders DESC;

--- Find the connection form Order Priority and Ship Mode and Products

SELECT [Ship Mode], [Order Priority], Count([Order Priority]) as Orders_count
FROM Orders
GROUP BY [Ship Mode], [Order Priority]
ORDER BY [Ship Mode]

SELECT distinct [Ship Mode]
FROM Orders

/* Q9: Find out which Region has the most Orders ? */ 
SELECT Region, Count([Order ID]) as Orders
FROM Orders
GROUP BY Region
ORDER BY Orders DESC;

/* Q10: Calculate the sum of Sales Value of Customers, Segment, Country, Region */
--- Customers
SELECT [Customer Name],count([Order ID]) as Orders, SUM(Sales) as Revenue
FROM Orders
GROUP BY [Customer Name]
ORDER BY Revenue DESC;

--- Segment
SELECT Segment,count([Order ID]) as Orders, SUM(Sales) as Revenue
FROM Orders
GROUP BY Segment
ORDER BY Revenue DESC;

--- Country
SELECT Country,count([Order ID]) as Orders, SUM(Sales) as Revenue
FROM Orders
GROUP BY Country
ORDER BY Revenue DESC;

--- Region
SELECT Region,count([Order ID]) as Orders, SUM(Sales) as Revenue
FROM Orders
GROUP BY Region
ORDER BY Revenue DESC;

--- Market
SELECT Market,count([Order ID]) as Orders, SUM(Sales) as Revenue
FROM Orders
GROUP BY Market
ORDER BY Revenue DESC;

/* Negative Profit */
--- Country
SELECT Country, SUM(Profit) as Neg_Profit
FROM Orders
WHERE Profit < 0
GROUP BY Country
Order BY Neg_Profit;

--- Region
SELECT Region, SUM(Profit) as Neg_Profit
FROM Orders
WHERE Profit < 0
GROUP BY Region
Order BY Neg_Profit;

--- Category and Sub-Category 
SELECT Category, [Sub-Category], SUM(Profit) as Neg_Profit
FROM Orders
WHERE Profit < 0
GROUP BY Category, [Sub-Category]
Order BY Neg_Profit

--- Product Name
SELECT [Sub-Category], [Product Name], MIN(Profit) as Neg_Profit
FROM Orders
WHERE Profit < 0 and [Sub-Category] LIKE 'Tables'
GROUP BY [Sub-Category], [Product Name]
ORDER BY Neg_Profit 
	
/* Details */
/* Break down to Month, Year */
SELECT DATEPART(year, [Order Date]) as Years, DATEPART(Month, [Order Date]) as Months
FROM Orders
--- Year (2012 - 2015)
SELECT Distinct DATEPART(year, [Order Date]) as Years
FROM Orders

--- Find Which years has the most Sales, Orders and Profit
--- Years
SELECT DATEPART(year, [Order Date]) as Years, COUNT([Order ID]) as Order_count
FROM Orders
GROUP BY  DATEPART(year, [Order Date])
ORDER BY Order_count DESC;

--- Sales
SELECT DATEPART(year, [Order Date]) as Years, ROUND(SUM([Sales]), 0) as Revenue
FROM Orders
GROUP BY  DATEPART(year, [Order Date])
ORDER BY Revenue DESC;

--- Profit
SELECT DATEPART(year, [Order Date]) as Years, ROUND(SUM(Profit), 0) as Profits
FROM Orders
GROUP BY  DATEPART(year, [Order Date])
ORDER BY Profits DESC;

--- Loss Profit
SELECT DATEPART(year, [Order Date]) as Years, ROUND(SUM(Profit), 0) as Loss
FROM Orders
WHERE Profit < 0
GROUP BY  DATEPART(year, [Order Date])
ORDER BY Loss;

/* 2015 */ 
--- Q1: Which month has the highest Sales, Order and Profit ? 
--- Revenue
SELECT DATEPART(MONTH, [Order Date]) as Years, ROUND(SUM([Sales]), 0) as Revenue
FROM Orders
WHERE DATEPART(YEAR, [Order Date]) = 2015
GROUP BY  DATEPART(MONTH, [Order Date])
ORDER BY Revenue DESC;

--- Orders
SELECT DATEPART(MONTH, [Order Date]) as Years, COUNT([Order ID]) as Order_Count
FROM Orders
WHERE DATEPART(YEAR, [Order Date]) = 2015
GROUP BY  DATEPART(MONTH, [Order Date])
ORDER BY Order_Count DESC;

--- Actual Profit (Profit - Loss)
SELECT DATEPART(MONTH, [Order Date]) as Years, ROUND(SUM(Profit), 0) as Actual_Profit
FROM Orders
WHERE DATEPART(YEAR, [Order Date]) = 2015
GROUP BY  DATEPART(MONTH, [Order Date])
ORDER BY Actual_Profit DESC;

--- Profit
SELECT DATEPART(MONTH, [Order Date]) as Years, ROUND(SUM(Profit), 0) as Profit_1
FROM Orders
WHERE DATEPART(YEAR, [Order Date]) = 2015 and Profit > 0
GROUP BY  DATEPART(MONTH, [Order Date])
ORDER BY Profit_1 DESC;

--- Loss
SELECT DATEPART(MONTH, [Order Date]) as Years, ROUND(SUM(Profit), 0) as Loss
FROM Orders
WHERE DATEPART(YEAR, [Order Date]) = 2015 and Profit < 0
GROUP BY  DATEPART(MONTH, [Order Date])
ORDER BY Loss;

--- Q2: Which segment has bring the most orders and revenue in 2015 ? 
--- Orders
SELECT Segment, COUNT([Order ID]) as Order_Count
FROM Orders
WHERE DATEPART(YEAR, [Order Date]) = 2015
GROUP BY Segment
ORDER BY Order_Count DESC;

--- Revenue
SELECT Segment, SUM(Sales) as Revenue
FROM Orders
WHERE DATEPART(YEAR, [Order Date]) = 2015
GROUP BY Segment
ORDER BY Revenue DESC;

--- Q3: Which customers has the most Orders and Revenue in 2015 ? 
--- Orders
SELECT [Customer Name], COUNT([Order ID]) as Order_Count
FROM Orders
WHERE DATEPART(YEAR, [Order Date]) = 2015
GROUP BY [Customer Name]
ORDER BY Order_Count DESC;

---- Revenue
SELECT [Customer Name], SUM(Sales) as Revenue
FROM Orders
WHERE DATEPART(YEAR, [Order Date]) = 2015
GROUP BY [Customer Name]
ORDER BY Revenue DESC;

--- Quantity
SELECT [Product Name], SUM(Quantity) as Quant_SUM
FROM Orders
WHERE DATEPART(YEAR, [Order Date]) = 2015
GROUP BY [Product Name]
ORDER BY Quant_SUM DESC

--- Order ID and Quantity is different. 1 Order ID has mulitple Product and 1 Product has multiple Quanity.
SELECT [Order ID], [Customer Name],  COUNT([Product Name]) as CC, SUM([Quantity]) as Quant_SUM, [Ship Mode]
FROM Orders
GROUP By [Order ID], [Customer Name], [Ship Mode]
ORDER BY CC DESC

--- Q4: Which category and sub-category is the number 1 star in 2015 ?
--- Category
SELECT Category, SUM(Sales) as Revenue, COUNT([Order ID]) as Orders_Count
FROM Orders
WHERE DATEPART(YEAR, [Order Date]) = 2015
GROUP BY Category
ORDER BY Revenue DESC;

--- Sub-Category
SELECT [Sub-Category], SUM(Sales) as Revenue, COUNT([Order ID]) as Orders_Count
FROM Orders
WHERE DATEPART(YEAR, [Order Date]) = 2015
GROUP BY [Sub-Category]
ORDER BY Revenue DESC;

--- Q5: What shipment is common use and total cost in 2015 ? 
SELECT [Ship Mode], COUNT([Ship Mode]) as Counting, SUM([Shipping Cost]) as Total_Cost
FROM Orders
WHERE DATEPART(YEAR, [Order Date]) = 2015
GROUP BY [Ship Mode]
ORDER BY Total_Cost DESC

--- Q6: What is normal delivery time and avg delivery time in each Ship mode ? Does highest shipping cost is lowest delivery time ?
---- Calculate Delivery Time
SELECT [Order ID], [Ship Mode], [Shipping Cost],DATEDIFF(Day, [Order Date], [Ship Date]) as Delivery_Time
FROM Orders

--- AVG Delivery time for each Ship Mode
SELECT [Ship Mode], AVG(DATEDIFF(Day, [Order Date], [Ship Date])) as AVG_Delivery_Time
FROM Orders
GROUP BY [Ship Mode]

--- Max delivery time for each Ship Mode
SELECT [Ship Mode], Max(DATEDIFF(Day, [Order Date], [Ship Date])) as Max_Delivery_Time
FROM Orders
GROUP BY [Ship Mode]

--- Does Ship Cost high means delivery time faster ? 
SELECT [Ship Mode], AVG([Shipping Cost]) as AVG_Ship_Cost, AVG(DATEDIFF(Day, [Order Date], [Ship Date])) as AVG_Delivery_Time  
FROM Orders
GROUP BY [Ship Mode];

/* If we define AVG_Delivery_Time + 1 is Standard Time, Then Delivery_Time > AVG_Deli_Time + 1 is Late Orders */
--- Count how many Late Orders for each Ship Mode ?
With Deli as (
SELECT [Ship Mode], DATEDIFF(day,[Order Date], [Ship Date]) as Deli_time, [Order Date], [Ship Date]
FROM Orders
),
 Standard_Deli as (
 SELECT [Ship Mode], AVG(Deli_time) + 1 as Standard_Deli_Time
 FROM Deli
 GROUP BY [Ship Mode]
 ),
 Join_deli as (
 SELECT Deli.[Ship Mode], Deli_time, Standard_Deli_Time From Deli
 RIGHT JOIN Standard_Deli ON Deli.[Ship Mode] = Standard_Deli.[Ship Mode]
 ),
 Compare AS (
 SELECT [Ship Mode],
 CASE
 WHEN Deli_time > Standard_Deli_Time THEN 1
 ELSE 0 END AS Late_Orders
 FROM Join_deli
 )
SELECT [Ship Mode], SUM(Late_Orders) as Late_Orders
FROM Compare
GROUP BY [Ship Mode];

SELECT *
FROM Orders

SELECT [Ship Mode], [Order Priority], COUNT([Order ID]) as CCC
FROM Orders
GROUP BY [Ship Mode], [Order Priority]
ORDER BY [Ship Mode], [Order Priority]


/* Conclusion 
- Data has : 51290 Total Orders
- Date of data: 2012 - 2015
- Overall: 
 - Orders:
 + Each Segment: Consumer is the number 1 with: 26518
 + Country with most orders: USA (9994)
 + Category: Office Supplies (31289)
 + Sub-Category: Binders (6146)
 
 - Sales Value (Revenue): 
 + Technology and Office Supplies with Most Revenue
 + Accessories (USB), Art, Binders is top 3 Revenue
 + Furniture (Leather Armchair), Office Supplies ( Binding System) 
and Technology (Cisto TelePresense) is top 3 Revnue Product Name
 + Region: Western Euroupe, Central America and Oceania top 3 Rev
 
- Negative Profit
 + USA we sell alot and we have the highest negative profit, after that
is Turkey and Nigeria 
+ Sub-CategoryL Tables brings alot of negative profit

Data for 3 Years, 2015 is the most and standout year. Brings alot of profit
and Revenue.
- 2015: 
+ Revenue, Orders, Profit: November, December, September top 3
+ Segment, Revenue: Consumers is the number 1: 8935
+ Technology bring the highest revenue and Office Supplies brings alot of Orders.
+ Shipping Methods: Standard and Second Class has alot of Late Orders */
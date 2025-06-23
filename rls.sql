CREATE TABLE dbo.Sales  
(  
    OrderID INT,  
    SalesRep VARCHAR(60),  
    Product VARCHAR(10),  
    Quantity INT  
);
    
--Populate the table with 6 rows of data, showing 3 orders for each test user. 
INSERT dbo.Sales (OrderID, SalesRep, Product, Quantity) VALUES
(1, '<username1>@<your_domain>.com', 'Valve', 5),   
(2, '<username1>@<your_domain>.com', 'Wheel', 2),   
(3, '<username1>@<your_domain>.com', 'Valve', 4),  
(4, '<username2>@<your_domain>.com', 'Bracket', 2),   
(5, '<username2>@<your_domain>.com', 'Wheel', 5),   
(6, '<username2>@<your_domain>.com', 'Seat', 5);  
    
SELECT * FROM dbo.Sales;  


---------------------------------------------


--Create a separate schema to hold the row-level security objects (the predicate function and the security policy)
CREATE SCHEMA rls;
GO
   
/*Create the security predicate defined as an inline table-valued function.
A predicate evaluates to true (1) or false (0). This security predicate returns 1,
meaning a row is accessible, when a row in the SalesRep column is the same as the user
executing the query.*/   
--Create a function to evaluate who is querying the table
CREATE FUNCTION rls.fn_securitypredicate(@SalesRep AS VARCHAR(60)) 
    RETURNS TABLE  
WITH SCHEMABINDING  
AS  
    RETURN SELECT 1 AS fn_securitypredicate_result   
WHERE @SalesRep = USER_NAME();
GO   
/*Create a security policy to invoke and enforce the function each time a query is run on the Sales table.
The security policy has a filter predicate that silently filters the rows available to 
read operations (SELECT, UPDATE, and DELETE). */
CREATE SECURITY POLICY SalesFilter  
ADD FILTER PREDICATE rls.fn_securitypredicate(SalesRep)   
ON dbo.Sales  
WITH (STATE = ON);
GO

------------------------------

SELECT USER_NAME();

-------------------------

SELECT * FROM dbo.Sales;

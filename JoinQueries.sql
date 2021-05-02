use TestData
select * from Supplier;
select * from Customer;
select * from order_T;

--INNER JOIN. Returns the records ONLY which matches the values from both the tables
--List all orders with customer information
SELECT OrderNumber, TotalAmount, FirstName, LastName, City, Country
  FROM [Order_T] JOIN Customer
    ON [Order_T].CustomerId = Customer.Id

--LEFT JOIN. performs a join starting with the first (left-most) table.
--Then, any matched records from the second table (right-most) will be included.
--List all customers and the total amount they spent irrespective whether they placed any orders or not.
SELECT C.*,O.OrderNumber,O.TotalAmount 
	FROM Customer C left join Order_T O
	ON C.Id = O.CustomerId

SELECT C.FirstName, C.LastName, C.Id
 FROM Order_T O right join Customer C 
 ON C.Id = O.CustomerId
 order by O.CustomerId
 --where O.CustomerId is NULL

 
WITH tempTable as
    (SELECT C.FirstName, C.LastName, C.Id, (CASE 
			WHEN C.Id is null THEN  'Insert'
			ELSE  'update'
		END)
 FROM Order_T O right join Customer C 
 ON C.Id = O.CustomerId
 order by O.CustomerId)
        select tempTable.FirstName, tempTable.LastName, tempTable.Id,
		(CASE 
			WHEN tempTable.Id is null THEN  'Insert'
			ELSE  'update'
		END) as newTable
		from tempTable

--RIGHT JOIN. performs a join starting with the second (right-most) table
--Then, any matched records from the first table (left-most) will be included.
--List customers that have not placed orders

SELECT C.*, O.OrderNumber
 FROM Order_T O right join Customer C 
 ON C.Id = O.CustomerId
 where O.OrderNumber is NULL


--FULL JOIN. Returns all matching records from both tables whether the other table matches or not.
--Match all customers and suppliers by country
SELECT C.FirstName, C.LastName, C.Country AS CustomerCountry, 
       S.Country AS SupplierCountry, S.CompanyName
  FROM Customer C FULL JOIN Supplier S 
    ON C.Country = S.Country
 ORDER BY C.Country, S.Country




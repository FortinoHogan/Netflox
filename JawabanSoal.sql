USE Netflox
--Nomor 1

SELECT [Name] = CONCAT(FirstName, ' ', LastName),
[CustAddress] = CONCAT(Address, ',', City) FROM MsCustomer
ORDER BY DOB ASC

--Nomor 2
SELECT [Staff] = CONCAT(RIGHT(StaffID, 3), ' - ', LastName) ,
[Email] = Email,
[Gender] = Gender From MsStaff
WHERE Salary > 1600000

--Nomor 3
CREATE VIEW vw_Q3OrderList
AS
	SELECT 
	[Customer Name] = CONCAT(FirstName, ' ', LastName),
	[Order Date] = CONVERT(VARCHAR, OrderDate, 105),
	[RentalDuration] = RentalDuration
	
	FROM
	MsCustomer MC
	JOIN TrOrder TOr ON MC.CustomerID=TOr.CustomerID
	JOIN TrOrderDetail TOD ON TOr.OrderID=TOD.OrderID
	WHERE DATEPART(MONTH, OrderDate) BETWEEN 07 AND 09
	AND
	DATEPART(YEAR, OrderDate) = 2021 
GO

--Nomor 4
SELECT 
	[Title] = REPLACE(Title, SUBSTRING(Title, CHARINDEX(' ', Title)+1, LEN(Title)), GenreName),
	[Film Details] = CONCAT(CONVERT(VARCHAR, YEAR(ReleaseDate), 105),' : ', Director)
	FROM
	MsFilms MF
	JOIN MsGenre MG ON MF.GenreID=MG.GenreID
	JOIN MsRegion MR ON MF.RegionID=MR.RegionID
	WHERE MR.RegionID = 'MR001'
	AND
	MF.Title LIKE '% %'

--Nomor 5
SELECT
	[Custonamer Name] = 
	(CASE
	WHEN Gender = 'M' THEN CONCAT('Mr. ', FirstName, LastName) 
	WHEN Gender = 'F' THEN CONCAT('Ms. ', FirstName, LastName)
	END),
	[Order Date] = CONVERT(VARCHAR, OrderDate, 105),
	[Title] = Title

	FROM
	MsCustomer MC
	JOIN TrOrder TOr ON MC.CustomerID=TOr.CustomerID
	JOIN TrOrderDetail TOD ON TOD.OrderID=TOr.OrderID
	JOIN MsFilms MF ON MF.FilmID=TOD.FilmID
	WHERE PaymentMethodID = 'MP001'

--Nomor 6
SELECT
	[Gender] = 
	(CASE
	WHEN Gender = 'M' THEN 'Male Staff'
	WHEN Gender = 'F' THEN 'Female Staff'
	END),
	[Total Salary] = CONCAT('RP. ',CAST(SUM(Salary)AS INTEGER), ',-' )
	FROM
	MsStaff
	GROUP BY Gender

--Nomor 7
SELECT
	
	[Title] = CONCAT(LEFT(MsRegion.RegionName, 2), ' ', Title),
	[Synopsis] = CONCAT(REVERSE(SUBSTRING(REVERSE(Director), 1, CHARINDEX(' ', REVERSE(Director)))), ' ', Synopsis),
	[Release Date] = ReleaseDate

	FROM
	MsFilms
	JOIN MsRegion ON MsFilms.RegionID=MsRegion.RegionID
	WHERE GenreID = 'MG002'

--Nomor 8
SELECT

	[Customer Name] = LOWER(CONCAT(FirstName, ' ', LastName)),
	[Order Count] = COUNT(DISTINCT(TrOrderDetail.OrderID)),
	[Film Count] = COUNT(TrOrder.CustomerID)
	FROM
	MsCustomer
	JOIN TrOrder ON MsCustomer.CustomerID=TrOrder.CustomerID
	JOIN TrOrderDetail ON TrOrderDetail.OrderID=TrOrder.OrderID
	WHERE
	DATEPART(MONTH, OrderDate) BETWEEN 02 AND 12
	AND
	DATEPART(YEAR, OrderDate) = 2021
	GROUP BY FirstName, LastName
	ORDER BY "Film Count" ASC

--Nomor 9
	SELECT
	[Customer Name] = CONCAT(MsCustomer.FirstName, ' ', MsCustomer.LastName),
	[Customer Order Time] =	CONVERT(VARCHAR, CAST(OrderDate AS TIME),100),
	[Customer Rental Duration] = SUM(RentalDuration)
	FROM
	MsCustomer
	JOIN TrOrder ON MsCustomer.CustomerID=TrOrder.CustomerID
	JOIN TrOrderDetail ON TrOrder.OrderID=TrOrderDetail.OrderID
	JOIN MsStaff ON MsStaff.StaffID=TrOrder.StaffID
	WHERE MsStaff.LastName IN('Sitorus', 'Haryanti')
	GROUP BY MsCustomer.Firstname, MsCustomer.LastName, TrOrder.OrderDate, MsStaff.LastName
	
--Nomor 10
SELECT
	[Customer Name] = CONCAT(MsCustomer.FirstName,  ' ', MsCustomer.LastName),
	[Customer Gender] = 
	(CASE
	WHEN MsCustomer.Gender = 'M' THEN 'Male'
	WHEN MsCustomer.Gender = 'F' THEN 'Female'
	END),
	[Total Order Count] = COUNT(DISTINCT(TrOrder.OrderID)),
	[Average Rental Duration] = AVG(RentalDuration)

	FROM
	MsCustomer
	JOIN TrOrder ON MsCustomer.CustomerID=TrOrder.CustomerID
	JOIN TrOrderDetail ON TrOrderDetail.OrderID=TrOrder.OrderID
	JOIN MsFilms ON TrOrderDetail.FilmID=MsFilms.FilmID
	JOIN MsRegion ON MsFilms.RegionID=MsRegion.RegionID
	JOIN MsStaff ON TrOrder.StaffID=MsStaff.StaffID
	WHERE TrOrder.StaffID IN ('MS002') OR MsFilms.RegionID LIKE 'MR002' AND MsFilms.RegionID LIKE 'MR003' AND MsFilms.RegionID LIKE 'MR004'
	GROUP BY MsCustomer.FirstName, MsCustomer.LastName, MsCustomer.Gender
	
--Nomor 11
CREATE PROCEDURE GetTopFiveFilms
AS
	SELECT TOP 5
	[Title] = Title,
	[Synopsis] = Synopsis,
	[Rental Duration] = (RentalDuration)

	FROM
	MsFilms
	JOIN TrOrderDetail ON MsFilms.FilmID=TrOrderDetail.FilmID
	WHERE TrOrderDetail.RentalDuration = '4'
	GROUP BY MsFilms.Title, MsFilms.Synopsis, TrOrderDetail.RentalDuration
	ORDER BY Title ASC
EXEC GetTopFiveFilms

--Nomor 12
CREATE PROCEDURE GetYearTotalFilm
AS
	SELECT
	[FilmYear] = YEAR(OrderDate),
	[CountData] = COUNT(DISTINCT(OrderDate))
	FROM
	MsFilms
	JOIN TrOrderDetail ON MsFilms.FilmID=TrOrderDetail.FilmID
	JOIN TrOrder ON TrOrderDetail.OrderID=TrOrder.OrderID
	GROUP BY DATEPART(YEAR, OrderDate)
	ORDER BY FilmYear ASC
EXEC GetYearTotalFilm

--Nomor 13
CREATE PROCEDURE GetOrderByCustomer
@CID VARCHAR(5)
AS
	SELECT
	[OrderID] = TrOrder.OrderID,
	[OrderDate] = OrderDate,
	[CustomerName] = CONCAT(FirstName, ' ', LastName),
	[Title] = Title,
	[RentalDuration] = RentalDuration

	FROM
	TrOrder
	JOIN MsCustomer ON MsCustomer.CustomerID=TrOrder.CustomerID
	JOIN TrOrderDetail ON TrOrderDetail.OrderID=TrOrder.OrderID
	JOIN MsFilms ON MsFilms.FilmID=TrOrderDetail.FilmID
	WHERE MsCustomer.CustomerID = @CID

EXEC  GetOrderByCustomer @CID = 'MC001'

--Nomor 14
CREATE PROCEDURE GetFilm
--DROP PROCEDURE GetFilm
@RN VARCHAR(100),
@GN VARCHAR(100) = NULL
AS
IF @GN is  null
BEGIN
	SELECT
	[Title] = Title,
	[GenreName] = GenreName,
	[ReleaseDate] = ReleaseDate,
	[Synopsis] = Synopsis,
	[Director] = Director

	FROM
	MsFilms
	JOIN MsGenre ON MsGenre.GenreID=MsFilms.GenreID
	JOIN MsRegion ON MsRegion.RegionID=MsFilms.RegionID
	WHERE MsRegion.RegionName = @RN
	ORDER BY Title ASC
END
ELSE
BEGIN
	SELECT
	[Title] = Title,
	[GenreName] = GenreName,
	[ReleaseDate] = ReleaseDate,
	[Synopsis] = Synopsis,
	[Director] = Director

	FROM
	MsFilms
	JOIN MsGenre ON MsGenre.GenreID=MsFilms.GenreID
	JOIN MsRegion ON MsRegion.RegionID=MsFilms.RegionID
	WHERE MsRegion.RegionName = @RN AND MsGenre.GenreName = @GN
	ORDER BY Title ASC
END
EXEC GetFilm @RN = 'Asia', @GN = 'Horror'
EXEC GetFilm @RN = 'Asia'

--Nomor 15
CREATE PROCEDURE GetOrderByCode
--DROP PROCEDURE GetOrderByCode
@ODID VARCHAR(5) = NULL,
@OID VARCHAR(5) = NULL
AS
IF @OID is NULL
BEGIN
	SELECT
	[OrderID] = TrOrder.OrderID,
	[OrderDate] = OrderDate,
	[Title] = Title,
	[Release Detail] = CONCAT(DATEPART(YEAR, ReleaseDate), ' : ', Director),
	[RentalDuration] = RentalDuration

	FROM
	TrOrder
	JOIN TrOrderDetail ON TrOrderDetail.OrderID=TrOrder.OrderID
	JOIN MsFilms ON MsFilms.FilmID=TrOrderDetail.FilmID
	WHERE TrOrderDetail.OrderDetailID = @ODID
	OR TrOrderDetail.OrderID = @OID
END
IF @ODID is NULL
BEGIN
	SELECT
	[OrderID] = TrOrder.OrderID,
	[OrderDate] = OrderDate,
	[Title] = Title,
	[Release Detail] = CONCAT(DATEPART(YEAR, ReleaseDate), ' : ', Director),
	[RentalDuration] = RentalDuration

	FROM
	TrOrder
	JOIN TrOrderDetail ON TrOrderDetail.OrderID=TrOrder.OrderID
	JOIN MsFilms ON MsFilms.FilmID=TrOrderDetail.FilmID
	WHERE TrOrderDetail.OrderID = @OID
	OR TrOrderDetail.OrderDetailID = @ODID
END
EXEC GetOrderByCode @OID = 'TO002'
EXEC GetOrderByCode @ODID = 'OD004'

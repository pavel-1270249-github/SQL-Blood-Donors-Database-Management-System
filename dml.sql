use blooddonors
go

INSERT [dbo].[donors] ([donorID], [donorName], [donorAddress]) VALUES (1, 'Al-Amin', 'Dhaka')
GO
INSERT [dbo].[donors] ([donorID], [donorName], [donorAddress]) VALUES (2, 'Masud Sheikh', 'Nilfamari')
GO
INSERT [dbo].[donors] ([donorID], [donorName], [donorAddress]) VALUES (3, 'Ripon Sheikh', 'Jamalpur')
GO
INSERT [dbo].[donors] ([donorID], [donorName], [donorAddress]) VALUES (4, 'Hemayet Molla', 'Madaripur')
GO
INSERT [dbo].[donors] ([donorID], [donorName], [donorAddress]) VALUES (5, 'Mujtoba Mahmud', 'Meherpur')
GO

INSERT [dbo].[hospitals] ([hospitalID], [hospitalName]) VALUES (1, 'National Heart Foundation')
GO
INSERT [dbo].[hospitals] ([hospitalID], [hospitalName]) VALUES (2, 'Prime Hospital')
GO
INSERT [dbo].[hospitals] ([hospitalID], [hospitalName]) VALUES (3, 'Kidney Foundation')
GO
INSERT [dbo].[hospitals] ([hospitalID], [hospitalName]) VALUES (4, 'Square Hospital Bangladesh')
GO
INSERT [dbo].[hospitals] ([hospitalID], [hospitalName]) VALUES (5, 'Ever Care')
GO

INSERT [dbo].[patients] ([patiantID], [patiantName], [bloodGroup], [patiantAddress], [payment], [hospitalID]) VALUES (1, 'Mamun Hasan', 'B+', 'Mirpur, Dhaka', 1000.0000, 1)
GO
INSERT [dbo].[patients] ([patiantID], [patiantName], [bloodGroup], [patiantAddress], [payment], [hospitalID]) VALUES (2, 'Rajab Sheikh', 'A+', 'Uttara, Dhaka', 150000.0000, 2)
GO
INSERT [dbo].[patients] ([patiantID], [patiantName], [bloodGroup], [patiantAddress], [payment], [hospitalID]) VALUES (3, 'Mahidul Molla', 'O-', 'Dhanmondi, Dhaka', 200000.0000, 3)
GO
INSERT [dbo].[patients] ([patiantID], [patiantName], [bloodGroup], [patiantAddress], [payment], [hospitalID]) VALUES (4, 'Masud Rana', 'AB+', 'Savar, Dhaka', 25000.0000, 4)
GO
USE [blooddonors]
GO
INSERT [dbo].[patiantDonors] ([donationID], [donorID], [patiantID], [timeOfDonation]) VALUES (1, 1, 1, CAST('2022-08-01 12:00:00.000' AS DateTime))
GO
INSERT [dbo].[patiantDonors] ([donationID], [donorID], [patiantID], [timeOfDonation]) VALUES (2, 2, 3, CAST('2022-05-01 22:00:00.000' AS DateTime))
GO
INSERT [dbo].[patiantDonors] ([donationID], [donorID], [patiantID], [timeOfDonation]) VALUES (3, 3, 4, CAST('2022-09-02 18:00:00.000' AS DateTime))
GO
INSERT [dbo].[patiantDonors] ([donationID], [donorID], [patiantID], [timeOfDonation]) VALUES (4, 4, 2, CAST('2022-01-01 11:00:00.000' AS DateTime))
GO
--procedure
EXEC spInsertDonors  'Amirul', 'Keranigonj'
 GO
SELECT * FROM donors
 GO
EXEC spUpdateDonors 6, 'Amirul Islam', 'Keranigonj, Dhaka'
 GO
SELECT * FROM donors
GO
EXEC  spDeleteDonors 6
GO
SELECT * FROM donors
GO
EXEC spInsertHospitals 'Medicare'
GO
SELECT * FROM hospitals
GO
EXEC spUpdateHospitals 6, 'Medicare Hospital'
GO
SELECT * FROM hospitals
GO
EXEC spDeleteHospitals 6
GO
SELECT * FROM hospitals
GO
EXEC spInsertpatients 'Abdul Alim', 'A+','Mirpur-10, Dhaka',21000,5
GO
SELECT * FROM patients
GO
EXEC spUpdatepatients 5, 'Abdul Alim', 'AB+','Mirpur-1, Dhaka',21000,5
GO
SELECT * FROM patients
GO
EXEC spDeletepatients 5
GO
SELECT * FROM patients
GO
EXEC spInsertPatiantDonors 5 ,4, '2022-03-14'	
GO
SELECT * FROM patiantDonors
GO
EXEC spDeletePatiantDonors 5
GO
SELECT * FROM patiantDonors
GO
--views
SELECT * FROM vPatiantDetails
GO
SELECT * FROM vAvailableDonors
GO
--udf
SELECT * FROM fnDonationDetails(1)
GO
SELECT dbo.fnpatients('A+')
go
--trigger
EXEC spInsertDonors  'Amirul', 'Keranigonj'
 GO
EXEC spInsertPatiantDonors 5 ,4, '2022-03-1'	
GO
SELECT * FROM donors
GO
SELECT * FROM patiantDonors
GO
INSERT [dbo].[patiantDonors] ([donationID], [donorID], [patiantID], [timeOfDonation]) VALUES (6, 5, 1, '2022-03-14') --Cannot Donate in 90 Days!
go
SELECT * FROM patiantDonors
GO
/*
 * --Queries added
 *************************************************************
 ************************************************************/
/*
 * 1 Join Inner 
 * **************************************
 * */
SELECT d.donorName, d.donorAddress, p.patiantName, p.bloodGroup, p.patiantAddress, h.hospitalName, pd.timeOfDonation
FROM donors d
INNER JOIN patiantDonors pd ON d.donorID = pd.donorID 
INNER JOIN patients p ON pd.patiantID = p.patiantID 
INNER JOIN  hospitals h ON p.hospitalID = h.hospitalID
GO
/*
 * 2 Filter Blood group
 * **************************************
 * */
SELECT d.donorName, d.donorAddress, p.patiantName, p.bloodGroup, p.patiantAddress, h.hospitalName, pd.timeOfDonation
FROM donors d
INNER JOIN patiantDonors pd ON d.donorID = pd.donorID 
INNER JOIN patients p ON pd.patiantID = p.patiantID 
INNER JOIN  hospitals h ON p.hospitalID = h.hospitalID
WHERE p.bloodGroup = 'O-'
GO
/*
 * 3 Filter Hospital
 * */
SELECT d.donorName, d.donorAddress, p.patiantName, p.bloodGroup, p.patiantAddress, h.hospitalName, pd.timeOfDonation
FROM donors d
INNER JOIN patiantDonors pd ON d.donorID = pd.donorID 
INNER JOIN patients p ON pd.patiantID = p.patiantID 
INNER JOIN  hospitals h ON p.hospitalID = h.hospitalID
WHERE h. hospitalName = 'National Heart Foundation'
GO
/*
 * 4 Outer (right)
 * */
SELECT d.donorName, d.donorAddress, p.patiantName, p.bloodGroup, p.patiantAddress, h.hospitalName, pd.timeOfDonation
FROM   patients AS p 
INNER JOIN patiantDonors AS pd ON p.patiantID = pd.patiantID 
INNER JOIN hospitals AS h ON p.hospitalID = h.hospitalID 
RIGHT OUTER JOIN donors AS d ON pd.donorID = d.donorID
GO
/*
 * 5 Rewrite 4 with CTE
 * */
WITH cteall AS
(

SELECT  pd.donorID, p.patiantName, p.bloodGroup, p.patiantAddress, h.hospitalName, pd.timeOfDonation
FROM   patients AS p 
INNER JOIN patiantDonors AS pd ON p.patiantID = pd.patiantID 
INNER JOIN hospitals AS h ON p.hospitalID = h.hospitalID 
)
SELECT d.donorName, c.patiantName, c.bloodGroup, c.patiantAddress, c.hospitalName, c.timeOfDonation
FROM cteall c
RIGHT OUTER JOIN donors d ON c.donorID=d.donorID
GO
/*
 * 6 Outer (right) Not Matched
 * */
SELECT  d.donorName, p.patiantName, p.bloodGroup, p.patiantAddress, h.hospitalName, pd.timeOfDonation
FROM   patients AS p 
INNER JOIN patiantDonors AS pd ON p.patiantID = pd.patiantID 
INNER JOIN hospitals AS h ON p.hospitalID = h.hospitalID 
RIGHT OUTER JOIN donors AS d ON pd.donorID = d.donorID
WHERE pd.donorID IS NULL
GO

/*
 * 7 SME 6 with Sub-Query
 * */
SELECT  d.donorName, p.patiantName, p.bloodGroup, p.patiantAddress, h.hospitalName, pd.timeOfDonation
FROM   patients AS p 
INNER JOIN patiantDonors AS pd ON p.patiantID = pd.patiantID 
INNER JOIN hospitals AS h ON p.hospitalID = h.hospitalID 
RIGHT OUTER JOIN donors AS d ON pd.donorID = d.donorID
WHERE d.donorID NOT IN (select donorID FROM patiantDonors)
GO
/*
 * 8 Using Aggregate 
 * */
SELECT d.donorName, count(pd.donorID)
FROM donors d
INNER JOIN patiantDonors pd ON d.donorID = pd.donorID 
INNER JOIN patients p ON pd.patiantID = p.patiantID 
INNER JOIN  hospitals h ON p.hospitalID = h.hospitalID
GROUP BY d.donorName
GO
SELECT d.donorName, p.bloodGroup, count(pd.donorID)
FROM donors d
INNER JOIN patiantDonors pd ON d.donorID = pd.donorID 
INNER JOIN patients p ON pd.patiantID = p.patiantID 
INNER JOIN  hospitals h ON p.hospitalID = h.hospitalID
GROUP BY d.donorName,  p.bloodGroup
GO
/*
 * 9 Using Aggregate With Having Clause
 * */
SELECT d.donorName, count(pd.donorID)
FROM donors d
INNER JOIN patiantDonors pd ON d.donorID = pd.donorID 
INNER JOIN patients p ON pd.patiantID = p.patiantID 
INNER JOIN  hospitals h ON p.hospitalID = h.hospitalID
GROUP BY d.donorName,  p.bloodGroup
HAVING p.bloodGroup = 'AB+'
GO
/*
 * 10 Windowing Function
 * */
SELECT d.donorName, 
 count(pd.donorID) OVER(ORDER BY d.donorID) 'Count',
 ROW_NUMBER() OVER(ORDER BY d.donorID) 'Number',
 RANK() OVER(ORDER BY d.donorID) 'Rank',
 DENSE_RANK() OVER(ORDER BY d.donorID) 'Denserank',
 NTILE(3) OVER(ORDER BY d.donorID) 'Ntile(3)'
FROM donors d
INNER JOIN patiantDonors pd ON d.donorID = pd.donorID 
INNER JOIN patients p ON pd.patiantID = p.patiantID 
INNER JOIN  hospitals h ON p.hospitalID = h.hospitalID
GO
/*
 * 11 CASE .. WHEN...END
 * */
SELECT  d.donorName, 
CASE 
	WHEN p.patiantName IS NULL THEN 'Nil'
	ELSE p.patiantName
END 'patiantName'
FROM   patients AS p 
INNER JOIN patiantDonors AS pd ON p.patiantID = pd.patiantID 
INNER JOIN hospitals AS h ON p.hospitalID = h.hospitalID 
RIGHT OUTER JOIN donors AS d ON pd.donorID = d.donorID
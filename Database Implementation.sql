CREATE DATABASE TEAM10_SMD;

USE TEAM10_SMD;

----------------------------Table 1------------------------------
-----------------------Create Table Address----------------------

CREATE TABLE dbo.Address
(
	[AddressID] [varchar](15) NOT NULL PRIMARY KEY,
	[Street] [varchar](100) NOT NULL,
	[City] [varchar](100) NOT NULL,
	[State] [varchar](50) NOT NULL,
	[ZipCode] [int] NOT NULL
)

----------------------------Table 2------------------------------
-----------------------Create Table Person-----------------------

CREATE TABLE dbo.Person
 (
	[PersonId] [varchar](15) NOT NULL PRIMARY KEY,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](20) NOT NULL,
	[Gender] [varchar](2) NOT NULL,
	[IdentificationNo] [nvarchar](10) NOT NULL,
	[SSN] [nvarchar](20) NOT NULL,
	[Phone] [bigint] NOT NULL,
	[Email] [nvarchar](50) NOT NULL
 );

----------------------------Table 3------------------------------------
-----------------------Create Table PersonAddress----------------------

CREATE TABLE [dbo].[PersonAddress]
(
	[PersonId] [varchar](15) NOT NULL,
	[AddressId] [varchar](15) NOT NULL,
	PRIMARY KEY([PersonID],[AddressID]),
	FOREIGN KEY([PersonID]) REFERENCES [PERSON]([PersonID]),
	FOREIGN KEY([AddressID]) REFERENCES [ADDRESS]([AddressID])
);

----------------------------Table 4------------------------------------
-----------------------Create Table JobTitle---------------------------

 CREATE TABLE dbo.JobTitle
 (
	[JobTitleId] [varchar](15) NOT NULL PRIMARY KEY,
	[TitleName] [varchar](50) NOT NULL,
	[Salary] [money] NOT NULL,
	[PaymentCycle] [varchar](10) NOT NULL
 );

----------------------------Table 5------------------------------------
-----------------------Create Table Discounts--------------------------

 CREATE TABLE dbo.Discounts
 (
	 [DiscountType] [varchar](15) NOT NULL PRIMARY KEY,
	 [DiscountPrice] [money] NOT NULL,
	 [Season] [varchar](10) NOT NULL
 );

----------------------------Table 6------------------------------------
-----------------------Create Table PlanType---------------------------

 CREATE TABLE dbo.PlanType
 (
	[PlanTypeId] [varchar](15) NOT NULL PRIMARY KEY,
	[PlanName] [varchar](30) NOT NULL,
	[AmountByMonth] [money] NOT NULL
 );

----------------------------Table 7------------------------------------
-----------------------Create Table EquipmentCategory------------------

 CREATE TABLE dbo.EquipmentCategory
 (
	[EquipmentCategoryId] [varchar](15) NOT NULL PRIMARY KEY,
	[CategoryName] [varchar](50) NOT NULL
  );

----------------------------Table 8----------------------------------
-----------------------Create Table Branch---------------------------

 CREATE TABLE dbo.Branch
 (
	[BranchId] [varchar](15) NOT NULL PRIMARY KEY,
	[Phone] [bigint] NOT NULL,
	[AddressID] [varchar](15) NOT NULL
	FOREIGN KEY([AddressID]) REFERENCES [ADDRESS]([AddressID])
 );
 
----------------------------Table 9-------------------------------------
-----------------------Create Table Equipment---------------------------
 CREATE TABLE dbo.Equipment
 (
	[EquipmentId] [varchar](15) NOT NULL PRIMARY KEY,
	[BranchId] [varchar](15) NOT NULL,
	[EquipmentCategoryId] [varchar](15) NOT NULL,
	[PurchaseDate] [datetime] NOT NULL,
	FOREIGN KEY([BranchId]) REFERENCES [BRANCH]([BranchId]),
	FOREIGN KEY([EquipmentCategoryId]) REFERENCES [EquipmentCategory]([EquipmentCategoryId])
 );

----------------------------Table 10---------------------------------------------
-----------------------Create Table MaintainanceRecord---------------------------
 CREATE TABLE dbo.MaintainanceRecord
 (
	[MaintainanceRecordId] [varchar](15) NOT NULL PRIMARY KEY,
	[EquipmentId] [varchar](15) NOT NULL,
	[MaintainanceDate] [datetime] NOT NULL,
	[MaintainanceDetail] [varchar](50) NOT NULL,
	[MainatainanceCost] [money] NOT NULL,
	FOREIGN KEY([EquipmentId]) REFERENCES [Equipment]([EquipmentId])
 );

----Function to create constraint on Maintainance Table
CREATE FUNCTION checkMaintenanceDate(@EquipmentID varchar(15))
Returns DateTime
AS
BEGIN
	DECLARE @PurchaseDate datetime
	SELECT @PurchaseDate=PurchaseDate from Equipment
	where EquipmentID=@EquipmentID
Return @PurchaseDate
END

----Alter table to add constraint "checkMaintenanceDate"
ALTER TABLE [dbo].[MaintainanceRecord] ADD CONSTRAINT Constraint_GreaterThanPurchaseDate CHECK(dbo.checkMaintenanceDate(EquipmentID)<MaintainanceDate)


 ----------------------------Table 11-----------------------------------
-----------------------Create Table ClassRoom---------------------------

 CREATE TABLE dbo.ClassRoom
 (
	[ClassRoomId] [varchar](15) NOT NULL PRIMARY KEY,
	[BranchId] [varchar](15) NOT NULL,
	[RoomNo] [int] NOT NULL,
	FOREIGN KEY([BranchId]) REFERENCES [BRANCH]([BranchId])
 );
 
 ----------------------------Table 12------------------------------------
 -----------------------Create Table Employees---------------------------
 CREATE TABLE dbo.Employees
 (
	[EmployeeId] [varchar](15) NOT NULL PRIMARY KEY,
	[PersonId] [varchar](15) NOT NULL,
	[BranchId] [varchar](15) NOT NULL,
	[JobTitleId] [varchar](15) NOT NULL,
	[HireDate] [date] NOT NULL,
	FOREIGN KEY([BranchId]) REFERENCES [BRANCH]([BranchId]),
	FOREIGN KEY([PersonId]) REFERENCES [PERSON]([PersonId]),
	FOREIGN KEY([JobTitleId]) REFERENCES [JobTitle]([JobTitleId])
 );

 ----------------------------Table 13----------------------------------------
 -----------------------Create Table PaymentRecord---------------------------

  CREATE TABLE dbo.PaymentRecord
 (
	[PaymentRecordId] [varchar](15) NOT NULL PRIMARY KEY,
	[EmployeeId] [varchar](15) NOT NULL,
	[PaymentDate] [datetime] NOT NULL,
	[DirectDepositAccount] [varchar](20) NOT NULL,
	FOREIGN KEY([EmployeeId]) REFERENCES [EMPLOYEES]([EmployeeId])
 );

 ----Function to create constraint on PaymentRecord Table
CREATE FUNCTION checkPayDate(@EmployeeID varchar(15))
Returns DateTime
AS
BEGIN
	DECLARE @HireDate datetime
	SELECT @HireDate=HireDate from Employees
	where EmployeeID=@EmployeeID
Return @HireDate
END

----Alter Table to add constraint "checkPayDate"
ALTER TABLE PaymentRecord ADD CONSTRAINT Constraint_GreaterThanHireDate CHECK(dbo.checkPayDate(EmployeeID)<PaymentDate)

 ----------------------------Table 14----------------------------------
 -----------------------Create Table Classes---------------------------


 CREATE TABLE dbo.Classes
 (
	[ClassId] [varchar](15) NOT NULL PRIMARY KEY,
	[InstructorId] [varchar](15) NOT NULL,
	[ClassRoomId] [varchar](15) NOT NULL,
	[ProgramName] [varchar](30) NOT NULL,
	[DayInWeek] [varchar](10) NOT NULL,
	[Time] [time](7) NOT NULL,
	[Capacity] [int] NOT NULL,
	[DurationInHours] [int] NOT NULL,
	FOREIGN KEY([ClassRoomId]) REFERENCES [ClassRoom] ([ClassRoomId]),
	FOREIGN KEY([InstructorId]) REFERENCES [Employees] ([EmployeeId])
 );

 ----------------------------Table 15-----------------------------------
 -----------------------Create Table Customer---------------------------

 CREATE TABLE dbo.Customer
 (
	[CustomerId] [varchar](15) NOT NULL PRIMARY KEY,
	[PersonId] [varchar](15) NOT NULL,
	[DiscountType] [varchar](15) NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[PlanTypeId] [varchar](15) NOT NULL,
	[BranchID] [varchar](15) NOT NULL,
	FOREIGN KEY([DiscountType]) REFERENCES [Discounts] ([DiscountType]),
	FOREIGN KEY([PersonId]) REFERENCES [Person] ([PersonId]),
	FOREIGN KEY([PlanTypeId]) REFERENCES [PlanType] ([PlanTypeId]),
	FOREIGN KEY([BranchID]) REFERENCES [BRANCH]([BranchID])
 );

 ----------------------------Table 16-------------------------------------
 -----------------------Create Table Enrollment---------------------------

  CREATE TABLE dbo.Enrollment
 (
	 [EnrollmentId] [varchar](15) NOT NULL PRIMARY KEY,
	 [ClassId] [varchar](15) NOT NULL,
	 [CustomerId] [varchar](15) NOT NULL,
	 FOREIGN KEY([ClassId]) REFERENCES [Classes] ([ClassId]),
	 FOREIGN KEY([CustomerId]) REFERENCES .[Customer] ([CustomerId])
 );

 ----------------------------Table 17----------------------------------------
 -----------------------Create Table BillingRecord---------------------------

 CREATE TABLE dbo.BillingRecord
 (
	[BillingRecordId] [varchar](15) NOT NULL PRIMARY KEY,
	[CustomerId] [varchar](15) NOT NULL,
	[BillingDate] [datetime] NOT NULL,
	FOREIGN KEY([CustomerId]) REFERENCES [Customer] ([CustomerId])
 );

----1. Function to create constraint on BillingRecord Table

CREATE FUNCTION checkBillingDate(@CustomerID varchar(15))
Returns DateTime
AS
BEGIN
	DECLARE @StartDate DateTime
	SELECT @StartDate=StartDate from [Customer]
	where CustomerID=@CustomerID
Return @StartDate
END

-----2. Function to create constraint on BillingRecord Table
CREATE FUNCTION checkBillingDate2(@CustomerID varchar(15))
Returns DateTime
AS
BEGIN
	DECLARE @EndDate DateTime
	SELECT @EndDate=EndDate from [Customer]
	where CustomerID=@CustomerID
Return @EndDate
END

--Alter Table to add two contraints "checkBillingDate" and "checkBillingDate2"
ALTER TABLE BillingRecord ADD CONSTRAINT Constraint_BetweenStartAndEndDate CHECK((dbo.checkBillingDate(CustomerID)<BillingDate) and (dbo.checkBillingDate2(CustomerID)>BillingDate))


/********************************************INSERTION SCRIPT********************************************/

----------------------------Table 1------------------------------
-----------------------Insert into Address----------------------

USE TEAM10_SMD
GO

INSERT INTO [dbo].[Address]
           ([AddressID]
           ,[Street]
           ,[City]
           ,[State]
           ,[ZipCode])
     VALUES
('Ad10001','#500-75 O Connor Street','Boston','Massachusetts',95112),
('Ad10002','#9900 2700 Production Way','Boston','Massachusetts',95112),
('Ad10003','00, rue Saint-Lazare','Dunkerque','Arizona',59140),
('Ad10004','02, place de Fontenoy','Verrieres Le Buisson','Utah',91370),
('Ad10005','035, boulevard du Montparnasse','Verrieres Le Buisson','Utah',91370),
('Ad10006','081, boulevard du Montparnasse','Austin','Texas',93400),
('Ad10007','081, boulevard du Montparnasse','Seattle','Washington',98104),
('Ad10008','084, boulevard du Montparnasse','Les Ulis','Utah',91940),
('Ad10009','1 Corporate Center Drive','Miami','Florida',33127),
('Ad10010','1 Mt. Dell Drive','Portland','Oregon',97205),
('Ad10011','1 Smiling Tree Court','Los Angeles','California',90012),
('Ad10012','1, allée des Princes','Rochester','New York',92400),
('Ad10013','1, avenue des Champs-Elysées','Trenton','New Jersey',75017),
('Ad10014','1, boulevard Beau Marchais','Sèvres','New York',92310),
('Ad10015','1, cours Mirabeau','Roncq','Arizona',59223),
('Ad10016','1, place Beaubernard','Trenton','New Jersey',75003),
('Ad10017','1, place Beaubernard','Trenton','New Jersey',75009),
('Ad10018','1, place Beaubernard','Austin','Texas',93400),
('Ad10019','1, place Beaubernard','Tremblay-en-France','Texas',93290),
('Ad10020','1, place de Brazaville','Colomiers','Garonne (Haute)',31770),
('Ad10021','1, place de Brazaville','Dunkerque','Arizona',59140),
('Ad10022','1, place de Brazaville','Lille','Arizona',59000),
('Ad10023','1, place de la République','Trenton','New Jersey',75017),
('Ad10024','1, rue de Courtaboeuf','Lieusaint','Texas',77127),
('Ad10025','1, rue de Courtaboeuf','Lille','Arizona',59000),
('Ad10026','1, rue de Courtaboeuf','Versailles','Massachusetts',78000),
('Ad10027','1, rue de Fontfroide','Trenton','New Jersey',75003),
('Ad10028','1, rue de l´Avenir','Chatou','Massachusetts',78400),
('Ad10029','1, rue de l´Avenir','Morangis','Utah',91420),
('Ad10030','1, rue de la Cavalerie','Trenton La Defense','New York',92081),
('Ad10031','1, rue de la Cavalerie','Roncq','Arizona',59223),
('Ad10032','1, rue de la Cavalerie','Sèvres','New York',92310),
('Ad10033','1, rue de la Centenaire','Cergy','Val dOise',95000),
('Ad10034','1, rue de la Centenaire','Colombes','New York',92700),
('Ad10035','1, rue de la Centenaire','Les Ulis','Utah',91940),
('Ad10036','1, rue de la Centenaire','Lille','Arizona',59000),
('Ad10037','1, rue de la Centenaire','Roubaix','Arizona',59100),
('Ad10038','1, rue de la Centenaire','Austin','Texas',93400),
('Ad10039','1, rue de la Centenaire','Versailles','Massachusetts',78000),
('Ad10040','1, rue de Maubeuge','SaltLakeCity','Utah',57000),
('Ad10041','1, rue de Maubeuge','Morangis','Utah',91420),
('Ad10042','1, rue de Maubeuge','Trenton','New Jersey',75007),
('Ad10043','1, rue de Maubeuge','Trenton','New Jersey',75009),
('Ad10044','1, rue de Maubeuge','Saint Germain en Laye','Massachusetts',78100),
('Ad10045','1, rue de Maubeuge','Villeneuve-dAscq','Arizona',59491),
('Ad10046','1, rue de Varenne','Boulogne-Billancourt','New York',92100),
('Ad10047','1, rue de Varenne','Dunkerque','Arizona',59140),
('Ad10048','1, rue Georges-Clémenceau','Trenton','New Jersey',75003),
('Ad10049','1, rue Lamarck','Versailles','Massachusetts',78000),
('Ad10050','1, rue Pierre-Demoulin','Croix','Arizona',59170),
('Ad10051','1, rue Pierre-Demoulin','Les Ulis','Utah',91940),
('Ad10052','1, rue Pierre-Demoulin','Orleans','Utah',45000),
('Ad10053','1, rue Pierre-Demoulin','Trenton','New Jersey',75007),
('Ad10054','1, rue Pierre-Demoulin','Trenton','New Jersey',75012),
('Ad10055','1, rue Ste-Honor','Saint Ouen','Loir et Cher',41100),
('Ad10056','10 Napa Ct.','Lebanon','Oregon',97355),
('Ad10057','10, avenue de Norvege','Trenton','New Jersey',75005),
('Ad10058','10, avenue du Port','Roissy en Brie','Texas',77680),
('Ad10059','10, avenue du Président-Kennedy','Trenton','New Jersey',75019),
('Ad10060','10, impasse Ste-Madeleine','Tremblay-en-France','Texas',93290),
('Ad10061','10, place Beaubernard','Verrieres Le Buisson','Utah',91370),
('Ad10062','10, place de Fontenoy','Roubaix','Arizona',59100),
('Ad10063','10, route de Utah','Pantin','Texas',93500),
('Ad10064','10, rue de l´Avenir','Suresnes','New York',92150),
('Ad10065','10, rue de la Centenaire','Austin','Texas',93400),
('Ad10066','10, rue de la Comédie','Lille','Arizona',59000),
('Ad10067','10, rue de Maubeuge','Orleans','Utah',45000),
('Ad10068','10, rue des Vendangeurs','Saint Germain en Laye','Massachusetts',78100),
('Ad10069','10, rue Lafayette','Trenton','New Jersey',75007),
('Ad10070','10, rue Lauriston','Bobigny','Texas',93000),
('Ad10071','10, rue Philibert-Delorme','Trenton','New Jersey',75007),
('Ad10072','10, rue Pierre-Demoulin','Orleans','Utah',45000),
('Ad10073','10, rue Royale','Rochester','New York',92400),
('Ad10074','10, rue Royale','Sèvres','New York',92310),
('Ad10075','100 Fifth Drive','Millington','Arizona',38054),
('Ad10076','100, boulevard d´Albi','Trenton','New Jersey',75006),
('Ad10077','100, rue de la Centenaire','Trenton La Defense','New York',92081),
('Ad10078','100, rue des Rosiers','Everett','Washington',98201),
('Ad10079','100, rue des Rosiers','Pantin','Texas',93500),
('Ad10080','100, rue Descartes','Boulogne-Billancourt','New York',92100),
('Ad10081','100, rue Jean Mermoz','Trenton','New Jersey',75002),
('Ad10082','100, rue Maillard','Roubaix','Arizona',59100),
('Ad10083','1000 Bidweld Street','Boston','Massachusetts',95112),
('Ad10084','1001, rue des Bouchers','Trenton','New Jersey',75012),
('Ad10085','1001bis, boulevard Saint Germain','Roubaix','Arizona',59100),
('Ad10086','1002 N. Spoonwood Court','Berkeley','California',94704),
('Ad10087','1002 N. Spoonwood Court','Hervey Bay','Florida',4655),
('Ad10088','1003 Matterhorn Ct','Lebanon','Oregon',97355),
('Ad10089','1004, rue des Bouchers','Trenton','New Jersey',75019),
('Ad10090','1005 Fremont Street','Colma','California',94014),
('Ad10091','1005 Matterhorn Ct.','Los Angeles','California',95112),
('Ad10092','1005 Matterhorn Ct.','Los Angeles','California',94941),
('Ad10093','1005 Tanager Court','Corvallis','Oregon',97330),
('Ad10094','1005 Tanager Court','Miami','Florida',2061),
('Ad10095','1005 Valley Oak Plaza','Boston','Massachusetts',95112),
('Ad10096','1005 Valley Oak Plaza','Los Angeles','California',95112),
('Ad10097','1005, rue des Bouchers','Colombes','New York',92700),
('Ad10098','1005, rue des Bouchers','Austin','Texas',93400),
('Ad10099','1006 Deercreek Ln','Los Angeles','California',90706),
('Ad10100','1006 Deercreek Ln','Torrance','California',90505),
('Ad10101','1007 Cardinet Dr.','Los Angeles','California',92020),
('Ad10102','1008 Lydia Lane','Los Angeles','California',91502),
('Ad10103','1009, rue des Bouchers','Colomiers','Garonne (Haute)',31770),
('Ad10104','101 Adobe Dr','Miami','Florida',2450),
('Ad10105','101 Adobe Dr','Puyallup','Washington',98371),
('Ad10106','101 Candy Rd.','Redmond','Washington',98052),
('Ad10107','101, avenue de la Gare','Peterborough','California',95112),
('Ad10108','101, avenue de la Gare','Roissy en Brie','Texas',77680),
('Ad10109','101, avenue des Champs-Elysées','Colombes','New York',92700),
('Ad10110','101, avenue Reille','Versailles','Massachusetts',78000),
('Ad10111','101, rue de Cambrai','Roubaix','Arizona',59100),
('Ad10112','101, rue de Terre Neuve','Trenton','New Jersey',75010),
('Ad10113','101, rue Léo Delibes','Trenton','New Jersey',75009),
('Ad10114','1010 Maple','Phoenix','Arizona',21201),
('Ad10115','1010, avenue de l?Union Centrale','Saint Germain en Laye','Massachusetts',78100),
('Ad10116','1010, impasse Notre-Dame','Orleans','Utah',45000),
('Ad10117','1011 Green St.','Bellingham','Washington',98225),
('Ad10118','1011 Yolanda Circle','Berkeley','California',94704),
('Ad10119','1011 Yolanda Circle','Boston','Massachusetts',95112),
('Ad10120','1011, avenue Foch','Pantin','Texas',93500),
('Ad10121','1013 Buchanan Rd','Miami','Florida',2444),
('Ad10122','1013 Buchanan Rd','Yakima','Washington',98901),
('Ad10123','1013 Holiday Hills Dr.','Bremerton','Washington',98312),
('Ad10124','1013 Holiday Hills Dr.','Gateshead','California',95112),
('Ad10125','1015 Lynwood Drive','Boston','Massachusetts',95112),
('Ad10126','1016 Park Avenue','Burbank','California',91502),
('Ad10127','1019 Book Road','Miami','Florida',2138),
('Ad10128','1019 Buchanan Road','Woodland Hills','California',91364),
('Ad10129','1019 Candy Rd.','Miami','Florida',2450),
('Ad10130','1019 Carletto Drive','Berkeley','California',94704),
('Ad10131','1019 Chance Drive','Sedro Woolley','Washington',98284),
('Ad10132','1019 Kenwal Rd.','Lake Oswego','Oregon',97034),
('Ad10133','1019 Mt. Davidson Court','Burien','Washington',98168),
('Ad10134','1019 Mt. Davidson Court','London','California',95112),
('Ad10135','1019 Pennsylvania Blvd','Marysville','Washington',98270),
('Ad10136','102 Silverado Drive','W. Linn','Oregon',97068),
('Ad10137','102 Vista Place','Milton Keynes','California',95112),
('Ad10138','102 Vista Place','Santa Monica','California',90401),
('Ad10139','102, rue de Berri','Les Ulis','Utah',91940),
('Ad10140','1020 Book Road','Bremerton','Washington',98312),
('Ad10141','1020 Carletto Drive','Miami','Florida',2036),
('Ad10142','1020 Carletto Drive','Santa Cruz','California',95062),
('Ad10143','1020, quai de Grenelle','Croix','Arizona',59170),
('Ad10144','1020, quai de Grenelle','Versailles','Massachusetts',78000),
('Ad10145','10203 Acorn Avenue','Boston','Massachusetts',95112),
('Ad10146','1023 Hawkins Street','Lebanon','Oregon',97355),
('Ad10147','1023 Hawkins Street','Townsville','Florida',4810),
('Ad10148','1023 Riveria Way','Burbank','California',91502),
('Ad10149','1023 Riviera Way','Oxford','California',95112),
('Ad10150','1024 Walnut Blvd.','Colma','California',94014)
GO

----------------------------Table 2------------------------------
-----------------------Insert into Person------------------------
INSERT INTO [dbo].[Person]
           ([PersonId]
           ,[FirstName]
           ,[LastName]
           ,[Gender]
           ,[IdentificationNo]
           ,[SSN]
           ,[Phone]
           ,[Email]
           )
     VALUES
('P10001','Ken','Sánchez','M','I10001',295847284,6975550142,'ken0@gmail.com'),
('P10002','Terri','Duffy','F','I10002',245797967,8195550175,'tei0@gmail.com'),
('P10003','Roberto','Tamburello','M','I10003',509647174,2125550187,'roo0@gmail.com'),
('P10004','Rob','Walters','M','I10004',112457891,6125550100,'rob0@gmail.com'),
('P10005','Gail','Erickson','F','I10005',695256908,8495550139,'gal0@gmail.com'),
('P10006','Jossef','Goldberg','M','I10006',998320692,1225550189,'jof0@gmail.com'),
('P10007','Dylan','Miller','M','I10007',134969118,1815550156,'dyn0@gmail.com'),
('P10008','Diane','Margheim','F','I10008',811994146,8155550138,'die1@gmail.com'),
('P10009','Gigi','Matthew','F','I10009',658797903,1855550186,'ggi0@gmail.com'),
('P10010','Michael','Raheem','M','I10010',879342154,3305552568,'mel6@gmail.com'),
('P10011','Ovidiu','Cracium','M','I10011',974026903,7195550181,'oiu0@gmail.com'),
('P10012','Thierry','DHers','M','I10012',480168528,1685550183,'try0@gmail.com'),
('P10013','Janice','Galvin','F','I10013',486228782,4735550117,'janice0@gmail.com'),
('P10014','Michael','Sullivan','M','I10014',42487730,4655550156,'michael8@gmail.com'),
('P10015','Sharon','Salavaria','F','I10015',56920285,9705550138,'sharon0@gmail.com'),
('P10016','David','Bradley','M','I10016',24756624,9135550172,'david0@gmail.com'),
('P10017','Kevin','Brown','M','I10017',253022876,1505550189,'kevin0@gmail.com'),
('P10018','John','Wood','M','I10018',222969461,4865550150,'john5@gmail.com'),
('P10019','Mary','Dempsey','F','I10019',52541318,1245550114,'mary2@gmail.com'),
('P10020','Wanida','Benshoof','F','I10020',323403273,7085550141,'wanida0@gmail.com'),
('P10021','Terry','Eminhizer','M','I10021',243322160,1385550118,'terry0@gmail.com'),
('P10022','Sariya','Harnpadoungsataya','M','I10022',95958330,3995550176,'sariya0@gmail.com'),
('P10023','Mary','Gibson','F','I10023',767955365,5315550183,'mary0@gmail.com'),
('P10024','Jill','Williams','F','I10024',72636981,5105550121,'jill0@gmail.com'),
('P10025','James','Hamilton','M','I10025',519899904,8705550122,'james1@gmail.com'),
('P10026','Peter','Krebs','M','I10026',277173473,9135550196,'peter0@gmail.com'),
('P10027','Jo','Brown','F','I10027',446466105,6325550129,'jo0@gmail.com'),
('P10028','Guy','Gilbert','M','I10028',14417807,3205550195,'guy1@gmail.com'),
('P10029','Mark','McArthur','M','I10029',948320468,4175550154,'mark1@gmail.com'),
('P10030','Britta','Simon','F','I10030',410742000,9555550169,'britta0@gmail.com'),
('P10031','Margie','Shoop','F','I10031',750246141,8185550128,'margie0@gmail.com'),
('P10032','Rebecca','Laszlo','F','I10032',330211482,3145550113,'rebecca0@gmail.com'),
('P10033','Annik','Stahl','M','I10033',801758002,4995550125,'annik0@gmail.com'),
('P10034','Suchitra','Mohan','F','I10034',754372876,7535550129,'suchitra0@gmail.com'),
('P10035','Brandon','Heidepriem','M','I10035',999440576,4295550137,'brandon0@gmail.com'),
('P10036','Jose','Lugo','M','I10036',788456780,5875550115,'jose0@gmail.com'),
('P10037','Chris','Okelberry','M','I10037',442121106,3155550144,'chris2@gmail.com'),
('P10038','Kim','Abercrombie','F','I10038',6298838,2085550114,'kim1@gmail.com'),
('P10039','Ed','Dudenhoefer','M','I10039',461786517,9195550140,'ed0@gmail.com'),
('P10040','JoLynn','Dobney','F','I10040',309738752,9035550145,'jolynn0@gmail.com'),
('P10041','Bryan','Baker','M','I10041',458159238,7125550113,'bryan0@gmail.com'),
('P10042','James','Kramer','M','I10042',339712426,1195550117,'james0@gmail.com'),
('P10043','Nancy','Anderson','F','I10043',693325305,9705550118,'nancy0@gmail.com'),
('P10044','Simon','Rapier','M','I10044',276751903,9635550134,'simon0@gmail.com'),
('P10045','Thomas','Michaels','M','I10045',500412746,2785550118,'thomas0@gmail.com'),
('P10046','Eugene','Kogan','M','I10046',66073987,1735550179,'eugene1@gmail.com'),
('P10047','Andrew','Hill','M','I10047',33237992,9085550159,'andrew0@gmail.com'),
('P10048','Ruth','Ellerbrock','F','I10048',690627818,1455550130,'ruth0@gmail.com'),
('P10049','Barry','Johnson','M','I10049',912265825,2065550180,'barry0@gmail.com'),
('P10050','Sidney','Higa','M','I10050',844973625,4245550189,'sidney0@gmail.com'),
('P10051','Jeffrey','Ford','M','I10051',132674823,9845550185,'jeffrey0@gmail.com'),
('P10052','Doris','Hartwig','F','I10052',565090917,3285550150,'doris0@gmail.com'),
('P10053','Diane','Glimp','F','I10053',9659517,2025550151,'diane0@gmail.com'),
('P10054','Bonnie','Kearney','F','I10054',109272464,2645550150,'bonnie0@gmail.com'),
('P10055','Taylor','Maxwell','M','I10055',233069302,5085550165,'taylor0@gmail.com'),
('P10056','Denise','Smith','F','I10056',652535724,8695550119,'denise0@gmail.com'),
('P10057','Frank','Miller','M','I10057',10708100,1675550139,'frank1@gmail.com'),
('P10058','Kendall','Keil','M','I10058',571658797,1385550128,'kendall0@gmail.com'),
('P10059','Bob','Hohman','M','I10059',843479922,6115550116,'bob0@gmail.com'),
('P10060','Pete','Male','M','I10060',827686041,7685550123,'pete0@gmail.com'),
('P10061','Diane','Tibbott','F','I10061',92096924,3615550180,'diane2@gmail.com'),
('P10062','John','Campbell','M','I10062',494170342,4355550113,'john0@gmail.com'),
('P10063','Maciej','Dusza','M','I10063',414476027,2375550128,'maciej0@gmail.com'),
('P10064','Michael','Zwilling','M','I10064',582347317,5825550148,'michael7@gmail.com'),
('P10065','Randy','Reeves','M','I10065',8066363,9615550122,'randy0@gmail.com'),
('P10066','Karan','Khanna','M','I10066',834186596,4475550186,'karan0@gmail.com'),
('P10067','Jay','Adams','M','I10067',63179277,4075550165,'jay0@gmail.com'),
('P10068','Charles','Fitzgerald','M','I10068',537092325,9315550118,'charles0@gmail.com'),
('P10069','Steve','Masters','M','I10069',752513276,7125550170,'steve0@gmail.com'),
('P10070','David','Ortiz','M','I10070',36151748,7125550119,'david2@gmail.com'),
('P10071','Michael','Ray','M','I10071',578935259,1565550199,'michael3@gmail.com'),
('P10072','Steven','Selikoff','M','I10072',443968955,9255550114,'steven0@gmail.com'),
('P10073','Carole','Poland','F','I10073',138280935,6885550192,'carole0@gmail.com'),
('P10074','Bjorn','Rettig','M','I10074',420023788,1995550117,'bjorn0@gmail.com'),
('P10075','Michiko','Osada','M','I10075',363996959,9845550148,'michiko0@gmail.com'),
('P10076','Carol','Philips','F','I10076',227319668,6095550153,'carol0@gmail.com'),
('P10077','Merav','Netz','F','I10077',301435199,2245550187,'merav0@gmail.com'),
('P10078','Reuben','Dsa','M','I10078',370989364,1915550112,'reuben0@gmail.com'),
('P10079','Eric','Brown','M','I10079',697712387,6805550118,'eric1@gmail.com'),
('P10080','Sandeep','Kaliyath','M','I10080',943170460,1665550156,'sandeep0@gmail.com'),
('P10081','Mihail','Frintu','M','I10081',413787783,7335550128,'mihail0@gmail.com'),
('P10082','Jack','Creasey','M','I10082',58791499,5215550113,'jack1@gmail.com'),
('P10083','Patrick','Cook','M','I10083',988315686,4255550117,'patrick1@gmail.com'),
('P10084','Frank','Martinez','M','I10084',947029962,2035550196,'frank3@gmail.com'),
('P10085','Brian','Goldstein','M','I10085',1662732,7305550117,'brian2@gmail.com'),
('P10086','Ryan','Cornelsen','M','I10086',769680433,2085550114,'ryan0@gmail.com'),
('P10087','Cristian','Petculescu','M','I10087',7201901,4345550133,'cristian0@gmail.com'),
('P10088','Betsy','Stadick','F','I10088',294148271,4055550171,'betsy0@gmail.com'),
('P10089','Patrick','Wedge','M','I10089',90888098,4135550124,'patrick0@gmail.com'),
('P10090','Danielle','Tiedt','F','I10090',82638150,5005550172,'danielle0@gmail.com'),
('P10091','Kimberly','Zimmerman','F','I10091',390124815,1235550167,'kimberly0@gmail.com'),
('P10092','Tom','Vande Velde','M','I10092',826454897,2955550161,'tom0@gmail.com'),
('P10093','KokHo','Loh','M','I10093',778552911,9995550155,'kokho0@gmail.com'),
('P10094','Russell','Hunter','M','I10094',718299860,7865550144,'russell0@gmail.com'),
('P10095','Jim','Scardelis','M','I10095',674171828,6795550113,'jim0@gmail.com'),
('P10096','Elizabeth','Keyser','F','I10096',912141525,3185550137,'elizabeth0@gmail.com'),
('P10097','Mandar','Samant','M','I10097',370581729,1405550132,'mandar0@gmail.com'),
('P10098','Sameer','Tejani','M','I10098',152085091,9905550172,'sameer0@gmail.com'),
('P10099','Nuan','Yu','M','I10099',431859843,9135550184,'nuan0@gmail.com'),
('P10100','Lolan','Song','M','I10100',204035155,5825550178,'lolan0@gmail.com'),
('P10101','Houman','Pournasseh','M','I10101',153288994,1805550136,'houman0@gmail.com'),
('P10102','Zheng','Mu','M','I10102',360868122,1135550173,'zheng0@gmail.com'),
('P10103','Ebru','Ersan','M','I10103',455563743,2025550187,'ebru0@gmail.com'),
('P10104','Mary','Baker','F','I10104',717889520,2835550185,'mary1@gmail.com'),
('P10105','Kevin','Homer','M','I10105',801365500,5555550113,'kevin2@gmail.com'),
('P10106','John','Kane','M','I10106',561196580,2545550114,'john4@gmail.com'),
('P10107','Christopher','Hill','M','I10107',393421437,1535550166,'christo@gmail.com'),
('P10108','Jinghao','Liu','M','I10108',630184120,7945550159,'jinghao0@gmail.com'),
('P10109','Alice','Ciccu','F','I10109',113695504,3335550173,'alice0@gmail.com'),
('P10110','Jun','Cao','M','I10110',857651804,2995550113,'jun0@gmail.com'),
('P10111','Suroor','Fatima','M','I10111',415823523,9325550161,'suroor0@gmail.com'),
('P10112','John','Evans','M','I10112',981597097,1725550130,'john1@gmail.com'),
('P10113','Linda','Moschell','F','I10113',54759846,6125550171,'linda0@gmail.com'),
('P10114','Mindaugas','Krapauskas','M','I10114',342607223,6375550120,'mindaugas0@gmail.com'),
('P10115','Angela','Barbariol','F','I10115',563680513,1505550194,'angela0@gmail.com'),
('P10116','Michael','Patten','M','I10116',398737566,4415550195,'michael2@gmail.com'),
('P10117','Chad','Niswonger','M','I10117',599942664,5595550175,'chad0@gmail.com'),
('P10118','Don','Hall','M','I10118',222400012,1005550174,'don0@gmail.com'),
('P10119','Michael','Entin','M','I10119',334834274,8175550186,'michael4@gmail.com'),
('P10120','Kitti','Lertpiriyasuwat','F','I10120',211789056,7855550132,'kitti0@gmail.com'),
('P10121','Pilar','Ackerman','M','I10121',521265716,5775550185,'pilar0@gmail.com'),
('P10122','Susan','Eaton','F','I10122',586486572,9435550196,'susan0@gmail.com'),
('P10123','Vamsi','Kuppa','M','I10123',337752649,9375550137,'vamsi0@gmail.com'),
('P10124','Kim','Ralls','F','I10124',420776180,3095550129,'kim0@gmail.com'),
('P10125','Matthias','Berndt','M','I10125',584205124,1395550120,'matthias0@gmail.com'),
('P10126','Jimmy','Bischoff','M','I10126',652779496,9275550168,'jimmy0@gmail.com'),
('P10127','David','Hamilton','M','I10127',750905084,9865550177,'david4@gmail.com'),
('P10128','Paul','Komosinski','M','I10128',384162788,1475550160,'paul0@gmail.com'),
('P10129','Gary','Yukish','M','I10129',502058701,9015550125,'gary0@gmail.com'),
('P10130','Rob','Caron','M','I10130',578953538,2385550116,'rob1@gmail.com'),
('P10131','Baris','Cetinok','M','I10131',273260055,1645550114,'baris0@gmail.com'),
('P10132','Nicole','Holliday','F','I10132',1300049,5085550129,'nicole0@gmail.com'),
('P10133','Michael','Rothkugel','M','I10133',830150469,4545550119,'michael1@gmail.com'),
('P10134','Eric','Gubbels','M','I10134',45615666,2605550119,'eric0@gmail.com'),
('P10135','Ivo','Salmre','M','I10135',964089218,1155550179,'ivo0@gmail.com'),
('P10136','Sylvester','Valdez','M','I10136',701156975,4925550174,'sylvester0@gmail.com'),
('P10137','Anibal','Sousa','F','I10137',63761469,1065550120,'anibal0@gmail.com'),
('P10138','Samantha','Smith','F','I10138',25011600,5875550114,'samantha0@gmail.com'),
('P10139','HungFu','Ting','M','I10139',113393530,4975550181,'hungfu0@gmail.com'),
('P10140','Prasanna','Samarawickrama','M','I10140',339233463,1295550199,'prasanna0@gmail.com'),
('P10141','Min','Su','M','I10141',872923042,5905550152,'min0@gmail.com'),
('P10142','Olinda','Turner','F','I10142',163347032,3065550186,'olinda0@gmail.com'),
('P10143','Krishna','Sunkammurali','M','I10143',56772045,4915550183,'krishna0@gmail.com'),
('P10144','Paul','Singh','M','I10144',886023130,7275550112,'paul1@gmail.com'),
('P10145','Cynthia','Randall','F','I10145',386315192,3525550138,'cynthia0@gmail.com'),
('P10146','Jian Shuo','Wang','M','I10146',160739235,9525550178,'jianshuo0@gmail.com'),
('P10147','Sandra','Reátegui Alayo','F','I10147',604664374,8965550168,'sandra0@gmail.com'),
('P10148','Jason','Watters','M','I10148',733022683,5715550179,'jason0@gmail.com'),
('P10149','Andy','Ruth','M','I10149',764853868,1185550110,'andy0@gmail.com'),
('P10150','Michael','Vanderhyde','M','I10150',878395493,2965550121,'michael5@gmail.com')
GO

---After inserting records into Person table run the below script to encrypt SSN. Please note we need to execute only from step 5 to step 7
--as we have already created key, certificate and password.

--Step 1
CREATE MASTER KEY ENCRYPTION BY   
PASSWORD = '<Crackme>';

  
--Step 2
CREATE CERTIFICATE personSSN  
   WITH SUBJECT = 'Employee Social Security Numbers';  
GO  

--Step 3
CREATE SYMMETRIC KEY SSN_Key_01  
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE personSSN;  
GO  


--Step 4
-- Create a column in which to store the encrypted data.  
ALTER TABLE dbo.[Person]  
    ADD EncryptedNationalIDNumber varbinary(250);   
GO  
--Step 5
-- Open the symmetric key with which to encrypt the data.  
OPEN SYMMETRIC KEY SSN_Key_01  
   DECRYPTION BY CERTIFICATE personSSN;  

 --Step 6
-- Encrypt the value in column SSN with symmetric   
-- key SSN_Key_01. Save the result in column EncryptedNationalIDNumber.  
UPDATE dbo.[Person]  
SET EncryptedNationalIDNumber = EncryptByKey(Key_GUID('SSN_Key_01'),[SSN] ) WHERE SSN NOT IN('XXX-XXX-XXX') ;  
GO  


--Step 7
--Replacing data in attribute SSN  with dummy value
UPDATE dbo.[Person]
SET SSN='XXX-XXX-XXX'
WHERE SSN IS NOT NULL;

-- Verify the encryption.  
-- First, open the symmetric key with which to decrypt the data.  
OPEN SYMMETRIC KEY SSN_Key_01  
   DECRYPTION BY CERTIFICATE personSSN;  
GO  


-- Now list the Column SSN, the encrypted ID, and the   
-- decrypted ciphertext.   
SELECT personId,[SSN], EncryptedNationalIDNumber   
    AS 'Encrypted SSN',  
    CONVERT(nvarchar, DecryptByKey(EncryptedNationalIDNumber))   
    AS 'Decrypted SSN'  
    FROM  dbo.[Person]
	order by personId;  
GO
----------------------------Table 3------------------------------------
-----------------------Insert into PersonAddress----------------------

INSERT INTO dbo.PersonAddress VALUES('P10001','Ad10001');
INSERT INTO dbo.PersonAddress VALUES('P10002','Ad10002');
INSERT INTO dbo.PersonAddress VALUES('P10003','Ad10003');
INSERT INTO dbo.PersonAddress VALUES('P10004','Ad10004');
INSERT INTO dbo.PersonAddress VALUES('P10005','Ad10005');
INSERT INTO dbo.PersonAddress VALUES('P10006','Ad10006');
INSERT INTO dbo.PersonAddress VALUES('P10007','Ad10007');
INSERT INTO dbo.PersonAddress VALUES('P10008','Ad10008');
INSERT INTO dbo.PersonAddress VALUES('P10009','Ad10009');
INSERT INTO dbo.PersonAddress VALUES('P10010','Ad10010');
INSERT INTO dbo.PersonAddress VALUES('P10011','Ad10011');
INSERT INTO dbo.PersonAddress VALUES('P10012','Ad10012');
INSERT INTO dbo.PersonAddress VALUES('P10013','Ad10013');
INSERT INTO dbo.PersonAddress VALUES('P10014','Ad10014');
INSERT INTO dbo.PersonAddress VALUES('P10015','Ad10015');
INSERT INTO dbo.PersonAddress VALUES('P10016','Ad10016');
INSERT INTO dbo.PersonAddress VALUES('P10017','Ad10017');
INSERT INTO dbo.PersonAddress VALUES('P10018','Ad10018');
INSERT INTO dbo.PersonAddress VALUES('P10019','Ad10019');
INSERT INTO dbo.PersonAddress VALUES('P10020','Ad10020');
INSERT INTO dbo.PersonAddress VALUES('P10021','Ad10021');
INSERT INTO dbo.PersonAddress VALUES('P10022','Ad10022');
INSERT INTO dbo.PersonAddress VALUES('P10023','Ad10023');
INSERT INTO dbo.PersonAddress VALUES('P10024','Ad10024');
INSERT INTO dbo.PersonAddress VALUES('P10025','Ad10025');
INSERT INTO dbo.PersonAddress VALUES('P10026','Ad10026');
INSERT INTO dbo.PersonAddress VALUES('P10027','Ad10027');
INSERT INTO dbo.PersonAddress VALUES('P10028','Ad10028');
INSERT INTO dbo.PersonAddress VALUES('P10029','Ad10029');
INSERT INTO dbo.PersonAddress VALUES('P10030','Ad10030');
INSERT INTO dbo.PersonAddress VALUES('P10031','Ad10031');
INSERT INTO dbo.PersonAddress VALUES('P10032','Ad10032');
INSERT INTO dbo.PersonAddress VALUES('P10033','Ad10033');
INSERT INTO dbo.PersonAddress VALUES('P10034','Ad10034');
INSERT INTO dbo.PersonAddress VALUES('P10035','Ad10035');
INSERT INTO dbo.PersonAddress VALUES('P10036','Ad10036');
INSERT INTO dbo.PersonAddress VALUES('P10037','Ad10037');
INSERT INTO dbo.PersonAddress VALUES('P10038','Ad10038');
INSERT INTO dbo.PersonAddress VALUES('P10039','Ad10039');
INSERT INTO dbo.PersonAddress VALUES('P10040','Ad10040');
INSERT INTO dbo.PersonAddress VALUES('P10041','Ad10041');
INSERT INTO dbo.PersonAddress VALUES('P10042','Ad10042');
INSERT INTO dbo.PersonAddress VALUES('P10043','Ad10043');
INSERT INTO dbo.PersonAddress VALUES('P10044','Ad10044');
INSERT INTO dbo.PersonAddress VALUES('P10045','Ad10045');
INSERT INTO dbo.PersonAddress VALUES('P10046','Ad10046');
INSERT INTO dbo.PersonAddress VALUES('P10047','Ad10047');
INSERT INTO dbo.PersonAddress VALUES('P10048','Ad10048');
INSERT INTO dbo.PersonAddress VALUES('P10049','Ad10049');
INSERT INTO dbo.PersonAddress VALUES('P10050','Ad10050');
INSERT INTO dbo.PersonAddress VALUES('P10051','Ad10051');
INSERT INTO dbo.PersonAddress VALUES('P10052','Ad10052');
INSERT INTO dbo.PersonAddress VALUES('P10053','Ad10053');
INSERT INTO dbo.PersonAddress VALUES('P10054','Ad10054');
INSERT INTO dbo.PersonAddress VALUES('P10055','Ad10055');
INSERT INTO dbo.PersonAddress VALUES('P10056','Ad10056');
INSERT INTO dbo.PersonAddress VALUES('P10057','Ad10057');
INSERT INTO dbo.PersonAddress VALUES('P10058','Ad10058');
INSERT INTO dbo.PersonAddress VALUES('P10059','Ad10059');
INSERT INTO dbo.PersonAddress VALUES('P10060','Ad10060');
INSERT INTO dbo.PersonAddress VALUES('P10061','Ad10061');
INSERT INTO dbo.PersonAddress VALUES('P10062','Ad10062');
INSERT INTO dbo.PersonAddress VALUES('P10063','Ad10063');
INSERT INTO dbo.PersonAddress VALUES('P10064','Ad10064');
INSERT INTO dbo.PersonAddress VALUES('P10065','Ad10065');
INSERT INTO dbo.PersonAddress VALUES('P10066','Ad10066');
INSERT INTO dbo.PersonAddress VALUES('P10067','Ad10067');
INSERT INTO dbo.PersonAddress VALUES('P10068','Ad10068');
INSERT INTO dbo.PersonAddress VALUES('P10069','Ad10069');
INSERT INTO dbo.PersonAddress VALUES('P10070','Ad10070');
INSERT INTO dbo.PersonAddress VALUES('P10071','Ad10071');
INSERT INTO dbo.PersonAddress VALUES('P10072','Ad10072');
INSERT INTO dbo.PersonAddress VALUES('P10073','Ad10073');
INSERT INTO dbo.PersonAddress VALUES('P10074','Ad10074');
INSERT INTO dbo.PersonAddress VALUES('P10075','Ad10075');
INSERT INTO dbo.PersonAddress VALUES('P10076','Ad10076');
INSERT INTO dbo.PersonAddress VALUES('P10077','Ad10077');
INSERT INTO dbo.PersonAddress VALUES('P10078','Ad10078');
INSERT INTO dbo.PersonAddress VALUES('P10079','Ad10079');
INSERT INTO dbo.PersonAddress VALUES('P10080','Ad10080');
INSERT INTO dbo.PersonAddress VALUES('P10081','Ad10081');
INSERT INTO dbo.PersonAddress VALUES('P10082','Ad10082');
INSERT INTO dbo.PersonAddress VALUES('P10083','Ad10083');
INSERT INTO dbo.PersonAddress VALUES('P10084','Ad10084');
INSERT INTO dbo.PersonAddress VALUES('P10085','Ad10085');
INSERT INTO dbo.PersonAddress VALUES('P10086','Ad10086');
INSERT INTO dbo.PersonAddress VALUES('P10087','Ad10087');
INSERT INTO dbo.PersonAddress VALUES('P10088','Ad10088');
INSERT INTO dbo.PersonAddress VALUES('P10089','Ad10089');
INSERT INTO dbo.PersonAddress VALUES('P10090','Ad10090');
INSERT INTO dbo.PersonAddress VALUES('P10091','Ad10091');
INSERT INTO dbo.PersonAddress VALUES('P10092','Ad10092');
INSERT INTO dbo.PersonAddress VALUES('P10093','Ad10093');
INSERT INTO dbo.PersonAddress VALUES('P10094','Ad10094');
INSERT INTO dbo.PersonAddress VALUES('P10095','Ad10095');
INSERT INTO dbo.PersonAddress VALUES('P10096','Ad10096');
INSERT INTO dbo.PersonAddress VALUES('P10097','Ad10097');
INSERT INTO dbo.PersonAddress VALUES('P10098','Ad10098');
INSERT INTO dbo.PersonAddress VALUES('P10099','Ad10099');
INSERT INTO dbo.PersonAddress VALUES('P10100','Ad10100');
INSERT INTO dbo.PersonAddress VALUES('P10101','Ad10101');
INSERT INTO dbo.PersonAddress VALUES('P10102','Ad10102');
INSERT INTO dbo.PersonAddress VALUES('P10103','Ad10103');
INSERT INTO dbo.PersonAddress VALUES('P10104','Ad10104');
INSERT INTO dbo.PersonAddress VALUES('P10105','Ad10105');
INSERT INTO dbo.PersonAddress VALUES('P10106','Ad10106');
INSERT INTO dbo.PersonAddress VALUES('P10107','Ad10107');
INSERT INTO dbo.PersonAddress VALUES('P10108','Ad10108');
INSERT INTO dbo.PersonAddress VALUES('P10109','Ad10109');
INSERT INTO dbo.PersonAddress VALUES('P10110','Ad10110');
INSERT INTO dbo.PersonAddress VALUES('P10111','Ad10111');
INSERT INTO dbo.PersonAddress VALUES('P10112','Ad10112');
INSERT INTO dbo.PersonAddress VALUES('P10113','Ad10113');
INSERT INTO dbo.PersonAddress VALUES('P10114','Ad10114');
INSERT INTO dbo.PersonAddress VALUES('P10115','Ad10115');
INSERT INTO dbo.PersonAddress VALUES('P10116','Ad10116');
INSERT INTO dbo.PersonAddress VALUES('P10117','Ad10117');
INSERT INTO dbo.PersonAddress VALUES('P10118','Ad10118');
INSERT INTO dbo.PersonAddress VALUES('P10119','Ad10119');
INSERT INTO dbo.PersonAddress VALUES('P10120','Ad10120');
INSERT INTO dbo.PersonAddress VALUES('P10121','Ad10121');
INSERT INTO dbo.PersonAddress VALUES('P10122','Ad10122');
INSERT INTO dbo.PersonAddress VALUES('P10123','Ad10123');
INSERT INTO dbo.PersonAddress VALUES('P10124','Ad10124');
INSERT INTO dbo.PersonAddress VALUES('P10125','Ad10125');
INSERT INTO dbo.PersonAddress VALUES('P10126','Ad10126');
INSERT INTO dbo.PersonAddress VALUES('P10127','Ad10127');
INSERT INTO dbo.PersonAddress VALUES('P10128','Ad10128');
INSERT INTO dbo.PersonAddress VALUES('P10129','Ad10129');
INSERT INTO dbo.PersonAddress VALUES('P10130','Ad10130');
INSERT INTO dbo.PersonAddress VALUES('P10131','Ad10131');
INSERT INTO dbo.PersonAddress VALUES('P10132','Ad10132');
INSERT INTO dbo.PersonAddress VALUES('P10133','Ad10133');
INSERT INTO dbo.PersonAddress VALUES('P10134','Ad10134');
INSERT INTO dbo.PersonAddress VALUES('P10135','Ad10135');
INSERT INTO dbo.PersonAddress VALUES('P10136','Ad10136');
INSERT INTO dbo.PersonAddress VALUES('P10137','Ad10137');
INSERT INTO dbo.PersonAddress VALUES('P10138','Ad10138');
INSERT INTO dbo.PersonAddress VALUES('P10139','Ad10139');
INSERT INTO dbo.PersonAddress VALUES('P10140','Ad10140');
INSERT INTO dbo.PersonAddress VALUES('P10141','Ad10141');
INSERT INTO dbo.PersonAddress VALUES('P10142','Ad10142');
INSERT INTO dbo.PersonAddress VALUES('P10143','Ad10143');
INSERT INTO dbo.PersonAddress VALUES('P10144','Ad10144');
INSERT INTO dbo.PersonAddress VALUES('P10145','Ad10145');
INSERT INTO dbo.PersonAddress VALUES('P10146','Ad10146');
INSERT INTO dbo.PersonAddress VALUES('P10147','Ad10147');
INSERT INTO dbo.PersonAddress VALUES('P10148','Ad10148');
INSERT INTO dbo.PersonAddress VALUES('P10149','Ad10149');
INSERT INTO dbo.PersonAddress VALUES('P10150','Ad10150');

----------------------------Table 4------------------------------------
-----------------------Insert into JobTitle---------------------------

INSERT INTO [dbo].[JobTitle]
           ([JobTitleId]
           ,[TitleName]
           ,[Salary]
           ,[PaymentCycle])
     VALUES
           ('J10001','Manager',2000,'Monthly'),
		   ('J10002','Admin',800,'Monthly'),
		   ('J10003','Therapist',500,'Monthly'),
		   ('J10004','Instructor',800,'Monthly'),
		   ('J10005','Maintenance',300,'Monthly'),
		   ('J10006','Receptionist',300,'Monthly'),
		   ('J10007','Accountant',500,'Monthly'),
		   ('J10008','Security',900,'Monthly'),
		   ('J10009','WellnessCoordinator',1000,'Monthly'),
		   ('J10010','GymAssistant',500,'Monthly')

GO

----------------------------Table 5------------------------------------
-----------------------Insert into Discounts--------------------------

INSERT INTO [dbo].[Discounts]
           ([DiscountType]
           ,[DiscountPrice]
           ,[Season])
     VALUES
('DT10001',10,'Summer'),
('DT10002',5,'Full_Year'),
('DT10003',12,'Winter'),
('DT10004',8,'Christmas'),
('DT10005',10,'NewYear'),
('DT10006',5,'Fall'),
('DT10007',6,'MidFall'),
('DT10008',8,'LateAutumn'),
('DT10009',5,'MidSpring'),
('DT10010',2,'MidSummer')

GO


----------------------------Table 6------------------------------------
-----------------------Insert into PlanType---------------------------

INSERT INTO [dbo].[PlanType]
           ([PlanTypeId]
           ,[PlanName]
           ,[AmountByMonth])
     VALUES
           ('PT10001','Regular',1200),
		   ('PT10002','Premium',3000),
		   ('PT10003','Couple',2500),
		   ('PT10004','Family',4000),
		   ('PT10005','Student',900),
		   ('PT10006','Silver',2800),
		   ('PT10007','Gold',2900),
		   ('PT10008','Platinum',3250),
		   ('PT10009','SeniorCitizen',800),
		   ('PT10010','Women',1000)
GO


----------------------------Table 7------------------------------------
-----------------------Insert into EquipmentCategory------------------

INSERT INTO [dbo].[EquipmentCategory]
           ([EquipmentCategoryId]
           ,[CategoryName])
     VALUES
			('EQ10001','TreadMill'),
			('EQ10002','RowingMachine'),
			('EQ10003','UprightBike'),
			('EQ10004','SpinBike'),
			('EQ10005','LegCurl'),
			('EQ10006','Dumbbell'),
			('EQ10007','InclineBench'),
			('EQ10008','SeatedCalf'),
			('EQ10009','BowFlex'),
			('EQ10010','Rogue')
GO

----------------------------Table 8----------------------------------
-----------------------Insert into Branch---------------------------

INSERT INTO [Branch] VALUES('B10001',7876754544,'Ad10001'); 
INSERT INTO [Branch] VALUES('B10002',7876234544,'Ad10012');
INSERT INTO [Branch] VALUES('B10003',7845754544,'Ad10027');
INSERT INTO [Branch] VALUES('B10004',7870954544,'Ad10040');
INSERT INTO [Branch] VALUES('B10005',7834454544,'Ad10009');
INSERT INTO [Branch] VALUES('B10006',7878344544,'Ad10088');
INSERT INTO [Branch] VALUES('B10007',7876211544,'Ad10098');
INSERT INTO [Branch] VALUES('B10008',7876756719,'Ad10114');
INSERT INTO [Branch] VALUES('B10009',7876754532,'Ad10117');
INSERT INTO [Branch] VALUES('B10010',7876754980,'Ad10142');

----------------------------Table 9-------------------------------------
-----------------------Insert into Equipment---------------------------

INSERT INTO [dbo].[Equipment]
           ([EquipmentId]
           ,[BranchId]
           ,[EquipmentCategoryId]
           ,[PurchaseDate])
     VALUES
           ('EQT10001','B10001','EQ10001','2018-01-01'),
		   ('EQT10002','B10001','EQ10002','2018-01-01'),
		   ('EQT10003','B10001','EQ10003','2018-01-01'),
		   ('EQT10004','B10001','EQ10004','2018-01-01'),
		   ('EQT10005','B10002','EQ10001','2018-01-01'),
		   ('EQT10006','B10002','EQ10002','2018-01-01'),
		   ('EQT10007','B10002','EQ10003','2018-01-01'),
		   ('EQT10008','B10002','EQ10004','2018-01-01'),
		   ('EQT10009','B10002','EQ10007','2018-01-01'),
		   ('EQT10010','B10002','EQ10008','2018-01-01'),
		   ('EQT10011','B10003','EQ10001','2018-01-01'),
		   ('EQT10012','B10003','EQ10005','2018-01-01'),
		   ('EQT10013','B10003','EQ10006','2018-01-01'),
		   ('EQT10014','B10003','EQ10007','2018-01-01'),
		   ('EQT10015','B10003','EQ10008','2018-01-01'),
		   ('EQT10016','B10004','EQ10001','2018-01-01'),
		   ('EQT10017','B10004','EQ10003','2018-01-01'),
		   ('EQT10018','B10004','EQ10004','2018-01-01'),
		   ('EQT10019','B10004','EQ10005','2018-01-01'),
		   ('EQT10020','B10004','EQ10006','2018-01-01')
GO


----------------------------Table 10---------------------------------------------
-----------------------Insert into MaintainanceRecord---------------------------

INSERT INTO [dbo].[MaintainanceRecord]
           ([MaintainanceRecordId]
           ,[EquipmentId]
           ,[MaintainanceDate]
           ,[MaintainanceDetail]
           ,[MainatainanceCost])
     VALUES
           ('MNT10001','EQT10001','2018-02-01','Wear&Tear',50),
		   ('MNT10002','EQT10002','2018-02-01','Wear&Tear',30),
		   ('MNT10003','EQT10003','2018-02-01','Wear&Tear',40),
		   ('MNT10004','EQT10004','2018-02-01','Wear&Tear',20),
		   ('MNT10005','EQT10005','2018-02-01','Wear&Tear',40),
		   ('MNT10006','EQT10006','2018-02-01','Wear&Tear',20),
		   ('MNT10007','EQT10007','2018-02-01','Wear&Tear',60),
		   ('MNT10008','EQT10008','2018-02-01','Wear&Tear',30),
		   ('MNT10009','EQT10009','2018-02-01','Wear&Tear',40),
		   ('MNT10010','EQT10010','2018-02-01','Wear&Tear',20),
		   ('MNT10011','EQT10011','2018-02-01','Wear&Tear',30),
		   ('MNT10012','EQT10012','2018-02-01','Wear&Tear',20),
		   ('MNT10013','EQT10013','2018-02-01','Wear&Tear',40),
		   ('MNT10014','EQT10014','2018-02-01','Wear&Tear',20),
		   ('MNT10015','EQT10015','2018-02-01','Wear&Tear',60),
		   ('MNT10016','EQT10016','2018-02-01','Wear&Tear',30),
		   ('MNT10017','EQT10017','2018-02-01','Wear&Tear',40),
		   ('MNT10018','EQT10018','2018-02-01','Wear&Tear',20),
		   ('MNT10019','EQT10019','2018-02-01','Wear&Tear',45),
		   ('MNT10020','EQT10020','2018-02-01','Wear&Tear',25),
		   ('MNT10021','EQT10001','2018-07-01','Wear&Tear',50),
		   ('MNT10022','EQT10002','2018-07-01','Wear&Tear',30),
		   ('MNT10023','EQT10003','2018-07-01','Wear&Tear',40),
		   ('MNT10024','EQT10004','2018-07-01','Wear&Tear',20),
		   ('MNT10025','EQT10005','2018-07-01','Wear&Tear',40),
		   ('MNT10026','EQT10006','2018-07-01','Wear&Tear',20),
		   ('MNT10027','EQT10007','2018-07-01','Wear&Tear',60),
		   ('MNT10028','EQT10008','2018-07-01','Wear&Tear',30),
		   ('MNT10029','EQT10009','2018-07-01','Wear&Tear',40),
		   ('MNT10030','EQT10010','2018-07-01','Wear&Tear',20),
		   ('MNT10031','EQT10011','2018-07-01','Wear&Tear',30),
		   ('MNT10032','EQT10012','2018-07-01','Wear&Tear',20),
		   ('MNT10033','EQT10013','2018-07-01','Wear&Tear',40),
		   ('MNT10034','EQT10014','2018-07-01','Wear&Tear',20),
		   ('MNT10035','EQT10015','2018-07-01','Wear&Tear',60),
		   ('MNT10036','EQT10016','2018-07-01','Wear&Tear',30),
		   ('MNT10037','EQT10017','2018-07-01','Wear&Tear',40),
		   ('MNT10038','EQT10018','2018-07-01','Wear&Tear',20),
		   ('MNT10039','EQT10019','2018-07-01','Wear&Tear',45),
		   ('MNT10040','EQT10020','2018-07-01','Wear&Tear',25),
		   ('MNT10041','EQT10001','2019-02-01','Wear&Tear',60),
		   ('MNT10042','EQT10002','2019-02-01','Wear&Tear',40),
		   ('MNT10043','EQT10003','2019-02-01','Wear&Tear',50),
		   ('MNT10044','EQT10004','2019-02-01','Wear&Tear',30),
		   ('MNT10045','EQT10005','2019-02-01','Wear&Tear',50),
		   ('MNT10046','EQT10006','2019-02-01','Wear&Tear',30),
		   ('MNT10047','EQT10007','2019-02-01','Wear&Tear',70),
		   ('MNT10048','EQT10008','2019-02-01','Wear&Tear',40),
		   ('MNT10049','EQT10009','2019-02-01','Wear&Tear',50),
		   ('MNT10050','EQT10010','2019-02-01','Wear&Tear',30),
		   ('MNT10051','EQT10011','2019-02-01','Wear&Tear',40),
		   ('MNT10052','EQT10012','2019-02-01','Wear&Tear',30),
		   ('MNT10053','EQT10013','2019-02-01','Wear&Tear',50),
		   ('MNT10054','EQT10014','2019-02-01','Wear&Tear',30),
		   ('MNT10055','EQT10015','2019-02-01','Wear&Tear',70),
		   ('MNT10056','EQT10016','2019-02-01','Wear&Tear',40),
		   ('MNT10057','EQT10017','2019-02-01','Wear&Tear',50),
		   ('MNT10058','EQT10018','2019-02-01','Wear&Tear',30),
		   ('MNT10059','EQT10019','2019-02-01','Wear&Tear',55),
		   ('MNT10060','EQT10020','2019-02-01','Wear&Tear',35),
		   ('MNT10061','EQT10001','2019-07-01','Wear&Tear',60),
		   ('MNT10062','EQT10002','2019-07-01','Wear&Tear',40),
		   ('MNT10063','EQT10003','2019-07-01','Wear&Tear',50),
		   ('MNT10064','EQT10004','2019-07-01','Wear&Tear',30),
		   ('MNT10065','EQT10005','2019-07-01','Wear&Tear',50),
		   ('MNT10066','EQT10006','2019-07-01','Wear&Tear',30),
		   ('MNT10067','EQT10007','2019-07-01','Wear&Tear',70),
		   ('MNT10068','EQT10008','2019-07-01','Wear&Tear',40),
		   ('MNT10069','EQT10009','2019-07-01','Wear&Tear',50),
		   ('MNT10070','EQT10010','2019-07-01','Wear&Tear',30),
		   ('MNT10071','EQT10011','2019-07-01','Wear&Tear',40),
		   ('MNT10072','EQT10012','2019-07-01','Wear&Tear',30),
		   ('MNT10073','EQT10013','2019-07-01','Wear&Tear',50),
		   ('MNT10074','EQT10014','2019-07-01','Wear&Tear',30),
		   ('MNT10075','EQT10015','2019-07-01','Wear&Tear',70)
GO


----------------------------Table 11----------------------------------------
-----------------------Insert into ClassRoom-------------------------------

  INSERT INTO [ClassRoom] VALUES('CL10001','B10001','101');
  INSERT INTO [ClassRoom] VALUES('CL10002','B10002','101');
  INSERT INTO [ClassRoom] VALUES('CL10003','B10003','101');
  INSERT INTO [ClassRoom] VALUES('CL10004','B10004','101');
  INSERT INTO [ClassRoom] VALUES('CL10005','B10005','101');
  INSERT INTO [ClassRoom] VALUES('CL10006','B10006','101');
  INSERT INTO [ClassRoom] VALUES('CL10007','B10007','101');
  INSERT INTO [ClassRoom] VALUES('CL10008','B10008','101');
  INSERT INTO [ClassRoom] VALUES('CL10009','B10009','101');
  INSERT INTO [ClassRoom] VALUES('CL10010','B10010','101');
  INSERT INTO [ClassRoom] VALUES('CL10011','B10001','102');
  INSERT INTO [ClassRoom] VALUES('CL10012','B10002','102');
  INSERT INTO [ClassRoom] VALUES('CL10013','B10003','102');
  INSERT INTO [ClassRoom] VALUES('CL10014','B10004','102');
  INSERT INTO [ClassRoom] VALUES('CL10015','B10005','102');
  INSERT INTO [ClassRoom] VALUES('CL10016','B10006','102');
  INSERT INTO [ClassRoom] VALUES('CL10017','B10007','102');
  INSERT INTO [ClassRoom] VALUES('CL10018','B10008','102');
  INSERT INTO [ClassRoom] VALUES('CL10019','B10009','102');
  INSERT INTO [ClassRoom] VALUES('CL10020','B10010','102');

----------------------------Table 12-------------------------------------------
-----------------------Insert into Employees---------------------------------

INSERT INTO dbo.Employees VALUES('E10001','P10028','B10001','J10001','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10002','P10002','B10001','J10002','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10003','P10026','B10001','J10004','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10004','P10130','B10010','J10001','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10005','P10137','B10010','J10002','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10006','P10138','B10010','J10008','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10007','P10141','B10005','J10001','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10008','P10147','B10005','J10002','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10009','P10087','B10005','J10009','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10010','P10030','B10002','J10001','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10011','P10032','B10002','J10002','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10012','P10034','B10002','J10008','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10013','P10061','B10004','J10001','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10014','P10067','B10004','J10002','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10015','P10051','B10004','J10009','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10016','P10136','B10006','J10001','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10017','P10093','B10006','J10002','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10018','P10146','B10006','J10008','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10019','P10057','B10003','J10001','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10020','P10059','B10003','J10002','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10021','P10071','B10003','J10004','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10022','P10079','B10007','J10001','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10023','P10120','B10007','J10002','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10024','P10108','B10007','J10009','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10025','P10062','B10008','J10001','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10026','P10066','B10008','J10002','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10027','P10045','B10008','J10004','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10028','P10007','B10009','J10001','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10029','P10078','B10009','J10002','2019-04-01');
INSERT INTO dbo.Employees VALUES('E10030','P10105','B10009','J10008','2019-04-01');

 ----------------------------Table 13----------------------------------------
 -----------------------Insert into PaymentRecord---------------------------
 
 INSERT INTO [dbo].[PaymentRecord]
           ([PaymentRecordId]
           ,[EmployeeId]
           ,[PaymentDate]
           ,[DirectDepositAccount])
     VALUES
            ('PREC10001','E10001','2019-05-01','ACC10001'),
			('PREC10002','E10002','2019-05-01','ACC10002'),
			('PREC10003','E10003','2019-05-01','ACC10003'),
			('PREC10004','E10004','2019-05-01','ACC10004'),
			('PREC10005','E10005','2019-05-01','ACC10005'),
			('PREC10006','E10006','2019-05-01','ACC10006'),
			('PREC10007','E10007','2019-05-01','ACC10007'),
			('PREC10008','E10008','2019-05-01','ACC10008'),
			('PREC10009','E10009','2019-05-01','ACC10009'),
			('PREC10010','E10010','2019-05-01','ACC10010'),
			('PREC10011','E10011','2019-05-01','ACC10011'),
			('PREC10012','E10012','2019-05-01','ACC10012'),
			('PREC10013','E10013','2019-05-01','ACC10013'),
			('PREC10014','E10014','2019-05-01','ACC10014'),
			('PREC10015','E10015','2019-05-01','ACC10015'),
			('PREC10016','E10016','2019-05-01','ACC10016'),
			('PREC10017','E10017','2019-05-01','ACC10017'),
			('PREC10018','E10018','2019-05-01','ACC10018'),
			('PREC10019','E10019','2019-05-01','ACC10019'),
			('PREC10020','E10020','2019-05-01','ACC10020'),
			('PREC10021','E10021','2019-05-01','ACC10021'),
			('PREC10022','E10022','2019-05-01','ACC10022'),
			('PREC10023','E10023','2019-05-01','ACC10023'),
			('PREC10024','E10024','2019-05-01','ACC10024'),
			('PREC10025','E10025','2019-05-01','ACC10025'),
			('PREC10026','E10026','2019-05-01','ACC10026'),
			('PREC10027','E10027','2019-05-01','ACC10027'),
			('PREC10028','E10028','2019-05-01','ACC10028'),
			('PREC10029','E10029','2019-05-01','ACC10029'),
			('PREC10030','E10030','2019-05-01','ACC10030'),
			('PREC10031','E10001','2019-05-01','ACC10001'),
			('PREC10032','E10002','2019-05-01','ACC10002'),
			('PREC10033','E10003','2019-05-01','ACC10003'),
			('PREC10034','E10004','2019-05-01','ACC10004'),
			('PREC10035','E10005','2019-05-01','ACC10005'),
			('PREC10036','E10006','2019-05-01','ACC10006'),
			('PREC10037','E10007','2019-05-01','ACC10007'),
			('PREC10038','E10008','2019-05-01','ACC10008'),
			('PREC10039','E10009','2019-05-01','ACC10009'),
			('PREC10040','E10010','2019-05-01','ACC10010'),
			('PREC10041','E10011','2019-05-01','ACC10011'),
			('PREC10042','E10012','2019-05-01','ACC10012'),
			('PREC10043','E10013','2019-05-01','ACC10013'),
			('PREC10044','E10014','2019-05-01','ACC10014'),
			('PREC10045','E10015','2019-05-01','ACC10015'),
			('PREC10046','E10016','2019-05-01','ACC10016'),
			('PREC10047','E10017','2019-05-01','ACC10017'),
			('PREC10048','E10018','2019-05-01','ACC10018'),
			('PREC10049','E10019','2019-05-01','ACC10019'),
			('PREC10050','E10020','2019-05-01','ACC10020'),
			('PREC10051','E10021','2019-05-01','ACC10021'),
			('PREC10052','E10022','2019-05-01','ACC10022'),
			('PREC10053','E10023','2019-05-01','ACC10023'),
			('PREC10054','E10024','2019-05-01','ACC10024'),
			('PREC10055','E10025','2019-05-01','ACC10025'),
			('PREC10056','E10026','2019-05-01','ACC10026'),
			('PREC10057','E10027','2019-05-01','ACC10027'),
			('PREC10058','E10028','2019-05-01','ACC10028'),
			('PREC10059','E10029','2019-05-01','ACC10029'),
			('PREC10060','E10030','2019-05-01','ACC10030'),
			('PREC10061','E10001','2019-05-01','ACC10001'),
			('PREC10062','E10002','2019-05-01','ACC10002'),
			('PREC10063','E10003','2019-05-01','ACC10003'),
			('PREC10064','E10004','2019-05-01','ACC10004'),
			('PREC10065','E10005','2019-05-01','ACC10005'),
			('PREC10066','E10006','2019-05-01','ACC10006'),
			('PREC10067','E10007','2019-05-01','ACC10007'),
			('PREC10068','E10008','2019-05-01','ACC10008'),
			('PREC10069','E10009','2019-05-01','ACC10009'),
			('PREC10070','E10010','2019-05-01','ACC10010'),
			('PREC10071','E10011','2019-05-01','ACC10011'),
			('PREC10072','E10012','2019-05-01','ACC10012'),
			('PREC10073','E10013','2019-05-01','ACC10013'),
			('PREC10074','E10014','2019-05-01','ACC10014'),
			('PREC10075','E10015','2019-05-01','ACC10015'),
			('PREC10076','E10016','2019-05-01','ACC10016'),
			('PREC10077','E10017','2019-05-01','ACC10017'),
			('PREC10078','E10018','2019-05-01','ACC10018'),
			('PREC10079','E10019','2019-05-01','ACC10019'),
			('PREC10080','E10020','2019-05-01','ACC10020'),
			('PREC10081','E10021','2019-05-01','ACC10021'),
			('PREC10082','E10022','2019-05-01','ACC10022'),
			('PREC10083','E10023','2019-05-01','ACC10023'),
			('PREC10084','E10024','2019-05-01','ACC10024'),
			('PREC10085','E10025','2019-05-01','ACC10025'),
			('PREC10086','E10026','2019-05-01','ACC10026'),
			('PREC10087','E10027','2019-05-01','ACC10027'),
			('PREC10088','E10028','2019-05-01','ACC10028'),
			('PREC10089','E10029','2019-05-01','ACC10029'),
			('PREC10090','E10030','2019-05-01','ACC10030')
GO

 ----------------------------Table 14----------------------------------
 -----------------------Insert into Classes---------------------------

INSERT INTO dbo.[Classes] VALUES('CLS10001','E10003','CL10001','yoga','Monday','08:00:00.0000000',20,1);
INSERT INTO dbo.[Classes] VALUES('CLS10002','E10003','CL10011','pool','Wednesday','17:00:00.0000000',30,1);
INSERT INTO dbo.[Classes] VALUES('CLS10003','E10012','CL10002','Zumba','Friday','18:00:00.0000000',5,1);
INSERT INTO dbo.[Classes] VALUES('CLS10004','E10012','CL10012','Aqua Zumba','Monday','08:00:00.0000000',20,1);
INSERT INTO dbo.[Classes] VALUES('CLS10005','E10021','CL10003','Zumba','Wednesday','17:00:00.0000000',30,1);
INSERT INTO dbo.[Classes] VALUES('CLS10006','E10021','CL10013','Martial arts','Friday','18:00:00.0000000',5,1);
INSERT INTO dbo.[Classes] VALUES('CLS10007','E10015','CL10004','Cycle','Monday','18:00:00.0000000',40,1);
INSERT INTO dbo.[Classes] VALUES('CLS10008','E10015','CL10014','yoga','Tuesday','08:00:00.0000000',35,1);
INSERT INTO dbo.[Classes] VALUES('CLS10009','E10009','CL10005','pool','Wednesday','17:00:00.0000000',5,1);
INSERT INTO dbo.[Classes] VALUES('CLS10010','E10009','CL10015','Martial arts','Monday','18:00:00.0000000',50,1);
INSERT INTO dbo.[Classes] VALUES('CLS10011','E10018','CL10006','pool','Wednesday','08:00:00.0000000',50,1);
INSERT INTO dbo.[Classes] VALUES('CLS10012','E10018','CL10016','Zumba','Friday','18:00:00.0000000',5,1);
INSERT INTO dbo.[Classes] VALUES('CLS10013','E10024','CL10007','yoga','Monday','08:00:00.0000000',20,1);
INSERT INTO dbo.[Classes] VALUES('CLS10014','E10024','CL10017','pool','Wednesday','17:00:00.0000000',30,1);
INSERT INTO dbo.[Classes] VALUES('CLS10015','E10027','CL10008','Martial arts','Friday','18:00:00.0000000',5,1);
INSERT INTO dbo.[Classes] VALUES('CLS10016','E10027','CL10018','Cycle','Monday','08:00:00.0000000',20,1);
INSERT INTO dbo.[Classes] VALUES('CLS10017','E10030','CL10009','Martial arts','Wednesday','17:00:00.0000000',30,1);
INSERT INTO dbo.[Classes] VALUES('CLS10018','E10030','CL10019','Cycle','Friday','18:00:00.0000000',5,1);
INSERT INTO dbo.[Classes] VALUES('CLS10019','E10006','CL10010','Aqua Zumba','Monday','18:00:00.0000000',40,1);
INSERT INTO dbo.[Classes] VALUES('CLS10020','E10006','CL10020','Zumba','Tuesday','08:00:00.0000000',35,1);

 ----------------------------Table 15-----------------------------------
 -----------------------Insert into Customer---------------------------

INSERT INTO [dbo].[Customer]
           ([CustomerId]
           ,[PersonId]
           ,[DiscountType]
           ,[StartDate]
           ,[EndDate]
           ,[PlanTypeId]
		   ,[BranchID])
     VALUES
	 ('C10001','P10005','DT10001','2019-04-01','2020-04-01','PT10001','B10001'),
('C10002','P10008','DT10002','2019-04-01','2020-04-01','PT10002','B10001'),
('C10003','P10009','DT10003','2019-04-01','2020-04-01','PT10003','B10001'),
('C10004','P10015','DT10004','2019-04-01','2020-04-01','PT10004','B10001'),
('C10005','P10019','DT10005','2019-04-01','2020-04-01','PT10005','B10001'),
('C10006','P10020','DT10006','2019-04-01','2020-04-01','PT10006','B10001'),
('C10007','P10013','DT10007','2019-04-01','2020-04-01','PT10007','B10001'),
('C10008','P10023','DT10008','2019-04-01','2020-04-01','PT10008','B10001'),
('C10009','P10024','DT10009','2019-04-01','2020-04-01','PT10009','B10001'),
('C10010','P10031','DT10010','2019-04-01','2020-04-01','PT10010','B10001'),
('C10011','P10027','DT10001','2019-04-01','2020-04-01','PT10001','B10001'),
('C10012','P10038','DT10002','2019-04-01','2020-04-01','PT10002','B10001'),
('C10013','P10043','DT10003','2019-04-01','2020-04-01','PT10006','B10001'),
('C10014','P10040','DT10004','2019-04-01','2020-04-01','PT10007','B10010'),
('C10015','P10048','DT10005','2019-04-01','2020-04-01','PT10008','B10010'),
('C10016','P10052','DT10006','2019-04-01','2020-04-01','PT10006','B10010'),
('C10017','P10053','DT10007','2019-04-01','2020-04-01','PT10007','B10010'),
('C10018','P10054','DT10008','2019-04-01','2020-04-01','PT10008','B10010'),
('C10019','P10056','DT10009','2019-04-01','2020-04-01','PT10009','B10010'),
('C10020','P10076','DT10010','2019-04-01','2020-04-01','PT10010','B10010'),
('C10021','P10077','DT10002','2019-04-01','2020-04-01','PT10001','B10010'),
('C10022','P10073','DT10003','2019-04-01','2020-04-01','PT10002','B10010'),
('C10023','P10088','DT10004','2019-04-01','2020-04-01','PT10006','B10010'),
('C10024','P10090','DT10005','2019-04-01','2020-04-01','PT10007','B10010'),
('C10025','P10091','DT10006','2019-04-01','2020-04-01','PT10008','B10010'),
('C10026','P10096','DT10007','2019-04-01','2020-04-01','PT10008','B10010'),
('C10027','P10109','DT10008','2019-04-01','2020-04-01','PT10009','B10010'),
('C10028','P10104','DT10009','2019-04-01','2020-04-01','PT10010','B10010'),
('C10029','P10113','DT10010','2019-04-01','2020-04-01','PT10001','B10010'),
('C10030','P10115','DT10002','2019-04-01','2020-04-01','PT10002','B10010'),
('C10031','P10124','DT10003','2019-04-01','2020-04-01','PT10006','B10010'),
('C10032','P10132','DT10004','2019-04-01','2020-04-01','PT10007','B10010'),
('C10033','P10122','DT10005','2019-04-01','2020-04-01','PT10008','B10010'),
('C10034','P10142','DT10006','2019-04-01','2020-04-01','PT10008','B10005'),
('C10035','P10145','DT10007','2019-04-01','2020-04-01','PT10009','B10005'),
('C10036','P10148','DT10008','2019-04-01','2020-04-01','PT10010','B10005'),
('C10037','P10149','DT10009','2019-04-01','2020-04-01','PT10001','B10005'),
('C10038','P10150','DT10010','2019-04-01','2020-04-01','PT10002','B10005'),
('C10039','P10143','DT10002','2019-04-01','2020-04-01','PT10006','B10005'),
('C10040','P10144','DT10003','2019-04-01','2020-04-01','PT10007','B10002'),
('C10041','P10123','DT10004','2019-04-01','2020-04-01','PT10008','B10002'),
('C10042','P10133','DT10005','2019-04-01','2020-04-01','PT10009','B10002'),
('C10043','P10134','DT10006','2019-04-01','2020-04-01','PT10010','B10002'),
('C10044','P10135','DT10007','2019-04-01','2020-04-01','PT10002','B10002'),
('C10045','P10139','DT10008','2019-04-01','2020-04-01','PT10004','B10002'),
('C10046','P10140','DT10009','2019-04-01','2020-04-01','PT10004','B10002'),
('C10047','P10125','DT10010','2019-04-01','2020-04-01','PT10005','B10002'),
('C10048','P10126','DT10001','2019-04-01','2020-04-01','PT10006','B10002'),
('C10049','P10127','DT10002','2019-04-01','2020-04-01','PT10010','B10002'),
('C10050','P10128','DT10003','2019-04-01','2020-04-01','PT10002','B10002'),
('C10051','P10129','DT10004','2019-04-01','2020-04-01','PT10004','B10002'),
('C10052','P10131','DT10005','2019-04-01','2020-04-01','PT10004','B10004'),
('C10053','P10116','DT10006','2019-04-01','2020-04-01','PT10005','B10004'),
('C10054','P10117','DT10007','2019-04-01','2020-04-01','PT10006','B10004'),
('C10055','P10118','DT10008','2019-04-01','2020-04-01','PT10006','B10004'),
('C10056','P10119','DT10009','2019-04-01','2020-04-01','PT10007','B10004'),
('C10057','P10121','DT10010','2019-04-01','2020-04-01','PT10008','B10004'),
('C10058','P10114','DT10002','2019-04-01','2020-04-01','PT10009','B10004'),
('C10059','P10106','DT10003','2019-04-01','2020-04-01','PT10006','B10004'),
('C10060','P10107','DT10004','2019-04-01','2020-04-01','PT10007','B10004'),
('C10061','P10110','DT10005','2019-04-01','2020-04-01','PT10008','B10004'),
('C10062','P10111','DT10006','2019-04-01','2020-04-01','PT10009','B10004'),
('C10063','P10112','DT10007','2019-04-01','2020-04-01','PT10004','B10004'),
('C10064','P10097','DT10008','2019-04-01','2020-04-01','PT10005','B10006'),
('C10065','P10098','DT10009','2019-04-01','2020-04-01','PT10006','B10006'),
('C10066','P10099','DT10010','2019-04-01','2020-04-01','PT10007','B10006'),
('C10067','P10100','DT10002','2019-04-01','2020-04-01','PT10008','B10006'),
('C10068','P10101','DT10003','2019-04-01','2020-04-01','PT10009','B10003'),
('C10069','P10102','DT10004','2019-04-01','2020-04-01','PT10010','B10003'),
('C10070','P10103','DT10005','2019-04-01','2020-04-01','PT10009','B10003'),
('C10071','P10092','DT10006','2019-04-01','2020-04-01','PT10006','B10003'),
('C10072','P10094','DT10007','2019-04-01','2020-04-01','PT10007','B10003'),
('C10073','P10095','DT10008','2019-04-01','2020-04-01','PT10008','B10003'),
('C10074','P10089','DT10009','2019-04-01','2020-04-01','PT10009','B10003'),
('C10075','P10074','DT10010','2019-04-01','2020-04-01','PT10004','B10003'),
('C10076','P10075','DT10002','2019-04-01','2020-04-01','PT10005','B10003'),
('C10077','P10080','DT10003','2019-04-01','2020-04-01','PT10006','B10003'),
('C10078','P10081','DT10004','2019-04-01','2020-04-01','PT10007','B10003'),
('C10079','P10082','DT10005','2019-04-01','2020-04-01','PT10009','B10003'),
('C10080','P10083','DT10006','2019-04-01','2020-04-01','PT10006','B10003'),
('C10081','P10084','DT10007','2019-04-01','2020-04-01','PT10007','B10003'),
('C10082','P10085','DT10008','2019-04-01','2020-04-01','PT10008','B10003'),
('C10083','P10086','DT10009','2019-04-01','2020-04-01','PT10009','B10003'),
('C10084','P10058','DT10010','2019-04-01','2020-04-01','PT10004','B10003'),
('C10085','P10060','DT10002','2019-04-01','2020-04-01','PT10005','B10007'),
('C10086','P10063','DT10003','2019-04-01','2020-04-01','PT10006','B10007'),
('C10087','P10064','DT10004','2019-04-01','2020-04-01','PT10007','B10007'),
('C10088','P10065','DT10005','2019-04-01','2020-04-01','PT10008','B10007'),
('C10089','P10068','DT10006','2019-04-01','2020-04-01','PT10009','B10007'),
('C10090','P10069','DT10007','2019-04-01','2020-04-01','PT10010','B10007'),
('C10091','P10070','DT10008','2019-04-01','2020-04-01','PT10009','B10007'),
('C10092','P10072','DT10009','2019-04-01','2020-04-01','PT10006','B10007'),
('C10093','P10055','DT10010','2019-04-01','2020-04-01','PT10007','B10007'),
('C10094','P10049','DT10002','2019-04-01','2020-04-01','PT10008','B10007'),
('C10095','P10050','DT10003','2019-04-01','2020-04-01','PT10009','B10007'),
('C10096','P10041','DT10004','2019-04-01','2020-04-01','PT10004','B10008'),
('C10097','P10042','DT10005','2019-04-01','2020-04-01','PT10005','B10008'),
('C10098','P10044','DT10006','2019-04-01','2020-04-01','PT10006','B10008'),
('C10099','P10046','DT10007','2019-04-01','2020-04-01','PT10007','B10008'),
('C10100','P10047','DT10008','2019-04-01','2020-04-01','PT10009','B10008'),
('C10101','P10039','DT10009','2019-04-01','2020-04-01','PT10006','B10008'),
('C10102','P10029','DT10010','2019-04-01','2020-04-01','PT10007','B10008'),
('C10103','P10033','DT10010','2019-04-01','2020-04-01','PT10008','B10008'),
('C10104','P10035','DT10002','2019-04-01','2020-04-01','PT10009','B10008'),
('C10105','P10036','DT10003','2019-04-01','2020-04-01','PT10004','B10008'),
('C10106','P10037','DT10004','2019-04-01','2020-04-01','PT10005','B10008'),
('C10107','P10025','DT10005','2019-04-01','2020-04-01','PT10006','B10008'),
('C10108','P10014','DT10006','2019-04-01','2020-04-01','PT10007','B10008'),
('C10109','P10021','DT10007','2019-04-01','2020-04-01','PT10008','B10008'),
('C10110','P10022','DT10001','2019-04-01','2020-04-01','PT10009','B10008'),
('C10111','P10016','DT10002','2019-04-01','2020-04-01','PT10010','B10008'),
('C10112','P10017','DT10003','2019-04-01','2020-04-01','PT10009','B10009'),
('C10113','P10018','DT10004','2019-04-01','2020-04-01','PT10006','B10009'),
('C10114','P10010','DT10005','2019-04-01','2020-04-01','PT10007','B10009'),
('C10115','P10011','DT10006','2019-04-01','2020-04-01','PT10008','B10009'),
('C10116','P10012','DT10007','2019-04-01','2020-04-01','PT10009','B10009'),
('C10117','P10006','DT10008','2019-04-01','2020-04-01','PT10004','B10009'),
('C10118','P10001','DT10009','2019-04-01','2020-04-01','PT10005','B10009'),
('C10119','P10003','DT10010','2019-04-01','2020-04-01','PT10006','B10009'),
('C10120','P10004','DT10010','2019-04-01','2020-04-01','PT10007','B10009')
GO

 ----------------------------Table 16-------------------------------------
 -----------------------Insert into Enrollment---------------------------

 INSERT INTO dbo.Enrollment VALUES('Er10001','CLS10001','C10001');
INSERT INTO dbo.Enrollment VALUES('Er10002','CLS10001','C10002');
INSERT INTO dbo.Enrollment VALUES('Er10003','CLS10001','C10003');
INSERT INTO dbo.Enrollment VALUES('Er10004','CLS10001','C10004');
INSERT INTO dbo.Enrollment VALUES('Er10005','CLS10001','C10005');
INSERT INTO dbo.Enrollment VALUES('Er10006','CLS10001','C10006');
INSERT INTO dbo.Enrollment VALUES('Er10007','CLS10001','C10007');
INSERT INTO dbo.Enrollment VALUES('Er10008','CLS10001','C10008');
INSERT INTO dbo.Enrollment VALUES('Er10009','CLS10001','C10009');
INSERT INTO dbo.Enrollment VALUES('Er10010','CLS10001','C10010');
INSERT INTO dbo.Enrollment VALUES('Er10011','CLS10001','C10011');
INSERT INTO dbo.Enrollment VALUES('Er10012','CLS10001','C10012');
INSERT INTO dbo.Enrollment VALUES('Er10013','CLS10001','C10013');
INSERT INTO dbo.Enrollment VALUES('Er10014','CLS10002','C10003');
INSERT INTO dbo.Enrollment VALUES('Er10015','CLS10002','C10004');
INSERT INTO dbo.Enrollment VALUES('Er10016','CLS10002','C10005');
INSERT INTO dbo.Enrollment VALUES('Er10017','CLS10002','C10006');
INSERT INTO dbo.Enrollment VALUES('Er10018','CLS10002','C10007');
INSERT INTO dbo.Enrollment VALUES('Er10019','CLS10002','C10008');
INSERT INTO dbo.Enrollment VALUES('Er10020','CLS10002','C10009');
INSERT INTO dbo.Enrollment VALUES('Er10021','CLS10002','C10010');
INSERT INTO dbo.Enrollment VALUES('Er10022','CLS10002','C10011');
INSERT INTO dbo.Enrollment VALUES('Er10023','CLS10002','C10012');
INSERT INTO dbo.Enrollment VALUES('Er10024','CLS10002','C10013');
INSERT INTO dbo.Enrollment VALUES('Er10025','CLS10003','C10040');
INSERT INTO dbo.Enrollment VALUES('Er10026','CLS10003','C10041');
INSERT INTO dbo.Enrollment VALUES('Er10027','CLS10003','C10042');
INSERT INTO dbo.Enrollment VALUES('Er10028','CLS10003','C10043');
INSERT INTO dbo.Enrollment VALUES('Er10029','CLS10003','C10044');
INSERT INTO dbo.Enrollment VALUES('Er10030','CLS10003','C10045');
INSERT INTO dbo.Enrollment VALUES('Er10031','CLS10003','C10046');
INSERT INTO dbo.Enrollment VALUES('Er10032','CLS10003','C10047');
INSERT INTO dbo.Enrollment VALUES('Er10033','CLS10003','C10048');
INSERT INTO dbo.Enrollment VALUES('Er10034','CLS10003','C10049');
INSERT INTO dbo.Enrollment VALUES('Er10035','CLS10003','C10050');
INSERT INTO dbo.Enrollment VALUES('Er10036','CLS10003','C10051');
INSERT INTO dbo.Enrollment VALUES('Er10037','CLS10004','C10040');
INSERT INTO dbo.Enrollment VALUES('Er10038','CLS10004','C10041');
INSERT INTO dbo.Enrollment VALUES('Er10039','CLS10004','C10042');
INSERT INTO dbo.Enrollment VALUES('Er10040','CLS10004','C10043');
INSERT INTO dbo.Enrollment VALUES('Er10041','CLS10004','C10044');
INSERT INTO dbo.Enrollment VALUES('Er10042','CLS10004','C10045');
INSERT INTO dbo.Enrollment VALUES('Er10043','CLS10004','C10046');
INSERT INTO dbo.Enrollment VALUES('Er10044','CLS10004','C10047');
INSERT INTO dbo.Enrollment VALUES('Er10045','CLS10004','C10048');
INSERT INTO dbo.Enrollment VALUES('Er10046','CLS10004','C10049');
INSERT INTO dbo.Enrollment VALUES('Er10047','CLS10004','C10050');
INSERT INTO dbo.Enrollment VALUES('Er10048','CLS10004','C10051');
INSERT INTO dbo.Enrollment VALUES('Er10049','CLS10005','C10068');
INSERT INTO dbo.Enrollment VALUES('Er10050','CLS10005','C10069');
INSERT INTO dbo.Enrollment VALUES('Er10051','CLS10005','C10070');
INSERT INTO dbo.Enrollment VALUES('Er10052','CLS10005','C10071');
INSERT INTO dbo.Enrollment VALUES('Er10053','CLS10005','C10072');
INSERT INTO dbo.Enrollment VALUES('Er10054','CLS10005','C10073');
INSERT INTO dbo.Enrollment VALUES('Er10055','CLS10005','C10074');
INSERT INTO dbo.Enrollment VALUES('Er10056','CLS10005','C10075');
INSERT INTO dbo.Enrollment VALUES('Er10057','CLS10005','C10076');
INSERT INTO dbo.Enrollment VALUES('Er10058','CLS10005','C10077');
INSERT INTO dbo.Enrollment VALUES('Er10059','CLS10005','C10078');
INSERT INTO dbo.Enrollment VALUES('Er10060','CLS10005','C10079');
INSERT INTO dbo.Enrollment VALUES('Er10061','CLS10005','C10080');
INSERT INTO dbo.Enrollment VALUES('Er10062','CLS10005','C10081');
INSERT INTO dbo.Enrollment VALUES('Er10063','CLS10005','C10082');
INSERT INTO dbo.Enrollment VALUES('Er10064','CLS10005','C10083');
INSERT INTO dbo.Enrollment VALUES('Er10065','CLS10005','C10084');
INSERT INTO dbo.Enrollment VALUES('Er10066','CLS10005','C10068');
INSERT INTO dbo.Enrollment VALUES('Er10067','CLS10005','C10069');
INSERT INTO dbo.Enrollment VALUES('Er10068','CLS10005','C10070');
INSERT INTO dbo.Enrollment VALUES('Er10069','CLS10005','C10071');
INSERT INTO dbo.Enrollment VALUES('Er10070','CLS10006','C10075');
INSERT INTO dbo.Enrollment VALUES('Er10071','CLS10006','C10076');
INSERT INTO dbo.Enrollment VALUES('Er10072','CLS10006','C10077');
INSERT INTO dbo.Enrollment VALUES('Er10073','CLS10006','C10078');
INSERT INTO dbo.Enrollment VALUES('Er10074','CLS10006','C10079');
INSERT INTO dbo.Enrollment VALUES('Er10075','CLS10006','C10080');
INSERT INTO dbo.Enrollment VALUES('Er10076','CLS10006','C10081');
INSERT INTO dbo.Enrollment VALUES('Er10077','CLS10006','C10082');
INSERT INTO dbo.Enrollment VALUES('Er10078','CLS10006','C10083');
INSERT INTO dbo.Enrollment VALUES('Er10079','CLS10007','C10052');
INSERT INTO dbo.Enrollment VALUES('Er10080','CLS10007','C10053');
INSERT INTO dbo.Enrollment VALUES('Er10081','CLS10007','C10054');
INSERT INTO dbo.Enrollment VALUES('Er10082','CLS10007','C10055');
INSERT INTO dbo.Enrollment VALUES('Er10083','CLS10007','C10056');
INSERT INTO dbo.Enrollment VALUES('Er10084','CLS10007','C10057');
INSERT INTO dbo.Enrollment VALUES('Er10085','CLS10007','C10058');
INSERT INTO dbo.Enrollment VALUES('Er10086','CLS10007','C10059');
INSERT INTO dbo.Enrollment VALUES('Er10087','CLS10007','C10060');
INSERT INTO dbo.Enrollment VALUES('Er10088','CLS10007','C10061');
INSERT INTO dbo.Enrollment VALUES('Er10089','CLS10007','C10062');
INSERT INTO dbo.Enrollment VALUES('Er10090','CLS10007','C10063');
INSERT INTO dbo.Enrollment VALUES('Er10091','CLS10008','C10052');
INSERT INTO dbo.Enrollment VALUES('Er10092','CLS10008','C10053');
INSERT INTO dbo.Enrollment VALUES('Er10093','CLS10008','C10054');
INSERT INTO dbo.Enrollment VALUES('Er10094','CLS10008','C10055');
INSERT INTO dbo.Enrollment VALUES('Er10095','CLS10008','C10056');
INSERT INTO dbo.Enrollment VALUES('Er10096','CLS10008','C10057');
INSERT INTO dbo.Enrollment VALUES('Er10097','CLS10008','C10058');
INSERT INTO dbo.Enrollment VALUES('Er10098','CLS10008','C10059');
INSERT INTO dbo.Enrollment VALUES('Er10099','CLS10008','C10060');
INSERT INTO dbo.Enrollment VALUES('Er10100','CLS10008','C10061');
INSERT INTO dbo.Enrollment VALUES('Er10101','CLS10008','C10062');
INSERT INTO dbo.Enrollment VALUES('Er10102','CLS10008','C10063');
INSERT INTO dbo.Enrollment VALUES('Er10103','CLS10009','C10034');
INSERT INTO dbo.Enrollment VALUES('Er10104','CLS10009','C10035');
INSERT INTO dbo.Enrollment VALUES('Er10105','CLS10009','C10036');
INSERT INTO dbo.Enrollment VALUES('Er10106','CLS10009','C10037');
INSERT INTO dbo.Enrollment VALUES('Er10107','CLS10009','C10038');
INSERT INTO dbo.Enrollment VALUES('Er10108','CLS10009','C10039');
INSERT INTO dbo.Enrollment VALUES('Er10109','CLS10010','C10034');
INSERT INTO dbo.Enrollment VALUES('Er10110','CLS10010','C10035');
INSERT INTO dbo.Enrollment VALUES('Er10111','CLS10010','C10036');
INSERT INTO dbo.Enrollment VALUES('Er10112','CLS10010','C10037');
INSERT INTO dbo.Enrollment VALUES('Er10113','CLS10010','C10038');
INSERT INTO dbo.Enrollment VALUES('Er10114','CLS10010','C10039');
INSERT INTO dbo.Enrollment VALUES('Er10115','CLS10011','C10064');
INSERT INTO dbo.Enrollment VALUES('Er10116','CLS10011','C10065');
INSERT INTO dbo.Enrollment VALUES('Er10117','CLS10011','C10066');
INSERT INTO dbo.Enrollment VALUES('Er10118','CLS10011','C10067');
INSERT INTO dbo.Enrollment VALUES('Er10119','CLS10012','C10064');
INSERT INTO dbo.Enrollment VALUES('Er10120','CLS10012','C10065');
INSERT INTO dbo.Enrollment VALUES('Er10121','CLS10012','C10066');
INSERT INTO dbo.Enrollment VALUES('Er10122','CLS10012','C10067');
INSERT INTO dbo.Enrollment VALUES('Er10123','CLS10013','C10085');
INSERT INTO dbo.Enrollment VALUES('Er10124','CLS10013','C10086');
INSERT INTO dbo.Enrollment VALUES('Er10125','CLS10013','C10087');
INSERT INTO dbo.Enrollment VALUES('Er10126','CLS10013','C10088');
INSERT INTO dbo.Enrollment VALUES('Er10127','CLS10013','C10089');
INSERT INTO dbo.Enrollment VALUES('Er10128','CLS10013','C10090');
INSERT INTO dbo.Enrollment VALUES('Er10129','CLS10013','C10091');
INSERT INTO dbo.Enrollment VALUES('Er10130','CLS10013','C10092');
INSERT INTO dbo.Enrollment VALUES('Er10131','CLS10013','C10093');
INSERT INTO dbo.Enrollment VALUES('Er10132','CLS10013','C10094');
INSERT INTO dbo.Enrollment VALUES('Er10133','CLS10013','C10095');
INSERT INTO dbo.Enrollment VALUES('Er10134','CLS10014','C10086');
INSERT INTO dbo.Enrollment VALUES('Er10135','CLS10014','C10087');
INSERT INTO dbo.Enrollment VALUES('Er10136','CLS10014','C10088');
INSERT INTO dbo.Enrollment VALUES('Er10137','CLS10014','C10089');
INSERT INTO dbo.Enrollment VALUES('Er10138','CLS10014','C10090');
INSERT INTO dbo.Enrollment VALUES('Er10139','CLS10014','C10091');
INSERT INTO dbo.Enrollment VALUES('Er10140','CLS10014','C10092');
INSERT INTO dbo.Enrollment VALUES('Er10141','CLS10014','C10093');
INSERT INTO dbo.Enrollment VALUES('Er10142','CLS10015','C10096');
INSERT INTO dbo.Enrollment VALUES('Er10143','CLS10015','C10097');
INSERT INTO dbo.Enrollment VALUES('Er10144','CLS10015','C10098');
INSERT INTO dbo.Enrollment VALUES('Er10145','CLS10015','C10099');
INSERT INTO dbo.Enrollment VALUES('Er10146','CLS10015','C10100');
INSERT INTO dbo.Enrollment VALUES('Er10147','CLS10015','C10101');
INSERT INTO dbo.Enrollment VALUES('Er10148','CLS10015','C10102');
INSERT INTO dbo.Enrollment VALUES('Er10149','CLS10015','C10103');
INSERT INTO dbo.Enrollment VALUES('Er10150','CLS10015','C10104');
INSERT INTO dbo.Enrollment VALUES('Er10151','CLS10015','C10105');
INSERT INTO dbo.Enrollment VALUES('Er10152','CLS10015','C10106');
INSERT INTO dbo.Enrollment VALUES('Er10153','CLS10015','C10107');
INSERT INTO dbo.Enrollment VALUES('Er10154','CLS10015','C10108');
INSERT INTO dbo.Enrollment VALUES('Er10155','CLS10015','C10109');
INSERT INTO dbo.Enrollment VALUES('Er10156','CLS10015','C10110');
INSERT INTO dbo.Enrollment VALUES('Er10157','CLS10015','C10111');
INSERT INTO dbo.Enrollment VALUES('Er10158','CLS10016','C10096');
INSERT INTO dbo.Enrollment VALUES('Er10159','CLS10016','C10097');
INSERT INTO dbo.Enrollment VALUES('Er10160','CLS10016','C10098');
INSERT INTO dbo.Enrollment VALUES('Er10161','CLS10016','C10099');
INSERT INTO dbo.Enrollment VALUES('Er10162','CLS10016','C10100');
INSERT INTO dbo.Enrollment VALUES('Er10163','CLS10016','C10101');
INSERT INTO dbo.Enrollment VALUES('Er10164','CLS10016','C10102');
INSERT INTO dbo.Enrollment VALUES('Er10165','CLS10016','C10103');
INSERT INTO dbo.Enrollment VALUES('Er10166','CLS10016','C10104');
INSERT INTO dbo.Enrollment VALUES('Er10167','CLS10016','C10105');
INSERT INTO dbo.Enrollment VALUES('Er10168','CLS10016','C10106');
INSERT INTO dbo.Enrollment VALUES('Er10169','CLS10016','C10107');
INSERT INTO dbo.Enrollment VALUES('Er10170','CLS10016','C10108');
INSERT INTO dbo.Enrollment VALUES('Er10171','CLS10016','C10109');
INSERT INTO dbo.Enrollment VALUES('Er10172','CLS10016','C10110');
INSERT INTO dbo.Enrollment VALUES('Er10173','CLS10017','C10112');
INSERT INTO dbo.Enrollment VALUES('Er10174','CLS10017','C10113');
INSERT INTO dbo.Enrollment VALUES('Er10175','CLS10017','C10114');
INSERT INTO dbo.Enrollment VALUES('Er10176','CLS10017','C10115');
INSERT INTO dbo.Enrollment VALUES('Er10177','CLS10017','C10116');
INSERT INTO dbo.Enrollment VALUES('Er10178','CLS10017','C10117');
INSERT INTO dbo.Enrollment VALUES('Er10179','CLS10017','C10118');
INSERT INTO dbo.Enrollment VALUES('Er10180','CLS10017','C10119');
INSERT INTO dbo.Enrollment VALUES('Er10181','CLS10017','C10120');
INSERT INTO dbo.Enrollment VALUES('Er10182','CLS10018','C10112');
INSERT INTO dbo.Enrollment VALUES('Er10183','CLS10018','C10113');
INSERT INTO dbo.Enrollment VALUES('Er10184','CLS10018','C10114');
INSERT INTO dbo.Enrollment VALUES('Er10185','CLS10018','C10115');
INSERT INTO dbo.Enrollment VALUES('Er10186','CLS10018','C10116');
INSERT INTO dbo.Enrollment VALUES('Er10187','CLS10018','C10117');
INSERT INTO dbo.Enrollment VALUES('Er10188','CLS10018','C10118');
INSERT INTO dbo.Enrollment VALUES('Er10189','CLS10018','C10119');
INSERT INTO dbo.Enrollment VALUES('Er10190','CLS10018','C10120');
INSERT INTO dbo.Enrollment VALUES('Er10191','CLS10019','C10014');
INSERT INTO dbo.Enrollment VALUES('Er10192','CLS10019','C10015');
INSERT INTO dbo.Enrollment VALUES('Er10193','CLS10019','C10016');
INSERT INTO dbo.Enrollment VALUES('Er10194','CLS10019','C10017');
INSERT INTO dbo.Enrollment VALUES('Er10195','CLS10019','C10018');
INSERT INTO dbo.Enrollment VALUES('Er10196','CLS10019','C10019');
INSERT INTO dbo.Enrollment VALUES('Er10197','CLS10019','C10020');
INSERT INTO dbo.Enrollment VALUES('Er10198','CLS10019','C10021');
INSERT INTO dbo.Enrollment VALUES('Er10199','CLS10019','C10022');
INSERT INTO dbo.Enrollment VALUES('Er10200','CLS10019','C10023');
INSERT INTO dbo.Enrollment VALUES('Er10201','CLS10019','C10024');
INSERT INTO dbo.Enrollment VALUES('Er10202','CLS10019','C10025');
INSERT INTO dbo.Enrollment VALUES('Er10203','CLS10019','C10026');
INSERT INTO dbo.Enrollment VALUES('Er10204','CLS10019','C10027');
INSERT INTO dbo.Enrollment VALUES('Er10205','CLS10019','C10028');
INSERT INTO dbo.Enrollment VALUES('Er10206','CLS10019','C10029');
INSERT INTO dbo.Enrollment VALUES('Er10207','CLS10019','C10030');
INSERT INTO dbo.Enrollment VALUES('Er10208','CLS10019','C10031');
INSERT INTO dbo.Enrollment VALUES('Er10209','CLS10019','C10032');
INSERT INTO dbo.Enrollment VALUES('Er10210','CLS10019','C10033');
INSERT INTO dbo.Enrollment VALUES('Er10211','CLS10020','C10014');
INSERT INTO dbo.Enrollment VALUES('Er10212','CLS10020','C10015');
INSERT INTO dbo.Enrollment VALUES('Er10213','CLS10020','C10016');
INSERT INTO dbo.Enrollment VALUES('Er10214','CLS10020','C10017');
INSERT INTO dbo.Enrollment VALUES('Er10215','CLS10020','C10018');
INSERT INTO dbo.Enrollment VALUES('Er10216','CLS10020','C10019');
INSERT INTO dbo.Enrollment VALUES('Er10217','CLS10020','C10020');
INSERT INTO dbo.Enrollment VALUES('Er10218','CLS10020','C10021');
INSERT INTO dbo.Enrollment VALUES('Er10219','CLS10020','C10022');
INSERT INTO dbo.Enrollment VALUES('Er10220','CLS10020','C10023');
INSERT INTO dbo.Enrollment VALUES('Er10221','CLS10020','C10024');
INSERT INTO dbo.Enrollment VALUES('Er10222','CLS10020','C10025');
INSERT INTO dbo.Enrollment VALUES('Er10223','CLS10020','C10026');
INSERT INTO dbo.Enrollment VALUES('Er10224','CLS10020','C10027');
INSERT INTO dbo.Enrollment VALUES('Er10225','CLS10020','C10028');
INSERT INTO dbo.Enrollment VALUES('Er10226','CLS10020','C10029');
INSERT INTO dbo.Enrollment VALUES('Er10227','CLS10020','C10030');
INSERT INTO dbo.Enrollment VALUES('Er10228','CLS10020','C10031');

 ----------------------------Table 17----------------------------------------
 -----------------------Insert into BillingRecord----------------------------

 INSERT INTO [dbo].[BillingRecord]
           ([BillingRecordId]
           ,[CustomerId]
           ,[BillingDate])
     VALUES          
		('BREC10001','C10001','2019-05-01'),
('BREC10002','C10002','2019-05-01'),
('BREC10003','C10003','2019-05-01'),
('BREC10004','C10004','2019-05-01'),
('BREC10005','C10005','2019-05-01'),
('BREC10006','C10006','2019-05-01'),
('BREC10007','C10007','2019-05-01'),
('BREC10008','C10008','2019-05-01'),
('BREC10009','C10009','2019-05-01'),
('BREC10010','C10010','2019-05-01'),
('BREC10011','C10011','2019-05-01'),
('BREC10012','C10012','2019-05-01'),
('BREC10013','C10013','2019-05-01'),
('BREC10014','C10014','2019-05-01'),
('BREC10015','C10015','2019-05-01'),
('BREC10016','C10016','2019-05-01'),
('BREC10017','C10017','2019-05-01'),
('BREC10018','C10018','2019-05-01'),
('BREC10019','C10019','2019-05-01'),
('BREC10020','C10020','2019-05-01'),
('BREC10021','C10021','2019-05-01'),
('BREC10022','C10022','2019-05-01'),
('BREC10023','C10023','2019-05-01'),
('BREC10024','C10024','2019-05-01'),
('BREC10025','C10025','2019-05-01'),
('BREC10026','C10026','2019-05-01'),
('BREC10027','C10027','2019-05-01'),
('BREC10028','C10028','2019-05-01'),
('BREC10029','C10029','2019-05-01'),
('BREC10030','C10030','2019-05-01'),
('BREC10031','C10031','2019-05-01'),
('BREC10032','C10032','2019-05-01'),
('BREC10033','C10033','2019-05-01'),
('BREC10034','C10034','2019-05-01'),
('BREC10035','C10035','2019-05-01'),
('BREC10036','C10036','2019-05-01'),
('BREC10037','C10037','2019-05-01'),
('BREC10038','C10038','2019-05-01'),
('BREC10039','C10039','2019-05-01'),
('BREC10040','C10040','2019-05-01'),
('BREC10041','C10041','2019-05-01'),
('BREC10042','C10042','2019-05-01'),
('BREC10043','C10043','2019-05-01'),
('BREC10044','C10044','2019-05-01'),
('BREC10045','C10045','2019-05-01'),
('BREC10046','C10046','2019-05-01'),
('BREC10047','C10047','2019-05-01'),
('BREC10048','C10048','2019-05-01'),
('BREC10049','C10049','2019-05-01'),
('BREC10050','C10050','2019-05-01'),
('BREC10051','C10051','2019-05-01'),
('BREC10052','C10052','2019-05-01'),
('BREC10053','C10053','2019-05-01'),
('BREC10054','C10054','2019-05-01'),
('BREC10055','C10055','2019-05-01'),
('BREC10056','C10056','2019-05-01'),
('BREC10057','C10057','2019-05-01'),
('BREC10058','C10058','2019-05-01'),
('BREC10059','C10059','2019-05-01'),
('BREC10060','C10060','2019-05-01'),
('BREC10061','C10061','2019-05-01'),
('BREC10062','C10062','2019-05-01'),
('BREC10063','C10063','2019-05-01'),
('BREC10064','C10064','2019-05-01'),
('BREC10065','C10065','2019-05-01'),
('BREC10066','C10066','2019-05-01'),
('BREC10067','C10067','2019-05-01'),
('BREC10068','C10068','2019-05-01'),
('BREC10069','C10069','2019-05-01'),
('BREC10070','C10070','2019-05-01'),
('BREC10071','C10071','2019-05-01'),
('BREC10072','C10072','2019-05-01'),
('BREC10073','C10073','2019-05-01'),
('BREC10074','C10074','2019-05-01'),
('BREC10075','C10075','2019-05-01'),
('BREC10076','C10076','2019-05-01'),
('BREC10077','C10077','2019-05-01'),
('BREC10078','C10078','2019-05-01'),
('BREC10079','C10079','2019-05-01'),
('BREC10080','C10080','2019-05-01'),
('BREC10081','C10081','2019-05-01'),
('BREC10082','C10082','2019-05-01'),
('BREC10083','C10083','2019-05-01'),
('BREC10084','C10084','2019-05-01'),
('BREC10085','C10085','2019-05-01'),
('BREC10086','C10086','2019-05-01'),
('BREC10087','C10087','2019-05-01'),
('BREC10088','C10088','2019-05-01'),
('BREC10089','C10089','2019-05-01'),
('BREC10090','C10090','2019-05-01'),
('BREC10091','C10091','2019-05-01'),
('BREC10092','C10092','2019-05-01'),
('BREC10093','C10093','2019-05-01'),
('BREC10094','C10094','2019-05-01'),
('BREC10095','C10095','2019-05-01'),
('BREC10096','C10096','2019-05-01'),
('BREC10097','C10097','2019-05-01'),
('BREC10098','C10098','2019-05-01'),
('BREC10099','C10099','2019-05-01'),
('BREC10100','C10100','2019-05-01'),
('BREC10101','C10101','2019-05-01'),
('BREC10102','C10102','2019-05-01'),
('BREC10103','C10103','2019-05-01'),
('BREC10104','C10104','2019-05-01'),
('BREC10105','C10105','2019-05-01'),
('BREC10106','C10106','2019-05-01'),
('BREC10107','C10107','2019-05-01'),
('BREC10108','C10108','2019-05-01'),
('BREC10109','C10109','2019-05-01'),
('BREC10110','C10110','2019-05-01'),
('BREC10111','C10111','2019-05-01'),
('BREC10112','C10112','2019-05-01'),
('BREC10113','C10113','2019-05-01'),
('BREC10114','C10114','2019-05-01'),
('BREC10115','C10115','2019-05-01'),
('BREC10116','C10116','2019-05-01'),
('BREC10117','C10117','2019-05-01'),
('BREC10118','C10118','2019-05-01'),
('BREC10119','C10119','2019-05-01'),
('BREC10120','C10120','2019-05-01'),
('BREC10121','C10001','2019-06-01'),
('BREC10122','C10002','2019-06-01'),
('BREC10123','C10003','2019-06-01'),
('BREC10124','C10004','2019-06-01'),
('BREC10125','C10005','2019-06-01'),
('BREC10126','C10006','2019-06-01'),
('BREC10127','C10007','2019-06-01'),
('BREC10128','C10008','2019-06-01'),
('BREC10129','C10009','2019-06-01'),
('BREC10130','C10010','2019-06-01'),
('BREC10131','C10011','2019-06-01'),
('BREC10132','C10012','2019-06-01'),
('BREC10133','C10013','2019-06-01'),
('BREC10134','C10014','2019-06-01'),
('BREC10135','C10015','2019-06-01'),
('BREC10136','C10016','2019-06-01'),
('BREC10137','C10017','2019-06-01'),
('BREC10138','C10018','2019-06-01'),
('BREC10139','C10019','2019-06-01'),
('BREC10140','C10020','2019-06-01'),
('BREC10141','C10021','2019-06-01'),
('BREC10142','C10022','2019-06-01'),
('BREC10143','C10023','2019-06-01'),
('BREC10144','C10024','2019-06-01'),
('BREC10145','C10025','2019-06-01'),
('BREC10146','C10026','2019-06-01'),
('BREC10147','C10027','2019-06-01'),
('BREC10148','C10028','2019-06-01'),
('BREC10149','C10029','2019-06-01'),
('BREC10150','C10030','2019-06-01'),
('BREC10151','C10031','2019-06-01'),
('BREC10152','C10032','2019-06-01'),
('BREC10153','C10033','2019-06-01'),
('BREC10154','C10034','2019-06-01'),
('BREC10155','C10035','2019-06-01'),
('BREC10156','C10036','2019-06-01'),
('BREC10157','C10037','2019-06-01'),
('BREC10158','C10038','2019-06-01'),
('BREC10159','C10039','2019-06-01'),
('BREC10160','C10040','2019-06-01'),
('BREC10161','C10041','2019-06-01'),
('BREC10162','C10042','2019-06-01'),
('BREC10163','C10043','2019-06-01'),
('BREC10164','C10044','2019-06-01'),
('BREC10165','C10045','2019-06-01'),
('BREC10166','C10046','2019-06-01'),
('BREC10167','C10047','2019-06-01'),
('BREC10168','C10048','2019-06-01'),
('BREC10169','C10049','2019-06-01'),
('BREC10170','C10050','2019-06-01'),
('BREC10171','C10051','2019-06-01'),
('BREC10172','C10052','2019-06-01'),
('BREC10173','C10053','2019-06-01'),
('BREC10174','C10054','2019-06-01'),
('BREC10175','C10055','2019-06-01'),
('BREC10176','C10056','2019-06-01'),
('BREC10177','C10057','2019-06-01'),
('BREC10178','C10058','2019-06-01'),
('BREC10179','C10059','2019-06-01'),
('BREC10180','C10060','2019-06-01'),
('BREC10181','C10061','2019-06-01'),
('BREC10182','C10062','2019-06-01'),
('BREC10183','C10063','2019-06-01'),
('BREC10184','C10064','2019-06-01'),
('BREC10185','C10065','2019-06-01'),
('BREC10186','C10066','2019-06-01'),
('BREC10187','C10067','2019-06-01'),
('BREC10188','C10068','2019-06-01'),
('BREC10189','C10069','2019-06-01'),
('BREC10190','C10070','2019-06-01'),
('BREC10191','C10071','2019-06-01'),
('BREC10192','C10072','2019-06-01'),
('BREC10193','C10073','2019-06-01'),
('BREC10194','C10074','2019-06-01'),
('BREC10195','C10075','2019-06-01'),
('BREC10196','C10076','2019-06-01'),
('BREC10197','C10077','2019-06-01'),
('BREC10198','C10078','2019-06-01'),
('BREC10199','C10079','2019-06-01'),
('BREC10200','C10080','2019-06-01'),
('BREC10201','C10081','2019-06-01'),
('BREC10202','C10082','2019-06-01'),
('BREC10203','C10083','2019-06-01'),
('BREC10204','C10084','2019-06-01'),
('BREC10205','C10085','2019-06-01'),
('BREC10206','C10086','2019-06-01'),
('BREC10207','C10087','2019-06-01'),
('BREC10208','C10088','2019-06-01'),
('BREC10209','C10089','2019-06-01'),
('BREC10210','C10090','2019-06-01'),
('BREC10211','C10091','2019-06-01'),
('BREC10212','C10092','2019-06-01'),
('BREC10213','C10093','2019-06-01'),
('BREC10214','C10094','2019-06-01'),
('BREC10215','C10095','2019-06-01'),
('BREC10216','C10096','2019-06-01'),
('BREC10217','C10097','2019-06-01'),
('BREC10218','C10098','2019-06-01'),
('BREC10219','C10099','2019-06-01'),
('BREC10220','C10100','2019-06-01'),
('BREC10221','C10101','2019-06-01'),
('BREC10222','C10102','2019-06-01'),
('BREC10223','C10103','2019-06-01'),
('BREC10224','C10104','2019-06-01'),
('BREC10225','C10105','2019-06-01'),
('BREC10226','C10106','2019-06-01'),
('BREC10227','C10107','2019-06-01'),
('BREC10228','C10108','2019-06-01'),
('BREC10229','C10109','2019-06-01'),
('BREC10230','C10110','2019-06-01'),
('BREC10231','C10111','2019-06-01'),
('BREC10232','C10112','2019-06-01'),
('BREC10233','C10113','2019-06-01'),
('BREC10234','C10114','2019-06-01'),
('BREC10235','C10115','2019-06-01'),
('BREC10236','C10116','2019-06-01'),
('BREC10237','C10117','2019-06-01'),
('BREC10238','C10118','2019-06-01'),
('BREC10239','C10119','2019-06-01'),
('BREC10240','C10120','2019-06-01'),
('BREC10241','C10001','2019-07-01'),
('BREC10242','C10002','2019-07-01'),
('BREC10243','C10003','2019-07-01'),
('BREC10244','C10004','2019-07-01'),
('BREC10245','C10005','2019-07-01'),
('BREC10246','C10006','2019-07-01'),
('BREC10247','C10007','2019-07-01'),
('BREC10248','C10008','2019-07-01'),
('BREC10249','C10009','2019-07-01'),
('BREC10250','C10010','2019-07-01'),
('BREC10251','C10011','2019-07-01'),
('BREC10252','C10012','2019-07-01'),
('BREC10253','C10013','2019-07-01'),
('BREC10254','C10014','2019-07-01'),
('BREC10255','C10015','2019-07-01'),
('BREC10256','C10016','2019-07-01'),
('BREC10257','C10017','2019-07-01'),
('BREC10258','C10018','2019-07-01'),
('BREC10259','C10019','2019-07-01'),
('BREC10260','C10020','2019-07-01'),
('BREC10261','C10021','2019-07-01'),
('BREC10262','C10022','2019-07-01'),
('BREC10263','C10023','2019-07-01'),
('BREC10264','C10024','2019-07-01'),
('BREC10265','C10025','2019-07-01'),
('BREC10266','C10026','2019-07-01'),
('BREC10267','C10027','2019-07-01'),
('BREC10268','C10028','2019-07-01'),
('BREC10269','C10029','2019-07-01'),
('BREC10270','C10030','2019-07-01'),
('BREC10271','C10031','2019-07-01'),
('BREC10272','C10032','2019-07-01'),
('BREC10273','C10033','2019-07-01'),
('BREC10274','C10034','2019-07-01'),
('BREC10275','C10035','2019-07-01'),
('BREC10276','C10036','2019-07-01'),
('BREC10277','C10037','2019-07-01'),
('BREC10278','C10038','2019-07-01'),
('BREC10279','C10039','2019-07-01'),
('BREC10280','C10040','2019-07-01'),
('BREC10281','C10041','2019-07-01'),
('BREC10282','C10042','2019-07-01'),
('BREC10283','C10043','2019-07-01'),
('BREC10284','C10044','2019-07-01'),
('BREC10285','C10045','2019-07-01'),
('BREC10286','C10046','2019-07-01'),
('BREC10287','C10047','2019-07-01'),
('BREC10288','C10048','2019-07-01'),
('BREC10289','C10049','2019-07-01'),
('BREC10290','C10050','2019-07-01'),
('BREC10291','C10051','2019-07-01'),
('BREC10292','C10052','2019-07-01'),
('BREC10293','C10053','2019-07-01'),
('BREC10294','C10054','2019-07-01'),
('BREC10295','C10055','2019-07-01'),
('BREC10296','C10056','2019-07-01'),
('BREC10297','C10057','2019-07-01'),
('BREC10298','C10058','2019-07-01'),
('BREC10299','C10059','2019-07-01'),
('BREC10300','C10060','2019-07-01'),
('BREC10301','C10061','2019-07-01'),
('BREC10302','C10062','2019-07-01'),
('BREC10303','C10063','2019-07-01'),
('BREC10304','C10064','2019-07-01'),
('BREC10305','C10065','2019-07-01'),
('BREC10306','C10066','2019-07-01'),
('BREC10307','C10067','2019-07-01'),
('BREC10308','C10068','2019-07-01'),
('BREC10309','C10069','2019-07-01'),
('BREC10310','C10070','2019-07-01'),
('BREC10311','C10071','2019-07-01'),
('BREC10312','C10072','2019-07-01'),
('BREC10313','C10073','2019-07-01'),
('BREC10314','C10074','2019-07-01'),
('BREC10315','C10075','2019-07-01'),
('BREC10316','C10076','2019-07-01'),
('BREC10317','C10077','2019-07-01'),
('BREC10318','C10078','2019-07-01'),
('BREC10319','C10079','2019-07-01'),
('BREC10320','C10080','2019-07-01'),
('BREC10321','C10081','2019-07-01'),
('BREC10322','C10082','2019-07-01'),
('BREC10323','C10083','2019-07-01'),
('BREC10324','C10084','2019-07-01'),
('BREC10325','C10085','2019-07-01'),
('BREC10326','C10086','2019-07-01'),
('BREC10327','C10087','2019-07-01'),
('BREC10328','C10088','2019-07-01'),
('BREC10329','C10089','2019-07-01'),
('BREC10330','C10090','2019-07-01'),
('BREC10331','C10091','2019-07-01'),
('BREC10332','C10092','2019-07-01'),
('BREC10333','C10093','2019-07-01'),
('BREC10334','C10094','2019-07-01'),
('BREC10335','C10095','2019-07-01'),
('BREC10336','C10096','2019-07-01'),
('BREC10337','C10097','2019-07-01'),
('BREC10338','C10098','2019-07-01'),
('BREC10339','C10099','2019-07-01'),
('BREC10340','C10100','2019-07-01'),
('BREC10341','C10101','2019-07-01'),
('BREC10342','C10102','2019-07-01'),
('BREC10343','C10103','2019-07-01'),
('BREC10344','C10104','2019-07-01'),
('BREC10345','C10105','2019-07-01'),
('BREC10346','C10106','2019-07-01'),
('BREC10347','C10107','2019-07-01'),
('BREC10348','C10108','2019-07-01'),
('BREC10349','C10109','2019-07-01'),
('BREC10350','C10110','2019-07-01'),
('BREC10351','C10111','2019-07-01'),
('BREC10352','C10112','2019-07-01'),
('BREC10353','C10113','2019-07-01'),
('BREC10354','C10114','2019-07-01'),
('BREC10355','C10115','2019-07-01'),
('BREC10356','C10116','2019-07-01'),
('BREC10357','C10117','2019-07-01'),
('BREC10358','C10118','2019-07-01'),
('BREC10359','C10119','2019-07-01'),
('BREC10360','C10120','2019-07-01')
GO

/****************************************COMPUTED COLUMNS************************************************/
/*Computed Columns based on a function
Create a Computed Column in Customer table based on a funtion return the total classes enrollment */

CREATE FUNCTION TotalClassEnrollment
(@InputCustomerId VARCHAR(20))
RETURNS INT
AS
	BEGIN
		DECLARE @TotalEnrollment INT;
		SELECT @TotalEnrollment = COUNT(e.EnrollmentId)
		FROM dbo.Enrollment e
		WHERE e.CustomerId = @InputCustomerId;
		RETURN @TotalEnrollment;
	END
GO

SELECT * FROM dbo.Customer;

ALTER TABLE dbo.Customer
ADD TotalEnrollment AS (dbo.TotalClassEnrollment(CustomerId));

SELECT * FROM dbo.Customer;

/*********************************VIEWS & FUNCTIONS FOR REPORTING PURPOSE********************************/

----------------------------FUNCTION 1-------------------------------
--Function for calculating the profit of Gyms in certain year and month
CREATE FUNCTION ProfitInYearMonth
 (@InputYear INT, @InputMonth INT)
RETURNS INT
AS
	BEGIN
		DECLARE @TotalPaymentToEmployee INT;
		DECLARE @TotalMaintenanceFee INT;
		DECLARE @TotalIncome INT;
	--Calculate the payment to employee
		SELECT @TotalPaymentToEmployee = ISNULL(SUM(jt.Salary), 0)
		FROM dbo.PaymentRecord pr
		LEFT JOIN dbo.Employees e
		ON pr.EmployeeId = e.EmployeeId
		LEFT JOIN dbo.JobTitle jt
		ON e.JobTitleId = jt.JobTitleId
		WHERE DATEPART(YEAR, pr.PaymentDate) = @InputYear 
			AND DATEPART(MONTH, pr.PaymentDate) = @InputMonth;
	--Calculate the equipment Maintainance cost
		SELECT @TotalMaintenanceFee = ISNULL(SUM(mr.MainatainanceCost), 0)
		FROM dbo.MaintainanceRecord mr
		WHERE DATEPART(YEAR, mr.MaintainanceDate) = @InputYear 
			AND DATEPART(MONTH, mr.MaintainanceDate) = @InputMonth;
	--Calculate the income from Customer Membership Fee
		SELECT @TotalIncome = ISNULL(SUM(pt.AmountByMonth - ISNULL(dc.DiscountPrice,0)), 0)
		FROM dbo.BillingRecord br
		LEFT JOIN dbo.Customer c
		ON br.CustomerId = c.CustomerId
		LEFT JOIN dbo.PlanType pt
		ON c.PlanTypeId = pt.PlanTypeId
		LEFT JOIN dbo.Discounts dc
		ON c.DiscountType = dc.DiscountType
		WHERE  DATEPART(YEAR, br.BillingDate) = @InputYear 
			AND DATEPART(MONTH, br.BillingDate) = @InputMonth;
	
		RETURN @TotalIncome - @TotalPaymentToEmployee - @TotalMaintenanceFee;
	END
GO

SELECT dbo.ProfitInYearMonth(2019,5);

DROP FUNCTION ProfitInYearMonth;

----------------------------FUNCTION 2----------------------------------------
/* Function to calculate the certain branch profit in a given month and year*/
CREATE FUNCTION ProfitInYearMonthBranch
 (@InputYear INT, @InputMonth INT, @InputBranch Varchar(15))
RETURNS @BranchProfit TABLE (BranchId VARCHAR(15), TotalPayment INT
		, TotalMaintenanceFee INT, TotalMembershipBill INT, TotalProfit INT)
AS
	BEGIN
		DECLARE @TotalPaymentToEmployee INT;
		DECLARE @TotalMaintenanceFee INT;
		DECLARE @TotalIncome INT;
		DECLARE @TotalProfit INT;
	--Calculate the payment to employee
		SELECT @TotalPaymentToEmployee = ISNULL(SUM(jt.Salary), 0)
		FROM dbo.PaymentRecord pr
		LEFT JOIN dbo.Employees e
		ON pr.EmployeeId = e.EmployeeId
		LEFT JOIN dbo.JobTitle jt
		ON e.JobTitleId = jt.JobTitleId
		WHERE DATEPART(YEAR, pr.PaymentDate) = @InputYear 
			AND DATEPART(MONTH, pr.PaymentDate) = @InputMonth AND e.BranchId = @InputBranch;
	--Calculate the equipment Maintainance cost
		SELECT @TotalMaintenanceFee = ISNULL(SUM(mr.MainatainanceCost), 0)
		FROM dbo.Equipment eq
		LEFT JOIN dbo.MaintainanceRecord mr
		ON eq.EquipmentId = mr.EquipmentId
		WHERE DATEPART(YEAR, mr.MaintainanceDate) = @InputYear 
			AND DATEPART(MONTH, mr.MaintainanceDate) = @InputMonth AND eq.BranchId = @InputBranch;
	--Calculate the income from Customer Membership Fee
		SELECT @TotalIncome = ISNULL(SUM(pt.AmountByMonth - ISNULL(dc.DiscountPrice,0)), 0)
		FROM dbo.BillingRecord br
		LEFT JOIN dbo.Customer c
		ON br.CustomerId = c.CustomerId
		LEFT JOIN dbo.PlanType pt
		ON c.PlanTypeId = pt.PlanTypeId
		LEFT JOIN dbo.Discounts dc
		ON c.DiscountType = dc.DiscountType
		WHERE  DATEPART(YEAR, br.BillingDate) = @InputYear 
			AND DATEPART(MONTH, br.BillingDate) = @InputMonth AND c.BranchID = @InputBranch;
		SET @TotalProfit = @TotalIncome - @TotalMaintenanceFee - @TotalPaymentToEmployee;
		
		INSERT INTO @BranchProfit VALUES(@InputBranch,@TotalPaymentToEmployee,
					@TotalMaintenanceFee,@TotalIncome,@TotalProfit);
		RETURN;
	END
GO

DROP FUNCTION ProfitInYearMonthBranch;


----------------------------View 1-----------------------------------------------
/*Create a View to show the fitness classes enrollments records from high to low,
	show the ClassId, ProgramName and the total enrollments number, 
	show the view and order by enrollments number from high to low
	*/
CREATE VIEW [Classes popularity] AS
	SELECT  cl.ClassId, cl.ProgramName, COUNT(en.EnrollmentId) AS [Total Enrollment]
	FROM dbo.Classes cl
	JOIN dbo.Enrollment en
	ON cl.ClassId = en.ClassId
	GROUP BY cl.ClassId, cl.ProgramName;

--Select from the view
SELECT * FROM [Classes popularity]
ORDER BY [Total Enrollment] DESC;

--Drop the view
DROP VIEW [Classes popularity];


----------------------------View 2-----------------------------------------------
/* Create a View to show the frequency of equipment maintenance grouping by EquimentCatagory,
	show the EquipmentCatagoryId, CatagoryName, total number of maintenance record,
	order by mantenance records number from high to low
	This view is to report which catagory of equipments is maintained more freguenyly.
	 */
CREATE VIEW [Maintainance Frequency] AS
	SELECT ec.EquipmentCategoryId, ec.CategoryName, 
			COUNT(mr.MaintainanceRecordId) AS[Total Maintence Records]
	FROM dbo.EquipmentCategory ec
	JOIN dbo.Equipment ep
	ON ec.EquipmentCategoryId = ep.EquipmentCategoryId
	JOIN dbo.MaintainanceRecord mr
	ON ep.EquipmentId = mr.EquipmentId
	GROUP BY ec.EquipmentCategoryId, ec.CategoryName;

--Select from the view
SELECT * FROM [Maintainance Frequency]
ORDER BY [Total Maintence Records] DESC;

--Drop the view
DROP VIEW [Maintainance Frequency];

----------------------------View 3-----------------------------------------------
/* Create a View to show the class instructor's information, including ProgramName, First Name, Last Name,
	Gender, and Email.
	Order by ClassId.
	*/
CREATE VIEW [Instructor Information] AS
	SELECT cl.ClassId, cl.ProgramName, p.FirstName, p.LastName, p.Gender, p.Email
	FROM dbo.Classes cl
	JOIN dbo.Employees e
	ON cl.InstructorId = e.EmployeeId
	JOIN dbo.Person p
	ON e.PersonId = p.PersonID;

--Select from the view
SELECT * FROM [Instructor Information]
ORDER BY ClassId;

--Drop the view
DROP VIEW [Instructor Information];

----------------------------View 4-----------------------------------------------
/*Create a view using Function "ProfitInYearMonthBranch" to show Profits for last 3 months of data
(includes data for Months May(05), June(06), July(07)
*/
CREATE VIEW [dbo].[ProfitPerBranch](BranchID,TotalPayment,TotalMaintenanceFee,TotalMembershipBill,TotalProfit,[Month]) AS(
select *,7  from [dbo].[ProfitInYearMonthBranch](2019,7,'B10001')
union
select *,7  from [dbo].[ProfitInYearMonthBranch](2019,7,'B10002')
union
select *,7  from [dbo].[ProfitInYearMonthBranch](2019,7,'B10003')
union
select *,7  from [dbo].[ProfitInYearMonthBranch](2019,7,'B10004')
union
select *,7  from [dbo].[ProfitInYearMonthBranch](2019,7,'B10005')
union
select *,7  from [dbo].[ProfitInYearMonthBranch](2019,7,'B10006')
union
select *,7  from [dbo].[ProfitInYearMonthBranch](2019,7,'B10007')
union
select *,7  from [dbo].[ProfitInYearMonthBranch](2019,7,'B10008')
union
select *,7  from [dbo].[ProfitInYearMonthBranch](2019,7,'B10009')
union
select *,7  from [dbo].[ProfitInYearMonthBranch](2019,7,'B10010')
union
select *,6  from [dbo].[ProfitInYearMonthBranch](2019,6,'B10001')
union
select *,6  from [dbo].[ProfitInYearMonthBranch](2019,6,'B10002')
union
select *,6  from [dbo].[ProfitInYearMonthBranch](2019,6,'B10003')
union
select *,6  from [dbo].[ProfitInYearMonthBranch](2019,6,'B10004')
union
select *,6  from [dbo].[ProfitInYearMonthBranch](2019,6,'B10005')
union
select *,6  from [dbo].[ProfitInYearMonthBranch](2019,6,'B10006')
union
select *,6  from [dbo].[ProfitInYearMonthBranch](2019,6,'B10007')
union
select *,6  from [dbo].[ProfitInYearMonthBranch](2019,6,'B10008')
union
select *,6  from [dbo].[ProfitInYearMonthBranch](2019,6,'B10009')
union
select *,6  from [dbo].[ProfitInYearMonthBranch](2019,6,'B10010')
union
select *,5  from [dbo].[ProfitInYearMonthBranch](2019,5,'B10001')
union
select *,5  from [dbo].[ProfitInYearMonthBranch](2019,5,'B10002')
union
select *,5  from [dbo].[ProfitInYearMonthBranch](2019,5,'B10003')
union
select *,5  from [dbo].[ProfitInYearMonthBranch](2019,5,'B10004')
union
select *,5  from [dbo].[ProfitInYearMonthBranch](2019,5,'B10005')
union
select *,5  from [dbo].[ProfitInYearMonthBranch](2019,5,'B10006')
union
select *,5  from [dbo].[ProfitInYearMonthBranch](2019,5,'B10007')
union
select *,5  from [dbo].[ProfitInYearMonthBranch](2019,5,'B10008')
union
select *,5  from [dbo].[ProfitInYearMonthBranch](2019,5,'B10009')
union
select *,5  from [dbo].[ProfitInYearMonthBranch](2019,5,'B10010')
)
GO
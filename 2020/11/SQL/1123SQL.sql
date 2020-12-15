--2020 11 23 Titanic��Ƥ��R---
--�X�ִ��J��s��-- 
USE Titanic

SELECT x.* 
  INTO [NewTitanic]
  FROM (SELECT * FROM train
        UNION
        SELECT * FROM test) x 
SELECT * FROM NewTitanic

--�d�XNULL��--
DECLARE @total int
SET @total = (SELECT COUNT(*) FROM NewTitanic)
SELECT 
	@total-COUNT([Survived]) AS [Survived_NULL],
	@total-COUNT([Pclass]) AS [Pclass_NULL],
	@total-COUNT([Name]) AS [Name_NULL],
	@total-COUNT([Sex]) AS [Sex_NULL],
	@total-COUNT([Age]) AS [Age_NULL],
	@total-COUNT([SibSp]) AS [SibSp_NULL],
	@total-COUNT([Parch]) AS [Parch_NULL],
	@total-COUNT([Ticket]) AS [Ticket_NULL],
	@total-COUNT([Fare]) AS [Fare_NULL],
	@total-COUNT([Cabin]) AS [Cabin_NULL],
	@total-COUNT([Embarked]) AS [Embarked_NULL]
FROM NewTitanic
SELECT * FROM NewTitanic

--
SELECT * FROM NewTitanic WHERE [Fare] IS NULL;
ALTER TABLE NewTitanic ALTER COLUMN [Fare] SMALLMONEY;

SELECT [Pclass],AVG([Fare]) FROM NewTitanic GROUP BY [Pclass];
SELECT * FROM NewTitanic WHERE [Pclass]=3 ORDER BY [Fare] DESC

---�P�i�������H��
SELECT [Ticket],COUNT([Fare]) AS [Cnt] FROM NewTitanic GROUP BY [Ticket];

--��s�P�i��������ڲ���
WITH TT
AS
(SELECT  [Ticket],COUNT([Fare]) AS  [Cnt]
FROM NewTitanic GROUP BY [Ticket] )
SELECT A.*,A.[Fare]/B.Cnt AS [NewFare]
--- INTO NewTitanic2
FROM NewTitanic AS A JOIN TT AS B
ON A.Ticket=B.Ticket


SELECT * FROM NewTitanic2 WHERE [Fare] IS NULL;
SELECT [Pclass],AVG([NewFare]) FROM NewTitanic2 GROUP BY [Pclass];
UPDATE [NewTitanic2] SET [NewFare]=7.5 WHERE [Fare] IS NULL; 


SELECT * FROM NewTitanic2 WHERE [NewFare]=0

SELECT * FROM NewTitanic2 WHERE NewFare>10 AND [Pclass]=3
SELECT * FROM NewTitanic2 WHERE NewFare<10 AND [Pclass]=1

SELECT [Survived],COUNT(*) FROM NewTitanic2 GROUP BY [Survived]
SELECT [Pclass],COUNT(*) FROM NewTitanic2 GROUP BY [Pclass]
SELECT [Pclass],COUNT(*) FROM NewTitanic2 WHERE [Survived]=1 GROUP BY [Pclass]
---
ALTER TABLE NewTitanic2 ALTER COLUMN [Fare] FLOAT;
ALTER TABLE NewTitanic2 ALTER COLUMN [Age] FLOAT;

---Master�����~�H---
SELECT * FROM NewTitanic2 where [Name] like '%Master%'
UPDATE NewTitanic2 SET [Age]=5 WHERE [Name] LIKE '%Master%' AND [Age] IS NULL 

--�k�h--
SELECT * FROM NewTitanic2 WHERE [Name] LIKE '%mrs.%'
--�k�h    ���Ѥ��ΥS��  �S���p�� --
SELECT * FROM NewTitanic2 WHERE [Name] LIKE '%mrs.%' AND [SibSp]>=1 AND [Parch]=0 AND [Age] IS NULL;
--SELECT * FROM NewTitanic2 WHERE [Sex]='female' AND [SibSp]>=1 AND [Parch]=0 AND [Age] IS NULL ;
--��k�h    ���Ѥ��ΥS��  �S���p�� --
UPDATE NewTitanic2 SET [Age]=22 WHERE [Name] LIKE '%mrs.%' AND [SibSp]>=1 AND [Parch]=0 AND [Age] IS NULL;

---
--�k�h �~�֬O�Ū�
SELECT * FROM NewTitanic2 WHERE [Name] LIKE '%mrs.%' AND [Age] IS NULL;
SELECT * FROM NewTitanic2 WHERE [Ticket]='W./C. 6607';
--
UPDATE NewTitanic2 SET [Age]=30 WHERE [Name] LIKE '%mrs.%' AND [SibSp]>=1 AND [Parch]>=1 AND [Age] IS NULL;
UPDATE NewTitanic2 SET [Age]=30 WHERE [Name] LIKE '%mrs.%' AND [Age] IS NULL; 

--==�k�h==--
-�k�h-
SELECT * FROM NewTitanic2 WHERE [Name] LIKE '%mr.%' AND [Age] IS NULL;
-�k�h-���p�ĩΤ�����-
SELECT * FROM NewTitanic2 WHERE [Name] LIKE '%mr.%' AND [Parch]>2 AND [Age] IS NULL;
SELECT * FROM NewTitanic2 WHERE [Name] LIKE '%mr,%' AND [Parch]=2 AND [Age] IS NULL;

--�k������ �b class3-
SELECT AVG([Age]) FROM NewTitanic2 WHERE [Name] LIKE '%mr.%' AND [Pclass]=3;
SELECT AVG([Age]) FROM NewTitanic2 WHERE [Name] LIKE '%mr.%' AND [Pclass]=3 AND [SibSp]=0 AND [Parch]=0;
SELECT [Pclass],AVG([Age]) FROM NewTitanic2 WHERE [Name] LIKE '%mr.%' AND [SibSp]=0 AND [Parch]=0 GROUP BY [Pclass]; 

SELECT * FROM NewTitanic2 WHERE [Name] LIKE '%mr.%' AND [SibSp]=0 AND [Parch]=0; 
SELECT * FROM NewTitanic2 WHERE [Name] LIKE '%mr.%' AND [Pclass]=3 AND [SibSp]=0 AND [Parch]=0;
SELECT * FROM NewTitanic2 WHERE [Name] LIKE '%mr.%' AND [Pclass]=1 AND [SibSp]=0 AND [Parch]=0 AND [Age] IS NULL;
SELECT * FROM NewTitanic2 WHERE [Name] LIKE '%mr.%' AND [Pclass]=2 AND [SibSp]=0 AND [Parch]=0 AND [Age] IS NULL;


---$

UPDATE NewTitanic2 SET [Age]=45 WHERE [Name] LIKE '%mr.%' AND [Pclass]=1 AND [SibSp]=0 AND [Parch]=0 AND [Age] IS NULL;
UPDATE NewTitanic2 SET [Age]=33 WHERE [Name] LIKE '%mr.%' AND [Pclass]=2 AND [SibSp]=0 AND [Parch]=0 AND [Age] IS NULL;
UPDATE NewTitanic2 SET [Age]=28 WHERE [Name] LIKE '%mr.%' AND [Pclass]=3 AND [SibSp]=0 AND [Parch]=0 AND [Age] IS NULL;
UPDATE NewTitanic2 SET [Age]=22 WHERE [Name] LIKE '%mr.%' AND [SibSp]>=2 AND [Parch]>=2 AND [Age] IS NULL;	--���a�x�A���������S�̭�
UPDATE NewTitanic2 SET [Age]=30 WHERE [Name] LIKE '%mr.%' AND [SibSp]>=2 AND [Parch]=0 AND [Age] IS NULL;	--�S�̭�
UPDATE NewTitanic2 SET [Age]=35 WHERE [Name] LIKE '%mr.%' AND [SibSp]=1 AND [Parch]>=1 AND [Age] IS NULL;	--���ѱC�A�åB���a�Ĥl
UPDATE NewTitanic2 SET [Age]=35 WHERE [Name] LIKE '%mr.%' AND [Age] IS NULL;	--�Ѿl��Mr.

SELECT * FROM NewTitanic2 WHERE [Name] LIKE '%mr.%' AND [Age] IS NULL;  

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM NewTitanic2 WHERE [Name] LIKE '%miss.%' AND [Age] IS NULL;  

/*
WITH TT
AS
( SELECT [Ticket],COUNT([PassengerId]) AS [Cnt] FROM NewTitanic2 GROUP BY [Ticket] HAVING COUNT([PassengerId])>1 )

SELECT *
FROM NewTitanic2
WHERE [Name] LIKE '%miss.%' AND [Age] IS NULL AND [Parch]=0
	AND [Ticket] IN (SELECT [TIcket] FROM TT); 
*/

WITH TT
AS
( SELECT [Ticket],COUNT([PassengerId]) AS [Cnt] FROM NewTitanic2 GROUP BY [Ticket] HAVING COUNT([PassengerId])>1 )
,UU
AS
(
	SELECT [PassengerId] FROM NewTitanic2
	WHERE [Name] LIKE '%miss.%' AND [Age] IS NULL AND [Parch]>0
		AND [Ticket] IN (SELECT [TIcket] FROM TT)
)
UPDATE NewTitanic2 SET [Age]=13 WHERE [PassengerId] IN(SELECT [PassengerId] FROM UU);		--�������ΥS�̩n�f��Miss(�~���p�B��)
 

WITH TT
AS
( SELECT [Ticket],COUNT([PassengerId]) AS [Cnt] FROM NewTitanic2 GROUP BY [Ticket] HAVING COUNT([PassengerId])>1 )
,UU
AS
(
	SELECT [PassengerId] FROM NewTitanic2
	WHERE [Name] LIKE '%miss.%' AND [Age] IS NULL AND [Parch]=0
		AND [Ticket] IN (SELECT [TIcket] FROM TT)
)
UPDATE NewTitanic2 SET [Age]=24 WHERE [PassengerId] IN(SELECT [PassengerId] FROM UU);		--�S�̩n�f��Miss(���~)



SELECT MAX([Age]),MIN([Age]),AVG([Age]) FROM NewTitanic2 WHERE [Name] LIKE '%miss.%' AND [Pclass]=3

SELECT * FROM NewTitanic2 WHERE [Name] LIKE '%miss.%' AND [Age] IS NULL;  
UPDATE NewTitanic2 SET [Age]=38 WHERE [Name] LIKE '%miss.%' AND [Age] IS NULL;	--�Ѿl��Miss.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT MAX([Age]),MIN([Age]),AVG([Age]) FROM NewTitanic2 WHERE [Sex]='male' AND [Pclass]=1
SELECT * FROM NewTitanic2 WHERE [Age] IS NULL;  

UPDATE NewTitanic2 SET [Age]=60 WHERE [PassengerId]=767;
UPDATE NewTitanic2 SET [Age]=45 WHERE [PassengerId]=980;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--SELECT * FROM NewTitanic2 WHERE [Age]<16 AND [Parch]>0

ALTER TABLE NewTitanic2 ADD [IsFamilyHasChild] INT;
UPDATE NewTitanic2 SET [IsFamilyHasChild]=0;

/*
WITH TT
AS
(
	--SELECT [Ticket] FROM NewTitanic2 WHERE [Age]<16 AND [Parch]>0
	SELECT * FROM NewTitanic2 WHERE [Age]<16 AND [Parch]>0
)
SELECT * FROM TT
*/

WITH TT
AS
(
	SELECT [Ticket] FROM NewTitanic2 WHERE [Age]<16 AND [Parch]>0
)
UPDATE NewTitanic2 SET [IsFamilyHasChild]=1 WHERE [Ticket] IN(SELECT [Ticket] FROM TT);


SELECT * FROM NewTitanic2


--SELECT * FROM  NewTitanic2 WHERE [Parch]>=1 AND [IsFamilyHasChild]=1 AND [Age]>=16;
ALTER TABLE NewTitanic2 ADD [IsMomOrDad] INT;
UPDATE NewTitanic2 SET [IsMomOrDad]=0;

WITH TT
AS
(
	SELECT [PassengerId] FROM  NewTitanic2 WHERE [Parch]>=1 AND [IsFamilyHasChild]=1 AND [Age]>=16
)
UPDATE NewTitanic2 SET [IsMomOrDad]=1 WHERE [PassengerId] IN(SELECT [PassengerId] FROM TT);

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE NewTitanic2 ADD [AgeLevel] INT;
UPDATE NewTitanic2 SET [AgeLevel]=IIF([Age]>=45,3,IIF([Age]<16,1,2));

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE NewTitanic2 ADD [IsGroup] INT;
UPDATE NewTitanic2 SET [IsGroup]=0;

WITH TT
AS
( SELECT [Ticket],COUNT([PassengerId]) AS [Cnt] FROM NewTitanic GROUP BY [Ticket] HAVING COUNT([PassengerId])>1 )
UPDATE NewTitanic2 SET [IsGroup]=1 WHERE [Ticket] IN(SELECT [Ticket] FROM TT);
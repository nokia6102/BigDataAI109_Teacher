
DECLARE @sql_query NVARCHAR(MAX);
SET @sql_query=N'SELECT * FROM NewCustomer'
INSERT INTO #TT
EXECUTE sp_execute_external_script @language = N'R',  
		@script = N'   

	sqlData <- data.frame(InputDataSet)
	cs<-colnames(sqlData)		#���X���W
	frm<-paste("", paste(cs[2:length(cs)], collapse="+"), sep="~")
	#print(frm)
	z <- rxKmeans(~ContinentName+MaritalStatus+Gender+Education+Occupation+AgeLevel
		+YearlyIncomeLevel+HasChild+HasHouse+HasCar+Star		
		, data=sqlData, numClusters = 5, seed=12345)
	#print(z)
	#print(str(z))
	OutputDataSet <- data.frame(cbind(sqlData$CustomerKey,z$cluster))
	'
	,@input_data_1=@sql_query	
;

-----
SELECT * FROM #TT
DROP TABLE #TT;

CREATE TABLE #TT 
(
	CustomerKey INT,
	GroupID INT
)

SELECT * FROM NewCustomer

SELECT A.* ,B.GroupId
INTO FinalCustomer
FROM NewCustomer AS A JOIN #TT AS B ON A.CustomerKey=B.CustomerKey;

SELECT * FROM	 FinalCustomer
----
DECLARE @sqlQuery NVARCHAR(MAX);
SET @sqlQuery=N'SELECT [GroupId],[ContinentName], [MaritalStatus], [Gender], [Education], [Occupation]
	, [AgeLevel], [YearlyIncomeLevel], [HasChild], [HasHouse], [HasCar], [Star] FROM FinalCustomer WHERE [CustomerKey]<=12940'
DECLARE @mm VARBINARY(MAX);

EXECUTE sp_execute_external_script @language = N'R',  
    @script = N'   		
	sqlData <- data.frame(InputDataSet)
	cs<-colnames(sqlData)		#���X���W
	frm<-paste(cs[1], paste(cs[2:length(cs)], collapse="+"), sep="~")
	model<-rxLogisticRegression(frm,sqlData,type="multiClass")
	print(model)
	'
	,@input_data_1=@sqlQuery
GO

CREATE TABLE �ҫ���
(
    �s�� INT IDENTITY(1,1) PRIMARY KEY,
	�ҫ��W�� NVARCHAR(20),
	�ҫ� VARBINARY(MAX),
	���ɮɶ� DATETIME2(2) DEFAULT SYSDATETIME()
)
GO

CREATE PROC #PP @sqlQuery NVARCHAR(MAX),@model VARBINARY(MAX) OUTPUT
AS
EXECUTE sp_execute_external_script @language = N'R',  
		@script = N'   		
	sqlData <- data.frame(InputDataSet)
	cs<-colnames(sqlData)		#���X���W
	frm<-paste(cs[1], paste(cs[2:length(cs)], collapse="+"), sep="~")
	model<-rxLogisticRegression(frm,sqlData,type="multiClass")
	#print(model)
	trainedModel <- rxSerializeModel(model,realtimeScoringOnly=TRUE)
	'
	,@input_data_1=@sqlQuery	
	,@params=N'@trainedModel VARBINARY(MAX) OUTPUT'
	,@trainedModel=@model OUTPUT;
GO

DECLARE @ss NVARCHAR(MAX);
SET @ss=N'SELECT [GroupId],[ContinentName], [MaritalStatus], [Gender], [Education], [Occupation]
	, [AgeLevel], [YearlyIncomeLevel], [HasChild], [HasHouse], [HasCar], [Star] FROM FinalCustomer WHERE [CustomerKey]<=12940'
DECLARE @mm VARBINARY(MAX);
EXEC #PP @ss,@mm OUTPUT;
INSERT INTO �ҫ���(�ҫ��W��,�ҫ�) VALUES(N'ù�N���j�k(�h����)(�Y��)',@mm);

SELECT * FROM �ҫ���

ALTER PROC #PP @sqlQuery NVARCHAR(MAX),@model VARBINARY(MAX) OUTPUT
AS
EXECUTE sp_execute_external_script @language = N'R',  
		@script = N'   		
	sqlData <- data.frame(InputDataSet)
	cs<-colnames(sqlData)		#���X���W
	frm<-paste(cs[1], paste(cs[2:length(cs)], collapse="+"), sep="~")
	model<-rxNeuralNet(frm,sqlData,type="multiClass")
	#print(model)
	trainedModel <- rxSerializeModel(model,realtimeScoringOnly=TRUE)
	'
	,@input_data_1=@sqlQuery	
	,@params=N'@trainedModel VARBINARY(MAX) OUTPUT'
	,@trainedModel=@model OUTPUT;
GO

DECLARE @ss NVARCHAR(MAX);
SET @ss=N'SELECT [GroupId],[ContinentName], [MaritalStatus], [Gender], [Education], [Occupation]
	, [AgeLevel], [YearlyIncomeLevel], [HasChild], [HasHouse], [HasCar], [Star] FROM FinalCustomer WHERE [CustomerKey]<=12940'
DECLARE @mm VARBINARY(MAX);
EXEC #PP @ss,@mm OUTPUT;
INSERT INTO �ҫ���(�ҫ��W��,�ҫ�) VALUES(N'�����g(�h����)(�Y��)',@mm);

DECLARE @ss NVARCHAR(MAX);
SET @ss=N'SELECT [GroupId],[ContinentName], [MaritalStatus], [Gender], [Education], [Occupation]
	, [AgeLevel], [YearlyIncomeLevel], [HasChild], [HasHouse], [HasCar], [Star] FROM FinalCustomer WHERE [CustomerKey]>12940'
DECLARE @mm VARBINARY(MAX);
SELECT @mm=�ҫ� FROM �ҫ��� WHERE �s��=1

EXECUTE sp_execute_external_script @language = N'R',  
		@script = N'   		
	sqlData <- data.frame(InputDataSet)
	model <- rxUnserializeModel(trainedModel)
	result<-rxPredict(model,sqlData,extraVarsToWrite=c("GroupId"))	
	OutputDataSet<-result	
	'
	,@input_data_1=@ss	
	,@params=N'@trainedModel VARBINARY(MAX)'
	,@trainedModel=@mm;

SELECT * FROM #TT

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE #TT
CREATE TABLE #TT
(
    ��ڲէO INT,
	���˲էO INT
)
GO

DECLARE @ss NVARCHAR(MAX);
SET @ss=N'SELECT [GroupId],[ContinentName], [MaritalStatus], [Gender], [Education], [Occupation]
	, [AgeLevel], [YearlyIncomeLevel], [HasChild], [HasHouse], [HasCar], [Star] FROM FinalCustomer WHERE [CustomerKey]>12940'
DECLARE @mm VARBINARY(MAX);
SELECT @mm=�ҫ� FROM �ҫ��� WHERE �s��=1

INSERT INTO #TT
EXECUTE sp_execute_external_script @language = N'R',  
		@script = N'   		
	sqlData <- data.frame(InputDataSet)
	model <- rxUnserializeModel(trainedModel)
	result<-rxPredict(model,sqlData,extraVarsToWrite=c("GroupId"))	
	#OutputDataSet<-result
	OutputDataSet<-result[,1:2]
	'
	,@input_data_1=@ss	
	,@params=N'@trainedModel VARBINARY(MAX)'
	,@trainedModel=@mm;

SELECT * FROM #TT

 SELECT * FROM �ҫ���
ALTER TABLE #TT ADD [Bingo] INT;
UPDATE #TT SET [Bingo]=0;
UPDATE #TT SET [Bingo]=1 WHERE ��ڲէO=���˲էO;

SELECT [��ڲէO],COUNT(*) AS Cnt,SUM([Bingo]) AS [Correct]
	,1.0*SUM([Bingo])/COUNT(*) AS [ù�N���j�k(�h����)(�Y��)�R�����v]
FROM #TT
GROUP BY [��ڲէO];

--=====[�����g(�h����)(�Y��)(�ҫ�2)====
ALTER PROC #PP @sqlQuery NVARCHAR(MAX),@model VARBINARY(MAX) OUTPUT
AS
EXECUTE sp_execute_external_script @language = N'R',  
		@script = N'   		
	sqlData <- data.frame(InputDataSet)
	cs<-colnames(sqlData)		#���X���W
	frm<-paste(cs[1], paste(cs[2:length(cs)], collapse="+"), sep="~")
	model<-rxNeuralNet(frm,sqlData,type="multiClass")
	#print(model)
	trainedModel <- rxSerializeModel(model,realtimeScoringOnly=TRUE)
	'
	,@input_data_1=@sqlQuery	
	,@params=N'@trainedModel VARBINARY(MAX) OUTPUT'
	,@trainedModel=@model OUTPUT;
GO

DECLARE @ss NVARCHAR(MAX);
SET @ss=N'SELECT [GroupId],[ContinentName], [MaritalStatus], [Gender], [Education], [Occupation]
	, [AgeLevel], [YearlyIncomeLevel], [HasChild], [HasHouse], [HasCar], [Star] FROM FinalCustomer WHERE [CustomerKey]<=12940'
DECLARE @mm VARBINARY(MAX);
EXEC #PP @ss,@mm OUTPUT;
INSERT INTO �ҫ���(�ҫ��W��,�ҫ�) VALUES(N'�����g(�h����)(�Y��)',@mm);

SELECT * FROM �ҫ���
---
DECLARE @ss NVARCHAR(MAX);
SET @ss=N'SELECT [GroupId],[ContinentName], [MaritalStatus], [Gender], [Education], [Occupation]
	, [AgeLevel], [YearlyIncomeLevel], [HasChild], [HasHouse], [HasCar], [Star] FROM FinalCustomer WHERE [CustomerKey]>12940'
DECLARE @mm VARBINARY(MAX);
SELECT @mm=�ҫ� FROM �ҫ��� WHERE �s��=2

INSERT INTO #TT
EXECUTE sp_execute_external_script @language = N'R',  
		@script = N'   		
	sqlData <- data.frame(InputDataSet)
	model <- rxUnserializeModel(trainedModel)
	result<-rxPredict(model,sqlData,extraVarsToWrite=c("GroupId"))	
	#OutputDataSet<-result
	OutputDataSet<-result[,1:2]
	'
	,@input_data_1=@ss	
	,@params=N'@trainedModel VARBINARY(MAX)'
	,@trainedModel=@mm;

SELECT * FROM #TT


ALTER TABLE #TT ADD [Bingo] INT;
UPDATE #TT SET [Bingo]=0;
UPDATE #TT SET [Bingo]=1 WHERE ��ڲէO=���˲էO;

SELECT [��ڲէO],COUNT(*) AS Cnt,SUM([Bingo]) AS [Correct]
	,1.0*SUM([Bingo])/COUNT(*)AS [�����g(�h����)(�Y��)(�ҫ�2)]
FROM #TT
GROUP BY [��ڲէO];

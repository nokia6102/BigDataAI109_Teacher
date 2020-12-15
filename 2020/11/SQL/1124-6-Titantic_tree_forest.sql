
SELECT [Survived], [Pclass], [Sex],[IsGroup], [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]<=910;

SELECT [Survived],COUNT(*)
FROM [Titantic].[dbo].[NewTitanic2]
WHERE [PassengerId]<=910
GROUP BY [Survived];



DECLARE @sql_query NVARCHAR(1024)=N'SELECT [Survived], [Pclass], [Sex],[IsGroup]
	, [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2]';

EXECUTE sp_execute_external_script @language = N'R',  
  @script = N'   
	inputData<-data.frame(InputDataSet)
	trainData<-inputData[0:910,]
	testData<-inputData[911:1309,]

	frm <- Survived~ Pclass+Sex+IsGroup+IsFamilyHasChild+IsMomOrDad+AgeLevel
	model <- rxDTree(frm, trainData) 
	print(model)


	result<-rxPredict(model, data= testData)
	print(str(result))
	OutputDataSet<-result;	
'
	,@input_data_1=@sql_query
	WITH RESULT SETS (( "���`���v" FLOAT,"�s�����v" FLOAT ))
;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROC #TempPP @sqlQuery NVARCHAR(MAX),@trainedModel VARBINARY(MAX) OUTPUT
AS
	EXECUTE sp_execute_external_script @language = N'R',  
	  @script = N'   
		inputData<-data.frame(InputDataSet)	
		cs<-colnames(inputData)		#���X���W
		frm<-paste(cs[1], paste(cs[2:length(cs)], collapse=" + "), sep=" ~ ")	
		#frm <- Survived~Pclass+Sex+IsGroup+IsFamilyHasChild+IsMomOrDad+AgeLevel
		model <- rxDTree(frm, inputData)
		trainedModel<-rxSerializeModel(model)
	'
		,@input_data_1=@sqlQuery
		,@params=N'@trainedModel VARBINARY(MAX) OUTPUT'
		,@trainedModel=@trainedModel OUTPUT
	;
GO

/*
DECLARE @ss NVARCHAR(1024)=N'SELECT [Survived], [Pclass], [Sex],[IsGroup]
	, [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]<=910';
DECLARE @mm VARBINARY(MAX);

EXEC #TempPP @ss,@mm OUTPUT;
SELECT @mm
*/


USE [Titantic]
--DROP TABLE �ҫ���
CREATE TABLE �ҫ���
(
    �s�� INT IDENTITY(1,1) PRIMARY KEY,
	�ҫ��W�� NVARCHAR(20),
	�ҫ� VARBINARY(MAX),
	���ɮɶ� DATETIME2(2) DEFAULT SYSDATETIME()
)

DECLARE @ss NVARCHAR(1024)=N'SELECT [Survived], [Pclass], [Sex],[IsGroup]
	, [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]<=910';
DECLARE @mm VARBINARY(MAX);

EXEC #TempPP @ss,@mm OUTPUT;
INSERT INTO �ҫ���(�ҫ��W��,�ҫ�) VALUES(N'�M����',@mm);

SELECT * FROM �ҫ���

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @sql_query NVARCHAR(1024)=N'SELECT [Survived], [Pclass], [Sex],[IsGroup]
	, [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]>910';

DECLARE @mm VARBINARY(MAX);
SELECT @mm=�ҫ� FROM �ҫ��� WHERE �s��=1;

EXECUTE sp_execute_external_script @language = N'R',  
	@script = N'   
		testData<-data.frame(InputDataSet)				#�ǤJ���ղ�
		trainedModel<-rxUnserializeModel(inputModel)	#�ǤJ�V�m�L���ҫ�

		#result<-rxPredict(trainedModel, data= testData,writeModelVars=TRUE)			
		result<-rxPredict(trainedModel, data= testData,extraVarsToWrite=c("Survived"))			
		OutputDataSet<-result;	
	'
	,@input_data_1=@sql_query
	,@params=N'@inputModel VARBINARY(MAX)'
	,@inputModel=@mm	
;

-----------------------------------------------------------------------------------------------------


CREATE TABLE #TT
(
    ���`���v FLOAT,
	�s�����v FLOAT,
	��l�s�� INT
)
GO


DECLARE @sql_query NVARCHAR(1024)=N'SELECT [Survived], [Pclass], [Sex],[IsGroup]
	, [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]>910';

DECLARE @mm VARBINARY(MAX);
SELECT @mm=�ҫ� FROM �ҫ��� WHERE �s��=1;

INSERT INTO #TT
EXECUTE sp_execute_external_script @language = N'R',  
	@script = N'   
		testData<-data.frame(InputDataSet)				#�ǤJ���ղ�
		trainedModel<-rxUnserializeModel(inputModel)	#�ǤJ�V�m�L���ҫ�

		result<-rxPredict(trainedModel, data= testData,extraVarsToWrite=c("Survived"))
		OutputDataSet<-result;	
	'
	,@input_data_1=@sql_query
	,@params=N'@inputModel VARBINARY(MAX)'
	,@inputModel=@mm
;

SELECT * FROM #TT
ALTER TABLE #TT ADD �w���s�� INT;
UPDATE #TT SET �w���s��=IIF(�s�����v>=0.6,1,0)


DECLARE @tt INT,@tf INT,@ft INT,@ff INT;
SELECT @tt=COUNT(*) FROM #TT WHERE ��l�s��=1 AND �w���s��=1;
SELECT @tf=COUNT(*) FROM #TT WHERE ��l�s��=1 AND �w���s��=0;
SELECT @ft=COUNT(*) FROM #TT WHERE ��l�s��=0 AND �w���s��=1;
SELECT @ff=COUNT(*) FROM #TT WHERE ��l�s��=0 AND �w���s��=0;
SELECT @tt,@tf,@ft,@ff;
SELECT (@tt+@ff)/399.0
SELECT 1.0*@tt/(@tt+@tf)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER PROC #TempPP @sqlQuery NVARCHAR(MAX),@trainedModel VARBINARY(MAX) OUTPUT
AS
	EXECUTE sp_execute_external_script @language = N'R',  
	  @script = N'   
		inputData<-data.frame(InputDataSet)	
		cs<-colnames(inputData)		#���X���W
		frm<-paste(cs[1], paste(cs[2:length(cs)], collapse=" + "), sep=" ~ ")			
		print(str(inputData))
		model <- rxDForest(frm, inputData)
		trainedModel<-rxSerializeModel(model)
	'
		,@input_data_1=@sqlQuery
		,@params=N'@trainedModel VARBINARY(MAX) OUTPUT'
		,@trainedModel=@trainedModel OUTPUT
	;
GO

DECLARE @ss NVARCHAR(1024)=N'SELECT [Survived], [Pclass], [Sex],[IsGroup]
	, [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]<=910';
DECLARE @mm VARBINARY(MAX);

EXEC #TempPP @ss,@mm OUTPUT;
INSERT INTO �ҫ���(�ҫ��W��,�ҫ�) VALUES(N'�M���˪L',@mm);
SELECT * FROM �ҫ���


--DELETE FROM �ҫ��� WHERE �s��=3;
SELECT * FROM �ҫ���

-----------------------------------------------------
SELECT * FROM #TT
DROP TABLE #TT
CREATE TABLE #TT
(
    ���`���v FLOAT,
	�s�����v FLOAT,
	�����s�� INT,
	��ڦs�� INT
)
GO



DECLARE @sql_query NVARCHAR(1024)=N'SELECT [Survived], [Pclass], [Sex],[IsGroup]
	, [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]>910';

DECLARE @mm VARBINARY(MAX);
SELECT @mm=�ҫ� FROM �ҫ��� WHERE �s��=2;

INSERT INTO #TT
EXECUTE sp_execute_external_script @language = N'R',  
	@script = N'   
		testData<-data.frame(InputDataSet)				#�ǤJ���ղ�
		trainedModel<-rxUnserializeModel(inputModel)	#�ǤJ�V�m�L���ҫ�

		result<-rxPredict(trainedModel, data= testData,extraVarsToWrite=c("Survived"),type=c("prob"))
		OutputDataSet<-result;	
	'
	,@input_data_1=@sql_query
	,@params=N'@inputModel VARBINARY(MAX)'
	,@inputModel=@mm
;


SELECT * FROM #TT
ALTER TABLE #TT ADD �����s��2 INT;
UPDATE #TT SET �����s��2=IIF(�s�����v>=0.6,1,0)


DECLARE @tt INT,@tf INT,@ft INT,@ff INT;
SELECT @tt=COUNT(*) FROM #TT WHERE ��ڦs��=1 AND �����s��2=1;
SELECT @tf=COUNT(*) FROM #TT WHERE ��ڦs��=1 AND �����s��2=0;
SELECT @ft=COUNT(*) FROM #TT WHERE ��ڦs��=0 AND �����s��2=1;
SELECT @ff=COUNT(*) FROM #TT WHERE ��ڦs��=0 AND �����s��2=0;
SELECT @tt,@tf,@ft,@ff;
SELECT (@tt+@ff)/399.0
SELECT 1.0*@tt/(@tt+@tf)

--1124
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--�������v

ALTER PROC #TempPP @sqlQuery NVARCHAR(MAX),@trainedModel VARBINARY(MAX) OUTPUT
AS
	EXECUTE sp_execute_external_script @language = N'R',  
	  @script = N'   
		inputData<-data.frame(InputDataSet)	
		cs<-colnames(inputData)		
		#print(str(inputData))
		#frm<-paste(cs[1], paste(cs[2:length(cs)], collapse="+"), sep="~")			
		#model <- rxNaiveBayes(frm, inputData)
		model <- rxNaiveBayes(Survived~Pclass+Sex+IsGroup+IsFamilyHasChild+IsMomOrDad+AgeLevel, inputData)		
		trainedModel<-rxSerializeModel(model)
	'
		,@input_data_1=@sqlQuery
		,@params=N'@trainedModel VARBINARY(MAX) OUTPUT'
		,@trainedModel=@trainedModel OUTPUT
	;
GO

DECLARE @ss NVARCHAR(1024)=N'SELECT [Survived]
	, [Pclass]
	, [Sex]		
	, CAST([IsGroup] AS NVARCHAR) AS [IsGroup]
	, CAST([IsFamilyHasChild] AS NVARCHAR) AS [IsFamilyHasChild]
	, CAST([IsMomOrDad] AS NVARCHAR) AS [IsMomOrDad]
	, CAST([AgeLevel] AS NVARCHAR) AS [AgeLevel]
	FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]<=910';
DECLARE @mm VARBINARY(MAX);

EXEC #TempPP @ss,@mm OUTPUT;
INSERT INTO �ҫ���(�ҫ��W��,�ҫ�) VALUES(N'������v',@mm);

--DELETE FROM �ҫ��� WHERE �s��=5;
SELECT * FROM �ҫ���

-----------------------------------------------------

DROP TABLE #TT;

CREATE TABLE #TT
(
	��ڦs�� NVARCHAR(2),
    ���`���v FLOAT,
	�s�����v FLOAT	
)
GO

DECLARE @sql_query NVARCHAR(1024)=N'SELECT [Survived]
	, [Pclass]
	, [Sex]		
	, CAST([IsGroup] AS NVARCHAR) AS [IsGroup]
	, CAST([IsFamilyHasChild] AS NVARCHAR) AS [IsFamilyHasChild]
	, CAST([IsMomOrDad] AS NVARCHAR) AS [IsMomOrDad]
	, CAST([AgeLevel] AS NVARCHAR) AS [AgeLevel]
	FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]>910';

DECLARE @mm VARBINARY(MAX);
SELECT @mm=�ҫ� FROM �ҫ��� WHERE �s��=6;

INSERT INTO #TT    --�H�U���G�s�J#TT��
EXECUTE sp_execute_external_script @language = N'R',  
	@script = N'   
		testData<-data.frame(InputDataSet)				#�ǤJ���ղ�
		trainedModel<-rxUnserializeModel(inputModel)	#�ǤJ�V�m�L���ҫ�

		result<-rxPredict(trainedModel, data= testData,type=c("prob"),extraVarsToWrite=c("Survived"))
		print(str(result))
		OutputDataSet<-result;	
	'
	,@input_data_1=@sql_query
	,@params=N'@inputModel VARBINARY(MAX)'
	,@inputModel=@mm
;


SELECT * FROM #TT
ALTER TABLE #TT ADD �����s�� INT;
UPDATE #TT SET �����s��=IIF(�s�����v>=0.6,1,0)


DECLARE @tt INT,@tf INT,@ft INT,@ff INT;
SELECT @tt=COUNT(*) FROM #TT WHERE ��ڦs��='1' AND �����s��=1;
SELECT @tf=COUNT(*) FROM #TT WHERE ��ڦs��='1' AND �����s��=0;
SELECT @ft=COUNT(*) FROM #TT WHERE ��ڦs��='0' AND �����s��=1;
SELECT @ff=COUNT(*) FROM #TT WHERE ��ڦs��='0' AND �����s��=0;
SELECT @tt,@tf,@ft,@ff;
SELECT (@tt+@ff)/399.0
SELECT 1.0*@tt/(@tt+@tf)











SELECT [Survived], [Pclass], [Sex],[IsGroup], [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2] WHERE [PassengerId]<=910;

SELECT [Survived],COUNT(*)
FROM [Titantic].[dbo].[NewTitanic2]
WHERE [PassengerId]<=910
GROUP BY [Survived];

DECLARE @sql_query NVARCHAR(1024)=N'SELECT [Survived], [Pclass], [Sex],[IsGroup]
	, [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM [Titantic].[dbo].[NewTitanic2]';

EXECUTE sp_execute_external_script @language = N'R',
@script =  N'   
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
----

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

----

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

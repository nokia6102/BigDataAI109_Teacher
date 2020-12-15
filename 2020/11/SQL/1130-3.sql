CREATE TABLE �ҫ���
(
    �s�� INT IDENTITY(1,1) PRIMARY KEY,
	�ҫ��W�� NVARCHAR(20),
	�ҫ� VARBINARY(MAX)
)
GO

ALTER PROC #TempPP @sqlQuery NVARCHAR(MAX),@trainedModel VARBINARY(MAX) OUTPUT
AS
	EXECUTE sp_execute_external_script @language = N'R',
	@script = N'
			inputData<-data.frame(InputDataSet)
			cs<-colnames(inputData)
			frm<-paste(cs[1], paste(cs[2:length(cs)], collapse="+"), sep="~")
			model<-rxLinMod(frm,inputData)
			print(model)
			trainedModel<-rxSerializeModel(model,realtimeScoringOnly=TRUE)
			'
			,@input_data_1=@sqlQuery
			,@params=N'@trainedModel VARBINARY(MAX) OUTPUT'
			,@trainedModel=@trainedModel OUTPUT
;
GO

DECLARE @ss NVARCHAR(1024)=N'SELECT * FROM NewPitcher';
DECLARE @mm VARBINARY(MAX);
EXEC #TempPP @ss,@mm OUTPUT;
INSERT INTO �ҫ���(�ҫ��W��,�ҫ�) VALUES(N'�u�ʰj�k(�Y��)',@mm);

--TRUNCATE TABLE TABLE
SELECT * FROM �ҫ���
-----------------------------------------------------------
ALTER PROC #TempPP @sqlQuery NVARCHAR(MAX),@trainedModel VARBINARY(MAX) OUTPUT
AS
	EXECUTE sp_execute_external_script @language = N'R',  
	@script = N'   
		inputData<-data.frame(InputDataSet)	
		cs<-colnames(inputData)				
		frm<-paste(cs[1], paste(cs[2:length(cs)], collapse="+"), sep="~")			
		model <- rxFastTrees(frm, inputData,type = c("regression"))		
		trainedModel<-rxSerializeModel(model,realtimeScoringOnly=TRUE)
	'	
	,@input_data_1=@sqlQuery
	,@params=N'@trainedModel VARBINARY(MAX) OUTPUT'
	,@trainedModel=@trainedModel OUTPUT
;
GO
DECLARE @ss NVARCHAR(1024)=N'SELECT * FROM NewPitcher';

DECLARE @mm VARBINARY(MAX);
EXEC #TempPP @ss,@mm OUTPUT;
INSERT INTO �ҫ���(�ҫ��W��,�ҫ�) VALUES(N'�ֳt�j�k��(�Y��)',@mm);
SELECT * FROM �ҫ���
---------------
DECLARE @sql_query NVARCHAR(1024)=N'SELECT * FROM NewPitcher';
DECLARE @mm VARBINARY(MAX);
SELECT @mm=�ҫ� FROM �ҫ��� WHERE �s��=2;

EXECUTE sp_execute_external_script @language = N'R',  
	@script = N'   
		testData<-data.frame(InputDataSet)				#�ǤJ���ղ�
		trainedModel<-rxUnserializeModel(inputModel)	#�ǤJ�V�m�L���ҫ�
		result<-rxPredict(trainedModel, data=testData,extraVarsToWrite=c("ERA"))
		OutputDataSet<-result;	
	'
	,@input_data_1=@sql_query
	,@params=N'@inputModel VARBINARY(MAX)'
	,@inputModel=@mm
;

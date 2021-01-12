/*
--使用老師寫的工具
--Win_LoadPicClassify
-- [PicTest] 資料庫
--上傳產生 PicPathData 資料表
*/

--用過清空
--DROP TABLE [dbo].[ObjectType]
--DROP TABLE [dbo].[TestPic]
--DROP TABLE [dbo].[TrainPic]

-------- 作出物件的Type表
WITH Temp
AS
(
	SELECT DISTINCT [Type] FROM [PicPathData]
)
SELECT IDENTITY(INT,1,1) AS Id,[Type]
INTO [ObjectType]
FROM Temp;

SELECT * FROM [ObjectType];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE A SET A.[Label]=B.[Id]
FROM [PicPathData] AS A JOIN [ObjectType] AS B ON A.[Type]=B.[Type];

SELECT * FROM PicPathData
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

WITH T1
AS
(
	SELECT DISTINCT [Type],COUNT(*) AS Cnt
	FROM [PicPathData]
	GROUP BY [Type]
),
T2
AS
(
	SELECT DISTINCT [Type],ROUND(Cnt*0.7,0) AS Range
	FROM T1
)
--SELECT * FROM T2;
,T3
AS
(
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY [Type] ORDER BY [Pic]) AS [SerId]
	FROM [PicPathData]
)
,T4
AS
(
	SELECT [Pic], A.[Type], [Label]
	FROM T3 AS A JOIN T2 AS B ON A.[Type]=B.[Type]
	WHERE A.SerId<=B.Range
)
SELECT * INTO TrainPic FROM T4;

---後3成做測試--
WITH Temp
AS
(
	SELECT * FROM [PicPathData]
	EXCEPT
	SELECT * FROM [TrainPic]
)
SELECT * INTO TestPic FROM Temp;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 

CREATE PROC #TempPP @sqlQuery NVARCHAR(MAX),@model VARBINARY(MAX) OUTPUT
AS
	EXECUTE sp_execute_external_script @language = N'R'
        ,@script = N' 
		sqlData<-data.frame(InputDataSet,stringsAsFactors = FALSE);
		sqlData[] <- lapply(sqlData, function(x) if (is.factor(x)) as.character(x) else {x})
		imageModel <- rxLogisticRegression( 
			formula = Label~Features
			,data = sqlData, 
			,normalize = "No",
			,type = "multiClass", 
			,mlTransforms = list( 
				loadImage(vars = list(Features = "Pic")), 
				resizeImage(vars = "Features", width = 224, height = 224), 
				extractPixels(vars = "Features"), 
				featurizeImage(var = "Features", dnnModel = "Resnet101"))
			,mlTransformVars = "Pic");	
		model <- rxSerializeModel(imageModel, realtimeScoringOnly = FALSE);
		'
		,@input_data_1 = @sqlQuery
		,@params = N'@model VARBINARY(MAX) OUTPUT'
		,@model = @model OUTPUT;
GO

-- sp_configure 'external scripts enabled', 1;
---RECONFIGURE WITH OVERRIDE;

DECLARE @model VARBINARY(MAX);
DECLARE @query nvarchar(max) = N'SELECT TOP(1) [Pic],[Type],[Label] FROM TrainPic';
EXEC #TempPP @query,@model OUTPUT;
INSERT INTO 模型表(模型名稱,模型) VALUES(N'快速羅吉斯(多選即時)',@model)

--補: 用一筆做模型
DECLARE @mm VARBINARY(MAX);
DECLARE @query nvarchar(max) = N'SELECT TOP(1) [Pic],[Type],[Label] FROM TrainPic';
EXEC #TempPP @query,@mm OUTPUT;
INSERT INTO 模型表(模型名稱,模型) VALUES(N'快速羅吉斯(多選即時)',@mm)

--補: 用全筆做模型
DECLARE @mm VARBINARY(MAX);
DECLARE @query nvarchar(max) = N'SELECT [Pic],[Type],[Label] FROM TrainPic';
EXEC #TempPP @query,@mm OUTPUT;
INSERT INTO 模型表(模型名稱,模型) VALUES(N'快速羅吉斯(多選即時3)',@mm)

SELECT * FROM 模型表
GO
--

--DROP TABLE 模型表;
--TRUNCATE TABLE 模型表;
CREATE TABLE 模型表
(
    編號 INT IDENTITY(1,1) PRIMARY KEY,
	模型名稱 NVARCHAR(20),
	模型 VARBINARY(MAX),
	建檔時間 DATETIME2(2) DEFAULT SYSDATETIME()
)
GO

--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--測所有圖片
DECLARE @savedmodel VARBINARY(MAX);
SELECT @savedmodel=模型 FROM 模型表 WHERE 編號=5;

DECLARE @query NVARCHAR(MAX);
SET @query=N'SELECT * FROM TestPic ORDER BY NEWID()';

EXEC sp_execute_external_script 
  @language = N'R',
  @script = N'
    mod <- rxUnserializeModel(model);
    
	testdata<-data.frame(InputDataSet,stringsAsFactors = FALSE);
	testdata[] <- lapply(testdata, function(x) if (is.factor(x)) as.character(x) else {x})
	predict_result <- rxPredict(modelObject = mod, data = testdata,extraVarsToWrite = "Label");	
		
	 print(summary(predict_result));
	 print(predict_result);

	OutputDataSet <- predict_result;
  '
  ,@input_data_1 = @query
  ,@params = N'@model varbinary(max)'
  ,@model=@savedmodel
GO

SELECT * FROM 模型表
GO

---預存程式: 測圖片
ALTER PROC EvalObject @PathInfo NVARCHAR(128)
AS
	CREATE TABLE #Test
	(
		[Pic] NVARCHAR(128),
		[Type] NVARCHAR(128),
		[Label] INT
	);			
	INSERT INTO #Test([Pic],[Type],[Label]) VALUES(@PathInfo,N'',0);
		
	CREATE TABLE #TempResult
	(		
		[PredictedLabel] INT,
		Score1 FLOAT,Score2 FLOAT,Score3 FLOAT,
		Score4 FLOAT,Score5 FLOAT,Score6 FLOAT,
		Score7 FLOAT,Score8 FLOAT,Score9 FLOAT,
		Score10 FLOAT,Score11 FLOAT,Score12 FLOAT,
		Score13 FLOAT,Score14 FLOAT,Score15 FLOAT,
		Score16 FLOAT
	);
	
	DECLARE @savedModel varbinary(max);
	SELECT @savedModel = 模型 FROM 模型表 WHERE 編號=5;
	
	INSERT INTO #TempResult
	EXEC sp_rxPredict @model = @savedModel,@inputData = N'SELECT [Pic],[Label] FROM #Test';

	SELECT A.Type,B.*
	FROM [dbo].[ObjectType] AS A JOIN #TempResult AS B ON A.Id=B.[PredictedLabel]
GO

--找不到預存程序 'sp_rxPredict'。
--https://dotblogs.com.tw/stanley14/2018/06/16/sqlmachinelearning_sp_rxpredict
sp_configure 'clr enabled', 1 
GO 
RECONFIGURE 
GO

/*
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--即時評分 功能安裝

1. cd C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\R_SERVICES\library\RevoScaleR\rxLibs\x64

2. RegisterRExt.exe /installRts [/instance:name] /database:databasename
   RegisterRExt.exe /installRts /instance:MSSQLSERVER
   RegisterRExt.exe /installRts /database:Titantic

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------1
*/
--

EXEC EvalObject N'G:\AI_BIGDATA\109-大數據資料分析及AI實戰班\梓君老師\AI\海關圖\刀子\1.jpg';
EXEC EvalObject N'G:\AI_BIGDATA\109-大數據資料分析及AI實戰班\梓君老師\AI\海關圖\鈔票\USD100-背面-2.jpg';
EXEC EvalObject N'I:\kkk.jpg';

/*
可使用老師寫的 Win_TestPicClassify 
開圖片測試程式呼叫EvalObject預存程式
*/
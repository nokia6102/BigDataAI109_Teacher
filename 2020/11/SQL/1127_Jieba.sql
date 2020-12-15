EXEC sp_execute_external_script  
	@language = N'Python'  
	, @script = N'
import jieba
#jieba.set_dictionary("dict.txt.big")

sentence = "�W�߭��ֻݭn�j�a�@�_�ӱ��s�A�w��[�J�ڭ̪���C�I"
print ("Input�G", sentence)
words = jieba.cut(sentence, cut_all=False)
print ("Output ��T�Ҧ� Full Mode�G")
for word in words:
	print (word)
'
----
EXEC sp_execute_external_script  
	@language = N'Python'  
	, @script = N'
import jieba
#jieba.set_dictionary("dict.txt.big")

#Ū�J���ε�
stopWords=[]
with open("C:\\PP\\MyStopWords.txt", "r", encoding="UTF-8") as file:
    for data in file.readlines():
        data = data.strip()
        stopWords.append(data)

sentence = "�W�߭��ֻݭn�j�a�@�_�ӱ��s�A�w��[�J�ڭ̪���C�I"
print ("Input�G", sentence)
words = jieba.cut(sentence, cut_all=False)

#��ﰱ�ε��A�O�d�Ѿl���J
remainderWords=[]
remainderWords = list(filter(lambda a: a not in stopWords and a != "\n", words))

print(remainderWords)
'
-----
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE DATABASE MyNews
USE MyNews;

--DROP TABLE MainCatalog;
CREATE TABLE MainCatalog
(
    MainId INT PRIMARY KEY,
	CatalogName NVARCHAR(20)
);
 
INSERT INTO MainCatalog VALUES(1,'�F�v'),(2,'���'),(3,'�]�g'),(4,'���d'),(5,'�B��');
INSERT INTO MainCatalog VALUES(11,'�D�ūD��'),(12,'����'),(13,'����')
INSERT INTO MainCatalog VALUES(21,'���'),(22,'�q��_�C��'),(23,'�Ѥ�')
INSERT INTO MainCatalog VALUES(31,'�Цa��'),(32,'�ѥ�'),(33,'�z�]')
INSERT INTO MainCatalog VALUES(41,'�e�f'),(42,'�'),(43,'�i��')
INSERT INTO MainCatalog VALUES(51,'�βy'),(52,'���y'),(53,'�x�y')
SELECT * FROM MainCatalog
 




CREATE TABLE News
(
	NewsId INT IDENTITY PRIMARY KEY,
	[Label] NVARCHAR(10),
	[News] NVARCHAR(MAX)
)

--TRUNCATE TABLE News
SELECT * FROM News
----
DECLARE @sqlQuery nvarchar(max) = N'SELECT [News] FROM [MyNews].[dbo].[News] WHERE [NewsId]=3'
EXEC sp_execute_external_script @language = N'Python'  
	, @script = N'
import jieba
import pandas as pd

stopWords=[]
with open("C:\\PP\\MyStopWords.txt", "r", encoding="UTF-8") as file:
    for data in file.readlines():
        data = data.strip()
        stopWords.append(data)

#���J�ۭq����r
jieba.load_userdict("C:\\PP\\MyKeyWords.txt")

train_data = InputDataSet
df=pd.DataFrame(train_data)
sentence=df.iloc[0,0]
words = jieba.cut(sentence, cut_all=False)

remainderWords=[]
remainderWords = list(filter(lambda a: a not in stopWords and a!= "\n" and a!="\r\n" and a!=" ", words))

print ("Output ��T�Ҧ� Full Mode�G")
for w in remainderWords:
    print (w)
'
, @input_data_1 = @sqlQuery

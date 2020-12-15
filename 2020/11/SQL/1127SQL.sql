

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

sentence = "�`�Τj�蘆�ѨM�ӭt�A�˥����`�έԿ�H������Q�Ѧb���_����B�ߤW�b�`���e�|��u��e���]�v�F�������ܡA�ާ@��O�u�|����L�A�]������ҭԿ�H�Ӯz�A�n��N�󨺭ӨS�g��B�S��O���A�L�]�ܦP�������Q����Ҭ��t�B���h��@���w�A�C  ��������X���X�A���ֱd�G�������~�ɧ@�����աB���e�`�ΰ��^�E�o���A�I�l����Ҥ���̱�O�A�p���G�ޭ��I�A����֫O�֤j�a�����D�A����쪺��O�B�g���o�W������ܡH  �������ٻ��A�ܦP�������Q����ҳo�Ǭ��t�B���h��@���w�A�A���N�O����Ҥ����������X�ӿ��`�ΡH�������ӯ�O�ܡH���@��Ӥ몺�����N�n���ѡA������ʶܡH����Ҥ����B���X�Կ�H���N�O���X�ӤH�b���a�H�u���x�ʴ��i�D�ڳo�L�{�A�ڻݭn��o�Ǫ����˨_���X�ӶܡH�ӥ��y�F�I�v  �˥��ҿ�e���]���ʰ��F�ϰ�ߩe�B�����ϥߩe�Կ�H�W���ʲ��A�]�ܽкq�⸭���ٵ��H�t�X�A�̫᧺����ο˥��Ұ��`�έԿ�H�E�����b�n���A�����u�������[�v�B�u�����O���v�I���n������աA�����쪺�k�৺���ڤ]�{���U�}�A�@�P���ۡm�ڬ۫H�n�C  ������j�աA�o�����|���@�ɳ��b�ݡA�n�����@�ɨ�ج۬ݡA���D�x�W�����|�O�x�W�H��a�@�D�A�S�������a�B�F�ҥi�H�z�w�B�ާ@�A�⩤�n�M���A�����]�n�F�Ѥ��إ���F���s�b���ƹ�C  ������C�|���A�L�|�j�}�j�ߡB���äϥ��A�B�u���@���B�S���]���C�̫�L�a�Y���ۡu�x�W�ۥѥ��D�U���A���إ���U���v�A�ë�Ū�F�ȩx�N¾�}���C  �����ڪ�ܡA�ܦh�Hı�o�o��B�B�ܦѡA���L���ѡA�u�O�X�D�o���A�o�۫H���˥i�H�ǩӸg��B�զ���j�ζ����j�a�^�m�A�u�o�O�̦n���Ѫ��A�]�|�O�̦n���`�Ρv�C  �����ڷP�ġA�o�����|���ܦh��|�B�~�ѡA�ܦh�H���u�ڰQ���A�B�Q�n�U�[�A�v���ܤ����d�A�P�������i�I�D�ӹ��A�o�����|������D�A���C�ӤH�����߽Ħۤv���ڷQ�A�o���x�W�A�uWe��re very small but we��re great.�v"
print ("Input�G", sentence)
words = jieba.cut(sentence, cut_all=False)

#��ﰱ�ε��A�O�d�Ѿl���J
remainderWords=[]
remainderWords = list(filter(lambda a: a not in stopWords and a != "\n", words))

print(remainderWords)

'
DECLARE @ss NVARCHAR(1024)=  (
SELECT
       [News]
  FROM [MyNews].[dbo].[News]
  WHERE [NewsId]=3  )
 SELECT @ss 

EXEC #TempPP @ss;

ALTER PROC #TempPP @ss NVARCHAR(MAX) 
AS
	EXECUTE sp_execute_external_script @language = N'Python',  
	  @script = N'   
import jieba
#jieba.set_dictionary("dict.txt.big")

#Ū�J���ε�
stopWords=[]
with open("C:\\PP\\MyStopWords.txt", "r", encoding="UTF-8") as file:
    for data in file.readlines():
        data = data.strip()
        stopWords.append(data)

print ("ss = ", sentence)
print ("Input�G", sentence)
words = jieba.cut(sentence, cut_all=False)

#��ﰱ�ε��A�O�d�Ѿl���J
remainderWords=[]
remainderWords = list(filter(lambda a: a not in stopWords and a != "\n", words))

print(remainderWords)
';
GO
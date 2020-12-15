#####用python的sort練習排序DataFrmae#####

#--python排序法練習--


#sort()

cars=['honda','mazda','bmw','benz','toyota','ford']
print('目前串列內容=',cars)
print('使用sort()由小排到大')
cars.sort(reverse=True)
print('排序串列結果=',cars)

aaa = [5,3,9,2]
print ('目前串列內容',aaa)
print ('使用sort()由小排到大')
aaa.sort()
print ('排列後的結果=',aaa)

######--sorted()--
#---------使用sorted()把資料倒回去給另一個變數
CH = ['趙淑芬','郭源潮','陳志豪','張天銘','林幸涵']
CH_1=(sorted(CH))
print(CH_1)

#---------sorted()排序法排list-----------
QQQ = [
    ('John','A',19),
    ('Bob','B',15),
    ('Amy','C',18)
]
#把結果倒給QQQ1
QQQ1=sorted(QQQ,key=lambda s: s[1]) #S[1]:使用第2個值來進行排序
print(QQQ1)

#####---排序DataFrame

import numpy as np
import pandas as pd
from sklearn import datasets
iris = datasets.load_iris()
iris_df = pd.DataFrame(data = np.c_[iris['data'],iris['target']],
                    columns = iris['feature_names']+['class'])
####上面先倒進一些DataFrame資料，指定給iris這個變數
print(iris_df)#顯示他

iris_df_2=iris_df.sort_index(axis=1) 
#axis指定為1，上面的行名排列倒過來排，稱他為iris_df_2
print(iris_df_2)#顯示他

iris_df_3=iris_df.sort_index(axis=0) 
#axis指定為0，跟最原始的iris_df幾乎沒變，0好像沒什麼效果，稱他為iris_df_3
print(iris_df_3)#顯示他

iris_df_4=iris_df.sort_values('sepal width (cm)') 
#指定特定的行作排序，此例中選sepal width (cm)這行，要python以這行的值為主進行排序
#稱他為iris_df_3
print(iris_df_4)#顯示他

iris_df_5=iris_df.sort_values('sepal width (cm)', ascending = False)
#指定特定的行作排序，此例中選sepal width (cm)這行，要python以這行的值為主進行排序
#ascending = False表示由大排到小
#稱他為iris_df_5
print(iris_df_5)#顯示他
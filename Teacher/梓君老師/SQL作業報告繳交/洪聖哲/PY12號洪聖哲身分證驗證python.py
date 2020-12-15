import numpy as np
import pandas as pd
import sklearn as skl
import matplotlib as mat

'''
python作業，身分證驗算練習
使用者輸入他的身分證字號，要去驗算他輸入的是否正確
'''

ID_numberInput=input('請輸入身分證字號')

#假設使用者在某個地方輸入了他的身分證字號
#把輸入的字串存入ID_numberInput
#↓把輸入進來的字串切開取值
mynumber_a=str(ID_numberInput[0])
mynumber_b=int(ID_numberInput[1])
mynumber_c=int(ID_numberInput[2])
mynumber_d=int(ID_numberInput[3])
mynumber_e=int(ID_numberInput[4])
mynumber_f=int(ID_numberInput[5])
mynumber_g=int(ID_numberInput[6])
mynumber_h=int(ID_numberInput[7])
mynumber_i=int(ID_numberInput[8])
mynumber_j=int(ID_numberInput[9])


if mynumber_a == 'A':
    letteA=1
    letteB=0
elif mynumber_a == 'B':
    letteA=1
    letteB=1
elif mynumber_a == 'C':
    letteA=1
    letteB=2
elif mynumber_a == 'D':
    letteA=1
    letteB=3
elif mynumber_a == 'E':
    letteA=1
    letteB=4
elif mynumber_a == 'F':
    letteA=1
    letteB=5
elif mynumber_a == 'G':
    letteA=1
    letteB=6
elif mynumber_a == 'H':
    letteA=1
    letteB=7
elif mynumber_a == 'j':
    letteA=1
    letteB=8
elif mynumber_a == 'k':
    letteA=1
    letteB=9
elif mynumber_a == 'L':
    letteA=2
    letteB=0
elif mynumber_a == 'M':
    letteA=2
    letteB=1
elif mynumber_a == 'N':
    letteA=2
    letteB=2
elif mynumber_a == 'O':
    letteA=3
    letteB=5
elif mynumber_a == 'P':
    letteA=2
    letteB=3
elif mynumber_a == 'Q':
    letteA=2
    letteB=4
elif mynumber_a == 'R':
    letteA=2
    letteB=5
elif mynumber_a == 'S':
    letteA=2
    letteB=6
elif mynumber_a == 'T':
    letteA=2
    letteB=7
elif mynumber_a == 'U':
    letteA=2
    letteB=8
elif mynumber_a == 'V':
    letteA=29
    letteB=9
elif mynumber_a == 'W':
    letteA=3
    letteB=2
elif mynumber_a == 'X':
    letteA=3
    letteB=0
elif mynumber_a == 'Y':
    letteA=3
    letteB=1
elif mynumber_a == 'Z':
    letteA=3
    letteB=3
elif mynumber_a == 'I':
    letteA=3
    letteB=4
else:
    print('輸入值有誤，請檢查第一個字母是否大寫')
    #return

#把英文字母轉換成指定的數字，存在letteA、B變數中

ID_text=(letteA+letteB*9+mynumber_b*8+mynumber_c*7+mynumber_d*6+mynumber_e*5+mynumber_f*4+mynumber_g*3+mynumber_h*2+mynumber_i*1)
ID_text=ID_text%10

#身分證公式


if 10-ID_text == mynumber_j:
    ID_text_1 = '正確'
else:
    ID_text_1 = '錯誤'
print(ID_text_1 )

#最後檢查ID_text，如果是0就是正確的，如果不是0就是錯誤

#---settting---Big5
setwd("c:/ddd")
#install.packages("ggplot2")
library(ggplot2)

#1
print ("1. 匯入 Customer,SaleData")
Customer <- read.csv("Customer.txt")
SaleData <- read.csv("SaleData.txt")
head(Customer)
head(SaleData)
print (strrep('-',50))

#2
print ("2. 產生客戶的年齡資料欄位(減20)，加入到客戶資料中")
Customer$Age <- floor(as.numeric(difftime(Sys.Date(),as.Date(Customer$BirthDate), units = "weeks"))/52.25) - 20
head(Customer)
print (strrep('-',50))

#3

theme <- theme(plot.title=element_text(hjust = 0.5,face="bold",size=20,family = "A",color = "#990033"))

print ("3-1. 會員客戶的年齡結構(直方圖)")
ggplot(data = Customer) + geom_histogram(aes(x = Age)) + labs(title = "會員年齡結構",x = "年齡" ,y = "人數") + theme
ggsave("3_1_會員年齡結構.png")

print ("3-2. 會員客戶 男/女的年齡結構(堆疊直方圖)")
ggplot(Customer, aes(x = Age, fill = Gender)) +   geom_bar(position = "stack")
ggsave("3_2_會員男女年齡結構(堆疊).png")

print ("3-3. 會員客戶 男/女的年齡結構(並列直方圖)")
ggplot(Customer, aes(x = Age, fill = Gender)) +   geom_bar(position = "dodge")
ggsave("3_3_會員男女年齡結構(並列).png")
#3-4
print ("年收入分組：1~17")
print ("1~3、3~7、7~10、11~17")
print ("3-4. 會員客戶的年收入結構(直方圖)")
#ggplot(data = Customer) + geom_histogram(aes(x = Age)) + labs(title = "會員年齡結構",x = "年齡" ,y = "人數") + theme
#ggsave("3_4_會員年齡結構.png")

ggplot(data = Customer) + geom_histogram(aes(x = YearlyIncome)) + labs(title = "會員年收入結構") + theme
ggsave("3_4_會員年收入結構.png")


print ("3-5. 會員客戶 男/女的年收入結構(堆疊/並列 直方圖)")
#ggplot(Customer, aes(x = YearlyIncome, fill = Gender)) +   geom_bar(position = "stack") 

ggplot(Customer, aes(Customer$YearlyIncome)) + geom_histogram(bins = 4)
ggsave("3_5_會員男女年收入結構.png")

#d1<-discretize(Customer,"equalwidth",17)


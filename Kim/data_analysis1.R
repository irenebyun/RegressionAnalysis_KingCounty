install.packages("parsedate")
install.packages("lubridate")

library(readxl)
library(dplyr)
library(psych)
library(parsedate)
library(lubridate)
library(RColorBrewer)

data <- read.csv("kc_house_data.csv", header = TRUE)


# ���κ� �м� ����
analysis <- data[,c(2,3:8)]


# �ŷ� ��¥ parse
analysis$date.parsed <- parsedate::parse_date(analysis$date)

# �ŷ� ��¥�� ��,��,��,���� ����
analysis$date.year <- lubridate::year(analysis$date.parsed)
analysis$date.month <- lubridate::month(analysis$date.parsed)
analysis$date.day <- lubridate::day(analysis$date.parsed)
analysis$date.ofweek <- lubridate::wday(analysis$date.parsed, label = TRUE)

analysis$date.yearmonth <- paste0(analysis$date.year,"-",analysis$date.month)

par(mfrow =c(1,1))

barplot(sort(table(analysis$date.year), decreasing = TRUE),
        main = "House Sales in King County by year",
        xlab = "year",
        ylab = "number of sales")

barplot(table(analysis$date.month),
        main = "House Sales in King County",
        xlab = "month",
        ylab = "number of sales")

# RcolorBrewer
color.palette <- RColorBrewer::brewer.pal(n=9, name = "PuBu")

#����� �ŷ����� ���� (����~������ ����)
barplot(table(analysis$date.yearmonth),
        col = color.palette,
        main = "House Sales in King County by year",
        xlab = "Year-Month",
        ylab = "number of sales")


# ȭ��� ������ ���� ���� ��
analysis$totalrooms <- analysis$bathrooms + analysis$bedrooms

# ��� ��� ���� 
analysis$priceperroom <- analysis$price / analysis$totalrooms

# ���� ��հ����� 5% ���� ���
roomaverage <- mean(analysis$priceperroom, trim = 0.05)

# �� ������ �з�(��� ã�ƺ� ��)
analysis$priceperroom.group <- cut(analysis$totalrooms, breaks = c(0, 3, 7, 10, 35), right=FALSE)
levels(analysis$priceperroom.group) <- c("����", "����", "����", "�ʴ���")

sum(analysis$priceperroom.group == "����")
sum(analysis$priceperroom.group == "����")
sum(analysis$priceperroom.group == "����")
sum(analysis$priceperroom.group == "�ʴ���")

# 1����, ������ �з�
analysis$hasfloors.group <- cut(analysis$floors, breaks = c(0,1,5), right = TRUE)
levels(analysis$hasfloors.group) <- c("1����", "������")

sum(analysis$hasfloors.group == "1����")
sum(analysis$hasfloors.group == "������")

sum(analysis$hasfloors.group == "1����" & analysis$priceperroom.group == "����")
sum(analysis$hasfloors.group == "1����" & analysis$priceperroom.group == "����")
sum(analysis$hasfloors.group == "1����" & analysis$priceperroom.group == "����")
sum(analysis$hasfloors.group == "1����" & analysis$priceperroom.group == "�ʴ���")

# �� 1���� ���� ��� �� �� ������ ���� ���
by(analysis$price, analysis$priceperroom.group, mean)
by(analysis$price, analysis$hasfloors.group, mean)

sum(analysis$hasfloors.group == "������" & analysis$priceperroom.group == "����")
sum(analysis$hasfloors.group == "������" & analysis$priceperroom.group == "����")
sum(analysis$hasfloors.group == "������" & analysis$priceperroom.group == "����")
sum(analysis$hasfloors.group == "������" & analysis$priceperroom.group == "�ʴ���")

mean(analysis$price[analysis$hasfloors.group == "1����" & analysis$priceperroom.group == "����"])
mean(analysis$price[analysis$hasfloors.group == "������" & analysis$priceperroom.group == "����"])

# ���� ũ�⺰ ���� ���(���� ũ�� �з��� ���Ƿ� ����)
XLmeanprice <- mean(analysis[analysis$priceperroom.group == "�ʴ���", "price"])
Lmeanprice <- mean(analysis[analysis$priceperroom.group == "����", "price"])
Mmeanprice <- mean(analysis[analysis$priceperroom.group == "����", "price"])
Smeanprice <- mean(analysis[analysis$priceperroom.group == "����", "price"])

mean(analysis$price)

# vector for house sizes
housesizes <- c(XLmeanprice, Lmeanprice, Mmeanprice, Smeanprice)

#�ٸ� �����ͺ� barplot(������ ���� �ʿ�)
par(mfrow = c(2,2))
for(i in 3:7){
    barplot(table(analysis[  ,i]),
         main = paste0("Barplot of ", colnames(analysis)[i] ))
}

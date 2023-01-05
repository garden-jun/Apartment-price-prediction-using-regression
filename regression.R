# work directory 설정
setwd("C:/TermProject")

# data 불러오기
data = read.csv(file="train.csv", header = T, fileEncoding = "utf-8")
# 분석할 dataframe 구축
data_seoul <- data[data$city=="서울특별시",]
data_seoul2 <- data_seoul[data_seoul$dong == "화양동",]
data = subset(data_seoul2,select = c("transaction_id", "exclusive_use_area","year_of_completion","transaction_year_month", "floor", "transaction_real_price"))
str(data)
summary(data)
# data 바로 접근
attach(data)

#------------------------------------------------------------------------------------
# 산점도 행렬 그리기
windows()
plot(data)
# 전용면적 실거래가
windows()
plot(exclusive_use_area, transaction_real_price)
# 설립일자 실거래가
windows()
plot(year_of_completion, transaction_real_price)
# 거래년월 실거래가
windows()
plot(transaction_year_month, transaction_real_price)
# 층 실거래가
windows()
plot(floor, transaction_real_price)

#------------------------------------------------------------------------------------
# 일반 모델
model = lm(transaction_real_price ~ exclusive_use_area + year_of_completion + transaction_year_month + floor, data = data)
summary(model)
plot(model)

# 잔차 플롯
res = resid(model)
plot(res)
plot(fitted(model), res)
plot(exclusive_use_area, res)
plot(year_of_completion, res)
plot(transaction_year_month, res)
plot(floor, res)

# 이상치가 나온 잔차 직접 확인.
data["47439",]
fitted(model)["47439"]
residuals(model)["47439"]
rstudent(model)["47439"]

# 이상치 확인
car::outlierTest(model)

# 멱변환 필요성 확인
summary(car::powerTransform(data$transaction_real_price))

# 다중공선성 확인
require(car)
vif(model)

# 자기상관성 확인
durbinWatsonTest(model)

#------------------------------------------------------------------------------------
# 이상치 제거하였을때 model
data2 = data[!(data$transaction_id == 47439), ]
data2 = subset(data2,select = c("exclusive_use_area","year_of_completion","transaction_year_month", "floor", "transaction_real_price"))
model2 = lm(transaction_real_price ~ exclusive_use_area + year_of_completion + transaction_year_month + floor, data = data2)
summary(model2)
plot(model2)
# 또다른 이상치 존재 확인
car::outlierTest(model2)
# 다중공성선
vif(model2)
# 멱변환 필요성 확인
summary(car::powerTransform(data$transaction_real_price))

#------------------------------------------------------------------------------------
# 시계열 데이터 처리를 위한 모델 만들기
data3 = data[-1, ]
#data3$year_of_completion2 = data$year_of_completion[1:370]
data3$transaction_year_month2 = data$transaction_year_month[1:370]
model3 = lm(transaction_real_price ~ exclusive_use_area + year_of_completion + transaction_year_month + transaction_year_month2 + floor, data = data3)
summary(model3)
plot(model3)

# 다중공선성 확인
vif(model3)

# 서울 화양동 아파트의 설립일자, 면적, 거래 년 월, 층에 따른 실거래가 분석 및 예측

## 1.	데이터 요약 및 설명: 모든 변수에 대한 그래픽 표시 또는 수치 요약 및 결과 설명
### 1.	반응변수
-	Y: transaction_real_price: 실거래가
### 2.	예측변수
-	X1: exclusive_use_area: 전용면적
-	X2: year_of_completion: 설립일자
-	X3: transaction_year_month: 거래년월
-	X4: floor: 층
### 3.	수치적 설명 (기초통계량 (최소값, 중앙값, 평균, 최대값, 4분위 수))
![image](https://user-images.githubusercontent.com/79080825/210826831-c5541b83-c49a-45ea-8a93-a29e5cc76467.png)
### 4.	그래픽 디스플레이
1) Data셋 산점도 행렬

    ![image](https://user-images.githubusercontent.com/79080825/210826939-88fa389c-b759-4162-92ad-fc8f26874c9c.png)

2) 실거래가 – 전용면적

    ![image](https://user-images.githubusercontent.com/79080825/210827189-7bbbfc31-0f11-4365-8d23-3b0b9ed6c21e.png)

3)	실거래가 – 설립일자

    ![image](https://user-images.githubusercontent.com/79080825/210827210-6eaef879-15cd-4628-b150-3abefe135ee3.png)

4)	실거래가 – 거래년월

    ![image](https://user-images.githubusercontent.com/79080825/210827245-8c1393d7-be45-431d-b254-b97d2703c122.png)

5)	실거래가 – 층 수

    ![image](https://user-images.githubusercontent.com/79080825/210827266-dafbd082-7417-476b-917f-671d12c54422.png)


### 5.	데이터 요약
-	전용면적이 커질수록 실거래가가 대체로 증가한다
-	설립일자가 최근에 가까울수록 실거래가가 대체로 감소한다.
-	거래년월이 최근에 가까울수록 실거래가가 대체로 증가한다. 또한 낮은 가격대의 매물이 새로 생겼으며, 마찬가지로 최근에 가까울수록 증가하는 경향이 있다.
-	낮은 가격대의 아파트는 13층 이하에 몰려있음을 알 수 있다.
-	30000~50000 가격대의 아파트는 전체적으로 고르게 있음을 알 수 있다.
-	최근에 지은 아파트는 층수가 낮고 낮은 가격대에 있음을 알 수 있다.
 
## 2. 적합하다고 생각되는 선형 회귀 모델 구축

### 1.	Model 1번 (시계열 변수 적용 x)
Y = B0 + B1X1 + B2X2 + B3X3 + B4X4 + e
- Y: transaction_real_price
- X1: exclusive_use_area
- X2: year_of_completion
- X3: transaction_year_month
- X4: floor
- e: 잔차

### 2.	Model 2번 (시계열 변수 적용 o) 
Y = B0 + B1X1 + B2X2 + B3X3 + B4X4 + B5X5 + e
- Y: transaction_real_price
- X1: exclusive_use_area
- X2: year_of_completion
- X3: transaction_year_month 
- X4: transaction_year_month2 (직전 거래의 거래년월) 
- X5: floor
- e: 잔차
 
## 3.	진단을 사용하여 모델을 평가합니다. 변환, 이상값 제거 등과 같이 정당하다고 생각되는 조치 취하기
### 1.	Model1의 summary 확인. 
  ![image](https://user-images.githubusercontent.com/79080825/210830457-6c71e689-ad87-438b-8405-97613f622ed9.png)

  - Model의 summary를 살펴보면, year_of_completion은 10%이내에서, 나머지 예측변수는 0.1% 이내에서 유의미한 결과를 가지므로 회귀계수는 모두 0이 아니라고 할 수 있다.
또한 R-squared값또한 0.924의 높은 수치를 가지므로 예측변수들은 모두 의미 있는 값을 지니고 있다고 볼 수 있다.

### 2.	QQplot을 통해 이상치 확인
  ![image](https://user-images.githubusercontent.com/79080825/210830496-b7138eb7-de19-4118-8208-9e92ed960b3a.png)

  - 위의 그림에서 보는 것처럼 Q-Q plot에서 47439번(transaction_id) 데이터가 이상치인 것을 제외하고 통계의 가정을 잘 만족시키는 것을 알 수 있다.

### 3.	잔차-인덱스 plot 확인 
  ![image](https://user-images.githubusercontent.com/79080825/210830524-e2045654-c3d3-4c0e-89ec-46d182cf5e02.png)

  - 잔차-index plot을 그려보았을 때 특정한 패턴이 보이지는 않는다.
  - index번호 25정도에서 매우 낮은 잔차를 보유하고 있음을 확인 할 수 있다. (이상치)

### 4.	잔차-적합값 plot 확인
  ![image](https://user-images.githubusercontent.com/79080825/210830551-04a19c5a-fa47-46d9-afaa-707852996403.png)

  - 잔차-fiited값 plot을 그려보았을 때 특정한 패턴이 보이지는 않는다. 
  - 50000 정도에서 매우 낮은 잔차를 보유하고 있음을 확인할 수 있다. (이상치)
  
### 5.	이상치 확인.
  ![image](https://user-images.githubusercontent.com/79080825/210830649-2fd37eee-4140-4dbf-8543-4e3e5c582828.png)

  - Transaction_id 47439번은 계속 확인한대로 이상치임을 알 수 있다.
  - (이상치에 대한 문제는 밑에서 다시 다룬다.)

### 6.	변수 변환 필요성 확인
  ![image](https://user-images.githubusercontent.com/79080825/210830720-01f770b5-dd06-44a4-ae5d-bf4b8197ec02.png)
 
  - 결과에 의하면 transaction_real_price를 정규화 시키기위해서는 약 0.9승을 할것을 제시하고 있다. 하지만 마지막줄에 람다 = 1이라는 가정을 기각할 수 없으므로(p = 0.35) 이 경우 변수 변환이 실제적으로 필요하다는 강한 증거는 없다.

### 7.	다중공선성 확인 (VIF)
  ![image](https://user-images.githubusercontent.com/79080825/210830786-21d665e2-5f4a-4046-97bc-ba287ae74a95.png)
  
  - 4개의 예측변수 모두 낮은 VIF 값을 가지고 있으므로 다중 공선성은 나타나지 않는다고 생각 해 볼 수 있다.

### 8.	자기상관성 확인
  ![image](https://user-images.githubusercontent.com/79080825/210831026-39fdf8a1-2eb9-4c7e-a6ee-8979d495089c.png)

  - Durbinwatson 통계량의 d의 분포를 확인하였을 때 해당하는 DL 보다 작으므로 자기상관성이 존재함을 확인할 수 있고 시간에 대한 데이터를 사용하였으니 시계열 데이터를 원인으로 생각 해 볼 수 있다.
  - (시계열에 대한 문제는 밑에서 다시 다룬다. J, K)

### 9.	이상치 제거 모델 설명
  ![image](https://user-images.githubusercontent.com/79080825/210831107-58f42c72-f973-4672-a14c-6382ca521df8.png)

  - R-squared값이 살짝 낮아졌지만, 전체적인 VIF값들 또한 낮아져 다중공성선이 더욱 사라지긴하였다. 하지만 이상치의 존재여부가 영향이 커보이진 않아 굳이 제거하여 데이터를 줄일 필요는 없어보인다.

### 10.	시계열 데이터 모델 설명
  ![image](https://user-images.githubusercontent.com/79080825/210831186-953fc65b-7a4a-476d-ac78-4411460b4a38.png)

  - 거래년월에 대한 유의값이 매우 작아진 것을 확인할 수 있다. 이는 최근에 갈수록 아파트가격이 높이지기는 하나, 가격이 싼 저층의 아파트 또한 증가하여 발생한 현상임을 생각해 볼 수 있다. 또한 R-squared값을 크지만 유의값이 작은 변수가 두개 있는 것으로 보아 두 변수는 공선성을 띌 것을 예측해 볼 수 있다. 다음은 시계열 모델에 대한 VIF 값이다.

### 11.	시계열 적용 모델의 VIF값.
  ![image](https://user-images.githubusercontent.com/79080825/210831291-e690745e-cec4-4fc0-b10a-460180bf0e94.png)

  - J에서 예측한대로 두 거래년월 데이터가 높은 공선성을 띔을 알 수 있다. 하지만, 시간에 따른 상관이 있다는 가정하에 시계열모델을 적용하였으므로 두 변수가 높은 공선성을 띄는 것은 너무나 당연할 지도 모른다.
  - 시계열데이터에 대한 처리는 해당 과목에서 자세히 다루지 않았으므로 이정도로 분석하고 넘어가도록 하겠다. (추후 시계열분석 과목을 들은 후 다시 생각해보도록 하겠습니다.)

## 4.	결과 요약 및 한계점

- 결론: 서울 화양동 아파트의 실거래가는 면적, 설립일자, 거래 년 월, 층에 따라 유의미하게 결정될 수 있음을 확인할 수 있었다. 위에서 언급한 모델에 따라 적합된 회귀 방정식은 다음과 같다.
    
    Y(hat)=(-1.444e+06) + (4.173e+02)X1 + (-7.816e+01)X2 + (7.972e+00)X3 + (3.554e+02)X4
- 따라서 실거래가는 면적이 증가할수록 증가하고, 설립일자가 최근일수록 감소하며, 거래일자가 최근일수록 증가하고, 층수가 높을수록 증가하는 경향이 있다.

- 나의 분석의 한계점: 시계열 문제를 제대로 해결하지 못하여 자기상관성 문제를 해결하지 못한 점이 있다. 나의 문제에서는 아파트 설립일자와(year_of_completion), 거래 년 월(transaction_year_month) 라는 두개의 시계열 데이터가 있었다. 하지만 교재에서 언급했듯이 전년도 예측변수를 추가하여 모델을 구축하고 문제를 해결해 보려고 하였으나, 오히려 (너무나 당연하게도) 전년도와 올해의 예측변수들끼리 다중공성선을 보이는 문제가 나타났다. 그 후 인터넷을 참고하여 시계열 데이터의 문제를 해결하기 위해 여러 모델을 적용시켜 봤음에도 이렇다한 정답은 찾지 못하였고 결국 원래 모델을 적합 시키기로 하였다.

# -------------------------------- ADVANCED ------------------------------------

# [ 고급 1. 적용함수 : 반복연산을 도와주는 함수 ]
# 1.1 apply(X,          # 대상                                                  # *
#          MARGIN = ,   # 방향(1:행별, 2:열별, c(1,2):원소별)
#          FUN = ,      # 적용함수
#          ...)         # 적용함수의 추가 인자

# - X에는 1차원 객체(벡터) 전달 불가, 2차원 데이터 전달 가능 *
# - 출력 결과는 데이터프레임 제외 모든 객체 가능(벡터, 리스트, 행렬) *
# - 주로 행별, 열별 그룹연산 수행을 위해 사용
# - R에서는 "원소별" 적용도 가능(파이썬 불가)

# 예제) 다음의 행렬에서 행별 총합 연산
ma1 <- matrix(1:25, nrow = 5)
ma1[1,1] <- NA
apply(ma1, 1, sum)             # NA 포함
apply(ma1, 1, sum, na.rm = T)  # NA 무시

sum(..., na.rm = F)

# 예제) iris 데이터에서 컬럼별 평균 연산
mean(iris$Sepal.Length)
mean(iris$Sepal.Width)

apply(iris[,-5], 2, mean)

# 예제) 다음의 벡터에서 천단위 구분기호 제거 후 숫자로 변경
v1 <- c('1,100','2,200','3,300')

library(stringr)
as.numeric(str_remove_all(v1, ','))

# 적용함수 전달 방법으로 풀이
f1 <- function(x) {
  as.numeric(str_remove_all(x, ','))
}

apply(v1, c(1,2), f1)       # 벡터 적용 불가
sapply(v1, f1)              # 벡터 적용 가능

# 1.2 lapply(list, function, ...)
# - 원소별 적용 *
# - 주로 벡터의 원소별 적용
# - 데이터 프레임 전달 시 키별 적용
# - 출력 결과 주로 리스트 *
lapply(v1, f1)                 # 리스트 출력
as.data.frame(lapply(v1, f1))  # 데이터프레임 출력(층 -> 컬럼)
as.vector(lapply(v1, f1))      # 벡터 출력 불가(key 구조 유지)
unlist(lapply(v1, f1))         # 벡터 출력 가능(key 구조 해제)

lapply(iris[,-5], mean)        # 컬럼별(key) 적용

# 1.3 sapply(list, function, ...)
# - 원소별 적용*
# - 주로 벡터의 원소별 적용
# - 2차원 데이터 셋의 원소별 적용도 가능*
# - 주로 벡터, 행렬로 리턴*
sapply(v1, f1)

# 1.4 mapply(function, ...)
# - 원소별 적용*
# - lapply, sapply와는 다르게 적용 함수를 1번째 인자로 전달*
# - 주로 벡터, 행렬 리턴
mapply(f1, v1)
mapply(f2, v1, ',')

# 1.5 tapply(vector, index, function)
# tapply(vector,    # 그룹연산 수행 대상(벡터)
#        index,     # 그룹벡터(group by 컬럼)
#        function)  # 적용함수(주로 그룹함수)
tapply(Fruits$Sales, Fruits$Fruit, sum)
# - 그룹별 적용
# - 벡터 자리에는 2차원 적용 불가 *
# - sql의 group by 연산과 비슷
# - 주로 벡터 리턴

tapply(iris[,-5], iris$Species, mean)  # 2차원 데이터 셋 적용 불가

# 예제) googleVis 패키지에 있는 Fruits 데이터에서
# 과일별 sales의 총합 출력

install.packages('googleVis')
library(googleVis)
Fruits

tapply(Fruits$Sales, Fruits$Fruit, sum)

# 예제) profit이 15이상일 경우와 미만일 경우 각 그룹의 sales의 총합             
g1 <- ifelse(Fruits$Profit >= 15, '15이상', '15미만')
tapply(Fruits$Sales, g1, sum)

vsum <- tapply(Fruits$Sales, Fruits$Profit>=15, sum)
names(vsum) <- c('15이하','15이상')

# [ 참고 14 : in sql ]
# select sum(Sales)
#   from Fruits
#  group by Fruit

# [ apply 실습 정리 ]
# 예제) 각 지점의 1분기 매출의 총합
df1 <- read.csv('apply_test2.csv', fileEncoding = 'euc-kr')

# Answer 1
rownames(df1) <- df1$name
df1 <- df1[, -1]

for (i in 1:length(rownames(df1))) {
  df1[i, ] <- str_replace_all(df1[i, ], ',', '')
  df1[i, ] <- str_replace_all(df1[i, ], '-', '0')
  df1[i, ] <- str_replace_all(df1[i, ], '\\.', '0')
  df1[i, ] <- str_replace_all(df1[i, ], '\\?', '0')
}
df1[,] <- sapply(df1, as.numeric)

v1 <- df1[, str_detect(colnames(df1), '.1')]    # 1분기
apply(df1[, str_detect(colnames(df1), '.1')], 1, sum)

# Answer 2
# step 1) ' ', '.', '?' 0으로 치환
# way 1) str_replace_all + apply
str_replace_all(df1, '[-.?]', '0')    # 데이터프레임 적용 불가
apply(df1, c(1, 2), str_replace_all, '[-.?]', '0')
# way 2) 사용자 정의 함수 + apply
f_rep <- function(x) {
  if((x == '-') | (x == '.') | (x == '?')) {    # x %in% c('-', '.', '?')
    '0'
  } else {
    x
  }
}
f_rep(df1)                   # Error => if문에 2차원 전달 불가
apply(df2, c(1, 2), f_rep)   # Wrong => 2차원 적용 가능, 치환 불가 (앞뒤 공백)
str_trim(df1, 'both')        # Error => 2차원 데이터셋에 적용 불가
df1[ , ] <- apply(df1, c(1, 2), str_trim, 'both')
df1[ , ] <- apply(df1, c(1, 2), f_rep)

# step 2) 숫자컬럼 변경 => 컬럼별 형변환이 보다 정확함 (as.numeric(df1$X2007.1))
f2 <- function(x) {
  as.numeric(str_remove_all(x, ','))
}
apply(df1[, -1], c(1, 2), f2)    # way 1
apply(df1[, -1], 2, f2)          # way 2
sapply(df1[, -1], f2)            # way 3

# step 3) 1분기 컬럼 추출
str_detect(colnames(df1), '1$')
df1_1 <- df1[ , str_detect(colnames(df1), '1$')]
rownames(df1_1) <- df1$name

# step 4) 지점별 1분기 매출 총합
apply(df_1, 1, sum)
# ------------------------------------------------------------------------------

# [ 고급 2. 정렬 함수 ]
# 2.1 order(...,                # 정렬대상 (벡터, 데이터프레임 불가)
#          na.last = T,         # NA 배치 순서
#          decreasing = T)      # 정렬 순서
# - 정렬 순서대로 위치값 리턴
# - 벡터만 정렬 가능, 여러 벡터 전달 가능(1차, 2차, ... 정렬 필요 시)
# - 각 벡터마다 정렬 순서 전달 가능
# - 문자와 숫자 벡터의 동시 정렬 시 정렬 순서 전달 오류 발생 (method 지정 필요)
# - 데이터프레임 직접 정렬 불가, 위치값 기반 색인으로 해결

v1 <- c(1, 10, 2, 9, 4)
order(v1)                       # 위치값 리턴 (1 3 5 4 2)
v1[order(v1)]                   # 정렬결과 (순서대로 행 재배치)

# 예제) emp 데이터에서 sal이 큰 순서대로 정렬
emp
order(emp$SAL, decreasing = T)
vord <- order(emp$SAL, decreasing = T)
emp[vord, ]
'월' < '화'
# 예제) emp 데이터에서 deptno가 작은순 정렬,
#       같은 deptno 내에서는 sal이 큰 순서대로 정렬
vord <- order(emp$DEPTNO, emp$SALARY, decreasing = c(F, T))    # 둘다 내림차순이 됨
emp[vord, ]

# 2.2 sort
sort(x,                     # 정렬대상
     decreasing = ,         # 정렬순서
     ...)                   # 기타옵션

sort(v1)                    # 정렬결과 직접 출력
sort(emp$SALARY)            # sort의 결과로는 데이터프레임 정렬 불가
# - 하나의 벡터만 정렬 가능
# - 정렬 결과는 정렬 순서대로 정렬된 결과 직접 리턴

# 2.3 doBy::orderBy
install.packages('doBy')
library('doBy')

doBy::orderBy(formula = ,     # Y ~ X1 + X2
              data = )        # 정렬할 데이터프레임
# - 데이터프레임 정렬 가능
# - formular에 정렬하고자 하는 여러 컬럼 나열 가능
# - formular의 +, - 기호로 각 정렬 순서 전달 가능

# Y ~ X
# iris$Species ~ iris$Sepal.Length + ... +

# 예제) emp 데이터에서 sal이 낮은 순서대로 정렬
orderBy( ~ SAL, emp)

# 예제) emp 데이터에서 deptno, sal이 낮은 순서대로 정렬
orderBy( ~ SAL + DEPTNO, emp)

# 예제) emp 데이터에서 deptno는 낮은순, sal이 높은 순서대로 정렬
orderBy( ~ DEPTNO - SAL, emp)
# ------------------------------------------------------------------------------

# [ 고급 3. sampling ]
# 3.1 sample(x,            # 추출할 원본 데이터(벡터)
#            size = ,      # 추출 개수
#            replace = ,   # 복원 추출 여부
#            prob = )      # 추출 비율
# - row number를 사용한 표본 추출
# - group name/group number를 사용한 표본 추출
# - class별 균등 추출 불가 (대체적으로 raw data 비율과 비슷하게 추출됨)

sample(c(1, 3, 5, 13, 5, 7), size = 1)
sample(c(1, 3, 5, 13, 5, 7), size = 10)    # 모집단보다 더 큰 표본 추출 불가
sample(c(1, 3, 5, 13, 5, 7), size = 10,
       replace = T)                        # 모집단보다 더 큰 표본 추출 가능
sample(1:2, size = 150, replace = T, prob = c(0.7, 0.3))

# [ 예제 - iris data를 70%, 30%의 두 집단으로 분리 ]
# 1) row number를 사용한 표본 추출
v_rn <- sample(1:nrow(iris), size = nrow(iris) * 0.7)

iris_train <- iris[v_rn, ]
iris_test <- iris[-v_rn, ]

nrow(iris_train)             # 150 * 0.7 = 105건 추출 확인
nrow(iris_test)              # 150 * 0.3 =  45건 추출 확인

table(iris$Species)          # 1 : 1 : 1의 비율
table(iris_train$Species)    # 1 : 1 : 1의 비율은 아니지만 비슷

# 2) group name/group number를 사용한 표본 추출
v_gname <- sample(c('a', 'b'),                 # a, b로 구성된 표본 추출
                  size = nrow(iris),             # 추출된 표본 개수
                  replace = T,                   # 복원추출 허용
                  prob = c(0.7, 0.3))            # a가 선택될 확률 70%

iris_train2 <- iris[v_gname == 'a', ]
iris_test2 <- iris[v_gname == 'b', ]

nrow(iris_train2)    # 105 => win에서는 112
nrow(iris_test2)     #  45 => win에서는  38

table(iris$Species)          # 50 : 50 : 50의 비율
table(iris_train2$Species)    # 40 : 35 : 30의 비율

# 3.2 doBy::samplyBy
# - data frame에서 직접 표본 추출 가능
# - 추출된 표본(train) 이외의 집단(test) 추출이 어려움
# - class별 균등 추출 가능
library(doBy)
samplyBy(formula = ,         # ~ Y
         frac = ,            # 추출 비율
         replace = ,         # 복원 추출 여부
         data = )            # raw data

# [ 예제 - iris data를 70%, 30%의 두 집단으로 분리 ]
# step 1) train set 추출
iris_train3 <- sampleBy( ~ Species, frac = 0.7, data = iris)
nrow(iris_train3)            # 105 * 0.7 = 105건 추출
table(iris_train3$Species)    # 35 : 35 : 35의 비율

# step 2) test set의 row number 획득
# way 1) 위치기반 추출
v_lo <- str_locate(rownames(iris_train3), '\\.')[ , 1]
v_rn <- str_sub(rownames(iris_train3), v_lo + 1)

# way 2) str_c
str_c(iris$Species, '.', rownames(iris)) %in%  rownames(iris_train3)

# way 3) 분리기반 추출
str_split(rownames(iris_train3), '\\.')    # 각 층마다 추출 어려움 => 함수 생성

f_split <- function(x) {
  as.numeric(str_split(x, '\\.')[[1]][2])
}

v_rn2 <- sapply(rownames(iris_train3), f_split)
sum(v_rn != v_rn2)    # 같은게 없다

# step 3) row number 기반 반대 집단 추출
# way 1)
iris_test3 <- iris[-v_rn, ]
# way 2)
iris_test4 <- iris[!(str_c(iris$Species, '.', rownames(iris)) %in%  rownames(iris_train3)), ]
# way 3)
iris_test5 <- iris[-v_rn2, ]

nrow(iris_test3)
table(iris_test3$Species)
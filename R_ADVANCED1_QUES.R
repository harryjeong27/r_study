# [ 적용함수 ]
# -------------------------------연 습 문 제------------------------------------
# 연습문제 25. seoul_new.txt 파일을 불러와서 다음의 형태를 갖는 데이터프레임 생성
# 사용자로부터 삭제할 대상을 전달받아 삭제하는 사용자 정의함수 생성,
# 다음의 데이터 프레임에 적용
df1 <- data.frame(col1 = c('1,100', '1,200'),
                  col2 = c('2,200', '2,300'),
                  stringsAsFactors = F)

f2 <- function(data, y) {
  as.numeric(str_remove_all(data, y))
}

f2(data = df1, y = ',')                # 2차원 전달 불가
apply(df1, c(1,2), f2, ',')            # 2차원 전달 가능
sapply(df1, f2, ',')                   # 2차원 전달 가능

df1 <- as.data.frame(apply(df1, c(1,2), f2, ','))    # data frame
df1 <- apply(df1, c(1,2), f2, ',')                   # matrix로 생성
df1[,] <- apply(df1, c(1,2), f2, ',')                # 기존 data frame 유지

# 연습문제 26
# 26.1 emp.csv 파일을 읽고 상/하반기 입사자의 평균연봉
df1 <- read.csv('emp.csv', stringsAsFactors = F)
# 연도 뽑아내기 1
secondhalf <- as.numeric(as.character(as.Date(df1$HIREDATE, '%Y-%m-%d'), '%m')) > 6 # 하반기
firsthalf <- as.numeric(as.character(as.Date(df1$HIREDATE, '%Y-%m-%d'), '%m')) <= 6 # 상반기

mean(df1[firsthalf, 'SAL'])
mean(df1[secondhalf, 'SAL'])

# 연도 뽑아내기 2
vmonth <- as.numeric(str_sub(df1$HIREDATE, 6, 7))
vgroup <- ifelse(vmonth < 7, '상반기', '하반기')
tapply(df1$SAL, vgroup, mean, na.rm = T)

# 26.2 2000-2013년_연령별실업율_40-49세.csv 파일을 읽고
# 2005년 ~ 2009년에 대해 각 월별, 연도별 실업률 평균
# 단, 연도 선택은 연도만 사용하여 표현, 예) year >= 2005
df2 <- read.csv('2000-2013년_연령별실업율_40-49세.csv', fileEncoding = "euc-kr")
library(stringr)

# Answer 1
colnames(df2)[2:15] <- str_sub(colnames(df2)[2:15], 2, 5)
rownames(df2) <- df2[ , 1]
df2 <- df2[ , -1]
mean(as.numeric((df2[1, colnames(df2)[6:10]])))

# Answer 2 
rownames(df2) <- str_c(df2$월, '월')
df2 <- df2[, -1]
# 1) 월별 실업률 평균
apply(df2, 1, mean)    # 1 => 행별

# 2) 연도별 실업률 평균
colnames(df2) <- as.numeric(str_remove_all(colnames(df2), '[X년]'))    # 행, 열 이름은 숫자로 바꿔도 다시 문자로 저장됨
apply(df2, 2, mean)    # 2 => 열별

# 연습 문제 27
# 1) apply_test.csv 파일을 읽고
# 부서별 판매량의 총합을 구하세요.
# 단, 각 셀이 -인 경우는 0으로 치환 후 계산
# (치환함수의 적용으로 풀이)
df3 <- read.csv('apply_test.csv', fileEncoding = "euc-kr")

# step 1) NA 또는 '-'값 0으로 수정
ifelse(is.na(df3), 0, df3)    # 리스트 형식으로 나오고 NA도 바뀌지 않음 => ifelse는 2차원 적용 불가
df3[is.na(df3)] <- 0          # 데이터 선택 후 수정 가능
str_replace_na(df3, 0)        # Error => 2차원 적용 불가

f_na <- function(x) {                 # 스칼라용 함수
  if ((x == '-') | is.na(x)) {
    return(0)
  } else {
    return(x)
  }
}

f_na('-')
f_na(NA)

# 2차원 데이터 셋의 원소별 적용이 필요
df3[, ] <- apply(df3, c(1, 2), f_na) # 2차원 적용, c(1, 2)로 위에 저장된 스칼라 하나씩 적용
sapply(df3, f_na)                    # 2차원 데이터 셋 적용 불가, 주로 벡터 적용

# 2차원 데이터 셋의 원소별 적용 : apply
# 1차원 데이터 셋의 원소별 적용 : sapply

# step 2) 2~5번째 컬럼 숫자컬럼으로 변경
as.numeric(df3[, -1])
df3[, -1] <- apply(df3[, -1], c(1, 2), as.numeric)    # way 1 
sapply(df3[, -1], as.numeric)                         # way 2

# step 3) 연도와 상관없이 각 행의 총합
df3$total <- apply(df3[, -1], 1, sum)

# step 4) 부서번호 가공
str_split(df3$deptno.name, '-')[[i]][1]    # 벡터에 split 사용 안되므로 함수 만듦
f_split <- function(x) {                   # 스칼라용 함수
  str_split(x, '-')[[1]][1]
}

f_split(df3$deptno.name)                         # 벡터 적용 안됨
df3$deptno <- sapply(df3$deptno.name, f_split)   # 벡터 연산 가능 (원소별 적용)

# step 5) 부서별 총합
tapply(df3$total, df3$deptno, sum)

# sapply, lapply, mapply의 차원 데이터 셋 적용 과정
# 1. 2차원 데이터 셋의 key별 데이터 분리
# 2. 각 key의 데이터를 벡터 형태로 함수에 전달
#    이 과정에서 함수는 벡터를 input 인자로 받게 됨
# => 함수 자체가 벡터연산이 가능한 경우만 적용함수를 통한 연산 가능

df4 <- data.frame(col1 = 1:5, col2 = 6:10)

f1 <- function(x) {        # 벡터연산 가능 (x에 벡터 input 가능)
  x * 10
}

f2 <- function(x) {        # 벡터연산 불가 (if 때문에 x에 scalar만 input 가능)
  if (x %% 2 == 0) {
    x * 10
  } else {
    x * 20
  }
}

apply(df4, c(1, 2), f1)    # 하나씩 빼서 연산하므로 벡터연산도 가능한 f1이 좋음
apply(df4, 1, f1)
sapply(df4, f1)            # sapply => key별로 분리해서 함수에 적용
# f1 => key별 값(벡터)에 대해 연산수행 가능
sapply(df4, f2)            # sapply => key별로 분리해서 함수에 적용
# f2 => key별 값(벡터)에 대해 연산수행 불가

# --------------------------------실 습 문 제-----------------------------------
# 실습문제 7    
# 7.1 subway2.csv 파일을 읽고,
df1 <- read.csv('subway2.csv', fileEncoding = "euc-kr", skip = 1) # 1번째 행 스킵
head(df1)
str(df1)

# step 1) 컬럼에 시간정보만 표현 (X05.06 => 5)
library(stringr)
colnames(df1)[-c(1, 2)] <- as.numeric(str_sub(colnames(df1)[-c(1, 2)], 2, 3))

# step 2) 승차/하차 데이터 분리 + 구분컬럼 삭제
df1_1 <- df1[df1$구분 == '승차', -2]
rownames(df1_1) <- df1_1$전체    # 행이름을 '전체'로 변경
df1_1 <- df1_1[, -1]             # '전체'는 삭제

df1_2 <- df1[df1$구분 == '하차', -2]
# 하차의 '전체'에는 역이름이 없으므로 승차에서 가져와야 함
# way 1) 승차의 역이름 가져오기
rownames(df1_2) <- rownames(df1_1)
df1_2 <- df1_2[, -1]

# way 2) 바로 위의 역이름가져오기

# 1) 역별 승차의 총합
apply(df1_1, 1, sum)

# 2) 역별 하차의 총합
apply(df1_2, 1, sum)

# 3) 시간대별 총합
apply(df1[, -c(1, 2)], 2, sum)

# 7.2 employment.csv 파일을 읽고
df2 <- read.csv('employment.csv', fileEncoding = "euc-kr")

# 1) 연도별 총근로일수의 평균
# step 1) 총근로일수 컬럼 선택
head(df2)
df2_1 <- df2[ , df2[1, ] == '총근로일수 (일)']
df2_1 <- df2_1[-1, ]    # 1번째 행 삭제
rownames(df2_1) <- df2$고용형태[-1]    # 고용형태 제외하고 선택

# step 2) '-'을 0으로 치환
# 무언가의 형태를 전체 데이터에 적용하고 싶다! -> 적용함수
apply(df2_1, c(1, 2), str_replace_all, '-', 0)    # Error => `replacement` must be a character vector
df2_1[ , ] <- apply(df2_1, c(1, 2), str_replace_all, '-', '0')  # 문자로 바꾸고 숫자로 다시 바꿔줌
df2_1[ , ] <- apply(df2_1, c(1, 2), as.numeric)

# step 3) 연도별 평균
apply(df2_1, 2, mean)

# 2) 고용형태별 월급여액 평균
# (전체근로자와 전체근로자(특수형태포함)가 같은 그룹이 되도록)
# Answer 1
# step 1) 월급여액 컬럼 선택
df2_2 <- df2[ , df2[1, ] == '월급여액 (천원)']
df2_2 <- df2_2[-1, ]
rownames(df2_2) <- df2$고용형태[-1]

# step 2) 컬럼 정리 (X2007.4 => 2007)
colnames(df2_2) <- str_sub(colnames(df2_2), 2, 5)

# step 3) 천단위 구분기호 삭제 및 숫자변경
f1 <- function(x) {
  as.numeric(str_remove_all(x, ','))
}
df2_2[ , ] <- apply(df2_2, c(1, 2), f1)

# step 4) 고용형태별 평균 (행별 평균)
df2_2$total <- apply(df2_2, 1, mean)

# step 5) 전체근로자와 전체근로자(특수형태포함)의 그룹평균 구하기
# 전체근로자(특수형태포함)에서 (특수형태포함)을 제거
str_split(rownames(df2_2), '\\(')    # 각 층마다 원소 추출 불가
f2 <- function(x) {
  str_split(x, '\\(')[[1]][1]
}
vgroup <- sapply(rownames(df2_2), f2)
tapply(df2_2$total, vgroup, mean)

# Answer 2 => 컬럼값 + 1번째 행 결합 후 컬럼 수정
# step 1) 컬럼 및 1번째 행 값 정리
v1 <- str_sub(colnames(df2)[-1], 2, 5)
df2[1, ][-1]
f3 <- function(x) {
  str_split(x, ' ')[[1]][1]
}
sapply(df2[1, ][-1], f3)
v2 <- sapply(df2[1, ][-1], f3)

# step 2) 가공된 값으로 컬럼 수정
colnames(df2)[-1] <- str_c(v1, v2, sep = '_')
df2 <- df2[-1, ]

# step 3) '-'을 NA로 수정 => str_replace 사용 불가 -> 사용자정의함수
f_na <- function(x) {
  if (x == '-') {
    NA
  } else {
    x
  }
}
df2[ , ] <- apply(df2, c(1, 2), f_na)

# step 4) 천단위 구분기호 제거 후 숫자 변경
apply(df2[, -1], c(1, 2), f1)

# step 5) 월급여액 컬럼 선택
# way 1)
df2[, str_detect(colnames(df2), '월급여액')]

# way 2)
vbool <- (str_detect(colnames(df2), '월급여액')) & (str_detect(colnames(df2[1,]), '2007'))
df2[, vbool, drop = F]

# [ 참고 : f_shift 함수 생성 ]
# f_shift(vector, n) : 빈문자열일 경우 n번째 이전값 가져오기 (위치기반)
# Answer 1
df1_w <- df1$전체
f_shift <- function(vector, n = 1) {
  v_vector <- vector                              # 이거 안 넣으면 Error
  for (i in seq(1, NROW(v_vector), 2)) {
    v_vector[i + n] <- v_vector[i]
  }
  return(v_vector)
}
f_shift(df1$전체)

# Answer 2
df1
f_shift <- function(vector, n = 1) {
  v_vector <- vector               # 입력받은 vector를 v_vector에 받아서 진행
  for (i in 1:length(v_vector)) {
    if (v_vector[i] == '') {
      v_vector[i] <- v_vector[i - n]
    }
  }
  return(v_vector)
}
f_shift(df1$전체)
v1 <- c('a', '', '', 'b', '', '')
f_shift(v1)

# 외부 패키지 활용 : zoo::na.locf => NA 값을 이전 혹은 이후 값으로 치환
install.packages('zoo')
library(zoo)

v2 <- c(1, NA, 2, NA)
na.locf(v2)                  # 이전(ffill) 값으로 치환
na.locf(v2, fromLast = T)    # 이후(bfill) 값으로 치환
# ------------------------------------------------------------------------------

# [ 정렬함수 ]
# -------------------------------연 습 문 제------------------------------------
# 연습문제 28. student.csv 파일을 읽고
# 남, 여 순서대로 데이터를 정렬하고, 같은 성별 내에서는 키가 높은순
# Answer 1 => packages
student$GENDER <- ifelse(str_sub(as.character(student$JUMIN), 7, 7) == '1', '남', '여')
orderBy( ~ GENDER - HEIGHT, student)

# Answer 2 => order
vord <- order(student$GENDER, student$HEIGHT, decreasing = c(F, T), method = 'radix')
student[vord, ]

# step 1) 성별컬럼 가공
student$g1 <- as.numeric(str_sub(student$JUMIN, 7, 7))
student$g2 <- ifelse(student$g1 == 1, 'M', 'F')
student$g3 <- ifelse(student$g1 == 1, '남자', '여자')

# step 2) order를 통한 정렬
vord1 <- order(student$g1, student$HEIGHT, decreasing = c(F, T))
student[vord1, ]

# 문자와 숫자컬럼이 같이 정렬할 경우 충돌이 발생할 수 있음
# 문자, 숫자컬럼 각각 정렬순서 전달
# method = 'radix' 써주기
vord2 <- order(student$g2, student$HEIGHT, decreasing = c(F, T), method = 'radix')
student[vord2]    

# 'radix'는 한글 정렬 컬럼 사용 불가
vord3 <- order(student$g3, student$HEIGHT, decreasing = c(F, T), method = 'radix')
student[vord3, ]

# step 3) orderBy를 통한 정렬
orderBy( ~ g3 - HEIGHT, data = student)
# ------------------------------------------------------------------------------

# [ sampling ]
# 연습문제 29. iris 데이터를 랜덤하게 샘플링하여 각각 70%와 30% 데이터로 분리,
# df_train, df_test에 저장 (랜덤하게 선택된 로우넘버로 풀이)
v_rn <- sample(1:nrow(iris), size = nrow(iris) * 0.7)
iris[v_rn, ]

df_train <- iris[v_rn, ]
df_test <- iris[-v_rn, ]

nrow(df_train)    # 105
nrow(df_test)     # 45
# ------------------------------------------------------------------------------

# [ 적용함수 ]
# --------------------------------실 습 문 제-----------------------------------
# 실습문제 8    
# 8.1 data2 데이터를 읽고 
sub <- read.csv('data2.csv', fileEncoding = 'euc-kr')

# 1) 다음과 같이 노선별 승하차의 총합을 표현
#     line_1  line_2  line_3  line_4
#      XXXXX   XXXXX   XXXXX   XXXXX
# way 1)
sub$승차 <- str_remove_all(sub$승차, ',')
sub$하차 <- str_remove_all(sub$하차, ',')
sub$승하차 <- as.numeric(sub$승차) + as.numeric(sub$하차)
tapply(sub$승하차, sub$노선번호, sum)

# way 2)
f1 <- function(x) {
  as.numeric(Str_remove_all(x, ','))
}
sub[, c(3, 4)] <- apply(sub[, c(3, 4)], c(1, 2), f1)
tapply(df1$승차 + df1$하차, df1$노선번호, sum, na.rm = T)

# [ 참고 - 평균 계산 컬럼의 치환값 필요시 ]
mean(c(1 ,2 ,3, '-'))                  # '-'가 0 또는 NA로 치환 필요
mean(c(1, 2, 3, 0))                    # 4개의 평균
mean(c(1, 2, 3, NA), na.rm = T)        # 3개의 평균

library(stringr)
str_replace_all(c(1, 2, 3, '-'), '-', '0')
str_replace_all(c(1, 2, 3, '-'), '-', NA)    # Error
str_replace_all(NA, 0)                       # Error
ifelse(c(1, 2, 3, '-') == '-', NA, c(1, 2, 3, '-'))

# 2) 오전 오후의 승하차의 총합을 표현
# 오전 오후
# XXXX XXXXX
sub$time <- ifelse(as.numeric(str_sub(str_pad(sub$시간, 4, 'left', 0), 1, 2)) < 12, '오전', '오후')
tapply(sub$승하차, sub$time, sum)

# 8.2 emp2.csv 데이터를 읽고 
emp2 <- read.csv('emp2.csv', fileEncoding = 'euc-kr')
# 1) 현재 직급이 없는 직원은 사원으로 치환
# way 1) '-'를 사원으로 직접 치환
emp2 <- read.csv('emp2.csv', fileEncoding = 'euc-kr')
emp2[emp2$POSITION == '-', 'POSITION'] <- '사원'
# or 치환함수
str_replace(emp2$POSITION, '-', '사원')

# way 2) '-'를 NA로 불러온 후 사원으로 치환
emp2 <- read.csv('emp2.csv', fileEncoding = 'euc-kr', na.strings = '-')
str_replace_na(emp2$POSITION, '사원')    # sql nvl함수와 비슷

# way 3) '-'를 사원으로 직접 치환(ifelse)
emp2 <- read.csv('emp2.csv', fileEncoding = 'euc-kr')
ifelse(emp2$POSITION == '-', '사원', emp2$POSITION)

# 2) 직급별 평균연봉을 출력
# way 1)
emp2$PAY <- as.numeric(str_replace_all(emp2$PAY, '-', '0'))
tapply(emp2$PAY, emp2$POSITION, mean)
# way 2)
emp2$PAY[emp2$PAY == '-'] <- NA
emp2$PAY <- as.numeric(emp2$PAY)
tapply(emp2$PAY, emp2$POSITION, mean, na.rm = T)

# 8.3 emp.csv 파일을 읽고 다음과 같이 표현
# deptno  ename 
# 10      CLARK KING MILLER     
# 20      SMITH JONES....    
# 30      ALLEN WARD...
emp <- read.csv('emp.csv', fileEncoding = 'euc-kr')

str_c(emp[emp$DEPTNO == 10, 'ENAME'], collapse = ' ')

vec1 <- tapply(emp$ENAME, emp$DEPTNO, str_c, collapse = ' ')
df3 <- as.data.frame(vec1)
df3$deptno <- rownames(df3)
colnames(df3)[1] <- 'ename'
df3[, c(2, 1)]
# ------------------------------------------------------------------------------

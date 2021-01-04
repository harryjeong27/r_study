# -------------------------------연 습 문 제------------------------------------
# 연습문제 1
# 연습문제 1) 2020년 8월 1일부터 2020년 8월 31일까지의 날짜를 모두 출력,
#             해당 날짜의 요일을 출력
v1 <- seq(from = as.Date('2020/08/01'), to = as.Date('2020/08/31'), by = 1)
class(v1)    # 날짜 벡터 => 벡터는 벡터라고 안나오고 데이터 타입이 나옴. 자료구조 타입 안나옴.
as.character(v1, '%A')

# 연습문제 2) 2020년 8월 15일부터 오늘 날짜까지 남은 일수 출력                  # *
v2 <- as.Date('2020/08/15') - Sys.Date()
as.numeric(v2)

v2 <- as.Date('2020/08/15') - Sys.Date()
class(v2)    # difftime TYPE
v2 + 100
class(v2)
# 날짜 계산하기 위해 숫자로 타입 변경
as.numeric(v2)               
# 계산하고 숫자타입 변경해도 그대로 difftime인데?
class(v2)

# 계산하고 변경하면 숫자 타입변경 가능!
v3 <- as.Date('2020/08/15') - Sys.Date()
v3
class(v3)    # difftime TYPE
v4 <- as.numeric(v3) + 100    
class(v4)

# 연습문제 2
# 2020년 7월의 일별 데이터를 출력,
# 그 중 v_year라는 컬럼(변수)에 연도만,
# v_month라는 컬럼(변수)에 월만,
# v_day라는 컬럼(변수)에 일만 분리저장
# v_bonus_date 컬럼에 6개월 후 데이터를 입력
v_date <- seq(as.Date('2020/07/01'), as.Date('2020/07/31'), 1)
v_date
v_year <- year(v_date)
v_month <- month(v_date)
v_day <- day(v_date)
v_bonus_date <- v_date + months(6)
# ------------------------------------------------------------------------------

# --------------------------------실 습 문 제-----------------------------------
# 실습문제 1 
# 1) 2020년 전체 날짜를 갖는 v1 변수 생성
v1 <- seq(as.Date('2020/01/01'), as.Date('2020/12/31'), 1)

# 2) 위의 벡터를 연도를 제외한 월/일 형식으로만 출력하여 v2 생성
v2<- as.character(v1, '%m/%d')

# 3) '2020/04/25'일로부터 100일 뒤의 날짜와 요일 출력
v3 <- as.Date('2020/04/25') + 100
class(v3)
v4 <- as.character(v3, '%A')
class(v4)
v4 <- as.character(v3, '%w')

# 4) 사원의 입사일이 다음과 같을때 현재까지 근무일수가 몇주, 
#             몇일인가 각각 출력
v_hiredate <- c('2018/04/06', '2019/12/23', '2019/05/04')  # 여러 값 넣을 경우 벡터로 넣어줌 
class(v_hiredate)
v_workday <- Sys.Date() - as.Date(v_hiredate)
v_workday1 <- as.numeric(v_workday)
class(v_workday1)
v_week <- v_workday1 %/% 7      # workday를 7로 나눈 몫 = 근무한 주
v_day <- v_workday1 %% 7        # workday를 7로 나눈 나머지 = 나머지 일수
trunc(v_workday / 7)            # trunc 함수도 활용 가능
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 3                                                                    
df1 <- read.csv('emp.csv') ; df1
class(df1)      # data.frame
# 1) emp.csv 파일을 읽고 10번 부서원의 이름, job, sal 출력                      
df1[, 'DEPTNO'] == 10       # 'DEPTNO'컬럼이 10인지 체크 
df1[, 8] == 10
df1$DEPTNO == 10            # $로도 컬럼 선택 가능
df1[df1$DEPTNO == 10, c('ENAME', 'JOB', 'SAL')]
# 위 내용을 몰랐다면? 하나씩 찾아서 진행
df1[c(3), c('ENAME', 'JOB', 'SAL')]

# 2) 20번 부서원의 sal의 총합 출력
df1[c(1, 4, 8, 11, 13), 6]
df1[c(1, 4, 8, 11, 13), 'SAL']
sum(df1[c(1, 4, 8, 11, 13), 'SAL'])

sum(df1[df1$DEPTNO == 20, 'SAL'])

# 3) sal이 2000이상인 직원 이름, sal 추출
df1[df1['SAL'] >= 2000, c('ENAME', 'JOB')]
df1[df1[, 'SAL'] >= 2000, c('ENAME', 'JOB')]    # 더 정확
df1[df1$SAL >= 2000, c('ENAME', 'JOB')]

# 4) smith와 allen의 이름과 연봉 추출
df1[c(1, 2), c(2, 6)]
df1[c(1, 2), c('ENAME', 'SAL')]

df1[df1$ENAME == c('SMITH', 'ALLEN'), c('ENAME', 'SAL')]
# in sql
# select ename, sal
#   from df1
#  where ename in ('smith', 'allen');

# ename in ('smith', 'allen') -> R로 변경
df1$ENAME %in% c('SMITH', 'ALLEN')
df1[df1$ENAME %in% c('SMITH', 'ALLEN'), c('ENAME', 'SAL')]

# 변수 활용 => 가독성에는 변수가 좋으나 연산에는 좋지 않음
v_bool <- df1$ENAME %in% c('SMITH', 'ALLEN')
df1[v_bool, c('ENAME', 'SAL')]
# df1[행색인, 컬럼색인]
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 3 (Continued)
# 5) v_sal의 이름 중 d를 D로 변경                                               # *
v_sal
names(v_sal[4]) <- 'C' ; v_sal          # Wrong Answer => v_sal[4]는 객체가 아님
names(v_sal)[4] <- 'D' ; v_sal
names(v_sal) <- c('a', 'b', 'c', 'D', 'e')    # possible but slow

# 예제) df1의 SAL 컬럼을 SALARY로 변경
df1
names(df1)
names(df1)[6] <- 'SALARY'

# 6) df1의 COMM 컬럼을 BONUS로 변경하되,                                        # *
#            COMM 컬럼의 위치를 모른다는 가정하에 처리
names(df1) == 'COMM'     # 몇번째가 True인지 나옴
names(df1)[names(df1) == 'COMM'] <- 'BONUS'  # 전체 중 True인 값에만 대입
df1

# 예제) df1에서 MGR 컬럼을 선택(조건색인)
df1[, 'MGR']    # 컬럼 자리에 이름 색인
df1['MGR']      # 가능하나 비추
df1$MGR
df1[, names(df1) == 'MGR']

# 예제) df1에서 MGR 컬럼 제외 다른 컬럼 모두 선택 (조건색인)                     # **
df1[, names(df1) != 'MGR']

df1[, -4]       # 4번째 컬럼 제외
df1[, -'MGR']   # 문자값을 제외할 수는 없음
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 4.
# 1) df1에서 1987년에 입사한 사람의 이름, 입사일, SAL 출력
as.character(df1$HIREDATE, '%Y')      # 연도만 빠지지 않음 why? 
class(df1$HIREDATE)                   # df1$HIREDATE가 문자로 읽힘

# 날짜 파싱(1980/12/17 00:00:00)
v_date <- as.Date(df1$HIREDATE, '%Y/%m/%d %H:%M:%S')
df1[as.character(v_date, '%Y') == '1987', c('ENAME', 'HIREDATE', 'SAL')]        # Answer 1

df1[(df1[, 'HIREDATE'] > 1987) & (df1[, 'HIREDATE'] < 1988),                    # Answer 2 => 묵시적 형 변환
    c('ENAME', 'HIREDATE', 'SAL')]

# 2) 사원번호가 7900, 7902, 7934인 직원의 SAL의 총합
sum(df1[df1[, 'EMPNO'] %in% c(7900, 7902, 7934), 'SAL'])

v_bool <- (df1$EMPNO == 7900 | df1$EMPNO == 7902 | df1$EMPNO == 7934)
sum(df1[v_bool, 'SAL'])
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 5. l3에서 김길동만 추출                                              # **
l3              # 리스트
l3$name         # 벡터
l3$name[2]      # Answer 1

l3[1]           # 리스트
l3[[1]]         # 벡터
l3[[1]][2]      # Answer 2
# ------------------------------------------------------------------------------

# --------------------------------실 습 문 제-----------------------------------
# 실습문제 2
# 2.1 emp.csv 데이터를 활용하여
emp1 <- read.csv('emp.csv') ; emp1
getwd()
# 1) 1월에 입사한 직원의 이름, 입사일, 연봉 출력
class(emp1$HIREDATE)
v_date2 <- as.Date(emp1[, 'HIREDATE'], '%Y-%m-%d')
emp1[as.character(v_date2, '%m') == '01', c('ENAME', 'HIREDATE', 'SAL')]

# 2) 각 직원의 입사요일을 DAY 컬럼에 추가
emp1$HIREDATE
v_date3 <- as.Date(emp1$HIREDATE, '%Y-%m-%d')
as.character(v_date3, '%A')
emp1$DAY <- c(as.character(v_date3, '%A'))

# 3) 다음의 계산식으로 퇴직금 계산 후 R_PAY 컬럼으로 추가                       # *
# (퇴직금 = 현재 SAL * trunc(근속년수 / 12))
# Answer 1
trunc(((Sys.Date() - as.Date(emp1$HIREDATE, '%Y-%m-%d')) / 365) / 12) # 근속년수

emp1$R_PAY2 <- c(as.numeric(emp1[, 'SAL'] * 
                              trunc(((Sys.Date() - as.Date(emp1$HIREDATE, '%Y-%m-%d')) / 365) / 12)))

# Answer 2
emp1$HIREDATE <- as.Date(emp1$HIREDATE)
v_year <- as.numeric(trunc((Sys.Date() - emp1$HIREDATE) / 365))
emp1$R_PAY <- emp1$SAL* trunc(v_year / 12)

# 4) 이름이 KING인 행 삭제                                                      # *
# Wrong Answer => Good try!
emp1[emp1$ENAME == 'KING', ] <- 0       # KING인 행의 값을 전부 0으로 치환

# Answer
emp1 <- emp1[emp1$ENAME != 'KING', ]    # 해당 행 제외한 나머지 선택 후 대입

# 5) 20번 부서직원 중 SAL이 2000이상인 직원의 SAL의 평균                        # *
# Answer 1
sal2000 <- emp1[emp1$DEPTNO == '20', 'SAL']
sal2000 >= 2000
mean(sal2000[sal2000 >= 2000])

# Answer 2 => Better
mean(emp1[(emp1$DEPTNO == 20) & (emp1$SAL >= 2000), 'SAL'])

# 2.2 다음의 리스트 생성
# no : 1, 2, 3, 4
# name : apple, banana, peach, berry
# price : 500, 200, 200, 50
# qty : 5, 2, 7, 8
# Answer 1
list1 <- list('no' = c(1, 2, 3, 4),
              'name' = c('apple', 'banana', 'peach', 'berry'),
              'price' = c(500, 200, 200, 50),
              'qty' = c(5, 2, 7, 8))

# Answer 2
v_no <- 1:4
v_name <- c('apple', 'banana', 'peach', 'berry')
v_price <- c(500, 200, 200, 50)
v_qty <- c(5, 2, 7, 9)

l1 <- list(no = v_no,
           name = v_name,
           price = v_price,
           qty = v_qty)

# 1) banana를 BANANA로 변경
# Answer 1
list1$name[2] <- 'BANANA'

# Answer 2
list[[2]][2] <- 'BANANA'

# 2) 10% 인상된 가격을 NEW_PRICE 키에 추가
list1$NEW_PRICE <- list1$price * 1.1   

# 3) peach의 qty를 출력 (단, peach의 위치를 모른다 가정)                        # **
list1$name == 'peach'
list1$qty[list1$name == 'peach']
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 6. 위 v1 벡터에서 NA인 부분을 찾아 0으로 수정
sum(v1)                 # NA를 포함하는 산술연산 NA리턴
v1[is.na(v1)] <- 0      # NA 치환
sum(v1)                 # 치환 후 연산

# 연습 문제 7
# 7.1 vec1 벡터 생성
vec1 <- c('사과', '배', '감', '버섯', '고구마')

# 1) vec1에서 3번째 요소인 감을 제외, vec1 출력
vec1[vec1 != vec1[3]]
vec1[vec1 != '감']

# 7.2 vec1, vec2 생성                                                           # **
vec1 <- c('봄', '여름', '가을', '겨울')
vec2 <- c('봄', '여름', '늦여름', '초가을')

# 1) vec1과 vec2를 합친 결과 출력
vec3 <- c(vec1, vec2)                  # union all (중복)
append(vec1, vec2[!vec1 %in% vec2])    # union (중복 제거)
vec3 <- append(vec1, vec2)

# 2) vec1에는 있는데 vec2에는 없는 결과 출력
vec3[vec3 != vec2]
vec2 %in% vec1
!vec1 %in% vec2

# 3) vec1과 vec2 둘다 있는 결과 출력
vec1[vec1 %in% vec2]
vec1[vec1 == vec2]
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 8. m3에서 2번째 컬럼이 5이상인 행을 선택
m3$              # matrix는 key구조를 갖지 않으므로 $ 의미 없음
  
  m3[m3[, 'B'] >= 5]
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 9. 1부터 20값을 갖는 5 x 4 행렬 생성 후 짝수값을 모두 0으로 수정
m5 <- matrix(data = 1:20,
             nrow = 5,
             ncol = 4)
m5[m5 %% 2 == 0] <- 0 ; m5
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 10.                                                                  # **
# 1) 아래 그림과 같은 형태의 행렬을 만드세요.
matrix(data = ,               # matrix 구성 date
       nrow = ,               # 행 수
       ncol = ,               # 컬럼 수
       byrow = FALSE,         # 행 우선순위 배치 여부
       dimnames = )   
seasons1 <- matrix(data = c('봄', '여름', '가을', '겨울'), 
                   nrow = 2,
                   ncol = 2,
                   byrow = FALSE)

seasons2 <- matrix(data = c('봄', '여름', '가을', '겨울'), 
                   nrow = 2,
                   ncol = 2,
                   byrow = T)
t(seasons1)    # 전치 함수

# 2) 아래 그림과 같이 seasons 행렬에서 여름과 겨울만 조회하는 방법을 쓰세요.
seasons2[, 2, drop = F]

# 3) 아래 그림과 같이 seasons 행렬에 3번 행을 추가하여 seasons_2 행렬을 만드세요.
seasons_2 <- rbind(seasons2, c('초봄', '초가을'))

# 4) 아래 그림처럼 seasons_2 변수에 열을 추가하여 seasons_3 행렬을 만드세요.
seasons_3 <- cbind(seasons_2, c('초여름', '초겨울', '한겨울'))
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 11. 다음의 데이터 프레임 생성                                        # **
# name : apple, mango, banana
# price : 1000, 1500, 500
# qty : 10, 5, 20
df3 <- data.frame('name' = c('apple', 'mango', 'banana'),
                  'price' = c(1000, 1500, 500),
                  'qty' = c(10, 5, 20), stringsAsFactors = T)

# 1) 다음의 행 추가
# berry, 2000, 3
df4 <- rbind(df3, as.factor(c('berry', 2000, 3)))    # Error => factor          # Ques2. price, qty가 왜 1, 2로 전달
str(df4)

# Error 조정 => factor 풀어주고 다시 factor화
df4$name <- as.character(df4$name)
df4[4, 1] <- 'berry'
df4$name <- as.factor(df4$name)

# 2) sales 컬럼에 price * qty 계산하여 추가
# Answer 1
df4$sales <- as.numeric(df4$price) * as.numeric(df4$qty)
# Answer 2
df3$price <- as.numeric(df3$price)
df3$qty <- as.numeric(df3$qty)
df3$sales <- df3$prcie * df3$qty
# ------------------------------------------------------------------------------

# --------------------------------실 습 문 제-----------------------------------
# 실습문제 3.
# 3.1 emp.csv 파일을 읽고
emp <- read.csv('emp.csv') ; emp
# 1) 상반기 입사한 사람은 연봉의 10%, 하반기는 15%의 보너스를 bonus 컬럼에 추가 # ***
#    (조건문 사용 불가)
# Wrong Answer 1
library(lubridate)
month(as.Date(emp$HIREDATE)) <= 6    # 상반기
!(month(as.Date(emp$HIREDATE)) > 6)
month(as.Date(emp$HIREDATE)) > 6   # 하반기

emp$bonus <- c((emp[month(as.Date(emp$HIREDATE)) <= 6, 'SAL'] * 1.1), 
               emp[month(as.Date(emp$HIREDATE)) > 6, 'SAL'] * 1.15)
# Error => 각 값을 합치는 벡터로 나옴 -> 즉, 순서가 맞지 않음

# Wrong Answer 2 => 1) 상반기 전부 넣기 2) 하반기만 수정
class(as.Date(emp$HIREDATE))    # 문자로 나오므로 날짜로 바꾸고 시작
emp$HIREDATE <- as.Date(emp$HIREDATE)
# 상반기
as.numeric(as.character(emp$HIREDATE, '%m')) < 7    

emp$bonus <- emp$SAL * 1.1    # 상반기 값 전부 넣기
# 하반기
emp$bonus[as.numeric(as.character(emp$HIREDATE, '%m')) >= 7] <-
  emp$SAL * 1.15    
# Errror => length가 다름 앞에는 하반기만, 뒤에는 전체 행

# Answer => 전체에 상반기용 SAL * 1.1 넣어주고, 전체 중 하반기인 곳에만 하반기 값 넣기
emp$HIREDATE <- as.Date(emp$HIREDATE)
v_bool <- as.numeric(as.character(emp$HIREDATE, '%m')) >= 7
emp$bonus <- emp$SAL * 1.1
emp$bonus[v_bool] <- emp$SAL[v_bool] * 1.15

# 2) comm이 NA인 경우 0으로 수정 후 comm의 평균 출력
emp$COMM[is.na(emp$COMM)] <- 0
class(emp$COMM)
mean(emp$COMM)

# 3) empno, ename, sal, deptno 컬럼만 선택 후 emp2 생성
emp2 <- emp[, c('EMPNO', 'ENAME', 'SAL', 'DEPTNO')]

# 4) 위 emp2 데이터프레임에 행 추가 (9400, HONG, 3000, 40)
emp2 <- rbind(emp2, c(9400, 'HONG', 3000, 40))
str(emp2)

# 데이터 타입 수정
emp2$SAL <- as.numeric(emp2$SAL)
emp2$DEPTNO <- as.numeric(emp2$DEPTNO)
emp2$EMPNO <- as.numeric(emp2$EMPNO)

as.integer()    # 정수 타입으로 변경

# 3.2 disease.txt 파일을 읽고                                                   # **
df2 <- read.table('/Users/harryjeong/r_data/disease.txt', fileEncoding = "euc-kr", stringsAsFactors = T)
df2 <- read.csv('disease2.csv')

# 1) 1번째 행의 값으로 컬럼 이름 변경                                           # **
# Wrong
colnames(df2) <- df2[1, ]
str(df2)                  # Wrong => factor이기 때문에 각 레벨의 숫자로 치환
factor(c('a', 'b', 'c'))  # Because, factor는 지정되면 각 값에 위치를 대입함 => 숫자로 변경

# step1) 각 컬럼을 모두 문자 컬럼으로 변경
df2[, 1] <- as.character(df2[ , 1])
df2[, 2] <- as.character(df2[ , 2])
df2[, 3] <- as.character(df2[ , 3])
df2[, 4] <- as.character(df2[ , 4])
df2[, 5] <- as.character(df2[ , 5])
df2[, 6] <- as.character(df2[ , 6])
df2
# step2) 컬럼 이름 변경
colnames(df2) <- df2[1, ]

# step3) 첫번째 행 제거
df2 <- df2[-1, ]

# step4) 숫자 컬럼으로 변경
df2[, 2] <- as.numeric(df2[ , 2])
df2[, 3] <- as.numeric(df2[ , 3])
df2[, 4] <- as.numeric(df2[ , 4])
df2[, 5] <- as.numeric(df2[ , 5])
df2[, 6] <- as.numeric(df2[ , 6])

# [ 참고 : 외부파일 불러오는 함수 비교 ]                                        # *
# read.csv : csv파일 전용, 분리구분자가 ','가 기본, header 컬럼화 o
# read.table : 일반파일 대상, 분리구분자가 탭이 기본, header 컬럼화 x

# 2) 각 NA값을 각 컬럼의 최소값으로 수정
# Answer 1
df2[is.na(df2)] <- 0
df2$콜레라[df2$콜레라 == 0] <- min(df2$콜레라[df2$콜레라 != 0])
df2$장티푸스[df2$장티푸스 == 0] <- min(df2$장티푸스[df2$장티푸스 != 0])
df2$이질[df2$이질 == 0] <- min(df2$이질[df2$이질!= 0])
df2$대장균[df2$대장균 == 0] <- min(df2$대장균[df2$대장균 != 0])
df2$A형간염[df2$A형간염 == 0] <- min(df2$A형간염[df2$A형간염 != 0])
df2

# Answer 2 => seems better **
df2$A형간염[!is.na(df2$A형간염)]        # NA가 아닌 대상
vmin1 <- min(df2$A형간염[!is.na(df2$A형간염)])
df2$A형간염[is.na(df2$A형간염)] <- vmin1

vmin2<- min(df2$콜레라[!is.na(df2$콜레라)])
df2$A형간염[is.na(df2$콜레라)] <- vmin2

vmin3 <- min(df2$장티푸스[!is.na(df2$장티푸스)])
df2$A형간염[is.na(df2$장티푸스)] <- vmin3

vmin4 <- min(df2$이질[!is.na(df2$이질)])
df2$A형간염[is.na(df2$이질)] <- vmin4

vmin5 <- min(df2$대장균[!is.na(df2$대장균)])
df2$A형간염[is.na(df2$대장균)] <- vmin5

# 3) "월별" 컬럼을 데이터 프레임의 행이름으로 설정,
#    본문에서 "월별" 컬럼 삭제
rownames(df2) <- c(df2$월별)
df3 <- df2[, -1]

# 4) A형간염의 컬럼 이름을 A간염으로 변경 (위치 색인 불가)
colnames(df2)[colnames(df2) == 'A형간염'] <- 'A간염'

# 5) NA를 하나라도 포함한 행 제외(df2)                                          # **
# Wrong
is.na(df2)
df2[df2 != is.na(df2), , drop = FALSE]

# Answer
is.na(df2$콜레라) | is.na(df2$장티푸스)    # NA를 하나라도 포함하면 True
df2[!(is.na(df2$콜레라) | is.na(df2$장티푸스) |    # NA를 하나라도 포함하면 False
        is.na(df2$A간염)  | is.na(df2$이질)     |
        is.na(df2$대장균)), ]
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 16. emp 데이터에서
# 1) 이름이 S로 시작하는(대소 구분 x) 직원의 이름, 연봉 출력
emp[str_detect(emp$ENAME, '^[sS]'), c('ENAME', 'SAL')]

# 2) 이름의 3번째 글자가 A인 직원의 이름, 연봉 출력
emp[str_detect(emp$ENAME, '..A'), c('ENAME', 'SAL')]
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 18. 다음의 변수의 10% 인상된 값 출력
v_sal <- c('1,200', '5,000', '3,300')
class(v_sal)
as.numeric(str_replace_all(v_sal, ',', '')) * 1.1
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 19                                                                   # *
# 1) vtel에서 국번 추출(034)
vtel <- '02)034-1234'
# Answer 1 => 분리기반 (str_split)
str_split(str_split(vtel, '-')[[1]][1], '\\)')[[1]][2]

# Answer 2 => ')', '-' 위치기반 (str_sub & str_locate)
str_sub(vtel, str_locate(vtel, '\\)')[, 1] + 1, str_locate(vtel, '-')[, 1] - 1)

# 2) student.csv 파일의 TEL 컬럼에서 각 행의 국번 추출
student <- read.csv('student.csv', fileEncoding = "euc-kr") ; student

# Answer 1 => 위치기반 (str_sub & str_locate)
str_locate(student$TEL, '\\)')[, 1]
str_locate(student$TEL, '-')[, 1]
str_sub(student$TEL,
        str_locate(student$TEL, '\\)')[, 1] + 1,
        str_locate(student$TEL, '-')[, 1] - 1)

# Answer 2 => 분리기반 (str_split)                                              # *
str_split(str_split(student$TEL, '-')[[1]][1], '\\)')[[1]][2]

# Answer 2-1
v_split1 <- c()
v_split2 <- c()
for (i in 1:nrow(student)) {
  v_split1 <- c(v_split, str_split(student$TEL, '-')[[i]][1])
  v_split2 <- c(v_split2, str_split(v_split, '\\)')[[1]][2])
}
v_split2

# Answer 2-2
v_split3 <- c()
v_split4 <- c()
for (i in 1:nrow(student)) {
  v_split3 <- str_split(student$TEL, '\\)')[[i]][2]
  v_split4 <- c(v_split4, str_split(v_split3, '-')[[1]][1])
  
}
v_split4
# ------------------------------------------------------------------------------
reviewed 1, 2020-09-13
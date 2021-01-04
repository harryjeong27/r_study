# -------------------------------- ADVANCED ------------------------------------
# [ 고급 4. join ]
# 4.1 merge
# - 두 테이블(데이터프레임)의 조인만 가능
# - equi join만 가능(non equi join 불가)
# - 여러개 컬럼으로 조인 가능
# - 기본 연산은 inner join, but outer join도 가능
merge(x,                            # 조인할 1번째 데이터프레임
      y,                            # 조인할 2번째 데이터프레임
      by = ,                        # 조인 컬럼(동일한 이름)
      by.x = ,                      # 1번째 데이터의 조인 컬럼
      by.y = ,                      # 2번째 데이터의 조인 컬럼
      all = ,                       # full outer join 여부(T/F)
      all.x = ,                     # left outer join 여부(T/F)
      all.y = ,                     # right outer join 여부(T/F)
      suffixes = c(".x", ".y")      # 동일 컬럼의 접미어
)

# 예제) emp.csv와 dept.csv 파일을 각각 불러온 후 조인하여 각 직원의 이름,
#       부서번호, 부서이름출력

emp <- read.csv('emp.csv', stringsAsFactors = F)
dept <- read.csv('dept.csv', stringsAsFactors = F)

merge(emp, dept, by = 'DEPTNO')[ , c('ENAME', 'DEPTNO', 'DNAME')]

# 예제) student.csv와 professor.csv 파일을 각각 불러온 후 조인하여 각 학생의 
#       이름, 학년, 지도교수 이름 출력
std <- read.csv('student.csv', fileEncoding = 'euc-kr')
pro <- read.csv('professor.csv', fileEncoding = 'euc-kr')

merge(std, pro, by = 'PROFNO')             # inner join => 조건에 맞는 행만 색인 
merge(std, pro, by = 'PROFNO', all.x = T)  # left outer join

merge(std, pro, by = 'PROFNO', all.x = T)[ , c('NAME.x', 'GRADE', 'NAME.y')]

# ------------------------------------------------------------------------------
# [ 고급 5. 그룹연산 ]
# - 그룹별 특정함수의 적용
# - 분리 -> 적용 -> 결합

# 5.1. tapply
# - 벡터로 리턴
# - 조건별 그룹연산 가능
# - 데이터프레임 입력 불가
# - 동시에 여러 컬럼 그룹연산 불가
tapply(emp$SAL, emp$DEPTNO, sum)
tapply(emp$SAL, emp$COMM, emp$DEPTNO, sum)    # Error => 불가

# 5.2 aggregate
# - 두가지 문법
# - 데이터프레임 리턴
# - 여러 컬럼 연산 가능
# - 여러 컬럼 그룹핑 가능
# - 여러 연산 컬럼에 서로 다른 함수 적용 불가
iris
aggregate(x,        # 연산대상 (벡터, 데이터프레임 가능)
          by,       # 그룹대상(group by 컬럼)
          FUN,      # 적용함수
          ...)      # 적용함수 필요 인자

aggregate(formula,  # 연산대상 (연산 넣으면 연산함) ~ 그룹대상 (연산 넣으면 그룹 추가됨)
          data,     # 데이터프레임
          FUN,      # 적용함수
          ...)      # 적용함수 필요 인자

# 1) 연산대상 1개, group by 컬럼 1개
# 예제) student 데이터에서 각 학년별 키의 평균
aggregate(std$HEIGHT, list(std$GRADE), mean, na.rm = T)
aggregate(HEIGHT ~ GRADE, std, mean, na.rm = T)
aggregate(HEIGHT ~ GRADE, std, max, na.rm = T)

# 2) 연산대상 2개, group by 컬럼 1개
# 예제) student 데이터에서 각 학년별 키, 몸무게의 평균
aggregate(std[ , c('HEIGHT', 'WEIGHT')], list(std$GRADE), mean, na.rm = T)
aggregate(HEIGHT + WEIGHT ~ GRADE, std, mean, na.rm = T)        # 불가
aggregate(cbind(HEIGHT, WEIGHT) ~ GRADE, std, mean, na.rm = T)  # 가능

# 3) 연산대상 1개, group by 컬럼 2개
# 예제) student 데이터에서 각 학년별, 학과별 키의 평균
aggregate(std$HEIGHT, list(std$GRADE, std$DEPTNO1), mean, na.rm = T)
aggregate(HEIGHT ~ GRADE + DEPTNO1, std, mean, na.rm = T)

aggregate(cbind(HEIGHT, WEIGHT) ~ GRADE + DEPTNO1,
          std,
          c('min', 'max'),    # Error => 각 대상별 서로 다른 함수 수행 불가
          na.rm = T)

# ------------------------------------------------------------------------------

# [ 고급 6. sqldf ]
# - R 프로그램을 sql문법으로 처리 가능하도록 만든 패키지
# - sql 문법과 완전히 동일하지는 않을 수 있음
# - 특히 조인(non equi join) 수행 시 유리
install.packages('sqldf')
library(sqldf)
emp <- read.csv('emp.csv')

# 1) ENAME, EMPNO 컬럼 추출
emp[, c('ENAME', 'EMPNO')]
sqldf('select ENAME, EMPNO from emp')

# 2) 'ALLEN'의 이름과 SAL 출력
emp[emp$ENAME == 'ALLEN', c('ENAME', 'SAL')]
sqldf('select ENAME, SAL from emp where ENAME = 'ALLEN'')    # Error
sqldf('select ENAME, SAL from emp where ENAME = "ALLEN"')
sqldf('select ENAME, SAL from emp where ENAME =\'ALLEN\'')
# ------------------------------------------------------------------------------

# [ 고급 7. plyr ]
# - apply 계열 함수의 변형 형태
# - data frame으로의 출력 가능
# - {}{}ply 형식의 다양한 함수 포함
# input          output
# 데이터형식     데이터형식

install.packages('plyr')
library(plyr)

# 7.1 plyr::adply
# - array input(matrix, data frame), data frame output
# - apply 함수와 비슷

# 예제) iris data의 행별 열별 총합
apply(iris[, -5], 1, sum)
apply(iris[, -5], 2, sum)

adply(iris[, -5], 1, sum)    # 행별 연산 시 기존 데이터프레임에 추가 o
adply(iris[, -5], 2, sum)    # 컬럼별 연산 시 기존 데이터프레임에 추가 x

# [ 참고 15 : adply에 mean 함수 전달 Error ]
apply(iris[, -5], 1, mean)   # 행별 벡터로 전달
adply(iris[, -5], 1, mean)   # 행별 데이터프레임으로 전달 (컬럼 포함)
adply(as.matrix(iris[, -5]), 1, mean)    # 매트릭스로 변경 후에는 가능

# [ 참고 16 : sum과 mean의 데이터 전달 방식에 따른 차이 ]
v1 <- 1:10
v2 <- data.frame(v1)

sum(v1)    # 가능
sum(v2)    # 가능

mean(v1)    # 가능
mean(v2)    # 불가, mean 함수는 데이터프레임의 연산 불가

# 7.2 plyr::ddply
# - 그룹연산 수행 (group by 연산)
# - 여러 개의 group by 컬럼 가능
# - 여러 컬럼의 그룹 연산 가능
# - 각 컬럼마다 서로 다른 그룹함수 전달 가능
# - 그룹별 비교 가능

# ddply(data = ,            # 데이터 프레임
#        .variables = ,      # 그룹 연산 컬럼
#        FUN = ,             # 내부 함수
#        ...)                # 연산수식

# ddply 내부 함수
# 1. summarise : 그룹별 데이터 요약 (sql group by 결과와 비슷)
# 2. transform : 원본 데이터와 그룹 연산 결과 조인 형태
# 3. mutate : transform과 유사, 이전 그룹연산 결과 재사용 가능
# 4. subset : 그룹별 조건 전달 가능 (조건 추출)

# 예제) emp에서 부서별 평균 연봉
ddply(emp, .(DEPTNO), summarise, avg_mean = mean(SAL), 
      mean_comm = mean(COMM, na.rm = T))
ddply(emp, .(DEPTNO), transform, avg_mean = mean(SAL))

# 예제) emp에서 부서별 평균 연봉보다 높은 연봉을 받는 직원 출력
emp_1 <- ddply(emp, .(DEPTNO), transform, avg_mean = mean(SAL))
emp[(emp_1$SAL > emp_1$avg_mean), ]

# 예제) student에서 학년별 키의 평균, 몸무게의 최대값 출력
ddply(student, .(GRADE), summarize, v1 = mean(HEIGHT),
      v2 = max(WEIGHT))

# 예제) student에서 학년별, 학과별 키의 평균
ddply(student, .(GRADE, DEPTNO1), summarize, v1 = mean(HEIGHT))

# 예제) subset을 사용한 그룹조건 전달
#       student 데이터에서 각 학년별 키가 가장 큰 학생 출력
ddply(student, .(GRADE), subset, HEIGHT == max(HEIGHT))

# mutate 사용 예) v1에 대한 추가 연산
ddply(student, .(GRADE), summarize, v1 = mean(HEIGHT), v2 = log(v1))
ddply(student, .(GRADE), mutate, v1 = mean(HEIGHT), v2 = log(v1))

# ------------------------------------------------------------------------------

# 데이터 구조
# 1. long data (tidy data)
# - 관계형 데이터베이스의 테이블 형식
# - 하나의 관찰 대상이 하나의 컬럼을 구성하는 방식
# - 조인 가능
# - group by 연산 가능
# - 구조 변경이 거의 없음

# 2. wide data (cross table)
# - 주로 공공기관 데이터 표현 형식(정리표)
# - 행별, 열별 연산이 용이 (group by 연산의 대체)
# - 시각화 시 필요
# - 조인 수행 불가
# - 컬럼의 잦은 추가/삭제 발생
# ------------------------------------------------------------------------------

# [ 고급 8. 데이터 구조 변경 by 내부함수]
# 8.1 stack : wide -> long
stack(x,       # data frame
      ...)     # 기타 옵션

# 8.2 unstack : long -> wide
unstack(x,     # data frame
        ...)   # formular : value column ~ index column

df1 <- data.frame(apple = c(10, 20, 30),
                  banana = c(20, 25, 30),
                  mango = c(5, 6, 7))

df2 <- data.frame(month = c(1, 2, 3),
                  apple = c(10, 20, 30),
                  banana = c(20, 25, 30),
                  mango = c(5, 6, 7))

df3 <- stack(df1)
stack(df2)    # month 컬럼도 stack 처리됨 (좋은 표현 x)

unstack(df3, values ~ ind)
# ------------------------------------------------------------------------------

# [ 고급 9. 데이터 구조 변경 by reshape2 패키지 ]
# - stack과 unstack 처리를 조금 더 깔끔하게 표현
# - stack에서는 stack될 컬럼과 stack되지 말아야 할 컬럼 지정 가능
# - unstack에서는 각각 행방향, 컬럼방향에 표현해야할 대상 지정 가능

install.packages('reshape2')
library(reshape2)
# 9.1 melt
# - stack 처리 함수(wide -> long)
# - stack 컬럼 지정 가능

# melt(data,             # 원본 데이터 프레임
#     id.var = ,         # stack시 제외 컬럼
#     measure.var = ,    # stack 처리할 컬럼 (생략 시 id.vars 제외 모두)
#     na.rm = F,         # NA 표현 여부
#     value.name = ,     # value column 이름 지정
#     variable.name = )  # index column 이름 지정

df2 <- data.frame(month = c(1, 2, 3),
                  apple = c(10, 20, 30),
                  banana = c(20, 25, 30),
                  mango = c(5, 6, 7))

melt(df2, id.vars = 'month')
melt(df2, id.vars = 'month', variable.name = '과일이름',
     value.name = '수량')

# 예제) melt_ex.csv 파일을 의미있는 tidy data로 변경
df1 <- read.csv('melt_ex.csv')
melt(df1, id.vars = c('year', 'mon'), variable.name = '이름',
     value.name = '수량')

# 9.2 dcast
# - unstack 처리 (long -> wide)
# - 교차 테이블 생성
# - 행고정(index column), 컬럼 고정, value 표현 컬럼 필요

dcast(data,               # data frame
      formula = ,         # 행 고정 ~ 컬럼 고정
      fun.aggregate = ,   # 요약함수 (필요 시 지정)
      ...,                # 함수 추가 인자
      drop = T,           # 차원 축소
      value.var = )       # value column (생략 시 맨 끝 컬럼)

# 예제 1) dcast_ex1.csv를 읽고, 다음과 같은 형식으로 배치
#        qty  price
# latte  100  2200
# mocha  80   2500
dcast1 <- read.csv('dcast_ex1.csv')
dcast(dcast1, name ~ info)

# 예제 2) dcast_ex2.csv를 읽고, 연도별 품목별 교차 테이블 생성
dcast2 <- read.csv('dcast_ex2.csv')
dcast(dcast2, year ~ name)                    # price 컬럼에 대한 교차테이블
dcast(dcast2, year ~ name, value.var = 'qty') # qty 컬럼에 대한 교차테이블

# 예제 3) dcast_ex3.csv를 읽고, 연도별 지점별 교차 테이블 생성
dcast3 <- read.csv('dcast_ex3.csv', fileEncoding = 'EUC-KR')
dcast(dcast3, 년도 ~ 지점, sum)
# ------------------------------------------------------------------------------

# [ 고급 10. 데이터 구조 변경 by dplyr 패키지 ]
# doBy : ~by (order, sort, sample) 상위
# plyr : apply 계열 함수(적용함수) 상위
# reshape2 : stack/unstack 상위
# dplyr : 구조화된 R 문법 제공(sql처럼)

install.packages('dplyr')
library(dplyr)

# 10.1 dplyr의 구조화된 문법
# 1) select : 컬럼의 선택
# 2) mudate : 컬럼 가공
# 3) filter : 행 선택
# 4) group_by : 그룹연산
# 5) arrange : 정렬
# 6) summarise_each : 그룹연산의 실제 연산 조건

# 예제 1) emp 테이블에서 이름, 사번, 연봉 선택
emp <- read.csv('emp.csv')

emp %>%                        # sql from절처럼 먼저 데이터 선택 후 진행
  select(ENAME, EMPNO, SAL)

# 예제 2) emp 테이블에서 이름, 사번, 연봉, 10% 인상된 연봉 출력
emp %>%                        # sql from절처럼 먼저 데이터 선택 후 진행
  select(ENAME, EMPNO, SAL) %>%
  mutate(new_sal = SAL * 1.1)

# 주의 : 문법적 순서에 따른 파싱 가능 여부(컬럼 정의 순서 달라짐)
emp %>%                        # Error => select에서 SAL이 필요 (순서대로 전달)
  select(ENAME, EMPNO) %>%
  mutate(new_sal = SAL * 1.1)

emp %>%                        
  mutate(new_sal = SAL * 1.1)  %>%
  select(ENAME, EMPNO, new_sal)

# 예제 3) emp 테이블에서 10번 부서원에 대한 이름, 부서번호, 연봉 출력
emp %>%
  select(ENAME, DEPTNO, SAL) %>%
  filter(DEPTNO == 10)

# 예제 4) emp 테이블에서 10번 부서원에 대한 이름, 부서번호, 연봉 출력
# 단, 연봉순으로 정렬
emp %>%
  select(ENAME, DEPTNO, SAL) %>%
  filter(DEPTNO == 10) %>%
  arrange(desc(SAL))

# 예제 5) emp 테이블에서 각 부서별 평균 연봉 출력
emp %>%
  select(DEPTNO, SAL) %>%
  group_by(DEPTNO) %>%
  summarize_each(mean, SAL)

# 예제 6) emp 테이블에서 HIREDATE 컬럼 제외 전체 선택
emp[ , c('EMPNO', 'ENAME', 'JOB')]
emp[ , -5]
emp[ , colnames(emp) != 'HIREDATE']

emp %>%
  select(-HIREDATE)

# [ 참고 17 : summarize_each의 across 대체 ]
std %>%
  select(GRADE, HEIGHT, WEIGHT) %>%
  group_by(GRADE) %>%
  summarise(across(mean, c(HEIGHT, WEIGHT)))
# ------------------------------------------------------------------------------
# [ 고급 11. which.min, which.max ]
# - 최대값과 최소값을 갖는 index 리턴(위치)

library(googleVis)
Fruits

library(reshape2)

df1 <- dcast(Fruits, Fruit ~ Year, value.var = 'Sales')
vord <- which.max(df1$`2008`)
df1[vord, 'Fruit']

# 예제 1) kimchi_test.csv 파일을 읽고,
df2 <- read.csv('kimchi_test.csv', fileEncoding = 'EUC-KR')
head(df2)
# 1) 1월 총각김치의 대형마트 판매량과 판매금액 출력(dplyr)
df2 %>%
  filter(제품 == '총각김치' & 판매월 == 1 & 판매처 == '대형마트') %>%
  select(수량, 판매금액)

# 2) 연도별 월별 전체 판매량의 총합 출력(dplyr)
# Wrong
df2 %>%
  group_by(판매년도, 판매월) %>%
  mutate(sum_sales = sum(수량)) %>%
  select(sum_sales)

# Answer
df2 %>%
  select(판매년도, 판매월, 수량) %>%
  group_by(판매년도, 판매월) %>%
  summarise_each(sum, 수량)

# 3) 연도별 판매량이 가장 많은 김치 출력
# Answer 1 => ddply - long data
library(plyr)
df3 <- ddply(df2, .(판매년도, 제품), summarise, total = sum(수량))
ddply(df3, .(판매년도), subset, total == max(total))

# Answer 2 => which.max - wide data
df4 <- dcast(df2, 제품 ~ 판매년도, sum, value.var = '수량')
which.max(df4[, -1])    # 2차원 데이터 적용 불가

f1 <- function(x) {
  vord <- which.max(x)
  df4[vord, 1]
}

f1(df4$`2013`)
f1(df4$`2014`)
f1(df4[ , -1])    # 2차원 적용 불가
apply(df4[ , -1], 2, f1)

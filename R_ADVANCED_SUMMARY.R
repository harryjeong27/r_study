# 1. 적용함수
# 1.1 apply(X,          # 대상                                                  
#          MARGIN = ,   # 방향(1:행별, 2:열별, c(1,2):원소별)
#          FUN = ,      # 적용함수
#          ...)         # 적용함수의 추가 인자
apply(iris[,-5], 2, mean)
# - X에는 1차원 객체(벡터) 전달 불가, 2차원 데이터 전달 가능
# - 출력 결과는 데이터프레임 제외 모든 객체 가능(벡터, 리스트, 행렬)
# - 주로 행별, 열별 그룹연산 수행을 위해 사용
# - R에서는 "원소별" 적용도 가능(파이썬 불가)

# 1.3 sapply(list, function, ...)
sapply(v1, f1)
# - 주로 벡터의 원소별 적용
# - 2차원 데이터 셋의 원소별 적용도 가능
# - 주로 벡터, 행렬로 리턴

# 1.5 tapply
# tapply(vector,    # 그룹연산 수행 대상(벡터)
#        index,     # 그룹벡터(group by 컬럼)
#        function)  # 적용함수(주로 그룹함수)
tapply(Fruits$Sales, Fruits$Fruit, sum)
# - 그룹별 적용
# - vector 자리에는 2차원 적용 불가 *
# - sql의 group by 연산과 비슷
# - 주로 벡터 리턴

# 2. 정렬함수
# 2.1 order(...,                # 정렬대상 (벡터, 데이터프레임 불가)
#          na.last = T,         # NA 배치 순서
#          decreasing = T)      # 정렬 순서
order(emp$SAL, decreasing = T)
# - 벡터만 정렬 가능, 여러 벡터 전달 가능(1차, 2차, ... 정렬 필요 시)
# - 각 벡터마다 정렬 순서 전달 가능
# - 문자와 숫자 벡터의 동시 정렬 시 정렬 순서 전달 오류 발생 (method 지정 필요)
# - 정렬 결과는 정렬 순서대로 위치값 리턴
# - 데이터프레임 직접 정렬 불가, 위치값 기반 색인으로 해결

# 2.2 sort
sort(x,                     # 정렬대상
     decreasing = ,         # 정렬순서
     ...)                   # 기타옵션
sort(v1)                    # 정렬결과 직접 출력
sort(emp$SALARY)            # sort의 결과로는 데이터프레임 정렬 불가
# - 하나의 벡터만 정렬 가능
# - 정렬 결과는 정렬 순서대로 정렬된 결과 직접 리턴

# 2.3 doBy::orderBy
doBy::orderBy(formula = ,     # Y ~ X1 + X2
              data = )        # 정렬할 데이터프레임
orderBy( ~ SAL + DEPTNO, emp)
# - 데이터프레임 정렬 가능
# - formular에 정렬하고자 하는 여러 컬럼 나열 가능
# - formular의 +, - 기호로 각 정렬 순서 전달 가능
# iris$Species ~ iris$Sepal.Length + ... +

# 3. sampling
# 3.1 sample(x,            # 추출할 원본 데이터(벡터)
#            size = ,      # 추출 개수
#            replace = ,   # 복원 추출 여부
#            prob = )      # 추출 비율
v_rn <- sample(1:nrow(iris), size = nrow(iris) * 0.7)
iris_train <- iris[v_rn, ]
iris_test <- iris[-v_rn, ]
# - row number를 사용한 표본 추출
# - group name/group number를 사용한 표본 추출
# - class별 균등 추출 불가 (대체적으로 raw data 비율과 비슷하게 추출됨)

# 3.2 doBy::samplyBy
# - data frame에서 직접 표본 추출 가능
# - 추출된 표본(train) 이외의 집단(test) 추출이 어려움
# - class별 균등 추출 가능
samplyBy(formula = ,         # ~ Y
         frac = ,            # 추출 비율
         replace = ,         # 복원 추출 여부
         data = )            # raw data
sampleBy( ~ Species, frac = 0.7, data = iris)

# 4. Join
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
merge(std, pro, by = 'PROFNO', all.x = T)[ , c('NAME.x', 'GRADE', 'NAME.y')]

# 5. 그룹연산
# 그룹별 특정함수의 적용
# 분리 -> 적용 -> 결합

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
aggregate(x,        # 연산대상 (벡터, 데이터프레임 가능)
          by,       # 그룹대상(group by 컬럼)
          FUN,      # 적용함수
          ...)      # 적용함수 필요 인자
aggregate(std$HEIGHT, list(std$GRADE), mean, na.rm = T)
aggregate(std[ , c('HEIGHT', 'WEIGHT')], list(std$GRADE), mean, na.rm = T)
aggregate(std$HEIGHT, list(std$GRADE, std$DEPTNO1), mean, na.rm = T)

aggregate(formula,  # 연산대상 (연산 넣으면 연산함) ~ 그룹대상 (연산 넣으면 그룹 추가됨)
          data,     # 데이터프레임
          FUN,      # 적용함수
          ...)      # 적용함수 필요 인자
aggregate(HEIGHT ~ GRADE, std, mean, na.rm = T)
aggregate(cbind(HEIGHT, WEIGHT) ~ GRADE, std, mean, na.rm = T)
aggregate(HEIGHT ~ GRADE + DEPTNO1, std, mean, na.rm = T)

# 6. Sqldf
sqldf::sqldf('select ENAME, SAL from emp where ENAME = "ALLEN"')
# - R 프로그램을 sql문법으로 처리 가능하도록 만든 패키지
# - sql 문법과 완전히 동일하지는 않을 수 있음
# - 특히 조인(non equi join) 수행 시 유리

# 7. plyr
# 7.2 plyr::ddply
# - 그룹연산 수행 (group by 연산)
# - 여러 개의 group by 컬럼 가능
# - 여러 컬럼의 그룹 연산 가능
# - 각 컬럼마다 서로 다른 그룹함수 전달 가능
# - 그룹별 비교 가능
# ddaply(data = ,           # 데이터 프레임
#        .variables = ,     # 그룹 연산 컬럼
#        FUN = ,            # 내부 함수
#        ...)               # 연산수식
# ddply 내부 함수
library(plyr)
# 1. summarise : 그룹별 데이터 요약 (sql group by 결과와 비슷)
ddply(emp, .(DEPTNO), summarise, avg_mean = mean(SAL), 
      mean_comm = mean(COMM, na.rm = T))
# 2. transform : 원본 데이터와 그룹 연산 결과 조인 형태
ddply(emp, .(DEPTNO), transform, avg_mean = mean(SAL))
# 3. mutate : transform과 유사, 이전 그룹연산 결과 재사용 가능
ddply(student, .(GRADE), mutate, v1 = mean(HEIGHT), v2 = log(v1))
# 4. subset : 그룹별 조건 전달 가능 (조건 추출)
ddply(student, .(GRADE), subset, HEIGHT == max(HEIGHT))

# 8. 데이터 구조 변경
# 8.1 stack : wide -> long
stack(x,       # data frame
      ...)     # 기타 옵션

# 8.2 unstack : long -> wide
unstack(x,     # data frame
        ...)   # formular : value column ~ index column

# 9.1 melt
# - stack 처리 함수(wide -> long)
# - stack 컬럼 지정 가능
melt(df1, id.vars = c('year', 'mon'), variable.name = '이름',
     value.name = '수량')
melt(data,             # 원본 데이터 프레임
    id.var = ,         # stack시 제외 컬럼 (그대로 유지)
    measure.var = ,    # stack 처리할 컬럼 (생략 시 id.vars 제외 모두)
    na.rm = F,         # NA 표현 여부
    value.name = ,     # value column 이름 지정
    variable.name = )  # index column 이름 지정

# 9.2 dcast
# - unstack 처리 (long -> wide)
# - 교차 테이블 생성
# - 행고정(index column), 컬럼 고정, value 표현 컬럼 필요
dcast(dcast2, year ~ name, mean, value.var = 'qty')
dcast(data,               # data frame
      formula = ,         # 행 고정 ~ 컬럼 고정
      fun.aggregate = ,   # 요약함수 (필요 시 지정)
      ...,                # 함수 추가 인자
      drop = T,           # 차원 축소
      value.var = )       # value column (생략 시 맨 끝 컬럼)

# 10.1 dplyr의 구조화된 문법
# 1) select : 컬럼의 선택
# 2) mudate : 컬럼 가공
# 3) filter : 행 선택
# 4) group_by : 그룹연산
# 5) arrange : 정렬
# 6) summarise_each : 그룹연산의 실제 연산 조건
emp %>%
  select(DEPTNO, SAL) %>%
  group_by(DEPTNO) %>%
  summarize_each(mean, SAL)

# 11. Which.min, which.max
# - 최대값과 최소값을 갖는 index 리턴(위치)
df1 <- dcast(Fruits, Fruit ~ Year, value.var = 'Sales')
vord <- which.max(df1$`2008`)
df1[vord, 'Fruit']
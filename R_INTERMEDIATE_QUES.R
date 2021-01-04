# -------------------------------연 습 문 제------------------------------------
# 연습문제 12. 10번 부서의 경우 SAL의 10% 증가값을, 나머지는 20% 증가값
#              NEW_SAL 컬럼에 추가
# if
# 1) 1번째 조건이 FALSE이므로 모두 else로 리턴 => Wrong Answer
if (emp$DEPTNO == 10){
  emp$NEW_SAL1 <- emp$SAL * 1.1
} else {
  emp$NEW_SAL1 <- emp$SAL * 1.2
}

# 2) 1번째 조건이 FALSE이므로 모두 else로 리턴 => Wrong Answer
emp$NEW_SAL2 <- 
  if (emp$DEPTNO == 10){
    emp$SAL * 1.1
  } else {
    emp$SAL * 1.2
  }

# ifelse                                                                        # *
ifelse (emp$DEPTNO == 10,
        emp$NEW_SAL3 <- emp$SAL * 1.1,
        emp$NEW_SAL3 <- emp$SAL * 1.2)
# 1) Wrong Answer => ifelse문은 리턴만 가능, 프로그래밍 처리 불가
vsal <- c()
ifelse (emp$DEPTNO == 10,
        vsal <- c(vsal, (emp$SAL * 1.1)),
        vsal <- c(vsal, (emp$SAL * 1.2)))
emp$NEW_SAL3 <- vsal
# 2) Answer
emp$NEW_SAL4 <- ifelse (emp$DEPTNO == 10,
                        emp$SAL * 1.1,
                        emp$SAL * 1.2)
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 13. emp 데이터에서 dname 컬럼 추가
#              10번 부서는 인사부, 20번은 재무부, 30번은 총무부
emp$dname <- 
  ifelse (emp$DEPTNO == 10,
          '인사부', 
          ifelse (emp$DEPTNO == 20,
                  '재무부',
                  '총무부'))
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 14. 10번 부서의 경우 SAL의 10% 증가값을, 나머지는 20% 증가값         # *
#              NEW_SAL 컬럼에 추가 (if + for문)
# Wrong Answer
vsal <- c()
for (vno in emp$DEPTNO) {
  if (vno == 10) {
    vsal <- c(vsal, emp$SAL * 1.1)
  } else {
    vsal <- c(vsal, emp$SAL * 1.2)
  }
}
length(vsal)    # 14 * 14 => 순서대로 행을 계산하는 것이 아닌 모든 행을 계산
# => 위치 변수 사용해야 함

# Answer => 위치 변수 활용                                                      
vsal <- c()
for (i in 1:nrow(emp)) {
  if (emp$DEPTNO[i] == 10) {
    vsal <- c(vsal, emp$SAL[i] * 1.1)
  } else {
    vsal <- c(vsal, emp$SAL[i] * 1.2)
  }
}
length(vsal)    # 14
emp$NEW_SAL <- vsal
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 15. emp에서 sal이 1000이하면 C, 1000 초과 2000이하 B, 2000 초과면    # *
#              A 리턴, grade 컬럼에 추가
emp$grade <- 
  ifelse (emp$SAL <= 1000,
          'C',
          ifelse (emp$SAL <= 2000,
                  'B',
                  'A'))

# 1) 반복 대상이 특정 컬럼인 경우                                               # **
vgrade <- c()    # 초기값
for (i in emp$SAL){
  if (i <= 1000){
    vgrade <- append(vgrade, 'C')
  } else if (i <= 2000){
    vgrade <- append(vgrade, 'B')
  } else{
    vgrade <- append(vgrade, 'A')
  }
}
emp$grade <- vgrade

# 2) 반복대상이 행의 위치값인 경우                                              # **
# 주로 반복 처리해야 할 컬럼이 여러개인 경우 사용
vgrade <- c()    # 초기값

for (i in 1:nrow(emp)){
  if (emp$SAL[i] < 1000) {
    vgrade <- append(vgrade, 'C')
  } else if (emp$SAL[i] <= 2000) {
    vgrade <- append(vgrade, 'B')
  } else{
    vgrade <- append(vgrade, 'A')
  }
}
emp$grade <- vgrade
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 20.
# 1) 1 ~ 100까지의 총합 출력
# i          vsum
# 1          (1)
# 2       ((1) + 2)
# 3     ((1 + 2) + 3)
# ...
# 100

i <- 1
vsum <- 0
while ( i <= 100 ) {
  vsum <- vsum + i
  i <- i + 1
  print(vsum)
}

# 2) 1 ~ 100까지의 총합 출력 (짝수만)
# Answer 1
i <- 1
vsum <- 0
while( i <= 50 ) {
  vsum <- vsum + (i * 2)
  i <- i + 1
}

# Answer 2
i <- 2
vsum <- 0
while( i <= 100 ) {
  vsum <- vsum + i
  i <- i + 2
}

# Answer 3
i <- 1
vsum <- 0
while(i <= 100) {
  if ( i%%2 == 0 ) {
    vsum <- vsum + (i * 2)
  }
  i <- i + 1
}
# ------------------------------------------------------------------------------

# --------------------------------실 습 문 제-----------------------------------
# 실습문제 5                                                                    # *
# 5.1 professor.csv 파일을 읽고
prof <- read.csv('professor.csv', fileEncoding = "euc-kr", stringsAsFactors = T) ; prof
library(stringr)
# 1) 교수번호가 40으로 시작하는 교수의 이름, 교수번호, pay 출력
# Answer 1
prof[substr(prof$PROFNO, 1, 2) == '40', c('NAME', 'PROFNO', 'PAY')]

# ^[Aa][Bb] => 이렇게 써야 A와 B 두개 모두 있는 경우 검색 (^[AaBb] x)

# Answer 2    *** ^은 시험문제                                                  # *
prof[str_detect(prof$PROFNO, '^40'), c('NAME', 'PROFNO', 'PAY')] 

# 2) email_id라는 각 교수의 이메일 아이디를 담는 컬럼 생성
# Answer 1
prof$email_id <- substr(prof$EMAIL, 1, str_locate(prof$EMAIL, '@')[, 1] - 1)

# Answer 2
prof$email_id <- str_sub(prof$EMAIL, 1, str_locate(prof$EMAIL, '@')[, 1] - 1)

# Answer 3 => 분리기반                                                          # *
str_split(prof$EMAIL, '@')[[1]][1]
str_split(prof$EMAIL, '@')[[2]][1]

for (i in 1:nrow(prof)) {
  prof$email_id[i] <- str_split(prof$EMAIL, '@')[[i]][1]
}

# 3) POSITION의 전임강사를 부교수로 수정                                        # *
# factor 변수가 아닌 경우
prof$POSITION <- ifelse (prof$POSITION == '전임강사', '부교수', prof$POSITION)
prof <- prof[!(colnames(prof) == 'position')]    # 열 삭제

# factor 변수로 나온다는 가정
# Answer 1 => level 수정
levels(prof$POSITION)[1] <- '부교수'
prof$POSITION <- ifelse (prof$POSITION == '전임강사', '부교수', prof$POSITION)

# Answer 2 => 값 직접 수정
prof$POSITION[prof$POSITION == '전임강사'] <- '부교수'     # NA 삽입 된다면? level에 없기 때문
levels(prof$POSITION) <- c('전임강사', '정교수', '조교수') # level 직접 수정
prof$POSITION[is.na(prof$POSITION)] <- '부교수'            # NA를 부교수로

# 4) 홈페이지 주소가 없는 경우 다음과 같이 수정
#    http://www.kic.com/email_id
# for + if => 반복해서 가져와야 할 행이 여러 개 일때는 아래처럼 위치 기반       
str_length(prof$HPAGE)  # 0 => 빈 문자열 삽입 확인
for (i in 1:nrow(prof)) {                   # 전체 행의 개수 (위치기반)
  if (prof$HPAGE[i] == '') {
    prof$HPAGE[i] <- (str_c('http://www.kic.com/', prof$email_id[i]))
  }
}

# ifelse
prof$HPAGE2 <- ifelse(prof$HPAGE == '',
                      str_c('http://www.kic.com/', prof$email_id),
                      prof$HPAGE)

# 5) 각 입사년도별 최대연봉을 받는 직원의 이름, 입사일, 연봉 출력               # **
# h_year 만들기 방법 1
h_year <- as.numeric(substr(prof$HIREDATE, 1, 4))

# h_year 만들기 방법 2
prof$HIREDATE <- as.Date(prof$HIREDATE)
prof$HYEAR <- as.numeric(as.character(prof$HIREDATE,'%Y'))

h_max <- c()
for (i in h_year) {
  h_max <- c(h_max, max(prof[h_year == i, 'PAY']))
}
prof$h_maxsal <- h_max
prof[prof$PAY == prof$h_maxsal, c('NAME', 'HIREDATE', 'PAY')]

# 5.2 data2.csv 파일을 읽고
data2 <- read.csv('data2.csv', fileEncoding = "euc-kr") ; data2

# 1) 4호선 라인의 전체 시간의 승차의 총합
# Answer 1 => replace
as.numeric((str_replace_all(data2$승차, ',', '')))
d_input <- data2[data2$노선번호 == 'line_4', '승차']
sum(as.numeric((str_replace_all(d_input, ',', ''))))

# Answer 2 => remove
data2$승차 <- as.numeric(str_remove_all(data2$승차, ','))
data2$하차 <- as.numeric(str_remove_all(data2$하차, ','))
sum(data2[data2$노선번호 == 'line_4', '승차'])

# 2) 1호선 라인의 9시~12시 시간대까지의 하차의 총합                             
# Answer 1 => 시간을 HHMM으로 이해한 경우
900 <= data2[data2$노선번호 == 'line_1', '시간'] < 13:00

d_time <- as.numeric(data2[data2$노선번호 == 'line_1', '시간'])
d_output <- as.numeric(str_replace_all(data2[data2$노선번호 == 'line_1', '하차'], ',', ''))
d_total <- c()

for (i in 1:NROW(d_time)) {
  if (d_time[i] >= 900 & d_time[i] < 1200) {
    d_total <- c(d_total, d_output[i])  
  }
}
sum(d_total)

# Answer 2 => 시간을 HH1HH2로 이해한 경우
# 시간 뽑아내기 : 앞두자리 시간 ~ 뒷두자리 시간
# Way 1
# 3자리면 앞에 1개 뒤에 2개
# 4자리면 앞에 2개 뒤에 2개

# Way 2
# 뒤에서 두자리 뽑고 남은 숫자로 시간 지정
str_sub('607', -2)
str_sub('0607', -2)
data$TIME <- as.numeric(str_sub(data2$시간, -2)) - 1

# Way 3                                                                         
# 앞에서 두자리 뽑기 => pad함수로 시간을 4자리로 만들기
TIME <- as.numeric(str_sub(str_pad(data2$시간, 4, 'left', '0'), 1, 2))
t_total <- c()
for (i in 1:NROW(as.numeric(data2[data2$노선번호 == 'line_1', '시간'])))
  if (TIME[i] > 8 & TIME[i] < 12) {
    t_total <- c(t_total, as.numeric(data2[data2$노선번호 == 'line_1', '하차'])[i])
  }

# 5.3 emp.csv 파일을 읽고                                                       # *
emp <- read.csv('emp.csv') ; emp
# 각 직원의 상위관리자 이름을 mgr_name이라는 컬럼으로 추가
# (단, 상위관리자가 없는 경우 NA)
emp$MGR[1] == emp$EMPNO
emp$ENAME[emp$MGR[1] == emp$EMPNO]
emp$mgr_name <- emp$ENAME[emp$MGR[1] == emp$EMPNO]

mgr_name <- c()
for (i in emp$MGR) {
  if (is.na(i)) {
    mgr_name <- c(mgr_name, NA)
  } else {
    mgr_name <- c(mgr_name, emp$ENAME[i == emp$EMPNO])
  }
}
emp$mgr_name <- mgr_name
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 21
# 1) 다음의 벡터에 반복문을 사용하여 10% 인상된 가격의 총합 리턴
v1 <- c(1000, 1500, NA, 3000, 4000)
vsum <- 0
for (i in v1) {
  if (is.na(i)) {
    next
  }
  vsum <- vsum + i * 1.1
}

# 2) NA 이전까지 print
for (i in v1) {
  if (is.na(i)) {
    break
  }
  print(i)
}
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 22                                                                   # *
# 22.1 위 문제를 for문 활용해서 벡터도 실행할 수 있게 만들기
for (i in c(0, 500, -5, 2, 9)) {
  if (i > 0) {
    return(1)
  } else if (i < 0) {
    return(-1)
  } else {
    return(0)
  }
}

# Answer => 위 상태도 괜찮지만, 벡터로 값이 들어오면 수행 안되므로
vresult <- c()
for (i in x) {
  if (i > 0) {
    vresult <- c(vresult, 1)
  } else if (i < 0) {
    vresult <- c(vresult, -1)
  } else {
    vresult <- c(vresult, 0)
  }
}

# Answer + function
f_sign2 <- function(x) {
  vresult <- c()
  for (i in x) {
    if (i > 0) {
      vresult <- c(vresult, 1)
    } else if (i < 0) {
      vresult <- c(vresult, -1)
    } else {
      vresult <- c(vresult, 0)
    }
  }
  return(vresult)    # return은 if와 for문 밖에
}

# Question : Answer 1처럼 함수 생성하지 않고도 가능한데? 적용함수 활용!         # *

# Answer 3 => 사용자 정의함수를 적용함수에 전달 (반복문 대체 연산)
f_sign(c(0, 500, -5, 2, 9))          # 벡터연산 불가
# sapply(list, function)
sapply(c(0, 500, -5, 2, 9), f_sign)  # 벡터연산 가능 => 각 원소를 f_sign에 넣음

# 22.2 sal값이 입력되면 등급을 출력하는 사용자 정의 함수 생성                   # *
# 1000미만 'C' 1000이상 3000 미만 'B', 3000 이상 'A'
# 1) 반복문 갖는 사용자 정의함수
f_sal <- function(x) {
  vsal <- c()
  for (i in x) {
    if (i < 1000) {
      vsal <- c(vsal, 'C')
    } else if (i < 3000) {
      vsal <- c(vsal, 'B')
    } else {
      vsal <- c(vsal, 'A')
    }
  }
  return(vsal)
}

# 2) 반복문 없는 사용자 정의함수 + sapply
f_sal <- function(x) {
  if (x < 1000) {
    return('C')
  } else if (x < 3000) {
    return('B')
  } else {
    return('A')
  }
}

f_sal(3000)
f_sal(emp$SAL)
sapply(emp$SAL, f_sal)

# 22.3 emp 데이터에서 보너스를 계산해주는 사용자 정의함수 생성                  # *
#      보너스는 10번 부서는 SAL의 10%, 20번은 15%, 30번은 20% 리턴
# 1) 적용함수
# step1) 먼저 7902직원의 보너스를 출력하는 수식 작성
vsal <- emp[emp$EMPNO == 7902, 'SAL']
vdeptno <- emp[emp$EMPNO == 7902, 'DEPTNO']

if (vdeptno == 10) {
  vsal * 1.1
} else if (vdeptno == 20) {
  vsal * 1.15
} else {
  vsal * 1.2
}

# ----------
f_bonus <- function(x) {
  vsal <- emp[emp$EMPNO == x, 'SAL']
  vdeptno <- emp[emp$EMPNO == x, 'DEPTNO']
  
  if (vdeptno == 10) {
    vsal * 1.1
  } else if (vdeptno == 20) {
    vsal * 1.15
  } else {
    vsal * 1.2
  }
}

# step2) 사용자 정의 함수 본문에 위 수식 전달, 7902 자리를 x로 변경
f_bonus(7902)
f_bonus(7369)
f_bonus(emp$EMPNO)              # Error => 정확한 벡터 연산 수행 x
sapply(emp$EMPNO, f_bonus)      # 벡터 연산 가능

emp
f_bonus <- function(x) {
  bonus <- 0
  if (emp$DEPTNO[emp$EMPNO == x] == 10) {
    bonus <- emp$SAL[emp$EMPNO == x] * 1.1
  } else if (emp$DEPTNO[emp$EMPNO == x] == 20) {
    bonus <- emp$SAL[emp$EMPNO == x] * 1.15
  } else {
    bonus <- emp$SAL[emp$EMPNO == x] * 1.2
  }
  return(bonus)
}
f_bonus(7499)

# 2) for                                                                        # * 해보기

# 22.4 부서번호에 따른 부서명 출력 함수 생성 및 적용
# 10번이면 인사부, 20은 재무부, 30은 총무부
f_dname <- function(x) {
  if (x == 10) {
    return('인사부')
  } else if (x == 20) {
    return('재무부')
  } else {
    return('총무부')
  }
}

f_dname(10)
f_dname(emp$DEPTNO)               # 벡터연산 불가
sapply(emp$DEPTNO, f_dname)       # 벡터연산 가능

# ------------------------------------------------------------------------------

# --------------------------------실 습 문 제-----------------------------------
# 실습문제 6                                                                    # *
# 6.1 exam_01.csv 파일을 읽고,                                                  # *
# f_hakjum함수를 생성하여 각 학생의 학번을 입력하면 학점이 나오도록
# 단, 학번 컬럼 입력시 전체 출력도 가능하게
# (f_hakjum(9411) = A+)
# 95이상 A+
# 90이상 A
# 85이상 B+
# 80이상 B
# 나머지 C
exam <- read.csv('exam_01.csv', fileEncoding = "euc-kr") ; exam

# Answer 1 => for
f_hakjum <- function(x) {
  hak <- c()
  for (i in x) {
    if (exam$TOTAL[exam$STUDNO == i] >= 95) {
      hak <- c(hak, 'A+')
    } else if (exam$TOTAL[exam$STUDNO == i] >= 90) {
      hak <- c(hak, 'A')
    } else if (exam$TOTAL[exam$STUDNO == i] >= 85) {
      hak <- c(hak, 'B+')
    } else if (exam$TOTAL[exam$STUDNO == i] >= 80) {
      hak <- c(hak, 'B')
    } else {
      hak <- c(hak, 'C')
    }
  }
  return(hak)
}
f_hakjum(exam$STUDNO)

# Answer 2 => sapply
f_hakjum <- function(x) {
  if (exam$TOTAL[exam$STUDNO == x] >= 95) {
    'A+'
  } else if (exam$TOTAL[exam$STUDNO == x] >= 90) {
    'A'
  } else if (exam$TOTAL[exam$STUDNO == x] >= 85) {
    'B+'
  } else if (exam$TOTAL[exam$STUDNO == x] >= 80) {
    'B'
  } else {
    'C'
  }
}
f_hakjum(9411)
sapply(exam$STUDNO, f_hakjum)

# 6.2 emp.csv 파일을 읽고,
# f_bonus라는 함수를 생성, 각 직원의 보너스를 출력
# (입사일이 1985년 이전인 경우는 근속년수 * 100, 이후인 경우는 90으로 계산)
emp <- read.csv('_emp__202007171152.csv') ; emp
# 1) empno 입력하면 보너스 출력* 2) 함수 쓰면 자동으로 전체 보너스 출력
# step1) empno 입력 -> hiredate -> 입사년도 구하기
# step2) (sysdate - hiredate) / 365 -> 근속년수 구하기
# step3) 입사일 1985 이전 이후에 따라 보너스 구하기
f_bonus <- function(x) {
  h_year <- as.numeric(as.character(as.Date(emp$HIREDATE[emp$EMPNO == x]), '%Y'))
  w_year <- trunc(as.numeric(((Sys.Date() - as.Date(emp$HIREDATE[emp$EMPNO == x])))) / 365)
  if (h_year < 1985) {
    w_year * 100
  } else {
    90
  }
}
f_bonus(7369)
f_bonus(emp$EMPNO)
sapply(emp$EMPNO, f_bonus)

# 6.3 다음의 사용자 정의함수 생성
# f_split(string, sep, n)
# str_split의 이해
str_split(string = ,
          pattern = ,
          n = )    # 몇번째 값을 가져올지에 대해
library(stringr)
str_split(a1, '#')           # 리스트로 출력
str_split(a1, '#')[[1]][2]   # 분리된 특정 위치 원소 추출 => 1층의 2번째
a1 <- 'a#b#dd#e##fa' 
str_split(a1, '#', 5)
l1 <- list(l2)
l2 <- c('a', 'b', 'dd', 'e', '', 'f')
str_sub(a1, (locate[1] + 1), (locate[2] - 1))
str_sub(a1, (locate[2] + 1), (locate[3] - 1))
str_sub(a1, (locate[3] + 1), (locate[4] - 1))
str_sub(a1, (locate[4] + 1), (locate[5] - 1))
str_sub(a1, (locate[5] + 1), (locate[6] - 1))

# Answer 1 => str_split 함수 자체 만들기                                        # *
f_split <- function(x, y, z) {
  locate <- str_locate_all(x, y)[[1]][, 2]
  l1 <- c(str_sub(x, 1, (locate[1] - 1)))
  for (i in 1:z-2) {
    l1 <- c(l1, str_sub(x, (locate[i] + 1), (locate[i + 1] - 1)))
  }
  l1 <- c(l1, str_sub(x, (locate[i + 1] + 1)))
  l2 <- list(l1)
  return(l2)
}

f_split('a#b#dd#e##fa', '#', 4)

# Answer 2 => str_split 함수에 n값을 통해 str_split의 원하는 컬럼의 원소 추출
# 1) input - scalar
f_split <- function(string, sep, n) {
  str_split(string, sep)[[1]][n]
}
f_split('a;b;c', ';', 3)

# 2) input - vector
f_split2 <- function(string, sep, n) {
  for (i in string) {
    vresult <- c(vresult, str_split(i, sep)[[1]][n])
  }
  return(vresult)
}
f_split2(c('a;b;c', 'A;B;C;D'), ';', 1)

# 사용용도
pro <- read.csv('professor.csv', fileEncoding = "euc-kr") ; exam
f_split2(pro$EMAIL, '@')

# sapply 활용                                                                   # *
sapply(list, function, ...)
# list => 적용대상
# function => 적용함수
# ... => 해당 함수가 추가적인 공간을 요구한다면 나열하는 공간 
# f(x, y, z)
# sapply(x, f, y, z) => 위 함수를 sapply에 넣으면 이렇게 사용가능 
# sapply(x, f, (y, z)) => 불가능
sapply(pro$EMAIL, f_split2, '@', 1)
# sapply가 pro$EMAIL를 가져오므로 sapply의 3, 4번째에 f_split2의 2, 3번째 인자를 넣음

# 6.4 oracle의 translate함수 구현(f_translate로 생성)                           # *
# (단, 두번째와 세번째 인자의 길이 같을 경우만 고려)
# 문자열, 대상문자, 변환문자
# Answer 1 => better
f_translate <- function(x, y, z) {
  for (i in 1:str_length('hw')) {
    if (str_length('hw') + 1 - i > 0) {
      a1 <- str_replace_all(a1, str_sub('hw', i, i), str_sub('HW', i, i))
    }
  }
}

f_translate <- function(x, y, z) {
  for (i in 1:str_length(y)) {
    if (str_length(y) + 1 - i > 0) {
      x <- str_replace_all(x, str_sub(y, i, i), str_sub(z, i, i))
    }
  }
  return(x)
}
f_translate('hello world!!!', 'o', ' ')
f_translate('abcba', 'ab', 'A')

# Answer 2 => 1 function missing
# translate('abcba', 'ab', 'AB') => 'ABcBA'
# translate('abcba', 'ab', 'A') => 'AcA' (이 기능은 제외, 내 답안은 포함)
# f_translate(string, old, new)
f_tranlstae <- function(string, old, new) {
}
# step1) old, new에 들어오는 문자열을 1글자씩 분리
# way1) str_sub
str_sub('ab', 1, 1)
str_sub('ab', 2, 2)
str_length('ab')
'ab'

# way2) str_split
str_split('ab', '')[[1]][1]
str_split('ab', '')[[1]][2]
str_length('ab')

# step2) old, new의 분리된 문자열로 치환 반복
f_translate2 <- function(string, old, new) {
  vold <- str_split(old, '')[[1]]   # 한글자로 나눠서 벡터로 변경
  vnew <- str_split(new, '')[[1]]
  vn <- length(vold)
  for (i in 1:vn) {
    string <- str_replace_all(string, vold[i], vnew[i])
  }
  return(string)
}

f_translate2('abcba', 'ab', 'A')
# 벡터 연산도 가능 => 본문 자체가 벡터를 방해하는 요소가 없음
f_translate2(c('abcba', 'ababc'), 'ab', 'AB') 
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 22.4 데이터 프레임에서 각 행에 NA를 n개 포함하는 경우 삭제하여 리턴   # *
#              하도록 사용자 정의함수 생성
df1 <- as.data.frame(matrix(1:25, ncol = 5))
df1[1, 1] <- NA
df1[2, 2:3] <- NA
df1[3, 3:5] <- NA
df1[4, 1:4] <- NA

f_dropna(df1, n)

# Answer 1 => NA만 공백으로 변환
for (i in 1:NROW(colnames(df1))) { 
  if (sum(is.na(df1[i, ])) >= 2) {
    df1[i, is.na(df1[i, ])] <- ''
  }
}

f_dropna <- function(x, n) {
  for (i in 1:NROW(colnames(x))) { 
    if (sum(is.na(x[i, ])) >= n) {
      x[i, is.na(x[i, ])] <- ''
    }
  }
  return(x)
}
f_dropna(df1, 1)

# Answer 2 => 해당 행을 제거                                                    # *
is.na(df1)
# 행별 NA의 총 개수
sum(is.na(df1)) >= n    # 전체 NA 개수

# Answer 2.1 => for문을 사용하여 각 행별 카운트
vcnt <- c()
for (i in 1:5) {
  vcnt <- c(vcnt, sum(is.na(df1[i, ])))
}
df1[!vcnt >= 3, ]

# Answer 2.2 => apply
# apply : 행별, 열별 특정 함수의 적용    => very powerful ***
apply(array,    # 2차원 데이터 형식
      margin,   # 방향(1: 행별, 2: 열별)
      ...)      # 적용함수와 추가 인자 
# => 보통 그룹함수와 잘 어울림 (여러개 전달 후 1개의 값 리턴)
# sapply(벡터, 함수) : 원소 하나를 빼서 전달 (벡터의 원소별 적용)
# apply : 행/열 하나를 빼서 전달 (행/열별 적용)
vcnt2 <- apply(is.na(df1), 1, sum)
df1[!vcnt2 >= 3, ]

# Anwer 2.3 사용자 정의 함수 생성
f_dropna2 <- function(x, n) {
  vcnt <- c()
  for (i in 1:nrow(x)) {
    vcnt <- c(vcnt, sum(is.na(x[i, ])))
  }
  x <- x[!vcnt >= n, ]
  return(x)
}
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 23                                                                   # *
# 23.1 팩토리얼 함수를 self call 형태로 생성
factorial(3)
f2 <- function(x) {
  if(x == 1) {
    1
  } else {
    f_fac(x - 1) * x
  }
}
f2(3)

# 23.2 피보나치 수열
# 1 1 2 3 5 8 13 21 ... 
# f(1) => 1
# f(2) => f(1) + 1
# f(3) => f(2) + f(1)
# f(4) => f(3) + f(2)

f3 <- function(x) {
  if((x == 1) | (x == 2)) {
    1
  }
  else {
    f3(x - 2) + f3(x - 1)
  }
}
f3(4)
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 24. seoul_new.txt 파일을 불러와서 다음의 형태를 갖는 데이터프레임 생성 # * window에서 풀이
# id                       text                 date      cnt
# 305 무료법률상담에 대한 부탁의 말씀입니다. 2017-09-27    2
# Answer 1
# step 1) 스칼라 테스트
data1 <- readLines('seoul_new.txt',  fileEncoding = "euc-kr", header = F)

v_str <- str_trim(data1[1], side = 'both')
v_str <- str_split(data[1], ' ')[[1]]
vid <- v_str[1]
vlen <- length(v_str)
vcnt <- v_str[vlen]
vdate <- v_str[vlen - 1]
vtext <- str_c(v_str[2:(vlen - 2)], collapse = ' ')
vid <- c() ; vcnt <- c() ; vdate <- c() ; vtext <- c()
for (i in data1) {
  v_str <- str_trim(i, side = 'both')
  v_str <- str_split(vstr, ' ')[[1]]
  vlen <- length(v_str)
  vid <- c(vid, v_str[1])
  vcnt <- c(vcnt, v_str[vlen])
  vdate <- c(vdate, v_str[vlen - 1])
  vtext <- vtext(str_c(v_str[2:(vlen - 2)], collapse = ' '))
}

df_data <- data.frame(id = vid, text = vtext, date = vdate, cnt = vcnt)
head(df_data)

df_data$id <- as.numeric(df_data$id)
df_data$cnt <- as.numeric(df_data$cnt)

# Answer 2 => 위와 같음
seoul <- read.csv('seoul_new.txt', fileEncoding = "euc-kr", header = F)
seoul <- read.csv("clipboard", header = F)

library(stringr)
seoul$id

id <- c()
cnt <- c()
date <- c()
text <- c()

for (i in 1:(nrow(seoul) - 1)) {
  id <- c(id, str_split(seoul$V1, ' ')[[i]][1])    # id
  cnt <- c(cnt, str_split(seoul$V1, ' ')[[i]][length(str_split(seoul$V1, ' ')[[i]]) - 1]) # cnt
  date <- c(date, str_split(seoul$V1, ' ')[[i]][length(str_split(seoul$V1, ' ')[[i]]) - 2]) # date
  text <- c(text, str_split(seoul$V1, ' ')[[i]][2:(length(str_split(seoul$V1, ' ')[[i]]) - 2 - 1)])
}
text <- c(str_split(seoul$V1, ' ')[[1]][2:(length(str_split(seoul$V1, ' ')[[1]]) - 2 - 1)])
# ------------------------------------------------------------------------------
reviewed 1, 2020-09-13
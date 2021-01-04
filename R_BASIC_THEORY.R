# --------------------------------  BASIC   ------------------------------------

# [ 참고 1 : 여러 라인 주석처리 및 해제(ctrl + shift + c) ]

# [ 기초 1. 환경설정 ]
# - 작업 디렉토리(홈디렉토리) : C:/Users/kitcoop/Documents => 외부파일 넣을 경로
getwd()                              # 작업 디렉토리 확인                       # *
setwd('/Users/harryjeong/r_data')    # 작업 디렉토리 변경 in this session       # *
# RStudio 환결설정에서 영구 변경 가능
# ------------------------------------------------------------------------------

# [ 기초 2. 변수 : 연산결과나 상수를 저장하기 위한 객체 ]
# 변수명 <- 상수 혹은 연산결과

# 아래처럼 작성해도 되지만
a1 = 1
1 -> a1

# 아래가 표준
a1 <- (1 + 10) * 101 / 200
a1 * 100
b1 <- 100
a1 + b1

# 문자 상수는 '' 혹은 ""로 묶어줌
c1 <- 'abc'
d1 <- "abc"

# 변수의 타입 확인 함수 : class
class(a1)   # numeric
class(c1)   # character

# 변수명에 함수명을 사용하면 안됨 ex) sum, mean, c
# 보통 숫자나 다른 문자 같이 사용
sum1 <- 1 + 1
vsum <- 1 + 1

c(1, 2, 3)    # C라는 함수 존재

# 변수의 산술연산
a1 + 1      # 숫자변수 + 숫자 가능
a1 + b1     # 숫자변수 + 숫자변수 가능
e1 <- '100'
e1 + 1      # Error => 문자 + 숫자 불가능, 숫자처럼 생긴 문자의 형 변환 발생 x (<-> oracle)

d1 <- Sys.Date()  # sysdate in oracle
class(d1)
d1 + 100          # 날짜 + 숫자 가능 (기본 단위 : Day)
# ------------------------------------------------------------------------------

# [ 기초 3. 형 변환 함수 ]
as.numeric()      # to_number in oracle
as.character()    # to_char in oracle
as.Date()         # to_date in oracle
# 모든 것에 대소 구분하므로 as.date로 쓰면 인식 안됨.

# 위 문제 숫자로 변경 후 처리
as.numeric(e1) + 1
# ------------------------------------------------------------------------------

# [ 기초 4. 변수에 연속적인 값 대입 ]
1:10        # 숫자에 연속배열 생성 가능
'a':'f'     # 문자에 연속배열 생성 불가능

# seq()                                                                         # *
seq()
help(seq)

seq(from = 1,    # 시작값
    to = 1,      # 끝값
    by = 1)      # 증가값

# [ 참고 2 : 함수의 사용 방법 ]
# - 정해진 순서대로 인자 전달, 각 인자의 이름 생략 가능
seq(from = 1, to = 10, by = 2)
seq(1, 10, 2)
# - 정해진 순서와 다른 순서로 인자 전달 시 반드시 인자 이름 명시
seq(to = 20, from = 10, by = 5)

# [ 참고 3 : 문자 -> 날짜 파싱 ]
2020/01/01 ~ 2020/01/31
seq('2020/01/01', '2020/01/31', by = 1)    # Error => 문자로 인식
seq(as.Date('2020/01/01'), as.Date('2020/01/31'), by = 1)    # 날짜로 변경

as.Date('2020/01/01')   # 기본 날짜 포맷
as.Date('06/30/2020')   # Error => 날짜 포맷이 다름
as.Date('06/30/2020', format = '%m/%d/%Y')    # 날짜 포맷 변경                  # *

# [ 참고 4 : 날짜 형식 확인 방법 ]
help(as.Date)    # 불가
help(strptime)   # 가능

# %Y : 4자리 년도
# %y : 2자리 년도
# %m : 월
# %d : 일
# %H : 시
# %M : 분
# %S : 초
# %w : 숫자요일(일요일 : 0)
# %A : 문자요일

# 날짜 -> 문자(날짜의 포맷 변경)
d1 <- Sys.Date()
d2 <- as.character(d1, '%m-%d, %Y')
class(d2)
# ------------------------------------------------------------------------------

# [ 기초 5. packages : 함수의 묶음, 외부 package를 다운받게 되면 ]
# 세션마다 해당 package를 로딩해서 사용

# 날짜 관련 외부 패키지 : lubridate                                             # *
install.packages("lubridate")
library(lubridate)

todate <- Sys.Date()
as.character(todate, '%Y')    # as.character를 사용해 날짜 변환

year(todate)                # 연도
month(todate)               # 월, 숫자형식 (label = T는 non-default값)
month(todate, label = T)    # 월, 영문날짜인 경우 문자형식 출력 (T : True)

day(todate)     # 일
wday(todate)               # 요일, 숫자형식
wday(todate, label = T)    # 요일, 문자형식

hour(todate)    # 시간
minute(todate)  # 분
second(todate)  # 초

todate + 7          # 7일 후
todate + days(7)    # 7일 후
todate + hours(7)   # 7시간 후
todate + months(7)  # 7개월 후
todate + years(7)   # 7년 후

lubridate::    # 패키지명 :: => 함수목록확인
    
# [ 참고 5 : 날짜 언어 변경 ]
Sys.setlocale('LC_TIME', 'c')       # 영문
Sys.setlocale('LC_TIME', 'KOREAN')  # 한글

# [ 참고 6 : 변수 확인 및 제거 ]                                                  # *
objects()    # 현재 세션에 정의된 변수 목록 확인
ls()         # 현재 세션에 정의된 변수 목록 확인
sum <- 10   
rm(sum)      # sum 변수 하나 제거
rm(a1)       # rm = remove here
rm(list = c('v1', 'v3'))  # 변수 여러개 제거(v1, v3)
rm(list = objects())    # 현재 세션에 정의된 모든 변수 삭제
rm(list = ls())         # 현재 세션에 정의된 모든 변수 삭제
# ------------------------------------------------------------------------------

# [ 기초 6. 산술 연산자 ]
7 %/% 3    # 몫
7 %% 3     # 나머지
2 ^ 3      # 거듭제곱(2의 3승)
2 ** 3     # 거듭제곱(2의 3승)
1e1        # 10
2e1        # 20
1e2        # 100
1e-1       # 0.1
# ------------------------------------------------------------------------------

# [ 기초 7. NULL ]                                                              # *
# NULL in DB : 아직 정의되지 않은 값
# NULL in R : NA & NULL
# Both must write in capital only
# - NA : 잘못 들어온 값
# - NULL : 정해지지 않은 값, 물리적 위치를 갖지 않음

as.Date('2020/01/01', '%Y/%M/%D')    # NA => 문법적으론 가능 but 해석 불가능
# ------------------------------------------------------------------------------

# [ 기초 8. 함수 format 읽기 ]
# [ 참고 7 : 가변형 인자 전달 방식 ]
# 함수의 인자 자리에 ...이 있는 경우는 여러 개 대상이 들어갈 수 있음
sum(..., na.rm = F)
sum(1, 2, 3)
sum(c(1, 2, 3))

# 아래 format에서 첫 인자가 여러개라면 file에서 벡터로 넣어야 함
cat(..., 
    file = , )
cat(..., 
    file = c(a.txt, b.txt))
cat(1, 2, NA, 3)      # 1 2 NA 3
cat(1, 2, NULL, 3)    # 1 2 3 (NULL이 자리를 차지하고 있지 않아 출력 x)
help(cat)

mean(x, ...)      # 첫번째 인자로 평균 구함
mean(1, 2, 3)     # 1만 전달 => 2, 3은 무시
mean(c(1, 2, 3))  # c(1, 2, 3)은 하나의 객체이므로 전체 전달 가능
help(mean)     

sum(1, 2, NA)     # NA => NA는 무시 되지 않음
sum(1, 2, NULL)   # 3 => NULL은 무시됨

NULL + 3                                                                        # *
# numeric(0) : 0바이트를 차지하고 있고, 자료구조가 있다면 NUMERIC이다. (결국, NULL)
# => 함수가 아니면 무시되지 않음
NA + 3            # NA
# ------------------------------------------------------------------------------

# [ 기초 9. 논리 연산자 ]                                                       # *
# 1) and
# Oracle => (v_sal > 1000) and (v_sal < 2000)
(v_sal > 1000) & (v_sal < 2000)
v_sal[(v_sal > 1000) & (v_sal < 2000)]

# 2) or
(v_sal <= 1000) | (v_sal >= 2000)
v_sal[(v_sal <= 1000) | (v_sal >= 2000)]

# 3) not
(v_sal > 1000)
!(v_sal > 1000)

v_sal == 1000
v_sal != 1000
!(v_sal == 1000)

# [ 참고 8 : 숫자를 사용한 논리값의 전달 ]
# 0 : FALSE(0이 아니면 TRUE)

!0       # True
!100     # False
1 & 3    # True & True = True
1 * 0    # True & False = False

# True False False => 각 결과마다 논리연산 o                                    # **
c(TRUE, TRUE, FALSE) & c(TRUE, FALSE, FALSE)      
# True => 각 결과마다 논리연산 x
c(TRUE, TRUE, FALSE) && c(TRUE, FALSE, FALSE)   

v1 <- 1:3               # c(1, 2, 3)
(v1 < 3) & (v1 == 1)    # (T T F) & (T F F ) => T F F 

# 예제) emp 데이터에서 sal > 2000이면서 deptno = 10인 직원선택
(emp1$SAL > 2000) & (emp1$DEPTNO == 10)
(emp1$SAL > 2000) && (emp1$DEPTNO == 10)

emp1[(emp1$SAL > 2000) && (emp1$DEPTNO == 10), ]    # 잘못된 전달
emp1[(emp1$SAL > 2000) & (emp1$DEPTNO == 10), ]     # 올바른 전달
# ------------------------------------------------------------------------------

# [ 기초 10. 포함 연산자 ]
v_sal[(v_sal == 800) | (v_sal == 1000)]
v_sal[v_sal %in% c(800, 1000)]
# ------------------------------------------------------------------------------

# [ 기초 11. 형(데이터 타입) 확인 함수 ]
v1 <- c(1, NA, 3)
v2 <- c(1, NULL, 3)

is.vector(v1)
is.numeric(v1)
is.na(v1)        # 벡터의 각 원소마다 NA 여부 리턴 => NA는 데이터에서 삭제 필요
is.na(v2)        # 벡터의 각 원소마다 NA 여부 리턴, NULL은 생략
is.null(v2)      # 벡터 자체가 NULL인지 리턴
# ------------------------------------------------------------------------------

# [ 기초 12. 문자열 함수 ]                                                      # *
# stringr 패키지 사용
install.packages('stringr')
library(stringr)

# 12.1 str_detect : 문자의 포함 여부 확인(패턴확인) => like in oracle           # *
str_detect(strings = ,
           pattern = )

v1 <- c('abc', 'bcd', 'Abc', 'acd', 'cabd')
v2 <- c('ab12', '1a34', 'cds', '1234', 'cde!')
v3 <- c('abc', 'aabc', 'aaabc', 'aaaabc')

str_detect(v1, 'a')           # 'a'를 포함하는지 여부
str_detect(v1, '[aA]')        # 'a' or 'A'를 포함하는지 여부
str_detect(v1, '[aA][bB]')    # 각 스칼라의 n번째에는 'a' or 'A',
# n+1번째에는 'b' or 'B'를 포함하는지 여부
str_detect(v1, '^a')          # 햇기호, 'a'로 시작하는지 여부
str_detect(v1, 'd$')          # 끝기호, 'd'로 끝나는지 여부

str_detect(v2, '.a')          # 2번째 글자가 'a' 인지 여부
str_detect(v2, '[0-9]')       # 숫자를 포함하는지 여부
str_detect(v2, '[:digit:]')   # 숫자를 포함하는지 여부
str_detect(v2, '[a-zA-Z]')    # 영문을 포함하는지 여부
str_detect(v2, '[:alpha:]')   # 영문을 포함하는지 여부
str_detect(v2, '[:punct:]')   # 특수기호를 포함하는지 여부

str_detect(v3, pattern = 'a{2,4}')   # 'a'가 연속적으로 2회이상 4회이하 포함

# 12.2 str_locate : 문자열에서의 특정 패턴의 위치 리턴 => instr in oracle
str_locate(string = ,
           pattern = )

v1 <- c('a#b#c#', 'a##b##')
str_locate(v1, '#')        # 2번째에서 시작해서 2번째에서 끝
str_locate(v1, '##')       # 2번째에서 시작해서 3번째에서 끝
str_locate_all(v1, '#')    # 모든 #의 위치 표시
# => 2번째 '#'의 위치를 가져오려면 각 층에서 2번째 행 선택                      # *
# How? 층을 반복하는 반복문 사용

# 12.3 str_count() : 문자열에서의 특정 값의 포함 횟수 리턴
str_count(string = ,
          pattern = )

str_count(v3, 'a')    # 각 원소마다 'a' 포함 횟수

# 12.4 str_c() : 분리되어진 문자열의 결합 => concat or | in oracle              # *
str_c(...,
      sep = ,               # 분리된 객체끼리 결합 시 삽입기호
      collapse = NULL)      # 하나의 객체 내 원소 결합 시 삽입기호

str_c('a', 'b', 'c')              # "abc"
str_c('a', 'b', 'c', sep = ' ')   # "a b c"  

v1 <- c('a', 'b', 'c')
v2 <- c('A', 'B', 'C')

str_c(v1, v2)               # 같은 위치끼리 결합
str_c(v1, v2, sep = '_')    # 같은 위치끼리 결합
str_c(v1)                   # a b c => 벡터
str_c(v1, collapse = '')    # abc
str_c(v1, collapse = '|')   # a|b|c
str_c(v1, '-----')          # 벡터 + 문자열 가능 like ename || '의 연봉은...'

# 12.5 substr, str_sub : 문자열 추출
substr(x, start, stop)    # stop : 위치
stringr::str_sub(string, start, stop)    # stop : 위치

v1 <- 'abcde'
substr(v1, 1, 2)
substr(v1, 2, 2)
str_sub(v1, 2, 2)

substr(v1, 2)    # Error => 내장함수, stop 생략 불가
str_sub(v1, 2)   # stop 생략 시 끝까지 추출

# 12.6 str_length() : 문자열의 길이 리턴                                        # *
v1 <- c('abc', 'aaab', '231vg')

length(v1)              # 3 => 벡터의 원소의 개수
str_length(v1)          # 3 4 5 => 벡터의 각 원소의 문자열의 크기

# 12.7 str_replace : 치환함수                                                   # *
str_replace(string = ,                 # 원본 문자열
            pattern = ,                # 찾을 문자열
            replacement = )            # 바꿀 문자열

str_replace('abcba12', 'aab', 'AB')    # 단어 치환(글자 대 글자 치환 )
str_replace('abcba12', 'ab', '')       # 삭제
str_remove('abcba12', 'ab')            # remove 함수로도 삭제 가능
str_replace('abcba12', '[ab]', '')     # a만 치환
str_replace_all('abcba12', '[ab]', '') # all을 써야 찾을 문자열 정규식 표현 가능# *

v1 <- c('12ab', NA, 'abc')
str_replace_all(v1, '[0-9]', 'a')      # 벡터의 원소별 치환 가능
str_replace_all(v1, NA, 'a')           # Error => NA의 치환 불가 (찾기 불가)    # *
str_replace_all(v1, 'abc', NA)         # Error => NA로 치환 불가 (변경 불가)

v2 <- c('a', 'b', 'c')
str_replace_all(v2, 'a', 0)            # Error => 문자로만 치환 가능

# [ NA 치환 방법 ]                                                              # *
v1[is.na(v1)] <- 'aa'                # NA만 선택 후 수정 방식
ifelse(is.na(v1), 'aa', v1)          # 전체 벡터 수정 방식
str_replace_na(v1, 'aa')             # nvl과 비슷 in Oracle

# 12.8 대소치환                                                                 # *
str_to_upper('abc')            # upper
str_to_lower('ABC')            # lower
str_to_title('abc')            # initcap

# 내장함수
toupper('abc')
tolower('ABC')

# 12.9 str_split : 문자열 분리                                                  # *
str_split(string = ,
          pattern = ,
          n = )

a1 <- 'a#b#c#'               # '#'으로 분리해서 구분하라
str_split(a1, '#')           # 리스트로 출력
str_split(a1, '#')[[1]][2]   # 분리된 특정 위치 원소 추출 => 1층의 2번째

# 12.10 str_pad : 삽입함수                                                      # *
str_pad(string,                              # 원본 문자열
        width = ,                            # 총 길이
        side = c('left', 'right', 'both'),   # 삽입 방향
        pad = '')                            # 삽입 문자

str_pad('506', 4, 'left', '0')

# 12.11 str_trim : 공백 제거함수                                                # *
str_trim(string,                              # 원본 문자열
         side = c('both', 'left', 'right'))   # 제거 방향

str_trim(' abc', 'left')
str_trim(' abc ', 'both')

# 12.12 str_trunc : 앞, 뒤 문자의 제거                                          # *
str_trunc(stirng = ,                            # 원본 문자열
          width = ,                             # 제거 후 리턴 길이
          side = c('center', 'left', 'right'),  # 제거방향
          ellipsis = )                          # 제거문자

str_trunc('aaaabcdaa', 6, 'left', 'a')          # "abcdaa"

# 12.13 str_extract_all(문자열, 패턴)
# - 원하는 패턴의 문자열 추출
# - 패턴에 정규식 표현 가능
# - 리스트 출력

# 예제) 다음의 역이름에서 역이름만 추출
str_extract_all('을지로2가(2)', '[가-힣]')
str_c(str_extract_all('을지로2가(2)', '[:alpha:]')[[1]], collapse = '')
# ------------------------------------------------------------------------------

# [ 기초 13. factor 변수 ]                                                      # *
# - 변수의 범주(level)가 정해져 있는 형태
# - 주로 문자일 경우
# - read.csv로 불러올때 문자 타입의 컬럼은 자동으로 factor로 생성

# 13.1 생성
f1 <- factor('m', c('m', 'f'))
f2 <- factor('m', c('m', 'f'), ordered = T)
f3 <- factor('m', c('m', 'f'), ordered = F)
f4 <- ordered('m', c('m', 'f'))    # ex) 요일
f5 <- factor(c('a', 'b', 'c'), c('a', 'b', 'c'))
str(f5)
str(f2)

# 13.2 level 확인
levels(f1)

# 13.3 factor 변수 <-> 일반변수
v1 <- c('a', 'b', 'c')
v2 <- as.factor(v1)
v3 <- as.character(v2)

# 13.4 factor 변수의 수정
v2[3] <- 'd'    # Error => level이 맞지 않음, NA로 치환
levels(v2) <- c('a', 'b', 'c', 'd')    # level 확장
v2              # level 수정 확인
v2[3] <- 'd'    # 값 입력 가능

# level 수정을 통한 값 수정 => 자동으로 대문자로 변경
levels(v2) <- toupper(c('a', 'b', 'c', 'd'))

# 13.5 문자열 컬럼이 자동으로 factor로 생성되는 경우
emp <- read.csv('emp.csv', stringsAsFactors = T) ; emp
# mac에서는 stringsAsFactors = F가 default
# window에서는 stringsAsFactors = T가 default
str(emp)

# 예제) emp 테이블 내 ENAME의 맨 앞 두자를 추출, 새로운 컬럼에 추가
emp$ENAME1 <- str_sub(emp$ENAME, 1, 2)
# window에서는 cbind로 문자컬럼 추가 시 자동으로 factor로 나옴                  # *
emp <- cbind(emp, 'ENAME2' = str_sub(emp$ENAME, 1, 2))
emp <- cbind(emp, 'ENAME2' = str_sub(emp$ENAME, 1, 2), stringsAsFactor = F)
str(emp)
# ------------------------------------------------------------------------------

# [ 기초 14. 전역변수와 지역변수 ]
# 전역변수 : 변수의 정의가 세션 전체 적용
# 지역변수 : 변수의 정의가 일부 함수에만 유효
# 1)
v1 <- 1                 # 함수 밖에서 선언, 전역변수
f1 <- function(x) {
  print(v1)
}
f1()

# 2)                    # 함수 내 선언, 지역변수
v1 <- 1                 # 우선순위 : 지역변수 > 전역변수
f2 <- function(x) {
  v1 <- 10
  print(v1)
}

f2()

# 3)
f3 <- function(x) {
  v2 <- 10                # 지역변수, f3 함수에서만 사용 가능
  print(v2)
}

f4 <- function(x) {
  print(v2)
}

f3()
f4()                        # object not found Error
v2                          # object not found Error

# 4) 지역변수의 전역변수 설정                                                   # *
f3 <- function(x) {
  v2 <<- 10                # 지역변수 -> 전역변수
  print(v2)
}

f4 <- function(x) {
  print(v2)
}

f3()                        # 10
f4()                        # 10
v2                          # 10

# 현 세션에 정의된 변수 생성 및 제거
ls()
rm('v2')
# ------------------------------------------------------------------------------

# [ 기초 15. 문자의 포맷 변경 ]
  # sprintf
  # - 문자로 리턴
  # to_char(1234, '09999') => '01234')
  # to_char(1234, '99999') => ' 1234')
  # to_char(1234, '9999.99') => '1234.00')
  
  sprintf(fmt = , # 변경할 포맷 (s: 문자열, d: 정수, f: 실수)
          ...)    # 변경 대상
  
  sprintf('%5d', 1234)     # " 1234" => 문자
  sprintf('%05d', 1234)    # "01234" => 문자
  sprintf('%7.2f', 1234)   # "1234.00" => 문자
  sprintf('%8.2f', 1234)   # " 1234.00" => 문자
  sprintf('%.2f', 1234)    # "1234.00" => 문자 (가장 많이 사용)
  sprintf('%5s', 'abc')    # "  abc" => 문자]
# ------------------------------------------------------------------------------
reviewed 1, 2020-09-12
# ------------------------------ INTERMEDIATE ----------------------------------
# [ 중급 1. 조건문 ]
# 1.1 if
# - 조건에 따른 치환 혹은 프로그래밍 처리 시 사용
# - 벡터 연산 불가 (벡터의 원소별 조건 전달이 불가, 조건은 반복 전달 불가)

# 1) Grammar
# if ( boolean_expression1 ) {
#     statement1 when TRUE
# } else if ( boolean_expression2 ) {
#     statement2 when TRUE
# } else {
#     statement2 when FALSE
# }

# 예제) v1의 값이 0이상이면 'A', 미만이면 'B' 리턴
v1 <- 11

if (v1 >= 0){
    'A'
}  else {
    'B'
}

# 예제) v1의 값이 30보다 크면 'A', 20보다 크면 'B', 20보다 작으면 'C' 리턴
if (v1 >= 30){
    'A'
} else if (v1 > 20){
    'B'
} else {
    'C'
}

# [ if문에 벡터 전달 불가 현상 ]                                                # *
v1 <- c(10, 25, 55)
if (v1 >= 30){
    'A'
} else if (v1 > 20){
    'B'
} else {
    'C'
}
# Error =>In if (v1 > 20) { :
# the condition has length > 1 and only the first element will be used
# if는 단 하나의 논리값만 허용한다. ex) 위에서 1번째 조건이 F T T 나옴
# => 반복이 안되므로 1번째 결과만 출력 => need < for >

# 예제) emp 데이터에서 sal이 3000이상인 경우는 'A', 아닌 경우는 'B' 리턴
emp$SAL >= 3000

if (emp$SAL >= 3000){    # B => 1번째 값에 대한 조건만 리턴
    'A'
} else {
    'B'
}

# 1.2 ifelse
# - 조건문(oracle의 decode함수와 비슷)
# - 벡터 연산 가능
# - 리턴만 가능, 프로그래밍 처리 불가
# 
# 1) Grammar
ifelse (test,    # boolean_expression
        yes,     # statement when TRUE
        no)      # statement when FALSE (생략 불가)

v1 <- c(1, 11, 20)
ifelse(v1 > 10, 'A', 'B')
# ------------------------------------------------------------------------------

# [ 중급 2. 반복문 ]
# 2.1 for
# 1) Grammar
# for (반복변수 in 반복대상) {
#     반복 수행할 문장
# }

v1 <- c(1, 2, 4, 5)
v1 + 10

for (i in v1) {
    print(v1 + 10)
}
# => 똑같은 값만 반복됨

# 위 결과 순서대로
# step1) i = 1
print(v1 + 10)    # 11 12 14 15

# step2) i = 2
print(v1 + 10)    # 11 12 14 15

# step3) i = 4
print(v1 + 10)    # 11 12 14 15

# step4) i = 5
print(v1 + 10)    # 11 12 14 15

# 똑같은 값만 반복되는 문제 해결
for (i in v1) {
    print(i + 10)
}

# if + for문의 결합
# if문은 조건의 결과가 하나여야 하므로
# for문을 통해 하나씩 전달, 반복연산 되도록 처리 필요

# 예제) emp 데이터에서 dname 컬럼 추가                                          # *
# 10번 부서는 인사부, 20번은 재무부, 30번은 총무부 (if + for문)

emp$dname2 <-
    for (i in emp$DEPTNO) {
        if (i == 10) {
            print('인사부')
        } else if (i == 20) {
            print('재무부')
        } else {
            print('총무부')
        }
    }
# NULL => for문 내 print를 쓴 순간 벡터 아님 => 컬럼에 추가할 수 없음

vdname <- c()    # 빈 그릇 생성
for (i in emp$DEPTNO) {    # deptno의 순서대로 vdname에 넣음
    if (i == 10) {
        vdname <- c(vdname, '인사부')
    } else if (i == 20) {
        vdname <- c(vdname, '재무부')
    } else {
        vdname <- c(vdname, '총무부')
    }
}
emp$dname2 <- vdname

# 2.2 while 
# for문 => 반복대상이 자동으로 다음으로 넘어감
# for (변수 in 반복대상) {
#     반복할 문장
# }
# 1) While
# - 반복 횟수가 정해져 있지 않음 (조건이 거짓이 될때까지 무한 반복)
# - 반복대상이 자동으로 넘어가지 않으므로 넘기는 작업 수행 필요
# - 초기값의 선언 필요

# 2) Grammar
# while (조건) {
#     반복할 문장
# }

# 예제) 1부터 10까지의 숫자에 10을 더해 출력
i <- 1
while ( i <= 10 ) {
    print(i + 10)
    i <- i + 1
}

# 2.3 반복 제어문 : 반복문의 흐름을 제어하는 구문                               # *
# 1) next : 반복문 내 next 뒤에 실행되는 문장스킵 (continue in Python)
for (i in 1:10) {           # 수행 횟수
    cmd1                    # 10
    if (i == 5) {           # i = 5일때 cmd2, cmd3가 스킵 됨
        next
    }
    cmd2                    # 9
    cmd3                    # 9
}
cmd4                        # 1

# 2) break : 반복문 즉시 종료
for (i in 1:10) {
    cmd1                    # 5
    if (i == 5) {
        break
    }
    cmd2                    # 4
}
cmd3                        # 1

#  quit : 프로그램 즉시 종료
for (i in 1:10) {
    cmd1                    # 5
    if (i == 5) {
        quit('no')
    }
    cmd2                    # 4
}
cmd3                        # 0

# 예제) 1 ~ 100 중 짝수의 합 출력 (for문 사용, 반복제어문 사용)
vsum <- 0
for (i in 1:10) {
    if (i %% 2 != 0) {
        next
    }
    vsum <- vsum + i
}
# ------------------------------------------------------------------------------

# [ 중급 3. 사용자 정의함수 ]
# 3.1 사용자 정의 함수 => 사용자가 직접 만드는 함수                              # *
# Y = f(x, y, z)

# Grammar
함수명 <- function(...) {
    cmd1
    cmd2
    ...
    return(object)
}

# 예제) input값의 10을 더한 값 리턴하는 함수 생성
f_add1 <- function(x) {
    return(x + 10)
}
f_add1(10)

# 예제) 세개 수를 전달 받아 (x + y) * z 형태의 값 리턴하는 함수 생성
f_add2 <- function(x, y, z) {
    vresult <- (x + y) * z
    return(vresult)
}

f_add2(5, 4, 10)
f_add2(y = 4, z = 10, x = 5)
f_add2(5, 4)

v1 <- c(1, 2, 3)
v2 <- c(10, 20, 30)
v3 <- c(2, 4, 6)

f_add2(v1, v2, v3)

# 예제) sign 함수 만들기
# f_sign(10) -> 1
v1 <- 10
if (v1 > 0) {
    1
} else if (v1 < 0) {
    -1
} else {
    0
}

# Answer 1
f_sign <- function(x) {
    if (x > 0) {
        vresult <- 1
    } else if (x < 0) {
        vresult <- -1
    } else {
        vresult <- 0
    }
    return(vresult)
}

f_sign(0)                     # x가 스칼라인 경우 working
f_sign(c(0, 500, -5, 2, 9))   # x가 벡터인 경우 not working => 반복 수행 불가

# 3.2 self call(재귀함수) => 함수가 자기를 호출                                  # *
f1 <- function(x) {
    f1(x - 1) + x
}
# f1(10) = f1(9) + 10
#        = f1(8) + 9 + 10
#        = f1(7) + 8 + 9 + 10    => 무한 반복 => stop point 필요, f1(1) = 1

# stop point 지정
f1 <- function(x) {
    if(x == 1) {
        1
    } else {
        f1(x - 1) +  x
    }
}
f1(10)

# 3.3 가변형 길이 인자를 갖는 사용자 정의 함수                                   # *
f1 <- function(...) {
    var1 <- list(...)       # c()로 묶어서 전달받아도 상관없음
    for (i in var1) {
        반복문장
    }
}

# 예제) 입력된 수의 총합을 출력하는 사용자 정의함수 생성
# fsum(2, 6, 8, 43)
fsum <- function(...) {
    vsum <- c(...)
    vhap <- 0
    for (i in vsum) {
        vhap <- vhap + i
    }
    return(vhap)
}

fsum(2, 6, 8, 43)
# ------------------------------------------------------------------------------

# [ 중급 4. 파일 입출력 ]
# 4.1 read.csv : csv (컴마로 분리구분된) 파일을 불러오는 함수
# 1) header = T : 첫 줄을 컬럼화 시킬지 여부
read.csv('read_test.csv', header = T)       # read.csv는 T가 default
read.table('read_test.csv', header = F)     # read.table은 F가 dafault

# 2) sep = "" : 각 파일의 분리 구분 기호
read.csv('read_test.csv', sep = ',')            # sep = ','
read.table('read_test.csv', sep = ',')          # sep = ','

read.csv('test1.txt', sep = ':', header = F)
read.csv('test1.txt', sep = ':')          
# Error(아래) => 파일의 엔드라인이 정확히 안되어 있음 -> 파일 내부에서 엔터 치고 저장
# In read.table(file = file, header = header, sep = sep, quote = quote,  :
#                   incomplete final line found by readTableHeader on 'test1.txt'

# 3) row.names : 불러올 때 각 행의 이름 부여
# 4) col.names : 불러올 때 각 컬럼 이름 부여
read.csv('test1.txt', sep = ':', header = F,
         col.names = c('name', 'deptno', 'sal'))   

# 5) na.strings = "NA" : NA로 처리할 문자열
df1 <- read.csv('read_test.csv', na.strings = c('.', '-', '?', '!', 'null'))
str(df1)

# 6) nrows = -1 : 불러올 행의 수
read.csv('emp.csv', nrows = -1)

# 7) skip = 0 : 스킵할 행의 개수
read.csv('emp.csv', skip = 1, header = F)

# 8) stringsAsFactors = T : 문자 컬럼의 팩터화 여부
# 9) encoding = "unknown" : 인코딩 옵션
read.csv('emp.csv', encoding = 'cp949')

# 4.2 write.csv(x,           # 저장할 객체 이름
#              file = ,       # 저장할 외부 파일명
#              sep = )        # 저장 시 분리 구분기호

df2 <- data.frame(col1 = c('a', 'b'),
                  col2 = c(1, 5))
write.csv(df2, 'df2_write_test.csv')

# 4.3 scan
# - 외부 파일을 "벡터"로 불러오기
# - 파일명 생략 시 사용자에게 값 입력 대기
# - 기본이 숫자 로딩, 문자 로딩 시 what = '' 필요
scan()                          # 숫자 연속 입력, 엔터 입력될 때까지
scan('file1.txt', sep = ',')    # 문자 연속 입력, 엔터 입력될 때까지

scan('file1.txt', sep = ',')            # 숫자 로딩
scan('file1.txt', sep = ',', what = '') # 문자 로딩

# 4.4 readLines
# - 외부 파일을 벡터로 불러오기
# - 각 라인을 벡터의 원소로 불러옴
readLines('file1.txt')

# 4.5 readLine
# - 사용자에게 입력 대기
# - 불러온 값은 문자형으로 저장
ans1 <- readline('정말 삭제할건가요? (Y|N) :')

if (ans1 =='Y') {
    '파일 삭제'
} else {
    print('파일을 삭제하지 않겠습니다.')
}

# -------
print('두 수를 입력받아 곱하는 프로그램')

no1 <- as.numeric(readline('첫번째 숫자를 입력하세요 : '))
no2 <- as.numeric(readline('두번째 숫자를 입력하세요 : '))

no1 * no2

# 4.6 바이너리 입출력
# - 현재까지 작업 환경(변수,함수)에 대한 저장 시
# - 사용자 정의 함수의 저장 용이

v1 <- 1 ; v2 <- 2 ; v3 <- 3

f1 <- function(x) {
    x + 1
}

save(...,      # 입력 대상 나열
     list = ,  # 입력 대상 벡터로 전달
     file = )  # 저장할 파일명

load(file = )  # 불러올 파일명

save(list = ls(), file = 'vlist')
rm(list=ls())
v1             # Error => 출력 불가
load('vlist')
v1             # 출력 가능
f1(10)         # 함수 사용 가능

# 4.7 데이터베이스 입출력(oracle)
# 1) 준비사항
# - 접속할 DB의 정보 : ip, port, db name, username, passwd
# ip : 192.168.0.115
# port : 1521
# db name : orcl
# username : scott
# passwd : oracle

# [ 참고 9 : oracle service port/ db name 확인 방법 ]
# C:\Users\KITCOOP> lsnrctl status

# - DB내의 통신 대상 : ojdbc6.jar(64bit)
# - R내의 통신 대상 : RJDBC(64bit)

# [ 참고 10 : oracle 설치 종류 ]
# oracle
# - server : instance(memory) + DB(disk)
# - client : instance(memory)

# 2) R의 패키지 설치 : RJDBC
install.packages('RJDBC')
library(RJDBC)

# 3) oracle 설치(client) : ojdbc6.jar 파일 생성

# 4) connection 생성
jdbcDriver <- JDBC(driverClass = "oracle.jdbc.OracleDriver",
                   classPath = 'C:/app/KITCOOP/product/11.2.0/client_1/ojdbc6.jar')

# My way
jdbc_driver = JDBC("oracle.jdbc.OracleDriver", classPath = "/Users/harryjeong/Downloads/ojdbc8.jar")
con = dbConnect(jdbc_driver, "jdbc:oracle:thin:@localhost:1521/xe",
                "scott",
                "tiger")

# Win's way
con1 <- dbConnect(jdbcDriver,
                  "jdbc:oracle:thin:@ip:port:db_name",
                  username,
                  passwd)

con1 <- dbConnect(jdbcDriver,
                  "jdbc:oracle:thin:@192.168.0.115:1521:orcl",
                  "scott",
                  "oracle")

# 5) 쿼리 수행
dbGetQuery(conn = ,       # 연결이름
           statement = )  # 실행 쿼리

df1 <- dbGetQuery(conn = con,       # 연결이름
                  statement = 'select * from emp')  # 실행 쿼리
class(df1)
# ------------------------------------------------------------------------------
reviewed 1, 2020-09-13
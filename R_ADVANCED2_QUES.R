# [ join ]
# -------------------------------연 습 문 제------------------------------------
# 연습문제 30. emp.csv 파일을 읽고, 각 직원의 상위관리자 이름 출력
#              단, 상위관리자가 없는 경우는 본인 이름으로 치환
emp1 <- read.csv('emp.csv')
emp2 <- read.csv('emp.csv')
merge(emp1, emp2, by.x = 'MGR', by.y = 'EMPNO')
df1 <- merge(emp1, emp2, by = 'EMPNO', by.x = 'MGR', by.y = 'EMPNO', all.x = T)[ , c('ENAME.x', 'ENAME.y')]
# way 1)
df1[is.na(df1$ENAME.y), ] <- df1$ENAME.x[is.na(df1$ENAME.y)]

# way 2)
str_replace_na(df1$ENAME.y, '홍길동')
str_replace_na(df1$ENAME.y, df1$ENAME.x)                # 치환 불가
ifelse(is.na(df1$ENAME.y), df1$ENAME.x, df1$ENAME.y)    # 치환 가능

# 연습문제 31. gogak.csv, gift.csv 파일을 읽고,
#              각 직원의 수령상품을 출력(조인은 R문법으로)
# 아래처럼 사용자 정의함수로 만들어두면 좋음
get_query(sql = 'select ...', ip = localhost, port = , sid = , user = , pwd = )
# localhost => 본인의 ip

# Answer 1 => for문을 사용한 처리
gift <- read.csv('gift.csv')
gogak <- read.csv('gogak.csv')

gift[(gift$G_START <= 980000) & (980000 <= gift$G_END), 'GNAME']
gift[(gift$G_START <= 73000) & (73000 <= gift$G_END), 'GNAME']
gift[(gift$G_START <= 320000) & (320000 <= gift$G_END), 'GNAME']

vgift <- c()
for (i in gogak$POINT) {
  vgift <- c(vgift, gift[(gift$G_START <= i) & (i <= gift$G_END), 'GNAME'])
}

gogak$GIFT <- vgift

# Answer 2 => 사용자 정의함수 + 적용함수
f_gift <- function(x) {
  gift[(gift$G_START <= x) & (x <= gift$G_END), 'GNAME']
}
gogak$GIFT2 <- sapply(gogak$POINT, f_gift)
# ------------------------------------------------------------------------------
# [ 그룹연산 ]
# -------------------------------연 습 문 제------------------------------------
# 연습문제 32. student.csv 파일과 exam_01.csv 파일을 읽고,
std
exam <- read.csv('exam_01.csv')

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
# 1) 각 학년별 시험성적의 평균을 구하세요.
stdexam <- merge(std, exam, by = 'STUDNO')[ , c('STUDNO', 'NAME', 'GRADE', 'TOTAL')]
# way 1)
aggregate(stdexam$TOTAL, list(stdexam$GRADE), mean, na.rm = T)
# way 2)
aggregate(TOTAL ~ GRADE, stdexam, mean, na.rm = T)

# 2) 각 학년별 최고성적을 갖는 학생 이름, 성적, 학년 출력
# Answer 
std_max <- aggregate(TOTAL ~ GRADE, stdexam, max, na.rm = T)    # 왜 오류..?
merge(stdexam, std_max, by = c('GRADE', 'TOTAL'))

# Wrong => 개선해서 다시 풀어보기
grade_max <- aggregate(stdexam$TOTAL, list(stdexam$GRADE), max, na.rm = T)

df1 <- data.frame()
for (i in 1:4) {
  df1 <- c(df1, stdexam[(stdexam$GRADE == grade_max[i, 1] & stdexam$TOTAL == grade_max[i, 2]), c('NAME', 'TOTAL', 'GRADE')])
}
stdexam[(stdexam$GRADE == grade_max[1, 1] & stdexam$TOTAL == grade_max[1, 2]), c('NAME', 'TOTAL', 'GRADE')]
stdexam[(stdexam$GRADE == grade_max[2, 1] & stdexam$TOTAL == grade_max[2, 2]), c('NAME', 'TOTAL', 'GRADE')]
stdexam[(stdexam$GRADE == grade_max[3, 1] & stdexam$TOTAL == grade_max[3, 2]), c('NAME', 'TOTAL', 'GRADE')]
# ------------------------------------------------------------------------------

# [ join, 그룹연산 ]
# --------------------------------실 습 문 제-----------------------------------
# 실습문제 9
# 9.1 movie_ex1.csv 파일을 읽고,
movie <- read.csv('movie_ex1.csv', fileEncoding = 'euc-kr')
# 1) 연령대별 성별 이용비율의 평균을 구하라.
aggregate(movie$이용_비율... , list(movie$연령대, movie$성별), mean)
aggregate(이용_비율... ~ 연령대 + 성별, movie, mean)

# 2) 요일별 이용비율의 평균을 구하라.
# 날짜를 인식하려면 1) 분리구분기호 2) 글자수 맞추기 (by. sprintf 함수)
# 1)
library(stringr)
mdate <- as.Date(str_c(movie$년, '/', movie$월, '/', movie$일), '%Y/%m/%d')  # 1)
movie$요일 <- as.character(mdate, '%A')
aggregate(이용_비율... ~ 요일, movie, mean)
# 행 정렬 안됨 => 행 순서 정해줌
aggregate(이용_비율... ~ 요일, movie, mean)[c(2, 6, 7, 5, 1 ,3, 4), ]

# 2) 2자리 월, 일 형식으로 가공
vdate <- str_c(movie$년, sprintf('%02d', movie$월), sprintf('%02d', movie$일)) 
as.Date(vdate, '%Y%m%d')

# 9.2 delivery.csv 파일을 읽고,
deli <- read.csv('delivery.csv', fileEncoding = 'euc-kr')
# 1) 일자별 총 통화건수를 구하라.
aggregate(통화건수 ~ 일자, deli, sum)
tapply(deli$통화건수, deli$일자, sum)

# 2) 음식점별 주문수가 가장 많은 시간대를 출력
# 선순위 데이터
# 중국음식 시간대 통화건수
#          1 6
#          2 10
#          3 30
#          ...
#          24 30
# step 1) 업종별 시간대별 통화건수 총합
deli_1 <- aggregate(통화건수 ~ 시간대 + 업종, deli, sum)
# step 2) 
deli_max <- aggregate(통화건수 ~ 업종, deli_1, max)
# step 3)
merge(deli_1, deli_max, by = c('업종', '통화건수'))

# 3) 일자별 전일대비 증감률을 구하라. (위치기반 사용자 정의함수 활용)
# Answer 1
deli_2 <- aggregate(통화건수 ~ 일자, deli, sum)
# 20180201 39653 39653
# 20180202 46081 39653
# 20180202 54124 46081
# 
# (46081 - 39653) / 39653 * 100

# step 1) 이전 행 값을 가져오는 사용자 정의함수 생성
# way 1)
f_shift <- function(x) {
  vshift <- c()
  for (i in 1:length(x)) {
    if (i == 1) {
      vshift <- c(vshift, x[1])
    } else {
      vshift <- c(vshift, x[i - 1])
    }
  }
  return(vshift)
}

# way 2) shorter
f_shift <- function(x) {
  vshift <- c()
  for (i in 1:length(x)) {
    vshift <- c(vshift, x[max(i - 1, 1)])
  }
  return(vshift)
}

# [ 참고 - 외부 패키지 사용 ]
install.packages('data.table')    # package down error
library(data)
sessionInfo()

v1 <- 1:10
shift(v1, n = 1, type = 'lag')              # NA 1 2 3 4 5 6 7 8 9
shift(v1, n = 1, fill = 0, type = 'lag')    # 0 1 2 3 4 5 6 7 8 9
shift(v1, n = 1, type = 'lead')             # 2 3 4 5 6 7 8 9 10 NA

# step 2) 전일자 통일건수 컬럼 생성
deli_2$before <- f_shift(deli_2$통화건수)

# step 3) 전일자 대비 증감률 계산
# (46081 - 39653) / 39653 * 100
deli_2$rate <- (deli_2$통화건수 - deli_2$before) / deli_2$before * 100

# Answer 2 => 다시 풀어보기
v1 <- aggregate(통화건수 ~ 일자 + 업종, deli, sum)

incr <- c()
incr <- c(incr, 0)
for (i in 2:nrow(v1) - 1) {
  if (v1$업종[i] == '음식점-족발/보쌈전문') {
    incr <- c(incr, (v1[i, 3] - v1[i - 1, 3]) / v1[i, 3] * 100)
  } else if (v1$업종[i] == '음식점-중국음식') {
    incr <- c(incr, (v1[i + 1, 3] - v1[i, 3]) / v1[i + 1, 3] * 100)
  } else if (v1$업종[i] == '치킨') {
    incr <- c(incr, (v1[i + 1, 3] - v1[i, 3]) / v1[i + 1, 3] * 100)
  } else {
    incr <- c(incr, (v1[i + 1, 3] - v1[i, 3]) / v1[i + 1, 3] * 100)
  }
}
incr <- c(incr, 0)
v1$증감률 <- incr

# 9.3 get_query 사용자 정의함수 생성 **
get_query <- function(sql, ip = 'localhost', port = '1521',
                      sid = 'xe', user = 'scott', pwd = 'tiger') {
  library(RJDBC)
  library(stringr)
  jdbc_driver = JDBC("oracle.jdbc.OracleDriver", classPath = "/Users/harryjeong/Downloads/ojdbc8.jar")
  vaddr <- str_c('jdbc:oracle:thin:@', ip, ':', port, '/', sid)
  con = dbConnect(jdbc_driver,
                  vaddr,
                  user,
                  pwd)
  df1 < - dbGetQuery(conn = con,
                     statement = sql)
  return(df1)
}
save(get_query, file = 'my_function')
get_query('select * from emp')

save(list = ls(), file = 'my_function')
# localhost => 본인의 ip

library(RJDBC)
get_query <- function(sql, user, pwd) {
  jdbc_driver = JDBC("oracle.jdbc.OracleDriver", classPath = "/Users/harryjeong/Downloads/ojdbc8.jar")
  con = dbConnect(jdbc_driver, "jdbc:oracle:thin:@//localhost:1521/xe",
                  "scott",
                  "tiger")
  df1 < - dbGetQuery(conn = con,
                     statement = sql)
}

get_query('select * from emp', 'scott', 'tiger')
# ------------------------------------------------------------------------------
# -------------------------------연 습 문 제------------------------------------
# 연습문제 40. data.csv 파일에서 연도별 총구직자수의 변화추이 선그래프 출력
# (각 연도별로 월별 구직자수의 변화를 확인할 수 있는 ...)
df1 <- read.csv('data.csv', fileEncoding = 'EUC-KR')
head(df1)
# Answer 1 => 교차테이블로 수정 후 진행
library(reshape2)
total <- dcast(df1, 월 ~ 년도)
dev.new()
plot(total$`2014`, type = 'o', col = 1, ylim = c(1000, 10000),
     ann = F, axes = F)
lines(total$`2015`, type = 'o', col = 2)
lines(total$`2016`, type = 'o', col = 3)
lines(total$`2017`, type = 'o', col = 4)
lines(total$`2018`, type = 'o', col = 5)

library(stringr)
axis(1, at = 1:12, labels = str_c(total$월, '월'), family = 'AppleGothic')
axis(2, ylim = c(1000, 10000))

title(main = '연도별 월별 구직자수 변화', col.main = 4, cex.main = 2,
      xlab = '월', cex.lab = 1.3,
      ylab = '구직자수', font.lab = 2,
      family = 'AppleGothic')

legend(10, 4000, colnames(total)[-1], col = 1:5, lty = 1)

# [ 참고 19 : plot 도표에 특정 행 하나 전달 시 ]
# - 데이터프레임에서 특정 행 하나 선택은 데이터프레임 출력
# - plot에 데이터프레임 입력 => 교차 산점도 출력
# - 행렬 전치 혹은 unlist로 벡터 만든 후 plot에 전달 필요
total2 <- dcast(df1, 년도 ~ 월)
dev.new()
plot(total2[1, -1])          
total2[1, -1]                # 데이터프레임 출력
as.vector(total2[1, -1])     # key구조 유지, 데이터프레임 출력
unlist(total2[1, -1])        # key구조 해제, 벡터 출력

dev.new()
plot(unlist(total2[1, -1]), type = 'o')

# Anwer 2 => 그냥 컬럼 뽑아서 진행
dev.new()
plot(df1$월[df1$년도 == 2014], df1$총구직자수[df1$년도 == 2014], 
     type = 'l', col = 1,
     xlab = '월', ylab = '총구직자수', family = 'AppleGothic',
     xlim = c(1, 12), ylim = c(0, 15000))
lines(df1$월[df1$년도 == 2015], df1$총구직자수[df1$년도 == 2015], 
      type = 'l', col = 2)
lines(df1$월[df1$년도 == 2016], df1$총구직자수[df1$년도 == 2016], 
      type = 'l', col = 3)
lines(df1$월[df1$년도 == 2017], df1$총구직자수[df1$년도 == 2017], 
      type = 'l', col = 4)
lines(df1$월[df1$년도 == 2018], df1$총구직자수[df1$년도 == 2018], 
      type = 'l', col = 5)

title(main = '연도별 총구직자수 변화추이', family = 'AppleGothic')
legend(x = 1,
       y = 15000,
       legend = 2014:2018,
       col = 2:6,
       lty = 1)

# 연습문제 41. subway2.csv 파일의 데이터를 기반으로 승차가 가장 많은 top 5개의
#              역을 구하고 각 역의 시간대별 승차의 증감추세를 도표화
# Answer 1
sub <- read.csv('subway2.csv', fileEncoding = 'EUC-KR', skip = 1)
head(sub)

# step 1) 승차 데이터 선택
sub2 <- sub[sub$구분 == '승차', -2]

# step 2) 역이름을 로우이름으로 설정
rownames(sub2) <- sub2$전체
sub2$전체 <- NULL    # sub2 <- sub2[ , -1] (특정 컬럼(KEY) 삭제)

# step 3) 역별 승차 총합
str(sub2)
vsum <- apply(sub2, 1, sum)

# step 4) 승차의 총합으로 정렬
sort(vsum, decreasing = T)[1:5]
vname <- names(sort(vsum, decreasing = T)[1:5])

# step 5) top5 역에 대한 시간별 승차 수 추출 후 전치
total <- sub2[rownames(sub2) %in% vname, ]
total <- t(sub2[rownames(sub2) %in% vname, ])

# step 6) 그래프 그리기
dev.new()
rownames(total) <- as.numeric(str_sub(rownames(total), 2, 3))

plot(total[ , 1], type = 'o', col = 1, ylim = c(1000, 380000))
# 단위 줄이기
plot(total[ , 1] / 1000, type = 'o', col = 1, ylim = c(1, 380),
     ann = F, axes = F, family = 'AppleGothic')
lines(total[ , 2] / 1000, type = 'o', col = 2)
lines(total[ , 3] / 1000, type = 'o', col = 3)
lines(total[ , 4] / 1000, type = 'o', col = 4)
lines(total[ , 5] / 1000, type = 'o', col = 5)

axis(1, at = 1:nrow(total), labels = rownames(total))
axis(2, ylim = c(1, 380))

title(main = '시간대별 승차 변화량',
      xlab = '시간대',
      ylab = '승차 수 / (천)', family = 'AppleGothic')
par(family = "AppleGothic")
legend(18, 400, colnames(total), col = 1:5, lty = 1)

# Answer 2
df2 <- read.csv('subway2.csv', fileEncoding = 'EUC-KR')
head(df2)
df2_2 <- df2[df2$X == '승차', ]
df2_2 <- df2_2[ , -2]
colnames(df2_2) <- df2[1, ][-1]
df2_3 <- dcast(df2_2, '' ~ 구분)
# 1) 
df2_2$TOTAL <- apply(df2_2[ , -1], 1, sum)
library(dplyr)
df2_2 %>%
  select(구분, TOTAL) %>%
  arrange(desc(TOTAL))

# 2) 
df2_2[ , -1] <- apply(df2_2[ , -1], c(1, 2), as.numeric)
dev.new()
plot(df2_2$`05~06`, df2_2$구분, type = 'l', ylim = c(0, 40000))
min(df2_2[ , -1])
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 42. 상반기사원별월별실적현황_new.csv을 읽고,
# 월별 각 직원의 성취도를 비교하기 위한 막대그래프 출력
# Answer 1
df1 <- read.csv('상반기사원별월별실적현황_new.csv', fileEncoding = 'EUC-KR')
df2 <- dcast(df1, 이름 ~ 월)
rownames(df2) <- df2$이름
df2$이름 <- NULL

dev.new()
par(family = "AppleGothic")
barplot(as.matrix(df2), beside = T, col = rainbow(nrow(df2)),
        ylim = c(0, 1.5),
        angle = 45,        # 막대의 빗금 각도
        density = 80,      # 막대의 빗금 농도
        names.arg = str_c(1:6, '월'),  # 막대그래프 눈금 이름 변경
        legend = rownames(df2),        # 막대그래프 범례 표시
        args.legend = list(cex = 1, x = 'topleft'))  # 막대그래프 범례 표시

# Answer 2
df3 <- read.csv('상반기사원별월별실적현황_new.csv', fileEncoding = 'EUC-KR')
ddply(df3, )
head(df3)

df3_1 <- dcast(df3, 월 ~ 이름, value.var = '성취도')
rownames(df3_1) <- df3_1[ , 1]
df3_1 <- df3_1[ , ]

dev.new()
barplot(as.matrix(t(df3_1)), beside = T, col = 1:6, ylim = c(0, 1.5))
par(family = "AppleGothic")
legend(1, 1.5, colnames(df3_1), fill = rainbow(6))
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 43. 영화이용현황.csv 파일을 읽고,
# 지역.시도별 성별 이용비율의 평균을 비교하기 위한 막대그래프 출력
# 80이상일 때 빨강, 50 ~ 80 노랑, 50미만 녹색으로 출력
# Answer 1
df1 <- read.csv('영화이용현황.csv', fileEncoding = 'EUC-KR')
head(df1)

library(reshape2)
total <- dcast(df1, 성별 ~ 지역.시도, sum)
rownames(total) <- total$성별
total$성별 <- NULL

dev.new()
barplot(as.matrix(total), beside = T, col = rainbow(2),
        legened = rownames(total))

# Answer 2
df5 <- read.csv('영화이용현황.csv', fileEncoding = 'EUC-KR')
head(df5)
df5_1 <- dcast(df5, 성별 ~ 지역.시도, mean, value.var = '이용_비율...')
rownames(df5_1) <- df5_1[ , 1]
df5_2 <- df5_1[ , -1]

dev.new()
par(family = "AppleGothic")
barplot(as.matrix(df5_2), beside = T,
        col = vcol,
        ylim = c(0, 0.004),
        ylab = '이용비율',
        legend = rownames(df5_2),
        args.legend = list(cex = 1, x = 'topright'),
        family = "AppleGothic"
)

vcol <- c()
for (i in rownames(df5_2)) {
  if (i == '남') {
    vcol <- c(vcol, 'blue')
  } else {
    vcol <- c(vcol, 'red')
  }
}
# ------------------------------------------------------------------------------

# --------------------------------실 습 문 제-----------------------------------
# 실습문제 11                   
# 11.1 kimchi_test.csv 파일을 읽고,                                             # * 수량, 금액 숫자 체크
# 1) 각 (연도별 제품별) 판매량과 판매금액의 평균을 구하고,
#    연도별 각 제품의 판매량의 증가추이를 plot 그래프로 표현
# Answer 1
kimchi <- read.csv('kimchi_test.csv', fileEncoding = 'EUC-KR')
head(kimchi)
# 판매량, 판매금액 크로스테이블 각각 만들기
kimchi2 <- ddply(kimchi, .(판매년도, 제품), summarise, v1 = mean(수량),
                 v2 = mean(판매금액))

kimchi3 <- dcast(kimchi, 판매년도 ~ 제품, sum, value.var = '수량')

plot(kimchi3$무김치/10000, type = 'o', col = 2, ylim = c(40, 80), ann = F, axe = F)
lines(kimchi3$열무김치/10000, type = 'o', col = 3)
lines(kimchi3$총각김치/10000, type = 'o', col = 4)
axis(1, at = 1:nrow(kimchi3), kimchi3$판매년도)
axis(2, ylim = c(40, 80))
title(main = '김치별 판매량 증감추이',
      xlab = '판매년도',
      ylab = '판매량(만)')

legend(1, 80, colnames(kimchi3)[-1], lty = 1, col = 2:4)

# Answer 2
df1 <- read.csv('kimchi_test.csv', fileEncoding = 'EUC-KR')
head(df1)

library(dplyr)
df1_1 <- df1 %>%
  select(판매년도, 제품, 수량, 판매금액) %>%
  group_by(판매년도, 제품) %>%
  summarize_each(mean, c(수량, 판매금액))

df1_2 <- dcast(df1_1, 제품 ~ 판매년도, value.var = '수량')
rownames(df1_2) <- df1_2[ , 1]
df1_2 <- df1_2[ , -1]

dev.new()
plot(df1_2$`2013`, type = 'l', col = 1, ylim = c(10000, 25000),
     ann = F, axes = F)
lines(df1_2$`2014`, type = 'l', col = 2, ylim = c(10000, 25000))
lines(df1_2$`2015`, type = 'l', col = 3, ylim = c(10000, 25000))
lines(df1_2$`2016`, type = 'l', col = 4, ylim = c(10000, 25000))

axis(1, at = 1:3, labels = c(rownames(df1_2)), family = 'AppleGothic')
axis(2, ylim = c(10000, 25000))
title(main = '연도별 제품의 판매량 추이', col.main = 'blue', cex.main = 2,
      xlab = '제품',
      ylab = '판매량', family = 'AppleGothic')
legend(1, 25000, colnames(df1_2), fill = rainbow(4), lty = 1)

# 2) 각 연도별로 제품의 판매량을 비교할 수 있도록 막대그래프로 표현
# Answer 1
rownames(kimchi3) <- kimchi3$판매년도
kimchi3$판매년도 <- NULL

t(kimchi3)
dev.new()
barplot(as.matrix(t(kimchi3))/10000, beside = T, col = rainbow(3),
        ylim = c(0, 80), legend = colnames(kimchi3))

# Answer 2
par(family = "AppleGothic")
barplot(as.matrix(df1_2), beside = T,
        col = rainbow(3),
        ylim = c(0, 20000),
        ylab = '판매량',
        legend = rownames(df1_2),
        args.legend = list(x = 'topleft'),
        family = "AppleGothic"
)

# 11.2 병원현황.csv 파일을 읽고,
# 1) 병원수가 가장 많은 5개 과목에 대해 연도별 병원수 증감추이를 시각화
# Answer 1
df_data <- read.csv('병원현황.csv', fileEncoding = 'EUC-KR', skip = 1)
head(df_data)

df_data <- df_data[ , -c(3, 4)]    # 항목과 구분 제거

# 표시과목의 '계' 데이터의 분리
df_data_tt <- df_data[df_data$표시과목 == '계', -2]
df_data <- df_data[df_data$표시과목 != '계', ]

# step 1) 연도/분기 컬럼을 stack 처리 (long data로 바꿔주기)
df_data2 <- melt(df_data, id.vars = c('시군구명칭', '표시과목'), variable.name = '날짜',
                 value.name = '병원수')

# step 2) 연도와 분기 각각 분리 후 컬럼 생성
library(stringr)
df_data2$년도 <- as.numeric(str_sub(df_data2$날짜, 2, 5))
df_data2$분기 <- as.numeric(str_sub(df_data2$날짜, 8, 8))

# step 3) 표시과목별 병원수 총합
df_data3 <- ddply(df_data2, .(표시과목), summarise, cnt = sum(병원수))
str(df_data2)

vrn <- order(df_data3$cnt, decreasing = T)[1:5]
vname <- df_data3$표시과목[vrn]

# step 4) 선택된 5개 과목에 대한 데이터 추출
df_data4 <- df_data2[df_data2$표시과목 %in% vname, ]
df_data5 <- dcast(df_data4, 년도 ~ 표시과목, sum, value.var = '병원수')

# step 5) 시각화
dev.new()
plot(df_data5$내과, type = 'o', col = 2, ylim = c(2000, 8000),
     ann = F, axes = F)
lines(df_data5$소아청소년과, type = 'o', col = 3)
lines(df_data5$이비인후과, type = 'o', col = 4)
lines(df_data5$일반의, type = 'o', col = 5)
lines(df_data5$전문과목미표시전문의, type = 'o', col = 6)

axis(1, at = 1:5, df_data5$년도)
axis(2, ylim = c(1000, 6000))

legend(1, 8000, colnames(df_data5)[-1], col = 2:6, lty = 1)

# Answer 2
df2 <- read.csv('병원현황.csv', fileEncoding = 'EUC-KR', skip = 1)
head(df2_1)
df2_1 <- df2[ , -1]
df2_1 <- df2[!(df2_1$표시과목 == '계'), ]
colnames(df2_1)
df2_2 <- df2_1[ , -1]
df2_2 <- df2_2[ , -2]
df2_2 <- df2_2[ , -2]

df2_2[ , -1] <- apply(df2_2[ , -1], c(1, 2), as.numeric)
df2_2 %>%
  select(표시과목) %>%
  group_by(표시과목) %>%
  summarize_each(sum, c(df2_2[ , -1]))

# 2) 병원수가 가장 많은 5개 과목에 대해 분기별 각 과목의 병원수를 비교하는 
#    막대그래프 생성
# step 1) 선택된 5개 과목에 대한 데이터 추출
df_data4 <- df_data2[df_data2$표시과목 %in% vname, ]

# step 2) 선택된 5개 과목에 대한 분기별 데이터 정리
total <- dcast(df_data4, 표시과목 ~ 분기, sum, value.var = '병원수')
rownames(total) <- total$표시과목
total$표시과목 <- NULL

# step 3) 시각화
barplot(as.matrix(total), beside = T, col = rainbow(5),
        ylim = c(0, 10000), legend = rownames(total))
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 44. 영화이용현황.csv 파일을 읽고,
# 1) 20세미만, 20대, 30대, 40대, 50대, 60세이상 별 이용비율의 평균
# Answer 1
movie <- read.csv('영화이용현황.csv', fileEncoding = 'euc-kr')
head(movie)
v1 <- str_c(str_sub(movie$연령대, 1, 1), '0대')
v1 <- str_replace_all(v1, '10대', '20세미만')
v1 <- str_replace_all(v1, '60대', '60세이상')
v1 <- str_replace_all(v1, '70대', '60세이상')

movie2 <- ddply(movie, .(v1), summarize, vsum = sum(이용_비율...))[c(2, 1, 3:6), ]

barplot(movie2$vsum, col = 2:7,
        names.org = movie2$v1,
        angle = c(0, 90, 45, 10, 80), density = 30)

# Answer 2
df1 <- read.csv('영화이용현황.csv', fileEncoding = 'euc-kr')
head(df1)
for (i in 1:nrow(df1)) {
  if (df1$연령대[i] < 20) {
    df1$연령범위[i] <- '20세 미만'
  } else if (df1$연령대[i] < 30) {
    df1$연령범위[i] <- '20대'
  } else if (df1$연령대[i] < 40) {
    df1$연령범위[i] <- '30대'
  } else if (df1$연령대[i] < 50) {
    df1$연령범위[i] <- '40대'
  } else if (df1$연령대[i] < 60) {
    df1$연령범위[i] <- '50대'
  } else {
    df1$연령범위[i] <- '60대 이상'
  }
}
df1_1 <- ddply(df1, .(연령범위), summarize, v1 = sum(이용_비율...))

# 2) 각 지역.시도별 이용률이 가장 높은 연령대 출력
# Answer 1
movie3 <- ddply(movie, .(지역.시도, v1),
                summarise, vsum = sum(이용_비율...))
ddply(movie3, .(지역.시도), subset, vsum == max(vsum))

# Answer 2
df1_2 <- ddply(df1, .(지역.시도, 연령범위), summarize, v1 = sum(이용_비율...))
ddply(df1_2, .(지역.시도), subset, v1 == max(v1))

# 3) 동별 이용비율의 총합을 구한 뒤 히스토그램으로 출력
df1_3 <- ddply(df1, .(지역.읍면동), summarize, v1 = sum(이용_비율...))
hist(df1_3$v1)
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 45. 영화이용현황.csv 파일을 읽고,
# 각 시군구별 영화이용률이 가장 높은 상위 3개 시군구에 대해 각각 성별 이용비율을
# 비교할 수 있는 pie 차트 시각화
# Answer 1
movie2 <- read.csv('영화이용현황.csv', fileEncoding = 'euc-kr')
head(movie2)
library(plyr)
movie2 <- ddply(movie, .(지역.시군구),
                summarize, v1 = sum(이용_비율...))

library(doBy)
vname <- doBy::orderBy( ~ -v1, movie2)[1:3, 1]

movie3 <- movie[movie$지역.시군구 %in% vname, ]
total <- dcast(movie3, 성별 ~ 지역.시군구, sum)

dev.new()
par(mfrow = c(1, 3))

pie3D(total$강남구, col = c(2, 4), explode = 0.1, main = '강남구',
      cex.main = 3)
pie3D(total$강남구, col = c(2, 4), explode = 0.1, main = '서구',
      cex.main = 3)
pie3D(total$강남구, col = c(2, 4), explode = 0.1, main = '중구',
      cex.main = 3)

# 각 구내 성별 비율 출력
f1 <- function(x) {
  round(x / sum(x) * 100, 2)
}
vrate <- as.data.frame(apply(total[ , -1], 2, f1))

# 시각화
pie3D(total$강남구, col = c(2, 4), explode = 0.1, main = '강남구',
      cex.main = 3, labels = str_c(vrate$강남구, '%'))
pie3D(total$강남구, col = c(2, 4), explode = 0.1, main = '서구',
      cex.main = 3, labels = str_c(vrate$서구, '%'))
pie3D(total$강남구, col = c(2, 4), explode = 0.1, main = '중구',
      cex.main = 3, labels = str_c(vrate$중구, '%'))

legend(0.5, 1, total$성별, fill = c(2, 4), cex = 1.2)

# Answer 2
movie <- read.csv('영화이용현황.csv', fileEncoding = 'euc-kr')
head(movie)
movie1 <- ddply(movie, .(지역.시군구), summarize, vsum = sum(이용_비율...))
vrn <- order(movie1$vsum, decreasing = T)[1:3]
vname <- movie1$지역.시군구[vrn]

movie2 <- movie[movie$지역.시군구 %in% vname, ]
movie2_1 <- ddply(movie2, .(지역.시군구, 성별), summarise, vsum = sum(이용_비율...))

dev.new()
par(mfrow = c(1, 3))
pie(movie2_1[movie2_1$지역.시군구 == vname[1], "vsum"],
    labels = c('MALE', 'FEMALE'), labelcol = 1,
    main = vname[1], family = 'AppleGothic')
pie(movie2_1[movie2_1$지역.시군구 == vname[2], "vsum"],
    labels = c('MALE', 'FEMALE'), labelcol = 2,
    main = vname[2], family = 'AppleGothic')
pie(movie2_1[movie2_1$지역.시군구 == vname[3], "vsum"],
    labels = c('MALE', 'FEMALE'), labelcol = 3,
    main = vname[3], family = 'AppleGothic')
# ------------------------------------------------------------------------------

# --------------------------------실 습 문 제-----------------------------------
# 실습문제 12
# 12.1 교습현황.csv 파일을 읽고,
# 1) 구별 교습과정의 총 금액을 막대그래프로 시각화
# Answer 1
df3 <- read.csv('교습현황.csv', fileEncoding = 'euc-kr', skip = 1)
head(df3)
df3 <- df3[ , -c(3, 4)]

# doBy : ~by (order, sort, sample) 상위
# plyr : apply 계열 함수(적용함수) 상위
# reshape2 : stack/unstack 상위
# dplyr : 구조화된 R 문법 제공(sql처럼)

install.packages('dplyr')
library(plyr) ; library(reshape2) ; library(stringr)
# step 1) 구 추출
str_extract_all(df3$교습소주소[1], '..구')
str_extract_all(df3$교습소주소[1], '[가-힣]{1, }구')
str_extract_all(df3$교습소주소[1], '[:alpha:]{1, }구')[[1]]

f1 <- function(x) {
  str_extract_all(x, '..구')[[1]][1]
}

class(sapply(df3$교습소주소, f1))
df3$구 <- sapply(df3$교습소주소, f1)

# step 2) 교습금액 컬럼 추출
df4 <- df3[ , str_detect(colnames(df3), '^X')]

# step 3) 학원별 총 교습금액 계산 (행별 합)
f_num <- function(x) {
  as.numeric(str_remove_all(x, ','))
}
df4[ , ] <- apply(df4, c(1, 2), f_num)

df3$total <- apply(df4, 1, sum)

# step 4) 구별, 교습과정별 교습금액 합 계산
str_remove_all('실용외국어(유아/초.중.고)', '\\(.{1,}\\)')

df3$교습과정 <- str_remove_all(df3$교습과정, '\\(.{1,}\\)')

dcast(df3, 교습과정 ~ 구, sum, value.var = 'total')  # 로봇 무용 / 동작구는 0임
ddply(df3, .(구, 교습과정), summarize, vsum = sum(total)) # 0은 안나옴

df3_total <- dcast(df3, 교습과정 ~ 구, sum, value.var = 'total')

# step 5) 시각화
dev.new()
barplot(as.matrix(df3_total[ , -1])/1000000, beside = T, ylim = c(0, 60000),
        col = rainbow(nrow(df3_total)))
legend(1, 60000, df3_total$교습과정, fill = 1:nrow(df3_total))

# Answer 2
df1 <- read.csv('교습현황.csv', fileEncoding = 'euc-kr', skip = 1)
head(df1)

library(reshape2)
df1_1 <- melt(df1, id.vars = c('교습소명', '교습소주소', '분야구분', '교습계열', '교습과정'),
              variable.name = '날짜', value.name = '매출액')
head(df1_1)
library(stringr)
df1_1$주소.구 <- str_sub(df1_1$교습소주소, 7, str_locate(df1_1$교습소주소, '구')[ , 2])

df1_1$매출액 <- str_trim(df1_1$매출액, 'both')
df1_1$매출액 <- str_replace_all(df1_1$매출액, ',', '')
df1_1$매출액 <- as.numeric(df1_1$매출액)
library(plyr)
df1_2 <- ddply(df1_1, .(주소.구), summarize, v1 = sum(매출액))

barplot(df1_2$v1 / 100000000, beside = T, ylim = c(0, 1500), col = c(1, 2),
        xlab = 'District', ylab = 'Sales / (0.1 billian)', legend = df1_2$주소.구)

# 2) 연도별 보습 교과과정의 지출금액이 가장 큰 동이름, 지출금액 출력
# Answer 1
# step 1) 동이름 추출
str_extract_all(df3$교습소주소[1], '[가-힣]{1,}동')[[1]][1]
f2 <- function(x) {
  str_extract_all(x, '[가-힣]{1,}동')[[1]][1]
}
unique(sapply(df3$교습소주소, f2))
df3$교습소주소[sapply(df3$교습소주소, f2) == '관악푸르지오상가동']

# -- 괄호 안에 동을 찾아야겠네.
str_extract_all(df3$교습소주소[1], '\\([가-힣]{1,}동')[[1]][1]
f2 <- function(x) {
  str_extract_all(x, '\\([가-힣]{1,}동')[[1]][1]
}
unique(sapply(df3$교습소주소, f2))
df3$교습소주소[is.na(sapply(df3$교습소주소, f2))]

# -- 괄호와 동 사이에 숫자도 있어야 하네.
str_extract_all(df3$교습소주소[1], '\\([가-힣0-9]{1,}동')[[1]][1]
f2 <- function(x) {
  str_extract_all(x, '\\([가-힣0-9]{1,}동')[[1]][1]
}
unique(sapply(df3$교습소주소, f2))
df3$동 <- str_remove_all(sapply(df3$교습소주소, f2), '[(0-9]')  # [] 대괄호 속에 들어가면 일반기호로 자동 인식함 

# step 2) 필요 데이터 추출
df4$동 <- df3$동
df4$교습과정 <- df3$교습과정

# step 3) 연도 컬럼 stack
df5 <- melt(df4, id.vars  = c('교습과정', '동'),
            variable.name = '년도', value.name = '금액')
df5$년도 <- as.numeric(str_sub(df5$년도, 2, 5))

# step 4) 년도별 동별 교습과정별 금액의 총합
df6 <- ddply(df5, .(년도, 동, 교습과정), summarize, vsum = sum(금액))

# step 5) 연도별 교습과정별 금액의 최대를 갖는 행 선택
ddply(df6, .(년도, 교습과정), subset, vsum == max(vsum))

# Answer 2
df1_1$연도 <- str_sub(df1_1$날짜, 2, 5)

a1 <- c()
for (i in 1:nrow(df1_1)) {
  if (str_count(df1_1$교습소주소[i], '\\(') == 1) {
    a1[i] <- str_sub(df1_1$교습소주소[i],
                     (str_locate(df1_1$교습소주소[i], '\\(')[ , 2] + 1),
                     (str_locate(df1_1$교습소주소[i], '\\)')[ , 2] - 1))
    a1[i] <- str_sub(a1[i], 1,
                     (str_locate(a1[i], '동')[ , 2]))
  } else {
    a1[i] <- str_sub(df1_1$교습소주소[i],
                     (str_locate(df1_1$교습소주소[i], '\\(')[ , 2] + 1))
    a1[i] <- str_sub(a1[i], (str_locate(a1[i], '\\(')[ , 2] + 1))
    a1[i] <- str_sub(a1[i], 1, (str_locate(a1[i], '동')[ , 2]))
  }
}
df1_1$주소.동 <- a1

df1_2 <- ddply(df1_1[df1_1$교습과정 == '보습', ], .(연도, 주소.동), summarize, v3 = sum(매출액))
ddply(df1_2, .(연도), subset, v3 == max(v3))

# 3) 각 교습과정별 매출이 가장 높은 교습소명을 출력한 뒤 
#    각 교습소명(교습과정)과 매출액을 비교할 수 있는 막대그래프 출력
# Answer 1
# step 1) 교습과정별 교습소명별 매출액
df4$교습소명 <- df3$교습소명
df4$total <- df3$total

df_total <- ddply(df4, .(교습과정, 교습소명), summarize, vsum = sum(total))

# step 2) 교습과정별 최대금액을 갖는 행 선택
df_total2 <- ddply(df_total, .(교습과정), subset, vsum == max(vsum))

# step 3) 시각화 
dev.new()
par(oma = c(4, 0, 0, 0))    # 각각 하, 좌, 상, 우 순으로 여백 지정
vname <- str_c(df_total2$교습소명, '\n', df_total2$교습과정)
barplot(df_total2$vsum/100000, col = rainbow(nrow(df_total2)),
        ylim = c(0, 30000), names.arg = vname, las = 2)    # las xlab을 세로로 변경

# Answer 2
head(df1_1)

df1_3 <- ddply(df1_1, .(교습과정, 교습소명), summarize, v1 = sum(매출액))
df1_3 <- ddply(df1_3, .(교습과정), subset, v1 == max(v1))

barplot(df1_3$v1 / 100000000, beside = T, ylim = c(0, 50), col = 1:nrow(df1_3),
        xlab = 'school(subject)', ylab = 'Sales / (0.1 billian)', legend = str_c(df1_3$교습소명, df1_3$교습과정))

# 12.2 total.csv 파일을 읽고,
# 1) 연도별 각 품목에 대한 매출을 막대그래프로 시각화
# Answer 1
data1 <- read.csv('total.csv', fileEncoding = 'euc-kr')
head(data1)

# step 1) 연도와 지점을 결합한 형태로 컬럼이름 변경
colnames(data1) <- str_c(str_sub(colnames(data1), 2, 5), '_', data1[1, ])
data1 <- data1[-1, ]

# step 2) stack 처리
colnames(data1)[1] <- 'name'
data2 <- melt(data1, id.vars = 'name',
              variable.name = '년도', value.name = '금액')

# step 3) 년도와 지점 컬럼 분리
data2$지점 <- str_sub(data2$년도, 6, 6)
data2$년도 <- str_sub(data2$년도, 1, 4)

# step 4) 금액컬럼 숫자 변경
data2$금액 <- sapply(data2$금액, f_num)

# step 5) 연도별 제품별 매출에 대한 교차테이블 생성
data_total <- dcast(data2, name ~ 년도, sum, value.var = '금액')

# step 6) 시각화
dev.new()
barplot(as.matrix(data_total[, -1])/1000, beside = T, col = 2:4,
        ylim = c(0, 100), legend = data_total$name,
        args.legend = list(cex = 0.7))

# Answer 2
df2 <- read.csv('total.csv', fileEncoding = 'euc-kr')
head(df2)

df2_1 <- df2[-1, ]
df2_1 <- melt(df2_1, id.vars = 'X', variable.name = '날짜', value.name = '매출액')
df2_1$연도 <- str_sub(df2_1$날짜, 2, 5)

ddply(df2_1, .(연도, X), summarize, v1 = sum('매출액'))

# 2) 지점별로 가장 매출이 높은 품목과 총 매출액을 함께 출력
# Answer 1
# step 1) 지점별 품목별 매출액 총합
data3 <- ddply(data2, .(지점, name), summarize, vsum = sum(금액))

# step 2) 지점별 최대값 갖는 행 선택
ddply(data3, .(지점), subset, vsum == max(vsum))
# ------------------------------------------------------------------------------

# -------------------------------연 습 문 제------------------------------------
# 연습문제 45. taxi_call.csv 파일을 읽고,
# 각 요일별로 시간대별 택시 이용률을 파이차트로 출력 (7개 파이)
taxi1 <- read.csv('taxi_call.csv', fileEncoding = 'euc-kr')
head(taxi1)

taxi1$day <- as.character(as.Date(as.character(taxi1$기준년월일), '%Y%m%d'), '%A')

# Answer 1
# step 1) 시간대별 요일별 교차테이블 생성
taxi1_total <- dcast(taxi1, 시간대 ~ day, sum, value.var = '통화건수')

# step 2) 각 요일별 시간대의 통화건수 비율
f_rate <- function(x) {
  round(x / sum(x) * 100, 1)
}
taxi1_total[ , -1] <- apply(taxi1_total[, -1], 2, f_rate)

# step 3) 각 파이의 label 값 가공
# 0시 (8.9%)
str_c(taxi1_total$시간대, '시(', taxi1_total$Monday, '%)')
str_c(taxi1_total$시간대, '시(', taxi1_total$Tuesday, '%)')
str_c(taxi1_total$시간대, '시(', taxi1_total$Wednesday, '%)')
str_c(taxi1_total$시간대, '시(', taxi1_total$Thursday, '%)')
str_c(taxi1_total$시간대, '시(', taxi1_total$Friday, '%)')

library(plotrix)
dev.new()
par(mfrow = c(2, 4))
pie3D(taxi1_total$Monday,
      labels = str_c(taxi1_total$시간대, '시(', taxi1_total$Monday, '%)'),
      labelcex = 0.5, main = 'Mon')
pie3D(taxi1_total$Tuesday,
      labels = str_c(taxi1_total$시간대, '시(', taxi1_total$Tuesday, '%)'),
      labelcex = 0.5, main = 'Tue')
pie3D(taxi1_total$Wednesday,
      labels = str_c(taxi1_total$시간대, '시(', taxi1_total$Wednesday, '%)'),
      labelcex = 0.5, main = 'Wed')
pie3D(taxi1_total$Thursday,
      labels = str_c(taxi1_total$시간대, '시(', taxi1_total$Thursday, '%)'),
      labelcex = 0.5, main = 'Thu')
pie3D(taxi1_total$Friday,
      labels = str_c(taxi1_total$시간대, '시(', taxi1_total$Friday, '%)'),
      labelcex = 0.5, main = 'Fri')

# Answer 2
taxi1_1 <- ddply(taxi1, .(day, 시간대), summarize, v1 = sum(통화건수))
total <- ddply(taxi1_1, .(day), summarize, v2 = sum(v1))

taxi1_2 <- dcast(taxi1_1, day ~ 시간대, sum, value.var = 'v1')
rownames(taxi1_2) <- taxi1_2$day
taxi1_2 <- taxi1_2[ , -1] 

dev.new()
par(mfrow = c(3, 3))
pie((taxi1_3[ , 1] * 100 / sum(taxi1_3[ , 1])),
    labels = 0:23, labelcol = 1,
    main = colnames(taxi1_3)[1], family = 'AppleGothic')
# ------------------------------------------------------------------------------
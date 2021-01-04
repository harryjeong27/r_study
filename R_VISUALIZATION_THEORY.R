# ------------------------------ VISUALIZATION ---------------------------------
# [ 시각화 1 ]
# figure : 그래프를 그릴 공간
dev.new()    # 새로운 하나의 figure 생성

# 1.1 plot : 선그래프, 산점도, 교차산점도, ...
plot(x,         # x축 좌표
     y,         # y축 좌표
     ...)       # 그래프 옵션

plot(c(1, 2, 3), c(10, 11, 12))

# 1) type : 선그래프 스타일
dev.new()
par(new = T)
plot(c(1, 2, 3), c(10, 11, 12), type = 'o')    # 점과 함께
plot(c(1, 2, 3), c(10, 11, 12), type = 'l')    # 선만 출력

# 2) col : 선의 색
plot(c(1, 2, 3), c(10, 11, 12), type = 'l', col = 'red')    # 빨강
plot(c(1, 2, 3), c(10, 11, 12), type = 'l', col = 1)        # 검정

# 3) lty : 선 스타일(점선, 실선, ...) => 교재 6장 3page 참조
par(mfrow = c(1, 3))    # 분할로 여러 그래프 동시 출력
plot(c(1, 2, 3), c(10, 11, 12), type = 'l', lty = 1)
plot(c(1, 2, 3), c(10, 11, 12), type = 'l', lty = 2)    # dashed
plot(c(1, 2, 3), c(10, 11, 12), type = 'l', lty = 3)    # dotted

# 4) xlab, ylab, main : 각 축 이름, 메인 제목
dev.new()
par(family="Arial Unicode MS")
plot(c(1, 2, 3), c(10, 11, 12), type = 'l',
     xlab = 'x축 이름', ylab = 'y축 이름')

# 5) xlim, ylim : 각 축 범위 설정
plot(c(1, 2, 3), c(10, 11, 12), type = 'l',
     xlab = 'x축 이름', ylab = 'y축 이름', ylim = c(0, 12))

# 6) axis : x축, y축 눈금 설정 함수 for xlim, ylim
axis(side = ,      # 눈금 설정 방향(x축 : 1, y축 : 2)
     at = ,        # 눈금 벡터
     labels = ,    # 각 눈금의 이름
     ...)          # 기타옵션

# 7) axes : x축, y축 눈금 출력 여부
plot(1:5, c(10, 9, 11, 7, 13), type = 'o', col = 4, ylim = c(0, 15),
     axes = F, family="AppleGothic")
plot(1:5, c(10, 9, 1, 7, 3), type = 'o', col = 4, ylim = c(0, 15),
     axes = F, family="AppleGothic")

# 8) ann : x축, y축 이름 출력 여부

# 9) title : 각 축, 메인 제목을 동시 전달하는 함수 for main, xlab, ylab
title(main = ,    # 메인제목
      sub = ,     # 서브제목
      xlab = ,    # x축 이름
      ylab = ,    # y축 이름
      ...)        # 기타옵션

# 10) legend : 범례를 출력하는 함수
legend(x = ,           # 범례 출력 x 위치
       y = ,           # 범례 출력 y 위치 (end)
       legend = ,      # 범례 표현 값
       fill = ,        # 범례 색 표현(막대그래프 출력 시 주로 사용)
       col = ,         # 범계 색 표현(선그래프 출력 시 주로 사용)
       ...)

# 예제) 다음의 데이터에 c축 눈금을 월화수목금 설정
axis(1, 1:5, c('월', '화', '수', '목', '금'), family="AppleGothic")
axis(2, ylim = c(0, 10))  # 15까지 출력 => y축 눈금 출력만 가능, ylim 변경 불가

# 데이터프레임의 선 그래프 출력
# - plot에 데이터 프레임 전달 시 각 컬럼별(로우별) 선그래프 출력불가
#   (교차 산점도 출력)
# - 각 컬럼별, 행별 분리하여 하나씩 생성 필요(파이썬에선 동시 출력 가능)
# - 여러 그래프를 하나의 figure에 동시 그릴 시 plot -> lines 대체

# 예제) 다음의 데이터프레임에서 각 과일별 판매량 증감 추이를 선 그래프로 출력
df1 <- data.frame(apple = c(100, 120, 150),
                  banana = c(200, 210, 250),
                  mango = c(90, 80, 110))
rownames(df1) <- 2010:2012

plot(df1$apple, type = 'o', col = 2)
lines(df1$banana, type = 'o', col = 3)  # apple에 맞춰 축 범위가 정해져서 출력 x

dev.new()

plot(df1$apple, type = 'o', col = 2, ylim = c(50, 300), axes = F, ann = F)
# ann => 축이름 생략
lines(df1$banana, type = 'o', col = 3)
lines(df1$mango, type = 'o', col = 4)

axis(1, at = 1:3, labels = rownames(df1))    # 눈금 설정
axis(2, ylim = c(50, 300))
par(family="AppleGothic")
title(main = '과일별 판매량 증감추이', col.main = 'red',    # 해당 글자 색 설정
      xlab = '연도', cex.lab = 1.5,                       # 해당 글자 크기 설정
      ylab = '판매량', font.lab = 4)                      # 해당 글자 폰트 설정

legend(1, 300, colnames(df1), col = 2:4, lty = 1)

# [ 참고 18 : 교차 산점도 ]
# - plot 함수에 데이터프레임 (숫자컬럼으로 구성된)을 전달하면 자동 출력
# - 각 변수간 상관관계 파악 시 사용
# - 분류분석 시 종속변수의 분류에 영향력이 큰 설명변수 찾는 과정에 사용
# - iris에서는 petal.length & petal.width

# 예제) iris 데이터의 4개 설명변수의 교차 산점도 출력
plot(iris[, -5])

# 예제) iris 데이터의 4개 설명변수의 교차 산점도 출력
#       출력 시 species의 값마다 서로 다른 색 부여
plot(iris[, -5], col = iris$Species)
str(iris)    # Species는 factor 변수이므로 1, 2, 3의 숫자가 대입됨

# 1.2 barplot
# - 막대 그래프
# - 컬럼별 서로 다른 그룹의 막대 생성
# - 하나의 컬럼 내 서로 다른 행 데이터가 stack된 형식 출력이 기본
barplot(height = ,    # 2차원 데이터
        ...)

# 예제) 다음의 데이터에 대해 각 과일별 판매량을 비교하는 막대그래프 출력
fruit <- data.frame(apply = c(100, 120, 150),
                    banana = c(200, 210, 250),
                    mango = c(90, 80, 110))

rownames(fruit) <- 2010:2012
dev.new()
barplot(as.matrix(fruit))                # stack된 형식
barplot(as.matrix(fruit), beside = T)    # 행별 서로 다른 막대

barplot(as.matrix(t(fruit)), beside = T, col = 2:4, ylim = c(0, 300))
# legend(1, 300, colnames(fruit), col = rainbow(3), lty = 1) # 범례모양 선스타일
legend(1, 300, colnames(fruit), fill = rainbow(3))         # 범례모양 박스스타일

# 조건별 서로 다른 색 전달 (사용자 정의 팔레트 생성)
barplot(as.matrix(fruit[ , 1]), col = vcol, beside = T)
v1 <- fruit[ , 1]

vcol <- c()
for (i in v1) {
  if (i <= 110) {
    vcol <- c(vcol, 'green')
  } else if (i <= 130) {
    vcol <- c(vcol, 'yellow')
  } else {
    vcol <- c(vcol, 'red')
  }
}

# 1.3 hist : 히스토그램
hist(x,                   # 벡터
     breaks = ,           # 막대별 범위
     include.lowest = ,   # 최소값 포함 여부
     right = T)           # 오른쪽 포함 여부

# [ 참고 20 : 데이터의 범위 정의 시 닫혀있다의 의미 ]
# a <= x < b    => [a, b) => 왼쪽이 닫혀있다
# a < x <= b    => (a, b] => 오른쪽이 닫혀있다

# 예제) student.csv 파일을 읽고 키에 대한 히스토그램 출력
std <- read.csv('student.csv', fileEncoding = 'EUC-KR')
dev.new()
par(mfrow = c(1, 2))
hist(std$HEIGHT)
hist(std$HEIGHT, breaks = c(160, 170, 180, 190))
hist(std$HEIGHT, angle = c(0, 90, 45, 10, 60), density = 30, col = 2:6,
     border = 1)

# 예제) 다음의 벡터에 대한 히스토그램을 출력
v1 <- c(160, 161, 163, 165, 166, 168, 171, 174)
hist(v1)    # right = T가 default => 160초과 165이하
# 160초과 165이하 : 3
# 165초과 170이하 : 2
# 160초과 165이하 개수가 4개로 표시 => include.lowest = T가 default이기 때문

hist(v1, breaks = c(160, 165, 170, 175),    # Error => 160이 포함되지 않는다
     include.lowest = F)

# 1.4 pie : 파이 차트
pie(x,                # 벡터
    labels = ,        # 각 파이 이름
    radius = ,        # 파이 크기
    clockwise = F,    # 파이 진행방향(시계방향 여부)
    init.angle = ,    # 파이 시작점
    col = ,           # 각 파이 색
    ...)              # 기타 옵션

vec1 <- c(10, 11, 14, 15, 2)
dev.new()
pie(vec1, labels = c('mon', 'tue', 'wed', 'thu', 'fri'))

library(stringr)
vrate <- vec1 / sum(vec1) * 100
vlabel <- str_c(c('mon', 'tue', 'wed', 'thu', 'fri'), '\n',
                round(vrate , 1), '%')

par(mfrow = c(1, 2))
pie(vec1, labels = c('mon', 'tue', 'wed', 'thu', 'fri'))
pie(vec1, labels = vlabel, init.angle = 90)

# pie3D
plotrix::pie3D
install.packages('plotrix')
library(plotrix)

pie3D(x,             # 벡터
      radius = ,     # 파이 원 크기
      height = ,     # 파이 높이
      labels = ,     # 각 파이 이름
      labelcex = ,   # 라벨 글자 크기
      labelcol = ,   # 라벨 글자 색
      explode = ,    # 파이 간 간격
      ...)

pie(vec1, labels = c('mon', 'tue', 'wed', 'thu', 'fri'))
pie3D(vec1, labels = c('mon', 'tue', 'wed', 'thu', 'fri'), explode = 0.1)

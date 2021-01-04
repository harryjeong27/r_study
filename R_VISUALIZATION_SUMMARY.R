# 1. plot
plot(x, y,
     type = ,    # 그래프 선 스타일 => 'o':선 + 점, 'l':선만
     col = ,     # color => 'red', 1
     lty = ,     # 선 스타일 => 2:dashed, 3: dotted
     xlab = ,    # x축 이름
     ylab = ,    # y축 이름
     main = ,    # 제목
     xlim = ,    # x축 범위 설정
     ylim = ,    # y축 범위 설정
     axes = F,   # x축 y축 눈금 출력 여부
     ann = F)    # x축 y축 이름출력 여부
lines()

# axis : x축, y축 설정 함수 for xlim, ylim
axis(side = ,    # 눈금 설정 방향 (x축 : 1, y축 : 2)
     at = ,      # 눈금 벡터 ex) 1:3
     labels = ,  # 각 눈금의 이름
     ...)        # 기타옵션

# title : 각 축, 메인 제목을 동시 전달하는 함수 for main, xlab, ylab
title(main = ,   # 메인제목
      sub = ,    # 서브제목
      xlab = ,   # x축 이름
      ylab = ,   # y축 이름
      ...)       # 기타옵션

# legend : 범례를 출력하는 함수
legend(x = ,        # 범례 출력 x 위치
       y = ,        # 범례 출력 y 위치 (end 값)
       legend = ,   # 범례 표현 값
       fill = ,     # 범례 색 표현 (막대그래프 출력 시 주로 사용)
       col = ,      # 범계 색 표현 (선그래프 출력 시 주로 사용)
       ...)

# 교차산점도
# plot 함수에 데이터프레임 전달하면 자동출력
# ex) plot(iris[ , -5], col = iris$Species)

# 2. barplot
barplot(height = ,    # 2차원 데이터
        beside = T,   # 행별 서로 다른 막대 (F:stack된 형식)
        ...)

# 3. hist
hist(x,                   # 벡터
     breaks = ,           # 막대별 범위
     include.lowest = ,   # 최소값 포함 여부
     right = T,           # 오른쪽 포함 여부
     angle = ,            # 막대 내 선의 각도 (0 ~ 360)
     density = ,          # 막대 내 선의 밀도 (0 ~ 100)
     border = )           # 막대의 경계선 색

# 4. pie
pie(x,                    # 벡터
    labels = ,            # 각 파이 이름
    radius = ,            # 파이 크기
    clockwise = F,        # 파이 진행방향 (시계방향 여부)
    init.angle = ,        # 파이 시작점
    col = ,               # 각 파이 색
    ...)                  # 기타 옵션


# 5. plotrix::pie3D
pie3D(x,                  # 벡터
      radius = ,          # 파이 원 크기
      height = ,          # 파이 높이
      labels = ,          # 각 파이 이름
      labelcex = ,        # 라벨 글자 크기
      labelcol = ,        # 라벨 글자 색
      explode = ,         # 파이 간 간격
      ...)












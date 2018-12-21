install.packages('MASS')
require(MASS)
green = rgb(63/255, 130/255, 64/255)

S = matrix(c(
  1.0, 0.5, 0.2,
  0.5, 1.0, 0.5,
  0.2, 0.5, 1.0
),3 ,3)
colnames(S) = c('Y', 'X', 'I')
rownames(S) = c('Y', 'X', 'I')

test = mvrnorm(
  100,
  mu = c(0, 0, 0),
  Sigma = S,
  empirical = T
)

cor(test)

Y = test[,1]
X = test[,2]
I = test[,3]

X.Y = lm(Y ~ X)

plot(
  X, Y,
  col = green,
  pch = 20,
  xlab = NULL,
  ylab = NULL,
  main = NULL,
  xlim = c(-2, 2)
)
abline(lm(X.Y))
# points(I, X.I$fitted.values)

X.I = lm(X ~ I)
plot(
  I, X,
  col = rgb(.3, .5, .01),
  pch = 20,
  xlab = NULL,
  ylab = NULL,
  main = NULL
)
points(I, X.I$fitted.values)


X.fittedI = lm(Y ~ X.I$fitted.values)
summary(X.fittedI)
plot(
  X.I$fitted.values, Y,
  col = rgb(.3, .5, .01),
  pch = 20,
  xlab = NULL,
  ylab = NULL,
  main = NULL,
  xlim = c(-2, 2)
)
abline(X.fittedI)




#schwache Instrumente

S = matrix(c(
  1.0,  0.5,  0.2,
  0.5,  1.0, 0.05,
  0.2, 0.05, 1.0
),3 ,3)
colnames(S) = c('Y', 'X', 'I')
rownames(S) = c('Y', 'X', 'I')

test = mvrnorm(
  100,
  mu = c(0, 0, 0),
  Sigma = S,
  empirical = T
)

cor(test)

Y = test[,1]
X = test[,2]
I = test[,3]

X.Y = lm(Y ~ X)

plot(
  X, Y,
  col = green,
  pch = 20,
  xlab = NULL,
  ylab = NULL,
  main = NULL,
  xlim = c(-2, 2)
)
abline(lm(X.Y))
# points(I, X.I$fitted.values)

X.I = lm(X ~ I)
plot(
  I, X,
  col = rgb(.3, .5, .01),
  pch = 20,
  xlab = NULL,
  ylab = NULL,
  main = NULL
)
points(I, X.I$fitted.values)


X.fittedI = lm(Y ~ X.I$fitted.values)
summary(X.fittedI)
plot(
  X.I$fitted.values, Y,
  col = rgb(.3, .5, .01),
  pch = 20,
  xlab = NULL,
  ylab = NULL,
  main = NULL,
  xlim = c(-2, 2)
)
abline(X.fittedI)
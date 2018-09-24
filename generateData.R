require(MASS)

test = mvrnorm(
  100,
  mu = c(0, 0, 0),
  Sigma = matrix(c(
    1.0, 0.5, 0.2,
    0.5, 1.0, 0.5,
    0.2, 0.5, 2.0
  ),3 ,3),
  empirical = T
)

cor(test)

Y = test[,1]
X = test[,2]
I = test[,3]

X.Y = lm(Y ~ X)
X.I = lm(X ~ I)
fitted.X.I = fitted(X.I)

plot(
  X.I$fitted.values, Y,
  col = rgb(.3, .5, .01),
  pch = 20,
  xlab = NULL,
  ylab = NULL,
  main = NULL,
  xlim = c(-2, 2)
)
abline(lm(Y ~ X.I$fitted.values))
# points(I, X.I$fitted.values)



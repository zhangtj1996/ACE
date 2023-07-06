library("acepack")
N <- 10000
x <- runif(N,0,1)
eps <- rnorm(N)*0.0001
y <- exp(exp(x)/sd(exp(x))+eps)
y <- y/sd(y)

a <- ace(x,y)

var(y)
var(a$ty)
var(a$tx)
var(eps)/(1+var(eps))
var(a$ty-a$tx)

plot(x,y)
plot(a$y,a$ty) # view the response transformation
plot(a$x,a$tx) # view the carrier transformation
plot(a$tx,a$ty) # examine the linearity of the fitted model

plot(a$x,a$ty-a$tx)


a <- ace(y,x)

rdc <- function(x,y,k=20,s=1/6,f=sin) {
  x <- cbind(apply(as.matrix(x),2,function(u)rank(u)/length(u)),1)
  y <- cbind(apply(as.matrix(y),2,function(u)rank(u)/length(u)),1)
  x <- s/ncol(x)*x%*%matrix(rnorm(ncol(x)*k),ncol(x))
  y <- s/ncol(y)*y%*%matrix(rnorm(ncol(y)*k),ncol(y))
  cancor(cbind(f(x),1),cbind(f(y),1))$cor[1]
}


a <- ace(x,y)
rdc(a$x,a$ty-a$tx)

a <- ace(y,x)
rdc(a$y,a$ty-a$tx)

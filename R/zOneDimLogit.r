oneDimLogit <- function(data, index, weights, adaweights, thresh=0.0001, lambdas=NULL, beta.naught=rep(0,ncol(data$x)), inner.iter=100, outer.iter=100, outer.thresh=0.0001, gamma=0.8, step=1, reset=10, alpha=0.95, min.frac=0.05, nlam=20, verbose=FALSE){
  if(is.null(lambdas)){
    lambdas <- betterPathCalc(data=data, index=index, weights=weights, alpha=alpha, min.frac=min.frac, nlam=nlam, type="logit", adaweights=adaweights)
  }
  
  X <- data$x
  y <- data$y
  n <- nrow(X)
  p <- ncol(X)

  #put the groups and adaweights in numerical order
  groups <- unique(index)
  ord.g = order(groups)
  groups = groups[ord.g]
  adaweights = adaweights[ord.g]
  
  #Reorder columns of X so that groups are contiguous
  ord <- order(index)
  index <- index[ord]
  X <- X[,ord]
  unOrd <- match(1:length(ord),ord)
  
  ## Coming up with other C++ info ##
  num.groups <- length(groups)
  range.group.ind <- rep(0,(num.groups+1))
  for(i in 1:num.groups){
    range.group.ind[i] <- min(which(index == groups[i])) - 1
  }
  range.group.ind[num.groups+1] <- ncol(X)
  group.length <- diff(range.group.ind)
  
  beta.naught <- rep(0,ncol(X))
  beta <- beta.naught
  
  beta.is.zero <- rep(1, num.groups)
  beta.old <- rep(0, ncol(X))
  beta <- matrix(0, nrow = ncol(X), ncol = nlam)

  eta <- rep(0,n)
  intercepts <- rep(log(sum(y)) - log(n-sum(y)), nlam)
  eta = eta + intercepts[1]

  beta.is.zero <- rep(1, num.groups)
  beta.old <- rep(0, ncol(X))
  
  for(i in 1:nlam){
    junk <- .C("logitNest", X=as.double(as.vector(X)), y=as.integer(y), w=as.double(weights), index=as.integer(index), adaweights=as.double(adaweights), nrow=as.integer(nrow(X)), ncol=as.integer(ncol(X)), numGroup=as.integer(num.groups), rangeGroupInd=as.integer(range.group.ind), groupLen=as.integer(group.length), lambda1=as.double(alpha*lambdas[i]), lambda2=as.double((1-alpha)*lambdas[i]), beta=as.double(beta.old), innerIter=as.integer(inner.iter), outerIter=as.integer(outer.iter), thresh=as.double(thresh), outerThresh=as.double(outer.thresh), eta=as.double(eta), gamma=as.double(gamma), betaIsZero=as.integer(beta.is.zero), betaZero=as.double(intercepts[i]), step=as.double(step))

    intercepts[i] = junk$betaZero
    if(i < nlam){
      intercepts[i+1] = intercepts[i]
    }
    beta.new <- junk$beta
    beta[,i] <- beta.new
    beta.is.zero <- junk$betaIsZero
    eta <- junk$eta
    beta.old <- beta.new
    if(verbose == TRUE) {
      write(paste("***Lambda", i, "***"),"")
    }
  }
 
  return(list(beta=beta[unOrd,], lambdas=lambdas, intercepts=intercepts))
}

## The code can be used to find and cache the inverse of a matrix

##Creates a set of functions to get/set as matrix and get/set the inverse of a matrix
makeCacheMatrix <- function(x = matrix()) { 
    inv <- NULL 
    set <- function(y) { 
      x <<- y 
      inv <<- NULL
    
    } 
    get <- function() x 
    setinverse <- function(inverse) inv <<- inverse 
    getinverse <- function() inv 
    list(set=set, get=get, 
        setinverse=setinverse, 
        getinverse=getinverse) 
} 


## Write a short comment describing this function
## CacheSolve Function to find inverse of a matrix.
cacheSolve <- function(x, ...) { 
    inv <- x$getinverse() 
    if(!is.null(inv)) { 
      message("getting cached data.") 
      return(inv) 
    } 
    data <- x$get() 
    inv <- solve(data) 
    x$setinverse(inv) 
    inv 
} 

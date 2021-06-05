rm(list=ls(all=TRUE))
library(ggplot2)


## m homopolymer length  3
## delta_v dropout rate  0 - 0.005
## b coding potential; entropy of each nucleotide in a valid sequence 1.98
## i index overhead 0.05 - 0.1 (fraction devoted to index sequences)
## l oligo length 100-200 nt

## L 256 bits (32 bytes) length of non-overlapping segments
## d number of segments to package in a droplet
## rho(d)  probability distribution

## K number of segments needed for decoding

## Z normalization parameter

d <- 1:15
K <- 100
c <- 0.1
delta_v <- 0.05
Z <- 1.033
        
s <- c*sqrt(K)*(log(K/delta_v))



results <- data.frame(matrix(ncol=3, nrow=1))
names(results) <- c("rho","tau","rsd")

calc_rho_d <- function(x){if( x == 1){
                              1/K
                          }else{
                              1/(x*(x-1))
                          }
}


rho <- sapply(d, calc_rho_d)

calc_tau_d <- function(x){ if( x >= 1 && x <= ((K/s)-1)){
                               s/(K*x)
                           } else if ( x > ((K/s)-1) && x <= K/s){
                               (s*log(s/delta_v))/K
                           } else if ( x > K/s){
                               0
                           }
}

tau <- sapply(d, calc_tau_d)

results <- data.frame(cbind(d, rho, tau))

results$rho.tau <- (results$rho + results$tau )

factor <- 1/sum(results$rho.tau)
results$rob_sol_dis <- results$rho.tau*factor

sum(results$rob_sol_dis)


plot(results$d, results$rob_sol_dis)

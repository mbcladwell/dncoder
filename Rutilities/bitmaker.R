rm(list=ls(all=TRUE))
library(ggplot2)

file.name <-"~/syncd/misc/DNCoder/RUtilities/outbits.txt"
file.remove(file.name)


counter <- 0
for(p in 0:1){
    for(o in 0:1){
        for(n in 0:1){
            for(m in 0:1){
                for(l in 0:1){
                    for(k in 0:1){
                        for(j in 0:1){
                            for(i in 0:1){
                                cat(paste0("(", counter, " . \"", p, o, n, m, l, k, j, i, "\")"), file=file.name, append=TRUE)
                                counter<- counter+1
                            }
                        }
                    }
                }}}}}

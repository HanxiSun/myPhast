setwd("~/GoogleDrive/Purdue/Research/Vinayak_Rao/17Spr_Genetic/Softwares/test/v1_robust")

# ======================================================== #
# ====================== Parameters ====================== #
# ======================================================== #
mu_seq <- nu_seq <- c(0.001,0.005,0.01,0.05,0.1)
phi_seq <- eta_seq <- seq(0.1, 0.6, 0.1)
cutoff <- 0.8        # cut off for (phi + eta)
tol <- 100           # num of bp diff for the start & end


# ======================================================== #
# =================== Original Results =================== #
# ======================================================== #
df <- read.table("../original_hmrc.gff", skip=3)
ori <- df[,c("V3","V4","V5")]
colnames(ori) <- c("type", "start", "end")
ori$type <- as.character(ori$type)
# record the result
res <- data.frame(mu=0.01, nu=0.01, phi=0.5, eta=0, 
                  nonNeutral=nrow(ori), sameRegion=nrow(ori), 
                  sameType=nrow(ori), notFound=0, extra=0, nSig=nrow(ori)) 


# ======================================================== #
# ====================== Experiment ====================== #
# ======================================================== #
for (mu in mu_seq){
    for (nu in nu_seq){
        for (phi in phi_seq){
            for (eta in eta_seq){
                if (phi+eta >= cutoff) next
                count <- rep(0, 5)   # temp var to record the 4 counts
                names(count) <- c("nonNeutral", "sameRegion", "sameType", "notFound", "extra")
                sameRegion2 <- 0     # sameRegion in terms of cur, i.e. extra=nrow(cur)-sameRegion2
                
                df <- read.table(paste("v1_rb_",mu,",",nu,",",phi,",",eta,".gff",sep=''), skip=3)
                cur <- df[,c("V3","V4","V5")]
                colnames(cur) <- c("type", "start", "end")
                cur$type <- as.character(cur$type)
                
                for (i in 1:nrow(ori)){
                    sameType <- (ori$type[i] == cur$type)
                    sameStart <- (abs(ori$start[i]-cur$start) < tol)
                    sameEnd <- (abs(ori$end[i]-cur$end) < tol)
                    
                    count["sameRegion"] <- count["sameRegion"] + sign(sum(sameStart & sameEnd))
                    count["sameType"] <- count["sameType"] + sign(sum(sameType & sameStart & sameEnd))
                    sameRegion2 <- sameRegion2 + sum(sameStart & sameEnd)
                }
                
                count["notFound"] <- nrow(ori) - count["sameRegion"]
                count["extra"] <- nrow(cur) - sameRegion2
                count["nonNeutral"] <- nrow(cur)
                
                df <- read.table(paste("phyloP_rb_",mu,",",nu,",",phi,",",eta,".txt",sep=''), skip=1)
                p.values <- df[,9]
                nSig <- sum(abs(p.values) < 0.05)
                
                res <- rbind(res, c(mu, nu, phi, eta, count, nSig))
            }
        }
    }
}

write.csv(res, "../v1_rb_result.csv", row.names=F)


# ======================================================== #
# ======================== Result ======================== #
# ======================================================== #
res <- read.csv("../v1_rb_result.csv", header=T)





############################################################
############################################################
############################################################
# mu<-nu<-0.001; phi<-eta<-0.1
# mu<-nu<-0.01; phi<-eta<-0.1

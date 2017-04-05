setwd("~/GoogleDrive/Purdue/Research/Vinayak_Rao/17Spr_Genetic/Softwares/test/v1_robust")

# ======================================================== #
# ====================== Parameters ====================== #
# ======================================================== #
lambda_seq <- seq(1.5, 5, 0.5)
phi_seq <- eta_seq <- seq(0.1, 0.6, 0.1)
cutoff <- 0.8        # cut off for (phi + eta)
# change type discription
type.adj <- function(t){
    sapply(t, function(x){a<-unlist(strsplit(x, '-')); a[length(a)]})
}


# ======================================================== #
# =================== Original Results =================== #
# ======================================================== #
df <- read.table("../original_hmrc.gff", skip=3)
ori <- df[,c("V3","V4","V5")]
colnames(ori) <- c("type", "start", "end")
ori$type <- type.adj(as.character(ori$type))
# record the result
res <- data.frame(lambda=1, phi=0.5, eta=0)
res$start <- list(ori$start)
res$end <- list(ori$end)
res$type <- list(ori$type)


# ======================================================== #
# ====================== Experiment ====================== #
# ======================================================== #
for (lambda in lambda_seq){
    for (phi in phi_seq){
        for (eta in eta_seq){
            if (phi+eta >= cutoff) next
            
            df <- read.table(paste("v1_rb_",lambda,",",phi,",",eta,".gff",sep=''), skip=3)
            cur <- df[,c("V3","V4","V5")]
            colnames(cur) <- c("type", "start", "end")
            cur$type <- type.adj(as.character(cur$type))
            cur.df <- data.frame(lambda=lambda, phi=phi, eta=eta) 
            cur.df$start <- list(cur$start)
            cur.df$end <- list(cur$end)
            cur.df$type <- list(cur$type)
            
            res <- rbind(res, cur.df)
        }
    }
}

save(res, file="../v1_rb_result_2.rda")





# ======================================================== #
# ======================== Result ======================== #
# ======================================================== #
load("../v1_rb_result_2.rda")

library(shiny)

runApp(list(
    ui = fluidPage(
        titlePanel("Robustness of DLESS")
    ),
    server = function(){}
))

















############################################################
############################################################
############################################################
# mu<-nu<-0.001; phi<-eta<-0.1
# mu<-nu<-0.01; phi<-eta<-0.1
# lambda <- lambda_seq[1]; phi <- phi_seq[1]; eta <- eta_seq[1]

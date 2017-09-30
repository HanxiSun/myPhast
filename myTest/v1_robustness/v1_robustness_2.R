setwd("~/GoogleDrive/Purdue/Research/Vinayak_Rao/17Spr_Genetic/Softwares/myPhast/myTest/")

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
df <- read.table("original_hmrc.gff", skip=3)
orig <- df[,c("V3","V4","V5")]
colnames(orig) <- c("type", "start", "end")
orig$type <- type.adj(as.character(orig$type))
# record the result
if(F){
    res <- data.frame(lambda=1, phi=0.5, eta=0)
    res$start <- list(orig$start)
    res$end <- list(orig$end)
    res$type <- list(orig$type)
}
res1 <- data.frame(lambda=1, phi=0.5, eta=0, 
                   start=orig$start, end=orig$end, type=orig$type)


# ======================================================== #
# ====================== Experiment ====================== #
# ======================================================== #
for (lambda in lambda_seq){
    for (phi in phi_seq){
        for (eta in eta_seq){
            if (phi+eta < cutoff){
                df <- read.table(paste("v1_robust/v1_rb_",lambda,",",phi,",",eta,".gff",sep=''), skip=3)
                cur <- df[,c("V3","V4","V5")]
                colnames(cur) <- c("type", "start", "end")
                cur$type <- type.adj(as.character(cur$type))
                
                if(F){
                    cur.df <- data.frame(lambda=lambda, phi=phi, eta=eta) 
                    cur.df$start <- list(cur$start)
                    cur.df$end <- list(cur$end)
                    cur.df$type <- list(cur$type)
                    
                    res <- rbind(res, cur.df)
                }
                res1 <- rbind(res1, 
                              data.frame(lambda=lambda, phi=phi, eta=eta,
                                         start=cur$start, end=cur$end, type=cur$type))
            } 
        }
    }
}

#save(res, res1, file="v1_rb_result_2.rda")
#save(res1, file="v1_rb_result_2.rda")
write.csv(res1, "v1_rb_result_2.csv", row.names=F)





# ======================================================== #
# ======================== Result ======================== #
# ======================================================== #
#load("v1_rb_result_2.rda")
res <- read.csv("v1_robustness/v1_rb_result_2.csv", header=T)

library(shiny)
library(ggplot2)

slider.lambda <- sliderInput(inputId = "lambda", label = "lambda", value = 2,
                             min = 1.5, max = 5, step = 0.5)
slider.eta <- sliderInput(inputId = "eta", label = "eta", value = 0.3,
                          min = 0.1, max = 0.6, step = 0.1)
slider.phi <- sliderInput(inputId = "phi", label = "phi", value = 0.3,
                          min = 0.1, max = 0.6, step = 0.1)

runApp(list(
    ui = fluidPage(
        titlePanel("Robustness of DLESS"), 
        sidebarPanel(
            radioButtons(inputId = "display", label = "Display Variable", 
                         choices = c("ACC rate (lambda)"="c.lambda", 
                                     "ACC trans p (eta)"="c.eta", 
                                     "CON trans p (phi)"="c.phi")),
            conditionalPanel(condition = "input.display == 'c.lambda'",
                             list(slider.eta, slider.phi)),
            conditionalPanel(condition = "input.display == 'c.eta'",
                             list(slider.lambda, slider.phi)),
            conditionalPanel(condition = "input.display == 'c.phi'",
                             list(slider.lambda, slider.eta))
        ), 
        mainPanel(
            plotOutput("locPlot")
        )
    ),
    server = function(input, output, session){
        output$locPlot <- renderPlot({
            orig <- res[res$eta==0,]
            rest <- res[res$eta!=0,]
            orig$orig <- T
            rest$orig <- F
            
            if (input$display == "c.lambda"){
                temp <- rest[abs(rest$eta-input$eta)<1e-5 & abs(rest$phi-input$phi)<1e-5,]
                temp <- rbind(orig, temp)
                
                ggplot(data.frame(location = range(c(temp$start, temp$end)), 
                                  lambda = range(temp$lambda)),
                       aes(location, lambda)) +
                    geom_segment(aes(x = start, y = lambda, 
                                     xend = end, yend = lambda,
                                     colour = type, size = orig), 
                                 data = temp)
            }else if (input$display == "c.eta"){
                temp <- rest[abs(rest$lambda-input$lambda)<1e-5 & abs(rest$phi-input$phi)<1e-5,]
                temp <- rbind(orig, temp)
                
                ggplot(data.frame(location = range(c(temp$start, temp$end)), 
                                  eta = range(temp$eta)),
                       aes(location, eta)) +
                    geom_segment(aes(x = start, y = eta, 
                                     xend = end, yend = eta,
                                     colour = type, size = orig), 
                                 data = temp)
            }else if (input$display == "c.phi"){
                temp <- rest[abs(rest$lambda-input$lambda)<1e-5 & abs(rest$eta-input$eta)<1e-5,]
                orig1 <- orig
                orig1$phi <- 0
                temp <- rbind(orig1, temp)
                
                ggplot(data.frame(location = range(c(temp$start, temp$end)), 
                                  phi = range(temp$phi)),
                       aes(location, phi)) +
                    geom_segment(aes(x = start, y = phi, 
                                     xend = end, yend = phi,
                                     colour = type, size = orig), 
                                 data = temp)
            }
        })
    }
))















############################################################
############################################################
############################################################
# mu<-nu<-0.001; phi<-eta<-0.1
# mu<-nu<-0.01; phi<-eta<-0.1
# lambda <- lambda_seq[1]; phi <- phi_seq[1]; eta <- eta_seq[1]

lambda<-1.5;phi<-.3;eta<-.4
temp <- rest[rest$eta == eta & rest$phi == phi,]
temp <- rest[abs(rest$eta-eta)<1e-3 & abs(rest$phi-phi)<1e-3,]
temp <- rest[abs(rest$eta-eta)<1e-3 & abs(rest$lambda-lambda)<1e-3,]
res[res$phi==phi & res$eta==eta,]

x <- stats::runif(12); y <- stats::rnorm(12)
i <- order(x, y); x <- x[i]; y <- y[i]
plot(x, y, main = "arrows(.) and segments(.)")
## draw arrows from point to point :
s <- seq(length(x)-1)  # one shorter than data
arrows(x[s], y[s], x[s+1], y[s+1], col= 1:3)
s <- s[-length(s)]
segments(x[s], y[s], x[s+2], y[s+2], col= 'pink')






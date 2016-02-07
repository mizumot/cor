library(shiny)
library(shinyAce)
library(psych)
library(beeswarm)



shinyServer(function(input, output) {


    bs <- reactive({
        if (input$colname == 0) {
            x <- read.csv(text=input$text, header=FALSE, sep="", na.strings=c("","NA","."))
            x <- as.matrix(x)
            describe(x)[2:13]
        } else {
            x <- read.csv(text=input$text, sep="", na.strings=c("","NA","."))
            describe(x)[2:13]
        }
    })

    output$textarea.out <- renderPrint({
        bs()
    })



    makeboxPlot <- function(){
        if (input$colname == 0) {
            dat <- read.csv(text=input$text, header=FALSE, sep="", na.strings=c("","NA","."))
        } else {
            dat <- read.csv(text=input$text, sep="", na.strings=c("","NA","."))
        }

        boxplot(dat, las=1, xlab= "Means and +/-1 SDs are displayed in red.")
        beeswarm(dat, col = 4, pch = 16, vert = TRUE,  add = TRUE)
        for (i in 1:ncol(dat)) {
            pts <- 0.2 + i
            mns <- mean(dat[,i], na.rm=TRUE)
            sds <- sd(dat[,i], na.rm=TRUE)

            points(pts, mns, pch = 18, col = "red", cex = 2)
            arrows(pts, mns, pts, mns + sds, length = 0.1, angle = 45, col = "red")
            arrows(pts, mns, pts, mns - sds, length = 0.1, angle = 45, col = "red")
        }
    }

    output$boxPlot <- renderPlot({
        print(makeboxPlot())
    })



    correl <- reactive({

        if (input$colname == 0) {
            x <- read.table(text=input$text, sep="", na.strings=c("","NA","."))
            x <- as.matrix(x)

            type <- switch(input$method,
                           Pearson = "pearson",
                           Spearman = "spearman",
                           Kendall = "kendall")

            round(cor(cbind(x), method = type, use = "pairwise.complete.obs"),3)

        } else {
            x <- read.csv(text=input$text, sep="", na.strings=c("","NA","."))

            type <- switch(input$method,
                           Pearson = "pearson",
                           Spearman = "spearman",
                           Kendall = "kendall")

            round(cor(cbind(x), method = type, use = "pairwise.complete.obs"),3)
        }
    })

    output$correl.out <- renderPrint({
        correl()
    })



    ci <- reactive({

        if (input$colname == 0) {
          x <- read.csv(text=input$text, header=FALSE, sep="", na.strings=c("","NA","."))
        } else {

          x <- read.csv(text=input$text, sep="", na.strings=c("","NA","."))

        }

           type <- switch(input$method,
                        Pearson = "pearson",
                        Spearman = "spearman",
                        Kendall = "kendall")

           ci.all <- function(x) {

                for (i in 1:length(x)) {
                    for (j in 1:length(x)) {
                        if (i >= j) {
                            next
                        } else {

                            r <- cor(x[,i], x[,j], method = type, use = "complete")
                            n <- length(x[,1])
                            pvl <- cor.test(x[,i], x[,j], method = type)
                            
                            if (input$method == "Kendall") {
                                # [Kendall CI] http://www.stat.umn.edu/geyer/5601/examp/corr.html
                                conf.level <- 0.95
                                signs <- sign(outer(x[,i], x[,i], "-") * outer(x[,j], x[,j], "-"))
                                tau <- mean(signs[lower.tri(signs)])
                                cvec <- apply(signs, 1, sum)
                                nn <- length(cvec)
                                sigsq <- (2 / (nn * (nn - 1))) *
                                    (((2 * (nn - 2)) / (nn * (nn - 1))) * var(cvec)
                                    + 1 - tau^2)
                                zcrit <- qnorm((1 + conf.level) / 2)
                                ci <- tau + c(-1, 1) * zcrit * sqrt(sigsq)

                            } else {
                                ci <- round(r.con(r, n), 3)
                                # [Spearman CI] http://www.statsdirect.com/help/default.htm#nonparametric_methods/spearman.htm
                            }
                            
                                if (input$method == "Pearson") {
                                    cortype <- c("Pearson's r =")
                                } else if (input$method == "Spearman") {
                                    cortype <- c("Spearman's ρ =")
                                } else {
                                    cortype <- c("Kendall's τ =")
                                }
                            
                            cat("----------", "\n", 
                            "Correlation between", colnames(x)[i], "&", colnames(x)[j], ":", "\n",
                            cortype, round(r, 3), "\n",
                            "95% CI [lower, upper] =", round(ci, 3), "\n",
                            "p-value =", round(pvl$p.value, 3), "\n",
                            "\n")
                        }
                    }
                }
            }

            ci.all(x)

    })

    output$ci.out <- renderPrint({
        ci()
    })



    makecorPlot <- function(){
        if (input$colname == 0) {
            x <- read.table(text=input$text, sep="", na.strings=c("","NA","."))
            x <- as.matrix(x)

            type <- switch(input$method,
                        Pearson = "pearson",
                        Spearman = "spearman",
                        Kendall = "kendall")

            pairs.panels(x, method = type)

        } else {
            x <- read.csv(text=input$text, sep="", na.strings=c("","NA","."))

            type <- switch(input$method,
                        Pearson = "pearson",
                        Spearman = "spearman",
                        Kendall = "kendall")

            pairs.panels(x, method = type)
        }
    }

    output$corPlot <- renderPlot({
        print(makecorPlot())
    })



    info <- reactive({
        info1 <- paste("This analysis was conducted with ", strsplit(R.version$version.string, " \\(")[[1]][1], ".", sep = "")
        info2 <- paste("It was executed on ", date(), ".", sep = "")
        cat(sprintf(info1), "\n")
        cat(sprintf(info2), "\n")
    })

    output$info.out <- renderPrint({
        info()
    })


})

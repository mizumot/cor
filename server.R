library(shiny)
library(shinyAce)
library(psych)


shinyServer(function(input, output) {


    bs <- reactive({
        if (input$colname == 0) {
            x <- read.table(text=input$text, sep="\t")
            x <- as.matrix(x)
            describe(x)[2:13]
        } else {
            x <- read.csv(text=input$text, sep="\t")
            describe(x)[2:13]
        }
    })
    
    
    correl <- reactive({
        
        if (input$colname == 0) {
            x <- read.table(text=input$text, sep="\t")
            x <- as.matrix(x)
            
            type <- switch(input$method,
                           Pearson = "pearson",
                           Spearman = "spearman",
                           Kendall = "kendall")
            
            round(cor(cbind(x), method = type),3)
            
        } else {
            x <- read.csv(text=input$text, sep="\t")
            
            type <- switch(input$method,
                           Pearson = "pearson",
                           Spearman = "spearman",
                           Kendall = "kendall")
            
            round(cor(cbind(x), method = type),3)
        }
    })
    
    
    
    makecorPlot <- function(){
        if (input$colname == 0) {
            x <- read.table(text=input$text, sep="\t")
            x <- as.matrix(x)
            
            type <- switch(input$method,
            Pearson = "pearson",
            Spearman = "spearman",
            Kendall = "kendall")
            
            pairs.panels(x, method = type)
            
        } else {
            x <- read.csv(text=input$text, sep="\t")
            
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
        info1 <- paste("This analysis was conducted with ", strsplit(R.version$version.string, " \\(")[[1]][1], ".", sep = "")# バージョン情報
        info2 <- paste("It was executed on ", date(), ".", sep = "")# 実行日時
        cat(sprintf(info1), "\n")
        cat(sprintf(info2), "\n")
    })
    
    output$info.out <- renderPrint({
        info()
    })



    output$textarea.out <- renderPrint({
        bs()
    })

    output$correl.out <- renderPrint({
        correl()
    })
    
    output$downloadCorPlot <- downloadHandler(
    filename = function() {
        paste('Corplot-', Sys.Date(), '.pdf', sep='')
    },
    content = function(FILE=NULL) {
        pdf(file=FILE)
		print(makecorPlot())
		dev.off()
	})

    

})

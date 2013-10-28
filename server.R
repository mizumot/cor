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
    
    
    output$corPlot <- renderPlot({
       
       
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
    })
    







    output$textarea.out <- renderPrint({
        bs()
    })

    output$correl.out <- renderPrint({
        correl()
    })
    

})

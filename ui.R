library(shiny)
library(shinyAce)



shinyUI(bootstrapPage(

    headerPanel("Correlation"),

########## Adding loading message #########

tags$head(tags$style(type="text/css", "
#loadmessage {
position: fixed;
top: 0px;
left: 0px;
width: 100%;
padding: 10px 0px 10px 0px;
text-align: center;
font-weight: bold;
font-size: 100%;
color: #000000;
background-color: #CCFF66;
z-index: 105;
}
")),

conditionalPanel(condition="$('html').hasClass('shiny-busy')",
tags$div("Loading...",id="loadmessage")),

########## Added up untill here ##########

    mainPanel(
        tabsetPanel(

        tabPanel("Main",

            strong('Option:'),

            checkboxInput("colname", label = strong("The data includes variable names in the 1st row."), value = T),

            br(),

            p('Note: Input values must be separated by tabs. Copy and paste from Excel/Numbers.'),

            p(HTML("<b><div style='background-color:#FADDF2;border:1px solid black;'>Missing values should be indicated by a period (.) or NA.</div></b>")),

            aceEditor("text", value="Test.A\tTest.B\n67\t70\n56\t68\n55\t66\n89\t77\n90\t100\n92\t60\n44\t55\n36\t44\n88\t76\n47\t55\n44\t45\n46\t88\n90\t88\n88\t78\n77\t89\n21\t33\n78\t87\n80\t67\n66\t87\n44\t57",
                mode="r", theme="terminal"),

            br(),

            h3("Basic statistics"),
            verbatimTextOutput("textarea.out"),

            br(),

            h3("Box plots with individual data points"),

            plotOutput("boxPlot", width="80%"),

            br(),

            h3("Correlation"),

            radioButtons("method", "Check the type of correlation coefficients:",
                        list("Pearson product-moment correlation coefficient" = "Pearson",
                             "Spearman's rank correlation coefficient (Spearman's rho)" = "Spearman",
                             "Kendall tau rank correlation coefficient (Kendall's tau)" = "Kendall")),

            verbatimTextOutput("correl.out"),

            br(),

            h4("95% confidence interval (CI)"),
            verbatimTextOutput("ci.out"),

            br(),

            h3("Scatter plot matrices"),

            plotOutput("corPlot"),

            br(),
            br(),

            strong('R session info'),
            verbatimTextOutput("info.out")

            ),


        tabPanel("About",

            strong('Note'),
            p('This web application is developed with',
            a("Shiny.", href="http://www.rstudio.com/shiny/", target="_blank"),
            ''),

            br(),

            strong('List of Packages Used'), br(),
            code('library(shiny)'),br(),
            code('library(shinyAce)'),br(),
            code('library(psych)'),br(),
            code('library(beeswarm)'),br(),

            br(),

            strong('Code'),
            p('Source code for this application is based on',
            a('"The handbook of Research in Foreign Language Learning and Teaching" (Takeuchi & Mizumoto, 2012).', href='http://mizumot.com/handbook/', target="_blank")),

            p('The code for this web application is available at',
            a('GitHub.', href='https://github.com/mizumot/cor', target="_blank")),

            p('If you want to run this code on your computer (in a local R session), run the code below:',
            br(),
            code('library(shiny)'),br(),
            code('runGitHub("cor","mizumot")')
            ),

            br(),

            strong('Citation in Publications'),
            p('Mizumoto, A. (2015). Langtest (Version 1.0) [Web application]. Retrieved from http://langtest.jp'),

            br(),

            strong('Article'),
            p('Mizumoto, A., & Plonsky, L. (2015).', a("R as a lingua franca: Advantages of using R for quantitative research in applied linguistics.", href='http://applij.oxfordjournals.org/content/early/2015/06/24/applin.amv025.abstract', target="_blank"), em('Applied Linguistics,'), 'Advance online publication. doi:10.1093/applin/amv025'),

            br(),

            strong('Recommended'),
            p('To learn more about R, I suggest this excellent and free e-book (pdf),',
            a("A Guide to Doing Statistics in Second Language Research Using R,", href="http://cw.routledge.com/textbooks/9780805861853/guide-to-R.asp", target="_blank"),
            'written by Dr. Jenifer Larson-Hall.'),

            p('Also, if you are a cool Mac user and want to use R with GUI,',
            a("MacR", href="http://www.urano-ken.com/blog/2013/02/25/installing-and-using-macr/", target="_blank"),
            'is defenitely the way to go!'),

            br(),

            strong('Author'),
            p(a("Atsushi MIZUMOTO,", href="http://mizumot.com", target="_blank"),' Ph.D.',br(),
            'Associate Professor of Applied Linguistics',br(),
            'Faculty of Foreign Language Studies /',br(),
            'Graduate School of Foreign Language Education and Research,',br(),
            'Kansai University, Osaka, Japan'),

            br(),

            a(img(src="http://i.creativecommons.org/p/mark/1.0/80x15.png"), target="_blank", href="http://creativecommons.org/publicdomain/mark/1.0/"),

            p(br())

            )

))
))
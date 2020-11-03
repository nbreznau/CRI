library(shiny)
library(ggplot2)
library(rdfanalysis)
library(dplyr)
library(shinyjs)

# cntrlist and wavelist

cntrlista <- c("AU", "AT", "BE", "CA", "CL", "HR", "CZ", "DK", "FI", "FR", "DE")
cntrlistb <- c("HU", "IE", "IL", "IT", "JP", "KR", "LV", "LT", "NT", "NZ", "NO")
cntrlistc <- c("PL", "PT","RU", "SK", "SI", "ES", "SE", "CH", "UK", "US", "UY")
wavelist <- c("w1985","w1990","w1996","w2006","w2016")


dropdownButton <- function(label = "", status = c("default", "primary", "success", "info", "warning", "danger"), ..., width = "100%") {
  
  status <- match.arg(status)
  # dropdown button content
  html_ul <- list(
    class = "dropdown-menu",
    style = if (!is.null(width)) 
      paste0("width: ", validateCssUnit(width), ";"),
    lapply(X = list(...), FUN = tags$li, style = "margin-left: 10px; margin-right: 10px;")
  )
  # dropdown button apparence
  html_button <- list(
    class = paste0("btn btn-", status," dropdown-toggle"),
    type = "button", 
    `data-toggle` = "dropdown"
  )
  html_button <- c(html_button, list(label))
  html_button <- c(html_button, list(tags$span(class = "caret")))
  # final result
  tags$div(
    class = "dropdown",
    do.call(tags$button, html_button),
    do.call(tags$ul, html_ul),
    tags$script(
      "$('.dropdown-menu').click(function(e) {
      e.stopPropagation();
});")
  )
}

ui <- fluidPage(
  useShinyjs(),
  tags$style(HTML("#title {font-size: 22px; line-height: 22px; margin: 12px 0}")),
  h1(id = "title", "The Effect of Immigration on Social Policy Preferences", align = "center"),
  tags$style(HTML("#subtitle {font-size: 20px; line-height: 20px; color: #3E3673; margin: 12px 0}")),
  h1(id = "subtitle", "Interactive Appendix of 1,292 Model Specifications from 73 Crowdsourced Research Teams", align = "center"),
  tags$hr(style="border-color: black;"),
  hr(),
  fluidRow(
    mainPanel(
      div(id = "reset",
      tabsetPanel(
        type = "tabs",
        tabPanel("Specification curve - AME", plotOutput("spec_curve"), 
                 fluidRow( #first fluid row
                   column(3,
                          h6(em("In the figure above:"))),
                   column(3,
                          tags$style(HTML("#ret {font-size: 11px; line-height: 11px; color: #e60000}")),
                          h6(id = "ret", strong("Red = significant negative"))),
                   column(3,
                          tags$style(HTML("#grr {font-size: 11px; line-height: 11px; color: #808080}")),
                          h6(id = "grr", strong("Gray = non-significant"))),
                   column(3,
                          tags$style(HTML("#blu {font-size: 11px; line-height: 11px; color: #0000ff}")),
                          h6(id = "blu", strong("Blue = significant positive")))), ## end of first fluid row   
                 hr(),
                 fluidRow( #second fluid row 
                   column(3, 
                          h5(strong("Specification Summary"), style={'margin:11px 0;'}),
                          h5(textOutput("teamn"), style={'margin:9px 0;'}), 
                          h5(textOutput("pr"), style={'margin:15px 0;'})
                   ),
                   column(3, 
                          dropdownButton(label = h5("Dependent Variables"), status = "default", 
                                         checkboxGroupInput(
                                           inputId = "mspecdv",
                                           label = "Questions Used <government should>:", 
                                           choices = list("Provide Jobs" = "Jobs",
                                                          "Income Equality" = "IncDiff",
                                                          "Unemployment" = "Unemp",
                                                          "Old Age Care" = "OldAge",
                                                          "Housing" = "House",
                                                          "Health Care" = "Health",
                                                          "*Include scales" = "Scaled"),
                                           selected = c("Jobs", "IncDiff","Unemp","OldAge","House","Health","Scaled"))),
                          hr(),
                          dropdownButton(label = h5("Immigration Measures"), status = "default", 
                                         checkboxGroupInput(
                                           inputId = "mspeciv",
                                           label = "% Foreign-Born as:", 
                                           choices = list("Stock" = "Stock", 
                                                          "Flow" = "Flow",
                                                          "Change in Flow" = "ChangeFlow"),
                                           selected = c("Stock","Flow","ChangeFlow")
                                         )),
                          hr(),
                          dropdownButton(label = h5("Country-Level Controls"), status = "default", width = 80,
                                         checkboxGroupInput(
                                           inputId = "mspecivx",
                                           label = NULL,
                                           choices = list("Social Spending (%GDP)" = "Soc_Spending",
                                                          "Unemployment Rate" = "Unemp_Rate",
                                                          "Employment Rate" = "Emp_Rate",
                                                          "GDP per Capita" = "GDP_Per_Capita",
                                                          "Combination" = "Combo",
                                                          "None" = "None"),
                                           selected = c("Soc_Spending","Unemp_Rate","Emp_Rate","GDP_Per_Capita",
                                                        "None", "Combo")
                                         )),
                          hr(),
                          dropdownButton(label = h5("Topical Knowledge"), status = "default", width = 80,
                                         checkboxGroupInput(    
                                             inputId = "topic",
                                             label = ("Level of Topical Knowledge"),
                                             choices = list("Low" = "Low",
                                                            "Mid" = "Mid",
                                                            "High" = "High",
                                                            "No Information" = "No Information"),
                                             selected = c("Low","Mid","High", "No Information")
                                         )
                          ),
                          hr()
                   ),                 
                   column(3,
                          div( id = "cntry",
                            dropdownButton(label = h5("Countries Included"), status = "default", tags$label("Must include:"),
                                         fluidRow(
                                           column(width=12,
                                                  actionButton(
                                                    label = "Choose all",
                                                    inputId = "any")
                                           )),
                                         fluidRow(
                                           column(width=3,
                                                  checkboxGroupInput(
                                                    label = NULL,
                                                    inputId = "countries1a",
                                                    choices = list("AU", "AT", "BE", "CA", "CL", "HR", "CZ", "DK", "FI", "FR", "DE"),
                                                    selected = cntrlista)
                                           ),
                                           column(width=3,
                                                  checkboxGroupInput(
                                                    label = NULL,
                                                    inputId = "countries1b",
                                                    choices = list("HU", "IE", "IL", "IT", "JP", "KR", "LV", "LT", "NT", "NZ", "NO"),
                                                    selected = cntrlistb)
                                           ),
                                           column(width=3,
                                                  checkboxGroupInput(
                                                    label = NULL,
                                                    inputId = "countries1c",
                                                    choices = list( "PL", "PT", "RU", "SK", "SI", "ES", "SE", "CH", "UK", "US", "UY"),
                                                    selected = cntrlistc)
                                           )
                                         )    
                          )),
                          hr(),
                          div( id = "wave", 
                            dropdownButton(label = h5("Survey waves"), status = "default", tags$label("Must include:"),
                                         fluidRow(
                                           column(width=12,
                                                  actionButton(
                                                    inputId = "many",
                                                    label = "Choose all")
                                           ),
                                           column(width=12,       
                                                  checkboxGroupInput(
                                                    inputId = "mwave",
                                                    label = NULL,
                                                    choices = list("1985" = "w1985",
                                                                   "1990" = "w1990",
                                                                   "1996" = "w1996",
                                                                   "2006" = "w2006",
                                                                   "2016" = "w2016"),
                                                    selected = wavelist)
                                           ),
                                         ))),
                          hr(),
                          dropdownButton(label = h5("Estimator"), status = "default", width = 80,
                                         checkboxGroupInput(    
                                             inputId = "emator",
                                             label = ("Choose estimators"),
                                             choices = list("OLS" = "ols",
                                                            "Logit" = "logit",
                                                            "O.Logit" = "ologit",
                                                            "GLM" = "ml_glm",
                                                            "Bayes" = "bayes"),
                                             selected = c("ols","logit","ologit","ml_glm","bayes")
                                                            )
                                         ),
                          hr(),
                          dropdownButton(label = h5("Total score"), status = "default", width = 80,
                                         checkboxGroupInput(    
                                             inputId = "total",
                                             label = ("Choose total score"),
                                             choices = list("Low" = "Low",
                                                            "Mid" = "Mid",
                                                            "High" = "High",
                                                            "No Information" = "No Information"),
                                             selected = c("Low","Mid","High", "No Information")
                                         )
                          ),
                          hr()
                          ),
                   column(3,
                          dropdownButton(label = h5("Other"), status = "default", width = 80,
                                         fluidRow(
                                           column(width=12,
                                                  checkboxGroupInput( 
                                                    inputId = "clust",
                                                    label = "Clustered S.E.",
                                                    choices = list("Yes" = "Yes",
                                                                   "No" = "No"),
                                                    selected = c("Yes","No"))
                                           ),
                                           column(width=12,
                                                  checkboxGroupInput( 
                                                    inputId = "twoway",
                                                    label = "\'Two-Way FE\'",
                                                    choices = list("Yes" = "Yes",
                                                                   "No" = "No"),
                                                    selected = c("Yes","No"))
                                           ),  
                                           column(width=12,
                                                  checkboxGroupInput( 
                                                    inputId = "dv_m",
                                                    label = "Dichotomized DV",
                                                    choices = list("Yes" = "Yes",
                                                                   "No" = "No"),
                                                    selected = c("Yes","No"))
                                           )
                                         )
                          ),
                          hr(),
                          dropdownButton(label = h5("Belief that H is true"), status = "default", width = 80,
                                         checkboxGroupInput(    
                                             inputId = "belief",
                                             label = ("Level of belief"),
                                             choices = list("Low" = "Low",
                                                            "Mid" = "Mid",
                                                            "High" = "High",
                                                            "No Information" = "No Information"),
                                             selected = c("Low","Mid","High", "No Information")
                                                            )
                                         ),
                          hr(),
                          dropdownButton(label = h5("Statistical Knowledge"), status = "default", width = 80,
                                         checkboxGroupInput(    
                                             inputId = "stat",
                                             label = ("Level of Statistical Knowledge"),
                                             choices = list("Low" = "Low",
                                                            "Mid" = "Mid",
                                                            "High" = "High",
                                                            "No Information" = "No Information"),
                                             selected = c("Low","Mid","High", "No Information")
                                         )
                          ),
                          hr(),
                          dropdownButton(label = h5("Pro-Immigration"), status = "default", width = 80,
                                         checkboxGroupInput(    
                                             inputId = "proimm",
                                             label = ("Level of Pro-Immigration"),
                                             choices = list("Low" = "Low",
                                                            "Mid" = "Mid",
                                                            "High" = "High",
                                                            "No Information" = "No Information"),
                                             selected = c("Low","Mid","High", "No Information")
                                         )
                          ),
                          hr()
                        )
                 ) ## end of second fluid row
        ),## end of first tab panel - spec_curve
        tabPanel("P-values", plotOutput("p_val"),
                 fluidRow( #first fluid row
                   column(3,
                          h6(em("In the figure above:"))),
                   column(3,
                          tags$style(HTML("#grr {font-size: 11px; line-height: 11px; color: #808080}")),
                          h6(id = "grr", strong("Gray = non-significant"))),
                   column(3,
                          tags$style(HTML("#blu {font-size: 11px; line-height: 11px; color: #0000ff}")),
                          h6(id = "blu", strong("Blue = significant")))), ## end of first fluid row   
                 hr(),
                 fluidRow( #second fluid row
                   column(3, 
                          h5(strong("Specification Summary"), style={'margin:11px 0;'}),
                          h5(textOutput("teamn2"), style={'margin:9px 0;'}), 
                          h5(textOutput("pr2"), style={'margin:15px 0;'})
                   ),
                   column(3, 
                          dropdownButton(label = h5("Dependent Variables"), status = "default", 
                                         checkboxGroupInput(
                                           inputId = "mspecdv2",
                                           label = "Questions Used <government should>:", 
                                           choices = list("Provide Jobs" = "Jobs",
                                                          "Income Equality" = "IncDiff",
                                                          "Unemployment" = "Unemp",
                                                          "Old Age Care" = "OldAge",
                                                          "Housing" = "House",
                                                          "Health Care" = "Health",
                                                          "*Include scales" = "Scaled"),
                                           selected = c("Jobs", "IncDiff","Unemp","OldAge","House","Health","Scaled"))),
                          hr(),
                          dropdownButton(label = h5("Immigration Measures"), status = "default", 
                                         checkboxGroupInput(
                                           inputId = "mspeciv2",
                                           label = "% Foreign-Born as:", 
                                           choices = list("Stock" = "Stock", 
                                                          "Flow" = "Flow",
                                                          "Change in Flow" = "ChangeFlow"),
                                           selected = c("Stock","Flow","ChangeFlow")
                                         )),
                          hr(),
                          dropdownButton(label = h5("Country-Level Controls"), status = "default", width = 80,
                                         checkboxGroupInput(
                                           inputId = "mspecivx2",
                                           label = NULL,
                                           choices = list("Social Spending (%GDP)" = "Soc_Spending",
                                                          "Unemployment Rate" = "Unemp_Rate",
                                                          "Employment Rate" = "Emp_Rate",
                                                          "GDP per Capita" = "GDP_Per_Capita",
                                                          "Combination" = "Combo",
                                                          "None" = "None"),
                                           selected = c("Soc_Spending","Unemp_Rate","Emp_Rate","GDP_Per_Capita",
                                                        "None", "Combo")
                                         )),
                          hr(),
                          dropdownButton(label = h5("Topical Knowledge"), status = "default", width = 80,
                                         checkboxGroupInput(    
                                           inputId = "topic2",
                                           label = ("Level of Topical Knowledge"),
                                           choices = list("Low" = "Low",
                                                          "Mid" = "Mid",
                                                          "High" = "High",
                                                          "No Information" = "No Information"),
                                           selected = c("Low","Mid","High", "No Information")
                                         )
                          ),
                          hr()
                   ),                 
                   column(3,
                          div(id = "cntry2",
                            dropdownButton(label = h5("Countries Included"), status = "default", tags$label("Must include:"),
                                         fluidRow(
                                           column(width=12,
                                                  actionButton(
                                                    label = "Choose all",
                                                    inputId = "any2")
                                           )),
                                         fluidRow(
                                           column(width=3,
                                                  checkboxGroupInput(
                                                    label = NULL,
                                                    inputId = "countries2a",
                                                    choices = list("AU", "AT", "BE", "CA", "CL", "HR", "CZ", "DK", "FI", "FR", "DE"),
                                                    selected = cntrlista)
                                           ),
                                           column(width=3,
                                                  checkboxGroupInput(
                                                    label = NULL,
                                                    inputId = "countries2b",
                                                    choices = list("HU", "IE", "IL", "IT", "JP", "KR", "LV", "LT", "NT", "NZ", "NO"),
                                                    selected = cntrlistb)
                                           ),
                                           column(width=3,
                                                  checkboxGroupInput(
                                                    label = NULL,
                                                    inputId = "countries2c",
                                                    choices = list( "PL", "PT", "RU", "SK", "SI", "ES", "SE", "CH", "UK", "US", "UY"),
                                                    selected = cntrlistc)
                                           )
                                         )    
                          )),
                          hr(),
                          div( id = "wave2",
                            dropdownButton(label = h5("Survey waves"), status = "default", tags$label("Must include:"),
                                         fluidRow(
                                           column(width=12,
                                                  actionButton(
                                                    inputId = "many2",
                                                    label = "Choose all")
                                           ),
                                           column(width=12,       
                                                  checkboxGroupInput(
                                                    inputId = "mwave2",
                                                    label = NULL,
                                                    choices = list("1985" = "w1985",
                                                                   "1990" = "w1990",
                                                                   "1996" = "w1996",
                                                                   "2006" = "w2006",
                                                                   "2016" = "w2016"),
                                                    selected = wavelist)
                                           ),
                                         ))),
                          hr(),
                          dropdownButton(label = h5("Estimator"), status = "default", width = 80,
                                         checkboxGroupInput(    
                                           inputId = "emator2",
                                           label = ("Choose estimators"),
                                           choices = list("OLS" = "ols",
                                                          "Logit" = "logit",
                                                          "O.Logit" = "ologit",
                                                          "GLM" = "ml_glm",
                                                          "Bayes" = "bayes"),
                                           selected = c("ols","logit","ologit","ml_glm","bayes")
                                         )
                          ),
                          hr(),
                          dropdownButton(label = h5("Total score"), status = "default", width = 80,
                                         checkboxGroupInput(    
                                           inputId = "total2",
                                           label = ("Choose total score"),
                                           choices = list("Low" = "Low",
                                                          "Mid" = "Mid",
                                                          "High" = "High",
                                                          "No Information" = "No Information"),
                                           selected = c("Low","Mid","High", "No Information")
                                         )
                          ),
                          hr()
                   ),
                   column(3,
                          dropdownButton(label = h5("Other"), status = "default", width = 80,
                                         fluidRow(
                                           column(width=12,
                                                  checkboxGroupInput( 
                                                    inputId = "clust2",
                                                    label = "Clustered S.E.",
                                                    choices = list("Yes" = "Yes",
                                                                   "No" = "No"),
                                                    selected = c("Yes","No"))
                                           ),
                                           column(width=12,
                                                  checkboxGroupInput( 
                                                    inputId = "twoway2",
                                                    label = "\'Two-Way FE\'",
                                                    choices = list("Yes" = "Yes",
                                                                   "No" = "No"),
                                                    selected = c("Yes","No"))
                                           ),  
                                           column(width=12,
                                                  checkboxGroupInput( 
                                                    inputId = "dv_m2",
                                                    label = "Dichotomized DV",
                                                    choices = list("Yes" = "Yes",
                                                                   "No" = "No"),
                                                    selected = c("Yes","No"))
                                           )
                                         )
                          ),
                          hr(),
                          dropdownButton(label = h5("Belief that H is true"), status = "default", width = 80,
                                         checkboxGroupInput(    
                                           inputId = "belief2",
                                           label = ("Level of belief"),
                                           choices = list("Low" = "Low",
                                                          "Mid" = "Mid",
                                                          "High" = "High",
                                                          "No Information" = "No Information"),
                                           selected = c("Low","Mid","High", "No Information")
                                         )
                          ),
                          hr(),
                          dropdownButton(label = h5("Statistical Knowledge"), status = "default", width = 80,
                                         checkboxGroupInput(    
                                           inputId = "stat2",
                                           label = ("Level of Statistical Knowledge"),
                                           choices = list("Low" = "Low",
                                                          "Mid" = "Mid",
                                                          "High" = "High",
                                                          "No Information" = "No Information"),
                                           selected = c("Low","Mid","High", "No Information")
                                         )
                          ),
                          hr(),
                          dropdownButton(label = h5("Pro-Immigration"), status = "default", width = 80,
                                         checkboxGroupInput(    
                                           inputId = "proimm2",
                                           label = ("Level of Pro-Immigration"),
                                           choices = list("Low" = "Low",
                                                          "Mid" = "Mid",
                                                          "High" = "High",
                                                          "No Information" = "No Information"),
                                           selected = c("Low","Mid","High", "No Information")
                                         )
                          ),
                          hr()
                   )
                 ) 
        ), ## second tab, p_bar
        tabPanel("Hypothesis testing", plotOutput("subject"),
                 fluidRow( #first fluid row
                   column(3,
                          h6(em("In the figure above:"))),
                   column(3,
                          tags$style(HTML("#ret {font-size: 11px; line-height: 11px; color: #e60000}")),
                          h6(id = "ret", strong("Red = H-reject"))),
                   column(3,
                          tags$style(HTML("#grr {font-size: 11px; line-height: 11px; color: #808080}")),
                          h6(id = "grr", strong("Gray = H-notest"))),
                   column(3,
                          tags$style(HTML("#blu {font-size: 11px; line-height: 11px; color: #0000ff}")),
                          h6(id = "blu", strong("Blue = H-support")))), ## end of first fluid row   
                 hr(),
                 fluidRow( #second fluid row
                   column(3, 
                          h5(strong("Specification Summary"), style={'margin:11px 0;'}),
                          h5(textOutput("teamn3"), style={'margin:9px 0;'}), 
                          h5(textOutput("pr3"), style={'margin:15px 0;'})
                   ),
                   column(3, 
                          dropdownButton(label = h5("Belief that H is true"), status = "default", width = 80,
                                         checkboxGroupInput(    
                                           inputId = "belief3",
                                           label = ("Level of belief"),
                                           choices = list("Low" = "Low",
                                                          "Mid" = "Mid",
                                                          "High" = "High"),
                                           selected = c("Low","Mid","High")
                                         )
                          ),
                          hr(),
                          dropdownButton(label = h5("Statistical Knowledge"), status = "default", width = 80,
                                         checkboxGroupInput(    
                                           inputId = "stat3",
                                           label = ("Level of Statistical Knowledge"),
                                           choices = list("Low" = "Low",
                                                          "Mid" = "Mid",
                                                          "High" = "High"),
                                           selected = c("Low","Mid","High")
                                         )
                          ),
                          hr()
                   ),                 
                   column(3,
                          dropdownButton(label = h5("Total score"), status = "default", width = 80,
                                         checkboxGroupInput(    
                                           inputId = "total3",
                                           label = ("Choose total score"),
                                           choices = list("Low" = "Low",
                                                          "Mid" = "Mid",
                                                          "High" = "High"),
                                           selected = c("Low","Mid","High")
                                         )
                          ),
                          hr(),
                          dropdownButton(label = h5("Topical Knowledge"), status = "default", width = 80,
                                         checkboxGroupInput(    
                                           inputId = "topic3",
                                           label = ("Level of Topical Knowledge"),
                                           choices = list("Low" = "Low",
                                                          "Mid" = "Mid",
                                                          "High" = "High"),
                                           selected = c("Low","Mid","High")
                                         )
                          ),
                          hr()
                        ),
                   column(3,
                          dropdownButton(label = h5("Pro-Immigration"), status = "default", width = 80,
                                         checkboxGroupInput(    
                                           inputId = "proimm3",
                                           label = ("Level of Pro-Immigration"),
                                           choices = list("Low" = "Low",
                                                          "Mid" = "Mid",
                                                          "High" = "High"),
                                           selected = c("Low","Mid","High")
                                         )
                          ),
                          hr(),
                          dropdownButton(label = h5("Immigration Measures"), status = "default", 
                                         checkboxGroupInput(
                                           inputId = "mspeciv3",
                                           label = "% Foreign-Born as:", 
                                           choices = list("Stock" = "Stock", 
                                                          "Flow" = "Flow"),
                                           selected = c("Stock","Flow")
                                         )),
                          hr()
                   )
                  )
                 
        ) ## third tab, subjective conclusion
      )## end of tabset panel
    )), ### end of mainpanel  
    
    fluidRow(
      tags$style(type='text/css', ".selectize-input { font-size: 11.5px; line-height: 11.5px;} 
                    .selectize-dropdown { font-size: 11.5px; line-height: 11.5px; }"), 
      column(3, 
             h6("_______________________", style={'margin:10px 0;'}),
             h6(strong("Notes for Users"), style={'margin:10px 0;'}),
             h6("1> Interactive Appendix for", style={'margin:1.5px 0;'}),
             h6(uiOutput("exec"), style={'margin:1.5px 0;'}),
             h6("2> Select specifications using dropdown menus", style={'margin:1.5px 0;'}),
             h6("3> Design: Nate Breznau & Hung H.V. Nguyen, ", style={'margin:1.5px 0;'}),
             h6("University of Bremen, breznau.nate@gmail.com", style={'margin:1.5px 0;'}),
             h6("_______________________", style={'margin:10px 0;'}),
             actionButton("resetAll", "Reset All")
             )
    )
  )
)

# deployApp(appDir = paste(getwd(),"/CRI_shiny",sep=""))

library(shiny)
library(ggplot2)
library(tidyverse)
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
  h1(id = "title", "The Hidden Universe of Data Analysis", align = "center"),
  tags$style(HTML("#subtitle {font-size: 20px; border-bottom: 2px solid silver; line-height: 20px; color: #3E3673; margin: 12px 0; padding-bottom: 8px}")),
  h1(id = "subtitle", "One Dataset, One Hypothesis, 73 Teams, 1,253 Models and 88 Conclusions", align = "center"),
  tags$hr(style="border-color: black;"),
  
  # FIRST MAIN COLUMN  
  div(
    tabsetPanel(
      type = "tabs",
      
      ## FIRST TAB PANEL        
      tabPanel("EFFECTS", 
               fluidRow(
                 column(9, style={'height: 500px; border-left: 1px solid silver; border-bottom: 1px solid silver; border-top: 1px solid silver'},
                        plotOutput("spec_curve")),
                 column(3, style = {'height:500px; border-left: 1px solid silver; border-right: 1px solid silver; border-top: 1px solid silver; border-bottom: 1px solid silver'},
                        fluidRow(
                          h5("Now Displaying", style={'padding: 4px; font-size: 14px; text-align:center; background-color:#D3D3D3'}),
                          column(6, style={'border-right: 1px solid silver;'},
                                 h6(strong(textOutput("modeln")), style={'font-size: 20px; text-align:center; padding-top: 4px'}), 
                                 h6("of 1,253 models", style={'margin:1.5px 0; text-align:center; padding: 2px; padding-bottom: 10px;'})),
                          column(6,
                                 h6(strong(textOutput("teamn")), style={'font-size: 20px; text-align:center; padding-top: 4px'}),
                                 h6("of 73 teams*", style={'margin:1.5px 0; text-align:center; padding: 2px; padding-bottom: 10px;'}))),
                        fluidRow(
                          h5("Empirical Summary", style={'padding-top: 6px; font-size: 14px; text-align:center; background-color:#D3D3D3'}),
                          h6(strong(textOutput("signeg")), style={'color: #66A61E;font-size: 18px; text-align:center; padding-top: 3px'}), 
                          h6("had negative effects at 95% CI", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                          h6("(weighted by models per team)", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                          h6(strong(textOutput("sigpos")), style={'color: #D95F02; font-size: 18px; text-align:center; padding-top: 6px'}), 
                          h6("had positive effects at 95% CI", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                          h6("(weighted by models per team)", style={'margin:1.5px 0; text-align:center; padding: 2px; padding-bottom: 10px;'})),
                        fluidRow(
                          h5("Team Conclusions", style={'padding-top: 6px; font-size: 14px; text-align:center; background-color:#D3D3D3'}),
                          column(6, style={'border-right: 1px solid silver;'},
                                 h6(strong(textOutput("hsupp")), style={'color: #66A61E;font-size: 18px; text-align:center; padding-top: 6px'}), 
                                 h6("support", style={'margin:1.5px 0; text-align:center; padding: 2px; padding-bottom: 10px;'})),
                          column(6,
                                 h6(strong(textOutput("hreje")), style={'color: #D95F02; font-size: 18px; text-align:center; padding-top: 6px'}), 
                                 h6("reject**", style={'margin:1.5px 0; text-align:center; padding: 2px; padding-bottom: 10px;'}))),

                        br(),
                        h6("*Two teams had no results, one lacked convergence and other failed measurement invariance", style={'margin:1px 0; font-size: 9px'}),
                        h6("**If not support or reject, the remainder concluded it was 'not testable' with these data", style={'margin:1px 0; font-size: 9px'}),
                        
                 )
               ), ## first fluidRow
               br(),
               fluidRow( 
                 h5("Filter models by research design and team characteristics"), style = {'text-align: center; padding: 8px; background-color:#4682B433'}
               ), ## end of second fluidRow
               
               fluidRow(id = "reset", 
                        column(3, style = {'height:400px; border-left: 1px solid silver; border-top: 1px solid silver; border-bottom: 1px solid silver'},
                               br(),
                               dropdownButton(label = h5("Dependent Variable"), status = "default", 
                                              checkboxGroupInput(
                                                inputId = "mspecdv",
                                                label = "Questions Used <government should>:", 
                                                choices = list("Provide Jobs" = "Jobs",
                                                               "Income Equality" = "IncDiff",
                                                               "Unemployment" = "Unemp",
                                                               "Old Age Care" = "OldAge",
                                                               "Housing" = "House",
                                                               "Health Care" = "Health",
                                                               "(Multi-Item Scale)" = "Scaled"),
                                                selected = c("Jobs", "IncDiff","Unemp","OldAge","House","Health","Scaled")
                                              )),
                               br(),
                               dropdownButton(label = h5("Test Variable"), status = "default", 
                                              checkboxGroupInput(
                                                inputId = "mspeciv",
                                                label = "Immigration measured as:", 
                                                choices = list("Stock" = "Stock", 
                                                               "Flow" = "Flow",
                                                               "Change in Flow" = "ChangeFlow",
                                                               "Stock & Flow Together" = "StockFlow"),
                                                selected = c("Stock","Flow","ChangeFlow", "StockFlow")
                                              )),
                               br(),
                               dropdownButton(label = h5("Independent Variables"), status = "default", width = 80,
                                              checkboxGroupInput(
                                                inputId = "mspecivx",
                                                label = "Country-level 'controls'",
                                                choices = list("Social Spending)" = "Soc_Spending",
                                                               "(Un)employment Rate" = "Unemp_Rate",
                                                               "GDP per Capita" = "GDP_Per_Capita",
                                                               "Gini" = "Gini",
                                                               "None of Above" = "None"),
                                                selected = c("Soc_Spending","Unemp_Rate","Gini","GDP_Per_Capita",
                                                             "None")
                                              ))),
                        column(3, style = {'height:400px; border-top: 1px solid silver; border-bottom: 1px solid silver'},
                               br(),
                               div( id = "cntry",
                                    dropdownButton(label = h5("Country Sample"), status = "default", tags$label("Must Include:"),
                                                   fluidRow(
                                                     column(width=12,
                                                            actionButton(
                                                              label = "Reset",
                                                              inputId = "any")
                                                     )),
                                                   fluidRow(
                                                     column(width=3,
                                                            checkboxGroupInput(
                                                              label = NULL,
                                                              inputId = "countries1a",
                                                              choices = list("AU", "AT", "BE", "CA", "CL", "HR", "CZ", "DK", "FI", "FR", "DE"),
                                                              selected = NULL)
                                                     ),
                                                     column(width=3,
                                                            checkboxGroupInput(
                                                              label = NULL,
                                                              inputId = "countries1b",
                                                              choices = list("HU", "IE", "IL", "IT", "JP", "KR", "LV", "LT", "NT", "NZ", "NO"),
                                                              selected = NULL)
                                                     ),
                                                     column(width=3,
                                                            checkboxGroupInput(
                                                              label = NULL,
                                                              inputId = "countries1c",
                                                              choices = list( "PL", "PT", "RU", "SK", "SI", "ES", "SE", "CH", "UK", "US", "UY"),
                                                              selected = NULL)
                                                     )
                                                   )    
                                    )),
                               br(),
                               div( id = "wave", 
                                    dropdownButton(label = h5("Suvery Waves"), status = "default", tags$label("Must include:"),
                                                   fluidRow(
                                                     column(12,
                                                            checkboxGroupInput(
                                                              inputId = "mwave",
                                                              label = NULL,
                                                              choices = list("1985" = "w1985",
                                                                             "1990" = "w1990",
                                                                             "1996" = "w1996",
                                                                             "2006" = "w2006",
                                                                             "2016" = "w2016"),
                                                              selected = NULL)
                                                     )))
                               ),
                               br(),
                               dropdownButton(label = h5("Estimator /Other"), status = "default", width = 80,
                                              fluidRow(
                                                column(12, 
                                                       checkboxGroupInput(    
                                                         inputId = "emator",
                                                         label = ("Choose estimators"),
                                                         choices = list("OLS" = "ols",
                                                                        "Logit" = "logit",
                                                                        "O.Logit" = "ologit",
                                                                        "GLM" = "ml_glm",
                                                                        "Bayes" = "bayes"),
                                                         selected = c("ols","logit","ologit","ml_glm","bayes")
                                                       ))),
                                              fluidRow(
                                                column(12, 
                                                       checkboxGroupInput( 
                                                         inputId = "other",
                                                         label = ("Other"),
                                                         choices = list("Clustered S.E." = "clustse",
                                                                        "Two-Way FE" = "twowayfe",
                                                                        "Dichotomized DV" = "dichtdv",
                                                                        "Any Nonlinear IVs" = "nonlin"),
                                                         selected = c("clustse","dichtdv","twowayfe","nonlin")
                                                       )))
                               ),
                               br(),
                               dropdownButton(label = h5("Peer Score"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "total",
                                                label = ("Model veracity:"),
                                                choices = list("Low" = "Low",
                                                               "Mid" = "Mid",
                                                               "High" = "High"),
                                                selected = c("Low","Mid","High")
                                              )
                               )),
                        column(3, style = {'height:400px; border-top: 1px solid silver; border-bottom: 1px solid silver'},
                               br(),
                               dropdownButton(label = h5("Methods Expertise"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "stat",
                                                label = ("Statistics Experience/ Knowledge"),
                                                choices = list("Low" = "Low",
                                                               "Mid" = "Mid",
                                                               "High" = "High"),
                                                selected = c("Low","Mid","High")
                                              )),
                               
                               br(),
                               dropdownButton(label = h5("Topic Expertise"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "topic",
                                                label = ("Topical Experience/ Knowledge"),
                                                choices = list("Low" = "Low",
                                                               "Mid" = "Mid",
                                                               "High" = "High"),
                                                selected = c("Low","Mid","High")
                                              )),
                               br(),
                               dropdownButton(label = h5("Prior Belief"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "belief",
                                                label = ("Hypothersis is true"),
                                                choices = list("Low" = "Low",
                                                               "Mid" = "Mid",
                                                               "High" = "High"),
                                                selected = c("Low","Mid","High")
                                              )),
                               br(),
                               dropdownButton(label = h5("Prior Attitude"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "proimm",
                                                label = ("Pro-immigration"),
                                                choices = list("Low" = "Low",
                                                               "Mid" = "Mid",
                                                               "High" = "High"),
                                                selected = c("Low","Mid","High")
                                              )),
                               
                               br()
                        ),
                        column(3, style={'height: 400px; border-left: 1px solid silver; border-right: 1px solid silver; border-top: 1px solid silver'},
                               h3("NOTES FOR USERS", style={'margin:4px 0; padding: 4px; font-size: 14px; text-align:center; background-color:#D3D3D3;'}),
                               h6("Hypothesis: immigration undermines support for social policy", style={'text-align: center; margin:6px 0; font-size: 11px '}),
                               h6("Data: International Social Survey Program, Role of Government (1985-2016)", style={'text-align: center; margin:6px 0; font-size: 11px '}),
                               h6("Toggle tabs above to view (1) effects, (2) p-values or (3) subjective team conclusions. Filter research designs and team characteristics in drowdown menus to the left. Not all combinations of specifications have corresponding results - only those considered appropriate test models by at least one team.", style={'margin:1.5px 0; font-size: 11px '}),
                               h6(uiOutput("exec"), style={'margin:1.5px 0; padding: 3px; text-align: center; font-size: 12px; font-style: italic'}),
                               h6(uiOutput("workp"), style={'margin:1.5px 0; padding: 3px; text-align: center; font-size: 12px; font-style: italic'}),
                               h6("Design: Nate Breznau & Hung H.V. Nguyen ", style={'margin:1.5px 0; font-size: 11px'}),
                               h6("University of Bremen", style={'margin:1.5px 0; font-size: 11px '}),
                               h6("Contact: breznau.nate@gmail.com", style={'margin:1.5px 0; font-size: 11px '}),
                               h6("     "),
                               h3("The button below removes all user defined parameters", style={'margin:12px 0; text-align: center; font-size: 12px; padding: 4px; background-color:#D3D3D3;'}),
                               h6("     "),
                               actionButton("resetAll", "Refresh All"))
                        
               ) ## end of third fluid row    
      ), ## end of first tab panel - spec_curve
      
      
      ## SECOND TAB PANEL     
      tabPanel("P-VALUES", 
               fluidRow(
                 column(9, style={'height: 500px; border-left: 1px solid silver; border-bottom: 1px solid silver; border-top: 1px solid silver'},
                        plotOutput("p_val")),
                 column(3, style = {'height:500px; border-left: 1px solid silver; border-right: 1px solid silver; border-top: 1px solid silver; border-bottom: 1px solid silver'},
                        fluidRow(
                          h5("Now Displaying", style={'padding-top: 8px; font-size: 14px; text-align:center; background-color:#D3D3D3'}),
                          column(6, style={'border-right: 1px solid silver;'},
                                 h6(strong(textOutput("modeln2")), style={'font-size: 20px; text-align:center; padding-top: 4px'}), 
                                 h6("of 1,253 models", style={'margin:1.5px 0; text-align:center; padding: 2px; padding-bottom: 10px;'})),
                          column(6,
                                 h6(strong(textOutput("teamn2")), style={'font-size: 20px; text-align:center; padding-top: 4px'}),
                                 h6("of 73 teams*", style={'margin:1.5px 0; text-align:center; padding: 2px; padding-bottom: 10px;'}))),
                        fluidRow(
                          h5("Empirical Summary", style={'padding-top: 8px; font-size: 14px; text-align:center; background-color:#D3D3D3'}),
                          h6(strong(textOutput("signeg2")), style={'color: #66A61E;font-size: 18px; text-align:center; padding-top: 3px'}), 
                          h6("had negative effects at 95% CI", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                          h6("(weighted by models per team)", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                          h6(strong(textOutput("sigpos2")), style={'color: #D95F02; font-size: 18px; text-align:center; padding-top: 6px'}), 
                          h6("had positive effects at 95% CI", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                          h6("(weighted by models per team)", style={'margin:1.5px 0; text-align:center; padding: 2px; padding-bottom: 10px;'})),
                        fluidRow(
                          h5("Team Conclusions", style={'padding-top: 8px; font-size: 14px; text-align:center; background-color:#D3D3D3'}),
                          column(6, style={'border-right: 1px solid silver;'},
                                 h6(strong(textOutput("hsupp2")), style={'color: #66A61E;font-size: 18px; text-align:center; padding-top: 6px'}), 
                                 h6("support", style={'margin:1.5px 0; text-align:center; padding: 2px; padding-bottom: 10px;'})),
                          column(6,
                                 h6(strong(textOutput("hreje2")), style={'color: #D95F02; font-size: 18px; text-align:center; padding-top: 6px'}), 
                                 h6("reject**", style={'margin:1.5px 0; text-align:center; padding: 2px; padding-bottom: 10px;'}))),
                        
                        br(),
                        h6("*Two teams had no results, one lacked convergence and other failed measurement invariance", style={'margin:1px 0; font-size: 9px'}),
                        h6("**If not support or reject, the remainder concluded it was 'not testable' with these data", style={'margin:1px 0; font-size: 9px'}),
                        
                 )
               ),
               br(),
               fluidRow( 
                 h5("Filter models by research design and team characteristics"), style = {'text-align: center; padding: 8px; background-color:#4682B433'}
               ),
               ### SECOND FLUID ROW
               fluidRow(id = "reset2", 
                        column(3, style = {'height:400px; border-left: 1px solid silver; border-top: 1px solid silver; border-bottom: 1px solid silver'},
                               br(),
                               dropdownButton(label = h5("Dependent Variable"), status = "default", 
                                              checkboxGroupInput(
                                                inputId = "mspecdv2",
                                                label = "Questions Used <government should>:", 
                                                choices = list("Provide Jobs" = "Jobs",
                                                               "Income Equality" = "IncDiff",
                                                               "Unemployment" = "Unemp",
                                                               "Old Age Care" = "OldAge",
                                                               "Housing" = "House",
                                                               "Health Care" = "Health",
                                                               "(Multi-Item Scale)" = "Scaled"),
                                                selected = c("Jobs", "IncDiff","Unemp","OldAge","House","Health","Scaled")
                                              )),
                               br(),
                               dropdownButton(label = h5("Test Variable"), status = "default", 
                                              checkboxGroupInput(
                                                inputId = "mspeciv2",
                                                label = "Immigration measured as:", 
                                                choices = list("Stock" = "Stock", 
                                                               "Flow" = "Flow",
                                                               "Change in Flow" = "ChangeFlow",
                                                               "Stock & Flow Together" = "StockFlow"),
                                                selected = c("Stock","Flow","ChangeFlow", "StockFlow")
                                              )),
                               br(),
                               dropdownButton(label = h5("Independent Variables"), status = "default", width = 80,
                                              checkboxGroupInput(
                                                inputId = "mspecivx2",
                                                label = "Country-level 'controls'",
                                                choices = list("Social Spending)" = "Soc_Spending",
                                                               "(Un)employment Rate" = "Unemp_Rate",
                                                               "GDP per Capita" = "GDP_Per_Capita",
                                                               "Gini" = "Gini",
                                                               "None of Above" = "None"),
                                                selected = c("Soc_Spending","Unemp_Rate","Gini","GDP_Per_Capita",
                                                             "None")
                                              ))),
                        column(3, style = {'height:400px; border-top: 1px solid silver; border-bottom: 1px solid silver'},
                               br(),
                               div( id = "cntry2",
                                    dropdownButton(label = h5("Country Sample"), status = "default", tags$label("Must Include:"),
                                                   fluidRow(
                                                     column(width=12,
                                                            actionButton(
                                                              label = "Reset",
                                                              inputId = "any2")
                                                     )),
                                                   fluidRow(
                                                     column(width=3,
                                                            checkboxGroupInput(
                                                              label = NULL,
                                                              inputId = "countries2a",
                                                              choices = list("AU", "AT", "BE", "CA", "CL", "HR", "CZ", "DK", "FI", "FR", "DE"),
                                                              selected = NULL)
                                                     ),
                                                     column(width=3,
                                                            checkboxGroupInput(
                                                              label = NULL,
                                                              inputId = "countries2b",
                                                              choices = list("HU", "IE", "IL", "IT", "JP", "KR", "LV", "LT", "NT", "NZ", "NO"),
                                                              selected = NULL)
                                                     ),
                                                     column(width=3,
                                                            checkboxGroupInput(
                                                              label = NULL,
                                                              inputId = "countries2c",
                                                              choices = list( "PL", "PT", "RU", "SK", "SI", "ES", "SE", "CH", "UK", "US", "UY"),
                                                              selected = NULL)
                                                     )
                                                   )    
                                    )),
                               br(),
                               div( id = "wave2", 
                                    dropdownButton(label = h5("Survey Waves"), status = "default", tags$label("Must include:"),
                                                   fluidRow(
                                                     column(12,
                                                            checkboxGroupInput(
                                                              inputId = "mwave2",
                                                              label = NULL,
                                                              choices = list("1985" = "w1985",
                                                                             "1990" = "w1990",
                                                                             "1996" = "w1996",
                                                                             "2006" = "w2006",
                                                                             "2016" = "w2016"),
                                                              selected = NULL)
                                                     )))
                               ),
                               br(),
                               dropdownButton(label = h5("Estimator /Other"), status = "default", width = 80,
                                              fluidRow(
                                                column(12, 
                                                       checkboxGroupInput(    
                                                         inputId = "emator2",
                                                         label = ("Choose estimators"),
                                                         choices = list("OLS" = "ols",
                                                                        "Logit" = "logit",
                                                                        "O.Logit" = "ologit",
                                                                        "GLM" = "ml_glm",
                                                                        "Bayes" = "bayes"),
                                                         selected = c("ols","logit","ologit","ml_glm","bayes")
                                                       ))),
                                              fluidRow(
                                                column(12, 
                                                       checkboxGroupInput( 
                                                         inputId = "other2",
                                                         label = ("Other"),
                                                         choices = list("Clustered S.E." = "clustse",
                                                                        "Two-Way FE" = "twowayfe",
                                                                        "Dichotomized DV" = "dichtdv",
                                                                        "Any Nonlinear IVs" = "nonlin"),
                                                         selected = c("clustse","dichtdv","twowayfe","nonlin")
                                                       )))
                               ),
                               br(),
                               dropdownButton(label = h5("Peer Score"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "total2",
                                                label = ("Model veracity:"),
                                                choices = list("Low" = "Low",
                                                               "Mid" = "Mid",
                                                               "High" = "High"),
                                                selected = c("Low","Mid","High")
                                              )
                               )),
                        column(3, style = {'height:400px; border-top: 1px solid silver; border-bottom: 1px solid silver'},
                               br(),
                               dropdownButton(label = h5("Methods Expertise"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "stat2",
                                                label = ("Statistics Experience/ Knowledge"),
                                                choices = list("Low" = "Low",
                                                               "Mid" = "Mid",
                                                               "High" = "High"),
                                                selected = c("Low","Mid","High")
                                              )),
                               
                               br(),
                               dropdownButton(label = h5("Topic Expertise"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "topic2",
                                                label = ("Topical Experience/ Knowledge"),
                                                choices = list("Low" = "Low",
                                                               "Mid" = "Mid",
                                                               "High" = "High"),
                                                selected = c("Low","Mid","High")
                                              )),
                               br(),
                               dropdownButton(label = h5("Prior Belief"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "belief2",
                                                label = ("Hypothesis is true"),
                                                choices = list("Low" = "Low",
                                                               "Mid" = "Mid",
                                                               "High" = "High"),
                                                selected = c("Low","Mid","High")
                                              )),
                               br(),
                               dropdownButton(label = h5("Prior Attitude"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "proimm2",
                                                label = ("Pro-immigration"),
                                                choices = list("Low" = "Low",
                                                               "Mid" = "Mid",
                                                               "High" = "High"),
                                                selected = c("Low","Mid","High")
                                              )),
                               
                               br()
                        ),
                        column(3, style={'height: 400px; border-left: 1px solid silver; border-right: 1px solid silver; border-top: 1px solid silver'},
                               h3("NOTES FOR USERS", style={'margin:4px 0; padding: 4px; font-size: 14px; text-align:center; background-color:#D3D3D3;'}),
                               h6("Hypothesis: immigration undermines support for social policy", style={'text-align: center; margin:6px 0; font-size: 11px '}),
                               h6("Data: International Social Survey Program, Role of Government (1985-2016)", style={'text-align: center; margin:6px 0; font-size: 11px '}),
                               h6("Toggle tabs above to view (1) effects, (2) p-values or (3) subjective team conclusions. Filter research designs and team characteristics in drowdown menus to the left. Not all combinations of specifications have corresponding results - only those considered appropriate test models by at least one team.", style={'margin:1.5px 0; font-size: 11px '}),
                               h6(uiOutput("exec2"), style={'margin:1.5px 0; padding: 3px; text-align: center; font-size: 12px; font-style: italic'}),
                               h6(uiOutput("workp2"), style={'margin:1.5px 0; padding: 3px; text-align: center; font-size: 12px; font-style: italic'}),
                               h6("Design: Nate Breznau & Hung H.V. Nguyen ", style={'margin:1.5px 0; font-size: 11px'}),
                               h6("University of Bremen", style={'margin:1.5px 0; font-size: 11px '}),
                               h6("Contact: breznau.nate@gmail.com", style={'margin:1.5px 0; font-size: 11px '}),
                               h6("     "),
                               h3("The button below removes all user defined parameters", style={'margin:12px 0; text-align: center; font-size: 12px; padding: 4px; background-color:#D3D3D3;'}),
                               h6("     "),
                               actionButton("resetAll2", "Refresh All"))
                        
               )
               
      ), 
      
      ## THIRD TAB PANEL
      tabPanel("CONCLUSIONS",
               fluidRow(
                 column(9, style={'height: 500px; border-left: 1px solid silver; border-bottom: 1px solid silver; border-top: 1px solid silver'},
                        plotOutput("conclude")),
                 column(3, style = {'height:500px; border-left: 1px solid silver; border-right: 1px solid silver; border-top: 1px solid silver; border-bottom: 1px solid silver'},
                        h5("SUMMARY", style={'margin:4px 0; padding: 4px; font-size: 14px; text-align:center; background-color:#D3D3D3'}),
                        h6(strong(textOutput("teamn3")), style={'margin:9px 0; font-size: 18px; text-align:center; padding-top: 12px'}),
                        h6("of 89 team conclusions*", style={'margin:1.5px 0; text-align:center; padding: 2px;'}),
                        h6(strong(textOutput("signeg3")), style={'color: #66A61E; font-size: 18px; text-align:center; padding-top: 12px'}), 
                        h6("of these team's effects", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                        h6("were negative (on avg.)", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                        h6(strong(textOutput("sigpos3")), style={'color: #D95F02; font-size: 18px; text-align:center; padding-top: 12px'}), 
                        h6("of these team's effects", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                        h6("were positive (on avg.)", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                        br(),
                        br(),
                        h6("*15 teams drew two different conclusions based on different measures of immigration (stock v. flow). Two teams are not visualized here because they had no numeric results although their conclusions were 'not testable'", style={'margin:1px 0; font-size: 9px'})
                 )
               ),
               br(),
               fluidRow( 
                 h5("Filter models by team characteristics"), style = {'text-align: center; padding: 8px; background-color:#4682B433'}
               ),
               fluidRow(id = "reset3",
                        column(3, style = {'height:400px; border-top: 1px solid silver; border-bottom: 1px solid silver'},
                               br(),
                               dropdownButton(label = h5("Methods Expertise"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "stat3",
                                                label = ("Statistics Experience/ Knowledge"),
                                                choices = list("Low" = "Low",
                                                               "Mid" = "Mid",
                                                               "High" = "High"),
                                                selected = c("Low","Mid","High")
                                              )
                               ),
                               br(),
                               dropdownButton(label = h5("Topic Expertise"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "topic3",
                                                label = ("Topical Experience/ Knowledge"),
                                                choices = list("Low" = "Low",
                                                               "Mid" = "Mid",
                                                               "High" = "High"),
                                                selected = c("Low","Mid","High")
                                              )
                               ),
                               br(),
                               dropdownButton(label = h5("Prior Belief"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "belief3",
                                                label = ("Hypothesis is true"),
                                                choices = list("Low" = "Low",
                                                               "Mid" = "Mid",
                                                               "High" = "High"),
                                                selected = c("Low","Mid","High")
                                              )
                               ),
                               br(),
                               dropdownButton(label = h5("Prior Attitude"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "proimm3",
                                                label = ("Pro-immigration"),
                                                choices = list("Low" = "Low",
                                                               "Mid" = "Mid",
                                                               "High" = "High"),
                                                selected = c("Low","Mid","High")
                                              )
                               )
                               
                        ),
                        column(3, style = {'height:400px; border-top: 1px solid silver; border-bottom: 1px solid silver'},
                               br(),
                               dropdownButton(label = h5("Peer Score"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "total3",
                                                label = ("Model veracity:"),
                                                choices = list("Low" = "Low",
                                                               "Mid" = "Mid",
                                                               "High" = "High"),
                                                selected = c("Low","Mid","High")
                                              )
                               ),
                               br(),
                               dropdownButton(label = h5("Number of Models"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "modelsn3",
                                                label = ("Total # Submitted"),
                                                choices = list("One" = "A",
                                                               "2-6" = "B",
                                                               "7-12" = "C",
                                                               "13-48" = "D",
                                                               "49+" = "F"),
                                                selected = c("A","B","C","D","F")
                                              )
                               ),
                               br(),
                               dropdownButton(label = h5("Sample Components"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "sample3",
                                                label = ("Includes any countries:"),
                                                choices = list("Only 13 Rich Democracies" = "A",
                                                               "Eastern Europe" = "B",
                                                               "All Possible Countries" = "C",
                                                               "Include All" = "D"),
                                                selected = c("D")
                                              ),
                                              checkboxGroupInput(
                                                inputId = "sample34",
                                                label = ("Include any waves:"),
                                                choices = list("2016 Wave" = "A",
                                                               "2006 Wave" = "B",
                                                               "1996 Wave" = "C",
                                                               "1985 or 1990" = "D",
                                                               "Inlcude All" = "E"),
                                                selected = c("E")
                                              )
                               ),
                               br(),
                        ),
                        column(3, style = {'height:400px; border-top: 1px solid silver; border-bottom: 1px solid silver'},
                               br(),
                               dropdownButton(label = h5("Model Design"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "design3",
                                                label = NULL,
                                                choices = list("'Two-Way Fixed Effects'" = "A",
                                                               "Country-Year as Level" = "B",
                                                               "Within-Country Slopes" = "C",
                                                               "Non-Linearities" = "D",
                                                               "Include All Types" = "E"),
                                                selected = c("E")
                                              )
                               ),
                               br(),
                               dropdownButton(label = h5("Tested For"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "design4",
                                                label = "Immigration as:",
                                                choices = list("Stock" = "A",
                                                               "Flow" = "B",
                                                               "Change in Flow" = "C",
                                                               "Stock & Flow Simultaneously" = "D",
                                                               "Include All Tests" = "E"),
                                                selected = c("E")
                                              )
                               ),
                               br(),
                        ),
                        column(3, style = {'height:500px; border-left: 1px solid silver; border-right: 1px solid silver; border-top: 1px solid silver; border-bottom: 1px solid silver'},
                               h3("NOTES FOR USERS", style={'margin:4px 0; padding: 4px; font-size: 14px; text-align:center; background-color:#D3D3D3;'}),
                               h6("Hypothesis: immigration undermines support for social policy", style={'text-align: center; margin:6px 0; font-size: 11px '}),
                               h6("Data: International Social Survey Program, Role of Government (1985-2016)", style={'text-align: center; margin:6px 0; font-size: 11px '}),
                               h6("Toggle tabs above to view (1) effects, (2) p-values or (3) subjective team conclusions. Filter research designs and team characteristics in drowdown menus to the left. Not all combinations of specifications have corresponding results - only those considered appropriate test models by at least one team.", style={'margin:1.5px 0; font-size: 11px '}),
                               h6(uiOutput("exec3"), style={'margin:1.5px 0; padding: 3px; text-align: center; font-size: 12px; font-style: italic'}),
                               h6(uiOutput("workp3"), style={'margin:1.5px 0; padding: 3px; text-align: center; font-size: 12px; font-style: italic'}),
                               h6("Design: Nate Breznau & Hung H.V. Nguyen ", style={'margin:1.5px 0; font-size: 11px'}),
                               h6("University of Bremen", style={'margin:1.5px 0; font-size: 11px '}),
                               h6("Contact: breznau.nate@gmail.com", style={'margin:1.5px 0; font-size: 11px '}),
                               h6("     "),
                               h3("The button below removes all user defined parameters", style={'margin:12px 0; text-align: center; font-size: 12px; padding: 4px; background-color:#D3D3D3;'}),
                               h6("     "),
                               actionButton("resetAll3", "Refresh All")
                        )
               )
               
               
      ) ## end of third panel
    ), # end tabset
  ) # end div
) # end page

# deployApp(appDir = here::here("/CRI_shiny", sep=""))

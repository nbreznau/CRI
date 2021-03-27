library(shiny)
library(ggplot2)
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
  h1(id = "title", "The Hidden Universe of Data Analysis", align = "center"),
  tags$style(HTML("#subtitle {font-size: 20px; border-bottom: 2px solid silver; line-height: 20px; color: #3E3673; margin: 12px 0}")),
  h1(id = "subtitle", "One Dataset, One Hypothesis, 73 Teams and 1,253 Models", align = "center"),
  tags$hr(style="border-color: black;"),
  
  # FIRST MAIN COLUMN  
  div(
    tabsetPanel(
      type = "tabs",
      
      ## FIRST TAB PANEL        
      tabPanel("EFFECTS", 
               fluidRow(
                 column(9, style={'height: 500px; border-left: 1px solid silver; border-bottom: 1px solid silver; border-top: 1px solid silver'},
                        plotOutput("spec_curve", brush = "plot_brush")),
                 column(3, style = {'height:500px; border-left: 1px solid silver; border-right: 1px solid silver; border-top: 1px solid silver; border-bottom: 1px solid silver'},
                        h5("SUMMARY", style={'margin:4px 0; padding: 4px; font-size: 14px; text-align:center; background-color:#D3D3D3'}),
                        h6(strong(textOutput("modeln")), style={'font-size: 18px; text-align:center; padding-top: 12px'}), 
                        h6("of 1,253 models", style={'margin:1.5px 0; text-align:center; padding: 2px;'}),
                        h6(strong(textOutput("teamn")), style={'margin:9px 0; font-size: 18px; text-align:center; padding-top: 12px'}),
                        h6("of 73 teams*", style={'margin:1.5px 0; text-align:center; padding: 2px;'}),
                        h6(strong(textOutput("signeg")), style={'font-size: 18px; text-align:center; padding-top: 12px'}), 
                        h6("had negative effects at 95% CI", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                        h6("(weighted by models per team)", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                        h6(strong(textOutput("sigpos")), style={'font-size: 18px; text-align:center; padding-top: 12px'}), 
                        h6("had positive effects at 95% CI", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                        h6("(weighted by models per team)", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                        br(),
                        br(),
                        h6("*Two teams had no results, one lacked convergence and other failed measurement invariance", style={'margin:1px 0; font-size: 9px'}),
                        br(),
                        verbatimTextOutput("info")
                 )
               ), ## first fluidRow
               br(),
               fluidRow( 
                 h5("Filter models by research design and team characteristics"), style = {'text-align: center; padding: 8px; background-color:#4682B433'}
               ), ## end of second fluidRow
               
               fluidRow(id = "reset", 
                        column(3, style = {'height:400px; border-left: 1px solid silver; border-top: 1px solid silver; border-bottom: 1px solid silver'},
                               br(),
                               dropdownButton(label = h5("Dep. Variables"), status = "default", 
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
                               dropdownButton(label = h5("Immigration Vars"), status = "default", 
                                              checkboxGroupInput(
                                                inputId = "mspeciv",
                                                label = "% Foreign-Born as:", 
                                                choices = list("Stock" = "Stock", 
                                                               "Flow" = "Flow",
                                                               "Change in Flow" = "ChangeFlow",
                                                               "Stock & Flow Together" = "StockFlow"),
                                                selected = c("Stock","Flow","ChangeFlow", "StockFlow")
                                              )),
                               br(),
                               dropdownButton(label = h5("Country Controls"), status = "default", width = 80,
                                              checkboxGroupInput(
                                                inputId = "mspecivx",
                                                label = NULL,
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
                                    dropdownButton(label = h5("Countries"), status = "default", tags$label("Must Include:"),
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
                                    dropdownButton(label = h5("Waves"), status = "default", tags$label("Must include:"),
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
                               dropdownButton(label = h5("Other"), status = "default", width = 80,
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
                               dropdownButton(label = h5("Methods Exp."), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "stat",
                                                label = ("Statistics Experience/ Knowledge"),
                                                choices = list("Low" = "Low",
                                                               "Mid" = "Mid",
                                                               "High" = "High"),
                                                selected = c("Low","Mid","High")
                                              )),
                               
                               br(),
                               dropdownButton(label = h5("Topic Exp."), status = "default", width = 80,
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
                                                label = ("Hyp. is true"),
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
                        plotOutput("p_val", brush = "plot2_brush")),
                 column(3, style = {'height:500px; border-left: 1px solid silver; border-right: 1px solid silver; border-top: 1px solid silver; border-bottom: 1px solid silver'},
                        h5("SUMMARY", style={'margin:4px 0; padding: 4px; font-size: 14px; text-align:center; background-color:#D3D3D3'}),
                        h6(strong(textOutput("modeln2")), style={'font-size: 18px; text-align:center; padding-top: 12px'}), 
                        h6("of 1,253 models", style={'margin:1.5px 0; text-align:center; padding: 2px;'}),
                        h6(strong(textOutput("teamn2")), style={'margin:9px 0; font-size: 18px; text-align:center; padding-top: 12px'}),
                        h6("of 73 teams*", style={'margin:1.5px 0; text-align:center; padding: 2px;'}),
                        h6(strong(textOutput("signeg2")), style={'font-size: 18px; text-align:center; padding-top: 12px'}), 
                        h6("had negative effects at 95% CI", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                        h6("(weighted by models per team)", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                        h6(strong(textOutput("sigpos2")), style={'font-size: 18px; text-align:center; padding-top: 12px'}), 
                        h6("had positive effects at 95% CI", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                        h6("(weighted by models per team)", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                        br(),
                        h6("*Two teams had no results, one lacked convergence and other failed measurement invariance", style={'margin:1px 0; font-size: 9px'}),
                        br(),
                        verbatimTextOutput("info2")
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
                               dropdownButton(label = h5("Dep. Variables"), status = "default", 
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
                               dropdownButton(label = h5("Immigration Vars"), status = "default", 
                                              checkboxGroupInput(
                                                inputId = "mspeciv2",
                                                label = "% Foreign-Born as:", 
                                                choices = list("Stock" = "Stock", 
                                                               "Flow" = "Flow",
                                                               "Change in Flow" = "ChangeFlow",
                                                               "Stock & Flow Together" = "StockFlow"),
                                                selected = c("Stock","Flow","ChangeFlow", "StockFlow")
                                              )),
                               br(),
                               dropdownButton(label = h5("Country Controls"), status = "default", width = 80,
                                              checkboxGroupInput(
                                                inputId = "mspecivx2",
                                                label = NULL,
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
                                    dropdownButton(label = h5("Countries"), status = "default", tags$label("Must Include:"),
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
                                    dropdownButton(label = h5("Waves"), status = "default", tags$label("Must include:"),
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
                               dropdownButton(label = h5("Other"), status = "default", width = 80,
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
                               dropdownButton(label = h5("Methods Exp."), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "stat2",
                                                label = ("Statistics Experience/ Knowledge"),
                                                choices = list("Low" = "Low",
                                                               "Mid" = "Mid",
                                                               "High" = "High"),
                                                selected = c("Low","Mid","High")
                                              )),
                               
                               br(),
                               dropdownButton(label = h5("Topic Exp."), status = "default", width = 80,
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
                                                label = ("Hyp. is true"),
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
                        h6(strong(textOutput("modeln3")), style={'font-size: 18px; text-align:center; padding-top: 12px'}), 
                        h6("of 1,253 models", style={'margin:1.5px 0; text-align:center; padding: 2px;'}),
                        h6(strong(textOutput("teamn3")), style={'margin:9px 0; font-size: 18px; text-align:center; padding-top: 12px'}),
                        h6("of 73 teams*", style={'margin:1.5px 0; text-align:center; padding: 2px;'}),
                        h6(strong(textOutput("signeg3")), style={'font-size: 18px; text-align:center; padding-top: 12px'}), 
                        h6("had negative effects at 95% CI", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                        h6("(weighted by models per team)", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                        h6(strong(textOutput("sigpos3")), style={'font-size: 18px; text-align:center; padding-top: 12px'}), 
                        h6("had positive effects at 95% CI", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                        h6("(weighted by models per team)", style={'margin:1.5px 0; text-align:center; padding: 2px'}),
                        br(),
                        br(),
                        h6("*Two teams had no results, one lacked convergence and other failed measurement invariance", style={'margin:1px 0; font-size: 9px'})
                 )
               ),
               br(),
               fluidRow( 
                 h5("Filter models by team characteristics"), style = {'text-align: center; padding: 8px; background-color:#4682B433'}
               ),
               fluidRow(id = "reset3",
                        column(3, style = {'height:400px; border-top: 1px solid silver; border-bottom: 1px solid silver'},
                               br(),
                               dropdownButton(label = h5("Prior Belief"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "belief3",
                                                label = ("Hyp. is true"),
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
                               dropdownButton(label = h5("Methods Exp."), status = "default", width = 80,
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
                               dropdownButton(label = h5("Peer Score"), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "total3",
                                                label = ("Model veracity:"),
                                                choices = list("Low" = "Low",
                                                               "Mid" = "Mid",
                                                               "High" = "High"),
                                                selected = c("Low","Mid","High")
                                              )
                               )
                        ),
                        column(3, style = {'height:400px; border-top: 1px solid silver; border-bottom: 1px solid silver'},
                               br(),
                               dropdownButton(label = h5("Topic Exp."), status = "default", width = 80,
                                              checkboxGroupInput(    
                                                inputId = "topic3",
                                                label = ("Topical Experience/ Knowledge"),
                                                choices = list("Low" = "Low",
                                                               "Mid" = "Mid",
                                                               "High" = "High"),
                                                selected = c("Low","Mid","High")
                                              )
                               )
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

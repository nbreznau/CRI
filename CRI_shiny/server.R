library("shiny")
library("ggplot2")
library("rdfanalysis")
library("dplyr")

# Load files

df <- read.csv("data/cri.csv")

### Transform values from 1 to column names for all countries 

df <- df %>%
  mutate_at(
    vars(AU:VE),
    funs(as.character(.))
  ) %>%
  mutate_at(
    vars(AU:VE),
    funs(if_else(. == "1", deparse(substitute(.)),.))
  )

### Transform values from 1 to column names for all waves 
df <- df %>%
  mutate_at(
    vars(w1985:w2016),
    funs(as.character(.))
  ) %>%
  mutate_at(
    vars(w1985:w2016),
    funs(if_else(. == "1", deparse(substitute(.)),.))
  )
## Transform variables to the right coding scheme 

df <- df %>%
  mutate(
    twowayfe = if_else(twowayfe == 1, "Yes", "No"),
    cluster_any = if_else(cluster_any == 1, "Yes", "No"),
    dv_m = if_else(dichotomize == 1, "Yes", "No"),
    indepv = case_when(
      socx_ivC == 1 & gdp_ivC == 0 & unemprate_ivC == 0 & emplrate_ivC == 0 ~ "Soc_Spending",
      socx_ivC == 0 & gdp_ivC == 1 & unemprate_ivC == 0 & emplrate_ivC == 0 ~ "GDP_Per_Capita",
      socx_ivC == 0 & gdp_ivC == 0 & unemprate_ivC == 1 & emplrate_ivC == 0 ~ "Unemp_Rate",
      socx_ivC == 0 & gdp_ivC == 0 & unemprate_ivC == 0 & emplrate_ivC == 1 ~ "Emp_Rate",
      socx_ivC == 0 & gdp_ivC == 0 & unemprate_ivC == 0 & emplrate_ivC == 0 ~ "None",
      TRUE ~ "Combo"
    ),
    DV = if_else(DV %in% c("Scale_4","Scale_5","Scale_6","Scale_Desrv","Scale_Univ"), "Scaled", DV)
  )


# cntrlist and wavelist

cntrlista <- c("AU", "AT", "BE", "CA", "CL", "HR", "CZ", "DK", "FI", "FR", "DE")
cntrlistb <- c("HU", "IE", "IL", "IT", "JP", "KR", "LV", "LT", "NT", "NZ", "NO")
cntrlistc <- c("PL", "PT","RU", "SK", "SI", "ES", "SE", "CH", "UK", "US", "UY")
wavelist <- names(select(df, w1985:w2016))  




server <- function(input, output, session) {
  
  output$exec <- renderUI({
    url <- a("The Crowdsourced Replication Initiative", href="https://osf.io/preprints/socarxiv/6j9qb/")
    tagList(url)
  })
  
  ### Specification curve AME  
  output$spec_curve <- renderPlot({
    
    dfspec1 <- reactive({
      filter(df, DV %in% input$mspecdv & indepv %in% input$mspecivx & mator %in% input$emator & cluster_any %in% input$clust & 
               twowayfe %in% input$twoway & dv_m %in% input$dv_m & iv_type %in% input$mspeciv & cntrlista %in% input$countries1a & 
               cntrlistb %in% input$countries1b & cntrlistc %in% input$countries1c & wavelist %in% input$mwave)
      
    })
    
    dfspec <- ({
      select(dfspec1(), DV, iv_type, software, AME, lower, upper)
    })
    
    sumout <- reactive({dfspec})
    
    output$pr <- renderText({
      pr <- round(
        ((length(which(sumout()$AME < 0 & sumout()$upper < 0)) ) / (length(sumout()$AME))*100),1)
      paste(pr, "% indicate a significant negative effect of immigration", sep="")
    })
    
    output$teamn <- renderText({
      teamn <- length(sumout()$AME)
      paste("displaying", teamn, "of 1,260 models")
    })
    
    plot_rdf_spec_curve(ests = dfspec, est = "AME", lb = "lower", ub = "upper", est_color = "grey",
                        pt_size = 2, pt_size_highlight = 2, est_color_signeg = "red", lower_to_upper = 1.5, 
                        est_label = "Marginal Effect", ribbon = F)
  }) ### end of specification curve
  ### P-values
  
  output$p_val <- renderPlot({
    dfp1 <- reactive({
      filter(df,DV %in% input$mspecdv2 & indepv %in% input$mspecivx2 & mator %in% input$emator2 & cluster_any %in% input$clust2 & twowayfe %in% input$twoway2 &
               dv_m %in% input$dv_m2 & iv_type %in% input$mspeciv2)
      
    })
    dfp <- ({
      select(dfp1(), DV, iv_type, software, AME, lower, upper, p)
    })
    dfp$pl <- dfp$p -0.05
    dfp$pu <- dfp$p + 0.05
    sumout2 <- reactive({dfp})
    
    output$pr <- renderText({
      pr <- round(
        ((length(which(sumout2()$AME < 0 & sumout()$upper < 0)) ) / (length(sumout2()$AME))*100),1)
      paste(pr, "% indicate a significant negative effect of immigration", sep="")
    })
    
    output$teamn <- renderText({
      teamn <- length(sumout2()$AME)
      paste("displaying", teamn, "of 1,260 models")
    })
    
    plot_rdf_spec_curve(dfp, "p", lb = "pl", ub = "pu", est_color = "grey", pt_size = 2, pt_size_highlight = 2, est_color_signeg = "red", lower_to_upper = 1.5, est_label = "Marginal Effect", ribbon = F)
    
    
  })
  
  ### Hypothesis Testing
  
}

## Reproduce the error (without shiny)

df <- read.csv("data/cri.csv")

df <- select(df, iv_type, software, AME, lower, upper)
df <- df[complete.cases(df),]
df <- df %>%
  rename(
    est = AME,
    lb = lower,
    ub = upper
  )

## Try adding an attribute called "choices" to the data frame - didn't work
attributes_list <- list(names = names(df),     
                        class = "data.frame",          
                        row.names = 1:nrow(df),
                        choices = c(1:2))  
attributes(df) <- attributes_list

plot_rdf_spec_curve(ests =  df, est = "est", lb = "lb", ub = "ub",est_color = "grey", 
                    pt_size = 2, pt_size_highlight = 2, est_color_signeg = "red", 
                    lower_to_upper = 1.5, est_label = "Marginal Effect", ribbon = F)





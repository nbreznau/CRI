library("shiny")
library("ggplot2")
library("rdfanalysis")
library("dplyr")

# Data transformation (only run with new data)
load("dfcri.Rda")

### Transform values from 1 to column names for all countries (run with new data set)
# df %>%
#   mutate_at(
#      vars(AU:VE),
#      if_else(. == "1", deparse(substitute(.)), .)
#    )

### Transform values from 1 to column names for all waves (run with new data set)
#  df %>% 
#    mutate_at(
#      vars(w1985:w2016),
#      if_else(. == 1, deparse(substitute(.)),.)
#    )


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
      filter(df, dv_type %in% input$mspecdv & indepv %in% input$mspecivx & mator %in% input$emator & cluster_any %in% input$clust & 
               twowayfe %in% input$twoway & dv_m %in% input$dv_m & iv_type %in% input$mspeciv & cntrlista %in% input$countries1a & 
               cntrlistb %in% input$countries1b & cntrlistc %in% input$countries1c & wavelist %in% input$mwave)
      
    })
    
    dfspec <- ({
      select(dfspec1(), dv_type, iv_type, software, est, lb, ub)
    })
    
    sumout <- reactive({dfspec})

    output$pr <- renderText({
      pr <- round(
        ((length(which(sumout()$est < 0 & sumout()$ub < 0)) ) / (length(sumout()$est))*100),1)
      paste(pr, "% indicate a significant negative effect of immigration", sep="")
    })
    
    output$teamn <- renderText({
      teamn <- length(sumout()$est)
      paste("displaying", teamn, "of 1,260 models")
    })
    
    plot_rdf_spec_curve(dfspec, "est", "lb", "ub", est_color = "grey", pt_size = 2, pt_size_highlight = 2, est_color_signeg = "red", lower_to_upper = 1.5, est_label = "Marginal Effect", ribbon = F)
  }) ### end of specification curve
  ### P-values
  
  output$p_val <- renderPlot({
    dfp1 <- reactive({
      filter(df,dv_type %in% input$mspecdv2 & indepv %in% input$mspecivx2 & mator %in% input$emator2 & cluster_any %in% input$clust2 & twowayfe %in% input$twoway2 &
               dv_m %in% input$dv_m2 & iv_type %in% input$mspeciv2)
      
    })
    dfp <- ({
      select(dfp1(), dv_type, iv_type, software, est, lb, ub, p)
    })
    dfp$pl <- dfp$p -0.05
    dfp$pu <- dfp$p + 0.05
    sumout2 <- reactive({dfp})
    
    output$pr <- renderText({
      pr <- round(
        ((length(which(sumout2()$est < 0 & sumout()$ub < 0)) ) / (length(sumout2()$est))*100),1)
      paste(pr, "% indicate a significant negative effect of immigration", sep="")
    })
    
    output$teamn <- renderText({
      teamn <- length(sumout2()$est)
      paste("displaying", teamn, "of 1,260 models")
    })
    
    plot_rdf_spec_curve(dfp, "p", lb = "pl", ub = "pu", est_color = "grey", pt_size = 2, pt_size_highlight = 2, est_color_signeg = "red", lower_to_upper = 1.5, est_label = "Marginal Effect", ribbon = F)

    
  })

  ### Hypothesis Testing
 
}


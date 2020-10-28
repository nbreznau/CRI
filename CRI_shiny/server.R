pacman::p_load(shiny, ggplot2, rdfanalysis, dplyr)
# Load files

df <- read.csv("data/cri_shiny.csv")
cri_team_combine <- read.csv("data/cri_shiny_team.csv")

### Server 

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
               cntrlistb %in% input$countries1b & cntrlistc %in% input$countries1c & wavelist %in% input$mwave & 
               BELIEF_HYPOTHESIS %in% input$belief & STATISTICS_SKILL %in% input$stat & TOPIC_KNOWLEDGE %in% input$topic &
               MODEL_SCORE %in% input$total & PRO_IMMIGRANT %in% input$proimm)
    })
    dfspec <- ({
      select(dfspec1(), DV, iv_type, software, est, lb, ub)
    })
    dfspec <- ({
      dfspec[complete.cases(dfspec),]
    })
    attr(dfspec, "choices") <- 1:3
    sumout <- reactive({dfspec})
    output$pr <- renderText({
      pr <- round(
        ((length(which(sumout()$est < 0 & sumout()$ub < 0)) ) / (length(sumout()$est))*100),1)
      paste(pr, "% indicate a significant negative effect of immigration", sep="")
    })
    
    output$teamn <- renderText({
      teamn <- length(sumout()$est)
      paste("displaying", teamn, "of 1,292 models")
    })
    plot_rdf_spec_curve(dfspec, "est", lb = "lb", ub = "ub", est_color = "grey", pt_size = 2, 
                        pt_size_highlight = 2, est_color_signeg = "red", lower_to_upper = 1.5, 
                        est_label = "Marginal Effect", ribbon = F)
  }) ### end of specification curve
  ### P-values
  
  output$p_val <- renderPlot({
    dfp1 <- reactive({
      filter(df,DV %in% input$mspecdv2 & indepv %in% input$mspecivx2 & mator %in% input$emator2 & cluster_any %in% input$clust2 & 
               twowayfe %in% input$twoway2 & dv_m %in% input$dv_m2 & iv_type %in% input$mspeciv2 & cntrlista %in% input$countries2a & 
               cntrlistb %in% input$countries2b & cntrlistc %in% input$countries2c & wavelist %in% input$mwave2 & 
               BELIEF_HYPOTHESIS %in% input$belief2 & STATISTICS_SKILL %in% input$stat2 & TOPIC_KNOWLEDGE %in% input$topic2 &
               MODEL_SCORE %in% input$total2 & PRO_IMMIGRANT %in% input$proimm2)
      
    })
    dfp <- ({
      select(dfp1(), DV, iv_type, software, est, p)
    })
    dfp$pl <- dfp$p -0.05
    dfp$pu <- dfp$p + 0.05
    dfp <- ({
      dfp[complete.cases(dfp),]
    })
    attr(dfp, "choices") <- 1:3
    sumout2 <- reactive({dfp})
    
    output$pr2 <- renderText({
      pr2 <- round(
        ((length(which(sumout2()$est < 0 & sumout2()$p < 0.05)) ) / (length(sumout2()$p))*100),1)
      paste(pr2, "% indicate a significant negative effect of immigration", sep="")
    })
    
    output$teamn2 <- renderText({
      teamn2 <- length(sumout2()$est)
      paste("displaying", teamn2, "of 1,292 models")
    })
    
    plot_rdf_spec_curve(dfp, "p", lb = "pl", ub = "pu", est_color = "blue", pt_size = 2, 
                        pt_size_highlight = 2, est_color_sigpos = "grey", lower_to_upper = 1.5, 
                        est_label = "P-Values", ribbon = F,)

  })
  
  ### Subjective Conclusion
  output$subject <- renderPlot({
    teamspec1 <- reactive({
      filter(cri_team_combine, iv_type2 %in% input$mspeciv3 & BELIEF_HYPOTHESIS %in% input$belief3 & STATISTICS_SKILL %in% input$stat3 & 
               TOPIC_KNOWLEDGE %in% input$topic3 & MODEL_SCORE %in% input$total3 & PRO_IMMIGRANT %in% input$proimm3)
    })
    teamspec <- ({
      select(teamspec1(), BELIEF_HYPOTHESIS, STATISTICS_SKILL, TOPIC_KNOWLEDGE,
             MODEL_SCORE, PRO_IMMIGRANT, est, lb, ub)
    })
    teamspec <- ({
      teamspec[complete.cases(teamspec),]
    })
    attr(teamspec, "choices") <- 1:5
    sumout3 <- reactive({teamspec})
    output$pr3 <- renderText({
      pr3 <- round(
        ((length(which(sumout3()$est < 0 & sumout3()$ub < 0)) ) / (length(sumout3()$est))*100),1)
      paste(pr3, "% reject the hypothesis", sep="")
    })
    
    output$teamn3 <- renderText({
      teamn3 <- length(sumout3()$est)
      paste("displaying", teamn3, "of 128 researchers")
    })
    plot_rdf_spec_curve(teamspec, est = "est", "lb", "ub", est_color = "grey", est_color_signeg = "red",  
                        choice_ind_point = F, pt_size = 2, lower_to_upper = 1.5, pt_size_highlight = 2,
                        est_label = "Hypothesis Test", ribbon = F)
  })
  observeEvent(input$resetAll,{
    reset("reset")
  })
  observeEvent(input$any, {
    reset("cntry")
  })
  observeEvent(input$any2, {
    reset("cntry2")
  })
  observeEvent(input$many, {
    reset("wave")
  })
  observeEvent(input$many2, {
    reset("wave2")
  })
}


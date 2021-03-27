library(ragg)
library(shiny)
library(tidyverse)
library(ggplot2)
library(ggpubr)



# Load files

df <- readRDS(paste0(getwd(),"/data/cri_shiny.Rds"))

cri_team_combine <- read.csv(paste0(getwd(),"/data/cri_shiny_team.csv"))

# cntrlist and wavelist
cntrlista <- c("AU", "AT", "BE", "CA", "CL", "HR", "CZ", "DK", "FI", "FR", "DE")
cntrlistb <- c("HU", "IE", "IL", "IT", "JP", "KR", "LV", "LT", "NT", "NZ", "NO")
cntrlistc <- c("PL", "PT","RU", "SK", "SI", "ES", "SE", "CH", "UK", "US", "UY")
wavelist <- c("w1985","w1990","w1996","w2006","w2016")


### Server 

server <- function(input, output, session) {
  
  
  
  output$exec <- renderUI({
    url <- a("Original Study Description", href="https://osf.io/preprints/socarxiv/6j9qb/")
    tagList(url)
  })
  
  output$workp <- renderUI({
    url <- a("Replication Materials", href="https://github.com/nbreznau/CRI")
    tagList(url)
  })
  output$exec2 <- renderUI({
    url <- a("Original Study Description", href="https://osf.io/preprints/socarxiv/6j9qb/")
    tagList(url)
  })
  
  output$workp2 <- renderUI({
    url <- a("Replication Materials", href="https://github.com/nbreznau/CRI")
    tagList(url)
  })
  output$exec3 <- renderUI({
    url <- a("Original Study Description", href="https://osf.io/preprints/socarxiv/6j9qb/")
    tagList(url)
  })
  
  output$workp3 <- renderUI({
    url <- a("Replication Materials", href="https://github.com/nbreznau/CRI")
    tagList(url)
  })
  # TAB ONE EFFECTS
  
  ## Filter
  
  dfspec1 <- reactive({
    filter(df, Jobs_str %in% input$mspecdv | # first filter on DV
             Unemp_str %in% input$mspecdv |
             IncDiff_str %in% input$mspecdv |
             OldAge_str %in% input$mspecdv |
             House_str %in% input$mspecdv |
             Health_str %in% input$mspecdv |
             Scale_str %in% input$mspecdv) %>%
      filter(Stock_str %in% input$mspeciv | # filter on TEST
               Flow_str %in% input$mspeciv |
               ChangeFlow_str %in% input$mspeciv |
               StockFlow %in% input$mspeciv) %>%
      filter(Soc_Spending %in% input$mspecivx | # filter on IVs
               Unemp_Rate %in% input$mspecivx |
               GDP_Per_Capita %in% input$mspecivx |
               Gini %in% input$mspecivx |
               None %in% input$mspecivx) %>%
      # make it so countries must be included by summing the true/false conditions with the length of the checkbox output
      filter((AU %in% input$countries1a  + AT %in% input$countries1a + BE %in% input$countries1a +
                CA %in% input$countries1a + CL %in% input$countries1a + HR %in% input$countries1a + 
                CZ %in% input$countries1a + DK %in% input$countries1a + FI %in% input$countries1a + 
                FR %in% input$countries1a + DE %in% input$countries1a) == length(input$countries1a)) %>%
      filter((HU %in% input$countries1b + IE %in% input$countries1b + IL %in% input$countries1b + 
                IT %in% input$countries1b + JP %in% input$countries1b + KR %in% input$countries1b + 
                LV %in% input$countries1b + LT %in% input$countries1b + NT %in% input$countries1b + 
                NZ %in% input$countries1b + NO %in% input$countries1b) == length(input$countries1b)) %>%
      filter((PL %in% input$countries1c + PT %in% input$countries1c + RU %in% input$countries1c + 
                SK %in% input$countries1c + SI %in% input$countries1c + ES %in% input$countries1c + 
                SE %in% input$countries1c + CH %in% input$countries1c + UK %in% input$countries1c + 
                US %in% input$countries1c + UY %in% input$countries1c) == length(input$countries1c)) %>%
      filter(mator %in% input$emator &  
               BELIEF_HYPOTHESIS %in% input$belief & STATISTICS_SKILL %in% input$stat & TOPIC_KNOWLEDGE %in% input$topic &
               MODEL_SCORE %in% input$total & PRO_IMMIGRANT %in% input$proimm) %>%
      filter((w1985 %in% input$mwave +  w1990 %in% input$mwave + w1996 %in% input$mwave + 
                w2006 %in% input$mwave + w2016 %in% input$mwave) == length(input$mwave)) %>%
      filter(other_other == 1 | clustse %in% input$other | twowayfe %in% input$other | 
               dichtdv %in% input$other | nonlin %in% input$other) %>%
      arrange(est) %>%
      mutate(check = ifelse(length(est) == 0, 0, 1),
             count = ifelse(check == 1, 1:n(), 0))
  })
  dfspec_null <- reactive({
    data.frame(
      x = rnorm(20),
      y = rnorm(20,1,0.5)
    )
  })
  
  ## Main Plot - EFFECTS    
  output$signeg <- renderText({
    signeg <- round(
      ((length(which(dfspec1()$est < 0 & dfspec1()$ub < 0)) ) / (length(dfspec1()$est))*100),1)
    
    sig_neg <- 100*round(sum(dfspec1()$inv_weight[dfspec1()$sig_group2 == 1]) / 
                           sum(dfspec1()$inv_weight),1)
    
    paste0(signeg,"% (", sig_neg, "%)")
  })
  
  output$sigpos <- renderText({
    # raw
    sigpos <- round(
      ((length(which(dfspec1()$est > 0 & dfspec1()$lb > 0)) ) / (length(dfspec1()$est))*100),1)
    # weighted
    sig_pos <- 100*round(sum(dfspec1()$inv_weight[dfspec1()$sig_group2 == 3]) /
                           sum(dfspec1()$inv_weight),3)
    
    paste0(sigpos,"% (", sig_pos, "%)")
  })
  
  output$modeln <- renderText({
    modeln <- length(dfspec1()$est)
    paste0(modeln)
  })
  
  output$teamn <- renderText({
    teamn <- (length(unique(dfspec1()$u_teamid))+2)
    paste0(teamn)
  })
  
  output$spec_curve <- renderPlot({
    if (nrow(dfspec1()) != 0){
      p1 <- ggplot(dfspec1()) +
        geom_errorbar(aes(x = count, ymin = lb, ymax = ub), color = "grey90") +
        geom_point(aes(x = count, y = est_ns_scl), color = "grey55", shape = "|", size = 2.5, show.legend =F) + 
        geom_point(aes(x = count, y = est_sig_scl, color = sig_group), shape = "|", size = 4) +
        scale_color_manual(values = c("#66A61E","NA", "#D95F02"), labels = c("Negative","Not sig.","Positive", " ")) +
        labs(color = "Effect at 95% CI", x = "Model Count, Ordered by AME", y = "Average Marginal Effect (AME)\nXY-Standardized") +
        annotate(geom = "text", x = (nrow(dfspec1())*.25), y = 0.3, label = "NEGATIVE (95% CI)", color = "#66A61E", fontface = "bold", size = 4) +
        annotate(geom = "text", x = (3*(nrow(dfspec1())*.25)), y = 0.3, label = "POSITIVE (95% CI)", color = "#D95F02", fontface = "bold", size = 4) +
        #annotate(geom = "text", x = (2*(nrow(dfspec1())*.25)), y = 0.3, label = "NOT STAT.\nSIGNIFICANT", fontface = "bold", color = "grey55", size = 4) +
        theme_classic() +
        coord_cartesian(ylim = c(-0.32,0.32)) +
        guides(color = guide_legend(override.aes = list(size=7, color=c("#66A61E","grey55", "#D95F02","NA")))) +
        theme(
          legend.position = "none",
          axis.title.x = element_text(size = 12),
          axis.title.y = element_text(size = 12)
        )
      p2 <- 
        ggplot(dfspec1()) +
        geom_tile(aes(x = count, y = 0.4, fill = factor(Hsup), height = 0.133, width = 0.25)) +
        geom_tile(aes(x = count, y = 0.2, fill = factor(Hrej), height = 0.133, width = 0.25)) +
        scale_y_continuous(breaks = c(0.4,0.2), labels = c("Support\n   ", "Reject")) +
        scale_fill_manual(values = c("white","#66A61E","#D95F02")) +
        ylab("Team\nConclusion") +
        theme_classic() +
        theme(
          axis.title.x = element_blank(),
          axis.title.y = element_text(size = 10),
          legend.position = "none",
          axis.line.x = element_blank(),
          axis.ticks.x = element_blank(),
          axis.text.x = element_blank()
        )
      
      p3labs <- c("Stock", "Flow", "Change\nin Flow")
      p3 <- 
        ggplot(dfspec1()) +
        geom_tile(aes(x = count, y = 0.6, fill = factor(Stock)), height = 0.133, width = 0.25) +
        geom_tile(aes(x = count, y = 0.4, fill = factor(Flow)), height = 0.133, width = 0.25) +
        geom_tile(aes(x = count, y = 0.2, fill = factor(ChangeFlow)), height = 0.133, width = 0.25) +
        scale_y_continuous(breaks = c(0.6,0.4,0.2), labels=p3labs) +
        scale_fill_manual(values = c("white","blue")) +
        theme_classic() +
        ylab("Immigration\nMeasurement") +
        theme(
          axis.title.x = element_blank(),
          axis.title.y = element_text(size = 10),
          legend.position = "none",
          axis.line.x = element_blank(),
          axis.ticks.x = element_blank(),
          axis.text.x = element_blank()
        )
      
      ggarrange(p1,p2,p3, heights = c(0.95, 0.28, 0.38), nrow = 3, ncol = 1)
    }
    else {
      ggplot(dfspec_null(),aes(x = x, y = y)) +
        geom_blank() + 
        annotate(geom = "text", x = 0, y = 0.8, label = "Sorry, there is no model for your combination", 
                 color = "#66A61E", fontface = "bold", size = 4)+
        labs (x = "Model Count, Ordered by AME", y = "Average Marginal Effect (AME)\nXY-Standardized")
    }
    
  }, height = 460, res = 96)
  ### end of specification curve
  
  
  ### P-values
  dfspec2 <- reactive({
    filter(df, Jobs_str %in% input$mspecdv2 | # first filter on DV
             Unemp_str %in% input$mspecdv2 |
             IncDiff_str %in% input$mspecdv2 |
             OldAge_str %in% input$mspecdv2 |
             House_str %in% input$mspecdv2 |
             Health_str %in% input$mspecdv2 |
             Scale_str %in% input$mspecdv2) %>%
      filter(Stock_str %in% input$mspeciv2 | # filter on TEST
               Flow_str %in% input$mspeciv2 |
               ChangeFlow_str %in% input$mspeciv2 |
               StockFlow %in% input$mspeciv2) %>%
      filter(Soc_Spending %in% input$mspecivx2 | # filter on IVs
               Unemp_Rate %in% input$mspecivx2 |
               GDP_Per_Capita %in% input$mspecivx2 |
               Gini %in% input$mspecivx2 |
               None %in% input$mspecivx2) %>%
      # make it so countries must be included by summing the true/false conditions with the length of the checkbox output
      filter((AU %in% input$countries2a  + AT %in% input$countries2a + BE %in% input$countries2a +
                CA %in% input$countries2a + CL %in% input$countries2a + HR %in% input$countries2a + 
                CZ %in% input$countries2a + DK %in% input$countries2a + FI %in% input$countries2a + 
                FR %in% input$countries2a + DE %in% input$countries2a) == length(input$countries2a)) %>%
      filter((HU %in% input$countries2b + IE %in% input$countries2b + IL %in% input$countries2b + 
                IT %in% input$countries2b + JP %in% input$countries2b + KR %in% input$countries2b + 
                LV %in% input$countries2b + LT %in% input$countries2b + NT %in% input$countries2b + 
                NZ %in% input$countries2b + NO %in% input$countries2b) == length(input$countries2b)) %>%
      filter((PL %in% input$countries2c + PT %in% input$countries2c + RU %in% input$countries2c + 
                SK %in% input$countries2c + SI %in% input$countries2c + ES %in% input$countries2c + 
                SE %in% input$countries2c + CH %in% input$countries2c + UK %in% input$countries2c + 
                US %in% input$countries2c + UY %in% input$countries2c) == length(input$countries2c)) %>%
      filter(mator %in% input$emator2 &  
               BELIEF_HYPOTHESIS %in% input$belief2 & STATISTICS_SKILL %in% input$stat2 & TOPIC_KNOWLEDGE %in% input$topic2 &
               MODEL_SCORE %in% input$total2 & PRO_IMMIGRANT %in% input$proimm2) %>%
      filter((w1985 %in% input$mwave2 +  w1990 %in% input$mwave2 + w1996 %in% input$mwave2 + 
                w2006 %in% input$mwave2 + w2016 %in% input$mwave2) == length(input$mwave2)) %>%
      filter(other_other == 1 | clustse %in% input$other2 | twowayfe %in% input$other | 
               dichtdv %in% input$other2 | nonlin %in% input$other2) %>%
      arrange(est) %>%
      mutate(
        p_new = abs(p)
      ) %>%
      arrange(p_new) %>%
      mutate(
        check2 = ifelse(length(p_new) == 0, 0, 1),
        count2 = ifelse(check2 == 1, 1:n(), 0),
        p_lb = p_new -0.001,
        p_ub = p_new +0.001,
        p_sig_group = as.factor(ifelse(is.na(p_new), NA_real_,ifelse(p_new <= 0.05 & est < 0, 1, ifelse(p_new <= 0.05 & est > 0, 2, 3))))
      )
  })

  output$signeg2 <- renderText({
    signeg2 <- round(
      ((length(which(dfspec2()$est < 0 & dfspec2()$ub < 0)) ) / (length(dfspec2()$est))*100),1)
    
    sig_neg2 <- 100*round(sum(dfspec2()$inv_weight[dfspec2()$sig_group2 == 1]) / 
                           sum(dfspec2()$inv_weight),1)
    
    paste0(signeg2,"% (", sig_neg2, "%)")
  })
  
  output$sigpos2 <- renderText({
    # raw
    sigpos2 <- round(
      ((length(which(dfspec2()$est > 0 & dfspec2()$lb > 0)) ) / (length(dfspec2()$est))*100),1)
    # weighted
    sig_pos2 <- 100*round(sum(dfspec2()$inv_weight[dfspec2()$sig_group2 == 3]) /
                           sum(dfspec2()$inv_weight),3)
    
    paste0(sigpos2,"% (", sig_pos2, "%)")
  })
  
  output$modeln2 <- renderText({
    modeln2 <- length(dfspec2()$est)
    paste0(modeln2)
  })
  
  output$teamn2 <- renderText({
    teamn2 <- (length(unique(dfspec2()$u_teamid))+2)
    paste0(teamn2)
  })

  output$p_val <- renderPlot({
    if (nrow(dfspec2()) != 0){
      p1 <- ggplot(dfspec2()) +
        geom_errorbar(aes(x = count2, ymin = p_lb, ymax = p_ub), color = "grey90")+
        geom_point(aes(x = count2, y = p_new, color = p_sig_group), shape = "|", size = 3) +
        scale_color_manual(values = c("#D95F02", "#66A61E", "grey"), labels = c("Neg sig.", "Pos sig.", "Not sig. ")) +
        labs(color = "Effect at 95% CI", x = "Model Count, Ordered by P Values", y = "Average Marginal Effect (AME)\nXY-Standardized") +
        annotate(geom = "text", x = (nrow(dfspec2())*.25), y = 0.8, label = "POSITIVE SIGNIFICANT (95% CI)", color = "#66A61E", fontface = "bold", size = 4) +
        annotate(geom = "text", x = (nrow(dfspec2())*.25), y = 0.3, label = "NEGATIVE SIGNIFICANT (95% CI)", color = "#D95F02", fontface = "bold", size = 4) +
        #annotate(geom = "text", x = (2*(nrow(dfspec1())*.25)), y = 0.3, label = "NOT STAT.\nSIGNIFICANT", fontface = "bold", color = "grey55", size = 4) +
        theme_classic() +
        coord_cartesian(ylim = c(-0.002,1)) +
        guides(color = guide_legend(override.aes = list(size=7, color=c("#66A61E","grey55", "#D95F02","NA")))) +
        theme(
          legend.position = "none",
          axis.title.x = element_text(size = 12),
          axis.title.y = element_text(size = 12),
        )
      p2 <- 
        ggplot(dfspec2()) +
        geom_tile(aes(x = count2, y = 0.4, fill = factor(Hsup), height = 0.133, width = 0.25)) +
        geom_tile(aes(x = count2, y = 0.2, fill = factor(Hrej), height = 0.133, width = 0.25)) +
        scale_y_continuous(breaks = c(0.4,0.2), labels = c("Support\n   ", "Reject")) +
        scale_fill_manual(values = c("white","#66A61E","#D95F02")) +
        ylab("Team\nConclusion") +
        theme_classic() +
        theme(
          axis.title.x = element_blank(),
          axis.title.y = element_text(size = 10),
          legend.position = "none",
          axis.line.x = element_blank(),
          axis.ticks.x = element_blank(),
          axis.text.x = element_blank(),
        )
      
      p3labs <- c("Stock", "Flow", "Change\nin Flow")
      p3 <- 
        ggplot(dfspec2()) +
        geom_tile(aes(x = count2, y = 0.6, fill = factor(Stock)), height = 0.133, width = 0.25) +
        geom_tile(aes(x = count2, y = 0.4, fill = factor(Flow)), height = 0.133, width = 0.25) +
        geom_tile(aes(x = count2, y = 0.2, fill = factor(ChangeFlow)), height = 0.133, width = 0.25) +
        scale_y_continuous(breaks = c(0.6,0.4,0.2), labels=p3labs) +
        scale_fill_manual(values = c("white","blue")) +
        theme_classic() +
        ylab("Immigration\nMeasurement") +
        theme(
          axis.title.x = element_blank(),
          axis.title.y = element_text(size = 10),
          legend.position = "none",
          axis.line.x = element_blank(),
          axis.ticks.x = element_blank(),
          axis.text.x = element_blank(),
        )
      
      ggarrange(p1,p2,p3, heights = c(0.95, 0.28, 0.38), nrow = 3, ncol = 1)
    }
    else {
      ggplot(dfspec_null(),aes(x = x, y = y)) +
        geom_blank() + 
        annotate(geom = "text", x = 0, y = 0.8, label = "Sorry, there is no model for your combination", 
                 color = "#66A61E", fontface = "bold", size = 4)+
        labs (x = "Model Count, Ordered by AME", y = "Average Marginal Effect (AME)\nXY-Standardized")
    }
    
  }, height = 460, res = 96)
  
  ### Subjective Conclusion
  dfsubj <- reactive({
    cri_team_combine %>%
      mutate(
        subj_concl = factor(Hresult, levels = c("Reject","No test","Support")),
        pct_negpos = ifelse(subj_concl == "Reject", AME_neg_p05, 
                            ifelse(subj_concl == "No test", AME_ns_p05, AME_sup_p05)),
        AME_Zt = ifelse(AME_Z < -0.03, -0.03, ifelse(AME_Z > 0.02, 0.02, AME_Z)),
      ) %>%
      arrange(subj_concl,AME_Zt) %>%
      filter(
        BELIEF_HYPOTHESIS %in% input$belief3 & STATISTICS_SKILL %in% input$stat3 & TOPIC_KNOWLEDGE %in% input$topic3 &
          MODEL_SCORE %in% input$total3 & PRO_IMMIGRANT %in% input$proimm3
      ) %>%
      mutate(
        check3 = ifelse(length(AME_Zt) == 0, 0, 1),
        count3 = ifelse(check3 == 1, 1:n(), 0),
      ) 
  })
  output$conclude <- renderPlot({
    if(nrow(dfsubj()) != 0){
      ggplot(dfsubj()) +
        geom_point(aes(x = count3, y = AME_Zt, color = subj_concl), shape = 18, size = 4) +   scale_color_manual(values = c("#D95F02", "grey55", "#66A61E"), labels = c("Rejected","Not testable","Supported")) +
        labs(color = "Conclusion\nHypothesis is:", x = "Team Conclusions", y = "Average Effect Size\nof Team's Test Models") +
        theme_classic() +
        theme(
          plot.margin=unit(c(0.2,0.2,0.2,1.05),"cm"),
          axis.title.y = element_text(size = 12),
          axis.title.x = element_text(size = 12)
        )
    }
    else{
      ggplot(dfspec_null(),aes(x = x, y = y)) +
        geom_blank() + 
        annotate(geom = "text", x = 0, y = 0.8, label = "Sorry, there is no model for your combination", 
                 color = "#66A61E", fontface = "bold", size = 4)+
        labs (x = "Model Count, Ordered by AME", y = "Average Marginal Effect (AME)\nXY-Standardized")
    }
  }, height = 460, res = 100)

  ### Reset buttons
  observeEvent(input$resetAll,{
    reset("reset")
  })
  observeEvent(input$resetAll2,{
    reset("reset2")
  })
  observeEvent(input$resetAll3,{
    reset("reset3")
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
  ### Interactive plots
  
  output$info <- renderText({
    xy_range_str <- function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("xmin=", round(e$xmin, 1), " xmax=", round(e$xmax, 1), 
             " ymin=", round(e$ymin, 1), " ymax=", round(e$ymax, 1))
    }
    paste0("brush: ", xy_range_str(input$plot_brush))
  })
  
  output$info2 <- renderText({

    xy_range_str <- function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("xmin=", round(e$xmin, 1), " xmax=", round(e$xmax, 1), 
             " ymin=", round(e$ymin, 1), " ymax=", round(e$ymax, 1))
    }
    paste0("brush: ", xy_range_str(input$plot2_brush))
  })
  

}
  

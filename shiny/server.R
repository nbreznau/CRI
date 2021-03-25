library(ragg)
library(shiny)
library(tidyverse)
library(ggplot2)
library(ggpubr)



# Load files

df <- readRDS("data/cri_shiny.Rds")

cri_team_combine <- read.csv("data/cri_shiny_team.csv")

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
        mutate(count = 1:n())
      

      
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
      p1 <- ggplot(dfspec1()) +
        geom_errorbar(aes(x = count, ymin = lb, ymax = ub), color = "grey90") +
        geom_point(aes(x = count, y = est_ns_scl), color = "grey55", shape = "|", size = 2.5, show.legend =F) + 
        geom_point(aes(x = count, y = est_sig_scl, color = sig_group), shape = "|", size = 4) +
        scale_color_manual(values = c("#66A61E","NA", "#D95F02"), labels = c("Negative","Not sig.","Positive"," ")) +
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
          axis.title.y = element_text(size = 12),
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
          axis.text.x = element_blank(),
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
          axis.text.x = element_blank(),
        )
      
      ggarrange(p1,p2,p3, heights = c(1, 0.24, 0.36), nrow = 3, ncol = 1)
    
  }) ### end of specification curve
    
    
    
  ### P-values
  
  output$p_val <- renderPlot({
    dfp1 <- reactive({
      filter(df,Jobs_str %in% input$mspecdv2 & 
               Unemp_str %in% input$mspecdv2 &
               IncDiff_str %in% input$mspecdv2 &
               OldAge_str %in% input$mspecdv2 &
               House_str %in% input$mspecdv2 &
               Health_str %in% input$mspecdv2 &
               Scale_str %in% input$mspecdv2 &
               #indepv %in% input$mspecivx2 & mator %in% input$emator2 & cluster_any %in% input$clust2 & 
               #twowayfe %in% input$twoway2 & dv_m %in% input$dv_m2 & iv_type %in% input$mspeciv2 & 
               #cntrlista %in% input$countries2a & 
               #cntrlistb %in% input$countries2b & cntrlistc %in% input$countries2c & 
               wavelist %in% input$mwave2 & 
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


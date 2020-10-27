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

# some upper_Z and lower_Z bounds are exactly zero, adjust fix this
df$lower_Z <- ifelse(df$lower_Z > -0.00000001 & df$lower_Z < 0.00000001, -0.0001, df$lower_Z)
df$upper_Z <- ifelse(df$upper_Z > -0.00000001 & df$upper_Z < 0.00000001, 0.0001, df$upper_Z)

#trim to have better plot range
df$lower_Z <- ifelse(df$lower_Z < -0.75, -0.75, df$lower_Z)
df$upper_Z <- ifelse(df$upper_Z > 0.75, 0.75, df$upper_Z)
df$upper_Z <- ifelse(df$upper_Z < -0.75, -0.745, df$upper_Z)
df$AME_Z <- ifelse(df$AME_Z < -0.75, -0.747, df$AME_Z)
df$AME_Z <- ifelse(df$AME_Z > 0.75, 0.747, df$AME_Z)



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
    DV = if_else(DV %in% c("Scale_4","Scale_5","Scale_6","Scale_Desrv","Scale_Univ"), "Scaled", DV),
    est = round(AME_Z,6),
    lb = round(lower_Z,6),
    ub = round(upper_Z,6)
  )


# create categories from aspects of the teams
df <- df %>% 
    mutate(stat_cat = ifelse(is.na(stat), "No Information", ifelse(stat < 0, "Low", ifelse(stat > -0.000000001 & stat < 0.45, "Mid", "High"))),
         belief_cat = ifelse(is.na(belief), "No Information", ifelse(belief < -0.5, "Low", ifelse(belief > -0.500000001 & belief < 0.12, "Mid", "High"))),
         topic_cat = ifelse(is.na(topic), "No Information", ifelse(topic < -0.3, "Low", ifelse(topic > -0.300000001 & topic < 0.02, "Mid", "High"))),
         total_score_cat = ifelse(is.na(total_score), "No Information", ifelse(total_score < 0.35, "Low", ifelse(total_score > 0.34999999 & total_score < 0.515, "Mid", "High"))),
         pro_immigrant_cat = ifelse(is.na(pro_immigrant), "No Information", ifelse(pro_immigrant < 2.001, "High", ifelse(pro_immigrant < 3.01, "Mid", "Low")))
  )

# get clean grouping variable (all scale types in one factor)
df <- df %>%
    mutate(
         iv_type2 = ifelse(main_IV_type=="Change in Flow","Flow",main_IV_type),
         iv_type2 = as.factor(iv_type2),
         stat_cat_factor = factor(stat_cat, levels = c("Low","Mid","High", "No Information")),
         belief_cat_factor = factor(belief_cat, levels = c("Low","Mid","High","No Information")),
         topic_cat_factor = factor(topic_cat, levels = c("Low","Mid","High","No Information")),
         total_score_cat_factor = factor(total_score_cat, levels = c("Low","Mid","High","No Information")),
         pro_immigrant_cat_factor = factor(pro_immigrant_cat, levels = c("Low","Mid","High","No Information"))
  ) 




# cntrlist and wavelist

cntrlista <- c("AU", "AT", "BE", "CA", "CL", "HR", "CZ", "DK", "FI", "FR", "DE")
cntrlistb <- c("HU", "IE", "IL", "IT", "JP", "KR", "LV", "LT", "NT", "NZ", "NO")
cntrlistc <- c("PL", "PT","RU", "SK", "SI", "ES", "SE", "CH", "UK", "US", "UY")
wavelist <- names(select(df, w1985:w2016))  



# Team-level 
cri_team_combine <- read.csv(file = "data/cri_team_combine.csv", header = T)




cri_team_combine <- cri_team_combine %>%
  mutate(iv_type2 = ifelse(Stock == 1, "Stock", "Flow"),
         iv_type2 = as.factor(iv_type2),
         stat_cat = ifelse(stat_cat == "Highest" | stat_cat == "High", "High", ifelse(stat_cat == "Low", "Mid", "Low")), # highest is very rare, combine
         stat_cat_factor = factor(stat_cat, levels = c("Low", "Mid", "High")),
         belief_cat = ifelse(belief_cat == "Highest" | belief_cat == "High", "High", ifelse(belief_cat == "Low", "Mid", "Low")), # high and highest are least frequent, combine
         belief_cat_factor = factor(belief_cat, levels = c("Low", "Mid", "High")),
         topic_cat = ifelse(topic_cat == "Highest" | topic_cat == "High", "High", ifelse(topic_cat == "Lowest", "Low", "Mid")), # highest is least frequent, combine
         topic_cat_factor = factor(topic_cat, levels = c("Low", "Mid", "High")),
         total_score_cat = ifelse(total_score_cat == "Lowest" | total_score_cat == "Low", "Low", ifelse(total_score_cat == "High", "Mid", "High")), # low and lowest are least frequent, combine
         total_score_cat_factor = factor(total_score_cat, levels = c("Low", "Mid", "High")),
         pro_immigrant_cat = ifelse(is.na(pro_immigrant), NA, ifelse(pro_immigrant < 2.001, "High", ifelse(pro_immigrant < 3.01, "Mid", "Low"))),
         pro_immigrant_cat_factor = factor(pro_immigrant_cat, levels = c("Low","Mid","High"))
  )











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
                 belief_cat_factor %in% input$belief & stat_cat_factor %in% input$stat & topic_cat_factor %in% input$topic &
                 total_score_cat_factor %in% input$total & pro_immigrant_cat_factor %in% input$proimm)
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
      filter(df,DV %in% input$mspecdv2 & indepv %in% input$mspecivx2 & mator %in% input$emator2 & cluster_any %in% input$clust2 & twowayfe %in% input$twoway2 &
               dv_m %in% input$dv_m2 & iv_type %in% input$mspeciv2)
      
    })
    dfp <- ({
      select(dfp1(), DV, iv_type, software, AME, lower, upper, p)
    })
    dfp$pl <- dfp$p -0.05
    dfp$pu <- dfp$p + 0.05
    sumout2 <- reactive({dfp})
    
    output$pr2 <- renderText({
      pr <- round(
        ((length(which(sumout2()$AME < 0 & sumout()$upper < 0)) ) / (length(sumout2()$AME))*100),1)
      paste(pr, "% indicate a significant negative effect of immigration", sep="")
    })
    
    output$teamn2 <- renderText({
      teamn <- length(sumout2()$AME)
      paste("displaying", teamn, "of 1,260 models")
    })
    
    plot_rdf_spec_curve(dfp, "p", lb = "pl", ub = "pu", est_color = "grey", pt_size = 2, pt_size_highlight = 2, est_color_signeg = "red", lower_to_upper = 1.5, est_label = "Marginal Effect", ribbon = F)
    
    
  })
  
  ### Subjective Conclusion
  output$subject <- renderPlot({
    teamspec <- reactive({
      filter(cri_team_combine, iv_type2 %in% mspeciv3 & belief_cat_factor %in% input$belief3 & stat_cat_factor %in% input$stat3 & 
               topic_cat_factor %in% input$topic3 & total_score_cat_factor %in% input$total3 & pro_immigrant_cat_factor %in% input$proimm3)
    })
    teamspec <- ({
      select(teamspec(), iv_type2, belief_cat_factor, stat_cat_factor, topic_cat_factor,total_score_cat_factor, pro_immigrant_cat_factor,
             Hresult)
    })
    teamspec <- ({
      teamspec[complete.cases(dfspec),]
    })
    attr(teamspec, "choices") <- 1:6
    sumout3 <- reactive({teamspec})
    output$pr3 <- renderText({
      pr3 <- round(
        ((length(which(sumout3()$est < 0 & sumout3()$ub < 0)) ) / (length(sumout3()$est))*100),1)
      paste(pr3, "% indicate a significant negative effect of immigration", sep="")
    })
    
    output$teamn3 <- renderText({
      teamn3 <- length(sumout3()$est)
      paste("displaying", teamn3, "of 1,292 models")
    })
    plot_rdf_spec_curve(teamspec, "est", lb = "lb", ub = "ub", est_color = "grey", pt_size = 2, 
                        pt_size_highlight = 2, est_color_signeg = "red", lower_to_upper = 1.5, 
                        est_label = "Marginal Effect", ribbon = F)
  })
  
}








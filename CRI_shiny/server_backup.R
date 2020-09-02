library("shiny")
library("ggplot2")
library("rdfanalysis")
library("dplyr")


load("dfcri.Rda")

server <- function(input, output, session) {
  
  output$exec <- renderUI({
    url <- a("The Crowdsourced Replication Initiative", href="https://osf.io/preprints/socarxiv/6j9qb/")
    tagList(url)
  })
  
  ### Specification curve AME  
  output$spec_curve <- renderPlot({
    filter1 <- reactive({
      if ("Scale" %in% input$mspecdv) { df %>%
          filter((df$Jobs %in% input$mspecdv | df$Unemp %in% input$mspecdv | df$IncDiff %in% input$mspecdv | 
                    df$OldAge %in% input$mspecdv | df$House %in% input$mspecdv | df$Health %in% input$mspecdv) & df$iv_type %in% input$mspeciv &
                   df$indepv %in% input$mspecivx & df$mator %in% input$emator & df$cluster_any %in% input$clust & df$twowayfe %in% input$twoway &
                   df$dv_m %in% input$dv_m)
      } else { df %>%
          filter((df$Jobs %in% input$mspecdv | df$Unemp %in% input$mspecdv | df$IncDiff %in% input$mspecdv | 
                    df$OldAge %in% input$mspecdv | df$House %in% input$mspecdv | df$Health %in% input$mspecdv & df$Scale == "0") & 
                   df$iv_type %in% input$mspeciv & df$indepv %in% input$mspecivx & df$mator %in% input$emator & df$cluster_any %in% input$clust & 
                   df$twowayfe %in% input$twoway & df$dv_m %in% input$dv_m)
      }
      
    })
    
    #include only waves or combinations of waves ticked
    filterw1 <- reactive({
      filter1() %>% filter(if ("w1985" %in% input$mwave & (!("many" %in% input$many))) filter1()$w1985 %in% input$mwave else 1==1)
    })  
    
    filterw2 <- reactive({
      filterw1() %>% filter(if ("w1990" %in% input$mwave & (!("many" %in% input$many))) filterw1()$w1990 %in% input$mwave else 1==1)
    }) 
    
    filterw3 <- reactive({
      filterw2() %>% filter(if ("w1996" %in% input$mwave & (!("many" %in% input$many))) filterw2()$w1996 %in% input$mwave else 1==1)
    }) 
    
    filterw4 <- reactive({
      filterw3() %>% filter(if ("w2006" %in% input$mwave & (!("many" %in% input$many))) filterw3()$w2006 %in% input$mwave else 1==1)
    }) 
    
    filterwave <- reactive({
      filterw4() %>% filter(if ("w2016" %in% input$mwave & (!("many" %in% input$many))) filterw4()$w2016 %in% input$mwave else 1==1)
    }) 
    
    #include only countries or combinations of countries ticked
    filter2 <- reactive({
      filterwave() %>% filter(if ("AU" %in% input$countries1b & (!("any" %in% input$countries1a))) filter1()$AU %in% input$countries1b else 1==1)
    })
    
    filter3 <- reactive({
      filter2() %>% filter(if ("AT" %in% input$countries1b & (!("any" %in% input$countries1a))) filter2()$AT %in% input$countries1b else 1==1)
    })
    
    filter4 <- reactive({
      filter3() %>% filter(if ("BE" %in% input$countries1b & (!("any" %in% input$countries1a))) filter3()$BE %in% input$countries1b else 1==1)
    })
    
    filter5 <- reactive({
      filter4() %>% filter(if ("CA" %in% input$countries1b & (!("any" %in% input$countries1a))) filter4()$CA %in% input$countries1b else 1==1)
    })
    
    filter6 <- reactive({
      filter5() %>% filter(if ("CL" %in% input$countries1b & (!("any" %in% input$countries1a))) filter5()$CL %in% input$countries1b else 1==1)
    })
    
    filter7 <- reactive({
      filter6() %>% filter(if ("HR" %in% input$countries1b & (!("any" %in% input$countries1a))) filter6()$HR %in% input$countries1b else 1==1)
    })
    
    filter8 <- reactive({
      filter7() %>% filter(if ("CZ" %in% input$countries1b & (!("any" %in% input$countries1a))) filter7()$CZ %in% input$countries1b else 1==1)
    })
    
    filter9 <- reactive({
      filter8() %>% filter(if ("DK" %in% input$countries1b & (!("any" %in% input$countries1a))) filter8()$DK %in% input$countries1b else 1==1)
    })
    
    filter10 <- reactive({
      filter9() %>% filter(if ("FI" %in% input$countries1b & (!("any" %in% input$countries1a))) filter9()$FI %in% input$countries1b else 1==1)
    })
    
    filter11 <- reactive({
      filter10() %>% filter(if ("FR" %in% input$countries1b & (!("any" %in% input$countries1a))) filter10()$FR %in% input$countries1b else 1==1)
    })
    
    filter12 <- reactive({
      filter11() %>% filter(if ("DE" %in% input$countries1b & (!("any" %in% input$countries1a))) filter11()$DE %in% input$countries1b else 1==1)
    })
    
    filter13 <- reactive({
      filter12() %>% filter(if ("HU" %in% input$countries1b & (!("any" %in% input$countries1a))) filter12()$HU %in% input$countries1c else 1==1)
    })
    
    filter14 <- reactive({
      filter13() %>% filter(if ("IE" %in% input$countries1b & (!("any" %in% input$countries1a))) filter13()$IE %in% input$countries1c else 1==1)
    })
    
    filter15 <- reactive({
      filter14() %>% filter(if ("IL" %in% input$countries1b & (!("any" %in% input$countries1a))) filter14()$IL %in% input$countries1c else 1==1)
    })
    
    filter16 <- reactive({
      filter15() %>% filter(if ("IT" %in% input$countries1b & (!("any" %in% input$countries1a))) filter15()$IT %in% input$countries1c else 1==1)
    })
    
    filter17 <- reactive({
      filter16() %>% filter(if ("JP" %in% input$countries1b & (!("any" %in% input$countries1a))) filter16()$JP %in% input$countries1c else 1==1)
    })
    
    filter18 <- reactive({
      filter17() %>% filter(if ("KR" %in% input$countries1b & (!("any" %in% input$countries1a))) filter17()$KR %in% input$countries1c else 1==1)
    })
    
    filter19 <- reactive({
      filter18() %>% filter(if ("LV" %in% input$countries1b & (!("any" %in% input$countries1a))) filter18()$LV %in% input$countries1c else 1==1)
    })
    
    filter20 <- reactive({
      filter19() %>% filter(if ("LT" %in% input$countries1b & (!("any" %in% input$countries1a))) filter19()$LT %in% input$countries1c else 1==1)
    })
    
    filter21 <- reactive({
      filter20() %>% filter(if ("NT" %in% input$countries1b & (!("any" %in% input$countries1a))) filter20()$NT %in% input$countries1c else 1==1)
    })
    
    filter22 <- reactive({
      filter21() %>% filter(if ("NZ" %in% input$countries1b & (!("any" %in% input$countries1a))) filter21()$NZ %in% input$countries1c else 1==1)
    })
    
    filter23 <- reactive({
      filter22() %>% filter(if ("NO" %in% input$countries1b & (!("any" %in% input$countries1a))) filter22()$NO %in% input$countries1c else 1==1)
    })
    
    filter24 <- reactive({
      filter23() %>% filter(if ("PL" %in% input$countries1b & (!("any" %in% input$countries1a))) filter23()$PL %in% input$countries1d else 1==1)
    })
    
    filter25 <- reactive({
      filter24() %>% filter(if ("PT" %in% input$countries1b & (!("any" %in% input$countries1a))) filter24()$PT %in% input$countries1d else 1==1)
    })
    
    filter26 <- reactive({
      filter25() %>% filter(if ("RU" %in% input$countries1b & (!("any" %in% input$countries1a))) filter25()$RU %in% input$countries1d else 1==1)
    })
    
    filter27 <- reactive({
      filter26() %>% filter(if ("SK" %in% input$countries1b & (!("any" %in% input$countries1a))) filter26()$SK %in% input$countries1d else 1==1)
    })
    
    filter28 <- reactive({
      filter27() %>% filter(if ("SI" %in% input$countries1b & (!("any" %in% input$countries1a))) filter27()$SI %in% input$countries1d else 1==1)
    })
    
    filter29 <- reactive({
      filter28() %>% filter(if ("ES" %in% input$countries1b & (!("any" %in% input$countries1a))) filter28()$ES %in% input$countries1d else 1==1)
    })
    
    filter30 <- reactive({
      filter29() %>% filter(if ("SE" %in% input$countries1b & (!("any" %in% input$countries1a))) filter29()$SE %in% input$countries1d else 1==1)
    })
    
    filter31 <- reactive({
      filter30() %>% filter(if ("CH" %in% input$countries1b & (!("any" %in% input$countries1a))) filter30()$CH %in% input$countries1d else 1==1)
    })
    
    filter32 <- reactive({
      filter31() %>% filter(if ("UK" %in% input$countries1b & (!("any" %in% input$countries1a))) filter31()$UK %in% input$countries1d else 1==1)
    })
    
    filter33 <- reactive({
      filter32() %>% filter(if ("US" %in% input$countries1b & (!("any" %in% input$countries1a))) filter32()$US %in% input$countries1d else 1==1)
    })
    
    filter34 <- reactive({
      filter33() %>% filter(if ("UY" %in% input$countries1b & (!("any" %in% input$countries1a))) filter33()$UY %in% input$countries1d else 1==1)
    })
    
    
    filterdf <- ({
      select(filter34(), dv_type, iv_type, software, est, lb, ub)
    })
    
    sumout <- reactive({filterdf})
    
    output$pr <- renderText({
      pr <- round(
        ((length(which(sumout()$est < 0 & sumout()$ub < 0)) ) / (length(sumout()$est))*100),1)
      paste(pr, "% indicate a significant negative effect of immigration", sep="")
    })
    
    output$teamn <- renderText({
      teamn <- length(sumout()$est)
      paste("displaying", teamn, "of 1,260 models")
    })
    
    plot_rdf_spec_curve(filterdf, "est", "lb", "ub", est_color = "grey", pt_size = 2, pt_size_highlight = 2, est_color_signeg = "red", lower_to_upper = 1.5, est_label = "Marginal Effect", ribbon = F)
  }) ### end of specification curve
  ### P-values
  
  output$p_val <- renderPlot({
    dfnew <- reactive({
      filter(df, dv_type %in% input$mspecdv2 & indepv %in% input$mspecivx2 & mator %in% input$emator2 & cluster_any %in% input$clust2 & twowayfe %in% input$twoway2 &
               dv_m %in% input$dv_m2 & iv_type %in% input$mspeciv2)
    })
    hist(dfnew()$p)
    
    
  })
  
  ### Hypothesis Testing
  
}


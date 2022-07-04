# Dredge function 
# Run and save results to reduce reproducibility computing time.

pacman::p_load("MuMIn")

cri_ml <- read.csv(file = here::here("results/cri_ml.csv"), header = TRUE)

# remove NAs
cri_ml <- cri_ml[!is.na(cri_ml$AME_Z),]

# set global option
options(na.action = "na.omit")

### create a function that takes in a list of variables as input and all interaction combinations as output

final_frame <- data.frame(Var1 = character(), Var2 = character())
dredge_input <- function(input_vars){
        for(i in seq_along(input_vars)){
                main_var = input_vars[i]
                remain_var = tail(input_vars, -i)
                combo_frame = expand.grid(main_var, remain_var)
                if(nrow(combo_frame) != 0){
                        final_frame = rbind(final_frame, combo_frame)
                }
        }
    output_string = paste(final_frame$Var1, final_frame$Var2, sep = "*")
    return(output_string)
}


### load csv file containing all usable variables

input_csv <- read.csv(here::here("data", "dredge_int.csv"))
colnames(input_csv) <- c("var", "used")


input_csv <- input_csv[which(input_csv$used == 1),]

input <- input_csv$var

output <- dredge_input(input)

dredge_mod <- lm(as.formula(paste("AME_Z ~", paste(output, collapse = "+"))), data = cri_ml)

########################################################################################################################
########################################################################################################################
########################################################################################################################


### DVs and Measurement

dredge1 <- lm(AME_Z ~ Jobs + IncDiff + House + Unemp + Health + OldAge + Flow + Stock + ChangeFlow + Stock*Jobs + Stock*House + Stock*IncDiff , data = cri_ml)

models1 <- dredge(dredge1)

dredge2 <- lm(AME_Z ~ Jobs + IncDiff + House + Health +  Flow + Stock + ChangeFlow + Stock*IncDiff , data = cri_ml)

models2 <- dredge(dredge2)


dredge3 <- lm(AME_Z ~ Jobs + IncDiff + House + Health +  Flow + Stock + ChangeFlow + Stock*IncDiff + w1996 + w2006 + w2016 + w2006*w2016 + orig13 + orig13*Jobs + eeurope + allavailable, data = cri_ml)

models3 <- dredge(dredge3)

dredge4 <- lm(AME_Z ~ Jobs + IncDiff + House + Flow + Stock + ChangeFlow + Stock*IncDiff + w2016 + orig13 +  eeurope + allavailable + twowayfe + level_cyear + mlm_fe + mlm_re, data = cri_ml)

models4 <- dredge(dredge4)

dredge5 <- lm(AME_Z ~ Jobs + IncDiff + House + Flow + Stock + ChangeFlow + Stock*IncDiff + w2016 + orig13 +  eeurope + twowayfe + level_cyear + mlm_re + pro_immigrant + stats_ipred + belief_ipred, data = cri_ml)

models5 <- dredge(dredge5)

dredge6 <- lm(AME_Z ~ Jobs + IncDiff + House + Flow + Stock + ChangeFlow + Stock*IncDiff + w2016 + orig13 +  eeurope + twowayfe + level_cyear + mlm_re + stats_ipred + twowayfe*Jobs + twowayfe*Stock, data = cri_ml)

models6 <- dredge(dredge6)

dredge7 <- lm(AME_Z ~ Jobs + IncDiff + House + Stock + ChangeFlow + Stock*IncDiff + w2016 + orig13 +  eeurope + twowayfe + level_cyear + twowayfe*Jobs + twowayfe*Stock, data = cri_ml)

models7 <- dredge(dredge7)

# Interestingly the 'best' models (via AICc) have only one variable. But this indicates the low explanatory power of each additional variable.

dredge8 <- lmer(AME_Z ~ Jobs + IncDiff + House + Stock + ChangeFlow + Stock*IncDiff + w2016 + orig13 +  eeurope + twowayfe + level_cyear + twowayfe*Jobs + twowayfe*Stock + (1 | u_teamid), data = cri_ml)

models8 <- dredge(dredge8)

save.image(file = here::here("code/script/dredge.Rdata"))

# Dredge function 
# Run and save results to reduce reproducibility computing time.

pacman::p_load("MuMIn")

cri_ml <- read.csv(file = here::here("results/cri_ml.csv"), header = TRUE)

# remove NAs
cri_ml <- cri_ml[!is.na(cri_ml$AME_Z),]

# set global option
options(na.action = "na.fail")


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

dredge8 <- lmer(AME_Z ~ Jobs + IncDiff + House + Stock + ChangeFlow + Stock*IncDiff + w2016 + orig13 +  eeurope + twowayfe + level_cyear + twowayfe*Jobs + twowayfe*Stock + (1 | team), data = cri_ml)

models8 <- dredge(dredge8)

rm(models1,models2,models3,models4,models5,models6,models7,models8)

save.image(file = here::here("code/script/dredge.Rdata"))

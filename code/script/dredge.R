# Dredge function 
# Run and save results to reduce reproducibility computing time.

pacman::p_load("MuMIn", "tidyverse")

cri_ml <- read.csv(file = here::here("results/cri_ml.csv"), header = TRUE)

# remove NAs
cri_ml <- cri_ml[!is.na(cri_ml$AME_Z),]

# set global option
options(na.action = "na.omit")

### create a function that takes in a list of variables as input and all interaction combinations as output

dredge_input <- function(input_vars, random_state = 1234, n_sample){
    final_frame <- data.frame(Var1 = character(), Var2 = character())
        for(i in seq_along(input_vars)){
                main_var = input_vars[i]
                remain_var = tail(input_vars, -i)
                combo_frame = expand.grid(main_var, remain_var)
                if(nrow(combo_frame) != 0){
                        final_frame = rbind(final_frame, combo_frame)
                }
        }
    ## number of combinations = n(n-1)/2.
    output_string = paste(final_frame$Var1, final_frame$Var2, sep = "*")
    set.seed(random_state)
    random_output = sample(output_string, n_sample)
    return(random_output)
}


### load csv file containing all usable variables

input_csv <- read.csv(here::here("data", "dredge_int.csv"))
colnames(input_csv) <- c("var", "used")

# Only those variables that are relevant
input_csv <- input_csv[which(input_csv$used == 1),]

input <- input_csv$var

# trim interactions that are empty cells or over 95% in a dichotomous distribution
all_interactions <- dredge_input(input)

keep_matrix <- matrix(nrow = length(all_interactions), ncol = 2)
keep_matrix[,1] <- all_interactions
keep_matrix <- as.data.frame(keep_matrix)
colnames(keep_matrix) <- c("int","sum")

# create interactions and get summary stats
x <- as.data.frame(matrix(ncol = length(all_interactions), nrow = length(cri_ml$X)))
colnames(x) <- all_interactions
cri_x <- cbind(cri_ml, x)

# Fill in the actual value for the interaction in columns 245 through 5809 of the df cri_x 

for (i in all_interactions) {
    g <- str_split(i, "\\*")
    r <- paste0("\"", i, "\"")
    cri_x[, r] <- ifelse(is.numeric(cri_x[, paste('\"', g[[1]][1], '\"', sep = "")]) & is.numeric(cri_x[, paste("\"", g[[1]][2], "\"", sep = "")]), cri_x[, paste0("\"", g[[1]][1], "\"")] * cri_x[, paste0("\"", g[[1]][2], "\"")], NA)
}

# Remove NAs and columns that have no variance.

cri_var <- cri_x %>%
    summarise_all(sd, na.rm = T)

cri_var[cri_var==0] = NA
cri_var <- cri_var[,!is.na(cri_var)]

output <- dredge_input(input, n_sample=10)
options(na.action = "na.omit")
dredge_mod <- lm(as.formula(paste("AME_Z ~", paste(output, collapse = "+"))), data = cri_ml)
options(na.action = "na.fail")
models <- dredge(dredge_mod)

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

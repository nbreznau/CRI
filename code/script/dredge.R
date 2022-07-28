# Dredge function 
# Run and save results to reduce reproducibility computing time.

pacman::p_load("MuMIn", "tidyverse")

cri_ml <- read.csv(file = here::here("results/cri_ml.csv"), header = TRUE)

# remove NAs
cri_ml <- cri_ml[!is.na(cri_ml$AME_Z),]

# set global option
options(na.action = "na.omit")

### create a function that takes in a list of variables as input and all interaction combinations as output
random_state = 1234
dredge_input <- function(input_vars, n_sample){
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
    first_half = str_split(i, "\\*")[[1]][1]
    second_half = str_split(i, "\\*")[[1]][2]
    if(is.numeric(cri_x[,first_half]) & is.numeric(cri_x[,second_half])){
            cri_x[,i] = cri_x[,first_half] *cri_x[,second_half]
    }

}

# Remove NAs and columns that have no variance.

cri_var <- cri_x %>%
    summarise_all(sd, na.rm = T)

# remove variables that have almost no variance as well (under 0.05 and between 0.95 and 1)
cri_var[cri_var >= 0 & cri_var <= 0.05] = NA
cri_var[cri_var >= 0.95 & cri_var <= 1] = NA
cri_var <- cri_var[,!is.na(cri_var)]

keep_vars <- colnames(cri_var)
cri_x <- cri_x %>%
    select(c(keep_vars))

#remove unused variables from input list
input <- input[input %in% c(keep_vars)]

#replace the * in variable names with the _ (otherwise dredge splits them)
colnames(cri_x) <- gsub(x = colnames(cri_x), pattern = "\\*", replacement = "_")
keep_vars_stars <- keep_vars
keep_vars <- gsub(keep_vars, pattern = "\\*", replacement = "_")

#remove results from variable list
keep_vars <- keep_vars[!(keep_vars %in% c("X", "u_teamid", "AME_Z", "upper_Z", "lower_Z",
                                     "u_delibtreatmentgroup1", "AME", "lower", "upper",
                                     "error", "z", "p", "team"))]


# generate random samples of 10 variables, that is all that the dredge can handle at once

i = 1
# set number of variables
s = 10
# set number of runs
r = 1000
for (n in 1:1000) {
    random_state = 1234 + i
    output <- sample(keep_vars, s)
    output <- gsub(x = output, pattern = "\\*", replacement = "_")
    options(na.action = "na.omit")
    dredge_mod <- lm(as.formula(paste("AME_Z ~", paste(output, collapse = "+"))), data = cri_x)
    assign(paste0("dredge_mod_", n), dredge_mod)
    options(na.action = "na.fail")
    models <- dredge(dredge_mod)
    assign(paste0("models_", n), models)
    i = i + 1
}

rm(list=ls(pattern="^dredge_mod_"))
#save.image(here::here("results","dredge_models_1000.Rdata"))

# Extract top two models from each result
dredge_results <- as.data.frame(matrix(ncol = 16, nrow = 2001))

s = 1
for (m in 1:1000) {
    x <- get(paste("models_",m, sep = ""))
    x <- x[1:2,]
    
    for (r in 1:2) {
        x[r,] <- ifelse(!(colnames(x[r,]) %in% c("df","logLik","AICc","delta","weight")), 
                             ifelse(!is.na(x[r,]), colnames(x[r,]), NA), x[r,])
    }
    
    y <- x[,1:11]
    z <- x[,12:16]
    dredge_results[s:(s+1),1:11] <- y
    dredge_results[s:(s+1),12:16] <- z
    s = s+2

}

colnames(dredge_results)[12:16] <- c("df","logLik","AICc","delta","weight")
write.csv(dredge_results, here::here("results","dredge_results.csv"), row.names = F)

dredge_results <- read.csv(here::here("results","dredge_results.csv"))

# Sort by AICc
dredge_results <- dredge_results[order(dredge_results$AICc, decreasing = T),]

# Identify variables in the first 20 best models and re-dredge them
dredge_best <- dredge_results[1:20,]

x <- as.vector(dredge_best$V2)[!is.na(dredge_best$V2)]
x1 <- as.vector(dredge_best$V3)[!is.na(dredge_best$V3)]
x2 <- as.vector(dredge_best$V4)[!is.na(dredge_best$V4)]
x3 <- as.vector(dredge_best$V5)[!is.na(dredge_best$V5)]
x4 <- as.vector(dredge_best$V6)[!is.na(dredge_best$V6)]
x5 <- as.vector(dredge_best$V7)[!is.na(dredge_best$V7)]
x6 <- as.vector(dredge_best$V8)[!is.na(dredge_best$V8)]
x7 <- as.vector(dredge_best$V9)[!is.na(dredge_best$V9)]
x8 <- as.vector(dredge_best$V10)[!is.na(dredge_best$V10)]
x9 <- as.vector(dredge_best$V11)[!is.na(dredge_best$V11)]

x <- c(x,x1,x2,x3,x4,x5,x6,x7,x8,x9)

# remove duplicates
dredge_best_vnames <- unique(x)

# we have 19 variables

# Again run dredge loop with 7 variables this time

i = 1
# set number of variables
s = 7
# set number of runs
r = 100
for (n in 1:100) {
    random_state = 1234 + i
    output <- sample(dredge_best_vnames, s)
    output <- gsub(x = output, pattern = "\\*", replacement = "_")
    options(na.action = "na.omit")
    dredge_mod <- lm(as.formula(paste("AME_Z ~", paste(output, collapse = "+"))), data = cri_x)
    assign(paste0("dredge_mod_", n), dredge_mod)
    options(na.action = "na.fail")
    models <- dredge(dredge_mod)
    assign(paste0("models_", n), models)
    i = i + 1
}

s = 1
for (m in 1:100) {
    x <- get(paste("models_",m, sep = ""))
    x <- x[1:2,]
    
    for (r in 1:2) {
        x[r,] <- ifelse(!(colnames(x[r,]) %in% c("df","logLik","AICc","delta","weight")), 
                        ifelse(!is.na(x[r,]), colnames(x[r,]), NA), x[r,])
    }
    
    y <- x[,1:11]
    z <- x[,12:16]
    dredge_results[s:(s+1),1:11] <- y
    dredge_results[s:(s+1),12:16] <- z
    s = s+2
    
}

dredge_best_vars <- ifelse(keep_vars)


########################################################################################################################
########################################################################################################################
########################################################################################################################


# Old Version - Dredge 'By Hand'

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

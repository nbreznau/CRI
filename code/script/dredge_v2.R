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

dredge_results_best <- as.data.frame(matrix(ncol = 16, nrow = 201))

s = 1
for (m in 1:100) {
    x <- get(paste("models_",m, sep = ""))
    
    if (length(x[,1]) > 127) {
        x <- x[1:2,]
        for (r in 1:2) {
            x[r,] <- ifelse(!(colnames(x[r,]) %in% c("df","logLik","AICc","delta","weight")), 
                        ifelse(!is.na(x[r,]), colnames(x[r,]), NA), x[r,])
        }
    
        y <- x[,1:8]
        z <- x[,9:13]
        dredge_results_best[s:(s+1),1:8] <- y
        dredge_results_best[s:(s+1),9:13] <- z
        s = s+2
    }
    else {
        print("skipped")
    }
}


colnames(dredge_results_best)[9:13] <- c("df","logLik","AICc","delta","weight")
dredge_results_best <- dredge_results_best[order(dredge_results_best$AICc, decreasing = T),]

# Identify variables in the first 20 best 'models'
dredge_best <- dredge_results_best[1:20,]

x <- as.vector(dredge_best$V2)[!is.na(dredge_best$V2)]
x1 <- as.vector(dredge_best$V3)[!is.na(dredge_best$V3)]
x2 <- as.vector(dredge_best$V4)[!is.na(dredge_best$V4)]
x3 <- as.vector(dredge_best$V5)[!is.na(dredge_best$V5)]
x4 <- as.vector(dredge_best$V6)[!is.na(dredge_best$V6)]
x5 <- as.vector(dredge_best$V7)[!is.na(dredge_best$V7)]
x6 <- as.vector(dredge_best$V8)[!is.na(dredge_best$V8)]


x <- c(x,x1,x2,x3,x4,x5,x6)

# remove duplicates
dredge_best_vnames <- unique(x)

write.csv(dredge_best_vnames, here::here("code", "script", "dredge_best_auto.csv"), row.names = F)



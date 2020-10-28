# Interactive Exploration of Data-Analytic Choices

We created a shinyapp to allow users to investigate results of Phase 3 of the Crowdsourced Replication Initiative, "Testing the Hypothesis". Users can plot their own specification curves of average marginal effects, subjective team conclusions about their tests and p-values.

## Using our shinyapps.io server

Click here XXXX *Note that we currently have limited bandwidth, so you might have lags or waiting times until we upgrade this*

## Run the app on your local machine

### Step 1. Import the code and data

Either clone our entire repository, or just this folder CRI/CRI_shiny. You need the files ui.R and server.R plus the folder 'data' which contains cri_shiny.csv and cri_shiny_team.csv

### Step 2. Initial run required

First open ui.R and server.R codefiles in your R session. Then select all code in server.R and run it. Do this by placing your cursor in the server.R code anywhere and pressing Ctrl+A to select all and then hit Ctrl+Enter. *You cannot do this by pressing Ctrl+Shift+Enter simultaneously because this command will launch the ShinyApp!*. Now repeat this process for the ui.R code.

### Step 3. Launch the app

Next go to the command line and run the following

`> ShinyApp(ui, server)`

## Internal Use: For deploying on shinyapps.io

Follow the steps above. Then load the 'rsconnect' package, most recent available using devtools.

`devtools::install_github("rstudio/rsconnect")
library("rsconnect")`

Then log into shinyapps.io account and get the token plus secret key.
1. Click on 'Tokens' in the dropdown menu under name
2. Click on 'Show'
3. Click on 'Show Secret'
4. Copy to clipboard
5. Paste this entire command into the command line

Make sure the shinyapp is not running locally (so close the window if open). Then deployApp.

`> deployApp(appName = "cri_shiny")



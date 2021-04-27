# Interactive Exploration of Data-Analytic Choices

We created a [Shiny](https://shiny.rstudio.com/) app to allow users to investigate the outcome variability we found in our project themselves. This can be done in one of two ways.

## 1. Using our shinyapps.io server

Click here: [`Launch Interactive App in Browser`](https://nate-breznau.shinyapps.io/shiny/) 

## 2. Run the app on your local machine with RStudio

If your use [RStudio](https://www.rstudio.com/), open the file `CRI/shiny/server.R` and click on the "Run App" button at the top right of the editor pane.

## 3. Run the app on your local machine

### Step 1. Download the code and data

Either clone the entire repository, or download just the folder `CRI/shiny` (where this file is located).
You need the files `ui.R` and `server.R` plus the folder `CRI/shiny/data/` which contains `cri_shiny.csv` and `cri_shiny_team.csv`.

### Step 2. Launch the app

Start R in the directory `CRI/` and run the following command:

```r
shiny::runApp("shiny")
```

The command will print out a local URL, which you can open in your browser.

## 4. Run app on Binder

The [Binder](https://mybinder.org/) configuration included in the repository also allows to run the Shiny app by opening the following URL:
[https://mybinder.org/v2/gh/nbreznau/CRI/HEAD?urlpath=shiny%2Fshiny%2F](https://mybinder.org/v2/gh/nbreznau/CRI/HEAD?urlpath=shiny%2Fshiny%2F)

## Internal Use: For deploying on shinyapps.io

Follow the steps above. Then load the 'rsconnect' package, most recent available using devtools.

```r
devtools::install_github("rstudio/rsconnect")
library("rsconnect")
```

Then log into shinyapps.io account and get the token plus secret key.
1. Click on 'Tokens' in the dropdown menu under name
2. Click on 'Show'
3. Click on 'Show Secret'
4. Copy to clipboard
5. Paste this entire command into the command line

Make sure the Shiny app is not running locally (so close the window if open). Then deployApp.

```r
deployApp(appName = "shiny")
```

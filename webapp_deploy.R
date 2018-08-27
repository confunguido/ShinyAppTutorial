#=============================================================================#
# Author: Guido Espana
#=============================================================================#
# Run the app in your local computer ---------------
#=============================================================================#
library(shiny)
runApp()

#=============================================================================#
# Deploy the app on shinyapps.io ---------------
#=============================================================================#
library(rsconnect)
rsconnect::setAccountInfo(name='yorname',
                          token='YOURTOKEN',
                          secret='yourSECRET')

rsconnect::deployApp(appDir = getwd())

# showLogs is not necessary
# run in if you need to see what's going on
rsconnect::showLogs(streaming=TRUE)



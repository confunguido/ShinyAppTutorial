#=============================================================================#
# Author: Guido Espana 
# User interface design ---------------
#=============================================================================#
ui =fluidPage(
      sidebarLayout(
        sidebarPanel = sidebarPanel(
          sliderInput(
            inputId = "PE9",
            label = "Prior exposure in 9-year olds before vaccination (PE9)",
            min = 0.1,
            max = 0.9,
            value = 0.7
          ),
          sliderInput(
            inputId = "Coverage",
            label = "Coverage",
            min = 0.4,
            max = 0.8,
            value = 0.8
          ),
          sliderInput(
            inputId = "Age",
            label = "Age of vaccination",
            min = 9,
            max = 17,
            value = 9,
            step = 1
          )
        ), 
        mainPanel = mainPanel(
          plotOutput("plotAverted")
        )
      )
  )

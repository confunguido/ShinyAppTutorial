#=============================================================================#
# Author: Guido Espana
#=============================================================================#
# user input ---------------
#=============================================================================#

#=============================================================================#
# Functions ---------------
#=============================================================================#
plot_color_bar = function(myColStrip_in, myColBreaks_in,myColBar_in, myTicks_in, label_in = ""){
  image(t(myColStrip_in),
        col = myColBar_in, breaks = myColBreaks_in,
        xlim = c(0,1.0), axes = F)
  ylims = par("usr")[c(3,4)]
  myBarTicks = seq(from = ylims[1], to = ylims[2], by = diff(ylims)/(length(myTicks_in) - 1))
  # print(myBarTicks)
  myBarTickLabels = myTicks_in
  axis(4, at = myBarTicks, labels = myBarTickLabels,las = 1)
  abline(h = myBarTicks[2], col = "black", lwd = 2)
  mtext(label_in, side = 4, line = 2, outer = F, lwd = 2)
}
plot_averted_heatmap = function(model_hosp_averted_in,  sp9_in, age_in, coverage_in){
  sensitivity_array = seq(from = 0, by = 0.02, to  = 1.0)
  specificity_array = seq(from = 0, by = 0.02, to  = 1.0)
  
  sensitivity_specificity_grid = expand.grid(
    Specificity = specificity_array,
    Sensitivity = sensitivity_array)
  
  lb = -0.15;ub = 0.15;n_breaks = 50
  
  # Create input data frame with user input
  intervention_data = data.frame(
    Specificity = sensitivity_specificity_grid$Specificity, 
    Sensitivity = sensitivity_specificity_grid$Sensitivity,
    Age = age_in, SP9 = sp9_in, Coverage = coverage_in)

  cases_prediction_grid =  predict(
    model_hosp_averted_in, intervention_data, predict.all = F)
  
  #fill up the matrix with the proportion of cases averted  
  cases_averted_matrix = matrix(cases_prediction_grid, 
                                length(specificity_array), 
                                length(sensitivity_array),byrow = T)
  
  #colorbar settings
  my_col_bar = rainbow(n_breaks + 20)[-c(1:10,((n_breaks+11):(n_breaks+20)))]
  my_col_breaks = seq(lb,ub,by = (ub - lb)/n_breaks)
  my_col_breaks_ticks = seq(lb,ub,by = (ub - lb)/2)
  my_col_strip = as.matrix((my_col_breaks + diff(my_col_breaks)[1] / 2)[-length(my_col_breaks)])
  
  # Plot the heatmap with contour lines
  layout(matrix(1:2,1,2),widths = c(3,1), heights = c(1,1))
  par(mar = c(1,2,0,1), oma = c(3,2,3,2))
  
  image(
    specificity_array,sensitivity_array, t(cases_averted_matrix), 
    col = my_col_bar,
    breaks = seq(lb,ub,by = (ub - lb)/n_breaks),ylab = "", xlab = ""
  )
  breaks_array = seq(lb,ub, by = 0.015)
  contour(
    x=specificity_array,
    y=sensitivity_array,
    z=t(cases_averted_matrix),
    level=breaks_array,
    lwd= c(rep(0.1,length(which(breaks_array <0))), 1, rep(0.1,length(which(breaks_array > 0)))),
    c(rep(0.1,n_breaks/2),2,rep(0.1,n_breaks/2)),
    add=T,drawlabels=T
  )
  
  mtext(text = expression(bold("Specificity")), side = 1, line = 2.5, cex = 1)    
  mtext(text = expression(bold("Sensitivity")), side = 2, line = 2.5, cex = 1)    
  mtext(text = expression(bold("Hospitalizations")), side = 3, line = 1, cex = 1)
  
  plot_color_bar(myColStrip_in = my_col_strip, 
                 myColBreaks_in = my_col_breaks, 
                 myColBar_in = my_col_bar, 
                 myTicks_in = my_col_breaks_ticks,
                 label_in = expression(bold("Proportion averted")))
  
}
#=============================================================================#
# Server ---------------
#=============================================================================#
library(randomForest)
set.seed(123)
model_hosp_averted = readRDS('./input/model_hosp_test_novax.RDS')

server = function(input, output){
  output$plotAverted = renderPlot({
   plot_averted_heatmap(model_hosp_averted, input$PE9, input$Age,input$Coverage)
  })
}

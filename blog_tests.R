#=============================================================================#
# Author: Guido Espana ----
#=============================================================================#
library(randomForest)
set.seed(123)
cases_averted = readRDS('./input/model_hosp_test_novax.RDS')

intervention_data = data.frame(Sensitivity = 0.8, Specificity = 0.8, Coverage = 0.8,
                               Age = 9, SP9 = 0.7)

print(predict(cases_averted,newdata = intervention_data))


## test-----
sensitivity_specificity_grid = expand.grid(
  Specificity = seq(from = 0, by = 0.02, to  = 1.0),
  Sensitivity = seq(from = 0, by = 0.02, to  = 1.0))

lb = -0.15;ub = 0.15;n.breaks = 50

# Create input data frame with user input
intervention_data = data.frame(
  Specificity = sensitivity_specificity_grid$Specificity, 
  Sensitivity = sensitivity_specificity_grid$Sensitivity,
  Age = age_in, SP9 = sp9_in, Coverage = coverage_in)

cases_prediction_grid =  predict(
  model_hosp_averted_in, intervention_data, predict.all = F)

#fill up the matrix with the proportion of cases averted  
cases_averted_matrix = matrix(
  cases_prediction_grid,
  nrow(sensitivity_specificity_grid), 
  nrow(sensitivity_specificity_grid))

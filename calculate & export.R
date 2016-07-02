# Data For the Latest Day, main strategies --------------------------------
# Variable classifications. Each classification means
# that a certain calculation (sum, mean,max,prod) should be
# applied to those variables.

alm.env$vartype <- list()

alm.env$vartype$sums <- c('NombreFamilia', 'RentDiaria',
                          'Suscripciones', 'Rescates')

alm.env$vartype$avgs <- c('Exposicion','Margen_Over_Equity_Ratio',
                          'Leverage_Ratio','RentDiaria','PatFamiliaFinal')

alm.env$vartype$prods <- 'Profit_Factor'

resetReports()
# Latest data -------------------------------------------------------------

# This section brings only the summary for the latest data

alm.env$db$pnl %>%
  filter(NombreFamilia %in% alm.env$portnames$main) %>%
  theLatest() %>%
  asReport('Portfolio_Latest_Indicators')



# Date Range Calculations -------------------------------------------------


# This section does all the types of calculations for all dates
# and for all the variable types.
# It saves them on the report objects for the alm.env environment



for (iLoop in 1:length(alm.env$rdt)) {
  # Sums
  alm.env$db$pnl %>%
    filter(NombreFamilia %in% alm.env$portnames$main) %>%
    filter(Fecha %within% alm.env$rdt[[iLoop]]) %>%
    filter(variable %in% alm.env$vartype$sums) %>%
    group_by(NombreFamilia, variable) %>%
    summarise(value = sum(value)) %>%
    mutate(periodo = names(alm.env$rdt)[iLoop], type = 'suma') %>%
    asReport('metricas_periodicas', append = TRUE)
  
  # Means
  alm.env$db$pnl %>%
    filter(NombreFamilia %in% alm.env$portnames$main) %>%
    filter(Fecha %within% alm.env$rdt[[iLoop]]) %>%
    filter(variable %in% alm.env$vartype$avgs) %>%
    group_by(NombreFamilia, variable) %>%
    summarise(value = mean(value)) %>%
    mutate(periodo = names(alm.env$rdt)[iLoop], type = 'promedio') %>%
    asReport('metricas_periodicas', append = TRUE)
  
  # Max
  alm.env$db$pnl %>%
    filter(NombreFamilia %in% alm.env$portnames$main) %>%
    filter(Fecha %within% alm.env$rdt[[iLoop]]) %>%
    filter(variable %in% alm.env$vartype$avgs) %>%
    group_by(NombreFamilia, variable) %>%
    summarise(value = max(value)) %>%
    mutate(periodo = names(alm.env$rdt)[iLoop], type = 'maximos') %>%
    asReport('metricas_periodicas', append = TRUE)
  
  
  # Prod
  alm.env$db$pnl %>%
    filter(NombreFamilia %in% alm.env$portnames$main) %>%
    filter(Fecha %within% alm.env$rdt[[iLoop]]) %>%
    filter(variable %in% alm.env$vartype$prods) %>%
    group_by(NombreFamilia, variable) %>%
    summarise(value = prod(value) - 1) %>%
    mutate(periodo = names(alm.env$rdt)[iLoop], type = 'productos') %>%
    asReport('metricas_periodicas', append = TRUE)
  
}



# Working Examples --------------------------------------------------------

# Here is a simple, non param function that shows the full db
# It can show any of the datbases on the same function.

dbContents('pnl') %>%
  reverseDate() %>%
  arrange(NombreFamilia) %>%
  filter(Fecha >= '2016-01-01') %>%
  asReport('full_pnl')

dbContents('bulk')
dbContents('pnl')

dbContents('bulk') %>% theLatest()

theLatest(dbContents('pnl')) %>% filter(NombreFamilia %in% 'VIX') %>%
  asReport('Latest_Vix_Variables')

# next one returns the exposure, with the leverage ratio

# But first do a generic function to get the members of a
# specific family

membersOf('TESORERIA') %>%
  asReport('t_members')

# so this one gives you the expo of any family



# See usage:
portfolio.exposure('VIX')
portfolio.exposure('BETA')
portfolio.exposure() # by default it gives you 'TOTAL T+ L' (should be a param.)


list.families()

portfolio.margin()
portfolio.margin('VIX')

theLatest(portfolio.margin())


theLatest(portfolio.exposure('TREND FOLLOWING'))

theLatest(portfolio.margin('ALFA'))


theLatest(alm.env$db$pnl) %>%
  filter(
    variable %in% c('PatFamilia', 'RentDiaria'),
    NombreFamilia %in% c('ALFA', 'BETA', 'TOTAL T+ L')
  )

portfolio.exposure('TREND FOLLOWING') %>%
  mutate(l2 = dplyr::lag(leverage_ratio))

pnl('VIX') %>%
  asReport('pnl_de_vix')
theLatest(pnl('BETA'))

cashFlows()
theLatest(cashFlows('FUTUROS ADMINISTRADOS'))

pnl('VIX') %>%
  reverseDate() %>%
  asReport('VIX_pnl')

theLatest(portfolio.margin('VIX')) %>%
  asReport('VIX_all_margins')

theLatest(portfolio.margin('FUTUROS ADMINISTRADOS')) %>%
  reverseDate() %>%
  asReport('another_title')

showReports()



pnl('VIX') %>%
  reverseDate() %>%
  asReport('VIX_pnl', append = TRUE)

allReportsToExcel()

wb <- createWorkbook()
addWorksheet(wb = wb, sheetName = "Sheet 1", gridLines = FALSE)
writeDataTable(wb = wb, sheet = 1, x = alm.env$reports$full_pnl)
saveWorkbook(wb = wb,file = 'xpp_smple.xlsx',overwrite = TRUE)

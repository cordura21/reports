source('createAlarmObject.R')
source('rpt.dates.R')
source('Set Strategies.R')
source('calculate & export.R')
source('export.R')

navs <- alm.env$db$pnl %>%
  filter(variable == 'nav')
library(xts)

all_dates <- unique(navs$Fecha)

eom.dates <- all_dates[endpoints(all_dates,on = 'months')]

eom.navs <- navs %>% filter(Fecha %in% eom.dates) 

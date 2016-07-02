# Flexible dates for reporting
require(lubridate)


# Let's use today, but this should be a parameter
rpt.date <- max(alm.env$db$pnl$Fecha)

# Create a list of date intervals,
# using the interval object from lubridate
# rdt stands for 'report dates'
library(lubridate)
rdt <- list()
rdt$today <- interval(rpt.date,rpt.date)
rdt$ytd <- interval(floor_date(rpt.date,unit = 'year'),rpt.date)
rdt$mtd <- interval(floor_date(rpt.date,unit = 'month'),rpt.date)
rdt$wtd <- interval(floor_date(rpt.date,unit = 'week'),rpt.date)
rdt$qtd <- interval(floor_date(rpt.date,unit = 'quarter'),rpt.date)

rdt$last.year <- interval(rpt.date - period( years = 1) ,rpt.date)

rdt$last.month <- interval(rpt.date - period( days = day(rpt.date)-1),rpt.date)           
rdt$three.years <- interval(rpt.date - period( years = 3),rpt.date)
require(bizdays)
rdt$five.days <- interval( offset(rpt.date,n = -5), rpt.date)
rdt$twenty.days <- interval( offset(rpt.date,n = -20), rpt.date)
rdt$sixty.days <- interval( offset(rpt.date,n = -60), rpt.date)
rdt$ninety.days <- interval( offset(rpt.date,n = -90), rpt.date)

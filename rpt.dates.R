# Flexible dates for reporting
require(lubridate)


# Let's use today, but this should be a parameter
rpt.date <- max(alm.env$db$pnl$Fecha)

# Create a list of date intervals,
# using the interval object from lubridate
# alm.env$rdt stands for 'report dates'
library(lubridate)
alm.env$rdt <- list()
alm.env$rdt$today <- interval(rpt.date,rpt.date)
alm.env$rdt$ytd <- interval(floor_date(rpt.date,unit = 'year'),rpt.date)
alm.env$rdt$mtd <- interval(floor_date(rpt.date,unit = 'month'),rpt.date)
alm.env$rdt$wtd <- interval(floor_date(rpt.date,unit = 'week'),rpt.date)
alm.env$rdt$qtd <- interval(floor_date(rpt.date,unit = 'quarter'),rpt.date)

alm.env$rdt$last.year <- interval(rpt.date - period( years = 1) ,rpt.date)

alm.env$rdt$last.month <- interval(rpt.date - period( days = day(rpt.date)-1),rpt.date)           
alm.env$rdt$three.years <- interval(rpt.date - period( years = 3),rpt.date)
require(bizdays)
alm.env$rdt$five.days <- interval( offset(rpt.date,n = -5), rpt.date)
alm.env$rdt$twenty.days <- interval( offset(rpt.date,n = -20), rpt.date)
alm.env$rdt$sixty.days <- interval( offset(rpt.date,n = -60), rpt.date)
alm.env$rdt$ninety.days <- interval( offset(rpt.date,n = -90), rpt.date)

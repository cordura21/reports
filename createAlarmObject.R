# Parameters and object creation ------------------------------------------


# Some parameters

alm <- list()
alm$data.path <-
  'data' # I suppose the original data is in a subfolder 'data'
alm$path$pnl <- 'metricas.RDS'
alm$path$bulk <- 'bulk.RDS'
alm$path$familias <- 'familias.RDS'
alm$data <- list() # Create a list to hold everything

library(dplyr)

# Load data on the object
alm$data$pnl <-
  tbl_df(readRDS(file.path(alm$data.path, alm$path$pnl)))

alm$data$bulk <-
  tbl_df(readRDS(file.path(alm$data.path, alm$path$bulk)))

# Change the date variable from the name 'Periodo' to 'Fecha'
names(alm$data$bulk)[which(names(alm$data$bulk) == 'Periodo')] <-
  'Fecha'

# I guess there is a more elegant way
alm$data$familias <-
  tbl_df(readRDS(file.path(alm$data.path, alm$path$familias))) %>%
  select(-Grupo, -Cartera)

# Now I create a sub-object for the databases

library(tidyr)

alm$db <- list()

# I just select variables I am now using, and drop others.
# This selection could be in a param file
alm$db$pnl <- alm$data$pnl %>%
  mutate(Asset_Over_Pat_Limit = as.double(Asset_Over_Pat_Limit)) %>%
 # gather(variable, value, PatFamilia:nav) %>%
  select(-Familia)

# Turn into long format
require(reshape2)
alm$db$pnl <- melt(alm$db$pnl,id.vars = c('Fecha','NombreFamilia' )) %>%
  filter( !is.na(value))

alm$db$bulk <- alm$data$bulk %>%
  select(
    Fecha,
    CarteraNom,
    TipoNombre,
    EspecieNombre,
    Cantidad,
    Valuacion,
    Resultado,
    Exposure,
    AT12,
    AT13
  )

# Now I just create an environment which is a copy of the list, and
# I delete the list. This way I can access the object from anywhere
alm.env <- as.environment(alm)
rm(alm)


# Build Functions ---------------------------------------------------------
dbContents <- function(db.name) {
  return(alm.env$db[[db.name]])
}

# This function shows just the latest data available
last.day <- function(db.name) {
  return(alm.env$db[[db.name]] %>%
           filter(Fecha == max(Fecha)))
}

membersOf <- function(family.name = 'TOTAL T+ L') {
  cartera.index <-
    which(alm.env$data$familias$Descripcion == family.name)
  retObject <- alm.env$data$familias[cartera.index, 'CarteraNom']
  return(retObject$CarteraNom)
}

portfolio.exposure <- function(family.name = 'TOTAL T+ L') {
  retObj <- alm.env$db$bulk %>%
    filter(CarteraNom %in% membersOf(family.name)) %>%
    group_by(Fecha) %>%
    summarise(
      valuacion = sum(Valuacion),
      exposure = sum(Exposure),
      leverage_ratio = exposure / valuacion
    )
  return(retObj)
}
# AT12 = Cash Margin accounts

portfolio.margin <- function(family.name = 'TOTAL T+ L') {
  retObj <- alm.env$db$bulk %>%
    filter(CarteraNom %in% membersOf(family.name)) %>%
    group_by(Fecha, AT12) %>%
    summarise(valuacion = sum(Valuacion),
              margin = sum(Valuacion)) %>%
    mutate(
      margin =  valuacion * ifelse(AT12 == 'Cash Margin Accounts', 1, 0),
      margin_ratio = margin / valuacion
    ) %>%
    group_by(Fecha) %>%
    summarise(
      valuacion = sum(valuacion),
      margin = sum(margin),
      margin_ratio = margin / valuacion
    )
  return(retObj)
}


# This just lists all available families
list.families <- function() {
  return(unique(alm.env$data$familias$CarteraNom))
}

theLatest <- function(x) {
  x <- x %>%
    filter(Fecha == max(Fecha))
  return(x)
}

pnl <- function(family.name = 'TOTAL T+ L') {
  return(alm.env$db$pnl %>%
           filter(NombreFamilia %in% family.name,
                  variable %in% c('RentDiaria')))
}

cashFlows <- function(family.name = 'TOTAL T+ L') {
  return(
    alm.env$db$pnl %>%
      filter(
        NombreFamilia %in% family.name,
        variable %in% c('Suscripciones', 'Rescates')
      ) %>%
      mutate(signedCashFlow = value * ifelse(variable == 'Rescates',-1, 1)) %>%
      group_by(Fecha) %>%
      summarise(cashFlow = sum(signedCashFlow)) %>%
      mutate(familia = family.name)
  )
}

resetReports <- function() {
  alm.env$reports <- list()
}

asReport <- function(x,title, append = FALSE) {

  if (title %in% names(alm.env$reports) & append == TRUE) {
    alm.env$reports[[title]] <- rbind(alm.env$reports[[title]],x)
  } else {
    alm.env$reports[[title]] <- x
  
  }
}

showReports <- function(n = NA) {
  if (is.na(n)) {
    return(alm.env$reports)
  }
  return(alm.env$reports[[n]])
}

reverseDate <- function(x){
  return(
    x %>%
      arrange(desc(Fecha))
  )
}

allReportsToExcel <- function(){
  require(xlsx)
  write.xlsx(x = as.data.frame(alm.env$reports[[1]]), file = "reports.xlsx",
             sheetName = names(alm.env$reports)[1], row.names = FALSE, append = FALSE)
  for(iLoop in 2:length(alm.env$reports)) {
    write.xlsx(x = as.data.frame(alm.env$reports[[iLoop]]), file = "reports.xlsx",
               sheetName = names(alm.env$reports)[iLoop], row.names = FALSE, append = TRUE)
    
  }
}


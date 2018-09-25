#! /usr/bin/Rscript
"Allocator v0.9.1

Passive allocation investment tool. It departs from three assumptions:
  1. the age when one wants to stop investing (should take life expectancy
    in your country into consideration);
  2. the user risk profile;
  3. that assets are grouped in three pools.
  3.1. the emergency fund, corresponds to expenses for six months (think six
    months of unemployment),
  3.2. the second pool corresponds to low risk investments
  3.3. the third pool are the high risk investments.

  Try to vary the types of investment within each pool, this tool will not handle
  investments within pool, only the total pool value. Decision on what is low
  and high risk, as well as decision on the risk profile is entirely on users
  discretion. Every year, the tool will help the user allocate the correct
  amount in each of the pools, based in a simple algorithm. Finally, since
  sometimes one needs to record a deposit into one of the investments
  quickly, there is a quick-add add command, in which one can add the latest
  low risk and high risk investment without going trough all the questions.

usage:
 allocator.R [(quick-add <low> <high>)]
 allocator.R --plot

options:
 -h --help         Shows this screen
 -p --plot         Plot a graph

" -> doc


#' Function to load dependencies, it is part of the sempsychiatry package
#' https://github.com/lf-araujo/sempsychiatry
#' This function can be used to load all packages required to SEM data 
#' analysis. One can pass package names as arguments and if these are not 
#' installed, they are download and installed. If they are in the system, 
#' they are not updated. The reason for this function is that updating 
#' packages can cause incompatibilities over time, as statistical packages 
#' are quickly updated by their owners. This approach makes sure to maintain 
#' the base installation as stable as possible.
#' @param List of packages
#' @keywords packages installation
#' @export

cat("\n Welcome! I will first try to install dependencies for this tool. \n")

dependencies <- function(dep){
  pb <- txtProgressBar(min = 0, max = length(dep), style = 3)
  for (i in seq_along(dep)){
    if (!dep[i] %in% installed.packages()){
      install.packages(dep[i], repos = "http://cran.rstudio.com/",
        dependencies = T)
    }
    library(dep[i], character.only = TRUE)
    setTxtProgressBar(pb, i )
  }
  close(pb)
}


dependencies(c("data.table", "docopt", "here"))
opts <- docopt(doc)

setwd(here())

# Utility to get users input
userinput <- function(question) {
  cat(question, "\n> ")
  n <- readLines(con = "stdin", 1)
  return(as.numeric(n))
}

destfile <- "./finances.csv"

# Plotting

if (opts$plot){
  png()
  data <- read.csv(destfile, stringsAsFactors = FALSE)
  plot(type="l",as.Date(data$date, format = "%Y-%m-%d"),data$low,col="red")
  lines(as.Date(data$date, format = "%Y-%m-%d"),data$high,col="green")
  dev.off()
  exit()
}


# Quick insertion of investiments via command line
if (!is.null(opts$low)){
  data <- read.csv(destfile, stringsAsFactors = FALSE)
  lastentry <- tail(data, n = 1)

  expenses <- lastentry$expenses
  investpercent <- lastentry$investpercent

  dataplus <- data.frame(date = as.character(Sys.Date()),
                                investpercent = lastentry$investpercent,
                                expenses = lastentry$expenses,
                                savings = lastentry$savings,
                                low = lastentry$low + as.numeric(opts$low),
                                high = lastentry$high + as.numeric(opts$high),
                                objective = lastentry$objective)


  data <- rbind(data, dataplus)
  write.csv(data,  file = destfile, row.names = F)
  cat("Your new investiments were recorded. Goodbye!")
  exit()
}

# Function that runs questions for the first time use of the program
newusercalc <- function(investpercent, expenses, savings, low, high, invest) {

  highobjective = (investpercent / 100) * invest
  lowobjective = invest - highobjective
  objective = abs(expenses - (low + high))

  if (expenses > savings){
    cat("You haven't reached the first step of creating the emergency pool.
      Deposit ", invest, "into your savings acount and keep doing it
      until it reaches ", expenses, "\n Good luck! \n")
  } else{
    cat("Deposit ", lowobjective, "into your low risk investiment pool. \n" )
    cat("Deposit ", highobjective, "into your high risk investiment pool. \n")
    cat("Your data has been saved to finances.csv in this directory. Goodbye!
      \n")
    write.csv(data.frame(date = Sys.Date(), investpercent, expenses, savings,
              low, high, objective ), row.names = F, file = "./finances.csv")
  }
}

# This is the main routine and algorithm specification
# Check if data file exists, this will be the criteria for considering first run
if (!file.exists(destfile)){

  userinput("Enter your age: ") -> age
  userinput("In which age you want to stop managing finances: ") -> end
  userinput("What is your risk profile: low risk (type 40), medium
    risk (type 20), high risk (type 0). Intermediary values are accepted: ") ->
    profile
  userinput("Enter your current 6 months expenses: ") -> expenses
  userinput("Enter your current savings account status: ") -> savings
  userinput("Enter your low risk investiments total: ") -> low
  userinput("Enter your high risk investiments total: ") -> high
  userinput("Finally, how much you have to save today: ") -> invest

  newusercalc( (end - profile) - age, expenses, savings, low, high, invest)

} else  {

  data <- read.csv(destfile, stringsAsFactors = FALSE)
  lastentry <- tail(data, n = 1)

  # Finds the first time last investpercent happened, so to allow calculation
  # of time
  t.first <- data[match(lastentry$investpercent, data$investpercent), ]

  if ( (Sys.Date() - as.Date(t.first$date, format = "%Y-%m-%d")) > 365) {
    userinput("Time to update 6 month expenses: ") -> expenses
    investpercent = lastentry$investpercent - 1
  } else {
    expenses = lastentry$expenses
    investpercent = lastentry$investpercent
  }

  userinput("Invested value in low risk since last time: ") -> investedlow
  userinput("Invested value in high risk since last time: ") -> investedhigh
  userinput("Total low risk value today: ") -> lowtoday
  userinput("Total high risk value today: ") -> hightoday
  userinput("Enter your current savings account status: ") -> savings
  userinput("Finally, how much you have to save today: ") -> invest

  aimhigh = (lowtoday + hightoday) * investpercent / 100
  aimlow = (lowtoday + hightoday) * (100 - investpercent) / 100


  if (lastentry$expenses > savings){
    cat("The emergency pool is outdated. \n Deposit ", expenses - savings,
      "into the emergency pool.")
    if (expenses - savings < invest){
      invest = invest - (expenses - savings)
    }
  } else {
    if (investpercent <= 0){
      investpercent = 0
      cat("Congratulations! You reached the year which you wanted to stop
        moving money around! Don't forget to consider converting all high
        risk investiment into types of high risk investiment that generates
        dividends.")
    }
  }

  investhigh =  (aimhigh / (aimhigh + aimlow)) * invest
  investlow = (aimlow / (aimhigh + aimlow)) * invest
  objective = abs(expenses - ( (lowtoday + hightoday) - (investedlow +
    investedhigh) - (lastentry$low + lastentry$high)))

  cat("Deposit ", investhigh, " into the high risk pool.\n")
  cat("Deposit ", investlow, " into the low risk pool.\n")

  dataplus <-data.frame(date = as.character(Sys.Date()), investpercent,
                        expenses, savings, low = lowtoday, high = hightoday,
                        objective)
  data <-rbind(data, dataplus)
  write.csv(data,  file = destfile, row.names = F)
  cat("Your data has been saved to finances.csv in this directory. Goodbye!\n")
}

##################################
#Author: Mike Underwood          #
#Email: underwoodjmike@gmail.com #
#Phone: (860) 670-3120           #
##################################

library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(RMariaDB)
library(DT)

ui <- dashboardPagePlus(
  skin = "red",
  title = "MySQL Test App",
  header = dashboardHeaderPlus(
    title = "MySQL Test App",
    enable_rightsidebar = TRUE
  ),
  sidebar = dashboardSidebar(
    sidebarMenu(
      menuItem("Excel File", tabName = "excel", icon = icon("file")),
      menuItem("One Off", tabName = "one", icon = icon("dashboard"))
    )
  ),
  body = dashboardBody(
    tabItems(
      tabItem(
        tabName = "excel",
        box(
          status = "danger",
          width = 12,
          fluidRow(
            column(
              5,
              fileInput(
                inputId = "excelUpload",
                label = "Excel Upload",
                accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  '.csv'
                )
              )
            ),
            column(
              4,
              selectInput(
                inputId = "dbTables",
                label = "Table",
                choices = tables
              )
            ),
            column(
              3,
              br(),
              actionButton(
                inputId =  "submitUpload",
                label = "Submit Upload"
              )
            )
          ),
          h4("Preview"),
          dataTableOutput("excelPreview")
        )
      ),
      tabItem(
        tabName = "one",
        box(
          status = "danger",
          width = 12,
          selectInput(
            inputId = "dbTables2",
            label = "Table",
            choices = tables
          ),
          conditionalPanel(
            condition = "input.dbTables2=='city'",
            fluidRow(
              column(
                6,
                textInput(
                  inputId = "nameCity",
                  label = "Name"
                ),
                textInput(
                  inputId = "district",
                  label = "District"
                )
              ),
              column(
                6,
                textInput(
                  inputId = "populationCity",
                  label = "Population"
                ),
                selectInput(
                  inputId = "countryCodeCity",
                  label = "Country Code",
                  choices = Codes
                )
              )
            )
          ),
          conditionalPanel(
            condition = "input.dbTables2 =='country'",
            fluidRow(
              column(
                4,
                textInput(
                  inputId = "countryCodeCountry",
                  label = "Country Code"
                ),
                textInput(
                  inputId = "nameCountry",
                  label = "Name"
                ),
                selectInput(
                  inputId = "continent",
                  label = "Continent",
                  choices = c("Africa", "Antartica", "Asia", "Europe", "North America", "Oceania", "South America")
                ),
                selectInput(
                  inputId = "regions",
                  label = "Region",
                  choices = c("Caribbean", "Southern and Central Asia", "Central Africa",
                              "Southern Europe", "Middle East", "South America",
                              "Polynesia", "Antarctica", "Australia and New Zealand",
                              "Western Europe", "Eastern Africa", "Western Africa",
                              "Eastern Europe", "Central America", "North America",
                              "Southeast Asia", "Southern Africa", "Eastern Asia",
                              "Nordic Countries", "Northern Africa", "Baltic Countries",
                              "Melanesia", "Micronesia", "British Islands",
                              "Micronesia/Caribbean")
                ),
                textInput(
                  inputId = "surfaceArea",
                  label = "Surface Area"
                )
              ),
              column(
                4,
                textInput(
                  inputId = "indepYear",
                  label = "Independence Year"
                ),
                textInput(
                  inputId = "populationCountry",
                  label = "Population"
                ),
                textInput(
                  inputId = "lifeExp",
                  label = "Life Expectancy"
                ),
                textInput(
                  inputId = "gnp",
                  label = "GNP"
                ),
                textInput(
                  inputId = "gnpOld",
                  label = "GNP Old"
                )
              ),
              column(
                4,
                textInput(
                  inputId ="localName",
                  label = "Local Name"
                ),
                textInput(
                  inputId = "governmentForm",
                  label = "Government Form"
                ),
                textInput(
                  inputId = "headOfState",
                  label = "Head Of State"
                ),
                textInput(
                  inputId = "capital",
                  label = "Capital"
                ),
                textInput(
                  inputId = "code2",
                  label = "Code 2"
                )
              )
            )
          ),
          conditionalPanel(
            condition = "input.dbTables2=='countrylanguage'",
            fluidRow(
              column(
                6,
                selectInput(
                  inputId = "countryCodeLang",
                  label = "Country Code",
                  choices = Codes
                ),
                textInput(
                  inputId = "language",
                  label = "Language"
                )
              ),
              column(
                6,
                selectInput(
                  inputId = "isOfficial",
                  label = "Is Official?",
                  choices = c("Yes", "No")
                ),
                textInput(
                  inputId = "percent",
                  label = "Percent"
                )
              )
            )
          ),
          actionButton(
            inputId = "submitOneOff",
            label = "Submit"
          )
        )
      )
    )
  ),
  footer = dashboardFooter(
    left_text = "R version 3.6.1",
    right_text = "MySQL version 8.0.17"
  ),
  rightsidebar = rightSidebar()
  
)
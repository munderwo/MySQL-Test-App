##################################
#Author: Mike Underwood          #
#Email: underwoodjmike@gmail.com #
#Phone: (860) 670-3120           #
##################################

server <- function(input, output, session)
{
  newData <- reactive({
    inFile <- input$excelUpload
    if(is.null(inFile))
      return(NULL)
    
    data = read.csv(inFile$datapath, fileEncoding="UTF-8-BOM", stringsAsFactors = FALSE)
    colnames(data) <- gsub("\\.", "", colnames(data))
    data
  })
  
  output$excelPreview <- renderDataTable({
    datatable(newData())
  })
  
  observeEvent(input$submitUpload, {
    req(input$excelUpload)
    showModal(
      modalDialog(
        title = "Are you sure?",
        "Clicking confirm will upload data to the database.",
        footer = fluidRow(
          column(
            6,
            div(
              class = "text-center",
              modalButton("Cancel")
            )
          ),
          column(
            6,
            div(
              class = "text-center",
              actionButton(
                inputId = "confirmExcelSubmit",
                label = "Confirm"
              )
            )
          )
        )
      )
    )
  })
  
  observeEvent(input$confirmExcelSubmit, {
    RMariaDB::dbWriteTable(
      conn = conn, 
      name = input[['dbTables']],
      value = newData(),
      append = TRUE
    )
    removeModal()
    showModal(
      modalDialog(
        title = "Upload Successful!"
      )
    )
  })
  
  observeEvent(input$submitOneOff, {
    showModal(
      modalDialog(
        title = "Are you sure?",
        "Clicking confirm will upload data to the database.",
        footer = fluidRow(
          column(
            6,
            div(
              class = "text-center",
              modalButton("Cancel")
            )
          ),
          column(
            6,
            div(
              class = "text-center",
              actionButton(
                inputId = "confirmOneOffSubmit",
                label = "Confirm"
              )
            )
          )
        )
      )
    )
  })
  
  observeEvent(input$confirmOneOffSubmit, {
    if(input[["dbTables2"]] == "city")
    {
      res <- RMariaDB::dbSendQuery(conn, "select count(*) from city")
      rows <- RMariaDB::dbFetch(res)
      RMariaDB::dbClearResult(res)
      
      query <- paste0("insert into city values(", 
                      rows, ", '", input$nameCity, "', '",
                      input$countryCodeCity, "', '", input$district, "', ", 
                      input$populationCity, ")"
               )

      RMariaDB::dbExecute(conn, query)
    }
    if(input[["dbTables2"]] == "country")
    {
      res <- RMariaDB::dbSendQuery(conn, "select count(*) from country")
      rows <- RMariaDB::dbFetch(res)
      RMariaDB::dbClearResult(res)
      
      query <<- paste0("insert into country values('",
                      input$countryCodeCountry, "', '", input$nameCountry, "', '",
                      input$continent, "', '",input$regions, "', ", 
                      input$surfaceArea, ", ",input$indepYear, ", ", 
                      input$populationCountry, ", ",input$lifeExp, ", ", input$gnp, ", ", 
                      input$gnpOld, ", '", input$localName, "', '", 
                      input$governmentForm, "', '", input$headOfState, "', ", 
                      input$capital, ", '", input$code2,
                      "')"
              )
      RMariaDB::dbExecute(conn, query)
    }
    if(input[["dbTables2"]] == "countrylanguage")
    {
      if(input$isOfficial == "Yes")
      {
        off = "T"
      }
      else
      {
        off = "F"
      }
      query <- paste0("insert into countrylanguage values('", input$countryCodeLang,
                     "', '",  input$language, "', '", off, "', ", input$percent, ")"
              )
      RMariaDB::dbExecute(conn, query)
    }
    removeModal()
    showModal(
      modalDialog(
        title = "Upload Successful!"
      )
    )
  })
  
}
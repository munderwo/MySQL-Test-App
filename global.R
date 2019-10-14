##################################
#Author: Mike Underwood          #
#Email: underwoodjmike@gmail.com #
#Phone: (860) 670-3120           #
##################################

# Connection to the default 'world' database.
# I put it in global so one connection is made on app statup.
# Root, password, host, and port will need to be changed based on install/location.
conn <- RMariaDB::dbConnect(MariaDB(), 
                  dbname = "world", 
                  user = "root", 
                  password = "password", 
                  host = "127.0.0.1", 
                  port = 3306)

#Extract tables for later use
tables <-  RMariaDB::dbListTables(conn)

#Country Codes for use later
res <- RMariaDB::dbSendQuery(conn1, "select Code from country")
Codes <- RMariaDB::dbFetch(res)
RMariaDB::dbClearResult(res)

#Closes Database Connection on app close.
onStop(function() RMariaDB::dbDisconnect(conn) , session = getDefaultReactiveDomain())




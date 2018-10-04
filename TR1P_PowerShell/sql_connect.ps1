$SQLServer = "aaaa.database.windows.net"
$SQLDBName = "Database"
$uid ="john"
$pwd = "pwd123"
$SqlQuery = "SELECT * from table;"
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True; User ID = $uid; Password = $pwd;"
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)

$DataSet.Tables[0] | out-file "C:\Scripts\xxxx.csv"
<%
'* Código para conexão no banco de dados
'On error resume next
Session.LCID = 1046
Dim oOracleDB
set oOracleDB = Server.CreateObject("ADODB.Connection")
oOracleDB.CommandTimeout    = 90
oOracleDB.ConnectionTimeout = 90
oOracleDB.CursorLocation    = 3
'oOracleDB.ConnectionString  =  "IDDB=Oracle;Provider=OraOLEDB.Oracle;Data Source=;User ID=;Password=;PLSQLRSet=1"
oOracleDB.ConnectionString = "Provider=MSDAORA.1;Password=;User ID=;Data Source=;Persist Security Info=True;"
oOracleDB.Open

%>
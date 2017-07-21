<%
If isObject(oOracleDB) Then
	oOracleDB.Close
	set oOracleDB = Nothing
End If
%>
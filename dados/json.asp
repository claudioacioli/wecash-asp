<!-- #include file="conectar.asp" -->
<%
    Response.Charset = "UTF-8"
    Response.ContentType = "application/json"

    sHistorico = Trim(Request("term")&"")

    sSQL = "SELECT DS_HISTORICO FROM ( "
    sSQL = sSQL & "SELECT DISTINCT DS_HISTORICO                                                                     "
    sSQL = sSQL & "  FROM TB_MOVIMENTO                                                                              "
    sSQL = sSQL & " WHERE ID_CAIXA IN (SELECT ID_CAIXA FROM TB_CAIXA WHERE ID_EMPRESA = "&Session("id_empresa")&")  "

    If sHistorico <> "" Then
        sSQL = sSQL & " AND UPPER(DS_HISTORICO) LIKE UPPER('%" & sHistorico & "%')"
    End If

    sSQL = sSQL & " ) WHERE ROWNUM < 16 "

    Set oRs = oOracleDb.Execute(sSQL)
    sJSON = "["
    Do While Not oRs.EOF
        sVirgula = ","
        If Len(sJSON) = 1 Then
            sVirgula = ""
        End If
        sJSON = sJSON & sVirgula & "{'id':'" & (oRs("DS_HISTORICO")) & "', 'value':'"& (oRs("DS_HISTORICO")) &"'}"
        oRs.MoveNext
    Loop
    sJSON = sJSON & "]"

    Response.Write Replace(sJSON,"'","""")
    Set oRs = Nothing

%>
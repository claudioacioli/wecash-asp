<!-- #include file="conectar.asp" -->
<%
	response.Charset = "iso-8859-1"
    
    Dim sAcao, sIdCategoria, sDsMeta, sDataInicio, sDataRealizacao, sNrValor, sNrEntrada
    
    CarregarDados()

    Select Case sAcao
        Case "planejar":
            planejar()
	End Select


    Sub Listar()
    End Sub

    Sub CarregarDados()
		sAcao               = Trim(Request("acao")&"")
        sIdCategoria		= trim(Request("id_categoria")&"")
		sDsMeta      		= trim(Request("ds_meta")&"")
		sDataInicio 		= trim(Request("dt_inicio")&"")
		sDataRealizacao 	= trim(Request("dt_confirmacao")&"")
		sNrValor 			= Replace(trim(Request("nr_valor")&""),".","")
        sNrEntrada 			= Replace(trim(Request("nr_entrada")&""),".","")
	End Sub

    Sub planejar()
        
        sSQL = ""
        sSQL = sSQL & " SELECT ROWNUM PARCELA, " 
        sSQL = sSQL & "        ADD_MONTHS(INICIO, LEVEL) DATA, "
        sSQL = sSQL & "        ROUND((VALOR-GUARDADO) / MESES, 2) VALOR_MENSAL "
        sSQL = sSQL & "   FROM    (SELECT  '"&sNrValor&"' AS valor, "
        sSQL = sSQL & "                   TO_DATE ('"&sDataInicio&"', 'dd/mm/yyyy') INICIO, "
        sSQL = sSQL & "                   TO_DATE ('"&sDataRealizacao&"', 'dd/mm/yyyy') META, "
        sSQL = sSQL & "                   MONTHS_BETWEEN(TO_DATE('"&sDataRealizacao&"','dd/mm/yyyy'), TO_DATE('"&sDataInicio&"','dd/mm/yyyy')) MESES, "
        sSQL = sSQL & "                   '"&sNrEntrada&"' as GUARDADO "
        sSQL = sSQL & "              FROM DUAL) "
        sSQL = sSQL & " CONNECT BY LEVEL <= MESES " 

        
        Set rs = oOracleDB.execute(sSQL)

        If Not rs.Eof Then
		%>
		<table class="chart">
            <col style="width:50px" />
                <col />
                <col style="width:150px" />
			<thead>                
				<tr>
                    <th><%=server.HTMLEncode("N.º")%></th>
					<th><%=server.HTMLEncode("Data parcela:")%></th>
					<th><%=server.HTMLEncode("Valor")%></th>
				</tr>
			</thead>
			<tbody>
            <%Do While Not RS.EOF%>
                <tr>
                    <td><%=server.HTMLEncode("N.º")&"&nbsp;"&rs("PARCELA")%></td>
                    <td><%=rs("DATA")%></td>
                    <td><%=rs("VALOR_MENSAL")%></td>
                </tr>
            <%
				RS.MoveNext
			Loop				
			%>
            </tbody>
            </table>
       <%
       End If
    End Sub

%>
<!-- #include file="desconectar.asp" -->
<!-- #include file="conectar.asp" -->
<%

	sMes = trim(Request("mes")&"")
	sAno = trim(Request("ano")&"")
	sReferencia	= sMes &"/"& sAno
	if sReferencia = "/" Then
		sReferencia = "06/2012"
	End If

	sIdEmpresa     = Session("id_empresa")
	sTipoMovimento = Request("tipo")

	sql = ""
	sql = sql & " SELECT max(t.ds_categoria) categoria, 													"
	sql = sql & "   	 T.Id_Categoria, to_char(sum(m.nr_valor_previsto),'9G999G999G990D00') Valor_Br, 								"
	sql = sql & "        ROUND( RATIO_TO_REPORT(sum(m.nr_valor_previsto)) OVER ()*100 ,2) AS porcentagem 	"
	sql = sql & "   FROM tb_Movimento m, 																	"
	sql = sql & "   	 tb_categoria t 																	"
	sql = sql & "  WHERE t.id_categoria = m.id_categoria 													"
	sql = sql & " 	 And T.Id_Empresa   = "&sIdEmpresa&" 													"
	sql = sql & " 	 AND ( TO_CHAR(Dt_Confirmacao,'MM/YYYY') = '"&sReferencia&"' 								"
	sql = sql & "    	   Or (Dt_Confirmacao Is  Null 														"
	sql = sql & " 		   AND to_date(TO_CHAR(dt_previsao,'MM/YYYY'),'MM/YYYY') < to_date('"&sReferencia&"','MM/YYYY') "
	sql = sql & " 		   And To_Date('"&sReferencia&"','MM/YYYY') <= To_Date(To_Char(Sysdate,'MM/YYYY'),'MM/YYYY') ) "
	sql = sql & " 		   Or To_Char(Dt_Confirmacao,'MM/YYYY') = '"&sReferencia&"' ) 						"
	sql = sql & "    And Dt_Confirmacao Is Not Null 														"
	sql = sql & "    And Tp_Movimento = '"&sTipoMovimento&"' 													"
	sql = sql & "    And bo_considerar_relatorio = 1 														"
	sql = sql & "  Group By T.Id_Categoria 																	"
	sql = sql & "  ORDER BY porcentagem desc 																"


	Set rs = oOracleDB.Execute(sql)

	If Not rs.EOF Then
%>
<table class="extra">
<thead>
	<tr>
    	<th><%=Server.HTMLEncode("Categoria")%></th>
    	<th width="100px"><%=Server.HTMLEncode("%")%></th>
    	<th width="100px"><%=Server.HTMLEncode("Valor")%></th>
	</tr>
</thead>
<tbody>
<%
		Do While Not rs.EOF
%>
<tr class='relSaldo'>
	<td><a href='javascript:void(0);' class='resumo' data-categoria="<%=rs("Id_Categoria")%>"><%=Server.HTMLEncode(rs("categoria"))%></a></td>
	<td><%=rs("porcentagem")%>%</td>
	<td>R$ <%=rs("valor_br")%></td>
</tr>
<%

	sql = ""
	sql = sql & " SELECT max(m.ds_historico) historico, 													"
	sql = sql & "   	 to_char(sum(m.nr_valor_previsto),'9G999G999G990D00') Valor_Br, 						"
	sql = sql & "        ROUND( RATIO_TO_REPORT(sum(m.nr_valor_previsto)) OVER ()*100 ,2) AS porcentagem 	"
	sql = sql & "   FROM tb_Movimento m, 																	"
	sql = sql & "   	 tb_categoria t 																	"
	sql = sql & "  WHERE t.id_categoria = m.id_categoria 													"
	sql = sql & " 	 And T.Id_Empresa   = "&sIdEmpresa&" 													"
	sql = sql & " 	 AND ( TO_CHAR(Dt_Confirmacao,'MM/YYYY') = '"&sReferencia&"' 								"
	sql = sql & "    	   Or (Dt_Confirmacao Is  Null 														"
	sql = sql & " 		   AND to_date(TO_CHAR(dt_previsao,'MM/YYYY'),'MM/YYYY') < to_date('"&sReferencia&"','MM/YYYY') "
	sql = sql & " 		   And To_Date('"&sReferencia&"','MM/YYYY') <= To_Date(To_Char(Sysdate,'MM/YYYY'),'MM/YYYY') ) "
	sql = sql & " 		   Or To_Char(Dt_Confirmacao,'MM/YYYY') = '"&sReferencia&"' ) 						"
	sql = sql & "    And Dt_Confirmacao Is Not Null 														"
	sql = sql & "    And Tp_Movimento = '"&sTipoMovimento&"' 													"
	sql = sql & "    And bo_considerar_relatorio = 1 														"
	sql = sql & "    And t.id_categoria = "&rs("id_categoria")&"											"
	sql = sql & "  Group By trim(upper(ds_historico)) 																	"
	sql = sql & "  ORDER BY porcentagem desc 																"

	Set rsMovimento = oOracleDB.Execute(sql)
	If Not rsMovimento.EOF Then
		Do While Not rsMovimento.EOF
%>
<tr>
	<td><%=Server.HTMLEncode(rsMovimento("historico"))%></td>
	<td><%=rsMovimento("porcentagem")%>%</td>
	<td>R$ <%=rsMovimento("valor_br")%></td>
</tr>		
<%			
			rsMovimento.MoveNext
		Loop
	End If
	Set rsMovimento = Nothing

%>



<%			
			rs.MoveNext
		Loop
%>
</tbody>
</table>
<%
	End If

	Set rs = Nothing

%>
<!-- #include file="desconectar.asp" -->
<!-- #include file="conectar.asp" -->
<%
	sMes = trim(Request("mes")&"")
	sAno = trim(Request("ano")&"")
	sReferencia	= sMes &"/"& sAno
	if sReferencia = "/" Then
		sReferencia = "06/2012"
	End If
	
	'response.write sReferencia

	sIdEmpresa     = Session("id_empresa")
	sTipoMovimento = "D"
	sSQL = ""
	sSQL = sSQL & "SELECT TP_FIXO_VARIAVEL,	"
	sSQL = sSQL & "       DECODE(TP_FIXO_VARIAVEL,  LAG(TP_FIXO_VARIAVEL,1,0) OVER(ORDER BY 1), ' ','F','Fixo','V','Variável','R','Renda') TIPO,  "
	sSQL = sSQL & "       MAX(DS_CATEGORIA) CATEGORIA, "
	sSQL = sSQL & "       TO_CHAR(SUM(NR_VALOR_PREVISTO),'9G999G999G990D00') TOTAL, "
	sSQL = sSQL & "       ROUND( RATIO_TO_REPORT(SUM(NR_VALOR_PREVISTO)) OVER (PARTITION BY TP_FIXO_VARIAVEL)*100 ,2) PORCENTAGEM, "
	sSQL = sSQL & "       TO_CHAR(SUM(SUM(NR_VALOR_PREVISTO)) OVER (PARTITION BY TP_FIXO_VARIAVEL),'9G999G999G990D00') TOTAL_FIXO_VARIAVEL "
	sSQL = sSQL & "  FROM TB_MOVIMENTO M, "
	sSQL = sSQL & "       TB_CATEGORIA C "
	sSQL = sSQL & " WHERE M.ID_CATEGORIA = C.ID_CATEGORIA "
	sSQL = sSQL & "   AND C.ID_EMPRESA = '"&sIdEmpresa&"' "
	sSQL = sSQL & "   AND C.TP_MOVIMENTO = '"&sTipoMovimento&"' "
	sSQL = sSQL & "   AND TP_FIXO_VARIAVEL IN ('F','V') "
	sSQL = sSQL & "   AND TO_CHAR(DT_CONFIRMACAO,'MM/YYYY') = '"&sReferencia&"' "
	sSQL = sSQL & "	  AND BO_CONSIDERAR_RELATORIO = 1 "
	sSQL = sSQL & " GROUP "
	sSQL = sSQL & "    BY TP_FIXO_VARIAVEL, C.ID_CATEGORIA "
	sSQL = sSQL & " ORDER "
	sSQL = sSQL & "    BY TP_FIXO_VARIAVEL, TOTAL DESC "	
	
	'Response.Write sSQL
	'Response.End
	
	Set rs = oOracleDB.Execute(sSQL)
	
	If Not rs.EOF Then
%>
<table class="extra">
<thead>
	<tr>
    	<th ><%=Server.HTMLEncode("Tipo Despesa")%></th>
    	<th colspan="2" width="150px">&nbsp;</th>
	</tr>
</thead>
<tbody>
<%
		Do While Not rs.EOF
			If Trim(rs("TIPO")&"") <> "" Then
%>
				<tr class='relSaldo'>
					<td width="90%"><a href='javascript:void(0);' class='resumo'><%=Server.HTMLEncode(rs("tipo"))%></a></td>
					<td width="10%" colspan='2' align="right">R$ <%=rs("TOTAL_FIXO_VARIAVEL")%></td>
				</tr>
<%
			End If
%>
			<tr>
				<td width="90%" align="left"><%=Server.HTMLEncode(rs("CATEGORIA"))%></td>
				<td width="5%" align="right"><%=rs("PORCENTAGEM")%>%</td>
				<td width="5%" align="right">R$ <%=rs("TOTAL")%></td>
			</tr>

<%
			rs.MoveNext
		Loop
%>
</tbody>
</table>
<%
	End If
%>
<!-- #include file="desconectar.asp" -->
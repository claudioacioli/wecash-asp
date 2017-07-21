<!-- #include file="../dados/conectar.asp" -->
<%
response.Charset = "utf-8"
dim html, linhaa
linhas = 18

sAno = Trim(Request("ano")&"")
If sAno = "" Then
	sAno = Year(Date())
End If

Sub Cabecalho()
%>
    <h1>
    	Resumo das despesas anuais
    </h1>
    <h2>
    	<label>Gerado em: <%=now()%></label><label>Ano: <%=sAno%></label><label>Usuário: <%=Server.HTMLEncode(Session("ds_email"))%></label><label>Empresa: <%=Server.HTMLEncode(Session("ds_empresa"))%></label>
    </h2>
<%
End Sub
Function CabecalhoTabela()
	Dim html
	html = html & "<table>"
	html = html & "	<thead>"
	html = html & "		<tr>"
	html = html & "			<th style='text-align:left;'>Categoria</th>"
	html = html & "			<th>Janeiro</th>"
	html = html & "			<th>Fevereiro</th>"
	html = html & "			<th>Mar&ccedil;o</th>"
	html = html & "			<th>Abril</th>"
	html = html & "			<th>Maio</th>"
	html = html & "			<th>Junho</th>"
	html = html & "			<th>Julho</th>"
	html = html & "			<th>Agosto</th>"
	html = html & "			<th>Setembro</th>"
	html = html & "			<th>Oubutro</th>"
	html = html & "			<th>Novembro</th>"
	html = html & "			<th>Dezembro</th>"
	html = html & "			<th>Total</th>"
	html = html & "		</tr>"
	html = html & "	</thead>"
	html = html & "	<tbody>"
	CabecalhoTabela = html
End Function
%>

<html>
	<head>
    	<title>WeCash - Relatório de Previsão de Débitos Anual</title>
<style type="text/css" media="print">
@page
{
size: landscape;
margin: 2cm;
}
.landScape
{ 
 width: 100%; 
 height: 100%; 
 margin: 0% 0% 0% 0%; 
 filter: progid:DXImageTransform.Microsoft.BasicImage(Rotation=3);
} 
h1{
	page-break-before:always
}
*{
	font: 11px arial, helvetica, arial, sans-serif;
}
</style>
<style>
*{
	font: 11px "helvetica neue", helvetica, arial, sans-serif;
}
body{
	margin:10px;
}
table{
	border-collapse:collapse;
	width:100%;	
	border:1px solid #000;
}
tfoot tr th{
	border-top:2px solid #000;
	padding:8px;
	text-align:right;
	font-weight:bold;
}
tbody td{
	border:1px solid #ccc;
	padding:8px;
	text-align:right;
}

table tbody tr:nth-child(odd) td{
    background-color: #fff;
}
table tbody tr:nth-child(even) td{
    background-color: #f5f5f5;
}

table tbody tr:hover td{
	background-color:#e9e9e9;
}
thead th{
	border-bottom:2px solid #000;
	padding:8px;
	text-align:right;
	font-weight:bold;
}

h1{
	border-bottom:3px solid #000;
	font-size:14px;
	padding:8px;
	font-weight:bold;
}
h2{
	padding:8px;
	
}

h2 label{
	margin-right:20px;	
}
</style>
	<body class="landScape">
<%
	call Cabecalho()
	
	sql = ""
	sql = sql &" select max(c.ds_categoria) categoria, 																													"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'01', nvl(m.nr_valor_previsto,0), 0)) janeiro, 																	"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'02', nvl(m.nr_valor_previsto,0), 0)) fevereiro, 																"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'03', nvl(m.nr_valor_previsto,0), 0)) marco, 																	"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'04', nvl(m.nr_valor_previsto,0), 0)) abril, 																	"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'05', nvl(m.nr_valor_previsto,0), 0)) maio, 																	"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'06', nvl(m.nr_valor_previsto,0), 0)) junho, 																	"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'07', nvl(m.nr_valor_previsto,0), 0)) julho, 																	"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'08', nvl(m.nr_valor_previsto,0), 0)) agosto, 																	"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'09', nvl(m.nr_valor_previsto,0), 0)) setembro, 																"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'10', nvl(m.nr_valor_previsto,0), 0)) outubro, 																	"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'11', nvl(m.nr_valor_previsto,0), 0)) novembro, 																"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'12', nvl(m.nr_valor_previsto,0), 0)) dezembro, 																"
	sql = sql &"        sum(nvl(m.nr_valor_previsto,0)) total 																													"
	sql = sql &"  from tb_movimento m, 																																	"
	sql = sql &"       tb_categoria c 																																	"
	sql = sql &"  where m.id_categoria = c.id_categoria 																												"
	sql = sql &"  and c.id_empresa = "&Session("id_empresa")&" 																																"
	sql = sql &"  and c.tp_movimento = 'D' 																																"
	sql = sql &"  and bo_considerar_relatorio = 1 "
	sql = sql &"  and to_char(m.dt_confirmacao,'yyyy') = '"&sAno&"' 																											"
	sql = sql &"  and dt_confirmacao is not null "
	sql = sql &"  group by c.id_categoria 																																"
	sql = sql &"  union 																																				"
	sql = sql &"  select max('') categoria, 																															"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'01', nvl(m.nr_valor_previsto,0), 0)) janeiro, 																	"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'02', nvl(m.nr_valor_previsto,0), 0)) fevereiro, 																"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'03', nvl(m.nr_valor_previsto,0), 0)) marco, 																	"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'04', nvl(m.nr_valor_previsto,0), 0)) abril, 																	"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'05', nvl(m.nr_valor_previsto,0), 0)) maio, 																	"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'06', nvl(m.nr_valor_previsto,0), 0)) junho, 																	"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'07', nvl(m.nr_valor_previsto,0), 0)) julho, 																	"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'08', nvl(m.nr_valor_previsto,0), 0)) agosto, 																	"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'09', nvl(m.nr_valor_previsto,0), 0)) setembro, 																"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'10', nvl(m.nr_valor_previsto,0), 0)) outubro, 																	"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'11', nvl(m.nr_valor_previsto,0), 0)) novembro, 																"
	sql = sql &"        sum(decode(to_char(m.dt_confirmacao,'mm'),'12', nvl(m.nr_valor_previsto,0), 0)) dezembro, 																"
	sql = sql &"        sum(nvl(m.nr_valor_previsto,0)) total 																													"
	sql = sql &"  from tb_movimento m, 																																	"
	sql = sql &"       tb_categoria c 																																	"
	sql = sql &"  where m.id_categoria = c.id_categoria 																												"
	sql = sql &"  and c.id_empresa = "&Session("id_empresa")&" 																																"
	sql = sql &"  and c.tp_movimento = 'D' 																																"
	sql = sql &"  and bo_considerar_relatorio = 1 "
	sql = sql &"  and to_char(m.dt_confirmacao,'yyyy') = '"&sAno&"' 																											"
	sql = sql &"  and dt_confirmacao is not null "
	sql = sql &"  order by categoria   																																	"
	
	Set rs = oOracleDB.execute(sql)
	If Not rs.Eof Then
		html = ""
		html = html & CabecalhoTabela()
		i = 0
		Do While Not rs.Eof
			i = i + 1
			If i > linhas Then
				html = html & "</table>"
				Response.Write html
				Cabecalho()
				html = ""
				html = CabecalhoTabela()
				i = 0
			End If
			If Trim(rs("categoria")&"") <> "" Then
				html = html & "		<tr>"
				html = html & "			<td style='text-align:left;'>"&Server.HTMLEncode(UCase(rs("categoria")&""))&"</td>"
				html = html & "			<td nowrap>R$ "&FormatNumber(rs("janeiro"),2)&"</td>"
				html = html & "			<td nowrap>R$ "&FormatNumber(rs("fevereiro"),2)&"</td>"
				html = html & "			<td nowrap>R$ "&FormatNumber(rs("marco"),2)&"</td>"
				html = html & "			<td nowrap>R$ "&FormatNumber(rs("abril"),2)&"</td>"
				html = html & "			<td nowrap>R$ "&FormatNumber(rs("maio"),2)&"</td>"
				html = html & "			<td nowrap>R$ "&FormatNumber(rs("junho"),2)&"</td>"
				html = html & "			<td nowrap>R$ "&FormatNumber(rs("julho"),2)&"</td>"
				html = html & "			<td nowrap>R$ "&FormatNumber(rs("agosto"),2)&"</td>"
				html = html & "			<td nowrap>R$ "&FormatNumber(rs("setembro"),2)&"</td>"
				html = html & "			<td nowrap>R$ "&FormatNumber(rs("outubro"),2)&"</td>"
				html = html & "			<td nowrap>R$ "&FormatNumber(rs("novembro"),2)&"</td>"
				html = html & "			<td nowrap>R$ "&FormatNumber(rs("dezembro"),2)&"</td>"
				html = html & "			<td nowrap>R$ "&FormatNumber(rs("total"),2)&"</td>"
				html = html & "		</tr>"
			Else
				html = html & "	</tbody>"
				html = html & "	<tfoot>"
				html = html & "		<tr>"
				html = html & "			<th style='text-align:left;'>Total Mensal</th>"
				html = html & "			<th nowrap>R$ "&FormatNumber(rs("janeiro"),2)&"</th>"
				html = html & "			<th nowrap>R$ "&FormatNumber(rs("fevereiro"),2)&"</th>"
				html = html & "			<th nowrap>R$ "&FormatNumber(rs("marco"),2)&"</th>"
				html = html & "			<th nowrap>R$ "&FormatNumber(rs("abril"),2)&"</th>"
				html = html & "			<th nowrap>R$ "&FormatNumber(rs("maio"),2)&"</th>"
				html = html & "			<th nowrap>R$ "&FormatNumber(rs("junho"),2)&"</th>"
				html = html & "			<th nowrap>R$ "&FormatNumber(rs("julho"),2)&"</th>"
				html = html & "			<th nowrap>R$ "&FormatNumber(rs("agosto"),2)&"</th>"
				html = html & "			<th nowrap>R$ "&FormatNumber(rs("setembro"),2)&"</th>"
				html = html & "			<th nowrap>R$ "&FormatNumber(rs("outubro"),2)&"</th>"
				html = html & "			<th nowrap>R$ "&FormatNumber(rs("novembro"),2)&"</th>"
				html = html & "			<th nowrap>R$ "&FormatNumber(rs("dezembro"),2)&"</th>"
				html = html & "			<th nowrap>R$ "&FormatNumber(rs("total"),2)&"</th>"
				html = html & "		</tr>"
				html = html & "	</tfoot>"
			End if
			rs.MoveNext
		Loop
		html = html & "	</table>"
		response.write html
	End If
	Set rs = Nothing

%>
</body>
</html>
<!-- #include file="../dados/desconectar.asp" -->
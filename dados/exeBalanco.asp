<!-- #include file="conectar.asp" -->
<%

response.Charset = "utf-8"
sAno = trim(Request("ano")&"")
bConfirmado = trim(Request("confirmado")&"")
sIdConta = trim(Request("idconta")&"")

if bConfirmado = "" Then
	bConfirmado = "N"
End If

if sIdConta = "" Then
	sql = "select id_caixa from tb_caixa where id_empresa = " & session("id_empresa")
	Set rs = Server.CreateObject("ADODB.RecordSet")
	rs.open sql, oOracleDB
	sIdConta = rs(0)
	Set rs = Nothing
End If

function xx(valorx, valory)
	if cdbl(valorx) > cdbl(valory) then
		valor = replace(valorx, ".", "")
		valor = replace(valor, ",", ".")
		xx = valor
	else
		valor = replace(valory, ".", "")
		valor = replace(valor, ",", ".")
		xx = valor
	end if
end function

function saldo(valorx, valory)
	valor = cdbl(valorx) - cdbl(valory)
	if valor = 0 then
		saldo = ""
	else
	saldo = "R$ "&formatNumber(valor,2)
	end if
end function

function print_saldo(valorx, valory)
	valor = cdbl(valorx) - cdbl(valory)
	if valor = 0 then
		retorno = 0
	else
		retorno = formatNumber(valor,2)
	end if

	valor = replace(retorno, ".", "")
	valor = replace(valor, ",", ".")

	print_saldo = valor

end function

sql = ""

	sql = sql & "select c.id_empresa, nvl(t.tp_movimento,'S') tipo, max(to_char(m.dt_confirmacao,'yyyy')) dt_ano, "
	sql = sql & " sum(decode(to_char(dt_confirmacao,'mm'),'01',nr_valor_previsto,0)) jan, "
	sql = sql & " sum(decode(to_char(dt_confirmacao,'mm'),'02',nr_valor_previsto,0)) fev, "
	sql = sql & " sum(decode(to_char(dt_confirmacao,'mm'),'03',nr_valor_previsto,0)) mar, "
	sql = sql & " sum(decode(to_char(dt_confirmacao,'mm'),'04',nr_valor_previsto,0)) abr, "
	sql = sql & " sum(decode(to_char(dt_confirmacao,'mm'),'05',nr_valor_previsto,0)) mai, "
	sql = sql & " sum(decode(to_char(dt_confirmacao,'mm'),'06',nr_valor_previsto,0)) jun, "
	sql = sql & " sum(decode(to_char(dt_confirmacao,'mm'),'07',nr_valor_previsto,0)) jul, "
	sql = sql & " sum(decode(to_char(dt_confirmacao,'mm'),'08',nr_valor_previsto,0)) ago, "
	sql = sql & " sum(decode(to_char(dt_confirmacao,'mm'),'09',nr_valor_previsto,0)) ""set"", "
	sql = sql & " sum(decode(to_char(dt_confirmacao,'mm'),'10',nr_valor_previsto,0)) ""out"", "
	sql = sql & " sum(decode(to_char(dt_confirmacao,'mm'),'11',nr_valor_previsto,0)) nov, "
	sql = sql & " sum(decode(to_char(dt_confirmacao,'mm'),'12',nr_valor_previsto,0)) dez, "
	sql = sql & " sum(decode(t.tp_movimento,'C',nr_valor_previsto,nr_valor_previsto*-1)) total "
	sql = sql & " from tb_movimento m, tb_categoria t, tb_caixa c  "
	sql = sql & " where  m.id_categoria = t.id_categoria " 
	sql = sql & " and m.id_caixa = c.id_caixa "
	sql = sql & " and c.id_empresa = " & session("id_empresa") & " "
	sql = sql & " and to_char(dt_confirmacao,'yyyy') = '"&sAno&"' "
	sql = sql & " and m.id_caixa = " & sIdConta
	sql = sql & " group by t.tp_movimento, c.id_empresa "
	sql = sql & " order by t.tp_movimento asc"

Set rs = Server.CreateObject("ADODB.RecordSet")
'rs.CursorLocation = 3
rs.open sql,oOracleDB
'set rs = oOracleDB.execute(sql)
'response.write rs.recordcount
'response.end

if not rs.eof then
	rs.movefirst
	js = ""
	js = js & " { 'bg_colour': '#ffffff', " 
	js = js & "	'elements': [ "
	
	'		{'type': 'tags', 
	'	   'values':[ { 'x': 0, 'y': 8, 'text': 8 },], #vai ter loop aqui bexiga
	'	   'font': 'Tahoma', 
	'	   'font-size': 10 
	'	   }, 
		   
	'1a893d
	
	If rs("tipo") = "C" Then
		
		sTipo = "C"

		receita_jan = rs("jan")
		receita_fev = rs("fev")
		receita_mar = rs("mar")
		receita_abr = rs("abr")
		receita_mai = rs("mai")
		receita_jun = rs("jun")
		receita_jul = rs("jul")
		receita_ago = rs("ago")
		receita_set = rs("set")
		receita_out = rs("out")
		receita_nov = rs("nov")
		receita_dez = rs("dez")
		
		js = js & "{ "
		js = js & "'type': 'bar_3d', "
		js = js & "'text': 'Receita', "
		js = js & "'colour': '#0088cc', "
		js = js & "'values': [ "
			
		js = js & "		{ 'top': '"&replace(rs("jan"),",",".")&"', 'tip': 'Total de Receita: R$ "&formatnumber(rs("jan"),2)&"', 'on-click': 'listar(\""01/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(rs("fev"),",",".")&"', 'tip': 'Total de Receita: R$ "&formatnumber(rs("fev"),2)&"', 'on-click': 'listar(\""02/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(rs("mar"),",",".")&"', 'tip': 'Total de Receita: R$ "&formatnumber(rs("mar"),2)&"', 'on-click': 'listar(\""03/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(rs("abr"),",",".")&"', 'tip': 'Total de Receita: R$ "&formatnumber(rs("abr"),2)&"', 'on-click': 'listar(\""04/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(rs("mai"),",",".")&"', 'tip': 'Total de Receita: R$ "&formatnumber(rs("mai"),2)&"', 'on-click': 'listar(\""05/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(rs("jun"),",",".")&"', 'tip': 'Total de Receita: R$ "&formatnumber(rs("jun"),2)&"', 'on-click': 'listar(\""06/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(rs("jul"),",",".")&"', 'tip': 'Total de Receita: R$ "&formatnumber(rs("jul"),2)&"', 'on-click': 'listar(\""07/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(rs("ago"),",",".")&"', 'tip': 'Total de Receita: R$ "&formatnumber(rs("ago"),2)&"', 'on-click': 'listar(\""08/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(rs("set"),",",".")&"', 'tip': 'Total de Receita: R$ "&formatnumber(rs("set"),2)&"', 'on-click': 'listar(\""09/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(rs("out"),",",".")&"', 'tip': 'Total de Receita: R$ "&formatnumber(rs("out"),2)&"', 'on-click': 'listar(\""10/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(rs("nov"),",",".")&"', 'tip': 'Total de Receita: R$ "&formatnumber(rs("nov"),2)&"', 'on-click': 'listar(\""11/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(rs("dez"),",",".")&"', 'tip': 'Total de Receita: R$ "&formatnumber(rs("dez"),2)&"', 'on-click': 'listar(\""12/"&sAno&"\"",\"""&sTipo&"\"")' } "
		
		js = js & "], "
		js = js & "'on-show':{'type':'grow-up','cascade':2,'delay':0}} "
	
	rs.movenext
	
	js = js & ", "
	
	End If
	
	If rs("tipo") = "D" Then

		sTipo = "D"
		
		despesa_jan = rs("jan")
		despesa_fev = rs("fev")
		despesa_mar = rs("mar")
		despesa_abr = rs("abr")
		despesa_mai = rs("mai")
		despesa_jun = rs("jun")
		despesa_jul = rs("jul")
		despesa_ago = rs("ago")
		despesa_set = rs("set")
		despesa_out = rs("out")
		despesa_nov = rs("nov")
		despesa_dez = rs("dez")
		
		js = js & "{'type': 'bar_3d', "
		js = js & "'text': 'Despesa', "
		js = js & "'colour': '#d01f3c'," 
		js = js & "'values': [ "
			
		js = js & "		{ 'top': '"&replace(cdbl(rs("jan")),",",".")&"', 'tip': 'Total de Despesa: R$ "&formatnumber(rs("jan"),2)&"', 'on-click': 'listar(\""01/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(cdbl(rs("fev")),",",".")&"', 'tip': 'Total de Despesa: R$ "&formatnumber(rs("fev"),2)&"', 'on-click': 'listar(\""02/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(cdbl(rs("mar")),",",".")&"', 'tip': 'Total de Despesa: R$ "&formatnumber(rs("mar"),2)&"', 'on-click': 'listar(\""03/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(cdbl(rs("abr")),",",".")&"', 'tip': 'Total de Despesa: R$ "&formatnumber(rs("abr"),2)&"', 'on-click': 'listar(\""04/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(cdbl(rs("mai")),",",".")&"', 'tip': 'Total de Despesa: R$ "&formatnumber(rs("mai"),2)&"', 'on-click': 'listar(\""05/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(cdbl(rs("jun")),",",".")&"', 'tip': 'Total de Despesa: R$ "&formatnumber(rs("jun"),2)&"', 'on-click': 'listar(\""06/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(cdbl(rs("jul")),",",".")&"', 'tip': 'Total de Despesa: R$ "&formatnumber(rs("jul"),2)&"', 'on-click': 'listar(\""07/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(cdbl(rs("ago")),",",".")&"', 'tip': 'Total de Despesa: R$ "&formatnumber(rs("ago"),2)&"', 'on-click': 'listar(\""08/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(cdbl(rs("set")),",",".")&"', 'tip': 'Total de Despesa: R$ "&formatnumber(rs("set"),2)&"', 'on-click': 'listar(\""09/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(cdbl(rs("out")),",",".")&"', 'tip': 'Total de Despesa: R$ "&formatnumber(rs("out"),2)&"', 'on-click': 'listar(\""10/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(cdbl(rs("nov")),",",".")&"', 'tip': 'Total de Despesa: R$ "&formatnumber(rs("nov"),2)&"', 'on-click': 'listar(\""11/"&sAno&"\"",\"""&sTipo&"\"")' }, "
		js = js & "		{ 'top': '"&replace(cdbl(rs("dez")),",",".")&"', 'tip': 'Total de Despesa: R$ "&formatnumber(rs("dez"),2)&"', 'on-click': 'listar(\""12/"&sAno&"\"",\"""&sTipo&"\"")' } "
		js = js & "], "
		js = js & " 'on-show':{'type':'grow-up','cascade':2,'delay':2}}"
		
		'rs.movenext
		js = js & ", "
		
	End If
	
	'If rs("tipo") = "S" Then
		js = js & " {'type': 'area', "
		js = js & " 'colour':'#1ACE1A', 'fill': '#1ACE1A', 'fill-alpha': 0.3, 'width':2,"
		js = js & "	'dot-style': {'type':'solid-dot', 'colour':'#1ACE1A', 'dot-size': 3, 'halo': 2},"
		js = js & "  'values': [ "
		js = js & "{'value':" & print_saldo(receita_jan, despesa_jan) & ",'tip':'"&saldo(receita_jan, despesa_jan)&"'},"
		js = js & "{'value':" & print_saldo(receita_fev, despesa_fev) & ",'tip':'"&saldo(receita_fev, despesa_fev)&"'},"
		js = js & "{'value':" & print_saldo(receita_mar, despesa_mar) & ",'tip':'"&saldo(receita_mar, despesa_mar)&"'},"
		js = js & "{'value':" & print_saldo(receita_abr, despesa_abr) & ",'tip':'"&saldo(receita_abr, despesa_abr)&"'},"
		js = js & "{'value':" & print_saldo(receita_mai, despesa_mai) & ",'tip':'"&saldo(receita_mai, despesa_mai)&"'},"
		js = js & "{'value':" & print_saldo(receita_jun, despesa_jun) & ",'tip':'"&saldo(receita_jun, despesa_jun)&"'},"
		js = js & "{'value':" & print_saldo(receita_jul, despesa_jul) & ",'tip':'"&saldo(receita_jul, despesa_jul)&"'},"
		js = js & "{'value':" & print_saldo(receita_ago, despesa_ago) & ",'tip':'"&saldo(receita_ago, despesa_ago)&"'},"
		js = js & "{'value':" & print_saldo(receita_set, despesa_set) & ",'tip':'"&saldo(receita_set, despesa_set)&"'},"
		js = js & "{'value':" & print_saldo(receita_out, despesa_out) & ",'tip':'"&saldo(receita_out, despesa_out)&"'},"
		js = js & "{'value':" & print_saldo(receita_nov, despesa_nov) & ",'tip':'"&saldo(receita_nov, despesa_nov)&"'},"
		js = js & "{'value':" & print_saldo(receita_dez, despesa_dez) & ",'tip':'"&saldo(receita_dez, despesa_dez)&"'}"
		js = js & "  ], "
		js = js & "	   'width': 2, 'text': 'Saldo','font-size': 12,'on-show':{'type': 'pop-up', 'cascade':2, 'delay':4}} "
		js = js & ", "
	'End IF

	js = js &"	{'type': 'tags', 'text': 'Saldo'," 
	js = js &"	   	'values':[ "
	js = js &"		{ 'x': 0, 'y': "& print_saldo(receita_jan, despesa_jan) &", 'text': '"&saldo(receita_jan, despesa_jan)&"' }, "
	js = js &"		{ 'x': 1, 'y': "& print_saldo(receita_fev, despesa_fev) &", 'text': '"&saldo(receita_fev, despesa_fev)&"' }, "
	js = js &"		{ 'x': 2, 'y': "& print_saldo(receita_mar, despesa_mar) &", 'text': '"&saldo(receita_mar, despesa_mar)&"' }, "
	js = js &"		{ 'x': 3, 'y': "& print_saldo(receita_abr, despesa_abr) &", 'text': '"&saldo(receita_abr, despesa_abr)&"' }, "
	js = js &"		{ 'x': 4, 'y': "& print_saldo(receita_mai, despesa_mai) &", 'text': '"&saldo(receita_mai, despesa_mai)&"' }, "
	js = js &"		{ 'x': 5, 'y': "& print_saldo(receita_jun, despesa_jun) &", 'text': '"&saldo(receita_jun, despesa_jun)&"' }, "
	js = js &"		{ 'x': 6, 'y': "& print_saldo(receita_jul, despesa_jul) &", 'text': '"&saldo(receita_jul, despesa_jul)&"' }, "
	js = js &"		{ 'x': 7, 'y': "& print_saldo(receita_ago, despesa_ago) &", 'text': '"&saldo(receita_ago, despesa_ago)&"' }, "
	js = js &"		{ 'x': 8, 'y': "& print_saldo(receita_set, despesa_set) &", 'text': '"&saldo(receita_set, despesa_set)&"' }, "
	js = js &"		{ 'x': 9, 'y': "& print_saldo(receita_out, despesa_out) &", 'text': '"&saldo(receita_out, despesa_out)&"' }, "
	js = js &"		{ 'x': 10,'y': "& print_saldo(receita_nov, despesa_nov) &", 'text': '"&saldo(receita_nov, despesa_nov)&"' }, "
	js = js &"		{ 'x': 11,'y': "& print_saldo(receita_dez, despesa_dez) &", 'text': '"&saldo(receita_dez, despesa_dez)&"' } "
	js = js &" 	], "
	js = js &"	   'font': 'Tahoma', "
	js = js &"	   'font-size': 10 "
	js = js &"	   } "
	
	
	js = js & "], "
	js = js & " 'x_axis': { 'labels': { 'font': 'tahoma', 'size': 10, 'labels': ['janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho', 'julho', 'agosto', 'setembro','outubro','novembro','dezembro'] }, "
	js = js & " 'colour': '#e9e9e9', 'grid-colour': '#ffffff' }, "
	js = js & " 'y_axis': { 'offset': false, 'colour': '#e9e9e9', 'grid-colour': '#e9e9e9', 'steps': 5000, 'max': 18000,'min':-5000},'tooltip': { 'mouse': 2, 'stroke': 2, 'colour': '#000000', 'background': '#ffffff' } } "
	response.write replace(js,"'","""")
end if
set rs = nothing

%>
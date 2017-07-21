<%
Function selected(valorbanco,valorselct)
	If trim(valorbanco&"") = trim(valorselct&"") Then
		selected = "selected='selected'"
	End If
End Function

Function checked(valorbanco,valorselct)
	If trim(valorbanco&"") = trim(valorselct&"") Then
		checked = "checked='checked'"
	End If
End Function

Function optCategoria(id_categoria)
	html = ""
	
	sql = ""
	sql = sql & "select id_categoria, ds_categoria "
	sql = sql & "from tb_categoria "
	sql = sql & "where id_empresa = '" & session("id_empresa") & "'"
	sql = sql & "  and tp_movimento = 'C' and id_super_categoria is null "
	sql = sql & " order by ds_categoria "
	Set rsCategoria = oOracleDB.execute(sql)
	If Not rsCategoria.Eof Then
		html = html & "<optgroup label='RECEITA'>"
		Do While Not rsCategoria.Eof
			html = html & "<option "&selected(rsCategoria("id_categoria"),id_categoria)&" value="&rsCategoria("id_categoria")&">"&server.HTMLEncode(rsCategoria("ds_categoria"))&"</option>"

            sql = ""
	        sql = sql & "select id_categoria, ds_categoria "
	        sql = sql & "from tb_categoria "
	        sql = sql & "where id_empresa = '" & session("id_empresa") & "'"
	        sql = sql & "  and id_super_categoria = "&rsCategoria("id_categoria")&" "
			sql = sql & "  and tp_movimento = 'C' "
	        sql = sql & " order by ds_categoria "

            Set rsSubCategoria = oOracleDB.execute(sql)
            If Not rsSubCategoria.EOF Then
                Do While Not rsSubCategoria.EOF
                    html = html & "<option "&selected(rsSubCategoria("id_categoria"),id_categoria)&" value="&rsSubCategoria("id_categoria")&">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"&server.HTMLEncode(rsSubCategoria("ds_categoria"))&"</option>"
                rsSubCategoria.MoveNext
                Loop
            End If
            Set rsSubCategoria = Nothing

		rsCategoria.MoveNext
		Loop
		html = html & "</optgroup>"
	End If
	sql = ""
	sql = sql & "select id_categoria, ds_categoria, tp_movimento "
	sql = sql & "from tb_categoria "
	sql = sql & "where id_empresa = '" & session("id_empresa") & "'"
	sql = sql & "  and tp_movimento = 'D' and id_super_categoria is null  "
	sql = sql & " order by tp_movimento, ds_categoria "
	Set rsCategoria = oOracleDB.execute(sql)
	If Not rsCategoria.Eof Then
		html = html & "<optgroup label='DESPESA'>"
		Do While Not rsCategoria.Eof
			html = html & "<option "&selected(rsCategoria("id_categoria"),id_categoria)&" value="&rsCategoria("id_categoria")&">"&server.HTMLEncode(rsCategoria("ds_categoria"))&"</option>"
            
            sql = ""
	        sql = sql & "select id_categoria, ds_categoria "
	        sql = sql & "from tb_categoria "
	        sql = sql & "where id_empresa = '" & session("id_empresa") & "'"
	        sql = sql & "  and id_super_categoria = "&rsCategoria("id_categoria")&" "
			sql = sql & "  and tp_movimento = 'D' "
	        sql = sql & " order by ds_categoria "

            Set rsSubCategoria = oOracleDB.execute(sql)
            If Not rsSubCategoria.EOF Then
                Do While Not rsSubCategoria.EOF
                    html = html & "<option "&selected(rsSubCategoria("id_categoria"),id_categoria)&" value="&rsSubCategoria("id_categoria")&">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"&server.HTMLEncode(rsSubCategoria("ds_categoria"))&"</option>"
                rsSubCategoria.MoveNext
                Loop
            End If
            Set rsSubCategoria = Nothing

		rsCategoria.MoveNext
		Loop
		html = html & "</optgroup>"
	End If
	optCategoria = html
End Function

Function optCaixa(id_caixa)
	sql = ""
	sql = sql & "select id_caixa, ds_caixa "
	sql = sql & "from tb_caixa "
	sql = sql & "where id_empresa = '" & session("id_empresa") & "'"
	sql = sql & " order by ds_caixa "
	Set rsCaixa = oOracleDB.execute(sql)

	html = ""
	If Not rsCaixa.Eof Then
		Do While Not rsCaixa.Eof
		html = html & "<option "&selected(rsCaixa("id_caixa"),id_caixa)&" value="&rsCaixa("id_caixa")&">"&server.HTMLEncode(rsCaixa("ds_caixa"))&"</option>"
		rsCaixa.MoveNext
		Loop
	End If
	optCaixa = html
End Function

Function optMes(id_mes)
	html = ""
	html = html & "<option "&selected(id_mes,"01")&" value='01'>Janeiro</option>"
	html = html & "<option "&selected(id_mes,"02")&" value='02'>Fevereiro</option>"
    html = html & "<option "&selected(id_mes,"03")&" value='03'>"&Server.HTMLEncode("Março")&"</option>"
    html = html & "<option "&selected(id_mes,"04")&" value='04'>Abril</option>"
    html = html & "<option "&selected(id_mes,"05")&" value='05'>Maio</option>"
    html = html & "<option "&selected(id_mes,"06")&" value='06'>Junho</option>"
    html = html & "<option "&selected(id_mes,"07")&" value='07'>Julho</option>"
    html = html & "<option "&selected(id_mes,"08")&" value='08'>Agosto</option>"
    html = html & "<option "&selected(id_mes,"09")&" value='09'>Setembro</option>"
    html = html & "<option "&selected(id_mes,"10")&" value='10'>Outubro</option>"
    html = html & "<option "&selected(id_mes,"11")&" value='11'>Novembro</option>"
    html = html & "<option "&selected(id_mes,"12")&" value='12'>Dezembro</option>"
	optMes = html
End Function

Function optAno(id_ano)
	html = ""
	html = html & "<option "&selected(id_ano,"2014")&" value='2014'>2014</option>"
    html = html & "<option "&selected(id_ano,"2015")&" value='2015'>2015</option>"
	html = html & "<option "&selected(id_ano,"2016")&" value='2016'>2016</option>"
    html = html & "<option "&selected(id_ano,"2017")&" value='2017'>2017</option>"
	optAno = html
End Function

Function nomeMes(id_mes)
	sMes = ""
	select case id_mes
		case "01" or 1
			sMes = "janeiro"
		case "02" or 2
			sMes = "fevereiro"
		case "03" or 3
			sMes = "março"
		case "04" or 4
			sMes = "abril"
		case "05" or 5
			sMes = "maio"
		case "06" or 6
			sMes = "junho"
		case "07" or 7
			sMes = "julho"
		case "08" or 8
			sMes = "agosto"
		case "09" or 9
			sMes = "setembro"
		case "10" or 10
			sMes = "outubro"
		case "11" or 11
			sMes = "novembro"
		case "12" or 12
			sMes = "dezembro"
	end select
	nomeMes = Server.HTMLEncode(sMes)
End Function

Function nomeDia(dia)
	sDia = ""
	select case dia
		case 1
			sDia = "Domingo"
		case 2
			sDia = "Segunda"
		case 3
			sDia = "Terça"
		case 4
			sDia = "Quarta"
		case 5
			sDia = "Quinta"
		case 6
			sDia = "Sexta"
		case 7
			sDia = "Sábado"
	end select
	nomeDia = Server.HTMLEncode(sDia)
End Function

Function AddZero(valor)
	sValor = ""
	Select Case valor
		case 1
			sValor = "01"
		case 2
			sValor = "02"
		case 3
			sValor = "03"
		case 4
			sValor = "04"
		case 5
			sValor = "05"
		case 6
			sValor = "06"
		case 7
			sValor = "07"
		case 8
			sValor = "08"
		case 9
			sValor = "09"
		case else
			sValor = valor
	End Select
	AddZero = sValor
End Function

Function Saudacao()
	hora = hour(now())
	sValor = ""
	If hora >= 0 and hora <= 11 Then
		sValor = "Bom dia!"
	ElseIf hora >= 12 and hora <= 17 Then
		sValor = "Boa tarde!"
	Else
		sValor = "Boa noite!"
	End If
	Saudacao = sValor
End Function

Function optCliente(id_cliente)

	sql = ""
	sql = sql & " select id_cliente, ds_fantasia 				"
	sql = sql & "   from vw_cliente 							"
	sql = sql & "  where id_empresa = '" & session("id_empresa") & "'	"
    sql = sql & "    and tp_pessoa = 'PJ' "
	sql = sql & "  order by ds_fantasia"
	Set rsCliente = oOracleDB.execute(sql)
    html = ""
	If Not rsCliente.Eof Then
        html = html & "<optgroup label='"&ucase(server.HTMLEncode("Pessoa Juridica"))&"'>"
		Do While Not rsCliente.Eof
		html = html & "<option "&selected(rsCliente("id_cliente"),id_cliente)&" value='"&rsCliente("id_cliente")&"'>"&Server.HTMLEncode(rsCliente("ds_fantasia")&"")&"</option>"
		rsCliente.MoveNext
		Loop
        html = html & "</optgroup>"
	End If

    sql = ""
	sql = sql & " select id_cliente, ds_razao_social 				"
	sql = sql & "   from vw_cliente 							"
	sql = sql & "  where id_empresa = '" & session("id_empresa") & "'	"
    sql = sql & "    and tp_pessoa = 'PF' "
	sql = sql & "  order by ds_fantasia"
	Set rsCliente = oOracleDB.execute(sql)
	If Not rsCliente.Eof Then
        html = html & "<optgroup label='"&ucase(server.HTMLEncode("Pessoa Fisica"))&"'>"
		Do While Not rsCliente.Eof
		html = html & "<option "&selected(rsCliente("id_cliente"),id_cliente)&" value='"&rsCliente("id_cliente")&"'>"&Server.HTMLEncode(rsCliente("ds_razao_social")&"")&"</option>"
		rsCliente.MoveNext
		Loop
        html = html & "</optgroup>"
	End If
	optCliente = html
	
End Function

Function UsToBr(valor)
	valor = Replace(valor,"-","")
	valor = Replace(valor,",","")
	valor = Replace(valor,".",",")
	UsToBr = valor
End Function

Function arCategoria(tipo)
	sql = ""
	sql = sql & "select id_categoria, ds_categoria "
	sql = sql & "from tb_categoria "
	sql = sql & "where id_empresa = '" & session("id_empresa") & "'"
	sql = sql & "  and tp_movimento = '"&tipo&"' "
	sql = sql & " order by ds_categoria "
	
	Set rs = oOracleDB.execute(sql)
	js = "[]"
	If Not rs.EOF Then
		js = "["
		Do While Not rs.EOF
			js = js & "{'id':'"&rs(0)&"','value':'"&Server.HTMLEncode(replace(rs(1),"'","\'"))&"'}," 
			rs.MoveNext
		Loop
		js = Mid(js,1,len(js)-1) &"]"
	End If
	Set rs = Nothing
	arCategoria = js
End Function

Function arCliente()
	sql = ""
	sql = sql & "select id_cliente, nvl(ds_fantasia,ds_razao_social) "
	sql = sql & "from vw_cliente "
	sql = sql & "where id_empresa = '" & session("id_empresa") & "'"
	sql = sql & " order by nvl(ds_fantasia,ds_razao_social) "
	
	Set rs = oOracleDB.execute(sql)
	js = "[]"
	If Not rs.EOF Then
		js = "["
		Do While Not rs.EOF
			js = js & "{'id':'"&rs(0)&"','value':'"&Server.HTMLEncode(replace(rs(1),"'","\'"))&"'}," 
			rs.MoveNext
		Loop
		js = Mid(js,1,len(js)-1) &"]"
	End If
	Set rs = Nothing
	arCliente = js
End Function
%>
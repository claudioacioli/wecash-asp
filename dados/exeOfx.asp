<!-- #include file="conectar.asp" -->
<%
	response.Charset = "iso-8859-1"
	
	Dim sIdConta, sData, sHistorico, sCategoria, sValor, sAcao, sCliente
	
	CarregarDados()
	
	Select Case sAcao
		case "ofx":
			validar()
			inserir()
			retornar("1")
	End Select
	
	Sub validar()
		If sIdConta = "" or sCategoria = "" or sHistorico = "" Then
			response.Redirect("../frmOfx.asp")
		End If
	End Sub
	
	Sub CarregarDados()

		sAcao 	 	 	= trim(Request.Form("acao")&"")
		sIdConta 	 	= trim(Request.Form("id_caixa")&"")
		
		sData 	 		= trim(Request.Form("data")&"")
		sHistorico		= trim(Request.Form("historico")&"")
		sValor			= trim(Request.Form("valor")&"")
		sCategoria		= trim(Request.Form("id_categoria")&"")
		sCliente		= trim(Request.Form("id_cliente")&"")
		
	End Sub
	
	Sub inserir()
		
		aData = Split(sData,", ")
		aHist = Split(sHistorico,", ")
		aValor = Split(sValor,", ")
		aCategoria = Split(sCategoria,", ")
		If Session("bo_cliente") = 1 Then
			aCliente = Split(sCliente,", ")
		End If
		
		for i = 0 to ubound(aHist)
		
			sNrValor = replace(aValor(i),"-","")
			'sNrValor = replace(sNrValor,",",".")
			'sNrValor = aValor(i)
			
			
			
			sql = "select sq_movimento.nextval from dual "
			set rs = oOracleDb.Execute(sql)
			sIdMovimento = rs(0)
			'sIdMovimento = 0
			
			sql = ""
			sql = sql & " insert into tb_Movimento(id_caixa, id_movimento, id_categoria, ds_historico,nr_valor_previsto,dt_previsao,dt_confirmacao) "
			sql = sql & " values ("&sIdConta&","&sIdMovimento&", '"&aCategoria(i)&"' ,'"&aHist(i)&"', to_number('"&sNrValor&"','999999999D00'), to_date('"&aData(i)&"','DD/MM/YYYY'),to_date('"&aData(i)&"','DD/MM/YYYY')) "
			'response.write sql
			oOracleDb.Execute(sql)
			
			If Session("bo_cliente") = 1 Then
				If Trim(aCliente(i)&"") <> "0" Then 
					sql = " insert into rl_movimento_cliente(id_cliente, id_movimento) values ('"&Trim(aCliente(i))&"','"&sIdMovimento&"') "
					oOracleDb.Execute(sql)
				End If
			End If
		
		next
		
	End Sub
	
	Sub retornar(feed)
		Response.Redirect "../frmMovimento.asp?cke=1&feed="&feed
	End Sub
	
	
%>
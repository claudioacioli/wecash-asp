<!-- #include file="conectar.asp" -->
<%
	
	response.Charset = "iso-8859-1"
	
	Dim sIdCaixa,sDsCaixa,sNrSaldo, sAcao
	
	CarregarDados()
	
	Select Case sAcao
		case "insert":
			
			validar()
			inserir()
			retornar("1")
			
		case "update":
		
			validar()
			alterar()
			retornar("2")
		
		case "delete":
		
			excluir()
			retornar("3")
		
		case "listar":
			
			listar()
			
		case "acessoRapido":
			
			acessoRapido()
			
	End Select
	
	
	Sub inserir()
		'sNrSaldo = replace(sNrSaldo,".","")
		'sNrSaldo = replace(sNrSaldo,",",".")
		sql = ""
		sql = sql & " insert into tb_caixa(id_empresa,id_caixa,ds_caixa,nr_saldo_inicial,dt_caixa) "
		sql = sql & " values ("&Session("id_empresa")&",sq_caixa.nextval,'"&sDsCaixa&"',to_number('"&sNrSaldo&"','999999999D00'),sysdate) "
		oOracleDb.Execute(sql)
		
	End Sub
	
	
	Sub alterar()
	
		If sIdCaixa <> "" Then
			'sNrSaldo = replace(sNrSaldo,".","")
			'sNrSaldo = replace(sNrSaldo,",",".")
			
			sql = ""
			sql = sql & "update tb_caixa set "
			sql = sql & " ds_caixa = '"&sDsCaixa&"', "
			sql = sql & " nr_saldo_inicial = to_number('"&sNrSaldo&"','999999999D00')"
			sql = sql & " where id_empresa = "&Session("id_empresa")&" "
			sql = sql & "   and id_caixa = "&sIdCaixa&" "
			oOracleDb.Execute(sql)
		End If
		
	End Sub
	
	Sub excluir()
		If sIdCaixa <> "" Then
			sql = ""
			sql = sql & " delete tb_caixa where id_caixa = "&sIdCaixa
			oOracleDb.Execute(sql)
		End If
	End Sub
	
	Sub validar()
		If sDsCaixa = "" or sNrSaldo = "" Then
			Response.Redirect "../frmAdicionarCaixa.asp"
		End if
	End Sub
	
	Sub retornar(feed)
		Response.Redirect "../frmCaixa.asp?feed="&feed
	End Sub
	
	
	Sub CarregarDados()
		sIdCaixa = trim(Request("id_caixa")&"")
		sDsCaixa = trim(Request.form("ds_caixa")&"")
		sNrSaldo = trim(Request.form("nr_saldo")&"")
		sAcao 	 = trim(Request("acao")&"")
	End Sub
	
	Sub listar()

		sql = ""
		sql = sql & "select id_caixa, ds_caixa, dt_caixa,nr_saldo_inicial, "
		sql = sql & "nr_saldo_inicial +  " 
		sql = sql & "( "
		sql = sql & "select nvl(sum(decode(t.tp_movimento,'C', m.nr_valor_previsto,0)) - sum(decode(t.tp_movimento,'D', m.nr_valor_previsto,0)),0) saldo "
		sql = sql & "from tb_movimento m, tb_categoria t "
		sql = sql & "where m.id_caixa = c.id_caixa "
		sql = sql & " and m.id_categoria = t.id_categoria "
		sql = sql & "and dt_confirmacao is not null "
		sql = sql & ") saldo, (select count(*) from tb_movimento where id_empresa = c.id_empresa and id_caixa = c.id_caixa) nr_movimento "
		sql = sql & "from tb_caixa c "
		sql = sql & "where id_empresa = '" & session("id_empresa") & "'"
		sql = sql & " order by dt_caixa "

		'response.write sql
		'response.end
		set rs = oOracleDB.execute(sql)

		If Not rs.Eof Then
		%>
		<table class="tab_search">
			<col  />
			<col style="width:150px" />
			<col style="width:100px" />
            <col style="width:100px" />
			<col style="width:25px" />
            <col style="width:25px" />
			<thead>
				<tr>
					<th><%=server.HTMLEncode("Descrição")%></th>
					<th>Data/Hora cadastro</th>
					<th align="right">Saldo Inicial</th>
                    <th align="right">Saldo atual</th>
					<th colspan="2"></th>
				</tr>
			</thead>
			<tbody>
			<%Do While Not rs.eof
          		class_saldo = "positivo"
				If cdbl(rs("saldo")) < 0 Then
					class_saldo = "negativo"
				End If
			%>
				<tr>
					<td class='flow'><%=Server.HTMLEncode(rs("ds_caixa"))%><span><%=rs("ds_caixa")%></span></td>
					<td><%=rs("dt_caixa")%></td>
					<td align='right' >R$&nbsp;<%=FormatNumber(rs("nr_saldo_inicial"),2)%><span>R$&nbsp;<%=FormatNumber(rs("nr_saldo_inicial"),2)%></span></td>
                    <td align='right' class='<%=class_saldo%>' >R$&nbsp;<%=FormatNumber(rs("saldo"),2)%><span>R$&nbsp;<%=FormatNumber(rs("saldo"),2)%></span></td>
					
                    <td><a href="frmAdicionarCaixa.asp?id=<%=rs("id_caixa")%>"><img src="includes/img/editar.png" /></a><span>Editar</span></td>
                    <%If cdbl(rs("nr_movimento")) = 0 Then%>
                    	<td><a href="javascript:excluir(<%=rs("id_caixa")%>,'<%=server.HTMLEncode(rs("ds_caixa"))%>');"><img src="includes/img/lixeira.png" /></a><span>Excluir</span></td>
                    <%Else%>
                    	<td><img src="includes/img/lixeiraoff.png" /><span>Esta conta não pode ser<br />excluída, pois há movimentações<br /> para a mesma.</span></td>
					<%End If%>
				</tr>
			<%
				rs.MoveNext
			Loop
				
			%>
			</tbody>
			
		</table>
		<%
		Else
		%>
		<div class='atencao'><%=Server.HTMLEncode("Não existe nenhuma conta informada.")%></div>
		<%
		End If	
		
	End Sub
	
	Sub acessoRapido()
	
		total = 0

		sql = ""
		sql = sql & "select id_caixa, ds_caixa, dt_caixa, "
		sql = sql & "nr_saldo_inicial +  " 
		sql = sql & "( "
		sql = sql & "select nvl(sum(decode(t.tp_movimento,'C', m.nr_valor_previsto,0)) - sum(decode(t.tp_movimento,'D', m.nr_valor_previsto,0)),0) saldo "
		sql = sql & "from tb_movimento m, tb_categoria t "
		sql = sql & "where m.id_caixa = c.id_caixa "
		sql = sql & " and t.id_categoria = m.id_categoria "
		sql = sql & "and dt_confirmacao is not null "
		sql = sql & ") saldo, (select count(*) from tb_movimento where id_empresa = c.id_empresa and id_caixa = c.id_caixa) nr_movimento "
		sql = sql & "from tb_caixa c "
		sql = sql & "where id_empresa = '" & session("id_empresa") & "'"
		sql = sql & " order by dt_caixa "
		set rs = oOracleDB.execute(sql)

		If Not rs.Eof Then
		%>
		<table class="chart">
			<col />
            <col style="width:100px" />
            <thead>
            	<tr>
                	<th colspan="2">Saldos</th>
                </tr>
            </thead>
			<tbody>
			<%Do While Not rs.eof
          		class_saldo = "positivo"
				If cdbl(rs("saldo")) < 0 Then
					class_saldo = "negativo"
				End If
				
				If cdbl(rs("saldo")) > 0 Then
					total = total + cdbl(rs("saldo"))
				End If
				
			%>
				<tr>
					<td class="flow"><%=Server.HTMLEncode(rs("ds_caixa"))%><span><%=Server.HTMLEncode(rs("ds_caixa"))%></span></td>
					<td align='right' class='<%=class_saldo%>' >R$&nbsp;<%=FormatNumber(rs("saldo"),2)%></td>
				</tr>
			<%
				rs.MoveNext
			Loop
				
			%>
			
				<tr>
					<td style="padding:8px; font-weight:bold;">Total</td>
					<td style="padding:8px; font-weight:bold;" align="right">R$ <%=formatNumber(total,2)%></td>
				</tr>
			</tbody>
		</table>
		<%
		Else
		%>
		<div class='atencao'><%=Server.HTMLEncode("Não existe ainda nenhuma conta informada.")%></div>
		<%
		End If	
		
	End Sub

%>
<!-- #include file="desconectar.asp" -->
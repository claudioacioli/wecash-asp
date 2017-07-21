<!-- #include file="conectar.asp" -->
<%
	response.Charset = "iso-8859-1"
	
	Dim sIdCategoria, sIdCaixa,sIdMovimento,sDsMovimento, sTipo, sDataPrevisao, sDataConfirmacao,sNrValor, sAcao, sConfirmar, sReferencia, sIdCliente, tp_fixo_variavel, sAdicionarNovo
	
	CarregarDados()
	
	Select Case sAcao
		case "insert":
			
			validar()
			inserir()
			If Session("bo_cliente") Then
				SetMovimentoCliente()
			End If
			
			If sAdicionarNovo = "true" Then
				Response.Redirect "../frmAdicionarMovimento.asp"
			Else
				retornar("1")
			End If
			
		case "update":
		
			validar()
			alterar()
			If Session("bo_cliente") Then
				SetMovimentoCliente()
			End If
			
			If sAdicionarNovo = "true" Then
				Response.Redirect "../frmAdicionarMovimento.asp"
			Else
				retornar("2")
			End If
		
		case "delete":
			If Session("bo_cliente") Then
				sIdCliente = ""
				SetMovimentoCliente()
			End If
			excluir()
			retornar("3")
		
		case "listar":
			
			listar()
			
		case "confirmar":
			confirmar()
		
		case "movimentoPorCategoria":
			movimentoPorCategoria()
		
		case "movimentoPorReferencia":
			movimentoPorReferencia()

		case "extrato":
			extrato()
			
		case "resumo":
			visaogeral()
			
	End Select
	
	
	Sub inserir()
		sData = "Null"
		If sDataConfirmacao <> "" Then
			sData = "to_date('"&sDataConfirmacao&"','DD/MM/YYYY')"
		End If
		
		'sNrValor = replace(sNrValor,".","")
		'sNrValor = replace(sNrValor,",",".")
		
		sql = "select sq_movimento.nextval from dual "
		set rs = oOracleDb.Execute(sql)
		sIdMovimento = rs(0)
		
		sql = ""
		sql = sql & " insert into tb_Movimento(id_caixa, id_movimento, id_categoria, ds_historico,nr_valor_previsto,dt_previsao,dt_confirmacao,tp_fixo_variavel) "
		sql = sql & " values ("&sIdCaixa&","&sIdMovimento&", '"&sIdCategoria&"' ,'"&sDsMovimento&"', to_number('"&sNrValor&"','999999999D00'), to_date('"&sDataPrevisao&"','DD/MM/YYYY'),"&sData&", '"&tp_fixo_variavel&"')"
	
		oOracleDb.Execute(sql)
		
	End Sub
	
	
	Sub alterar()
	
		If sIdMovimento <> "" Then
			sql = ""
			
			sData = "Null"
			If sDataConfirmacao <> "" Then
				sData = "to_date('"&sDataConfirmacao&"','DD/MM/YYYY')"
			End If
			
			'sNrValor = replace(sNrValor,".","")
			'sNrValor = replace(sNrValor,",",".")
			
			sql = sql & "update tb_movimento set "
			sql = sql & " id_caixa = '"&sIdCaixa&"', "
			sql = sql & " ds_historico = '"&sDsMovimento&"', "
			sql = sql & " dt_previsao = to_date('"&sDataPrevisao&"','DD/MM/YYYY'), "
			sql = sql & " dt_confirmacao = "&sData&" , "
			sql = sql & " nr_valor_previsto =  to_number('"&sNrValor&"','999999999D00'), "
			sql = sql & " id_categoria = '"&sIdCategoria&"', "
			sql = sql & " tp_fixo_variavel = '"&tp_fixo_variavel&"'"
			sql = sql & " where id_Movimento = "&sIdMovimento&" "
			oOracleDb.Execute(sql)
			
		End If
		
	End Sub
	
	Sub SetMovimentoCliente()
		
		If sIdMovimento <> "" Then
		
			If sIdCliente <> "" Then
				sql = "select 1 from rl_movimento_cliente where id_movimento = "&sIdMovimento&" "
				Set rs = oOracleDB.execute(sql)
				If rs.eof Then
					sql = " insert into rl_movimento_cliente(id_cliente, id_movimento) values ('"&sIdCliente&"','"&sIdMovimento&"') "
				Else
					sql = " update rl_movimento_cliente set id_cliente = '"&sIdCliente&"' where id_movimento = '"&sIdMovimento&"' "
				End If
			Else
				sql = "delete from rl_movimento_cliente where id_movimento = "&sIdMovimento
			End If
			
			oOracleDB.execute(sql)
			
		End If
		
	End Sub
	
	Sub confirmar()
		
		If sIdMovimento <> "" Then
			
			data = "sysdate"
			dataRetorno = date()
			If sConfirmar = "N" Then
				data = "null"
				dataRetorno = ""
			End If
			
			sql = ""
			sql = sql & "update tb_movimento set "
			sql = sql & " dt_confirmacao = "&data&" "
			sql = sql & " where id_Movimento = "&sIdMovimento&" "
			oOracleDb.Execute(sql)
			
			Response.write dataRetorno
			
		End If
		
	End Sub
	
	Sub excluir()
		If sIdMovimento <> "" Then
			sql = ""
			sql = "delete from rl_movimento_cliente where id_movimento = "&sIdMovimento
			oOracleDb.Execute(sql)
			sql = ""
			sql = sql & " delete tb_movimento where id_movimento = "&sIdMovimento
			oOracleDb.Execute(sql)
		End If
	End Sub
	
	Sub validar()
		If sDsMovimento & sNrSaldo = "" Then
			Response.Redirect "../frmAdicionarMovimento.asp"
		End if
	End Sub
	
	Sub retornar(feed)
		Response.Redirect "../frmMovimento.asp?cke=1&feed="&feed
	End Sub
	
	
	Sub CarregarDados()

		sAcao 	 	 		= trim(Request("acao")&"")
		sIdCaixa 	 		= trim(Request("id_caixa")&"")
		sIdMovimento 		= trim(Request("id_Movimento")&"")
		sIdCategoria		= trim(Request("id_categoria")&"")
		sDsMovimento 		= trim(Request.form("ds_historico")&"")
		sTipo		 		= trim(Request.form("tp_movimento")&"")
		sDataPrevisao 		= trim(Request.form("dt_previsto")&"")
		sDataConfirmacao 	= trim(Request("dt_confirmacao")&"")
		sNrValor 			= trim(Request("nr_valor")&"")
		sConfirmar			= trim(Request("confirmado")&"")
		sReferencia			= trim(Request("referencia")&"")
		sIdCliente			= trim(Request("id_cliente")&"")
		tp_fixo_variavel    = trim(Request("tp_fixo_variavel")&"")
		sAdicionarNovo		= trim(Request("new")&"")
		
	End Sub
	
	Function Saldos(tipo,confirmado)
		sql = ""
		sql = sql & "select nvl(sum( m.nr_valor_previsto),0)																							"
		sql = sql & "from tb_Movimento m, tb_caixa c, tb_categoria t				 																					"
		sql = sql & "where c.id_caixa = m.id_caixa 																										"
		sql = sql & "  and c.id_empresa = " & session("id_empresa") & " 																				"
		sql = sql & "  and m.id_categoria = t.id_categoria "
		sql = sql & "  and ( 																															"
		sql = sql & " 			to_char(dt_previsao,'MM/YYYY') = '"&sReferencia&"' 																		"
    	sql = sql & "		or 	(dt_confirmacao is null and to_date(to_char(dt_previsao,'MM/YYYY'),'MM/YYYY') < to_date('"&sReferencia&"','MM/YYYY')  and to_date('"&sReferencia&"','MM/YYYY') <= to_date(to_char(sysdate,'MM/YYYY'),'MM/YYYY')  ) 	" 
    	sql = sql & "		or 	to_char(dt_confirmacao,'MM/YYYY') = '"&sReferencia&"' 																	"
    	sql = sql & "	) 																																"
		
		
		If tipo = "D" or tipo = "C" Then
			sql = sql & "  and t.tp_movimento = '"&tipo&"' 																								"
		End If
		
		If confirmado Then
			sql = sql & "  and dt_confirmacao is not null																								"
		End If
		
		Set rs = oOracleDB.execute(sql)
		Saldos = rs(0)
	
	End function
	
	Sub listar()


		'valor_credito_previsto 		= Saldos("C",false)
		'valor_credito_confirmado 	= Saldos("C",true)

		'Response.write cdbl(valor_credito_previsto) - cdbl(valor_credito_confirmado) & "<br />"
		'Response.end

		'valor_credito_pendente 		= cdbl(valor_credito_previsto) - cdbl(valor_credito_confirmado)
		
		'valor_debito_previsto 		= Saldos("D",false)
		'valor_debito_confirmado 	= Saldos("D",true)
		'valor_debito_pendente 		= cdbl(valor_debito_previsto) - cdbl(valor_debito_confirmado)

		'valor_saldo_previsto 		= cdbl(valor_credito_previsto) - cdbl(valor_debito_previsto)
		'valor_saldo_confirmado 		= cdbl(valor_credito_confirmado) - cdbl(valor_debito_confirmado)
		
		sql = ""
		sql = sql & " Select Max(C.Ds_Caixa) Conta, "
		sql = sql & "       nvl(Sum(Case When Ct.Tp_Movimento = 'C' Then Nr_Valor_Previsto End),0) As Total_Credito_Previsto, "
		sql = sql & "       Nvl(Sum(Case When Ct.Tp_Movimento = 'C' And Dt_Confirmacao Is Not Null Then Nr_Valor_Previsto End),0) As Total_Credito_Pago, "
		sql = sql & "       Nvl(Sum(Case When Ct.Tp_Movimento = 'C' And Dt_Confirmacao Is Null Then Nr_Valor_Previsto End),0) As Total_Credito_Pendente,       "
		sql = sql & "       Nvl(Sum(Case When Ct.Tp_Movimento = 'D' Then Nr_Valor_Previsto End),0) As Total_Debito_Previsto, "
		sql = sql & "       Nvl(Sum(Case When Ct.Tp_Movimento = 'D' And Dt_Confirmacao Is Not Null Then Nr_Valor_Previsto End),0) As Total_Debito_Pago,       "
		sql = sql & "              Nvl(Sum(Case When Ct.Tp_Movimento = 'D' And Dt_Confirmacao Is Null Then Nr_Valor_Previsto End),0) As Total_Debito_Pendente, "
		sql = sql & "      (Nvl(Sum(Case When Ct.Tp_Movimento = 'C' Then Nr_Valor_Previsto End),0) - Nvl(Sum(Case When Ct.Tp_Movimento = 'D' Then Nr_Valor_Previsto End),0) ) Saldo_Previsto, "
		sql = sql & "      (Nvl(Sum(Case When Ct.Tp_Movimento = 'C' And Dt_Confirmacao Is Not Null Then Nr_Valor_Previsto End),0) - Nvl(Sum(Case When Ct.Tp_Movimento = 'D' And Dt_Confirmacao Is Not Null Then Nr_Valor_Previsto End),0) ) saldo_provisorio "
		sql = sql & "  From Tb_Caixa C, "
		sql = sql & "       Tb_Movimento M, "
		sql = sql & "       Tb_Categoria Ct "
		sql = sql & " Where C.Id_Caixa = M.Id_Caixa "
		sql = sql & " AND M.ID_CATEGORIA = CT.ID_CATEGORIA "
		sql = sql & " And C.Id_Empresa = " & session("id_empresa") & "  "
		sql = sql & "  And ( 												"								
		sql = sql & " 			( to_char(dt_previsao,'MM/YYYY') = '"&sReferencia&"' and ( dt_confirmacao is null or to_char(dt_confirmacao,'MM/YYYY') = '"&sReferencia&"' ) ) "
		sql = sql & "      or 	(dt_confirmacao is null and to_date(to_char(dt_previsao,'MM/YYYY'),'MM/YYYY') < to_date('"&sReferencia&"','MM/YYYY')  and to_date('"&sReferencia&"','MM/YYYY') <= to_date(to_char(sysdate,'MM/YYYY'),'MM/YYYY')  ) 	 "
		sql = sql & "    	or 	to_char(dt_confirmacao,'MM/YYYY') = '"&sReferencia&"' 																"
		sql = sql & "    	) 	 "
		sql = sql & " GROUP BY C.ID_CAIXA " 

		'response.write sql

		Set rsSaldos = oOracleDB.execute(sql)

		if Not rsSaldos.EOF Then
		%>
			<table class="">

        	<thead>
            	<tr>
            		<th rowspan="2" style="border-right:1px solid #ccc;">&nbsp;</th>
                    <th colspan="3" style="border-right:1px solid #ccc;"><%=Server.HTMLEncode("Crédito")%></th>
                    <th colspan="3" style="border-right:1px solid #ccc;"><%=Server.HTMLEncode("Débito")%></th>
                    <th colspan="2">Saldo</th>
                </tr>
                <tr>
                	<th style="border-right:1px solid #ccc;">Previsto</th>
                	<th style="border-right:1px solid #ccc;">Pendente</th>
                	<th style="border-right:1px solid #ccc;">Confirmado</th>
                	<th style="border-right:1px solid #ccc;">Previsto</th>
                	<th style="border-right:1px solid #ccc;">Pendente</th>
                	<th style="border-right:1px solid #ccc;">Confirmado</th>
                	<th style="border-right:1px solid #ccc;">Previsto</th>
                	<th>Confirmado</th>
                </tr>
            </thead>
            <tbody>
<%
			do While Not rsSaldos.EOF
				class_saldo_previsto 		= "positivo"
				class_saldo_confirmado 		= "positivo"

				If cdbl(rsSaldos("Saldo_Previsto")) < 0 Then
					class_saldo_previsto = "negativo"
				End If
			
				If cdbl(rsSaldos("saldo_provisorio")) < 0 Then
					class_saldo_confirmado = "negativo"
				End If
%>
				<tr>
					<td style="border-right:1px solid #ccc;"><%=rsSaldos("Conta")%></td>
                    <td class="positivo" style="border-right:1px solid #e9e9e9;">R$ <%=FormatNumber(rsSaldos("Total_Credito_Previsto"),2)%><span>R$ <%=FormatNumber(rsSaldos("Total_Credito_Previsto"),2)%></span></td>
                    <td class="positivo" style="border-right:1px solid #e9e9e9;">R$ <%=FormatNumber(rsSaldos("Total_Credito_Pendente"),2)%><span>R$ <%=FormatNumber(rsSaldos("Total_Credito_Pendente"),2)%></span></td>
                    <td style="border-right:1px solid #ccc;" class="positivo">R$ <%=FormatNumber(rsSaldos("Total_Credito_Pago"),2)%><span>R$ <%=FormatNumber(rsSaldos("Total_Credito_Pago"),2)%></span></td>
                    
                    <td class="positivo" style="border-right:1px solid #e9e9e9;">R$ <%=FormatNumber(rsSaldos("Total_Debito_Previsto"),2)%><span>R$ <%=FormatNumber(rsSaldos("Total_Debito_Previsto"),2)%></span></td>
                    <td class="positivo" style="border-right:1px solid #e9e9e9;">R$ <%=FormatNumber(rsSaldos("Total_Debito_Pendente"),2)%><span>R$ <%=FormatNumber(rsSaldos("Total_Debito_Pendente"),2)%></span></td>
                    <td style="border-right:1px solid #ccc;" class="positivo">R$ <%=FormatNumber(rsSaldos("Total_Debito_Pago"),2)%><span>R$ <%=FormatNumber(rsSaldos("Total_Debito_Pago"),2)%></span></td>
                    
                    <td class="<%=class_saldo_previsto%>" style="border-right:1px solid #e9e9e9;">R$ <%=FormatNumber(rsSaldos("Saldo_Previsto"),2)%><span>R$ <%=FormatNumber(rsSaldos("Saldo_Previsto"),2)%></span></td>
                    <td class="<%=class_saldo_confirmado%>">R$ <%=FormatNumber(rsSaldos("saldo_provisorio"),2)%><span>R$ <%=FormatNumber(rsSaldos("saldo_provisorio"),2)%></span></td>
                </tr>
<%
				rsSaldos.moveNext
			Loop
%>
			</tbody>
			</table>
<%			
		End If
		
		Set rsSaldos = Nothing

		
		sql = ""
		sql = sql & "select c.id_caixa, 																												"
		sql = sql & " c.ds_caixa, 																														"
		sql = sql & " t.ds_categoria,  																													"
		sql = sql & " t.id_categoria,  																													"
		sql = sql & " m.id_Movimento,  																													"
		sql = sql & " m.ds_historico,  																													"
		sql = sql & " to_char(m.dt_previsao,'DD/MM/YYYY') dt_previsao, 																					"
		sql = sql & " to_char(m.dt_confirmacao,'DD/MM/YYYY') dt_confirmacao, 																			"
		sql = sql & " m.nr_valor_previsto, 																												"
		sql = sql & " t.tp_movimento, m.tp_fixo_variavel 																													"
		If Session("bo_cliente") Then
			sql = sql & ",(select nvl(ds_fantasia,ds_razao_social) from vw_cliente cl, rl_movimento_cliente rmc where cl.id_cliente = rmc.id_cliente and rmc.id_movimento(+) = m.id_movimento ) ds_fantasia "
		End If
		sql = sql & "from tb_Movimento m, tb_caixa c, tb_categoria t 																					"
		sql = sql & "where c.id_caixa = m.id_caixa 																										"
		sql = sql & "  and t.id_categoria = m.id_categoria 																								"
		sql = sql & "  and c.id_empresa = " & session("id_empresa") & " 																				"
		sql = sql & "  and ( 																															"
		sql = sql & " 			to_char(dt_previsao,'MM/YYYY') = '"&sReferencia&"' 																			"
    	sql = sql & "		or 	(dt_confirmacao is null and to_date(to_char(dt_previsao,'MM/YYYY'),'MM/YYYY') < to_date('"&sReferencia&"','MM/YYYY')  and to_date('"&sReferencia&"','MM/YYYY') <= to_date(to_char(sysdate,'MM/YYYY'),'MM/YYYY')  ) 	" 
    	sql = sql & "		or 	to_char(dt_confirmacao,'MM/YYYY') = '"&sReferencia&"' 																	"
    	sql = sql & "	) 																																"
		sql = sql & "order by m.dt_confirmacao desc, m.dt_previsao, t.tp_movimento "
		
		'to_date(to_char(dt_previsao,'MM/YYYY'),'MM/YYYY') <= to_date('"&sReferencia&"','MM/YYYY') ) 
		'and  to_date('"&sReferencia&"','MM/YYYY') > to_date(to_char(sysdate,'MM/YYYY'),'MM/YYYY')
		
		Set rs = oOracleDB.execute(sql)
		
        col = ""
		colspan = "8"
        th_fantasia = ""
		ds_fantasia = ""
		
		If Session("bo_cliente") = 1 Then
			colspan = "9"
			col = "<col  />"
			th_fantasia = "<th>Cliente</th>"			
		End If
		
		If Not rs.Eof Then
		
        %>
		<table class="tab_search">
			<col style="width:25px" />
            <col style="width:100px" />
			<col style="width:100px" />
            <%=col%>
			<col  />			
			<col style="width:100px" />	
            <col style="width:25px" />
			<col style="width:100px" />

			<col style="width:80px" />
			<col style="width:25px" />
            <col style="width:25px" />
			<thead>
				<tr>
					<th></th>
                    <th><%=server.HTMLEncode("Previsto para")%></th>
					<th><%=server.HTMLEncode("Confirmado em")%></th>
					<%=th_fantasia%>
					<th><%=server.HTMLEncode("Histórico")%></th>
					<th><%=server.HTMLEncode("Conta")%></th>
					<th></th>
                    <th>Categoria</th>
					<th>Valor</th>
					<th colspan="2"></th>
				</tr>
			</thead>
			<tbody>
			<%Do While Not rs.eof%>		
				<%
				classe = ""
				check = ""
				
				sTextoAuxiliar = ""
				
				If Session("bo_cliente") = 1 Then
                    span = ""
                    if trim(rs("ds_fantasia")&"") <> "" Then
                        span = "<span>"&Server.HTMLEncode(rs("ds_fantasia")&"")&"</span>"
                    End If
					ds_fantasia = "<td class='flow'>"&Server.HTMLEncode(rs("ds_fantasia")&"")&""&span&"</td>"
				End If
				
				IF date() > DateValue(rs("dt_previsao")&"") Then
					classe = "class='atrasado' "
					If Trim(rs("dt_confirmacao")&"") = "" Then
						sTextoAuxiliar = sTextoAuxiliar & "atrasadoatrasadosatrasadaatrasadas"
					End If
				elseif date() = DateValue(rs("dt_previsao")&"") then
					classe = "class='hoje' "
				else
					If Trim(rs("dt_confirmacao")&"") <> "" Then
						sTextoAuxiliar = sTextoAuxiliar & "em dia"
					End If
				End If
				
				If Trim(rs("dt_confirmacao")&"") <> "" Then
					classe = "class='confirmado' "
					check = "checked='checked'"
					sTextoAuxiliar = sTextoAuxiliar & "confirmadaconfirmadoconfirmadasconfirmados"
				else
					sTextoAuxiliar = sTextoAuxiliar & "previstoprevistosa pagar"
				End If
				
				If Trim(rs("tp_movimento")&"") = "D" Then
					sTextoAuxiliar = sTextoAuxiliar & "despesadespesas"
				Else
					sTextoAuxiliar = sTextoAuxiliar & "receitareceitas"
				End If
				
				'If 1=1 Then
				'	classe = replace(classe, "'", "")
				'	classe = replace(classe, "=", "")
				'	classe = replace(classe, " ", "")
				'	classe = replace(classe, "class", "")
				'	classe = "class='"&classe&" fixo'"
				'End If
				
				sClasseFixoVariavel = ""
				If trim(rs("tp_fixo_variavel")&"") = "F" Then
					sClasseFixoVariavel = "fixo"
				ElseIf trim(rs("tp_fixo_variavel")&"") = "V" Then
					sClasseFixoVariavel = "variavel"
				ElseIf trim(rs("tp_fixo_variavel")&"") = "R" Then
					sClasseFixoVariavel = "renda"
				End If
				
				%>
				
				<tr <%=classe%>>
					<td class="<%=sClasseFixoVariavel%>" text="<%=sTextoAuxiliar%>">
						<input type="checkbox" <%=check%> value="<%=rs("id_movimento")%>" onclick='confirmar(this)' />
                        <span>Confirmado?</span>
					</td>
                    <td text="<%=sClasseFixoVariavel%>"><%=rs("dt_previsao")%></td>
					<td><%=rs("dt_confirmacao")%></td>
					<%=ds_fantasia%>
					<td class="flow"><%=server.HTMLEncode(rs("ds_historico"))%><span><%=server.HTMLEncode(rs("ds_historico"))%></span></td>
					<td class="flow"><%=server.HTMLEncode(rs("ds_caixa"))%><span><%=server.HTMLEncode(rs("ds_caixa"))%></span></td>
					<td>
						<%If Trim(rs("tp_movimento")&"") = "D" Then%>
							<img src="includes/img/pagar.png" />
                            <span><%=Server.HTMLEncode("Despesa")%></span>
						<%Else%>
							<img src="includes/img/receber.png" />
                            <span><%=Server.HTMLEncode("Receita")%></span>
						<%End If%>
					</td>
                    <td class="flow"><%=server.HTMLEncode(rs("ds_categoria"))%><span><%=server.HTMLEncode(rs("ds_categoria"))%></span></td>
					<td align='right' class='positivo'>R$ <%=FormatNumber(rs("nr_valor_previsto"),2)%><span>R$ <%=FormatNumber(rs("nr_valor_previsto"),2)%></span></td>
					<td><a href='frmAdicionarMovimento.asp?id=<%=rs("id_movimento")%>'><img src="includes/img/editar.png" /></a><span>Editar</span></td>
                    <td><a href="javascript:excluir(<%=rs("id_movimento")%>,'<%=server.HTMLEncode("Tem certeza que deseja excluir a movimentação "&rs("ds_historico")&"?")%>');"><img src="includes/img/lixeira.png" /></a><span>Excluir</span></td>
				</tr>
			<%
				rs.MoveNext
			Loop
				
			%>
			</tbody>
			<tfoot>
				<tr>
					<th colspan="<%=col%>" ></th>
					<th align="right"></th>
					<th></th>
				</tr>
			</tfoot>
		</table>
		<%
		Else
		%>
			<br />
            <div class='atencao'><%=Server.HTMLEncode("Não existe nenhuma movimentação no período informado!")%></div>
		<%
		End If	
		
	End Sub
	
	Sub movimentoPorReferencia()
		
		sTipo = Trim(Request("tipo")&"")
		sReferencia = Trim(Request("referente")&"")

		sql = ""
		sql = sql & "select c.id_caixa, 																												"
		sql = sql & " c.ds_caixa, 																														"
		sql = sql & " t.ds_categoria,  																													"
		sql = sql & " t.id_categoria,  																													"
		sql = sql & " m.id_Movimento,  																													"
		sql = sql & " m.ds_historico,  																													"
		sql = sql & " to_char(m.dt_previsao,'DD/MM/YYYY') dt_previsao, 																					"
		sql = sql & " to_char(m.dt_confirmacao,'DD/MM/YYYY') dt_confirmacao, 																			"
		sql = sql & " m.nr_valor_previsto, 																												"
		sql = sql & " t.tp_movimento 																													"
		sql = sql & "from tb_Movimento m, tb_caixa c, tb_categoria t 																					"
		sql = sql & "where c.id_caixa = m.id_caixa 																										"
		sql = sql & "  and t.id_categoria = m.id_categoria 																								"
		sql = sql & "  and c.id_empresa = " & session("id_empresa") & " 																				"
		sql = sql & "  and ( 																															"
		sql = sql & " 			to_char(dt_previsao,'MM/YYYY') = '"&sReferencia&"' 																			"
    	sql = sql & "		or 	(dt_confirmacao is null and to_date(to_char(dt_previsao,'MM/YYYY'),'MM/YYYY') < to_date('"&sReferencia&"','MM/YYYY')  and to_date('"&sReferencia&"','MM/YYYY') <= to_date(to_char(sysdate,'MM/YYYY'),'MM/YYYY')  ) 	" 
    	sql = sql & "		or 	to_char(dt_confirmacao,'MM/YYYY') = '"&sReferencia&"' 																	"
    	sql = sql & "	) 												"	
		sql = sql & "	AND   t.tp_movimento = '"&sTipo&"' "
		sql = sql & "order by m.dt_confirmacao desc, m.dt_previsao, t.tp_movimento "
		Set rs = oOracleDB.execute(sql)
		
		If Not rs.Eof Then
		
        %>
		<table class="chart">
			<col  />			
			<col style="width:130px" />	
			<col style="width:130px" />
			<col style="width:100px" />
			<col style="width:100px" />
			<col style="width:80px" />
			
			<thead>
				<tr>
					<%=th_fantasia%>
					<th><%=server.HTMLEncode("Histórico")%></th>
					<th><%=server.HTMLEncode("Conta")%></th>
                    <th>Categoria</th>
					<th><%=server.HTMLEncode("Previsto para")%></th>
					<th><%=server.HTMLEncode("Confirmado em")%></th>
					<th>Valor</th>
				</tr>
			</thead>
			<tbody>
			<%Do While Not rs.eof%>		
				<%
				classe = ""
				check = ""
				
				If Session("bo_cliente") = 1 Then
					ds_fantasia = "<td>"&Server.HTMLEncode(rs("ds_fantasia")&"")&"</td>"
				End If
				
				IF date() > DateValue(rs("dt_previsao")&"") Then
					classe = "class='atrasado' "
				End If
				
				If Trim(rs("dt_confirmacao")&"") <> "" Then
					classe = "class='confirmado' "
					check = "checked='checked'"
				End If
				%>
				
				<tr>
					
                    <%=ds_fantasia%>
					<td class="flow"><%=server.HTMLEncode(rs("ds_historico"))%></td>
					<td class="flow"><%=server.HTMLEncode(rs("ds_caixa"))%></td>
                    <td class="flow">
					<%If Trim(rs("tp_movimento")&"") = "D" Then%>
							<img src="includes/img/pagar.png" align="absmiddle" style="margin-right:2px;" />
                            <span><%=Server.HTMLEncode("Débito")%></span>
						<%Else%>
							<img src="includes/img/receber.png"  align="absmiddle" style="margin-right:2px;" />
                            <span><%=Server.HTMLEncode("Crédito")%></span>
						<%End If%>
					<%=server.HTMLEncode(rs("ds_categoria"))%>
                    </td>
					<td align="center"><%=rs("dt_previsao")%></td>
					<td align="center"><%=rs("dt_confirmacao")%></td>
					<td align='right' class='positivo'>R$ <%=FormatNumber(rs("nr_valor_previsto"),2)%></td>
				</tr>
			<%
				rs.MoveNext
			Loop
				
			%>
			</tbody>
			
		</table>
		
		<%
		
		End If	

	End Sub

	Sub movimentoPorCategoria()
	
		sIdCaixa = trim(Request("id_caixa")&"")
		sTipo = trim(Request("tipo")&"")

		sql = ""
		sql = sql & "select c.id_caixa, 																												"
		sql = sql & " c.ds_caixa, 																														"
		sql = sql & " t.ds_categoria,  																													"
		sql = sql & " t.id_categoria,  																													"
		sql = sql & " m.id_Movimento,  																													"
		sql = sql & " m.ds_historico,  																													"
		sql = sql & " to_char(m.dt_previsao,'DD/MM/YYYY') dt_previsao, 																					"
		sql = sql & " to_char(m.dt_confirmacao,'DD/MM/YYYY') dt_confirmacao, 																			"
		sql = sql & " m.nr_valor_previsto, 																												"
		sql = sql & " t.tp_movimento 																													"
		If Session("bo_cliente") Then
			sql = sql & ",(select nvl(ds_fantasia,ds_razao_social) from vw_cliente cl, rl_movimento_cliente rmc where cl.id_cliente = rmc.id_cliente and rmc.id_movimento(+) = m.id_movimento ) ds_fantasia "
		End If
		sql = sql & "from tb_Movimento m, tb_caixa c, tb_categoria t 																					"
		sql = sql & "where c.id_caixa = m.id_caixa 																										"
		sql = sql & "  and t.id_categoria = m.id_categoria 																								"
		sql = sql & "  and c.id_empresa = " & session("id_empresa") & " 																				"
		sql = sql & "  and ( 																															"
		sql = sql & " 			to_char(dt_previsao,'MM/YYYY') = '"&sReferencia&"' 																			"
    	sql = sql & "		or 	(dt_confirmacao is null and to_date(to_char(dt_previsao,'MM/YYYY'),'MM/YYYY') < to_date('"&sReferencia&"','MM/YYYY')  and to_date('"&sReferencia&"','MM/YYYY') <= to_date(to_char(sysdate,'MM/YYYY'),'MM/YYYY')  ) 	" 
    	sql = sql & "		or 	to_char(dt_confirmacao,'MM/YYYY') = '"&sReferencia&"' 																	"
    	sql = sql & "	) 																																"
		'sql = sql & "  and m.dt_confirmacao is not null 																								"
		If sIdCaixa <> "" and sIdCaixa <> "0" Then
			sql = sql & "	AND   m.id_caixa = "&sIdCaixa&" "
		End If
	
		If sTipo <> "" Then
			sql = sql & "	AND   t.tp_movimento = '"&sTipo&"' "
		Else
			sql = sql & "	AND   t.tp_movimento = 'D' "
		End If
		
		sql = sql & "  and t.id_categoria = "&sIdCategoria&"																							"
		sql = sql & "order by m.dt_confirmacao desc, m.dt_previsao, t.tp_movimento "
		
		
		Set rs = oOracleDB.execute(sql)
		
		col = ""
		colspan = "8"
        th_fantasia = ""
		ds_fantasia = ""
		
		If Session("bo_cliente") = 1 Then
			colspan = "9"
			col = "<col  />"
			th_fantasia = "<th>Cliente</th>"			
		End If
		
		If Not rs.Eof Then
		
        %>
		<table class="chart">
			<%=col%>
			<col  />			
			<col style="width:130px" />	
			<col style="width:130px" />
			<col style="width:100px" />
			<col style="width:100px" />
			<col style="width:80px" />
			
			<thead>
				<tr>
					<%=th_fantasia%>
					<th><%=server.HTMLEncode("Histórico")%></th>
					<th><%=server.HTMLEncode("Conta")%></th>
                    <th>Categoria</th>
					<th><%=server.HTMLEncode("Previsto para")%></th>
					<th><%=server.HTMLEncode("Confirmado em")%></th>
					<th>Valor</th>
				</tr>
			</thead>
			<tbody>
			<%Do While Not rs.eof%>		
				<%
				classe = ""
				check = ""
				
				If Session("bo_cliente") = 1 Then
					ds_fantasia = "<td>"&Server.HTMLEncode(rs("ds_fantasia")&"")&"</td>"
				End If
				
				IF date() > DateValue(rs("dt_previsao")&"") Then
					classe = "class='atrasado' "
				End If
				
				If Trim(rs("dt_confirmacao")&"") <> "" Then
					classe = "class='confirmado' "
					check = "checked='checked'"
				End If
				%>
				
				<tr>
					
                    <%=ds_fantasia%>
					<td class="flow"><%=server.HTMLEncode(rs("ds_historico"))%></td>
					<td class="flow"><%=server.HTMLEncode(rs("ds_caixa"))%></td>
                    <td class="flow">
					<%If Trim(rs("tp_movimento")&"") = "D" Then%>
							<img src="includes/img/pagar.png" align="absmiddle" style="margin-right:2px;" />
                            <span><%=Server.HTMLEncode("Débito")%></span>
						<%Else%>
							<img src="includes/img/receber.png"  align="absmiddle" style="margin-right:2px;" />
                            <span><%=Server.HTMLEncode("Crédito")%></span>
						<%End If%>
					<%=server.HTMLEncode(rs("ds_categoria"))%>
                    </td>
					<td align="center"><%=rs("dt_previsao")%></td>
					<td align="center"><%=rs("dt_confirmacao")%></td>
					<td align='right' class='positivo'>R$ <%=FormatNumber(rs("nr_valor_previsto"),2)%></td>
				</tr>
			<%
				rs.MoveNext
			Loop
				
			%>
			</tbody>
			
		</table>
		
		<%
		
		End If	
		
	End Sub
	
	Function saldo_anterior(id_caixa,referencia)
		sql = ""
		sql = sql & "select nvl(max(nr_saldo_inicial),0) + nvl(sum(decode(t.tp_movimento,'C', m.nr_valor_previsto,0)) - sum(decode(t.tp_movimento,'D', m.nr_valor_previsto,0)),0) saldo "
		sql = sql & "  from tb_movimento m, tb_categoria t, tb_caixa c 																											 "
		sql = sql & " where c.id_caixa = "&id_caixa&" 																																	 "
		sql = sql & "   and c.id_caixa = m.id_caixa 																															 "
		sql = sql & "   and m.id_categoria = t.id_categoria  																													 "
		sql = sql & "   and dt_confirmacao is not null  																														 "
		sql = sql & "   and to_date(to_char(dt_confirmacao,'mm/yyyy'),'mm/yyyy') < to_date('"&referencia&"','mm/yyyy') 																 "
		Set rsaldo = oOracleDB.execute(sql)
		
		If not rsaldo.Eof Then
			saldo_anterior = rsaldo(0)
		End If
		
	End Function
	
	Sub extrato()

		sql = ""
		sql = sql & "select  m.id_movimento, 																															"
		sql = sql & " m.ds_historico,  																													"
		sql = sql & " decode(to_char(m.dt_confirmacao,'DD/MM/YYYY'),lag(to_char(m.dt_confirmacao,'DD/MM/YYYY'),1,0) over(ORDER BY dt_confirmacao),'',to_char(m.dt_confirmacao,'DD/MM/YYYY')) data, "
		sql = sql & " decode(t.tp_movimento,'C',m.nr_valor_previsto,'') Entrada,																		"
        sql = sql & " decode(t.tp_movimento,'D',m.nr_valor_previsto,'') Saida, 																			"
		sql = sql & " t.tp_movimento 																													"
		If Session("bo_cliente") Then
			sql = sql & ",(select nvl(ds_fantasia,ds_razao_social) from vw_cliente cl, rl_movimento_cliente rmc where cl.id_cliente = rmc.id_cliente and rmc.id_movimento(+) = m.id_movimento ) ds_fantasia "
		End If
		sql = sql & "from tb_Movimento m, tb_caixa c, tb_categoria t 																					"
		sql = sql & "where c.id_caixa = m.id_caixa 																										"
		sql = sql & "  and t.id_categoria = m.id_categoria 																								"
		sql = sql & "  and c.id_empresa = " & session("id_empresa") & " 																				"
		sql = sql & "  and to_char(dt_confirmacao,'MM/YYYY') = '"&sReferencia&"' 																				"
		sql = sql & "  and c.id_caixa = "&sIdCaixa&"																									"
		sql = sql & "  and dt_confirmacao is not null "
		sql = sql & "order by m.dt_confirmacao asc "
		
		'response.write sql
		
		Set rs = oOracleDB.execute(sql)
		
		col = ""
		colspan = "5"
        th_fantasia = ""
		ds_fantasia = ""
		
		If Session("bo_cliente") = 1 Then
			colspan = "6"
			col = "<col  />"
			th_fantasia = "<th>Cliente</th>"			
		End If
		
		If Not rs.Eof Then
		
        %>
		<table class="extra">
			<col style="width:80px" />
			<%=col%>
			<col  />
            <col style="width:20px" />
			<col style="width:80px" />
			<col style="width:80px" />
			
			<thead>
            	<tr>
					<th><%=server.HTMLEncode("Data")%></th>
					<%=th_fantasia%>
					<th><%=server.HTMLEncode("Histórico")%></th>
                    <th></th>
					<th align="right">Entrada</th>
					<th align="right"><%=server.HTMLEncode("Saída")%></th>
				</tr>
            </thead>
			<tbody>
			 	<tr class='relSaldo'>
                	<td colspan="<%=colspan%>" align="right">Saldo:&nbsp;<%=formatnumber(saldo_anterior(sIdCaixa,sReferencia),2)%></td>
                </tr>
            <%
				boPrimeira = true
				saldo = cdbl(saldo_anterior(sIdCaixa,sReferencia))
			%>
			<%Do While Not rs.eof%>		
				<%
				classe = ""
				check = ""
				
				If Session("bo_cliente") = 1 Then
					span = ""
                    If Trim(rs("ds_fantasia")&"") <> "" Then
                        span = "<span>"&Server.HTMLEncode(rs("ds_fantasia")&"")&"</span>"
                    End If
                    ds_fantasia = "<td class='flow'>"&Server.HTMLEncode(rs("ds_fantasia")&"")&""&span&"</td>"
				End If
				
				If Trim(rs("data")&"") <> "" and not boPrimeira Then
				%>
                <tr class='relSaldo'>
                	<td colspan="<%=colspan%>" align="right">Saldo:&nbsp;<%=formatnumber(saldo,2)%></td>
                </tr>
                <%	
				End If
				
				If trim(rs("tp_movimento")&"") = "D"  Then
					saldo = saldo - cdbl(rs("saida"))
				Else
					saldo = saldo + cdbl(rs("entrada"))
				End If
				
				%>
				
				<tr data="[{'id':'<%=rs("id_movimento")%>'}]" oncontextmenu="acioli.context(event,'contextMenu');">
					<td align="center"><%=Trim(rs("data")&"")%></td>
					<%=ds_fantasia%>
					<td style="padding:6px;" class="flow"><%=server.HTMLEncode(rs("ds_historico"))%><span><%=server.HTMLEncode(rs("ds_historico"))%></span></td>
                    <%
						If Trim(rs("tp_movimento")&"") = "C" Then
                            hint = "Receita"
							sclass = "positivo"
						Else
							sclass = "negativo"
                            hint = "Despesa"
						End If
					%>
                    
					<td align="center" class="<%=sclass%>"><%=rs("tp_movimento")%><span><%=hint%></span></td>
                    <td align='right' class='positivo'>
						<%If Trim(rs("entrada")&"") <> "" Then%>
                        R$ <%=FormatNumber(rs("entrada"),2)%>
                        <%End If%>
					</td>
					<td align='right' class='negativo'>
                    	<%If Trim(rs("saida")&"") <> "" Then%>
                        R$ <%=FormatNumber(rs("saida"),2)%>
                        <%End If%>
                     </td>
				</tr>
			<%
				boPrimeira = false
				rs.MoveNext
			Loop
				
			%>
            	<tr class='relSaldo'>
                	<td colspan="<%=colspan%>" align="right">Saldo:&nbsp;<%=formatnumber(saldo,2)%></td>
                </tr>
			</tbody>
			
		</table>
		
		<%
		Else
		%>
			<div class='atencao'><%=Server.HTMLEncode("Não existe nenhuma movimentação no período informado!")%></div>
		<%
		
		End If	
		
	End Sub
	
	Sub visaogeral()
        
		valor_credito_previsto 		= Saldos("C",false)
		valor_credito_confirmado 	= Saldos("C",true)
		'valor_credito_pendente 		= cdbl(valor_credito_previsto) - cdbl(valor_credito_confirmado)
		
		valor_debito_previsto 		= Saldos("D",false)
		valor_debito_confirmado 	= Saldos("D",true)
		'valor_debito_pendente 		= cdbl(valor_debito_previsto) - cdbl(valor_debito_confirmado)

		'valor_saldo_previsto 		= cdbl(valor_credito_previsto) - cdbl(valor_debito_previsto)
		'valor_saldo_confirmado 		= cdbl(valor_credito_confirmado) - cdbl(valor_debito_confirmado)

        %>
        <table class="chart">
			<col />
            <col style="width:100px" />
            <thead>
            	<tr>
                	<th colspan="2"><%=Server.HTMLEncode("Previsto")%></th>
                </tr>
            </thead>
			<tbody>
                <tr>
                    <td class="flow">A receber:</td>
                    <td align='right' class="positivo">R$ <%=formatNumber(valor_credito_previsto,2)%></td>
                </tr>
				<tr>
                    <td class="flow">A pagar:</td>
                    <td align='right' class="negativo">R$ <%=formatNumber(valor_debito_previsto,2)%></td>
                </tr>

            </tbody>
		</table>
		
		<table class="chart">
			<col />
            <col style="width:100px" />
            <thead>
            	<tr>
                	<th colspan="2"><%=Server.HTMLEncode("Confirmado")%></th>
                </tr>
            </thead>
			<tbody>
                <tr>
                    <td class="flow">Recebido:</td>
                    <td align='right' class="positivo">R$ <%=formatNumber(valor_credito_confirmado,2)%></td>
                </tr>
                <tr>
                    <td class="flow">Pago:</td>
                    <td align='right' class="negativo">R$ <%=formatNumber(valor_debito_confirmado,2)%></td>
                </tr>
            </tbody>
		</table>
        <%


    End Sub
%>
<!-- #include file="desconectar.asp" -->
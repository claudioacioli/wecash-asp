<!-- #include file="conectar.asp" -->
<%
	response.Charset = "iso-8859-1"
	
	Dim sIdCategoria,sDsCategoria, sAcao, sTpMovimento, sBoConsiderarRelatorio
	
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
			
	End Select
	
	
	Sub inserir()
		
		sql = ""
		sql = sql & " insert into tb_categoria(id_empresa,id_categoria,ds_categoria,tp_movimento,bo_considerar_relatorio) "
		sql = sql & " values ("&Session("id_empresa")&",sq_categoria.nextval,'"&sDsCategoria&"','"&sTpMovimento&"','"&sBoConsiderarRelatorio&"') "
		oOracleDb.Execute(sql)
		
	End Sub
	
	
	Sub alterar()
	
		If sIdCategoria <> "" Then
			sql = ""
			sql = sql & "update tb_categoria set 							"
			sql = sql & " ds_categoria = '"&sDsCategoria&"' 				"
			If sTpMovimento <> "" then
				sql = sql & ", tp_movimento = '"&sTpMovimento&"' 				"
			End If
            sql = sql & " ,bo_considerar_relatorio = '"&sBoConsiderarRelatorio&"' "
			sql = sql & " where id_empresa = "&Session("id_empresa")&" 		"
			sql = sql & "   and id_categoria = "&sIdCategoria&" 			"
			oOracleDb.Execute(sql)
		End If
		
	End Sub
	
	Sub excluir()
		If sIdCategoria <> "" Then
			sql = ""
			sql = sql & " delete tb_categoria where id_categoria = "&sIdCategoria
			oOracleDb.Execute(sql)
		End If
	End Sub
	
	Sub validar()
		If sDsCategoria = "" Then
			Response.Redirect "../frmAdicionarCategoria.asp"
		End if
	End Sub
	
	Sub retornar(feed)
		Response.Redirect "../frmCategoria.asp?feed="&feed
	End Sub
	
	
	Sub CarregarDados()
		sIdCategoria 	= trim(Request("id_categoria")&"")
		sDsCategoria 	= trim(Request.form("ds_categoria")&"")
		sAcao 	 		= trim(Request("acao")&"")
		sTpMovimento 	= trim(Request("tp_movimento")&"")
        sBoConsiderarRelatorio = trim(Request("bo_considerar_relatorio")&"")
	End Sub
	
	Sub listar()

		sql = ""
		sql = sql & "select c.id_categoria, c.ds_categoria, tp_movimento, (select count(*) from tb_movimento where id_empresa = c.id_empresa and id_categoria = c.id_categoria) nr_movimento "
		sql = sql & "from tb_categoria c  "
		sql = sql & "where c.id_empresa = '" & session("id_empresa") & "' "
		sql = sql & "order by c.ds_categoria "
		set rs = oOracleDB.execute(sql)

		If Not rs.Eof Then
		%>
		<table class="tab_search">
			<col style="width:25px" />
            <col  />
			<col style="width:25px" />
            <col style="width:25px" />
			<thead>
				<tr>
					<th colspan="2"><%=server.HTMLEncode("Descrição")%></th>
					<th colspan="2"></th>
				</tr>
			</thead>
			<tbody>
			<%Do While Not rs.eof%>
				<tr>
                	<td>
						<%If Trim(rs("tp_movimento")&"") = "D" Then%>
							<img src="includes/img/pagar.png" />
                            <span><%=Server.HTMLEncode("Despesa")%></span>
						<%Else%>
							<img src="includes/img/receber.png" />
                            <span><%=Server.HTMLEncode("Receita")%></span>
						<%End If%>
					</td>
					<td class="flow"><%=Server.HTMLEncode(rs("ds_categoria"))%><span><%=Server.HTMLEncode(rs("ds_categoria"))%></span></td>
					<td><a href="frmAdicionarCategoria.asp?id=<%=rs("id_categoria")%>"><img src="includes/img/editar.png" /></a><span>Editar</span></td>
                    <%If cdbl(rs("nr_movimento")) = 0 Then%>
                    	<td><a href="javascript:excluir(<%=rs("id_categoria")%>,'<%=server.HTMLEncode(rs("ds_categoria"))%>');"><img src="includes/img/lixeira.png" /></a><span>Excluir</span></td>
                    <%Else%>
                    	<td><img src="includes/img/lixeiraoff.png" /><span>Esta categoria não pode ser<br />excluída, pois há movimentações<br /> para a mesma.</span></td>
                    <%End If%>
				</tr>
			<%
				rs.MoveNext
			Loop
				
			%>
			</tbody>
			<tfoot>
				<tr>
					<th colspan="3" ></th>
					
				</tr>
			</tfoot>
		</table>
		<%
		Else
		%>
		<div class='atencao'><%=Server.HTMLEncode("Não existe nenhuma categoria informada.")%></div>
		<%
		End If	
		
	End Sub
%>
<!-- #include file="desconectar.asp" -->
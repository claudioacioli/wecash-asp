<!-- #include file="conectar.asp" -->
<%
	response.Charset = "iso-8859-1"
	
	Dim sAcao, sIdCliente, sDsRazao, sDsFantasia, sNrCnpj, sNrIe, sNrCodigo, sIdCategoria
	
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
		
		case "existeCodigo":
		
			existeCodigo()	
		
		case "existeCnpj":
			
			existeCnpj()
			
		case "existeIE":
			
			existeIE()
			
		case "existeRazao":
			
			existeRazao()
			
	End Select
	
	
	Sub inserir()
	
		sql = "select sq_cliente.nextval from dual"
		set rs = oOracleDb.Execute(sql)
		If Not rs.Eof Then
			
			id_cliente = rs(0)
			
			sql = ""
			sql = sql & "insert into tb_cliente (id_empresa, id_cliente, nr_codigo) "
			sql = sql & " values ("&Session("id_empresa")&","&id_cliente&",'"&sNrCodigo&"') "
			oOracleDb.Execute(sql)
			
			sql = ""
			sql = sql & " insert into tb_pessoa_juridica(id_cliente, ds_razao_social, ds_fantasia, nr_cnpj, nr_ie) "
			sql = sql & " values ("&id_cliente&", '"&sDsRazao&"', '"&sDsFantasia&"', '"&sNrCnpj&"', '"&sNrIe&"') "
			oOracleDb.Execute(sql)
		
		End If
		set rs = nothing
		
	End Sub
	
	
	Sub alterar()
	
		If sIdCliente <> "" Then
			
			sql = "update tb_cliente set "
			sql = sql & " nr_codigo = '"&sNrCodigo&"' "
			sql = sql & " where id_empresa = "&Session("id_empresa")&" "
			sql = sql & "   and id_cliente = "&sIdCliente&" "
			oOracleDb.Execute(sql)
			
			sql = ""
			sql = sql & "update tb_pessoa_juridica set "
			sql = sql & " ds_razao_social = '"&sDsRazao&"', "
			sql = sql & " ds_fantasia = '"&sDsFantasia&"', "
			sql = sql & " nr_cnpj = '"&sNrCnpj&"', "
			sql = sql & " nr_ie = '"&sNrIe&"' "
			sql = sql & " where id_cliente = "&sIdCliente&" "

			oOracleDb.Execute(sql)
			
		End If
		
	End Sub
	
	Sub excluir()
		If sIdCliente <> "" Then
			
			sql = ""
			sql = sql & " delete tb_pessoa_juridica where id_cliente = "&sIdCliente
			oOracleDb.Execute(sql)
			
			sql = ""
			sql = sql & " delete tb_cliente where id_cliente = "&sIdCliente
			oOracleDb.Execute(sql)
		End If
	End Sub
	
	Sub existeCodigo()
        sql = "select 1 from tb_cliente where nr_codigo = upper('"&trim(sNrCodigo&"")&"') and id_cliente <> '"&sIdCliente&"' and id_empresa = "&Session("id_empresa")&" "
        'response.Write sql
        set rs = oOracleDB.execute(sql)
        If not rs.eof Then
            response.write "1"
        Else
            response.write "0"
        End If
    End Sub
	
	Sub existeCnpj()
        sNrCnpj	= trim(Request("nr_cnpj")&"")
		sql = "select 1 from tb_pessoa_juridica pj, tb_cliente c where pj.id_cliente = c.id_cliente and nr_cnpj = '"&trim(sNrCnpj&"")&"' and c.id_cliente <> '"&sIdCliente&"' and id_empresa = "&Session("id_empresa")&" "
        'response.Write sql
        set rs = oOracleDB.execute(sql)
        If not rs.eof Then
            response.write "1"
        Else
            response.write "0"
        End If
    End Sub
	
	Sub existeRazao()
        sDsRazao = trim(Request("ds_razao_social")&"")
		sql = "select 1 from tb_pessoa_juridica pj, tb_cliente c where pj.id_cliente = c.id_cliente and upper(ds_razao_social) = upper('"&trim(sDsRazao&"")&"') and c.id_cliente <> '"&sIdCliente&"' and id_empresa = "&Session("id_empresa")&" "
        'response.Write sql
        set rs = oOracleDB.execute(sql)
        If not rs.eof Then
            response.write "1"
        Else
            response.write "0"
        End If
    End Sub
	
	Sub existeIE()
        sNrIe = trim(Request("nr_ie")&"")
		sql = "select 1 from tb_pessoa_juridica pj, tb_cliente c where pj.id_cliente = c.id_cliente and nr_ie = '"&trim(sNrIe&"")&"' and c.id_cliente <> '"&sIdCliente&"' and id_empresa = "&Session("id_empresa")&" "
        'response.Write sql
        set rs = oOracleDB.execute(sql)
        If not rs.eof Then
            response.write "1"
        Else
            response.write "0"
        End If
    End Sub
	
	Sub validar()
	
		If sDsRazao = "" or sDsFantasia = "" or sNrCnpj = "" Then
			Response.Redirect "../frmAdicionarCliente.asp"
		End if
		
	End Sub
	
	Sub retornar(feed)
		Response.Redirect "../frmCliente.asp?feed="&feed
	End Sub
	
	
	Sub CarregarDados()
	
		sIdCliente 		= trim(Request("id_cliente")&"")
		sDsRazao 		= trim(Request.form("ds_razao_social")&"")
		sDsFantasia 	= trim(Request.form("ds_fantasia")&"")
		sNrCnpj			= trim(Request.form("nr_cnpj")&"")
		sNrIe			= trim(Request.form("nr_ie")&"")
		sAcao 	 		= trim(Request("acao")&"")
		sNrCodigo		= trim(Request("nr_codigo")&"")
		sIdCategoria	= trim(Request("id_categoria")&"")
		
	End Sub
	
	Sub listar()

		sql = ""
		sql = sql & "select c.id_cliente,								"
		sql = sql & "		c.ds_razao_social,							"
		sql = sql & "		c.ds_fantasia,								"
		sql = sql & "		c.nr_cnpj,									"
		sql = sql & "		c.nr_ie,									"
		sql = sql & "		c.nr_codigo,								"
		sql = sql & "		(select count(0) from rl_movimento_cliente r where r.id_cliente = c.id_cliente) nr_movimento "
		sql = sql & "  from	vw_cliente c								"
		sql = sql & " where c.id_empresa = "&Session("id_empresa")&" 	"
        sql = sql & " and c.tp_pessoa = 'PJ' "
		
		set rs = oOracleDB.execute(sql)

		If Not rs.Eof Then
		%>
		<table class="tab_search">
        	<%If Session("bo_codigo_cliente") = 1 Then%>
				<col style="width:60px" />
            <%End If%>
            <col style="width:130px" />
            <col  />
            <col  />
			<col style="width:130px" />
			<col style="width:25px" />
            <col style="width:25px" />
            <!--<col style="width:25px" />
            <col style="width:25px" />-->
			<thead>
				<tr>
                	<th>C&oacute;digo</th>
					<th><%=server.HTMLEncode("CNPJ")%></th>
                    <th>Raz&#227;o Social</th>
					<th><%=server.HTMLEncode("Fantasia")%></th>
					<th>Inscri&#231;&#227;o Estadual</th>
                    <!--<th colspan="4"></th>-->
                    <th colspan="2"></th>
				</tr>
			</thead>
			<tbody>
			<%Do While Not rs.eof %>
				<tr>
                	<%If Session("bo_codigo_cliente") = 1 Then%>
                		<td><%=rs("nr_codigo")%></td>
					<%End If%>
                  <td><%=rs("nr_cnpj")%></td>
                    <td class='flow'><%=Server.HTMLEncode(rs("ds_razao_social")&"")%><span><%=Server.HTMLEncode(rs("ds_razao_social")&"")%></span></td>
                    <td class='flow'><%=Server.HTMLEncode(rs("ds_fantasia")&"")%><span><%=Server.HTMLEncode(rs("ds_fantasia")&"")%></span></td>
                    <td><%=rs("nr_ie")%></td>
					<!--<td><a href="#"><img src="includes/img/email.png" /></a>
                    	<span class="info">
							<%=server.HTMLEncode("Endereços")%>:
                            <p><label>Logradouro: Teste</label></p>
                            <p><label>Bairro: Teste</label></p>
                            <p><label>Cep: Teste</label></p>
                            <p><label>Cidade: Teste</label></p>
                            <p><label>Estado: Teste</label></p>
                        </span>
                    </td>
                    <td><a href="#"><img src="includes/img/telephone.png" /></a><span class="info"><%=server.HTMLEncode("Telefones")%>:</span></td>
                    -->
                    <td><a href="frmAdicionarCliente.asp?id=<%=rs("id_cliente")%>"><img src="includes/img/editar.png" /></a><span>Editar</span></td>
                    <%If cdbl(rs("nr_movimento")) = 0 Then%>
                    	<td><a href="javascript:excluir(<%=rs("id_cliente")%>,'<%=server.HTMLEncode(rs("ds_razao_social")&"")%>');"><img src="includes/img/lixeira.png" /></a><span>Excluir</span></td>
                    <%Else%>
                    	<td><img src="includes/img/lixeiraoff.png" /><span><%=Server.HTMLEncode("Este cliente não pode ser")%><br /><%=Server.HTMLEncode("excluído, pois há movimentações")%><br /><%=Server.HTMLEncode(" para o mesmo.")%></span></td>
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
		<div class='atencao'><%="N&#227;o existe nenhum cliente informado."%></div>
		<%
		End If	
		
	End Sub
%>
<!-- #include file="desconectar.asp" -->
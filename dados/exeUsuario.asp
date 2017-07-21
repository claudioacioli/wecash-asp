<!-- #include file="conectar.asp" -->
<%
	response.Charset = "iso-8859-1"
	
	Dim sAcao, sIdUsuario, sDsEmail, sDsSenha, sBoAtivo, sBoAdm, sDsSenhaAtual
	
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
			
		case "senha":
			alterar_senha()
			Response.Redirect "../frmConfUsuario.asp?feed=4"

        case "configurar":
            Configurar()
            Response.Redirect "../frmConfigurar.asp?feed=5"

        case "existeEmail":
            existeEmail()

	End Select
	
	
	Sub inserir()
	
		sql = ""
		sql = sql & " insert into tb_usuario(id_empresa, id_usuario, ds_email, ds_senha, bo_administrador, bo_ativo) "
		sql = sql & " values ("&Session("id_empresa")&",sq_usuario.nextval, '"&sDsEmail&"', '"&sDsSenha&"', '"&sBoAdm&"', '"&sBoAtivo&"') "
		oOracleDb.Execute(sql)
		
	End Sub
	
	
	Sub alterar()
	
		If sIdUsuario <> "" Then
			
			sql = ""
			sql = sql & "update tb_usuario set "
			sql = sql & " ds_email = '"&sDsEmail&"', "
			sql = sql & " ds_senha = '"&sDsSenha&"', "
			sql = sql & " bo_ativo = '"&sBoAtivo&"', "
			sql = sql & " bo_administrador = '"&sBoAdm&"' "
			sql = sql & " where id_empresa = "&Session("id_empresa")&" "
			sql = sql & "   and id_usuario = "&sIdUsuario&" "
			oOracleDb.Execute(sql)
			
		End If
		
	End Sub
	
	Sub alterar_senha()
			
			sql = "select 1 from tb_usuario where ds_email = '"&Session("ds_email")&"' and ds_senha='"&sDsSenhaAtual&"' "
			set rs = oOracleDb.execute(sql)
            If not rs.eof Then
			    sql = ""
			    sql = sql & "update tb_usuario set "
			    sql = sql & " ds_senha = '"&sDsSenha&"' "
			    sql = sql & " where id_empresa = "&Session("id_empresa")&" "
			    sql = sql & "   and id_usuario = "&Session("id_usuario")&" "
			    oOracleDb.Execute(sql)
            Else
                response.Redirect "../frmConfUsuario.asp?msg=Senha atual incorreta"
			End If

	End Sub
	
    Sub Configurar()
        sEmpresa = Trim(Request("ds_empresa")&"")
        sBoCliente = Trim(Request("bo_cliente")&"")
        sql = ""
        sql = sql & " update tb_empresa "
        sql = sql & "    set ds_empresa = '"&sEmpresa&"', "
        sql = sql & "        bo_cliente = '"&sBoCliente&"'"
        sql = sql & " where id_empresa = "&Session("id_empresa")&" "
        oOracleDb.Execute(sql)

        Session("bo_cliente") = cint(sBoCliente)
		Session("ds_empresa") = sEmpresa

    End Sub
	
	Sub excluir()
		If sIdUsuario <> "" Then
			sql = ""
			sql = sql & " delete tb_usuario where id_usuario = "&sIdUsuario
			oOracleDb.Execute(sql)
		End If
	End Sub
	
	Sub validar()
		If sDsEmail = "" or sDsSenha = "" or sBoAtivo = "" or sBoAdm = "" Then
			Response.Redirect "../frmAdicionarUsuario.asp"
		End if
		
	End Sub
	
	Sub retornar(feed)
		Response.Redirect "../frmUsuario.asp?feed="&feed
	End Sub
	
	
	Sub CarregarDados()
	
		sAcao       	= Trim(Request("acao")&"")
        sIdUsuario  	= Trim(Request("id_usuario")&"")
        sDsEmail    	= Trim(Request("ds_email")&"")
        sDsSenha    	= Trim(Request("ds_senha")&"")
        sBoAdm      	= Trim(Request("bo_administrador")&"")
        sBoAtivo    	= Trim(Request("bo_ativo")&"")
		sDsSenhaAtual 	= Trim(Request("ds_senha_atual")&"")
		
	End Sub

    Sub existeEmail()
        sql = "select 1 from tb_usuario where upper(ds_email) = upper('"&trim(sDsEmail&"")&"') and id_usuario <> '"&sIdUsuario&"' "
        'response.Write sql
        set rs = oOracleDB.execute(sql)
        If not rs.eof Then
            response.write "1"
        Else
            response.write "0"
        End If
    End Sub
	
	Sub listar()

		sql = ""
		sql = sql & "select u.id_usuario,								"
		sql = sql & "		u.ds_email,							        "
		sql = sql & "		u.ds_senha,								    "
		sql = sql & "		u.bo_ativo,									"
		sql = sql & "		u.bo_administrador							"
		sql = sql & "  from	tb_usuario u								"
		sql = sql & " where u.id_empresa = "&Session("id_empresa")&" and id_usuario <> "&Session("id_usuario")&"	"
		
		set rs = oOracleDB.execute(sql)

		If Not rs.Eof Then
		%>
		<table class="tab_search">
        	<col  />
            <col style="width:100px" />
            <col style="width:80px" />
			<col style="width:25px" />
            <col style="width:25px" />
			<thead>
				<tr>
                	<th><%=server.HTMLEncode("Email")%></th>
					<th align="center"><%=server.HTMLEncode("Administrador")%></th>
                    <th align="center"><%=server.HTMLEncode("Ativo")%></th>
                    <th colspan="2"></th>
				</tr>
			</thead>
			<tbody>
			<%Do While Not rs.eof %>
				<tr>
                	
                    <td><%=rs("ds_email")%></td>
                    <td align="center">
                        <%If cint(rs("bo_administrador")) = 1 Then %>
                            <img src="includes/img/ok.png" /><span><%=Server.HTMLEncode("Usuário com perfil administrador")%></span>
                        <%Else%>
                            <img src="includes/img/no.png" /><span><%=Server.HTMLEncode("Usuário sem perfil administrador")%></span>
                        <%End If%>
                    </td>
					<td align="center">
                        <%If cint(rs("bo_ativo")) = 1 Then %>
                            <img src="includes/img/ok.png" /><span><%=Server.HTMLEncode("Usuário ativo")%></span>
                        <%Else%>
                            <img src="includes/img/no.png" /><span><%=Server.HTMLEncode("Usuário inativo")%></span>
                        <%End If%>
                    </td>
                    <td><a href="frmAdicionarUsuario.asp?id=<%=rs("id_usuario")%>"><img src="includes/img/editar.png" /></a><span>Editar</span></td>
                    <td><a href="javascript:excluir(<%=rs("id_usuario")%>,'<%=server.HTMLEncode(rs("ds_email"))%>');"><img src="includes/img/lixeira.png" /></a><span>Excluir</span></td>
                    
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
			<div class='atencao'><%=Server.HTMLEncode("Não existe nenhum usuário informado.")%></div>
		<%
		End If	
		
	End Sub
%>
<!-- #include file="desconectar.asp" -->
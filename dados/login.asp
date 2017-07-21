<!-- #include file="conectar.asp" -->
<%

	email = request("email")
	senha = request("senha")
	
	If trim(email&"") = "" Then
		msg = "Campo Email do usuário de preenchimento obrigatório. Favor informe-o."
		Response.Redirect("../Default.asp?msg="&msg)
	End if
	
	If trim(senha&"") = "" Then
		msg = "Campo Senha do usuário de preenchimento obrigatório. Favor informe-o."
		Response.Redirect("../Default.asp?msg="&msg)
	End if	

	email = replace(email,"'","")
	senha = replace(senha,"'","")
	
	sql = ""
	sql = sql & "select u.id_empresa, u.id_usuario, e.bo_cliente, u.bo_administrador, u.bo_ativo, e.ds_empresa, e.bo_importar_cliente	"
	sql = sql & "  from tb_usuario u, tb_empresa e 						"
	sql = sql & " where e.id_empresa = u.id_empresa						"
	sql = sql & "   and upper(ds_email) = upper('"&email&"') 			"
	sql = sql & "   and upper(ds_senha) = upper('"&senha&"') 							"
	
	Set rs = oOracleDB.execute(sql)
	If Not rs.eof Then
		If cint(rs("bo_ativo")) = 1 then
			
            Session("id_empresa") = rs("id_empresa")
			Session("id_usuario") = rs("id_usuario")
			Session("bo_cliente") = cint(rs("bo_cliente"))
			Session("bo_codigo_cliente") = 1
			Session("ds_email") = email
			Session("ds_empresa") = rs("ds_empresa")
			Session("bo_administrador") = cint(rs("bo_administrador"))
			Session("bo_importar_cliente") = cint(rs("bo_importar_cliente"))

            Response.Cookies("email") = email
			Response.Cookies("email").Expires = DateAdd("M", 6, Date)

			Response.Redirect("../frmMovimento.asp")

		Else
			Response.Redirect("../Default.asp?msg=Prezado usuário, seu contato foi desativado pelo administrador.&email="&email)
		End If
	Else
		Response.Redirect("../Default.asp?msg=O nome de Email de usuário ou a Senha inserido está incorreto.&email="&email)
	End If
%>
<!-- #include file="desconectar.asp" -->
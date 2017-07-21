<!-- #include file="includes/web/top.asp" -->
<%

Dim id_usuario, ds_email, acao, bo_adm, bo_ativo, ds_senha

id_usuario = trim(Request("id")&"")
acao = "insert"

If id_usuario <> "" Then

	sql = ""
	sql = sql & "select id_usuario, ds_email, bo_administrador, bo_ativo, ds_senha "
	sql = sql & " from tb_usuario "
	sql = sql & " where id_empresa = '" & session("id_empresa") & "'"
	sql = sql & "  and id_usuario = "&id_usuario&" "
	set rs = oOracleDB.execute(sql)

	ds_email = rs("ds_email")
	bo_adm 	 = cint(rs("bo_administrador"))
	bo_ativo = cint(rs("bo_ativo"))
	ds_senha = rs("ds_senha")
	acao = "update"
Else
    id_usuario = 0
End If

%>			
				<h1 class='usuario'><%=Server.HTMLEncode("Usuários")%></h1>
				<form id="formCategoria" action="dados/exeUsuario.asp" onsubmit="return acioli.validation.submit(this)" method="post">
					<input type="hidden" name="id_usuario" value="<%=id_usuario%>" />
					<input type="hidden" name="acao" value="<%=acao%>" />
					<p>
						<label><span class="red">*</span><%=server.HTMLEncode("E-mail")%>:<input autocomplete="off" placeholder="<%=server.HTMLEncode("teste@gmail.com")%>" datatype="alfanumericaccent" autofocus maxlength="60" value="<%=ds_email%>" type="text" size="80" name="ds_email"  validation="['NULL','MAIL','EXISTS']" msgexists="<%=Server.HTMLEncode("Email já existente na base de dados") %>" url_exists="dados/exeUsuario.asp?acao=existeEmail&id_usuario=<%=id_usuario%>&ds_email=" msgmail="<%=server.HTMLEncode("E-mail informado é inválido! Favor informe um e-mail válido.")%>" msgnull="<%=server.HTMLEncode("Campo E-mail de preenchimento obrigatório. Favor informe-o.")%>" /></label>
					</p>
                    <p>
						<label><span class="red">*</span><%=server.HTMLEncode("Senha")%>:<input autocomplete="off" placeholder="<%=server.HTMLEncode("*********")%>" datatype="alfanumericaccent" maxlength="10" value="<%=ds_senha%>" type="password" size="50" name="ds_senha" id="ds_senha" validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Senha de preenchimento obrigatório. Favor informe-o.")%>" /></label>
					</p>
                     <p>
						<label><span class="red">*</span><%=server.HTMLEncode("Confirmar Senha")%>:<input autocomplete="off" placeholder="<%=server.HTMLEncode("*********")%>" datatype="alfanumericaccent" maxlength="10" value="<%=ds_senha%>" type="password" size="50" validateiddependence="ds_senha" name="ds_senha_confirmar" validation="['NULL','CONFIRM']" msgconfirm="<%=Server.HTMLEncode("Campo Senha não confere com campo Confirmar senha.")%>" msgnull="<%=server.HTMLEncode("Campo Senha de preenchimento obrigatório. Favor informe-o.")%>" /></label>
					</p>
                    <p>
                    	<label><span class="red">*</span><%=server.HTMLEncode("Ativo")%>:</label>
                        <p>
                    	<label><input name="bo_ativo" type="radio" value="1" <%=checked(bo_ativo,1)%> validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Ativo de preenchimento obrigatório. Favor informe-o.")%>" />Sim</label>
                        <label><input name="bo_ativo" type="radio" value="0" <%=checked(bo_ativo,0)%> /><%=Server.HTMLEncode("Não")%></label>
                        </p>
                    </p>
                    <p>
                    	<label><span class="red">*</span><%=server.HTMLEncode("Administrador")%>:</label>
                        <p>
                    	<label><input name="bo_administrador" type="radio" value="1" <%=checked(bo_adm,1)%> validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Administrador de preenchimento obrigatório. Favor informe-o.")%>" />Sim</label>
                        <label><input name="bo_administrador" type="radio" value="0" <%=checked(bo_adm,0)%> /><%=Server.HTMLEncode("Não")%></label>
                        </p>
                    </p>
                    <p>
                        <nav>
                            <button type="submit" id='btnSalvar' class='minimal-indent'><img src="includes/img/salvar.png" />Salvar</button>
                            <button type="button" onclick="document.location.href='frmUsuario.asp';" class='minimal-indent'><img src="includes/img/cancelar.png" />Cancelar</button>
                        </nav>
                    </p>
				</form>
				
<!-- #include file="includes/web/foot.asp" -->
<script>
/*	acioli.id('btnSalvar').onclick=function(){
		var f = acioli.id('formCategoria');
		if(acioli.validation.submit(f)){
			f.submit();
		}
	}
*/
</script>
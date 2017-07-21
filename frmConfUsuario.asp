<!-- #include file="includes/web/top.asp" -->
<%

Dim ds_email, acao

acao = "update"


sql = ""
sql = sql & "select id_usuario, ds_email, bo_administrador, bo_ativo, ds_senha "
sql = sql & " from tb_usuario "
sql = sql & " where id_empresa = '" & session("id_empresa") & "'"
sql = sql & "  and id_usuario = "&session("id_usuario")&" "
set rs = oOracleDB.execute(sql)

ds_email = rs("ds_email")
acao = "senha"


%>			
				<h1 class='usuario'><%=Server.HTMLEncode("Usuário")%></h1>
				<form action="dados/exeUsuario.asp" onsubmit="return acioli.validation.submit(this)" method="post">
					<input type="hidden" name="acao" value="<%=acao%>" />
					<p>
						<label>E-mail:
						<input type="text" readonly value="<%=ds_email%>" size="80" /></label>
					</p>
                    <p>
						<label><span class="red">*</span><%=server.HTMLEncode("Senha atual")%>:<input autocomplete="off" placeholder="<%=server.HTMLEncode("*********")%>" datatype="alfanumericaccent" maxlength="10" value="" type="password" size="50" name="ds_senha_atual" validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Senha atual de preenchimento obrigatório. Favor informe-o.")%>" /></label>
					</p>
                    <p>
						<label><span class="red">*</span><%=server.HTMLEncode("Nova senha")%>:<input autocomplete="off" placeholder="<%=server.HTMLEncode("*********")%>" datatype="alfanumericaccent" maxlength="10" value="" type="password" size="50" name="ds_senha" id="ds_senha" validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Nova senha de preenchimento obrigatório. Favor informe-o.")%>" /></label>
					</p>
                     <p>
						<label><span class="red">*</span><%=server.HTMLEncode("Confirmar nova senha")%>:<input autocomplete="off" placeholder="<%=server.HTMLEncode("*********")%>" datatype="alfanumericaccent" maxlength="10" value="" type="password" size="50" name="ds_senha_confirmar" validateiddependence="ds_senha" validation="['NULL','CONFIRM']" msgconfirm="<%=Server.HTMLEncode("Campo Nova senha não confere com campo Confirmar nova senha.")%>" msgnull="<%=server.HTMLEncode("Campo Confirmar nova senha de preenchimento obrigatório. Favor informe-o.")%>" /></label>
					</p>
                    <p>
                        <nav>
                            <button type="submit" id='btnSalvar' class='minimal-indent'><img src="includes/img/salvar.png" />Salvar</button>
                        </nav>
                    </p>
                    <%If Trim(Request("msg")&"") <> "" Then %>
                    	<div class="atencao"><%=Request("msg")%></div>
                    <%End If%>
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
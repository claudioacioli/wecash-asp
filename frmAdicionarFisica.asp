<!-- #include file="includes/web/top.asp" -->
<%

Dim acao, id_cliente, ds_nome, nr_cpf, nr_codigo

id_cliente = trim(Request("id")&"")
acao = "insert"

If id_cliente <> "" Then

	sql = ""
	sql = sql & "select id_cliente, ds_razao_social, nr_cnpj, nr_codigo"
	sql = sql & " from vw_cliente "
	sql = sql & " where id_empresa = '" & session("id_empresa") & "'"
	sql = sql & "  and id_cliente = "&id_cliente&" "
	set rs = oOracleDB.execute(sql)

	nr_codigo 		= rs("nr_codigo")&""
	nr_cpf 			= rs("nr_cnpj")&""
	ds_nome 		= Server.HTMLEncode(rs("ds_razao_social")&"")
	acao = "update"
Else

	id_cliente = "0"
	
End If

%>			
				<h1 class='cliente'><%=Server.HTMLEncode("Pessoa física")%></h1>
				<form id="formCategoria" action="dados/exePFisica.asp" onsubmit="return acioli.validation.submit(this)" method="post">
					<input type="hidden" name="id_cliente" value="<%=id_cliente%>" />
					<input type="hidden" name="acao" value="<%=acao%>" />
                    <%If Session("bo_codigo_cliente") = 1 Then%>
                        <p>
                            <label><span class="red">*</span><%=server.HTMLEncode("Código")%>:<input placeholder="<%=server.HTMLEncode("001")%>" maxlength="12" datatype="alfanumeric" autofocus value="<%=nr_codigo%>" type="text" size="30" name="nr_codigo"  validation="['NULL','EXISTS']" msgexists="<%=Server.HTMLEncode("O código informado já está cadastrado! Favor informe outro código.") %>" url_exists="dados/exePFisica.asp?acao=existeCodigo&id_cliente=<%=id_cliente%>&nr_codigo=" msgnull="<%=server.HTMLEncode("Campo Código de preenchimento obrigatório. Favor informe-o.")%>" /></label>
                        </p>
                    <%End If%>
                    <p>
						<label><span class="red">*</span><%=server.HTMLEncode("CPF")%>:<input autocomplete="off" placeholder="<%=server.HTMLEncode("000.000.000-00")%>" maxlength="14" datatype="numeric" format="###.###.###-##" value="<%=nr_cpf%>" type="text" size="50" name="nr_cpf"  validation="['NULL','CPF','EXISTS']" msgexists="<%=Server.HTMLEncode("O CPF informado já está cadastrado! Favor informe outro CPF.") %>" url_exists="dados/exePFisica.asp?acao=existeCpf&id_cliente=<%=id_cliente%>&nr_cpf=" msgcpf="<%=server.HTMLEncode("Campo CPF inválido. Favor informe um CPF válido.")%>" msgnull="<%=server.HTMLEncode("Campo CPF de preenchimento obrigatório. Favor informe-o.")%>" /></label>
					</p>
                    <p>
						<label><span class="red">*</span><%=server.HTMLEncode("Nome")%>:<input autocomplete="off" placeholder="<%=server.HTMLEncode("Claudio Acioli")%>" datatype="alfanumericaccent" maxlength="200" value="<%=ds_nome%>" type="text" size="80" name="ds_nome"  validation="['NULL']"  msgnull="<%=server.HTMLEncode("Campo Nome de preenchimento obrigatório. Favor informe-o.")%>" /></label>
					</p>
                    <p>
                        <nav>
                            <button type="submit" id='btnSalvar' class='minimal-indent'><img src="includes/img/salvar.png" />Salvar</button>
                            <button type="button" onclick="document.location.href='frmFisica.asp';" class='minimal-indent'><img src="includes/img/cancelar.png" />Cancelar</button>
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
<!-- #include file="includes/web/top.asp" -->
<%

Dim acao, id_cliente, ds_razao_social, ds_fantasia, nr_cnpj, nr_ie

id_cliente = trim(Request("id")&"")
acao = "insert"

If id_cliente <> "" Then

	sql = ""
	sql = sql & "select id_cliente, ds_razao_social, nr_cnpj, ds_fantasia, nr_ie, nr_codigo"
	sql = sql & " from vw_cliente "
	sql = sql & " where id_empresa = '" & session("id_empresa") & "'"
	sql = sql & "  and id_cliente = "&id_cliente&" "
	set rs = oOracleDB.execute(sql)

	nr_codigo 		= rs("nr_codigo")&""
	nr_cnpj 		= rs("nr_cnpj")&""
	ds_razao_social = Server.HTMLEncode(rs("ds_razao_social")&"")
	ds_fantasia 	= Server.HTMLEncode(rs("ds_fantasia")&"")
	nr_ie			= rs("nr_ie")&""
	id_categoria	= ""
	acao = "update"
Else

	id_cliente = "0"
	
End If

%>			
				<h1 class='cliente'><%=Server.HTMLEncode("Pessoa jurídica")%></h1>
				<form id="formCategoria" action="dados/exeCliente.asp" onsubmit="return acioli.validation.submit(this)" method="post">
					<input type="hidden" name="id_cliente" value="<%=id_cliente%>" />
					<input type="hidden" name="acao" value="<%=acao%>" />
                    <%If Session("bo_codigo_cliente") = 1 Then%>
                        <p>
                            <label><span class="red">*</span><%=server.HTMLEncode("Código")%>:<input placeholder="<%=server.HTMLEncode("001")%>" maxlength="12" datatype="alfanumeric" autofocus value="<%=nr_codigo%>" type="text" size="30" name="nr_codigo"  validation="['NULL','EXISTS']" msgexists="<%=Server.HTMLEncode("O código informado já está cadastrado! Favor informe outro código.") %>" url_exists="dados/exeCliente.asp?acao=existeCodigo&id_cliente=<%=id_cliente%>&nr_codigo=" msgnull="<%=server.HTMLEncode("Campo Código de preenchimento obrigatório. Favor informe-o.")%>" /></label>
                        </p>
                    <%End If%>
                    <p>
						<label><span class="red">*</span><%=server.HTMLEncode("CNPJ")%>:<input autocomplete="off" placeholder="<%=server.HTMLEncode("00.000.000/0000-00")%>" maxlength="18" datatype="numeric" format="##.###.###/####-##" value="<%=nr_cnpj%>" type="text" size="50" name="nr_cnpj"  validation="['NULL','CNPJ','EXISTS']" msgexists="<%=Server.HTMLEncode("O CNPJ informado já está cadastrado! Favor informe outro CNPJ.") %>" url_exists="dados/exeCliente.asp?acao=existeCnpj&id_cliente=<%=id_cliente%>&nr_cnpj=" msgcnpj="<%=server.HTMLEncode("Campo CNPJ inválido. Favor informe um CNPJ válido.")%>" msgnull="<%=server.HTMLEncode("Campo CNPJ de preenchimento obrigatório. Favor informe-o.")%>" /></label>
					</p>
                    <p>
						<label><span class="red">*</span><%=server.HTMLEncode("Razão Social")%>:<input autocomplete="off" placeholder="<%=server.HTMLEncode("Empresa Silva S/A")%>" datatype="alfanumericaccent" maxlength="200" value="<%=ds_razao_social%>" type="text" size="80" name="ds_razao_social"  validation="['NULL','EXISTS']" msgexists="<%=Server.HTMLEncode("A Razão Social informada já está cadastrada! Favor informe outra Razão Social.") %>" url_exists="dados/exeCliente.asp?acao=existeRazao&id_cliente=<%=id_cliente%>&ds_razao_social=" msgnull="<%=server.HTMLEncode("Campo Razão Social de preenchimento obrigatório. Favor informe-o.")%>" /></label>
					</p>
                    <p>
						<label><span class="red">*</span><%=server.HTMLEncode("Nome fantasia")%>:<input autocomplete="off" placeholder="<%=server.HTMLEncode("Silva")%>" datatype="alfanumericaccent" maxlength="200" value="<%=ds_fantasia%>" type="text" size="70" name="ds_fantasia"  validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Nome fantasia de preenchimento obrigatório. Favor informe-o.")%>" /></label>
					</p>
                    <p>
						<label><%=server.HTMLEncode("Inscrição Estadual")%>:<input autocomplete="off" placeholder="<%=server.HTMLEncode("11.111.111/111-11")%>" datatype="numeric" maxlength="17" format="##.###.###/###-##" value="<%=nr_ie%>" type="text" size="50" name="nr_ie" validation="['EXISTS']" msgexists="<%=Server.HTMLEncode("A Inscrição Estadual informada já está cadastrada! Favor informe outra Inscrição Estadual.") %>" url_exists="dados/exeCliente.asp?acao=existeIE&id_cliente=<%=id_cliente%>&nr_ie=" /></label>
					</p>
                    <!--
                    <p>
                    	<label><%=server.HTMLEncode("Categoria Padrão")%>:
                        	<select autofocus name="id_categoria" style="width:300px;">
								<option value=""></option>
                                <%=optCategoria(id_categoria)%>
                        	</select>
                        </label>
                    </p>
                    -->
                    <p>
                        <nav>
                            <button type="submit" id='btnSalvar' class='minimal-indent'><img src="includes/img/salvar.png" />Salvar</button>
                            <button type="button" onclick="document.location.href='frmCliente.asp';" class='minimal-indent'><img src="includes/img/cancelar.png" />Cancelar</button>
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
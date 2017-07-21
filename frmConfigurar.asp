<!-- #include file="includes/web/top.asp" -->
<%

Dim  ds_empresa, acao, bo_cliente

acao = "configurar"


	sql = ""
	sql = sql & "select ds_empresa, bo_cliente "
	sql = sql & " from tb_empresa "
	sql = sql & " where id_empresa = '" & session("id_empresa") & "'"	
	set rs = oOracleDB.execute(sql)

	ds_empresa = Server.HTMLEncode(rs("ds_empresa"))
	bo_cliente = cint(rs("bo_cliente"))
	

%>			
				<h1 class='configurar'><%=Server.HTMLEncode("Configurações")%></h1>
				<form id="formCategoria" action="dados/exeUsuario.asp" onsubmit="return acioli.validation.submit(this)" method="post">
					<input type="hidden" name="acao" value="<%=acao%>" />
					<p>
						<label><span class="red">*</span><%=server.HTMLEncode("Empresa")%>:<input autocomplete="off" placeholder="<%=server.HTMLEncode("Empresa Silva ltda")%>" datatype="alfanumericaccent" autofocus maxlength="100" value="<%=ds_empresa%>" type="text" size="100" name="ds_empresa"  validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Empresa de preenchimento obrigatório. Favor informe-o.")%>" /></label>
					</p>
                    <p>
                    	<label><span class="red">*</span><%=server.HTMLEncode("Prezado cliente, caso o controle de clientes seja habilitado marcando a opção 'Sim' deste campo, o mesmo poderá ser feito via sistema e as movimentações poderão estar ligadas aos clientes. Deseja habilitar?")%>:</label>
                        <p>
                    	<label><input name="bo_cliente" type="radio" value="1" <%=checked(bo_cliente,1)%> validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Cliente de preenchimento obrigatório. Favor informe-o.")%>" />Sim</label>
                        <label><input name="bo_cliente" type="radio" value="0" <%=checked(bo_cliente,0)%> /><%=Server.HTMLEncode("Não")%></label>
                        </p>
                    </p>
                    <p>
                        <nav>
                            <button type="submit" id='btnSalvar' class='minimal-indent'><img src="includes/img/salvar.png" />Salvar</button>
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
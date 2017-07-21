<!-- #include file="includes/web/top.asp" -->
	<h1 class='cliente'>Clientes</h1>
				<form action="dados/exeCliente.asp" onsubmit="return acioli.validation.submit(this)" method="post">
					<input type="hidden" name="acao" value="<%=acao%>" />
					<p>
                    	<label>Exemplo:</label><br />
                        <img src="includes/img/txtcliente.png" style="border:1px solid #ccc;outline:3px solid #e9e9e9;"/>
                    </p>
                    <p>
						<label><span class="red">*</span><%=server.HTMLEncode("Carregar arquivo csv")%>:<input autocomplete="off" placeholder="<%=server.HTMLEncode("cliente.csv")%>" autofocus type="file" style="width:400px;" name="ds_arquivo"  validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Carregar arquivo de preenchimento obrigatorio. Favor informe-o.")%>" /></label>
					</p>
                    <p>
                        <nav>
                            <button type="submit" id='btnSalvar' class='minimal-indent'><img src="includes/img/salvar.png" />Salvar</button>
                            <button type="button" onclick="document.location.href='frmCliente.asp';" class='minimal-indent'><img src="includes/img/voltar.png" />Voltar</button>
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
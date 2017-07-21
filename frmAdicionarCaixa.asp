<!-- #include file="includes/web/top.asp" -->			
<%

Dim id_caixa, ds_caixa, nr_saldo, acao

id_caixa = trim(Request("id")&"")
acao = "insert"
nr_saldo = ""

If id_caixa <> "" Then

	sql = ""
	sql = sql & "select id_caixa, ds_caixa, nr_saldo_inicial, dt_caixa "
	sql = sql & "from tb_caixa "
	sql = sql & "where id_empresa = '" & session("id_empresa") & "'"
	sql = sql & "  and id_caixa = "&id_caixa&" "
	set rs = oOracleDB.execute(sql)

	ds_caixa = Server.HTMLEncode(rs("ds_caixa"))
	nr_saldo = rs("nr_saldo_inicial")
	nr_saldo = FormatNumber(nr_saldo,2)
	acao = "update"
	
End If

%>
	<h1 class='caixa'>Contas</h1>
	<form id="formCaixa" action="dados/exeCaixa.asp" method="post" onsubmit="return acioli.validation.submit(this);">
		<input type="hidden" name="id_caixa" value="<%=id_caixa%>" />
		<input type="hidden" name="acao" value="<%=acao%>" />
		<p>
        	<nav>
				<button type="submit" class='minimal-indent' id='btnSalvar' ><img src="includes/img/salvar.png" />Salvar</button>
                <button type="button" onclick="document.location.href='frmCaixa.asp';" class='minimal-indent'><img src="includes/img/cancelar.png" />Cancelar</button>
			</nav>
        </p>
        <p>
			<label><span class="red">*</span><%=server.HTMLEncode("Descrição")%>:<input autocomplete="off" autofocus maxlength="200" value="<%=ds_caixa%>" type="text" size="80" name="ds_caixa" datatype="alfanumericaccent" placeholder="<%=server.HTMLEncode("Conta bancária, carteira, cartão de refeição, etc.")%>" validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Descrição de preenchimento obrigatório. Favor informe-o.")%>" /></label>
		</p>
		<p>
			<label><span class="red">*</span>Saldo inicial:<input autocomplete="off" maxlength="11" value="<%=nr_saldo%>" type="text" size="30" name="nr_saldo" style='text-align:right;' onblur="//formataValor(this);" onkeydown="Formata(this,8,event,2)" datatype="decimal" validation="['NULL']" placeholder="0,00" msgnull="<%=server.HTMLEncode("Campo Saldo inicial de preenchimento obrigatório. Favor informe-o.")%>" /></label>
		</p>		
    </form>
<!-- #include file="includes/web/foot.asp" -->
<script>
	/*acioli.id('btnSalvar').onclick=function(){
		var f = acioli.id('formCaixa');
		if(acioli.validation.submit(f)){
			f.submit();
		}
	};*/
	var valorToUS=function(valor){
		valor = (valor.toString()).replace(',','.');
		valor = parseFloat(valor);
		return isNaN(valor)?0:valor;
	};
	var valorToBR=function(valor){
		valor = valor.toFixed(2);
		valor = (valor.toString()).replace('.',',');
		return valor;
	};
	var formataValor = function(obj){
		obj.value = valorToBR(valorToUS(obj.value));
	};
</script>
<!-- #include file="includes/web/top.asp" -->
<h1 class='meta'>Meta</h1>
<form id="formMeta" action="#" method="post">
<p>
    <nav>
		<button type="button" id='btnPlanejar' class='minimal-indent' onclick="planejar();"><img src="includes/img/meta.png" />Planejar</button>
		<button type="button" id='btnSalvarNovo' formaction="dados/exeMovimento.asp?new=true" class='minimal-indent'><img src="includes/img/salvar.png" />Salvar</button>
        <button type="button" onclick="document.location.href='frmMovimento.asp?cke=1';" class='minimal-indent'><img src="includes/img/cancelar.png" />Cancelar</button>
	</nav>
</p>
<p>
	<label>
        <span class="red">*</span>Categoria:
        <select name="id_categoria" style="width:300px;"  validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Categoria de preenchimento obrigatório. Favor informe-o.")%>">
			<option value=""></option>
			<%=optCategoria(id_categoria)%>
        </select>
    </label>
</p>
<p>
	<label>
        <span class="red">*</span><%=server.HTMLEncode("Descrição")%>:
        <input autocomplete="off" placeholder="<%=server.HTMLEncode("Comprar um carro!")%>" datatype="alfanumericaccent" autofocus maxlength="200" value="<%=ds_meta%>" type="text" size="80" name="ds_meta"  validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Descrição de preenchimento obrigatório. Favor informe-o.")%>" />
	</label>
</p>
<p>
	<label><span class="red">*</span><%=server.HTMLEncode("Inicio para")%>:<input autocomplete="off" id="dt_previsto" name="dt_inicio" value="<%=dt_inicio%>" maxlength="10" type="text" size="40" validation="['NULL','DATE']" msgdate="<%=server.HTMLEncode("Data inválida! Favor informe uma data válida.")%>" msgnull="<%=server.HTMLEncode("Campo Início para de preenchimento obrigatório. Favor informe-o.")%>" format="##/##/####" datatype="numeric" placeholder="10/10/2012" /></label>
</p>
<p>
	<label><%=server.HTMLEncode("Realizar em")%>:<input autocomplete="off" id="dt_confirmacao" name="dt_confirmacao" value="<%=dt_confirmacao%>" maxlength="10" type="text" size="40" format="##/##/####" validation="['DATE']"  msgdate="<%=server.HTMLEncode("Data inválida! Favor informe uma data válida.")%>" datatype="numeric" placeholder="10/10/2012" /></label>
</p>
<p>
	<label><span class="red">*</span>Valor:<input style='text-align:right;' name="nr_valor" type="text" value="<%=nr_valor%>" size="30" maxlength="11" validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Valor de preenchimento obrigatório. Favor informe-o.")%>" datatype="decimal" placeholder="0,00" onblur="//formataValor(this);" onkeydown="Formata(this,8,event,2)" /></label>
</p>
<p>
	<label><span class="red">*</span>Entrada:<input style='text-align:right;' name="nr_entrada" type="text" value="<%=nr_entrada%>" size="30" maxlength="11" validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Valor de preenchimento obrigatório. Favor informe-o.")%>" datatype="decimal" placeholder="0,00" onblur="//formataValor(this);" onkeydown="Formata(this,8,event,2)" /></label>
</p>
<hr />
<div id="divPlanejar">

</div>
</form>
<!-- #include file="includes/web/foot.asp" -->
<script>
     var valorToUS = function (valor) {
        valor = (valor.toString()).replace(',', '.');
        valor = parseFloat(valor);
        return isNaN(valor) ? 0 : valor;
    };

    var valorToBR = function (valor) {
        valor = valor.toFixed(2);
        valor = (valor.toString()).replace('.', ',');
        return valor;
    };

    var formataValor = function (obj) {
        obj.value = valorToBR(valorToUS(obj.value));
    };

    $(document).ready(function (evt) {
        $("#dt_previsto").datepicker({
            showAnim:"show",
            showOtherMonths: true,
            selectOtherMonths: true,
			showButtonPanel: true
        });
        $("#dt_confirmacao").datepicker({
            showAnim:"show",
            showOtherMonths: true,
            selectOtherMonths: true,
			showButtonPanel: true
        });
        
    });

    var planejar = function(){      
        
        var dados = U.Form.query(U.id("formMeta"));
        alert(dados);    
        acioli.exec.planejar(dados);  
    };

</script>
<!-- #include file="includes/web/top.asp" -->
<h1 class='transferencia'><%=Server.HTMLEncode("Transferência")%></h1>
<form>
	<p>
		<nav>
			<button type="submit" id='btnSalvar' class='minimal-indent'><img src="includes/img/salvar.png" />Salvar</button>
			<button type="button" onclick="document.location.href='frmMovimento.asp?cke=1';" class='minimal-indent'><img src="includes/img/cancelar.png" />Cancelar</button>
		</nav>
	</p>
	<p>
		<p>
			<label><span class="red">*</span>De conta:
				<select <%=autofocusconta%> name="id_caixa" style="width:300px;"  validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Conta de preenchimento obrigatório. Favor informe-o.")%>">
					<option value=""></option>
					<%=optCaixa(id_caixa)%>
				</select>
			</label>
		</p>
		<p>
			<label><span class="red">*</span>Para conta:
				<select <%=autofocusconta%> name="id_caixa" style="width:300px;"  validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Conta de preenchimento obrigatório. Favor informe-o.")%>">
					<option value=""></option>
					<%=optCaixa(id_caixa)%>
				</select>
			</label>
		</p>
		<p>
			<label><span class="red">*</span><%=server.HTMLEncode("Data")%>:<input autocomplete="off" id="dt_confirmacao" name="dt_confirmacao" value="<%=dt_confirmacao%>" maxlength="10" type="text" size="40" format="##/##/####" validation="['DATE']"  msgdate="<%=server.HTMLEncode("Data inválida! Favor informe uma data válida.")%>" datatype="numeric" placeholder="10/10/2012" /></label>
		</p>
		<p>
			<label><span class="red">*</span>Valor:<input style='text-align:right;' name="nr_valor" type="text" value="<%=nr_valor%>" size="30" maxlength="11" validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Valor de preenchimento obrigatório. Favor informe-o.")%>" datatype="decimal" placeholder="0,00" onblur="//formataValor(this);" onkeydown="Formata(this,8,event,2)" /></label>
		</p>
		<p>
			<label><input type="checkbox" />&nbsp;Incluir taxa</label>
		</p>
	</p>
</form>
<!-- #include file="includes/web/foot.asp" -->
<script>
	$(document).ready(function(){
		 $("#dt_confirmacao").datepicker({
            showAnim:"show",
            showOtherMonths: true,
            selectOtherMonths: true,
			showButtonPanel: true
        });
	});
</script>	
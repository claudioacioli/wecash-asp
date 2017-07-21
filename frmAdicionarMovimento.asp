<!-- #include file="includes/web/top.asp" -->
<%

If Session("bo_cliente") = 1 Then
	autofocuscliente = "autofocus='autofocus'"
else
	autofocusconta = "autofocus='autofocus'"
End If

Dim acao, id_movimento, id_categoria, id_caixa, tp_movimento, ds_historico, dt_previsao, dt_confirmacao, nr_valor
acao = "insert"
tp_fixo_variavel = "V"
id_movimento = trim(Request("id")&"")
If id_movimento <> "" Then
	sql = ""
	sql = sql & "select c.id_caixa, t.id_categoria, m.id_Movimento, m.ds_historico, to_char(m.dt_previsao,'DD/MM/YYYY') dt_previsao, to_char(m.dt_confirmacao,'DD/MM/YYYY') dt_confirmacao, m.nr_valor_previsto, t.tp_movimento, rmc.id_cliente, m.tp_fixo_variavel "
	sql = sql & "from tb_Movimento m, tb_caixa c, tb_categoria t, rl_movimento_cliente rmc "
	sql = sql & "where c.id_caixa = m.id_caixa "
	sql = sql & "  and t.id_categoria = m.id_categoria "
	sql = sql & "  and m.id_movimento = rmc.id_movimento(+) "
	sql = sql & "  and c.id_empresa = " & session("id_empresa") & " "
	sql = sql & "  and m.id_movimento = " & id_movimento

	set rs = oOracleDB.execute(sql)
	
	acao = "update"
	id_movimento	= rs("id_movimento") 
	id_categoria	= rs("id_categoria")
	id_caixa		= rs("id_caixa")
	id_cliente		= rs("id_cliente")&""
	tp_movimento	= rs("tp_movimento")
	ds_historico	= Server.HTMLEncode(rs("ds_historico"))
	dt_previsao		= rs("dt_previsao")
	dt_confirmacao	= rs("dt_confirmacao")
	nr_valor		= formatNumber(rs("nr_valor_previsto"),2)
	tp_fixo_variavel = rs("tp_fixo_variavel")
End If
%>
				<h1 class='movimentacao'><%=Server.HTMLEncode("Movimentações")%></h1>
				<form id='formMovimento' action='dados/exeMovimento.asp' method='post' onsubmit="return acioli.validation.submit(this);">
					<input type="hidden" name="acao" value="<%=acao%>" />
					<input type="hidden" name="id_movimento" value="<%=id_movimento%>" />
                    <p>
                    	<nav>
							<button type="submit" id='btnSalvar' class='minimal-indent'><img src="includes/img/salvar.png" />Salvar</button>
							<button type="submit" id='btnSalvarNovo' formaction="dados/exeMovimento.asp?new=true" class='minimal-indent'><img src="includes/img/salvar.png" />Salvar Adicionar</button>
                            <button type="button" onclick="document.location.href='frmMovimento.asp?cke=1';" class='minimal-indent'><img src="includes/img/cancelar.png" />Cancelar</button>
						</nav>
                    </p>
                    <%If Session("bo_cliente") = 1 Then%>
                    <p>
                    	<label>Cliente:
                        	<select <%=autofocuscliente%> name="id_cliente" style="width:400px;">
								<option value=""></option>
								<%=optCliente(id_cliente)%>
                            </select>
                        </label>
                    </p>
					<%End If%>
                    <p>
						<label><span class="red">*</span>Conta:
                        	<select <%=autofocusconta%> name="id_caixa" style="width:300px;"  validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Conta de preenchimento obrigatório. Favor informe-o.")%>">
								<option value=""></option>
								<%=optCaixa(id_caixa)%>
                            </select>
                        </label>
					</p>
					<!--<p>
						<label><span class="red">*</span>Tipo:
                        	<select name="tp_movimento" style="width:300px;">
                            	<option <%'=selected("C",tp_movimento)%> value='C'><%'=server.HTMLEncode("Crédito")%></option>
                                <option <%'=selected("D",tp_movimento)%> value='D'><%'=server.HTMLEncode("Débito")%></option>
                            </select>
                        </label>
					</p>-->
                    <p>
						<label><span class="red">*</span>Categoria:
                        	<select name="id_categoria" style="width:300px;"  validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Categoria de preenchimento obrigatório. Favor informe-o.")%>">
								<option value=""></option>
								<%=optCategoria(id_categoria)%>
                            </select>
                        </label>
					</p>
                    <p>
						<label><span class="red">*</span><%=server.HTMLEncode("Histórico")%>:<input autocomplete="off" id="ds_historico" name="ds_historico" type="text" size="80" value="<%=ds_historico%>" maxlength="200" validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Histórico de preenchimento obrigatório. Favor informe-o.")%>" datatype="alfanumericaccent" placeholder="<%=Server.HTMLEncode("Anuidade cartão de crédito, Pagamento fatura, etc. ")%>" /></label>
					</p>
                    <p>
						<label><span class="red">*</span><%=server.HTMLEncode("Previsto para")%>:<input autocomplete="off" id="dt_previsto" name="dt_previsto" value="<%=dt_previsao%>" maxlength="10" type="text" size="40" validation="['NULL','DATE']" msgdate="<%=server.HTMLEncode("Data inválida! Favor informe uma data válida.")%>" msgnull="<%=server.HTMLEncode("Campo Previsto para de preenchimento obrigatório. Favor informe-o.")%>" format="##/##/####" datatype="numeric" placeholder="10/10/2012" /></label>
					</p>
                    <p>
						<label><%=server.HTMLEncode("Confirmado em")%>:<input autocomplete="off" id="dt_confirmacao" name="dt_confirmacao" value="<%=dt_confirmacao%>" maxlength="10" type="text" size="40" format="##/##/####" validation="['DATE']"  msgdate="<%=server.HTMLEncode("Data inválida! Favor informe uma data válida.")%>" datatype="numeric" placeholder="10/10/2012" /></label>
					</p>
                    <p>
						<label><span class="red">*</span>Valor:<input style='text-align:right;' name="nr_valor" type="text" value="<%=nr_valor%>" size="30" maxlength="11" validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Valor de preenchimento obrigatório. Favor informe-o.")%>" datatype="decimal" placeholder="0,00" onblur="//formataValor(this);" onkeydown="Formata(this,8,event,2)" /></label>
					</p>
					<p>
                    	<label><%=server.HTMLEncode("Esse movimento é")%>:</label>
                        <p>
                    	<label class="renda"><input name="tp_fixo_variavel" type="radio" value="R" <%=checked(tp_fixo_variavel,"R")%> /><%=server.HTMLEncode("Renda")%></label>
						<label class="fixo"><input name="tp_fixo_variavel" type="radio" value="F" <%=checked(tp_fixo_variavel,"F")%> />Fixo</label>
                        <label class="variavel"><input name="tp_fixo_variavel" type="radio" value="V" <%=checked(tp_fixo_variavel,"V")%> /><%=server.HTMLEncode("Variável")%></label>						
                        </p>
                    </p>
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
        $("#ds_historico").autocomplete({
            source: "dados/json.asp",
            autoFocus: true,
            minLength:1,
            delay:300
        })
    });

</script>
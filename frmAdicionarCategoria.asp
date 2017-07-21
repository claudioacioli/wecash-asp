<!-- #include file="includes/web/top.asp" -->
<%

Dim id_categoria, ds_categoria, acao

id_categoria = trim(Request("id")&"")
acao = "insert"

If id_categoria <> "" Then

	sql = ""
	sql = sql & "select id_categoria, ds_categoria, tp_movimento, bo_considerar_relatorio"
	sql = sql & " from tb_categoria "
	sql = sql & " where id_empresa = '" & session("id_empresa") & "'"
	sql = sql & "  and id_categoria = "&id_categoria&" "
	set rs = oOracleDB.execute(sql)
	ds_categoria = server.HTMLEncode(rs("ds_categoria"))
	tp_movimento = trim(rs("tp_movimento")&"")
    bo_considerar_relatorio = trim(rs("bo_considerar_relatorio")&"")
	set rs = nothing
	
	acao = "update"
	
	sql = "select 1 from tb_movimento where id_categoria = "&id_categoria
	set rs = oOracleDB.execute(sql)
	If not rs.eof Then
		read = "disabled='disabled'"
		msg = "<div class='redmsg'>"&Server.HTMLEncode("O Tipo de operação não pode ser alterado, pois há movimentações para esta categoria.")&"</div>"
	End If
	set rs = nothing
Else
	
	id_categoria = "0"
	
End If

%>			
				<h1 class='categoria'>Categorias</h1>
				<form id="formCategoria" action="dados/exeCategoria.asp" onsubmit="return acioli.validation.submit(this)" method="post">
					<input type="hidden" name="id_categoria" value="<%=id_categoria%>" />
					<input type="hidden" name="acao" value="<%=acao%>" />
					<p>
                        <nav>
                            <button type="submit" id='btnSalvar' class='minimal-indent'><img src="includes/img/salvar.png" />Salvar</button>
                            <button type="button" onclick="document.location.href='frmCategoria.asp';" class='minimal-indent'><img src="includes/img/cancelar.png" />Cancelar</button>
                        </nav>
                    </p>
                    <p>
						<label><span class="red">*</span><%=server.HTMLEncode("Descrição")%>:<input autocomplete="off" placeholder="<%=server.HTMLEncode("Habitação, Transporte, Alimentação, etc.")%>" datatype="alfanumericaccent" autofocus maxlength="200" value="<%=ds_categoria%>" type="text" size="80" name="ds_categoria"  validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Descrição de preenchimento obrigatório. Favor informe-o.")%>" /></label>
					</p>
                    <p>
                    	<label><span class="red">*</span><%=server.HTMLEncode("Tipo de operação")%>:</label>
                        <p>
                    	<label><input <%=read%> name="tp_movimento" type="radio" value="C" <%=checked(tp_movimento,"C")%> validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo Tipo de operação de preenchimento obrigatório. Favor informe-o.")%>" />Receita</label>
                        <label><input <%=read%> name="tp_movimento" type="radio" value="D" <%=checked(tp_movimento,"D")%> />Despesa</label>
                        <%=msg%>
                        </p>
                    </p>
                    <p>
                        <label><span class="red">*</span><%=server.HTMLEncode("Considerar categoria nos seus relatórios?")%>:</label>
                        <p>
                    	    <label><input name="bo_considerar_relatorio" type="radio" value="1" <%=checked(bo_considerar_relatorio,"1")%> validation="['NULL']" msgnull="<%=server.HTMLEncode("Opção de considerar no relatório é de preenchimento obrigatório. Favor informe-o.")%>" /><%=server.HTMLEncode("Sim")%></label>
                            <label><input name="bo_considerar_relatorio" type="radio" value="0" <%=checked(bo_considerar_relatorio,"0")%> /><%=server.HTMLEncode("Não")%></label>                            
                        </p>
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
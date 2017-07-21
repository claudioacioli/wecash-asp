<!-- #include file="includes/web/top.asp" -->
<%

id_movimento = Request.QueryString("id")
If id_movimento <> "" Then
	sql = "select ds_historico from tb_movimento where id_movimento = "&id_movimento
	set rs = oOracleDB.execute(sql)
	ds_historico = rs("ds_historico")
	set rs = Nothing
	
	sql = "SELECT ID_ANEXO_MOVIMENTO,ID_MOVIMENTO,NM_ANEXO,NM_PATH,NR_TAMANHO,NM_TIPO FROM TB_ANEXO_MOVIMENTO WHERE ID_MOVIMENTO = "&id_movimento&""
	
	set rs = oOracleDB.execute(sql)
	
	
End If

%>

<h1 class='movimentacao'><%=Server.HTMLEncode("Anexar Documentos")%></h1>
<form action="" method="post">
	<input type="hidden" name="id_movimento" value="<%=Request.QueryString("id")%>" />
	<p>
		<nav>
			<button type="submit" id='btnSalvar' class='minimal-indent'><img src="includes/img/importar.png" />Enviar</button>
            <button type="button" onclick="document.location.href='frmMovimento.asp?cke=1';" class='minimal-indent'><img src="includes/img/voltar.png" />Voltar</button>
		</nav>
	</p>
	<p>
		<label>
			<%=Server.HTMLEncode("Histórico")%>:
			<input type="text" readonly="readonly" style="width:450px;" value="<%=ds_historico%>" />
		</label>
	</p>
	<p>
		<label>
			<span class="red">*</span>
			Documento:
			<input type="file" name="documento" style="width:350px;" />
		</label>
	</p>
	<p>
		<label>
			<span class="red">*</span>
			<%=Server.HTMLEncode("Descrição")%>:
			<input type="text" name="descricao"  />
		</label>
	</p>
</form>
<hr />
<table class="tab_search">
	<thead>
		<tr>
			<th>Anexo</th>
			<th>Tipo</th>
			<th>Tamanho</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Comprovantte de pagamento</td>
			<td>PDF</td>
			<td>54545kb</td>
		</tr>
		<tr>
			<td>Comprovantte de pagamento</td>
			<td>PDF</td>
			<td>54545kb</td>
		</tr>
	</tbody>
</table>
<!-- #include file="includes/web/foot.asp" -->
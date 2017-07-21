 <%
 If Session("bo_cliente") <> 1 Then
 	Response.Redirect("frmCaixa.asp")
 End If
 %>
<!-- #include file="includes/web/top.asp" -->
	<h1 class='cliente'><%=Server.HTMLEncode("Pessoa Física")%></h1>
	<nav>
		<button onclick="document.location.href='frmAdicionarFisica.asp';" class='minimal-indent'><img src="includes/img/add.png" />Adicionar</button>
        <button onclick="atualizar();" class='minimal-indent'><img src="includes/img/atualizar.png" />Atualizar</button>
        <input type="text" autocomplete="off" class="search" placeholder="Filtrar" onKeyUp="apex_search.search(event);" />
	</nav>
	<p id="listarCliente">
	</p>
<!-- #include file="includes/web/foot.asp" -->	
<script>
	window.onload = function(){
		acioli.exec.listarClienteFisico("");
		apex_search.init();
	};
	var excluir = function(id,campo){
		if(confirm('Tem certeza que deseja excluir o cliente '+campo+'?')){
			acioli.doc.location.href = 'dados/exePFisica.asp?acao=delete&id_cliente='+id;
		}
	};
	var atualizar = function(){
		acioli.exec.listarClienteFisico('');
		apex_search.init();
	};
</script>
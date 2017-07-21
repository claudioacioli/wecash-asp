<!-- #include file="includes/web/top.asp" -->
	<h1 class='categoria'>Categorias</h1>
	<nav>
		<button onclick="document.location.href='frmAdicionarCategoria.asp';" class='minimal-indent'><img src="includes/img/add.png" />Adicionar</button>
		<button onclick="atualizar();" class='minimal-indent'><img src="includes/img/atualizar.png" />Atualizar</button>
        <input type="text" autocomplete="off" class="search" placeholder="Filtrar" onKeyUp="apex_search.search(event);" />
	</nav>
	<p id="listarCategoria">
	</p>
<!-- #include file="includes/web/foot.asp" -->	
<script>
	window.onload = function(){
		acioli.exec.listarCategoria("");
		apex_search.init();
	};
	var excluir = function(id,campo){
		if(confirm('Tem certeza que deseja excluir a categoria '+campo+'?')){
			acioli.doc.location.href = 'dados/exeCategoria.asp?acao=delete&id_categoria='+id;
		}
	};
	var atualizar = function(){
		acioli.exec.listarCategoria('');
		apex_search.init();
	};
</script>
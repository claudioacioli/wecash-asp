<!-- #include file="includes/web/top.asp" -->			
	<h1 class='caixa'>Contas</h1>
	<nav>
		<button onclick="document.location.href='frmAdicionarCaixa.asp';" class='minimal-indent'><img src="includes/img/add.png" />Adicionar</button>
		<button onclick="atualizar();" class='minimal-indent'><img src="includes/img/atualizar.png" />Atualizar</button>
        <input type="text" autocomplete="off" class="search" placeholder="Filtrar" onKeyUp="apex_search.search(event);" />
	</nav>
	<p id="listarCaixa">
	
	</p>
<!-- #include file="includes/web/foot.asp" -->	
<script>
	window.onload = function(){
		acioli.exec.listarCaixa("");
		apex_search.init();
	};
	var excluir = function(id,campo){
		if(confirm('Tem certeza que deseja excluir a conta '+campo+'?')){
			acioli.doc.location.href = 'dados/exeCaixa.asp?acao=delete&id_caixa='+id;
		}
	};
	var atualizar = function(){
		acioli.exec.listarCaixa('');
		apex_search.init();
	};
</script>
<!-- #include file="includes/web/top.asp" -->			
	<h1 class='usuario'><%=Server.HTMLEncode("Usuários")%></h1>
	<nav>
		<button onclick="document.location.href='frmAdicionarUsuario.asp';" class='minimal-indent'><img src="includes/img/add.png" />Adicionar</button>
		<button onclick="atualizar();" class='minimal-indent'><img src="includes/img/atualizar.png" />Atualizar</button>
        <input type="text" autocomplete="off" class="search" placeholder="Filtrar" onKeyUp="apex_search.search(event);" />
	</nav>
	<p id="listarUsuario"></p>
<!-- #include file="includes/web/foot.asp" -->
<script>
    window.onload = function () {
        acioli.exec.listarUsuario("");
        apex_search.init();
    };
    var excluir = function (id, campo) {
        if (confirm('Tem certeza que deseja desativar o usuario ' + campo + '?')) {
            acioli.doc.location.href = 'dados/exeUsuario.asp?acao=delete&id_usuario=' + id;
        }
    };
    var atualizar = function () {
        acioli.exec.listarUsuario('');
        apex_search.init();
    };
</script>	
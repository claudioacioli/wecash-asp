<!DOCTYPE HTML>
<html>
	<head>
    	<meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
		<link rel="stylesheet" type="text/css" href="includes/style/index.css" />
        <link rel="stylesheet" type="text/css" href="includes/style/menu.css" />
        <title>Gquip</title>
        <style>
#area{
	
}
        </style>
	</head>
	<body>
        <div id="dBarra">
			<center style="margin-top:10px;margin-bottom:10px;">
            	<button onclick='acioli.exec.saldo("");' class='minimal-indent'><img src="includes/img/atualizar.png" />Atualizar</button>
            </center>
            <h1 class="saldo" style="margin-bottom:1px;">Saldos</h1>
            <p id="divSaldos"></p>
        </div>
        <div id="page">
            <header>
                <a style="background:transparent url(includes/img/header-bg.png) no-repeat top right;" href="frmMovimento.asp"><img src="includes/img/logo.png" align="absmiddle" border="0" /></a>
                <nav id="mconf">
                    <ul  class="horizontal">
                        <li><a href="#"><%=Server.HTMLEncode("Acioli Tecnologia")%></a>
                        	<ul class="submenu1">
                                <li><a href="frmConfigurar.asp"><%=Server.HTMLEncode("Configurações")%></a></li>
                                <li><a href="frmUsuario.asp"><%=Server.HTMLEncode("Usuários")%></a></li>
                            </ul>       
                        </li>
                        <li><a href="#"><%="kllaudyo@gmail.com"%></a>
                            <ul class="submenu1">
                                <li><a href="frmConfUsuario.asp">Mudar Senha</a></li>
                                <li><a href="dados/logout.asp">Sair</a></li>
                            </ul>
                        </li>
                    </ul>
                </nav>
                <nav>
                 	<ul class="menu">
                    	<li>
                            	<a href="#">Movimenta&#231;&#245;es</a>
                                <ul class="submenu">
                                	<li><a href="frmMovimento.asp">Lan&#231;amentos</a></li>
                                    <li><a href="frmExtrato.asp">Extrato por conta</a></li>
                                    <li><a href="frmAnalise.asp"><%=server.HTMLEncode("Análise por categoria")%></a></li>
                                </ul>
                            </li> 
                   	 	<li><a href="frmCaixa.asp">Contas</a></li>
                        <%If Session("bo_cliente") = 1 Then%>
                        	<li><a href="#">Clientes</a>
                            	<ul class="submenu">
                                	<li><a href="frmCliente.asp"><%=server.HTMLEncode("Pessoa jurídica")%></a></li>
                                    <li><a href="frmFisica.asp"><%=server.HTMLEncode("Pessoa física")%></a></li>
                                </ul>
                            </li>
                        <%End If%>
                    	<li><a href="frmCategoria.asp">Categorias</a></li>
                        <li class='designer'></li>
                    	
                   </ul>
                </nav>
            </header>
			<div id="content">
                <h1 class="importar">Receita X Despesa = Saldo</h1>
                <p id="g" style="margin-bottom:10px;"></p>
            </div>
            <!--
            <div id="content">
                <h1 class="importar">Importar lancamentos</h1>
                <nav style="margin-bottom:10px;">
                <button onclick="atualizar();" class='minimal-indent'><img src="includes/img/atualizar.png" />Atualizar</button>
                <select style="margin-left:10px;display:inline;"><option>Novembro</option></select>
                </nav>
                <div id="gr1" style="display:inline;"></div>
                <div id="gr2" style="display:inline;"></div>
            </div>-->            
		</div>
        <footer>
        	<div id="foot">
            	Copyright &copy; 2012 Wecash. Todos os direitos reservados.
            </div>
            
        </footer>
	</body>
</html>

<script src="includes/script/library/ajax.class.js"></script>
<script src="includes/script/library/validation.class.js"></script>
<script src="includes/script/library/format.class.js"></script>
<script src="includes/script/library/datatypes.class.js"></script>
<script src="includes/script/library/json.js"></script>
<script src="includes/script/library/swfobject.js"></script>
<script src="includes/script/acioli.class.js"></script>
<script>
    window.onload = function () {
        swfobject.embedSWF("includes/script/open-flash-chart.swf", "g", "100%", "320", "8.0.0", "", { wmode: "opaque" });
        //swfobject.embedSWF("includes/script/open-flash-chart.swf", "gr1", "48%", "320", "8.0.0", "", { "data-file": "pie1.txt" });
        //swfobject.embedSWF("includes/script/open-flash-chart.swf", "gr2", "48%", "320", "8.0.0", "", { "data-file": "pie1.txt" });
    };
    function open_flash_chart_data() {
        var a = new ajax();
		var js = acioli.trim(a.exec("dados/exeBalanco.asp", "ano=2012" ,"POST",false,a.RETURN_TEXT));
        return js;
    };
</script>
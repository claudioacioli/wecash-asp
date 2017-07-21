<!-- #include file="../../dados/conectar.asp" -->
<!-- #include file="../../dados/funcoes.asp" -->
<%
Session.Timeout = 120
response.Charset = "iso-8859-1"

If trim(Session("id_empresa")&"") = "" Then
	response.Redirect("Default.asp")
End If

Dim sql,BoMovimento
sql = ""
sql = sql & "select count(*) "
sql = sql & "from tb_caixa "
sql = sql & "where id_empresa = '" & session("id_empresa") & "'"
sql = sql & ""
Set rs = oOracleDB.execute(sql)

BoMovimento = false
If not cdbl(rs(0)) = 0 Then
	BoMovimento = true
End If
Set rs = Nothing

sql = ""
sql = sql & "select count(*) "
sql = sql & "from tb_categoria "
sql = sql & "where id_empresa = '" & session("id_empresa") & "'"
sql = sql & ""

Set rs = oOracleDB.execute(sql)
If cdbl(rs(0)) = 0 Then
	BoMovimento = false
End If
Set rs = Nothing

If instr(ucase(request.servervariables("url")&""),ucase("frmMovimento.asp")) > 0 and not BoMovimento then
	response.Redirect "frmCaixa.asp"
End If

%>
<!DOCTYPE HTML>
<html>
	<head>
    	<meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
		<link rel="stylesheet" type="text/css" href="includes/library/bootstrap/css/bootstrap.min.css" />
		<link rel="stylesheet" type="text/css" href="includes/library/jquery/jquery-ui/css/smoothness/jquery-ui-1.10.4.custom.min.css" />
		<link rel="stylesheet" type="text/css" href="includes/style/index.css" />
        <link rel="stylesheet" type="text/css" href="includes/style/menu.css" />
        <title>WeCa$h</title>
	</head>
	<body>
    <!--
    	<div id="top">
      		
        </div>
	-->
        <%
        sFeed = Trim(Request("feed")&"")
        if sFeed <> "" Then 
            Select Case sFeed
                Case "1"
                    sMsgFeed = Server.HTMLEncode("Inclusão realizada com sucesso!")
                Case "2"
                    sMsgFeed = Server.HTMLEncode("Alteração realizada com sucesso!")
                Case "3"
                    sMsgFeed = Server.HTMLEncode("Exclusão realizada com sucesso!")
                Case "4"
                    sMsgFeed = Server.HTMLEncode("Senha alterada com sucesso!")
                Case "5"
                    sMsgFeed = Server.HTMLEncode("Configuração alterada com sucesso!")
            End Select
        %>
            <div id="feedback"><%=sMsgFeed%></div>
            <script>
                window.setTimeout(function () { acioli.id('feedback').style.visibility='hidden' },3000)
            </script>
        <%End If%>
		<div id="dBarra">
        	<h1><%=nomeDia(weekday(date()))%>, <%=AddZero(day(Date()))%> de <%=nomeMes(month(date()))%> de <%=year(date())%></h1>
			<!--<center style="margin-top:10px;margin-bottom:10px;">
            	<button onclick='acioli.exec.saldo("");' class='minimal-indent'><img src="includes/img/atualizar.png" />Atualizar</button>
            </center>-->
            <!--<h1 class="saldo" style="margin-bottom:1px;">Saldos</h1>-->
           
            <p id="divSaldos"></p>
		</div>
		<!--
		<div class="navbar navbar-default navbar-fixed-top">
				<div class="container">
					<div class="navbar-header">
						<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#barra">
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
						</button>
						<a class="navbar-brand" href="#">WeCa$h</a>
					</div>
					<div class="collapse navbar-collapse" id="barra">
						<ul class="nav navbar-nav">
							<li class="active"><a href="#">Movimenta&#231</a></li>
							<li><a href="#">Contas</a></li>
							<li><a href="#">Categorias</a></li>
							<li><a href="#">Consultas</a></li>
						</ul>
					</div>
				</div>
			</div>	-->	
		<div id="page">
		
			
		
            <header>
                <a style="background:transparent url(includes/img/header-bg.png) no-repeat top right;" href="frmMovimento.asp"><img src="includes/img/logo.png" align="absmiddle" border="0" /></a>
                <!--<div style="position:absolute;top:25px;left:160px;"><%=nomeDia(weekday(date()))%>, <%=AddZero(day(Date()))%> de <%=nomeMes(month(date()))%> de <%=year(date())%></div>-->
                <nav id="mconf">
                    <ul  class="horizontal">
                        <li><a href="#"><%=Server.HTMLEncode(Session("ds_empresa"))%></a>
                        	<%If Session("bo_administrador") = 1 Then%>
                                <ul class="submenu1">
                                    <li><a href="frmConfigurar.asp"><%=Server.HTMLEncode("Configurações")%></a></li>
                                    <li><a href="frmUsuario.asp"><%=Server.HTMLEncode("Usuários")%></a></li>
                                </ul>       
                            <%End If%>
                        </li>
                        <li><a href="#"><%=Session("ds_email")%></a>
                            <ul class="submenu1">
                                <li><a href="frmConfUsuario.asp">Mudar Senha</a></li>
                                <li><a href="dados/logout.asp">Sair</a></li>
                            </ul>
                        </li>
                    </ul>
                </nav>
                <nav>
                 	<ul class="menu">
                    	<%If BoMovimento Then%>
                    		<li>
                            	<a href="frmMovimento.asp">Movimenta&#231;&#245;es</a>
                            </li> 
                   	 	<%End If%>
                    	<li><a href="frmCaixa.asp">Contas</a></li>
                        <%If Session("bo_cliente") = 1 Then%>
                        	<li><a href="#">Clientes</a>
                            	<ul class="submenu">
                                	<li><a href="frmCliente.asp"><%=server.HTMLEncode("Pessoa Jurídica")%></a></li>
                                    <li><a href="frmFisica.asp"><%=server.HTMLEncode("Pessoa Física")%></a></li>
                                </ul>
                            </li>
                        <%End If%>
                    	<li><a href="frmCategoria.asp">Categorias</a></li>
                        <li><a href="#"><%=Server.HTMLEncode("Relatórios")%></a>
                            <ul class="submenu">
                                <li><a href="frmExtrato.asp"><%=server.HTMLEncode("Conciliação Bancária")%></a></li>
                                <li><a href="frmConsultaPorCategoria.asp"><%=server.HTMLEncode("Consulta por categoria")%></a></li>
								<li><a href="frmFixoVariavel.asp"><%=server.HTMLEncode("Fixo X Variável")%></a></li>
								<li><a href="frmAnalise.asp"><%=server.HTMLEncode("Análise por categoria")%></a></li>                                
                                <li><a href="frmResumo.asp"><%=server.HTMLEncode("Balanço Anual")%></a></li>
								<li><a href="javascript:void(0);" onclick="window.open('relatorios/frmPrevisaoAnualGastos.asp','','');"><%=server.HTMLEncode("Acompanhamento Anual")%></a></li>
                            </ul>
                        </li>
                        <li class='designer'></li>
                    	<!--<li>
                            <a href="dados/logout.asp">Sair</a>
                            <ul class="submenu">
                                <li><a href="#">Configura&#231;&#245;es</a></li>
                                <%If Session("bo_administrador") = 1 Then%>
                                	<li><a href="frmUsuario.asp"><%=Server.HTMLEncode("Usuários")%></a></li>
                                <%End If%>
                                <li><a href="dados/logout.asp">Sair</a></li>
                            </ul>
                        </li>-->
                   </ul>
                </nav>
            </header>
			<div id="content">

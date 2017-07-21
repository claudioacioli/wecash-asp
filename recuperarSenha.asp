<!DOCTYPE HTML>
<html>
    <head>
        <meta charset="utf-8">
        <title>WeCash</title>
        <link rel="stylesheet" type="text/css" href="includes/style/index.css" />
    </head>
    <body style="margin:0px;">
    	<div id="page" style="margin-top:5px;">
			<a href="Default.asp"><img src="includes/img/logo.png" align="absmiddle" style="border:none" /></a>
            <div id="content">
            	<h1 class="redefinir">Identifique sua conta</h1>
            	<form id="formAcesso" method="post" action="dados/recuperarSenha.asp">
                    <div class="msg">Antes de redefinirmos sua senha, precisamos inserir as informações abaixo para ajudar a identificar sua conta.</div>
                    <p>
                        <label><span style="display:inline-block;width:250px;text-align:right;padding-right:3px;">Insira seu e-mail de usuário:</span>
                            <input type="email" autocomplete="off" autofocus name="email" datatype="alfanumericaccent" validation="['NULL','MAIL']" msgmail="E-mail informado é inválido! Favor informe um e-mail válido." msgnull="Campo Email do usuário é de preenchimento obrigatório. Favor informe-o." style="width:350px;display:inline;" maxlength="60" />
                        </label>
					</p>
                    <p>
                        <label><span style="display:inline-block;width:250px;text-align:right;padding-right:3px;">Insira seu CPF:</span>
                            <input type="text" autocomplete="off" name="cpf" datatype="numeric" validation="['NULL']" msgnull="Campo CPF é de preenchimento obrigatório. Favor informe-o." style="width:150px;display:inline;" maxlength="14" format="###.###.###-##" />
                        </label>
					</p>
                    <p>
                    	<button type="submit" id='btnSalvar' class='minimal-indent' style="margin-left:255px;"><img src="includes/img/cadeado.png" />Redefinir</button>
                        <button type="button" onclick="document.location.href='Default.asp';" class='minimal-indent'><img src="includes/img/voltar.png" />Voltar</button>
                    </p>
                    <%If Trim(Request("msg")&"") <> "" Then %>
                    	<div class="atencao"><%=Request("msg")%></div>
                    <%End If%>
                </form>
<!-- #include file="includes/web/foot.asp" -->
<script>
    acioli.id('formAcesso').onsubmit = function () {
        return acioli.validation.submit(this);
    };
</script>
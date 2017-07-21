<%
    
  sEmail = Trim(Request.Cookies("email")&"")
  If Trim(Request("email")&"") <> "" Then
    sEmail = Trim(Request("email")&"")
  End If

%>
<!DOCTYPE HTML>
<html>
    <head>
        <meta charset="utf-8">
        <title>WeCash</title>
        <link rel="stylesheet" type="text/css" href="includes/style/index.css" />
    </head>
    <body style="margin:0px;">
    	<div id="page" style="margin-top:5px;">
			<img src="includes/img/logo.png" align="absmiddle" />
            <div id="content">
            	<h1 class="acessar">Acessar Sistema</h1>
            	<form id="formAcesso" method="post" action="dados/login.asp">
                	<p>
                        <label><span style="display:inline-block;width:250px;text-align:right;padding-right:3px;">Email do usuário:</span>
                            <input tabindex="1" type="email" autocomplete="off" id="email" name="email" datatype="alfanumericaccent" validation="['NULL','MAIL']" msgmail="E-mail informado é inválido! Favor informe um e-mail válido." msgnull="Campo Email do usuário é de preenchimento obrigatório. Favor informe-o." style="width:350px;display:inline;" maxlength="60" value="<%=sEmail%>" />
                        </label>
					</p>
                    <p>
                        <label><span style="display:inline-block;width:250px;text-align:right;padding-right:3px;">Senha:</span>
                            <input tabindex="2" type="password"  autocomplete="off" id="senha" name="senha" style="width:100px;display:inline;" validation="['NULL']" msgnull="Campo Senha é de preenchimento obrigatório. Favor informe-o." maxlength="20" />
                        </label>
					</p>
                    <p>
                        <a tabindex="4" style="margin-left:255px;" href="recuperarSenha.asp">Esqueceu sua senha?</a>
                    </p>
                    <p>
                    	<button tabindex="3" type="submit" id='btnSalvar' class='minimal-indent' style="margin-left:255px;"><img src="includes/img/cadeado.png" />Acessar</button>
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
    $(document).ready(function (evt) {

        if ($("#email").val().length == 0) {
            $("#email").focus();
        } else {
            $("#senha").focus();
        };

    });
</script>
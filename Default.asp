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
        <link rel="stylesheet" type="text/css" href="includes/style/main.css" />
    </head>
    <body style="margin:0px;">
    	<div class="container">
			<img src="includes/img/logo.png" align="absmiddle" />
            <div  class="box">
            	<h1 >Acessar Sistema</h1>
            	<form id="formAcesso" method="post" action="dados/login.asp">
                	<p>
                        <label class="form-label" for="email">Email do usuário:</label>
                        <input class="form-input" tabindex="1" type="email" autocomplete="off" id="email" name="email" datatype="alfanumericaccent" validation="['NULL','MAIL']" msgmail="E-mail informado é inválido! Favor informe um e-mail válido." msgnull="Campo Email do usuário é de preenchimento obrigatório. Favor informe-o." maxlength="60" value="<%=sEmail%>" />
					</p>
                    <p>
                        <label class="form-label">Senha:</label>
                        <input tabindex="2" type="password"  autocomplete="off" id="senha" name="senha" class="form-input" validation="['NULL']" msgnull="Campo Senha é de preenchimento obrigatório. Favor informe-o." maxlength="20" />
					</p>
                    <p>
                    	<button tabindex="3" type="submit" id='btnSalvar' class="form-button-md form-button-primary">Acessar</button>
                    </p>
                    <p>
                        <a tabindex="4"  href="recuperarSenha.asp">Esqueceu sua senha?</a>
                    </p>
                    <%If Trim(Request("msg")&"") <> "" Then %>
                    	<div class="atencao"><%=Request("msg")%></div>
                    <%End If%>
                </form>
<!-- #include file="includes/web/foot.asp" -->
<script>
(function(){

    const
        emailElement = document.querySelector("#email"),
        passElement = document.querySelector("#senha"),
        formElement = document.querySelector("#formAcesso"),
        onSubmit = e => {
            if(!acioli.validation.submit(e.target))
                e.preventDefault();
        },
        renderFocus = () => {
            passElement.focus();
            if(!emailElement.value.toString().length)
                emailElement.focus();
        }
    ;
    document.addEventListener("DOMContentLoaded", () => {
        //Events
        formElement.addEventListener("submit", onSubmit);
        //Renders
        renderFocus();
    });
})();
</script>
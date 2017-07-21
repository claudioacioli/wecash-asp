<!-- #include file="includes/web/top.asp" -->
<h1 class='importar'><%=Server.HTMLEncode("Importar movimentações dos meses anteriores")%></h1>
<form method="post">
    <p>
        <label><%=server.HTMLEncode("Ano")%>:
            <select id="ano" style="width:100px;">
			    <%=optAno("")%>
		    </select>
        </label>
    </p>
    <p>
        <label><%=server.HTMLEncode("Mes")%>:
            <select id="mes" style="width:130px;">
		        <%=optMes("")%>
		    </select>
        </label>
    </p>
    <p>
        <label><%=server.HTMLEncode("Movimentações")%>:</label>
    </p>
</form>
<!-- #include file="includes/web/foot.asp" -->
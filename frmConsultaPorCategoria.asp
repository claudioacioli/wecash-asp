<!-- #include file="includes/web/top.asp" -->	
	<h1 class='extrato'><%=Server.HTMLEncode("Consulta por Categoria")%></h1>
	<nav style="margin-bottom:20px;">
		<button id="bAtualizar" class='minimal-indent'><img src="includes/img/atualizar.png" />Atualizar</button>
		<select id="mes" class="rel-mes">
			<%=optMes("")%>
		</select>
		<select id="ano" class="rel-ano">
			<%=optAno("")%>
		</select>
		<select id="tipo" class="rel-tipo">
			<option value='D'><%=Server.HTMLEncode("Débito")%></option>
			<option value='C'><%=Server.HTMLEncode("Crédito")%></option>
		</select>
	</nav>
	<p id="body"></p>
<!-- #include file="includes/web/foot.asp" -->
<script>
var WC = {

	ano : function(){
		return (new Date()).getFullYear();
	},

	mes : function(){
		var mes = (new Date()).getMonth() + 1;
		if(mes<10){
			return '0' + mes;
		};
		return mes;
	},

	refresh : function(){
		$.get(
			"dados/exeConsultaCategoria.asp",
			{
				"mes" : $("#mes").val(),
				"ano" : $("#ano").val(),
				"tipo" : $("#tipo").val()
			},
			function(data){
				$("#body").html(data);
			}
		);
		
	},

	selected : function(obj, option){
		$(obj).val(option);
	},
	
};

$(document).ready(function(evt){

	WC.selected($("#mes"), WC.mes());
	WC.selected($("#ano"), WC.ano());

	WC.refresh();

	$("#mes").on("change",function(evt){
		WC.refresh();
	});

	$("#ano").on("change",function(evt){
		WC.refresh();
	});

	$("#tipo").on("change",function(evt){
		WC.refresh();
	});

	$("#bAtualizar").on("change",function(evt){
		WC.refresh();
	});

})

</script>
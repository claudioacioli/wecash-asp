<!-- #include file="includes/web/top.asp" -->			
	<h1 class='movimentacao'><%=Server.HTMLEncode("Movimentações")%></h1>
    <nav>
		<button onclick="document.location.href='frmAdicionarMovimento.asp';" class='minimal-indent'><img src="includes/img/add.png" />Adicionar</button>
		<!--<button onclick="document.location.href='frmOFX.asp';" class='minimal-indent'><img src="includes/img/importar.png" />Importar</button>
        <button onclick="document.location.href='frmImportar.asp';" class='minimal-indent'><img src="includes/img/importar.png" />Importar</button>-->
        <button onclick="mesAno();" class='minimal-indent'><img src="includes/img/atualizar.png" />Atualizar</button>
		 <select onchange="mesAno();" id="mes" style="width:130px;display:none;margin-left:10px;">
			<%=optMes("")%>
		 </select>
		 <select  onchange="mesAno();" id="ano" style="width:100px;display:inline;margin-left:10px;">
			<%=optAno("")%>
		 </select>
         <input type="text" id="txtfiltro" autocomplete="off" class="search" placeholder="Filtrar" onblur="filtrovoltar(this.value)" onKeyUp="apex_search.search(event);" />
	</nav>

    <br />
    <ul class="nav nav-tabs">
        <li id="01"><a href="#" data-mes="01">Janeiro</a></li>
        <li id="02"><a href="#" data-mes="02">Fevereiro</a></li>
        <li id="03"><a href="#" data-mes="03">Marco</a></li>
        <li id="04"><a href="#" data-mes="04">Abril</a></li>
        <li id="05"><a href="#" data-mes="05">Maio</a></li>
		<li id="06"><a href="#" data-mes="06">Junho</a></li>
        <li id="07"><a href="#" data-mes="07">Julho</a></li>
        <li id="08"><a href="#" data-mes="08">Agosto</a></li>
        <li id="09"><a href="#" data-mes="09">Setembro</a></li>
        <li id="10"><a href="#" data-mes="10">Outubro</a></li>
        <li id="11"><a href="#" data-mes="11">Novembro</a></li>
        <li id="12"><a href="#" data-mes="12">Dezembro</a></li>
    </ul>

    <p id="listarMovimento">
	</p>
<!-- #include file="includes/web/foot.asp" -->
<%
tdConfirmado = 6
If Session("bo_cliente") = 1 Then
	tdConfirmado = 7
End If
%>
<script>
	window.onload=function(){
		<%If Request("cke") = "1" Then%>
			var mes = acioli.getCookie("mes");
			var ano = acioli.getCookie("ano");
            var filtro = "";
            if(acioli.getCookie("filtro")!=undefined){
			    var filtro = acioli.getCookie("filtro");
            };
		<%Else%>
			var data = new Date();
			var mes = trataMes(data.getMonth());
			var ano = data.getFullYear();		
			var filtro = "";
		<%End If%>
		
		var oMes = acioli.id('mes');
		var oAno = acioli.id('ano');
		
		checkSelect(oMes,mes);
		checkSelect(oAno,ano);
		acioli.id('txtfiltro').value = filtro;
		
		acioli.setCookie("mes",mes,1);
		acioli.setCookie("ano",ano,1);
		
		$("#"+mes+" a").tab("show");
		
		$(".nav-tabs a").click(function(evt){
			evt.preventDefault();
			var ano = $("#ano").val();
			acioli.exec.listarMovimento("referencia="+$(this).data("mes")+"/"+ano);
			apex_search.init();

			$(this).tab("show");
			acioli.setCookie("mes",$(this).data("mes"),1);
		});
		
		acioli.exec.listarMovimento("referencia="+mes+"/"+ano);
		apex_search.init();
		acioli.id('txtfiltro').onkeyup();		
		
	};
	var excluir = function(id,msg){
		if(confirm(msg)){
			acioli.doc.location.href = 'dados/exeMovimento.asp?acao=delete&id_movimento='+id;
		}
	}
	var confirmar = function(obj){
		
		var tr = obj.parentNode.parentNode;
		//<%=tdConfirmado%>
		var trData = tr.cells[2];
		bConfirmado = 'N';
		tr.className = '';
		if(obj.checked){
			bConfirmado = 'S';
			tr.className = 'confirmado';
		};
		
		trData.innerHTML = acioli.exec.confirmar("id_Movimento="+obj.value+"&confirmado="+bConfirmado);
		acioli.exec.saldo("");
		var sRef = acioli.id("mes").value + "/" + acioli.id("ano").value;
		acioli.exec.resumo("referencia="+sRef);
		
		$.get("dados/exeResumoCategoria.asp").done(function(data){
			eval(data);
		});
		
	};
	
	var mesAno = function(){
		var mes = acioli.id('mes').value;
		var ano = acioli.id('ano').value;
		acioli.setCookie("mes",mes,1);
		acioli.setCookie("ano",ano,1);
		acioli.exec.listarMovimento("referencia="+mes+"/"+ano);
		apex_search.init();
	}
	
	var trataMes = function(mes){
		mes = mes + 1;
		if(mes<10){
			return '0'+mes;
		}
		return mes;
	}
	
	var checkSelect = function(sel,valor){
		for(var i=0; i < sel.options.length; i++){
			if(	sel.options[i].value == valor){
				sel.options[i].selected=true;
				break;
			}
		}	
	}
	
	var filtrovoltar = function(valor){
		acioli.setCookie("filtro",valor,1);	
	}
	
</script>
<!-- #include file="includes/web/top.asp" -->	
	<h1 class='extrato'><%=Server.HTMLEncode("Conciliação Bancária")%></h1>
    <nav  style="margin-bottom:20px;">
		<button onclick="mesAno();" class='minimal-indent'><img src="includes/img/atualizar.png" />Atualizar</button>
		<select id="id_caixa" onchange="mesAno();" style="width:150px;display:inline;margin-left:10px;">
			<%=optCaixa("")%>
		</select>		
        <select onchange="mesAno();" id="mes" style="width:130px;display:inline;margin-left:10px;">
			<%=optMes("")%>
		</select>
		<select  onchange="mesAno();" id="ano" style="width:100px;display:inline;margin-left:10px;">
			<%=optAno("")%>
		</select>
	</nav>
    <p id="gExtrato" ></p>
    <p id="listarMovimento" oncontextmenu="acioli.disableRightMenu(event);">
	</p>
    <div id="contextMenu">
    	<ul>
        	<li><a href="javascript:void(0);">Editar</a></li>
            <li><a href="javascript:void(0);">Excluir</a></li>
        </ul>
    </div>
<!-- #include file="includes/web/foot.asp" -->
<script>
	var id_gextrato = "gExtrato";
	var url_GExtrato = "dados/exeGExtrato.asp";
	window.onload=function(){
		
		var data = new Date();
		var mes = trataMes(data.getMonth());
		var ano = data.getFullYear();		
		
		var oMes = acioli.id('mes');
		var oAno = acioli.id('ano');
		
		var oCaixa = acioli.id('id_caixa');
		
		checkSelect(oMes,mes);
		checkSelect(oAno,ano);
		
		acioli.exec.extrato("referencia="+mes+"/"+ano+"&id_caixa="+oCaixa.value);
		//swfobject.embedSWF("includes/script/open-flash-chart.swf", id_gextrato, "100%", "300", "8.0.0","",{"data-file":url_GExtrato},{wmode:"opaque"});	
		document.body.onclick=function(){
			acioli.contextClose('contextMenu');
		};
	}
	
	var mesAno = function(){
		var mes = acioli.id('mes').value;
		var ano = acioli.id('ano').value;
		var oCaixa = acioli.id('id_caixa');
		acioli.exec.extrato("referencia="+mes+"/"+ano+"&id_caixa="+oCaixa.value);
		apex_search.init();
		//var tmp = findSWF(id_gextrato);
		//tmp.reload(url_GExtrato + "?mes="+mes+"&ano="+ano+"&id_caixa="+oCaixa.value);
	
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
	
	
</script>

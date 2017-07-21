<!-- #include file="includes/web/top.asp" -->
	<h1 class='analise'><%=Server.HTMLEncode("Análise por categoria")%></h1>
	<nav style="margin-bottom:20px;">
		<button onclick="mesAno()" class='minimal-indent'><img src="includes/img/atualizar.png" />Atualizar</button>
        <select onchange="mesAno();" id="mes" style="width:130px;display:inline;margin-left:10px;">
			<%=optMes("")%>
		 </select>
		 <select  onchange="mesAno();" id="ano" style="width:100px;display:inline;margin-left:10px;">
			<%=optAno("")%>
		 </select>
         <select  onchange="mesAno();" id="caixa" style="width:150px;display:inline;margin-left:10px;">
         	<option value="0">Todos</option>
			<%=optCaixa("")%>
		 </select>
         <select  onchange="mesAno();" id="tipo" style="width:100px;display:inline;margin-left:10px;">
         	<option value="D">Despesa</option>
            <option value="C">Receita</option>
		 </select>
		 <select onchange="mesAno()" id="confirmado" style="width:100px;display:inline;margin-left:10px;">
		 	<option value="N">Previsto</option>
            <option value="S">Confirmado</option>
		 </select>
	</nav>
	<div id="atencao" class="atencao" style="display:none;"><%=server.HTMLEncode("Não existe nenhuma movimentação com o filtro informado!")%></div>
    <p id="gPrevisaoCategoria" style="display:none;" ></p>
    <p id="listarMovimento" ></p>
<!-- #include file="includes/web/foot.asp" -->
<script>
	var id_PrevisaoCategoria = "gPrevisaoCategoria";
	var url_PrevisaoCategoria = "dados/exeAnalise.asp";
	window.onload=function(){
		var data = new Date();
		var mes = acioli.trataMes(data.getMonth());
		var ano = data.getFullYear();
		var oMes = acioli.id('mes');
		var oAno = acioli.id('ano');
		
		acioli.checkSelect(oMes,mes);
		acioli.checkSelect(oAno,ano);
		//{"data-file":url_PrevisaoCategoria},
		swfobject.embedSWF("includes/script/open-flash-chart.swf", id_PrevisaoCategoria, "100%", "320", "8.0.0","","",{wmode:"opaque",menu:"true"});	
		
		mesAno();
	}
	
	var mesAno = function(){
		var mes = acioli.id('mes').value;
		var ano = acioli.id('ano').value;
		var caixa = acioli.id('caixa').value;
		var tipo = acioli.id('tipo').value;
		var confirmado = acioli.id("confirmado").value;
		var tmp = findSWF(id_PrevisaoCategoria);
		//tmp.reload(url_PrevisaoCategoria + "?mes="+mes+"&ano="+ano+"&id_caixa="+caixa+"&tipo="+tipo);
		acioli.id('listarMovimento').innerHTML = '';
		
		
		var a = new ajax();
		var js = acioli.trim(a.exec(url_PrevisaoCategoria, "mes="+mes+"&ano="+ano+"&id_caixa="+caixa+"&tipo="+tipo+"&confirmado="+confirmado ,"POST",false,a.RETURN_TEXT));
		try{
			if(js!=''){
				acioli.id('gPrevisaoCategoria').style.display='block';
				acioli.id('atencao').style.display='none';
				tmp.load(js);
			}else{
				acioli.id('gPrevisaoCategoria').style.display='none';
				acioli.id('atencao').style.display='block';
			}
		}catch(e){
			
		}
	
	};
	
	var listar = function(data){
		acioli.exe.movimentoPorCategoria(data);
	};
	
	function open_flash_chart_data()
	{
		var mes = acioli.id('mes').value;
		var ano = acioli.id('ano').value;
		var caixa = acioli.id('caixa').value;
		var tipo = acioli.id('tipo').value;
		var tmp = findSWF(id_PrevisaoCategoria);
		
		var a = new ajax();
		var js = acioli.trim(a.exec(url_PrevisaoCategoria, "mes="+mes+"&ano="+ano+"&id_caixa="+caixa+"&tipo="+tipo ,"POST",false,a.RETURN_TEXT));
		if(js!=''){
			acioli.id('gPrevisaoCategoria').style.display='block';
			acioli.id('atencao').style.display='none';
			return js;
		}else{
			acioli.id('gPrevisaoCategoria').style.display='none';
			acioli.id('atencao').style.display='block';
			return "";
		}
		
	}
	
	
	
</script>
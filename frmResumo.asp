<!-- #include file="includes/web/top.asp" -->
    <h1 class='analise'><%=Server.HTMLEncode("Balanço Anual")%></h1>
    <nav style="margin-bottom:20px;">
		<button onclick="atualiza_resumo()" class='minimal-indent'><img src="includes/img/atualizar.png" />Atualizar</button>
    	<select onchange="atualiza_resumo()" id="ano_resumo" style="width:130px;display:inline;margin-left:10px;"><%=optano("")%></select>
    	<!--<select onchange="atualiza_resumo()" id="confirmado" style="width:100px;display:inline;margin-left:10px;">
		 	<option value="N">Previsto</option>
            <option value="S">Confirmado</option>
		 </select>-->
		 <select onchange="atualiza_resumo()" name="conta" id="conta" style="width:130px;display:inline;margin-left:10px;">
		 	<%=optCaixa("")%>
		 </select>
    </nav>
    <p id="g" style="margin-bottom:10px;z-index:-1000000000;"></p>
    <div id="atencao_resumo" class="atencao" style="display:none;"><%=server.HTMLEncode("Não existe nenhuma movimentação com o ano informado!")%></div>
    <p id="listarMovimento" ></p>

    <!--
    <h1 class='chart'><%=Server.HTMLEncode("Resumo mensal das categoria")%></h1>
    <nav style="margin-bottom:20px;">
		<button class='minimal-indent' onclick="atualiza_categoria()"><img src="includes/img/atualizar.png" />Atualizar</button>
    	<select id="mes_categoria" onchange="atualiza_categoria()" style="width:130px;display:inline;margin-left:10px;"><%=optmes("")%></select>
        <select id="ano_categoria" onchange="atualiza_categoria()" style="width:130px;display:inline;margin-left:10px;"><%=optano("")%></select>
    </nav>
    <div id="gr1" style="display:inline;"></div>
    <div id="atencao_categoria_receita" class="atencao" style="display:none;width:50%;vertical-align:top;margin:10px;"><%=server.HTMLEncode("Não existe nenhuma movimentação de receita com mes e ano informados!")%></div>
    <div id="gr2" style="display:inline;"></div>
    <div id="atencao_categoria_despesa" class="atencao" style="display:none;width:50%;vertical-align:top;margin:10px;"><%=server.HTMLEncode("Não existe nenhuma movimentação de despesa com mes e ano informados!")%></div>
    <br />
	-->
<!-- #include file="includes/web/foot.asp" -->
<script>
	var grafico_resumo = "g";
	var grafico_categoria_receita = "gr1";
	var grafico_categoria_despesa = "gr2";
    window.onload = function () {
        
		var data = new Date();
		var mes = acioli.trataMes(data.getMonth());
		var ano = data.getFullYear();
		var oMes = acioli.id('mes_categoria');
		var oAno = acioli.id('ano_categoria');
		var oAno1 = acioli.id('ano_resumo');
		var oConta = acioli.id("conta");
		//acioli.checkSelect(oMes,mes);
		//acioli.checkSelect(oAno,ano);
		acioli.checkSelect(oAno1,ano);
		
		swfobject.embedSWF("includes/script/open-flash-chart.swf", grafico_resumo,  "100%", "320", "8.0.0", "", { wmode: "opaque" });
        //swfobject.embedSWF("includes/script/open-flash-chart.swf", grafico_categoria_receita, "48%", "320", "8.0.0", "", { "get-data": "open_flash_c" },{ wmode: "opaque" });
		//swfobject.embedSWF("includes/script/open-flash-chart.swf", grafico_categoria_despesa, "48%", "320", "8.0.0", "", { "get-data": "open_flash_d" },{ wmode: "opaque" });
    };
    function open_flash_chart_data() {
		
		var oAno = acioli.id('ano_resumo');
        var a = new ajax();
		var js = acioli.trim(a.exec("dados/exeBalanco.asp", "ano="+oAno.value ,"POST",false,a.RETURN_TEXT));
        return js;
    };
	function open_flash_c(){
		
		var oMes = acioli.id('mes_categoria');
		var oAno = acioli.id('ano_categoria');		
		var a = new ajax();
		var js = acioli.trim(a.exec("dados/exeAnalise.asp?mes="+oMes.value+"&ano="+oAno.value+"&tipo=C&title=true", "" ,"POST",false,a.RETURN_TEXT));
        return js;
	}
	
	function open_flash_d(){
		var oMes = acioli.id('mes_categoria');
		var oAno = acioli.id('ano_categoria');
		
		var a = new ajax();
		var js = acioli.trim(a.exec("dados/exeAnalise.asp?mes="+oMes.value+"&ano="+oAno.value+"&tipo=D&title=true", "" ,"POST",false,a.RETURN_TEXT));
        return js;
	}
	
	var atualiza_resumo = function(){
		var ano = acioli.id('ano_resumo').value;
		var conta = acioli.id("conta").value;
		var tmp = findSWF(grafico_resumo);
		var a = new ajax();
		var js = acioli.trim(a.exec("dados/exeBalanco.asp", "ano="+ano+"&idconta="+conta ,"POST",false,a.RETURN_TEXT));
        acioli.id('listarMovimento').innerHTML = '';
		try{
			if(js!=''){
				acioli.id(grafico_resumo).style.display='block';
				acioli.id('atencao_resumo').style.display='none';
				tmp.load(js);
			}else{
				acioli.id(grafico_resumo).style.display='none';
				acioli.id('atencao_resumo').style.display='block';
			}
		}catch(e){
			
		}
		
	};

	var listar = function(data, tipo){
		acioli.exec.movimentoPorReferencia(data, tipo);
	};
	
	var atualiza_categoria = function(){
		var mes = acioli.id('mes_categoria').value;
		var ano = acioli.id('ano_categoria').value;
		var tmp1 = findSWF(grafico_categoria_receita);
		var tmp2 = findSWF(grafico_categoria_despesa);
		
		var a = new ajax();
		var js = acioli.trim(a.exec("dados/exeAnalise.asp?mes="+mes+"&ano="+ano+"&tipo=C&title=true", "" ,"POST",false,a.RETURN_TEXT));
		try{
			if(js!=''){
				acioli.id(grafico_categoria_receita).style.display='inline';
				acioli.id('atencao_categoria_receita').style.display='none';
				tmp1.load(js);
			}else{
				acioli.id(grafico_categoria_receita).style.display='none';
				acioli.id('atencao_categoria_receita').style.display='inline';
			}
		}catch(e){
			
		}
		
		var js = acioli.trim(a.exec("dados/exeAnalise.asp?mes="+mes+"&ano="+ano+"&tipo=D&title=true", "" ,"POST",false,a.RETURN_TEXT));
		try{
			if(js!=''){
				acioli.id(grafico_categoria_despesa).style.display='inline';
				acioli.id('atencao_categoria_despesa').style.display='none';
				tmp2.load(js);
			}else{
				acioli.id(grafico_categoria_despesa).style.display='none';
				acioli.id('atencao_categoria_despesa').style.display='inline';
			}
		}catch(e){
			
		}
		
	};
</script>
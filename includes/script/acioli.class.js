/*
* @author Claudio Acioli <kllaudyo@gmail.com>
* @version 1.0
* @package includes.script
*/


var acioli=function(){};
	
/*<basico>*/
	acioli.doc = window.document;

	acioli.id = function(oId){
		return acioli.doc.getElementById(oId);
	};
	
	acioli.isObject = function(o){
		return o!==undefined;
	};
	
	acioli.name = function(oName){
		return acioli.doc.getElementsByName(oId);
	};
	
	acioli.href = function(link){
		document.location.href=link;
	};
	
	acioli.trim = function(value){
		return value.replace(/^\s+|\s+$/g,"");
	};
	
	acioli.retornaNumeros = function(value){
		return value.replace(/[^\d,]+/g, '');
	}
	
	acioli.getElementsByAttribute = function(oElm, strTagName, strAttributeName, strAttributeValue){
		
	    var arrElements = (strTagName == "*" && document.all)? document.all : oElm.getElementsByTagName(strTagName);
	    var arrReturnElements = new Array();
	    var oAttributeValue = (typeof strAttributeValue != "undefined")? new RegExp("(^|\\s)" + strAttributeValue + "(\\s|$)") : null;
	    var oCurrent;
	    var oAttribute;
	    for(var i=0; i<arrElements.length; i++){
	        oCurrent = arrElements[i];
	        oAttribute = oCurrent.getAttribute(strAttributeName);
	        if(typeof oAttribute == "string" && oAttribute.length > 0){
	            if(typeof strAttributeValue == "undefined" || (oAttributeValue && oAttributeValue.test(oAttribute))){
	                arrReturnElements.push(oCurrent);
	            }
	        }
	    }
	    return arrReturnElements;
	}
	
	acioli.addEvent = function(eventTarget, eventType, eventHandler) {
		if (eventTarget.addEventListener) {
			eventTarget.addEventListener(eventType, eventHandler,false);
		} else if (eventTarget.attachEvent) {
			eventType = "on" + eventType;
			eventTarget.attachEvent(eventType, eventHandler);
		} else {
			eventTarget["on" + eventType] = eventHandler;
		};
	};
	
	acioli.setCookie = function(c_name,value,exdays){
		var exdate=new Date();
		exdate.setDate(exdate.getDate() + exdays);
		var c_value=escape(value) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
		document.cookie=c_name + "=" + c_value;
	};
	
	acioli.getCookie = function(c_name){
		var i,x,y,ARRcookies=document.cookie.split(";");
		for (i=0;i<ARRcookies.length;i++)
		{
		  x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
		  y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
		  x=x.replace(/^\s+|\s+$/g,"");
		  if (x==c_name)
			{
			return unescape(y);
			}
		  }
	};
	
/*</basico>*/

/*<tela>*/
	acioli.clearOptionSelect = function(oSelect){
		while(oSelect.length){
			oSelect.removeChild(oSelect.options[0]);
		};
	};
	
	acioli.addOptionSelect = function(oSelect, value, txt){
		var opt = document.createElement('option');
		var txt = document.createTextNode(txt);
		opt.value = value;
		opt.appendChild(txt);
		oSelect.appendChild(opt);
	};
	
	acioli.selectedOption = function(oSelect,value){
		for(var i=0; i<oSelect.options.length; i++){
			if(oSelect.options[i].value == value){
				oSelect.options[i].selected=true;
				break;
			};
		};
	};

	acioli.JsonToSelect = function(oJson,oSelect,clear){
		if(clear!==undefined && clear == true){
			acioli.clearOptionSelect(oSelect);
		};
		for(var i=0; i<oJson.length; i++){
			acioli.addOptionSelect(oSelect,oJson[i].id,oJson[i].desc);
		};
	};
	
	acioli.exec = function(){};
	acioli.exec.listarCaixa = function(dados){
		var a = new ajax();
		var html = a.exec(acioli.url.listarCaixa, dados ,"POST",false,a.RETURN_TEXT);
		acioli.id("listarCaixa").innerHTML = html;
	};
	acioli.exec.listarMovimento = function(dados){
		var a = new ajax();
		var html = a.exec(acioli.url.listarMovimento, dados ,"POST",false,a.RETURN_TEXT);
		acioli.id("listarMovimento").innerHTML = html;
	};
	acioli.exec.listarCategoria = function(dados){
		var a = new ajax();
		var html = a.exec(acioli.url.listarCategoria, dados ,"POST",false,a.RETURN_TEXT);
		acioli.id("listarCategoria").innerHTML = html;
	};
	
	acioli.exec.listarCliente = function(dados){
		var a = new ajax();
		var html = a.exec(acioli.url.listarCliente, dados ,"POST",false,a.RETURN_TEXT);
		acioli.id("listarCliente").innerHTML = html;
	};
	
	acioli.exec.listarClienteFisico = function(dados){
		var a = new ajax();
		var html = a.exec(acioli.url.listarClienteFisico, dados ,"POST",false,a.RETURN_TEXT);
		acioli.id("listarCliente").innerHTML = html;
	};

    acioli.exec.listarUsuario = function (dados) {
        var a = new ajax();
        var html = a.exec(acioli.url.listarUsuario, dados, "POST", false, a.RETURN_TEXT);
        acioli.id("listarUsuario").innerHTML = html;
    };

	acioli.exec.movimentoPorCategoria = function(dados){
		var a = new ajax();
		var html = a.exec(acioli.url.MovCategoria, dados ,"POST",false,a.RETURN_TEXT);
		acioli.id("listarMovimento").innerHTML = "";
		acioli.id("listarMovimento").innerHTML = html;
	};

	acioli.exec.movimentoPorReferencia = function(data, tipo){
		var a = new ajax();
		var html = a.exec(acioli.url.MovReferencia, "referente="+data+"&tipo="+tipo ,"POST",false,a.RETURN_TEXT);
		acioli.id("listarMovimento").innerHTML = "";
		acioli.id("listarMovimento").innerHTML = html;
	};
	
	acioli.exec.extrato = function(dados){
		var a = new ajax();
		var html = a.exec(acioli.url.extrato, dados ,"POST",false,a.RETURN_TEXT);
		acioli.id("listarMovimento").innerHTML = "";
		acioli.id("listarMovimento").innerHTML = html;
	};
	
	acioli.exec.saldo = function(dados){
		var a = new ajax();
		var html = a.exec(acioli.url.saldo, dados ,"POST",false,a.RETURN_TEXT);
		acioli.id("divSaldos").innerHTML = "";
		acioli.id("divSaldos").innerHTML = html;
	};

	acioli.exec.planejar = function (dados) {
	    var a = new ajax();
	    var html = a.exec(acioli.url.planejar, dados, "POST", false, a.RETURN_TEXT);
	    alert(html);
	    acioli.id("divPlanejar").innerHTML = "";
	    acioli.id("divPlanejar").innerHTML = html;
	}
	
	acioli.exec.confirmar = function(dados){
		var a = new ajax();		
		var html = a.exec(acioli.url.movimento + "acao=confirmar", dados ,"POST",false,a.RETURN_TEXT);
		return html;
    };
	
	acioli.exec.resumo = function(dados){
		var a = new ajax();		
		var html = a.exec(acioli.url.movimento + "acao=resumo", dados ,"POST",false,a.RETURN_TEXT);
		//acioli.id("divAnalise").innerHTML = "";
		//acioli.id("divAnalise").innerHTML = html;
	};
	
	acioli.disableRightMenu = function(ev){
		ev = ev || window.event;
		if(ev.cancelBubble){
			ev.cancelBubble=true;
		}
		ev.preventDefault();
		ev.stopPropagation();
		return false;
	};
	
	acioli.context=function(ev,id){
		ev = ev || window.event;
		var obj = ev.srcElement || ev.target;
		if(ev.pageY){
			acioli.id(id).style.top = ev.pageY + 'px';
			acioli.id(id).style.left = ev.pageX + 'px';
		}else{
			acioli.id(id).style.top =  (ev.clientY + document.body.scrollTop + document.body.scrollTop) + 'px'; 
			acioli.id(id).style.left = (ev.clientX + document.body.scrollLeft + document.body.scrollLeft) + 'px';
		}
		acioli.id(id).style.display='block';
		
		var js = obj.parentNode.getAttribute('data');
		acioli.data = js;
		alert(eval(acioli.data));
	}
	
	acioli.data = null;
		
	acioli.contextClose=function(id){
		acioli.id(id).style.display='none';
	}
	
/*</tela>*/
	
/*<url>*/
	acioli.url = function(){};
	acioli.url.index = "";
	acioli.url.movimento = "dados/exeMovimento.asp?";
	acioli.url.caixa = "dados/exeCaixa.asp?";
	acioli.url.categoria = "dados/exeCategoria.asp?";
	acioli.url.cliente = "dados/exeCliente.asp?";
	acioli.url.usuario = "dados/exeUsuario.asp?";
	acioli.url.fisica = "dados/exePFisica.asp?";
	acioli.url.meta = "dados/exeMeta.asp?";
	
	acioli.url.listarCaixa = acioli.url.caixa + "acao=listar";
	acioli.url.listarMovimento = acioli.url.movimento + "acao=listar";
	acioli.url.listarCategoria = acioli.url.categoria + "acao=listar";
	acioli.url.listarCliente = acioli.url.cliente + "acao=listar";
	acioli.url.listarClienteFisico = acioli.url.fisica + "acao=listar";
	acioli.url.MovCategoria = acioli.url.movimento + "acao=movimentoPorCategoria";
	acioli.url.MovReferencia = acioli.url.movimento + "acao=movimentoPorReferencia";
	acioli.url.extrato = acioli.url.movimento + "acao=extrato";
	acioli.url.saldo = acioli.url.caixa + "acao=acessoRapido";
	acioli.url.planejar = acioli.url.meta + "acao=planejar";
	acioli.url.listarUsuario = acioli.url.usuario + "acao=listar";

	acioli.trataMes = function(mes){
		mes = mes + 1;
		if(mes<10){
			return '0'+mes;
		}
		return mes;
	}
	
	acioli.checkSelect = function(sel,valor){
		for(var i=0; i < sel.options.length; i++){
			if(	sel.options[i].value == valor){
				sel.options[i].selected=true;
				break;
			}
		}	
	}
/*<url>*/
	
/*<bibliotecas>*/
	acioli.validation = validation; //validação
    acioli.datatypes =  datatypes; //tipo de dado informado no campo
    acioli.format = format; //formatação
	//executando bibliotecas
	datatypes.events(acioli.doc);
	format.events(acioli.doc);
/*<bibliotecas>*/	


/*teste*/
window.apex_search = {};
apex_search.init = function () {
    if (document.getElementsByClassName("tab_search").length > 0) {
        var table = document.getElementsByClassName("tab_search")[0];
        var tbody = table.getElementsByTagName('TBODY')[0];
        this.rows = tbody.getElementsByTagName('TR');
        this.rows_length = apex_search.rows.length;
        this.rows_text = [];
        for (var i = 0; i < apex_search.rows_length; i++) {
            this.rows_text[i] = (apex_search.rows[i].innerText) ? apex_search.rows[i].innerText.toUpperCase() : apex_search.rows[i].textContent.toUpperCase();
            for (var j = 0; j < apex_search.rows[i].cells.length; j++) {
                if (apex_search.rows[i].cells[j].getAttribute('text')) {
                    this.rows_text[i] += apex_search.rows[i].cells[j].getAttribute('text').toUpperCase();
                };

            };
        };
    };
}

apex_search.lsearch = function(){
	this.term = document.getElementsByClassName('search')[0].value.toUpperCase();
	for(var i=0,row;row = this.rows[i],row_text = this.rows_text[i];i++){
		row.style.display = ((row_text.indexOf(this.term) != -1) || this.term  === '')?'':'none';
	}
	this.time = false;
}

apex_search.search = function(e){
    var keycode;
    if(window.event){keycode = window.event.keyCode;}
    else if (e){keycode = e.which;}
    else {return false;}
	apex_search.lsearch();
}

function Limpar(valor, validos) {	
	var result = "";
	var aux;
	for (var i=0; i < valor.length; i++) {
		aux = validos.indexOf(valor.substring(i, i+1));
		if (aux>=0) {
			result += aux;
		}
	}
	return result;
}

//Formata número tipo moeda usando o evento onKeyDown

function Formata(campo,tammax,teclapres,decimal) {
	var tecla = teclapres.keyCode;
	vr = Limpar(campo.value,"0123456789");
	tam = vr.length;
	dec=decimal
	
	if (tam < tammax && tecla != 8){ tam = vr.length + 1 ; }
	
	if (tecla == 8 )
	{ tam = tam - 1 ; }
	
	if ( tecla == 8 || tecla >= 48 && tecla <= 57 || tecla >= 96 && tecla <= 105 )
	{
	
	if ( tam <= dec )
	{ campo.value = vr ; }
	
	if ( (tam > dec) && (tam <= 5) ){
	campo.value = vr.substr( 0, tam - 2 ) + "," + vr.substr( tam - dec, tam ) ; }
	if ( (tam >= 6) && (tam <= 8) ){
	campo.value = vr.substr( 0, tam - 5 ) + "." + vr.substr( tam - 5, 3 ) + "," + vr.substr( tam - dec, tam ) ; 
	}
	if ( (tam >= 9) && (tam <= 11) ){
	campo.value = vr.substr( 0, tam - 8 ) + "." + vr.substr( tam - 8, 3 ) + "." + vr.substr( tam - 5, 3 ) + "," + vr.substr( tam - dec, tam ) ; }
	if ( (tam >= 12) && (tam <= 14) ){
	campo.value = vr.substr( 0, tam - 11 ) + "." + vr.substr( tam - 11, 3 ) + "." + vr.substr( tam - 8, 3 ) + "." + vr.substr( tam - 5, 3 ) + "," + vr.substr( tam - dec, tam ) ; }
	if ( (tam >= 15) && (tam <= 17) ){
	campo.value = vr.substr( 0, tam - 14 ) + "." + vr.substr( tam - 14, 3 ) + "." + vr.substr( tam - 11, 3 ) + "." + vr.substr( tam - 8, 3 ) + "." + vr.substr( tam - 5, 3 ) + "," + vr.substr( tam - 2, tam ) ;}
	} 

}
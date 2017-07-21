/*
* @author Claudio Acioli <kllaudyo@gmail.com>
* @version 1.0
* @package includes.script
*/

var format = function(){};
format.events = function(obj){
	var e = acioli.getElementsByAttribute(obj,"*","format");
	for(var i=0; i<e.length; i++){
		acioli.addEvent(e[i], "keypress", format.mascarakey);
		acioli.addEvent(e[i], "paste", format.mascarapaste);
	};
};

format.mascarakey = function(){
	
	var src = this;
	var mask = src.getAttribute('format');
	var e = (window.event) ? window.event : arguments[0];
	var k = e.keyCode || e.wich || e.charCode ;
	
	if(k==8 || k==9 || k==13 || k==16 || k==20 || k==46){
		return true;
	};
	
	src.maxLength = mask.length;
	var i = src.value.length;
	var saida = "#";
	var texto = mask.substring(i);
	var t = texto.substring(0,1);

	if (t != saida) {
		src.value += t;
	};
	
};

format.mascarapaste = function(){
	var campo = this;
	window.setTimeout(function(){format.mascaraAfterpaste(campo)},10);	
}

format.mascaraAfterpaste = function(campo){
	var mascara = campo.getAttribute('format');
	var valor = acioli.retornaNumeros(campo.value);
	valor   = (valor).substring(0,format.countMask(mascara));
	var tamvlr  = valor.length;
	if (tamvlr==mascara.length)
		return;
	campo.value = "";
	
	while (tamvlr>=1){
		if (mascara.substr(mascara.length-1,1) == "#"){
			campo.value = valor.substr(tamvlr-1, 1) + campo.value;
			tamvlr--;
		}else {
			campo.value = mascara.substr(mascara.length-1,1) + campo.value;
		}
		mascara = mascara.substring(0,mascara.length-1);
	}
}

format.countMask = function(mask){
	var c = mask.length;
	var t = 0;
	for(var i=0; i<c; i++){
		var txt = mask.substring(i);
		txt = txt.substring(0,1);
		if(txt=='#'){
			t++;
		}
	}
	return t;
}
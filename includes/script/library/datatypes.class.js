/*
* Taj
* @author Claudio Acioli <kllaudyo@gmail.com>
* @version 1.0
* @package includes.script
*/
var datatypes = function(){};

datatypes.events = function(obj){
	var e = acioli.getElementsByAttribute(obj,"*","datatype");
	for(var i=0; i<e.length; i++){
		switch((e[i].getAttribute("datatype")).toUpperCase()){
			case "NUMERIC":
				acioli.addEvent(e[i], "keypress", datatypes.numerickey);
				acioli.addEvent(e[i], "paste", datatypes.numericpaste);
				acioli.addEvent(e[i], "drop", datatypes.numericdrop);
				break;
			case "DECIMAL":
				acioli.addEvent(e[i], "keypress", datatypes.decimalkey);
				acioli.addEvent(e[i], "paste", datatypes.decimalpaste);
				acioli.addEvent(e[i], "drop", datatypes.decimaldrop);
				break;
			case "ALFANUMERIC":
				acioli.addEvent(e[i], "keypress", datatypes.alfanumerickey);
				acioli.addEvent(e[i], "paste", datatypes.alfanumericpaste);
				acioli.addEvent(e[i], "drop", datatypes.alfanumerickey);
				break;
			case "ALFANUMERICACCENT":
				acioli.addEvent(e[i], "keypress", datatypes.alfanumericaccentkey);
				acioli.addEvent(e[i], "paste", datatypes.alfanumericaccentpaste);
				acioli.addEvent(e[i], "drop", datatypes.alfanumericaccentdrop);
				break;
			case "MAIL":
				acioli.addEvent(e[i], "keypress", datatypes.alfanumericmailkey);
				acioli.addEvent(e[i], "paste", datatypes.alfanumericmailpaste);
				acioli.addEvent(e[i], "drop", datatypes.alfanumericmaildrop);				
		};
	};
};

datatypes.numerickey=function(){
	var e = (window.event) ? window.event : arguments[0];
	var k = e.keyCode || e.wich || e.charCode ;
	if(k==8 || k==9 || k==13 || k==16 || k==20 || k==46){
		return true;
	}
	var txt = String.fromCharCode(k);
	if(txt){
		var re = /^[0-9]/;
		if(!txt.match(re)){
			try{
				e.preventDefault();
			}catch(err){
				e.returnValue = false;	
			};
		};
	};
	/*if (k > 31 && (k < 48 || k > 57)){
		try{
			e.preventDefault();
		}catch(err){
			e.returnValue = false;	
		};
	};*/
};

datatypes.numericpaste=function(){
	var e = (window.event)?window.event:arguments[0];
	var txt = e.clipboardData && e.clipboardData.getData ? e.clipboardData.getData('text/plain') : window.clipboardData && window.clipboardData.getData ? window.clipboardData.getData('Text') : false;	
	if(txt){
		var re = /^[0-9]/;
		if(!txt.match(re)){
			try{
				e.preventDefault();
			}catch(err){
				e.returnValue = false;	
			};
		};
	};
};

datatypes.numericdrop=function(){
	var e = (window.event)?window.event:arguments[0];
	try{
		e.preventDefault();
	}catch(err){
		e.returnValue = false;	
	};
};

datatypes.decimalkey=function(){
	var e = (window.event) ? window.event : arguments[0];
	var k = e.keyCode || e.wich || e.charCode ;
	if(k==8 || k==9 || k==13 || k==16 || k==20 || k==46){
		return true;
	}
	var txt = String.fromCharCode(k);
	if(txt){
		var re = /^[0-9,]/;
		if(!txt.match(re)){
			try{
				e.preventDefault();
			}catch(err){
				e.returnValue = false;	
			};
		};
	};
	/*if (k > 31 && (k < 48 || k > 57)){
		try{
			e.preventDefault();
		}catch(err){
			e.returnValue = false;	
		};
	};*/
};

datatypes.decimalpaste=function(){
	var e = (window.event)?window.event:arguments[0];
	var txt = e.clipboardData && e.clipboardData.getData ? e.clipboardData.getData('text/plain') : window.clipboardData && window.clipboardData.getData ? window.clipboardData.getData('Text') : false;	
	if(txt){
		var re = /^[0-9][-]/;
		if(!txt.match(re)){
			try{
				e.preventDefault();
			}catch(err){
				e.returnValue = false;	
			};
		};
	};
};

datatypes.decimaldrop=function(){
	var e = (window.event)?window.event:arguments[0];
	try{
		e.preventDefault();
	}catch(err){
		e.returnValue = false;	
	};
};

datatypes.alfanumerickey=function(){
	var e = (window.event) ? window.event : arguments[0];
	var k = e.keyCode || e.wich || e.charCode ;
	if(k==8 || k==9 || k==13 || k==16 || k==20 || k==46){
		return true;
	}
	var txt = String.fromCharCode(k);
	if(txt){
		var re = /^[a-z0-9]+$/i;
		if(!txt.match(re)){
			try{
				e.preventDefault();
			}catch(err){
				e.returnValue = false;	
			};
		};
	};
};

datatypes.alfanumericpaste=function(){
	var e = (window.event) ? window.event : arguments[0];
	var txt = e.clipboardData && e.clipboardData.getData ? e.clipboardData.getData('text/plain') : window.clipboardData && window.clipboardData.getData ? window.clipboardData.getData('Text') : false;
	if(txt){
		var re = /^[a-z0-9]+$/i;
		if(!txt.match(re)){
			try{
				e.preventDefault();
			}catch(err){
				e.returnValue = false;	
			};
		};
	};
};

datatypes.alfanumericdrop=function(){
	var e = (window.event)?window.event:arguments[0];
	try{
		e.preventDefault();
	}catch(err){
		e.returnValue = false;	
	};
};

datatypes.alfanumericaccentkey=function(){
	var e = (window.event) ? window.event : arguments[0];
	var k = e.keyCode || e.wich || e.charCode ;
	if(k==8 || k==9 || k==13 || k==16 || k==20 || k==46){
		return true;
	}
	var txt = String.fromCharCode(k);
	if(txt){
		var re = /^[a-z\u00C0-\u00ff 0-9!#$%&"()\/*+,-.°º:;?@[\\\]_`{|}~]+$/i;

		if(!txt.match(re)){
			try{
				e.preventDefault();
			}catch(err){
				e.returnValue = false;	
			};
		};
	};
};

datatypes.alfanumericaccentpaste=function(){
	var e = (window.event) ? window.event : arguments[0];
	var txt = e.clipboardData && e.clipboardData.getData ? e.clipboardData.getData('text/plain') : window.clipboardData && window.clipboardData.getData ? window.clipboardData.getData('Text') : false;
	if(txt){
		var re = /^[a-z\u00C0-\u00ff 0-9!#$%&"()\/*+,-.°º:;?@[\\\]_`{|}~]+$/i;
		if(!txt.match(re)){
			try{
				e.preventDefault();
			}catch(err){
				e.returnValue = false;	
			};
		};
	};
};

datatypes.alfanumericaccentdrop=function(){
	var e = (window.event)?window.event:arguments[0];
	try{
		e.preventDefault();
	}catch(err){
		e.returnValue = false;	
	};
};

datatypes.alfanumericmailkey=function(){
	var e = (window.event) ? window.event : arguments[0];
	var k = e.keyCode || e.wich || e.charCode ;
	if(k==8 || k==9 || k==13 || k==16 || k==20 || k==46){
		return true;
	}
	var txt = String.fromCharCode(k);
	if(txt){
		var re = /^[a-z0-9@._-]+$/i;
		if(!txt.match(re)){
			try{
				e.preventDefault();
			}catch(err){
				e.returnValue = false;	
			};
		};
	};
};

datatypes.alfanumericmailpaste=function(){
	var e = (window.event) ? window.event : arguments[0];
	var txt = e.clipboardData && e.clipboardData.getData ? e.clipboardData.getData('text/plain') : window.clipboardData && window.clipboardData.getData ? window.clipboardData.getData('Text') : false;
	if(txt){
		var re = /^[a-z0-9@._-]+$/i;
		if(!txt.match(re)){
			try{
				e.preventDefault();
			}catch(err){
				e.returnValue = false;	
			};s
		};
	};
};

datatypes.alfanumericmaildrop=function(){
	var e = (window.event)?window.event:arguments[0];
	try{
		e.preventDefault();
	}catch(err){
		e.returnValue = false;	
	};
};
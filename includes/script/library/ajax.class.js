var ajax = function(){
	
	this.RETURN_TEXT = 0;
	this.RETURN_JSON = 1;
	this.RETURN_XML = 2;
	
	var req = null;
	
	var error = function(desc){
		var window_error = window.open("","Error","status=1,width=350,height=150");
		window_error.document.write("<html><head><title>Error - Taj</title><link rel='stylesheet' href='includes/style/acioli.css' /></head><body>")
		window_error.document.write("<h1>Ajax Error</h1>");
		window_error.document.write("<div class='box'>"+desc+"</div>");
		window_error.document.write("</body></html>");
	}
	
	var getHttp = function(){
		if (window.XMLHttpRequest) {
			try {
				return new XMLHttpRequest();
			} catch(e) {
				return null;
			}
		} else if (window.ActiveXObject) {
			try {
				return new ActiveXObject("Msxml2.XMLHTTP");
			} catch(e) {
				try {
					return new ActiveXObject("Microsoft.XMLHTTP");
				} catch(e) {
					return null;
				}
			}
		}
	}
	
	var execFunc = function(func,type){
		try{
			if(req.readyState===4){
				if(req.status===200){
					
					switch(type){
					
						case 0:
							func(req.responseText);
							break;
						case 1:
							func(eval(req.responseText));
							break;
						case 2:
							func(req.responseXML);
							break;
						default:
							func(req.responseText);
							break;
					}
					
				}else{
					
					var msg = "Erro ajax<br />" + req.statusText + "<br />" + req.responseText;
					error(msg);
					
				}
			}
		}catch(ex){
			error(ex.message);
		}
	}
	
	this.exec=function(url,data,method,async,type,func){
		try{
			req = getHttp();
			if(method!==undefined){
				method = method.toUpperCase();
			}
			
			if(method!=="POST" && method!=="GET"){
				alert("metodo desconhecido");
			}
			
			if(req){
				if(method==="GET"){
					req.open(method,url,async);
					req.send(null);
				}else if(method==="POST"){
					req.open(method,url,async);
					req.setRequestHeader('Content-Type','application/x-www-form-urlencoded;');
					req.send(data);
				}
			}
			
			if(func!==undefined){
				
				req.onreadystatechange = function(){execFunc(func,type)};
				
			}else{
				switch(type){
					case this.RETURN_TEXT:
						return req.responseText;
					case this.RETURN_JSON:
						return eval(req.responseText);
					case this.RETURN_XML:
						return eval(req.responseXML);
					default:
						return req.responseText;
				}
			}
		}catch(ex){
			error(ex.message);
		}
		return null;
		
	}
	
}


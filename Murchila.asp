<html>
	<head>
<style>
	tr.child{
		display:none;
	}
</style>
	</head>
	<body>
		<table border="1">
			<thead>
				<tr>
					<th>Carteira</th>
					<th>Movimentos</th>
					<th>Valor</th>
				</tr>
			</thead>
			<tbody id="tb-corpo">
			
			</tbody>
		</table>
		<script>
			
window.Q = {
		
	id : function(id){
		return document.getElementById(id);
	},
	
	is_object : function(object) {
		return typeof object === 'object';
	},
	
	is_string : function(str) {
		return typeof str === "string";
	},
	
	is_undefined : function(object) {
		return typeof object === 'undefined';
	},
	
	is_function : function(func) {
		return typeof func === 'function';
	},
	
	has_class : function(ele, cls) {
		return ele.className.match(new RegExp('(\\s|^)' + cls + '(\\s|$)'));
	},

	add_class : function(ele, cls) {
		if (!Q.has_class(ele, cls))
			ele.className += " " + cls;
	},
	
	remove_class : function(ele, cls) {
		if (Q.has_class(ele, cls)) {
			var reg = new RegExp('(\\s|^)' + cls + '(\\s|$)');
			ele.className = ele.className.replace(reg, ' ');
		};
	},
	
	on : function(eventTarget, eventType, eventHandler) {

		try {
			if (eventTarget.addEventListener) {
				eventTarget
						.addEventListener(eventType, eventHandler, false);
			} else if (eventTarget.attachEvent) {
				eventType = "on" + eventType;
				eventTarget.attachEvent(eventType, eventHandler);
			} else {
				eventTarget["on" + eventType] = eventHandler;
			}
			;
		} catch (ex) {
			try {
				eventType = "on" + eventType;
				eventTarget.attachEvent(eventType, eventHandler);
			} catch (ex) {
				try {
					eventTarget["on" + eventType] = eventHandler;
				} catch (ex) {
				}
			}
		}

	},
		
	ajax : function() {
	
		if (Q.is_undefined(window.XMLHttpRequest)) {
			window.XMLHttpRequest = function() {
				try {
					return new ActiveXObject("Msxml2.XMLHTTP.6.0");
				} catch (e1) {
					try {
						return new ActiveXObject("Msxml2.XMLHTTP.3.0");
					} catch (e2) {
						try {
							return new ActiveXObject("Msxml2.XMLHTTP");
						} catch (e3) {
							try {
								return new ActiveXObject("Microsoft.XMLHTTP");
							} catch (e4) {
								throw new Error("XMLHttpRequest is not supported");
							};
						};
					};
				};
			};
		};

		return new XMLHttpRequest();
	
	},
	
	http_response_type : function(type, ajax) {
		switch (type.toString().toUpperCase()) {
			case 'JSON':
				return U.Json.parser(ajax.responseText);
			case 'TEXT':
			case 'HTML':
				return ajax.responseText;
			case 'XML':
				return ajax.responseXML;
			default:
				return ajax.responseText;
		};
	},
		
	http_request : function(options) {

		if (Q.is_object(options)) {
			if (!Q.is_string(options.url))
				return false;
			options.method 			  = options.method ? options.method : 'GET';
			options.url 		     += options.method === 'GET' ? (options.query ? '?' + options.query : '') : '';
			options.assincrony 		  = options.assincrony ? true : false;
			options.returnType 		  = Q.is_string(options.returnType) ? options.returnType: 'HTML';
			options.header_accept 	  = options.accept ? options.accept : false;
			options.onloading 		  = Q.is_function(options.onloading) ? options.onloading : function() {};
			options.onloaded 		  = Q.is_function(options.onloaded) ? options.onloaded : function() {};
			options.oninteractive 	  = Q.is_function(options.oninteractive) ? options.oninteractive : function() {};
			options.isExecuteCallback = Q.is_function(options.oncallback);
			options.oncallback 		  = options.isExecuteCallback ? options.oncallback : function() {};

			var ajax = Q.ajax();
				ajax.open(options.method, options.url, options.assincrony);
			
			if (options.header_accept) {
				ajax.setRequestHeader("Accept", options.header_accept);
			};

			if (options.method === 'GET') {
				ajax.send(null);
			} else {
				ajax.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
				ajax.send(options.query);
			};

			if (!options.assincrony) {
				return Q.http_response_type(options.returnType, ajax);
			} else {
				ajax.onreadystatechange = function() {
					switch (ajax.readyState) {
					case 1:
						options.onloading();
						break;
					case 2:
						options.onloaded();
						break;
					case 3:
						options.oninteractive();
						break;
					case 4:
						if (ajax.status === 200) {
							if (options.isExecuteCallback) {
								options.oncallback(U.Ajax.returnType(options.returnType, ajax));
							};
						};
						break;
					};
				};
			};

		};

	}
			
};
			
window.app = {
	
	carrega_dados_agregados : function(){
		Q.id("tb-corpo").innerHTML = Q.http_request({url:"exe_agrega.asp",sync:false});
	},
	
	carrega_dados_detalhados : function(id){
		
		var tr_pai = Q.id("tr-" + id);
		var tr_filha = tr_pai.parentNode.rows[tr_pai.rowIndex];		
		if(Q.has_class(tr_filha, "child")){		
			tr_filha.cells[0].innerHTML = Q.http_request({url:"exe_detalhe.asp",query:"id="+id,sync:false});
			Q.remove_class(tr_filha,"child");
		}else{
			Q.add_class(tr_filha, "child");
		};
	}
	
};

Q.on(window, "load", function(ev){
	app.carrega_dados_agregados();
});
			
</script>
	</body>
</html>
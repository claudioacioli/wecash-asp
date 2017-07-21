/**
 * @author Claudio Acioli
 * @version 1.5.1
 */


if (!Array.prototype.indexOf) {
     Array.prototype.indexOf = function (searchElement /*, fromIndex */ ) {
    'use strict';
    if (this == null) {
      throw new TypeError();
    }
    var n, k, t = Object(this),
        len = t.length >>> 0;

    if (len === 0) {
      return -1;
    }
    n = 0;
    if (arguments.length > 1) {
      n = Number(arguments[1]);
      if (n != n) { // shortcut for verifying if it's NaN
        n = 0;
      } else if (n != 0 && n != Infinity && n != -Infinity) {
        n = (n > 0 || -1) * Math.floor(Math.abs(n));
      }
    }
    if (n >= len) {
      return -1;
    }
    for (k = n >= 0 ? n : Math.max(len - Math.abs(n), 0); k < len; k++) {
      if (k in t && t[k] === searchElement) {
        return k;
      }
    }
    return -1;
  };
}

/**
 * Implements insertAdjacentHTML
 */
if (typeof document.querySelector == "undefined") {
	document.querySelectorAll = function(sel) {
		var sels = sel.split(","), run = function(node, selector) {
			var sel = selector.split(/[ >]+/), com = selector.match(/[ >]+/g)
					|| [], s, c, ret = [ node ], nodes, l, i, subs, m, j, check, x, w, ok, as;
			com.unshift(" ");
			while (s = sel.shift()) {
				c = com.shift();
				if (c)
					c = c.replace(/^ +| +$/g, "");
				nodes = ret.slice(0);
				ret = [];
				l = nodes.length;
				subs = s.match(/[#.[]?[a-z_-]+(?:='[^']+'|="[^"]+")?]?/gi);
				m = subs.length;
				for (i = 0; i < l; i++) {
					if (subs[0].charAt(0) == "#")
						ret = [ document.getElementById(subs[0].substr(1)) ];
					else {
						check = c == ">" ? nodes[i].children : nodes[i]
								.getElementsByTagName("*");
						if (!check)
							continue;
						w = check.length;
						for (x = 0; x < w; x++) {
							ok = true;
							for (j = 0; j < m; j++) {
								switch (subs[j].charAt(0)) {
								case ".":
									if (!check[x].className.match(new RegExp(
											"\\b" + subs[j].substr(1) + "\\b")))
										ok = false;
									break;
								case "[":
									as = subs[j].substr(1, subs[j].length - 2)
											.split("=");
									if (!check[x].getAttribute(as[0]))
										ok = false;
									else if (as[1]) {
										as[1] = as[1].replace(/^['"]|['"]$/g,
												"");
										if (check[x].getAttribute(as[0]) != as[1])
											ok = false;
									}
									break;
								default:
									if (check[x].tagName.toLowerCase() != subs[j]
											.toLowerCase())
										ok = false;
									break;
								}
								if (!ok)
									break;
							}
							if (ok)
								ret.push(check[x]);
						}
					}
				}
			}
			return ret;
		}, l = sels.length, i, ret = [], tmp, m, j;
		for (i = 0; i < l; i++) {
			tmp = run(this, sels[i]);
			m = tmp.length;
			for (j = 0; j < m; j++) {
				ret.push(tmp[j]);
			}
		}
		return ret;
	};
	document.querySelector = function(sel) {
		var ret = this.querySelectorAll(sel);
		if (ret.length > 0)
			return ret[0];
		else
			return null;
	};
	if (typeof HTMLElement != "undefined") {
		HTMLElement.prototype.querySelector = document.querySelector;
		HTMLElement.prototype.querySelectorAll = document.querySelectorAll;
	} else {
		try {
			dommods_extend.push(function() {
				var a = document.getElementsByTagName("*"), l = a.length, i;
				for (i = 0; i < l; i++) {
					a[i].querySelector = document.querySelector;
					a[i].querySelectorAll = document.querySelectorAll;
				}
			});
		} catch (ex) {

		}
	}
	;
};

var Insert = (function() {

	if (document.createElement("div").insertAdjacentHTML) {
		return {
			before : function(e, h) {
				e.insertAdjacentHTML("beforebegin", h);
			},
			after : function(e, h) {
				e.insertAdjacentHTML("afterend", h);
			},
			atStart : function(e, h) {
				e.insertAdjacentHTML("afterbegin", h);
			},
			atEnd : function(e, h) {
				e.insertAdjacentHTML("beforeend", h);
			}
		};
	}
	;

	function fragment(html) {
		var elt = document.createElement("div");
		var frag = document.createDocumentFragment();
		elt.innerHTML = html;
		while (elt.firstChild)
			frag.appendChild(elt.firstChild);
		return frag;
	}
	;

	var Insert = {
		before : function(elt, html) {
			elt.parentNode.insertBefore(fragment(html), elt);
		},
		after : function(elt, html) {
			elt.parentNode.insertBefore(fragment(html), elt.nextSibling);
		},
		atStart : function(elt, html) {
			elt.insertBefore(fragment(html), elt.firstChild);
		},
		atEnd : function(elt, html) {
			elt.appendChild(fragment(html));
		}
	};

	Element.prototype.insertAdjacentHTML = function(pos, html) {
		switch (pos.toLowerCase()) {
		case "beforebegin":
			return Insert.before(this, html);
		case "afterend":
			return Insert.after(this, html);
		case "afterbegin":
			return Insert.atStart(this, html);
		case "beforeend":
			return Insert.atEnd(this, html);
		}
		;
	};
	return Insert;
}());

var U = {

	_WIN : window,
	_DOC : window.document,

	_DOM : function() {
		if (document.ELEMENT_NODE == null) {
			document.ELEMENT_NODE = 1;
			document.ATTRIBUTE_NODE = 2;
			document.TEXT_NODE = 3;
			document.CDATA_SECTION_NODE = 4;
			document.ENTITY_REFERENCE_NODE = 5;
			document.ENTITY_NODE = 6;
			document.PROCESSING_INSTRUCTION_NODE = 7;
			document.COMMENT_NODE = 8;
			document.DOCUMENT_NODE = 9;
			document.DOCUMENT_TYPE_NODE = 10;
			document.DOCUMENT_FRAGMENT_NODE = 11;
			document.NOTATION_NODE = 12;
		}
		;
	},

	debugging : false,
	debug : function(where, erro) {
		if (U.debugging) {
			alert("local:" + where + "\n" + "description : " + erro.message);
		}
		;
	},
	
	var_dump : function(){
		for(var idump = 0; idump < arguments.length; idump++){
			alert(idump + ": " + arguments[idump]);
			console.log(idump +": "+ arguments[idump]);
		};
	},

	isChrome : function() {
		'use strict';
		return (U._WIN.navigator.userAgent.indexOf("Chrome") >= 0);
	},
	isFirefox : function() {
		'use strict';
		return (U._WIN.navigator.userAgent.indexOf("Firefox") >= 0);
	},
	isSafari : function() {
		'use strict';
		return (U._WIN.navigator.userAgent.indexOf("Safari") >= 0);
	},
	isIE : function() {
		'use strict';
		return (U._WIN.navigator.userAgent.indexOf("MSIE") >= 0);
	},
	isOpera : function() {
		'use strict';
		return (U._WIN.navigator.userAgent.indexOf("Opera") >= 0);
	},
	isArray : function(arr) {
		'use strict';
		return U.isObject(arr) && arr.constructor === Array;
	},
	isFunction : function(func) {
		'use strict';
		return typeof func === 'function';
	},
	isObject : function(object) {
		'use strict';
		return typeof object === 'object';
	},
	isString : function(str) {
		'use strict';
		return typeof str === "string";
	},
	isNull : function(object) {
		'use strict';
		return object === null;
	},
	isUndefined : function(object) {
		'use strict';
		return typeof object === 'undefined';
	},
	isEmail : function(value) {
		'use strict';
		if (U.trim(value) != "") {
			var pattern = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
			return pattern.test(value);
		}
		;
		return false;
	},
	isNumeric : function(value) {
		'use strict';
		if (U.trim(value) != "") {
			return (parseFloat(value, 10) == (value * 1));
		}
		;
		return false;
	},
	isEmpty : function(value) {
		'use strict';
		return U.trim(value) == "";
	},
	isGeo : function() {
		return navigator.geolocation;
	},
	isMobile : function() {
		/* by Marcelo Rodrigues - 15/01/2014 */
		var userAgent = navigator.userAgent.toLowerCase();
		return (userAgent
				.search(/(android|avantgo|blackberry|bolt|boost|cricket|docomo|fone|hiptop|mini|mobi|palm|phone|pie|tablet|up\.browser|up\.link|webos|wos)/i) != -1) ? true
				: false;
	},
	isPhone : function(value) {
		'use strict';
		if (!U.isEmpty(U.trim(value))) {
			var pattern = /^[0-9() -]/
			return pattern.test(value);
		}
		;
		return false;
	},

	isCEP : function(value) {
		'use strict';
		if (!U.isEmpty(U.trim(value))) {
			var pattern = /^[0-9]{5}[-]{1}[0-9]{3}/
			return pattern.test(value);
		}
		;
		return false;
	},

	isCPF : function(value) {

		var cpf = value;
		erro = new String;

		if (cpf.length >= 11) {
			cpf = cpf.replace('.', '');
			cpf = cpf.replace('.', '');
			cpf = cpf.replace('-', '');

			var nonNumbers = /\D/;
			if (nonNumbers.test(cpf)) {
				return false;
			} else {
				if (cpf == "00000000000" || cpf == "11111111111"
						|| cpf == "22222222222" || cpf == "33333333333"
						|| cpf == "44444444444" || cpf == "55555555555"
						|| cpf == "66666666666" || cpf == "77777777777"
						|| cpf == "88888888888" || cpf == "99999999999") {

					return false;
				}

				var a = [];
				var b = new Number;
				var c = 11;

				for (i = 0; i < 11; i++) {
					a[i] = cpf.charAt(i);
					if (i < 9)
						b += (a[i] * --c);
				}

				if ((x = b % 11) < 2) {
					a[9] = 0
				} else {
					a[9] = 11 - x
				}
				b = 0;
				c = 11;

				for (y = 0; y < 10; y++)
					b += (a[y] * c--);

				if ((x = b % 11) < 2) {
					a[10] = 0;
				} else {
					a[10] = 11 - x;
				}

				if ((cpf.charAt(9) != a[9]) || (cpf.charAt(10) != a[10])) {
					return false;
				}
			}
		} else {
			return false;
		}

		return true;

	},

	isCNPJ : function(value) {

		var cnpj = value.replace(/\D+/g, '');

		if (cnpj.length < 14) {
			return false
		}
		;

		if (cnpj == "00000000000000") {
			return false;
		}

		var soma = 0;
		soma = 6 * eval(cnpj.charAt(0));
		soma = soma + (7 * eval(cnpj.charAt(1)));
		soma = soma + (8 * eval(cnpj.charAt(2)));
		soma = soma + (9 * eval(cnpj.charAt(3)));
		soma = soma + (2 * eval(cnpj.charAt(4)));
		soma = soma + (3 * eval(cnpj.charAt(5)));
		soma = soma + (4 * eval(cnpj.charAt(6)));
		soma = soma + (5 * eval(cnpj.charAt(7)));
		soma = soma + (6 * eval(cnpj.charAt(8)));
		soma = soma + (7 * eval(cnpj.charAt(9)));
		soma = soma + (8 * eval(cnpj.charAt(10)));
		soma = soma + (9 * eval(cnpj.charAt(11)));

		var digito_verificador = soma - (11 * Math.floor(soma / 11));

		if (digito_verificador == 10) {
			digito_verificador = 0;
		}
		;

		if (eval(cnpj.charAt(12)) != digito_verificador) {
			return false;
		}
		;

		soma = 5 * eval(cnpj.charAt(0));
		soma = soma + (6 * eval(cnpj.charAt(1)));
		soma = soma + (7 * eval(cnpj.charAt(2)));
		soma = soma + (8 * eval(cnpj.charAt(3)));
		soma = soma + (9 * eval(cnpj.charAt(4)));
		soma = soma + (2 * eval(cnpj.charAt(5)));
		soma = soma + (3 * eval(cnpj.charAt(6)));
		soma = soma + (4 * eval(cnpj.charAt(7)));
		soma = soma + (5 * eval(cnpj.charAt(8)));
		soma = soma + (6 * eval(cnpj.charAt(9)));
		soma = soma + (7 * eval(cnpj.charAt(10)));
		soma = soma + (8 * eval(cnpj.charAt(11)));
		soma = soma + (9 * eval(cnpj.charAt(12)));

		digito_verificador = soma - (11 * Math.floor(soma / 11));

		if (digito_verificador == 10) {
			digito_verificador = 0;
		}
		;

		if (eval(cnpj.charAt(13)) != digito_verificador) {
			return false;
		}
		;

		return true;

	},

	isElementSupporAttribute : function(element, attribute) {
		var test = document.createElement(element);
		return (attribute in test);
	},

	create : function(element, attributes) {
		'use strict';
		if (U.isString(element)) {
			var dom = U._DOC.createElement(element);
			U.attributes(dom, attributes);
			return dom;
		};
		return null;
	},
	
	attributes : function(element, attributes){
		if(U.isObject(element) && U.isArray(attributes)){
			for(var ia=0; ia < attributes.length; ia++){
				element.setAttribute(attributes[ia].name, attributes[ia].value);
			};
		};
	},
	
	append : function(element, child) {
		'use strict';
		if (U.isObject(element) && U.isObject(child)) {
			element.appendChild(child);
		}
		;
	},
	remove : function(element) {
		'use strict';
		if (U.isObject(element)) {
			var father = element.parentNode;
			father.removeChild(element);
		}
		;
	},
	id : function(id) {
		'use strict';
		if (U.isString(id)) {
			return U._DOC.getElementById(id);
		}
		;
		return null;
	},
	name : function(name) {
		'use strict';
		if (U.isString(name)) {
			return U._DOC.getElementsByName(name);
		}
		;
		return null;
	},
	tag : function(tag, element) {
		'use strict';
		if (U.isString(tag)) {
			if(!U.isUndefined(element)){
				return element.getElementsByTagName(tag);
			}else{
				return U._DOC.getElementsByTagName(tag);
			};
		};
		return null;
	},
	getClass : function(className) {
		'use strict';
		if (U.isString(className)) {
			return U._DOC.getElementsByClassName(className);
		}
		;
		return null;
	},
	query : function(query) {
		'use strict';
		if (U.isString(query)) {
			return U._DOC.querySelectorAll(query);
		}
		;
		return null;
	},

	nvl : function(element, nullvalue) {
		if (U.isEmpty(element.value)) {
			element.value = nullvalue;
		}
		;
	},

	trim : function(value) {
		/**
		 * Util.trim("String") // return String;
		 */
		'use strict';
		if (U.isString(value)) {
			return value.replace(/^\s+|\s+$/g, "");
		}
		;
		return null;
	},

	strip : function(value) {
		'use strict';
		var endSpace = new RegExp("^\\s*|\\s*$", "g");
		var multSpace = new RegExp("\\s\\s+", "g");
		value = value.replace(multSpace, ' ');
		value = value.replace(endSpace, '');
		return value;
	},

	stripHTML : function(value) {
		'use strict';
		return value.replace(/(<([^>]+)>)/ig, "")
	},

	encodeHTML : function(str) {
		'use strict';
		var buf = [];
		for ( var i = str.length - 1; i >= 0; i--) {
			buf.unshift([ '&#', str[i].charCodeAt(), ';' ].join(''));
		}
		return buf.join('');
	},

	decodeHTML : function(str) {
		'use strict';
		str = str.replace(/&amp;/g, '&');
		return str.replace(/&#(\d+);/g, function(match, dec) {
			return String.fromCharCode(dec);
		});
	},

	replaceAll : function(string, value, valueto) {
		'use strict';
		return string.replace(/value/g, valueto);
	},

	removeLastChar : function(string) {
		'use strict';
		if (!U.isEmpty(string)) {
			return string.substring(0, string.length - 1);
		}
		;
	},

	toNumber : function(value) {
		try {
			return parseFloat(value.toString().replace(".", "").replace(",",
					"."));
		} catch (ex) {
			return 0;
		}
	},

	toNumberBR : function(value) {
		try {
			return value.toString().replace(",", "").replace(".", ",");
		} catch (ex) {
			alert(ex.description);
			return 0;
		}
	},

	size : function(obj) {
		var size = 0, key;
		for (key in obj) {
			if (obj.hasOwnProperty(key))
				size++;
		}
		return size;
	},

	formatNumber : function(n, c, d, t) {
		// var n = Number,
		try {
			n = n.replace(".", "").replace(",", ".");
			n = parseFloat(n);
			c = isNaN(c = Math.abs(c)) ? 2 : c, d = d == undefined ? "." : d,
					t = t == undefined ? "," : t, s = n < 0 ? "-" : "",
					i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "",
					j = (j = i.length) > 3 ? j % 3 : 0;
			return s + (j ? i.substr(0, j) + t : "")
					+ i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t)
					+ (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
		} catch (ex) {
			return 0;
		}
	},

	getText : function(element) {

		U._DOM();
		var text = "";
		for ( var i = 0, il = element.childNodes.length; i < il; i++) {
			var el = element.childNodes[i];
			if (el.nodeType == document.TEXT_NODE
					|| el.nodeType == document.CDATA_SECTION_NODE
					|| el.nodeType == document.COMMENT_NODE) {
				text += el.nodeValue;
			} else if (el.nodeType == document.ELEMENT_NODE
					&& el.tagName == 'BR') {
				text += ' ';
			} else {
				text += U.getText(el);
			}
			;
		}
		;
		return U.strip(text);

	},

	redirect : function(url) {
		/**
		 * Util.redirect("http://www.google.com");
		 */
		'use strict';
		if (U.isString(url)) {
			U._DOC.location.href = url;
		}
		;
	},

	insertionSort : function(arr_data) {
		var j, index;
		for ( var i = 0, il = arr_data.length; i < il; i++) {
			index = arr_data[i];
			j = i;
			while ((j > 0) && (arr_data[j - 1] > index)) {
				arr_data[j] = arr_data[j - 1];
				j -= 1;
			}
			;
			arr_data[j] = index;
		}
		;
		return arr_data;
	},

	text : function(text) {
		/**
		 * Util.text("descriï¿½ï¿½o de um texto qualquer"); // retorna um
		 * textNode
		 */
		'use strict';
		if (U.isString(text)) {
			return U._DOC.createTextNode(text);
		}
		;

		return null;
	},

	a : function(text, href) {
		var a = U.create("a");
		// U.append(a,U.text(text));
		a.textContent = text;
		a.setAttribute('href', href);
		return a;
	},

	image : function(src) {
		/**
		 * Util.image("//caminho/arquivo.tipo"); // retorna um objeto Image
		 */
		'use strict';
		if (U.isString(src)) {
			var img = new Image();
			img.setAttribute("src", src);
			return img;
		}
		;
		return null;
	},

	printf : function(text) {
		/**
		 * Util.printf("
		 * <li><a href='%s'>%s</a>","http://teste.com","novo link"); // return "
		 * <li><a href='http://teste.com'>novo link</a>";
		 */
		'use strict';
		if (U.isString(text)) {
			var i = 1, args = arguments;
			return text.replace(/%s/g, function() {
				return (i < args.length) ? args[i++] : "";
			});
		}
		;
	},

	DOMParser : function(string) {
		var dom = null;
		if (window.DOMParser) {
			parser = new DOMParser();
			dom = parser.parseFromString(string, "text/xml");
		} else {
			dom = new ActiveXObject("Microsoft.XMLDOM");
			dom.async = false;
			dom.loadXML(string);
		}
		;
	},

	script : function(src) {
		var script = U._DOC.createElement("script");
		script.type = "text/javascript";
		script.src = src;
		U.tag("body")[0].appendChild(script);
	},

	/**
	 * Necessita criar uma instancia desse objeto var email = new Mail();
	 * email.setTo("kllaudyo@gmail.com;claudio.acioli@outlook.com");
	 * email.setBody("Parabéns"); email.send(); var email = null;
	 */
	Mail : function() {

		var to = null;
		var cc = null;
		var bcc = null;
		var subject = null;
		var body = null;

		this.setTo = function(emails) {
			to = emails;
		};

		this.setCC = function(emails) {
			cc = emails;
		};

		this.setBCC = function(emails) {
			bcc = emails;
		};

		this.setSubject = function(text) {
			subject = text;
		};

		this.setBody = function(text) {
			body = encodeURIComponent(text);
		};

		this.make = function() {
			var string = "mailto:" + to + "?";
			if (!U.isNull(cc)) {
				string += "&cc=" + cc;
			}
			;
			if (!U.isNull(bcc)) {
				string += "&bcc=" + bcc;
			}
			;
			if (!U.isNull(subject)) {
				string += "&subject=" + subject;
			}
			;
			if (!U.isNull(body)) {
				string += "&body=" + body;
			}
			;
			return string;
		};

		this.send = function() {
			window.document.location.href = this.make();
		};
	},

	CSS : {

		hasClass : function(ele, cls) {
			return ele.className.match(new RegExp('(\\s|^)' + cls + '(\\s|$)'));
		},

		addClass : function(ele, cls) {
			if (!U.CSS.hasClass(ele, cls))
				ele.className += " " + cls;
		},

		removeClass : function(ele, cls) {
			if (U.CSS.hasClass(ele, cls)) {
				var reg = new RegExp('(\\s|^)' + cls + '(\\s|$)');
				ele.className = ele.className.replace(reg, ' ');
			}
			;
		},

		atual : function() {

			var atual = null;
			var classCss = null;

			this.set = function(elm, cls) {
				classCss = cls;
				if (atual != null) {
					remove();
				}
				;
				atual = elm;
				U.CSS.addClass(atual, classCss);
			};

			var remove = function() {
				U.CSS.removeClass(atual, classCss);
			};
		}
	},

	Url : {

		anchor : function() {
			return U._DOC.location.hash;
		},

		host : function() {
			return U._DOC.location.host;
		},

		path : function() {
			return U._DOC.location.pathname;
		},

		port : function() {
			return U.isEmpty(U._DOC.location.port) ? 80 : U._DOC.location.port;
		},

		protocol : function() {
			return U._DOC.location.protocol;
		},

		request : function() {
			return U._DOC.location.search;
		},

		refresh : function() {
			U._DOC.location.reload(true);
		}

	},

	File : {

		getExtension : function(file) {
			/**
			 * U.File.getExtension("file.js"); return js;
			 */
			'use strict';
			return file.substr(file.lastIndexOf(".") + 1).toLowerCase();
		}
	},

	Geo : {

		Maps : function(mapa) {

			var geocoder;
			geocoder = new google.maps.Geocoder();

			this.options = {
				zoom : 16,
				center : new google.maps.LatLng(-34.397, 150.644),
				mapTypeId : google.maps.MapTypeId.HYBRID
			};

			this.map = new google.maps.Map(mapa, this.options);

			this.setGeoLocation = function() {
				var me = this;
				if (navigator.geolocation) {
					navigator.geolocation
							.getCurrentPosition(function(position) {
								me.setLatLng(position.coords.latitude,
										position.coords.longitude);
							});
				}
				;
			};

			this.setLatLng = function(lat, log) {
				var pos = new google.maps.LatLng(lat, log);
				this.map.setCenter(pos);
			};

			this.search = function(text, marker, msg) {
				var me = this;
				geocoder.geocode({
					'address' : text + ', Brasil'
				}, function(results, status) {
					if (status == google.maps.GeocoderStatus.OK) {
						var pos = results[0].geometry.location;
						me.setCenter(pos);
						if (marker) {
							marker.setPosition(pos);
							marker.setInfo(msg);
						}
						;

					}
					;
				});
			};

			this.setCenter = function(pos) {
				this.map.setCenter(pos);
			};

		},

		Marker : function(map, draggable, callback) {

			this.map = map;
			this.info = null;
			this.drag = (draggable) ? true : false;
			this.callback = (callback) ? callback : null;

			this.create = function() {
				var me = this;

				me.marker = new google.maps.Marker({
					map : me.map.map,
					draggable : me.drag,
					animation : google.maps.Animation.DROP
				});

				me.ondragend();

			};

			this.setInfo = function(text) {
				var me = this;
				if (!me.info) {
					me.info = new google.maps.InfoWindow();
				}
				;
				google.maps.event.addListener(me.marker, 'click', function() {
					me.info.setContent(text);
					me.info.open(me.map.map, this);
				});
			};

			this.ondragend = function() {
				var me = this;
				if (me.callback) {
					google.maps.event.addListener(me.marker, 'dragend',
							function() {
								me.callback(this.getPosition().lat(), this
										.getPosition().lng());
							});
				}
				;
			};

			this.setPosition = function(pos) {
				this.marker.setPosition(pos);
			};

			this.setLatLng = function(lat, lng) {
				var ll = new google.maps.LatLng(lat, lng, false);
				this.setPosition(ll);
			};

		}
	},

	XMPP : {

		connection : null,
		uri : null,
		server : null,
		jid : null,

		init : function() {
			try {
				var scripts = [ 'strophe.js', 'flXHR.js', 'strophe.flxhr.js' ];
				for ( var s = 0; s < scripts.length; s++) {
					U.script("_script/_library/" + scripts[s]);
				}
				;
			} catch (ex) {
				U.debug("XMPP.init", ex);
			}
			;
			return true;
		},

		connect : function() {
			try {
				U.XMPP.connection = new Strophe.Connection(U.XMPP.uri);
			} catch (ex) {
				U.debug("XMPP.connect", ex);
			}
			;
			return true;
		},

		login : function(username, password) {
			try {
				if (!U.isEmpty(username) && !U.isEmpty(password)) {
					U.XMPP.jid = username + "@" + U.XMPP.server;
					U.XMPP.connection.connect(U.XMPP.jid, password,
							U.XMPP.status);
				}
				;
			} catch (ex) {
				U.debug("XMPP.login", ex);
			}
			;
			return true;
		},

		status : function(status) {
			try {
				switch (status) {
				case Strophe.Status.CONNECTED:
					U.XMPP.Event.onlogged();
					U.XMPP.set();
					break;
				case Strophe.Status.AUTHFAIL:
					U.XMPP.Event.onfail();
					break;
				case Strophe.Status.DISCONNECTED:
					U.XMPP.Event.onlogout();
					break;
				default:

				}
				;
			} catch (ex) {
				U.debug("XMPP.status", ex);
			}
			;
			return true;
		},

		set : function() {
			try {
				U.XMPP.iq();
				U.XMPP.connection.addHandler(U.XMPP.Event.onchangeroster,
						"jabber:iq:roster", "iq", "set");
				U.XMPP.connection.addHandler(U.XMPP.Event.onmensagechat, null,
						"message", "chat");
				U.XMPP.presence();
			} catch (ex) {
				U.debug("XMPP.set", ex);
			}
			;
			return true;
		},

		iq : function() {
			try {
				U.XMPP.connection.sendIQ($iq({
					type : "get",
					to : U.XMPP.server
				}).c("query", {
					xmlns : "jabber:iq:roster"
				}), U.XMPP.Event.onroster);
			} catch (ex) {
				U.debug("XMPP.iq", ex);
			}
			;
			return true;
		},

		presence : function() {
			try {

				U.XMPP.connection.send($build("presence", {
					to : U.XMPP.server
				}));
				return true;

			} catch (ex) {
				U.debug("XMPP.presence", ex);
			}
			;
			return true;
		},

		subscribe : function(jid, name) {
			try {

				U.XMPP.connection.sendIQ($id({
					type : "set",
					to : U.XMPP.server
				}).c("query", {
					xmlns : "jabber:iq:roster"
				}).c("item", {
					jid : jid + "@" + U.XMPP.server,
					name : name
				}));

				U.XMPP.connection.send($pres({
					to : jid + "@" + U.XMPP.server,
					"type" : "subscribe"
				}));

			} catch (ex) {
				U.debug("XMPP.subscribe", ex);
			}
			;
			return true;
		},

		accept : function() {
			try {
				U.XMPP.connection.send($pres({
					to : from,
					"type" : "subscribed"
				}));
			} catch (ex) {
				U.debug("XMPP.accept", ex);
			}
			;
			return true;
		},

		block : function() {
			try {
				U.XMPP.connection.send($pres({
					to : from,
					"type" : "unsubscribed"
				}));
			} catch (ex) {
				U.debug("XMPP.block", ex);
			}
			;
			return true;
		},

		mensage : function(jid, body) {
			try {
				U.XMPP.connection.send($msg({
					to : jid + "@" + U.XMPP.server,
					"type" : "chat"
				}).c("body").t(body));
			} catch (ex) {
				U.debug("XMPP.mensage", ex);
			}
			;
			return true;
		},

		Event : {

			/**
			 * Definido pelo usuÃ¡rio.
			 */

			onpresence : function(oPresence) {
				try {

					var type = oPresence.getAttribute("type");
					var from = oPresence.getAttribute("from");

					switch (type) {
					case "subscribe":
						U.XMPP.Event.onsubscribe(oPresence);
						break;
					case "available":
						break;
					case "unavailable":
						break;
					case "error":
						break;
					}
					;

				} catch (ex) {
					U.debug("XMPP.Event.onpresence", ex);
				}
				;
				return true;

				var type = oPresence.getAttribute("type");
				var from = oPresence.getAttribute("from");
				switch (type) {
				case "subscribe":
					if (confirm("aceita ser amigo de " + from + "?")) {
						me.user.send($pres({
							to : from,
							"type" : "subscribed"
						}));
					} else {
						me.user.send($pres({
							to : from,
							"type" : "unsubscribed"
						}));
					}
					;
					break;
				case "unavailable":
					break;
				case "error":
					break;
				default:
					alert(from);

				}
				;
				return true;

			},

			onroster : function(oRoster) {
				try {
					U.XMPP.connection.addHandler(U.XMPP.Event.onpresence, null,
							"presence");
				} catch (ex) {
					U.debug("XMPP.Event.onroster", ex);
				}
				;
				return true;
			},
			onchangeroster : function(oRoster) {
			},

			onlogged : function() {
			},
			onlogout : function() {
			},
			onfail : function() {
			},
			onmensagechat : function(oMessage) {
			},
			onsubscribe : function(oPresence) {
			}

		}
	},

	Xmpp : {

		uri : null,
		server : null,

		load : function() {
			var scripts = [ 'strophe.js', 'flXHR.js', 'strophe.flxhr.js' ];
			for ( var s = 0; s < scripts.length; s++) {
				U.script("_script/_library/" + scripts[s]);
			}
			;
		},

		User : function(callbackMsg) {

			this.user = null;
			var me = this;

			this.login = function(email, password) {

				try {
					var parent = this;
					var con = new Strophe.Connection(U.Xmpp.uri);
					con.connect(email, password, function() {

						var status = arguments[0];
						switch (status) {
						case Strophe.Status.CONNECTED:
							parent.user = con;
							parent.onlogin();
							parent.init();
							break;
						case Strophe.Status.AUTHFAIL:
							parent.onfailauth();
							break;
						case Strophe.Status.DISCONNECTED:
							parent.onlogout();
							break;
						default:
							this.onfaillogin();
						}
						;

					});
				} catch (ex) {
					alert(ex);
				}
				return true;
			};

			this.init = function() {
				this.iq();
				this.user.addHandler(me.onrosterchanged, "jabber:iq:roster",
						"iq", "set");
				this.user.addHandler(me.onmensage, null, "message", "chat");
				this.presence();
			};

			this.iq = function() {
				var iq = $iq({
					type : "get",
					to : U.Xmpp.server
				}).c("query", {
					xmlns : "jabber:iq:roster"
				});
				this.user.sendIQ(iq, this.onroster);
				return true;

			};

			this.presence = function() {
				var pres = $build("presence", {
					to : U.Xmpp.server
				});
				this.user.send(pres);
				// return true;
			};

			this.add = function(id, name) {
				var d = {
					jid : id,
					name : name
				};
				var iq = $iq({
					type : "set",
					to : U.Xmpp.server
				}).c("query", {
					xmlns : "jabber:iq:roster"
				}).c("item", d);
				this.user.sendIQ(iq);
				var subscribe = $pres({
					to : d.jid,
					"type" : "subscribe"
				});
				this.user.send(subscribe);
				return true;
			};

			this.mensage = function(id, msg) {
				me.user.send($msg({
					to : id,
					"type" : "chat"
				}).c("body").t(msg));
				return true;
			};

			this.onmensage = function(oMsg) {
				if (U.isFunction(callbackMsg)) {
					callbackMsg(oMsg);
				}
				return true;
			};

			this.onroster = function(oIq) {
				// var iqs = oIq.childNodes[0].childNodes;
				// for(var i=0; i<iqs.length; i++){
				// alert(iqs[i].getAttribute("name"));
				// };
				me.user.addHandler(me.onpresence, null, "presence");

			};

			this.onpresence = function(oPresence) {
				var type = oPresence.getAttribute("type");
				var from = oPresence.getAttribute("from");
				switch (type) {
				case "subscribe":
					if (confirm("aceita ser amigo de " + from + "?")) {
						me.user.send($pres({
							to : from,
							"type" : "subscribed"
						}));
					} else {
						me.user.send($pres({
							to : from,
							"type" : "unsubscribed"
						}));
					}
					;
					break;
				case "unavailable":
					break;
				case "error":
					break;
				default:
					alert(from);

				}
				;
				return true;
			};

			this.onrosterchanged = function(oIq) {
				// alert(oIq);
				return true;
			};

			this.onlogin = function() {
				alert("XMPP:connected");
			};

			this.onlogout = function() {
				alert("XMPP:not connected");
			};

			this.onfailauth = function() {
				alert("XMPP:authentication fail");
			};

			this.onfaillogin = function() {
				alert("XMPP:error on connection");
			};

		}
	},

	Date : {

		today : function() {
			'use strict';
			return new Date();
		},

		addDay : function(date, days) {
			'use strict';
			date.setDate(date.getDate() + days);
		},

		addMonth : function(date, months) {
			'use strict';
			date.setMonth(date.getMonth() + months);
		},

		addYear : function(date, years) {
			'use strict';
			date.setFullYear(date.getFullYear() + years);
		},

		getMes : function(mes) {
			'use strict';
			switch (mes) {
			case 0:
				return [ "01", "janeiro", "jan" ];
			case 1:
				return [ "02", "fevereiro", "fev" ];
			case 2:
				return [ "03", "marï¿½o", "mar" ];
			case 3:
				return [ "04", "abril", "abr" ];
			case 4:
				return [ "05", "maio", "mai" ];
			case 5:
				return [ "06", "junho", "jun" ];
			case 6:
				return [ "07", "julho", "jul" ];
			case 7:
				return [ "08", "agosto", "ago" ];
			case 8:
				return [ "09", "setembro", "set" ];
			case 9:
				return [ "10", "outubro", "out" ];
			case 10:
				return [ "11", "novembro", "nov" ];
			case 11:
				return [ "12", "dezembro", "dez" ];
			}
		},

		getSemana : function(diaSemana) {
			'use strict';
			switch (diaSemana) {
			case 0:
				return [ "domingo", "dom" ];
			case 1:
				return [ "segunda", "seg" ];
			case 2:
				return [ "terï¿½a", "ter" ];
			case 3:
				return [ "quarta", "qua" ];
			case 4:
				return [ "quinta", "qui" ];
			case 5:
				return [ "sexta", "sex" ];
			case 6:
				return [ "sï¿½bado", "sab" ];
			}
		}
	},

	Rest : {

		GET : function(url, data, callback) {

			'use strict';

			var ajax = U.Ajax.http();
			ajax.open("GET", url + "?" + U.Ajax.query(data));
			ajax.onreadystatechange = function() {
				if (ajax.readyState === 4 && callback) {
					callback(ajax);
				}
				;
			};
			ajax.send(null);
		},

		POST : function(url, data, callback) {

			'use strict';

			var httpMethod = (!U.isUndefined(arguments[3])) ? "POST"
					: arguments[3].toString();

			var ajax = U.Ajax.http();
			ajax.open(httpMethod, url);
			ajax.onreadystatechange = function() {
				if (ajax.readyState === 4 && callback) {
					callback(ajax);
				}
				;
			};
			ajax.setRequestHeader('Content-Type',
					'application/x-www-form-urlencoded');
			ajax.send(U.Ajax.query(data));

		},

		PUT : function(url, data, callback) {
			U.Rest.POST(url, data, callback, "PUT");
		},

		DELETE : function(url, data, callback) {
			U.Rest.POST(url, data, callback, "DELETE");
		}
	},

	Ajax : {

		http : function() {

			/**
			 * Util.Ajax.http() //return new XMLHttpRequest;
			 */

			'use strict';

			if (U.isUndefined(window.XMLHttpRequest)) {
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
									return new ActiveXObject(
											"Microsoft.XMLHTTP");
								} catch (e4) {
									throw new Error(
											"XMLHttpRequest is not supported");
								}
								;
							}
							;
						}
						;
					}
					;
				};
			}
			;

			return new XMLHttpRequest();

		},

		query : function(data) {

			'use strict';

			if (!data) {
				var pairs = [];
				for ( var name in data) {
					if (!data.hasOwnProperty(name))
						continue;
					if (typeof data[name] === "function")
						continue;
					var value = data[name].toString();
					name = encodeURIComponent(name.replace(" ", "+"));
					value = encodeURIComponent(value.replace(" ", "+"));
					pairs.push(name + "=" + value);
				}
				;
				return pairs.join('&');
			}
			;
		},

		returnType : function(type, ajax) {
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
			}
			;
		},

		execute : function(options) {

			/**
			 * option = { url : string, // 'URL', query : string or
			 * U.Ajax.query({param1 : valor, param2 : valor}); method : string,
			 * //'GET','POST','PUT','DELETE','UPDATE' assincrony : boolean,
			 * //true|| false oncallback : function //function(retorno){}
			 * returnType : string // 'JSON','XML','TEXT','HTML' };
			 */

			'use strict';

			if (U.isObject(options)) {

				if (!U.isString(options.url))
					return false;
				options.method = options.method ? options.method : 'GET';
				options.url += options.method === 'GET' ? (options.query ? '?'
						+ options.query : '') : '';
				options.assincrony = options.assincrony ? true : false;
				options.returnType = U.isString(options.returnType) ? options.returnType
						: 'HTML';
				options.header_accept = options.accept ? options.accept : false;

				options.onloading = U.isFunction(options.onloading) ? options.onloading
						: function() {
						};
				options.onloaded = U.isFunction(options.onloaded) ? options.onloaded
						: function() {
						};
				options.oninteractive = U.isFunction(options.oninteractive) ? options.oninteractive
						: function() {
						};
				options.isExecuteCallback = U.isFunction(options.oncallback);
				options.oncallback = options.isExecuteCallback ? options.oncallback
						: function() {
						};

				var ajax = U.Ajax.http();

				ajax.open(options.method, options.url, options.assincrony);
				if (options.header_accept) {
					ajax.setRequestHeader("Accept", options.header_accept);
				}
				;

				if (options.method === 'GET') {
					ajax.send(null);
				} else {
					ajax.setRequestHeader('Content-Type',
							'application/x-www-form-urlencoded');
					ajax.send(options.query);
				}
				;

				if (!options.assincrony) {
					return U.Ajax.returnType(options.returnType, ajax);
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
									options.oncallback(U.Ajax.returnType(
											options.returnType, ajax));
								}
								;
							}
							;
							break;
						}
						;
					};
				}
				;

			}
			;

		},

		beacon : function(url, params, callback) {
			'use strict';
			var p;
			switch (typeof params) {
			case "string":
				p = params;
				break;
			case "object":
				p = params.join('&');
				break;
			default:
				return;
			}

			var img = new Image();
			(img).src = url + '?' + p;

			if (U.isFunction(callback)) {

				img.onload = function() {
					callback(img.width);
				};

				img.onerror = function() {
					callback(img.width);
				};

			}
			;

		},

		upload : function(options) {

			var iframe = null;
			var form = options.form;

			var settings = function() {

				try {
					iframe = U.name("upload_iframe")[0];
				} catch (ex) {
					iframe = null;
				}
				;

				if (iframe == null) {

					iframe = U.create("iframe");
					iframe.setAttribute("width", "0");
					iframe.setAttribute("height", "0");
					iframe.setAttribute("border", "0");
					iframe.setAttribute("name", "upload_iframe");
					iframe.style.width = "0px";
					iframe.style.height = "0px";
					iframe.style.border = "none";

					form.parentNode.appendChild(iframe);

				}
				;

				form.target = iframe.getAttribute("name");
				// form.enctype = "Multipart/Form-Data";
				// form.setAttribute("enctype","multipart/form-data");
				// form.setAttribute("encoding","multipart/form-data");

			};

			settings();
			form.submit();
			// options.submit.click();
			U.Event.add(iframe, "load", function() {
				var body = iframe.contentWindow.document || iframe.document;
				options.callback(body.body.innerHTML);
			});

		}

	},

	Json : {

		parser : function(string) {
			'use strict';
			if (U.isString(string) && !U.isEmpty(string)) {
				return eval("(" + string + ")");
			}
			;
		},

		Min : {
			parser : function(string, delimiter_row, delimiter_cell) {
				if (U.isString(string) && !U.isEmpty(string)) {
					var arr = string.split(delimiter_row);
					var cnt = arr.length;
					for ( var i = 0; i < cnt; i++) {
						arr[i] = arr[i].split(delimiter_cell);
					}
					;
					return arr;
				}
				;
			}
		},

		filterCustomFormat : function(search, json) {
			if (U.trim(search) != "") {
				var arr = json.split(";");
				var count = arr.length;
				var js = "";
				for ( var i = 0; i < count; i++) {
					if (arr[i].toUpperCase().indexOf(search.toUpperCase()) > -1) {
						js += arr[i] + ';';
					}
					;
				}
				;
				return js.substring(0, js.length - 1);
			}
			;
			return json;
		},

		sortCustomFormat : function(array, index) {

			var number = function(a, b) {
				return a[index] - b[index];
			};

			var alpha = function(a, b) {
				a = a[index].toString().toLowerCase();
				b = b[index].toString().toLowerCase();
				return ((a < b) ? -1 : ((a > b) ? 1 : 0));
			};
			// perigoso, avalidar depois
			if (U.isNumeric(array[0][index])) {
				array.sort(number);
			} else {
				array.sort(alpha);
			}
			;

		}
	},

	Event : {

		add : function(eventTarget, eventType, eventHandler) {
			/**
			 * Util.Event.add(Object, "click", functionCallback); //add event on
			 * object;
			 */
			'use strict';
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

		remove : function(eventTarget, type, eventHandler) {
			/**
			 * Util.Event.remove(Object, "click", functionSetted); //remove
			 * event.
			 */
			'use strict';
			if (eventTarget && eventTarget.removeEventListener) {
				eventTarget.removeEventListener(type, eventHandler, false);
			} else if (eventTarget && eventTarget.detachEvent) {
				eventTarget.detachEvent('on' + type, eventHandler);
			};
		},

		cancel : function(event) {
			'use strict';
			try {
				if (event.preventDefault) {
					event.preventDefault();
				} else {
					event.returnValue = false;
				}
				;
			} catch (ex) {
				window.event.returnValue = false;
			}
			;
		},

		getAscii : function(event) {
			return event.keyCode || event.which;
		},

		getTarget : function(event) {
			return event.target || event.srcElement;
		},

		onHashChange : function(callback) {
			if (U.isFunction(callback)) {
				U._WIN.onhashchange = callback;
			}
			;
		},

		onHelp : function(element, callback) {
			if (U.isObject(element) && U.isFunction(callback)) {
				if (U.isIE()) {
					U.Event.add(element, "help", function() {
						var evt = arguments[0];
						U.Event.cancel(evt);
						callback();
					});
				} else {
					U.Event.add(element, "keydown", function() {
						var evt = arguments[0];
						if (U.Event.getAscii(evt) == 112) {
							callback();
							U.Event.cancel(evt);
						}
						;
					});
				}
				;
			}
			;
		}

	},

	Cookie : {

		isEnable : function() {
			'use strict';
			return window.navigator.cookieEnabled;
		},

		get : function(name) {
			/**
			 * Util.Cookie.get(name); // string with value of cookie;
			 */
			'use strict';
			var i, x, y, ARRcookies = U._DOC.cookie.split(";");
			for (i = 0; i < ARRcookies.length; i++) {
				x = ARRcookies[i].substr(0, ARRcookies[i].indexOf("="));
				y = ARRcookies[i].substr(ARRcookies[i].indexOf("=") + 1);
				x = x.replace(/^\s+|\s+$/g, "");
				if (x == name) {
					return unescape(y);
				}
				;
			}
			;
		},

		set : function(name, value) {
			/**
			 * Util.Cookie.set(name, value); //add cookie on browser;
			 */
			'use strict';
			var exdate = new Date();
			exdate.setDate(exdate.getDate() + 1);
			var c_value = escape(value)
					+ ((1 == null) ? "" : "; expires=" + exdate.toUTCString());
			U._DOC.cookie = name + "=" + c_value;
		}

	},

	Combo : {

		Options : {

			get : function(combo) {

				/**
				 * Util.Combo.Option.get(Object); // return Object Collection
				 * Options;
				 */
				'use strict';
				return combo.options;
			},

			add : function(combo, value, text) {

				/**
				 * Util.Combo.Option.add(Object, value, text); // add option in
				 * combo;
				 */
				'use strict';
				var opt = U.create('option');
				var txt = U.text(text);
				opt.value = value;
				opt.appendChild(txt);
				combo.appendChild(opt);
			},

			length : function(combo) {
				/**
				 * Util.Combo.Option.length(Object); // return count options in
				 * Combo;
				 */
				'use strict';
				return combo.options.length;
			},

			selected : function(combo, value) {
				/**
				 * Util.Combo.Option.selected(Object. value); // selected in
				 * combo;
				 */
				'use strict';
				var opts = this.get(combo);
				var len = this.length(combo);
				for ( var i = 0; i < len; i++) {
					var opt = opts[i];
					if (value == opt.value) {
						opt.selected = true;
						break;
					}
					;
				}
				;
			},

			removeAll : function(combo) {
				/**
				 * Util.Combo.Option.removeAll(Object); // Clear options of
				 * Combo;
				 */
				'use strict';
				var len = this.length(combo);
				while (len) {
					combo.removeChild(combo.options[0]);
					len--;
				}
				;
			}

		},

		setJsonOption : function(combo, json) {
			/**
			 * Util.Combo.setJsonOption(Object, jsonCode); // set json to
			 * option;
			 */
			'use strict';
			for ( var i = 0; i < json.length; i++) {
				this.Options.add(combo, json[i].value, json[i].text);
			}
			;
		}

	},

	Form : {

		checkedIndexRadio : function(object) {
			'use strict';
			var len = object.length;
			for ( var r = 0; r < len; r++) {
				if (object[r].checked) {
					return r;
				}
				;
			}
			;
			return -1;
		},

		checkedValueRadio : function(object) {
			'use strict';
			var len = object.length;
			for ( var r = 0; r < len; r++) {
				if (object[r].checked) {
					return object[r].value;
				}
				;
			}
			;
			return null;
		},

		encode : function(name, value) {
			/**
			 * Util.Form.encode("parametro","valor"); // retorna o parametro
			 * codificado;
			 */
			'use strict';
			var param = encodeURIComponent(name);
			param += "=";
			param += encodeURIComponent(value);
			return param;

		},

		Type : {
			number : function() {
				var e = U.Event.getAscii(arguments[0]);
				var k = e.keyCode || e.wich || e.charCode;
				if (k == 8 || k == 9 || k == 13 || k == 16 || k == 20
						|| k == 46) {
					return true;
				}
				var txt = String.fromCharCode(k);
				if (txt) {
					var re = /^[0-9]/;
					if (!txt.match(re)) {
						U.Event.cancel(arguments[0]);
					}
					;
				}
				;
			}
		},

		query : function(form) {
			/**
			 * U.Form.query(ObjetoFormulario); // retorna todos os parametros de
			 * um formulï¿½rio em formato url exemplo do retorno :
			 * parametro=1&parametro1=2&outro=3
			 */
			'use strict';
			var aParams = new Array();
			var oForm = form;
			for ( var i = 0; i < oForm.elements.length; i++) {
				var oField = oForm.elements[i];
				switch (oField.type) {
				case "button":
				case "submit":
				case "reset":
					break;
				case "checkbox":
				case "radio":
					if (!oField.checked) {
						break;
					}
				case "text":
				case "hidden":
				case "password":
					aParams.push(U.Form.encode(oField.name, oField.value));
					break;
				default:
					switch (oField.tagName.toLowerCase()) {
					case "select":
						aParams.push(U.Form.encode(oField.name,
								oField.options[oField.selectedIndex].value));
						break;
					default:
						aParams.push(U.Form.encode(oField.name, oField.value));
					}
				}
			}
			return aParams.join("&");
		},

		validationXML : function(fileXML, form, callback) {

			try {

				var objXML = U.Ajax.execute({
					"url" : fileXML,
					"returnType" : "XML"
				});

				var root = objXML.documentElement;
				var inp = root.getElementsByTagName("input");

				U.Event
						.add(
								form,
								"submit",
								function() {

									for ( var i = 0; i < inp.length; i++) {

										var input = inp[i];
										for ( var j = 0; j < input.childNodes.length; j++) {

											var validation = input.childNodes[j];

											if (validation.nodeType == document.ELEMENT_NODE) {

												var e = U.id(input
														.getAttribute("id"));

												if (U.isObject(e)
														&& !U.isNull(e)) {
													if (!e.disabled) {
														var msg = validation
																.getAttribute("message");
														switch (validation.nodeName) {
														case "required":
															if (U
																	.isEmpty(e.value)) {
																callback(e, msg);
																U.Event
																		.cancel(arguments[0]);
																return;
															}
															;
															break;
														case "mail":
															if (!U
																	.isEmpty(e.value)) {
																if (!U
																		.isEmail(e.value)) {
																	callback(e,
																			msg);
																	U.Event
																			.cancel(arguments[0]);
																	return;
																}
																;
															}
															;
															break;
														case "cnpj":
															if (!U
																	.isEmpty(e.value)) {
																if (!U
																		.isCNPJ(e.value)) {
																	callback(e,
																			msg);
																	U.Event
																			.cancel(arguments[0]);
																	return;
																}
																;
															}
															;
															break;
														case "cpf":
															if (!U
																	.isEmpty(e.value)) {
																if (!U
																		.isCPF(e.value)) {
																	callback(e,
																			msg);
																	U.Event
																			.cancel(arguments[0]);
																	return;
																}
																;
															}
															;
															break;
														case "cep":
															if (!U
																	.isEmpty(e.value)) {
																if (!U
																		.isCEP(e.value)) {
																	callback(e,
																			msg);
																	U.Event
																			.cancel(arguments[0]);
																	return;
																}
																;
															}
															;
															break;
														case "phone":
															if (!U
																	.isEmpty(e.value)) {
																if (!U
																		.isPhone(e.value)) {
																	callback(e,
																			msg);
																	U.Event
																			.cancel(arguments[0]);
																	return;
																}
																;
															}
															;
															break;
														}
														;
													}
													;
												}
												;
											}
											;

										}
										;

									}
									;

								});

			} catch (ex) {
				alert(ex.description);
			}

		},

		validation : function(form, callback) {

			var f = U.isObject(form) ? form : U.id(form);

			if (U.isObject(f)) {
				var e = f.elements;
				var l = e.length;
				for ( var i = 0; i < l; i++) {
					var disabled = (e[i].disabled) ? true : false;
					if (e[i].getAttribute('data-validation') && !disabled) {
						var att = eval(e[i].getAttribute("data-validation"));
						var l_att = att.length;
						for ( var j = 0; j < l_att; j++) {
							switch (att[j]) {
							case "NULL":
								switch ((e[i].nodeName).toUpperCase()) {
								case "INPUT":
									switch ((e[i].type).toUpperCase()) {
									case "TEXT":
										if (U.isEmpty(e[i].value)) {
											callback(
													e[i],
													e[i]
															.getAttribute("data-msgnull"));
											return false;
										}
										;
										break;
									case "RADIO":
										var name = e[i].getAttribute("name");
										var obj = U.name(name);
										var bNull = true;
										for ( var x = 0; x < obj.length; x++) {
											if (obj[x].checked) {
												bNull = false;
												break;
											}
											;
										}
										;

										if (bNull) {
											callback(
													e[i],
													e[i]
															.getAttribute("data-msgnull"));
											return false;
										}
										;

										break;

									default:
										if (U.isEmpty(e[i].value)) {
											callback(
													e[i],
													e[i]
															.getAttribute("data-msgnull"));
											return false;
										}
										;
										break;
									}
									;

									break;

								case "SELECT":

									if (U.isEmpty(e[i].value)) {
										callback(e[i], e[i]
												.getAttribute("data-msgnull"));
									}
									;

									break;

								}
								;
								break;
							case "MAIL":
								if (!U.isEmail(e[i].value)) {
									callback(e[i], e[i]
											.getAttribute("data-msgmail"));
									return false;
								}
								;
								break;
							case "PASSWORD":
								break;
							case "CONFIRM_PASSWORD":
								break;
							case "CNPJ":
								break;
							}
							;
						}
						;
					}
					;
				}
				;
				return true;
			}
			;
			return false;
		}

	},

	Table : {

		search : function(table, text) {

		},

		sort : function(tableID, n, comparator) {

			var rows = U.query("#" + tableID + " tbody tr");

			rows = Array.prototype.slice.call(rows, 0);
			rows.sort(function(row1, row2) {
				var cell1 = row1.getElementsByTagName("td")[n];
				var cell2 = row2.getElementsByTagName("td")[n];
				var val1 = cell1.textContent || cell1.innerText;
				var val2 = cell2.textContent || cell2.innerText;
				if (comparator)
					return comparator(val1, val2);
				if (val1 < val2)
					return -1;
				else if (val1 > val2)
					return 1;
				else
					return 0;
			});

			return rows;

		},

		Tbody : {

			allRows : function(table) {
				var len = table.tBodies.length;
				var rows = [];
				for ( var i = 0; i < len; i++) {
					var len_rows = table.tBodies[i].rows.length;
					for ( var j = 0; j < len_rows; j++) {
						rows.push(table.tBodies[i].rows[j]);
					}
					;
				}
				;
				return rows;
			},

			removeAll : function(table) {
				if (U.isObject(table)) {
					while (table.tBodies.length) {
						table.removeChild(table.tBodies[0]);
					}
					;
				}
				;
			},

			pagination : function(table, rows, size) {

				U.Table.Tbody.removeAll(table);
				for ( var i = 0, c = 0; i < rows.length && c <= size; i++, c++) {
					if (c == 0 || c == size) {
						c = 0;
						var tb = U.create("tbody");
						table.appendChild(tb);
					}
					;
					tb.appendChild(rows[i]);
				}
				;

			}
		},

		Tr : {

			remove : function(tr) {
				if (U.isObject(tr)) {
					tr.parentNode.removeChild(tr);
				}
				;
			},

			removeAll : function(table) {
				if (U.isObject(table)) {
					while (table.rows.length) {
						table.removeChild(table.rows[0]);
					}
					;
				}
				;
			}

		}

	},

	SearchTable : function() {

		this.table = function() {

			var table = arguments[0];
			if (table) {
				var tb = table;
				var len = table.tBodies.length;
				var row = [];
				for ( var i = 0; i < len; i++) {
					var len_rows = table.tBodies[i].rows.length;
					for ( var j = 0; j < len_rows; j++) {
						row.push(table.tBodies[i].rows[j]);
					}
					;
					// row.push(Array.prototype.slice.call(table.tBodies[i].rows));
					// row.push(table.tBodies[i].rows);
				}
				;
				this.rows = row;
				// this.rows = tb.tBodies.rows;
				this.rows_length = this.rows.length;
				this.rows_text = [];
				for ( var i = 0; i < this.rows_length; i++) {
					try {
						// alert(this.rows[i]);
						this.rows_text[i] = (this.rows[i].textContent) ? this.rows[i].textContent
								.toUpperCase()
								: this.rows[i].innerText.toUpperCase();
						// this.rows_text[i] +=
						// (this.rows[i].getAttribute("search")) ?
						// this.rows[i].getAttribute("search").toUpperCase() :
						// '';
					} catch (ex) {
						// U.debugging = true;
						// U.debug("for text", ex);
					}
				}
				;
			}
			;

		};

		this.set = function() {
			this.term = arguments[0].toUpperCase();
			for ( var i = 0, row; row = this.rows[i],
					row_text = this.rows_text[i]; i++) {
				row.style.display = ((row_text.indexOf(this.term) != -1) || this.term === '') ? ''
						: 'none';
				// alert(row.parentNode);
				// row.parentNode.style.display = row.style.display;
			}
			;
			this.time = false;
		};

		this.get = function(evt, value) {
			var ascii = U.Event.getAscii(arguments[0]);
			this.set(value);
		};
	}

};
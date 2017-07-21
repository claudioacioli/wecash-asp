/*
* @author Claudio Acioli <kllaudyo@gmail.com>
* @version 1.0
* @package includes.script
*/

var validation = function(){};

validation.NULL = "NULL";
validation.INT = "NUMBER";
validation.DATE = "DATE";
validation.MAIL = "MAIL";
validation.CNPJ = "CNPJ";
validation.CPF = "CPF";
validation.GROUP = "GROUP";

validation.EXISTS = "EXISTS";
validation.CONFIRM = "CONFIRM";
validation.MIN_LENGTH = "MIN_LENGTH";

validation.submit = function (oFormOrId) {
    var f = (acioli.isObject(oFormOrId)) ? oFormOrId : acioli.id(oFormOrId);
    var e = f.elements;
    var l = e.length;
    for (var i = 0; i < l; i++) {

        var disabled = (e[i].disabled) ? true : false;

        if (e[i].getAttribute('validation') && !disabled) {

            var att = eval(e[i].getAttribute('validation'));
            var latt = att.length;
            for (var j = 0; j < latt; j++) {
                switch (att[j]) {
                    case validation.NULL:
                        switch (e[i].nodeName) {
                            case "INPUT":
                                switch ((e[i].type).toUpperCase()) {
                                    case "TEXT":
                                        if (validation.isEmpty(e[i].value)) {
                                            alert(e[i].getAttribute("msgnull"));
                                            e[i].focus();
                                            return false;
                                        };
                                        break;
                                    case "RADIO":
                                        var name = e[i].getAttribute("name");
                                        var obj = document.getElementsByName(name);
                                        var bNull = true;
                                        for (var x = 0; x < obj.length; x++) {
                                            if (obj[x].checked) {
                                                bNull = false;
                                                break;
                                            }
                                        }

                                        if (bNull) {
                                            alert(e[i].getAttribute("msgnull"));
                                            e[i].focus();
                                            return false;
                                        }
                                        break;
                                    default:
                                        if (validation.isEmpty(e[i].value)) {
                                            alert(e[i].getAttribute("msgnull"));
                                            e[i].focus();
                                            return false;
                                        };
                                        break;
                                }

                                break;
                            case "SELECT":
                                if (validation.isEmpty(e[i].value)) {
                                    alert(e[i].getAttribute("msgnull"));
                                    e[i].focus();
                                    return false;
                                };
                                break;
                        }

                        break;
					
					case validation.GROUP:
						if (!validation.isEmpty(e[i].value)) {
							if (!validation.inGroup(e[i])) {
                                alert(e[i].getAttribute("msggroup"));
                                e[i].focus();
                                return false;
                            };
						};
						break;
                    case validation.MAIL:
                        if (!validation.isEmpty(e[i].value)) {
                            if (!validation.isMail(e[i].value)) {
                                alert(e[i].getAttribute("msgmail"));
                                e[i].focus();
                                return false;
                            };
                        }
                        break;
                    case validation.EXISTS:
                        if (!validation.isEmpty(e[i].value)) {
                            var url = e[i].getAttribute('url_exists');
                            if (validation.isExists(url, e[i].value)) {
                                alert(e[i].getAttribute("msgexists"));
                                e[i].focus();
                                return false;
                            };

                        }
                        break;

                    case validation.CNPJ:
                        if (!validation.isEmpty(e[i].value)) {
                            if (!validation.isCnpj(e[i].value)) {
                                alert(e[i].getAttribute("msgcnpj"));
                                e[i].focus();
                                return false;
                            }
                        }
                        break;
                    case validation.CONFIRM:
                        if (!validation.isEmpty(e[i].value)) {
                            var id = e[i].getAttribute('validateiddependence');
                            var comp = document.getElementById(id);
                            if (!validation.isEqual(e[i].value, comp.value)) {
                                alert(e[i].getAttribute("msgconfirm"));
                                e[i].focus();
                                return false;
                            }
                        }
                        break;
                    case validation.MIN_LENGTH:
                        if (!validation.isEmpty(e[i].value)) {
                            if (validation.isMin(e[i].value, e[i].getAttribute('minlength'))) {
                                alert(e[i].getAttribute("msglenght"));
                                e[i].focus();
                                return false;
                            }
                        }
                        break;
					case validation.CPF:
						if (!validation.isEmpty(e[i].value)) {
							if (!validation.isCpf(e[i].value)) {
								alert(e[i].getAttribute("msgcpf"));
                                e[i].focus();
                                return false;
							};
						}
						break;
                    case validation.DATE:
                        if (!validation.isEmpty(e[i].value)) {
                            if (!validation.validaDat(e[i].value)) {
                                alert(e[i].getAttribute("msgdate"));
                                e[i].focus();
                                return false;
                            }
                        }
                        break;
                }
            }
        }
    };
    return true;
};

validation.isEmpty = function(value){
	if(value===''||value===null||acioli.trim(value)===''){
		return true;
	};
	return false;
};

validation.inGroup = function(campo){
	var ar = campo.getAttribute("group").split(',');
	for(var i=0; i<ar.length; i++){
		if( acioli.trim(ar[i].toUpperCase()) == acioli.trim(campo.value.toUpperCase()) ){
			return true;
			break;
		}
	}
	
	return false;
};

validation.isCpf = function(value){
	var cpf = value;
  	erro = new String;

	if (cpf.length >= 11)
	{	
			cpf = cpf.replace('.', '');
			cpf = cpf.replace('.', '');
			cpf = cpf.replace('-', '');

			var nonNumbers = /\D/;
			if (nonNumbers.test(cpf)) 
			{
					return false;
			}
			else
			{
					if (cpf == "00000000000" || 
							cpf == "11111111111" || 
							cpf == "22222222222" || 
							cpf == "33333333333" || 
							cpf == "44444444444" || 
							cpf == "55555555555" || 
							cpf == "66666666666" || 
							cpf == "77777777777" || 
							cpf == "88888888888" || 
							cpf == "99999999999") {
							
							return false;
					}
	
					var a = [];
					var b = new Number;
					var c = 11;

					for (i=0; i<11; i++){
							a[i] = cpf.charAt(i);
							if (i < 9) b += (a[i] * --c);
					}
	
					if ((x = b % 11) < 2) { a[9] = 0 } else { a[9] = 11-x }
					b = 0;
					c = 11;
	
					for (y=0; y<10; y++) b += (a[y] * c--); 
	
					if ((x = b % 11) < 2) { a[10] = 0; } else { a[10] = 11-x; }
	
					if ((cpf.charAt(9) != a[9]) || (cpf.charAt(10) != a[10])) {
						return false;
					}
			}
	}
	else
	{
		return false;
	}
	
	return true;	

}

validation.isCnpj = function (value) {
    var cnpj = value.replace(/\D+/g, '');
    if (cnpj.length < 14) {
        return false
    };

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
    };

    if (eval(cnpj.charAt(12)) != digito_verificador) {
        return false;
    };

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
    };

    if (eval(cnpj.charAt(13)) != digito_verificador) {
        return false;
    };

    return true;

};

validation.isCnpjExists=function(value){
	var a = new ajax();
	var txt = a.exec(acioli.url.index, acioli.url.validCnpj + "&cnpj=" + escape(value) ,"GET",false,a.RETURN_TEXT);
	return (parseInt(txt,10)==0)?false:true;
};

validation.isRazaoExists = function(valueRazao,valueCnpj){
	var a = new ajax();
	var txt = a.exec(acioli.url.index, acioli.url.validRazao + "&cnpj=" + escape(valueCnpj) + "&razao=" + escape(valueRazao) ,"GET",false,a.RETURN_TEXT);
	return (parseInt(txt,10)==0)?false:true;
};

validation.isExists = function (url, value) {
    var a = new ajax();
    var txt = a.exec(url + value, "", "GET", false, a.RETURN_TEXT);
	try{
    	return (parseInt(txt, 10) == 0) ? false : true;
	}catch(e){
		alert(txt);
	}
}

validation.isMail = function(value){
	var padrao = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;  
	return padrao.test(value); 
};

validation.isMailExists = function(valueMail,validUsuario){
	var a = new ajax();
	var txt = a.exec(acioli.url.index, acioli.url.validMail + "&mail=" + escape(valueMail) + "&idUsuario=" + validUsuario, "GET", false, a.RETURN_TEXT);
	return (parseInt(txt,10)==0)?false:true;
};

validation.isEqual = function(valueOne,valueTwo){
	return (valueOne===valueTwo) ? true : false;
};

validation.isMin = function(value,min){
	return (value.length<min)?true:false;
};

validation.validaDat = function (valor) {
    var date = valor;
    var ardt = new Array;
    var ExpReg = new RegExp("(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[012])/[12][0-9]{3}");
    ardt = date.split("/");
    erro = false;
    if (date.search(ExpReg) == -1) {
        erro = true;
    }
    else if (((ardt[1] == 4) || (ardt[1] == 6) || (ardt[1] == 9) || (ardt[1] == 11)) && (ardt[0] > 30))
        erro = true;
    else if (ardt[1] == 2) {
        if ((ardt[0] > 28) && ((ardt[2] % 4) != 0))
            erro = true;
        if ((ardt[0] > 29) && ((ardt[2] % 4) == 0))
            erro = true;
    }
    if (erro) {
        return false;
    }
    return true;
};
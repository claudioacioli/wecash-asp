<!-- #include file="includes/web/top.asp" -->
<script>
	
	var aDespesa = <%=arCategoria("D")%>;
	var aReceita = <%=arCategoria("C")%>;
	var aCliente = <%=arCliente()%>
	
</script>
<h1 class='movimentacao'><%=Server.HTMLEncode("Movimentações")%></h1>
<div id="area" style="padding:20px;border:1px  dashed #ccc;" ><%=Server.HTMLEncode("Arraste seu arquivo OFX para esta área pontilhada.")%></div>
<p style="padding-bottom:0px;display:none;">
	<label>Selecione um arquivo ofx:
		<input type="file" id="arq" style="width:450px;" />
	</label>
</p>
<div id="msg" style="display:none;" class="atencao"></div>
<div id="titulo" style="display:none;margin-top:10px;">
    
    <table class="" style="display:none;">
        <thead>
        <tr>
            <th>Nome</th>
            <th>Tamanho</th>
            <th>Tipo</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td id="txtNome"></td>
            <td id="txtTamanho"></td>
            <td id="txtTipo"></td>
        </tr>
        </tbody>
    </table>
    <form action="dados/exeOfx.asp" onsubmit="return acioli.validation.submit(this)" method="post">
    <input type="hidden" name="acao" value="ofx" />
    <nav>
        <button type="submit" class='minimal-indent'><img src="includes/img/salvar.png" />Salvar</button>
        <select name="id_caixa" validation="['NULL']" msgnull="<%=server.HTMLEncode("Campo conta de preenchimento obrigatório. Favor informe-o")%>" style="width:200px;display:inline;margin-left:10px;margin-right:0px;">
        <option value=""></option>
		<%=optCaixa("")%>
        </select>
        <input type="text" autocomplete="off" class="search" placeholder="Filtrar" onKeyUp="apex_search.search(event);" />
    </nav>
    
    <table class="ofx tab_search" id="dados">
        <col style="width:100px;text-align:center;" />
        <col />
        <%If Session("bo_cliente") = 1 Then%>
        	<col style="width:150px;text-align:center;" />
        <%end if%>
        <col style="width:150px;text-align:center;" />
        <col style="width:70px;text-align:left;" />
        <col style="width:25px;text-align:center;" />
        <thead>
            <tr>
                <th>Data</th>
                <th><%=Server.HTMLEncode("Histórico")%></th>
                <%If Session("bo_cliente") = 1 Then%>
                	<th>Cliente</th>
                <%End If%>
                <th>Categoria</th>
                <th>Valor</th>
                <th>&nbsp;</th>
            </tr>
        </thead>
        <tbody></tbody>
    </table>
    </form>
</div>
<!-- #include file="includes/web/foot.asp" -->	
<script>    
	var target = acioli.id("area");
    var handleDrag = function (e) {
        e.preventDefault();
    }
    target.ondragenter = handleDrag;
    target.ondragover = handleDrag;
    target.ondrop = function (e) {
        var files = e.dataTransfer.files;
        Leitor(files[0]);
        e.preventDefault();
    }
	
	var joinJson = function(ar,element,separator){
		var s = '';
		for(var i=0; i<ar.length;i++){
			s = s + ar[i][element] + separator;
		}
		return s.substring(0,s.length - separator.length);
	}
	
	var encodeArray = function(ar){
		for(var i=0; i<ar.length; i++){
			ar[i].value = Encoder.htmlDecode(ar[i].value);
		}
		return ar;
	}
	aDespesa = encodeArray(aDespesa);
	aReceita = encodeArray(aReceita);
	aCliente = encodeArray(aCliente);
	
    acioli.id('arq').onchange = function () {
        Leitor(this.files[0]);
    }

    var Leitor = function (arquivo) {
        var tipo = (/[.]/.exec(arquivo.name)) ? /[^.]+$/.exec(arquivo.name) : "undefined";

        var leitor = new FileReader();
        leitor.onload = function (e) {
            var contents = e.target.result;
            var txt = contents.substring(contents.indexOf("<OFX>"));
            //document.getElementById('conteudo').value = txt;
            xml_load(txt);
        }


        if ((tipo.toString()).toUpperCase() == 'OFX') {
            acioli.id('msg').style.display = 'none';
            leitor.readAsText(arquivo, "ISO-8859-1");
            acioli.id('txtNome').innerHTML = arquivo.fileName;
            acioli.id('txtTipo').innerHTML = (/[.]/.exec(arquivo.fileName)) ? /[^.]+$/.exec(arquivo.fileName) : undefined;
            acioli.id('txtTamanho').innerHTML = (arquivo.fileSize / 1024).toFixed(0) + 'kb';
        } else {
            acioli.id('msg').innerHTML = 'O arquivo selecionado não pode ser lido pelo sistema';
            acioli.id('msg').style.display = 'block';
            acioli.id('titulo').style.display = 'none';
        }
    }

    var xml_load = function (txt) {
        //	var xml = document.implementation.createDocument("", "", null);
        //	xml.load(txt);
        //	alert(xml);
        try {
            var parser = new DOMParser();
            var xml = parser.parseFromString("<?xml version='1.0' encoding='iso-8859-1' ?>" + txt, "application/xml");
        } catch (e) {
            acioli.id('msg').innerHTML = 'Seu arquivo ofx é uma versão mais antiga do q a suportada';
            acioli.id('msg').style.display = 'block';
            return;
        }
        var oRoot = xml.documentElement;
        var oTransacao = oRoot.getElementsByTagName("STMTTRN");
        var tbl = document.getElementById("dados");
        var t = document.getElementById("titulo");
        var tb = tbl.tBodies[0];
        t.style.display = '';

        while (tb.rows.length) {
            tb.deleteRow(0);
        }

        for (var i = 0; i < oTransacao.length; i++) {
            var data = oTransacao[i].getElementsByTagName('DTPOSTED')[0].textContent;
            var historico = oTransacao[i].getElementsByTagName('MEMO')[0].textContent;
            var valor = oTransacao[i].getElementsByTagName('TRNAMT')[0].textContent;

            //Apresentação data
            data = data.substring(0, 8);
            var ano = data.substring(0, 4);
            var mes = data.substring(4, 6);
            var dia = data.substring(6, 8);
            data = dia + '/' + mes + '/' + ano;

            //Apresentação valor
            var valorBr = valor.replace(',', '');
            valorBr = valorBr.replace('.', ',');
            valorBr = valorBr.replace('-', '');
            //valorBr = valorBr.toFixed(2);
            valorBr = 'R$ ' + valorBr;

            sClass = 'positivo';
            if (valor.indexOf('-') > -1) {
                sClass = 'negativo';
            }

            var tr = tb.insertRow(tb.rows.length);

            var td = tr.insertCell(tr.cells.length);
            td.innerHTML = data;
			var hid = document.createElement("input");
			hid.setAttribute('type','hidden');
			hid.setAttribute('name','data');
			hid.setAttribute('value',data);
            td.style.paddingLeft='3px';
			td.appendChild(hid);

            var td = tr.insertCell(tr.cells.length);
            var inp = document.createElement("input");
			inp.setAttribute('name','historico');
			inp.setAttribute("validation","['NULL']");
			inp.setAttribute("msgnull",Encoder.htmlDecode("<%=Server.HTMLEncode("Campo histórico de preenchimento obrigatório. Favor infome-o.")%>"));
            inp.value = historico;
            td.setAttribute('text', historico);
            inp.onfocus = function () {
                var tr = this.parentNode.parentNode;
                tr.className = 'focado';
            }
            inp.onblur = function () {
                var tr = this.parentNode.parentNode;
                tr.className = '';
            }
            inp.onkeyup = function () {
                inputKeyMove(arguments[0], this);
            }
            inp.onchange = function () {
                this.parentNode.setAttribute('text', this.value);
                apex_search.init();
            }
            td.appendChild(inp);
			<%If Session("bo_cliente") = 1 Then%>
			
				var td = tr.insertCell(tr.cells.length);
				var inp = document.createElement("input");
				inp.setAttribute('name','cliente');
				inp.setAttribute("placeholder", "Digite o nome ou a fantasia");
				inp.setAttribute("autocomplete", "off");
				inp.setAttribute("validation","['GROUP']");
				inp.setAttribute("group",joinJson(aCliente,'value',','));
				inp.setAttribute("msgnull",Encoder.htmlDecode("<%=Server.HTMLEncode("Campo cliente de preenchimento obrigatório. Favor infome-o.")%>"));
				inp.setAttribute("msggroup",Encoder.htmlDecode("<%=Server.HTMLEncode("Cliente não cadastrado")%>"));
	
				inp.onkeyup = function () {
					
					complete(this, arguments[0], aCliente );
					inputKeyMove(arguments[0], this);
				};
				inp.onfocus = function () {
					var tr = this.parentNode.parentNode;
					tr.className = 'focado';
				}
				inp.onblur = function () {
					var tr = this.parentNode.parentNode;
					tr.className = '';
				}
				inp.onchange = function () {
					this.parentNode.setAttribute('text', this.value);
					if(this.value==''){
						this.nextSibling.value = 0;
					}
					apex_search.init();
				}
				
				var hid = document.createElement("input");
				hid.setAttribute('type','hidden');
				hid.setAttribute('name','id_cliente');
				hid.setAttribute('value',0);
				
				td.appendChild(inp);
				td.appendChild(hid);
			
			<%End If%>

            var td = tr.insertCell(tr.cells.length);
			
            var inp = document.createElement("input");
            var ar = (sClass=='negativo') ? aDespesa : aReceita;
			inp.setAttribute("placeholder", "Digite a categoria");
			inp.setAttribute("autocomplete", "off");
			inp.setAttribute("validation","['NULL','GROUP']");
			inp.setAttribute("group",joinJson(ar,'value',','));
			inp.setAttribute("msgnull",Encoder.htmlDecode("<%=Server.HTMLEncode("Campo categoria de preenchimento obrigatório. Favor infome-o.")%>"));
			inp.setAttribute("msggroup",Encoder.htmlDecode("<%=Server.HTMLEncode("Categoria não cadastrada")%>"));
			inp.setAttribute('name','categoria');
            inp.setAttribute('sclass',sClass);
			
			inp.onkeyup = function () {
				var ar = (this.getAttribute('sclass')=='negativo') ? aDespesa : aReceita;
                complete(this, arguments[0], ar);
                inputKeyMove(arguments[0], this);
            };
            inp.onchange = function () {
                this.parentNode.setAttribute('text', this.value);
                apex_search.init();
            }
            inp.onfocus = function () {
                var tr = this.parentNode.parentNode;
                tr.className = 'focado';
            }
            inp.onblur = function () {
                var tr = this.parentNode.parentNode;
                tr.className = '';
            }
			
			var hid = document.createElement("input");
			hid.setAttribute('type','hidden');
			hid.setAttribute('name','id_categoria');
			hid.setAttribute('value',0);
			
			td.appendChild(inp);
			td.appendChild(hid);

            var td = tr.insertCell(tr.cells.length);
            td.innerHTML = valorBr;
            td.style.textAlign = 'left';
            td.className = sClass;
			var hid = document.createElement("input");
			hid.setAttribute('type','hidden');
			hid.setAttribute('name','valor');
			hid.setAttribute('value',valor);
			td.appendChild(hid);

            var td = tr.insertCell(tr.cells.length);
            var img = document.createElement('img');
            img.setAttribute('src', 'includes/img/lixeira.png');
            td.appendChild(img);
            img.setAttribute('historico', historico);
            img.onclick = function (e) {
                var msg = Encoder.htmlDecode('Deseja excluir a movimentação "') + this.getAttribute('historico') + '"?';
                if (confirm(msg)) {
                    var tr = this.parentNode.parentNode;
                    tb.removeChild(tr);
                }
            }

            var span = document.createElement("span");
            span.innerHTML = "Excluir";
            td.appendChild(span);

            td.style.width = '25px';
            td.style.textAlign = 'center';
        }

        apex_search.init();

    }

    function complete(obj, evt, arSearch) {
        if ((!obj) || (!evt) || (arSearch.length == 0)) {
            return;
        }

        if (obj.value.length == 0) {
            return;
        }

        var elm = (obj.setSelectionRange) ? evt.which : evt.keyCode;

        if ((elm < 32) || (elm >= 33 && elm <= 46) || (elm >= 112 && elm <= 123)) {
            return;
        }

        var txt = obj.value.replace(/;/gi, ",");
        elm = txt.split(",");
        txt = elm.pop(); // removeu o ultimo elemento do array, provavelmente vazio
        txt = txt.replace(/^\s*/, ""); // fez um trim do array acredito

        if (txt.length == 0) {
            return;
        }

        if (obj.createTextRange) {
            var rng = document.selection.createRange();
            if (rng.parentElement() == obj) {
                elm = rng.text;
                var ini = obj.value.lastIndexOf(elm);
            }
        } else if (obj.setSelectionRange) {
            var ini = obj.selectionStart;
        }

        for (var i = 0; i < arSearch.length; i++) {
            elm = arSearch[i].value.toString();
			id = arSearch[i].id.toString();
            if (elm.toLowerCase().indexOf(txt.toLowerCase()) == 0) {
                obj.value += elm.substring(txt.length, elm.length);
                obj.nextSibling.value = id;
				obj.onchange();
                break;
            }
        }

        if (obj.createTextRange) {
            rng = obj.createTextRange();
            rng.moveStart("character", ini);
            rng.moveEnd("character", obj.value.length);
            rng.select();
        } else if (obj.setSelectionRange) {
            obj.setSelectionRange(ini, obj.value.length);
        }
    }

    var inputKeyMove = function (ev) {
        ev = ev || window.event;
        var tecla = ev.keyCode || ev.wich;
        var obj = arguments[1];
        var td = obj.parentNode;
        var tr = td.parentNode;
        var tb = tr.parentNode;

        var indRow = tr.rowIndex - 1;
        var indCel = td.cellIndex;

        var tTr = tb.rows.length - 1;
        var tTd = tr.cells.length - 1;

        var boFocus = false;
        if (!ev.shiftKey) {
            switch (tecla) {
                case 37:
                    indCel = (indCel - 1 > 0) ? indCel - 1 : indCel;
                    boFocus = true;
                    break;
                case 38:
                    indRow = (indRow - 1 >= 0) ? indRow - 1 : indRow;
                    while (tb.rows[indRow].style.display == 'none' && indRow <= tTr) {
                        indRow--;
                    }
                    boFocus = true;
                    break;
                case 39:
                    indCel = (indCel + 1 <= tTd) ? indCel + 1 : indCel;
                    boFocus = true;
                    break;
                case 40:
                    indRow = (indRow + 1 <= tTr) ? indRow + 1 : indRow;
                    while (tb.rows[indRow].style.display == 'none' && indRow <= tTr) {
                        indRow++;
                    }
                    boFocus = true;
                    break;
            }
        }

        if (boFocus) {

            var nTD = tb.rows[indRow].cells[indCel];
            var obj = nTD.childNodes[0];
            obj.focus();
            (obj.select) ? obj.select() : null;
            
        }

    }
</script>
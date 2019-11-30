			</div>
		</div>
        <footer>
        	<div id="foot" style="color:rgb(186, 193, 199);font-size: 18px;">
            	Copyright &copy; 2012 WeCa$h. Todos os direitos reservados.
            </div>
        </footer>
	</body>
</html>
<script src="includes/library/jquery/jquery-1.11.1.min.js"></script>
<script src="includes/library/jquery/jquery-ui/js/jquery-ui-1.10.4.min.js"></script>
<script src="includes/library/bootstrap/js/bootstrap.min.js"></script>
<script src="includes/script/library/ajax.class.js"></script>
<script src="includes/script/library/validation.class.js"></script>
<script src="includes/script/library/format.class.js"></script>
<script src="includes/script/library/datatypes.class.js"></script>
<script src="includes/script/library/json.js"></script>
<script src="includes/script/library/encode.js"></script>
<script src="includes/script/library/swfobject.js"></script>
<script src="includes/script/library/Util.js"></script>
<script src="includes/script/acioli.class.js"></script>
<script src="includes/library/highcharts/highcharts.js"></script>
<script src="includes/library/highcharts/highcharts-3d.js"></script>
<script src="includes/library/highcharts/modules/exporting.js"></script>

<script defer="defer">
jQuery(function($){
        $.datepicker.regional['pt-BR'] = {
                closeText: 'Fechar',
                prevText: '&#x3c;Anterior',
                nextText: 'Pr&oacute;ximo&#x3e;',
                currentText: 'Hoje',
                monthNames: ['Janeiro','Fevereiro','Mar&ccedil;o','Abril','Maio','Junho',
                'Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'],
                monthNamesShort: ['Jan','Fev','Mar','Abr','Mai','Jun',
                'Jul','Ago','Set','Out','Nov','Dez'],
                dayNames: ['Domingo','Segunda-feira','Ter&ccedil;a-feira','Quarta-feira','Quinta-feira','Sexta-feira','Sabado'],
                dayNamesShort: ['Dom','Seg','Ter','Qua','Qui','Sex','Sab'],
                dayNamesMin: ['Dom','Seg','Ter','Qua','Qui','Sex','Sab'],
                weekHeader: 'Sm',
                dateFormat: 'dd/mm/yy',
                firstDay: 0,
                isRTL: false,
                showMonthAfterYear: false,
                yearSuffix: ''};
        $.datepicker.setDefaults($.datepicker.regional['pt-BR']);
		$.datepicker._gotoToday = function(id) { 
			$(id).datepicker('setDate', new Date()).datepicker('hide').blur(); 
		};
});
function findSWF(movieName) {
  if (navigator.appName.indexOf("Microsoft")!= -1) {
    return window["ie_" + movieName];
  } else {
    return document[movieName];
  }
}
</script>
 <script>
 	if(acioli.id("divSaldos")){
		acioli.exec.saldo("");
	};
 	if(acioli.id("divAnalise")){
		var data = new Date();
		var mes = acioli.trataMes(data.getMonth());
		var ano = data.getFullYear();
		var sref = mes+'/'+ano;
		//acioli.exec.resumo("referencia="+sref);
	};
</script>
<script type="text/javascript">

    var _gaq = _gaq || [];
    _gaq.push(['_setAccount', 'UA-30397354-1']);
    _gaq.push(['_trackPageview']);

    (function () {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();

</script>
<!-- #include file="../../dados/desconectar.asp" -->
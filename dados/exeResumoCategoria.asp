<!-- #include file="conectar.asp" -->
<%

	response.Charset = "iso-8859-1"

	sMes = Month(Date())
	sAno = Year(Date())
	
	If sMes < 10 Then
		sMes = "0"&sMes&""
	End If
	
	sReferencia			= sMes &"/"& sAno
	

	
	sIdEmpresa     = Session("id_empresa")
	sTipoMovimento = "D"

	sql = ""
	sql = sql & " SELECT max(t.ds_categoria) categoria, 													"
	sql = sql & "   	 T.Id_Categoria, to_char(sum(m.nr_valor_previsto),'9G999G999G990D00') Valor_Br, 								"
	sql = sql & "        ROUND( RATIO_TO_REPORT(sum(m.nr_valor_previsto)) OVER ()*100 ,2) AS porcentagem 	"
	sql = sql & "   FROM tb_Movimento m, 																	"
	sql = sql & "   	 tb_categoria t 																	"
	sql = sql & "  WHERE t.id_categoria = m.id_categoria 													"
	sql = sql & " 	 And T.Id_Empresa   = "&sIdEmpresa&" 													"
	sql = sql & " 	 AND ( TO_CHAR(Dt_Confirmacao,'MM/YYYY') = '"&sReferencia&"' 								"
	sql = sql & "    	   Or (Dt_Confirmacao Is  Null 														"
	sql = sql & " 		   AND to_date(TO_CHAR(dt_previsao,'MM/YYYY'),'MM/YYYY') < to_date('"&sReferencia&"','MM/YYYY') "
	sql = sql & " 		   And To_Date('"&sReferencia&"','MM/YYYY') <= To_Date(To_Char(Sysdate,'MM/YYYY'),'MM/YYYY') ) "
	sql = sql & " 		   Or To_Char(Dt_Confirmacao,'MM/YYYY') = '"&sReferencia&"' ) 						"
	sql = sql & "    And Dt_Confirmacao Is Not Null 														"
	sql = sql & "    And Tp_Movimento = '"&sTipoMovimento&"' 													"
	sql = sql & "    And bo_considerar_relatorio = 1 														"
	sql = sql & "  Group By T.Id_Categoria 																	"
	sql = sql & "  ORDER BY porcentagem desc 																"
	Set rs = oOracleDB.execute(sql)
	js = ""
	If not rs.eof then	
	
%>
$(function () {
    $('#divCat').highcharts({
        chart: {
            type: 'pie'
        },
        title: {
            text: 'Despesas'
        },
        subtitle: {
            text: 'por categoria'
        },
        plotOptions: {
            pie: {
				size:200
            }
        },
<%	
		js = js & "series: [{"
		js = js & " name:'Despesa mensal',"
		js = js & " dataLabels:{enable:false}, "
		js = js & " data: [ "
		
		do while not rs.eof
			sNrValor = rs("Valor_Br")
			sNrValor = replace(sNrValor,".","")
			sNrValor = replace(sNrValor,",",".")
			
			js = js & "['"&rs("categoria")&"',"&sNrValor&"],"
			rs.movenext
		loop
		js = mid(js,1,len(js)-1) & "]}]"
	End If
	Set rs = Nothing
	Response.Write js
%>
});});
<!-- #include file="desconectar.asp" -->
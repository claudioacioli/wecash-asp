<!-- #include file="conectar.asp" -->
<%
	response.Charset = "iso-8859-1"
	sMes = trim(Request("mes")&"")
	sAno = trim(Request("ano")&"")
	sReferencia			= sMes &"/"& sAno
	if sReferencia = "/" Then
		sReferencia = "06/2014"
	End If
	
	sIdCaixa = trim(Request("id_caixa")&"")
	sTipo = trim(Request("tipo")&"")
	bTitle = trim(Request("title")&"")
	bConfirmado = trim(Request("confirmado")&"")
	sTitle = ""
	If bTitle <> "" Then
		If sTipo = "D" Then
			sTitle = "Despesa"
		Else
			sTitle = "Receita"
		End If
	End If
	
	sql = 		" SELECT " 
	sql = sql & "  		max(t.ds_categoria) categoria, "
	sql = sql & "  		to_char(sum(m.nr_valor_previsto),'9999999990D00') valor, "
	sql = sql & "  		t.id_categoria, sum(m.nr_valor_previsto) valor_br, "
    sql = sql & "       ROUND( RATIO_TO_REPORT(sum(m.nr_valor_previsto)) OVER ()*100 ,2) AS porcentagem "
	sql = sql & "  FROM tb_Movimento m, "
	sql = sql & "  		tb_categoria t "
	sql = sql & " WHERE t.id_categoria                                    = m.id_categoria "
	sql = sql & "	AND t.id_empresa                                      = " & session("id_empresa") & " "
	sql = sql & "	AND ( TO_CHAR(dt_previsao,'MM/YYYY')                  = '"&sReferencia&"' "
	sql = sql & "	OR (dt_confirmacao                                   IS NULL "
	sql = sql & "	AND to_date(TO_CHAR(dt_previsao,'MM/YYYY'),'MM/YYYY') < to_date('"&sReferencia&"','MM/YYYY') "
	sql = sql & "	AND to_date('"&sReferencia&"','MM/YYYY')                     <= to_date(TO_CHAR(sysdate,'MM/YYYY'),'MM/YYYY') ) "
	sql = sql & "	OR TO_CHAR(dt_confirmacao,'MM/YYYY')                  = '"&sReferencia&"' ) "
	sql = sql & "   And bo_considerar_relatorio = 1"
	
	If bConfirmado = "S" Then
		sql = sql & "	AND dt_confirmacao is not null "
	End If

	If sIdCaixa <> "" and sIdCaixa <> "0" Then
		sql = sql & "	AND   m.id_caixa = "&sIdCaixa&" "
	End If
	
	If sTipo <> "" Then
		sql = sql & "	AND   t.tp_movimento = '"&sTipo&"' "
	Else
		sql = sql & "	AND   t.tp_movimento = 'D' "
	End If
	
	sql = sql & " group by t.id_categoria "
	sql = sql & " ORDER BY valor desc "

set rs = oOracleDB.execute(sql)
if not rs.eof then	
	js = "{"&_
	"'bg_colour':'#ffffff', "&_
	"'title':{ "&_
	"'text':'"&sTitle&"', "&_
	"'style':'{font-size: 13px;font-weight:bold;}' "&_
	"}, "&_
	"'elements':[ "&_
	"{ "&_
	"'type':'pie', "&_
	"'colours':['#d01f3c','#356aa0','#C79810','#008000','#800080','#FF8000','#FF9999','#804000','#C0C0C0','#FF80FF'], "&_
	"'alpha':0.6, 'animate': [ { 'type': 'fade' }, { 'type': 'bounce', 'distance': 10 } ], 'gradient-fill': true, "&_
	"'border':2, "&_
	"'start-angle':26, "&_
	"'values':[ "
	do while not rs.eof
		sNrValor = replace(rs(1),".","")
		sNrValor = replace(rs(1),",",".")
		js = js & "{'value':"&sNrValor&",'label':"""&trim(rs(0))& " ("&rs("porcentagem")&"%) " & """, 'tip':"" "&trim(rs(0))&" (R$ "&formatnumber(rs(3),2)&" - "&rs("porcentagem")&"%)"", 'on-click':'acioli.exec.movimentoPorCategoria(\""referencia="&sReferencia&"&id_categoria="&rs(2)&"&id_caixa="&sIdCaixa&"&tipo="&sTipo&"\"")'}, "
		rs.movenext
	loop
	js = mid(js,1,len(js)-2) & "]}]}"
	
	response.write replace(js,"'","""")
end if
	
%>
<!-- #include file="desconectar.asp" -->
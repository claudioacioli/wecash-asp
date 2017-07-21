<!-- #include file="conectar.asp" -->
<%
	sMes = trim(Request("mes")&"")
	sAno = trim(Request("ano")&"")
	sIdCaixa = trim(Request("id_caixa")&"")
	sReferencia	= sMes &"/"& sAno
	if sReferencia = "/" Then
		sReferencia = "02/2012"
	End If
	
sql = " select max(saida) from (select	"
sql = sql & "	  (to_char(sum(decode(t.tp_movimento,'C',m.nr_valor_previsto,0)),'999999999990D00')) Entrada, "
sql = sql & "     (to_char(sum(decode(t.tp_movimento,'D',m.nr_valor_previsto,0)),'999999999990D00')) Saida	"
sql = sql & "		from tb_Movimento m, tb_caixa c, tb_categoria t "
sql = sql & "		where c.id_caixa = m.id_caixa "
sql = sql & "		  and t.id_categoria = m.id_categoria "
sql = sql & "		  and c.id_empresa =  "&Session("id_empresa")&" "
sql = sql & "		  and to_char(dt_confirmacao,'MM/YYYY') = '"&sReferencia&"' "
sql = sql & "		  and c.id_caixa = "&sIdCaixa&" "
sql = sql & "		  and dt_confirmacao is not null )"	

maior = 0

'response.write sql
set rs = oOracleDB.execute(sql)
if not rs.eof then
	maior = Int(rs(0)*100)/100
	passo = int( (rs(0)/10) * 100 ) / 100
End if
set rs = nothing

sql = "select	"
sql = sql & "     to_char(dt_confirmacao,'dd') data ,   "
sql = sql & "		 to_char(sum(decode(t.tp_movimento,'C',m.nr_valor_previsto,0)),'999999999990D00') Entrada, "
sql = sql & "     to_char(sum(decode(t.tp_movimento,'D',m.nr_valor_previsto,0)),'999999999990D00') Saida	"
sql = sql & "		from tb_Movimento m, tb_caixa c, tb_categoria t "
sql = sql & "		where c.id_caixa = m.id_caixa "
sql = sql & "		  and t.id_categoria = m.id_categoria "
sql = sql & "		  and c.id_empresa =  "&Session("id_empresa")&" "
sql = sql & "		  and to_char(dt_confirmacao,'MM/YYYY') = '"&sReferencia&"' "
sql = sql & "		  and c.id_caixa = "&sIdCaixa&" "
sql = sql & "		  and dt_confirmacao is not null "
sql = sql & "      group by to_char(dt_confirmacao,'dd') "
sql = sql & "		order by to_char(dt_confirmacao,'dd') asc "


set rs = oOracleDB.execute(sql)
if not rs.eof then

js = ""&_
"	{"&_
"		'bg_colour':'#ffffff',"&_
"  		'title':{"&_
"   	 		'text':   'Extrato mensal "&anoMes&"',"&_
"    		'style': '{font-size: 10px;}'"&_
"  		},"&_
""&_
"  		'elements':["&_
"		{'type':'tags', "&_ 
"		 'values':[ "
cont = 0
do while not rs.eof
js = js & "{'x':"&cont&",'y':"&rs(2)&",'text':"&rs(2)&"},"
cont = cont + 1
rs.movenext
loop
rs.movefirst
js = mid(js,1,len(js)-1)  & "],'font':'Tahoma','font-size':10},			"&_
"    	{"&_
"      		'type':      'area',"&_
"      		'colour':    '#d01f3c',"&_
"			'fill': '#d01f3c', "&_
"			'fill-alpha': 0.1, "&_
"      		'text':      'Saídas',"&_
"      		'font-size': 10,"&_
"      		'width':     2,"&_
"	  		'dot-style':    { "&_
"								'type':'solid', "&_
"								'sides':1, "&_
"								'alpha':1, "&_
"								'hollow':true, "&_
"								'background-colour':'#d01f3c', "&_
"								'background-alpha': 0.4, "&_
"								'width':1 },"&_
"     		'values' :   ["
label = ""
do while not rs.eof
	js = js & "{'value' :"&rs(2)&", 'type':'area', 'colour':'#d01f3c', 'hollow':true,'tip':'"&rs(2)&" dia "&rs(0)&" '},"
	label = label &"'" & rs(0) & "',"
rs.movenext
loop
label = mid(label,1,len(label)-1)
js = mid(js,1,len(js)-1) & "]}"
js = js & "],	"&_
"					'x_axis':{"&_
"    					'labels':{'labels':["&label&"]},"&_
"						'colour':'#e9e9e9',"&_
"						'grid-colour':'#ffffff'"&_
" 					},"&_
"					'y_axis':{"&_
"    					'colour':'#e9e9e9',"&_
"						'grid-colour':'#ffffff',"&_
"						'min':0, "&_
"						'max':'"&maior&"', "&_
"						'steps':'"&passo&"' "&_
"  					}"&_
"				}"

response.write replace(js,"'","""")
end if
%>
<!-- #include file="desconectar.asp" -->
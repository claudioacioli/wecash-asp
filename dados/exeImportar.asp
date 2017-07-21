<!-- #include file="conectar.asp" -->
<%
Sub cliente()
	'"Tipo";0
	'"Nome";1
	'"Razão Social";2
	'"Telefone";3
	'"Celular";4
	'"Email";5
	'"CNPJ";6
	'"CPF";7
	'"Logradouro";8
	'"Bairro";9
	'"Site";10
	'"CEP";11
	'"Cidade"12
    'pagina asp para importação de bancos
    
	Response.codepage = 1252
    Response.CharSet ="ISO-8859-1"
    Set fs = Server.CreateObject("Scripting.FileSystemObject")
    sArquivo = Server.MapPath("xxx.csv")
    Set arquivo = fs.getFile(sArquivo)
    set texto = arquivo.OpenAsTextStream(1)
    nlinha = 0
	Do While texto.AtEndOfStream <> True
        linha = texto.readLine
		nlinha = nlinha  + 1
		If nlinha > 3 Then
			
			ar = split(replace(linha,"""",""),";")
		   
			tipo = trim(ar(0)&"")
			ds_email = trim(ar(5)&"")
			ds_site = trim(ar(10)&"")
			ds_razao = trim(ar(2)&"")
			ds_nome = replace(trim(ar(1)&""),"'","''")
			nr_cnpj = trim(ar(6)&"")
			nr_cpf = trim(ar(7)&"")
			
			sql = "select sq_cliente.nextval from dual"
			Set rs = oOracleDB.execute(sql)
			id = rs(0)
			
			sql = "insert into tb_cliente (id_empresa, id_cliente, ds_email, ds_site)"
			sql = sql & "values("&Session("id_empresa")&","&id&", '"&trim(ar(5)&"")&"','"&ar(10)&"') "
			oOracleDB.execute(sql)
			
			
			If instr(tipo,"Pessoa Jur") > 0 then
				sql = "insert into tb_pessoa_juridica( id_cliente, nr_cnpj, ds_razao_social, ds_fantasia) "
				sql = sql & " values ("&id&", '"&nr_cnpj&"','"&ds_razao&"','"&ds_nome&"') "
				oOracleDB.execute(sql)
			Else
				sql = "insert into tb_pessoa_fisica( id_cliente, nr_cpf, ds_nome) "
				sql = sql & " values ("&id&", '"&nr_cpf&"','"&ds_nome&"') "
				oOracleDB.execute(sql)
			End If
			
			ds_logradouro = trim(ar(8)&"")
			ds_bairro = trim(ar(9)&"")
			ds_cep = trim(ar(11)&"")
			ds_cidade = trim(ar(12)&"")
			
			If ds_cep <> "" Then
				sql = "insert into tb_endereco (id_cliente, id_endereco, ds_logradouro, ds_bairro, nr_cep, ds_cidade )"
				sql = sql & " values ("&id&", sq_endereco.nextval, '"&ds_logradouro&"', '"&ds_bairro&"', '"&ds_cep&"', '"&ds_cidade&"') "
				oOracleDB.execute(sql)
			End If
			
			nr_telefone = trim(ar(3)&"")
			nr_celular = trim(ar(4)&"")
			
			If nr_telefone <> "" Then
				sql = "insert into tb_contato(id_cliente, id_contato, ds_email, nr_telefone, tp_telefone) "
				sql = sql & " values ( "&id&", sq_contato.nextval, '"&ds_email&"','"&nr_telefone&"','T') "
				oOracleDB.execute(sql)
			End If
			
			If nr_celular <> "" Then
				sql = "insert into tb_contato(id_cliente, id_contato, ds_email, nr_telefone, tp_telefone) "
				sql = sql & " values ( "&id&", sq_contato.nextval, '"&ds_email&"','"&nr_celular&"','C') "
				oOracleDB.execute(sql)
	
			End If
		
 		End If      
    Loop
End Sub

Sub Categoria()
	'"Tipo";"Situação";"Reconciliado";"Data";"Número";"Favorecido";"Categoria";"Receita";"Despesa";"Conta";"Histórico";"Saldo";"Observações";"Valor"
	Response.codepage = 1252
    Response.CharSet ="ISO-8859-1"
    Set fs = Server.CreateObject("Scripting.FileSystemObject")
    sArquivo = Server.MapPath("categoria.csv")
    Set arquivo = fs.getFile(sArquivo)
    set texto = arquivo.OpenAsTextStream(1)
    nlinha = 0
	Do While texto.AtEndOfStream <> True
		linha = replace(texto.readLine,"""","")
		nlinha = nlinha  + 1
		If nlinha > 3 Then
			ar = split(linha,";")
			tipo = ar(0)
			scategoria = ar(6)
			acategoria = split(scategoria,":")
			
			If ubound(acategoria) >= 1 Then
                sCategoria = acategoria(0)
				sSubCategoria = acategoria(1)
			Else
				sCategoria = acategoria(0)
			End If
			
			id = Session("id_empresa")
			If tipo = "Pagamento" then
			
				sql = "select id_categoria from tb_categoria where id_empresa = "&id&" and tp_movimento = 'D' and ds_categoria = '"&sCategoria&"' "
				set rs = oOracleDB.execute(sql)

				If Rs.eof then
                    
                    sql = "select sq_categoria.nextval from dual"
                    set rs = oOracleDB.execute(sql)
                    id_categoria = rs(0)

					sql = "insert into tb_categoria(id_empresa, id_categoria, ds_categoria, tp_movimento) values("&id&","&id_categoria&", '"&scategoria&"', 'D') "
					oOracleDB.execute(sql)

                    If trim(sSubCategoria&"") <> "" Then
                        sql = "insert into tb_categoria(id_empresa, id_categoria, ds_categoria, tp_movimento, id_super_categoria) values("&id&",sq_categoria.nextval, '"&sSubCategoria&"', 'D',"&id_categoria&") "
					    oOracleDB.execute(sql)
                    End If

                Else
                    id_categoria = rs("id_categoria")
                    sql = "select 1 from tb_categoria where id_empresa = "&id&" and tp_movimento = 'D' and ds_categoria = '"&sSubCategoria&"' "
				    set rs = oOracleDB.execute(sql)
                    
                    If rs.eof then
                        sql = "insert into tb_categoria(id_empresa, id_categoria, ds_categoria, tp_movimento, id_super_categoria) values("&id&",sq_categoria.nextval, '"&sSubCategoria&"', 'D',"&id_categoria&") "
					    oOracleDB.execute(sql)
				    End If

                End If
				
			Else
			
				sql = "select id_categoria from tb_categoria where id_empresa = "&id&" and tp_movimento = 'C' and ds_categoria = '"&scategoria&"' "
				set rs = oOracleDB.execute(sql)
				
                If Rs.eof then
                    
                    sql = "select sq_categoria.nextval from dual"
                    set rs = oOracleDB.execute(sql)
                    id_categoria = rs(0)

					sql = "insert into tb_categoria(id_empresa, id_categoria, ds_categoria, tp_movimento) values("&id&","&id_categoria&", '"&scategoria&"', 'C') "
					oOracleDB.execute(sql)

                    If trim(sSubCategoria&"") <> "" Then
                        sql = "insert into tb_categoria(id_empresa, id_categoria, ds_categoria, tp_movimento, id_super_categoria) values("&id&",sq_categoria.nextval, '"&sSubCategoria&"', 'C',"&id_categoria&") "
					    oOracleDB.execute(sql)
                    End If
                Else
                    id_categoria = rs("id_categoria")
                    sql = "select 1 from tb_categoria where id_empresa = "&id&" and tp_movimento = 'C' and ds_categoria = '"&sSubCategoria&"' "
				    set rs = oOracleDB.execute(sql)
                    
                    If rs.eof then
                        sql = "insert into tb_categoria(id_empresa, id_categoria, ds_categoria, tp_movimento, id_super_categoria) values("&id&",sq_categoria.nextval, '"&sSubCategoria&"', 'C',"&id_categoria&") "
					    oOracleDB.execute(sql)
				    End If

                End If
			
			End If
			
		End If
	Loop
	
End Sub

Sub Contas()
    '0      1           2               3       4       5           6           7           8       9       10          11          12          13
	'"Tipo";"Situação";"Reconciliado";"Data";"Número";"Favorecido";"Categoria";"Receita";"Despesa";"Conta";"Histórico";"Saldo";"Observações";"Valor"
	Response.codepage = 1252
    Response.CharSet ="ISO-8859-1"
    Set fs = Server.CreateObject("Scripting.FileSystemObject")
    sArquivo = Server.MapPath("categoria.csv")
    Set arquivo = fs.getFile(sArquivo)
    set texto = arquivo.OpenAsTextStream(1)
    nlinha = 0
    id = Session("id_empresa")
	Do While texto.AtEndOfStream <> True
		linha = replace(texto.readLine,"""","")
		nlinha = nlinha  + 1
		If nlinha > 1 Then
			ar = split(linha,";")
			conta = ar(9)
            If trim(conta&"") <> "" Then
                sql = "select 1 from tb_caixa where id_empresa = "&id&" and ds_caixa = '"&conta&"' "
                Set rs = oOracleDB.execute(sql)
                If rs.EOF Then
                    sql = "insert into tb_caixa(id_empresa, id_caixa, ds_caixa, nr_saldo_inicial) values ("&id&",sq_caixa.nextval,'"&conta&"',0) "
                    oOracleDB.execute(sql)
                End If
                Set rs = Nothing
            End If
        End If
	Loop

End Sub

Sub Movimento()
    '0      1           2               3       4       5           6           7           8       9       10          11          12          13
	'"Tipo";"Situação";"Reconciliado";"Data";"Número";"Favorecido";"Categoria";"Receita";"Despesa";"Conta";"Histórico";"Saldo";"Observações";"Valor"
	Response.codepage = 1252
    Response.CharSet ="ISO-8859-1"
    Set fs = Server.CreateObject("Scripting.FileSystemObject")
    sArquivo = Server.MapPath("novo.csv")
    Set arquivo = fs.getFile(sArquivo)
    set texto = arquivo.OpenAsTextStream(1)
    nlinha = 0
    id = Session("id_empresa")
	Do While texto.AtEndOfStream <> True
		linha = replace(texto.readLine,"""","")
		nlinha = nlinha  + 1
		If nlinha > 3 Then
			ar = split(linha,";")

            sql = "select sq_movimento.nextval from dual"
            Set rs = oOracleDB.execute(sql)
            id_movimento = rs(0)

            '### PROCURA CONTA DO MOVIMENTO ###'
			sConta = trim(ar(9)&"")
            sql = "select id_caixa from tb_caixa where ds_caixa = '"&sConta&"' and id_empresa = "&id&" "
            Set rsConta = oOracleDB.execute(sql)
            If Not rsConta.eof then
                id_conta = rsConta(0)
            Else
                id_conta = 206
            End If
            Set rsConta = Nothing

            
            '### PROCURA CATEGORIA DO MOVIMENTO ###'
            sCategoria = ar(6)
            acategoria = split(sCategoria,":")
            sTipo = ar(0)

            If sTipo = "Pagamento" Then
                sqlW = " and tp_movimento = 'D' "
            Else
                sqlW = " and tp_movimento = 'C' "
            End If

			If ubound(acategoria) >= 1 Then
                sCategoria = acategoria(0)
                sSubCategoria = acategoria(1)
                sql = "select id_categoria from tb_categoria where id_empresa = "&id&" "&sqlW&" and ds_categoria = '"&sSubCategoria&"' and id_super_categoria = (select id_categoria from tb_categoria where ds_categoria = '"&sCategoria&"' and id_empresa = '"&id&"' and id_super_categoria is null "&sqlW&" ) "
            Else
				sCategoria = acategoria(0)
                sql = "select id_categoria from tb_categoria where id_empresa = "&id&" and ds_categoria = '"&sCategoria&"' "&sqlW&" "
			End If

            Set rsCategoria = oOracleDB.execute(sql)
            If Not rsCategoria.Eof Then
                id_categoria = rsCategoria(0)
            End If
            Set rsCategoria = Nothing


            '### PROCURA CLIENTE DO MOVIMENTO ###'
            sCliente = ar(5)
            sql = "select id_cliente from vw_cliente where id_empresa = "&id&" and (ds_fantasia = '"&sCliente&"' or ds_razao_social = '"&sCliente&"' ) "
            Set rs = oOracleDB.execute(sql)
            If Not rs.Eof Then
                id_cliente = trim(rs(0)&"")
            Else
                id_cliente = ""
            End If
            Set rs = Nothing


            '### PEGA VALORES PARA MOVIMENTO ###
            situacao = ar(1)
            dt_previsto = trim(ar(3)&"")
            dt_confirmado = trim(dt_previsto&"")
            ds_historico = trim(ar(10)&"")
            
            valor = trim(ar(13)&"")
            valor = replace(valor,"-","")
            valor = replace(valor,".","")
		    valor = replace(valor,",",".")

            If  id_movimento <> "" and id_categoria <> "" and dt_previsto <> "" Then
                sql = "insert into tb_movimento(id_movimento, id_caixa, id_categoria, ds_historico, dt_previsao, dt_confirmacao, nr_valor_previsto) values ("&id_movimento&","&id_conta&","&id_categoria&",'"&ds_historico&"',to_date('"&dt_previsto&"','DD/MM/YYYY'),to_date('"&dt_confirmado&"','DD/MM/YYYY'),TO_NUMBER('"&valor&"','999999990D00'))"
                oOracleDB.execute(sql)
                If id_cliente <> "" Then
                    sql = "insert into rl_movimento_cliente (id_movimento, id_cliente) values ("&id_movimento&","&id_cliente&") "
                    oOracleDB.execute(sql)
                End If
            End If

        End If
	Loop

End Sub

Movimento()

%>
<!-- #include file="desconectar.asp" -->
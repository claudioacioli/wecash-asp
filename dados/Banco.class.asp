<%

Class Banco

	Private oConexao

	Public Function abrir_conexao()

		Set oConexao                    = Server.CreateObject("ADODB.Connection")
		    oConexao.CommandTimeout     = 90
		    oConexao.ConnectionTimeout  = 90
		    oConexao.CursorLocation     = 3
		    oConexao.ConnectionString   = "Provider=MSDAORA.1;Password=;User ID=;Data Source=;Persist Security Info=True;"
            oConexao.Open

	End Function

	Public Function conexao()
		Set conexao = oConexao
	End Function

	Public Function fechar_conexao()
		Set oConexao = Nothing
	End Function

End Class

%>
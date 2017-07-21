<%
  
  Class Categoria

    Public Function listar(id_empresa)

        sSQL = ""
        sSQL = sSQL & " select c.id_categoria, c.ds_categoria, tp_movimento, (select count(*) from tb_movimento where id_empresa = c.id_empresa and id_categoria = c.id_categoria) nr_movimento "
        sSQL = sSQL & "   from tb_categoria c"
        sSQL = sSQL & "  where c.id_empresa = ? "
        sSQL = sSQL & "  order by c.ds_categoria "

    End Function  

  End Class
    
%>

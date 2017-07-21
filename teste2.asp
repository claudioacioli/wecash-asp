<%@language=Python%>
<%
#import cx_Oracle
from matematica import soma
import cgitb

print "Content-Type: text/plain;charset=utf-8"

cgitb.enable()

if 1==1:
	Response.Write(soma(1,2))
%>




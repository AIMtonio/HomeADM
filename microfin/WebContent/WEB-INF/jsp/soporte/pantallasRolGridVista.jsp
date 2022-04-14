<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
</head>
<c:set var="listaopciones" value="${listaResultado[0]}"/>
 
<body style="background: #FFF; margin: 0pt; ">
<br>
	<div> 
	<!-- id="seleccionado" style="width:45%;position:absolute; left:1%; top:40%"> -->
	<fieldset class="ui-widget ui-widget-content ui-corner-all">	
	<table id="selec">
	<c:forEach items="${listaopciones}" var="lista" >
			
					<tr id=fila>

					<td><input id="${lista.opcionMenuID}" name="numero" size="5" value="${lista.opcionMenuID}"/></td>
					<td><input class="check" type="checkbox" id="${lista.desplegado}" value="${lista.desplegado}" name="opcion"/>
					<input id="${lista.desplegado}" name="pantalla" size="35" value="${lista.desplegado}"/></td>
				</tr>
		
			</c:forEach>

  	
</table>
</fieldset>
</div>

 </body>
</html>


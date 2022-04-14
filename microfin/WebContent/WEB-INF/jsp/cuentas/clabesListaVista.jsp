<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<c:set var="campoLista"   value="${listaResultado[0]}"/>
<c:set var="listaResultado"  value="${listaResultado[1]}"/>


<table id="tablaLista">
	<tr id="encabezadoLista">
		<td>Clave</td>
		<td><s:message code="safilocale.cliente"/></td>
	</tr>
	<c:forEach items="${listaResultado}" var="clabeCliente" >
		<tr onclick="cargaValorLista('${campoLista}', '${clabeCliente.clabe}');">
			<td>${clabeCliente.clabe}</td>
			<td>${clabeCliente.etiqueta}</td>
		</tr>
	</c:forEach>
</table>

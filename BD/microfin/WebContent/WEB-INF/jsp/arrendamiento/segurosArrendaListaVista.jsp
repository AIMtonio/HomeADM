<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="beanLista" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista >= '1'}">
			<tr id="encabezadoLista">
				<td>Seguro</td>
				<td>Descripci&oacute;n</td>	
			</tr>
			<c:forEach items="${beanLista}" var="items" >
			<tr onclick="cargaValorLista('${campoLista}', '${items.seguroArrendaID}');">
				<td nowrap="nowrap">${items.seguroArrendaID}</td>
				<td nowrap="nowrap">${items.descripcion}</td>
			</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
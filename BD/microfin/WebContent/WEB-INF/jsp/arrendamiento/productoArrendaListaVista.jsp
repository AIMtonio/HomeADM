<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="productoBean" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista >= '1'}">
			<tr id="encabezadoLista">
				<td>ProductoID</td>
				<td>Nombre</td>	
			</tr>
			<c:forEach items="${productoBean}" var="productos" >
			<tr onclick="cargaValorLista('${campoLista}', '${productos.productoArrendaID}');">
				<td nowrap="nowrap">${productos.productoArrendaID}</td>
				<td nowrap="nowrap">${productos.nombreCorto}</td>
			</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
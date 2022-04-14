<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="arrendamiento" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '3'}">
			<tr id="encabezadoLista">
				<td>No. Arrendamiento</td>
				<td>Nombre Producto</td>
				<td>Nombre Cliente</td>
			</tr>
			<c:forEach items="${arrendamiento}" var="producto" >
				<tr onclick="cargaValorLista('${campoLista}', '${producto.arrendaID}');">
					<td>${producto.arrendaID}</td>
					<td>${producto.nombreCorto}</td>
					<td>${producto.nombreCliente}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>

<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="impuesto" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td>Impuesto</td>
				<td>Descripción</td>
				<td>Descripción Corta</td>
			</tr>
			<c:forEach items="${impuesto}" var="impuesto" >
				<tr onclick="cargaValorLista('${campoLista}', '${impuesto.impuestoID}');">
					<td>${impuesto.impuestoID}</td>
					<td>${impuesto.descripcion}</td>
					<td>${impuesto.descripCorta}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td>Impuesto</td>
				<td>Descripción</td>
				<td>Descripción Corta</td>
				<td>Tasa</td>
			</tr>
			<c:forEach items="${impuesto}" var="impuesto" >
				<tr onclick="cargaValorLista('${campoLista}', '${impuesto.impuestoID}');">
					<td>${impuesto.impuestoID}</td>
					<td>${impuesto.descripcion}</td>
					<td>${impuesto.descripCorta}</td>
					<td>${impuesto.tasa}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
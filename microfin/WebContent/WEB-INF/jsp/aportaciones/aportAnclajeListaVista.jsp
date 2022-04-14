<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="aportaciones" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td nowrap="nowrap">N&uacute;mero</td>
				<td nowrap="nowrap">Nombre</td>
				<td nowrap="nowrap">Monto</td>
				<td nowrap="nowrap">Vencimiento</td>
				<td nowrap="nowrap">Tipo Aportaci&oacute;n</td>
			</tr>
			<c:forEach items="${aportaciones}" var="aportacion" >
				<tr onclick="cargaValorLista('${campoLista}', '${aportacion.aportacionID}');">
					<td nowrap="nowrap">${aportacion.aportacionID}</td>
					<td nowrap="nowrap">${aportacion.nombreCompleto}</td>
					<td nowrap="nowrap">${aportacion.monto}</td>
					<td nowrap="nowrap">${aportacion.fechaVencimiento}</td>
					<td nowrap="nowrap">${aportacion.descripcion}</td>
				</tr>
			</c:forEach>
		</c:when>

		<c:when test="${tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td>N&uacute;mero</td>
				<td>Nombre</td>
				<td>Monto</td>
				<td>Vencimiento</td>
				<td>Tipo Aportaci&oacute;n</td>
			</tr>
			<c:forEach items="${aportaciones}" var="aportacion" >
				<tr onclick="cargaValorLista('${campoLista}', '${aportacion.aportacionID}');">
					<td>${aportacion.aportacionID}</td>
					<td>${aportacion.nombreCompleto}</td>
					<td>${aportacion.monto}</td>
					<td>${aportacion.fechaVencimiento}</td>
					<td>${aportacion.descripcion}</td>
				</tr>
			</c:forEach>
		</c:when>

		<c:when test="${tipoLista == '3'}">
			<tr id="encabezadoLista">
				<td>N&uacute;mero</td>
				<td>Nombre</td>
				<td>Monto</td>
				<td>Vencimiento</td>
				<td>Tipo Aportaci&oacute;n</td>
			</tr>
			<c:forEach items="${aportaciones}" var="aportacion" >
				<tr onclick="cargaValorLista('${campoLista}', '${aportacion.aportacionID}');">
					<td>${aportacion.aportacionID}</td>
					<td>${aportacion.nombreCompleto}</td>
					<td>${aportacion.monto}</td>
					<td>${aportacion.fechaVencimiento}</td>
					<td>${aportacion.descripcion}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>


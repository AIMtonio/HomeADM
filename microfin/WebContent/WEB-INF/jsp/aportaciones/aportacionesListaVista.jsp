<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="aportaciones" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1' || tipoLista == '6' || tipoLista == '7' || tipoLista == '12' || tipoLista == '13' || tipoLista == '20'}">
			<tr id="encabezadoLista">
				<td nowrap="nowrap">No. Aportaci&oacute;n</td>
				<td nowrap="nowrap">Nombre <s:message code="safilocale.cliente"/></td>
				<td nowrap="nowrap">Monto</td>
				<td nowrap="nowrap">Fecha Vencimiento</td>
				<td nowrap="nowrap">Descripci&oacute;n</td>
				<td nowrap="nowrap">Estatus Aportaci&oacute;n</td>
			</tr>
			<c:forEach items="${aportaciones}" var="aportacion" >
				<tr onclick="cargaValorLista('${campoLista}', '${aportacion.aportacionID}');">
					<td nowrap="nowrap">${aportacion.aportacionID}</td>
					<td nowrap="nowrap">${aportacion.nombreCompleto}</td>
					<td nowrap="nowrap">${aportacion.monto}</td>
					<td nowrap="nowrap">${aportacion.fechaVencimiento}</td>
					<td nowrap="nowrap">${aportacion.descripcion}</td>
					<td nowrap="nowrap">${aportacion.estatus}</td>
				</tr>
			</c:forEach>
		</c:when>

		<c:when test="${tipoLista == '4'}">
			<tr id="encabezadoLista">
				<td nowrap="nowrap">No. Aportaci&oacute;n</td>
				<td nowrap="nowrap">Nombre <s:message code="safilocale.cliente"/></td>
				<td nowrap="nowrap">Monto</td>
				<td nowrap="nowrap">Fecha Vencimiento</td>
				<td nowrap="nowrap">Descripci&oacute;n</td>
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

		<c:when test="${tipoLista == '5'}">
			<tr id="encabezadoLista">
				<td nowrap="nowrap">No. Aportaci&oacute;n</td>
				<td nowrap="nowrap">Nombre <s:message code="safilocale.cliente"/></td>
				<td nowrap="nowrap">Monto</td>
				<td nowrap="nowrap">Fecha Vencimiento</td>
				<td nowrap="nowrap">Descripci&oacute;n</td>
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

		<c:when test="${tipoLista == '10' || tipoLista == '11'}">
			<tr id="encabezadoLista">
				<td nowrap="nowrap">No. Aportaci&oacute;n</td>
				<td nowrap="nowrap">Nombre <s:message code="safilocale.cliente"/></td>
				<td nowrap="nowrap">Monto</td>
				<td nowrap="nowrap">Fecha Vencimiento</td>
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
		
		<c:when test="${tipoLista == '19'}"> 
			<tr id="encabezadoLista">
				<td><s:message code="safilocale.liscliente"/></td>
				<td nowrap="nowrap">Nombre</td>
			</tr>
			<c:forEach items="${aportaciones}" var="cliente" >
				<tr onclick="cargaValorListaCte('${campoLista}', '${cliente.numero}');">
					<td nowrap="nowrap">${cliente.numero}</td>
					<td nowrap="nowrap">${cliente.nombreCompleto}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>


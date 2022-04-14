<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="cajeroATM" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td >Cajero:</td>
				<td>Usuario:</td>
				<td>Sucursal:</td>
			</tr>
			<c:forEach items="${cajeroATM}" var="cajero" >
				<tr onclick="cargaValorLista('${campoLista}', '${cajero.cajeroID}');">
					<td>${cajero.cajeroID}</td>
					<td>${cajero.nombreCompleto}</td>
					<td>${cajero.nombreSucursal}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td nowrap="nowrap">Cajero:</td>
				<td nowrap="nowrap">Usuario:</td>
				<td nowrap="nowrap">Sucursal:</td>
				<td nowrap="nowrap">Ubicación:</td>
			</tr>
			<c:forEach items="${cajeroATM}" var="cajero" >
				<tr onclick="cargaValorLista('${campoLista}', '${cajero.cajeroID}');">
					<td nowrap="nowrap">${cajero.cajeroID}</td>
					<td nowrap="nowrap">${cajero.nombreCompleto}</td>
					<td nowrap="nowrap">${cajero.nombreSucursal}</td>
					<td nowrap="nowrap">${cajero.ubicacion}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>


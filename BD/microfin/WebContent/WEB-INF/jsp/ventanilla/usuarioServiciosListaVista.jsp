<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="usuarios" value="${listaResultado[2]}"/>


<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1' || tipoLista == '5'}">
			<tr id="encabezadoLista">
				<td>Usuario</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${usuarios}" var="usuarioServicios" >
				<tr onclick="cargaValorLista('${campoLista}', '${usuarioServicios.usuarioID}');">
					<td>${usuarioServicios.usuarioID}</td>
					<td>${usuarioServicios.nombreCompleto}</td>
				</tr>
			</c:forEach>
		</c:when>

		<c:when test="${tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td>Usuario</td>
				<td  nowrap="nowrap">Nombre</td>
				<td  nowrap="nowrap">Dirección</td>
				<td  nowrap="nowrap">Sucursal</td>
			</tr>
			<c:forEach items="${usuarios}" var="usuarioServicios" >
				<tr onclick="cargaValorListaCte('${campoLista}', '${usuarioServicios.usuarioID}');">
					<td nowrap="nowrap">${usuarioServicios.usuarioID}</td>
					<td nowrap="nowrap">${usuarioServicios.nombreCompleto}</td>
					<td nowrap="nowrap">${usuarioServicios.direccion}</td>
					<td nowrap="nowrap">${usuarioServicios.nombreSucursal}</td>
				</tr>
			</c:forEach>
		</c:when>

		<c:when test="${tipoLista == '3'}">
			<tr id="encabezadoLista">
				<td>Remitente</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${usuarios}" var="usuarioServicios" >
				<tr onclick="cargaValorListaCte('${campoLista}', '${usuarioServicios.remitenteID}');">
					<td nowrap="nowrap">${usuarioServicios.remitenteID}</td>
					<td nowrap="nowrap">${usuarioServicios.nombreCompleto}</td>
				</tr>
			</c:forEach>
		</c:when>
  	</c:choose>
</table>

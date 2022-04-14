<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="arrendamientosBean" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<!-- BUSQUEDA GENERAL -->
		<c:when test="${ tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td>ArrendamientoID</td>
				<td nowrap="nowrap">No. <s:message code="safilocale.cliente"/></td>
				<td><s:message code="safilocale.cliente"/></td>
				<td>Estatus</td>
				<td>Nombre Producto</td>	
				<td>Sucursal</td>
				<td>Fec.Inicio</td>	
				<td>Fec.Fin</td>	
			</tr>
			<c:forEach items="${arrendamientosBean}" var="arrendamientos" >
				<tr onclick="cargaValorLista('${campoLista}', '${arrendamientos.arrendaID}');">
					<td>${arrendamientos.arrendaID}</td>
					<td nowrap="nowrap">${arrendamientos.clienteID}</td>
					<td nowrap="nowrap">${arrendamientos.nombreCliente}</td>
					
					<c:if test="${arrendamientos.estatus == 'V'}">
						<td>VIGENTE</td>   
					</c:if> 
					<c:if test="${arrendamientos.estatus == 'A'}">
						<td>AUTORIZADO</td> 
					</c:if>
					<c:if test="${arrendamientos.estatus == 'P'}">
						<td>PAGADO</td>
					</c:if> 
					<c:if test="${arrendamientos.estatus == 'C'}">
						<td>CANCELADO</td>
					</c:if>
					<c:if test="${arrendamientos.estatus == 'B'}">
						<td>VENCIDO</td>
					</c:if>
					<c:if test="${arrendamientos.estatus == 'G'}">
						<td>GENERADO</td>
					</c:if>  
					<td nowrap="nowrap">${arrendamientos.productoArrendaID}</td>
					<td nowrap="nowrap">${arrendamientos.sucursalID}</td>
					<td nowrap="nowrap">${arrendamientos.fechaPrimerVen}</td>
					<td nowrap="nowrap">${arrendamientos.fechaUltimoVen}</td>
				</tr>
			</c:forEach>
		</c:when>
		<!-- BUSQUEDA X SUCURSAL -->
		<c:when test="${ tipoLista == '3'}">
			<tr id="encabezadoLista">
				<td>ArrendamientoID</td>
				<td nowrap="nowrap">No. <s:message code="safilocale.cliente"/></td>
				<td><s:message code="safilocale.cliente"/></td>
				<td>Estatus</td>
				<td>Nombre Producto</td>
				<td>Fec.Inicio</td>	
				<td>Fec.Fin</td>
			</tr>
			<c:forEach items="${arrendamientosBean}" var="arrendamientos" >
				<tr onclick="cargaValorLista('${campoLista}', '${arrendamientos.arrendaID}');">
					<td>${creditos.creditoID}</td>
					<td nowrap="nowrap">${arrendamientos.clienteID}</td>
					<td nowrap="nowrap">${arrendamientos.nombreCliente}</td>
					
					<c:if test="${arrendamientos.estatus == 'V'}">
						<td>VIGENTE</td>   
					</c:if> 
					<c:if test="${arrendamientos.estatus == 'A'}">
						<td>AUTORIZADO</td> 
					</c:if>
					<c:if test="${arrendamientos.estatus == 'P'}">
						<td>PAGADO</td>
					</c:if> 
					<c:if test="${arrendamientos.estatus == 'C'}">
						<td>CANCELADO</td>
					</c:if>
					<c:if test="${arrendamientos.estatus == 'B'}">
						<td>VENCIDO</td>
					</c:if>
					<c:if test="${arrendamientos.estatus == 'G'}">
						<td>GENERADO</td>
					</c:if> 
					<td nowrap="nowrap">${arrendamientos.productoArrendaID}</td>
					<td nowrap="nowrap">${arrendamientos.fechaPrimerVen}</td>
					<td nowrap="nowrap">${arrendamientos.fechaVencimien}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
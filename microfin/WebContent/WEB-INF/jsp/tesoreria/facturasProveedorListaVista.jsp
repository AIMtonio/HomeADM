<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="facturaprovBean" value="${listaResultado[2]}"/>

<table id="tablaLista" WIDTH="480">
	<c:choose>
		<c:when test="${tipoLista >= '1' && tipoLista < '4' }">
			<tr id="encabezadoLista">
				<td>Factura</td>
				<td>Proveedor</td>
				<td>Estatus</td>
			</tr>
			
			<c:forEach items="${facturaprovBean}" var="facturas" >
 				<tr onclick="cargaValorLista('${campoLista}','${facturas.noFactura}');" >
					<td>${facturas.noFactura}</td>
					<td>${facturas.facturaProvID}</td>
					<c:if test="${facturas.estatus == 'A'}">
						<td>ALTA</td>						
					</c:if>
					<c:if test="${facturas.estatus == 'C'}">
						<td>CANCELADA</td>
					</c:if>
					<c:if test="${facturas.estatus == 'P'}">
						<td>PARCIALMENTE PAGADA</td>
					</c:if>
						<c:if test="${facturas.estatus == 'L'}">
						<td>LIQUIDADA </td>
					</c:if>
					<c:if test="${facturas.estatus == 'R'}">
						<td>EN PROCESO REQUISICIÓN </td>
					</c:if>
					<c:if test="${facturas.estatus == 'I'}">
						<td>IMPORTADA </td>
					</c:if>
				</tr>
			</c:forEach>
		</c:when>
		
		<c:when test="${tipoLista == '4'}">
			<tr id="encabezadoLista">
				<td>Factura</td>
				<td>Proveedor</td>
				<td>Estatus</td>
			</tr>
			<c:forEach items="${facturaprovBean}" var="facturas" >
				<tr onclick="cargaValorListaFacturaProv('${campoLista}','${facturas.noFactura}','${facturas.proveedorID}');" >
					<td>${facturas.noFactura}</td>
					<td>${facturas.facturaProvID}</td>
					<c:if test="${facturas.estatus == 'A'}">
						<td>ALTA</td>
					</c:if>
					<c:if test="${facturas.estatus == 'C'}">
						<td>CANCELADA</td>
					</c:if>
					<c:if test="${facturas.estatus == 'P'}">
						<td>PARCIALMENTE PAGADA</td>
					</c:if>
						<c:if test="${facturas.estatus == 'L'}">
						<td>LIQUIDADA </td>
					</c:if>
					<c:if test="${facturas.estatus == 'R'}">
						<td>EN PROCESO REQUISICIÓN </td>
					</c:if>
					<c:if test="${facturas.estatus == 'I'}">
						<td>IMPORTADA </td>
					</c:if>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '5'}">
			<tr id="encabezadoLista">
				<td>Factura</td>
				<td>Proveedor</td>
				<td>Estatus</td>
			</tr>
			<c:forEach items="${facturaprovBean}" var="facturas" >
				<tr onclick="cargaValorListaFacturaProv('${campoLista}','${facturas.noFactura}','${facturas.proveedorID}');" >
					<td>${facturas.noFactura}</td>
					<td>${facturas.facturaProvID}</td>
					<c:if test="${facturas.estatus == 'A'}">
						<td>ALTA</td>
					</c:if>
					<c:if test="${facturas.estatus == 'C'}">
						<td>CANCELADA</td>
					</c:if>
					<c:if test="${facturas.estatus == 'P'}">
						<td>PARCIALMENTE PAGADA</td>
					</c:if>
						<c:if test="${facturas.estatus == 'L'}">
						<td>LIQUIDADA </td>
					</c:if>
					<c:if test="${facturas.estatus == 'R'}">
						<td>EN PROCESO REQUISICIÓN </td>
					</c:if>
					<c:if test="${facturas.estatus == 'I'}">
						<td>IMPORTADA </td>
					</c:if>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '6'}">
			<tr id="encabezadoLista">
				<td>Factura</td>
				<td>Proveedor</td>
				<td>Estatus</td>
			</tr>
			<c:forEach items="${facturaprovBean}" var="facturas" >
				<tr onclick="cargaValorLista('${campoLista}','${facturas.noFactura}');" >
					<td>${facturas.noFactura}</td>
					<td>${facturas.facturaProvID}</td>
					<c:if test="${facturas.estatus == 'A'}">
						<td>ALTA</td>
					</c:if>
					<c:if test="${facturas.estatus == 'C'}">
						<td>CANCELADA</td>
					</c:if>
					<c:if test="${facturas.estatus == 'P'}">
						<td>PARCIALMENTE PAGADA</td>
					</c:if>
						<c:if test="${facturas.estatus == 'L'}">
						<td>LIQUIDADA </td>
					</c:if>
					<c:if test="${facturas.estatus == 'R'}">
						<td>EN PROCESO REQUISICIÓN </td>
					</c:if>
					<c:if test="${facturas.estatus == 'I'}">
						<td>IMPORTADA </td>
					</c:if>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
 
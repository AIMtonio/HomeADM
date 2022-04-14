<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="arrendaBean" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'|| tipoLista=='6'}">
			<tr id="encabezadoLista">
				<td>ArrendaID</td>
				<td nowrap="nowrap"><s:message code="safilocale.cliente"/></td>
				<td>Estatus</td>
				<td>Nombre Producto</td>	
				<td>Fec.Apertura</td>
				<td>Fec.Ult.Ven</td>
			</tr>
			<c:forEach items="${arrendaBean}" var="arrendamientos" >
				<tr onclick="cargaValorLista('${campoLista}', '${arrendamientos.arrendaID}');">
					<td nowrap="nowrap">${arrendamientos.arrendaID}</td>
					<td nowrap="nowrap">${arrendamientos.nombreCompleto}</td>
					<td nowrap="nowrap">${arrendamientos.estatus}</td>
					<td nowrap="nowrap">${arrendamientos.descripProducto}</td>
					<td nowrap="nowrap">${arrendamientos.fechaApertura}</td>
					<td nowrap="nowrap">${arrendamientos.fechaUltimoVen}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '5'}">
			<tr id="encabezadoLista">
				<td>ArrendaID</td>
				<td nowrap="nowrap"><s:message code="safilocale.cliente"/></td>
				<td>Estatus</td>
				<td>Nombre Producto</td>	
				<td>Sucursal</td>
				<td>Fec.Apertura</td>
				<td>Fec.Ult.Ven</td>
			</tr>
			<c:forEach items="${arrendaBean}" var="arrendamientos" >
				<tr onclick="cargaValorLista('${campoLista}', '${arrendamientos.arrendaID}');">
					<td nowrap="nowrap">${arrendamientos.arrendaID}</td>
					<td nowrap="nowrap">${arrendamientos.nombreCompleto}</td>
					<td nowrap="nowrap">${arrendamientos.estatus}</td>
					<td nowrap="nowrap">${arrendamientos.descripProducto}</td>
					<td nowrap="nowrap">${arrendamientos.nombreSucursal}</td>
					<td nowrap="nowrap">${arrendamientos.fechaApertura}</td>
					<td nowrap="nowrap">${arrendamientos.fechaUltimoVen}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
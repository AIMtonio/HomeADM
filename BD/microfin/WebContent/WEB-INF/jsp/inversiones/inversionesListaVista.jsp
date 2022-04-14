<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="inversiones" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1' || tipoLista == '8' || tipoLista == '9'}">
			<tr id="encabezadoLista">
				<td nowrap="nowrap">Numero</td>
				<td nowrap="nowrap">Nombre</td>
				<td nowrap="nowrap">Monto</td>
				<td nowrap="nowrap">Vencimiento</td>
				<td nowrap="nowrap">Tipo Inversi&oacute;n</td>
			</tr>
			<c:forEach items="${inversiones}" var="inversion" >
				<tr onclick="cargaValorLista('${campoLista}', '${inversion.inversionID}');">
					<td nowrap="nowrap">${inversion.inversionID}</td>		
					<td nowrap="nowrap">${inversion.nombreCompleto}</td>			
					<td nowrap="nowrap">${inversion.montoString}</td>
					<td nowrap="nowrap">${inversion.fechaVencimiento}</td>
					<td nowrap="nowrap">${inversion.descripcion}</td>
				</tr>
			</c:forEach>		
		</c:when>
		<c:when test="${tipoLista == '3'}">
			<tr id="encabezadoLista">
				<td>Numero</td>
				<td>Nombre</td>
				<td>Monto</td>
				<td>Vencimiento</td>
				<td>Tipo Inversi&oacute;n</td>
			</tr>
			<c:forEach items="${inversiones}" var="inversion" >
				<tr onclick="cargaValorLista('${campoLista}', '${inversion.inversionID}');">
					<td>${inversion.inversionID}</td>
					<td>${inversion.nombreCompleto}</td>	
					<td>${inversion.montoString}</td>
					<td>${inversion.fechaVencimiento}</td>
					<td>${inversion.descripcion}</td>
				</tr>
			</c:forEach>		
		</c:when>
		
				<c:when test="${tipoLista == '5'}">
			<tr id="encabezadoLista">
				<td>Numero</td>
				<td>Nombre</td>
				<td>Monto</td>
				<td>Vencimiento</td>
				<td>Tipo Inversi&oacute;n</td>
			</tr>
			<c:forEach items="${inversiones}" var="inversion" >
				<tr onclick="cargaValorLista('${campoLista}', '${inversion.inversionID}');">
					<td>${inversion.inversionID}</td>
					<td>${inversion.nombreCompleto}</td>	
					<td>${inversion.montoString}</td>
					<td>${inversion.fechaVencimiento}</td>
					<td>${inversion.descripcion}</td>
				</tr>
			</c:forEach>		
		</c:when>
		
		<c:when test="${tipoLista == '6'}">
			<tr id="encabezadoLista">
				<td>Numero</td>
				<td>Nombre</td>
				<td>Monto</td>
				<td>Vencimiento</td>
				<td>Tipo Inversi&oacute;n</td>
			</tr>
			<c:forEach items="${inversiones}" var="inversion" >
				<tr onclick="cargaValorLista('${campoLista}', '${inversion.inversionID}');">
					<td>${inversion.inversionID}</td>
					<td>${inversion.nombreCompleto}</td>	
					<td>${inversion.montoString}</td>
					<td>${inversion.fechaVencimiento}</td>
					<td>${inversion.descripcion}</td>
				</tr>
			</c:forEach>		
		</c:when>
		
		<c:when test="${tipoLista == '7'}">
			<tr id="encabezadoLista">
				<td>Numero</td>
				<td>Etiqueta</td>
				<td>Monto</td>
				<td>Vencimiento</td>
				<td>Tipo Inversi&oacute;n</td>
			</tr>
			<c:forEach items="${inversiones}" var="inversion" >
				<tr onclick="cargaValorLista('${campoLista}', '${inversion.inversionID}');">
					<td>${inversion.inversionID}</td>
					<td>${inversion.etiqueta}</td>	
					<td>${inversion.montoString}</td>
					<td>${inversion.fechaVencimiento}</td>
					<td>${inversion.descripcion}</td>
				</tr>
			</c:forEach>		
		</c:when>
	</c:choose>	
</table>


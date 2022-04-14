<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="cedes" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose> 
		<c:when test="${tipoLista == '1' || tipoLista == '6' || tipoLista == '7' || tipoLista == '12' || tipoLista == '13'}">
			<tr id="encabezadoLista">
				<td nowrap="nowrap">No. CEDE</td>
				<td nowrap="nowrap">Nombre Cliente</td>
				<td nowrap="nowrap">Monto</td>
				<td nowrap="nowrap">Fecha Vencimiento</td>
				<td nowrap="nowrap">Descripci&oacute;n</td>
				<td nowrap="nowrap">Estatus CEDE</td>				
			</tr>
			<c:forEach items="${cedes}" var="cede" >
				<tr onclick="cargaValorLista('${campoLista}', '${cede.cedeID}');">
					<td nowrap="nowrap">${cede.cedeID}</td>		
					<td nowrap="nowrap">${cede.nombreCompleto}</td>			
					<td nowrap="nowrap">${cede.monto}</td>
					<td nowrap="nowrap">${cede.fechaVencimiento}</td>
					<td nowrap="nowrap">${cede.descripcion}</td>
					<td nowrap="nowrap">${cede.estatus}</td>							
				</tr>
			</c:forEach>		
		</c:when>
		
		<c:when test="${tipoLista == '4'}">
			<tr id="encabezadoLista">
				<td nowrap="nowrap">No. CEDE</td>
				<td nowrap="nowrap">Nombre Cliente</td>
				<td nowrap="nowrap">Monto</td>
				<td nowrap="nowrap">Fecha Vencimiento</td>
				<td nowrap="nowrap">Descripci&oacute;n</td>
							
			</tr>
			<c:forEach items="${cedes}" var="cede" >
				<tr onclick="cargaValorLista('${campoLista}', '${cede.cedeID}');">
					<td nowrap="nowrap">${cede.cedeID}</td>		
					<td nowrap="nowrap">${cede.nombreCompleto}</td>			
					<td nowrap="nowrap">${cede.monto}</td>
					<td nowrap="nowrap">${cede.fechaVencimiento}</td>
					<td nowrap="nowrap">${cede.descripcion}</td>
										
				</tr>
			</c:forEach>		
		</c:when>
		
				<c:when test="${tipoLista == '5'}">
			<tr id="encabezadoLista">
				<td nowrap="nowrap">No. CEDE</td>
				<td nowrap="nowrap">Nombre Cliente</td>
				<td nowrap="nowrap">Monto</td>
				<td nowrap="nowrap">Fecha Vencimiento</td>
				<td nowrap="nowrap">Descripci&oacute;n</td>
							
			</tr>
			<c:forEach items="${cedes}" var="cede" >
				<tr onclick="cargaValorLista('${campoLista}', '${cede.cedeID}');">
					<td nowrap="nowrap">${cede.cedeID}</td>		
					<td nowrap="nowrap">${cede.nombreCompleto}</td>			
					<td nowrap="nowrap">${cede.monto}</td>
					<td nowrap="nowrap">${cede.fechaVencimiento}</td>
					<td nowrap="nowrap">${cede.descripcion}</td>
										
				</tr>
			</c:forEach>		
		</c:when>
		
		<c:when test="${tipoLista == '10' || tipoLista == '11'}">
			<tr id="encabezadoLista">
				<td nowrap="nowrap">No. CEDE</td>
				<td nowrap="nowrap">Nombre Cliente</td>
				<td nowrap="nowrap">Monto</td>
				<td nowrap="nowrap">Fecha Vencimiento</td>
				<td nowrap="nowrap">Tipo Cede</td>
							
			</tr>
			<c:forEach items="${cedes}" var="cede" >
				<tr onclick="cargaValorLista('${campoLista}', '${cede.cedeID}');">
					<td nowrap="nowrap">${cede.cedeID}</td>		
					<td nowrap="nowrap">${cede.nombreCompleto}</td>			
					<td nowrap="nowrap">${cede.monto}</td>
					<td nowrap="nowrap">${cede.fechaVencimiento}</td>
					<td nowrap="nowrap">${cede.descripcion}</td>
										
				</tr>
			</c:forEach>		
		</c:when>
		
	</c:choose>	
</table>


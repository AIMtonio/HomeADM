<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="domiciliacionPagosBean" value="${listaResultado[2]}"/>


<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td>No. <s:message code="safilocale.cliente"/></td>			
				<td  nowrap="nowrap">Nombre</td>
			</tr>
			<c:forEach items="${domiciliacionPagosBean}" var="cliente" >
				<tr onclick="cargaValorLista('${campoLista}', '${cliente.clienteID}');">
					<td>${cliente.clienteID}</td>
					<td>${cliente.nombreCliente}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '7' }">
			<tr id="encabezadoLista">
				<td>Fecha</td>			
				<td  nowrap="nowrap">Folio</td>
				<td nowrap="nowrap">Nombre Archivo</td>
			</tr>
			<c:forEach items="${domiciliacionPagosBean}" var="cliente" >
				<tr onclick="cargaValorLista('${campoLista}', '${cliente.folioID}');">
					<td>${cliente.fechaArchivo}</td>
					<td>${cliente.folioID}</td>
					<td>${cliente.nombreArchivo}</td>
				</tr>
			</c:forEach>
		
		</c:when>
		
	</c:choose>
</table>
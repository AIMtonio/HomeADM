<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="operEscalamientoInterno" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td>Folio</td>
				<td>Nombre <s:message code="safilocale.cliente"/></td>			
			</tr>
			<c:forEach items="${operEscalamientoInterno}" var="opeEscalaInt" >
				<tr onclick="cargaValorLista('${campoLista}', '${opeEscalaInt.folioOperacionID}');">
					<td>${opeEscalaInt.folioOperacionID}</td>
					<td>${opeEscalaInt.nombreCliente}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td>Folio</td>
				<td>Nombre <s:message code="safilocale.cliente"/>/Usuario</td>
				<td>Monto</td>
				<td>Fecha</td>
				<td>Operaci&oacute;n</td>
				<td>Estatus</td>		
			</tr>
			<c:forEach items="${operEscalamientoInterno}" var="opeEscalaInt" >
				<tr onclick="cargaValorLista('${campoLista}', '${opeEscalaInt.folioOperacionID}');">
					<td>${opeEscalaInt.folioOperacionID}</td>
					<td>${opeEscalaInt.nombreCliente}</td>
					<td>${opeEscalaInt.monto}</td>
					<td>${opeEscalaInt.fechaOperacion}</td>
					<td>${opeEscalaInt.operacionDesc}</td>
					<td>${opeEscalaInt.estatus}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
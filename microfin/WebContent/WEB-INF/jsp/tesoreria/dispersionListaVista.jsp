<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="tipoLista"  	value="${listaResultado[0]}"/>
<c:set var="campoLista" 	value="${listaResultado[1]}"/>
<c:set var="dispersionBean" value="${listaResultado[2]}"/>


<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td>Folio</td>
				<td>Instituci&oacute;n</td>
				<td>No. Cuenta</td>
				<td>Fecha</td>					
			</tr>
			<c:forEach items="${dispersionBean}" var="filaDispersion" >
			<tr onclick="cargaValorLista('${campoLista}', '${filaDispersion.folioOperacion}');">
				<td>${filaDispersion.folioOperacion}</td>
				<td>${filaDispersion.nombreCorto}</td>
				<td>${filaDispersion.numCtaInstit}</td>
				<td>${filaDispersion.fechaOperacion}</td>
			</tr>
			</c:forEach>
		</c:when>
		
		<c:when test="${tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td>Folio</td>
				<td>Instituci&oacute;n</td>
				<td>No. Cuenta</td>
				<td>Fecha</td>					
			</tr>
			<c:forEach items="${dispersionBean}" var="filaDispersion" >
			<tr onclick="cargaValorLista('${campoLista}', '${filaDispersion.folioOperacion}');">
				<td>${filaDispersion.folioOperacion}</td>
				<td>${filaDispersion.nombreCorto}</td>
				<td>${filaDispersion.numCtaInstit}</td>
				<td>${filaDispersion.fechaOperacion}</td>
			</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '3'}">
			<tr id="encabezadoLista">
				<td>Solicitud</td>
				<td>Nombre Beneficiario</td>
				<td>Monto</td>			
			</tr>
			<c:forEach items="${dispersionBean}" var="filaDispersion" >
			<tr onclick="cargaValorLista('${campoLista}', '${filaDispersion.solicitudCreditoID}');">
				<td>${filaDispersion.solicitudCreditoID}</td>
				<td>${filaDispersion.nombreCompleto}</td>
				<td>${filaDispersion.montoDisp}</td>
			</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '4'}">
			<tr id="encabezadoLista">
				<td>Referencia</td>
				<td>Nombre Beneficiario</td>
				<td>Monto</td>			
			</tr>
			<c:forEach items="${dispersionBean}" var="filaDispersion" >
			<tr onclick="cargaValorLista('${campoLista}', '${filaDispersion.cuentaDestino}');">
				<td>${filaDispersion.cuentaDestino}</td>
				<td>${filaDispersion.nombreCompleto}</td>
				<td>${filaDispersion.montoDisp}</td>
			</tr>
			</c:forEach>
		</c:when>

	</c:choose>
</table>


<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="lineasCreditoBean" value="${listaResultado[2]}"/>


<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td>L&iacute;nea Cr&eacute;dito</td> 
				<td><s:message code="safilocale.cliente"/></td>
			</tr>
			<c:forEach items="${lineasCreditoBean}" var="lineasCredito" >
				<tr onclick="cargaValorLista('${campoLista}', '${lineasCredito.lineaCreditoID}');">
					<td>${lineasCredito.lineaCreditoID}</td>
					<td>${lineasCredito.clienteID}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '3'}">
			<tr id="encabezadoLista">
				<td>L&iacute;nea Cr&eacute;dito</td>
				<td><s:message code="safilocale.cliente"/></td>
			</tr>
			<c:forEach items="${lineasCreditoBean}" var="lineasCredito" >
				<tr onclick="cargaValorLista('${campoLista}', '${lineasCredito.lineaCreditoID}');">
					<td>${lineasCredito.lineaCreditoID}</td>
					<td>${lineasCredito.clienteID}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '4'}">
			<tr id="encabezadoLista">
				<td>L&iacute;nea Cr&eacute;dito</td>
				<td><s:message code="safilocale.cliente"/></td>
			</tr>
			<c:forEach items="${lineasCreditoBean}" var="lineasCredito" >
				<tr onclick="cargaValorLista('${campoLista}', '${lineasCredito.lineaCreditoID}');">
					<td>${lineasCredito.lineaCreditoID}</td>
					<td>${lineasCredito.clienteID}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '5'}">
			<tr id="encabezadoLista">
				<td>L&iacute;nea Cr&eacute;dito</td>
				<td><s:message code="safilocale.cliente"/></td>
			</tr>
			<c:forEach items="${lineasCreditoBean}" var="lineasCredito" >
				<tr onclick="cargaValorLista('${campoLista}', '${lineasCredito.lineaCreditoID}');">
					<td>${lineasCredito.lineaCreditoID}</td>
					<td>${lineasCredito.clienteID}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '6'}">
			<tr id="encabezadoLista">
				<td>L&iacute;nea Cr&eacute;dito</td>
				<td><s:message code="safilocale.cliente"/></td>
			</tr>
			<c:forEach items="${lineasCreditoBean}" var="lineasCredito" >
				<tr onclick="cargaValorLista('${campoLista}', '${lineasCredito.lineaCreditoID}');">
					<td>${lineasCredito.lineaCreditoID}</td>
					<td>${lineasCredito.clienteID}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '7' || tipoLista == '9'}">
			<tr id="encabezadoLista">
				<td>L&iacute;nea Cr&eacute;dito</td>
				<td>Cuenta Ahorro</td>
				<td><s:message code="safilocale.cliente"/></td>
			</tr>
			<c:forEach items="${lineasCreditoBean}" var="lineasCredito" >
				<tr onclick="cargaValorLista('${campoLista}', '${lineasCredito.lineaCreditoID}');">
					<td>${lineasCredito.lineaCreditoID}</td>
					<td>${lineasCredito.cuentaID}</td>
					<td>${lineasCredito.clienteID}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '8'}">
			<tr id="encabezadoLista">
				<td>L&iacute;nea Cr&eacute;dito</td>
				<td>Tipo L&iacute;nea</td>
				<td>Saldo Disponible</td>
				<td>Fecha Vencimiento</td>
			</tr>
			<c:forEach items="${lineasCreditoBean}" var="lineasCredito" >
				<tr onclick="cargaValorLista('${campoLista}', '${lineasCredito.lineaCreditoID}');">
					<td>${lineasCredito.lineaCreditoID}</td>
					<td>${lineasCredito.descripcion}</td>
					<td>${lineasCredito.saldoDisponible}</td>
					<td>${lineasCredito.fechaVencimiento}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>


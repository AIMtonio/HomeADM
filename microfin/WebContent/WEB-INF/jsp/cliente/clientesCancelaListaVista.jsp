<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="clientesCancelaBean" value="${listaResultado[2]}"/>


<table id="tablaLista">
	<c:choose>
	<c:when test="${tipoLista == '1' || tipoLista == '2'}">
	<tr id="encabezadoLista">
		<td>Folio</td>
		<td><s:message code="safilocale.cliente"/></td>
		<td>Nombre <s:message code="safilocale.cliente"/> </td>
		<td>Estatus</td>
	</tr>
	<c:forEach items="${clientesCancelaBean}" var="filaClientesCancela" >
		<tr onclick="cargaValorLista('${campoLista}', '${filaClientesCancela.clienteCancelaID}');">
			<td>${filaClientesCancela.clienteCancelaID}</td>
			<td>${filaClientesCancela.clienteID}</td>
			<td>${filaClientesCancela.nombreCompleto}</td>
			<td>${filaClientesCancela.estatusDes}</td>
		</tr>
	</c:forEach>
	</c:when>
	<c:when test="${tipoLista == '3'}">
		<tr id="encabezadoLista">
			<td>Folio</td>
			<td><s:message code="safilocale.cliente"/></td>
			<td>Nombre <s:message code="safilocale.cliente"/> </td>
			<td>Estatus</td>
		</tr>
		<c:forEach items="${clientesCancelaBean}" var="listaClientes" >
			<tr onclick="cargaValorLista('${campoLista}', '${listaClientes.clienteCancelaID}');">
				<td>${listaClientes.clienteCancelaID}</td>
				<td>${listaClientes.clienteID}</td>
				<td>${listaClientes.nombreCompleto}</td>
				<td>${listaClientes.estatusDes}</td>
			</tr>
		</c:forEach>
	</c:when>
	<c:when test="${tipoLista == '4'}">
		<tr id="encabezadoLista">
			<td>Folio</td>
			<td><s:message code="safilocale.cliente"/></td>
			<td>Nombre <s:message code="safilocale.cliente"/> </td>
			<td>Estatus</td>
		</tr>
		<c:forEach items="${clientesCancelaBean}" var="filaClientesCancela" >
			<tr onclick="cargaValorLista('${campoLista}', '${filaClientesCancela.clienteID}');">
				<td>${filaClientesCancela.clienteCancelaID}</td>
				<td>${filaClientesCancela.clienteID}</td>
				<td>${filaClientesCancela.nombreCompleto}</td>
				<td>${filaClientesCancela.estatusDes}</td>
			</tr>
		</c:forEach>
	</c:when>
    </c:choose>
</table>


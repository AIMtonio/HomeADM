<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="clienteSeguro" value="${listaResultado[2]}"/>


<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1' || tipoLista == '4' }"> 
			<tr id="encabezadoLista">
				<td><s:message code="safilocale.liscliente"/></td>	
				<td>Nombre</td>
			</tr>
			<c:forEach items="${clienteSeguro}" var="cliente" >
				<tr onclick="cargaValorListaCte('${campoLista}', '${cliente.clienteID}');">
					<td>${cliente.clienteID}</td>
					<td>${cliente.nombreCliente}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '5'}"> 
			<tr id="encabezadoLista">
				<td><s:message code="safilocale.liscliente"/></td>	
				<td>Nombre</td>
				<td>Sucursal</td>
			</tr>
			<c:forEach items="${clienteSeguro}" var="cliente" >
				<tr onclick="cargaValorListaCte('${campoLista}', '${cliente.clienteID}');">
					<td>${cliente.clienteID}</td>
					<td>${cliente.nombreCliente}</td>
					<td>${cliente.sucursalSeguro}</td>
				</tr>
			</c:forEach>
		</c:when>

		<c:when test="${tipoLista == '3'}"> 
			<tr id="encabezadoLista">
				<td>SeguroID</td>
				<td><s:message code="safilocale.cliente"/>ID</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${clienteSeguro}" var="cliente" >
				<tr onclick="cargaValorLista('${campoLista}', '${cliente.seguroClienteID}');">
					<td>${cliente.seguroClienteID}</td>
					<td>${cliente.clienteID}</td>
					<td>${cliente.nombreCliente}</td>
				</tr>
			</c:forEach>
		</c:when>
  	</c:choose>
</table>
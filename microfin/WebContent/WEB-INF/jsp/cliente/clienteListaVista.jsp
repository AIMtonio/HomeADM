<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
  

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="clientes" value="${listaResultado[2]}"/>


<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '19'  || tipoLista== '20'|| tipoLista== '21'|| tipoLista== '22'|| 
		tipoLista== '23' || tipoLista== '24'|| tipoLista== '25' || tipoLista== '26' || tipoLista== '27' 
	    || tipoLista== '32' || tipoLista == '35' || tipoLista == '38'}"> 
			<tr id="encabezadoLista">
				<td><s:message code="safilocale.liscliente"/></td>				
				<td  nowrap="nowrap">Nombre</td>
				<td  nowrap="nowrap">Dirección</td>
			</tr>
			<c:forEach items="${clientes}" var="cliente" >
				<tr onclick="cargaValorListaCte('${campoLista}', '${cliente.numero}');">
					<td nowrap="nowrap">${cliente.numero}</td>
					<td nowrap="nowrap">${cliente.nombreCompleto}</td>
					<td nowrap="nowrap">${cliente.direccion}</td>
				</tr>
			</c:forEach>
		
		</c:when>
		
		<c:when test="${tipoLista== '31' || tipoLista == '34'}"> 
			<tr id="encabezadoLista">
				<td><s:message code="safilocale.liscliente"/></td>				
				<td  nowrap="nowrap">Nombre</td>
				<td  nowrap="nowrap">Dirección</td>
				<td  nowrap="nowrap">Sucursal</td>
			</tr>
			<c:forEach items="${clientes}" var="cliente" >
				<tr onclick="cargaValorListaCte('${campoLista}', '${cliente.numero}');">
					<td nowrap="nowrap">${cliente.numero}</td>
					<td nowrap="nowrap">${cliente.nombreCompleto}</td>
					<td nowrap="nowrap">${cliente.direccion}</td>
					<td nowrap="nowrap">${cliente.nombSucursal}</td>
				</tr>
			</c:forEach>
		
		</c:when>
		
		
		<c:when test="${tipoLista == '1'  ||tipoLista == '8' ||tipoLista == '9'
		  ||tipoLista == '10' || tipoLista == '12' ||tipoLista == '13' ||tipoLista == '14' || tipoLista== '15'|| tipoLista== '16'
		  ||tipoLista == '5'  || tipoLista == '6' || tipoLista == '33' || tipoLista == '36' || tipoLista== '30' || tipoLista== '40'
		  || tipoLista == '39' || tipoLista== '41'}">
			<tr id="encabezadoLista">
				<td><s:message code="safilocale.liscliente"/></td>				
				<td  nowrap="nowrap">Nombre</td>
			</tr>
			<c:forEach items="${clientes}" var="cliente" >
				<tr onclick="cargaValorLista('${campoLista}', '${cliente.numero}');">
					<td nowrap="nowrap">${cliente.numero}</td>
					<td nowrap="nowrap">${cliente.nombreCompleto}</td>
				</tr>
			</c:forEach>		
		</c:when>
		
		<c:when test="${ tipoLista == '2'}"> 
			<tr id="encabezadoLista">
				<td><s:message code="safilocale.liscliente"/></td>
				<td nowrap="nowrap">Nombre</td>
				<td nowrap="nowrap">Teléfono</td>

			</tr>
			<c:forEach items="${clientes}" var="cliente" >
				<tr onclick="cargaValorListaCte('${campoLista}', '${cliente.telefonoCelular}');">
					<td nowrap="nowrap">${cliente.numero}</td>
					<td nowrap="nowrap">${cliente.nombreCompleto}</td>
					<td nowrap="nowrap">${cliente.telefonoCelular}</td>		
				</tr>
			</c:forEach>
		</c:when>
		
				<c:when test="${tipoLista == '28'}"> 
			<tr id="encabezadoLista">
				<td><s:message code="safilocale.liscliente"/></td>
				<td nowrap="nowrap">Nombre</td>
				<td nowrap="nowrap">Teléfono</td>
				<td nowrap="nowrap">Dirección</td>

			</tr>
			<c:forEach items="${clientes}" var="cliente" >
				<tr onclick="cargaValorListaCte('${campoLista}', '${cliente.telefonoCelular}');">
					<td nowrap="nowrap">${cliente.numero}</td>
					<td nowrap="nowrap">${cliente.nombreCompleto}</td>
					<td nowrap="nowrap">${cliente.telefonoCelular}</td>					
					<td nowrap="nowrap">${cliente.direccion}</td>
				</tr>
			</c:forEach>
		</c:when>

		<c:when test="${tipoLista == '3'}"> 
			<tr id="encabezadoLista">
				<td><s:message code="safilocale.liscliente"/></td>
				<td nowrap="nowrap">Nombre</td>
				<td nowrap="nowrap">Dirección</td>

			</tr>
			<c:forEach items="${clientes}" var="cliente" >
				<tr onclick="cargaValorListaCte('${campoLista}', '${cliente.numero}');">
					<td nowrap="nowrap">${cliente.numero}</td>
					<td nowrap="nowrap">${cliente.nombreCompleto}</td>
				</tr>
			</c:forEach>
		</c:when>
				<c:when test="${tipoLista == '29'}"> 
			<tr id="encabezadoLista">
				<td><s:message code="safilocale.liscliente"/></td>
				<td nowrap="nowrap">Nombre</td>
				<td nowrap="nowrap">Dirección</td>

			</tr>
			<c:forEach items="${clientes}" var="cliente" >
				<tr onclick="cargaValorListaCte('${campoLista}', '${cliente.numero}');">
					<td nowrap="nowrap">${cliente.numero}</td>
					<td nowrap="nowrap">${cliente.nombreCompleto}</td>
					<td nowrap="nowrap">${cliente.direccion}</td>
				</tr>
			</c:forEach>
		</c:when>

			<c:when test="${tipoLista == '4'}"> 
			<tr id="encabezadoLista">
				<td><s:message code="safilocale.liscliente"/></td>
				<td nowrap="nowrap">Nombre</td>
			</tr>
			<c:forEach items="${clientes}" var="cliente" >
				<tr onclick="cargaValorListaCte('${campoLista}', '${cliente.numero}');">
					<td nowrap="nowrap">${cliente.numero}</td>
					<td nowrap="nowrap">${cliente.nombreCompleto}</td>
				</tr>
			</c:forEach>
		</c:when>
  	</c:choose>
</table>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
  

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="cuentasDestino" value="${listaResultado[2]}"/>


<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}"> 
			<tr id="encabezadoLista">
				<td>Número Cuenta</td>
				<td>Alias</td>
				<td>Banco</td>
				<td>Cuenta Clabe</td>
			</tr>
			<c:forEach items="${cuentasDestino}" var="cuentas" >
				<tr onclick="cargaValorLista('${campoLista}', '${cuentas.cuentaTranID}');">
					<td>${cuentas.cuentaTranID}</td>
					<td>${cuentas.alias}</td>
					<td>${cuentas.nombre}</td>
					<td>${cuentas.clabe}</td>
				</tr>
			</c:forEach>
		</c:when>
  
  	
		<c:when test="${tipoLista == '2'}"> 
			<tr id="encabezadoLista">
				<td>Número Cuenta</td>
				<td>Cuenta Destino</td>
				<td>Nombre</td>
				
			</tr>
			<c:forEach items="${cuentasDestino}" var="cuentas" >
				<tr onclick="cargaValorLista('${campoLista}', '${cuentas.cuentaTranID}');">
					<td>${cuentas.cuentaTranID}</td>
					<td>${cuentas.cuentaDestino}</td>
					<td>${cuentas.nombreClienteD}</td>
				</tr>
			</c:forEach>
		</c:when>
		
			<c:when test="${tipoLista == '4'}"> 
			<tr id="encabezadoLista">
				<td>Número Cuenta</td>
				<td>Alias</td>
				<td>Banco</td>
				<td>Cuenta Clabe</td>
			</tr>
			<c:forEach items="${cuentasDestino}" var="cuentas" >
				<tr onclick="cargaValorLista('${campoLista}', '${cuentas.cuentaTranID}');">
					<td>${cuentas.cuentaTranID}</td>
					<td>${cuentas.alias}</td>
					<td>${cuentas.nombre}</td>
					<td>${cuentas.clabe}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '5'}"> 
			<tr id="encabezadoLista">
				<td>Número Cuenta</td>
				<td>Alias</td>
				<td>Banco</td>
				<td>Cuenta Clabe</td>
			</tr>
			<c:forEach items="${cuentasDestino}" var="cuentas" >
				<tr onclick="cargaValorLista('${campoLista}', '${cuentas.cuentaTranID}');">
					<td>${cuentas.cuentaTranID}</td>
					<td>${cuentas.alias}</td>
					<td>${cuentas.nombre}</td>
					<td>${cuentas.clabe}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '7'}"> 
			<tr id="encabezadoLista">
				<td>Número Cuenta</td>
				<td>Alias</td>
				<td>Banco</td>
				<td>Cuenta Clabe</td>
			</tr>
			<c:forEach items="${cuentasDestino}" var="cuentas" >
				<tr onclick="cargaValorLista('${campoLista}', '${cuentas.clabe}');">
					<td>${cuentas.cuentaTranID}</td>
					<td>${cuentas.alias}</td>
					<td>${cuentas.nombre}</td>
					<td>${cuentas.clabe}</td>
				</tr>
			</c:forEach>
		</c:when>
		
		<c:when test="${tipoLista == '8'}"> 
			<tr id="encabezadoLista">
				<td>Cuenta Clabe</td>
				<td>Alias</td>
				<td>Banco</td>
			</tr>
			<c:forEach items="${cuentasDestino}" var="cuentas" >
				<tr onclick="cargaValorLista('${campoLista}', '${cuentas.clabe}');">
					<td>${cuentas.clabe}</td>
					<td>${cuentas.alias}</td>
					<td>${cuentas.nombre}</td>
					
				</tr>
			</c:forEach>
		</c:when>
		
		<c:when test="${tipoLista == '9'}"> 
			<tr id="encabezadoLista">
				<td>Cuenta Clabe</td>
				<td>Estatus</td>
			</tr>
			<c:forEach items="${cuentasDestino}" var="cuentas" >
				<tr onclick="cargaValorLista('${campoLista}', '${cuentas.clabe}');">
					<td>${cuentas.clabe}</td>
					<td>${cuentas.estatusDomicilio}</td>   
				</tr>
			</c:forEach>
		</c:when>
		
  	</c:choose>
</table>

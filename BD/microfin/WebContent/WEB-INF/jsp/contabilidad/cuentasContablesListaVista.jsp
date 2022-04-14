<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="cuentasContables" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td>Cuenta</td>
				<td>Descripción</td>
			</tr>
			<c:forEach items="${cuentasContables}" var="cuenta" >
				<tr onclick="cargaValorLista('${campoLista}', '${cuenta.cuentaCompleta}');">
					<td nowrap="nowrap">${cuenta.cuentaCompleta}</td>
					<td nowrap="nowrap">${cuenta.descripcion}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td>Cuenta</td>
				<td>Descripci&oacute;n</td>
			</tr>
			<c:forEach items="${cuentasContables}" var="cuenta" >
				<tr onclick="cargaValorLista('${campoLista}', '${cuenta.cuentaMayor}');">
					<td>${cuenta.cuentaCompleta}</td>
					<td>${cuenta.descripcion}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '3'}">
			<tr id="encabezadoLista">
				<td>Cuenta</td>
				<td>Descripci&oacute;n</td>
			</tr>
			<c:forEach items="${cuentasContables}" var="cuenta" >
				<tr onclick="cargaValorLista('${campoLista}', '${cuenta.cuentaCompleta}');">
					<td>${cuenta.cuentaCompleta}</td>
					<td>${cuenta.descripcion}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '4'}">
			<tr id="encabezadoLista">
				<td>Cuenta</td>
				<td>Descripción</td>
			</tr>
			<c:forEach items="${cuentasContables}" var="cuenta" >
				<tr onclick="cargaValorLista('${campoLista}', '${fn:substring(cuenta.cuentaCompleta, 4, 12)}');">
					<td>${cuenta.cuentaCompleta}</td>
					<td>${cuenta.descripcion}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '5'}">
			<tr id="encabezadoLista">
				<td>Cuenta</td>
				<td>Descripci&oacute;n</td>
			</tr>
			<c:forEach items="${cuentasContables}" var="cuenta" >
				<tr onclick="cargaValorLista('${campoLista}', '${cuenta.cuentaCompleta}');">
					<td>${cuenta.cuentaCompleta}</td>
					<td>${cuenta.descripcion}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '6'}">
			<tr id="encabezadoLista">
				<td>Cuenta</td>
				<td>Descripci&oacute;n</td>
			</tr>
			<c:forEach items="${cuentasContables}" var="cuenta" >
		
				<tr onclick="cargaValorLista('${campoLista}', '${cuenta.cuentaCompleta}');">
					<td>${cuenta.cuentaCompleta}</td>
					<td>${cuenta.descripcion}</td>
				</tr>
			</c:forEach>		
		</c:when>		
		<c:when test="${tipoLista == '7'}">
			<tr id="encabezadoLista">
				<td>Cuenta</td>
				<td>Descripci&oacute;n</td>
			</tr>
			<c:forEach items="${cuentasContables}" var="cuenta" >
		
				<tr onclick="cargaValorLista('${campoLista}', '${cuenta.cuentaCompleta}');">
					<td>${cuenta.cuentaCompleta}</td>
					<td>${cuenta.descripcion}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '9'}">
			<tr id="encabezadoLista">
				<td>Cuenta</td>
				<td>Descripci&oacute;n</td>
			</tr>
			<c:forEach items="${cuentasContables}" var="cuenta" >
				<tr onclick="cargaValorLista('${campoLista}', '${cuenta.cuentaCompleta}');">
					<td>${cuenta.cuentaCompleta}</td>
					<td>${cuenta.descripcion}</td>
				</tr>
			</c:forEach>
		</c:when>
		
  	</c:choose>
</table>
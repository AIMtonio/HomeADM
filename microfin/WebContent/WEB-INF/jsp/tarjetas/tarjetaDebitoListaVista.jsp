<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="tarjetasDebito" value="${listaResultado[2]}"/>


<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td>Núm. Tarjeta</td>
			</tr>
			<c:forEach items="${tarjetasDebito}" var="tarjetaDebito" >
				<tr onclick="cargaValorListaTarjetaDeb('${campoLista}', '${fn:substring(tarjetaDebito.tarjetaDebID, 0, 4)}', '${tarjetaDebito.tarjetaDebID}');">
						<td>${tarjetaDebito.tarjetaDebID}</td>
				</tr>
			</c:forEach>
		</c:when>
			<c:when test="${tipoLista == '5'}">
			<tr id="encabezadoLista">
				<td>Núm. Tarjeta</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${tarjetasDebito}" var="tarjetaDebito" >
				<tr onclick="cargaValorLista('${campoLista}', '${tarjetaDebito.tarjetaDebID}');">
						<td>${tarjetaDebito.tarjetaDebID}</td>
							<td>${tarjetaDebito.nombre}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
		<c:choose>

		<c:when test="${tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td>Núm Tarjeta</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${tarjetasDebito}" var="rol" >
				<tr onclick="cargaValorLista('${campoLista}', '${rol.tarjetaDebID}');">
					<td>${rol.tarjetaDebID}</td>					
					<td>${rol.nombreComp}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '3'}">
			<tr id="encabezadoLista">
				<td>Núm. Tarjeta</td>
			</tr>
			<c:forEach items="${tarjetasDebito}" var="tarjetaDebito" >
				<tr onclick="cargaValorListaTarjetaDeb('${campoLista}', '${fn:substring(tarjetaDebito.tarjetaDebID, 0, 4)}', '${tarjetaDebito.tarjetaDebID}');">
						<td>${tarjetaDebito.tarjetaDebID}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '4'}">
			<tr id="encabezadoLista">
				<td>Núm. Tarjeta</td>
			</tr>
			<c:forEach items="${tarjetasDebito}" var="tarjetaDebito" >
				<tr onclick="cargaValorListaTarjetaDeb('${campoLista}', '${fn:substring(tarjetaDebito.tarjetaDebID, 0, 4)}', '${tarjetaDebito.tarjetaDebID}');">
						<td>${tarjetaDebito.tarjetaDebID}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '6'}">
			<tr id="encabezadoLista">
				<td>Núm Tarjeta</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${tarjetasDebito}" var="rol" >
				<tr onclick="cargaValorLista('${campoLista}', '${rol.tarjetaDebID}');">
					<td>${rol.tarjetaDebID}</td>					
					<td>${rol.nombreComp}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '7'}">
			<tr id="encabezadoLista">
				<td>Núm. Tarjeta</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${tarjetasDebito}" var="tarjetaDebito" >
				<tr onclick="cargaValorListaTarjetaDeb('${campoLista}', '${fn:substring(tarjetaDebito.tarjetaDebID, 0, 4)}', '${tarjetaDebito.tarjetaDebID}');">
						<td>${tarjetaDebito.tarjetaDebID}</td>
						<td>${tarjetaDebito.nombreComp}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '8'}">
			<tr id="encabezadoLista">
				<td>Núm Tarjeta</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${tarjetasDebito}" var="rol" >
				<tr onclick="cargaValorLista('${campoLista}', '${rol.tarjetaDebID}');">
					<td>${rol.tarjetaDebID}</td>					
					<td>${rol.nombreComp}</td>
				</tr>
			</c:forEach>
		</c:when>		
		<c:when test="${tipoLista == '9' ||tipoLista == '10'}">
			<tr id="encabezadoLista">
				<td>Núm Tarjeta</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${tarjetasDebito}" var="rol" >
				<tr onclick="cargaValorLista('${campoLista}', '${rol.tarjetaDebID}');">
					<td>${rol.tarjetaDebID}</td>					
					<td>${rol.nombreComp}</td>
				</tr>
			</c:forEach>
		</c:when>
			<c:when test="${tipoLista == '11'}">
			<tr id="encabezadoLista">
				<td>Núm Tarjeta</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${tarjetasDebito}" var="rol" >
				<tr onclick="cargaValorLista('${campoLista}', '${rol.tarjetaDebID}');">
					<td>${rol.tarjetaDebID}</td>
					<td>${rol.nombreComp}</td>
				</tr>
			</c:forEach>
		</c:when>
			<c:when test="${tipoLista == '15'}">
			<tr id="encabezadoLista">
				<td>Núm. Tarjeta</td>
				<td>Nombre</td>
			</tr>
				<c:forEach items="${tarjetasDebito}" var="rol" >
				<tr onclick="cargaValorLista('${campoLista}', '${rol.tarjetaDebID}');">
					<td>${rol.tarjetaDebID}</td>
					<td>${rol.nombreComp}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista >= '13' || tipoLista == '14' || tipoLista == '17'}"><!-- 13 y 14 -->
			<tr id="encabezadoLista">
				<td>Núm Tarjeta</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${tarjetasDebito}" var="rol" >
				<tr onclick="cargaValorLista('${campoLista}', '${rol.tarjetaDebID}');">
					<td>${rol.tarjetaDebID}</td>
					<td>${rol.nombreComp}</td>
				</tr>
			</c:forEach>
		</c:when>
  	</c:choose>
</table>
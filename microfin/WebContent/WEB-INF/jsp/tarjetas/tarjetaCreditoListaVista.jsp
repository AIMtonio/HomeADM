<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="tarjetasCredito" value="${listaResultado[2]}"/>


<table id="tablaLista">

	<c:choose>

		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td>Núm Tarjeta</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${tarjetasCredito}" var="rol" >
				<tr onclick="cargaValorLista('${campoLista}', '${rol.tarjetaCredID}');">
					<td>${rol.tarjetaCredID}</td>					
					<td>${rol.nombreComp}</td>
				</tr>
			</c:forEach>
		</c:when>
		
		<c:when test="${tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td>Núm Tarjeta</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${tarjetasCredito}" var="rol" >
				<tr onclick="cargaValorLista('${campoLista}', '${rol.tarjetaCredID}');">
					<td>${rol.tarjetaCredID}</td>					
					<td>${rol.nombreComp}</td>
				</tr>
			</c:forEach>
		</c:when>
		
		<c:when test="${tipoLista == '3'}">
			<tr id="encabezadoLista">
				<td>Núm. Tarjeta</td>
				<td>Nombre</td>
				<td>Tipo</td>
			</tr>
			<c:forEach items="${tarjetasCredito}" var="tarjetaDebito" >
				<tr onclick="cargaValorListaTarjetaCred('${campoLista}', '${fn:substring(tarjetaDebito.tarjetaCredID, 0, 4)}', '${tarjetaDebito.tarjetaCredID}');">
						<td>${tarjetaDebito.tarjetaCredID}</td>
						<td>${tarjetaDebito.nombreComp}</td>
						<td>${tarjetaDebito.tipo}</td>
				</tr>
			</c:forEach>
		</c:when>
				<c:when test="${tipoLista == '4'}">
			<tr id="encabezadoLista">
				<td>Núm Tarjeta</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${tarjetasCredito}" var="rol" >
				<tr onclick="cargaValorLista('${campoLista}', '${rol.tarjetaCredID}');">
					<td>${rol.tarjetaCredID}</td>					
					<td>${rol.nombreComp}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '11'}">
			<tr id="encabezadoLista">
				<td>Núm Tarjeta</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${tarjetasCredito}" var="rol" >
				<tr onclick="cargaValorLista('${campoLista}', '${rol.tarjetaCredID}');">
					<td>${rol.tarjetaCredID}</td>
					<td>${rol.nombreComp}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '12'}">
			<tr id="encabezadoLista">
				<td>Núm. Tarjeta</td>
				<td>Nombre</td>
			</tr>
				<c:forEach items="${tarjetasCredito}" var="rol" >
				<tr onclick="cargaValorLista('${campoLista}', '${rol.tarjetaCredID}');">
					<td>${rol.tarjetaCredID}</td>
					<td>${rol.nombreComp}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista >= '13'}"><!-- 13 y 14 -->
			<tr id="encabezadoLista">
				<td>Núm Tarjeta</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${tarjetasCredito}" var="rol" >
				<tr onclick="cargaValorLista('${campoLista}', '${rol.tarjetaCredID}');">
					<td>${rol.tarjetaCredID}</td>
					<td>${rol.nombreComp}</td>
				</tr>
			</c:forEach>
		</c:when>
		
		<c:when test="${tipoLista == '5'}">
				<tr id="encabezadoLista">
					<td>Núm. Tarjeta</td>
					<td>Nombre</td>
				</tr>
				<c:forEach items="${tarjetasCredito}" var="tarjetaDebito" >
					<tr onclick="cargaValorLista('${campoLista}', '${tarjetaDebito.tarjetaCredID}');">
							<td>${tarjetaDebito.tarjetaCredID}</td>
								<td>${tarjetaDebito.nombre}</td>
					</tr>
				</c:forEach>
		</c:when>

		<c:when test="${tipoLista == '14'}">
			<tr id="encabezadoLista">
				<td>Núm Tarjeta</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${solicitudTarDeb}" var="rol" >
				<tr onclick="cargaValorLista('${campoLista}', '${rol.tarjetaCredID}');">
					<td>${rol.tarjetaCredID}</td>					
					<td>${rol.nombreComp}</td>
				</tr>
			</c:forEach>
		</c:when>


  	</c:choose>
</table>
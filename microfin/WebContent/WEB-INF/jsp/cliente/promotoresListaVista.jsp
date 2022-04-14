<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="promotores" value="${listaResultado[2]}"/>


<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td>Promotores</td>
			</tr>
			<c:forEach items="${promotores}" var="promotor" >
				<tr onclick="cargaValorLista('${campoLista}', '${promotor.promotorID}');">
					<td>${promotor.nombrePromotor}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td>Promotores</td>
				<td>Sucursal</td>
			</tr>
			<c:forEach items="${promotores}" var="promotor" >
				<tr onclick="cargaValorLista('${campoLista}', '${promotor.promotorID}');">
					<td>${promotor.nombrePromotor}</td>
					<td>${promotor.nombreSucursal}</td>
				</tr>
			</c:forEach>
		</c:when>
		
		
		<c:when test="${tipoLista == '4'}">
			<tr id="encabezadoLista">
				<td>Numero</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${promotores}" var="promotor" >
				<tr onclick="cargaValorLista('${campoLista}', '${promotor.promotorID}');">
					<td>${promotor.promotorID}</td>
					<td>${promotor.nombrePromotor}</td>
				</tr>
			</c:forEach>
		</c:when>
		
		
		
		<c:when test="${tipoLista == '7'}">
			<tr id="encabezadoLista">
				<td>Número</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${promotores}" var="promotor" >
				<tr onclick="cargaValorLista('${campoLista}', '${promotor.numero}');">
					<td>${promotor.numero}</td>
					<td>${promotor.nombre}</td>
				</tr>
			</c:forEach>
		</c:when>
		
		<c:when test="${tipoLista == '8'}">
			<tr id="encabezadoLista">
				<td>Promotor</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${promotores}" var="promotor" >
				<tr onclick="cargaValorLista('${campoLista}', '${promotor.promotorID}');">
					<td>${promotor.promotorID}</td>
					<td>${promotor.nombrePromotor}</td>
				</tr>
			</c:forEach>
		</c:when>
		
		<c:when test="${tipoLista == '10'}">
			<tr id="encabezadoLista">
				<td>Promotores</td>
			</tr>
			<c:forEach items="${promotores}" var="promotor" >
				<tr onclick="cargaValorLista('${campoLista}', '${promotor.promotorID}');">
					<td>${promotor.nombrePromotor}</td>
				</tr>
			</c:forEach>
		</c:when>
		
  	</c:choose>
</table>

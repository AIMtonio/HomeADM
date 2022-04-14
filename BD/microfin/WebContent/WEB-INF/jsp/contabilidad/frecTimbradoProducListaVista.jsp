<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="frecTimbradas" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1' ||  tipoLista == '3'}" >
			<tr id="encabezadoLista">
				<td>Número</td>
				<td>Producto de Crédito</td>
			</tr>
			<c:forEach items="${frecTimbradas}" var="frecTim" >
				<tr onclick="cargaValorLista('${campoLista}', '${frecTim.producCreditoID}');">
					<td>${frecTim.producCreditoID}</td>
					<td>${frecTim.descripcion}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '2'}" >
			<tr id="encabezadoLista">
				<td>Frecuencia</td>
				<td>Número</td>
				<td>Producto de Crédito</td>
			</tr>
			<c:forEach items="${frecTimbradas}" var="frecTim" >
				<tr onclick="cargaValorLista('${campoLista}', '${frecTim.producCreditoID}');">
					<td>${frecTim.frecuenciaID}</td>
					<td>${frecTim.producCreditoID}</td>
					<td>${frecTim.descripcion}</td>
				</tr>
			</c:forEach>
		</c:when>

	</c:choose>
</table>
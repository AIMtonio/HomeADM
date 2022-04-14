<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="avales" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>

		<c:when test="${tipoLista == '1' || tipoLista=='5' || tipoLista=='6'}">


			<tr id="encabezadoLista">
				<td>AvalID</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${avales}" var="avales" >
				<tr onclick="cargaValorLista('${campoLista}', '${avales.avalID}');">
					<td>${avales.avalID}</td>
					<td>${avales.nombreCompleto}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '4'}">
			<tr id="encabezadoLista">
				<td>ClienteID</td>
				<td>Nombre</td>
			</tr>
			<c:forEach items="${avales}" var="avales" >
				<tr onclick="cargaValorLista('${campoLista}', '${avales.clienteID}');">
					<td>${avales.clienteID}</td>
					<td>${avales.nombreCompleto}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
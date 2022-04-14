<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="tipoInstrumento"  value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td>Tipo Instrumento</td>
				<td>Descripci&oacute;n</td>
			</tr>
			<c:forEach items="${tipoInstrumento}" var="catalogo" >
				<tr onclick="cargaValorLista('${campoLista}', '${catalogo.catMovimientoID}');">
					<td nowrap="nowrap">${catalogo.catMovimientoID}</td>
					<td nowrap="nowrap">${catalogo.nombreMovimiento}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
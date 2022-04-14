<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="facturas" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '3'}">
			<tr id="encabezadoLista">
				<td nowrap="nowrap">Folio Carga</td>
				<td nowrap="nowrap">Nombre Usuario</td>
				<td nowrap="nowrap">Fecha Carga</td>
			</tr>
			<c:forEach items="${facturas}" var="factura" >
				<tr onclick="cargaValorLista('${campoLista}', '${factura.folioCargaID}');">
					<td>${factura.folioCargaID}</td>
					<td>${factura.usuario}</td>
					<td>${factura.fechaCarga}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
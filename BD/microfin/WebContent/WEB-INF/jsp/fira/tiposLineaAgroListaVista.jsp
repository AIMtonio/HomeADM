<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="campoLista" value="${listaResultado[1]}" />
<c:set var="tiposLineasAgros" value="${listaResultado[2]}" />
<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td>Numero</td>
				<td>Nombre</td>
			
			</tr>
			<c:forEach items="${tiposLineasAgros}" var="tiposLineasAgro">
				<tr onclick="cargaValorLista('${campoLista}', '${tiposLineasAgro.tipoLineaAgroID}');">
				    <td>${tiposLineasAgro.tipoLineaAgroID}</td>
					<td>${tiposLineasAgro.nombre}</td>
					
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>

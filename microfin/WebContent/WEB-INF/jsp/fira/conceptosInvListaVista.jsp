<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="conceptos" value="${listaResultado[2]}"/>


<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td>Concepto Fira</td>
				<td>Descripción</td>
			</tr>
			<c:forEach items="${conceptos}" var="solicitud" >
 					<tr onclick="cargaValorLista('${campoLista}', '${solicitud.conceptoInvID}');">
 				<td>${solicitud.conceptoInvID}</td>
					<td>${solicitud.descripcion}</td>
				</tr>
			</c:forEach>
		</c:when>

	</c:choose>
</table>
 
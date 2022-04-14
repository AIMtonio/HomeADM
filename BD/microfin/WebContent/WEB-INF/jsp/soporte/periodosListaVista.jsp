<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="periodos" value="${listaResultado[2]}"/>
<c:set var="numeroPeriodo" value="0"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '5'}">
			<tr id="encabezadoLista">
				<td>No. Periodo</td>
				<td>Periodo</td>
			</tr>
			<c:forEach items="${periodos}" var="periodo" >
				<c:set var="numeroPeriodo" value="${numeroPeriodo + 1}"/>
				<tr onclick="cargaValorLista('${campoLista}', '${periodo.anioMes}');">
					<td>${numeroPeriodo}</td>
					<td>${periodo.anioMes}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>

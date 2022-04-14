<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="monedas" 	value="${listaResultado[2]}"/>

<table id="tablaLista">
	<tr id="encabezadoLista">
			<td>Moneda</td>
			<td>Descripción:</td>
	</tr>
	<c:forEach items="${monedas}" var="moneda" >
	<tr onclick="cargaValorLista('${campoLista}', '${moneda.monedaID}');">
		<td>${moneda.monedaID}</td>
		<td>${moneda.descripcion}</td>
	</tr>
	</c:forEach>
</table>

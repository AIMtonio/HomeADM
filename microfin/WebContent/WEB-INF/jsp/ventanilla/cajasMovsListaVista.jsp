<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="cajasMovs" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<tr id="encabezadoLista">
		<td>Transacción</td>
		<td>Referencia </td>		
		<td>Monto</td>
		<td>Nombre</td>
	</tr>
	<c:forEach items="${cajasMovs}" var="cajasMov" >
		<tr onclick="cargaValorLista('${campoLista}', '${cajasMov.numeroMov}');">
			<td>${cajasMov.numeroMov}</td>
			<td>${cajasMov.referenciaMov}</td>
			<td>${cajasMov.montoEnFirme}</td>
			<td>${cajasMov.nombreCliente}</td>
		</tr>
	</c:forEach>
</table>


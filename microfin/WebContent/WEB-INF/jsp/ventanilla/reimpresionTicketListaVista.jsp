<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page pageEncoding="UTF-8"%>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="reimpresionTicket" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td nowrap="nowrap">Número de Transacción</td>
				<td nowrap="nowrap">Referencia</td>
				<td nowrap="nowrap">Monto</td>
				<td nowrap="nowrap">Nombre</td>
			</tr>
			<c:forEach items="${reimpresionTicket}" var="reimpresion" >
				<tr onclick="cargaValorLista('${campoLista}', '${reimpresion.transaccionID}');">
					<td nowrap="nowrap">${reimpresion.transaccionID}</td>
					<td nowrap="nowrap">${reimpresion.referencia}</td>
					<td nowrap="nowrap">${reimpresion.montoOperacion}</td>
					<td nowrap="nowrap">${reimpresion.nombrePersona}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>	
</table>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="sucursales" value="${listaResultado[2]}"/>

<table id="tablaLista">
		<tr id="encabezadoLista">
			<td>Sucursal</td>
		</tr>
		<c:forEach items="${sucursales}" var="sucursal" >
			<tr onclick="cargaValorLista('${campoLista}', '${sucursal.sucursalID}');">
				<td>${sucursal.nombreSucurs}</td>
			</tr>
		</c:forEach>
</table>
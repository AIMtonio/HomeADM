<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="partidas" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td>Folio</td>
				<td>Sucursal</td>
				<td>Elabor&oacute; </td>
			</tr>
			<c:forEach items="${partidas}" var="partida" >
				<tr onclick="cargaValorLista('${campoLista}', '${partida.folio}');">
					<td>${partida.folio}</td>
					<td>${partida.nombreSucursal}</td>
					<td>${partida.nombreUsuario}</td>
				</tr>
			</c:forEach>
		</c:when>
		
		<c:when test="${tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td>Monto</td>
				<td>Descripci&oacute;n</td>
			</tr>
			<c:forEach items="${partidas}" var="partida" >
				<tr onclick="cargaValorLista('partidaPreID', '${partida.folio}');
				             cargaValorLista('${campoLista}', '${partida.montoPet}');">
					<td>${partida.montoPet}</td>
					<td>${partida.descripcionPet}</td>
				</tr>
			</c:forEach>
		</c:when>
  	</c:choose>
</table>
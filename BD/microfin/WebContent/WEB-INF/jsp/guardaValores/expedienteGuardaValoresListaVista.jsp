<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"	value="${listaResultado[0]}"/>
<c:set var="campoLista"	value="${listaResultado[1]}"/>
<c:set var="documentos"	value="${listaResultado[2]}"/>
<c:set var="campoTipoPersona" value="${listaResultado[3]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td>N&#250;mero</td>
				<td>No. Participante</td>
				<td>Nombre Completo</td>
				<td>Tipo Instrumento</td>
				<td>Sucursal</td>
			</tr>
			<c:forEach items="${documentos}" var="documento" >
				<tr onclick="cargaValorLista('${campoLista}', '${documento.numeroExpedienteID}');">
					<td nowrap="nowrap">${documento.numeroExpedienteID}</td>
					<td nowrap="nowrap">${documento.numeroInstrumento}</td>
					<td nowrap="nowrap">${documento.nombreParticipante}</td>
					<td nowrap="nowrap">${documento.descripcion}</td>
					<td nowrap="nowrap">${documento.sucursalID}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td>N&#250;mero Participante</td>
				<td>Nombre Completo</td>
			</tr>
			<c:forEach items="${documentos}" var="documento" >
				<tr onclick="cargaValorListaParticipante('${campoLista}', '${documento.numeroInstrumento}', '${campoTipoPersona}', '${documento.tipoPersona}');">
					<td nowrap="nowrap">${documento.numeroInstrumento}</td>
					<td nowrap="nowrap">${documento.nombreParticipante}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
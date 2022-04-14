<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="documentos"	value="${listaResultado[2]}"/>
<c:set var="campoArchivo" value="${listaResultado[3]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '2' || tipoLista=='3' }">
			<tr id="encabezadoLista">
				<td>No. Documento</td>
				<td>Nombre Completo</td>
				<td>No. Instrumento</td>
				<td>Tipo Documento</td>
				<td>Nombre Documento</td>
			</tr>
			<c:forEach items="${documentos}" var="documento" >
				<tr onclick="cargaValorLista('${campoLista}', '${documento.documentoID}');">
					<td nowrap="nowrap">${documento.documentoID}</td>
					<td nowrap="nowrap">${documento.nombreParticipante}</td>
					<td nowrap="nowrap">${documento.numeroInstrumento}</td>
					<td nowrap="nowrap">${documento.grupoDocumentoID}</td>
					<td nowrap="nowrap">${documento.nombreDocumento}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '4'}">
			<tr id="encabezadoLista">
				<td>Tipo Documento</td>
				<td>Nombre Documento</td>
			</tr>
			<c:forEach items="${documentos}" var="documento" >
				<tr onclick="cargaValorListaGrdVal('${campoLista}', '${documento.tipoDocumentoID}', '${campoArchivo}', '${documento.documentoID}');">
					<td nowrap="nowrap">${documento.tipoDocumentoID}</td>
					<td nowrap="nowrap">${documento.descripcion}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
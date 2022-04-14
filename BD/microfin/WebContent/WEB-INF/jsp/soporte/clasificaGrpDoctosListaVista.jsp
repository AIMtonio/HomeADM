<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="documentos"  value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td>Tipo Documento ID</td>
				<td>Descripci&oacute;n</td>
			</tr>
			<c:forEach items="${documentos}" var="documento" >
				<tr onclick="cargaValorLista('${campoLista}', '${documento.tipoDocumentoID}');">
					<td nowrap="nowrap">${documento.tipoDocumentoID}</td>
					<td nowrap="nowrap">${documento.descripcion}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
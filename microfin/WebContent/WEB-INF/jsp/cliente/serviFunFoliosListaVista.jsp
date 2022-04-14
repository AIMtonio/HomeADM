<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="serviFunFolios" value="${listaResultado[2]}"/>


<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista >= '1'}"> 
			<tr id="encabezadoLista">
				<td>No. <s:message code="safilocale.cliente"/></td>
				<td>Nombre</td>
				<td>Estatus</td>
			</tr>
			<c:forEach items="${serviFunFolios}" var="serviFun" >
				<tr onclick="cargaValorLista('${campoLista}', '${serviFun.serviFunFolioID}');">
					<td>${serviFun.serviFunFolioID}</td>
					<td>${serviFun.tramPrimerNombre}</td>
					<td>${serviFun.estatusDescripcion}</td>
				</tr>
			</c:forEach>
		</c:when>

  	</c:choose>
</table>
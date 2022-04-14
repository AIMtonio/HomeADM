<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="instituciones" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td>Institución</td>
			</tr>
			<c:forEach items="${instituciones}" var="institucion" >
				<tr onclick="cargaValorLista('${campoLista}', '${institucion.institucionID}');">
					<td>${institucion.nombreCorto}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '3'}">
			<tr id="encabezadoLista">
				<td>Institución</td>
			</tr>
			<c:forEach items="${instituciones}" var="institucion" >
				<tr onclick="cargaValorLista('${campoLista}', '${institucion.institucionID}');">
					<td>${institucion.nombreCorto}</td>
				</tr>
			</c:forEach>
		</c:when>
			<c:when test="${tipoLista == '4'}">
			<tr id="encabezadoLista">
				<td>Institución</td>
			</tr>
			<c:forEach items="${instituciones}" var="institucion" >
				<tr onclick="cargaValorLista('${campoLista}', '${institucion.claveParticipaSpei}');">
					<td>${institucion.nombreCorto}</td>
				</tr>
			</c:forEach>
		</c:when>
		
		<c:when test="${tipoLista == '5'}">
			<tr id="encabezadoLista">
				<td>Institución</td>
			</tr>
			<c:forEach items="${instituciones}" var="institucion" >
				<tr onclick="cargaValorLista('${campoLista}', '${institucion.institucionID}');">
					<td>${institucion.nombreCorto}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '7'}">
			<tr id="encabezadoLista">
				<td>ID</td>
				<td>Institución</td>
			</tr>
			<c:forEach items="${instituciones}" var="institucion" >
				<tr onclick="cargaValorLista('${campoLista}', '${institucion.institucionID}');">
					<td>${institucion.institucionID}</td>
					<td>${institucion.nombreCorto}</td>
				</tr>
			</c:forEach>
		</c:when>
  	</c:choose>	
</table>
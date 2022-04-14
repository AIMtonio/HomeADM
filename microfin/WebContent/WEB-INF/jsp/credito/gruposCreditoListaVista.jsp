<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="grupos" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'  ||  tipoLista == '6'}">
			<tr id="encabezadoLista">
				<td>GrupoID</td>
				<td>Nombre</td>
				<td>Sucursal</td>
			</tr>
			<c:forEach items="${grupos}" var="gruposCre" >
				<tr onclick="cargaValorLista('${campoLista}', '${gruposCre.grupoID}');">
					<td>${gruposCre.grupoID}</td>
					<td>${gruposCre.nombreGrupo}</td>
					<td>${gruposCre.nombreSucursal}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td>Grupo</td>
				<td>Nombre</td>
				<td>Sucursal</td>
			</tr>
			<c:forEach items="${grupos}" var="gruposCre" >
				<tr onclick="cargaValorLista('${campoLista}', '${gruposCre.grupoID}');">
					<td>${gruposCre.grupoID}</td>
					<td>${gruposCre.nombreGrupo}</td>
					<td>${gruposCre.nombreSucursal}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '3'}">
			<tr id="encabezadoLista">
				<td>Grupo</td>
				<td>Nombre</td>
				<td>Sucursal Grupo</td>
			</tr>
			<c:forEach items="${grupos}" var="gruposCre" >
				<tr onclick="cargaValorLista('${campoLista}', '${gruposCre.grupoID}');">
					<td>${gruposCre.grupoID}</td>
					<td>${gruposCre.nombreGrupo}</td>
					<td>${gruposCre.nombreSucursal}</td>
				</tr>
			</c:forEach>
		</c:when>
			<c:when test="${tipoLista == '4'}">
			<tr id="encabezadoLista">
				<td>Grupo</td>
				<td>Nombre</td>
				<td>Sucursal</td>
			</tr>
			<c:forEach items="${grupos}" var="gruposCre" >
				<tr onclick="cargaValorLista('${campoLista}', '${gruposCre.grupoID}');">
					<td>${gruposCre.grupoID}</td>
					<td>${gruposCre.nombreGrupo}</td>
					<td>${gruposCre.nombreSucursal}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '5'}">
			<tr id="encabezadoLista">
				<td>GrupoID</td>
				<td>Nombre</td>
				<td>Sucursal</td>
			</tr>
			<c:forEach items="${grupos}" var="gruposCre" >
				<tr onclick="cargaValorLista('${campoLista}', '${gruposCre.grupoID}');">
					<td>${gruposCre.grupoID}</td>
					<td>${gruposCre.nombreGrupo}</td>
					<td>${gruposCre.nombreSucursal}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
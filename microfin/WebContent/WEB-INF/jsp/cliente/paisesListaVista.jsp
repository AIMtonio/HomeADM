<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="paises" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1' || tipoLista == '4' || tipoLista == '5'}">
			<tr id="encabezadoLista">
				<td>Pa&iacute;ses</td>
			</tr>
			<c:forEach items="${paises}" var="pais" >
				<tr onclick="cargaValorLista('${campoLista}', '${pais.paisID}');">
					<td>${pais.nombre}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td>Pa&iacute;ses</td>
			</tr>
			<c:forEach items="${paises}" var="pais" >
				<tr onclick="cargaValorLista('${campoLista}', '${pais.paisCNBV}');">
					<td>${pais.nombre}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '3'}">
			<tr id="encabezadoLista">
				<td>Pa&iacute;ses</td>
			</tr>
			<c:forEach items="${paises}" var="pais" >
				<tr onclick="cargaValorLista('${campoLista}', '${pais.clavePaisDIOT}');">
					<td>${pais.descPaisDIOT}</td>
				</tr>
			</c:forEach>
		</c:when>
  	</c:choose>
</table>
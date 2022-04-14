<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="arrendaBean" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista >= '1'}">
			<tr id="encabezadoLista">
				<td>DepRefereID</td>
				<td nowrap="nowrap">Instituci&oacute;n</td>
				<td>NumCta</td>
				<td>Fec.Carga</td>	
			</tr>
			<c:forEach items="${arrendaBean}" var="arrendamientos" >
				<tr onclick="cargaValorLista('${campoLista}', '${arrendamientos.depRefereID}');">
					<td nowrap="nowrap">${arrendamientos.depRefereID}</td>
					<td nowrap="nowrap">${arrendamientos.nombreCorto}</td>
					<td nowrap="nowrap">${arrendamientos.numCtaInstit}</td>
					<td nowrap="nowrap">${arrendamientos.fechaCarga}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
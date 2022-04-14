<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="tasas" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose> 
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td nowrap="nowrap">No. Tasa</td>
				<td nowrap="nowrap">Montos</td>
				<td nowrap="nowrap">Plazos</td>
				<td nowrap="nowrap">Calificaci&oacute;n</td>		
			</tr>
			<c:forEach items="${tasas}" var="tasa" >
				<tr onclick="cargaValorLista('${campoLista}', '${tasa.tasaCedeID}');">
					<td nowrap="nowrap">${tasa.tasaCedeID}</td>		
					<td nowrap="nowrap">${tasa.montoID}</td>			
					<td nowrap="nowrap">${tasa.plazoID}</td>
					<td nowrap="nowrap">${tasa.calificacion}</td>						
				</tr>
			</c:forEach>		
		</c:when>
		
	</c:choose>	
</table>


<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="inversiones" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td nowrap="nowrap">N&uacute;mero</td>
				<td nowrap="nowrap">Instituci&oacute;n</td>
				<td nowrap="nowrap">Monto</td>
				<td nowrap="nowrap">Estatus</td>
				<td nowrap="nowrap">Vencimiento</td>
			</tr>
			<c:forEach items="${inversiones}" var="inversion" >
				<tr onclick="cargaValorLista('${campoLista}', '${inversion.inversionID}');">
					<td nowrap="nowrap">${inversion.inversionID}</td>		
					<td nowrap="nowrap">${inversion.nombreInstitucion}</td>			
					<td nowrap="nowrap">${inversion.monto}</td>
					<td nowrap="nowrap">${inversion.estatus}</td>
					<td nowrap="nowrap">${inversion.fechaVencimiento}</td>
				</tr>
			</c:forEach>		
		</c:when>
	</c:choose>	
</table>


<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="creditosBean" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '62'}">
			<tr id="encabezadoLista">
				<td>No. Cr&eacute;dito</td>
				<td>Fecha Pago</td>	
				<td>Monto Pagado</td>
			</tr>
			<c:forEach items="${creditosBean}" var="creditos" >
				<tr onclick="cargaValorListaFondeo('${campoLista}', '${creditos.creditoID}', '${creditos.numTransaccion}');">
					<td>${creditos.creditoID}</td>
					<td nowrap="nowrap">${creditos.fechaPago}</td>
					<td nowrap="nowrap">${creditos.totalPago}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
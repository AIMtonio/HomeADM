<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="parametrosBINs" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td>Num</td>
				<td>Num. BIN</td>
				<td>Marca</td>
			</tr>
			<c:forEach items="${parametrosBINs}" var="parametrosBIN" >
				<tr onclick="cargaValorLista('${campoLista}', '${parametrosBIN.tarBinParamsID}');">
					<td>${parametrosBIN.tarBinParamsID}</td>
					<td>${parametrosBIN.numBIN}</td>
					<td>${parametrosBIN.descMarcaTar}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
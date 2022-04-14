<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="destinosCredito" value="${listaResultado[2]}"/>


<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1' || tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td>Numero</td>
				<td>Descripcion</td>
			</tr>
			<c:forEach items="${destinosCredito}" var="destinos" >
				<tr onclick="cargaValorLista('${campoLista}', '${destinos.destinoCreID}');">
					<td>${destinos.destinoCreID}</td>
					<td>${destinos.descripcion}</td>
				</tr>
			</c:forEach>
		</c:when>
  	</c:choose>
</table>
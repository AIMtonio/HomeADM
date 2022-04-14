<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="periodoContable" value="${listaResultado[2]}"/>

<table id="tablaLista" border="0" cellpadding="0" cellspacing="0" width="100%"> 
	<c:choose>
		<c:when test="${tipoLista == '3'}">
			<tr id="encabezadoLista">
				<td>Periodo</td>
			</tr>
			<c:forEach items="${periodoContable}" var="periodo" >
				<tr onclick="cargaValorLista('${campoLista}', '${periodo.numeroPeriodo}');">
					<td>${periodo.numeroPeriodo}</td>
				</tr>
			</c:forEach>
		</c:when>
  	</c:choose>
</table>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="campoLista" value="${listaResultado[1]}" />
<c:set var="cadenaBeanList" value="${listaResultado[2]}" />
<table id="tablaLista">
	<tr id="encabezadoLista">
		<td>Subprograma</td>
		<td>Descripci&oacute;n</td>
	</tr>
	<c:forEach items="${cadenaBeanList}" var="catCadenaProductivaBean">
		<tr onclick="cargaValorLista('${campoLista}', '${catCadenaProductivaBean.cveSubProgramaID}');">
			<td>${catCadenaProductivaBean.subPrograma}</td>
			<td nowrap="nowrap">${catCadenaProductivaBean.subPrograma}</td>
		</tr>
	</c:forEach>
</table>
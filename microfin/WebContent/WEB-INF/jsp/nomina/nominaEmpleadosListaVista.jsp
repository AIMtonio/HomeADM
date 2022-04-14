<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="campoLista" value="${listaResultado[1]}" />
<c:set var="listaRegistros" value="${listaResultado[2]}" />

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '3'}">
			<tr id="encabezadoLista">
				<td>N&uacute;mero</td>
				<td>N&uacute;mero cliente</td>
				<td>Nombre instituci&oacute;n</td>
				<td>N&uacute;mero convenio</td>
				<td>N&uacute;mero empleado</td>
			</tr>
			<c:forEach items="${listaRegistros}" var="registro">
				<tr onclick="cargaValorLista('${campoLista}', '${registro.nominaEmpleadoID}');">
					<td>${registro.nominaEmpleadoID}</td>
					<td>${registro.clienteID}</td>
					<td>${registro.nombreInstNomina}</td>
					<td>${registro.convenioNominaID}</td>
					<td>${registro.noEmpleado}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>

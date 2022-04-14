<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="regulatorioD0842Bean" value="${listaResultado[2]}"/>


<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td>ID</td>
				<td>Otorgante</td>
				<td>No. Contrato</td>
			</tr>
			<c:forEach items="${regulatorioD0842Bean}" var="regulatorio0842" >
				<tr onclick="cargaValorLista('${campoLista}', '${regulatorio0842.identificadorID}');">
					<td>${regulatorio0842.identificadorID}</td>
					<td>${regulatorio0842.descripcion}</td>
					<td>${regulatorio0842.numeroContrato}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
	
</table>


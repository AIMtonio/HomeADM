<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
  

<c:set var="tipoLista"  value="${listResultado[0]}"/>
<c:set var="campoLista" value="${listResultado[1]}"/>
<c:set var="remesas" value="${listResultado[2]}"/>


<table id="tablaLista">
	<tr id="encabezadoLista">
		<td>Referencia</td>
		<td>Remesadora</td>
		<td>Monto</td>
	</tr>
	<c:forEach items="${remesas}" var="remesa" >
		<tr onclick="cargaValorLista('${campoLista}', '${remesa.referencia}');">
			<td>${remesa.referencia}</td>
			<td>${remesa.remesadora}</td>
			<td>${remesa.monto}</td>
		</tr>
	</c:forEach>
</table>

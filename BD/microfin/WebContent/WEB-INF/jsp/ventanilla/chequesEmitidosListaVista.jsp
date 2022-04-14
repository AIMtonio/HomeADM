<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
  

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="cheques" value="${listaResultado[2]}"/>


<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '3' || tipoLista == '5' || tipoLista == '6' || tipoLista == '7' || tipoLista == '8' }"> 
			<tr id="encabezadoLista">
				<td>No. Cheque</td>
				<td>Beneficiario</td>
				<td>Monto</td>
				<td>Fecha</td>
			</tr>
			<c:forEach items="${cheques}" var="cheques" >
			<tr onclick="cargaValorLista('${campoLista}', '${cheques.numChequeCan}');">
				<td>${cheques.numChequeCan}</td>
				<td>${cheques.beneficiarioCan}</td>
				<td align="right">${cheques.montoCan}</td>
				<td>${cheques.fechaCan}</td>				
			</tr>
			</c:forEach>
		</c:when>			
		</c:choose>
</table>
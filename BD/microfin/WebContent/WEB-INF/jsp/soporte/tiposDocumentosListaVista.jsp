<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
  

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista"  value="${listaResultado[1]}"/>
<c:set var="tiposDoctos" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '3'}"> 
			<tr id="encabezadoLista">
				<td>N&uacute;mero</td>
				<td>Descripci&oacute;n</td>
			</tr>
			<c:forEach items="${tiposDoctos}" var="doctos" >
				<tr onclick="cargaValorLista('${campoLista}', '${doctos.tipoDocumentoID}');">
					<td>${doctos.tipoDocumentoID}</td>
					<td>${doctos.descripcion}</td>
				</tr>
			</c:forEach>		
		</c:when>
		
      
		<c:when test="${tipoLista == '4'}"> 

			<tr id="encabezadoLista">
				<td>Tipo Documento</td>
				<td>Descripcion</td>
			</tr>
			<c:forEach items="${tiposDoctos}" var="doctos">

				<tr onclick="cargaValorLista('${campoLista}', '${doctos.tipoDocumentoID}');">
					<td>${doctos.tipoDocumentoID}</td>
					<td>${doctos.descripcionDoc}</td>
				</tr>
			</c:forEach>		
		</c:when>
  	</c:choose>
</table>

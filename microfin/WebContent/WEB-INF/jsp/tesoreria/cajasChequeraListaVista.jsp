<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
  

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="cuentasChequera" value="${listaResultado[2]}"/>


<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '6'}"> 
			<tr id="encabezadoLista">
				<td>Cuenta:</td>
				<td>Sucursal:</td>				
			</tr>
				<c:forEach items="${cuentasChequera}" var="cuentasChequera" >
			<tr onclick="cargaValorLista('${campoLista}', '${cuentasChequera.numCtaInstit}');">
				<td>${cuentasChequera.numCtaInstit}</td>
				<td>${cuentasChequera.sucursalInstit}</td>									
			</tr>
				</c:forEach>
		</c:when>				
	</c:choose>		
	
</table>
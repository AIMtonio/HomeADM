<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
  

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="companias" value="${listaResultado[2]}"/>


<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '2'}"> 
			<tr id="encabezadoLista">
				<td nowrap="nowrap">CompaniaID</td>				
				<td  nowrap="nowrap">Razón Social</td>
			</tr>
			<c:forEach items="${companias}" var="companias" >
				<tr onclick="cargaValorListaCte('${campoLista}', '${companias.companiaID}');">
					<td nowrap="nowrap">${companias.companiaID}</td>
					<td nowrap="nowrap">${companias.razonSocial}</td>
				</tr>
			</c:forEach>
		
		</c:when>
  	</c:choose>
</table>
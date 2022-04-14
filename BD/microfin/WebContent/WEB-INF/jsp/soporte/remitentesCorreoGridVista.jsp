<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista" value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="correosgrid" value="${listaResultado[2]}"/>



<table id="tablaLista" width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
<c:choose>
<c:when test="${tipoLista == '2'}"> 
<tr id="encabezadoLista">
<td>No.</td>
<td>Descripción</td>
<td>Servidor SMTP</td>
<td>Tipo de Seguridad</td>
<td>Correo de Salida</td>
<td>Estatus</td>
</tr>
<c:forEach items="${correosgrid}" var="Enviocorreosgrid" >

<tr onclick="cargaValorLista('${campoLista}', '${Enviocorreosgrid.remitenteID}');">
<td>${Enviocorreosgrid.remitenteID}</td>
<td>${Enviocorreosgrid.descripcion}</td>
<td>${Enviocorreosgrid.servidorSMTP}</td>
<td>${Enviocorreosgrid.tipoSeguridad}</td>
<td>${Enviocorreosgrid.correoSalida}</td>
<td>${Enviocorreosgrid.estatus}</td>
	
</tr>
</c:forEach>
</c:when>


</c:choose>
</table>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="listaPaginada" value="${listaResultado[1]}" />
<c:set var="listaResultado" value="${listaPaginada.pageList}" />

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<c:choose>
	<c:when test="${tipoLista == '10'}">
		<legend>Inversiones Vencidas</legend>
	</c:when>
	<c:when test="${tipoLista == '2'}">
		<legend>Inversiones Vigentes</legend>
	</c:when>
</c:choose>
	<table width="100%">
		<tr id="encabezadoLista">
			<td class="label" align="center">N&uacute;mero</td>
			<td class="label" align="center">Tipo</td>
			<td class="label" align="center">Etiqueta</td>
			<td class="label" align="center">Inicio</td>
			<td class="label" align="center">Vencimiento</td>							
			<td class="label" align="center">Monto</td>
			<td class="label" align="center">Tasa Neta</td>
			<td class="label" align="center">Inter&eacute;s Generado</td>
			<c:choose>
				<c:when test="${tipoLista == '10'}">
					<td class="label" align="center">Inter&eacute;s  Retenido</td>
					<td class="label" align="center">Inter&eacute;s  Pagado</td>
				</c:when>
				<c:when test="${tipoLista == '2'}">
					<td class="label" align="center">Inter&eacute;s a Retener</td>
					<td class="label" align="center">Inter&eacute;s a Recibir</td>
				</c:when>
			</c:choose>
		</tr>
		<c:forEach items="${listaResultado}" var="resCteInv" varStatus="status"> 
		<tr>
				<td  align="left"> 
					<label>${resCteInv.inversionID}</label>						
				</td> 
				<td  align="left" nowrap="nowrap"> 
					<label>${resCteInv.tipoInversionID}</label>						
				</td> 
				<td  align="left"> 
					<label>${resCteInv.etiqueta}</label>						
				</td> 
				<td  align="center" nowrap="nowrap"> 
					<label>${resCteInv.fechaInicio}</label>						
				</td> 
				<td  align="center"> 
					<label>${resCteInv.fechaVencimiento}</label>						
				</td> 
				<td  align="right"> 
					<label>${resCteInv.montoString}</label>					
				</td> 
				<td  align="right"> 
					<label>${resCteInv.tasaNetaString}</label>				
				</td> 
				<td  align="right"> 
					<label>${resCteInv.interesGeneradoString}</label>					
				</td> 
				<td  align="right"> 
					<label>${resCteInv.interesRetenerString}</label>					
				</td> 
				<td  align="right"> 
					<label>${resCteInv.interesRecibirString}</label>					
				</td>  
	    </tr>
		</c:forEach>
	</table>
	<c:if test="${!listaPaginada.firstPage}">
		<input onclick="muevePagina(${tipoLista},'previous')" type="button" value="" id="anterior${tipoLista}" class="btnAnterior" />
	</c:if>
	<c:if test="${!listaPaginada.lastPage}">
		<input onclick="muevePagina(${tipoLista},'next')" type="button" id="siguiente${tipoLista}" value="" class="btnSiguiente" />
	</c:if>
</fieldset>

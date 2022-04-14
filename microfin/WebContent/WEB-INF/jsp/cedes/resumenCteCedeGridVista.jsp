<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend>CEDES</legend>	 
	<table width="100%">
		<tr id="encabezadoLista">
			<td class="label" align="center">N&uacute;mero</td>
			<td class="label" align="center">Tipo</td>
			<td class="label" align="center">Tipo Pago</td>
			<td class="label" align="center">Inicio</td>
			<td class="label" align="center">Vencimiento</td>							
			<td class="label" align="center">Monto</td>
			<td class="label" align="center">Tasa</td>
			<td class="label" align="center">Inter&eacute;s Generado</td>
			<td class="label" align="center">Inter&eacute;s a Retener</td>
			<td class="label" align="center">Inter&eacute;s a Recibir</td>
		</tr>
		<c:forEach items="${resumenCteCede}" var="resCteCEDE" varStatus="status"> 
		<tr>
				<td  align="left"> 
					<label>${resCteCEDE.cedeID}</label>						
				</td> 
				<td  align="left" nowrap="nowrap"> 
					<label>${resCteCEDE.tipoCedeID}</label>						
				</td> 
				<td  align="left"> 
					<label>${resCteCEDE.tipoPagoInt}</label>						
				</td> 
				<td  align="center" nowrap="nowrap"> 
					<label>${resCteCEDE.fechaInicio}</label>						
				</td> 
				<td  align="center"> 
					<label>${resCteCEDE.fechaVencimiento}</label>						
				</td> 
				<td  align="right"> 
					<label>${resCteCEDE.monto}</label>					
				</td> 
				<td  align="right"> 
					<label>${resCteCEDE.tasaNeta}</label>				
				</td> 
				<td  align="right"> 
					<label>${resCteCEDE.interesGenerado}</label>					
				</td> 
				<td  align="right"> 
					<label>${resCteCEDE.interesRetener}</label>					
				</td> 
				<td  align="right"> 
					<label>${resCteCEDE.interesRecibir}</label>					
				</td>  
	    </tr>
		</c:forEach>
	</table>
</fieldset>

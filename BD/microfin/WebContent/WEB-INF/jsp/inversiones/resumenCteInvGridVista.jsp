<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend>Inversiones</legend>	
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
			<td class="label" align="center">Inter&eacute;s a Retener</td>
			<td class="label" align="center">Inter&eacute;s a Recibir</td>
		</tr>
		<c:forEach items="${resumCteInv}" var="resCteInv" varStatus="status"> 
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
</fieldset>

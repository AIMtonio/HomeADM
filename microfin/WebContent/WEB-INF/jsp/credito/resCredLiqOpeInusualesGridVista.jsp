<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="creditoLiq" value="${creditoLiq}"/>

	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>&Uacute;ltimos Cr&eacute;ditos</legend>	
			<table width="100%">
			<tr id="encabezadoLista">
				<td class="label" align="center">No. Cr&eacute;dito</td>
				<td class="label" align="center">Producto Cr&eacute;dito </td>
				<td class="label" align="center">Fecha Entrega</td>
				<td class="label" align="center">Fecha Liquidaci&oacute;n</td>
				<td class="label" align="center">Usuario que Tramit&oacute; la Solicitud</td>
				<td class="label" align="center">Monto Otorgado </td>							
				<td class="label" align="center">Destino del Cr&eacute;dito </td>
				<td class="label" align="center">Proyecto </td>				
			</tr>
			     		
			<c:forEach items="${creditoLiq}" var="creditoLiq" varStatus="status2"> 
			<tr>
				<td  align="left"> 
					<label>${creditoLiq.creditoID}</label>					
				</td> 
				<td  align="left"> 
					<label>${creditoLiq.producCreditoID}</label>					
				</td> 
				<td  align="center"> 
					<label>${creditoLiq.fechaMinistrado}</label>				
				</td> 
				<td  align="center"> 
					<label>${creditoLiq.fechTerminacion}</label>					
				</td> 
				<td  align="left"> 
					<label>${creditoLiq.nombreUsuario}</label>					
				</td> 
				<td  align="right"> 
					<label>${creditoLiq.montoCredito}</label>				
				</td> 
				<td  align="left"> 
					<label>${creditoLiq.desDestinoCredito}</label>					
				</td> 
				<td  align="left"> 
					<label>${creditoLiq.proyecto}</label>				
				</td>						     		
			</tr>
		</c:forEach>
		</table>
	</fieldset>

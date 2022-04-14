<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Cr&eacute;ditos</legend>	
			<table width="100%">
			<tr id="encabezadoLista">
				<td class="label" align="center">No. Cr&eacute;dito</td>
				<td class="label" align="center">Producto Cr&eacute;dito </td>
				<td class="label" align="center">Fecha Solicitud </td>
				<td class="label" align="center">Monto Solicitado </td>
				<td class="label" align="center">Monto Otorgado </td>							
				<td class="label" align="center">Fecha Desembolso </td>
				<td class="label" align="center">Fecha de Vencimiento </td>
				<td class="label" align="center">Saldo Total </td>
				<td class="label" align="center">Monto Exigible </td>
				<td class="label" align="center">Fecha Prox. Vto. </td>
				<td class="label" align="center">Estatus</td>
				<td class="label" align="center">Origen</td>
			</tr>
			     		
			<c:forEach items="${resumCteCred}" var="resCteCred" varStatus="status"> 
			<tr>
				<td  align="left"> 
					<label>${resCteCred.creditoID}</label>					
				</td> 
				<td  align="left"> 
					<label>${resCteCred.producCreditoID}</label>					
				</td> 
				<td  align="center"> 
					<label>${resCteCred.fechaAutoriza}</label>				
				</td> 
				<td  align="right"> 
					<label>${resCteCred.montoPagar}</label>					
				</td> 
				<td  align="right"> 
					<label>${resCteCred.montoCredito}</label>					
				</td> 
				<td  align="center"> 
					<label>${resCteCred.fechaMinistrado}</label>				
				</td> 
				<td  align="center"> 
					<label>${resCteCred.fechaVencimien}</label>					
				</td> 
				<td  align="right"> 
					<label>${resCteCred.montoDesemb}</label>				
				</td> 
				<td  align="right"> 
					<label>${resCteCred.pagoExigible}</label>					
				</td> 
				<td  align="center"> 
					<label>${resCteCred.fechaCorte}</label>					
				</td>	
				<td  align="center"> 
					<label>${resCteCred.estatus}</label>				
				</td>	
				<td  align="center"> 
					<label>${resCteCred.origen}</label>				
				</td>		     		
			</tr>
		</c:forEach>
		</table>
	</fieldset>
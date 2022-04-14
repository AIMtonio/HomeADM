<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Movimientos de Ahorro</legend>	
			<table width="100%">
			<tr id="encabezadoLista">
				<td class="label" align="center">Fecha</td>
				<td class="label" align="center">Descripci&oacute;n </td>
				<td class="label" align="center">Tipo </td>
				<td class="label" align="center">Referencia</td>
				<td class="label" align="center">Monto </td>				
			</tr>
			     		
			<c:forEach items="${movcuentasaho}" var="movcuentas" varStatus="status"> 
			<tr>
				<td  align="center"> 
					<label>${movcuentas.fecha}</label>					
				</td> 
				<td  align="left"> 
					<label>${movcuentas.descripcionMov}</label>					
				</td> 
				<td  align="center"> 
					<label>${movcuentas.tipoMov}</label>				
				</td> 
				<td  align="left"> 
					<label>${movcuentas.referenciaMov}</label>					
				</td> 
				<td  align="right" esMoneda="true"> 
					<label>${movcuentas.cantidadMov}</label>					
				</td>						
			</tr>
		</c:forEach>
		</table>
	</fieldset>
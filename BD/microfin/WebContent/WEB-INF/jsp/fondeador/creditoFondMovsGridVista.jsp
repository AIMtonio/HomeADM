<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<br></br>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<div id="formaGenerica3" class="formaGenerica3">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Movimientos</legend>	
		<table id="tablaMovsFond" border="0" cellpadding="0" cellspacing="0" width="60%">
			<tbody>	
				<tr>	
					<td class="label" nowrap="nowrap"><label for="lblFecha">No. Amortizaci&oacute;n</label></td>					
					<td class="label" nowrap="nowrap"><label for="lblFecha">Fecha Operacion</label></td>
					<td class="label" nowrap="nowrap"><label for="lblCR">Descripci&oacute;n</label></td>	
					<td class="label" nowrap="nowrap"><label for="lblCuenta">Tipo</label></td>
			  		<td class="label" nowrap="nowrap"><label for="lblReferencia">Naturaleza</label></td> 
		     		<td class="label" nowrap="nowrap"><label for="lblDescripcion">Cantidad</label></td> 
				</tr>
				<c:forEach items="${listaResultado}" var="movCreditoFond" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td> 
							<input type="text" id="amortizacionID${status.count}"  name="amortizacionID" size="12"  
									value="${movCreditoFond.amortizacionID}" readonly="true" disabled="true"/> 
					  	</td> 
						<td> 
							<input type="text" id="fechaOperacion${status.count}"  name="fechaOperacion" size="12"  
									value="${movCreditoFond.fechaOperacion}" readonly="true" disabled="true"/> 
					  	</td> 
					  	<td> 
							<input type="text" id="descripcion${status.count}" name="descripcion" size="45" 
									value="${movCreditoFond.descripcion}" readonly="true" disabled="true"/> 
					  	</td> 
					  	<td> 
							<input type="text" id="descripTipMov${status.count}" name="descripTipMov" size="38" 
									value="${movCreditoFond.descripTipMov}" readonly="true" disabled="true"/> 
					  	</td>
						<td>   
				         	<input type="text" id="natMovimientoDes${status.count}" name="natMovimientoDes" size="8" align="right"
				         			value="${movCreditoFond.natMovimientoDes}" readonly="true" disabled="true"/> 
				     	</td> 
					  	<td> 
							<input type="text"  style="text-align:right" id="cantidad${status.count}" name="cantidad" size="15" 
									value="${movCreditoFond.cantidad}" readonly="true" disabled="true" esMoneda="true"/> 
					  	</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>				
	</fieldset>
</div>
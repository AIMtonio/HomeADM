<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<c:set var="listaResultado"  value="${listaResultado[0]}"/>
<fieldset class="ui-widget ui-widget-content ui-corner-all">             
	<legend>Inversionistas Kubo</legend>	
		<form id="gridDetalle" name="gridDetalle">
			
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
				  		<td class="label"> 
			         	<label for="lblConsecu">Consecutivo</label> 
			     		</td> 
			     		<td class="label"> 
					   	<label for="lblCliente">No. <s:message code="safilocale.cliente"/></label> 
						</td>
						<td class="label"> 
			         	<label for="lblFechaRegistro">Fecha</label> 
			     		</td>    
			     			<td class="label"> 
			         	<label for="lblMontoFondeo">Monto</label> 
			     		</td>  
			     		<td class="label"> 
			         	<label for="lblPorcenFondeo">Porcentaje</label> 
			     		</td>  		  		
			     		<td class="label"> 
			         	<label for="lblTasaPasiva">Tasa</label> 
			     		</td>	
			     		<td class="label"> 
			         	<label for="lblMargen">Margen</label> 
			     		</td>	
					</tr>
					
					<c:forEach items="${listaResultado}" var="fondeo" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
						  	<td> 
								<input id="consecutivo${status.count}" name="consecutivo" size="12" 
										value="${fondeo.consecutivo}" readOnly="true" disabled="true"/> 
						  	</td> 
						  	<td> 
								<input id="clienteID${status.count}"  name="clienteID" size="50"  
										value="${fondeo.clienteID}" readOnly="true" disabled="true"/> 
						  	</td> 
						  	<td>   
				         	<input id="fechaRegistro${status.count}" name="fechaRegistro" size="15" align="right"
				         			value="${fondeo.fechaRegistro}" readOnly="true" disabled="true" /> 
				     		</td> 
							<td> 
				         	<input id="montoFondeo${status.count}" name="montoFondeo" size="10"  align="right" 
				         			value="${fondeo.montoFondeo}" readOnly="true" disabled="true" esMoneda="true"/> 
				     		</td> 
							<td> 
				         	<input id="porcentajeFondeo${status.count}" name="porcentajeFondeo" size="10" align="right"
				         			value="${fondeo.porcentajeFondeo}" readOnly="true" disabled="true" esMoneda="true"/>
				         	<label for="lblporc">%</label> 
				     		</td> 
				     		<td> 
				         	<input id="tasaPasiva${status.count}" name="tasaPasiva" size="8" align="right"
				         			value="${fondeo.tasaPasiva}" readOnly="true" disabled="true" esTasa="true"/> 
				     		</td> 
				     		<td> 
				         	<input id="margen${status.count}" name="margen" size="10" align="right"
				         			value="${fondeo.margen}" readOnly="true" disabled="true" esMoneda="true"/> 
				     		</td> 
						</tr>
						<td colspan=2>
						</td>
	               <c:set var="totalM" value="${fondeo.montoTotal}"/> 
						<c:set var="porcentajeM" value="${fondeo.porcentaje}"/> 
					</c:forEach>
					<td><label for="lblTotal">Total</label></td>
				  <td> 
				         	<input id="totalMonto" name="total" size="10" align="right"
				         			value="${totalM}" readOnly="true" disabled="true" esMoneda="true"/> 
				         			
				   </td>  
				   <td> 
				         	<input id="porcentajeMonto" name="totalPorcentaje" size="10" align="right"
				         			value="${porcentajeM}" readOnly="true" disabled="true" esMoneda="true"/> 
				         			<label for="lblporc">%</label>
				   </td>  
				</tbody>
				
			</table>
		
	
</form>

</fieldset>
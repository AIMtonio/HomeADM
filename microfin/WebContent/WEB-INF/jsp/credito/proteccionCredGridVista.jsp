<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<br/>


	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Cr&eacute;ditos</legend>	
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label" > <label for="lblTipoDocumento"> Crédito</label></td>
						<td class="label"> <label for="lblProductoCredito"> Producto Crédito</label></td>
						<td class="label"> <label for="lblFechaAutoriza"> Estatus</label></td>
						<td class="label"> <label for="lblMontoOtorgado"> Monto Otorgado</label></td>							
						<td class="label"> <label for="lblFechaDesem"> Fecha Desembolso</label></td>						
						<td class="label"> <label for="lblDeudaTotal"> Deuda Total S/IVA</label></td>
						<td class="label"> <label for="lblMontoProteccion">Monto Protección</label></td>
						<td class="label"> <label for="lblProteccion"> Protección</label></td>
						
					</tr>
					<c:set var="tipoLista"  	value="${resumCteCred[0]}"/>
					<c:set var="resumCteCred" 	value="${resumCteCred[1]}"/>
					     		
					<c:forEach items="${resumCteCred}" var="resCteCred" varStatus="status"> 
					<tr id="renglon${status.count}" name="renglon">
						<td>
							<input type="text" id="numeroCredito${status.count}" name="numeroCredito" size="15" 
								value="${resCteCred.creditoID}" readOnly="true"  disabled="disabled" />
						
						</td>
						<td>
							<input type="text" id="productoCredito${status.count}" name="productoCredito" size="40" 
								value="${resCteCred.producCreditoID}" readOnly="true"  disabled="disabled" />				
						</td>
						
						<td>
								<input type="text" id="estatus${status.count}" name="estatus" size="15" 
									value="${resCteCred.estatus}" readOnly="true"  disabled="disabled" />				
						</td> 
		
					  	<td>
					  		<input type="text" id="montoCredito${status.count}" name="montoCredito" size="15" 
					  			value="${resCteCred.montoCredito}" readOnly="true"  disabled="disabled" style="text-align: right" esMoneda="true"/>
					  	
						</td>
					  	<td>
					  		<input type="text" id="fechaDesembolso${status.count}" name="fechaDesembolso" size="15" 
					  			value="	${resCteCred.fechaMinistrado}" readOnly="true"  disabled="disabled"  />			  	
					  </td>	
					  <td>
					  		<input type="text" id="totalAdeudo${status.count}" name="totalAdeudo" size="15" 
					  			value="${resCteCred.totalAdeudo}" readOnly="true"  disabled="disabled" style="text-align: right" 
					  			esMoneda="true"/>					  			
					  	
					  	</td>	
				  		 <td>
				  		 	<c:if test = "${tipoLista == 2 }">	
					  			<input type="text" id="diferencia${status.count}" name="diferencia"  size="15"  
					  				value="${resCteCred.monAplicaCredito}" readOnly="true"  disabled="disabled" 
					  				style="text-align: right" esMoneda="true" value="0.00" />
					  		</c:if>	
					  		<c:if test = "${tipoLista == 17}">	
					  			<input type="text" id="diferencia${status.count}" name="diferencia"  size="15"  
					  				value="0.00"  onblur="calculaProteccionCredito(this.id);"  style="text-align: right" esMoneda="true"/>
					  		</c:if>	
				  		</td>
					  	
					  	<td>
					  		<input type="checkbox" id="proteccion${status.count}" name="proteccion" 
					  				value="S" onclick="sumaProteccionCredito(this.id)"  esMoneda="true"  />
			    			<label for="lblProteccion"> </label>  						  	
					  	</td>		     		
					</tr>
				</c:forEach>
				<tr>
						<td></td>
						<td></td>
						<td></td>
						<td></td>	
						<td></td>						
						<td><label for="lblTotalProteccion">Total Beneficio: </label>  	</td>						
						<td><input type="text" id="monAplicaCredito" name="monAplicaCredito" size="15" readOnly="true"  disabled="disabled" 
								style="text-align: right" esMoneda="true" value="0.00"/>   </td>				
				</tr>
			</tbody>	
		</table>
	</fieldset>
	
	

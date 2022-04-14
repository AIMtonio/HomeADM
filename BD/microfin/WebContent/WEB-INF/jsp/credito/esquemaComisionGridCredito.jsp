<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

	<c:set var="esquemaComisionLis"  value="${esquemaComisionLis}" />
	<div id="esquemaComisionGrid" >
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend>Detalle</legend>	
			<input type="button" id="agregar" value="Agregar" class="botonGral" onclick="agregaNuevoEsquema()"/>
				<table border="0" cellpadding="0" cellspacing="0" width="100%" id="miTabla"> 		
					<tbody>	
					<tr>
						<td class="label"> 
						<label for="lblNo">No</label> 
						</td> 
						<td class="label"> 
						<label for="lblMonInicial"> Mon.Inicial</label> 
				  		</td>
				  		<td class="label"> 
			        	<label for="lblMonFinal">Mon.Final</label> 
			     		</td>
			     		<td class="label"> 
			        	<label for="lblTipo">Tipo</label> 
			     		</td> 
			     		<td class="label"> 
			        	<label for="lblComision">Comisión</label> 
			     		</td>  
			     		<td class="label"> 
			     		</td>  
					 </tr>			    
			   		 <c:forEach items="${esquemaComisionLis}" var="esquemaComisionLis" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td> 
						<input  id="consecutivo${status.count}" name="consecutivo" size="6" value="${status.count}" disabled="true" />					
						</td> 
						<td>
						<input type="text" size="14" name="montoInicial" id="montoInicial${status.count}" value="${esquemaComisionLis.montoInicial}" readOnly="true"  esMoneda="true" disabled="true" onchange="agregaFormato(this.id)"/>
						</td>
						<td>
							<input type="text" size="14" name="montoFinal" id="montoFinal${status.count}" value="${esquemaComisionLis.montoFinal}" " readOnly="true"  esMoneda="true" disabled="true" onchange="agregaFormato(this.id)"/>
						</td>
						<td>
							<select name="tipoComision" id="tipoComision${status.count}" disabled="true" >
								<option value="M"${esquemaComisionLis.tipoComision == 'M' ? 'selected' : ''}>MONTO</option>
								<option value="P"${esquemaComisionLis.tipoComision == 'P' ? 'selected' : ''}>PORCENTAJE (1/100)</option>
							</select>
						</td>
						<td>
							<input type="text" size="14" name="comision" id="comision${status.count}" value="${esquemaComisionLis.comision}" disabled="true"  onBlur="cambioFormatoComision()"/>
							</td>
						<td>
							<input type="button" name="elimina" id="${status.count}" class="btnElimina" value="" onclick="eliminarEsquema(this.id)"/>
							<input type="button" name="agrega" id="agrega${status.count}" class="btnAgrega" onclick="agregaNuevoEsquema()"/>							
						</td>
					</tr>
					<c:set var="numeroFilas"  value="${status.count}" />
	
				</c:forEach>
				</tbody>								
			</table>
			<input type="hidden" value="${numeroFilas}" name="numeroEsquema" id="numeroEsquema" />
			
		</fieldset>
	</div>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>

	<head>	
		<script type="text/javascript" src="dwr/interface/conceptoContableServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/polizaServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>     
		<script type="text/javascript" src="dwr/interface/polizaArchivosServicio.js"></script> 	
		<script type="text/javascript" src="dwr/interface/periodoContableServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/prorrateoContableServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 		
		<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/catIngresosEgresosServicio.js"></script> 		
		<script type="text/javascript" src="dwr/interface/catMetodosPagoServicio.js"></script> 	
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/proveedoresServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/divisasServicio.js"></script>  
		<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>		  
	   	<script type="text/javascript" src="js/contabilidad/polizaContableCatalogo.js"></script>
	   	<script type="text/javascript" src="js/contabilidad/polizaInfAdicional.js"></script>	
	   	   		  
	</head>
<body>

<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">P&oacute;lizas Contables</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="polizaBean">  	
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label"> 
				         <label for="lblpolizaID">P&oacute;liza:</label> 
				     	</td> 
				     	<td> 
				      	<form:input type="text" id="polizaID" name="polizaID" path="polizaID" autocomplete="off" size="8" 
				         	tabindex="1" /> 
				     	</td> 
				     	<td class="separador"></td> 	
				     	<td class="label"> 
				      	<label for="lblfecha">Fecha:</label> 
				     	</td> 
				     	<td> 
				      	<form:input id="fecha" name="fecha" path="fecha" size="20"
				         	type="text" esCalendario="true" tabindex="2" iniForma = "false" /> 
				     	</td> 
					</tr>	
					<tr> 
						<td class="label"> 
				         <label for="lblconcepto">Concepto:</label> 
				     	</td> 
				     	<td> 
				      	<form:input type="text" id="conceptoID" name="conceptoID" autocomplete="off" path="conceptoID" size="4"
				         	tabindex="3" /> 
				     	</td> 
				     	<td class="separador"></td> 	
				     	<td class="label"> 
				      	<label for="lblDescripcion">Descripci&oacute;n:</label> 
				     	</td> 
				     	<td> 
				      	<form:input type="text" id="concepto" name="concepto" path="concepto" size="60"
				         	tabindex="4" onBlur=" ponerMayusculas(this)" /> 
				     	</td> 
				   </tr>		
					<tr>
						<td class="label"> 
				         <label for="lbltipo">Tipo:</label> 
				     	</td> 
				      	<td>	 
				     		<select id="tipo" name="tipo" tabindex="6" readOnly="true" disabled="true">
								<option value="M">MANUAL</option>
								<option value="A">AUTOMATICO</option>
							</select>    					      	
				     	</td>  
				     	<td class="separador"></td> 	
				    	 <td class="label"> 
				         <label for="lblmonedaID">Moneda:</label> 
				     	</td>
				     	<td> 
				     		<select id="monedaID" name="monedaID" tabindex="6">
								<option value="">Seleccionar</option>
							</select> 
				     	</td> 
				 	</tr> 	
				 	<tr>
				 		<td class="label"> 
				         <label for="lblplantilla">Plantilla: </label> 
				      </td> 
				 		<td>
			     			<select id="plantilla" name="plantilla" path="plantilla" tabindex="7">
								<option value="S">Si</option>
								<option  selected="selected" value="N" >No</option>
							</select>
						</td>
						<td class="separador"></td> 	
				     	<td class="label"> 
				         <label for="lbldesplant" id="lbldes" style="display: none;" >Descripci&oacute;n Plantilla:</label> 
				     	</td>
				     	<td> 
				     		<input type="text" id="desPlantilla" name="desPlantilla" size="60"
				         		tabindex="8" style="display: none;" /> 
				         	<input type="hidden" id="detallePoliza" name="detallePoliza" size="100" />	
				     	</td> 				
				 	</tr>
				 	<tr>
						<td colspan="7">
							
							<div id="gridDetalle" name="gridDetalle" style="width:1000px;overflow-x:scroll; display: none;"></div>
							<input type="hidden" id="prorrateoHecho" name="prorrateoHecho" value="N"/>											
						</td>												
					</tr>												
				</table>							
				
				
				<div id="divGridPolizaArchivo" name="divGridPolizaArchivo" style="display: none;"></div>
				<div id="informacionAdicional" name="informacionAdicional" style="display: none;">
					
					<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend>Informaci&oacute;n Adicional</legend>
					<table border="0" cellpadding="0" width="100%">
						<tr>
							<td class="label"> 
					         <label for="lblmovimiento">Movimiento:</label> 
					     	</td> 
					     	<td> 
					      		<select id="movimiento" name="movimiento" tabindex="9" >
					      			<option value="">SELECCIONAR</option>
									<option value="I">INGRESO</option>
									<option value="E">EGRESO</option>
								</select>    
					     	</td> 
					     	<td class="separador"></td>
					     	<td>
								<label>Instituci&oacute;n:</label>
							</td>
							<td>
								<form:input type="text" name="institucionID" id="institucionID" size="4" maxlength="11" tabindex="10" autocomplete="off" path="institucionID" />
								<input type="text" name="nomInstitucion" id="nomInstitucion" size="45" readOnly="true" disabled = "true" />
							</td>
						</tr>
							
						<tr>  
							<td class="label"> 
							   	<label for="lblNumCtaBancaria">Número de Cuenta Bancaria:</label> 
							</td>
					    	<td>
								<form:input type="text" id="numCtaBancaria" name="numCtaBancaria" path="numCtaBancaria" size="30" tabindex="11" /> 
								      	
			           		</td>
			           		<td class="separador"></td>
			           		<td class="label">
						    	<label for="lblctaClabe">Cuenta Clabe:</label> 
							</td>
						    <td>
								<form:input  type="text"  id="cuentaClabe" name="cuentaClabe" path="cuentaClabe" size="38" tabindex="12" maxlength="18" readOnly="true" disabled = "true"/> 			
							</td>
						</tr>			
						<tr>
							<td class="label"> 
					        	 <label for="lbltipoDoc">Tipo:</label> 
					     	</td> 
					     	<td>   
								<select id="tipoDoc" name="tipoDoc" path="tipoDoc"  tabindex="13" >
									<option value="">SELECCIONAR</option>							     	
								</select>
					     	</td> 
					     	<td class="separador"></td>
					     	<td class="label">
					     		<label for="lblnumCheque">Folio:</label>
					     	</td>
							<td>
								<input id="numCheque" name="numCheque" size="20" type="text" iniforma="false" tabindex="14" maxlength="10" class="valid">
							</td>
						</tr>						
						<tr>
							<td>
								<label>Pagador:</label>
								</td>
								<td>
									<form:input type="text" name="pagadorID" id="pagadorID" size="4"  tabindex="15" autocomplete="off" path="pagadorID" />
									<input type="text" name="nomPagador" id="nomPagador" size="45" readOnly="true" disabled = "true" />
								</td>
								<td class="separador"></td>
								<td class="label"> 
							   		<label for="lblimporte">Importe:</label> 
								</td>
					    		<td>
									<form:input type="text" id="importe" name="importe" path="importe" size="13" tabindex="16" style="text-align: right; color: black;" autocomplete="off"
									 esmoneda="true" class="valid" maxlength="18"  /> 	
															      	
			           			</td>
						</tr>
						
						<tr>  
							<td class="label"> 
							   	<label for="lblreferencia">Referencia:</label> 
							</td>
					    	<td>
								<form:input type="text" id="referenciaDoc" name="referenciaDoc" path="referenciaDoc" size="38" tabindex="17" maxlength="18"  /> 
								      	
			           		</td>
			           		<td class="separador"></td>
			           		<td class="label"> 
					        	 <label for="lblmetodoPago">M&eacute;todo de Pago:</label> 
					     	</td> 
					     	<td> 
					      		<select id="metodoPago" name="metodoPago" tabindex="18" >
					      			<option value="">SELECCIONAR</option>								
								</select>    
					     	</td> 
						</tr>						
						<tr id="Transferencia" style="display: none;">
							<td>
								<label>Instituci&oacute;n Origen:</label>
								</td>
								<td>
									<form:input type="text" name="instOrigenID" id="instOrigenID" size="4" maxlength="11" tabindex="19" autocomplete="off" path="instOrigenID" />
									<input type="text" name="nomInstOrigen" id="nomInstOrigen" size="45" readOnly="true" disabled = "true" />
								</td>
								<td class="separador"></td>
								<td class="label">
						    	<label for="lblctaClabeorigen">Cuenta Clabe Origen:</label> 
							</td>
						    <td>
								<form:input  type="text"  id="ctaClabeOrigen" name="ctaClabeOrigen" path="ctaClabeOrigen" size="38" tabindex="20" maxlength="18" /> 			
							</td>
						</tr>						
						<tr>
							<td>
								<label>Moneda:</label>
							</td>
							<td>
								<form:input type="text" name="monedaIDDoc" id="monedaIDDoc" size="4" maxlength="11" tabindex="21" autocomplete="off" path="monedaIDDoc" />
								<input type="text" name="descMoneda" id="descMoneda" size="45" readOnly="true" disabled = "true" />
							</td>
							<td class="separador"></td>
								<td class="label"> 
							   	<label for="lbltipoCambio">Tipo de Cambio:</label> 
							</td>
					    	<td>
								<form:input type="text" id="tipoCambio" name="tipoCambio" path="tipoCambio" size="13" tabindex="22" autocomplete="off" class="valid" maxlength="18" readOnly="true" disabled = "true" /> 	
															      	
			           		</td>
						</tr>
						
					</table>
					<table align="right">
					<tr>
						<td align="right">
							<input type="button" id="agregarDoc" name="agregarDoc" tabindex="23" class="submit" 
								 value="Agregar" tabindex="5" />
							<input type="button" id="modificarDoc" name="modificarDoc" tabindex="24" class="submit" 
								 value="Modificar" tabindex="6" />
						</td>
					</tr>
				</table>	
				</fieldset>

				</div>
					
				<table border="0" cellpadding="0" cellspacing="0" width="100%"> 
					<tr>
						<td colspan="5">
							<table align="right">
								<tr>
									<td align="right">			
										<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar"/>
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>				
									</td>
									<td align="right">
									
				                      	<button type="button" class="submit" id="imprimir" >Imprimir</button>
				                      	<input type="button" id="adjuntar" name="adjuntar" class="submit" value="Adjuntar" /> 
				                      	<input type="button" id="infAdicionalBtn" name="infAdicionalBtn" class="submit" value="Inf. Adicional" />
				                      	
									</td>									
								</tr>
									<tr>
										<td>
											 <div id="imagenPoliza" style="display: none;">
											 	<img id= "imgPoliza" SRC="images/user.jpg" WIDTH="100%" HEIGHT="100%" border ="0" alt="Poliza"/> 
											</div> 
								       </td> 
									</tr>	
							</table>		
						</td>
					</tr>	
		     </table> 
	</form:form>
	</fieldset> 
</div>

<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
	<div id="ContenedorAyuda" style="display: none;">
		<div id="elementoLista"/>
	</div>
</html>

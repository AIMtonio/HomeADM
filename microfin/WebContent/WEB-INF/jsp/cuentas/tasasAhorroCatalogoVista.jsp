<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
		<script type='text/javascript' src='js/jquery-ui-1.8.13.custom.min.js'></script>
		<script type='text/javascript' src='js/jquery-ui-1.8.13.min.js'></script>
		<script type='text/javascript' src='js/jquery.formatCurrency-1.4.0.min.js'></script>
		<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>     
      	<script type="text/javascript" src="dwr/interface/tasasAhorroServicio.js"></script>   
		<script type="text/javascript" src="js/cuentas/tasasAhorroCatalogo.js"></script>      
	</head>
   
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tasasAhorroBean"> 
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend class="ui-widget ui-widget-header ui-corner-all">Tasas de Ahorro</legend>
		     		<table border="0" cellpadding="0" cellspacing="0" width="100%"> 
			     		<tr>
				   			<td class="label"> 
				         		<label for="lblTipoCta">Tipo Cuenta: </label> 
				     		</td>
				     		<td>
				         		<form:select id="tipoCuentaID" name="tipoCuentaID" path="tipoCuentaID" tabindex="1">
									<form:option value="-1">Seleccionar</form:option>
								</form:select>
				     		</td> 
				     		<td class="separador"></td> 				
				      		<td class="label"> 
				         		<label for="lblPersona">Persona:</label> 
				    	 	</td> 
				    		<td nowrap="nowrap"> 
								<form:radiobutton id="tipoPersonaF" name="tipoPersona" path="tipoPersona" value="F" tabindex="2" checked="true" iniForma="false"/>
								<label for="lbltipoPersonaF">F&iacute;sica</label> 
								
								<form:radiobutton id="tipoPersonaA" name="tipoPersona" path="tipoPersona" value="A" tabindex="4" iniForma="false"/>
				     			<label for="lbltipoPersonaA"> Física Act Emp</label>
								
								<form:radiobutton id="tipoPersonaM" name="tipoPersona" path="tipoPersona" value="M" tabindex="3" iniForma="false"/>
				     			<label for="lbltipoPersonaM">Moral</label> 				     			
				     			
				     		</td> 
				 		</tr> 
				 		<tr>
				   			<td class="label"> 
				         		<label for="lblMoneda">Moneda:</label> 
				     		</td>
				     		<td>
					        	<form:select id="monedaID" name="monedaID" path="monedaID" tabindex="5">
									<form:option value="-1">Seleccionar</form:option>
								</form:select>  
				     		</td> 
				      		<td class="separador"></td> 				
				      		<td class="label"> 
				         		<label for="lblNumero">No.:</label> 
				    		</td> 
				    		<td> 
				         		<form:input id="tasaAhorroID" name="tasaAhorroID" path="tasaAhorroID" size="12" tabindex="5" /> 
				     		</td> 
				 		</tr> 
				 		<tr>
				   			<td class="label"> 
				         		<label for="lblMontoInferior">Monto Inferior:</label> 
				     		</td>
				     		<td>
				         		<form:input id="montoInferior" name="montoInferior" path="montoInferior" size="15" tabindex="6" esMoneda="true" />
				     		</td> 
				     		<td class="separador"></td> 				
				      		<td class="label"> 
				         		<label for="lblmontoSuperior">Monto Superior:</label> 
				    	 	</td> 
				    		<td> 
				         		<form:input id="montoSuperior" name="montoSuperior" path="montoSuperior" size="15" tabindex="7" esMoneda="true" /> 
				     		</td> 
				 		</tr> 
				 		<tr>
				   			<td class="label"> 
				         		<label for="lbltasa">Tasa</label> 
				     		</td>
				     		<td>
				         		<form:input id="tasa" name="tasa" path="tasa" size="8" tabindex="8" esTasa="true" /><label for="lbltasa">%</label> 
				     		</td> 
				     		<td class="separador"></td> 				     		
				 		</tr> 
				 	</table>				 			
					<div id="tasasAhorroGrid" name="tasasAhorroGrid" style="display: none;">
					</div>	
					<table align="right">
						<tr>
							<td colspan="5">
								<table align="right">
									<tr>
										<td align="right">
											<input type="submit" id="graba" name="graba" class="submit" value="Grabar" tabindex="11" />
											<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="12" />
											<input type="submit" id="elimina" name="elimina" class="submit" value="Eliminar" tabindex="13"  />
											<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>				
										</td>
									</tr>
								</table>		
							</td>
						</tr>	
					</table>
				</fieldset>
			</form:form>
		</div>
		<div id="cargando" style="display: none;">	</div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
		</div>
	</body>
	<div id="mensaje" style="display: none;"/>
</html>
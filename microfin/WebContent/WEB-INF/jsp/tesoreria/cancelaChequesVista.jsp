<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/chequesEmitidosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/motivoCancelacionChequesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script> 
		<script type="text/javascript" src="js/tesoreria/cancelaCheques.js"></script> 
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cancelaCheques">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend class="ui-widget ui-widget-header ui-corner-all">Cancelaci&oacute;n de Cheques</legend>
						<table border="0" width="100%" >
							<tr>
								<td class="label" nowrap ="nowrap">
						 			<label for="lblTipoCancelacion">Tipo Cancelaci&oacute;n: </label>	 			
						 		</td>
						 		<td>
									<form:select id="tipoCancelacion" name="tipoCancelacion" path="tipoCancelacion" style="width:230px" tabindex="1">
										<form:option value="">SELECCIONAR</form:option>								
										<form:option value="1">GASTOS Y ANTICIPOS</form:option>
										<form:option value="2">DISPERSIONES SIN REQUISICIONES</form:option>
										<form:option value="3">DISPERSIONES DE REQUISICIONES (CON FACTURAS)</form:option>
									</form:select>
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
						 			<label for="institucionID">Instituci&oacute;n Bancaria: </label>	 			
						 		</td>
	 							<td>
	 								<form:input id="institucionID" name="institucionID" path="institucionID" size="5" tabindex="2" autocomplete="off" />
	 								<input type="text" id="nombreInstitucion" name="nombreInstitucion" size="40" disabled="true" />	 			
	 							</td>	
							</tr>							 
							<tr>
							<td class="label" nowrap="nowrap">
	 								<label for="numCtaInstit">Cuenta Bancaria: </label>	 				 			
						 		</td>
						 		<td>
	 								<form:input id="numCtaInstit" name="numCtaInstit" path="numCtaInstit"  size="25" tabindex="3"  autocomplete="off"/>	 			 				 			
	 							</td>
	 							<td class="separador"></td>
								<td class="label" >
									<label for="lblTipoChequera">Formato Cheque:</label>
								</td>
								<td>
									<select id="tipoChequera" name="tipoChequera" tabindex="4">
										<option value="">SELECCIONAR</option>
									</select>
								</td>																										
	 						</tr>
	 						<tr>
	 							<td class="label" nowrap ="nowrap">
	 								<label for="numCheque">N&uacute;mero Cheque: </label>	 				 			
						 		</td>
						 		<td>
	 								<form:input id="numCheque" name="numCheque" path="numCheque"  size="25" tabindex="5" autocomplete="off"/>	 			 				 			
	 							</td>
	 							<td class="separador"></td>	 	
						 		<td class="label" nowrap="nowrap">
						 			<label for="sucursalEmision">Sucursal Emisi&oacute;n: </label>
						 		</td>
						 		<td>
						 			<form:input id="sucursalEmision" name="sucursalEmision" path="sucursalEmision" size="6" readonly="true"/>
	 								<input type="text" id="nombreSurcursal" name="nombreSurcursal" size="40" disabled="true" />	 									 			
						 		</td>		 				
							</tr>
							<tr>	 			
						 		<td class="label" nowrap="nowrap">
									<label for="fechaEmision">Fecha Emisi&oacute;n: </label>
								</td>
								<td>
						 			<form:input name="fechaEmision"	id="fechaEmision" path="fechaEmision" size="15" readonly="true" />				
						 		</td> 
						 	</tr>	
							<tr id="trFact1">
						 		<td class="label" nowrap="nowrap">
						 			<label for="numReqGasID">N&uacute;m. Requisici&oacute;n: </label>
						 		</td>
						 		<td>
						 			<form:input id="numReqGasID" name="numReqGasID" path="numReqGasID" size="5" readonly="true"/>
						 		</td>		 		
						 		<td class="separador"></td>	 			
						 		<td class="label" nowrap="nowrap">
									<label for="proveedorID">N&uacute;m. Proveedor: </label>
								</td>
								<td>
						 			<form:input name="proveedorID"	id="proveedorID" path="proveedorID" size="5" readonly="true" />	
						 			<input type="text" id="nombreProveedor" name="nombreProveedor" size="40" disabled="true" />	 									 									 						
						 		</td> 		
							</tr>
							<tr id="trFact2">
						 		<td class="label" nowrap="nowrap">
						 			<label for="numFactura">N&uacute;m. Factura: </label>
						 		</td>
						 		<td>
						 			<form:input id="numFactura" name="numFactura" path="numFactura" size="15" readonly="true"/>
						 		</td>		 		
						 		<td class="separador"></td>	 			
								<td class="separador"></td>
							</tr>
							<tr>
								<td class="label"  nowrap="nowrap">
									<label for="monto"> Monto:</label>
								</td>
								<td>
									<form:input name="monto" id="monto" path="monto" size="15" readonly="true" esMoneda="true" style="text-align: right"/>
								</td>
								<td class="separador"></td>
								<td class="label"  nowrap="nowrap">
									<label for="beneficiario">Nombre Beneficiario:</label>
								</td>
								<td>
									<form:input path="beneficiario" name="beneficiario" id="beneficiario" size="46" readonly="true"  maxlength="100"/>
								</td>				
							</tr>
							<tr>
								<td class="label"  nowrap="nowrap">
									<label for="concepto">Concepto:</label>
								</td>
								<td>
									<form:input path="concepto" name="concepto" id="concepto" size="46" readonly="true"/>
								</td>
								<td class="separador"></td>		
								<td class="label"  nowrap="nowrap">
									<label for="motivoCancela"> Motivo Cancelaci&oacute;n:</label>
								</td>
								<td>
									<form:input name="motivoCancela" id="motivoCancela" path="motivoCancela" size="5" tabindex="6" autocomplete="off"/>
									<input type="text" id="descripcion" name="descripcion" size="40" disabled="true" />	 									 									 						
								</td>										
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label class="comentario">Comentario:</label>
								</td>
								<td>
									<textarea id="comentario" name="comentario" cols =43 rows=6 tabindex="7" autocomplete="off" onBlur=" ponerMayusculas(this)"  style="overflow:auto;resize:none" maxlength="500"></textarea>
								</td>
							</tr>
					</table>
					<br>
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="cancelarCheque" name="cancelarCheque"   class="submit"
									  value="Cancelar" tabindex="8"/>
								<input type="hidden" id="numeroPoliza" name="numeroPoliza"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>						
							</td>
						</tr>
					</table>	
				</fieldset>
			</form:form>
		</div>
		<div id="cargando" style="display: none;">	
		</div>
		<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
		</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>
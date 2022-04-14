<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="js/date.js"></script>
	<script type="text/javascript" src="dwr/interface/cedesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/operacionesFechasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tiposCedesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tasasCedesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>  
    <script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/inversionServicioScript.js"></script>  
    <script type="text/javascript" src="dwr/interface/plazosPorProductosServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>    
    <script type="text/javascript" src="js/soporte/mascara.js"></script>
	<script type="text/javascript" src="js/general.js"></script> 
    <script type="text/javascript" src="js/cedes/altaCedes.js"></script>
	
	<title>Alta de CEDE</title>
</head> 


<body>
 <div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">CEDE</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST"  commandName="cedesBean" >
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend >Datos Generales</legend>
				<table border="0">
					<tr>
						<td class="label">
							<label>CEDE: </label>
						</td>						
						<td>
							<form:input type="text" name="cedeID" id="cedeID" path="cedeID" size="11" maxlength="11"  autocomplete="off" tabindex="1" />			    
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td class="label">
							<label><s:message code="safilocale.cliente"/>: </label>
						</td>
						<td>
							<form:input type="text" name="clienteID" id="clienteID" size="11" maxlength="11" tabIndex= "2"  autocomplete="off" path="clienteID" />
							<input type="text" name="nombreCompleto" id="nombreCompleto" size="50"   readonly="true"  disabled="true" />
							<input type="hidden" id="socioCliente" name="socioCliente" value="<s:message code="safilocale.cliente"/>" />		  
						</td>						
					</tr>
					<tr>
						<td class="label" style=" vertical-align: text-top;">
							<label>Direcci&oacute;n: </label>
						</td>
						<td>
							<textarea rows="3" cols="80" name="direccion" id="direccion" readonly="true"   autocomplete="off"></textarea>
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" style=" vertical-align: text-top;">
							<label>Tel&eacute;fono: </label>
						</td>
						<td style=" vertical-align: text-top;">
							<input type="text" name="telefono" id="telefono" size="15" readonly="true"   disabled="true" />
						</td>
					</tr>
					<tr>
						<td>
							<label>Cuenta Cobro: </label>
						</td>
						<td>
							<form:input id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID" size="15" maxlength="18" tabIndex = "6"  autocomplete="off" />										
						</td>
						<td class="separador"></td>
						<td>
							<label>Saldo&nbsp;: </label>				
						</td>
						<td>
							<input type="text" id="totalCuenta" name="totalCuenta" style="text-align: right;" size="15" readonly="true"  esMoneda="true"  disabled="disabled"/>
							<label id="tipoMoneda"></label>	
						</td>
						<td></td>
						<td>
							<input type="hidden" id="tasaFV" name="tasaFV"/>
							<form:input type="hidden" name="monedaID" id="monedaID" path="monedaID" />
						</td>
					</tr>
					<tr>
						<td>
							<label>Tipo de CEDE:  &nbsp;</label>								
						</td>
						<td nowrap="nowrap">
							<form:input id="tipoCedeID" name="tipoCedeID" path="tipoCedeID" tabIndex = "7" size="15" maxlength="11" autocomplete="off" />
							<input type="text" id="descripcion" name="descripcion"  size="40" readonly="true"  disabled="true"/>
							<input type="hidden" id="diaInhabil" name="diaInhabil"  size="5" readonly="true"  disabled="true"/>	
							<input type="hidden" id="esDiaHabil" name="esDiaHabil"  size="5" readonly="true"  disabled="true"/>
							<input type="hidden" id="pagoIntCal" name="pagoIntCal"  size="5" readonly="true" />	
						</td>
						<td class="separador"></td>
						<td>
							<label>Tipo de Pago:</label>
						</td>					
						<td>
							<select id="tipoPagoInt" name="tipoPagoInt" tabindex="8">
								<option value="">SELECCIONAR</option>
							</select>
						</td>
					</tr>	
					<tr>
						<td class="label">
							<label id="lbldiasPeriodo" for="diasPeriodo">No. D&iacute;as Periodo:</label>
						</td>
						<td><form:select id="diasPeriodo" name="diasPeriodo" path="diasPeriodo" tabindex="9" >
								<form:option value="">SELECCIONAR</form:option>
							</form:select>
						</td>
					</tr>
				</table>
				<br> 
				<table>
					<tr>
						<td colspan="4">  
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend >Condiciones: </legend>
								<table border="0" width="100%">
									<tr>
										<td>
											<label>Monto: </label>
										</td>
										<td nowrap="nowrap">
											<form:input name="monto" id="monto" size="18" path="monto" esMoneda="true" autocomplete="off" tabIndex = "10" style="text-align: right;" />
											<label id="tipoMonedaInv"></label>
										</td>
										<td nowrap="nowrap">
											<label id="lblTasa">Tasa Bruta: </label>
										</td>
										<td nowrap="nowrap">
											<form:input type="text" name="tasaFija" id="tasaFija" path="tasaFija" size="12" readonly="true"  disabled="true" esTasa = "true"  style="text-align: right;"/><label id="lblporcien">%</label>
										</td>
										<td>&nbsp;&nbsp;</td>
										<td nowrap="nowrap">
											<label id="lblInteresGenerado">Inter&eacute;s Generado: </label>
										</td>
										<td>
											<form:input name="interesGenerado" id="interesGenerado" path="interesGenerado" readonly="true"  disabled="true" size="18"   esMoneda="true"  style="text-align: right;"/>
										</td>
										<td colspan="2" >
											<label >Tipo de Reinversi&oacute;n: </label>
										</td>									
									</tr>
									<tr>
										<td>
											<label>Plazo: </label>
										</td>
										<td>
											<form:select id="plazoOriginal" name="plazoOriginal" path="plazoOriginal" tabindex="11">
												<option value="">SELECCIONAR</option>
											</form:select>
										</td>	
										<td>
											<label>Tasa ISR: </label>
										</td>
										<td>
											<input type="text" name="tasaISR" id="tasaISR" readonly="true"  disabled="true" value="" size="12"  esTasa="true"  esMoneda="true"  style="text-align: right;"/><label>%</label>
										</td>
										<td>&nbsp;&nbsp;</td>
										<td>
											<label>ISR a Retener: </label>
										</td>
										<td>
											<input  type="text"  name="interesRetener" id="interesRetener" path="interesRetener"  readonly="true"   disabled="true" size="18"  esMoneda="true" style="text-align: right;"/>
										</td>
										<td colspan="2">
											<form:input type="radio" name="reinvertir" id="reinvertirVenSi" value="S" path="reinversion" tabindex="12" /><label>Reinvertir al Vencimiento</label>
										</td>
									</tr>
									<tr>
										<td>
											<label>
												D&iacute;as a Pagar de Inter&eacute;s:
											</label>
										</td>
										<td>
											<form:input type="text" name="plazo" id="plazo" path="plazo"  size="18" readOnly="true" disabled="disabled" style="text-align: right;" />
										</td>
										<td>
											<label>Tasa Neta: </label>
										</td>
										<td>
											<input type="text" name="tasaNeta" id="tasaNeta" size="12" readonly="true"  disabled="true" esTasa="true"  style="text-align: right;"/><label>%</label>
										</td>
										<td>&nbsp;&nbsp;</td>
										<td>
											<label>Inter&eacute;s Recibir: </label>
										</td>
										<td>
											<input type="text"   name="interesRecibir" id="interesRecibir" readonly="true"  disabled="true" size="18"  esMoneda="true"  style="text-align: right;"/>
										</td>
										<td colspan="2">
											<form:input type="radio" name="reinvertir" id="reinvertirVenNo" value="N" path="reinversion" tabindex="13"/><label>No Reinvertir</label>
										</td>									
									</tr>
									<tr>
										<td nowrap="nowrap">
											<label>Fecha de Inicio: </label>
										</td>
										<td>
											<form:input type="text" name="fechaInicio" id="fechaInicio"	path="fechaInicio" size="18"  autocomplete="off" tabIndex = "14" readonly="true"  disabled="true"/>													
										</td>
										<td class="label" nowrap="nowrap">
											<label for="lbconsultaGAT">GAT Nominal: </label>
										</td>
										<td >
											<input type="text" name="valorGat" id="valorGat" size="12" readonly="true"  disabled="true" style="text-align: right;"/><label for="lbconsultaGAT">%</label>
										</td>
										<td class="separador"/>																	
										<td class="label">
											<label for="valorGatReal">GAT Real: </label>
										</td>
										<td nowrap="nowrap">
											<input type="text" name="valorGatReal" id="valorGatReal"  size="18" readonly="true"  disabled="true" style="text-align: right;"/><label for="valorGatReal">%</label>
										</td>		
										<td colspan="2">
											<form:select id="tipoReinversion" name="tipoReinversion" path="reinvertir"/>
										</td>
									</tr>
									<tr id='trVariable'>
										<td nowrap="nowrap">
											<label>Fecha de Vencimiento: </label>
										</td>
										<td nowrap="nowrap">
											<form:input type="text" name="fechaVencimiento" id="fechaVencimiento" path="fechaVencimiento" size="18"  autocomplete="off"  tabIndex = "15" readonly="true" disabled="disabled"/>
										</td>			
										<td id="tdlblCalculoInteres">
											<label id="lblCalculoInteres">C&aacute;lculo Inter&eacute;s:</label>
										</td>
										<td id="tdcalculoInteres">
											<input id="desCalculoInteres" type="text" name="desCalculoInteres" size="40" readonly="true"  disabled="true"/>
										</td>
										<td id="tdlblTasaBaseID" nowrap="nowrap">
											<label id="lblTasaBaseID">Tasa Base:</label>
										</td>
										<td id="tdDesTasaBaseID">
											<input id="destasaBaseID" name="destasaBaseID" size="12" readonly="true"  disabled="true"/>
										</td>
										<td>&nbsp;&nbsp;</td>																		
									</tr>
									<tr id='trVariable1'>
										<td id='tdlblSobreTasa'>
											<label id="lblSobreTasa">Sobre Tasa: </label>
										</td>
										<td>
											<form:input type="text" name="sobreTasa" id="sobreTasa" path="sobreTasa" size="12" readonly="true" esTasa="true"  style="text-align: right;"/>
										</td>
										<td >
											<label id="lblPisoTasa">Piso Tasa: </label>
										</td>
										<td>
											<form:input type="text" name="pisoTasa" id="pisoTasa" path="pisoTasa" size="12" readonly="true" esTasa="true"  style="text-align: right;"/>
										</td>
										<td></td>
										<td >
											<label id="lblTehoTasa">Techo Tasa: </label>
										</td>
										<td>
											<form:input type="text" name="techoTasa" id="techoTasa" path="techoTasa" size="12" readonly="true" esTasa="true"  style="text-align: right;"/>
										</td>
									</tr>
									<tr>
										<td colspan="7">&nbsp;</td>
										<td align="right" nowrap="nowrap">
											<label>Total a Recibir: </label>
										</td>
										<td>
											<input type="text" name="granTotal" id="granTotal" readonly="true"  esMoneda="true"	size="25"   style="text-align: right;"/>
										</td>
									</tr>
									<tr>
										<td colspan="8">&nbsp;</td>	
										<td align="right">							
											<input type="button" id="simular" name="simular" class="submit" value="Simular Calendario" tabindex="16"/>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td id="tdCajaRetiro" colspan="5" style="display:none">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend>Lugar de Retiro al Vencimiento: </legend>
								<table border="0" width="100%">
								<tr>
									<td class="label">
										<label for="cajaRetiro">Caja: </label>
									</td>
									<td nowrap="nowrap">
							 			<form:input id="cajaRetiro" name="cajaRetiro" path="cajaRetiro" size="4" tabindex="17" maxlength="11" />
										<input type="text" id="nombreCaja" name="nombreCaja" size="47" readOnly="true" />
									</td>
								</tr>
								</table>
							</fieldset>
						</td>
					</tr>
				</table>
				<br>
				<div id="contenedorSim">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend >Calendario de Pagos: </legend>
						<br>
						<div id="contenedorSimulador" style="overflow-y: scroll; width: 1100px; height: 400px;display: none;"></div>
					</fieldset>
				</div>
				<table border="0" width="100%">
					<tr>
						<td colspan="4"  align="right">
							<input type="hidden" id="estatusCede" name="estatusCede" value = "A"/>
							<input type="submit" id="agrega" name="agrega" class="submit" tabIndex = "18" value="Agregar" disabled="disabled" />	
							<input type="submit" id="modificar" name="modificar" class="submit" tabIndex = "19" value="Modificar" disabled="disabled" />						
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
							<input type="hidden" id="tasaFV" name="tasaFV"/>	
							<input type="hidden" id="calculoInteres" name="calculoInteres"/>
							<input type="hidden" id="tasaBaseID" name="tasaBaseID"/>
							<input type="hidden" id="valorTasaBaseID" name="valorTasaBaseID"/>	
							<input type="hidden" id="relaciones" name="relaciones"/>	
							<input type="hidden" id="segmentacion" name="segmentacion"/>	
							<input type="hidden" id="productoSAFI" name="productoSAFI" />
							<input type="hidden" id="tipoPersona" name="tipoPersona" />
						</td>
					</tr>	
				</table>		
			</fieldset>		
		</form:form>
    <br>
</fieldset> 
</div>


<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/></div>
</div>
<div id="mensaje" style="display: none;"/></div>
	
</body>
</html>

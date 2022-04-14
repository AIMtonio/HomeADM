<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head> 
		<script type="text/javascript" src="dwr/interface/cedesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposCedesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/operacionesFechasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tasasCedesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/plazosPorProductosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="js/date.js"></script>
		<script type="text/javascript" src="js/soporte/mascara.js"></script>
		<script type="text/javascript" src="js/general.js"></script>		
		<script type="text/javascript" src="js/cedes/reinvierteCede.js"></script>
		<title>
			Reinversi&oacute;n Manual CEDES
		</title>
	</head>	
	<body>
		<div id="contenedorForma">
				<fieldset class="ui-widget ui-widget-content ui-corner-all" >
					<legend class="ui-widget ui-widget-header ui-corner-all">Reinversi&oacute;n Manual CEDE</legend>					
					<form:form id="formaGenerica" name="formaGenerica" method="POST" action = "/microfin/reinversionCEDE.htm" commandName="cedesBean" >
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend >Datos Generales</legend>
							<table border="0" width="100%">
								<tr>
									<td class="label">
										<label>CEDE:</label>
									</td>
									<td>
										<input type="text" name="cedeID" id="cedeID" size="11" tabIndex = "1" autocomplete="off"/>
										<input type="hidden" id="estatus" name="estatus"  size="5" readonly="true" />					  
									</td>
								</tr>
								<tr>
									<td class="label">
										<label><s:message code="safilocale.cliente"/>: </label>
									</td>
						
									<td>
										<form:input type="text" name="clienteID" id="clienteID" size="11" autocomplete="off" path="clienteID" readonly="true"/>
										<input type="text" name="nombreCompleto" id="nombreCompleto" size="50" readonly="true"  />
										<input type="hidden" id="socioCliente" name="socioCliente" value="<s:message code="safilocale.cliente"/>" />		  
									</td>						
								</tr>
								<tr>
									<td class="label" style=" vertical-align: text-top;">
										<label>Direcci&oacute;n:</label>
									</td>
									<td>
										<textarea rows="3" cols="75" name="direccion" id="direccion" readonly="true"></textarea>
									</td>
									<td class="label" style=" vertical-align: text-top;">
										<label>Tel&eacute;fono:</label>
									</td>
									<td class="label" style=" vertical-align: text-top;">
										<input type="text" name="telefono" id="telefono" size="15" readonly="true" />
									</td>
								</tr>
								<tr>
									<table border="0" width="100%">
										<tr>
											<td width="10%">
												<label>Cuenta Cobro:</label>		
											</td>
											<td width="20%">
												<input id="cuentaAhoID" name="cuentaAhoID" size="13" autocomplete="off" readonly="true"/>												
											</td>
											<td width="10%">
												<label>Saldo:</label>		
											</td width ="15%">
											<td>
												<input type="text" id="totalCuenta" name="totalCuenta" style="text-align: right;" size="15"  readonly="true"  esMoneda="true" />
												<input type="hidden" name="monedaID" id="monedaID" />
												<label id="tipoMoneda"></label>		
											</td>
										</tr>
										<tr>
											<td>
												<label>Tipo de CEDE:</label>
											</td>
											<td nowrap="nowrap">
												<input id="tipoCedeID" name="tipoCedeID" size="5" autocomplete="off"  readonly="true"/>
												<input type="text" id="descripcion" name="descripcion" size="35" readonly="true" />
												<input type="hidden" id="diaInhabil" name="diaInhabil"  size="5" readonly="true" />	
												<input type="hidden" id="esDiaHabil" name="esDiaHabil"  size="5" readonly="true" />	
												<input type="hidden" id="pagoIntCal" name="pagoIntCal"  size="5" readonly="true" />
												<label id="tipoMonedaCede"></label>		
											</td>
											<td>
												<label>Tipo de Pago:</label>
											</td>
											<td>
												<select id="tipoPagoInt" name="tipoPagoInt" tabindex="2">
													<option value="">SELECCIONAR</option>
												</select>
											</td>
										</tr>
										<tr>
											<td >
												<label>Tipo de Reinversi&oacute;n:</label>
											</td>
											<td>
												<table border="0" >
													<tr>
														<td nowrap="nowrap">
															<form:input type="radio" name="reinvertir" id="reinvertirVenSi" path="reinversion" value="S"  tabindex="3"/>
															<label for="reinvertirVenSi">Reinvertir al vencimiento</label><br>
															<form:input type="radio" name="reinvertir" id="reinvertirVenNo" path="reinversion" value="N"  tabindex="3"/>
															<label for="reinvertirVenNo">No reinvertir</label>
														</td>
													</tr>
												</table>
											</td>
											<td nowrap="nowrap" id="lblTipoReinversion">
												<label>Tipo de<br> Reinversi&oacute;n Automatica:</label>
											</td>
											<td id="tdTipoReinversion">
												<form:select id="tipoReinversion" name="tipoReinversion" path="reinvertir" tabIndex = "4" style="display: none;">
													
												</form:select>
											</td>
										</tr>
										<tr>
											<td class="label">
												<label id="lbldiasPeriodo" for="diasPeriodo">No. D&iacute;as Periodo:</label>
											</td>
											<td><form:select id="diasPeriodo" name="diasPeriodo" path="diasPeriodo" tabindex="5" >
													<form:option value="">SELECCIONAR</form:option>
												</form:select>
											</td>
										</tr>
									</table>
									
								</tr>
								<tr>
									<td colspan="5">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend >Condiciones Nueva CEDE:</legend>
											<table border="0">
												<tr>
													<td class="label">
														<label>Monto:</label>
													</td>
													<td>
														<input type="text" name="monto" id="monto" size="18" style="text-align: right;" autocomplete="off" esMoneda="true" maxlength="18" tabIndex = "6"/>
														<label id="tipoMonedaInv"></label>
													</td>
													<td class="label">
														<label>Tasa Bruta:</label>
													</td>
													<td nowrap="nowrap">
														<input type="text" name="tasa" id="tasa" size="12" readonly="true" 			style="text-align: right;" esTasa="true"/><label>%</label>
													</td>
													<td class="label" nowrap="nowrap">
														<label>Inter&eacute;s Generado:</label>
													</td>
													<td>
														<input name="interesGenerado" id="interesGenerado" readonly="true" style="text-align: right;" esMoneda="true" size="18"/>
													</td>
												</tr>
												<tr>
													<td class="label">
														<label>Plazo: </label>
													</td>
													<td>
														<form:select id="plazoOriginal" name="plazoOriginal" path="plazoOriginal" tabindex="7">
															<option value="">SELECCIONAR</option>
														</form:select>
													</td>																	
													<td class="label">
														<label>Tasa ISR:</label>
													</td>
													<td nowrap="nowrap">
														<input type="text" name="tasaISR" id="tasaISR" readonly="true" value="" size="12" esTasa="true" style="text-align: right;" /><label>%</label></td>
													<td class="label">
														<label>ISR a Retener: </label>
													</td>
													<td>
														<input name="interesRetener" id="interesRetener" readonly="true" esMoneda="true" size="18" style="text-align: right;"/>
													</td>													
												</tr>
												<tr>
													<td class="label">
														<label>
															D&iacute;as a Pagar de Inter&eacute;s:
														</label>
													</td>
													<td>
														<form:input type="text" name="plazo" id="plazo" path="plazo"  size="18" readonly="true" style="text-align: right;" />
													</td>												
													<td class="label">
														<label>Tasa Neta:</label>
													</td>
													<td nowrap="nowrap">
														<input type="text" name="tasaNeta" id="tasaNeta" size="12" readonly="true" style="text-align: right;" esTasa="true"  /><label>%</label>
													</td>
													<td class="label">
														<label>Inter&eacute;s Recibir:</label>
													</td>
													<td>
														<input name="interesRecibir" id="interesRecibir" readonly="true" esMoneda="true" size="18" style="text-align: right;"/>
													</td>
												</tr>
												<tr>
													<td class="label">
														<label>Fecha de<br>Inicio:</label>
													</td>
													<td>
														<input type="text" name="fechaInicio" id="fechaInicio" size="18" autocomplete="off" readonly="true"/>
													</td>																	
													<td class="label">
														<label for="lbconsultaGAT">GAT Nominal: </label>
													</td>
													<td >
														<input type="text" name="valorGat" id="valorGat" size="12" readonly="true" style="text-align: right;"/><label for="lbconsultaGAT" >%</label>
													</td>
													<td class="label">
														<label for="valorGatReal">GAT Real: </label>
													</td>
													<td nowrap="nowrap" >
														<input type="text" name="valorGatReal" id="valorGatReal" size="18" readonly="true" style="text-align: right;"/><label for="valorGatReal" >%</label>
													</td>
												</tr>
												<tr id='trVariable'>
													<td class="label">
														<label>Fecha de<br>Vencimiento:</label>
													</td>
													<td>
														<input type="text" name="fechaVencimiento" id="fechaVencimiento" size="18" Calendario="true" readonly="true" autocomplete="off"/>
													</td>
													<td id="tdlblCalculoInteres" nowrap="nowrap">
														<label id="lblCalculoInteres">
															Calculo Inter&eacute;s:
														</label>
													</td>
													<td id="tdcalculoInteres">
														<input id="desCalculoInteres" type="text" name="desCalculoInteres" size="33" readonly="true"/>
													</td>
													<td id="tdlblTasaBaseID" nowrap="nowrap">
														<label id="lblTasaBaseID">
															Tasa Base:
														</label>
													</td>
													<td id="tdDesTasaBase">
														<input id="destasaBaseID" name="destasaBaseID" size="12" readonly="true"/>
													</td>
												</tr>
												<tr id='trVariable1'>
													<td>
														<label id="lblSobreTasa">
															Sobre Tasa:
														</label>
													</td>
													<td>
														<input type="text" name="sobreTasa" id="sobreTasa" size="12" readonly="true" 
															 esTasa="true"  style="text-align: right;"/>
													</td>
													<td >
														<label id="lblPisoTasa">
															Piso Tasa:
														</label>
													</td>
													<td>
														<input type="text" name="pisoTasa" id="pisoTasa" size="12" readonly="true" 
														 esTasa="true"  style="text-align: right;"/>
													</td>
													<td>
														<label id="lblTehoTasa">
															Techo Tasa:
														</label>
													</td>
													<td>
														<input type="text" name="techoTasa" id="techoTasa" size="12" readonly="true" 
														 esTasa="true"  style="text-align: right;"/>
													</td>
												</tr>
												<tr>
													<td colspan="7">
													</td>
													<td align="right" nowrap="nowrap">
														<label>Total a Recibir:</label>
													</td>
													<td>
														<input type="text" name="granTotal" id="granTotal" readonly="true" esMoneda="true" size="18"
														style="text-align: right;"/>
													</td>												
												</tr>
												<tr>
													<td colspan="8">
														&nbsp;
													</td>	
													<td align="right">							
														<input type="button" id="simular" name="simular" class="submit" value="Simular Calendario" tabindex="8"/>
													</td>
												</tr>	
											</table>
										</fieldset>
										
										
								<div id="contenedorSim">
								  	<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend >Calendario de Pagos: </legend>
									<br>
									<div id="contenedorSimulador" style="overflow: scroll; width: 1000px; height: 300px;display: none;"></div>
						  		</fieldset>
								</div>
										<table border="0" cellpadding="0" cellspacing="0" width="100%">
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
												 			<form:input id="cajaRetiro" name="cajaRetiro" path="cajaRetiro" size="4" tabindex="14" maxlength="11" />
															<input type="text" id="nombreCaja" name="nombreCaja" size="47" readOnly="true" />
														</td>
													</tr>
													</table>
												</fieldset>
											</td>
										</tr>
											<tr>
												<td colspan="4">
													<table align="right" boder='0'>
														<tr>
															<td align="right">
																<input type="submit" id="reinvertirBoton" name="reinvertirBoton" class="submit" value="Reinvertir" tabIndex="9" />
																<input type="submit" id="cancelar" name="cancelar" class="submit" value="No Reinvertir(Abonar CEDE)" tabIndex="10" />
																<a id="enlace" href="" target="_blank">
										                     		<button type="button" class="submit" id="imprime" name="imprime" tabIndex="11" >
										                              Imp.Pagare
										                      		</button>
																</a>												  
																<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>	
																<input type="hidden" id="calculoInteres" name="calculoInteres"/>
																<input type="hidden" id="tasaBaseID" name="tasaBaseID"/>
																<input type="hidden" id="interesRecibirOrginal" name="interesRecibirOrginal"/>
																<input type="hidden" id="tasaFV" name="tasaFV"/>
																<input type="hidden" id="valorTasaBaseID" name="valorTasaBaseID"/>	

															</td>
														</tr>
													</table>
												</td>
											</tr>	
										</table>	
									</td>
								</tr>
								
							</table>								
						</fieldset>	
					</form:form>				
				</fieldset>		
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
		</div>
		<div id="mensaje" style="display: none;"/>
	</body>
</html>
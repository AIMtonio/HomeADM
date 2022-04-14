<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="js/forma.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasTransferServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/utileriaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSpeiServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasFirmaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cajasVentanillaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/impresionTicketResumenServicio.js"></script>
		<script type="text/javascript" src="js/soporte/ServerHuella.js"></script>
		<script type="text/javascript" src="js/ventanilla/impTicketVentSofiExpress.js"></script>
		<script type="text/javascript" src="js/ventanilla/speiEnvio.js"></script>
		<script type="text/javascript" src="js/ventanilla/impresionResumenTicket.js"></script>
		<script>
			if(parametroBean.tipoImpresoraTicket == 'A'){
				importarScriptSAFI('js/soporte/impresoraTicket.js');
			}
			if(parametroBean.tipoImpresoraTicket == 'S'){
				if(applet == null){
					importarScriptSAFI('js/WebSocketImpresion.js');
					importarScriptSAFI('js/soporte/impresoraTicketSck.js');
				}
			}
		</script>

	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="speiEnivio">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Envío SPEI</legend>
					<table width="100%">
						<%-----------------------------------------------	TRANSFERENCIAS SPEI----------------------------------------------%>
						<tr>
							<td colspan="2" >
								<div id="transferenciaSPEI">
									<table>
										<tr>
											<td>
												<input id="tipoPago" name="tipoPago" iniForma="false" size="13" tabindex="1" type="hidden"  />
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lblCuentaAhoID">Cuenta:</label>
											</td>
											<td>
												<input id="cuentaAhoID" name="cuentaAhoID" iniForma="false" size="13" tabindex="3" type="text" />
												<input id="tipoCuentaOrd" name="tipoCuentaOrd" iniForma="false" size="13" tabindex="4" type="hidden" />
												<input id="cuentaOrd" name="cuentaOrd" iniForma="false" size="13" tabindex="5" type="hidden" />
											</td>
											<td class="separador" colspan="2"></td>
											<td class="label" nowrap="nowrap">
												<label for="lbltipoCtaSPEI">Tipo Cuenta: </label>
											</td>
											<td>
												<input id="destipoCtaSPEI" name="destipoCtaSPEI" size="35" tabindex="6" type="text" readOnly="true" iniForma="false" disabled="true" />
											</td>
										</tr>
										<tr>
											<td class="label" >
												<label for="lblCliente">Cliente:</label>
											</td>
											<td>
												<input id="clienteID" name="clienteID" readOnly="true" iniForma="false" size="13" tabindex="7" type="text"  disabled="true"/>
												<input id="nombreOrd" name="nombreOrd" size="45" tabindex="8" type="text" readOnly="true" iniForma="false" disabled="true" />
												<input type="hidden" id="tipoPersonaSPEI" name="tipoPersonaSPEI" tabindex="9" readOnly="true" iniForma="false" disabled="true" />
												<input id="ordRFC" name="ordRFC" tabindex="10" type="hidden" readOnly="true" iniForma="false" disabled="true" />
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lblMonedaSPEI">Moneda:</label>
											</td>
											<td>
												<input id="monedaID" name="monedaID" readOnly="true" iniForma="false" size="13" tabindex="11" type="text" disabled="true"/>
												<input id="desmoneda" name="desmoneda" size="25" tabindex="12" type="text" readOnly="true" iniForma="false" disabled="true" />
											</td>
											<td class="separador" colspan="2"></td>
											<td class="label" nowrap="nowrap">
												<label for="lblSaldoDisp">Saldo Disponible: </label>
											</td>
											<td>
												<input id="saldoDisp" name="saldoDisp" size="25" tabindex="13" type="text" readOnly="true" iniForma="false" disabled="true"  esMoneda="true" style='text-align:right;'/>
											</td>
										</tr>
									</table>
									<br>
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend>Beneficiario</legend>
										<div>
											<table>
												<tr>
													<td class="label">
														<label for="lblTipoCtaBenSPEI">Cuenta Destino:</label>
													</td>
													<td>
														<input id="tipoCtaBenSPEI" name="tipoCtaBenSPEI" size="10" tabindex="14" type="text" iniForma="false"  />
														<input id="tipoCuentaBen" name="tipoCuentaBen" size="10" tabindex="15" type="hidden" iniForma="false"  />
													</td>
													<td class="separador" colspan="1"></td>
													<td class="label" nowrap="nowrap">
														<label for="lblCtaBenSPEI">Cuenta: </label>
													</td>
													<td>
														<input id="cuentaBeneficiario" name="cuentaBeneficiario" size="25"  type="text" iniForma="false"  readOnly="true"/>
													</td>
													<td>
														<input type="hidden" id="tipoCuenta" name="tipoCuenta" size="25" tabindex="18" iniForma="false"  />
													</td>
												</tr>
												<tr>
													<td class="label" nowrap="nowrap">
														<label for="lblBancoSPEI">Banco: </label>
													</td>
													<td>
														<input id="instiReceptora" name="instiReceptora"size="10" type="text" iniForma="false" readOnly="true"/>
														<input id="desbancoSPEI" name="desbancoSPEI" size="38" tabindex="20" type="text" readOnly="true" iniForma="false" disabled="true" />
													</td>
												</tr>
												<tr>
													<td class="label" nowrap="nowrap">
														<label for="lblNombreBenSPEI">Nombre: </label>
													</td>
													<td>
														<input id="nombreBeneficiario" name="nombreBeneficiario" size="50" type="text" iniForma="false" onblur="ponerMayusculas(this)" readOnly="true"/>
													</td>
													<td class="separador" colspan="1">
													<td class="label" nowrap="nowrap">
														<label for="lblRFCbenSPEI">RFC ó CURP: </label>
													</td>
													<td>
														<input id="beneficiarioRFC" name="beneficiarioRFC" size="25" type="text" iniForma="false" onblur="ponerMayusculas(this)" readOnly="true"/>
													</td>
												</tr>
											</table>
										</div>
									</fieldset>
									<br>
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend>Transferencia</legend>
										<div>
											<table>
												<tr>
													<td class="label" nowrap="nowrap">
														<label for="lblMontoTransSPEI">Monto a Transferir: </label>
													</td>
													<td>
														<input id="montoTransferir" name="montoTransferir" size="12" tabindex="26" type="text" iniForma="false"  esMoneda="true" style='text-align:right;'/>
													</td>
													<td class="separador" colspan="1"></td>
													<td class="label" nowrap="nowrap">
														<label for="lblIVAPagarSPEI">IVA a Pagar: </label>
													</td>
													<td>
														<input id="pagarIVA" name="pagarIVA" size="12"  type="text"  tabindex="27" iniForma="false"   esMoneda="true" style='text-align:right;'/>
													</td>
												</tr>
												<tr>
													<td class="label" nowrap="nowrap">
														<label for="lblComisionSPEI">Comisi&oacute;n por Transferencia: </label>
													</td>
													<td>
														<input id="comisionTrans" name="comisionTrans" readonly="true" size="12"  type="text" iniForma="false"   esMoneda="true" style='text-align:right;'/>
													</td>
													<td class="separador" colspan="1">
													<td class="label" nowrap="nowrap">
														<label for="lblIVAComisionSPEI">IVA de Comisi&oacute;n: </label>
													</td>
													<td>
														<input id="comisionIVA" name="comisionIVA" size="12"  type="text" readonly="true" iniForma="false"  esMoneda="true" style='text-align:right;'/>
													</td>
												</tr>
												<tr>
													<td class="label" nowrap="nowrap">
														<label for="lblTotCargoCtaSPEI">Total Cargo a Cuenta: </label>
													</td>
													<td>
														<input id="totalCargoCuenta" name="totalCargoCuenta" readonly="true" size="12" type="text" iniForma="false"  esMoneda="true" style='text-align:right;'/>
													</td>
													<td>
														<input id="totalCargoLetras" name="totalCargoLetras" readonly="true" size="12" type="hidden" iniForma="false"  esMoneda="true"/>
													</td>
												</tr>
												<tr>
													<td class="label" nowrap="nowrap">
														<label for="lblReferenciaSPEI">Concepto de Pago: </label>
													</td>
													<td>
														<textarea id="conceptoPago" name="conceptoPago" maxlength="40" iniForma="false" cols="30" rows="2" tabindex="28"  onblur="ponerMayusculas(this); limpiarCajaTexto(this.id);" onkeypress="return validadorCaracteres(event);">
														</textarea>
													</td>
												</tr>
												<tr>
													<td class="label" nowrap="nowrap">
														<label for="lblReferenciaNum">Referencia Num&eacute;rica: </label>
													</td>
													<td>
														<input id="referenciaNum" name="referenciaNum" size="15" tabindex="29" type="text" iniForma="false" maxlength="7" onkeypress="return validadorNumeros(event);"/>
													</td>
												</tr>
											</table>
										</div>
									</fieldset>
								</div>
							</td>
						</tr>
						<%-----------------------------------------------	TERMINA	----------------------------------------------%>
					</table>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="separador" align="left">
								<span id="statusSrvHuella"></span>
							</td>
							<td colspan="6">
								<table align="right" boder='0'>
									<tr>
										<td align="right">
											<input type="button" class="submit" id="imprimirCarta" value="Carta de Autorización" tabindex="30"/>
											<input type="submit" id="graba"	name="graba" class="submit" value="Grabar Transacción" tabindex="31"/>
											<a id="enlaceResumen" target="_blank">
												<button  type="button" id="imprimirResumen" name="imprimirResumen" class="submit" value="Imp. Resumen">Imp. Resumen</button>
											</a>
											<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" iniForma="false" />
											<input type="hidden" id="usuarioEnvio" name="usuarioEnvio" size="10" />
											<input type="hidden" id="numTransaccion" name="numTransaccion" size="10" />
											<input type="hidden" id="claveRastreo" name="claveRastreo" size="10" />
											<input type="hidden" id="tipoOperacion" name="tipoOperacion" value="6" />
											<input type="hidden" id="socioClienteAlert" name="socioClienteAlert" value="<s:message code="safilocale.cliente"/>" />
											<input type="hidden" id="numeroTransaccion" name="numeroTransaccion" iniForma="false" />
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</fieldset>
			</form:form>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
		<div id="elementoLista"/></div>
	</body>
	<div id="mensaje" style="display: none;"/>
</html>
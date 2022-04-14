<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/reimpresionTicketServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasTransferServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="js/cliente/transferenciaEntreCuentasVista.js"></script>
		<script type="text/javascript" src="js/soporte/ServerHuella.js"></script>
		<script type="text/javascript" src="js/ventanilla/huellaDigitalVentanilla.js"></script>
		<script type="text/javascript" src="js/ventanilla/impresionReTicketGeneral.js"></script>
		<script type="text/javascript" src="js/ventanilla/impresionTickets.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<input type="hidden" id="socioClienteAlert" name="socioClienteAlert" value="<s:message code="safilocale.cliente"/>" />
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="transferenciaEntreCuentas">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Transferencia</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="lblCuentaAhoIDT">Cuenta:</label>
							</td>
							<td>
								<input id="cuentaAhoID" name="cuentaAhoID" iniForma="false" size="11" tabindex="1" type="text" />
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="lblCuentaAhoIDT">Tipo Cuenta: </label>
							</td>
							<td>
								<input id="tipoCuentaID" name="tipoCuentaID" size="25" tabindex="2" type="text" readOnly="true" iniForma="false" disabled="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblNombreClienteT"><s:message code="safilocale.cliente"/>: </label>
							</td>
							<td colspan="4">
								<input id="clienteID" name="clienteID" size="11" type="text" readOnly="true" iniForma="false" disabled="true" tabindex="3" />
								<input id="nombreClienteT" name="nombreClienteT" size="50" maxlength="200" ntype="text" readOnly="true" iniForma="false" disabled="true" tabindex="4" />
								</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblMoneda">Moneda:</label>
							</td>
							<td>
								<input id="monedaID" name="monedaID" size="4" type="text" readOnly="true" disabled="true" tabindex="4" />
								<input id="descripcionMoneda" name="descripcionMoneda" size="32" type="text" iniForma="false" readOnly="true" disabled="true" tabindex="5" />
							</td>
							<td class="separador"></td>
							<td id="tdsaldoDisponT" class="label">
								<label for="lblSaldo">Saldo	Disponible: </label>
							</td>
							<td>
								<input id="saldoDisponble" name="saldoDisponble" size="25" type="text" readOnly="true" disabled="true" tabindex="6" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblMontoCargar">Monto a Cargar : </label>
							</td>
							<td>
								<input id="monto" name="monto" size="12" type="text" esMoneda="true" style="text-align: right" iniForma="false" tabindex="7" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblReferenciaT">Referencia: </label>
							</td>
							<td>
								<textarea id="referencia" name="referencia" iniForma="false" cols="30" rows="2" tabindex="8" onblur="ponerMayusculas(this); limpiarCajaTexto(this.id);" maxlength="50"></textarea>
							</td>
							<td class="separador"></td>
							<td class="separador"></td>
						</tr>
						<tr>
							<td>
								<input type="hidden" id="etiquetaCuentaCargo" name="etiquetaCuentaCargo"  />
								<input type="hidden" id="etiquetaCuentaAbono" name="etiquetaCuentaAbono"  />
								<input type="hidden" id="numClienteTCtaRecep" name="numClienteTCtaRecep"  />
								<input type="hidden" id="sucursalID" 		  name="sucursalID" 		iniForma="false" />
								<input type="hidden" id="fechaSistema"		  name="fechaSistema" 		iniForma="false" />
								<input type="hidden" id="numeroCaja"		  name="numeroCaja" 		iniForma="false" />
								<input type="hidden" id="tipoTransaccion"	  name="tipoTransaccion" 	iniForma="false" />
								<input type="hidden" id="tipoOperacion"		  name="tipoOperacion" 		iniForma="false" />
								<input type="hidden" id="alertSocio" 		  name="alertSocio" value="<s:message code="safilocale.cliente"/>"/>
							</td>
						</tr>
					</table>
					<br>

					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Cuenta Abono</legend>
						<br>
						<div>
							<table>
								<tr>
									<td class="label">
										<label for="lblCuentaAhoIDTC">Cuenta: </label>
									</td>
									<td >
										<select id="cuentaAhoIDRecepcion" name="cuentaAhoIDRecepcion" path="cuentaAhoIDRecepcion" tabindex="9" >
											<option value="">SELECCIONAR</option>
										</select>
								   	</td>
								</tr>
							</table>
						</div>
					</fieldset>
					<br>
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="graba" name="graba" class="submit" value="Grabar"  tabindex="10"/>
							</td>
						</tr>
					</table>
				</fieldset>
			</form:form>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
		<div id="cajaListaCte" style="display: none;overflow-y: scroll;height=150px;">
		<div id="elementoListaCte"></div>
		</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>
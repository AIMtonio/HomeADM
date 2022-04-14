<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposLineasAgroServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/consolidacionesServicio.js"></script>
		<script type="text/javascript" src="js/fira/condicionesLineasAgro.js"></script>
		<script type="text/javascript" src="js/utileria.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="lineasCreditoBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="ui-widget ui-widget-header ui-corner-all">Condiciones de L&iacute;neas de Cr&eacute;dito Agro</legend>
						<table width="100%">
							<tr>
								<td class="label">
									<label for="lbllineaCreditoID">L&iacute;nea Cr&eacute;dito: </label>
								</td>
								<td>
									<form:input id="lineaCreditoID" name="lineaCreditoID" path="lineaCreditoID" size="15" tabindex="1" numMax ="12" />
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="lblClienteID"><s:message code="safilocale.cliente" />: </label>
								</td>
								<td>
									<form:input id="clienteID" name="clienteID" path="clienteID" size="10" tabindex="2" numMax ="50" />
									<input type="text" id="nombreCte" name="nombreCte" size="50"  tabindex="3" readOnly= "true" disabled = "true" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="lblCuentaAhoID">Cuenta: </label>
								</td>
								<td>
									<form:input id="cuentaID" name="cuentaID" path="cuentaID" size="15" tabindex="4" numMax ="50"/>
									<input id="desCuenta" name="desCuenta" size="40"  type="text" readOnly="true" tabindex="5" disabled = "true"/>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="lblMonedaID">Moneda: </label>
								</td>
								<td>
									<form:input id="monedaID" name="monedaID" path="monedaID" size="10" readOnly="true" disabled="true" tabindex="6"/>
									<input id="moneda" name="moneda" size="50"  type="text" readOnly="true" tabindex="7" disabled = "true"/>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="lblTipoLineaCreditoAgroID">Tipo de L&iacute;nea: </label>
								</td>
								<td>
									<form:select id="tipoLineaAgroID" name="tipoLineaAgroID" path="tipoLineaAgroID" tabindex="8">
										<form:option value="">SELECCIONAR</form:option>
									</form:select>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="lblsolicitado">Monto Solicitado:</label>
								</td>
								<td>
									<form:input id="solicitado" name="solicitado" path="solicitado" size="20" tabindex="9" esMoneda="true" style="text-align: right" onkeypress="return ingresaSoloNumeros(event,2,this.id);"/>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="lblfechaInicio">Fecha Inicio:</label>
								</td>
								<td>
									<form:input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="15" tabindex="10"/>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="lblfechaVencimiento">Fecha Vencimiento: </label>
								</td>
								<td>
									<form:input id="fechaVencimiento" name="fechaVencimiento" path="fechaVencimiento" size="15" tabindex="11"/>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="lblestatus">Estatus: </label>
								</td>
								<td>
									<form:input id="estatus" name="estatus" path="estatus" size="15" tabindex="12" readOnly="true" disabled = "true" />
								</td>
							</tr>
						</table>
						<br>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend class="ui-widget ui-widget-header ui-corner-all">Detalles</legend>
							<table>
								<tr>
									<td class="label">
										<label for="lblsaldoDisponible">Saldo Disponible:</label>
									</td>
									<td>
										<form:input id="saldoDisponible" name="saldoDisponible" path="saldoDisponible" size="20" tabindex="13" esMoneda="true" style="text-align: right" onkeypress="return ingresaSoloNumeros(event,2,this.id);"/>
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="lblsaldoDeudor">Saldo en Atraso:</label>
									</td>
									<td>
										<form:input id="saldoDeudor" name="saldoDeudor" path="saldoDeudor" size="20" tabindex="14" esMoneda="true" style="text-align: right" onkeypress="return ingresaSoloNumeros(event,2,this.id);"/>
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="lblpagado">Monto Pagado:</label>
									</td>
									<td>
										<form:input id="pagado" name="pagado" path="pagado" size="20" tabindex="15" esMoneda="true" style="text-align: right" onkeypress="return ingresaSoloNumeros(event,2,this.id);"/>
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="lblnumeroCreditos">No. Disposiciones:</label>
									</td>
									<td>
										<form:input id="numeroCreditos" name="numeroCreditos" path="numeroCreditos" size="20" tabindex="16" esMoneda="true" style="text-align: right" onkeypress="return ingresaSoloNumeros(event,2,this.id);"/>
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="lblultMontoDisposicion">Monto Ult. Disposici&oacute;n:</label>
									</td>
									<td>
										<form:input id="ultMontoDisposicion" name="ultMontoDisposicion" path="ultMontoDisposicion" size="20" tabindex="17" esMoneda="true" style="text-align: right" onkeypress="return ingresaSoloNumeros(event,2,this.id);"/>
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="lbldispuesto">Monto Dispuesto:</label>
									</td>
									<td>
										<form:input id="dispuesto" name="dispuesto" path="dispuesto" size="20" tabindex="18" esMoneda="true" style="text-align: right" onkeypress="return ingresaSoloNumeros(event,2,this.id);"/>
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="lblsaldoComAnual">Monto Comisiones Pagadas:</label>
									</td>
									<td>
										<form:input id="saldoComAnual" name="saldoComAnual" path="saldoComAnual" size="20" tabindex="19" esMoneda="true" style="text-align: right" onkeypress="return ingresaSoloNumeros(event,2,this.id);"/>
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="lblultFechaDisposicion">Fecha Ultimo Disposici&oacute;n:</label>
									</td>
									<td>
										<form:input id="ultFechaDisposicion" name="ultFechaDisposicion" path="ultFechaDisposicion" size="20" tabindex="20" style="text-align: right" />
									</td>
								</tr>
							</table>
						</fieldset>
						<br>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend class="ui-widget ui-widget-header ui-corner-all">Comisiones</legend>
							<table>
								<tr>
									<td class="label">
										<label for="lblManejaComAdmon">Comisi&oacute;n por Administraci&oacute;n: </label>
									</td>
									<td>
										<form:select id="manejaComAdmon" name="manejaComAdmon" path="manejaComAdmon" tabindex="21">
											<form:option value="">SELECCIONAR</form:option>
											<form:option value="S">SI</form:option>
											<form:option value="N">NO</form:option>
										</form:select>
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="lblForPagComAdmon">Tipo de Cobro: </label>
									</td>
									<td>
										<form:select id="forCobComAdmon" name="forCobComAdmon" path="forCobComAdmon" tabindex="22">
											<form:option value="">SELECCIONAR</form:option>
											<form:option value="D">DISPOSICI&Oacute;N</form:option>
											<form:option value="T">TOTAL EN PRIMERA DISPOSICI&Oacute;N</form:option>
										</form:select>
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="lblPorcentajeComAdmon">Porcentaje: </label>
									</td>
									<td>
										<form:input id="porcentajeComAdmon" name="porcentajeComAdmon" path="porcentajeComAdmon" size="15" tabindex="23" esMoneda="true" style="text-align: right" onkeypress="return ingresaSoloNumeros(event,2,this.id);"/>
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="lblManejaComGarantia">Comisi&oacute;n por Serv. de Garant&iacute;a: </label>
									</td>
									<td>
										<form:select id="manejaComGarantia" name="manejaComGarantia" path="manejaComGarantia" tabindex="24">
											<form:option value="">SELECCIONAR</form:option>
											<form:option value="S">SI</form:option>
											<form:option value="N">NO</form:option>
										</form:select>
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="lblForPagComGarantia">Tipo de Cobro: </label>
									</td>
									<td>
										<form:select id="forCobComGarantia" name="forCobComGarantia" path="forCobComGarantia" tabindex="25">
											<form:option value="">SELECCIONAR</form:option>
											<form:option value="C">CADA CUOTA</form:option>
										</form:select>
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="lblPorcentajeComGarantia">Porcentaje: </label>
									</td>
									<td>
										<form:input id="porcentajeComGarantia" name="porcentajeComGarantia" path="porcentajeComGarantia" size="15" tabindex="26" esMoneda="true" style="text-align: right" onkeypress="return ingresaSoloNumeros(event,2,this.id);"/>
									</td>
								</tr>
							</table>
						</fieldset>
						<br>
						<table>
							<tr>
								<td class="label">
									<label for="lblmontoUltimoIncremento">Incremento de la l&iacute;nea: </label>
								</td>
								<td>
									<form:input id="montoUltimoIncremento" name="montoUltimoIncremento" path="montoUltimoIncremento" size="15" tabindex="27" esMoneda="true" style="text-align: right" onkeypress="return ingresaSoloNumeros(event,2,this.id);"/>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="lblfechaNuevoVenci">Nueva Fecha de Vencimiento: </label>
								</td>
								<td>
									<form:input id="fechaNuevoVenci" name="fechaNuevoVenci" path="fechaNuevoVenci" size="15" tabindex="28"  esCalendario="true"/>
								</td>
							</tr>
						</table>
					</fieldset>
					<br>
					<table border="0" cellpadding="0" cellspacing="0"  width="100%">
						<tr>
							<td colspan="5">
								<table align="right">
									<tr>
										<td align="right">
											<input type="submit" id="reactiva" name="reactiva" class="submit" value="Reactivar" tabindex="29"/>
											<input type="submit" id="modifica" name="modifica" class="submit"  value="Modificar" tabindex="30"/>
											<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
											<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>
											<input type="hidden" id="montoMinimo" name="montoMinimo" />
											<input type="hidden" id="montoMaximo" name="montoMaximo"/>
											<input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>" />
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
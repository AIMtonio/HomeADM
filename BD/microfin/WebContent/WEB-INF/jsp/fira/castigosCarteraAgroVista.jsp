<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/amortizacionCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/creditosMovsServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/castigosCarteraAgroServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/amortizacionCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/estimacionPreventivaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/invGarantiaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/opcionesMenuRegServicio.js"></script>
		<script type="text/javascript" src="js/fira/castigosCarteraAgro.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="castigosCarteraAgro">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Castigo de Cartera</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="creditoID">Crédito: </label>
							</td>
							<td>
								<form:input id="creditoID" name="creditoID" path="creditoID" size="12" iniForma = 'false'  tabindex="1" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="producCreditoID">Producto Cr&eacute;dito: </label>
							</td>
							<td >
								<input id="producCreditoID" name="producCreditoID"  size="12" type="text" readOnly="true" />
								<input id="descripProducto" name="descripProducto" size="45" type="text" readOnly="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="clienteID"><s:message code="safilocale.cliente"/>: </label>
							</td>
							<td >
								<input id="clienteID" name="clienteID"  size="12"  type="text" readOnly="true" />
								<input id="nombreCliente" name="nombreCliente"  size="45" type="text" readOnly="true" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblestatus">Estatus:</label>
							</td>
							<td>
								<input id="estatus" name="estatus" size="12" type="text" readOnly="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="monto">Monto Solicitado: </label>
							</td>
							<td>
								<input id="monto" name="monto"  size="12"  type="text" readOnly="true"  style="text-align: right" esMoneda="true"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label  for="moneda">Moneda: </label>
							</td>
							<td>
								<input id="monedaID" name="monedaID"  size="12"  type="text" readOnly="true" />
								<input id="monedaDes" name="monedaDes" size="12"  type="text" readOnly="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblfechaInicio">Fecha Inicio: </label>
							</td>
							<td>
								<input id="fechaIni" name="fechaIni"  type="text" readOnly="true"  size="12" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblfechaVenc">Fecha Vencimiento: </label>
							</td>
							<td>
								<input id="fechaVenc" name="fechaVenc" size="12" type="text" readOnly="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lbltotalAdeudo">Total Adeudo: </label>
							</td>
							<td>
								<input id="totalAdeudo" name="totalAdeudo"   size="12" type="text" readOnly="true" style="text-align: right" esMoneda="true"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lbldiasAtraso">D&iacute;as de Atraso: </label>
							</td>
							<td>
								<input id="diasAtraso" name="diasAtraso" size="12" type="text" readOnly="true" style="text-align: right"/>
							</td>
						</tr>
					</table>
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Detalle del Adeudo </legend>
						<table>
							<tr>
								<td class="label">
									<label for="lblsaldoCapital">Saldo Capital: </label>
								</td>
								<td>
									<input id="saldoCap" name="saldoCap"   size="15" type="text" readOnly="true" style="text-align: right" esMoneda="true"/>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="lblsaldoInteres">Saldo de Inter&eacute;s: </label>
								</td>
								<td>
									<input id="saldoInt" name="saldoInt" size="15" type="text" readOnly="true" style="text-align: right" esMoneda="true"/>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="lblmoratorios">Moratorios: </label>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								</td>
								<td>
								 <input id="saldoMoratorios" name="saldoMoratorios" size="15" type="text" readOnly="true" style="text-align: right" esMoneda="true"/>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="SaldoComFaltaPa">Comisiones: </label>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								</td>
								<td>
									<input type="text" id="SaldoComFaltaPa" name="SaldoComFaltaPa" size="15"  readOnly="true" style="text-align: right" esMoneda="true"/>
								</td>
							</tr>
						</table>
					</fieldset>
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>&Uacute;ltima Estimaci&oacute;n Crediticia </legend>
						<table>
							<tr>
								<td class="label">
									<label for="lblfecha">Fecha: </label>
								</td>
								<td>
									<input id="fecha" name="fecha"   size="15" type="text" readOnly="true" />
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="lbltotalReserva">Total Reserva: </label>
								</td>
								<td>
									<input id="totalReserva" name="totalReserva" size="15" type="text" readOnly="true" style="text-align: right" esMoneda="true"/>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="lblreservaCap">Reserva Capital: </label>
								</td>
								<td>
									<input id="reservaCap" name="reservaCap" size="15" type="text" readOnly="true" style="text-align: right" esMoneda="true"/>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="lblreservaInt">Reserva Inter&eacute;s: </label>
								</td>
								<td>
									<input id="reservaInt" name="reservaInt" size="15" type="text" readOnly="true" style="text-align: right" esMoneda="true"/>
								</td>
							</tr>
						</table>
					</fieldset>
					<table>
						<tr>
							<td class="label">
								<label for="lblmotivoCast">Motivo del Castigo: </label>
							</td>
							<td>
								<form:select id="motivoCastigoID" name="motivoCastigoID" path="motivoCastigoID" tabindex="21">
									<form:option value="">Selecciona</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblTipoCobranza">Cobranza Realizada: </label>
							</td>
							<td>
								<form:select id="tipoCobranza" name="tipoCobranza" path="tipoCobranza" tabindex="22">
									<form:option value="">Selecciona</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblobserva">Observaciones: </label>
							</td>
							<td>
								<textarea id="observaciones" name="observaciones" row="4" cols="30" tabindex="23" onblur="ponerMayusculas(this); limpiarCajaTexto(this.id);" maxlength="100" class="valid"></textarea>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblCredCastigo">Tipo de cr&eacute;dito a castigar: </label>
							</td>
							<td>
								<form:select id="credCastigoID" name="credCastigoID" path="credCastigoID" tabindex="24">
									<form:option value="0">SELECCIONAR</form:option>
									<form:option value="1">CREDITO R</form:option>
									<form:option value="2">CREDITO RC</form:option>
									<form:option value="3">AMBOS</form:option>
								</form:select>
							</td>
						</tr>
					</table>
				</fieldset>
				<table align="right" >
					<tr>
						<td align="right" >
							<input type="submit" id="castiga" name="castiga" class="submit" tabIndex = "25" value="Castigar" />
							<button type="button" class="submit" id="impPoliza" style="display:none">Ver Póliza</button>
							<input type="hidden" id="polizaID" name="polizaID" iniForma="false"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
							<input type="hidden" id="tipoCastigo" name="tipoCastigo" />
						</td>
					</tr>
				</table>
			</form:form>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
		</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/amortizacionCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/creditosMovsServicio.js"></script>
<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="js/credito/pagoCreVertical.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Pago de Crédito Vertical</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="960px">
					<tr>
						<td class="label">
							<label for="creditoID">Crédito: </label>
						</td>
						<td>
							<form:input id="creditoID" name="creditoID" path="creditoID" size="12" iniForma='false' tabindex="1" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="clienteID"><s:message code="safilocale.cliente" />: </label>
						</td>
						<td>
							<form:input id="clienteID" name="clienteID" path="clienteID" size="12" type="text" readOnly="true" />
							<input id="nombreCliente" name="nombreCliente" size="50" type="text" readOnly="true" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="lblPagaIVA">Paga IVA: </label>
						</td>
						<td>
							<select id="pagaIVA" name="pagaIVA" path="pagaIVA" tabindex="2" disabled="true">
								<option value="">--</option>
								<option value="S">SI</option>
								<option value="N">NO</option>
							</select>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="cuentaID">Cuenta Cargo:</label>
						</td>
						<td>
							<form:input id="cuentaID" name="cuentaID" size="12" readOnly="true" type="text" path="cuentaID" />
							<input id="nomCuenta" name="nomCuenta" size="50" type="text" readOnly="true" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="saldo">Saldo:</label>
						</td>
						<td>
							<input id="saldoCta" name="saldoCta" size="12" type="text" readOnly="true" style="text-align: right" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="moneda">Moneda:</label>
						</td>
						<td>
							<form:input id="monedaID" name="monedaID" path="monedaID" size="12" type="text" readOnly="true" />
							<input id="monedaDes" name="monedaDes" size="12" type="text" readOnly="true" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="lblestatus">Estatus:</label>
						</td>
						<td>
							<form:input id="estatus" name="estatus" path="estatus" size="12" type="text" readOnly="true" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="lblMonto">Monto a Pagar:</label>
						</td>
						<td>
							<form:input id="montoPagar" name="montoPagar" path="montoPagar" size="12" tabindex="3" type="text" esMoneda="true" readOnly="true" style="text-align: right" />
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lbldiasFaltaPago">D&iacute;as Falta Pago:</label>
						</td>
						<td>
							<input id="diasFaltaPago" name="diasFaltaPago" size="12" type="text" readOnly="true" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="lblMonto">Tasa Fija:</label>
						</td>
						<td>
							<form:input id="tasaFija" name="tasaFija" path="tasaFija" size="12" type="text" readOnly="true" style="text-align: right" />
							<label>%</label>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblProxFechPago">Prox. Pago:</label>
						</td>
						<td>
							<input type="text" id="fechaProxPago" name="fechaProxPago" size="12" readOnly="true" />
						</td>
					</tr>
					<tr class="ocultarSeguros">
						<td class="label">
							<label>Cobra Seguro Cuota:</label>
						</td>
						<td>
							<form:select name="cobraSeguroCuota" id="cobraSeguroCuota" disabled="true" path="cobraSeguroCuota">
								<option value="N">NO</option>
								<option value="S">SI</option>
							</form:select>
						</td>
					</tr>
				</table> <br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Saldo Cr&eacute;dito</legend>
					<br>
					<div>
						<table>
							<tr>
								<td class="label">
									<label for="adeudoTotal"><b>Total Adeudo:</b></label>
								</td>
								<td>
									<input id="adeudoTotal" name="adeudoTotal" size="15" tabindex="16" type="text" disabled="true" esMoneda="true" style="text-align: right" />
								</td>
							</tr>
						</table> <br>
					</div>
					<br>
					<div>
						<table border="0" cellpadding="0" cellspacing="0" width="900px">
							<tr>
								<td class="label" colspan="2">
									<label><b>Capital </b></label>
								<td class="label" colspan="2">
									<label><b>Inter&eacute;s</b></label>
								<td class="label">
									<label><b>IVA Inter&eacute;s </b></label>
								</td>
								<td>
									<input type="text" name="saldoIVAInteres" id="saldoIVAInteres" size="8" readonly="true" disabled="true" tabIndex="29" esMoneda="true" style="text-align: right" />
								</td>
								<td class="label" colspan="2">
									<label><b>Comisiones</b></label>
								<td class="label" colspan="2">
									<label><b>IVA Comisiones</b></label>
							</tr>
							<tr>
								<td>
									<label>Vigente: </label>
								</td>
								<td>
									<input id="saldoCapVigent" name="saldoCapVigent" size="8" tabindex="18" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" />
								</td>
								<td>
									<label>Ordinario: </label>
								</td>
								<td>
									<input type="text" name="saldoInterOrdin" id="saldoInterOrdin" size="8" readonly="true" disabled="true" tabIndex="23" esMoneda="true" style="text-align: right" />
								</td>
								<td colspan="2"></td>
								<td>
									<label> Falta Pago: </label>
								</td>
								<td>
									<input type="text" name="saldoComFaltPago" id="saldoComFaltPago" size="8" readonly="true" disabled="true" tabIndex="32" esMoneda="true" style="text-align: right" />
								</td>
								<td>
									<label> Falta Pago: </label>
								</td>
								<td>
									<input type="text" name="salIVAComFalPag" id="salIVAComFalPag" size="8" readonly="true" disabled="true" tabIndex="35" esMoneda="true" style="text-align: right" />
								</td>
							</tr>
							<tr>
								<td>
									<label>Atrasado: </label>
								</td>
								<td>
									<input id="saldoCapAtrasad" name="saldoCapAtrasad" size="8" tabindex="19" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" />
								</td>
								<td>
									<label>Atrasado: </label>
								</td>
								<td>
									<input type="text" name="saldoInterAtras" id="saldoInterAtras" size="8" readonly="true" disabled="true" tabIndex="24" esMoneda="true" style="text-align: right" />
								</td>
								<td class="label">
									<label><b>Moratorio</b></label>
								</td>
								<td>
									<input type="text" name="saldoMoratorios" id="saldoMoratorios" size="8" readonly="true" disabled="true" tabIndex="30" esMoneda="true" style="text-align: right" />
								</td>
								<td>
									<label>Otras: </label>
								</td>
								<td>
									<input type="text" name="saldoOtrasComis" id="saldoOtrasComis" size="8" readonly="true" disabled="true" tabIndex="33" esMoneda="true" style="text-align: right" />
								</td>
								<td>
									<label>Otras: </label>
								</td>
								<td>
									<input type="text" name="saldoIVAComisi" id="saldoIVAComisi" size="8" readonly="true" disabled="true" tabIndex="36" esMoneda="true" style="text-align: right" />
								</td>
							</tr>
							<tr>
								<td>
									<label>Vencido: </label>
								</td>
								<td>
									<input type="text" name="saldoCapVencido" id="saldoCapVencido" size="8" readonly="true" disabled="true" tabIndex="20" esMoneda="true" style="text-align: right" />
								</td>
								<td>
									<label>Vencido: </label>
								</td>
								<td>
									<input type="text" name="saldoInterVenc" id="saldoInterVenc" size="8" readonly="true" disabled="true" tabIndex="25" esMoneda="true" style="text-align: right" />
								</td>
								<td class="label">
									<label><b>IVA Moratorio</b></label>
								</td>
								<td>
									<input type="text" name="saldoIVAMorator" id="saldoIVAMorator" size="8" readonly="true" disabled="true" tabIndex="31" esMoneda="true" style="text-align: right" />
								</td>
								<td>
									<label>Admon: </label>
								</td>
								<td>
									<input type="text" name="saldoAdmonComis" id="saldoAdmonComis" size="8" readonly="true" disabled="true" tabIndex="33" esMoneda="true" style="text-align: right" value="0.00" />
								</td>
								<td>
									<label>Admon: </label>
								</td>
								<td>
									<input type="text" name="saldoIVAAdmonComisi" id="saldoIVAAdmonComisi" size="8" readonly="true" disabled="true" tabIndex="36" esMoneda="true" style="text-align: right" value="0.00" />
								</td>
							</tr>
							<tr>
								<td>
									<label>Vencido no Exigible: </label>
								</td>
								<td>
									<input type="text" name="saldCapVenNoExi" id="saldCapVenNoExi" size="8" readonly="true" disabled="true" tabIndex="21" esMoneda="true" style="text-align: right" />
								</td>
								<td>
									<label>Provisi&oacute;n:</label>
								</td>
								<td>
									<input type="text" name="saldoInterProvi" id="saldoInterProvi" size="8" readonly="true" disabled="true" tabIndex="26" esMoneda="true" style="text-align: right" />
								</td>
								<td></td>
								<td></td>
								<td class="label ocultaSeguro">
									<label>Seguro</label>
								</td>
								<td class="ocultaSeguro">
									<input type="text" name="saldoSeguroCuota" id="saldoSeguroCuota" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" />
								</td>
								<td class="label ocultaSeguro">
									<label>Seguro</label>
								</td>
								<td class="ocultaSeguro">
									<input type="text" name="saldoIVASeguroCuota" id="saldoIVASeguroCuota" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" />
								</td>
							</tr>
							<tr>
								<td>
									<label><b>Total: </b></label>
								</td>
								<td>
									<input name="totalCapital" id="totalCapital" type="text" size="8" readonly="true" disabled="true" tabIndex="22" esMoneda="true" style="text-align: right" />
								</td>
								<td>
									<label>Cal.No Cont.: </label>
								</td>
								<td>
									<input type="text" name="saldoIntNoConta" id="saldoIntNoConta" size="8" readonly="true" disabled="true" tabIndex="27" esMoneda="true" style="text-align: right" />
								</td>
								<td></td>
								<td></td>
								<td class="label"><label>Anual:</label></td>
								<td><input id="saldoComAnual" name="saldoComAnual" type="text" esMoneda="true" size="8" readonly="true" disabled="true" style="text-align: right"></td>
								<td class="label"><label>Anual:</label></td>
								<td><input id="saldoComAnualIVA" name="saldoComAnualIVA" type="text" esMoneda="true" size="8" readonly="true" disabled="true" style="text-align: right"></td>
							</tr>
							<tr>
								<td class="separador" colspan="2"></td>
								<td>
									<label><b>Total: </b></label>
								</td>
								<td>
									<input type="text" name="totalInteres" id="totalInteres" size="8" readonly="true" disabled="true" tabIndex="28" esMoneda="true" style="text-align: right" />
								</td>
								<td></td>
								<td></td>
								<td>
									<label><b>Total: </b></label>
								</td>
								<td>
									<input type="text" name="totalComisi" id="totalComisi" size="8" readonly="true" disabled="true" tabIndex="34" esMoneda="true" style="text-align: right" />
								</td>
								<td>
									<label><b>Total: </b></label>
								</td>
								<td>
									<input type="text" name="totalIVACom" id="totalIVACom" size="8" readonly="true" disabled="true" tabIndex="37" esMoneda="true" style="text-align: right" />
								</td>
							</tr>
						</table>
					</div>
				</fieldset>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>L&iacute;nea de Cr&eacute;dito</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="900px">
						<tr>
							<td class="label">
								<label for="lineaCreditoID">Cr&eacute;dito: </label>
							</td>
							<td>
								<form:input id="lineaCreditoID" name="lineaCreditoID" path="lineaCreditoID" size="12" tabindex="38" type="text" readOnly="true" disabled="true" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="producCreditoID">Producto Cr&eacute;dito: </label>
							</td>
							<td>
								<form:input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="12" tabindex="39" type="text" readOnly="true" disabled="true" />
								<input id="descripProducto" name="descripProducto" size="45" tabindex="40" type="text" readOnly="true" disabled="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="saldoDisponible">Saldo Disponible: </label>
							</td>
							<td>
								<input id="saldoDisponible" name="saldoDisponible" size="12" tabindex="41" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="dispuesto">Dispuesto: </label>
							</td>
							<td>
								<input id="dispuesto" name="dispuesto" size="12" tabindex="42" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblestatus">Estatus:</label>
							</td>
							<td>
								<input id="estatusLinCred" name="estatusLinCred" size="12" tabindex="43" type="text" readOnly="true" disabled="true" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lbldiasFaltaPago">No. de Cr&eacute;ditos que ha tenido: </label>
							</td>
							<td>
								<input id="numeroCreditos" name="numeroCreditos" size="12" tabindex="44" type="text" readOnly="true" disabled="true" />
							</td>
						</tr>
					</table> <input id="fechaSistema" name="fechaSistema" size="12" tabindex="45" type="hidden" />
				</fieldset>
				<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
					<tr>
						<td align="right">
							<input type="button" id="amortiza" name="amortiza" class="submit" tabIndex="46" value="Consultar Amortizaciones" /> <input type="button" id="movimientos" name="movimientos" class="submit" value="Consultar Movimientos" tabIndex="47" /> <input type="submit" id="pagar" name="pagar" class="submit" value="Pagar" tabIndex="48" /> <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" /> <a id="enlaceTicket" target="_blank">
								<button type="button" id="impTicket" name="impTicket" class="submit" value="Imp. Ticket">Imprimir</button>
							</a>
						</td>
					</tr>
				</table> <input id="numeroTransaccion" name="numeroTransaccion" size="12" type="hidden" readOnly="true" disabled="true" /> <input id="exigibleDiaPago" name="exigibleDiaPago" size="12" type="hidden" readOnly="true" disabled="true" />
			</fieldset>
		</form:form>
	</div>
	<div id="gridAmortizacion"></div>
	<div id="gridMovimientos"></div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
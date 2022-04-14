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
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/garantiaFiraServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
		<script type="text/javascript" src="js/fira/aplicaGarantiasAgro.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="aplicaGarantiaFira">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Aplicaci&oacute;n de Garant&iacute;as FIRA</legend>
					<table border="0" width="960px">
						<tr>
							<td class="label">
								<label for="creditoID">Cr&eacute;dito: </label>
							</td>
							<td>
								<form:input id="creditoID" name="creditoID" path="creditoID" size="15" iniForma = 'false' tabindex="1" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="clienteID"><s:message code="safilocale.cliente"/>: </label>
							</td>
							<td >
								<form:input id="clienteID" name="clienteID" path="clienteID" size="15" 	 type="text" readOnly="true" disabled="true"/>
						        <input id="nombreCliente" name="nombreCliente" size="50"  type="text" readOnly="true" disabled="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblPagaIVA">Paga IVA: </label>
							</td>
							<td>
								<select id="pagaIVA" name="pagaIVA" path="pagaIVA"  tabindex="2" disabled="true">
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
								<form:input type="text" id="cuentaID" name="cuentaID" size="15"   readOnly="true" path="cuentaID" disabled="true"/>
								<input id="nomCuenta" name="nomCuenta"  size="50"  type="text" readOnly="true" disabled="true"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label  for="saldo">Saldo:</label>
							</td>
						    <td >
								<input id="saldoCta" name="saldoCta" size="15" 	  type="text" readOnly="true"  style="text-align: right" disabled="true"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label  for="moneda">Moneda:</label>
							</td>
							<td >
								<form:input id="monedaID" name="monedaID" path="monedaID" size="15"  type="text" readOnly="true"/>
						        <input id="monedaDes" name="monedaDes" size="15"  type="text" readOnly="true" disabled="true"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblestatus">Estatus:</label>
							</td>
							<td>
								<form:input id="estatus" name="estatus" path="estatus" size="15"  type="text" readOnly="true" disabled="true"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="garantiaLiquida">Garant&iacute;a L&iacute;quida:</label>
							</td>
						    <td nowrap="nowrap" class="label">
						    	<form:input id="garantiaLiquida" name="garantiaLiquida" path="garantiaLiquida" size="15"  type="text" readOnly="true" style="text-align: right" />
						    </td>
						</tr>
						<tr>
							<td class="label" nowrap="nowrap" ><label for="lbldiasFaltaPago">D&iacute;as Falta Pago:</label>
							</td>
							<td><input id="diasFaltaPago" name="diasFaltaPago" size="15"  type="text" readOnly="true" disabled="true"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblMonto">Tasa:</label>
							</td>
						    <td nowrap="nowrap" class="label">
						    	<form:input id="tasaFija" name="tasaFija" path="tasaFija" size="15"  type="text" readOnly="true" style="text-align: right" disabled="true" /><label> %</label>
						    </td>
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="lblProxFechPago">Prox. Pago:</label>
							</td>
							<td>
								<input type="text" id="fechaProxPago" name="fechaProxPago" size="15"   readOnly="true" disabled="true"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblObservacion">Causa de Pago:</label>
							</td>
							<td>
								<textarea id="observacion" name="observacion" path="observacion" tabindex="2" cols="50" rows="2" onblur=" ponerMayusculas(this);" maxlength="500" deshabilitado="false" class="valid"></textarea>
							</td>
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="lbl">Cr&eacute;dito Cont. Fondeador:</label>
							</td>
							<td>
								<input type="text" id="creditoContFondeador" name="creditoContFondeador" path="creditoContFondeador" maxlength="20"  size="15" tabindex="3" onkeypress="return validaSoloNumero(event,this);" />
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="lblmostrarAcred">ID de Acr&eacute;ditado: </label>
							</td>
							<td>
								<input type="text" id="acreditadoIDFIRA" name="acreditadoIDFIRA" size="18" maxlength="20" tabindex="16" onkeypress="return validaSoloNumero(event,this);"/>
							</td>
						</tr>
					</table>
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend >Garant&iacute;as a Aplicar</legend>
						<br>
						<div>
							<table>
								<tr>
									<td class="label">
										<label for="tipoGarantia">Tipo Garant&iacute;a:</label>
									</td>
									<td class="label">
										<input type="checkbox" id="fega" name="fega" value="1" readonly="readonly" checked onclick="javascript: return false;">
									</td>
									<td class="label">
										<label for="fega">FEGA</label>
									</td>
									<td class="separador"></td>
									<td class="label">
										<input type="checkbox" id="fonaga" name="fonaga" value="2" readonly="readonly" checked onclick="javascript: return false;" >
									</td>
									<td class="label">
										<label for="fonaga">FONAGA</label>
									</td>
									<td class="separador"></td>
									<td class="label">
										<input type="checkbox" id="progEspecial" name="progEspecial" value="3"  readonly="readonly" checked onclick="javascript: return false;">
									</td>
									<td class="label">
										<label for="progEspecial">PROGRAMA ESPECIAL</label>
									</td>
								</tr>
							</table>
						</div>
						<br>

						<div>
							<table>
								<tr>
								<td class="separador"></td>
								<td class="separador"></td>
									<td class="label">
										<label for="totalAdeudo"><b>Total Adeudo:</b></label>
									</td>
									<td>
										<input id="totalAdeudo" name="totalAdeudo" size="15" tabindex="16" type="text" esMoneda="true" style="text-align: right" autocomplete="off" />
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="garantiaAplicar"><b>Garant&iacute;a Aplicar:</b></label>
									</td>
									<td>
										<input id=garantiaAplicar name="garantiaAplicar" size="15" tabindex="16" type="text" esMoneda="true" style="text-align: right" autocomplete="off" />
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="programaEsp"><b>Programa Especial:</b></label>
									</td>
									<td>
										<input id="programaEsp" name="programaEsp" size="15" tabindex="16" type="text" esMoneda="true" style="text-align: right" autocomplete="off" />
									</td>
								</tr>
							</table>
						</div>
						<br>
						<br>
						<div >
						<table border="0" width="900px">
							<tr>
								<td class="label" colspan="2"><label><b>Capital </b></label>
								<td class="label" colspan="2"><label><b>Inter&eacute;s</b></label>
								<td class="label"><label><b>IVA Inter&eacute;s </b></label></td>
								<td><input type="text"  name="saldoIVAInteres" id="saldoIVAInteres" size="8" readonly="true" disabled="true" tabIndex="29" esMoneda="true" style="text-align: right" /></td>
								<td class="label" colspan="2"><label><b>Comisiones</b></label>
								<td class="label" colspan="2"><label><b>IVA Comisiones</b></label>
							</tr>
							<tr>
								<td><label>Vigente: </label></td>
								<td><input id="saldoCapVigent" name="saldoCapVigent" size="8" tabindex="18" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
								<td><label>Ordinario: </label></td>
								<td><input type="text" name="saldoInterOrdin" id="saldoInterOrdin" size="8" readonly="true" disabled="true" tabIndex="23" esMoneda="true" style="text-align: right" /></td>
								<td colspan="2"></td>
								<td><label> Falta Pago: </label></td>
								<td><input type="text" name="saldoComFaltPago" id="saldoComFaltPago" size="8" readonly="true" disabled="true" tabIndex="32" esMoneda="true" style="text-align: right" /></td>
								<td><label> Falta Pago: </label></td>
								<td><input type="text" name="salIVAComFalPag" id="salIVAComFalPag" size="8" readonly="true" disabled="true" tabIndex="35" esMoneda="true" style="text-align: right" /></td>
							</tr>
							<tr>
								<td><label>Atrasado: </label></td>
								<td><input id="saldoCapAtrasad" name="saldoCapAtrasad" size="8" tabindex="19" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
								<td><label>Atrasado: </label></td>
								<td><input type="text" name="saldoInterAtras" id="saldoInterAtras" size="8" readonly="true" disabled="true" tabIndex="24" esMoneda="true" style="text-align: right" /></td>
								<td class="label"><label><b>Moratorio</b></label></td>
								<td><input type="text"  name="saldoMoratorios" id="saldoMoratorios" size="8" readonly="true" disabled="true" tabIndex="30" esMoneda="true" style="text-align: right" /></td>
								<td><label>Otras: </label></td>
								<td><input type="text" name="saldoOtrasComis" id="saldoOtrasComis" size="8" readonly="true" disabled="true" tabIndex="33" esMoneda="true" style="text-align: right" /></td>
								<td><label>Otras: </label></td>
								<td><input type="text" name="saldoIVAComisi" id="saldoIVAComisi" size="8" readonly="true" disabled="true" tabIndex="36" esMoneda="true" style="text-align: right" /></td>
							</tr>
							<tr>
								<td><label>Vencido: </label></td>
								<td><input type="text" name="saldoCapVencido" id="saldoCapVencido" size="8" readonly="true" disabled="true" tabIndex="20" esMoneda="true" style="text-align: right" /></td>
								<td><label>Vencido: </label></td>
								<td><input type="text" name="saldoInterVenc" id="saldoInterVenc" size="8" readonly="true" disabled="true" tabIndex="25" esMoneda="true" style="text-align: right" /></td>
								<td class="label"><label><b>IVA Moratorio</b></label></td>
								<td><input type="text" name="saldoIVAMorator" id="saldoIVAMorator" size="8" readonly="true" disabled="true" tabIndex="31" esMoneda="true" style="text-align: right" /></td>
								<td><label>Admon: </label></td>
								<td><input type="text" name="saldoAdmonComis" id="saldoAdmonComis" size="8" readonly="true" disabled="true" tabIndex="33" esMoneda="true" style="text-align: right" value="0.00" /></td>
								<td><label>Admon: </label></td>
								<td><input type="text" name="saldoIVAAdmonComisi" id="saldoIVAAdmonComisi" size="8" readonly="true" disabled="true" tabIndex="36" esMoneda="true" style="text-align: right" value="0.00" /></td>
							</tr>
							<tr>
								<td><label>Vencido no Exigible: </label></td>
								<td><input type="text" name="saldCapVenNoExi" id="saldCapVenNoExi" size="8" readonly="true" disabled="true" tabIndex="21" esMoneda="true" style="text-align: right" /></td>
								<td><label>Provisi&oacute;n:</label></td>
								<td><input type="text" name="saldoInterProvi" id="saldoInterProvi" size="8" readonly="true" disabled="true" tabIndex="26" esMoneda="true" style="text-align: right" /></td>
								 <td class="separador" colspan="2"></td>
								 <td><label><b>Total: </b></label></td>
								<td><input type="text" name="totalComisi" id="totalComisi" size="8" readonly="true" disabled="true" tabIndex="37" esMoneda="true" style="text-align: right" /></td>
								<td><label><b>Total: </b></label></td>
								<td><input type="text" name="totalIVACom" id="totalIVACom" size="8" readonly="true" disabled="true" tabIndex="37" esMoneda="true" style="text-align: right" /></td>
							</tr>
							<tr>
								<td><label><b>Total: </b></label></td>
								<td><input name="totalCapital" id="totalCapital" type="text" size="8" readonly="true" disabled="true" tabIndex="22" esMoneda="true" style="text-align: right" /></td>
								<td><label>Cal.No Cont.: </label></td>
								<td><input type="text" name="saldoIntNoConta" id="saldoIntNoConta" size="8" readonly="true" disabled="true" tabIndex="27" esMoneda="true" style="text-align: right" /></td>
							</tr>
							<tr>
								<td class="separador" colspan="2"></td>
								<td><label><b>Total: </b></label></td>
								<td><input type="text" name="totalInteres" id="totalInteres" size="8" readonly="true" disabled="true" tabIndex="28" esMoneda="true" style="text-align: right" /></td>
							</tr>
						</table>
					</div>
				</fieldset>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend >L&iacute;nea de Cr&eacute;dito</legend>
						<table border="0" width="900px">
							<tr>
								<td class="label">
									<label for="lineaCreditoID">Cr&eacute;dito: </label>
								</td>
								<td>
									<form:input id="lineaCreditoID" name="lineaCreditoID" path="lineaCreditoID" size="12" tabindex="38" type="text" readOnly="true" disabled="true"/>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="producCreditoID">Producto Cr&eacute;dito: </label>
								</td>
								<td>
									<form:input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="12" tabindex="39" type="text" readOnly="true" disabled="true"/>
						         	<input id="descripProducto" name="descripProducto" size="45" tabindex="40" type="text" readOnly="true" disabled="true"/>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="saldoDisponible">Saldo Disponible: </label>
								</td>
								<td>
									<input id="saldoDisponible" name="saldoDisponible" size="12" tabindex="41" type="text" readOnly="true" disabled="true" esMoneda="true"  style="text-align: right"/>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label  for="dispuesto">Dispuesto: </label>
								</td>
								<td>
									<input id="dispuesto" name="dispuesto" size="12" tabindex="42" type="text" readOnly="true" disabled="true" esMoneda="true"  style="text-align: right"/>
								</td>
							</tr>
							<tr>
							 	<td class="label">
							    	<label for="estatusLinCred">Estatus:</label>
							  	</td>
							    <td>
							     	<input id="estatusLinCred" name="estatusLinCred" size="12" tabindex="43" type="text" readOnly="true" disabled="true"/>
							  	</td>
							    <td class="separador"></td>
							    <td class="label">
							    	<label for="numeroCreditos">No. de Cr&eacute;ditos que ha tenido: </label>
								</td>
							   	<td>
							    	<input id="numeroCreditos" name="numeroCreditos"  size="12" tabindex="44" type="text" readOnly="true" disabled="true"/>
							   	</td>
							</tr>
						</table>
						<input id="fechaSistema" name="fechaSistema"  size="12"  tabindex="45" type="hidden"/>
					</fieldset>

					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
						<tr>
							<td align="right">
								<input type="button" id="amortiza" name="amortiza" class="submit" tabIndex = "46" value="Consultar Amortizaciones" />
								<input type="button" id="movimientos" name="movimientos" class="submit" value="Consultar Movimientos" tabIndex = "47" />
								<input type="submit" id="aplicar" name="aplicar" class="submit" value="Aplicar" tabIndex = "48" />
								<input type="submit" id="cancelar" name="cancelar" class="submit" value="Cancelar" tabIndex = "49" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
								<input type="hidden" id="montoTotCredSinIVA" name="montoTotCredSinIVA"/>
								<input type="hidden" id="estatusGarantia" name="estatusGarantia"/>
								<input type="hidden" id="porcentajeGtia" name="porcentajeGtia"/>
								<input type="hidden" id="tipoGarantiaID" name="tipoGarantiaID"/>
							</td>
						</tr>
					</table>
					<input id="numeroTransaccion" name="numeroTransaccion"  size="12" type="hidden" readOnly="true" disabled="true"/>
				</fieldset>
			</form:form>
		</div>
		<div id="gridAmortizacion"></div>
		<div id="gridMovimientos"></div>

		<div id="cargando" style="display: none;">
		</div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>
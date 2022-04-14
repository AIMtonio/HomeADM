<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head> 
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/amortizacionCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/creditosMovsServicio.js"></script>
<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/formTipoCalIntServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/esquemaOtrosAccesoriosServicio.js"></script>
<script type="text/javascript" src="js/credito/consultaCredito.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Consulta Cr&eacute;dito</legend>
				<table border="0" width="60%">
					<tr>
						<td class="label"><label for="creditoID">Cr&eacute;dito: </label></td>
						<td><form:input id="creditoID" name="creditoID" path="creditoID" size="12" iniForma='false' tabindex="1" /></td>
						<td class="separador"></td>
						<td class="label"><label for="clienteID"><s:message code="safilocale.cliente" />: </label></td>
						<td><input id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="4" type="text" readOnly="true" disabled="true" /> <input id="nombreCliente" name="nombreCliente" path="nombreCliente" size="45" tabindex="4" type="text" readOnly="true" disabled="true" /></td>
					</tr>
					<tr>
						<td class="label"><label for="cuentaID">Cuenta: </label></td>
						<td><input id="cuentaID" name="cuentaID" path="cuentaID" size="12" tabindex="4" type="text" readOnly="true" disabled="true" /></td>
						<td class="separador"></td>
						<td class="label"><label for="moneda">Moneda: </label></td>
						<td><input id="monedaID" name="monedaID" path="monedaID" size="12" tabindex="4" type="text" readOnly="true" disabled="true" /> <input id="monedaDes" name="monedaDes" size="12" tabindex="4" type="text" readOnly="true" disabled="true" /></td>
					</tr>
					<tr>
						<td class="label"><label for="lblestatus">Estatus:</label></td>
						<td><input id="estatus" name="estatus" path="estatus" size="12" tabindex="4" type="text" readOnly="true" disabled="true" /></td>
						<td class="separador">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>
						<td class="label" nowrap="nowrap"><label for="producCreditoID">Producto Cr&eacute;dito: </label></td>
						<td nowrap="nowrap"><input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="12" tabindex="4" type="text" readOnly="true" disabled="true" /> <input id="descripProducto" name="descripProducto" size="45" tabindex="4" type="text" readOnly="true" disabled="true" /></td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap"><label for="lbldiasFaltaPago">D&iacute;as Falta Pago:</label></td>
						<td><input id="diasFaltaPago" name="diasFaltaPago" size="12" tabindex="13" type="text" readOnly="true" disabled="true" /></td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap"><label id="lbltasaFija" for="tasaFija">Tasa Fija:</label></td>
						<td><input id="tasaFija" name="tasaFija" path="tasaFija" size="12" tabindex="4" type="text" readOnly="true" disabled="true" style="text-align: right;" /> <label>%</label></td>

					</tr>
					<tr>
						<td class="label" id="tdGrupoGrupoCredlabel" style="display: none;"><label for="lblmonedacr">Grupo: </label></td>
						<td id="tdGrupoGrupoCredinput" style="display: none;"><input id="grupoID" name="grupoID" size="12" tabindex="8" type="text" readOnly="true" disabled="true" /> <input id="grupoDes" name="grupoDes" size="30" tabindex="10" type="text" readOnly="true" disabled="true" /></td>
						<td class="separador"></td>
						<td class="label" id="tdGrupoCicloCredlabel" style="display: none;"><label for="lblciclo">Ciclo: </label></td>
						<td id="tdGrupoCicloCredinput" style="display: none;"><input id="cicloID" name="cicloID" size="12" tabindex="8" type="text" readOnly="true" disabled="true" /></td>
					</tr>
					<tr>
						<td id="tipoPrepagoTD1" style="display: none;" nowrap="nowrap"><label>Tipo Prepago Capital:</label></td>

						<td id="tipoPrepagoTD" style="display: none;"><select id="tipoPrepago" name="tipoPrepago" path="tipoPrepago" tabindex="29">
								<option value="">SELECCIONAR</option>
								<option value="U">&Uacute;ltimas Cuotas</option>
								<option value="I">Cuotas Siguientes Inmediatas</option>
								<option value="V">Prorrateo Cuotas Vigentes</option>
						</select></td>
						<td class="separador" id="separador" style="display: none;"></td>
						<td class="label"><label for="lblOrigen">Origen:</label></td>
						<td><input id="origen" name="origen" path="origen" size="25" tabindex="30" type="text" readOnly="true" disabled="true" /></td>
					</tr>
					<tr name="tasaBase">
						<td class="label"><label for="lblcalInter">C&aacute;lculo de Inter&eacute;s </label></td>
						<td><form:select id="calcInteresID" name="calcInteresID" path="" tabindex="24" disabled="true">
								<form:option value="">SELECCIONAR</form:option>
							</form:select></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
					</tr>
					<tr name="tasaBase">
						<td class="label"><label for="TasaBase">Tasa Base: </label></td>
						<td nowrap="nowrap"><input type="text" id="tasaBase" name="tasaBase" path="tasaBase" size="8" readonly="true" disabled="true" tabindex="60" /> <input type="text" id="desTasaBase" name="desTasaBase" size="25" readonly="true" disabled="true" tabindex="61" /></td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap"><label for="SobreTasa">Valor Tasa Base: </label></td>
						<td><input type="text" id="tasaBaseValor" name="tasaBaseValor" path="" size="12" esTasa="true" tabindex="63" readOnly="true" disabled="true" style="text-align: right;" /> <label for="porcentaje">%</label></td>
					</tr>
					<tr name="tasaBase">
						<td class="label"><label for="SobreTasa">SobreTasa: </label></td>
						<td><input type="text" id="sobreTasa" name="sobreTasa" path="sobreTasa" size="8" esTasa="true" tabindex="63" readOnly="true" disabled="true" style="text-align: right;" /> <label for="porcentaje">%</label></td>
						<td class="separador"></td>
						<td class="label" name="tasaPisoTecho"><label for="PisoTasa">Piso Tasa: </label></td>
						<td name="tasaPisoTecho"><input type="text" id="pisoTasa" name="pisoTasa" path="pisoTasa" size="12" style="text-align: right;" esTasa="true" readOnly="true" disabled="true" tabindex="64" /> <label for="porcentaje">%</label></td>
					</tr>
					<tr name="tasaBase">
						<td class="label" name="tasaPisoTecho"><label for="TechoTasa">Techo Tasa: </label></td>
						<td name="tasaPisoTecho"><input type="text" id="techoTasa" name="techoTasa" path="techoTasa" size="8" style="text-align: right;" esTasa="true" readOnly="true" disabled="true" tabindex="65" /> <label for="porcentaje">%</label></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
					</tr>
					<tr class="ocultarSeguros">
						<td class="label"><label>Cobra Seguro Cuota:</label></td>
						<td><form:select name="cobraSeguroCuota" id="cobraSeguroCuota" disabled="true" path="cobraSeguroCuota">
								<option value="N">NO</option>
								<option value="S">SI</option>
							</form:select>
						</td>
						<td class="separador"></td>
						<td class="tipoSofipo label"><label for="idenCreditoCNBV">Identificador CNBV: </label></td>
						<td class="tipoSofipo "><input type="text" id="idenCreditoCNBV" name="idenCreditoCNBV" path="idenCreditoCNBV" size="32" readOnly="true" disabled="true" tabindex="65" /></td>
					</tr>
				</table>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Saldo Cr&eacute;dito</legend>
					<br>
					<div>
						<table>
							<tr>
								<td class="label"><label for="lblTotcionsulta">Tipo Pago:</label></td>
								<td class="label"><input type="radio" id="totalAde" name="totalAde" value="T" tabindex="23" checked="checked" /> <label for="siguientetotaladeu" class="label">Total Adeudo</label> <input type="hidden" id="finiquito" name="finiquito" value="S" tabindex="22" iniForma="false" /> <input
									type="hidden" id="permiteFiniquito" name="permiteFiniquito" value="" tabindex="22" iniForma="false" /></td>
								<td class="separador"></td>
								<td class="label"><input type="radio" id="exigible" name="exigible" value="E" tabindex="15" /> <label for="anteriorexigi">Pago Cuota</label></td>
							</tr>
						</table>
						<br>
						<table>
							<tr>
								<td class="label"><label for="lblTotalAd" id="labelTotalAdeudoPC"><b>Total Adeudo :</b></label></td>
								<td><input id="adeudoTotal" name="adeudoTotal" size="15" tabindex="16" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>

								<td class="label"><label id="labelPagoExigiblePC"><b>Total Pagar :</b></label></td>
								<td><input id="pagoExigible" name="pagoExigible" size="15" tabindex="17" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
								<td class="label"><label id="lblexigibleAlDia"><b>Exigible al D&iacute;a:</b></label></td>
								<td><input id="exigibleAlDia" name="exigibleAlDia" size="15" tabindex="17" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
								<td class="label"><label id="lblmontoProyectado"><b>Monto Proyectado:</b></label></td>
								<td><input id="montoProyectado" name="montoProyectado" size="15" tabindex="17" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
							</tr>
							<tr>
								<td class="label"><label for="lblTotalAdGrup" id="labelTotalAdeGrupalPC"><b>Total Adeudo Grupal:</b></label></td>
								<td><input id="montoTotDeudaPC" name="montoTotDeudaPC" size="15" tabindex="17" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>

								<td class="label"><label id="labelPagoExiGrupoPC"><b>Total Pagar Grupal:</b></label></td>
								<td><input id="montoTotExigiblePC" name="montoTotExigiblePC" size="15" tabindex="17" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
								<td class="label"><label id="lblExigibleAlDiaG"><b>Exigible al D&iacute;a:</b></label></td>
								<td><input id="exigibleAlDiaG" name="exigibleAlDiaG" size="15" tabindex="17" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
								<td class="label"><label id="lblMontoProyectadoG"><b>Monto Proyectado:</b></label></td>
								<td><input id="montoProyectadoG" name="montoProyectadoG" size="15" tabindex="17" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
							</tr>
						</table>
					</div>
					<br>
					<div>
						<table border="0" width="100%">
							<tr>
								<td class="label" colspan="2"><label><b>Capital </b></label></td>
								<td class="label" colspan="2"><label><b>Inter&eacute;s</b></label></td>
								<td class="label"><label><b>IVA Inter&eacute;s </b></label></td>
								<td><input type="text" name="saldoIVAInteres" id="saldoIVAInteres" size="8" readonly="true" disabled="true" tabIndex="29" esMoneda="true" style="text-align: right" /></td>
								<td class="label" colspan="2"><label><b>Comisiones</b></label>
								<td class="label" colspan="2"><label><b>IVA Comisiones</b></label></td>
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
								<td><input type="text" name="saldoMoratorios" id="saldoMoratorios" size="8" readonly="true" disabled="true" tabIndex="30" esMoneda="true" style="text-align: right" /></td>
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
								<td class="label" nowrap="nowrap"><label><b>IVA Moratorio</b></label></td>
								<td><input type="text" name="saldoIVAMorator" id="saldoIVAMorator" size="8" readonly="true" disabled="true" tabIndex="31" esMoneda="true" style="text-align: right" /></td>
								<td><label>Admon: </label></td>
								<td><input type="text" name="saldoAdmonComis" id="saldoAdmonComis" size="8" readonly="true" disabled="true" tabIndex="33" esMoneda="true" style="text-align: right" value="" /></td>
								<td><label>Admon: </label></td>
								<td><input type="text" name="saldoIVAAdmonComisi" id="saldoIVAAdmonComisi" size="8" readonly="true" disabled="true" tabIndex="36" esMoneda="true" style="text-align: right" value="" /></td>
							</tr>
							<tr>
								<td nowrap="nowrap"><label>Vencido no Exigible: </label></td>
								<td><input type="text" name="saldCapVenNoExi" id="saldCapVenNoExi" size="8" readonly="true" disabled="true" tabIndex="21" esMoneda="true" style="text-align: right" /></td>
								<td><label>Provisi&oacute;n:</label></td>
								<td><input type="text" name="saldoInterProvi" id="saldoInterProvi" size="8" readonly="true" disabled="true" tabIndex="26" esMoneda="true" style="text-align: right" /></td>
								<td></td>
								<td></td>
								<td class="label"><label>Seguro:</label></td>
								<td><input type="text" name="saldoSeguroCuota" id="saldoSeguroCuota" size="8" readonly="true" disabled="true" tabIndex="37" esMoneda="true" style="text-align: right" /></td>
								<td nowrap="nowrap" class="label"><label>IVA Seguro:</label></td>
								<td><input type="text" name="saldoIVASeguroCuota" id="saldoIVASeguroCuota" size="8" readonly="true" disabled="true" tabIndex="37" esMoneda="true" style="text-align: right" /></td>
							</tr>
							<tr>
								<td><label><b>Total: </b></label></td>
								<td><input name="totalCapital" id="totalCapital" type="text" size="8" readonly="true" disabled="true" tabIndex="22" esMoneda="true" style="text-align: right" /></td>
								<td nowrap="nowrap"><label>Cal.No Cont.: </label></td>
								<td><input type="text" name="saldoIntNoConta" id="saldoIntNoConta" size="8" readonly="true" disabled="true" tabIndex="27" esMoneda="true" style="text-align: right" /></td>
								<td class="label"><label></label></td>
								<td></td>
								<td><label>Anualidad:</label></td>
								<td><input type="text" name="saldoComAnual" id="saldoComAnual" size="8" readonly="true" disabled="true" tabIndex="34" esMoneda="true" style="text-align: right" /></td>
								<td><label>Anualidad:</label></td>
								<td><input type="text" name="saldoComAnualIVA" id="saldoComAnualIVA" size="8" readonly="true" disabled="true" tabIndex="37" esMoneda="true" style="text-align: right" /></td>
							</tr>
							<tr>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td><label><b>Total: </b></label></td>
								<td><input type="text" name="totalComisi" id="totalComisi" size="8" readonly="true" disabled="true" tabIndex="34" esMoneda="true" style="text-align: right" /></td>
								<td><label><b>Total: </b></label></td>
								<td><input type="text" name="totalIVACom" id="totalIVACom" size="8" readonly="true" disabled="true" tabIndex="37" esMoneda="true" style="text-align: right" /></td>
							</tr>
							<tr>
								<td class="separador" colspan="2"></td>
								<td><label><b>Total: </b></label></td>
								<td><input type="text" name="totalInteres" id="totalInteres" size="8" readonly="true" disabled="true" tabIndex="28" esMoneda="true" style="text-align: right" /></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
						</table>
					</div>
				</fieldset>
				<div id="linea">
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>L&iacute;nea de Cr&eacute;dito</legend>
						<table border="0" width="100%">
							<tr>
								<td class="label"><label for="lineaCreditoID">Cr&eacute;dito: </label></td>
								<td><input id="lineaCreditoID" name="lineaCreditoID" path="lineaCreditoID" size="12" tabindex="4" type="text" readOnly="true" disabled="true" /></td>
								<td class="separador"></td>
								<td class="label"><label for="saldoDisponible">Saldo Disponible: </label></td>
								<td><input id="saldoDisponible" name="saldoDisponible" path="saldoDisponible" size="12" tabindex="4" type="text" readOnly="true" disabled="true" esMoneda="true" /></td>
							</tr>
							<tr>
								<td class="label"><label for="dispuesto">Dispuesto: </label></td>
								<td><input id="dispuesto" name="dispuesto" path="dispuesto" size="12" tabindex="4" type="text" readOnly="true" disabled="true" esMoneda="true" /></td>
								<td class="separador"></td>
								<td class="label"><label for="lblestatus">Estatus:</label></td>
								<td><input id="estatusLinCred" name="estatusLinCred" path="estatusLinCred" size="12" tabindex="4" type="text" readOnly="true" disabled="true" /></td>
							</tr>
							<tr>
								<td class="label"><label for="lbldiasFaltaPago">No. de Cr&eacute;ditos que ha tenido: </label></td>
								<td><input id="numeroCreditos" name="numeroCreditos" path="numeroCreditos" size="12" tabindex="4" type="text" readOnly="true" disabled="true" /></td>
								<td class="separador"></td>
							</tr>
							<tr>
								<td class="label"><label for="lblcomAnualLin">Comisi&oacute;n Anual: </label></td>
								<td><input type="text" name="comAnualLin" id="comAnualLin" size="12" esMoneda="true" readonly="true" disabled="true" style="text-align: right;" /></td>
								<td class="separador"></td>
								<td class="label"><label for="lblIVAComAnualLin">IVA Com. Anual: </label></td>
								<td><input type="text" name="IVAComAnualLin" id="IVAComAnualLin" size="12" esMoneda="true" readonly="true" disabled="true" style="text-align: right;" /></td>
							</tr>
						</table>
					</fieldset>
				</div>
				<table border="0" width="100%">
					<tr>
						<td colspan="4" align="right">
						<input type="button" id="amortiza" name="amortiza" class="submit" tabIndex="13" value="Consultar Amortizaciones" /> 
						<input type="button" id="movimientos" name="movimientos" class="submit" value="Consultar Movimientos" tabIndex="14" />
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" /></td>
					</tr>
				</table>
				<div id="gridAmortizacion"></div>
				<div id="gridMovimientos"></div>
				<div id="gridCalendarioActual"></div>
				<table border="0" width="100%">
					<tr>
						<td colspan="4" align="right">
						<input type="button" id="ExportExcel" name="ExportExcel" class="submit" value="Exportar" tabIndex="15" /> </td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
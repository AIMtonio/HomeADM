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
<script type="text/javascript" src="dwr/interface/formTipoCalIntServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
<script type="text/javascript" src="js/fira/pagoCreditoAgro.js"></script>
</head>
<body> 
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Pago de Cr&eacute;dito</legend>
				<table border="0" width="960px">
					<tr>
						<td class="label"><label for="creditoID">Cr&eacute;dito: </label></td>
						<td width="18%"><form:input id="creditoID" name="creditoID" path="creditoID" size="15" iniForma='false' tabindex="1" /></td>
						<td class="separador"></td>
						<td class="label"><label for="clienteID"><s:message code="safilocale.cliente" />: </label></td>
						<td nowrap="nowrap"><form:input id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="2" type="text" readOnly="true" disabled="true" /> <input id="nombreCliente" name="nombreCliente" size="30" tabindex="3" type="text" readOnly="true" disabled="true" /></td>
					</tr>
					<tr>
						<td class="label"><label for="lblPagaIVA">Paga IVA: </label></td>
						<td><select id="pagaIVA" name="pagaIVA" path="pagaIVA" tabindex="4" disabled="true">
								<option value="">--</option>
								<option value="S">SI</option>
								<option value="N">NO</option>
						</select></td>
						<td class="separador"></td>
						<td class="label"><label for="cuentaID">Cuenta Cargo:</label></td>
						<td nowrap="nowrap"><form:input type="text" id="cuentaID" name="cuentaID" size="12" readOnly="true" disabled="true" tabindex="5" path="cuentaID" /> <input id="nomCuenta" name="nomCuenta" size="30" tabindex="6" type="text" readOnly="true" disabled="true" /></td>
					</tr>
					<tr>
						<td class="label"><label for="saldo">Saldo:</label></td>
						<td><input id="saldoCta" name="saldoCta" size="15" tabindex="7" type="text" readOnly="true" disabled="true" style="text-align: right" /></td>
						<td class="separador"></td>
						<td class="label"><label for="moneda">Moneda:</label></td>
						<td><form:input id="monedaID" name="monedaID" path="monedaID" size="12" tabindex="8" type="text" readOnly="true" disabled="true" /> <input id="monedaDes" name="monedaDes" size="12" tabindex="10" type="text" readOnly="true" disabled="true" /></td>
					</tr>
					<tr>
						<td class="label"><label for="lblestatus">Estatus:</label></td>
						<td><form:input id="estatus" name="estatus" path="estatus" size="15" tabindex="11" type="text" readOnly="true" disabled="true" /></td>
						<td class="separador"></td>
						<td class="label"><label for="lblMonto">Monto a Pagar:</label></td>
						<td><form:input id="montoPagar" name="montoPagar" path="montoPagar" size="12" tabindex="12" type="text" esMoneda="true" style="text-align: right" /></td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap"><label for="creditoR">Cr&eacute;dito R:</label></td>
						<td><form:input type="text" id="creditoR" name="creditoR" path="creditoR" onkeypress="validaSoloNumero(event)" size="15" esMoneda="true" tabindex="13" style="text-align: right" maxlength="6" /> <label>%</label></td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap"><label for="creditoRC">Cr&eacute;dito RC:</label></td>
						<td><form:input type="text" id="creditoRC" name="creditoRC" path="creditoRC" size="12" esMoneda="true" readOnly="true" disabled="true" style="text-align: right"/> <label>%</label></td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap"><label for="lbldiasFaltaPago">D&iacute;as Falta Pago:</label></td>
						<td><input id="diasFaltaPago" name="diasFaltaPago" size="15" tabindex="13" type="text" readOnly="true" disabled="true" /></td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap"><label id="lbltasaFija" for="tasaFija">Tasa Fija:</label></td>
						<td><form:input id="tasaFija" name="tasaFija" path="tasaFija" size="12" tabindex="12" type="text" readOnly="true" disabled="true" style="text-align: right" /> <label>%</label></td>
					</tr>
					<tr>
						<td class="label" id="tdGrupoCicloCredlabel" style="display: none;"><label for="lblciclo">Ciclo:</label></td>
						<td id="tdGrupoCicloCredinput" style="display: none;"><input id="cicloID" name="cicloID" size="12" tabindex="8" type="text" readOnly="true" disabled="true" /></td>

						<td class="separador"></td>
						<td class="label" id="tdlblProrrateoPago" style="display: none;"><label for="lblProrroteoPago">Prorrateo Pago:</label></td>
						<td id="tdProrrateoPago" style="display: none;"><select id="prorrateoPago" name="prorrateoPago" tabindex="4" disabled="true">
								<option value="">--</option>
								<option value="S">SI</option>
								<option value="N">NO</option>
						</select></td>
					</tr>
					<tr>
						<td class="label " nowrap="nowrap"><label for="lblProxFechPago">Prox. Pago:</label></td>
						<td><input type="text" id="fechaProxPago" name="fechaProxPago" size="15" iniForma="false" tabindex="19" readOnly="true" disabled="true" /></td>
						<td class="separador"></td>
						<td class="label ocultaSeguro" id="tdGrupoGrupoCredlabel" style="display: none;"><label for="lblmonedacr">Grupo:</label></td>
						<td id="tdGrupoGrupoCredinput" style="display: none;"><input id="grupoID" name="grupoID" size="12" tabindex="8" type="text" readOnly="true" disabled="true" /> <input id="grupoDes" name="grupoDes" size="30" tabindex="10" type="text" readOnly="true" disabled="true" /></td>
					</tr>
					<tr name="tasaBase">
						<td class="label"><label for="lblcalInter">C&aacute;lculo de Inter&eacute;s </label></td>
						<td><form:select id="calcInteres" name="calcInteres" path="" tabindex="24" disabled="true">
								<form:option value="">SELECCIONAR</form:option>
							</form:select></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
					</tr>
					<tr name="tasaBase">
						<td class="label"><label for="TasaBase">Tasa Base: </label></td>
						<td nowrap="nowrap"><input type="text" id="tasaBase" name="tasaBase" path="tasaBase" size="15" readonly="true" disabled="true" tabindex="60" /> <input type="text" id="desTasaBase" name="desTasaBase" size="25" readonly="true" disabled="true" tabindex="61" /></td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap"><label for="SobreTasa">Valor Tasa Base: </label></td>
						<td><input type="text" id="tasaBaseValor" name="tasaBaseValor" path="" size="12" esTasa="true" tabindex="63" readOnly="true" disabled="true" style="text-align: right;" /> <label for="porcentaje">%</label></td>
					</tr>
					<tr name="tasaBase">
						<td class="label"><label for="SobreTasa">SobreTasa: </label></td>
						<td><input type="text" id="sobreTasa" name="sobreTasa" path="sobreTasa" size="15" esTasa="true" tabindex="63" readOnly="true" disabled="true" style="text-align: right;" /> <label for="porcentaje">%</label></td>
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
					<tr style="display: none;">
						<td class="label"><label>Cobra Seguro Cuota:</label></td>
						<td><form:select name="cobraSeguroCuota" id="cobraSeguroCuota" disabled="true" path="cobraSeguroCuota">
								<option value="N">NO</option>
								<option value="S">SI</option>
							</form:select></td>
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
								<td class="label" nowrap="nowrap"><input type="radio" id="totalAde" name="totalAde" value="T" tabindex="23" checked="checked" /> <label for="totalAde" class="label" >Total Adeudo</label> <input type="hidden" id="finiquito" name="finiquito" value="S" tabindex="22" iniForma="false" /> <input type="hidden" id="permiteFiniquito" name="permiteFiniquito" value="" tabindex="22" iniForma="false" /></td>
								<td class="separador"></td>
								<td class="label"><input type="radio" id="exigible" name="exigible" value="E" tabindex="24" /> <label for="exigible">Pago Cuota</label></td>
								<td class="separador"></td>
								<td class="label" id="tdPrepagoCredito"><input type="radio" id="prepagoCredito" name="prepagoCredito" value="P" tabindex="25" /> <label for="prepagoCredito">Prepago</label></td>
								<td class="separador"></td>
								<td class="label">
									<div id="divTipoPrepago">
										<label for="tipoPrepago">Tipo Prepago Capital: </label>
									</div>
								</td>
								<td>
									<div id="divTipoPrepago1">
										<form:select id="tipoPrepago" name="tipoPrepago" path="tipoPrepago" tabindex="29">
											<form:option value="">SELECCIONAR</form:option>
											<form:option value="U">&Uacute;ltimas Cuotas</form:option>
											<form:option value="I">Cuotas Siguientes Inmediatas</form:option>
											<form:option value="V">Prorrateo Cuotas Vivas</form:option>
										</form:select>
									</div>
								</td>
							</tr>
						</table>
						<table>
							<tr>
								<td class="label" nowrap="nowrap"><label for="lblTotalAd" id="labelTotalAdeudoPC"><b>Total Adeudo:</b></label></td>
								<td><input id="adeudoTotal" name="adeudoTotal" size="15" tabindex="16" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>

								<td class="label"><label id="labelPagoExigiblePC"><b>Total Pagar :</b></label></td>
								<td><input id="pagoExigible" name="pagoExigible" size="15" tabindex="17" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
								<td class="label"><label id="lblexigibleAlDia"><b>Exigible al D&iacute;a:</b></label></td>
								<td><input id="exigibleAlDia" name="exigibleAlDia" size="15" tabindex="17" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
								<td class="label"><label id="lblmontoProyectado"><b>Monto Proyectado:</b></label></td>
								<td><input id="montoProyectado" name="montoProyectado" size="15" tabindex="17" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>

								<td class="label"><label for="lblTotalAd" id="labelTotalAdeudoPrepago"><b>Total Adeudo :</b></label></td>
								<td><input id="adeudoTotalPrepago" name="adeudoTotalPrepago" size="15" tabindex="16" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
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
								<td class="label"><label id="lblmontoTotGrupalDeudaPrepago"><b>Total Adeudo Grupal :</b></label></td>
								<td><input id="montoTotGrupalDeudaPrepago" name="montoTotGrupalDeudaPrepago" size="15" tabindex="17" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
							</tr>
							<tr>
								<td class="separador" />
								<td class="separador" />
								<td class="label" id="lblUltCuotaPagada" style="display: none;"><label for="ultCuotaPagada"><b>&Uacute;ltima Cuota Pagada:</b></label></td>
								<td><input id="ultCuotaPagada" name="ultCuotaPagada" size="15" tabindex="17" type="text" readOnly="true" disabled="true" style="text-align: right; display: none;" /></td>
								<td class="label" id="lblFechaUltCuotaPagada" style="display: none;"><label for="fechaUltCuotaPagada"><b>Fecha &Uacute;ltima Cuota Pagada: </b></label></td>
								<td><input id="fechaUltCuotaPagada" name="fechaUltCuotaPagada" size="15" tabindex="17" type="text" readOnly="true" disabled="true" style="text-align: right; display: none;" /></td>
								<td class="label" id="lblCuotasAtraso" style="display: none;"><label for="cuotasAtraso"><b>Cuotas en Atraso: </b></label></td>
								<td><input id="cuotasAtraso" name="cuotasAtraso" size="15" tabindex="17" type="text" readOnly="true" disabled="true" style="text-align: right; display: none;" /></td>
							</tr>
							<tr>
								<td class="separador" />
								<td class="separador" />
								<td class="label" id="lblMontoNoCartVencida" style="display: none;"><label for="montoNoCartVencida"><b>Monto para no Pasar a Cartera Vencida: </b></label></td>
								<td><input id="montoNoCartVencida" name="montoNoCartVencida" size="15" tabindex="17" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right; display: none;" /></td>
							</tr>
						</table>
					</div>
					<div>
						<table border="0" width="900px">
							<tr>
								<td class="label" colspan="2"><label><b>Capital </b></label>
								<td class="label" colspan="2"><label><b>Inter&eacute;s</b></label>
								<td class="label"><label><b>IVA Inter&eacute;s </b></label></td>
								<td><input type="text" name="saldoIVAInteres" id="saldoIVAInteres" size="8" readonly="true" disabled="true" tabIndex="29" esMoneda="true" style="text-align: right" /></td>
								<td class="label" colspan="2"><label><b>Comisiones</b></label>
								<td class="label" colspan="2"><label><b>IVA Comisiones</b></label>
							</tr>
							<tr>
								<td><label>Vigente: </label></td>
								<td><input id="saldoCapVigent" name="saldoCapVigent" size="12" tabindex="18" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
								<td><label>Ordinario: </label></td>
								<td><input type="text" name="saldoInterOrdin" id="saldoInterOrdin" size="12" readonly="true" disabled="true" tabIndex="23" esMoneda="true" style="text-align: right" /></td>
								<td colspan="2"></td>
								<td><label> Falta Pago: </label></td>
								<td><input type="text" name="saldoComFaltPago" id="saldoComFaltPago" size="8" readonly="true" disabled="true" tabIndex="32" esMoneda="true" style="text-align: right" /></td>
								<td><label> Falta Pago: </label></td>
								<td><input type="text" name="salIVAComFalPag" id="salIVAComFalPag" size="8" readonly="true" disabled="true" tabIndex="35" esMoneda="true" style="text-align: right" /></td>
							</tr>
							<tr>
								<td><label>Atrasado: </label></td>
								<td><input id="saldoCapAtrasad" name="saldoCapAtrasad" size="12" tabindex="19" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
								<td><label>Atrasado: </label></td>
								<td><input type="text" name="saldoInterAtras" id="saldoInterAtras" size="12" readonly="true" disabled="true" tabIndex="24" esMoneda="true" style="text-align: right" /></td>
								<td class="label"><label><b>Moratorio</b></label></td>
								<td><input type="text" name="saldoMoratorios" id="saldoMoratorios" size="8" readonly="true" disabled="true" tabIndex="30" esMoneda="true" style="text-align: right" /></td>
								<td><label>Otras: </label></td>
								<td><input type="text" name="saldoOtrasComis" id="saldoOtrasComis" size="8" readonly="true" disabled="true" tabIndex="33" esMoneda="true" style="text-align: right" /></td>
								<td><label>Otras: </label></td>
								<td><input type="text" name="saldoIVAComisi" id="saldoIVAComisi" size="8" readonly="true" disabled="true" tabIndex="36" esMoneda="true" style="text-align: right" /></td>
							</tr>
							<tr>
								<td><label>Vencido: </label></td>
								<td><input type="text" name="saldoCapVencido" id="saldoCapVencido" size="12" readonly="true" disabled="true" tabIndex="20" esMoneda="true" style="text-align: right" /></td>
								<td><label>Vencido: </label></td>
								<td><input type="text" name="saldoInterVenc" id="saldoInterVenc" size="12" readonly="true" disabled="true" tabIndex="25" esMoneda="true" style="text-align: right" /></td>
								<td class="label"><label><b>IVA Moratorio</b></label></td>
								<td><input type="text" name="saldoIVAMorator" id="saldoIVAMorator" size="8" readonly="true" disabled="true" tabIndex="31" esMoneda="true" style="text-align: right" /></td>
								<td><label>Admon: </label></td>
								<td><input type="text" name="saldoAdmonComis" id="saldoAdmonComis" size="8" readonly="true" disabled="true" tabIndex="33" esMoneda="true" style="text-align: right" value="0.00" /></td>
								<td><label>Admon: </label></td>
								<td><input type="text" name="saldoIVAAdmonComisi" id="saldoIVAAdmonComisi" size="8" readonly="true" disabled="true" tabIndex="36" esMoneda="true" style="text-align: right" value="0.00" /></td>
							</tr>
							<tr>
								<td><label>Vencido no Exigible: </label></td>
								<td><input type="text" name="saldCapVenNoExi" id="saldCapVenNoExi" size="12" readonly="true" disabled="true" tabIndex="21" esMoneda="true" style="text-align: right" /></td>
								<td><label>Provisi&oacute;n:</label></td>
								<td><input type="text" name="saldoInterProvi" id="saldoInterProvi" size="12" readonly="true" disabled="true" tabIndex="26" esMoneda="true" style="text-align: right" /></td>
								<td></td>
								<td></td>
								<td class="label"><label>Anual:</label></td>
								<td><input id="saldoComAnual" name="saldoComAnual" type="text" esMoneda="true" size="8" readonly="true" disabled="true" style="text-align: right"></td>
								<td class="label"><label>Anual:</label></td>
								<td><input id="saldoComAnualIVA" name="saldoComAnualIVA" type="text" esMoneda="true" size="8" readonly="true" disabled="true" style="text-align: right"></td>
								<td style="display: none;" class="label "><label>Seguro</label></td>
								<td style="display: none;" class=""><input type="text" name="saldoSeguroCuota" id="saldoSeguroCuota" size="8" readonly="true" disabled="true" tabIndex="37" esMoneda="true" style="text-align: right" /></td>
								<td style="display: none;" class="label "><label>Seguro</label></td>
								<td style="display: none;" class=""><input type="text" name="saldoIVASeguroCuota" id="saldoIVASeguroCuota" size="8" readonly="true" disabled="true" tabIndex="37" esMoneda="true" style="text-align: right" /></td>
							</tr>
							<tr>
								<td><label>Contingente:</label></td>
								<td><input name="saldoCapContingente" id="saldoCapContingente" type="text" size="12" readonly="true" disabled="true" tabIndex="22" esMoneda="true" style="text-align: right" /></td>
								<td><label>Cal.No Cont.: </label></td>
								<td><input type="text" name="saldoIntNoConta" id="saldoIntNoConta" size="12" readonly="true" disabled="true" tabIndex="27" esMoneda="true" style="text-align: right" /></td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<td class="separador" colspan="2"></td>
								<td><label>Contingente:</label></td>
								<td><input name="saldoIntContingente" id="saldoIntContingente" type="text" size="12" readonly="true" disabled="true" tabIndex="22" esMoneda="true" style="text-align: right" /></td>
								<td class="separador" colspan="2"></td>
								<td class="separador" colspan="2"></td>
								<td class="separador" colspan="2"></td>
							</tr>
							<tr>
								<td><label><b>Total: </b></label></td>
								<td><input name="totalCapital" id="totalCapital" type="text" size="12" readonly="true" disabled="true" tabIndex="22" esMoneda="true" style="text-align: right" /></td>
								<td><label><b>Total: </b></label></td>
								<td><input type="text" name="totalInteres" id="totalInteres" size="12" readonly="true" disabled="true" tabIndex="28" esMoneda="true" style="text-align: right" /></td>
								<td></td>
								<td></td>
								
								<td><label><b>Total: </b></label></td>
								<td><input type="text" name="totalComisi" id="totalComisi" size="8" readonly="true" disabled="true" tabIndex="34" esMoneda="true" style="text-align: right" /></td>
								<td><label><b>Total: </b></label></td>
								<td><input type="text" name="totalIVACom" id="totalIVACom" size="8" readonly="true" disabled="true" tabIndex="37" esMoneda="true" style="text-align: right" /></td>
							</tr>
						</table>
					</div>
				</fieldset>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>L&iacute;nea de Cr&eacute;dito</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="900px">
						<tr>
							<td class="label"><label for="lineaCreditoID">Cr&eacute;dito: </label></td>
							<td><form:input id="lineaCreditoID" name="lineaCreditoID" path="lineaCreditoID" size="12" tabindex="38" type="text" readOnly="true" disabled="true" /></td>
							<td class="separador"></td>
							<td class="label"><label for="producCreditoID">Producto Cr&eacute;dito: </label></td>
							<td><form:input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="12" tabindex="39" type="text" readOnly="true" disabled="true" /> <input id="descripProducto" name="descripProducto" size="45" tabindex="40" type="text" readOnly="true" disabled="true" /></td>
						</tr>
						<tr>
							<td class="label"><label for="saldoDisponible">Saldo Disponible: </label></td>
							<td><input id="saldoDisponible" name="saldoDisponible" size="12" tabindex="41" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
							<td class="separador"></td>
							<td class="label"><label for="dispuesto">Dispuesto: </label></td>
							<td><input id="dispuesto" name="dispuesto" size="12" tabindex="42" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
						</tr>
						<tr>
							<td class="label"><label for="lblestatus">Estatus:</label></td>
							<td><input id="estatusLinCred" name="estatusLinCred" size="12" tabindex="43" type="text" readOnly="true" disabled="true" /></td>
							<td class="separador"></td>
							<td class="label"><label for="lbldiasFaltaPago">No. de Cr&eacute;ditos que ha tenido: </label></td>
							<td><input id="numeroCreditos" name="numeroCreditos" size="12" tabindex="44" type="text" readOnly="true" disabled="true" /></td>
						</tr>
					</table>
					<input id="fechaSistema" name="fechaSistema" size="12" tabindex="45" type="hidden" />
				</fieldset>

				<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
					<tr>
						<td>
							<div id="divTipoCredito">
								<label for="lblTipoCredito">Tipo de Crédito: </label>
								<select id="tipoCredito" name="tipoCredito" path="tipoCredito" tabindex="46" disabled="true">
									<option value="" >SELECCIONAR</option>
									<option value="A">ACTIVO</option>
									<option value="C">CONTINGENTE</option>
								</select>
							</div>
						</td>
						<td align="right">
							<input type="button" id="amortiza" name="amortiza" class="submit" tabIndex="47" value="Consultar Amortizaciones" /> 
							<input type="button" id="movimientos" name="movimientos" class="submit" value="Consultar Movimientos" tabIndex="48" /> 
							<input type="submit" id="pagar" name="pagar" class="submit" value="Pagar" tabIndex="49" /> 
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" /> 
							<a id="enlaceTicket" target="_blank">
								<button type="button" id="impTicket" name="impTicket" class="submit" value="Imp. Ticket">Imprimir</button>
							</a>
						</td>

					</tr>
				</table>
				<input id="numeroTransaccion" name="numeroTransaccion" size="12" type="hidden" readOnly="true" disabled="true" /> <input id="exigibleDiaPago" name="exigibleDiaPago" size="12" type="hidden" readOnly="true" disabled="true" />
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
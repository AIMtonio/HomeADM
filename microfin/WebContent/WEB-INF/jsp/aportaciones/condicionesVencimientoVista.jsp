<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/aportacionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/condicionesVencimServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposAportacionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/operacionesFechasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tasasAportacionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
		<script type="text/javascript" src="js/utileria.js"></script>
		<script type="text/javascript" src="js/aportaciones/condicionesVencimiento.js"></script>
		<script type="text/javascript" src="js/soporte/mascara.js"></script>
		<script type="text/javascript" src="js/general.js"></script>
	</head>
<body>
<div id="contenedorForma">
<fieldset class="ui-widget ui-widget-content ui-corner-all"  width="100%" >
<legend class="ui-widget ui-widget-header ui-corner-all">Condiciones de Vencimiento</legend>
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="aportacionesBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend >Datos Generales</legend>
		<table border="0" width="1150px">
			<tr>
				<td class="label">
					<label for="aportacionID">Aportaci&oacute;n: </label>
				</td>
				<td>
					<form:input type="text" name="aportacionID" id="aportacionID" path="aportacionID" size="11" maxlength="11"  autocomplete="off" tabindex="1" />
				</td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td class="label">
					<label><s:message code="safilocale.cliente"/>: </label>
				</td>
				<td>
					<form:input type="text" name="clienteID" id="clienteID" path="clienteID" size="11" maxlength="11" tabIndex= "2" readonly="true"  disabled="true"  autocomplete="off" />
					<input type="text" name="nombreCliente" id="nombreCliente" path="nombreCliente" size="50"   readonly="true"  disabled="true" />
				</td>
				<td class="separador"></td>
				<td class="label">
					<label>Fecha Vencimiento: </label>
				</td>
				<td>
					<form:input type="text" name="fechaVencimiento" id="fechaVencimiento" path="fechaVencimiento"  size="15" maxlength="11" tabIndex= "3" readonly="true"  disabled="true" autocomplete="off" />
				</td>
			</tr>
			<tr>
				<td class="label">
					<label>Capital: </label>
				</td>
				<td>
					<form:input type="text" name="capital" id="capital"  path="monto"  size="11" maxlength="11" tabIndex= "4" readonly="true" disabled="true" autocomplete="off" esMoneda="true" style="text-align: right;"/>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label>Inter&eacute;s: </label>
				</td>
				<td>
					<form:input type="text" name="interes" id="interes"  path="interesGenerado"  size="15" maxlength="11" tabIndex= "5" readonly="true" disabled="true" autocomplete="off" esMoneda="true" style="text-align: right;"/>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label>ISR: </label>
				</td>
				<td>
					<form:input type="text" name="isr" id="isr" path="isrRetener" size="15" maxlength="11" tabIndex= "6" readonly="true" disabled="true" autocomplete="off" esMoneda="true" style="text-align: right;"/>
				</td>
			</tr>
			<tr>
				<td class="label">
					<label>Plazo: </label>
				</td>
				<td>
					<form:input type="text" name="plazo" id="plazo"  path="plazoOriginal" size="11" maxlength="11" tabIndex= "7" readonly="true"  disabled="true" autocomplete="off"/>
					<label>D&iacute;as </label>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label>Tasa: </label>
				</td>
				<td>
					<form:input type="text" name="tasa" id="tasa" path="tasaFija"  size="15" maxlength="11" tabIndex= "8" readonly="true"  disabled="true" autocomplete="off" esTasa="true" style="text-align: right;"/>
					<label>%</label>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label>Tasa ISR: </label>
				</td>
				<td>
					<form:input type="text" name="tasaISR" id="tasaISR" path="tasaISR" size="15" maxlength="11" tabIndex= "9" readonly="true"  disabled="true" autocomplete="off" esTasa="true" style="text-align: right;"/>
					<label>%</label>
				</td>
			</tr>
				<td class="label">
					<label>Capitaliza Inter&eacute;s: </label>
				</td>
				<td>
					<table border="0">
					<tr>
						<td>
							<form:input type="radio" name="capitalizaSi" id="capitalizaSi" path="capitaliza"  value="S" disabled="true" tabindex="10"/><label>Si<br>
						</td>
						<td>
							<form:input type="radio" name="capitalizaNo" id="capitalizaNo" path="capitaliza" value="N" disabled="true" tabindex="11" checked="true"/><label>No</label>
						</td>
					</tr>
					</table>
				</td>
				<td class="separador"></td>
				<td>
					<label>Tipo de Pago:</label>
				</td>
				<td>
					<select id="tipoPago" name="tipoPago" path="tipoPagoInt" readonly="true" disabled="true" tabindex="12">
						<option value="N">SELECCIONAR</option>
						<option value="V">AL VENCIMIENTO</option>
						<option value="E">PROGRAMADO</option>
					</select>
				</td>
				<td class="separador"></td>
				<td id="tdDiaPago">
					<label>D&iacute;a de Pago:</label>
				</td>
				<td>
					<select id="diaPago" name="diaPago" path="diasPagoInt" readonly="true" disabled="true" tabindex="13">
						<option value="">SELECCIONAR</option>
					</select>
				</td>
			<tr>
				<td class="label" style=" vertical-align: text-top;">
					<label>Notas: </label>
				</td>
				<td colspan="7">
					<table border="0">
						<tr>
							<td>
								<textarea rows="3" cols="60" name="notas" id="notas" path="notas" autocomplete="off" readonly="true"  disabled="true" tabindex="14"></textarea>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="label">
					<label>Reinversi&oacute;n Autom&aacute;tica: </label>
				</td>
				<td>
					<table border="0">
					<tr>
						<td>
							<form:input type="radio" name="reinversionAutomSi" id="reinversionAutomSi" value="S"  path="reinversionAutom" tabindex="15"/><label for="reinversionAutomSi">Si<br>
						</td>
						<td>
							<form:input type="radio" name="reinversionAutomNo" id="reinversionAutomNo" value="N"  path="reinversionAutom" tabindex="16" checked="true"/><label for="reinversionAutomNo">No</label>
						</td>
					</tr>
					</table>
				</td>
			</tr>
			<tr class="siRenovacion" style="display: none;">
				<td >
					<label id="tdTipoReinversion" style="display: none;">Tipo de Reinversi&oacute;n:</label>
				</td>
				<td>
					<select id="reinversion" name="reinversion" path="reinversion" tabindex="17" onchange="limpiaSimulador()" style="display: none;">
						<option value="N">SELECCIONAR</option>
						<option value="C">CAPITAL</option>
						<option value="CI">CAPITAL M&Aacute;S INTER&Eacute;S</option>

					</select>
				</td>
				<td class="separador"></td>
				<td>
					<label id="lblOpcionAport" style="display: none;">Tipo de Aportaci&oacute;n:</label>
				</td>
				<td>
					<select id="opcionAport" name="opcionAport" path="opcionAport" onchange="limpiaSimulador()" tabindex="18" style="display: none;">
						<option value="">SELECCIONAR</option>
					</select>
				</td>
				<td class="separador"></td>
				<td class="consolidarSaldos">
					<label for="consolidarSaldosNo" style="">Consolidar Saldos: </label>
				</td>
				<td class="label consolidarSaldos">
					<form:radiobutton id="consolidarSaldosSi" name="consolidarSaldos" path="consolidarSaldos" value="S" tabindex="25"/>
 					<label for="consolidarSaldosSi">Si</label>
					<form:radiobutton id="consolidarSaldosNo" name="consolidarSaldos" path="consolidarSaldos" value="N" tabindex="25" checked="checked"/>
					<label for="consolidarSaldosNo">No</label>
				</td>
			</tr>
			<tr class="cantidadReno" style="display: none;">
				<td class="separador" colspan="3"></td>
				<td>
					<label for="cantidad" style="">Cantidad: </label>
				</td>
				<td>
					<form:input type="text" name="cantidad" id="cantidad" path="cantidadReno" size="15" onchange="limpiaSimulador()" tabIndex= "19"  autocomplete="off" style="text-align: right;" esMoneda="true" />
				</td>
			</tr>
		</table>
		<br>
		<div id="gridConsolidacion">
		</div>
		<br>
			<fieldset  class="ui-widget ui-widget-content ui-corner-all" id="condicionesNuevaAport" style="display: none;">
			<legend >Condiciones Nueva Aportaci&oacute;n</legend>
				<table border="0">
					<tr>
						<td>
							<label>Monto: </label>
						</td>
						<td>
							<form:input type="text" name="montoNuevaAport" id="montoNuevaAport" path="montoNuevaAport" size="18" maxlength="12" tabIndex= "20" readonly="true"  disabled="true"  autocomplete="off" esMoneda="true" style="text-align: right;" onkeypress="return validaSoloNumero(event,this);"/>
						</td>
						<td class="separador"></td>
						<td>
							<label>Monto Renovaci&oacute;n: </label>
						</td>
						<td>
							<form:input type="text" name="montoRenovNuevaAport" id="montoRenovNuevaAport" path="montoRenovNuevaAport" size="16" maxlength="11" tabIndex= "21" readonly="true"  disabled="true"  autocomplete="off" esMoneda="true" style="text-align: right;"/>
						</td>
						<td class="separador"></td>
						<td>
							<label>Monto Global: </label>
						</td>
						<td>
							<form:input type="text" name="montoGlobalNuevaAport" id="montoGlobalNuevaAport" path="montoGlobalNuevaAport" size="16" maxlength="11" tabIndex= "22" readonly="true"  disabled="true"  autocomplete="off" esMoneda="true" style="text-align: right;"/>
						</td>
					</tr>
					<tr>
						<td>
							<label>Tipo de Pago: </label>
						</td>
						<td>
							<select id="tipoPagoNuevaAport" name="tipoPagoNuevaAport" onchange="limpiaSimulador()" path="tipoPagoNuevaAport" tabindex="23">
								<option value="">SELECCIONAR</option>
							</select>
						</td>
						<td class="separador"></td>
						<td>
							<label id="lblDiaPago" style="display: none;">D&iacute;a de Pago: </label>
						</td>
						<td size="16">
							<select id="diaPagoNuevaAport" name="diaPagoNuevaAport" onchange="limpiaSimulador()" path="diaPagoNuevaAport" tabindex="24" style="display: none;">
								<option value="">SELECCIONAR</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label>Plazo: </label>
						</td>
						<td>
							<form:input type="text" name="plazoNuevaAport" onchange="limpiaSimulador()" id="plazoNuevaAport" path="plazoNuevaAport" size="18" maxlength="11" tabIndex= "25"  autocomplete="off"/>
							<label>D&iacute;as </label>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label>Fecha Inicio: </label>
						</td>
						<td>
							<form:input type="text" name="fechaInicioNuevaAport" id="fechaInicioNuevaAport" path="fechaInicioNuevaAport" size="16" maxlength="11" tabIndex= "26" readonly="true"  disabled="true" autocomplete="off"/>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label>Fecha Vencimiento: </label>
						</td>
						<td>
							<form:input type="text" name="fechaVencimNuevaAport" id="fechaVencimNuevaAport" path="fechaVencimNuevaAport" size="16" maxlength="11" tabIndex= "27" readonly="true"  disabled="true" autocomplete="off"/>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label>Tasa Bruta: </label>
						</td>
						<td>
							<form:input type="text" name="tasaBrutaNuevaAport" onchange="limpiaIntereses()" id="tasaBrutaNuevaAport" path="tasaBrutaNuevaAport" size="18" maxlength="11" tabIndex= "28"  autocomplete="off" esMoneda="true" style="text-align: right;" />
							<label>%</label>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label>Tasa ISR: </label>
						</td>
						<td>
							<form:input type="text" name="tasaISRNuevaAport" id="tasaISRNuevaAport" path="tasaISRNuevaAport" size="16" maxlength="11" tabIndex= "29" readonly="true"  disabled="true" autocomplete="off" esTasa="true" style="text-align: right;"/>
							<label>%</label>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label>Tasa Neta: </label>
						</td>
						<td>
							<form:input type="text" name="tasaNetaNuevaAport" id="tasaNetaNuevaAport" path="tasaNetaNuevaAport" size="16" maxlength="11" tabIndex= "30" readonly="true"  disabled="true" autocomplete="off" esTasa="true" style="text-align: right;"/>
							<label>%</label>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label>Capitaliza Inter&eacute;s: </label>
						</td>
						<td>
							<table border="0">
							<tr>
								<td>
									<form:input type="radio" name="capitalizaNuevaAportSi" id="capitalizaNuevaAportSi" value="S"  path="capitalizaNuevaAport" tabindex="31"/><label>Si<br>
								</td>
								<td>
									<form:input type="radio" name="capitalizaNuevaAportNo" id="capitalizaNuevaAportNo" value="N"  path="capitalizaNuevaAport" tabindex="32" checked="true"/><label>No</label>
								</td>
							</tr>
							</table>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label>GAT Nominal: </label>
						</td>
						<td>
							<form:input type="text" name="gatNominalNuevaAport" id="gatNominalNuevaAport" path="gatNominalNuevaAport" size="16" maxlength="11" tabIndex= "33" readonly="true"  disabled="true" autocomplete="off" esTasa="true" style="text-align: right;" />
							<label>%</label>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label>GAT Real: </label>
						</td>
						<td>
							<form:input type="text" name="gatRealNuevaAport" id="gatRealNuevaAport" path="gatRealNuevaAport" size="16" maxlength="11" tabIndex= "34" readonly="true"  disabled="true" autocomplete="off" esTasa="true" style="text-align: right;" />
							<label>%</label>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label>Inter&eacute;s Generado: </label>
						</td>
						<td>
							<form:input type="text" name="interesGenNuevaAport" id="interesGenNuevaAport" path="interesGenNuevaAport"  esMoneda="true" size="18" maxlength="11" tabIndex= "35" readonly="true"  disabled="true" autocomplete="off" style="text-align: right;" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label>ISR Retener: </label>
						</td>
						<td>
							<form:input type="text" name="isrRetenerNuevaAport" id="isrRetenerNuevaAport" path="isrRetenerNuevaAport"  esMoneda="true" size="16" maxlength="11" tabIndex= "36" readonly="true"  disabled="true" autocomplete="off" style="text-align: right;" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label>Inter&eacute;s Recibir: </label>
						</td>
						<td>
							<form:input type="text" name="intRecibirNuevaAport" id="intRecibirNuevaAport" path="intRecibirNuevaAport" size="16"  esMoneda="true" maxlength="11" tabIndex= "37" readonly="true"  disabled="true" autocomplete="off" style="text-align: right;" />
						</td>
					</tr>
					<tr>
						<table border="0" width="100%">
							<tr>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="label">
									<label>Total a Recibir: </label>
								</td>
								<td>
									<form:input type="text" name="totRecibirNuevaAport" id="totRecibirNuevaAport" path="totRecibirNuevaAport" esMoneda="true" size="16" maxlength="11" tabIndex= "38" readonly="true"  disabled="true" autocomplete="off" style="text-align: right;" />
								</td>
							</tr>
						</table>
						<table>
							<tr>
								<td class="label" style=" vertical-align: text-top;">
									<label>Notas: </label>
								</td>
								<td>
									<textarea rows="3" cols="80" name="notasNuevaAport" maxlength="500" id="notasNuevaAport" path="notasNuevaAport" autocomplete="off" tabIndex= "39" size="500" style="text-transform: uppercase;"></textarea>
								</td>

							</tr>
							<tr>
								<td class="label" style=" vertical-align: text-top;">
									<label id="lblEspecificaciones" style="display: none;">Especificaciones: </label>
								</td>
								<td>
									<textarea rows="3" cols="80" name="especificacionesNuevaAport" id="especificacionesNuevaAport" path="especificacionesNuevaAport" autocomplete="off" tabIndex= "40" readonly="true"  disabled="true" style="display: none;"></textarea>
								</td>
							</tr>
							<tr>
								<td class="label" style="vertical-align: text-top;">
									<label id="lblCondiciones">Condiciones: </label>
								</td>
								<td>
									<textarea rows="3" cols="80" name="condiciones" id="condiciones" path="condiciones" autocomplete="off" tabindex="40" style="text-transform: uppercase;"></textarea>
								</td>
							</tr>
						</table>
						<table border="0" width="100%">
							<tr>
								<td colspan="4"  align="right">
									<input type="button" id="simular" name="simular" class="submit" value="Simular Calendario" tabindex="41"/>
								</td>
							</tr>
						</table>
					</tr>
				</table>
			</fieldset>
			<div id="divContenedorSimulador">
					<br>
					<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend >Calendario de Pagos: </legend>
					<br>
					<div id="contenedorSimulador" style="overflow-y: scroll; width: 1100px; display: none;"></div>
				</fieldset>
			</div>
			<br>
			<br>
			<table border="0" width="100%">
				<tr>
					<td colspan="4"  align="right">
						<input type="submit" id="grabar" name="grabar" class="submit" tabIndex = "42" value="Grabar"/>
						<input type="submit" id="autorizar" name="autorizar" class="submit" tabIndex = "43" value="Autorizar"/>
					</td>
				</tr>
				<tr>
					<td colspan="4"  align="right">
						<input type="hidden" id="diaInhabil" name="diaInhabil"  size="5" readonly="true"  disabled="true"/>
						<input type="hidden" id="totalSaldo" name="totalSaldo"  readonly="true"  disabled="true"/>
						<input type="hidden" id="estatus" name="estatus"  size="5" readonly="true" path="estatus" disabled="true"/>
						<input type="hidden" id="existe" name="existe"  size="5" readonly="true"  disabled="true"/>
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"  size="5" readonly="true"  disabled="true"/>
						<input type="hidden" id="plazoOriginalNuevaAport" name="plazoOriginalNuevaAport" path="plazoOriginalNuevaAport" size="5" readonly="true"  disabled="true"/>
						<input type="hidden" id="aportTipoCapitaliza" name="aportTipoCapitaliza" size="5" readonly="true"  disabled="true"/>
						<input type="hidden" id="simulacion" name="simulacion" size="5" readonly="true"  disabled="true"/>
						<input type="hidden" id="detalle" name="detalle" size="5" readonly="true"  disabled="true"/>
						<input type="hidden" id="grupoAportConsol" name="grupoAportConsol" size="10" readonly="true"  disabled="true"/>
						<input type="hidden" id="tasaMontoGlobal" name="tasaMontoGlobal" size="10" readonly="true"  disabled="true"/>
						<input type="hidden" id="totalFinal" name="totalFinal"  readonly="true"  disabled="true"/>
					</td>
				</tr>
			</table>
		</fieldset>
</fieldset>
</form:form>
</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="mensaje" style="display: none;"></div>
</body>
</html>
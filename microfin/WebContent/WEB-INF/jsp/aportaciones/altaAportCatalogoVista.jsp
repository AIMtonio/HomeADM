<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="js/date.js"></script>
	<script type="text/javascript" src="dwr/interface/aportacionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/operacionesFechasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tiposAportacionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tasasAportacionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/inversionServicioScript.js"></script>
	<script type="text/javascript" src="dwr/interface/plazosPorProductosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="js/soporte/mascara.js"></script>
	<script type="text/javascript" src="js/general.js"></script>
	<script type="text/javascript" src="js/aportaciones/altaAportaciones.js"></script>

	<title>Alta de Aportaci&oacute;n</title>
</head>


<body>
 <div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Aportaci&oacute;n</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST"  commandName="aportacionesBean" >
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend >Datos Generales</legend>
				<table border="0">
					<tr>
						<td class="label">
							<label>Aportaci&oacute;n: </label>
						</td>
						<td>
							<form:input type="text" name="aportacionID" id="aportacionID" path="aportacionID" size="11" maxlength="11"  autocomplete="off" tabindex="1" />
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td class="label">
							<label><s:message code="safilocale.cliente"/>: </label>
						</td>
						<td>
							<form:input type="text" name="clienteID" id="clienteID" size="11" maxlength="11" tabIndex= "2"  autocomplete="off" path="clienteID" />
							<input type="text" name="nombreCompleto" id="nombreCompleto" size="50"   readonly="true"  disabled="true" />
							<input type="hidden" id="socioCliente" name="socioCliente" value="<s:message code="safilocale.cliente"/>" />
						</td>
					</tr>
					<tr>
						<td class="label" style=" vertical-align: text-top;">
							<label>Direcci&oacute;n: </label>
						</td>
						<td>
							<textarea rows="3" cols="80" name="direccion" id="direccion" readonly="true"   autocomplete="off"></textarea>
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" style=" vertical-align: text-top;">
							<label>Tel&eacute;fono: </label><br>
							<label style="margin-top: 8px;display:inline-block;">Apertura: </label>
						</td>
						<td style=" vertical-align: text-top;">
							<input type="text" name="telefono" id="telefono" size="15" readonly="true"   disabled="true" /><br>
							<select id="aperturaAport" name="aperturaAport" tabindex="3" style="margin-top: 8px;">
								<option value="FA">FECHA ACTUAL</option>
								<option value="FP">FECHA POSTERIOR</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>
							<label>Cuenta Cobro: </label>
						</td>
						<td>
							<form:input id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID" size="15" maxlength="18" tabIndex = "6"  autocomplete="off" />
						</td>
						<td class="separador"></td>
						<td>
							<label>Saldo&nbsp;: </label>
						</td>
						<td>
							<input type="text" id="totalCuenta" name="totalCuenta" style="text-align: right;" size="15" readonly="true"  esMoneda="true"  disabled="disabled"/>
							<label id="tipoMoneda"></label>
						</td>
						<td></td>
						<td>
							<input type="hidden" id="tasaFV" name="tasaFV"/>
							<form:input type="hidden" name="monedaID" id="monedaID" path="monedaID" />
						</td>
					</tr>
					<tr>
						<td>
							<label>Tipo de Aportaci&oacute;n:  &nbsp;</label>
						</td>
						<td nowrap="nowrap">
							<form:input id="tipoAportacionID" name="tipoAportacionID" path="tipoAportacionID" tabIndex = "7" size="15" maxlength="11" autocomplete="off" />
							<input type="text" id="descripcion" name="descripcion"  size="40" readonly="true"  disabled="true"/>
							<input type="hidden" id="diaInhabil" name="diaInhabil"  size="5" readonly="true"  disabled="true"/>
							<input type="hidden" id="esDiaHabil" name="esDiaHabil"  size="5" readonly="true"  disabled="true"/>
							<input type="hidden" id="pagoIntCal" name="pagoIntCal"  size="5" readonly="true" />
						</td>
						<td class="separador"></td>
						<td>
							<label>Tipo de Pago:</label>
						</td>
						<td>
							<select id="tipoPagoInt" name="tipoPagoInt" tabindex="8">
								<option value="">SELECCIONAR</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>
							<label id="lbldiasPago">D&iacute;as Pago:</label>
						</td>
						<td>
							<select id="diasPagoInt" name="diasPagoInt" tabindex="9">
							</select>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label id="lbldiasPeriodo" for="diasPeriodo">No. D&iacute;as Periodo:</label>
						</td>
						<td><form:select id="diasPeriodo" name="diasPeriodo" path="diasPeriodo" tabindex="9" >
								<form:option value="">SELECCIONAR</form:option>
							</form:select>
						</td>
					</tr>
				</table>
				<br>
				<table>
					<tr>
						<td colspan="4">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend >Condiciones: </legend>
								<table border="0" width="100%">
									<tr class="trMontoGlobal" style="display: none;">
										<td>
											<label>Monto Global: </label>
										</td>
										<td nowrap="nowrap">
											<form:input name="montoGlobal" id="montoGlobal" size="18" path="montoGlobal" esMoneda="true" autocomplete="off" tabIndex = "10" style="text-align: right;" readonly="true"  disabled="true"/>
										</td>
									</tr>
									<tr>
										<td>
											<label>Monto: </label>
										</td>
										<td nowrap="nowrap">
											<form:input name="monto" id="monto" size="18" path="monto" esMoneda="true" autocomplete="off" tabIndex = "11" style="text-align: right;" />
											<label id="tipoMonedaInv"></label>
										</td>
										<td nowrap="nowrap">
											<label id="lblTasa">Tasa Bruta: </label>
										</td>
										<td nowrap="nowrap">
											<form:input type="text" name="tasaFija" id="tasaFija" path="tasaFija" size="12" readonly="true"  disabled="true"  style="text-align: right;" tabIndex = "15" autocomplete="off"/><label id="lblporcien">%</label>
										</td>
										<td>&nbsp;&nbsp;</td>
										<td nowrap="nowrap">
											<label id="lblInteresGenerado">Inter&eacute;s Generado: </label>
										</td>
										<td>
											<form:input name="interesGenerado" id="interesGenerado" path="interesGenerado" readonly="true"  disabled="true" size="18"   esMoneda="true"  style="text-align: right;"/>
										</td>
										<td colspan="2" >
											<label >Tipo de Reinversi&oacute;n: </label>
										</td>
									</tr>
									<tr>
										<td>
											<label>Plazo: </label>
										</td>
										<td id="tdPlazoOriginal">
											<input id="plazoOriginal" name="plazoOriginal" path="plazoOriginal" tabindex="12" size="10"><label> D&iacute;as</label>
										</td>
										<td id="tdPlazoOriginalIn">
											<input id="plazoOriginalIn" tabindex="12" size="10"/><label> D&iacute;as</label>
										</td>

										<td>
											<label>Tasa ISR: </label>
										</td>
										<td>
											<input type="text" name="tasaISR" id="tasaISR" readonly="true"  disabled="true" value="" size="12"  esTasa="true"  esMoneda="true"  style="text-align: right;"/><label>%</label>
										</td>
										<td>&nbsp;&nbsp;</td>
										<td>
											<label>ISR a Retener: </label>
										</td>
										<td>
											<input  type="text"  name="interesRetener" id="interesRetener" path="interesRetener"  readonly="true"   disabled="true" size="18"  esMoneda="true" style="text-align: right;"/>
										</td>
										<td colspan="2">
											<form:input type="radio" name="reinvertir" id="reinvertirVenSi" value="S" path="reinversion" tabindex="16" /><label id="reinvVenc">Reinvertir al Vencimiento</label>
											<form:input type="radio" name="reinvertir" id="reinvertirPost" value="F" path="reinversion" tabindex="18" /><label id="reinvPost">Posteriormente</label>
										</td>
									</tr>
									<tr>
										<td id="lblDiaPagInteres">
											<label>
												D&iacute;as a Pagar de Inter&eacute;s:
											</label>
										</td>
										<td id="inputDiaPagInt">
											<form:input type="text" name="plazo" id="plazo" path="plazo"  size="18" readOnly="true" disabled="disabled" style="text-align: right;" />
										</td>
										<td id="lblDiaCapInteres">
											<label>
												Capitaliza Inter&eacute;s:
											</label>
										</td>
										<td id="inputDiaCapInt">
											<form:select id="capitaliza" name="capitaliza" path="capitaliza" tabindex="13">
											</form:select>
										</td>
										<td>
											<label>Tasa Neta: </label>
										</td>
										<td>
											<input type="text" name="tasaNeta" id="tasaNeta" size="12" readonly="true"  disabled="true" esTasa="true"  style="text-align: right;"/><label>%</label>
										</td>
										<td>&nbsp;&nbsp;</td>
										<td>
											<label>Inter&eacute;s Recibir: </label>
										</td>
										<td>
											<input type="text"   name="interesRecibir" id="interesRecibir" readonly="true"  disabled="true" size="18"  esMoneda="true"  style="text-align: right;"/>
										</td>
										<td colspan="2" id="tdReinvertirVenNo">
											<form:input type="radio" name="reinvertir" id="reinvertirVenNo" value="N" path="reinversion" tabindex="17"/><label id="reinvVencNo">No Reinvertir</label>
										</td>

									</tr>
									<tr>
										<td nowrap="nowrap">
											<label>Fecha de Inicio: </label>
										</td>
										<td>
											<form:input type="text" name="fechaInicio" id="fechaInicio"	path="fechaInicio" size="18"  autocomplete="off" tabIndex = "17" readonly="true"  disabled="true" esCalendario="true" tabindex="14"/>
										</td>
										<td class="label" nowrap="nowrap">
											<label for="lbconsultaGAT">GAT Nominal: </label>
										</td>
										<td >
											<input type="text" name="valorGat" id="valorGat" size="12" readonly="true"  disabled="true" style="text-align: right;"/><label for="lbconsultaGAT">%</label>
										</td>
										<td class="separador"/>
										<td class="label">
											<label for="valorGatReal">GAT Real: </label>
										</td>
										<td nowrap="nowrap">
											<input type="text" name="valorGatReal" id="valorGatReal"  size="18" readonly="true"  disabled="true" style="text-align: right;"/><label for="valorGatReal">%</label>
										</td>
										<td colspan="2" id="tdTipoReinversion">
											<form:select id="tipoReinversion" name="tipoReinversion" path="reinvertir"/>
										</td>

									</tr>
									<tr id='trVariable'>
										<td nowrap="nowrap">
											<label>Fecha de Vencimiento: </label>
										</td>
										<td nowrap="nowrap">
											<form:input type="text" name="fechaVencimiento" id="fechaVencimiento" path="fechaVencimiento" size="18"  autocomplete="off"  tabIndex = "14" readonly="true" disabled="disabled"/>
										</td>
										<td id="tdlblCalculoInteres">
											<label id="lblCalculoInteres">C&aacute;lculo Inter&eacute;s:</label>
										</td>
										<td id="tdcalculoInteres">
											<input id="desCalculoInteres" type="text" name="desCalculoInteres" size="40" readonly="true"  disabled="true"/>
										</td>
										<td id="tdlblTasaBaseID" nowrap="nowrap">
											<label id="lblTasaBaseID">Tasa Base:</label>
										</td>
										<td id="tdDesTasaBaseID">
											<input id="destasaBaseID" name="destasaBaseID" size="12" readonly="true"  disabled="true"/>
										</td>
										<td id="lblopciones">
											<label>Aportaci&oacute;n: </label>
										</td>
										<td colspan="2" id="opciones">
											<form:select id="opcionAport" name="opcionAport" path="opcionAport" tabindex="20">
											</form:select>
										</td>
										<td class="label" id="lblInvRenovar">
											<label for="invRenovar">Inv. Renovar: </label>
										</td>
										<td nowrap="nowrap" id="tdInvRenovar">
											<input type="text" name="invRenovar" id="invRenovar"  size="18" style="text-align: right;" tabindex = "21"/>
										</td>
										<td class="label" id="lblCant">
											<label for="cantidad">Cantidad: </label>
										</td>
										<td nowrap="nowrap" id="tdCantidadReno">
											<input type="text" name="cantidadReno" id="cantidadReno"  size="18" style="text-align: right;" esMoneda="true" tabindex = "22"/>
										</td>
									</tr>
									<tr id='trVariable1'>
										<td id='tdlblSobreTasa'>
											<label id="lblSobreTasa">Sobre Tasa: </label>
										</td>
										<td>
											<form:input type="text" name="sobreTasa" id="sobreTasa" path="sobreTasa" size="12" readonly="true" esTasa="true"  style="text-align: right;"/>
										</td>
										<td >
											<label id="lblPisoTasa">Piso Tasa: </label>
										</td>
										<td>
											<form:input type="text" name="pisoTasa" id="pisoTasa" path="pisoTasa" size="12" readonly="true" esTasa="true"  style="text-align: right;"/>
										</td>
										<td></td>
										<td >
											<label id="lblTehoTasa">Techo Tasa: </label>
										</td>
										<td>
											<form:input type="text" name="techoTasa" id="techoTasa" path="techoTasa" size="12" readonly="true" esTasa="true"  style="text-align: right;"/>
										</td>
									</tr>
									<tr>
										<td colspan="7">&nbsp;</td>
										<td align="right" nowrap="nowrap">
											<label>Total a Recibir: </label>
										</td>
										<td>
											<input type="text" name="granTotal" id="granTotal" readonly="true"  esMoneda="true"	size="25"   style="text-align: right;" tabindex="22" />
										</td>
									</tr>
									<tr style="align-content: left;">
										<td>
											<label  id="labelNotas" for="lblNotas">Notas: </label>
										</td>
										<td colspan="6" style="padding: 2px;">
											<textarea id="notas" name="notas" rows="2" cols="52"
														style="margin: 2px; width: 100%; height: 64px;" maxlength="500" onblur=" ponerMayusculas(this);" tabindex="23">
											</textarea>
										</td>
									</tr>
									<tr class="tablaComentario" style="align-content: left;">
										<td>
											<label  id="labelHistorialCom" for="lblComentarios">Especificaciones: </label>
										</td>
										<td colspan="6" style="padding: 2px;">
											<textarea id="comentAport" name="comentAport" disabled rows="2" cols="52" style="margin: 2px; width: 100%; height: 64px;" ></textarea>
										</td>
									</tr>
									<tr>
										<td colspan="8">&nbsp;</td>
										<td align="right">
											<input type="button" id="simular" name="simular" class="submit" value="Simular Calendario" tabindex="24"/>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
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
										<form:input id="cajaRetiro" name="cajaRetiro" path="cajaRetiro" size="4" tabindex="25" maxlength="11" />
										<input type="text" id="nombreCaja" name="nombreCaja" size="47" readOnly="true" />
									</td>
								</tr>
								</table>
							</fieldset>
						</td>
					</tr>
				</table>
				<br>
				<div id="contenedorSim">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend >Calendario de Pagos: </legend>
						<br>
						<div id="contenedorSimulador" style="overflow-y: scroll; width: 1100px; height: 400px;display: none;"></div>
					</fieldset>
				</div>
				<table border="0" width="100%">
					<tr>
						<td colspan="4"  align="right">
							<input type="submit" id="agrega" name="agrega" class="submit" tabIndex = "26" value="Agregar" disabled="disabled" />
							<input type="submit" id="modificar" name="modificar" class="submit" tabIndex = "27" value="Modificar" disabled="disabled" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
							<input type="hidden" id="tasaFV" name="tasaFV"/>
							<input type="hidden" id="calculoInteres" name="calculoInteres"/>
							<input type="hidden" id="tasaBaseID" name="tasaBaseID"/>
							<input type="hidden" id="valorTasaBaseID" name="valorTasaBaseID"/>
							<input type="hidden" id="relaciones" name="relaciones"/>
							<input type="hidden" id="segmentacion" name="segmentacion"/>
							<input type="hidden" id="productoSAFI" name="productoSAFI" />
							<input type="hidden" id="tipoPersona" name="tipoPersona" />
							<input type="hidden" id="espTasa" name="espTasa" />
							<input type="hidden" id="maxPuntos" name="maxPuntos" />
							<input type="hidden" id="minPuntos" name="minPuntos" />
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	<br>
</fieldset>
</div>


<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="mensaje" style="display: none;"></div>

</body>
</html>

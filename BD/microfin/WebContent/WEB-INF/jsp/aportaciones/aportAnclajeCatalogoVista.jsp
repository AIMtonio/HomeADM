<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="js/date.js"></script>
	<script type="text/javascript" src="js/soporte/mascara.js"></script>
	<script type="text/javascript" src="dwr/interface/aportacionesAnclajeServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tiposAportacionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tasasAportacionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/aportacionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/operacionesFechasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
 	<script type="text/javascript" src="dwr/interface/identifiClienteServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>

	<script type="text/javascript" src="js/aportaciones/aportacionesAnclaje.js"></script>

	    <script type="text/javascript" src="js/general.js"></script>
    <script type="text/javascript" src="js/generarRFC.js"></script>


<title>Anclaje de Aportaci&oacute;n</title>
</head>
<body>
 <div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Anclaje de Aportaciones</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST"   commandName="aportacionesAnclajeBean" >
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend >Datos Generales</legend>
				<table border="0" width="100%">
					<tr>
						<td>
							<label for="aportAnclajeID" >Aportaci&oacute;n Anclar: </label>
						</td>

						<td>
							<form:input type="text" name="aportAnclajeID" id="aportAnclajeID" path="aportAnclajeID" size="11"  autocomplete="off" tabindex="1" />

						<td class="separador"></td>

						<td>
							<label for="aportacionOriID">Aportaci&oacute;n Madre: </label>
						</td>

						<td>
							<form:input type="text" name="aportacionOriID" id="aportacionOriID" path="aportacionOriID" size="11"  autocomplete="off" tabindex="2" />
							<input type="hidden" id="estatus" name="estatus"  size="5" readonly="true" />
						</td>
					</tr>

					<tr>
						<td>
							<label><s:message code="safilocale.cliente"/>: </label>
						</td>

						<td colspan="4">
							<form:input type="text" name="clienteID" id="clienteID" size="11" autocomplete="off" path="clienteID" readonly="true"  disabled="true"/>
							<input type="text" name="nombreCompleto" id="nombreCompleto" size="50" readonly="true" disabled="true"/>
						</td>
					</tr>

					<tr style="vertical-align: top;">
						<td colspan="1" nowrap="nowrap">
							<label>Tel&eacute;fono: </label>
						</td>

						<td>
							<input type="text" name="telefono" id="telefono" size="15" readonly="true" disabled="true"/>
						</td>

						<td class="separador"></td>

						<td>
							<label>Direcci&oacute;n: </label>
						</td>

						<td>
							<textarea rows="3" cols="80" name="direccion" id="direccion" readonly="true" autocomplete="off"></textarea>
						</td>
					</tr>

					<tr>
						<td>
							<label>Cuenta Cobro: </label>
						</td>

						<td>
							<input type="text" id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID" size="15" readonly="true"  autocomplete="off" disabled="true"/>
						</td>

						<td class="separador"></td>

						<td>
							<label>Saldo&nbsp;: </label>
						</td>

						<td>
							<input type="text" id="totalCuenta" name="totalCuenta" style="text-align: right;" size="15"  esMoneda="true" readonly="true" disabled="true"/>
							<form:input type="hidden" name="monedaID" id="monedaID" path="monedaID" />
							<label id="tipoMoneda"></label>
						</td>
					</tr>

					<tr>
						<td colspan="5"><br></td>
					</tr>

					<tr>
						<td colspan="5">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend >Aportaci&oacute;n Madre: </legend>
							<table border="0" width="150px">
							<tr >
								<td nowrap="nowrap"><label>Monto Original:</label></td>
								<td nowrap="nowrap">
										<input type="text" name="montOriginal" id="montOriginal"  size="18"  esMoneda="true" autocomplete="off" style="text-align: right;" readonly="true" disabled="true" />
										<input type="hidden" id="motoOr" name="motoOr" size="23"  />
								</td>
								<td class="separador"></td>
								<td nowrap="nowrap"><label>Monto Conjunto:</label></td>
								<td nowrap="nowrap"><input name="montConjuntoF" type="text" id="montConjuntoF"  size="18"  esMoneda="true" autocomplete="off" style="text-align: right;" readonly="true" disabled="true"  /></td>
							</tr>
							<tr>
								<td nowrap="nowrap"><label>Plazo:</label></td>
								<td nowrap="nowrap"><input id="plazoInvOr" type="text" name="plazoInvOr" style="text-align: right;" type="text" readonly="readonly" disabled="true" value="" size="12"></td>
								<td class="separador"></td>
								<td nowrap="nowrap"><label>&Uacute;ltima Tasa Mejorada:</label></td>
								<td nowrap="nowrap"><input type="text" name="nuevaTasa" id="nuevaTasa"  size="12" readonly="true" disabled="true" esTasa = "true"  style="text-align: right;"/><label>%</label></td>
							</tr>
							<tr>
								<td nowrap="nowrap"><label>Tasa:</label></td>
								<td nowrap="nowrap"><input type="text" name="tasaAportOri" id="tasaAportOri"  size="12" readonly="true" disabled="true"  esTasa = "true"  style="text-align: right;"/><label>%</label></td>
								<td class="separador"></td>
								<td nowrap="nowrap"><label>Inter&eacute;s Mejorado:</label></td>
								<td nowrap="nowrap"><form:input type="text" id="nuevoInteresGen" name="nuevoInteresGen" path="nuevoInteresGen" esMoneda="true" style="text-align: right;" readonly="readonly" disabled="true" size="18"/></td>
							</tr>
							<tr>
								<td nowrap="nowrap"><label>Inter&eacute;s Generado:</label></td>
								<td nowrap="nowrap"><input id="interesGenInOri" type="text" name="interesGenInOri" style="text-align: right;" size="18" readonly="true" disabled="true"></td>
								<td class="separador"></td>
								<td nowrap="nowrap"><label>Inter&eacute;s a Recibir Mejorado:</label></td>
								<td nowrap="nowrap"><form:input type="text" id="nuevoInteresRec" name="nuevoInteresRec" path="nuevoInteresRec" esMoneda="true" style="text-align: right;" readonly="readonly" disabled="true" size="18"/></td>
							</tr>
							<tr>
								<td nowrap="nowrap"><label>ISR a Retener:</label></td>
								<td nowrap="nowrap"><input id="interesRetOri" type="text" name="interesRetOri" style="text-align: right;" size="18" readonly="true" disabled="true"></td>
							</tr>
							<tr>
								<td nowrap="nowrap"><label>Inter&eacute;s a Recibir:</label></td>
								<td nowrap="nowrap"><input id="interesRecInOri" type="text" name="interesRecInOri" style="text-align: right;" size="18" readonly="true" disabled="true"></td>
							</tr>
							<tr>
								<td nowrap="nowrap">
									<label>Tipo de Aportaci&oacute;n:</label>
								</td>
								<td nowrap="nowrap">
									<form:input id="tipoAportacionID" name="tipoAportacionID" path="tipoAportacionID"  readonly="true" disabled="true" size="6"  autocomplete="off"/>
									<input type="text" id="descripcion" name="descripcion" readonly="true" size="50" disabled="true"/>
									<input type="hidden" id="diaInhabil" name="diaInhabil"  size="5" readonly="true" />
									<input type="hidden" id="esDiaHabil" name="esDiaHabil"  size="5" readonly="true" />
								</td>
								</tr>
								<tr>
									<td id="lblTasaBase">
										<label>Tasa Base: </label>
									</td>
									<td id="tdTasaBase">
										<input type="text" name="tasaBaseOr" id="tasaBaseOr" path="tasaBaseOr"  size="12" readonly="true"  esMoneda = "true"  readonly="true" disabled="true" />
									</td>
								</tr>

								<tr id="trVariable">
									<td>
										<label>Sobre Tasa:</label>
									</td>

									<td>
										<input type="text" name="sobreTasaOr" id="sobreTasaOr" path="sobreTasaOr" size="12" readonly="true" esMoneda = "true"  style="text-align: right;" readonly="true" disabled="true" /><label>%</label>
									</td>

									<td>
										<label>Piso Tasa: </label>
									</td>

									<td>
										<input type="text" name="pisoTasaOr" id="pisoTasaOr" path="pisoTasaOr"  size="12" readonly="true" esMoneda = "true"  style="text-align: right;" readonly="true" disabled="true"/><label>%</label>
									</td>
								</tr>
								<tr id="trTasaVariable1">
									<td>
										<label>Techo Tasa:</label>
									</td>

									<td>
										<input type="text" name="techoTasaOr" id="techoTasaOr" path="techoTasaOr" size="12" readonly="true" esMoneda = "true"  style="text-align: right;" readonly="true" disabled="true" /><label>%</label>
									</td>
									<td>
										<label>C&aacute;lculo de Inter&eacute;s: </label>
									</td>

									<td>
										<input type="text" name="calculoInteresMa" id="calculoInteresMa"  path="calculoInteresMa" size="33" readonly="true" esMoneda = "true" disabled="true"/>
									</td>

								</tr>
							</table>

							</fieldset>
						</td>
					</tr>

					<tr>
						<td colspan="5"><br></td>
					</tr>

					<tr>
						<td colspan="5">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend >Aportaci&oacute;n Anclar: </legend>
							<table border="0" width="100%">
								<tr>
									<td width="8%">
										<label>Monto: </label>
									</td>

									<td>
										<input type="text" name="montoAnclar" id="montoAnclar" path="montoAnclar"  size="18"  esMoneda="true" autocomplete="off" tabIndex = "3" style="text-align: right;" />
									</td>

									<td class="separador"></td>
								</tr>
							</table>
							</fieldset>
						</td>
					</tr>

					<tr>
						<td colspan="5"><br></td>
					</tr>

					<tr>
						<td colspan="5">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend >Condiciones: </legend>
							<table border="0" width="100%">
								<tr>
									<td nowrap="nowrap">
										<label>Monto: </label>
									</td>

									<td nowrap="nowrap">
										<form:input name="monto" id="monto" size="18" path="monto" esMoneda="true" autocomplete="off" tabIndex = "4" readonly="true" disabled="true" style="text-align: right;" onkeypress="return IsNumber(event)"/>
										<label id="tipoMonedaInv"></label>
									</td>

									<td>&nbsp;&nbsp;</td>
									<td nowrap="nowrap">
										<label id="lblTasa">Tasa Bruta: </label>
									</td>

									<td nowrap="nowrap">
										<form:input type="text" name="tasaBruta" id="tasaBruta" path="tasaBruta" size="12" readonly="true" disabled="true" esTasa = "true"  style="text-align: right;"/><label id="lblporcien">%</label>
									</td>

									<td>&nbsp;&nbsp;</td>

									<td nowrap="nowrap">
										<label id="lblInteresGenerado">Inter&eacute;s Generado: </label>
									</td>

									<td>
										<form:input name="interesGenerado" id="interesGenerado" path="interesGenerado" readonly="true" disabled="true" size="18"   esMoneda="true"  style="text-align: right;"/>
									</td>
								</tr>


								<tr>
									<td nowrap="nowrap">
										<label>Plazo: </label>
									</td>

									<td>
										<form:input name="plazoOriginal" id="plazoOriginal"  path="plazoOriginal" size="18"  autocomplete="off" readonly="true"  disabled="true" style="text-align: right;"/>
									</td>
															<td class="separador"></td>

									<td nowrap="nowrap">
										<label>Tasa ISR: </label>
									</td>

									<td>
										<input type="text" name="tasaISR" id="tasaISR" readonly="true" disabled="true" value="" size="12" esTasa = "true" style="text-align: right;"/><label>%</label>
									</td>

									<td>&nbsp;&nbsp;</td>

									<td nowrap="nowrap">
										<label>ISR a Retener: </label>
									</td>

									<td>
										<form:input name="interesRetener" id="interesRetener" path="interesRetener"  readonly="true"  disabled="true" size="18"  esMoneda="true" style="text-align: right;"/>
									</td>
								</tr>

								<tr>
									<td nowrap="nowrap">
										<label>
											D&iacute;as a Pagar de Inter&eacute;s:
										</label>
									</td>

									<td>
										<form:input type="text" name="plazo" id="plazo" path="plazo"  size="18" readonly="true" disabled="true" style="text-align: right;" />
									</td>
															<td class="separador"></td>

									<td nowrap="nowrap">
										<label>Tasa Neta:</label>
									</td>

									<td>
										<input type="text" name="tasaNeta" id="tasaNeta" size="12" readonly="true" disabled="true"  esTasa="true"  style="text-align: right;"/><label>%</label>
									</td>

									<td>&nbsp;&nbsp;</td>

									<td nowrap="nowrap">
										<label>Inter&eacute;s Recibir: </label>
									</td>

									<td>
										<form:input name="interesRecibir" id="interesRecibir" path="interesRecibir" readonly="true" disabled="true"  size="18"  esMoneda="true"  style="text-align: right;"/>
									</td>

								</tr>

								<tr>
									<td nowrap="nowrap">
										<label>Fecha de Inicio: </label>
									</td>

									<td>
										<form:input type="text" name="fechaInicio" id="fechaInicio"	path="fechaInicio" size="18"  autocomplete="off" readonly="true" disabled="true"/>
									</td>
																<td class="separador"></td>

									<td class="label" nowrap="nowrap">
											<label for="lbconsultaGAT">GAT Nominal: </label>
									</td>

									<td >
										<input type="text" name="valorGat" id="valorGat" size="12" readonly="true" disabled="true"  esTasa="true" style="text-align: right;"/><label for="lbconsultaGAT">%</label>
									</td>

									<td class="separador"/>

									<td class="label" nowrap="nowrap">
										<label for="valorGatReal">GAT Real: </label>
									</td>

									<td nowrap="nowrap">
										<input type="text" name="valorGatReal" id="valorGatReal"  size="18" readonly="true" disabled="true" style="text-align: right;"/><label for="valorGatReal">%</label>
									</td>

									<td nowrap="nowrap">
										<label>Monto Conjunto: </label>
										<form:input type="text" name="montoTotal" id="montoTotal" path="montoTotal" readonly="true"  disabled="true" esMoneda="true" size="18"   style="text-align: right;"/>
									</td>
								</tr>

								<tr>
									<td nowrap="nowrap">
										<label>Fecha de Vencimiento: </label>
									</td>

									<td>
										<form:input type="text" name="fechaVencimiento" id="fechaVencimiento" path="fechaVencimiento" size="18"  autocomplete="off"  readonly="true" disabled="true"/>
									</td>

									<td class="separador"></td>

									<td id="lblCalculoInteres" nowrap="nowrap">
										<label id="lblCalculoInteres">C&aacute;lculo Inter&eacute;s:</label>
									</td>

									<td id="tdcalculoInteres">
										<input id="desCalculoInteres" type="text" name="desCalculoInteres" size="33" readonly="true"/>
									</td>

									<td>
									</td>

									<td id="lblTasaBaseID" nowrap="nowrap">
										<label id="lblTasaBaseID">Tasa Base:</label>
									</td>

									<td id="tdDesTasaBaseID">
										<input id="destasaBaseID" name="destasaBaseID" size="12" readonly="true"/>
									</td>

								</tr>

								<tr id='trVariable2'>
									<td id='tdlblSobreTasa'>
										<label id="lblSobreTasa">Sobre Tasa: </label>
									</td>

									<td>
										<form:input type="text" name="sobreTasa" id="sobreTasa" path="sobreTasa" size="12" readonly="true" disabled="true" esMoneda="true"  style="text-align: right;"/>
									</td>
									<td class="separador"></td>

									<td >
										<label id="lblPisoTasa">Piso Tasa: </label>
									</td>

									<td>
										<form:input type="text" name="pisoTasa" id="pisoTasa" path="pisoTasa" size="12" readonly="true" disabled="true" esMoneda="true"  style="text-align: right;"/>
									</td>

									<td>
									</td>

									<td >
										<label id="lblTehoTasa">Techo Tasa: </label>
									</td>

									<td>
										<form:input type="text" name="techoTasa" id="techoTasa" path="techoTasa" size="12" readonly="true" disabled="true"  esMoneda="true"  style="text-align: right;"/>
									</td>
								</tr>

								<tr>
									<td colspan="7">&nbsp;</td>

									<td align="right">

									</td>
									<td nowrap="nowrap">
									<label>Total a Recibir: </label>
										<form:input type="text" name="granTotal" id="granTotal" path="granTotal" readonly="true" disabled="true"  esMoneda="true"		size="19"   style="text-align: right;"/>
									</td>
								</tr>
							</table>
							</fieldset>
						</td>
					</tr>

					<tr>
						<td colspan="5"><br></td>
					</tr>
				</table>
				<table border="0"  width="100%">
					<tr>
						<td colspan="4"  align="right">
							<input type="submit" id="agrega" name="agrega" class="submit" tabIndex = "8" value="Agregar" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
							<input type="hidden" id="tasaFV" name="tasaFV"/>
							<input type="hidden" id="tasaBaseID" name="tasaBaseID"/>
							<input type="hidden" id="tasaBaseIDOri" name="tasaBaseIDOri"/>
							<input type="hidden" id="valorTasaBaseID" name="valorTasaBaseID"/>
							<input type="hidden" id="calculoInteres" name="calculoInteres"/>
							<input type="hidden" id="calculoInteOri" name="calculoInteOri"/>
							<input type="hidden" id="valorGatOri" name="valorGatOri"/>
							<input type="hidden" id="valorGatRealOri" name="valorGatRealOri"/>
							<input type="hidden" id="montosAnclados" name="montosAnclados"/>
							<input type="hidden" id="interesesAnclados" name="interesesAnclados"/>
							<input type="hidden" id="plazoOriginalMadre" name="plazoOriginalMadre"/>

						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
</fieldset>

</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="mensaje" style="display: none;"></div>

</body>
</html>
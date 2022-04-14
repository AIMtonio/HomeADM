<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/tiposAportacionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tasasAportacionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/aportacionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/inversionServicioScript.js"></script>
    <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/tasasAportacionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
 	<script type="text/javascript" src="js/soporte/mascara.js"></script>
	<script type="text/javascript" src="js/aportaciones/autorizaAportaciones.js"></script>	
	<script type="text/javascript" src="js/contratos/reciboMexiPrevicrem.js"></script> <!-- JS del Recibo de MEXI -->

<title>Autorizaci&oacute;n de Aportaciones</title>
</head>
<body>

	<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Autorizaci&oacute;n de Aportaciones</legend>

		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="aportacionesBean" >

		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend >Datos Generales</legend>
			<table border="0" width="100%">
				<tr>
					<td class="label">
						<label>Aportaci&oacute;n:</label>
					</td>
					<td>
						<form:input type="text" name="aportacionID" id="aportacionID" path="aportacionID" size="11" autocomplete="off" tabIndex="1"/>
					</td>
					<td class="label">
						<label class="label">Estatus:</label>
					</td>
					<td>
						<form:input type="text" name="estatus" id="estatus" path="estatus" size="15" readonly="true" disabled="true" />
					</td>
				</tr>
				<tr>
					<td class="label">
						<label><s:message code="safilocale.cliente"/>:</label>
					</td>
					<td>
						<input type="text" name="clienteID" id="clienteID" size="11" readonly="true" disabled="true" />
						<input type="text" name="nombreCompleto" id="nombreCompleto" size="50" readonly="true" disabled="true" />
					</td>
					<td class="separador"></td>
					<td class="separador"></td>
					<td class="separador"></td>
				</tr>
				<tr >
					<td class="label" style=" vertical-align: text-top;">
						<label>Direcci&oacute;n:</label>
					</td>
					<td>
						<textarea
							rows="3" cols="80" name="direccion" id="direccion" readonly="true">
						</textarea>
					</td>
					<td class="label" style=" vertical-align: text-top;">
						<label>Tel&eacute;fono:</label>
					</td>
					<td style=" vertical-align: text-top;">
						<input type="text" name="telefono" id="telefono" size="15" readonly="true" disabled="true" />
					</td>
				</tr>
				<tr>
					<td nowrap="nowrap">
						<label>Cuenta Cobro:</label>
					</td>
					<td>
						<form:input id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID" size="13" autocomplete="off" readonly="true"  disabled="true" />
					</td>
					<td class="label">
						<label>Saldo&nbsp;:</label>
					</td>
					<td nowrap="nowrap">
						<input type="text" id="saldoCuenta" name="saldoCuenta" style="text-align: right;" size="15" readonly="true"  esMoneda="true" disabled="true" />
						<input type="hidden" name="monedaID" id="monedaID" />
						<label id="tipoMoneda"></label>
					</td>
				</tr>
				<tr>
					<td nowrap="nowrap">
						<label>Tipo de Aportaci&oacute;n:</label>
					</td>
					<td nowrap="nowrap">
						<form:input id="tipoAportacionID" name="tipoAportacionID" path="tipoAportacionID" size="7" autocomplete="off" readonly="true" disabled="true"  />
						<input type="text" id="descripcion" name="descripcion" size="40" readonly="true" disabled="true"/>
					</td>
					<td nowrap="nowrap">
						<label id="lblfechaApertura">Fecha Apertura:</label>
					</td>
					<td nowrap="nowrap">
						<form:input id="fechaApertura" name="fechaApertura" path="fechaApertura" size="20" autocomplete="off" readonly="true" disabled="true"/>
					</td>
				</tr>
				<tr>
					<td>
						<label>Tipo de Pago:</label>
					</td>
					<td>
						<select id="tipoPagoInt" name="tipoPagoInt" tabindex="8">
							<option value="">SELECCIONAR</option>
						</select>
					</td>
					<td>
						<label id="lbldiasPago">D&iacute;as Pago:</label>
					</td>
					<td>
						<select id="diasPagoInt" name="diasPagoInt" tabindex="9">
						</select>
					</td>
				</tr>
			</table>
			<br>
			 <table  border="0" width="100%">
				<tr>
					<td colspan='4' >&nbsp;</td>
				</tr>
				<tr >
					<td colspan="4">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend >Condiciones</legend>
							<table border="0">
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
										<label>Monto:</label>
									</td>

									<td nowrap="nowrap">
										<form:input name="monto" id="monto" size="18" path="monto" esMoneda="true" readonly="true"  disabled="true" style="text-align: right;"/>
										<label id="tipoMonedaInv"></label>
									</td>

									<td nowrap="nowrap">
										<label>Tasa Bruta:</label>
									</td>

									<td nowrap="nowrap">
										<form:input type="text" name="tasaFija" id="tasaFija" path="tasaFija" size="12" style="text-align: right;" readonly="true"  disabled="true" esTasa="true"/><label>%</label>
									</td>

									<td>&nbsp;&nbsp;</td>

									<td nowrap="nowrap">
										<label>Inter&eacute;s Generado:</label>
									</td>
									<td nowrap="nowrap">
										<form:input name="interesGenerado" id="interesGenerado" path="interesGenerado" style="text-align: right;" disabled="true"
													size="18" readonly="true"  esMoneda="true"/>
									</td>

									<td colspan="2" >
											<label >Tipo de Reinversi&oacute;n: </label>
									</td>
								</tr>
								<tr>
									<td>
										<label>Plazo: </label>
									</td>

									<td>
										<form:input name="plazoOriginal" id="plazoOriginal" path="plazoOriginal" size="10" readonly="true" autocomplete="off" style="text-align: right;"  disabled="true" tabIndex="10"  /><label>D&iacute;as</label>
									</td>

									<td nowrap="nowrap">
										<label>Tasa ISR:</label>
									</td>
									<td nowrap="nowrap">
										<form:input type="text" name="tasaISR" id="tasaISR" path="tasaISR" style="text-align: right;"
												 readonly="true" size="12"  disabled="true" esTasa="true"/><label>%</label>
									</td>
									<td>&nbsp;&nbsp;</td>
									<td nowrap="nowrap">
										<label>ISR a Retener: </label>
									</td>
									<td>
										<form:input name="interesRetener" id="interesRetener" path="interesRetener" style="text-align: right;"
													size="18" disabled="true" readonly="true"  esMoneda="true"/>
									</td>

									<td colspan="2">
										<form:input type="radio" name="reinvertir" id="reinvertirVenSi" value="S" path="reinversion" />
										<form:input type="radio" name="reinvertir" id="reinvertirPost" value="F" path="reinversion" tabindex="12" /><label id="reinvPost">Posteriormente</label>
									</td>
								</tr>
								<tr>
									<td nowrap="nowrap">
										<label>
											D&iacute;as a Pagar de Inter&eacute;s:
										</label>
									</td>

									<td>
										<form:input type="text" name="plazo" id="plazo" path="plazo"  disabled="true" size="18" readonly="true" style="text-align: right;" />
									</td>

									<td nowrap="nowrap">
										<label>Tasa Neta:</label>
									</td>

									<td nowrap="nowrap">
										<form:input type="text" name="tasaNeta" id="tasaNeta" path="tasaNeta" disabled="true" style="text-align: right;"
													size="12" readonly="true"   esTasa="true" /><label>%</label>
									</td>

									<td>&nbsp;&nbsp;</td>

									<td nowrap="nowrap">
										<label>Inter&eacute;s Recibir:</label>
									</td>

									<td>
										<form:input name="interesRecibir" id="interesRecibir" path="interesRecibir" style="text-align: right;" disabled="true" size="18" readonly="true"  esMoneda="true"/>
									</td>

									<td colspan="2">
										<form:input type="radio" name="reinvertir" id="reinvertirVenNo" value="N" path="reinversion"/>
									</td>
								</tr>
								<tr>
									<td nowrap="nowrap">
										<label>Fecha de Inicio:</label>
									</td>

									<td>
										<form:input type="text" name="fechaInicio" id="fechaInicio"
														 path="fechaInicio" size="18" readonly="true" disabled="true"/>
									</td>

									<td class="label" nowrap="nowrap">
										<label for="lbconsultaGAT">GAT Nominal: </label>
									</td>

									<td nowrap="nowrap">
										<input type="text" name="valorGat" id="valorGat" size="12" disabled="true" readonly="true" style="text-align: right;"/><label for="lbconsultaGAT">%</label>
									</td>

									<td class="separador"/>

									<td class="label" nowrap="nowrap">
										<label for="valorGatReal">GAT Real: </label>
									</td>

									<td nowrap="nowrap">
										<input type="text" name="valorGatReal" id="valorGatReal"  size="18" disabled="true" readonly="true" style="text-align: right;"/><label for="valorGatReal">%</label>
									</td>

									<td colspan="2">
										<form:select id="tipoReinversion" name="tipoReinversion" path="reinvertir" style="display:none"/>
									</td>
								</tr>
								<tr>
									<td nowrap="nowrap">
										<label>Fecha de Vencimiento:</label>
									</td>
									<td>
										<form:input type="text" name="fechaVencimiento" id="fechaVencimiento"
														 path="fechaVencimiento" size="18" readonly="true" disabled="true" />
									</td>

									<td id="tdlblCalculoInteres" nowrap="nowrap">
										<label id="lblCalculoInteres">C&aacute;lculo Inter&eacute;s:</label>
									</td>

									<td id="tdcalculoInteres">
										<input id="desCalculoInteres" type="text" name="desCalculoInteres" size="4" readonly="true"/>
									</td>

									<td>
									</td>

									<td id="tdlblTasaBaseID" nowrap="nowrap">
										<label id="lblTasaBaseID">Tasa Base:</label>

									</td>

									<td id="tdDesTasaBaseID">
										<input id="tasaBase" name="tasaBase" size="12" readonly="true"/>
									</td>

									<td>&nbsp;&nbsp;</td>
								</tr>
								<tr id='trVariable1'>
									<td id='tdlblSobreTasa' nowrap="nowrap">
										<label id="lblSobreTasa">Sobre Tasa: </label>
									</td>

									<td>
										<form:input type="text" name="sobreTasa" id="sobreTasa" path="sobreTasa" size="12" readonly="true" esTasa="true"  style="text-align: right;"/>
									</td>

									<td nowrap="nowrap">
										<label id="lblPisoTasa">Piso Tasa: </label>
									</td>

									<td>
										<form:input type="text" name="pisoTasa" id="pisoTasa" path="pisoTasa" size="12" readonly="true" esTasa="true"  style="text-align: right;"/>
									</td>

									<td>
									</td>

									<td nowrap="nowrap">
										<label id="lblTehoTasa">Techo Tasa: </label>
									</td>

									<td>
										<form:input type="text" name="techoTasa" id="techoTasa" path="techoTasa" size="12" readonly="true" esTasa="true"  style="text-align: right;"/>
									</td>
								</tr>
								<tr>
									<td id="lblDiaCapInteres">
										<label>
											Capitaliza Inter&eacute;s:
										</label>
									</td>
									<td id="inputDiaCapInt">
										<form:select id="capitaliza" name="capitaliza" path="capitaliza" tabindex="13">
										</form:select>
									</td>
								</tr>
								<tr>
									<td colspan="7">&nbsp;</td>
									<td align="right" nowrap="nowrap">
										<label>Total a Recibir:</label>
									</td>
									<td><input type="text" name="totalRecibir" id="totalRecibir" readonly="true" esMoneda="true" disabled="true" style="text-align: right;"
										size="18"/>
									</td>
								</tr>
							</table>
							<table align="left">
								<tr >
									<td>
										<label  id="labelNotas" for="lblNotas">Notas: </label>
									</td>
									<td class="separador"></td>
									<td colspan="8">&nbsp;</td>
									<td colspan="6" style="padding: 2px;">
										<textarea id="notas" name="notas" rows="2" cols="52" 
													style="margin: 2px; width: 620px; height: 64px;" maxlength="500">
										</textarea>
									</td>
									<td class="separador"></td>
								</tr>
							</table>
							<table align="left" id="tablaComentario">
								<tr  >
									<td>
										<label  id="labelHistorialCom" for="lblComentarios">Especificaciones: </label>	 					
									</td>
									<td>
										<textarea id="comentAport" name="comentAport" disabled rows="2" cols="42" 
													style="margin: 2px; width: 620px; height: 64px;" ></textarea>
									</td>
									<td class="separador"></td>
									<td></td>
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
							 			<form:input id="cajaRetiro" name="cajaRetiro" path="cajaRetiro" size="4" tabindex="14" readonly="true" maxlength="11"/>
										<input type="text" id="nombreCaja" name="nombreCaja" size="47" readOnly="true" />
									</td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
				<tr><td colspan='4'>&nbsp;</td></tr>
			</table>
			<br>
			<div id="contenedorSim">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend >Calendario de Pagos: </legend>
					<br>
					<div id="contenedorSimulador" style="overflow-y: scroll; width: 100%; height: 400px;display: none;"></div>
				</fieldset>
			</div>
		</fieldset>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td colspan="4">
							<table align="right" boder='0'>
								<tr>
									<td align="right">
										<input type="submit" id="autoriza" name="autoriza" class="submit"  value="Autorizar" tabIndex="2" />
		                     			<input type="submit" class="submit" id="imprime" name="imprime"	value="Imp.Pagar&eacute;" tabIndex="3" />
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
										<input type="hidden" id="tipoTasa">
										<input type="hidden" id="sobreTasa">
										<input type="hidden" id="pisoTasa">
										<input type="hidden" id="techoTasa">
										<input type="hidden" id="productoSAFI" name="productoSAFI" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
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

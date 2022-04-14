<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/tipoInstrumServicio.js"></script>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/parametrosAlertasServicio.js"></script>
<script type="text/javascript" src="js/pld/parametrosAlertas.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="alertasAutomaticas">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Par&aacute;metros de Alertas Inusuales</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label" style="width: 20%">
							<label for="tipoPersona">Tipo de Persona:</label>
						</td>
						<td style="width: 22%">
							<form:select id="tipoPersona" path="tipoPersona" name="tipoPersona" tabindex="1" style="width: 85%">
								<form:option value="">SELECCIONAR</form:option>
								<form:option value="F">FÍSICA</form:option>
								<form:option value="M">MORAL</form:option>
								<form:option value="A">FÍSICA CON ACTIVIDAD EMPRESARIAL</form:option>
							</form:select>
						</td>
						<td class="separador" style="width: 5%"></td>
						<td class="label" style="width: 20%">
							<label for="nivelRiesgo">Nivel de Riesgo:</label>
						</td>
						<td style="width: 22%">
							<form:select id="nivelRiesgo" path="nivelRiesgo" name="nivelRiesgo" tabindex="2" style="width: 72%">
								<form:option value="">SELECCIONAR</form:option>
								<form:option value="B">BAJO</form:option>
								<form:option value="M">MEDIO</form:option>
								<form:option value="A">ALTO</form:option>
							</form:select>
						</td>
					</tr>
					<tr class="parametrizacionXTipoNivel">
						<td class="label">
							<label for="folio">Folio: </label>
						</td>
						<td>
							<form:input type="text" id="folioID" name="folioID" path="folioID" size="12" maxlength="4" tabindex="3"/>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="fechaVigencia">Fecha Inicio Vigencia: </label>
						</td>
						<td>
							<form:input type="text" id="fechaVigencia" name="fechaVigencia" path="fechaVigencia" size="12" disabled="true" />
						</td>
					</tr>
					<tr class="parametrizacionXTipoNivel">
						<td class="label" nowrap="nowrap">
							<label for="varPTrans">% Cambio M&iacute;nimo en Depositos/Retiros<br>Declarados Perfil Transaccional:&nbsp;
							</label>
						</td>
						<td>
							<form:input type="text" id="varPTrans" name="varPTrans" path="varPTrans" size="10" tabindex="8" style="text-align:right;" esMoneda="true"/>
							<a href="javaScript:" onclick="ayuda('ayudaID1')"><img src="images/help-icon.gif"></a>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="varPagos">% M&iacute;nimo de Cambio en Pagos Exigibles:&nbsp;
							</label>
						</td>
						<td>
							<form:input type="text" id="varPagos" name="varPagos" path="varPagos" size="10" tabindex="9" style="text-align:right;" esMoneda="true"/>
							<a href="javaScript:" onclick="ayuda('ayudaID2')"><img src="images/help-icon.gif"></a>
						</td>
					</tr>
					<tr class="parametrizacionXTipoNivel">
						<td class="label">
							<label for="varNumDep">% N&uacute;mero de Dep&oacute;sitos Extra:&nbsp;
							</label>
						</td>
						<td>
							<form:input type="text" id="varNumDep" name="varNumDep" path="varNumDep" size="10" tabindex="10" style="text-align:right;" esMoneda="true"/>
							<a href="javaScript:" onclick="ayuda('ayudaID3')"><img src="images/help-icon.gif"></a>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="varNumRet">% N&uacute;mero de Retiros Extra:&nbsp;
							</label>
						</td>
						<td>
							<form:input type="text" id="varNumRet" name="varNumRet" path="varNumRet" size="10" tabindex="11" style="text-align:right;" esMoneda="true"/>
							<a href="javaScript:" onclick="ayuda('ayudaID4')"><img src="images/help-icon.gif"></a>
						</td>
					</tr>
					<tr class="parametrizacionXTipoNivel">
						<td class="label">
							<label for="varPlazo">Plazo M&iacute;nimo de Pago Anticipado en Cuotas Exigibles:
							</label>
						</td>
						<td>
							<form:input type="text" id="varPlazo" name="varPlazo" path="varPlazo" size="10" tabindex="14" style="text-align:right;" esMoneda="true"/>
							<a href="javaScript:" onclick="ayuda('ayudaID5')"><img src="images/help-icon.gif"></a>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="liquidAnticipad">¿Reportar Liquidaci&oacute;n Anticipada?
							</label>
						</td>
						<td>
							<form:radiobutton id="liquidAnticipadS" name="liquidAnticipad" tabindex="15" path="liquidAnticipad" value="S" checked="checked" />
							<label for="liquidAnticipadS">Si</label>
							<form:radiobutton id="liquidAnticipadN" name="liquidAnticipad" tabindex="16" path="liquidAnticipad" value="N" />
							<label for="liquidAnticipadN">No</label>
							<a href="javaScript:" onclick="ayuda('ayudaID1')"><img src="images/help-icon.gif"></a>
						</td>
					</tr>
					<tr class="parametrizacionXTipoNivel trLiqAnticipada">
						<td class="label">
							<label for="varNumDep">% D&iacute;as Liquidaci&oacute;n Anticipada:</label>
						</td>
						<td>
							<form:input type="text" id="porcDiasLiqAnt" name="porcDiasLiqAnt" path="" size="10" tabindex="17" style="text-align:right;" esMoneda="true"/>
							<a href="javaScript:" onclick="ayuda('ayudaID6')"><img src="images/help-icon.gif"></a>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="varNumRet">% Monto Liquidaci&oacute;n Anticipada:</label>
						</td>
						<td>
							<form:input type="text" id="porcLiqAnt" name="porcLiqAnt" path="" size="10" tabindex="18" style="text-align:right;" esMoneda="true"/>
							<a href="javaScript:" onclick="ayuda('ayudaID7')"><img src="images/help-icon.gif"></a>
						</td>
					</tr>
					<tr class="parametrizacionXTipoNivel">
						<td class="label">
							<label for="varNumDep">% Monto Cuota Anticipada:</label>
						</td>
						<td>
							<form:input type="text" id="porcAmoAnt" name="porcAmoAnt" path="" size="10" tabindex="19" style="text-align:right;" esMoneda="true"/>
							<a href="javaScript:" onclick="ayuda('ayudaID8')"><img src="images/help-icon.gif"></a>
						</td>
						<td class="separador" colspan="3"></td>
					</tr>
					<tr class="parametrizacionXTipoNivel">
						<td class="label">
							<label for="estatus">Estatus:</label>
						</td>
						<td>
							<form:select id="estatus" name="estatus" path="estatus" tabindex="-1" disabled="true" style="width: 35%">
								<form:option value="V">VIGENTE</form:option>
								<form:option value="B">BAJA</form:option>
							</form:select>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="tipoInstruMonID">Tipo Instrumento Monetario:</label>
						</td>
						<td nowrap="nowrap">
							<select MULTIPLE id="tipoInstruMonID" name="tipoInstruMonID" path="tipoInstruMonID" size="5" tabindex="20">
							</select>
						</td>
					</tr>
					<tr class="parametrizacionXTipoNivel">
						<td align="right" colspan="5">
							<input type="submit" id="modificar" name="modificar" class="submit" tabindex="50" value="Modificar" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
							<input type="hidden" id="folioVigente" name="folioVigente" />
							<form:input type="hidden" id="folioID" name="folioID" path="folioID" size="5" tabindex="1" />
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
	<div id="mensaje" style="display: none;"></div>
	<div id="ContenedorAyuda" style="display: none;">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Alertas Inusuales</legend>
			<div id="ayudaID1">
				<p>Porcentaje de Holgura que se le da a los Dep&oacute;sitos y Retiros Declarados en el Perfil Transaccional.</p>
			</div>
			<div id="ayudaID2">
				<p>Porcentaje de Holgura que se le da a los Pagos de Cr&eacute;ditos cuando supera más de lo Exigible.</p>
			</div>
			<div id="ayudaID3">
				<p>Porcentaje de Holgura que se le da al N&uacute;mero de Dep&oacute;sitos declarados en el Perfil Transaccional.</p>
			</div>
			<div id="ayudaID4">
				<p>Porcentaje de Holgura que se le da al N&uacute;mero de Retiros declarados en el Perfil Transaccional.</p>
			</div>
			<div id="ayudaID5">
				<p>Plazo en N&uacute;mero de D&iacute;as M&iacute;nimo para Pago anticipado en Cuotas Exigibles. </p>
			</div>
			<div id="ayudaID6">
				<p>Porcentaje de D&iacute;as que se tendr&aacute; permitido Liquidar un Cr&eacute;dito de manera Anticipada.<br>Este Porcentaje es Calculado de acuerdo al Plazo del Cr&eacute;dito.</p>
			</div>
			<div id="ayudaID7">
				<p>Porcentaje calculado sobre el Monto Total del Cr&eacute;dito. Si el Monto de Liquidaci&oacute;n supera el porcentaje permitido se Genera una Alerta.</p>
			</div>
			<div id="ayudaID8">
				<p>Porcentaje calculado sobre el Monto de la Cuota del Cr&eacute;dito. Si el Monto de Pago supera el Monto de la Cuota + Porcentaje Permitido se Genera una Alerta.</p>
			</div>
		</fieldset>
	</div>
</body>
</html>

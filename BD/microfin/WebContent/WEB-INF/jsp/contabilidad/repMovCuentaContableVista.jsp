<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tipoInstrumentosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>
<script type="text/javascript" src="js/contabilidad/reporteMovCuentaContable.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Movimientos por Cuenta Contable</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="reportesContables" target="_blank">
				<table>
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>
									<label>Parámetros</label>
								</legend>
								<table border="0" width="100%">
									<tr>
										<td class="label">
											<label>Fecha Inicial:</label>
										</td>
										<td>
											<form:input type="text" name="fechaIni" id="fechaIni" path="fechaIni" autocomplete="off" esCalendario="true" size="14" tabindex="1" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label>Fecha Final:</label>
										</td>
										<td>
											<form:input type="text" name="fechaFin" id="fechaFin" path="fechaFin" autocomplete="off" esCalendario="true" size="14" tabindex="2" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label>Rango de Cuentas Contables: </label>
										</td>
									</tr>
									<tr>
										<td class="label" valign="top">
											<label>Cuenta Contable Inicial:</label>
										</td>
										<td valign="top">
											<form:input type="text" name="cuentaCompleta" id="cuentaCompleta" path="cuentaCompleta" autocomplete="off" size="25" tabindex="3" maxlength="55" />
											<form:textarea id="desCuentaCompleta" name="desCuentaCompleta" size="40" type="text" path="desCuentaCompleta" readOnly="true" iniForma='false' />
										</td>
									</tr>
									<tr>
										<td class="label" valign="top">
											<label>Cuenta Contable Final:</label>
										</td>
										<td valign="top">
											<form:input type="text" name="cuentaCompletaFin" id="cuentaCompletaFin" path="cuentaCompletaFin" autocomplete="off" size="25" tabindex="4" maxlength="55" />
											<form:textarea id="desCuentaCompletaF" name="desCuentaCompletaF" size="40" type="text" path="desCuentaCompletaF" readOnly="true" iniForma='false' />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label>Instrumento:</label>
										</td>
										<td>
											<form:select name="tipoInstrumentoID" id="tipoInstrumentoID" path="tipoInstrumentoID" tabindex="6">
												<form:option value="0">INDISTINTO</form:option>
											</form:select>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label>Rango Inicial Ins.:</label>
										</td>
										<td>
											<form:input type="text" name="primerRango" id="primerRango" path="primerRango" tabindex="7" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label>Rango Final Ins.:</label>
										</td>
										<td>
											<form:input type="text" name="segundoRango" id="segundoRango" path="segundoRango" tabindex="8" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label>C. Costos Inicial:</label>
										</td>
										<td>
											<form:input type="text" id="primerCentroCostos" name="primerCentroCostos" path="primerCentroCostos" tabindex="9" />
											<input type="text" id="descripcionCenCosIni" name="descripcionCenCosIni" disabled="disabled" size="39">
										</td>
									</tr>
									<tr>
										<td class="label">
											<label>C. Costos Final:</label>
										</td>
										<td>
											<form:input tupe="text" id="segundoCentroCostos" name="segundoCentroCostos" path="segundoCentroCostos" tabindex="10" />
											<input type="text" id="descripcionCenCosFin" name="descripcionCenCosFin" disabled="disabled" size="39">
										</td>
									</tr>
									<tr>
										<td>
											<form:input id="nombreInstitucion" name="nombreInstitucion" size="40" path="nombreInstitucion" type="hidden" />
											<form:input id="nombreusuario" name="nombreusuario" size="25" path="nombreusuario" type="hidden" />
											<form:input id="fechaEmision" name="fechaEmision" size="25" path="fechaEmision" type="hidden" />
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
						<td>
							<table width="100px">
								<tr>
									<td class="label" style="position: absolute; top: 12%;">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend>
												<label>Presentaci&oacute;n</label>
											</legend>
											<input type="radio" id="pdf" name="pdf" value="pdf" checked="checked" /> <label> PDF </label> <br> <input type="radio" id="excel" name="excel" value="excel"> <label> Excel </label>
										</fieldset>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<table align="right" border='0'>
								<tr>
									<td width="350px">&nbsp;</td>
									<td align="right">
										<input type="button" id="generar" name="generar" class="submit" tabindex="13" value="Generar" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</form:form>
		</fieldset>
	</div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista" />
	</div>
</body>
</html>
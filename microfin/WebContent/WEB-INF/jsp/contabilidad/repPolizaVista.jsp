<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tipoInstrumentosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>
<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
<script type="text/javascript" src="js/contabilidad/reportePoliza.js"></script>
<script type="text/javascript" src="js/utileria.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="reportePoliza" target="_blank">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de P&oacute;lizas</legend>
				<table border="0" width="100%">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>Par&aacute;metros</legend>
								<table width="100%">
									<tr>
										<td>
											<label for="fechaInicial">Fecha Inicial:</label>
										</td>
										<td>
											<form:input type="text" name="fechaInicial" id="fechaInicial" path="fechaInicial" autocomplete="off" esCalendario="true" size="14" tabindex="1" />
										</td>
										<td colspan="3"></td>
									</tr>
									<tr>
										<td>
											<label for="fechaFinal">Fecha Final:</label>
										</td>
										<td>
											<form:input type="text" name="fechaFinal" id="fechaFinal" path="fechaFinal" autocomplete="off" esCalendario="true" size="14" tabindex="2" />
										</td>
										<td colspan="3"></td>
									</tr>
									<tr>
										<td>
											<label for="usuarioID">Usuario:</label>
										</td>
										<td nowrap="nowrap">
											<form:input type="text" name="usuarioID" id="usuarioID" path="usuarioID" autocomplete="off" size="12" tabindex="3" />
											<input type="text" id="nomUsuario" name="nomUsuario" autocomplete="off" size="50" />
										</td>
									</tr>
									<tr>
										<td>
											<label for="polizaID">No.Póliza:</label>
										</td>
										<td>
											<form:input type="text" name="polizaID" id="polizaID" path="polizaID" autocomplete="off" size="12" tabindex="3" />
										</td>
										<td colspan="3"></td>
									</tr>
									<tr>
										<td>
											<label for="numeroTransaccion">No.Transacción:</label>
										</td>
										<td>
											<form:input type="text" name="numeroTransaccion" id="numeroTransaccion" path="numeroTransaccion" autocomplete="off" size="12" tabindex="4" />
										</td>
										<td colspan="3"></td>
									</tr>
									<tr>
										<td>
											<label for="monedaID">Moneda:</label>
										</td>
										<td>
											<form:select id="monedaID" name="monedaID" path="monedaID" tabindex="6">
												<form:option value="0">TODAS</form:option>
											</form:select>
										</td>
										<td colspan="3"></td>
									</tr>
									<tr>
										<td>
											<label for="tipoInstrumentoID">Instrumento:</label>
										</td>
										<td>
											<form:select id="tipoInstrumentoID" name="tipoInstrumentoID" path="tipoInstrumentoID" tabindex="7">
												<form:option value="0">INDISTINTO</form:option>
											</form:select>
											<form:input type="text" id="primerRango" name="primerRango" path="primerRango" tabindex="8" />
											<label for="segundoRango">a</label>
											<form:input type="text" id="segundoRango" name="segundoRango" path="segundoRango" tabindex="9" />
										</td>
									</tr>
									<tr>
										<td>
											<label for="primerCentroCostos">C. Costos Inicial:</label>
										</td>
										<td>
											<form:input type="text" id="primerCentroCostos" name="primerCentroCostos" path="primerCentroCostos" tabindex="10" />
											<input type="text" id="descripcionCenCosIni" name="descripcionCenCosIni" disabled="disabled" size="39">
										</td>
									</tr>
									<tr>
										<td>
											<label for="segundoCentroCostos">C. Costos Final:</label>
										</td>
										<td>
											<form:input tupe="text" id="segundoCentroCostos" name="segundoCentroCostos" path="segundoCentroCostos" tabindex="11" />
											<input type="text" id="descripcionCenCosFin" name="descripcionCenCosFin" disabled="disabled" size="39">
										</td>
										<td colspan="3"></td>
									</tr>
									<tr>
										<td>
											<form:input type="hidden" name="nombreInstitucion" id="nombreInstitucion" path="nombreInstitucion" size="12" />
											<form:input type="hidden" name="nombreUsuario" id="nombreUsuario" path="nombreUsuario" size="12" />
											<form:input type="hidden" name="fechaEmision" id="fechaEmision" path="fechaEmision" size="12" />
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
						<td>
							<br>
							<table width="110px">
								<tr>
									<td class="label" style="position: absolute; top: 12%;">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend>
												<label for="pdf">Presentación: </label>
											</legend>
											<input type="radio" id="pdf" name="tipoReporte" value="pdf" tabindex="13" checked />
											<label for="pdf"> PDF </label>
											<br>
											<input type="radio" id="excel" name="tipoReporte" tabindex="12" />
											<label for="excel"> Excel </label>
										</fieldset>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<div>
					<table align="right" width="100%">
						<tr>
							<td align="right">
								<button id="generar" name="generar" tabindex="50" class="submit">Generar</button>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
								<input type="hidden" id="hora" name="hora" size="25">
							</td>
						</tr>
					</table>
				</div>
			</fieldset>
		</form:form>
	</div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
</html>
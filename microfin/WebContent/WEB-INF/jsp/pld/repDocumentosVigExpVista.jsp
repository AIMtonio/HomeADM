<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/estadosPreocupantesServicio.js"></script>
<script type="text/javascript" src="js/pld/repArchivosVigExpira.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="clienteArchivos" target="_blank">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Documentos Vigencia (Comprobante de Domicilio)</legend>
				<table border="0" width="100%">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>
									<label>Par&aacute;metros</label>
								</legend>
								<table border="0" width="100%">
									<tr>
										<td class="label">
											<label for="fechaInicio">Fecha Inicio: </label>
										</td>
										<td>
											<form:input type="text" name="fechaInicio" id="fechaInicio" path="fechaInicio" autocomplete="off" size="12" tabindex="1" esCalendario="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="fechaFinal">Fecha Final: </label>
										</td>
										<td>
											<form:input type="text" name="fechaFinal" id="fechaFinal" path="fechaFinal" autocomplete="off" size="12" tabindex="2" esCalendario="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="sucursal">Sucursal:</label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="sucursal" name="sucursal" size="11" tabindex="3" autocomplete="off" value="" />
											<input type="text" id="nombreSucursal" name="nombreSucursal" disabled="disabled" size="40" value="" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="nivelRiesgo">Nivel de Riesgo:</label>
										</td>
										<td>
											<form:select id="nivelRiesgo" name="nivelRiesgo" path="nivelRiesgo" tabindex="4">
												<form:option value="">SELECCIONAR</form:option>
												<form:option value="T">TODAS</form:option>
												<form:option value="A">ALTO</form:option>
												<form:option value="M">MEDIO</form:option>
												<form:option value="B">BAJO</form:option>
											</form:select>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="estatus">Estatus:</label>
										</td>
										<td>
											<form:select id="estatus" name="estatus" path="estatus" tabindex="5">
												<form:option value="">SELECCIONAR</form:option>
												<form:option value="T">TODAS</form:option>
												<form:option value="E">VENCIDO</form:option>
												<form:option value="V">VIGENTE</form:option>
											</form:select>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td>
							<table width="200px">
								<tr>
									<td class="label">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend>
												<label>Presentaci&oacute;n</label>
											</legend>
											<table style="width: 50%">
												<tr>
													<td>
														<input type="radio" id="excel" name="tipoReporte" value="1" tabindex="6" checked="checked" />
													</td>
													<td>
														<label for="excel"> Excel </label>
													</td>
												</tr>
											</table>
										</fieldset>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<table border="0" width="100%">
					<tr>
						<td colspan="5">
							<table align="right" border='0'>
								<tr>
									<td width="350px">&nbsp;</td>
									<td align="right">
										<input type="button" id="generar" name="generar" class="submit" tabindex="7" value="Generar" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
</html>
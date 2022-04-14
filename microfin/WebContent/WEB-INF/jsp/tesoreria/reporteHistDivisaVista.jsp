<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/divisasServicio.js"></script>
<script type="text/javascript" src="js/utileria.js"></script>
<script type="text/javascript" src="js/tesoreria/repHistDivisas.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="divisas" target="_blank">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Hist&oacute;rico de Divisas</legend>
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
										<td>
											<label for="monedaId">N&uacute;mero de Divisa:</label>
										</td>
										<td nowrap="nowrap">
											<form:input id="monedaId" name="monedaId" path="monedaId" size="11" tabindex="3" iniforma="false" />
											<form:input id="descripcion" name="descripcion" path="descripcion" size="38" disabled="disabled" />
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td>
							<table style="width: 25%">
								<tr>
									<td>
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend>
												<label>Presentaci&oacute;n</label>
											</legend>
											<table style="width: 100%">
												<tr>
													<td>
														<input type="radio" id="excel" name="tipoReporte" value="1" tabindex="2" checked="checked" />
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
					<tr>
						<td align="right" colspan="5">
							<input type="button" id="generar" name="generar" class="submit" tabindex="4" value="Generar" />
						</td>
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
	<div id="mensaje" style="display: none;"></div>
</body>
</html>
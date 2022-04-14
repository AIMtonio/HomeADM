<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/estadosPreocupantesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
<script type="text/javascript" src="js/pld/reporteOpePLD.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="opeInusualesBean" target="_blank">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Operaciones PLD</legend>
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
											<label for="fechaInicio">Tipo de Reporte: </label>
										</td>
										<td>
											<select name="tipoOperacion" id="tipoOperacion" tabindex="1">
												<option value="">SELECCIONAR</option>
												<option value="1">OPERACIONES INUSUALES</option>
												<option value="2">OPERACIONES REELEVANTES</option>
												<option value="3">OPERACIONES INT. PREOCUPANTES</option>
											</select>
										</td>
									</tr>
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
											<label for="estatus">Estatus:</label>
										</td>
										<td>
											<form:select id="estatus" name="estatus" path="estatus" tabindex="4"></form:select>
										</td>
									</tr>
									<tr id="trOperaciones">
										<td class="label" nowrap="nowrap">
											<label for="lblOperaciones">Operaciones de:</label>
										</td>
										<td nowrap="nowrap">
											<form:select id="operaciones" name="operaciones" path="operaciones" tabindex="5">
												<form:option value="">TODOS</form:option>
												<form:option value="C">CLIENTES</form:option>
												<form:option value="U">USUARIOS DE SERVICIOS</form:option>
											</form:select>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
						<td>
							<table width="200px">
								<tr>
									<td class="label" style="position:absolute;top:6%;">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend><label>Presentaci&oacute;n</label></legend>
												<input type="radio" id="excel" name="tipoReporte" value="1" tabindex="6" checked="checked" />
												<label for="excel"> Excel </label>
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
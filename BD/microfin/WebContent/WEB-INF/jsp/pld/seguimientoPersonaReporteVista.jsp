<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
<script type="text/javascript" src="js/pld/seguimientoPersonaReporte.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="seguimientoPersonaRepBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Coincidencias en Listas</legend>
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
											<input type="text" id="fechaInicio" name="fechaInicio" size="12" tabindex="1" esCalendario="true" />
										</td>
										<td class="separador"></td>
									</tr>
									<tr>
										<td class="label">
											<label for="fechaFin">Fecha Final: </label>
										</td>
										<td>
											<input type="text" id="fechaFin" name="fechaFin" size="12" tabindex="2" esCalendario="true" />
										</td>
										<td class="separador"></td>
									</tr>
									<tr id="trOperaciones">
										<td class="label" nowrap="nowrap">
											<label for="lblOperaciones">Operaciones de:</label>
										</td>
										<td nowrap="nowrap">
											<form:select id="operaciones" name="operaciones" path="operaciones" tabindex="3">
												<form:option value="">TODOS</form:option>
												<form:option value="C">CLIENTES</form:option>
												<form:option value="U">USUARIOS DE SERVICIOS</form:option>
											</form:select>
										</td>
									</tr>
								</table>
							</fieldset>
							<table align="left">
								<tr>
									<td class="label">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend>
												<label>Presentaci&oacute;n</label>
											</legend>
											<input type="radio" id="excel" name="tipoReporte" value="1" tabindex="5" /> <label> Excel </label>
										</fieldset>
									</td>
								</tr>
							</table>
							<br> <br>
							<table align="right">
								<tr>
									<td>
										<input type="button" id="generar" name="generar" class="submit" tabIndex="6" value="Generar" />
									</td>
								</tr>
							</table>
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
</body>

</html>
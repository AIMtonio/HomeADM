<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/archivoReelevantesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/periodosReelevantesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/reporteReelevantesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
	<script type="text/javascript" src="js/pld/reporteReelevantes.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="reporteReelevantes">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Operaciones Relevantes</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label"><label for="periodoID">Periodo:</label></td>
						<td><form:select id="periodoID" name="periodoID" path="periodoID" tabindex="1">
								<form:option value="-1">Seleccionar</form:option>
							</form:select></td>
						<td class="separador"></td>
						<td class="label"><label for="anioGeneracion">Año Periodo: </label></td>
						<td><input id="anioGeneracion" name="anioGeneracion" size="8" tabindex="1" esCalendario="true" maxlength="4" disabled="true"/></td>

					</tr>
					<tr>
						<td class="label"><label for="periodoInicio">Fecha Inicial: </label></td>
						<td><form:input id="periodoInicio" name="periodoInicio" path="periodoInicio" size="12" tabindex="2" disabled="true" /></td>
						<td class="separador"></td>
						<td class="label"><label for="fechaGeneracion">Fecha Actual: </label></td>
						<td><form:input id="fechaGeneracion" name="fechaGeneracion" path="fechaGeneracion" size="12" tabindex="1" disabled="true" /></td>
						<td><input id="periodoOculto" name="periodoOculto" size="12" tabindex="1" type="hidden" iniforma="false" /></td>
					</tr>
					<tr>
						<td class="label"><label for="periodoFin">Fecha Final: </label></td>
						<td><form:input id="periodoFin" name="periodoFin" path="periodoFin" size="12" tabindex="3" disabled="true" /></td>
						<td class="separador"></td>
						<td class="label"><label for="archivo">Nombre del Archivo: </label></td>
						<td><form:input id="archivo" name="archivo" path="archivo" size="40" tabindex="4" disabled="true" /> <input id="archivoOculto" name="archivoOculto" size="40" tabindex="4" type="hidden" iniforma="false" /> <input id="periodoFinOculto" name="periodoFinOculto" size="12" tabindex="3" type="hidden" iniforma="false" /></td>
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
				<table align="right">
					<tr>
						<td align="right">
							<input type="button" id="generarNombre" name="generarNombre" class="submit" tabindex="6" value="Generar Nombre"/>
							<input type="submit" id="generarArchivo" name="generarArchivo" class="submit" tabindex="7" value="Generar Archivo" />
							<input type="button" id="generarExcel" name="generarExcel" class="submit" tabindex="8" value="Generar Excel" />
							<input type="button" id="descargar" name="descargar" class="submit" tabindex="9" value="Descargar Archivo PLD" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
						</td>
					</tr>
				</table>
			</fieldset>
			<input type="hidden" id="rutaArchivosPLD" name="rutaArchivosPLD" size="40" tabindex="2" disabled="true" />
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none; position: absolute; z-index: 999;"></div>
</html>
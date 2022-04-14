<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/opeInusualesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
		<script type="text/javascript" src="js/pld/pldOpeInusualesRep.js"></script>
	</head>
<body>
	<div id="contenedorForma">

		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="opeInusuales">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Operaciones Inusuales</legend>

				<table border="0" cellpadding="0" cellspacing="0" width="50%">

					<tr>
						<td class="label">
							<label for="fechaActual">Fecha Actual: </label>
						</td>
						<td class="label">
							<input id="fechaActual" name="fechaActual" size="12" tabindex="1" disabled="true" />
						</td>

					</tr>

					<tr>
						<td class="label">
							<label for="archivo">Nombre del archivo: </label>
						</td>

						<td class="label">
							<form:input id="nombreArchivo" name="nombreArchivo" path="nombreArchivo" size="40" tabindex="2" disabled="true" />

						</td>
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
				<input type="hidden" id="rutaArchivosPLD" name="rutaArchivosPLD" size="40" tabindex="2" disabled="true" />

				<div id="divOperInusuales" name="divOperInusuales" style="display: none;"></div>
				<input type="hidden" id="datosOperInusuales" name="datosOperInusuales" size="20" tabindex="3" disabled="true" />

				<table align="right" id="botonesReporte">
					<tr>
						<td align="right">
							<input type="button" id="generarNombre" name="generarNombre" class="submit" tabindex="5" value="Generar Nombre" />
							<input type="submit" id="generarArchivo" name="generarArchivo" class="submit" tabindex="5" value="Generar Archivo" />
							<input type="button" id="reporteFinalizado" name="reporteFinalizado" class="submit" tabindex="4" value="Registrar Folio SITI" />
							<input type="button" id="generarExcel" name="generarExcel" class="submit" tabindex="7" value="Generar Excel" />
							<input type="button" id="descargar" name="descargar" class="submit" tabindex="8" value="Descargar Archivo PLD" />
							<input type="hidden" id="tipoActualizacion" name="tipoActualizacion" value="0" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="0" />
						</td>

					</tr>
				</table>

			</fieldset>



			<fieldset class="ui-widget ui-widget-content ui-corner-all" id="divFolioSITI" style="display: none;">
				<legend>Registrar Folio SITI</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="80%">
					<tr>
						<td class="label">
							<label for="lblFolio">Folio SITI:</label>
						</td>
						<td>
							<input type="text" id="folioSITI" name="folioSITI" size="60" tabindex="6" maxlength="15" onBlur=" ponerMayusculas(this);" />
						</td>

					</tr>
					<tr>
						<td class="label">
							<label for="lblUsuario">Usuario SITI: </label>
						</td>

						<td>
							<input type="text" id="usuarioSITI" name="usuarioSITI" size="60" tabindex="7" maxlength="15" onBlur=" ponerMayusculas(this);" />
						</td>
					</tr>

				</table>
				<table align="right">
					<tr>
						<td>
							<input type="submit" id="guardar" name="guardar" class="submit" tabindex="8" value="Guardar" />
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
</body>
<div id="mensaje" style="display: none;"></div>
</html>
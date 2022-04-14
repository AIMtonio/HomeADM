<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/cargaArchivoMasivoActivoServicio.js"></script>
		<script type="text/javascript" src="js/activos/cargaMasivaActivos.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cargaMasivaActivosBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Carga Masiva de Activos</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="fechaRegistro">Fecha de Registro:</label>
							</td>
							<td class="label">
								<input type="text" name="fechaRegistro" id="fechaRegistro" path="fechaRegistro" esCalendario="true" size="12" tabindex="1" />
							</td>
							<td class="separador">
						</tr>
						<tr>
							<td class="label">
								<label id="labelNombreArchivo" for="nombreArchivo">Nombre del Archivo :&nbsp;</label>
							</td>
							<td class="label">
								<form:input type="text" id="nombreArchivo" name="nombreArchivo" path="" size="35" maxlength="50" tabindex="2" disabled="true" />
								<form:input type="hidden" id="rutaArchivos" name="rutaArchivos" path="" size="30"  maxlength="200" readOnly="true" value=""/>
							</td>
							<td class="separador">
							<td>
								<input type="button"id="adjuntar" name="adjuntar" class="submit" value="Adjuntar" tabindex="3" />
								<a href="javaScript:" onclick="ayuda()"> <img src="images/help-icon.gif"></a>
							</td>
						</tr>
						<tr>
							<td align="right" colspan="4">
								<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="4" />
								<input type="hidden" id="numero" name="numero" size="10" tabindex="4" />
								<input type="hidden" id="transaccionID" name="transaccionID" size="20" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="2" />
								<input type="hidden" id="sucursalID" name="sucursalID"  />
							</td>
						</tr>
					</table>
				</fieldset>
			</form:form>
			</div>
			<div id="ejemploArchivo" style="display: none"></div>
			<div id="cargando" style="display: none;"></div>
			<div id="cajaLista" style="display: none;">
				<div id="elementoLista"></div>
			</div>
			<div id="mensaje" style="display: none;"></div>
	</body>
</html>
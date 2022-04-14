<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/catInstGuardaValoresServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGuardaValoresServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/documentosGuardaValoresServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/catalogoAlmacenesServicio.js"></script>
		<script type="text/javascript" src="js/guardaValores/ubicacionDocumentosGuardaValoresVista.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="documentosGuardaValoresBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Registro de Ubicaci&oacute;n de Documentos</legend>
					<table width="100%">
						<tr>
							<td class="label">
								<label for="tipoInstrumento">Tipo Instrumento:</label>
							</td>
							<td>
								<form:select id="tipoInstrumento" name="tipoInstrumento" path="tipoInstrumento" tabindex="1">
									<form:option value="0">SELECCIONA</form:option>
								</form:select>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="documentoID">No. Documento:</label>
							</td>
							<td>
								<form:input id="documentoID" name="documentoID" path="documentoID" size="12" tabindex="2"  type="text" iniforma="false" autocomplete="off"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="fechaRegistro">Fecha Registro: </label>
							</td>
							<td>
								<form:input id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="12" tabindex="3" type="text" disabled="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="participanteID">Participante:</label>
							</td>
							<td>
								<form:input id="participanteID" name="participanteID" size="12" path="participanteID" tabindex="4" type="text" iniforma="false" disabled="true"/>
								<input id="nombreParticipante" name="nombreParticipante" size="50" type="text" disabled="true" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="numeroInstrumento">No. Instrumento:</label>
							</td>
							<td>
								<form:input id="numeroInstrumento" name="numeroInstrumento" path="numeroInstrumento" size="12" tabindex="5"  type="text" iniforma="false" disabled="true"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="origenDocumento">Origen Documento:</label>
							</td>
							<td>
								<form:input id="origenDocumento" name="origenDocumento" path="origenDocumento" size="63" tabindex="6" maxlength="100" type="text" disabled="true" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="tipoDocumentoID">Tipo Documento:</label>
							</td>
							<td>
								<form:input id="tipoDocumentoID" name="tipoDocumentoID" path="tipoDocumentoID" size="50" tabindex="7" maxlength="100" type="text" disabled="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="nombreDocumento">Documento:</label>
							</td>
							<td>
								<form:input id="nombreDocumento" name="nombreDocumento" path="nombreDocumento" size="63" tabindex="8" maxlength="100" type="text" disabled="true" />
							<td class="separador"></td>
							<td class="label">
								<label for="estatus">Estatus:</label>
							</td>
							<td>
								<form:input id="estatus" name="estatus" path="estatus" size="20" tabindex="9" maxlength="20" type="text" disabled="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="almacenID">No. Almac&eacute;n:</label>
							</td>
							<td>
								<form:input id="almacenID" name="almacenID" size="12" path="almacenID" tabindex="10" type="text" iniforma="false" disabled="true" autocomplete="off"/>
								<input id="nombreAlmacen" name="nombreAlmacen" size="50" type="text" disabled="true"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="ubicacion">Pasillo:</label>
							</td>
							<td>
								<textarea id="ubicacion" name="ubicacion" path="ubicacion" tabindex="11" cols="48" rows="2" onblur=" ponerMayusculas(this);" maxlength="500" disabled="true" class="valid" autocomplete="off"></textarea>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="seccion">Caj&oacute;n:</label>
							</td>
							<td>
								<textarea id="seccion" name="seccion" path="seccion" tabindex="12" cols="60" rows="2" onblur=" ponerMayusculas(this);" maxlength="500" disabled="true" class="valid" autocomplete="off"></textarea>
							</td>
						</tr>
					</table>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					<input type="hidden" id="sucursalID" name="sucursalID"/>
					<input type="hidden" id="tipoMensaje"  value="<s:message code='safilocale.cliente'/>" />
					<div id="guardar">
						<table align="right">
							<tr>
								<td align="right">
									<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="13" />
								</td>
								<td align="right">
									<input type="submit" id="cancelar" name="cancelar" class="submit" value="Cancelar" tabindex="16" />
								</td>
							</tr>
						</table>
					</div>
				</fieldset>
			</form:form>
		</div>

		<div id="cargando" style="display: none;">
		</div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
		</div>
	</body>
	<div id="mensaje" style="display: none;"/>
</html>
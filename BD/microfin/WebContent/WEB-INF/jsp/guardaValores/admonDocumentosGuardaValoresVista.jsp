<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/documentosGuardaValoresServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/catInstGuardaValoresServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/catalogoMovGuardaValoresServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposDocumentosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGuardaValoresServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clasificaGrpDoctosServicio.js"></script>
		<script type="text/javascript" src="js/guardaValores/admonDocGuardaValoresVista.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="documentosGuardaValoresBean" >
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Administraci&oacute;n de Documentos</legend>
					<br>
					<table width="100%">
						<tr>
							<td class="label">
								<label for="catMovimientoID">Tipo Movimiento: </label>
							</td>
							<td>
								<form:select id="catMovimientoID" name="catMovimientoID" path="catMovimientoID" tabindex="1">
									<form:option value="">SELECCIONAR</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="tipoInstrumento">Tipo Instrumento:</label>
							</td>
							<td>
								<form:select id="tipoInstrumento" name="tipoInstrumento" path="tipoInstrumento" tabindex="2">
									<form:option value="0">SELECCIONA</form:option>
								</form:select>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="documentoID">No. Documento:</label>
							</td>
							<td>
								<form:input id="documentoID" name="documentoID" path="documentoID" size="12" tabindex="3"  type="text" iniforma="false" autocomplete="off" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="fechaRegistro">Fecha Registro: </label>
							</td>
							<td>
								<form:input id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="12" tabindex="4" type="text" disabled="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="participanteID">Participante:</label>
							</td>
							<td>
								<form:input id="participanteID" name="participanteID" size="12" path="participanteID" tabindex="5" type="text" iniforma="false" disabled="true"/>
								<input id="nombreParticipante" name="nombreParticipante" size="50" type="text" disabled="true" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="numeroInstrumento">No. Instrumento:</label>
							</td>
							<td>
								<form:input id="numeroInstrumento" name="numeroInstrumento" path="numeroInstrumento" size="12" tabindex="6"  type="text" iniforma="false" disabled="true"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="origenDocumento">Origen Documento:</label>
							</td>
							<td>
								<form:input id="origenDocumento" name="origenDocumento" path="origenDocumento" size="63" tabindex="7" maxlength="100" type="text" disabled="true" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="tipoDocumentoID">Tipo Documento:</label>
							</td>
							<td>
								<form:input id="tipoDocumentoID" name="tipoDocumentoID" path="tipoDocumentoID" size="40" tabindex="8" maxlength="100" type="text" disabled="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="nombreDocumento">Documento:</label>
							</td>
							<td>
								<form:input id="nombreDocumento" name="nombreDocumento" path="nombreDocumento" size="63" tabindex="9" maxlength="100" type="text" disabled="true" />
							<td class="separador"></td>
							<td class="label">
								<label for="estatus">Estatus:</label>
							</td>
							<td>
								<form:input id="estatus" name="estatus" path="estatus" size="20" tabindex="10" maxlength="20" type="text" disabled="true" />
							</td>
						</tr>

						<form:input type="hidden" id="usuarioAutorizaID" name="usuarioAutorizaID" path="usuarioAutorizaID"/>
						<form:input type="hidden" id="usuarioDevolucionID" name="usuarioDevolucionID" path="usuarioDevolucionID"/>
					</table>
					<br>
					<div id="movimientos">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend id="labelTitulo">Movimiento</legend>
							<table>
								<tr>
									<td class="label">
										<label for="fechaMovimiento">Fecha Movimiento: </label>
									</td>
									<td>
										<input id="fechaMovimiento" name="fechaMovimiento" path="fechaMovimiento" size="12" tabindex="12" type="text" disabled="true" />
									</td>
								</tr>
								<tr>
									<td class="label" id="lblSeccionPrestamo">
										<label for="usuarioPrestamoID">Usuario Pr&eacute;stamo:</label>
									</td>
									<td id="lblSeccionPrestamo2">
										<form:input id="usuarioPrestamoID" name="usuarioPrestamoID" size="12" path="usuarioPrestamoID" tabindex="11" type="text" iniforma="false" disabled="true"/>
										<input id="nombreUsuarioPrestamoID" name="nombreUsuarioPrestamoID" size="50" type="text" disabled="true" />
									</td>
									<td class="label" id="lblTipoDocumentoSusticionID">
										<label for="tipoDocumentoSusticionID">Documento a Sustituir:</label>
									</td>
									<td id="lblTipoDocumentoSusticionID2">
										<form:input id="docSustitucionID" name="docSustitucionID" path="docSustitucionID" size="12" tabindex="11" type="text" iniforma="false" disabled="true"/>
										<form:input id="nombreDocSustitucion" name="nombreDocSustitucion" path="nombreDocSustitucion" size="50" type="text"  tabindex="12" maxlength="50" disabled="true"  onblur=" ponerMayusculas(this);" />
									</td>
									<td id="comboSustitucion">
										<select id="listaComboDigitaliza" name="listaComboDigitaliza" path="listaComboDigitaliza" style= "display:none; width:100%;" tabindex="11" onblur="consultaComboDigital(this.id)" >
											<option value="0">SELECCIONA</option>
										</select>
									</td>
									<td class="separador" id="labelSeparador"></td>
									<td class="label">
										<label for="observaciones">Motivo:</label>
									</td>
									<td>
										<textarea id="observaciones" name="observaciones" path="observaciones" tabindex="13" cols="48" rows="2" onblur=" ponerMayusculas(this);" maxlength="500" disabled="true" class="valid"></textarea>
									</td>
								</tr>
								<form:input type="hidden" id="archivoID" name="archivoID" path="archivoID" value="0"/>
							</table>
						</fieldset>
					</div>
					<br>
					<div id="autorizacion">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend>Autorizacion</legend>
							<table>
								<tr>
									<td class="label">
										<label for="claveUsuario">Usuario:</label>
									</td>
									<td>
										<form:input id="claveUsuario" name="claveUsuario" path="claveUsuario" size="25" maxlength="45" iniForma="false" type="password" tabindex="14" autocomplete="off"  disabled="true" class="valid"/>
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="contrasenia">Contrase&ntilde;a:</label>
									</td>
									<td>
										<form:input id="contrasenia" name="contrasenia" size="25" path="contrasenia" maxlength="45" iniForma="false" type="password" tabindex="15" autocomplete="off"  disabled="true" class="valid"/>
									</td>
								</tr>
							</table>
						 </fieldset>
					</div>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					<input type="hidden" id="prestamoDocGrdValoresID" name="prestamoDocGrdValoresID"/>
					<input type="hidden" id="sucursalID" name="sucursalID"/>
					<input type="hidden" id="origenDocumentoID" name="origenDocumentoID"/>
					<input type="hidden" id="grupoDocumentoID" name="grupoDocumentoID"/>
					<input type="hidden" id="productoCreditoID" name="tipoPersona" size="50" />
					<input type="hidden" id="manejaCheckList" name="manejaCheckList" size="50" />
					<input type="hidden" id="manejaDigitalizacion" name="manejaDigitalizacion" size="50" />
					<input type="hidden" id="tipoMensaje"  value="<s:message code='safilocale.cliente'/>" />
					<div id="guardar">
						<table align="right">
							<tr>
								<td align="right">
									<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="16" />
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
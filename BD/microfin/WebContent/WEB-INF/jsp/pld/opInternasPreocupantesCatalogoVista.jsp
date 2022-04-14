<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/procInternosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/motivosPreoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/empleadosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/puestosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/categoriasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/estadosPreocupantesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/opIntPreocupantesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/archAdjuntosPLDServicio.js"></script>
<script type="text/javascript" src="js/pld/opIntPreocupantes.js"></script>
<script type="text/javascript" src="js/pld/archivosAdjPLDGrid.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="opIntPreocupantes">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Seguimiento de Operaciones Internas Preocupantes</legend>
				<br>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label">
							<label for="1"></label> <label for="consecutivo">N&uacute;mero: </label>
							<form:input id="opeInterPreoID" name="opeInterPreoID" path="opeInterPreoID" size="5" tabindex="1" />
						</td>
					</tr>
				</table>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Datos Generales del Registro de la Operaci&oacute;n</legend>
					<br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="fecha">Fecha de Captura: </label>
							</td>
							<td>
								<form:input id="fecha" name="fecha" path="fecha" size="12" tabindex="2" disabled="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="fechaDeteccion">Fecha Detecci&oacute;n: </label>
							</td>
							<td>
								<form:input id="fechaDeteccion" name="fechaDeteccion" path="fechaDeteccion" size="12" tabindex="2" disabled="true" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="motivo">Motivo:</label>
							</td>
							<td>
								<form:input id="catMotivPreoID" name="catMotivPreoID" path="catMotivPreoID" size="12" tabindex="3" disabled="true" />
								<textarea id="descripcionMotivo" name="descripcionMotivo" cols="37" rows="2" tabindex="4" readonly="true"></textarea>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="procesoInterno">Proceso Interno:</label>
							</td>
							<td>
								<form:input id="catProcedIntID" name="catProcedIntID" path="catProcedIntID" size="12" tabindex="5" disabled="true" />
								<textarea id="descripcionProceso" name="descripcionProceso" cols="37" rows="2" tabindex="6" readonly="true"></textarea>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="tipoPersona">Tipo Persona:</label>
							</td>
							<td>
								<form:input id="categoriaID" name="categoriaID" path="categoriaID" size="5" tabindex="7" disabled="true" />
								<input type="text" id="descripcionCategoria" name="descripcionCategoria" size="39" tabindex="8" readonly="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="sucursal">Sucursal:</label>
							</td>
							<td>
								<form:input id="sucursalID" name="sucursalID" path="sucursalID" size="5" tabindex="9" disabled="true" />
								<input type="text" id="descripcionSucursal" name="descripcionSucural" size="40" tabindex="10" readonly="true" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="personaReportar">Persona a Reportar:</label>
							</td>
							<td>
								<form:input id="clavePersonaInv" name="clavePersonaInv" path="clavePersonaInv" size="5" tabindex="11" disabled="true" />
								<input type="hidden" id="descripcionSucursal" name="descripcionSucural" size="40" tabindex="12" disabled="true" />
								<form:input id="nomPersonaInv" name="nomPersonaInv" path="nomPersonaInv" size="40" readonly="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="frecuencia">Existe Frecuencia:</label>
							</td>
							<td>
								<form:radiobutton id="frecuencia" name="frecuencia" tabindex="12" path="frecuencia" disabled="true" value="S" />
								<label for="frecuenciaS">Si</label>
								<form:radiobutton id="frecuencia2" name="frecuencia2" tabindex="13" path="frecuencia" disabled="true" value="N" checked="checked" />
								<label for="frecuenciaN">No</label>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="describirFrecuencia" id="descripcionF" style="display: none">Frecuencia:</label>
							</td>
							<td>
								<form:textarea id="desFrecuencia" name="desFrecuencia" cols="50" rows="2" path="desFrecuencia" tabindex="14" readonly="true" style="display: none" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="InvolucraCliente">Involucra <s:message code="safilocale.cliente" />:
								</label>
							</td>
							<td>
								<input id="involucraCliente" type="radio" name="involucraCliente" tabindex="15" value="S" iniforma="false" disabled="true" /> <label for="si">Si</label> <input id="involucraCliente2" type="radio" name="involucraCliente2" tabindex="16" value="N" disabled="true" checked="checked" /> <label for="no">No</label>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="clienteInvolucrado" id="clienteInv" style="display: none">Nombre del <s:message code="safilocale.cliente" />:
								</label>
							</td>
							<td>
								<form:input id="cteInvolucrado" name="cteInvolucrado" path="cteInvolucrado" size="51" tabindex="17" disabled="true" style="display: none" />
							</td>
						</tr>
					</table>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="descripcion">Descripci&oacute;n:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </label>
								<form:textarea id="desOperacion" name="desOperacion" cols="100" rows="5" path="desOperacion" tabindex="19" maxlength="300" readonly="true" />
							</td>
						</tr>
					</table>
					<br>
					<table style="width: 100%">
						<tr>
							<td>
								<div id="gridArchivos" style="width: 100%"></div>
							</td>
						</tr>
						<tr>
							<td class="label" style="text-align: right;" colspan="5">
								<input type="button" id="adjuntar" name="adjuntar" class="submit" tabindex="84" value="Adjuntar" />
							</td>
						</tr>
					</table>
					<br>
					<div id="ActividadesOC">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<br>
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td class="label">
										<label for="estatus">Estado del Registro:</label>
									</td>
									<td>
										<form:select id="estatus" name="estatus" path="estatus" tabindex="1" disabled="true">
											<form:option value="-1">SELECCIONAR</form:option>
										</form:select>
									</td>
									<td></td>
									<td></td>
									<td class="separador"></td>
									<td class="label">
										<label for="fechaCierre">Fecha de Cierre:</label>
										<form:input id="fechaCierre" name="fechaCierre" path="fechaCierre" tabindex="8" size="12" disabled="true" />
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="comentarioOC">Comentario OC:</label>
									<td>
										<form:textarea id="comentarioOC" name="comentarioOC" cols="60" rows="2" path="comentarioOC" tabindex="8" readonly="true" onBlur=" ponerMayusculas(this)" />
									</td>
								</tr>
							</table>
						</fieldset>
					</div>
				</fieldset>
				<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="grabar" name="grabar" class="submit" tabIndex="9" value="Actualizar" /> <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
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
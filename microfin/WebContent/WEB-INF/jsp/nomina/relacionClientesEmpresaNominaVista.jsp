<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/catQuinqueniosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposPuestosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/nominaEmpleadosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tipoEmpleadosConvenioServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/conveniosNominaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="js/nomina/relacionClientesEmpresaNomina.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="empleadoNominaBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Relaci&oacute;n <s:message code="safilocale.cliente"/>s Empresa N&oacute;mina</legend>
					<table border="0" cellpadding="0" cellspacing="0" style="table-layout: fixed;">
						<tr>
							<td>
								<label for="clienteID"><s:message code="safilocale.cliente"/>:</label>
							</td>
							<td>
								<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="10" iniForma='false' maxlength="10" autocomplete="off" />
								<form:input type="text" id="nombreCompleto" name="nombreCompleto" path="nombreCompleto" size="50" disabled="true" />
							</td>

							<td class="separador"></td>

							<td>
								<label for="nominaEmpleadoID">N&uacute;mero:&nbsp;</label>
							</td>
							<td>
								<form:input type="text" id="nominaEmpleadoID" name="nominaEmpleadoID" path="nominaEmpleadoID" size="10" maxlength="9" autocomplete="off" />
							</td>
						</tr>
						<tr>
							<td>
								<label for="institNominaID">Empresa de N&oacute;mina:</label>
							</td>
							<td>
								<form:input type="text" id="institNominaID" name="institNominaID" path="institNominaID" size="10" maxlength="9" autocomplete="off" />
								<form:input type="text" id="nombreInstNomina" name="nombreInstNomina" path="nombreInstNomina" size="50" disabled="true" />
							</td>

							<td class="separador"></td>

							<td>
								<label for="convenioNominaID">No. Convenio:</label>
							</td>
							<td>
								<form:select name="convenioNominaID" id="convenioNominaID" path="convenioNominaID">
									<form:option value="">SELECCIONAR</form:option>
								</form:select>
							</td>
						</tr>
						<tr>
							<td>
								<label for="tipoEmpleadoID">Tipo Empleado:</label>
							</td>
							<td>
								<form:select name="tipoEmpleadoID" id="tipoEmpleadoID" path="tipoEmpleadoID">
									<form:option value="">SELECCIONAR</form:option>
								</form:select>
							</td>

							<td class="separador"></td>

							<td>
								<label for="noEmpleado">No. Empleado:</label>
							</td>
							<td>
								<form:input type="text" id="noEmpleado" name="noEmpleado" path="noEmpleado" size="30" maxlength="30" />
							</td>
						</tr>
						<tr>
							<td>
								<label for="puestoOcupacionID">Puesto:</label>
							</td>
							<td>
								<form:select name="puestoOcupacionID" id="puestoOcupacionID" path="puestoOcupacionID" >
									<form:option value="">SELECCIONAR</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td class="quinquenios">
								<label for="noEmpleado">Quinquenio:</label>
							</td>
							<td class="quinquenios">
								<select id="quinquenioID" name="quinquenioID">
									<option value="">SELECCIONAR</option>
								</select>
							</td>
						</tr>

						<tr>
							<td>
								<label for="puestoOcupacionID">Centro de Adscripción:</label>
							</td>
							<td class="label">
								<textarea id="centroAdscripcion" name="centroAdscripcion"  onblur="ponerMayusculas(this);" rows="4" maxlength="80" cols="50"></textarea>
							</td>
							<td class="separador"></td>
							<td>
								<label for="noEmpleado">Fecha Ingreso:</label>
							</td>
							<td>
								<input type="text" id="fechaIngreso" name="fechaIngreso" size="10" maxlength="10" escalendario="true">
							</td>
						</tr>
						<tr>
						<td>
							<label for="noPension">No Pensi&oacute;n:</label>
						</td>
						<td class="label">
							<input typ="text" id="noPension" name="noPension" maxlength="25" size="25"></textarea>
						</td>
					</tr>
					</table>

					<table border="0" width="100%">
						<tr>
							<td align="right">
								<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" />
								<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar"  />
								<input type="submit" id="eliminar" name="eliminar" class="submit" value="Eliminar" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
								<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>
								<input type="hidden" id="tipoUsuario" value="<s:message code='safilocale.cliente'/>"/>
							</td>
						</tr>
					</table>

					<div id="formaTabla" style="display: none;"></div>
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
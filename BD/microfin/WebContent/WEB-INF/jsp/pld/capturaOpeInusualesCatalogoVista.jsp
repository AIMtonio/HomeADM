<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>

<head>
	<link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon" />
	<title>SAFI - Captura de Operaciones Inusuales</title>
	<link rel="stylesheet" type="text/css" href="css/template.css" media="screen,print" />
	<link rel="stylesheet" type="text/css" href="css/menuTree.css" media="screen,print" />
	<link rel="stylesheet" type="text/css" href="css/redmond/jquery-ui-1.8.13.custom.css" />
	<script type="text/javascript" src="js/jquery-1.5.1.min.js"></script>
	<script type="text/javascript" src="js/jquery.ui.datepicker-es.js"></script>
	<script type="text/javascript" src="js/jquery-ui-1.8.13.custom.min.js"></script>
	<script type="text/javascript" src="js/jquery-ui-1.8.13.min.js"></script>
	<script type="text/javascript" src="js/jquery.validate.js"></script>
	<script type="text/javascript" src="js/jquery.jmpopups-0.5.1.js"></script>
	<script type="text/javascript" src="js/jquery.blockUI.js"></script>
	<link rel="stylesheet" type="text/css" href="css/forma.css" media="all">
	<script type='text/javascript' src='js/jquery.hoverIntent.minified.js'></script>
	<script type="text/javascript" src="js/jquery.plugin.tracer.js"></script>
	<script type="text/javascript" src="dwr/interface/motivosInuServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/procInternosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/empleadosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/puestosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/opIntPreocupantesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/companiasServicio.js"></script>
	<script type="text/javascript" src="dwr/engine.js"></script>
	<script type="text/javascript" src="dwr/util.js"></script>
	<script type="text/javascript" src="js/formaPLD.js"></script>
	<script type="text/javascript" src="js/pld/capturaOpeInusuales.js"></script>
</head>

<body>
	<div id="contenedorForma" style="top: 0px;">
		<label for="desplegado1">Compa&ntilde;ia: </label>
		<select id="desplegado1" name="desplegado1" iniforma="false">
			<option value="">SELECCIONAR</option>
		</select>
		<br>
		<p style="text-align: justify;">Operaci&oacute;n Inusual: Cualquier actividad, conducta, comportamiento o aportaci&oacute;n al capital social de la Entidad que no concuerde con los antecedentes o actividad conocida o declarada por el Socio o Cliente, o con su patr&oacute;n habitual de comportamiento transaccional, en funci&oacute;n al monto, frecuencia, tipo o naturaleza de la Operaci&oacute;n de que se trate, sin que exista una justificaci&oacute;n razonable para dicho comportamiento, o bien, Operaci&oacute;n Inusual es aquella que por cualquier otra causa las Entidades consideren que los recursos pudieran estar destinados a favorecer, prestar ayuda, auxilio o cooperaci&oacute;n de cualquier especie para la comisi&oacute;n del delito previsto en el art&iacute;culo 139 del
			C&oacute;digo Penal Federal o que pudiese ubicarse en alguno de los supuestos del art&iacute;culo 400 Bis del mismo ordenamiento legal.</p>
		<br>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="capturaOperacionInu">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Captura de Operaciones Inusuales</legend>
				<br>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label">
							<label for="consecutivo">N&uacute;mero: </label>
							<form:input id="opeInusualID" name="opeInusualID" path="opeInusualID" size="5" tabindex="1" />
						</td>
					</tr>
				</table>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Datos Generales del Registro de la Operaci&oacute;n</legend>
					<br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label" style="vertical-align: top;" nowrap="nowrap">
								<label for="fechaDeteccion">Fecha Detecci&oacute;n: </label>
							</td>
							<td style="vertical-align: top;">
								<form:input id="fechaDeteccion" name="fechaDeteccion" path="fechaDeteccion" size="12" tabindex="2" esCalendario="true" />
							</td>
							<td class="separador"></td>
							<td class="label" style="vertical-align: top;">
								<label for="catMotivInuID">Motivo:</label>
							</td>
							<td style="vertical-align: top;" nowrap="nowrap">
								<form:input id="catMotivInuID" name="catMotivInuID" path="catMotivInuID" size="12" tabindex="3" onBlur=" ponerMayusculas(this)" />
								<textarea id="descripcionMotivo" name="descripcionMotivo" cols="37" rows="2" readOnly="true" onBlur=" ponerMayusculas(this)"></textarea>
							</td>
						</tr>
						<tr>
							<td class="label" style="vertical-align: top;" nowrap="nowrap">
								<label for="catProcedIntID">Proceso Interno:</label>
							</td>
							<td style="vertical-align: top;" nowrap="nowrap">
								<form:input id="catProcedIntID" name="catProcedIntID" path="catProcedIntID" size="12" tabindex="5" onBlur=" ponerMayusculas(this)" />
								<textarea id="descripcionProceso" name="descripcionProceso" cols="37" rows="2" readOnly="true" onBlur=" ponerMayusculas(this)"></textarea>
							</td>
							<td class="separador"></td>
							<td class="label" style="vertical-align: top;" nowrap="nowrap">
								<label for="clavePersonaInv">Persona a Reportar:</label>
							</td>
							<td style="vertical-align: top;" nowrap="nowrap">
								<form:input id="clavePersonaInv" name="clavePersonaInv" path="clavePersonaInv" size="12" tabindex="11" />
								<input type="hidden" id="descripcionSucursal" name="descripcionSucural" size="40" tabindex="12" disabled="true" />
								<form:input id="nomPersonaInv" name="nomPersonaInv" path="nomPersonaInv" size="51" maxlength="100" onBlur=" ponerMayusculas(this)" />
								<form:input type="hidden" id="nombresPersonaInv" name="nombresPersonaInv" path="nombresPersonaInv" size="51" maxlength="100" />
								<form:input type="hidden" id="apPaternoPersonaInv" name="apPaternoPersonaInv" path="apPaternoPersonaInv" size="51" maxlength="100" />
								<form:input type="hidden" id="apMaternoPersonaInv" name="apMaternoPersonaInv" path="apMaternoPersonaInv" size="51" maxlength="100" />
								<form:input type="hidden" id="tipoPerSAFI" name="tipoPerSAFI" path="tipoPerSAFI" size="51" maxlength="100" value="CTE" />
							</td>
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="frecuencia2">Existe Frecuencia:</label>
							</td>
							<td nowrap="nowrap">
								<form:radiobutton id="frecuencia" name="frecuencia" tabindex="12" path="frecuencia" value="S" />
								<label for="frecuencia">Si</label>
								<form:radiobutton id="frecuencia2" name="frecuencia2" tabindex="13" path="frecuencia" value="N" checked="checked" />
								<label for="frecuencia2">No</label>
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="desFrecuencia" id="descripcionF" style="display: none">Describir Frecuencia:</label>
							</td>
							<td>
								<form:textarea id="desFrecuencia" name="desFrecuencia" cols="50" rows="2" maxlength="150" path="desFrecuencia" tabindex="14" style="display: none" onBlur=" ponerMayusculas(this)" />
							</td>
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="involucraEmpleado2">Involucra Empleado:</label>
							</td>
							<td nowrap="nowrap">
								<input id="involucraEmpleado" type="radio" name="involucraEmpleado" tabindex="15" value="S" iniforma="false" />
								<label for="involucraEmpleado">Si</label>
								<input id="involucraEmpleado2" type="radio" name="involucraEmpleado2" tabindex="16" value="N" checked="checked" />
								<label for="involucraEmpleado2">No</label>
							</td>
							<td class="separador"></td>
							<td class="label" style="vertical-align: top;" nowrap="nowrap">
								<label for="empInvolucrado" id="empleadoInv" style="display: none">Nombre del Empleado:</label>
							</td>
							<td>
								<form:input id="empInvolucrado" name="empInvolucrado" path="empInvolucrado" size="51" tabindex="17" style="display: none" maxlength="100" onBlur=" ponerMayusculas(this)" />
							</td>
						</tr>
						<tr>
							<td class="label" style="vertical-align: top;">
								<label for="desOperacion">Descripci&oacute;n:</label>
							</td>
							<td colspan="5">
								<form:textarea id="desOperacion" name="desOperacion" cols="100" rows="5" path="desOperacion" tabindex="19" maxlength="300" onBlur=" ponerMayusculas(this)" />
							</td>
						</tr>
					</table>
				</fieldset>
				<table width="100%">
					<tr>
						<td align="right" colspan="5">
							<input type="submit" id="guardar" name="guardar" class="submit" value="Grabar" tabindex="20" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
							<input type="hidden" id="desplegado" name="desplegado" />
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;">
	</div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>

</html>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/pldListasPersBloqServicio.js"></script>
<script type="text/javascript" src="dwr/interface/catTipoListaPLDServicio.js"></script>
<script type="text/javascript" src="js/pld/pldListasPersBloq.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="listasPersBloq">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Listas de Personas Bloqueadas</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label"><label for="personaBloqID">N&uacute;mero:&nbsp;</label></td>
						<td class="label"><form:input type="text" id="personaBloqID" name="personaBloqID" path="personaBloqID" size="10" tabindex="1" /></td>
						<td class="separador"></td>
						<td class="label"><label for="tipoPersona">Tipo Persona: </label></td>
						<td class="label"><form:radiobutton id="persFisica" name="tipoPersona" path="tipoPersona" value="F" tabindex="2" checked="checked" type="radio" /> <label for="persFisica">F&iacute;sica</label>&nbsp;&nbsp; <form:radiobutton id="persMoral" name="tipoPersona" path="tipoPersona" value="M" tabindex="3" type="radio" /> <label for="persMoral">Moral</label></td>
					</tr>
					<tr name="personaFisica">
						<td class="label"><label for="primerNombre">Primer Nombre:&nbsp;</label></td>
						<td><form:input type="text" id="primerNombre" name="primerNombre" path="primerNombre" size="50" maxlength="50" tabindex="4" onBlur=" ponerMayusculas(this)" autocomplete="off" /></td>
						<td class="separador"></td>
						<td class="label"><label for="segundoNombre">Segundo Nombre:&nbsp;</label></td>
						<td><form:input type="text" id="segundoNombre" name="segundoNombre" path="segundoNombre" size="50" maxlength="50" tabindex="5" onBlur=" ponerMayusculas(this)" autocomplete="off" /></td>
					</tr>
					<tr name="personaFisica">
						<td class="label"><label for="tercerNombre">Tercer Nombre:&nbsp;</label></td>
						<td><form:input type="text" id="tercerNombre" name="tercerNombre" path="tercerNombre" size="50" maxlength="50" tabindex="6" onBlur=" ponerMayusculas(this)" autocomplete="off" /></td>
						<td class="separador"></td>
						<td class="label"><label for="apellidoPaterno">Apellido Paterno:&nbsp;</label></td>
						<td><form:input type="text" id="apellidoPaterno" name="apellidoPaterno" path="apellidoPaterno" size="50" maxlength="50" tabindex="7" onBlur=" ponerMayusculas(this)" autocomplete="off" /></td>
					</tr>
					<tr name="personaFisica">
						<td class="label"><label for="apellidoMaterno">Apellido Materno:&nbsp;</label></td>
						<td><form:input type="text" id="apellidoMaterno" name="apellidoMaterno" path="apellidoMaterno" size="50" maxlength="50" tabindex="8" onBlur=" ponerMayusculas(this)" autocomplete="off" /></td>
						<td class="separador"></td>
						<td class="label"><label type="text" for="fechaNacimiento">Fecha de Nacimiento:&nbsp;</label></td>
						<td><form:input type="text" id="fechaNacimiento" name="fechaNacimiento" esCalendario="true" path="fechaNacimiento" size="15" tabindex="9" maxlength="10" autocomplete="off" /></td>
					</tr>
					<tr name="personaFisica">
						<td class="label"><label for="RFC">RFC:&nbsp;</label></td>
						<td><form:input type="text" id="RFC" name="RFC" path="RFC" size="25" onBlur=" ponerMayusculas(this)" tabindex="10" maxlength="13" autocomplete="off" /> <input type="button" id="generar" name="generar" value="Generar" class="submit" /></td>
						<td class="separador"></td>
						<td class="label"><label for="nombresConocidos">Nombres Conocidos:&nbsp;</label></td>
						<td><form:input id="nombresConocidos" name="nombresConocidos" path="nombresConocidos" tabindex="11" size="50" maxlength="100" onBlur=" ponerMayusculas(this)" autocomplete="off" /></td>
					</tr>
					<tr name="personaMoral">
						<td class="label"><label for="razonSocial">Raz&oacute;n Social:</label></td>
						<td><form:input id="razonSocial" name="razonSocial" path="razonSocial" size="50" tabindex="12" onBlur=" ponerMayusculas(this)" maxlength="150" autocomplete="off" /></td>
						<td class="separador"></td>
						<td class="label"><label for="RFCm">RFC:</label></td>
						<td><form:input id="RFCm" name="RFCm" path="RFCm" tabindex="13" maxlength="12" onBlur=" ponerMayusculas(this)" autocomplete="off" /></td>
					</tr>
					<tr>
						<td class="label"><label for="paisID">Pa&iacute;s:&nbsp;</label></td>
						<td><form:input type="text" id="paisID" name="paisID" path="paisID" size="6" tabindex="14" onBlur=" ponerMayusculas(this)" autocomplete="off" /> <input type="text" id="nombrePais" name="nombrePais" size="39" disabled="true" readOnly="true" tabindex="15" /></td>
						<td class="separador"></td>
						<td class="label"><label for="estadoID" id="lblEstado">Estado:&nbsp;</label></td>
						<td nowrap="nowrap"><form:input type="text" id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="15" autocomplete="off" /> <input type="text" id="nombreEstado" name="nombreEstado" size="39" disabled="true" readOnly="true" tabindex="17" /></td>
					</tr>
					<tr>
						<td class="label"><label for="tipoLista">Tipo Lista:</label></td>
						<td><form:input type="text" id="tipoLista" name="tipoLista" path="tipoLista" size="6" tabindex="16" onBlur=" ponerMayusculas(this)" autocomplete="off" /> <input type="text" id="tipoListaDes" name="tipoListaDes" size="45" disabled="true" readOnly="true" /></td>
						<td class="separador"></td>
						<td class="label"><label for="estatus">Estatus:</label></td>
						<td><form:select id="estatus" name="estatus" path="estatus" tabindex="17">
								<form:option value="">SELECCIONAR</form:option>
								<form:option value="A">ACTIVO</form:option>
								<form:option value="I">INACTIVO</form:option>
							</form:select></td>
					</tr>
					<tr>
						<td class="label"><label for="tipoLista">Fecha de Alta:</label></td>
						<td><form:input type="text" id="fechaAlta" name="fechaAlta" path="fechaAlta" size="12" readonly="true" /></td>
						<td class="separador"></td>
						<td class="label"><label for="tipoLista">Fecha de Inactivaci&oacute;n:</label></td>
						<td><form:input type="text" id="fechaInactivacion" name="fechaInactivacion" path="fechaInactivacion" size="12" readonly="true" /></td>
					</tr>
					<tr>
						<td class="label"><label for="tipoLista">Fecha de Reactivaci&oacute;n:</label></td>
						<td><form:input type="text" id="fechaReactivacion" name="fechaReactivacion" path="fechaReactivacion" size="12" readonly="true" /></td>
						<td class="separador"></td>
						<td class="label"><label for="numeroOficio">N&uacute;mero de Oficio:</label></td>
						<td><form:input type="text" id="numeroOficio" name="numeroOficio" path="numeroOficio" size="12" tabindex="18"/></td>
					</tr>
					<tr>
						<td align="right" colspan="5">
							<input type="submit" id="guardar" name="guardar" class="submit" value="Guardar" tabindex="50" />
							<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="51" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="0" />
							<input type="hidden" id="tipoActualizacion" name="tipoActualizacion" value="0" />
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
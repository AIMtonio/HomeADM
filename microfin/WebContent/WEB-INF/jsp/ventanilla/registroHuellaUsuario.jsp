<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/usuarioServicios.js"></script>
		<script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>
		<script type="text/javascript" src="js/soporte/ServerHuella.js"></script>
		<script type="text/javascript" src="js/ventanilla/registroHuellaUsuario.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="huellaDigital">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Huella Usuario de Servicio</legend>

					<table style="margin-top: .5em; min-width: max-content;">
						<tr>
							<td class="label">
								<label for="usuarioID">Usuario Servicio: </label>
							</td>
							<td class="label">
								<form:input id="usuarioID" name="usuarioID" path="usuarioID" size="10" autocomplete="off" tabindex="1"/>
								<input type="text" id="nombreCompleto" name="nombreCompleto" size="40" disabled="true" readonly="true"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="tipoPersona">Tipo de Persona: </label>
							</td>
							<td>
								<input type="text" id="tipoPersona" name="tipoPersona" size="25" disabled="true" readonly="true"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="genero">G&eacute;nero: </label>
							</td>
							<td>
								<input type="text" id="sexo" name="sexo" size="25" disabled="true" readonly="true"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="fechaNacimiento">Fecha de Nacimiento: </label>
							</td>
							<td>
								<input type="text" id="fechaNacimiento" name="fechaNacimiento" size="25" disabled="true" readonly="true"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="estatus">Estatus Huellas: </label>
							</td>
							<td class="label" id="Estatus_Registro_Huella">
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="dedoHuellaUno">Mano Izquierda: </label>
							</td>
							<td>
								<input type="text" id="dedoHuellaUno" name="dedoHuellaUno" size="18" disabled="true" readonly="true"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="dedoHuellaDos">Mano Derecha: </label>
							</td>
							<td>
								<input type="text" id="dedoHuellaDos" name="dedoHuellaDos" size="18" disabled="true" readonly="true"/>
							</td>
						</tr>
					</table>
					<br>
					<table width="100%" >
						<tr>
							<td class="separador">
								<span id="statusSrvHuella"></span>
							</td>

							<td align="right" colspan="3">
								<input type ="button" id="grabar" name="grabar" class="submit" value="Registrar Huella" tabIndex="2"/>
								<input type="hidden" name="" id="ctrlUsuarioID">
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
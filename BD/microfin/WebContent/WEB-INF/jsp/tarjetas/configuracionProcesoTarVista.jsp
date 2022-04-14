<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/tarEnvioCorreoParamServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/configuracionProcesoTarServicio.js"></script>
		<script type="text/javascript" src="js/tarjetas/configuracionProcesoTarVista.js"></script>
	</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="configProcesoTar">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Configuraci&oacute;n Proceso Tarjetas </legend>
			<!--Seccion de configuracion ftp-->
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Configuraci&oacute;n Conexi&oacute;n FTP</legend>
				<table>
					<input type="hidden" id="configFTPProsaID" name="configFTPProsaID" value = "1"/>
					<tr>
						<td class="label">
							<label for="lblServidor">Servidor:</label>
						</td>
						<td>
						  <input id="servidor" name="servidor" size="40" type="text" tabindex="2"
						  maxlength="30"/>
						</td>
						<td class="separador"></td>
					</tr>
					<tr>
						<td class="label">
							<label for="lblPuerto">Puerto:</label>
						</td>
						<td>
						  <form:input id="puerto" name="puerto" path="puerto" size="40" tabindex="3"
						  	maxlength="10"
						  />
						</td>
						<td class="separador"></td>
					</tr>
					<tr>
						<td class="label">
							<label for="lblUsuario">Usuario:</label>
						</td>
						<td>
						  <form:input id="usuario" name="usuario" path="usuario" size="40" tabindex="4"
						  maxlength="40"/>
						</td>
						<td class="separador"></td>
					</tr>
					<tr>
						<td class="label">
							<label for="lblContrasenia">Contraseña:</label>
						</td>
						<td>
							<input type="password" id="contrasenia" name="contrasenia"  size="40"  tabindex="5" maxlength="30"/>
						</td>
						<td class="separador"></td>
					</tr>
					<tr>
						<td class="label">
							<label for="lblRuta">Ruta:</label>
						</td>
						<td>
							<form:input id="ruta" name="ruta" path="ruta" size="40" tabindex="6"
							maxlength="50"
							/>
						</td>
						<td class="separador"></td>
					</tr>
				</table>
				<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="modificarFTP" name="modificarFTP" class="submit" value="Aceptar" tabindex="7"/>
						</td>
					</tr>
				</table>
			</fieldset>
			<!--Fin Seccion de configuracion ftp-->
			<br>
			<!--Seccion de configuracion del horario-->
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Configuraci&oacute;n del Horario</legend>
				<table>
					<tr>
						<td class="label">
							<label for="lblHoraIni">Hora Inicio:</label>
							<form:input type="text" id="horaInicio" name="horaInicio" path="horaInicio" size="20" tabindex="20" maxlength="2"/>



							<label for="lblHoraIntervalo">Intervalo(Min):</label>
							<form:input id="intervaloMin" name="intervaloMin" path="intervaloMin" size="20" tabindex="21" />

							<label for="lblNumIntentos">Num.Intentos:</label>
							<form:input id="numIntentos" name="numIntentos" path="numIntentos" size="15" tabindex="22"/>
						</td>

					</tr>
				</table>
				<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="modificarConfHora" name="modificarConfHora" class="submit" value="Aceptar" tabindex="23"/>
						</td>
					</tr>
				</table>
				<input type="hidden" id="tipoTransaccionFTP" name="tipoTransaccion"/>
			</fieldset>
			<!--Fin Seccion de configuracion del horario-->
			<br>
			<!--Seccion de configuracion de correos-->
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Configuraci&oacute;n de Correos</legend>
				<table>
					<tr>
						<td>
							<label for="lblRemitente">Remitente:</label>
							<form:input id="usuarioRemitente" name="usuarioRemitente" path="" size="6" 	 tabindex="30"
							maxlength="11"/>
			        		<input id="correoRemitente" name="correoRemitente" size="40"
			         		type="text" readOnly="true" disabled="true"
			         		/>
						</td>

					</tr>
					<tr>
						<td>
							<label for="lblNotificarA">Notificar a:</label>
			         		<div id="gridDestinatarios">

							</div>
						</td>
					</tr>
					<tr>
						<td>

							<label for="lblCorreo">Correo:</label>
							<textarea type="text" id="mensajeCorreo" name="mensajeCorreo" path="" size="53" tabindex="35"
							maxlength="800"/>
						</td>
					</tr>
				</table>
				<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="modificaConfCorreo" name="modificaConfCorreo" class="submit" value="Aceptar" tabindex="36"/>
						</td>
					</tr>
				</table>
			</fieldset>
			<!--Fin Seccion de configuracion de correos-->
			<br>
	</fieldset>
	<!--<table align="right">
		<tr>
			<td align="right">
				<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="16"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
			</td>
		</tr>
	</table>-->

</form:form>
</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="ContenedorAyuda" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>

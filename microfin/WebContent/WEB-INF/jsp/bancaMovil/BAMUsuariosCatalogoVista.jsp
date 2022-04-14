<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/perfilServicio.js"></script>
<script type="text/javascript" src="dwr/interface/usuariosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/preguntaServicio.js"></script> 
<script type="text/javascript" src="dwr/interface/imagenAntiphishingServicio.js"></script>  

<script type="text/javascript" src="js/bancaMovil/catalogoUsuarios.js"></script>
<script type="text/javascript" src="js/soporte/mascara.js"></script>

<link rel="stylesheet" type="text/css" href="css/forma.css" media="screen,print"  />
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST"
			commandName="bloDesUsuario" autocomplete = "off">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Usuarios de Banca M&oacute;vil</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">

				</table>
				
				<input type="hidden" id="usuarioID" name="usuarioID" autocomplete="off"  tabindex="1" />
				<input type="hidden" id="imei" name="imei" autocomplete="off"  tabindex="2" />
				<input type="hidden" id="fechaCancel" name="fechaCancel" autocomplete="off"  tabindex="2" />
				<input type="hidden" id="motivoCancel" name="motivoCancel" autocomplete="off"  tabindex="3" />
				<input type="hidden" id="fechaBloqueo" name="fechaBloqueo" autocomplete="off"  tabindex="4" />
				<input type="hidden" id="motivoBloqueo" name="motivoBloqueo" autocomplete="off"  tabindex="5" />
				
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Datos del Usuario</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						
						<tr>
							<td class ="label"> <label for="clienteID"><s:message code="safilocale.cliente"/>:</label></td>
							 <td nowrap="nowrap"><input id="clienteID" name="clienteID" size="12" maxlength="16"  tabindex="6" /> 
							 <input id="nombreCompleto" name="nombreCompleto" readOnly="true" 
							 onBlur="ponerMayusculas(this)" size="50" maxlength="200"/></td>
							 <td class="separador"></td>
							 <td class="label"><label for="email">Email: </label></td>						
							<td>
							<input id="email" name="email" autocomplete="off" size="50" type="email" maxlength="50" tabindex="7" />
							</td>	
						</tr>
						
						<tr>
							<td class="label"><label for="primerNombre">Primer Nombre:</label></td>
							<td><input type="text" id="primerNombre" name="primerNombre" autocomplete="off" size="29"  tabindex="8" /></td>
							 <td class="separador"></td>
							<td class="label"><label for="segundoNombre">Segundo Nombre: </label></td>
							<td><input type="text" id="segundoNombre" name="segundoNombre" autocomplete="off" size="29"  tabindex="9" /></td>
						</tr>
						
						<tr>
							<td class="label"><label for="apellidoPaterno">Apellido Paterno:</label></td>
							<td><input type="text" id="apellidoPaterno" name="apellidoPaterno" autocomplete="off" size="29"  tabindex="10" /></td>
							 <td class="separador"></td>
							<td class="label"><label for="apellidoMaterno">Apellido Materno: </label></td>
							<td><input type="text" id="apellidoMaterno" name="apellidoMaterno" autocomplete="off" size="29"  tabindex="11" /></td>
						</tr>
					
						<tr>
							<td class="label"><label for="telefono">Tel&eacute;fono: </label></td>
							<td><input id="telefono"  placeholder="Cel. a 10 d&iacute;gitos" name="telefono" size="15" maxlength="10" tabindex="12" /></td>	
							<td class="separador"></td>
							<td class="label">
				
						</table>
					</table>
				</fieldset>

					<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Seguridad</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="55%">
							<table border="0"  cellspacing="0">
						<tr>
							<td class="label"> <label for="clave">Clave Usuario: </label> </td>
							<td> <input id="clave" name="clave" autocomplete="nope" type="text" size="15" maxlength="30" tabindex="15" /></td>	
						</tr>
						<tr>
							<td class="label"> <label for="contrasenia">Contraseña: </label> </td>
							<td> <input id="contrasenia" name="contrasenia" autocomplete="nope" type="password" size="15" maxlength="200" tabindex="16" /></td>	
						</tr>
						<tr>
							<td class="label">
							<label for="fraseBienvenida">Frase de Bienvenida: </label>
							</td>
							<td>
							<input id="fraseBienvenida" name="fraseBienvenida" type="text"  size="50" onBlur="ponerMayusculas(this)" maxlength="50" tabindex="17" />
							</td>
						</tr>
						<tr>
							<td class="label"><label for="preguntaSecretaID">Pregunta Secreta: </label></td>
							<td nowrap="nowrap"><input id="preguntaSecretaID" name="preguntaSecretaID" type="text"  size="5" maxlength="20" tabindex="18" iniForma="false" /> 
							<input id="redaccion" type="text"  name="redaccion" readOnly="true" size="44" /></td>
						</tr>
						<tr>
								<td class="label"><label for="respuestaPregSecreta">Rspta. Preg. Secreta: </label></td>
								<td nowrap="nowrap"><input id="respuestaPregSecreta" name="respuestaPregSecreta" type="text" 
								onBlur="ponerMayusculas(this)" size="50" maxlength="100" tabindex="19" /></td>
						</tr>
						</table>
						
						</td>

						<td>
								<table border="0"  cellspacing="0" >
						<tr>
							<td class="label">
								<label for="imgAntif">Imagen Antiphishing: </label>
							</td>	
							<td>
								<img id="imgCliente" src="images/usuario_defecto.png"  width="80" height="80" class="submit" value="Cambiar Imagen" tabindex="20" type="button"/>	
							</td> 
						</tr>
						</table>
						</td>
					</tr>	
					</table>
				</fieldset>

			   <fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>General</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						
						<tr>
							<td class="label"><label for="fechaUltimoAcceso">&Uacute;ltimo Acceso:</label></td>
							<td> <input id="fechaUltimoAcceso" name="fechaUltimoAcceso" readOnly="true" size="29" tabindex="21"/> </td>
							<td class="label"><label for="estatus">Estatus Usuario: </label></td>
							<td><input id="estatus" name="estatus" readOnly="true" size="33" tabindex="22" /></td>
						</tr>

						<tr>
							<td class="label"><label for="fechaCreacion">Fecha de Registro: </label></td>
							<td><input id="fechaCreacion" name="fechaCreacion"readOnly="true" size="29" tabindex="23" /></td>
							<td class="label"><label for="estatusSesion">Estatus Sesion: </label></td>
							<td><input id="estatusSesion" name="estatusSesion" readOnly="true" size="33" tabindex="24" /></td>
						</tr>
						
						<tr>
							<td class="label">
								<label for="servicioBancaMov">Servicio Banca Movil: </label>
							</td>
							<td colspan="1">
								<input type="radio" id="servicioBancaMovS" name="servicioBancaMov" tabindex="25" value="S"/>
								<label>Si</label>
								<input type="radio" id="servicioBancaMovN" name="servicioBancaMov" tabindex="26" value="N" checked="true"/>
								<label>No</label>  
							</td>
							<td class="label">
								<label for="servicioBancaWeb">Servicio Banca Web: </label>
							</td>
							<td colspan="1">
								<input type="radio" id="servicioBancaWebS" name="servicioBancaWeb" tabindex="27" value="S"/>
								<label>Si</label>
								<input type="radio" id="servicioBancaWebN" name="servicioBancaWeb" tabindex="28" value="N" checked="true"/>
								<label>No</label>  
							</td>
						</tr>
						
						<tr>
							<td class="label"><label for="loginsFallidos">Login Fallidos: </label></td>
							<td><input id="loginsFallidos" name="loginsFallidos"readOnly="true" tabindex="29 size="29" /></td>
						</tr>
					
					</table>
				</fieldset>


					<table border="0"  cellspacing="0" width="100%">
							<tr>
								<br>
								<td align="right">
									<div id="conteImagenPhishing" style="overflow: scroll; width: 100%; height: 400px;display: none;"></div>
									<input type="hidden" id="imagenPhishingID" name="imagenPhishingID" size="5" tabindex="30" /> 	
									<input type="submit" id="agrega"name="agrega" class="submit" value="Agregar" tabindex="31" />
									<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="32" /> 
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
									<input type="hidden" id="empresa" name="empresa"/> 
									<input type="hidden" id="perfilID" name="perfilID" value="1"/>
							</tr>
						</table>


		</form:form>
	</div>

<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none; overflow:">
		<div id="elementoLista"></div>
	</div>
	<div id="cajaListaCte"
		style="display: none; overflow-y: scroll; height: 200px;">
		<div id="elementoListaCte"></div>
	</div>
	

</body>

<div id="mensaje" style="display: none;"></div>
</html>
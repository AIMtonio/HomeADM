<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript"
	src="dwr/interface/edoCtaParamsServicio.js"></script>
<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
<script type="text/javascript" src="js/soporte/mascara.js"></script>
<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script> 
<script type="text/javascript" src="js/soporte/EdoCtaParams.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST"
			commandName="edoCtaParamsBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Parámetros
					Estado de Cuenta</legend>

				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Unidad Especializada de Atención a Usuarios (UEAU)</legend>
					<table>
						<tr>
							<td><label for="ciudadUEAU">Entidad Federativa: </label></td>
							<td><form:input id="ciudadUEAUID" name="ciudadUEAUID"
									path="ciudadUEAUID" size="6" tabindex="1" /> <form:input
									type="text" id="ciudadUEAU" name="ciudadUEAU" path="ciudadUEAU"
									size="35" tabindex="2" disabled="true" readOnly="true"
									iniForma="false" /></td>
							<td class="separador"></td>
							<td><label for="telefonoUEAU">Teléfono: </label></td>
							<td><form:input id="telefonoUEAU" name="telefonoUEAU"
									path="telefonoUEAU" size="15" maxlength="10" tabindex="3" /> <label
								for="lblExt">Ext.:</label> <form:input id="extTelefonoPart"
									name="extTelefonoPart" path="extTelefonoPart" size="10"
									maxlength="6" tabindex="4" /></td>
						</tr>
						<tr>
							<td><label for="otrasCiuUEAU">Teléfono Otra Ciudad:
							</label></td>
							<td><form:input id="otrasCiuUEAU" name="otrasCiuUEAU"
									path="otrasCiuUEAU" size="15" maxlength="10" tabindex="5" /> <label
								for="lblExt">Ext.:</label> <form:input id="extTelefono"
									name="extTelefono" path="extTelefono" size="10" maxlength="6"
									tabindex="6" /></td>
							<td class="separador"></td>
							<td><label for="horarioUEAU">Horario de Atención: </label></td>
							<td><textarea id="horarioUEAU" name="horarioUEAU" rows="2"
									cols="40" tabindex="7" onBlur=" ponerMayusculas(this)" /></td>
						</tr>
						<tr>
							<td><label for="correoUEAU">Correo Electrónico: </label></td>
							<td><form:input id="correoUEAU" name="correoUEAU"
									path="correoUEAU" size="46" tabindex="8" /></td>
						</tr>
						<tr>
							<td><label for="direccionUEAU">Dirección: </label></td>
							<td><textarea id="direccionUEAU" name="direccionUEAU"
									rows="3" cols="42" tabindex="9" onBlur=" ponerMayusculas(this)"></textarea>
							</td>
						</tr>
					</table>
				</fieldset>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Cuentas</legend>
					<table>
						<td class="label"><label for="tipoCuentaID">Tipo	Cuentas:</label></td>
				   <td> 
		         	<select MULTIPLE id="tipoCuentaID" name="tipoCuentaID" path="tipoCuentaID"  size="5">
					 </select>	
		     		</td> 
					</table>
				</fieldset>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Rutas de Acceso</legend>
					<table>
						<tr>
							<td class="label"><label for="rutaExpPDF">Generación
									Edo. Cta. (.prpt): </label></td>
							<td><form:input type="text" id="rutaReporte"
									name="rutaReporte" path="rutaReporte" size="55" tabindex="10" />
							</td>
						</tr>
						<tr>
							<td class="label"><label for="rutaReporte">Alojamiento
									Edo. Cta.: </label></td>
							<td><form:input type="text" id="rutaExpPDF"
									name="rutaExpPDF" path="rutaExpPDF" size="55" tabindex="11" />
							</td>
						</tr>
						<tr>
							<td class="label"><label for="rutaCBB">Obtención
									Código Binario (CBB): </label></td>
							<td><form:input type="text" id="rutaCBB" name="rutaCBB"
									path="rutaCBB" size="55" tabindex="12" /></td>
						</tr>
						<tr>
							<td class="label"><label for="rutaCFDI">CFDI: </label></td>
							<td><form:input type="text" id="rutaCFDI" name="rutaCFDI"
									path="rutaCFDI" size="55" tabindex="12" /></td>
						</tr>
						<tr>
							<td class="label"><label for="lblRutaLogo">Ruta
									Logo: </label></td>
							<td><form:input type="text" id="rutaLogo" name="rutaLogo"
									path="rutaLogo" size="55" tabindex="13" /></td>
						</tr>
						<tr>
							<td class="label">
								<label for="envioAut">Habilitar envío de correo selectivo:</label>
							</td>
							<td>
								<input type="radio" id="envioAut" name="envioAutomatico" value="S" tabindex="14">
								<label>Sí</label>
								<input type="radio" name="envioAutomatico" value="N" tabindex="15">
								<label>No</label>
							</td>
						</tr>
						<tr id="correoServidor">
							<td class="label">
								<label for="correoRemitente">Remitente Edo. Cta.:</label>
							</td>
							<td>
								<input type="text" id="correoRemitente" name="correoRemitente" size="35" tabindex="16" maxlength="50"/></td>
							<td class="label">
								<label for="servidorSMTP">Servidor de Correo:</label>
							</td>
							<td>
								<input type="text" id="servidorSMTP" name="servidorSMTP" size="46" tabindex="17" maxlength="50"/>
							</td>
						</tr>
						<tr id="usuarioClave">
							<td class="label">
								<label for="usuarioRemitente">Usuario:</label>
							</td>
							<td>
								<input type="text" id="usuarioRemitente" name="usuarioRemitente" size="35" tabindex="18" maxlength="50"/>
							</td>
							<td class="label">
								<label for="contraseniaRemitente">Contraseña:</label>
							</td>
							<td>
								<input type="password" id="contraseniaRemitente" name="contraseniaRemitente" size="46" tabindex="19" maxlength="50" autocomplete="new-password"/>
							</td>
						</tr>
						<tr id="puertoAsunto">
							<td class="label">
								<label for="puertoSMTP">Puerto:</label>
							</td>
							<td>
								<input type="text" id="puertoSMTP" name="puertoSMTP" size="5" tabindex="20" maxlength="4"/>
							</td>
							<td class="label">
								<label for="asunto">Asunto:</label>
							</td>
							<td>
								<input type="text" id="asunto" name="asunto" size="46" tabindex="21" maxlength="100"/>
							</td>
						</tr>
						<tr>
							<td id="labelReqAut" class="label" style="display: none;">
								<label for="requiereAut">Requiere autentificación:</label>
							</td>
							<td id="reqAut" style="display: none;">
								<input type="radio" id="aut" name="requiereAut" value="S" checked="true" tabindex="22">
								<label>Sí</label>
								<input type="radio" name="requiereAut" value="N" tabindex="23">
								<label>No</label>
							</td>
							<td id="labelAut" class="label">
								<label for="tipoAut">Tipo de Autentificación:</label>
							</td>
							<td>
								<select name="tipoAut" id="tipoAut" tabindex="24">
									<option value="" selected>SELECCIONAR</option>
									<option value="NINGUNA" >NINGUNA</option>
									<option value="SSL" >SSL</option>
								</select>
							</td>
						</tr>
						<tr id="cuerpo">
							<td class="label" valign="top">
								<label for="cuerpoTexto">Texto del correo:</label>
							</td>
							<td colspan="3">
								<textarea id="cuerpoTexto" name="cuerpoTexto" rows="10" cols="120" tabindex="25"></textarea>
							</td>
						</tr>
					</table>

				</fieldset>
				<br>
				<table>
					<tr>
						<td class="label"><label for="montoMin">Monto Mínimo
								para generar CFDI: </label></td>
						<td align="left"><form:input id="montoMin" name="montoMin"
								path="montoMin" size="20" esMoneda="true" tabindex="26" /></td>
					</tr>
				</table>

				<table width="100%">
					<tr>
						<td align="right"><input type="submit" id="modifica"
							name="modifica" class="submit" value="Modificar" tabindex="27" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
							<input type="hidden" id="tipoActualizacion"
							name="tipoActualizacion" /></td>

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

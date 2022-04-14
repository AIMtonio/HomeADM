<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/puestosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/rolesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/companiasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/empleadosServicio.js"></script>
<script type="text/javascript" src="js/soporte/usuarioCatalogo.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="usuario">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Usuarios</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label">
							<label for="numero">N&uacute;mero: </label> 
						</td>
						<td>
							<form:input type="text" id="usuarioID" name="usuarioID" path="usuarioID" size="13" tabindex="1" />
						</td>
					</tr>
					<tr>
						<td class="label"> 
				        	<label for="empleadoID">Empleado:</label> 
				     	</td> 
				     	<td> 
				      		<form:input type="text" id="empleadoID" name="empleadoID" path="empleadoID" size="13" tabindex="1" /> 
				     	</td>
						<td class="separador"></td>
						<td class="label">
							<label for="nombre">Nombre:</label>
						</td>
						<td>
							<form:input type="text" id="nombre" name="nombre" path="nombre" size="30" tabindex="2" maxlength="50" onBlur=" ponerMayusculas(this)" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="apPaterno">Apellido Paterno: </label>
						</td>
						<td>
							<form:input type="text" id="apPaterno" name="apPaterno" path="apPaterno" size="30" tabindex="3" maxlength="50" onBlur=" ponerMayusculas(this)" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="apMaterno">Apellido Materno:</label>
						</td>
						<td>
							<form:input type="text" id="apMaterno" name="apMaterno" path="apMaterno" size="30" tabindex="4" maxlength="50" onBlur=" ponerMayusculas(this)" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="rfc">RFC:</label>
						</td>
						<td>
							<form:input type="text" id="rfc" name="rfc" path="rfc" size="16" tabindex="5" maxlength="13"
							onBlur=" ponerMayusculas(this)"/>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="CURP">CURP:</label>
						</td>
						<td>
							<form:input id="curp" name="curp" path="curp" tabindex="6" size="25" onBlur=" ponerMayusculas(this)" maxlength="18"/>
						</td>						
					</tr>
					<tr>
						<td class="label">
							<label for="clave">Clave: </label>
						</td>
						<td>
							<form:input type="text" id="clave" name="clave" path="clave" tabindex="7" size="30" maxlength="45" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="contrasenia">Contrase&ntilde;a:</label>
						</td>
						<td>
							<form:password id="contrasenia" name="contrasenia" path="contrasenia" size="30" tabindex="8" maxlength="45" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="clave">Acceder con: </label>
						</td>

						<td >
							<select id="accederAutorizar" name="accederAutorizar" tabindex="9">
								<option value="">SELECCIONAR</option>
								<option value="C">CONTRASEÑA</option>
								<option value="H">HUELLA DIGITAL</option>
								<option value="A">AMBOS</option>
							</select>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="correo">Correo: </label>
						</td>
						<td>
							<form:input type="text" id="correo" name="correo" path="correo" size="30" tabindex="10" maxlength="50" />
						</td>
					</tr>
					<tr>						
						<td class="label">
							<label for="Sucursal">Sucursal Usuario:</label>
						</td>
						<td>
							<form:input type="text" id="sucursalUsuario" name="sucursalUsuario" path="sucursalUsuario" size="13" tabindex="11" />
							<input type="text" id="nomSucursal" name="nomSucursal" size="30" tabindex="11" disabled="true" readOnly="true" />
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="rol">Rol: </label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="rolID" name="rolID" path="rolID" size="13" tabindex="12" />
							<input type="text" id="nombreRol" name="nombreRol" size="35" tabindex="12" disabled="true" readOnly="true" />
						</td>
					</tr>
					<tr>						
						<td class="label" nowrap="nowrap">
							<label for="clavePuestoID">Puesto: </label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="clavePuestoID" name="clavePuestoID" path="clavePuestoID" size="13" tabindex="13" />
							<input type="text" id="descripcionPuesto" name="descripcionPuesto" size="30" tabindex="13" disabled="true" readOnly="true" />
						</td>
						<td class="separador"></td>
						<td>
							<label for="fechUltPass">Direcci&oacute;n IP: </label>
						</td>
						<td>
							<form:input type="text" id="ipSesion" name="ipSesion" path="ipSesion" size="30" tabindex="14" maxlength="15" />
						</td>
					</tr>
					<tr>						
						<td class="label" nowrap="nowrap">
							<label for="fechUltAcces">Fecha de &Uacute;ltimo Acceso:</label>
						</td>
						<td>
							<form:input type="text" id="fechUltAcces" name="fechUltAcces" path="fechUltAcces" size="30" tabindex="15" disabled="true" readOnly="true" />
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="fechUltPass">Fecha del &Uacute;ltimo Password: </label>
						</td>
						<td>
							<form:input type="text" id="fechUltPass" name="fechUltPass" path="fechUltPass" size="30" tabindex="16" disabled="true" readOnly="true" />
						</td>
					</tr>
					<tr>						
						<td class="label">
							<label for="fechaAlta">Fecha de Alta:</label>
						</td>
						<td>
							<form:input type="text" id="fechaAlta" name="fechaAlta" path="fechaAlta" size="30" tabindex="17" disabled="true" readOnly="true" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="estatus">Estatus:</label>
						</td>
						<td>
							<form:input type="text" id="estatus" name="estatus" path="estatus" size="30" tabindex="18" disabled="true" readOnly="true" />
						</td>
					</tr>
					<tr>
						
						<td class="label">
							<label for="realizaConsultasCC">Puede Hacer Consultas Circulo: </label>
						</td>
						<td colspan="2">
							<form:input type="radio" id="realizaConsultasCCSI" name="realizaConsultasCC" path="realizaConsultasCC" tabindex="19" value="S" />
							<label>Si</label>
							<form:input type="radio" id="realizaConsultasCCNO" name="realizaConsultasCC" path="realizaConsultasCC" tabindex="20" value="N" checked="true" />
							<label>No</label>
						</td>
						<td class="label">
							<label for="realizaConsultasBC">Puede Hacer Consultas Bur&oacute;: </label>
						</td>
						<td colspan="2">
							<form:input type="radio" id="realizaConsultasBCSI" name="realizaConsultasBC" path="realizaConsultasBC" tabindex="21" value="S" />
							<label>Si</label>
							<form:input type="radio" id="realizaConsultasBCNO" name="realizaConsultasBC" path="realizaConsultasBC" tabindex="22" value="N" checked="true" />
							<label>No</label>
						</td>
					</tr>					
					<tr id="trUsuarioCirculo" style="display: none;">
						<td class="label">
							<label for="usuarioCirculo">Usuario Circulo: </label>
						</td>
						<td>
							<form:input type="text" id="usuarioCirculo" name="usuarioCirculo" path="usuarioCirculo" size="30" tabindex="23" maxlength="12" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="contrasenaCirculo">Contrase&ntilde;a Circulo: </label>
						</td>
						<td>
							<form:input type="password" id="contrasenaCirculo" name="contrasenaCirculo" path="contrasenaCirculo" size="30" tabindex="24" maxlength="15" autocomplete="new-password" />
						</td>
					</tr>
					<tr id="trUsuarioBuro" style="display: none;">
						<td class="label">
							<label for="usuarioBuroCredito">Usuario bur&oacute; Cr&eacute;dito: </label>
						</td>
						<td>
							<form:input type="text" id="usuarioBuroCredito" name="usuarioBuroCredito" path="usuarioBuroCredito" size="30" tabindex="25" maxlength="12" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="contrasenaBuroCredito">Contrase&ntilde;a bur&oacute; Cr&eacute;dito: </label>
						</td>
						<td>
							<form:input type="password" id="contrasenaBuroCredito" name="contrasenaBuroCredito" autocomplete="new-password" path="contrasenaBuroCredito" size="30" tabindex="26" maxlength="15" />
						</td>
					</tr>
					<tr> 
						<td class="label"> 
					   		<label for="folioIdentificacion">No. de Identificaci&oacute;n: </label> 
					   </td> 
					   <td> 
					   		<form:input id="folioIdentificacion" name="folioIdentificacion" path="folioIdentificacion" size="25" tabindex="27" maxlength = "18" onBlur=" ponerMayusculas(this)"/> 
					   </td> 
					   <td class="separador"></td>
					   <td class="label"> 
							<label for="folioIdentificacion">Direcci&oacute;n: </label> 
					</td>
					   <td nowrap="nowrap" colspan="3">
							<textarea id="direccionCompleta" name="direccionCompleta" cols="46" rows="3" tabindex="28" onBlur=" ponerMayusculas(this)" maxlength = "200"></textarea>
					   </td>
					</tr> 
					<tr> 
						<td class="label"  nowrap="nowrap"> 
							<label for="fechaExpedicion">Fecha Expedici&oacute;n Identificaci&oacute;n: </label> 
						</td> 
						<td> 
							<form:input id="fechaExpedicion" name="fechaExpedicion" path="fechaExpedicion" size="14" tabindex="29" esCalendario="true" /> 
						</td>
						<td class="separador"></td> 
					   <td class="label"  nowrap="nowrap"> 
					    	<label for="fechaVencimiento">Fecha Vencimiento Identificaci&oacute;n:</label> 
					   </td> 
					   <td> 
					    	<form:input id="fechaVencimiento" name="fechaVencimiento" path="fechaVencimiento" size="14" tabindex="30" esCalendario="true"/> 
					   </td> 
					   <td></td>
					</tr>
					<tr>
						<td class="label">
							<label for="realizaConsultasCC">Monitor de Solicitudes: </label>
						</td>
						<td >
							<form:input type="radio" id="monitorSI" name="accesoMonitor" path="accesoMonitor" tabindex="31" value="S" />
							<label>Si</label>
							<form:input type="radio" id="monitorNO" name="accesoMonitor" path="accesoMonitor" tabindex="32" value="N" checked="true" />
							<label>No</label>
						</td>
						
					</tr>
					<tr class="validarVigDomi" style="display: none;">
						<td class="label">
							<label for="realizaConsultasCC">Notificaci&oacute;nes: </label>
						</td>
						<td colspan="2" nowrap="nowrap">
							<form:input type="radio" id="notificacionSi" name="notificacion" path="notificacion" tabindex="33" value="S" />
							<label>Si</label>&nbsp;
							<form:input type="radio" id="notificacionNo" name="notificacion" path="notificacion" tabindex="34" value="N" checked="true" />
							<label>No</label>&nbsp; <a href="javaScript:" onclick="ayudaValidaVig()"><img src="images/help-icon.gif"></a>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="usaAplicacion">Usa Aplicaci&oacute;n m&oacute;vil: </label>
						</td>
						<td >
							<form:input type="radio" id="usaAplicacionSI" name="usaAlicacion" path="usaAplicacion" tabindex="37" value="S" checked="true"/>
							<label>Si</label>
							<form:input type="radio" id="usaAplicacionNO" name="usaAplicacion" path="usaAplicacion" tabindex="38" value="N"  />
							<label>No</label>
						</td>
						<td class="separador"></td>
						<td class="label" >
							<label for="imei" id="lblImei">IMEI: </label>
						</td>
						<td colspan="2" >
							<form:input type="input" id="imei" name="imei" path="imei" size="39" tabindex="39" maxlength="32" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="notificaCierre">Notifica Cierre Aut.: </label>
						</td>
						<td >
							<form:input type="radio" id="notificaCierreSI" name="notificaCierre" path="notificaCierre" tabindex="21" value="S" />
							<label>Si</label>
							<form:input type="radio" id="notificaCierreNO" name="notificaCierre" path="notificaCierre" tabindex="22" value="N" checked="true" />
							<label>No</label>
						</td>
						
					</tr>
					<tr>
						<td colspan="5" align="right">
							<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="40" /> <input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="41" /> <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" /> <input type="hidden" id="rutaReportes" name="rutaReportes" /> <input type="hidden" id="rutaImgReportes" name="rutaImgReportes" /> <input type="hidden" id="logoCtePantalla" name="logoCtePantalla" />
						</td>
					</tr>
				</table>
				<br>
				<table id="reglas de pass">
					<tr>
						<td class="label">
							<DIV class="label">
								<label id="mensajeLabel"> </label>
							</DIV>
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
	<div id="divOculto" style="display: none;">
		<div id="ayudaValVig">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Notificaciones</legend>
				<div id="ContenedorAyuda" style="text-align: justify; padding: 10px">
					<b>Validaci&oacute;n en Vigencia de Comprobante de Domicilio:</b> <br>Muestra una Alerta al Iniciar sesi&oacute;n si la sucursal existen
					<s:message code="safilocale.cliente" />s con Documentos (Comprobante de Domicilio) por Expirar.
				</div>
			</fieldset>
		</div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>

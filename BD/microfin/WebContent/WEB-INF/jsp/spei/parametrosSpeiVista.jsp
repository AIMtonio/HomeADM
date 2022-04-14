<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head>

	<link rel="stylesheet" type="text/css" href="css/mensaje.css" media="all"  >
	<script type="text/javascript" src="dwr/interface/parametrosSpeiServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tarEnvioCorreoParamServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script> 
	<script type="text/javascript" src="js/spei/parametrosSpei.js"></script>
</head>
<body>


<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Taller de Productos SPEI</legend>

		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="parametrosSpeiBean" target="_blank">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">

				<tr>
					<td class="label" nowrap="nowrap"><label for="lblEmpresa">N&uacute;mero Empresa: </label></td>
					<td nowrap="nowrap">
						<input type="text" id="empresaID" name="empresaID" size="10" iniForma="false" tabindex="1"/>
						<input type="text" id="nombreInsitutcion" name="nombreInsitutcion" size="50"  readonly="true" disabled="disabled"/>
					</td>
					<td class="separador"></td>
					<td class="label" nowrap="nowrap">
						<label for="lblHabilitado">Habilitar SPEI: </label>
					</td>
					<td>
						<form:radiobutton id="habilitadoSi" name="habilitadoSi" path="habilitado" value="S" tabindex="2" checked="checked" />
						<label for="habilitadoSi">Si</label>&nbsp;&nbsp;
						<form:radiobutton id="habilitadoNo" name="habilitadoNo" path="habilitado" value="N" tabindex="3"/>
						<label for="habilitadoNo">No</label>
					</td>
				</tr>
			</table>
			<div id="contenedorSPEI">
				<table>
					<tr>
						<td class="label"><label id="tipoOperacion" for="lblTipoOperacion">Tipo de conexi&oacute;n: </label></td>
						<td class="label" nowrap="nowrap">
							<form:radiobutton id="Tipo1" name="Tipo1" path="tipoOperacion" value="S" tabindex="4" checked="checked" />
							<label id="S" for="S">STP</label>&nbsp;&nbsp;
							<form:radiobutton id="Tipo2" name="Tipo2" path="tipoOperacion" value="B" tabindex="5"/>
							<label id="B" for="B">Banxico</label>
						</td>
					</tr>
	
					<tr>
						<td class="label" nowrap="nowrap"><label for="lblClabe">Cuenta CLABE Participante SPEI: </label></td>
					   	<td nowrap="nowrap"><input type="text" id="clabe" name="clabe" size="25" tabindex="6" maxlength="18"/></td>
	
					   	<td class="separador"></td>
	
	
	
						<td class="label" nowrap="nowrap"><label for="lblCtaSpei">Cta. Contable Concentradora SPEI: </label></td>
					   	<td nowrap="nowrap"><input type="text" id="ctaSpei" name="ctaSpei" size="25" tabindex="7" maxlength="20"/></td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap"><label for="lblMonReqAutTeso">Requiere Autorizaci&oacute;n de Tesorer&iacute;a a partir de: </label></td>
						<td nowrap="nowrap"><input type="text" id="monReqAutTeso" name="monReqAutTeso" size="15" style="text-align: right" esmoneda="true" tabindex="8" maxlength="18"/></td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap"><label for="lblMonMaxSpeiVen">Monto Máximo SPEI Ventanilla: </label></td>
						<td nowrap="nowrap"><input type="text" id="monMaxSpeiVen" name="monMaxSpeiVen" size="15" style="text-align: right" esmoneda="true" tabindex="9" maxlength="18"/></td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap"><label for="lblHorario">Horario de Procesos SPEI: </label></td>
						<td nowrap="nowrap">
							<select id="horarioInicioHrs" tabindex="10"></select><select id="horarioInicioMins" tabindex="11"></select>
							<label for="lblHorarioA"> a </label>
							<select id="horarioFinHrs" tabindex="12"></select><select id="horarioFinMins" tabindex="13"></select>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap"><label for="lblHorarioFinVen">Horario SPEI Ventanilla: </label></td>
						<td nowrap="nowrap">
							<select id="horarioFinVenHrs" tabindex="14"></select><select id="horarioFinVenMins" tabindex="15"></select>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap"><label for="lblSpeiVenAutTes">SPEI Ventanilla Autoriza Tesorer&iacute;a: </label></td>
						<td class="label" nowrap="nowrap">
							<form:radiobutton id="speiVenAutTes1" name="speiVenAutTes1" path="speiVenAutTes" value="S" tabindex="16"/>
							<label for="S">Si</label>&nbsp;&nbsp;
							<form:radiobutton id="speiVenAutTes2" name="speiVenAutTes2"  path="speiVenAutTes" value="N" tabindex="17" checked="checked"/>
							<label for="N">No</label>
						</td>
						<td class="separador"></td>
						<td class="label topologia"><label  id="topologia"  for="lblTopologia">Topolog&iacute;a SPEI: </label></td>
		  			    <td class="label topologia" nowrap="nowrap">
							<form:radiobutton id="topologia1"  name="topologia1" path="topologia" value="T" tabindex="18" checked="checked" />
							<label for="T">T</label>&nbsp;&nbsp;
							<form:radiobutton id="topologia2" name="topologia2" path="topologia" value="V" tabindex="19"/>
							<label for="V">V</label>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap"><label for="lblMonReqAutDesemo">Desembolsos Requieren Autorizaci&oacute;n a partir de: </label></td>
						<td nowrap="nowrap"><input type="text" id="monReqAutDesem" name="monReqAutDesem" size="15" style="text-align: right" esmoneda="true" tabindex="20" maxlength="18"/></td>
					   	<td class="separador"></td>
						<td class="label" nowrap="nowrap"><label for="lblCtaContableTesoreria">Cta. Contable Tesorer&iacute;a SPEI: </label></td>
					   	<td nowrap="nowrap"><input type="text" id="ctaContableTesoreria" name="ctaContableTesoreria" size="25" tabindex="21" maxlength="25"/></td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap"><label for="lblParticipanteSpei">Participante SPEI: </label></td>
						<td><input type="text" id="participanteSpei" name="participanteSpei" size="15" tabindex="22" maxlength="5"/></td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap"><label for="lblFrecuenciaEnvio">Frecuencia de Env&iacute;os de SPEI: </label></td>
						<td class="label" nowrap="nowrap">
							<select id="frecuenciaEnMins" tabindex="23"></select>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap"><label for="lblBloqueoRecepcion">Bloquea recepci&oacute;n de SPEI: </label></td>
						<td class="label" nowrap="nowrap">
							<form:radiobutton id="bloqueoRecepcion1" name="bloqueoRecepcion1" path="bloqueoRecepcion" value="S" tabindex="24" />
							<label for="S">Si</label>&nbsp;&nbsp;
							<form:radiobutton id="bloqueoRecepcion2" name="bloqueoRecepcion2" path="bloqueoRecepcion" value="N" tabindex="25"  checked="checked"/>
							<label for="N">No</label>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap"><label for="lblMontoMinimoBloq" id="lblMontoMinimoBloq">Monto de Bloqueo por Recepci&oacute;n de SPEI: </label></td>
						<td nowrap="nowrap"><input type="text" id="montoMinimoBloq" name="montoMinimoBloq" size="15" style="text-align: right" esmoneda="true" tabindex="26" maxlength="16"/></td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap"><label for="lblParticipaPagoMovil">Participa Pago M&oacute;vil: </label></td>
						<td class="label" nowrap="nowrap">
							<form:radiobutton id="participaPagoMovil1" name="participaPagoMovil1" path="participaPagoMovil" value="S" tabindex="27"/>
							<label for="S">Si</label>&nbsp;&nbsp;
							<form:radiobutton id="participaPagoMovil2" name="participaPagoMovil2" path="participaPagoMovil"	value="N" tabindex="28" checked="checked"/>
							<label for="N">No</label>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap"><label for="lblMonMaxSpeiBcaMovil" id="lblMonMaxSpeiBcaMovil">Monto M&aacute;ximo SPEI Banca M&oacute;vil: </label></td>
						<td><input type="text" id="monMaxSpeiBcaMovil" name="monMaxSpeiBcaMovil" size="15"  style="text-align: right" esmoneda="true" tabindex="29" maxlength="18"/></td>
					</tr>
					<tr>
						<td class="label saldoMinimoCuentaSTP" nowrap="nowrap"><label for="lblMinimoStp">M&iacute;nimo de saldo de STP: </label></td>
					   	<td class="saldoMinimoCuentaSTP" nowrap="nowrap"><input type="text" id="saldoMinimoCuentaSTP" name="saldoMinimoCuentaSTP" maxlength="19" size="20" tabindex="30" autocomplete="off"/></td>
	
					   	<td class="separador"></td>
	
	
	
						<td class="label rutaKeystoreStp" nowrap="nowrap"><label for="lblRutaStp">Ruta Keystore de STP: </label></td>
					   	<td class="rutaKeystoreStp" nowrap="nowrap"><input type="text" id="rutaKeystoreStp" name="rutaKeystoreStp" maxlength="200"size="42" tabindex="31" autocomplete="off"/></td>
					</tr>
	
					<tr>
						<td class="label aliasCertificadoStp" nowrap="nowrap"><label for="lblAliasStp">Alias del certificado: </label></td>
					   	<td  class="aliasCertificadoStp" nowrap="nowrap"><input type="text" id="aliasCertificadoStp" name="aliasCertificadoStp" maxlength="50" size="20" tabindex="32" autocomplete="off"/></td>
	
					   	<td class="separador"></td>
	
	
	
						<td class="label passwordKeystoreStp" nowrap="nowrap"><label for="lblPasswordstp">Password de certificado STP: </label></td>
					   	<td class="passwordKeystoreStp" nowrap="nowrap"><input type="password" id="passwordKeystoreStp" name="passwordKeystoreStp" maxlength="250" size="20" tabindex="33" autocomplete="new-password"/></td>
					</tr>
	
					<tr>
						<td class="label empresaSTP" nowrap="nowrap"><label for="lblEmpresaStp">Empresa STP: </label></td>
					   	<td class="empresaSTP" nowrap="nowrap"><input type="text" id="empresaSTP" name="empresaSTP" maxlength="15" size="20" tabindex="34" autocomplete="off"/></td>
	
					   	<td class="separador"></td>
	
					  	<td class="label notificacionesCorreo"><label id="notificacionesCorreo"  for="lblNotificionCorreo">Notificaci&oacute;n por Correo: </label></td>
		  			    <td class="label notificacionesCorreo" nowrap="nowrap">
							<form:radiobutton id="notificacion1"  name="notificacion1" path="notificacionesCorreo" value="S" tabindex="35" checked="checked" />
							<label for="notificacion1">Si</label>&nbsp;&nbsp;
							<form:radiobutton id="notificacion2" name="notificacion2" path="notificacionesCorreo" value="N" tabindex="36"/>
							<label for="notificacion2">No</label>
						</td>
					</tr>
	
					<tr>
						<td class="label correoNotificacion" nowrap="nowrap"><label id="lblCorreoNotificacion" for="lblCorreoNotificacion">Correo de Notificaci&oacute;n </label></td>
					   	<td class="correoNotificacion" nowrap="nowrap"><input type="text" id="correoNotificacion" name="correoNotificacion" maxlength="500" size="30" tabindex="37" autocomplete="off"/></td>
	
					   	<td class="separador correoNotificacion"></td>
	
					   <td class="label remitenteID" nowrap="nowrap"><label id="lblRemitente" for="lblRemitente">Remitente correo: </label></td>
						<td class="remitenteID" nowrap="nowrap">
							<input type="text" id="remitenteID" name="remitenteID" size="11" tabindex="38"/>
							<input type="text" id="remitenteCorreo" name="remitenteCorreo" size="30"  readonly="true" disabled="disabled"/>
						</td>
					</tr>
					<tr>
						<td class="label intentosMaxEnvio" nowrap="nowrap"><label id="lblIntentosMaxEnvio" for="lblIntentosMaxEnvio">N&uacute;mero M&aacute;ximo de Intentos</label></td>
					   	<td class="intentosMaxEnvio" nowrap="nowrap"><input type="text" id="intentosMaxEnvio" name="intentosMaxEnvio" maxlength="11" size="10" tabindex="39" autocomplete="off"  onKeyPress="return soloNumeros(event)"/></td>
				
						<td class="separador intentosMaxEnvio"></td>
						<td class="label usuarioContraseniaWS" nowrap="nowrap"><label id="lblusuarioContraseniaWS" for="lblusuarioContraseniaWS">Usuario y contraseña del WS (Basex64) </label><a href="javaScript:" onClick="ayudausuario();"><img src="images/help-icon.gif" ></a></td>
						<td class="usuarioContraseniaWS" nowrap="nowrap"><input type="text" id="usuarioContraseniaWS" name="usuarioContraseniaWS" maxlength="500" size="30" tabindex="41" autocomplete="off" /></td>

						
					
					</tr>
					
					<tr>
						<td class="label urlWS" nowrap="nowrap"><label id="lblUrlWS" for="lblUrlWS">URL del WS</label></td>
					   	<td class="urlWS" nowrap="nowrap"><input type="text" id="urlWS" name="urlWS" maxlength="200" size="42" tabindex="40" autocomplete="off" /></td>
						<td class="separador"></td>
						<td class="label urlWSPF" nowrap="nowrap"><label id="lblUrlWSPF" for="lblUrlWSPF">URL del WS para registro de Cuentas Clabe Persona Fisica</label></td>
					   	<td class="urlWSPF" nowrap="nowrap"><input type="text" id="urlWSPF" name="urlWSPF" maxlength="200" size="42" tabindex="40" autocomplete="off" /></td>
					</tr>

					<tr>
						<td class="label urlWSPM" nowrap="nowrap"><label id="lblUrlWSPM" for="lblUrlWSPM">URL del WS para registro de Cuentas Clabe Persona Moral</label></td>
					   	<td class="urlWSPM" nowrap="nowrap"><input type="text" id="urlWSPM" name="urlWSPM" maxlength="200" size="42" tabindex="40" autocomplete="off" /></td>
						<td class="separador"></td>
						<td class="label prioridad" nowrap="nowrap"><label for="lblPrioridad">Prioridad de SPEI: </label></td>
						<td class="label prioridad" nowrap="nowrap">
							<form:radiobutton id="prioridad1" name="prioridad1" path="prioridad" value="1" tabindex="42" checked="checked" />
							<label for="Normal">Normal</label>&nbsp;&nbsp;
							<form:radiobutton id="prioridad2" name="prioridad2" path="prioridad" value="0" tabindex="43"/>
							<label for="Alta">Alta</label>
						</td>
					</tr>
					
				</table>
			</div>
			<table align="right" border='0'>
				<tr align="right">
					<td align="right">
					<a target="_blank" >
						<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="44"/>
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
						<input type="hidden" id="horarioInicio" name="horarioInicio"/>
						<input type="hidden" id="horarioFin" name="horarioFin"/>
						<input type="hidden" id="horarioFinVen" name="horarioFinVen"/>
						<input type="hidden" id="frecuenciaEnvio" name="frecuenciaEnvio"/>
					</a>
					</td>
				</tr>
			</table>
		</form:form>
	</fieldset>
</div>
<div id="cargando" style="display: none;">
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
<div id="ContenedorAyuda" style="display: none;">
	<div id="elemento"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>

<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/tarEnvioCorreoParamServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/validaCajasTransferServicio.js"></script>
		<script type="text/javascript" src="js/soporte/validaCajasTransfer.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="validaCajaTrans">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Validaci&oacute;n de Cajas y Transferencias</legend>
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="ui-widget ui-widget-header ui-corner-all">Configuraci&oacute;n</legend>
						<table width="100%">
							<tr>
								<td class="label">
									<label for="lblHora">Hora: </label>
									<form:input type="text" id="horaInicio" name="horaInicio" path="horaInicio" size="5" maxlength="5" tabindex="1" autocomplete="off"/>
									<label for="lblNumEjecuciones">hrs.</label>
								</td>
								<td class="separador">&nbsp;</td>
								<td class="label">
									<label for="lblNumEjecuciones">Num. Ejecuciones: </label>
									<form:input type="text" id="numEjecuciones" name="numEjecuciones" path="numEjecuciones" size="4" maxlength="1" tabindex="2" autocomplete="off"/>
									<label for="lblNumEjecuciones">veces</label>
								</td>
								<td class="separador">&nbsp;</td>
								<td class="label">
									<label for="lblHora">Intervalo de Tiempo: </label>
									<form:input type="text" id="intervalo" name="intervalo" path="intervalo" size="4" maxlength="1" tabindex="3" autocomplete="off"/>
									<label for="lblNumEjecuciones">Horas</label>
								</td>
							</tr>
						</table>
						<table width="100%">
							<tr>
								<td align="right">
									<input type="submit" id="guardar" name="guardar" class="submit" value="Guardar" tabindex="4" autocomplete="off"/>
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
									<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>
									<input type="hidden" id="expresionCron" name="expresionCron"/>
								</td>
							</tr> 
						</table> 
					</fieldset>
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="ui-widget ui-widget-header ui-corner-all">Notificaci&oacute;n</legend>
						<table width="100%">
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lblHora">Remitente: </label>
								</td>
								<td class="separador">&nbsp;</td>
								<td nowrap="nowrap">
									<form:input type="text" id="remitenteID" name="remitenteID" path="remitenteID" size="5" tabindex="6" autocomplete="off"/>
									<form:input type="text" id="descripcion" name="descripcion" path="descripcion" size="40" readonly="true" />
								</td>
								<td class="label" nowrap="nowrap">
								</td>
								<td nowrap="nowrap"></td>
							</tr>
							
							<tr></tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lblDestinatario">Destinatarios: </label>
								</td>
								<td class="separador">&nbsp;</td>
								<td class="label" nowrap="nowrap">
									<label for="lblDirigido">Dirigido a: </label>
								</td>
							</tr>
							
							<tr>
								<td class="separador">&nbsp;</td>
								<td class="separador">&nbsp;</td>
								<td class="label" nowrap="nowrap">
									<div id="gridDirigido"></div>
								</td>
							</tr>
							
							<tr>
								<td class="separador">&nbsp;</td>
								<td class="separador">&nbsp;</td>
								<td class="label" nowrap="nowrap">
									<label for="lblDirigido">Con copia a: </label>
									<div id="gridConCopia"></div>
								</td>
							</tr>
						</table>
						<table  width="100%">
							<tr>
								<td align="right">
									<input type="submit" id="guardarDestinatarios" name="guardarDestinatarios" class="submit" value="Guardar"/>
									<input type="hidden" id="detalle" name="detalle"/>
								</td>
							</tr>
						</table>
					</fieldset>
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
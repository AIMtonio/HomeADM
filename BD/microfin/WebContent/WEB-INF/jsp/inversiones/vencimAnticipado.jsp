<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/inversionServicioScript.js"></script>
	<script type="text/javascript" src="dwr/interface/tipoInversionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tasasInversionServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/invGarantiaServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasFirmaServicio.js"></script>
	<script type="text/javascript" src="js/soporte/ServerHuella.js"></script>
	<script type="text/javascript" src="js/soporte/mascara.js"></script>
	<script type="text/javascript" src="js/inversiones/vencimAnticipadoInver.js"></script>

<title>Vencimiento Anticipado de Inversi&oacute;n</title>
</head>
<body>

	<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Vencimiento Anticipado de  Inversi&oacute;n</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="inversionBean" >
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend >Datos Generales</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td><label>Inversi&oacute;n:</label></td>
					<td>
						<form:input type="text" name="inversionID" id="inversionID" path="inversionID" size="12" autocomplete="off" tabindex="1"/>
					</td>
					<td colspan="2"></td>
				</tr>
				<tr>
					<td><label>No. <s:message code="safilocale.cliente"/>:</label></td>
					<td><input type="text" name="clienteID" id="clienteID" size="12"
								  readonly="true" disabled="true"/>
						<input type="text" name="nombreCompleto" id="nombreCompleto" size="50"
								  readonly="true" disabled="true"/>
					</td>

					</tr>
				<tr >
					<td><label>Direcci&oacute;n:</label></td>
					<td nowrap="nowrap" colspan="3"><textarea rows="3" cols="80" name="direccion" id="direccion" readonly="true" disabled="true"></textarea>
						<label>Tel&eacute;fono:</label>
						<input type="text" name="telefono" id="telefono" size="15" readonly="true" disabled="true"/>
					</td>
				</tr>
				<tr><td colspan='4'>&nbsp;</td></tr>
				<tr>
					<td><label>Cuenta Cobro:</label></td>
					<td><form:input id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID" size="12"  autocomplete="off" readonly="true" disabled="true"/>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label>Saldo:</label>
						<input type="text" id="totalCuenta" name="totalCuenta"  style="text-align: right;" size="15" readonly="true" disabled="true" esMoneda="true"/>
						<input type="hidden" name="monedaID" id="monedaID" />
						<label id="tipoMoneda"></label>
					</td>
				</tr>
				<tr>
					<td><label>Tipo de Inversi&oacute;n:</label></td>
					<td >
						<form:input id="tipoInversionID" name="tipoInversionID" path="tipoInversionID" size="12" autocomplete="off" readonly="true" disabled="true"/>
						<input type="text" id="descripcion" name="descripcion" size="40" readonly="true" disabled="true" />
					</td>
					<td class="separador"></td>
					<td class="label">
						<label>Etiqueta:</label>
						<form:input id="etiqueta" name="etiqueta" path="etiqueta" size="48" autocomplete="off" readonly="true" disabled="true" />
					</td>
				</tr>
				<tr>
					<td><label>Estatus:</label></td>
					<td><form:input type="text" name="estatus" id="estatus" path="estatus"
										 size="12" autocomplete="off" readonly="true" disabled="true"/>
					</td>
					<td colspan="2"></td>
				</tr>

				<tr><td colspan='4' >&nbsp;</td></tr>
				<tr>
					<td colspan="4">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend >Condiciones</legend>
						<table border="0">
							<tr>
								<td><label>Monto:</label></td>
								<td>
									<form:input name="monto" id="monto" size="18" path="monto" esMoneda="true" style="text-align: right;"
													readonly="true" disabled="true"/>
									<label id="tipoMonetable" border="0" cellpadding="0" cellspacing="0" width="100%"></label>
								</td>
								<td><label>Tasa Bruta:</label></td>
								<td><form:input type="text" name="tasa" id="tasa" path="tasa" size="12" style="text-align: right;"
													 readonly="true" disabled="true" esTasa="true"/><label>%</label></td>
								<td>&nbsp;&nbsp;</td>
								<td><label>Int&eacute;res Generado:</label></td>
								<td><form:input name="saldoProvision" id="saldoProvision" path="saldoProvision" style="text-align: right;"
												size="18" readonly="true" disabled="true" esMoneda="true"/></td>
							</tr>

							<tr>
								<td><label>Plazo:</label></td>
								<td><form:input name="plazo" id="plazo" path="plazo" size="18" style="text-align: right;"
													 readonly="true" disabled="true"/></td>
								<td><label>Tasa ISR</label></td>
								<td><form:input type="text" name="tasaISR" id="tasaISR" path="tasaISR" size="12" style="text-align: right;"
											 readonly="true" value="0.00" disabled="true" esTasa="true"/><label>%</label>
								</td>
								<td>&nbsp;&nbsp;</td>
								<td><label>Inter&eacute;s Retener:</label></td>
								<td><form:input name="interesRetener" id="interesRetener" path="interesRetener" style="text-align: right;"
													size="18" readonly="true" disabled="true" esMoneda="true"/></td>
							</tr>
							<tr>
								<td><label>Fecha de<br>Inicio:</label></td>
								<td><form:input type="text" name="fechaInicio" id="fechaInicio"
													 path="fechaInicio" size="18" readonly="true" disabled="true"/>
								</td>
								<td><label>Tasa Neta:</label></td>
								<td><form:input type="text" name="tasaNeta" id="tasaNeta" path="tasaNeta" style="text-align: right;"
												size="12" readonly="true" disabled="true" esTasa="true" /><label>%</label>
								</td>
								<td>&nbsp;&nbsp;</td>
								<td><label>Inter&eacute;s Recibir:</label></td>
								<td><form:input name="interesRecibir" id="interesRecibir" path="interesRecibir" style="text-align: right;"
												size="18" readonly="true" disabled="true" esMoneda="true"/></td>
							</tr>
							<tr>
								<td><label>Fecha de<br>Vencimiento:</label></td>
								<td><form:input type="text" name="fechaVencimiento" id="fechaVencimiento"
													 path="fechaVencimiento" size="18" readonly="true" disabled="true"/>
								</td>
								<td><label>Días<br> Transcurridos:</label></td>
								<td><form:input name="diasTrans" id="diasTrans" path="diasTrans" size="18" style="text-align: right;"
													 readonly="true" disabled="true"/></td>

							</tr>
							<tr>
								<td colspan="7">&nbsp;</td>
								<td align="right"><label>Total a Recibir:</label></td>
								<td><input name="granTotal" id="granTotal" disabled="true"  type="text" esMoneda="true" size="12" style="text-align: right;"/></td>
							</tr>

						</table>
						</fieldset>
					</td>
				</tr>

				<tr><td colspan='4'>&nbsp;</td></tr>

			</table>
		</fieldset>
		<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Usuario Autoriza</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="900px">
				<tr>
					<td class="label" nowrap="nowrap">
						<label for="usuarioA">Usuario Autoriza: </label>
					</td>
					<td >
						<form:input id="usuarioAutorizaID" name="usuarioAutorizaID" size="50" path="usuarioAutorizaID" tabindex="2" type="password" />
					</td>

				</tr>
				<tr>
				 	<td class="label" nowrap="nowrap">
				    	<label for="pass">Password:</label>
				  	</td>
				    <td>
				    <form:input type="password" name="contraseniaUsuarioAutoriza" id="contraseniaUsuarioAutoriza"
				    	path="contraseniaUsuarioAutoriza" value="" size="50"  tabindex="3" autocomplete="new-password"/>
				    </td>
				</tr>
			</table>
			<input id="fechaSistema" name="fechaSistema"  size="12" type="hidden"/>
		</fieldset>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="separador">
					<span id="statusSrvHuella"></span>
				</td>
				<td colspan="4">
					<table align="right" boder='0'>
						<tr>
							<td align="right">
								<input type="submit" id="cancela" name="cancela" class="submit"  value="Cancelar" tabIndex="4"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
								<input type="hidden" id="creditosInvGar" name="creditosInvGar"/>
								<input type="hidden" id="tipoOperacion" name="tipoOperacion" value="4" />
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		</form:form>
		</fieldset>
	</div>
<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
<div id="mensaje" style="display: none;"/>
</body>
</html>

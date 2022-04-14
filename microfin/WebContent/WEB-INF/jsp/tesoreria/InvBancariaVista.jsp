<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="js/utileria.js"></script>
		<script type="text/javascript" src="js/date.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>
	  	<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>
	  	<script type="text/javascript" src="dwr/interface/operacionesFechasServicio.js"></script>
	  	<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
	  	<script type="text/javascript" src="dwr/interface/invBancariaServicioScript.js"></script>
	  	<script type="text/javascript" src="dwr/interface/distCCInvBancariaServicio.js"></script>
	  	<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
		<script type="text/javascript" src="js/tesoreria/invBancaria.js"></script>
		<title>Inversi&oacute;n Bancaria</title>
	</head>
	<body>
 		<div id="contenedorForma">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Inversiones Bancarias</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="invBancariaBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend >Datos Generales</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="80%" border="0" cellpadding="0" cellspacing="0">
							<table>
								<tr>
									<td><label>Inversi&oacute;n:</label></td>
									<td><form:input type="text" name="inversionID" id="inversionID" path="inversionID" size="12" maxlength="11" autocomplete="off" tabindex="1" /></td>
									<td colspan="2"></td>
								</tr>
								<tr>
									<td><label>Instituci&oacute;n:</label></td>
									<td><form:input type="text" name="institucionID" id="institucionID" size="4" maxlength="11" tabindex="2" autocomplete="off" path="institucionID" />
										<input type="text" name="nombreCompleto" id="nombreCompleto" size="51" readOnly="true" disabled = "true" />
									</td>
									<td colspan="2" align="right"></td>
								</tr>
								<tr>
									<td><label>N&uacute;mero de Cuenta:</label></td>
									<td><form:input id="numCtaInstit" type="text" name="numCtaInstit" path="numCtaInstit" size="30"  tabIndex="3" autocomplete="off" maxlength="20"/>
										<label>Saldo: </label>
										<input type="text" id="totalCuenta" name="totalCuenta" size="19" readOnly="true" disabled="true" esMoneda="true" style="text-align: right"/>
										<form:input type="hidden" name="monedaID" id="monedaID" path="monedaID" />
										<label id="tipoMoneda"></label>
									</td>
									<td colspan="2"></td>
								</tr>
								<tr>
									<td><label>Referencia de Inversi&oacute;n:</label></td>
									<td colspan="3">
										<form:input type="text" id="tipoInversion" name="tipoInversion" path="tipoInversion" tabIndex="4" size="55" maxlength="150" onblur="ponerMayusculas(this)" autocomplete="off" />
									</td>
								</tr>
								<tr>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="8">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend >Condiciones</legend>
								<table border="0" width="100%">
									<tr>
										<td><label>Monto:</label></td>
										<td><form:input type="text" name="monto" id="monto" size="20" path="monto" value="" maxlength="16" esMoneda="true" autocomplete="off" tabIndex = "5" style="text-align: right"/></td>
										<td><label>Tasa Bruta:</label></td>
										<td nowrap="nowrap"><form:input type="text" name="tasa" id="tasa" path="tasa" size="8" tabIndex="10" maxlength="16" esTasa="true"/><label> %</label></td>
										<td>&nbsp;&nbsp;</td>
										<td><label>Interés Generado:</label></td>
										<td><form:input type="text" name="interesGenerado" id="interesGenerado" path="interesGenerado" readOnly="true"  disabled="true" esMoneda="true" style="text-align: right"/></td>
										<td colspan="2">&nbsp;&nbsp;</td>
									</tr>
									<tr>
										<td><label>Fecha de <br>Inicio:</label></td>
										<td><form:input type="text" name="fechaInicio" id="fechaInicio" path="fechaInicio" size="15"  esCalendario="true"  tabIndex = "6" autocomplete="off"  /></td>
										<td><label>Tasa ISR:</label></td>
										<td nowrap="nowrap"><form:input type="text" name="tasaISR" id="tasaISR" path="tasaISR"  value="0.60" size="7"  maxlength="16" tabIndex="11" esTasa="true" /><label> %</label></td>
										<td>&nbsp;&nbsp;</td>
										<td><label>Interés Retener:</label></td>
										<td><form:input type="text" name="interesRetener" id="interesRetener" path="interesRetener"  readOnly="true"  disabled="true" esMoneda="true" style="text-align: right"/></td>
										<td>&nbsp;&nbsp;</td>
										<td>&nbsp;&nbsp;</td>
									</tr>
									<tr>
										<td><label>Plazo:</label></td>
										<td><form:input type="text" name="plazo" id="plazo" path="plazo" size="4" tabIndex = "7" autocomplete="off"  maxlength="3"/><label> D&iacute;as</label></td>
										<td><label>Tasa Neta:</label></td>
										<td nowrap="nowrap"><form:input type="text" name="tasaNeta" id="tasaNeta" path="tasaNeta" size="7" readOnly="true" disabled="true" esTasa="true"/><label> %</label></td>
										<td>&nbsp;&nbsp;</td>
										<td><label>Interés Recibir:</label></td>
										<td><form:input type="text" name="interesRecibir" id="interesRecibir" path="interesRecibir" readOnly="true"  disabled="true" esMoneda="true" style="text-align: right"/></td>
										<td>&nbsp;&nbsp;</td>
										<td>&nbsp;&nbsp;</td>
									</tr>
									<tr>
										<td><label>Fecha de<br>Vencimiento</label></td>
										<td><form:input type="text" name="fechaVencimiento" id="fechaVencimiento" path="fechaVencimiento" size="15"  esCalendario="true"  tabIndex = "8" autocomplete="off"  /></td>
										<td>&nbsp;&nbsp;</td>
										<td colspan="6">&nbsp;&nbsp;</td>
									</tr>

									<tr>
									<td><label>Año Bancario:</label></td>
									<td><form:input  type="text" name="diasBase" id="diasBase" path="diasBase" size="4" maxlength="3" minlength="3" tabIndex = "9" /><label>&nbsp;D&iacute;as</label></td>
										<td colspan="3">&nbsp;</td>
										<td align="right"><label>Total a Recibir:</label></td>
										<td><form:input type="text" name="totalRecibir" id="totalRecibir" path="totalRecibir" readOnly="true" disabled="true" esMoneda="true" style="text-align: right"/></td>
									</tr>
									<tr><td colspan="8">
									<table>
									<tr>
										<td><label>Clasificaci&oacute;n de la Inv.:</label></td>
									</tr>
									<tr>
									<td><form:input id="invValoresOp" type="radio" name="clasificacionInver" path="clasificacionInver" Value="I" tabindex="12"></form:input><label>Inv. En Valores</label></td>
									<td></td>
									<td><form:input id="reportosOp" type="radio" name="clasificacionInver" path="clasificacionInver" Value="R" tabindex="13"></form:input><label>Reportos</label></td>
									</tr>
									<tr id="pregTipoTitulo">
										<td><label>Tipo de Título:</label></td>
									</tr>
									<tr id="opTipoTitulo">
										<td><form:input id="ttN" type="radio" name="tipoTitulo" path="tipoTitulo" value="N" tabindex="15"></form:input><label>Para Negociar</label></td>
										<td></td>
										<td><form:input id="ttD" type="radio" name="tipoTitulo" path="tipoTitulo"  value="D" tabindex="16"></form:input><label>Disp. Para Venta</label></td>
										<td></td>
										<td><form:input id="ttC" type="radio" name="tipoTitulo" path="tipoTitulo"  value="C" tabindex="17"></form:input><label>Conservados al Vencimiento</label></td>
									</tr>
									<tr id="pregRestriccion">
										<td><label>Restricci&oacute;n:</label></td>
									</tr>
									<tr id="opRestriccion">
										<td><form:input id="resC" type="radio" name="tipoRestriccion" path="tipoRestriccion" value="C" tabindex="18"></form:input><label>Con Restricci&oacute;n</label></td>
										<td></td>
										<td><form:input id="resS" type="radio" name="tipoRestriccion" path="tipoRestriccion" Value="S" tabindex="19"></form:input><label>Sin Restricci&oacute;n</label></td>
									</tr>
									<tr id="pregTipoDeuda">
										<td><label>Tipo de Deuda:</label></td>
									</tr>
									<tr id="opTipoDeuda">
										<td><form:input id="tdG" type="radio" name="tipoDeuda" path="tipoDeuda" Value="G" tabindex="20"></form:input><label>Gubernamental</label></td>
										<td></td>
										<td><form:input id="tdB" type="radio" name="tipoDeuda" path="tipoDeuda" Value="B" tabindex="21"></form:input><label>Bancaria</label></td>
										<td></td>
										<td><form:input id="tdO" type="radio" name="tipoDeuda" path="tipoDeuda" Value="O" tabindex="22"></form:input><label>Otros T&iacute;tulos</label></td>
										<td><form:input type="hidden" name="fechaSistema" id="fechaSistema" path="fechaSistema"  /></td>
									</tr>
									</table>
									</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td colspan="8">
						<input type="text" id="detalle" name="detalle" size="100"  style="display: none;" />
						<div id="gridDetalle" name="gridDetalle" style="width:100%;overflow-x:scroll; display: none;"></div>
						</td>
					</tr>
				</table>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td colspan="4">
							<table align="right" border='0'>
								<tr>
									<td align="right">
										<input type="submit" id="agrega" name="agrega" class="submit" tabIndex = "24" value="Agregar" />
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
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
			<div id="elementoLista"></div>
		</div>
		<div id="mensaje" style="display: none;"></div>
	</body>
</html>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/ingresosOperacionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cajasVentanillaServicio.js"></script>
		<script type="text/javascript" src="js/ventanilla/envioEfectivoBanco.js"></script>  
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="transferBancoBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all"> Env&iacute;o Efectivo a Banco</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%"> 
	 	<tr id="trEnvioEfectivo">
	 		<td colspan="2" class="label">
	 			<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend><label>Env&iacute;o de Efectivo a Bancos</label></legend>
	 			<table  border="0" cellpadding="0" cellspacing="0" width="100%">
	 				<tr>
	 					<td class="label">
		 					<label for="lblSucursalDestino">Instituci&oacute;n:</label>
	 					</td>
	 					<td>
							<form:input id="institucionID" name="institucionID" path="institucionID" size="3" tabindex="1" />
							<input type="text" id="nombreInstitucion" name="nombreInstitucion" size="65" readOnly="true"/>
						</td>
						<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="lblCajaDestino">Sucursal Origen:</label>
							</td>
							<td>
								<form:input id="sucursalID" name="sucursalID" path="sucursalID" size="3" readOnly="true"/>
								<input type="text" id="descSucursal" name="descSucursal" readOnly="true" >
							</td>
					</tr>
				<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblSucursalOrigen">Cuenta Bancaria:</label>
						</td>
						<td>
							<form:input type="text" id="numCtaInstit" name="numCtaInstit" path="numCtaInstit" tabindex="2"  maxlength="20"/>
						</td>
						<td class="separador"></td>
						<td class="label"><label for="lblCajaOrigen">Caja Origen:</label></td>
					<td>
						<form:input id="cajaID" name="cajaID" path="cajaID" size="3" readOnly="true"/>
						<input type="text" id="descCaja" name="descCaja" readOnly="true"  >
					</td>		
				</tr>
				<tr>
						<td class="label">
							<label for="lblMoneda">Moneda:</label>
						</td>
						<td>
							<form:select id="monedaID" name="monedaID" path="monedaID" tabindex="3">
							<form:option value="0">SELECCIONAR</form:option>
							</form:select>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="lblReferencia">Referencia:</label>
						</td>
						<td>
							<form:input type="text" id="referencia" name="referencia" path="referencia" size="30"
							 onblur=" ponerMayusculas(this)" maxlength="50" tabindex="4"/>
						</td>
				</tr>
				<tr>
			<td colspan="3" class="label" id="tdSalidaEfectivo">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend><label>Salida de Efectivo</label></legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label"><label for="lblDenominacion">Denominaci&oacute;n</label>
							</td>
							<td class="separador"></td>
							<td><label for="lblCantidad">Disponible</label></td>
							<td class="separador"></td>
							<td align="right"><label for="lblCantidad">Cantidad</label></td>
							<td class="separador"></td>
							<td class="label" align="right"><label for="lblMonto">Monto</label>
							</td>
						</tr>
						<tr>
							<td align="right">
								<input id="denoSalMilID" iniForma="false" name="denomiSalidaID" size="8" type="hidden" readOnly="true" disabled="true"
								style="text-align: right" value="1"></input> 
								<input id="denoSalMil" iniForma="false" name="denomiSalida"	size="8" type="text" readOnly="true" disabled="true"
								 style="text-align: right" value="1000"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalMil"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true" disabled="true"
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="cantSalMil"
								name="cantSalida" size="8" type="text" value="0"
								iniForma="false" style="text-align: right" tabindex="5" onkeypress="return validaSoloNumero(event,this);"></input></td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalMil" name="montoSalida" size="10" type="text"
								readOnly="true" disabled="true" esMoneda="true"
								iniForma="false" style="text-align: right"></input></td>
						</tr>
						<tr>
							<td align="right"><input id="denoSalQuiID"
								iniForma="false" name="denomiSalidaID" size="8"
								type="hidden" readOnly="true" disabled="true"
								style="text-align: right" value="2" ></input> <input
								id="denoSalQui" iniForma="false" name="denomiSalida"
								size="8" type="text" readOnly="true" disabled="true"
								style="text-align: right" value="500"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalQui"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true" disabled="true"
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="cantSalQui"
								name="cantSalida" size="8" type="text" value="0"
								iniForma="false" style="text-align: right" tabindex="6" onkeypress="return validaSoloNumero(event,this);"></input></td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalQui" name="montoSalida" size="10" type="text"
								readOnly="true" disabled="true" esMoneda="true"
								iniForma="false" style="text-align: right"></input></td>
						</tr>
						<tr>
							<td align="right"><input id="denoSalDosID"
								iniForma="false" name="denomiSalidaID" size="8"
								type="hidden" readOnly="true" disabled="true"
								style="text-align: right" value="3"></input> <input
								id="denoSalDos" iniForma="false" name="denomiSalida"
								size="8" type="text" readOnly="true" disabled="true"
								style="text-align: right" value="200"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalDos"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true" disabled="true"
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="cantSalDos"
								name="cantSalida" size="8" type="text" value="0"
								iniForma="false" style="text-align: right" tabindex="7" onkeypress="return validaSoloNumero(event,this);"></input></td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalDos" name="montoSalida" size="10" type="text"
								readOnly="true" disabled="true" esMoneda="true"
								iniForma="false" style="text-align: right"></input></td>
						</tr>
						<tr>
							<td align="right"><input id="denoSalCienID"
								iniForma="false" name="denomiSalidaID" size="8"
								type="hidden" readOnly="true" disabled="true"
								style="text-align: right" value="4"></input> <input
								id="denoSalCien" iniForma="false" name="denomiSalida"
								size="8" type="text" readOnly="true" disabled="true"
								style="text-align: right" value="100"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalCien"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true" disabled="true"
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="cantSalCien"
								name="cantSalida" size="8" type="text" value="0"
								iniForma="false" style="text-align: right" tabindex="8" onkeypress="return validaSoloNumero(event,this);"></input></td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalCien" name="montoSalida" size="10"
								type="text" readOnly="true" disabled="true"
								iniForma="false" esMoneda="true"
								style="text-align: right"></input></td>
						</tr>
						<tr>
							<td align="right"><input id="denoSalCinID"
								iniForma="false" name="denomiSalidaID" size="8"
								type="hidden" readOnly="true" disabled="true"
								style="text-align: right" value="5"></input> <input
								id="denoSalCin" iniForma="false" name="denomiSalida"
								size="8" type="text" readOnly="true" disabled="true"
								style="text-align: right" value="50"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalCin"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true" disabled="true"
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="cantSalCin"
								name="cantSalida" size="8" type="text" value="0"
								iniForma="false" style="text-align: right" tabindex="9" onkeypress="return validaSoloNumero(event,this);"></input></td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalCin" name="montoSalida" size="10" type="text"
								readOnly="true" disabled="true" esMoneda="true"
								iniForma="false" style="text-align: right"></input></td>
						</tr>
						<tr>
							<td align="right"><input id="denoSalVeiID"
								iniForma="false" name="denomiSalidaID" size="8"
								type="hidden" readOnly="true" disabled="true"
								style="text-align: right" value="6"></input> <input
								id="denoSalVei" iniForma="false" name="denomiSalida"
								size="8" type="text" readOnly="true" disabled="true"
								style="text-align: right" value="20"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalVei"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true" disabled="true"
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="cantSalVei"
								name="cantSalida" size="8" type="text" value="0"
								iniForma="false" style="text-align: right" tabindex="10" onkeypress="return validaSoloNumero(event,this);"></input></td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalVei" name="montoSalida" size="10" type="text"
								readOnly="true" disabled="true" esMoneda="true"
								iniForma="false" style="text-align: right"></input></td>
						</tr>
						<tr>
							<td align="right"><input id="denoSalMonID"
								iniForma="false" name="denomiSalidaID" size="8"
								type="hidden" readOnly="true" disabled="true"
								style="text-align: right" value="7"></input> <input
								id="denoSalMon" iniForma="false" name="denomiSalida"
								size="8" type="text" readOnly="true" disabled="true"
								style="text-align: right" value="Monedas"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalMon"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true" disabled="true"
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="cantSalMon"
								name="cantSalida" size="8" type="text" value="0"
								iniForma="false" style="text-align: right" tabindex="11" esMoneda="true"></input></td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalMon" name="montoSalida" size="10" type="text"
								readOnly="true" disabled="true" esMoneda="true"
								iniForma="false" style="text-align: right"></input></td>
						</tr>
						<tr align="right">
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td align="right"><label for="lblTotal">Total</label>
							</td>
							<td class="separador"></td>
							<td align="right">
								<input type="text" id="cantidad" name="cantidad" path="cantidad" size="10" value="0"
								readOnly="true" disabled="true" esMoneda="true"
								iniForma="false" style="text-align: right"/>
							</td>
						</tr>
						<tr>
							<td align="center" colspan="7">
								<!-- input type="button" id="agregarSalEfec" name="agregarSalEfec" class="submit" value="Agregar" / -->
								<input type="hidden" id="billetesMonedasEntrada" name="billetesMonedasEntrada" /> 
								<input type="hidden" id="billetesMonedasSalida"	name="billetesMonedasSalida" />
							</td>
							</tr>
							</table>
						</fieldset>
					</td>
				</tr>
	 			</table>
	 		</fieldset>
	 		</td>
	 	</tr>
	</table>
	<table align="right">
		<tr>
			<td align="right">
				<a id="ligaPDF" href="RepTicketVentanillaEnvioEfectBanc.htm" target="_blank"  >
				  		<button type="button" class="submit" id="generar" style="display:none" tabindex="13">Imp. Ticket</button> 
				</a>
				<input type="submit" id="enviar" name="enviar" class="submit" value="Enviar"  tabindex="12"/>
				<button type="button" class="submit" id="impPoliza" style="display:none">Comprobante</button>
				<input type="hidden" id="polizaID" name="polizaID" iniForma="false"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" iniForma="false"/>
				<input type="hidden" id="fecha" name="fecha" path="fecha" iniForma="false" />
				<input type="hidden" id="folioTransaccion" name="folioTransaccion" iniForma="false"  />
				<input type="hidden" id="fechaSistemaP" name="fechaSistemaP" iniForma="false"  />
				<input type="hidden" id="numerobanco" name="numerobanco" iniForma="false"  />
				<input type="hidden" id="nombreBanco" name="nombreBanco" iniForma="false"  />
				<input type="hidden" id="cuenta" name="cuenta" iniForma="false"  />
			</td>
		</tr>
	</table>
	</fieldset>	
</form:form>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>
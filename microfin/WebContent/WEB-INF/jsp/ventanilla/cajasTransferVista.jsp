<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head> 
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cajasVentanillaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/ingresosOperacionesServicio.js"></script>
		<script type="text/javascript" src="js/ventanilla/cajasTransfer.js"></script>  
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cajasTransferBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Transferencias Cajas</legend>			
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	 	<tr>
	 		<td class="label" nowrap="nowrap">
	 			<label for="lblSucursalDestino">Sucursal Destino</label>
	 		</td>
	 		<td>
					<form:select id="sucursalDestino" name="sucursalDestino" path="sucursalDestino" tabindex="1">
						<form:option value="0">Selecciona:</form:option>
					</form:select>
	 		</td>
			<td class="separador"></td>
	 		<td class="label" nowrap="nowrap">
	 			<label for="lblSucursalOrigen">Sucursal Origen</label>
	 		</td>
	 		<td>
	 			<input type="text" id="sucursal" name="sucursal" readOnly="true" />
	 			<form:input id="sucursalOrigen" name="sucursalOrigen" path="sucursalOrigen" style="display:none" tabindex="2" />
					
	 		</td>
		</tr>
		<tr>
	 		<td class="label" nowrap="nowrap">
	 			<label for="lblCajaDestino">Caja Destino</label>
	 		</td>
	 		<td nowrap="nowrap">
	 			<form:input id="cajaDestino" name="cajaDestino" path="cajaDestino" size="4" tabindex="3" />
				<input type="text" id="descajaDestino" name="descajaDestino" size="36" readOnly="true" />
	 		</td>
	 		<td class="separador"></td>
	 		<td class="label" nowrap="nowrap">
	 			<label for="lblCajaOrigen">Caja Origen</label>
	 		</td>
	 		<td nowrap="nowrap">
	 			<form:input id="cajaOrigen" name="cajaOrigen" path="cajaOrigen" size="4" readOnly="true"/>
	 			<input type="text" id="desCaja" name="desCaja" size="36" readOnly="true" />
	 		</td>
		</tr>
		<tr>
			<td class="label" nowrap="nowrap">
	 			<label>Descripci&oacute;n Caja Destino:</label>
	 		</td>
			<td>
				<input type="text" id="descripCajaDestino" name="descripCajaDestino" size="41" readOnly="true" />
			</td>
			<td class="separador"></td>
			<td class="label" nowrap="nowrap">
	 			<label>Descripci&oacute;n Caja Origen:</label>
	 		</td>
			<td>
				<input type="text" id="descripCajaOrigen" name="descripCajaOrigen" size="41" readOnly="true" />
			</td>
		</tr>
		<tr>
	 		<td class="label">
	 			<label for="lblMoneda">Moneda</label>
	 		</td>
	 		<td>
	 			<form:select id="monedaID" name="monedaID" path="monedaID" tabindex="9" disabled="true" >
					<form:option value="1">PESOS</form:option>
				</form:select>
	 		</td>
	 		<td class="separador"></td>
	 		<td class="label">
	 			<label for="lblReferencia">Referencia</label>
	 		</td>
	 		<td>
	 			<input type="text" id="referencia" name="referencia" maxlength="150" size="70" onblur=" ponerMayusculas(this)" tabindex="10"/>
	 		</td>
		</tr>
		<tr>
			<td colspan="3">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Salida de Efectivo</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label"><label for="lblDenominacion">Denominaci&oacute;n</label>
							</td>
							<td class="separador"></td>
							<td><label for="lblCantidad">Disponible</label></td>
							<td class="separador"></td>
							<td><label for="lblCantidad">Cantidad</label></td>
							<td class="separador"></td>
							<td class="label"><label for="lblMonto">Monto</label>
							</td>
						</tr>
						<tr>
							<td align="right">
								<input id="denoSalMilID" iniForma="false" name="denomiSalidaID" size="8" type="hidden" readOnly="true" 
								style="text-align: right" value="1"></input> 
								<input id="denoSalMil" iniForma="false" name="denomiSalida"	size="8" type="text" readOnly="true" 
								esMoneda="true" style="text-align: right" value="1000"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalMil"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true" 
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td align="right">
								<input id="cantSalMil"name="cantSalida" size="4" type="text" tabIndex="11" value="0"iniForma="false" 
								style="text-align: right" onkeypress="return validaSoloNumero(event,this);">
								</input>
							</td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalMil" name="montoSalida" size="10" type="text"
								readOnly="true"  esMoneda="true" value="0.00"
								iniForma="false" style="text-align: right"></input></td>
						</tr>
						<tr>
							<td align="right"><input id="denoSalQuiID"
								iniForma="false" name="denomiSalidaID" size="8"
								type="hidden" readOnly="true" 
								style="text-align: right" value="2"></input> <input
								id="denoSalQui" iniForma="false" name="denomiSalida"
								size="8" type="text" readOnly="true" 
								style="text-align: right" value="500"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalQui"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true" 
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="cantSalQui" tabIndex="12"
								name="cantSalida" size="4" type="text" value="0"
								iniForma="false" style="text-align: right"  onkeypress="return validaSoloNumero(event,this);"></input></td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalQui" name="montoSalida" size="10" type="text"
								readOnly="true"  esMoneda="true"  value="0.00"
								iniForma="false" style="text-align: right"></input></td>
						</tr>
						<tr>
							<td align="right"><input id="denoSalDosID"
								iniForma="false" name="denomiSalidaID" size="8"
								type="hidden" readOnly="true" 
								style="text-align: right" value="3"></input> <input
								id="denoSalDos" iniForma="false" name="denomiSalida"
								size="8" type="text" readOnly="true" 
								style="text-align: right" value="200"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalDos"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true" 
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="cantSalDos" tabIndex="13"
								name="cantSalida" size="4" type="text" value="0"
								iniForma="false" style="text-align: right" onkeypress="return validaSoloNumero(event,this);"></input></td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalDos" name="montoSalida" size="10" type="text"
								readOnly="true"  esMoneda="true"  value="0.00"
								iniForma="false" style="text-align: right"></input></td>
						</tr>
						<tr>
							<td align="right"><input id="denoSalCienID"
								iniForma="false" name="denomiSalidaID" size="8"
								type="hidden" readOnly="true" 
								style="text-align: right" value="4"></input> <input
								id="denoSalCien" iniForma="false" name="denomiSalida"
								size="8" type="text" readOnly="true"
								style="text-align: right" value="100"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalCien"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true" 
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="cantSalCien" tabIndex="14"
								name="cantSalida" size="4" type="text" value="0"
								iniForma="false" style="text-align: right" onkeypress="return validaSoloNumero(event,this);"></input></td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalCien" name="montoSalida" size="10"
								type="text" readOnly="true"   value="0.00"
								iniForma="false" esMoneda="true"
								style="text-align: right"></input></td>
						</tr>
						<tr>
							<td align="right"><input id="denoSalCinID"
								iniForma="false" name="denomiSalidaID" size="8"
								type="hidden" readOnly="true" 
								style="text-align: right" value="5"></input> <input
								id="denoSalCin" iniForma="false" name="denomiSalida"
								size="8" type="text" readOnly="true" 
								style="text-align: right" value="50"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalCin"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true" 
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="cantSalCin" tabIndex="15"
								name="cantSalida" size="4" type="text" value="0"
								iniForma="false" style="text-align: right" onkeypress="return validaSoloNumero(event,this);"></input></td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalCin" name="montoSalida" size="10" type="text"
								readOnly="true" esMoneda="true" value="0.00"
								iniForma="false" style="text-align: right"></input></td>
						</tr>
						<tr>
							<td align="right"><input id="denoSalVeiID"
								iniForma="false" name="denomiSalidaID" size="8"
								type="hidden" readOnly="true" 
								style="text-align: right" value="6"></input> <input
								id="denoSalVei" iniForma="false" name="denomiSalida"
								size="8" type="text" readOnly="true"
								style="text-align: right" value="20"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalVei"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true"
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="cantSalVei" tabIndex="16"
								name="cantSalida" size="4" type="text" value="0"
								iniForma="false" style="text-align: right" onkeypress="return validaSoloNumero(event,this);"></input></td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalVei" name="montoSalida" size="10" type="text"
								readOnly="true"  esMoneda="true" value="0.00"
								iniForma="false" style="text-align: right"></input></td>
						</tr>
						<tr>
							<td align="right"><input id="denoSalMonID"
								iniForma="false" name="denomiSalidaID" size="8"
								type="hidden" readOnly="true" 
								style="text-align: right" value="7"></input> <input
								id="denoSalMon" iniForma="false" name="denomiSalida"
								size="8" type="text" readOnly="true" 
								style="text-align: right" value="Monedas"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalMon"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true" 
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="cantSalMon" tabIndex="17"
								name="cantSalida" size="4" type="text" value="0"
								iniForma="false" style="text-align: right"></input></td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalMon" name="montoSalida" size="10" type="text"
								readOnly="true"  esMoneda="true"  value="0.00"
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
								readOnly="true" esMoneda="true"
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
	<table align="right">
		<tr>
			<td align="right">
				<input type="submit" id="transferir" name="transferir" class="submit" value="Transferir" tabindex="20"/>
				<a id="ligaPDF" href="RepTicketCajasTransfer.htm" target="_blank"  >
				  		<button type="button" class="submit" id="generar" style="display:none">Imp. Ticket</button> 
				 </a>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" iniForma="false"/>
				<input type="hidden" id="fecha" name="fecha" path="fecha" iniForma="false" />
				<input type="hidden" id="tipoCaja" name="tipoCaja" path="tipoCaja" iniForma="false" />
				<input type="hidden" id="folioTransaccion" name="folioTransaccion" iniForma="false"  />
				<input type="hidden" id="fechaSistemaP" name="fechaSistemaP" iniForma="false"  />
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
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head> 		
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/ingresosOperacionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cajasVentanillaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>
		
		<script type="text/javascript" src="js/ventanilla/recepcionEfectivoBanco.js"></script>
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="transferBancoBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Recepción de Efectivo de Bancos</legend>			
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	 	<tr>
	 		<td colspan="2" class="label">
	 			<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend><label>Recepcion de Efectivo de Bancos</label></legend>
	 			<table  border="0" cellpadding="0" cellspacing="0" width="100%">
	 				<tr>
	 					<td class="label">
		 					<label for="lblSucursalDestino">Institución:</label>
	 					</td>
	 					<td>
							<form:input id="institucionID" name="institucionID" path="institucionID" size="3" tabindex="1" />
							<input type="text" id="nombreInstitucion" name="nombreInstitucion" size="65" readOnly="true"/>
						</td>
						<td class="separador"></td>
							<td class="label">
								<label for="lblCajaDestino">Sucursal:</label>
							</td>
							<td>
								<form:input id="sucursalID" name="sucursalID" path="sucursalID" size="3" readOnly="true"/>
								<input type="text" id="descSucursal" name="descSucursal" readOnly="true">
							</td>
					</tr>
				<tr>
						<td class="label">
							<label for="lblSucursalOrigen">Cuenta Bancaria:</label>
						</td>
						<td>
							<form:input id="numCtaInstit" name="numCtaInstit" path="numCtaInstit" tabindex="2" maxlength="20"/>
						</td>
						<td class="separador"></td>
						<td class="label"><label for="lblCajaOrigen">Caja</label></td>
					<td>
						<form:input id="cajaID" name="cajaID" path="cajaID" size="3" readOnly="true" />
						<input type="text" id="descCaja" name="descCaja" readOnly="true">
					</td>		
				</tr>
				<tr>
						<td class="label">
							<label for="lblMoneda">Moneda:</label>
						</td>
						<td>
							<form:select id="monedaID" name="monedaID" path="monedaID"  tabindex="3">
							<form:option value="0">SELECCIONAR</form:option>
							</form:select>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="lblReferencia">Referencia:</label>
						</td>
						<td>
							<form:input type="text" id="referencia" name="referencia" path="referencia"
							 size="30" onblur=" ponerMayusculas(this)" maxlength="50" tabindex="4"/>
						</td>
		</tr>
		<tr>
					<td class="label">
						<label>C.Costos:</label>
					</td>
					<td>
						<form:input type="text" id="cCostos" name="cCostos" size="10" path="cCostos" maxlength="10" tabindex="5"/>
						<input type="text" id="nombrecCostos" name="nombrecCostos"  size="40" readonly="true">
					</td>
					<td class="separador"></td>
					<td>
					</td>
				</tr>
		<tr>
			<td colspan="2">
				<div id="entradaSalida">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend><label>Entrada de Efectivo</label></legend>
									<table border="0" cellpadding="0" cellspacing="0"
										width="100%">
										<tr>
											<td class="label"><label for="lblDenominacion">Denominaci&oacute;n</label>
											</td>
											<td class="separador"></td>
											<td class="label" align="right" ><label for="lblCantidad">Cantidad</label></td>
											<td class="separador"></td>
											<td class="label" align="right"><label for="lblMonto">Monto</label>
											</td>
										</tr>
										<tr>
											<td align="right"><input id="denoEntraMilID"
												name="denomiEntradaID" size="4" type="hidden"
												readOnly="true" iniForma="false" disabled="true"
												style="text-align: right" value="1"></input> <input
												id="denoEntraMil" name="denomiEntrada" size="8"
												type="text" readOnly="true" iniForma="false"
												disabled="true" style="text-align: right"
												value="1000"></input></td>
											<td class="separador"></td>
											<td align="right"><input id="cantEntraMil"
												name="cantEntrada" size="8" type="text" value="0"
												iniForma="false" style="text-align: right" tabIndex="6" onkeypress="return validaSoloNumero(event,this);" ></input></td>
											<td class="separador"></td>
											<td align="right"><input id="montoEntraMil"
												name="montoEntrada" size="10" type="text" readOnly="true"
												iniForma="false" disabled="true" esMoneda="true"
												style="text-align: right"></input></td>
										</tr>
										<tr>
											<td align="right"><input id="denoEntraQuiID"
												name="denomiEntradaID" size="4" type="hidden"
												readOnly="true" iniForma="false" disabled="true"
												style="text-align: right" value="2"></input> <input
												id="denoEntraQui" name="denomiEntrada" size="8"
												type="text" readOnly="true" iniForma="false"
												disabled="true" style="text-align: right"
												value="500"></input></td>
											<td class="separador"></td>
											<td align="right"><input id="cantEntraQui"
												name="cantEntrada" size="8" type="text" value="0"
												iniForma="false" style="text-align: right" tabIndex="7" onkeypress="return validaSoloNumero(event,this);" ></input></td>
											<td class="separador"></td>
											<td align="right"><input id="montoEntraQui"
												name="montoEntrada" size="10" type="text" readOnly="true"
												iniForma="false" disabled="true" esMoneda="true"
												style="text-align: right"></input></td>
										</tr>
										<tr>
											<td align="right"><input id="denoEntraDosID"
												name="denomiEntradaID" size="4" type="hidden"
												readOnly="true" iniForma="false" disabled="true"
												style="text-align: right" value="3"></input> <input
												id="denoEntraDos" name="denomiEntrada" size="8"
												type="text" readOnly="true" iniForma="false"
												disabled="true" style="text-align: right"
												value="200"></input></td>
											<td class="separador"></td>
											<td align="right"><input id="cantEntraDos"
												name="cantEntrada" size="8" type="text" value="0"
												iniForma="false" style="text-align: right" tabIndex="8" onkeypress="return validaSoloNumero(event,this);"></input></td>
											<td class="separador"></td>
											<td class="label" align="right"><input
												id="montoEntraDos" name="montoEntrada" size="10"
												type="text" readOnly="true" disabled="true"
												iniForma="false" esMoneda="true"
												style="text-align: right"></input></td>
										</tr>
										<tr>
											<td align="right"><input id="denoEntraCienID"
												name="denomiEntradaID" size="4" type="hidden"
												readOnly="true" iniForma="false" disabled="true"
												style="text-align: right" value="4"></input> <input
												id="denoEntraCien" iniForma="false" name="denomiEntrada"
												size="8" type="text" readOnly="true" disabled="true"
												style="text-align: right" value="100"></input></td>
											<td class="separador"></td>
											<td align="right"><input id="cantEntraCien"
												name="cantEntrada" size="8" type="text" value="0"
												iniForma="false" style="text-align: right" tabIndex="9" onkeypress="return validaSoloNumero(event,this);"></input></td>
											<td class="separador"></td>
											<td class="label" align="right"><input
												id="montoEntraCien" name="montoEntrada" size="10"
												type="text" readOnly="true" disabled="true"
												iniForma="false" esMoneda="true"
												style="text-align: right"></input></td>
										</tr>
										<tr>
											<td align="right"><input id="denoEntraCinID"
												name="denomiEntradaID" size="4" type="hidden"
												readOnly="true" iniForma="false" disabled="true"
												style="text-align: right" value="5"></input> <input
												id="denoEntraCin" iniForma="false" name="denomiEntrada"
												size="8" type="text" readOnly="true" disabled="true"
												style="text-align: right" value="50"></input></td>
											<td class="separador"></td>
											<td align="right"><input id="cantEntraCin"
												name="cantEntrada" size="8" type="text" value="0"
												iniForma="false" style="text-align: right" tabIndex="10" onkeypress="return validaSoloNumero(event,this);"></input></td>
											<td class="separador"></td>
											<td class="label" align="right"><input
												id="montoEntraCin" name="montoEntrada" size="10"
												type="text" readOnly="true" disabled="true"
												iniForma="false" esMoneda="true"
												style="text-align: right"></input></td>
										</tr>
										<tr>
											<td align="right"><input id="denoEntraVeiID"
												name="denomiEntradaID" size="4" type="hidden"
												readOnly="true" iniForma="false" disabled="true"
												style="text-align: right" value="6"></input> <input
												id="denoEntraVei" iniForma="false" name="denomiEntrada"
												size="8" type="text" readOnly="true" disabled="true"
												style="text-align: right" value="20"></input></td>
											<td class="separador"></td>
											<td align="right"><input id="cantEntraVei"
												name="cantEntrada" size="8" type="text" value="0"
												iniForma="false" style="text-align: right" tabIndex="11" onkeypress="return validaSoloNumero(event,this);"></input></td>
											<td class="separador"></td>
											<td align="right"><input id="montoEntraVei"
												name="montoEntrada" size="10" type="text" readOnly="true"
												iniForma="false" disabled="true" esMoneda="true"
												style="text-align: right"></input></td>
										</tr>
										<tr>
											<td align="right"><input id="denoEntraMonID"
												name="denomiEntradaID" size="4" type="hidden"
												readOnly="true" iniForma="false" disabled="true"
												style="text-align: right" value="7"></input> <input
												id="denoEntraMon" iniForma="false" name="denomiEntrada"
												size="8" type="text" readOnly="true" disabled="true"
												style="text-align: right" value="Monedas"></input></td>
											<td class="separador"></td>
											<td align="right"><input id="cantEntraMon"
												name="cantEntrada" size="8" type="text" value="0"
												iniForma="false" style="text-align: right" tabIndex="12" esMoneda="true"></input></td>
											<td class="separador"></td>
											<td align="right"><input id="montoEntraMon"
												name="montoEntrada" size="10" type="text" readOnly="true"
												iniForma="false" disabled="true" esMoneda="true"
												style="text-align: right"></input></td>
										</tr>
										<tr align="right">
											<td class="separador"></td>
											<td class="separador"></td>
											<td align="right"><label for="lblTotal">Total</label>
											</td>
											<td class="separador"></td>
											<td align="right"><input id="cantidad" name="cantidad" path="cantidad" size="10" type="text" value="0"
												readOnly="true" disabled="true" esMoneda="true"
												iniForma="false" style="text-align: right"></input></td>
										</tr>
										<tr>
											<td align="center" colspan="5">
												<!-- input type="button" id="agregarEntEfec" name="agregarEntEfec" class="submit"value="Agregar" / -->
												<input type="hidden" id="billetesMonedasEntrada" name="billetesMonedasEntrada" />
											</td>
										</tr>
										
									</table>
								</fieldset>
							</td>
						</tr>
					</table>
				</div>
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
				  		<button type="button" class="submit" id="generar" style="display:none" tabIndex="14">Imp. Ticket</button> 
				</a>
				<input type="submit" id="aceptar" name="aceptar" class="submit" value="Aceptar" tabindex="13"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="fecha" name="fecha" path="fecha" iniForma="false" />
				<input type="hidden" id="numerobanco" name="numerobanco" iniForma="false"  />
				<input type="hidden" id="nombreBanco" name="nombreBanco" iniForma="false"  />
				<input type="hidden" id="cuenta" name="cuenta" iniForma="false"  />
				<input type="hidden" id="referen" name="referen" iniForma="false"  />
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
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head> 
		<script type="text/javascript" src="dwr/interface/cajasTransferServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cajasVentanillaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/ingresosOperacionesServicio.js"></script>
		
		<script type="text/javascript" src="js/ventanilla/recepcionTransfer.js"></script>
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cajasTransferBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Recepción Transferencias</legend>			
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	 	<tr>
	 		<td class="label">
	 			<label for="lblRecepcion">Recepción</label>
	 		</td>
	 		<td>
				<select id="foliosRecepcion" name="foliosRecepcion">
					<form value="0">Selecciona</option>
				</select>
	 		</td>
	 		<td>
				<input id="cajaOrigenVal" name="cajaOrigenVal" size="4" type="hidden" iniForma="false" ></input>
				<input id="polizaID" name="polizaID" size="4" type="hidden" iniForma="false" ></input>
	 		</td>
		</tr>
		<tr>
			<td colspan="5">
				<div id="entradaSalida">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend>Entrada de Efectivo</legend>
									<table border="0" cellpadding="0" cellspacing="0"
										width="100%">
										<tr>
											<td class="label"><label for="lblDenominacion">Denominaci&oacute;n</label>
											</td>
											<td class="separador"></td>
											<td><label for="lblCantidad">Cantidad</label></td>
											<td class="separador"></td>
											<td class="label"><label for="lblMonto">Monto</label>
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
												name="cantEntrada" size="4" type="text" value="0"
												iniForma="false" style="text-align: right" readonly="true"></input></td>
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
												name="cantEntrada" size="4" type="text" value="0"
												iniForma="false" style="text-align: right" readonly="true"></input></td>
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
												name="cantEntrada" size="4" type="text" value="0"
												iniForma="false" style="text-align: right" readonly="true"></input></td>
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
												name="cantEntrada" size="4" type="text" value="0"
												iniForma="false" style="text-align: right" readonly="true"></input></td>
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
												name="cantEntrada" size="4" type="text" value="0"
												iniForma="false" style="text-align: right" readonly="true"></input></td>
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
												name="cantEntrada" size="4" type="text" value="0"
												iniForma="false" style="text-align: right" readonly="true"></input></td>
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
												name="cantEntrada" size="4" type="text" value="0"
												iniForma="false" style="text-align: right" readonly="true"></input></td>
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
											<td align="right"><input id="sumTotalEnt"
												name="sumTotalEnt" size="10" type="text" value="0"
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
	
	<table align="right">
		<tr>
			<td align="right">
				<input type="submit" id="aceptar" name="aceptar" class="submit" value="Aceptar"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="sucursalID" name="sucursalID"/>
				<input type="hidden" id="cajaID" name="cajaID"/>
				<input type="hidden" id="fecha" name="fecha"/>
				<input type="hidden" id="monedaID" name="monedaID"/>
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
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/ingresosOperacionesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/seguroVidaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/utileriaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/cajasVentanillaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/opcionesPorCajaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/reversasOperCajaServicios.js"></script>
<script type="text/javascript" src="dwr/interface/reimpresionTicketServicio.js"></script>
<script type="text/javascript" src="js/jquery.lightbox-0.5.pack.js"></script>

<script type="text/javascript" src="js/ventanilla/reversaIngresosOperaciones.js"></script>
<script>
	if(parametroBean.tipoImpresoraTicket == 'A'){
		importarScriptSAFI('js/soporte/impresoraTicket.js');
	}
	if(parametroBean.tipoImpresoraTicket == 'S'){
		if(applet == null){
			importarScriptSAFI('js/WebSocketImpresion.js');
			importarScriptSAFI('js/soporte/impresoraTicketSck.js');
		}
		
	}	
</script>

<script type="text/javascript" src="js/ventanilla/impresionTickets.js"></script>
<script>
	$(function() {
		$('#imagenCte a').lightBox();
	});
</script>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="reversas">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reversa de Operaciones</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblTipoOperacion">Tipo de Operaci&oacute;n: </label>
						</td>
						<td align="left">
						<select id="tipoOperacion" name="tipoOperacion" path="tipoOperacion" tabindex="1">
																					
							</select>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="lblFechaSistema">Fecha: </label>
						</td>
						<td>
							<input id="fechaSistemaP" name="fechaSistemaP" size="13" type="text" readOnly="true" iniForma="false" />
						</td>
					</tr>
				
					<tr>
					<td class="separador" colspan="5"><br></td>
					</tr>
					<!-- ----------------------------------CARGO A CUENTA ----------------------------------------------- -->
					<tr>
						<td colspan="5">
							<div id="cargoCuenta" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend> Reversa Cargo a Cuenta</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label"><label for="lblTransaccionCC">Número  Transacción:</label></td>
											<td><input id="numeroTransaccionCC" name="numeroTransaccionCC" size="12" iniForma="false" type="text" tabindex="10"/></td>											
											<td class="separador"></td>																						
										</tr>
										
										<tr>
											<td class="label"><label for="lblCuentaAhoID">Cuenta:</label>
											</td>
											<td><input id="cuentaAhoIDCa" name="cuentaAhoIDCa"
													iniForma="false" size="20"  type="text"  readOnly="true" /></td>
											<td class="separador"></td>
											<td class="label"><label for="lblCuentaAhoID">TipoCuenta: </label></td>
											<td><input id="tipoCuentaCa" name="tipoCuentaCa" size="30"  
													type="text" readOnly="true" iniForma="false" disabled="true" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblNombreClienteca"><s:message code="safilocale.cliente"/>: </label></td>
											<td colspan="4"><input id="numClienteCa" name="numClienteCa" size="15" 
															type="text" readOnly="true"	iniForma="false" disabled="true"  /> 
												<input	id="nombreClienteCa" name="nombreClienteCa" size="60" 
														type="text" readOnly="true" iniForma="false" disabled="true" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblMoneda">Moneda:
											</label></td>
											<td><input id="monedaIDCa" name="monedaIDCa" size="4" type="text"
														 readOnly="true" disabled="true"/>
												<input id="monedaCa" name="monedaCa" size="32" type="text" 
														iniForma="false"	readOnly="true" disabled="true" 
														 /></td>										
											<td class="separador"></td>
											<td id="tdsaldoDisponCa" class="label"><label for="lblSaldo">Saldo
													Disponible: </label></td>
											<td><input id="saldoDisponCa" name="saldoDisponCa" size="25" type="text" readOnly="true"
													 disabled="true" style="text-align: right"/></td>
											
										</tr>
										<tr>
											<td class="label"><label for="lblMontoCargar">Monto: </label></td>
											<td><input id="montoCargar" name="montoCargar" size="12" type="text" esMoneda="true" 
													style="text-align: right"	iniForma="false"  disabled="true" /></td>
										</tr>
										
										<tr>
											<td class="label"><label for="lblReferencia">Referencia:
											</label></td>
											<td><textarea id="referenciaCa" name="referenciaCa"	iniForma="false" cols="30" rows="2" 
														maxlength="50" tabindex="11" ></textarea></td>
														<!-- 
											<td class="separador"></td>
											<td class="separador"></td>
											<td align="right"><a id="enlace">
													<input type="button" id="verFirmas" name="verFirmas" class="submit" value="Firmas" />
											</a>
											</td>-->
										</tr>
									</table>
								</fieldset>
							</div>
						</td>
					</tr>
					
					<!-- -------------------------------------------------ABONO A CUENTA ---------------------------------------->
					<tr>
						<td colspan="5">
							<div id="abonoCuenta" style="display: none;"> 
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend> Reversa Abono	a Cuenta</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label"><label for="lblTransaccionAC">Número  Transacción:</label></td>
											<td><input id="numeroTransaccionAC" name="numeroTransaccionAC" size="12" iniForma="false" type="text" tabindex="20"
														/></td>											
											<td class="separador"></td>																						
										</tr>
										<tr>
											<td class="label"><label for="lblCuentaAhoID">Cuenta:</label></td>
											<td><input id="cuentaAhoIDAb" name="cuentaAhoIDAb" iniForma="false" size="15" 
												 type="text" readOnly="true" disabled="true"/></td>
											<td class="separador"></td>
											<td class="label"><label for="lblCuentaAhoID">Tipo Cuenta: </label></td>
											<td><input id="tipoCuentaAb" name="tipoCuentaAb" size="30"  type="text" readOnly="true"
													iniForma="false" disabled="true" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblNombreClienteab"><s:message code="safilocale.cliente"/>:</label></td>
											<td colspan="4"><input id="numClienteAb" name="numClienteAb" size="15" type="text" readOnly="true"
															iniForma="false" disabled="true" />
												 <input	id="nombreClienteAb" name="nombreClienteAb" size="60" type="text" readOnly="true"
												 		 iniForma="false" disabled="true"  /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblMonedaab">Moneda:</label></td>
											<td><input id="monedaIDAb" name="monedaIDAb" size="4" type="text" readOnly="true" disabled="true" /> 
												<input id="monedaAb" name="monedaAb" size="32" type="text" iniForma="false" readOnly="true" 
														disabled="true"  /></td>											
											<td class="separador"></td>
											<td id="tdsaldoDisponAb" class="label"><label for="lblSaldodisponible">Saldo	Disponible: </label></td>
											<td><input id="saldoDisponAb" name="saldoDisponAb" size="25" type="text" readOnly="true"
													 disabled="true"  /></td>											
										</tr>
										<tr>
											<td class="label"><label for="lblMontoAbonar">Monto: </label></td>
											<td><input id="montoAbonar" name="montoAbonar" size="12" type="text" esMoneda="true" 
													style="text-align: right" iniForma="false"   readOnly="true"
												 	disabled="true"/></td>
										</tr>
										<tr>
											<td class="label"><label for="lblReferencia">Referencia:</label></td>
											<td><textarea id="referenciaAb" name="referenciaAb"	iniForma="false" cols="30" rows="2" maxlength="50" tabindex="21"
													></textarea></td>
										</tr>
									</table>
								</fieldset>
							</div>
						</td>
					</tr>
					

					
					<!-- ----------------------------------------GARANTIA LIQUIDA--------------------------------- -->
					<tr>
						<td colspan="5">
							<div id="garantiaLiq" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend > Reversa Garant&iacute;a L&iacute;quida</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										
										<tr>
											<td class="label"><label for="lblTransaccionGL">Número  Transacción:</label></td>
											<td><input id="numeroTransaccionGL" name="numeroTransaccionGL" size="12" iniForma="false" type="text" tabindex="30"
														/></td>											
											<td class="separador"></td>																						
										</tr>
										<tr>
											<td class="label">
												<label for="lblNombreClienteGL"><s:message code="safilocale.cliente"/>:</label>
											</td>
											<td colspan="4"><input id="numClienteGL" readOnly="true" disabled="true"
												name="numClienteGL" size="18" type="text"   />
												 <input
												id="nombreClienteGL" name="nombreClienteGL" size="60"
												type="text" readOnly="true" iniForma="false" disabled="true"
												 /></td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap"><label for="lblReferencia">N&uacute;mero Cr&eacute;dito: </label>
											</td>
											
											<td>
												<input id="referenciaGL" readOnly name="referenciaGL" size="18" type="text"  />
											</td>											
											<td class="separador"></td>	
											<td class="label"><label class="label" for="formaPago">Forma Pago:</label></td>
											<td>
												<input id="pagoGLEfectivo" name="formaPagoGL"  type="radio" value="DE" checked="checked" />
												<label for="lblpagoGLEfectivo">Efectivo</label>
												<input id="pagoGLCargoCuenta" name="formaPagoGL" type="radio" value="CC" />
												<label for="lblpagoGLCargoCuenta">Cargo a Cuenta</label>																								
											</td>
											
										</tr>
										<tr>
											<td class="label"><label for="lblCuentaAhoID">Cuenta:</label></td>
											<td><input id="cuentaAhoIDGL" name="cuentaAhoIDGL"
												iniForma="false" size="18"  type="text"  readOnly="true" disabled="true"/></td>
											<td class="separador"></td>
											<td class="label"><label for="lblTipoCta">Tipo
													Cuenta: </label></td>
											<td><input id="tipoCuentaGL" name="tipoCuentaGL"
												size="25"  type="text" readOnly="true"
												iniForma="false" disabled="true" /></td>
										</tr>
										<tr id="trsaldoDisponGL">
											<td class="label"><label for="lblSaldodisponible">Saldo Disponible:</label></td>
											<td><input id="saldoDisponGL" name="saldoDisponGL"
												size="18" type="text" readOnly="true" disabled="true"
												 /></td>
											<td class="separador"></td>	
											<td class="label"><label for="lblSaldobloq">Saldo Bloqueado: </label></td>
											<td><input id="saldoBloqGL" name="saldoBloqGL"
												size="18" type="text" readOnly="true" disabled="true"
												 style="text-align: right" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblMonedaGL">Moneda:</label></td>
											<td ><input id="monedaIDGL" name="monedaIDGL" size="2"
												type="text" readOnly="true" disabled="true"  />
												<input id="monedaGL" name="monedaGL" size="25" type="text" iniForma="false"
												readOnly="true" disabled="true"  /></td>
											<td class="separador"></td>	
											<td class="label"><label for="lblMontoGarantiaLiq">Monto:</label></td>
											<td><input id="montoGarantiaLiq" name="montoGarantiaLiq"
												size="18" type="text" esMoneda="true" readOnly="true" disabled="true"
												style="text-align: right" iniForma="false"  /></td>
											
										</tr>
										
										<tr>
											
											<td class="label" id = "tdGrupoGLlabel" style="display: none;">
												<label for="lblGrupoGL">Grupo:</label>
											</td>
											<td id = "tdGrupoGLinput" style="display: none;">
												<input id="grupoIDGL" name="grupoIDGL"
													readOnly="true" disabled="true" iniForma="false" size="17"
													 type="text" />
												<input id="grupoDesGL" name="grupoDesGL"  iniForma="false" 
												size="30"  type="text" readOnly="true"
												disabled="true" />
											</td>
											<td class="separador"></td>	
											<td class="label" id = "tdGrupoCicloGLlabel" style="display: none;">
												<label for="lblGrupoCicloDGL">Ciclo:</label>
											</td>
											<td id = "tdGrupoCicloGLinput" style="display: none;">
												<input id="cicloIDGL" name="cicloIDGL"
													readOnly="true" disabled="true" iniForma="false" size="17"
													 type="text" />
											</td>
										</tr>
									</table>
								</fieldset>
							</div>
						</td>
					</tr>
					
					
					<!-- ----------------------------------------COBRO COMISION POR APERTURA --------------------------------- -->
					<tr>
						<td colspan="5">
							<div id="comisionApertura" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend> Reversa Comisi&oacute;n
										por Apertura</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
									<tr>
											<td class="label"><label for="lblTransaccionAR">Número Transacción:</label></td>
											<td><input id="numeroTransaccionAR" name="numeroTransaccionAR" size="12" iniForma="false" type="text" tabindex="40"
														/></td>											
											<td class="separador"></td>																						
										</tr>										
										<tr>
											<td class="label"><label for="lblcreditoIDAR">Cr&eacute;dito:</label></td>
											<td><input id="creditoIDAR" name="creditoIDAR" size="17"
												iniForma="false" type="text" readOnly="true" /></td>
											<td class="separador"></td>
											<td class="label"><label for="lblclienteIDAR"><s:message code="safilocale.cliente"/>:</label></td>
											<td><input id="clienteIDAR" name="clienteIDAR" size="17"
												 type="text" readOnly="true" disabled="true"
												iniForma="false" /> 
												<input id="nombreClienteAR"
												name="nombreClienteAR" size="60"  type="text"
												readOnly="true" disabled="true" iniForma="false" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblMontoCreAR">Monto:
											</label></td>
											<td><input type="text" id="montoCreAR" name="montoCreAR"
												readOnly="true" disabled="true" size="17" 
												 esMoneda="true" iniForma="false" /></td>
											<td class="separador"></td>
											<td class="label"><label for="lblProdCred">Producto
													Cr&eacute;dito:</label></td>
											<td><input id="productoCreditoIDAR"
												name="productoCreditoIDAR" size="17" 
												type="text" readOnly="true" disabled="true" iniForma="false" />
												<input id="desProdCreditoAR" name="desProdCreditoAR"
												size="60"  type="text" readOnly="true"
												disabled="true" iniForma="false" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblcuentaIDcreAR">Cuenta
													Cargo: </label></td>
											<td><input type="text" id="cuentaAhoIDAR"
												name="cuentaAhoIDAR" readOnly="true" disabled="true"
												size="17"  type="text" iniForma="false" /> <input
												id="nomCuentaAR" name="nomCuentaAR" size="30" 
												type="text" readOnly="true" disabled="true" iniForma="false" />
											</td>
											<td class="separador"></td>
											<td class="label"><label for="lblmonedaAR">Moneda:
											</label></td>
											<td><input id="monedaIDAR" name="monedaIDAR" size="17"
												iniForma="false"  type="text" readOnly="true"
												disabled="true" /> <input id="monedaDesAR"
												name="monedaDesAR" size="30" iniForma="false" 
												type="text" readOnly="true" disabled="true" /></td>

										</tr>
										<tr>
											<td class="label"><label for="lblTipoComisionDC">Tipo
													Comisi&oacute;n:</label></td>
											<td><input id="tipoComisionAR" name="tipoComisionAR"
													readOnly="true" disabled="true" iniForma="false" size="17"
													 type="text" />
													<input id="formaCobAR" name="formaCobAR"
													readOnly="true" disabled="true" iniForma="false" size="17"
													 type="hidden" /></td>
													
											<td class="separador"></td>
											<td class="label"><label for="lblMontoComisionAR">Monto Comisión:</label></td>
											<td><input type="text" id="montoComisionAR" name="montoComisionAR"
												readOnly="true" disabled="true" size="17" 
												type="text" iniForma="false" esMoneda="true"  style="text-align: right" />
											<class="label"><label for="lblivaMontoRealAR">IVA:</label>
											<input id="ivaMontoRealAR" name="ivaMontoRealAR" size="17"
												iniForma="false" type="text" readOnly="true"
												disabled="true" esMoneda="true"  style="text-align: right" /></td>
																																																						
										</tr>
										<tr style="display: none;">
											<td class="label"><label for="lbltotalComPAgadoAR"> Comisión Pagada:</label></td>
											<td><input id="totalPagadoDepAR" name="totalPagadoDepAR"iniForma="false" size="17"
												 type="text" esMoneda="true"  style="text-align: right" eadOnly="true"
												disabled="true"/></td>	
											<td class="separador"></td>																																
										</tr>

										<tr>
											
																															
											<td class="label"><label for="lbltotalDepAR">Total:</label></td>
											<td><input id="totalDepAR" name="totalDepAR" iniForma="false" size="17"
												 type="text" esMoneda="true"  style="text-align: right" readOnly="true"/></td>	
											<td class="separador"></td>											
											<td class="label"><label for="lblComisionAR">Comisión:</label></td>
											<td><input type="text" id="comisionAR" name="comisionAR"
												readOnly="true" disabled="true" size="17" 
												type="text" iniForma="false" esMoneda="true"  style="text-align: right" />
												<class="label"><label for="lblivaAR">IVA:</label>
												<input id="ivaAR" name="ivaAR" size="17"
												iniForma="false"  type="text" readOnly="true"
												disabled="true" esMoneda="true"  style="text-align: right" /></td>
												
												
																																	
										</tr>
										<tr>	
											<td class="label" id="tdGrupoARlabel"><label for="lblGrupo">Grupo:</label>
											</td>
											<td id="tdGrupoARinput"><input id="grupoIDAR" name="grupoIDAR"
												readOnly="true" disabled="true" iniForma="false" size="17"
												 type="text" />
												<input id="grupoDesAR" name="grupoDesAR"  iniForma="false" 
												size="30" type="text" readOnly="true"
												disabled="true" /></td>
											<td class="separador"></td>																														
											<td class="label" id = "tdGrupoCicloARlabel" style="display: none;">
												<label for="lblGrupoCicloDAR">Ciclo:</label>
											</td>
											<td id = "tdGrupoCicloARinput" style="display: none;">
												<input id="cicloIDAR" name="cicloIDAR"
													readOnly="true" disabled="true" iniForma="false" size="17"
													type="text" />
											</td>																					
										</tr>
									</table>
								</fieldset>
							</div>
						</td>
					</tr>
					<!-- --------------------------------------------DESEMBOLSO DEL CREDITO---------------------------------- -->
					<tr>
						<td colspan="5">
							<div id="desembolsoCred" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend> Reversa Desembolso
										Cr&eacute;dito</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label"><label for="lblTransaccionDC">Número  Transacción:</label></td>
											<td><input id="numeroTransaccionDC" name="numeroTransaccionDC" size="12" iniForma="false" type="text" tabindex="50"
														/></td>											
											<td class="separador"></td>																						
										</tr>
										<tr>
											<td class="label"><label for="lblcreditoIDDC">Cr&eacute;dito:</label></td>
											<td><input id="creditoIDDC" name="creditoIDDC" size="17"
												iniForma="false" type="text" readOnly="true"/></td>
											<td class="separador"></td>
											<td class="label"><label for="lblclienteIDDC"><s:message code="safilocale.cliente"/>:</label></td>
											<td><input id="clienteIDDC" name="clienteIDDC" size="17"
												 type="text" readOnly="true" disabled="true"
												iniForma="false" /> <input id="nombreClienteDC"
												name="nombreClienteDC" size="50" type="text"
												readOnly="true" disabled="true" iniForma="false" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblMontoCreDC">Monto:
											</label></td>
											<td><input type="text" id="montoCreDC" name="montoCreDC"
												readOnly="true" disabled="true" size="17" 
												type="text" esMoneda="true" iniForma="false" style="text-align: right" /></td>
											<td class="separador"></td>
											<td class="label"><label for="lblProdCredDC">Producto
													Cr&eacute;dito:</label></td>
											<td><input id="productoCreditoIDDC"
												name="productoCreditoIDDC" size="17" 
												type="text" readOnly="true" disabled="true" iniForma="false" />
												<input id="desProdCreditoDC" name="desProdCreditoDC"
												size="50"  type="text" readOnly="true"
												disabled="true" iniForma="false" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblcuentaIDcreDC">Cuenta
													Cargo: </label></td>
											<td><input type="text" id="cuentaAhoIDDC"
												name="cuentaAhoIDDC" size="17" type="text"
												iniForma="false" readOnly="true" disabled="true" /> <input id="nomCuentaDC"
												name="nomCuentaDC" size="30"  type="text"
												readOnly="true" disabled="true" iniForma="false" /></td>
											<td class="separador"></td>
											<td id="tdsaldoDisponDC" class="label"><label for="lblSaldo">Saldo
													Disponible: </label></td>
											<td><input id="saldoDisponDC" name="saldoDisponDC" size="17" type="text" 
												readOnly="readonly" disabled="disabled"  style="text-align: right"/></td>
										</tr>
										<tr>	
											<td class="label"><label for="lblmonedaDC">Moneda:
											</label></td>
											<td><input id="monedaIDDC" name="monedaIDDC" size="17"
												iniForma="false" type="text" readOnly="true"
												disabled="true" /> <input id="monedaDesDC"
												name="monedaDesDC" size="30" iniForma="false" 
												type="text" readOnly="true" disabled="true" /></td>
												
											<td class="separador"></td>
												
											<td class="label"><label for="lblTipoComisionDC">Tipo
													Comisi&oacute;n:</label></td>
											<td><input id="tipoComisionDC" name="tipoComisionDC"
												readOnly="true" disabled="true" iniForma="false" size="17"
												type="text" /></td>

										</tr>
										<tr>
											<td class="label"><label for="lblComisionDC">Comisi&oacute;n:
											</label></td>
											<td><input type="text" id="comisionDC" name="comisionDC"
												readOnly="true" disabled="true" size="17" 
												type="text" iniForma="false" esMoneda="true" style="text-align: right" /></td>
											<td class="separador"></td>
											<td class="label"><label for="lblivaDC">IVA:</label></td>
											<td><input id="ivaDC" name="ivaDC" size="17"
												iniForma="false"  type="text" readOnly="true"
												disabled="true" esMoneda="true" style="text-align: right" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblTotalDesembolsoDC">Monto
													Desembolso:</label></td>
											<td><input id="totalDesembolsoDC"
												name="totalDesembolsoDC" size="17" iniForma="false"
												 type="text"  readOnly="true"
												disabled="true" esMoneda="true" style="text-align: right"/></td>
											<td class="separador"></td>	
											<td class="label"><label for="lblTotalpordesDC">Monto por Retirar:</label></td>
											<td><input id="montoPorDesemDC"
												name="montoPorDesemDC" size="17" iniForma="false"
												 type="text"  readOnly="true" disabled="true"
												esMoneda="true" style="text-align: right"/></td>
										</tr>
										<tr>
											<td class="label" id = "tdGrupoDClabel" style="display: none;">
												<label for="lblGrupoDC">Grupo:</label>
											</td>
											<td id = "tdGrupoDCinput" style="display: none;">
												<input id="grupoIDDC" name="grupoIDDC"
													readOnly="true" disabled="true" iniForma="false" size="17"
													 type="text" />
												<input id="grupoDesDC" name="grupoDesDC"  iniForma="false" 
												size="30"  type="text" readOnly="true"
												disabled="true" />
											</td>
											<td class="separador"></td>		
											<td class="label" id = "tdGrupoCicloDClabel" style="display: none;">
												<label for="lblGrupoCicloDC">Ciclo:</label>
											</td>
											<td id = "tdGrupoCicloDCinput" style="display: none;">
												<input id="cicloIDDC" name="cicloIDDC"
													readOnly="true" disabled="true" iniForma="false" size="17"
													 type="text" />
											</td>
										</tr>
										<tr>
											<td class="label"><label for="lblTotalRetirarDC">Total:</label></td>
											<td><input id="totalRetirarDC"
												name="totalRetirarDC" size="17" iniForma="false" readOnly="true"
												 type="text" esMoneda="true" style="text-align: right"/></td>
										</tr>
									</table>
								</fieldset>
							</div>
						</td>
					</tr>
					
					<!------------------------------ COBRO DEL SEGURO DE VIDA ----------------------------------------->
					<tr>
						<td colspan="5">
							<div id="cobroSeguroVida" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend>Cobro Cobertura de Riesgo</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">																																							
										<tr>
											<td class="label"><label for="lblTransaccion">Número  Transacción:</label></td>
											<td><input id="numeroTransaccionCSV" name="numeroTransaccionCSV" size="12" iniForma="false" type="text" tabindex="60"
														/></td>											
											<td class="separador"></td>																						
										</tr>
										<tr>
											<td class="label"><label for="lblCreditoIDSC">Crédito:</label></td>
											<td><input id="creditoIDSC" name="creditoIDSC" size="12" iniForma="false" type="text" 
														 style="text-align: right" readOnly="true" disabled="true"  /></td>
											
											<td class="separador"></td>											
											<td class="label"><label for="lblclienteSC"><s:message code="safilocale.cliente"/>:</label></td>
											<td><input id="clienteIDSC" name="clienteIDSC" size="12"	 type="text"
											 		readOnly="true" disabled="true" iniForma="false" style="text-align: right" />
												<input id="nombreClienteSC" name="nombreClienteSC" size="50" type="text" 
													readOnly="true" disabled="true" iniForma="false" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblMontoCreditoSC">Monto Crédito:	</label></td>
											<td><input type="text" id="montoCreditoSC" name="montoCreditoSC"	readOnly="true" disabled="true" 
													size="12"   esMoneda="true"	iniForma="false" 
													style="text-align: right" /></td>												
											<td class="separador"></td>																																																					
											
											<td class="label"><label for="lblProdCreditoSC">Producto Cr&eacute;dito:</label></td>
											<td><input id="productoCreditoSC"	name="productoCreditoSC" size="12" 
													type="text" readOnly="true" disabled="true" iniForma="false" style="text-align: right" />
												<input id="desProdCreditoSC" name="desProdCreditoSC" size="50"  type="text" 
														readOnly="true"	disabled="true" iniForma="false" /></td>
										</tr>
											
										<tr>
											<td class="label"><label for="lblEstatusCreditoC">Estatus Crédito:	</label></td>
											<td><input type="text" id="estatusCreditoSeguroC" name="estatusCreditoSeguroC"	readOnly="true" disabled="true" 
													size="12"  type="text" esMoneda="true"	iniForma="false" style="text-align: right" /></td>												
											<td class="separador"></td>
												
											<td class="label"><label for="lblCuentaC">Cuenta:	</label></td>
											<td><input type="text" id="cuentaClienteSC" name="cuentaClienteSC"	readOnly="true" disabled="true" 
													size="12"  type="text" iniForma="false" style="text-align: right" />
												<input id="descCuentaSeguroC"	name="descCuentaSeguroC" size="30" iniForma="false"  type="text" 
														readOnly="true" disabled="true" /></td>											
										</tr>									
										<tr>																						
											<td class="label"><label for="lblmonedaSC">Moneda:	</label></td>
											<td><input id="monedaSC" name="monedaSC" size="12" iniForma="false" type="text" 
														readOnly="true"	disabled="true" style="text-align: right" /> 
												<input id="monedaDesSC"	name="monedaDesSC" size="30" iniForma="false"  type="text" 
														readOnly="true" disabled="true" /></td>
											
											<td class="separador"></td>	
											<td class="label" id="tdGrupoCreditoS">
												<label for="lnlGrupoS" id="lblCreditoid">Grupo:</label></td>
											<td id="tdGrupoCreditoSInput" >
												<input id="grupoIDSC" name="grupoIDSC" readOnly="true" disabled="true" iniForma="false"
														 size="12"	 type="text" style="text-align: right"/>
												<input id="grupoDesSC" name="grupoDesSC"  iniForma="false" size="30" 
														type="text" readOnly="true"	disabled="true" /></td>																																								
										</tr>								
									
										<tr>																																																		
											<td class="label" id ="tdGrupoCicloSC" >
												<label for="lblGrupoCicloSC">Ciclo:</label></td>
											<td id ="tdGrupoCicloSinputC"  >
												<input id="cicloIDSC" name="cicloIDSC" readOnly="true" disabled="true" iniForma="false" size="12"
													type="text" /></td>											
										</tr>
								</table>
								
									<br>

									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend>Cobertura de Riesgo</legend>
										<br>
										<div>
											<table>
												<tr>
													<td class="label"><label for="lblNumPolizaSC">No. Póliza:</label></td>
													<td><input id="numeroPolizaSC" name="numeroPolizaSC" size="17"  type="text" 
														readOnly="true" disabled="true" iniForma="false" /></td>
													<td class="separador"></td>
													<td class="label"><label for="lblEstatusSC">Estatus:</label></td>
													<td><input id="estatusSeguroC" name="estatusSeguroC" size="15"
														 type="text" readOnly="true" disabled="true" iniForma="false" /></td>
												</tr> 
												<tr>
													<td class="label"><label for="lblFechaInicioC">Fecha Inicio:</label></td>
													<td><input id="fechaInicioSeguroC" name="fechaInicioSeguroC" size="17"  type="text" 
														readOnly="true" disabled="true" iniForma="false" /></td>
													<td class="separador"></td>
													<td class="label"><label for="lblFechaVenSeguroC">Fecha Vencimiento:</label></td>
													<td><input id="fechaVencimientoC" name="fechaVencimientoC" size="17"
														 type="text" readOnly="true" disabled="true" iniForma="false" /></td>
												</tr> 
												<tr>
													
													<td class="label"><label for="lblFormaPagoSC">Forma Pago:</label></td>
													
													<td class="label">
													<input type="radio" id="pagoAnticipadoSC" name="pagoAnticipadoSC" value="A"  disabled="true" />
														<label for="lblPAgoanticipadoC">Anticipado</label>&nbsp;
														<input type="radio" id="pagoDeduccionSC" name="pagoDeduccionSC" value="D"  disabled="true" /> 
														<label for="lblPagoDeduccionC">Deducción</label>
														<input type="radio" id="pagoFinanciadoSC" name="pagoFinanciadoSC" value="F"  disabled="true" /> 
														<label for="lblpagoFinanciadoSC">Financiado</label>	</td>
														
													<td class="separador"></td>
														<td class="label"><label for="lblBeneficiarioSeguroC">Beneficiario:</label></td>
													<td><input id="beneficiarioSeguroC" name="beneficiarioSeguroC" size="50"
														iniForma="false" type="text"  disabled="true"/></td>																																		
												</tr>
												<tr>
													<td class="label"><label for="lblRelacionBeneficiarioC">Relación:</label></td>
													<td><input id="relacionBeneficiarioC" name="relacionBeneficiarioC" size="6"
														iniForma="false" type="text"  disabled="true" />
														<input id="desRelacionBeneficiarioC" name="desRelacionBeneficiarioC" size="50"
														 type="text" readOnly="true" disabled="true" iniForma="false" />	</td>
													<td class="separador"></td>
													<td class="label"><label for="lblDireccionBeneficiarioC">Dirección:</label></td>
													<td><input id="direccionBeneficiarioC" name="direccionBeneficiarioC" size="50"
														 type="text" readOnly="true" disabled="true" iniForma="false" /></td>														
												</tr>
												<tr>
													
													<td class="label"><label for="lblMontoPolizaC">Monto Póliza:</label></td>
													<td><input id="montoPolizaC" name="montoPolizaC" size="17"  type="text" 
														readOnly="true" disabled="true" iniForma="false" esMoneda="true" style="text-align: right"	 /></td>
													<td class="separador"></td>
													<td class="label"><label for="lblMontoSeguroVidaC">Monto Seguro Vida:</label></td>
													<td><input id="montoSeguroVidaC" name="montoSeguroVidaC" size="17"  type="text" 
														readOnly="true" disabled="true" iniForma="false" esMoneda="true"	 /></td>												
												</tr>
												<tr>
													<td class="label"><label for="lblMontoPAgoSeguroVidaC">Monto Cobrado:	</label></td>													
													<td><input type="text" id="montoPagoSegurVidaC" name="montoPagoSegurVidaC"	readOnly="true" disabled="true" 
													size="17"  type="text" esMoneda="true"	iniForma="false"  
													style="text-align: right" /></td>
													<td class="separador"></td>
													<td class="label"><label for="lblMontoPendientePagoSeguroC">Monto Pendiente de Cobro:</label></td>
													<td><input id="montoPendienteCobro" name="montoPendienteCobro" size="17"  type="text" 
														readOnly="true" disabled="true" iniForma="false" esMoneda="true"	 /></td>																																										
												</tr>
												<tr>												
													<td class="label"><label for="lblMontoSeguroPagarC">Monto:</label></td>
													<td><input id="montoSeguroCobro" name="montoSeguroCobro" size="17"  type="text" 
														 iniForma="false" esMoneda="true"	readOnly="true" disabled="true" style="text-align: right" /></td>
												</tr>
											</table>
											</div>
									</fieldset>
									
									
								</fieldset>
							</div>
						</td>
					</tr>											
					
					<tr><!-------------------------------------------- APLICA SEGURO VIDA---------------------------- -->
						<td colspan="5">
							<div id="pagoSeguroVida" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend>Pago Cobertura de Riesgo</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										
										<tr>
											<td class="label"><label for="lblTransaccionSV">Número  Transacción:</label></td>
											<td><input id="numeroTransaccionSV" name="numeroTransaccionSV" size="12" 
														iniForma="false" type="text" tabindex="70"
														/></td>											
											<td class="separador"></td>																						
										</tr>
										<tr>
											<td class="label" nowrap="nowrap"><label for="lblCreditoIDS">Crédito:</label></td>
											<td><input id="creditoIDS" name="creditoIDS" size="12" iniForma="false" type="text" 
														 style="text-align: right" readOnly="true" /></td>
											
											<td class="separador"></td>											
											<td class="label" nowrap="nowrap"><label for="lblclienteS"><s:message code="safilocale.cliente"/>:</label></td>
											<td><input id="clienteIDS" name="clienteIDS" size="12"	  type="text"
											 		readOnly="true" disabled="true" iniForma="false"style="text-align: right" />
												<input id="nombreClienteS" name="nombreClienteS" size="50"   type="text" 
													readOnly="true" disabled="true" iniForma="false" /></td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap"><label for="lblMontoCreditoS">Monto Crédito:	</label></td>
											<td><input type="text" id="montoCreditoS" name="montoCreditoS"	readOnly="true" disabled="true" 
													size="12"  type="text" esMoneda="true"	iniForma="false" 
													style="text-align: right" /></td>												
											<td class="separador"></td>																															
											
											<td class="label"nowrap="nowrap"><label for="lblProdCreditoS">Producto Cr&eacute;dito:</label></td>
											<td><input id="productoCreditoS"	name="productoCreditoS" size="12" 
													type="text" readOnly="true" disabled="true" iniForma="false"style="text-align: right" />
												<input id="desProdCreditoS" name="desProdCreditoS" size="50"  type="text" 
														readOnly="true"	disabled="true" iniForma="false" /></td>
										</tr>	
										<tr>
											<td class="label" nowrap="nowrap"><label for="lblEstatusCredito">Estatus Crédito:	</label></td>
											<td><input type="text" id="estatusCreditoSeguro" name="estatusCreditoSeguro"	readOnly="true" disabled="true" 
													size="12"  type="text" esMoneda="true"	iniForma="false" style="text-align: right" /></td>												
											<td class="separador"></td>
											
												<td class="label"><label for="lblDiasAtraso">Días Atraso:</label></td>
											<td><input id="diasAtrasoCredito" name="diasAtrasoCredito" size="6" 
													type="text" readOnly="true" disabled="true" iniForma="false" style="text-align: right"/>
												</td>
										
										</tr>									
										<tr>	
											<td class="label"><label for="lblCuenta">Cuenta:	</label></td>
											<td><input type="text" id="cuentaClienteS" name="cuentaClienteS"	readOnly="true" disabled="true" 
													size="12"  type="text" iniForma="false" style="text-align: right" />
												<input id="descCuentaSeguro"	name="descCuentaSeguro" size="30" iniForma="false"  type="text" 
														readOnly="true" disabled="true" /></td>												
											<td class="separador"></td>
											<td class="label" ><label for="lblmonedaS">Moneda:	</label></td>
											<td><input id="monedaS" name="monedaS" size="12" iniForma="false"  type="text" 
														readOnly="true"	disabled="true" style="text-align: right" /> 
												<input id="monedaDesS"	name="monedaDesS" size="30" iniForma="false"  type="text" 
														readOnly="true" disabled="true" /></td>
										</tr>								
									
										<tr id="trGrupo" style="display: none;" >
											<td class="label"  id="tdGrupoCreditoS" >
												<label for="lnlGrupoS">Grupo:</label></td>
											<td id="tdGrupoCreditoSInput">
												<input id="grupoIDS" name="grupoIDS" readOnly="true" disabled="true" iniForma="false"
														 size="1" type="text" style="text-align: right"/>
												<input id="grupoDesS" name="grupoDesS"  iniForma="false" size="30"
														type="text" readOnly="true"	disabled="true" /></td>
											<td class="separador"></td>	
												
											<td class="label" id ="tdGrupoCicloS" >
												<label for="lblGrupoCicloS">Ciclo:</label></td>
											<td id ="tdGrupoCicloSinput">
												<input id="cicloIDS" name="cicloIDS" readOnly="true" disabled="true" iniForma="false" size="12"
													type="text" /></td>
										</tr>
								</table>								
									<br>
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend>Cobertura de Riesgo</legend>
										<br>
										<div>
											<table>
												<tr>
													<td class="label"><label for="lblNumPolizaS">No. Póliza:</label></td>
													<td><input id="numeroPolizaS" name="numeroPolizaS" size="17" type="text" 
														readOnly="true" disabled="true" iniForma="false" /></td>
													<td class="separador"></td>
													<td class="label"><label for="lblEstatusS">Estatus:</label></td>
													<td><input id="estatusSeguro" name="estatusSeguro" size="15"
														type="text" readOnly="true" disabled="true" iniForma="false" /></td>
												</tr> 
												<tr>
													<td class="label"><label for="lblFechaInicio">Fecha Inicio:</label></td>
													<td><input id="fechaInicioSeguro" name="fechaInicioSeguro" size="17" type="text" 
														readOnly="true" disabled="true" iniForma="false" /></td>
													<td class="separador"></td>
													<td class="label"><label for="lblFechaVenSeguro">Fecha Vencimiento:</label></td>
													<td><input id="fechaVencimiento" name="fechaVencimiento" size="17"
														 type="text" readOnly="true" disabled="true" iniForma="false" /></td>
												</tr> 
												<tr>
													
													<td class="label"><label for="lblFormaPagoS">Forma Pago:</label></td>
													
													<td class="label">
													<input type="radio" id="pagoAnticipadoS" name="pagoAnticipadoS" value="A"  disabled="true" />
														<label for="lblPAgoanticipado">Anticipado</label>&nbsp;
														<input type="radio" id="pagoDeduccionS" name="pagoDeduccionS" value="D"  disabled="true" /> 
														<label for="lblPagoDeduccion">Deducción</label>
														<input type="radio" id="pagoFinanciadoS" name="pagoFinanciadoS" value="F"  disabled="true" /> 
														<label for="lblpagoFinanciadoS">Financiado</label>	</td>
														
													<td class="separador"></td>
														<td class="label"><label for="lblBeneficiarioSeguro">Beneficiario:</label></td>
													<td><input id="beneficiarioSeguro" name="beneficiarioSeguro" size="50"
														iniForma="false" type="text" disabled="true"/></td>																																		
												</tr>
												<tr>
													<td class="label"><label for="lblRelacionBeneficiario">Relación:</label></td>
													<td><input id="relacionBeneficiario" name="relacionBeneficiario" size="6"
														iniForma="false" type="text"  disabled="true" />
														<input id="desRelacionBeneficiario" name="desRelacionBeneficiario" size="50"
														 type="text" readOnly="true" disabled="true" iniForma="false" />	</td>
													<td class="separador"></td>
													<td class="label"><label for="lblDireccionBeneficiario">Dirección:</label></td>
													<td><input id="direccionBeneficiario" name="direccionBeneficiario" size="50"
														 type="text" readOnly="true" disabled="true" iniForma="false" /></td>														
												</tr>
												<tr>
													
													<td class="label"><label for="lblMontoPoliza">Monto Póliza:</label></td>
													<td><input id="montoPoliza" name="montoPoliza" size="17"  type="text" 
														readOnly="true" disabled="true" iniForma="false" esMoneda="true"	 /></td>													
												</tr>
											</table>
											</div>
									</fieldset>
									
									
								</fieldset>
							</div>
						</td>
					</tr>
				
					<tr><!-------------------------------------------- USUARIO Y CONTRASEÑA---------------------------- -->
						<td colspan="5">
							<div id="usuarioContrasenia" style="display: none;">
							 	<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend>Usuario  Autoriza</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label" nowrap="nowrap"><label for="lblUsuario">Usuario:</label></td>
											<td><input id="claveUsuarioAut" name="claveUsuarioAut" size="35" iniForma="false" type="password" maxlength="45" tabindex="100"
														/></td>
											
																			
											<td class="label" nowrap="nowrap"><label for="lblContrasenia">Contraseña:</label></td>
											<td><input id="contraseniaAut" name="contraseniaAut" size="35"	 type="password" maxlength="45"
											 		iniForma="false" tabindex="101"/>
												</td>
										</tr>	
										<tr>
											<td class="label" nowrap="nowrap"><label for="lblMotivo">Motivo:</label></td>
											<td><textarea id="motivo" name="motivo" onblur="ponerMayusculas(this)" maxlength="200" 
													rows="3" cols="50"  tabindex="102"></textarea></td>
											<td class="separador" ></td>	
																				
											<input  type="hidden" id="descripcionOper" name="descripcionOper" size="50" iniForma="false" />
											<input  type="hidden" id="usuarioAutID" name="usuarioAutID" size="50" iniForma="false" />
											<input type="hidden" id="claveUsuarioLog" name="claveUsuarioLog"/>
													
										</tr>															
										
									</table>						
								 </fieldset>
							</div>
						</td>
					</tr>
					<!-- -------------------------------ENTRADAS Y SALIDAS DE EFECTIVO--------------------------->	
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
															name="cantEntrada" size="7" type="text" value="0"
															iniForma="false" style="text-align: right" onfocus="validaFocoInputMoneda(this.id);" tabindex="200"></input></td>
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
														<td align="right"><input id="cantEntraQui" onfocus="validaFocoInputMoneda(this.id);"
															name="cantEntrada" size="7" type="text" value="0"
															iniForma="false" style="text-align: right" tabindex="201"></input></td>
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
														<td align="right"><input id="cantEntraDos" onfocus="validaFocoInputMoneda(this.id);"
															name="cantEntrada" size="7" type="text" value="0"
															iniForma="false" style="text-align: right" tabindex="202"></input></td>
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
														<td align="right"><input id="cantEntraCien" onfocus="validaFocoInputMoneda(this.id);"
															name="cantEntrada" size="7" type="text" value="0"
															iniForma="false" style="text-align: right" tabindex="203"></input></td>
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
														<td align="right"><input id="cantEntraCin" onfocus="validaFocoInputMoneda(this.id);"
															name="cantEntrada" size="7" type="text" value="0"
															iniForma="false" style="text-align: right" tabindex="204"></input></td>
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
														<td align="right"><input id="cantEntraVei" onfocus="validaFocoInputMoneda(this.id);"
															name="cantEntrada" size="7" type="text" value="0"
															iniForma="false" style="text-align: right" tabindex="205"></input></td>
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
														<td align="right"><input id="cantEntraMon" onfocus="validaFocoInputMoneda(this.id);"
															name="cantEntrada" size="7" type="text" value="0"
															iniForma="false" style="text-align: right" tabindex="206"></input></td>
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
														<td align="center" colspan="5"><input type="button"
															id="agregarEntEfec" name="agregarEntEfec" class="submit"
															value="Agregar" tabindex="207"/></td>
													</tr>
												</table>
											</fieldset>
										</td>
										<td class="separador"></td>
										<td>
											<fieldset class="ui-widget ui-widget-content ui-corner-all">
												<legend>Salida de Efectivo</legend>
												<table border="0" cellpadding="0" cellspacing="0"
													width="100%">
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
														<td align="right"><input id="denoSalMilID"
															iniForma="false" name="denomiSalidaID" size="8"
															type="hidden" readOnly="true" disabled="true"
															style="text-align: right" value="1"></input> <input
															id="denoSalMil" iniForma="false" name="denomiSalida"
															size="8" type="text" readOnly="true" disabled="true"
															style="text-align: right" value="1000"></input></td>
														<td class="separador"></td>
														<td align="right"><input id="disponSalMil"
															name="disponSalida" size="8" type="text" value="0"
															iniForma="false" readOnly="true" disabled="true"
															style="text-align: right"></input></td>
														<td class="separador"></td>
														<td align="right"><input id="cantSalMil" onfocus="validaFocoInputMoneda(this.id);"
															name="cantSalida" size="7" type="text" value="0"
															iniForma="false" style="text-align: right" tabindex="208"></input></td>
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
															style="text-align: right" value="2"></input> <input
															id="denoSalQui" iniForma="false" name="denomiSalida"
															size="8" type="text" readOnly="true" disabled="true"
															style="text-align: right" value="500"></input></td>
														<td class="separador"></td>
														<td align="right"><input id="disponSalQui"
															name="disponSalida" size="8" type="text" value="0"
															iniForma="false" readOnly="true" disabled="true"
															style="text-align: right"></input></td>
														<td class="separador"></td>
														<td align="right"><input id="cantSalQui" onfocus="validaFocoInputMoneda(this.id);"
															name="cantSalida" size="7" type="text" value="0"
															iniForma="false" style="text-align: right" tabindex="209"></input></td>
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
															name="disponSalida" size="8" type="text" value="0"
															iniForma="false" readOnly="true" disabled="true"
															style="text-align: right"></input></td>
														<td class="separador"></td>
														<td align="right"><input id="cantSalDos" onfocus="validaFocoInputMoneda(this.id);"
															name="cantSalida" size="7" type="text" value="0"
															iniForma="false" style="text-align: right" tabindex="210"></input></td>
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
															name="disponSalida" size="8" type="text" value="0"
															iniForma="false" readOnly="true" disabled="true"
															style="text-align: right"></input></td>
														<td class="separador"></td>
														<td align="right"><input id="cantSalCien" onfocus="validaFocoInputMoneda(this.id);"
															name="cantSalida" size="7" type="text" value="0"
															iniForma="false" style="text-align: right" tabindex="211"></input></td>
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
															name="disponSalida" size="8" type="text" value="0"
															iniForma="false" readOnly="true" disabled="true"
															style="text-align: right"></input></td>
														<td class="separador"></td>
														<td align="right"><input id="cantSalCin" onfocus="validaFocoInputMoneda(this.id);"
															name="cantSalida" size="7" type="text" value="0"
															iniForma="false" style="text-align: right" tabindex="212"></input></td>
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
															name="disponSalida" size="8" type="text" value="0"
															iniForma="false" readOnly="true" disabled="true"
															style="text-align: right"></input></td>
														<td class="separador"></td>
														<td align="right"><input id="cantSalVei" onfocus="validaFocoInputMoneda(this.id);"
															name="cantSalida" size="7" type="text" value="0"
															iniForma="false" style="text-align: right" tabindex="213"></input></td>
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
															name="disponSalida" size="8" type="text" value="0"
															iniForma="false" readOnly="true" disabled="true"
															style="text-align: right"></input></td>
														<td class="separador"></td>
														<td align="right"><input id="cantSalMon" onfocus="validaFocoInputMoneda(this.id);"
															name="cantSalida" size="7" type="text" value="0"
															iniForma="false" style="text-align: right" tabindex="214"></input></td>
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
														<td align="right"><input id="sumTotalSal"
															name="sumTotalSal" size="10" type="text" value="0"
															readOnly="true" disabled="true" esMoneda="true"
															iniForma="false" style="text-align: right"></input></td>
													</tr>
													<tr>
														<td align="center" colspan="7"><input type="button"
															id="agregarSalEfec" name="agregarSalEfec" class="submit"
															value="Agregar" tabindex="215"/></td>
													</tr>
												</table>
											</fieldset>
										</td>
									</tr>
								</table>
							</div>
						</td>
					</tr>
					<!------------------------------------------------------TOTALES------------------------>
					<tr>
						<td colspan="5">
							<div id="totales">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend>Totales</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label"><label for="lblTotalEntradas">Total
													Entradas: </label></td>
											<td align="left" colspan="12"><input id="totalEntradas"
												name="totalEntradas" size="14" type="text" readOnly="true"
												disabled="true" esMoneda="true" style="text-align: right"
												iniForma="false" value="0"></input></td>
										</tr>
										<tr>
											<td class="label"><label for="lblTotalSalidas">Total
													Salidas: </label></td>
											<td align="left" colspan="12"><input id="totalSalidas"
												name="totalSalidas" size="14" type="text" readOnly="true"
												disabled="true" esMoneda="true" style="text-align: right"
												iniForma="false" value="0"></input></td>
										</tr>
										<tr>
											<td class="label"><label for="lblDiferencia">Diferencia:
											</label></td>
											<td align="left" colspan="12"><input id="diferencia"
												name="diferencia" size="14" type="text" readOnly="true"
												disabled="true" esMoneda="true" style="text-align: right"
												iniForma="false" value="0"></input></td>
										</tr>
										<tr>
											<td class="label"><label for="lblNumImpr">Numero
													de Impresiones: </label></td>
											<td align="left" colspan="12"><select id="numCopias"
												name="numCopias" iniForma="false" tabindex="250">
													<option selected="selected" value="1">1</option>
													<option value="2">2</option>
											</select></td>
										</tr>
									</table>
								</fieldset>
							</div>
						</td>

					</tr>
					<tr>
						<td colspan="4" align="right"><input type="submit" id="graba"
							name="graba" class="submit" value="Graba Transacción" tabindex="251" /></td>
						<td align="right">
							<a id="enlaceTicket" target="_blank"> 
								<button  type="button" id="impTicket" name="impTicket" class="submit"
									value="Imp. Ticket" style="display: none;">Imp. Ticket</button>
							</a>
						</td>
						<td><input type="hidden" id="tipoTransaccion"
							name="tipoTransaccion" iniForma="false" /></td>
					</tr>
					<tr>
						<td>
							<div id="imagenCte">
								<img id="imgCliente" src="images/user.jpg"  border="0" style="display: none;" />
							</div> 
							<input type="hidden" id="nombreInstitucion" name="nombreInstitucion" iniForma="false" /> 
							<input type="hidden" id="numeroSucursal" name="numeroSucursal" iniForma="false" /> 
							<input type="hidden" id="nombreSucursal" name="nombreSucursal" iniForma="false" /> 
							<input type="hidden" id="numeroCaja" name="numeroCaja" iniForma="false" /> 
							<input type="hidden" id="nomCajero" name="nomCajero" iniForma="false" /> 
							<input type="hidden" id="numeroTransaccion" name="numeroTransaccion" iniForma="false" /> 
							<input type="hidden" id="billetesMonedasEntrada" name="billetesMonedasEntrada" /> 
							<input type="hidden" id="billetesMonedasSalida" name="billetesMonedasSalida" />
							<input type="hidden" id="listaCuentasGLAdicional" name="listaCuentasGLAdicional"  />
							<input id="fechaSistema" name="fechaSistema" size="12" type="hidden" />
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
	<input type="hidden" id="socioClienteAlert" name="socioClienteAlert" value="<s:message code="safilocale.cliente"/>" />
</body>

<div id="mensaje" style="display: none;"></div>
</html>
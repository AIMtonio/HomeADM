<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/formTipoCalIntServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
<script type="text/javascript" src="dwr/interface/arrendamientoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/arrendaAmortiServicio.js"></script>
<script type="text/javascript" src="dwr/interface/reimpresionTicketServicio.js"></script>
<script type="text/javascript" src="dwr/interface/esquemaOtrosAccesoriosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>
<script type="text/javascript" src="dwr/interface/pslConfigProductoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tarjetaDebitoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/amortizacionCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/usuarioServicios.js"></script>
<script type="text/javascript" src="dwr/interface/impresionTicketResumenServicio.js"></script>
<script type="text/javascript" src="dwr/interface/catalogoRemesasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tiposIdentiServicio.js"></script>  
<script type="text/javascript" src="js/ventanilla/pagoApoyoEscolar.js"></script>
<script type="text/javascript" src="js/ventanilla/recepcionDocumentosSBC.js"></script>
<script type="text/javascript" src="js/ventanilla/pagoServiciosCheque.js"></script>
<script type="text/javascript" src="js/ventanilla/cobroAnualTarjetaDeb.js"></script>
<script type="text/javascript" src="js/ventanilla/salidaGastosAnticipos.js"></script>
<script type="text/javascript" src="js/ventanilla/entradaGastosAnticipos.js"></script>
<script type="text/javascript" src="js/ventanilla/reclamoHaberesExMenor.js"></script>
<script type="text/javascript" src="js/ventanilla/pagoServifun.js"></script>
<script type="text/javascript" src="js/soporte/ServerHuella.js"></script>
<script type="text/javascript" src="js/ventanilla/pagoClientesCancela.js"></script>
<script type="text/javascript" src="js/ventanilla/huellaDigitalVentanilla.js"></script>
<script type="text/javascript" src="js/ventanilla/ingresosOperacionesVista.js"></script>
<script type="text/javascript" src="js/ventanilla/impresionReTicketGeneral.js"></script>
<script type="text/javascript" src="js/ventanilla/pagoArrendamiento.js"></script>
<script type="text/javascript" src="js/ventanilla/impresionTickets.js"></script>
<script type="text/javascript" src="js/ventanilla/impresionResumenTicket.js"></script>
<script type="text/javascript" src="dwr/interface/revisionRemesasServicio.js"></script>

<script>
	$(function() {
		$('#imagenCte a').lightBox();
	});
</script>
<body>
	<div id="contenedorForma">
	<input type="hidden" id="socioClienteAlert" name="socioClienteAlert" value="<s:message code="safilocale.cliente"/>" />
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="ingresosOperaciones">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Ingresos de Operaciones</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label">
							<label for="tipoOperacion">Tipo de Operaci&oacute;n: </label>
						</td>
						<td align="left">
							<select id="tipoOperacion" name="tipoOperacion" path="tipoOperacion" tabindex="1">
							</select>
						</td>
						<td class="separador" ></td>
						<td class="label">
							<label for="lblFechaSistema">Fecha:</label>
						</td>
						<td>
							<input id="fechaSistemaP" name="fechaSistemaP" size="13" type="text" readOnly="true" iniForma="false" />

						</td>

					</tr>
					<tr id ="tarjetaIdentiCA">
						<td class="label">
							<label for="IdentificaSocio">N&uacute;mero Tarjeta:</label>
						</td>
						<td nowrap="nowrap">
							<input id="numeroTarjeta" name="numeroTarjeta" size="20" tabindex="2" type="text"/>
						</td>
					</tr>
					<%-----------------------------------------------	RETIRO EN EFECTIVO (CARGO A CUENTA) 	----------------------------------------------%>
					<tr>
						<td colspan="5">
							<div id="cargoCuenta" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Cargo a Cuenta</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label">
												<label for="lblCuentaAhoID">Cuenta:</label>
											</td>
											<td nowrap="nowrap">
												<input id="cuentaAhoIDCa" name="cuentaAhoIDCa" iniForma="false" size="13" tabindex="2" type="text" />
												<input id="saldoCargo" name="saldoCargo" type="hidden" />
												<input type="button" id="buscarMiSucEf" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit" />
												<input type="button" id="buscarGeneralEf" name="buscarGeneral" value="B&uacute;squeda General" class="submit" />
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblCuentaAhoID">Tipo Cuenta: </label>
											</td>
											<td>
												<input id="tipoCuentaCa" name="tipoCuentaCa" size="25" tabindex="3" type="text" readOnly="true" iniForma="false" disabled="true" />
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lblNombreClienteca">
													<s:message code="safilocale.cliente" />:
												</label>
											</td>
											<td colspan="4">
												<input id="numClienteCa" name="numClienteCa" size="11" type="text" readOnly="true" iniForma="false" disabled="true" tabindex="4" />
												<input id="nombreClienteCa" name="nombreClienteCa" size="60" type="text" readOnly="true" iniForma="false" disabled="true" tabindex="5" />
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lblMoneda">Moneda: </label>
											</td>
											<td>
												<input id="monedaIDCa" name="monedaIDCa" size="4" type="text" readOnly="true" disabled="true" tabindex="7" />
												<input id="monedaCa" name="monedaCa" size="32" type="text" iniForma="false" readOnly="true" disabled="true" tabindex="8" />
											</td>
											<td class="separador"></td>
											<td id="lblSaldoDis" class="label">
												<label for="lblSaldo">Saldo Disponible: </label>
											</td>
											<td>
												<input id="saldoDisponCa" name="saldoDisponCa" size="25" type="text" readOnly="true" disabled="true" tabindex="6" />
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lblMontoCargar">Monto a Cargar : </label>
											</td>
											<td>
												<input id="montoCargar" name="montoCargar" size="12" type="text" esMoneda="true" style="text-align: right" iniForma="false" tabindex="8" />
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lblReferencia">Referencia: </label>
											</td>
											<td>
												<textarea id="referenciaCa" name="referenciaCa" maxlength="50" iniForma="false" cols="30" rows="2" tabindex="9"></textarea>
											</td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td align="right">
												<a id="enlace"> <input type="button" id="verFirmas" name="verFirmas" class="submit" value="Firmas" tabindex="10" />
												</a>
											</td>
										</tr>
									</table>
								</fieldset>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<div id="comisionApertura" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Comisi&oacute;n
										por Apertura</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label"><label for="lblcreditoIDAR">Cr&eacute;dito:</label></td>
											<td><input id="creditoIDAR" name="creditoIDAR" size="17"
												iniForma="false" type="text" tabindex="2" />
												<input id="saldoCapital" name="saldoCapital" type="hidden" /></td>

											<td class="separador"></td>
											<td class="label"><label for="lblclienteIDAR"><s:message code="safilocale.cliente"/>:</label></td>
											<td><input id="clienteIDAR" name="clienteIDAR" size="17"
												tabindex="3" type="text" readOnly="true" disabled="true"
												iniForma="false" /> <input id="nombreClienteAR"
												name="nombreClienteAR" size="60" tabindex="4" type="text"
												readOnly="true" disabled="true" iniForma="false" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblMontoCreAR">Monto:
											</label></td>
											<td><input type="text" id="montoCreAR" name="montoCreAR"
												readOnly="true" disabled="true" size="17" tabindex="5"
												esMoneda="true" iniForma="false" /></td>
											<td class="separador"></td>
											<td class="label"><label for="lblProdCred">Producto
													Cr&eacute;dito:</label></td>
											<td><input id="productoCreditoIDAR"
												name="productoCreditoIDAR" size="17" tabindex="6"
												type="text" readOnly="true" disabled="true" iniForma="false" />
												<input id="desProdCreditoAR" name="desProdCreditoAR"
												size="30" tabindex="7" type="text" readOnly="true"
												disabled="true" iniForma="false" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblcuentaIDcreAR">Cuenta
													Cargo: </label></td>
											<td nowrap="nowrap"><input type="text" id="cuentaAhoIDAR"
												name="cuentaAhoIDAR" readOnly="true" disabled="true"
												size="17" tabindex="8" iniForma="false" /> <input
												id="nomCuentaAR" name="nomCuentaAR" size="30" tabindex="9"
												type="text" readOnly="true" disabled="true" iniForma="false" />
											</td>
											<td class="separador"></td>
											<td class="label"><label for="lblmonedaAR">Moneda:
											</label></td>
											<td><input id="monedaIDAR" name="monedaIDAR" size="17"
												iniForma="false" tabindex="10" type="text" readOnly="true"
												disabled="true" /> <input id="monedaDesAR"
												name="monedaDesAR" size="30" iniForma="false" tabindex="11"
												type="text" readOnly="true" disabled="true" /></td>

										</tr>
										<tr>
											<td class="label" nowrap="nowrap"><label for="lblTipoComisionDC">Tipo
													Comisi&oacute;n:</label></td>
											<td><input id="tipoComisionAR" name="tipoComisionAR"
													readOnly="true" disabled="true" iniForma="false" size="17"
													tabindex="14" type="text" />
													<input id="formaCobAR" name="formaCobAR"
													readOnly="true" disabled="true" iniForma="false" size="17"
													tabindex="14" type="hidden" /></td>

											<td class="separador"></td>
											<td class="label" nowrap="nowrap"><label for="lblMontoComisionAR">Monto Comisi&oacute;n:</label></td>
											<td><input type="text" id="montoComisionAR" name="montoComisionAR"
												readOnly="true" disabled="true" size="17" tabindex="12"
												iniForma="false" esMoneda="true"  style="text-align: right" />
											<class="label"><label for="lblivaMontoRealAR">IVA:</label>
											<input id="ivaMontoRealAR" name="ivaMontoRealAR" size="17"
												iniForma="false" tabindex="15" type="text" readOnly="true"
												disabled="true" esMoneda="true"  style="text-align: right" /></td>

										</tr>
										<tr>
										<td class="label" nowrap="nowrap"><label for="lbltotalComPAgadoAR"> Comisi&oacute;n Pagada:</label></td>
											<td><input id="totalPagadoDepAR" name="totalPagadoDepAR" iniForma="false" size="17"
												tabindex="15" type="text" esMoneda="true"  style="text-align: right" readOnly="true"
												disabled="true"/></td>
											<td class="separador"></td>

											<td class="label" nowrap="nowrap"><label for="lblComisionPendienteAR">Pendiente Pago:</label></td>
											<td><input type="text" id="comisionPendienteAR" name="comisionPendienteAR"
												readOnly="true" disabled="true" size="17" tabindex="12"
												iniForma="false" esMoneda="true"  style="text-align: right" />
												<class="label"><label for="lblivaPendienteAR">IVA:</label>
												<input id="ivaPendienteAR" name="ivaPendienteAR" size="17"
												iniForma="false" tabindex="15" type="text" readOnly="true"
												disabled="true" esMoneda="true"  style="text-align: right" /></td>
										</tr>

										<tr>
											<td class="label"><label for="lbltotalDepAR">Total:</label></td>
											<td><input id="totalDepAR" name="totalDepAR" iniForma="false" size="17"
												tabindex="15" type="text" esMoneda="true"  style="text-align: right"/></td>
											<td class="separador"></td>
											<td class="label" nowrap="nowrap"><label for="lblComisionAR">Comisi&oacute;n a Pagar:</label></td>
											<td><input type="text" id="comisionAR" name="comisionAR"
												readOnly="true" disabled="true" size="17" tabindex="12"
												type="text" iniForma="false" esMoneda="true"  style="text-align: right" />
												<class="label"><label for="lblivaAR">IVA:</label>
												<input id="ivaAR" name="ivaAR" size="17"
												iniForma="false" tabindex="15" type="text" readOnly="true"
												disabled="true" esMoneda="true"  style="text-align: right" /></td>
										</tr>
										<tr>
										<td class="label" id="tdGrupoARlabel"><label for="lblGrupo">Grupo:</label>
											</td>
											<td id="tdGrupoARinput" nowrap="nowrap"><input id="grupoIDAR" name="grupoIDAR"
												readOnly="true" disabled="true" iniForma="false" size="12"
												tabindex="14" type="text" />
												<input id="grupoDesAR" name="grupoDesAR"  iniForma="false"
												size="30" tabindex="10" type="text" readOnly="true"
												disabled="true" /></td>
											<td class="separador"></td>
											<td class="label" id = "tdGrupoCicloARlabel" style="display: none;">
												<label for="lblGrupoCicloDAR">Ciclo:</label>
											</td>
											<td id = "tdGrupoCicloARinput" style="display: none;">
												<input id="cicloIDAR" name="cicloIDAR"
													readOnly="true" disabled="true" iniForma="false" size="17"
													tabindex="16" type="text" />
											</td>
										</tr>
									</table>
								</fieldset>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="5">

						<!--  DESEMBOLSO DE CREDITO -->
							<div id="desembolsoCred" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Desembolso
										Cr&eacute;dito</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label"><label for="lblcreditoIDDC">Cr&eacute;dito:</label></td>
											<td nowrap="nowrap"><input id="creditoIDDC" name="creditoIDDC" size="17"
												iniForma="false" type="text" tabindex="2" />
												<input id="saldoAhoCre" name="saldoAhoCre"
												type="hidden"  />
												<input type ="button" id="buscarMiSucDes" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/>
												<input type ="button" id="buscarGeneralDes" name="buscarGeneral" value="B&uacute;squeda General" class="submit"/>
												</td>
											<td class="separador"></td>
											<td class="label"><label for="lblclienteIDDC"><s:message code="safilocale.cliente"/>:</label></td>
											<td nowrap="nowrap"><input id="clienteIDDC" name="clienteIDDC" size="17"
												tabindex="3" type="text" readOnly="true" disabled="true"
												iniForma="false" /> <input id="nombreClienteDC"
												name="nombreClienteDC" size="50" tabindex="4" type="text"
												readOnly="true" disabled="true" iniForma="false" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblMontoCreDC">Monto:
											</label></td>
											<td><input type="text" id="montoCreDC" name="montoCreDC"
												readOnly="true" disabled="true" size="17" tabindex="5"
												esMoneda="true" iniForma="false" style="text-align: right" /></td>
											<td class="separador"></td>
											<td class="label"><label for="lblProdCredDC">Producto
													Cr&eacute;dito:</label></td>
											<td nowrap="nowrap"><input id="productoCreditoIDDC"
												name="productoCreditoIDDC" size="17" tabindex="6"
												type="text" readOnly="true" disabled="true" iniForma="false" />
												<input id="desProdCreditoDC" name="desProdCreditoDC"
												size="50" tabindex="7" type="text" readOnly="true"
												disabled="true" iniForma="false" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblcuentaIDcreDC">Cuenta
													Cargo: </label></td>
											<td nowrap="nowrap"><input type="text" id="cuentaAhoIDDC"
												name="cuentaAhoIDDC" size="17" tabindex="8"
												iniForma="false" readOnly="true" disabled="true" /> <input id="nomCuentaDC"
												name="nomCuentaDC" size="30" tabindex="9" type="text"
												readOnly="true" disabled="true" iniForma="false" /></td>
											<td class="separador"></td>
											<td id="tdsaldoDisponDC" class="label"><label for="lblSaldo">Saldo
													Disponible: </label></td>
											<td><input id="saldoDisponDC" name="saldoDisponDC" size="17" type="text"
												readOnly="readonly" disabled="disabled" tabindex="6" style="text-align: right"/></td>
										</tr>
										<tr>
											<td class="label"><label for="lblmonedaDC">Moneda:
											</label></td>
											<td nowrap="nowrap"><input id="monedaIDDC" name="monedaIDDC" size="17"
												iniForma="false" tabindex="10" type="text" readOnly="true"
												disabled="true" /> <input id="monedaDesDC"
												name="monedaDesDC" size="30" iniForma="false" tabindex="11"
												type="text" readOnly="true" disabled="true" /></td>

											<td class="separador"></td>

											<td class="label"><label for="lblTipoComisionDC">Tipo
													Comisi&oacute;n:</label></td>
											<td><input id="tipoComisionDC" name="tipoComisionDC"
												readOnly="true" disabled="true" iniForma="false" size="17"
												tabindex="14" type="text" /></td>

										</tr>
										<tr>
											<td class="label"><label for="lblComisionDC">Comisi&oacute;n:
											</label></td>
											<td><input type="text" id="comisionDC" name="comisionDC"
												readOnly="true" disabled="true" size="17" tabindex="12"
												iniForma="false" esMoneda="true" style="text-align: right" /></td>
											<td class="separador"></td>
											<td class="label"><label for="lblivaDC">IVA:</label></td>
											<td><input id="ivaDC" name="ivaDC" size="17"
												iniForma="false" tabindex="13" type="text" readOnly="true"
												disabled="true" esMoneda="true" style="text-align: right" /></td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap"><label for="lblTotalDesembolsoDC">Monto
													Desembolso:</label></td>
											<td><input id="totalDesembolsoDC"
												name="totalDesembolsoDC" size="17" iniForma="false"
												tabindex="15" type="text"  readOnly="true"
												disabled="true" esMoneda="true" style="text-align: right"/></td>
											<td class="separador"></td>
											<td class="label" nowrap="nowrap"><label for="lblTotalpordesDC">Monto por Retirar:</label></td>
											<td><input id="montoPorDesemDC"
												name="montoPorDesemDC" size="17" iniForma="false"
												tabindex="15" type="text"  readOnly="true" disabled="true"
												esMoneda="true" style="text-align: right"/></td>
										</tr>
										<tr>
											<td class="label" id = "tdGrupoDClabel" style="display: none;">
												<label for="lblGrupoDC">Grupo:</label>
											</td>
											<td id = "tdGrupoDCinput" style="display: none;">
												<input id="grupoIDDC" name="grupoIDDC"
													readOnly="true" disabled="true" iniForma="false" size="17"
													tabindex="16" type="text" />
												<input id="grupoDesDC" name="grupoDesDC"  iniForma="false"
												size="30" tabindex="17" type="text" readOnly="true"
												disabled="true" />
											</td>
											<td class="separador"></td>
											<td class="label" id = "tdGrupoCicloDClabel" style="display: none;">
												<label for="lblGrupoCicloDC">Ciclo:</label>
											</td>
											<td id = "tdGrupoCicloDCinput" style="display: none;">
												<input id="cicloIDDC" name="cicloIDDC"
													readOnly="true" disabled="true" iniForma="false" size="17"
													tabindex="16" type="text" />
											</td>
										</tr>
										<tr>
											<td class="label"><label for="lblTotalRetirarDC">Total
													Retirar:</label></td>
											<td><input id="totalRetirarDC"
												name="totalRetirarDC" size="17" iniForma="false"
												tabindex="15" type="text"
												esMoneda="true" style="text-align: right"/></td>
											<td><input id="montoPorRetirarActDC" 	name="montoPorRetirarActDC" size="17" iniForma="true"
													 type="hidden" esMoneda="true" style="text-align: right"/></td>
										</tr>


									</table>
								</fieldset>
							</div>
						</td>
					</tr>					
					<tr>
						<td colspan="5">
							<div id="abonoCuenta" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Abono a Cuenta</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label">
												<label for="lblCuentaAhoID">Cuenta: </label>
											</td>
											<td nowrap="nowrap">
												<input id="cuentaAhoIDAb" name="cuentaAhoIDAb" iniForma="false" size="13" tabindex="2" type="text" />
												<input type="hidden" id="saldoDispoBloq" name="saldoDispoBloq" />
												<input type="button" id="buscarMiSucAb" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit" />
												<input type="button" id="buscarGeneralAb" name="buscarGeneral" value="B&uacute;squeda General" class="submit" />
											</td>
											<td class="separador"></td>
											<td nowrap="nowrap">
												<label for="lblCuentaAhoID">Tipo Cuenta: </label>
											</td>
											<td>
												<input id="tipoCuentaAb" name="tipoCuentaAb" size="25" tabindex="3" type="text" readOnly="true" iniForma="false" disabled="true" />
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lblNombreClienteab">
													<s:message code="safilocale.cliente" />:
												</label>
											</td>
											<td colspan="4">
												<input id="numClienteAb" name="numClienteAb" size="11" type="text" readOnly="true" iniForma="false" disabled="true" tabindex="4" />
												<input id="nombreClienteAb" name="nombreClienteAb" size="60" type="text" readOnly="true" iniForma="false" disabled="true" tabindex="5" />
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lblMonedaab">Moneda: </label>
											</td>
											<td>
												<input id="monedaIDAb" name="monedaIDAb" size="4" type="text" readOnly="true" disabled="true" />
												<input id="monedaAb" name="monedaAb" size="32" type="text" iniForma="false" readOnly="true" disabled="true" tabindex="7" />
											</td>
											<td class="separador"></td>
											<td id="tdsaldoDisponAb" class="label">
												<label for="lblSaldodisponible">Saldo Disponible: </label>
											</td>
											<td>
												<input id="saldoDisponAb" name="saldoDisponAb" size="25" type="text" readOnly="true" disabled="true" tabindex="6" />
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lblMontoAbonar">Monto a Abonar: </label>
											</td>
											<td>
												<input id="montoAbonar" name="montoAbonar" size="12" type="text" esMoneda="true" style="text-align: right" iniForma="false" tabindex="8" />
											</td>
											<td class="separador"></td>
											<td id="lblAdeudoProfun" class="label">
												<label for="adeudoPROFUN">Adeudo PROFUN: </label>
											</td>
											<td>
												<input id="adeudoPROFUN" name="adeudoPROFUN" size="25" type="text" esMoneda="true" style="text-align: right" iniForma="false" tabindex="8" readOnly="true" disabled="true" />
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lblReferencia">Referencia: </label>
											</td>
											<td>
												<textarea id="referenciaAb" name="referenciaAb" maxlength="50" iniForma="false" cols="30" rows="2" tabindex="9"></textarea>
											</td>
										</tr>
									</table>
									<input type='hidden' id='grabaLimitesCta' name='grabaLimitesCta' size='10' />
								</fieldset>
							</div>
						</td>
					</tr>
					<!-- ----------------------------------------garantia liquida --------------------------------- -->
					<tr>
						<td colspan="5">
							<div id="garantiaLiq" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Garant&iacute;a
										L&iacute;quida</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">

										<tr>
											<td class="label">
												<label for="lblNombreClienteGL"><s:message code="safilocale.cliente"/>:</label>
											</td>
											<td nowrap="nowrap" colspan="4">
												<input id="numClienteGL" name="numClienteGL" size="18" type="text"  tabindex="1" />
												<input id="nombreClienteGL" name="nombreClienteGL" size="50" type="text" readOnly="true" iniForma="false" disabled="true"
													tabindex="2" />
												<input type ="button" id="buscarMiSuc" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/>
												<input type ="button" id="buscarGeneral" name="buscarGeneral" value="B&uacute;squeda General" class="submit"/>

											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap"><label for="lblReferencia">N&uacute;mero Cr&eacute;dito: </label></td>
											<td><select id="referenciaGL" name="referenciaGL"
												tabindex="3" iniForma="false">
													<option value="">Seleccionar</option>
											</select></td>
											<td class="separador"></td>
											<td class="label"><label class="label" for="formaPago">Forma Pago:</label></td>
											<td>
												<input id="pagoGLEfectivo" name="formaPagoGL"  type="radio" value="DE" checked="checked"/>
												<label for="lblpagoGLEfectivo">Efectivo</label>
												<input id="pagoGLCargoCuenta" name="formaPagoGL" type="radio" value="CC"/>
												<label for="lblpagoGLCargoCuenta">Cargo a Cuenta</label>
											</td>

										</tr>
										<tr>
											<td class="label"><label for="lblCuentaAhoID">Cuenta:</label></td>
											<td><input id="cuentaAhoIDGL" name="cuentaAhoIDGL"
												iniForma="false" size="18" tabindex="4" type="text"  readOnly="true" disabled="true"/></td>
											<td class="separador"></td>
											<td class="label"><label for="lblTipoCta">Tipo
													Cuenta: </label></td>
											<td><input id="tipoCuentaGL" name="tipoCuentaGL"
												size="25" tabindex="4" type="text" readOnly="true"
												iniForma="false" disabled="true" /></td>
										</tr>
										<tr id="trsaldoBloqGL">
											<td class="label"><label for="lblSaldobloq">Saldo Bloqueado: </label></td>
											<td><input id="saldoBloqGL" name="saldoBloqGL"
												size="18" type="text" readOnly="true" disabled="true"
												tabindex="7" /></td>
											<td class="separador"></td>
											<td id="tdsaldoDisponGL" class="label" nowrap="nowrap"><label for="lblSaldodisponible">Saldo Disponible:</label></td>
											<td><input id="saldoDisponGL" name="saldoDisponGL"
												size="18" type="text" readOnly="true" disabled="true"
												tabindex="6" /></td>


										</tr>
										<tr>
											<td class="label"><label for="lblMonedaGL">Moneda:</label></td>
											<td ><input id="monedaIDGL" name="monedaIDGL" size="4"
												type="text" readOnly="true" disabled="true" tabindex="8" />
												<input id="monedaGL" name="monedaGL" size="32" type="text" iniForma="false"
												readOnly="true" disabled="true" tabindex="9" /></td>
											<td class="separador"></td>
											<td class="label"><label for="lblMontoGarantiaLiq">Monto:</label></td>
											<td><input id="montoGarantiaLiq" name="montoGarantiaLiq"
												size="18" type="text" esMoneda="true"
												style="text-align: right" iniForma="false" tabindex="13" /></td>

										</tr>

										<tr>

											<td class="label" id = "tdGrupoGLlabel" style="display: none;">
												<label for="lblGrupoGL">Grupo:</label>
											</td>
											<td id = "tdGrupoGLinput" style="display: none;">
												<input id="grupoIDGL" name="grupoIDGL"
													readOnly="true" disabled="true" iniForma="false" size="17"
													tabindex="11" type="text" />
												<input id="grupoDesGL" name="grupoDesGL"  iniForma="false"
												size="30" tabindex="12" type="text" readOnly="true"
												disabled="true" />
											</td>
											<td class="separador"></td>
											<td class="label" id = "tdGrupoCicloGLlabel" style="display: none;">
												<label for="lblGrupoCicloDGL">Ciclo:</label>
											</td>
											<td id = "tdGrupoCicloGLinput" style="display: none;">
												<input id="cicloIDGL" name="cicloIDGL"
													readOnly="true" disabled="true" iniForma="false" size="17"
													tabindex="13" type="text" />
											</td>
										</tr>

									</table>
								</fieldset>
							</div>
						</td>
					</tr>

					<!-- ------------------PAGO ARRENDAMIENTO -------------------- -->
					<tr>
						<td colspan="5">
							<div id="pagoArrendamiento" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Pago de Arrendamiento</legend>
									<table cellpadding="0" cellspacing="0" width="100%" border="0">
										<tr>
											<td class="label">
												<label for="lblArrendamientoID">Arrenda:</label>
											</td>
											<td nowrap="nowrap">
												<input type="text" id="arrendamientoID" name="arrendamientoID" size="12" iniForma="false" tabindex="2" />
												<input type ="button" id="buscarMiSucArrendamiento" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/>
												<input type ="button" id="buscarMiGralArrendamiento" name="buscarGeneral" value="B&uacute;squeda General" class="submit"/>
											</td>
											<td class="separador"></td>
											<td class="label">
												<label for="lblclienteArrendamientoID"><s:message code="safilocale.cliente"/>:</label>
											</td>
											<td><input id="clienteArrendamientoID" name="clienteArrendamientoID" size="12"  type="text"
													readOnly="true" disabled="true" />
												<input id="nomCteArrendamiento" name="nomCteArrendamiento" size="40"  type="text"
													readOnly="true" disabled="true" />
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lblmonArrendamiento">Moneda:</label>
											</td>
											<td><input id="monedaArrendamientoID" name="monedaArrendamientoID" size="12"
													 type="text" readOnly="true" disabled="true" />
												<input id="monedaArrendamiento" name="monedaArrendamiento" size="30" iniForma="false"
													 type="text" readOnly="true" disabled="true" />
											</td>
											<td class="separador"></td>
											<td class="label">
												<label for="lblStatusArrendamiento">Estatus:</label>
											</td>
											<td>
												<input id="statusArrendamiento" name="statusArrendamiento" size="12" type="text" readOnly="true" disabled="true" />
											</td>
										</tr>
										<tr>
											<td class="label"><label for="lblMonPagArrendamiento">Monto a Pagar :</label></td>
											<td>
												<input id="montoPagarArrendamiento" name="montoPagarArrendamiento" size="12"
													 type="text" esMoneda="true" iniForma="false"
													tabindex="3" style="text-align: right" />
											</td>
											<td class="separador"></td>
											<td class="label" nowrap="nowrap">
												<label for="lbldiasFaltaPagoArrendamiento">D&iacute;as Falta Pago:</label>
											</td>
											<td>
												<input id="diasFaltaPagoArrendamiento" name="diasFaltaPagoArrendamiento" size="12"  type="text" readOnly="true" disabled="true" />
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblProxFechPagoArrendamiento">Prox. Pago: </label>
											</td>
											<td>
												<input type="text" id="fecProxPagoArrendamiento" name="fecProxPagoArrendamiento" size="12" iniForma="false"  readOnly="true" disabled="true" />
											</td>
											<td class="separador"></td>
											<td class="label">
												<label for="lblprodArrendamiento">Producto Arrendado:</label>
											</td>
											<td>
												<input id="prodArrendamientoID" name="prodArrendamientoID" size="12"  type="text" iniForma="false" disabled="disabled" readonly="readonly" style="text-align: right" />
												<input type="text" id="descriProdArrendamiento" name="descriProdArrendamiento" size="30" iniForma="false" disabled="disabled" readonly="readonly"/>
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="tasaFijaArrendamiento" id="lblTasaFijaArrendamiento">Tasa Fija Anualizada: </label>
											</td>
											<td>
												<input type="text" id="tasaFijaArrendamiento" name="tasaFijaArrendamiento" size="12"
											 		esTasa="true" readOnly="true" style="text-align: right;"/>
											 	<label for="porcentaje">%</label>
											</td>
										</tr>
									</table>
									<br>
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend>Saldo Arrendamiento</legend>
										<div>
											<table>
												<tr>
													<td class="label"><label for="lblTotArrendamiento">Tipo Pago:</label></td>
													<td class="label">
														<input type="radio" id="exigibleArrendamiento" name="exigibleArrendamiento" value="E" tabindex="7" />
														<label for="anteriorexigiArrendamiento">Pago Cuota</label>
													</td>
													<td class="separador"></td>
												</tr>
												<tr>
													<td class="label">
														<label id="lblexigibleAlDiaArrendamiento"><b>Exigible al Día:</b></label></td>
													<td><input id="exigAlDiaArrendamiento" name="exigAlDiaArrendamiento"
															size="15"  type="text" readOnly="true"
															disabled="true" esMoneda="true" style="text-align: right" />
													</td>
												</tr>
											</table>
										</div>
										<br>
										<div id= "saldoArrendamiento">
											<table border="0" cellpadding="0" cellspacing="0" width="900px">
												<tr>
													<td class="label" colspan="2"><label><b>Capital </b></label>
													<td class="label" colspan="2"><label><b>Inter&eacute;s</b></label>
													<td class="label"><label><b>IVA Capital </b></label></td>
													<td><input type="text"  name="salIVACapArrendamiento" id="salIVACapArrendamiento"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" /></td>
													<td class="label" colspan="2"><label><b>Comisiones</b></label>
													<td class="label" colspan="2"><label><b>IVA Comisiones</b></label>
												</tr>
												<tr>
													<td><label>Vigente: </label></td>
													<td><input id="saldoCapVigentArrendamiento" name="saldoCapVigentArrendamiento"
														size="8" type="text" readOnly="true"
														disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td><label>Vigente: </label></td>
													<td><input type="text" name="saldoInterVigArrendamiento" id="saldoInterVigArrendamiento"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" /></td>
													<td class="label"><label><b>IVA Inter&eacute;s </b></label></td>
													<td><input type="text"  name="salIVAIntereArrendamiento" id="salIVAIntereArrendamiento"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" />
													</td>
													<td><label> Falta Pago: </label></td>
													<td><input type="text" name="saldoComFaltPagoArrendamiento"
														id="saldoComFaltPagoArrendamiento" size="8" readonly="true"
														disabled="true"  esMoneda="true"
														style="text-align: right" /></td>
													<td><label> Falta Pago: </label></td>
													<td><input type="text" name="salIVAComFalPagArrendamiento" id="salIVAComFalPagArrendamiento" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
												</tr>
												<tr>
													<td><label>Atrasado: </label></td>
													<td><input id="salCapAtrasadArrendamiento" name="salCapAtrasadArrendamiento"
														size="8" type="text" readOnly="true"
														disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td><label>Atrasado: </label></td>
													<td><input type="text" name="saldoInterAtrasArrendamiento" id="saldoInterAtrasArrendamiento"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" /></td>
													<td colspan="2"></td>
													<td><label>Otras: </label></td>
													<td><input type="text" name="saldoOtrasComisArrendamiento" id="saldoOtrasComisArrendamiento"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" /></td>
													<td><label>Otras: </label></td>
													<td><input type="text" name="saldoIVAComisiArrendamiento" id="saldoIVAComisiArrendamiento"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" /></td>
												</tr>
												<tr>
													<td><label>Vencido: </label></td>
													<td><input type="text" name="salCapVenArrendamiento" id="salCapVenArrendamiento"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" /></td>
													<td><label>Vencido: </label></td>
													<td><input type="text" name="salInterVencArrendamiento" id="salInterVencArrendamiento"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" /></td>
													<td class="label"><label><b>Moratorio</b></label></td>
													<td><input type="text"  name="saldoMorArrendamiento" id="saldoMorArrendamiento"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" /></td>
													<td><label>Seguro Inmobiliario: </label></td>
													<td><input type="text" name="salSegInComisArrendamiento" id="salSegInComisArrendamiento"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" value="0.00"/></td>
													<td><label>Seguro Inmobiliario: </label></td>
													<td><input type="text" name="salIVASegInComisArrendamiento" id="salIVASegInComisArrendamiento"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" value="0.00"/>
													</td>
												</tr>
												<tr>
													<td><label><b>Total: </b></label></td>
													<td><input name="totalCapitalArrendamiento" id="totalCapitalArrendamiento"
														type="text" size="8" readonly="true" disabled="true"
														 esMoneda="true" style="text-align: right" /></td>
													<td><label><b>Total: </b></label></td>
													<td><input type="text" name="totalInteresArrendamiento" id="totalInteresArrendamiento"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" /></td>
													<td class="label"><label><b>IVA Moratorio</b></label></td>
													<td><input type="text" name="salIVAMorArrendamiento" id="salIVAMorArrendamiento"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" /></td>
													<td><label>Seguro de Vida: </label></td>
													<td><input type="text" name="salSegVidaComisArrendamiento" id="salSegVidaComisArrendamiento"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" value="0.00"/>
													</td>

													<td><label>Seguro de Vida: </label></td>
													<td><input type="text" name="salIVASegVidaComisArrendamiento" id="salIVASegVidaComisArrendamiento"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" value="0.00"/>
													</td>
												</tr>
												<tr>
													<td colspan="6"></td>
													<td><label><b>Total: </b></label></td>
													<td><input type="text" name="totalComisiArrendamiento" id="totalComisiArrendamiento"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" /></td>
													<td><label><b>Total: </b></label></td>
													<td><input type="text" name="totalIVAComArrendamiento" id="totalIVAComArrendamiento"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" /></td>
												</tr>
											</table>
										</div>
									</fieldset>
									<br>
									<div id="divFormaPagoEfecCuenta" style="display: none;" >
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend>Forma de Pago</legend>
											<table border="0" cellpadding="0" cellspacing="0" width="50%" >
												<tr>
													<td class="label">
														<label for="lblformaPagoEfecYCuenta">Forma de Pago:</label>
													</td>
													<td>
														<input type="radio" id="formaPagoEfectivo" name="formaPagoEfectivo" value="E" tabindex ="8" checked="checked"/>
														<label for="lblforPagEfe">Efectivo</label>
													</td>
												</tr>
											</table>
										</fieldset>
									</div>
									<br>
									<input id="fechaSistema" name="fechaSistema" size="12" type="hidden" />
								</fieldset>
							</div>
						</td>
					</tr> <!-- termina PAGO DE ARRENDAMIENTO -->

					<tr>
						<td colspan="5">

						<!-- PAGO DE CREDITO -->
							<div id="pagoCredito" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Pago de Cr&eacute;dito</legend>
									<table cellpadding="0" cellspacing="0" width="100%" border="0">
										<tr>
											<td class="label">
												<label for="lblcreditoID">Cr&eacute;dito:</label>
											</td>
											<td nowrap="nowrap">
												<input type="text" id="creditoID" name="creditoID" size="12" iniForma="false" tabindex="2" />
												<input type="hidden" id="saldoCapitalInsoluto" name="saldoCapitalInsoluto"  />
												<input type ="button" id="buscarMiSucCre" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/>
												<input type ="button" id="buscarGeneralCre" name="buscarGeneral" value="B&uacute;squeda General" class="submit"/>
												<input type="hidden" id="aplicaGarAdiPagoCre" name="aplicaGarAdiPagoCre"  iniForma="false"/>
											</td>
											<td class="separador"></td>
											<td class="label">
												<label for="lblclienteID"><s:message code="safilocale.cliente"/>:</label>
											</td>
											<td><input id="clienteID" name="clienteID" size="12"  type="text"
													readOnly="true" disabled="true" />
												<input id="nombreCliente" name="nombreCliente" size="40"  type="text"
													readOnly="true" disabled="true" />
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lblPagaIVA">Paga IVA: </label></td>
											<td>
												<select id="pagaIVA" name="pagaIVA" disabled="true">
													<option value="">--</option>
													<option value="S">SI</option>
													<option value="N">NO</option>
												</select>
											</td>
											<td class="separador"></td>
											<td class="label">
												<label for="lblcuentaIDcre">Cuenta Cargo: </label></td>
											<td><input type="text" id="cuentaID" name="cuentaID" readOnly="true" disabled="true"
													size="12"  />
												<input id="nomCuenta" name="nomCuenta" size="30"  type="text"
													readOnly="true" disabled="true" /></td>
										</tr>
										<tr>
												<td class="label"><label for="lblmonedacr">Moneda:
											</label></td>
											<td><input id="monedaID" name="monedaID" size="12"
													 type="text" readOnly="true" disabled="true" />
												<input id="monedaDes" name="monedaDes" size="30" iniForma="false"
													 type="text" readOnly="true" disabled="true" /></td>
											<td class="separador"></td>
											<td id="tdSaldoCta"class="label" nowrap="nowrap"><label for="lblsaldocta1">Saldo Disponible:</label></td>
											<td><input id="saldoCta" name="saldoCta" size="12"  type="text"
													readOnly="true" disabled="true" />
											</td>
										</tr>
										<tr>
											<td class="label"><label for="lblestatus">Estatus:</label>
											</td>
											<td><input id="estatus" name="estatus" size="12"
												 type="text" readOnly="true" disabled="true" /></td>
											<td class="separador"></td>
											<td class="label"><label for="lblMontopagar">Monto a Pagar :</label></td>
											<td><input id="montoPagar" name="montoPagar" size="12"
													 type="text" esMoneda="true" iniForma="false"
													tabindex="3" style="text-align: right" />
												<input type="hidden" id="montoPagadoCredito" name="montoPagadoCredito" size="12"
													 type="text" esMoneda="true" iniForma="false"
													style="text-align: right" />
												</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap"><label for="lbldiasFaltaPago">D&iacute;as Falta Pago:</label></td>
											<td><input id="diasFaltaPago" name="diasFaltaPago" size="12"  type="text"
												readOnly="true" disabled="true" /></td>
											<td class="separador"></td>
											<td class="label" nowrap="nowrap"><label for="lblGarantiaAdicional">Garant&iacute;a Adicional:</label></td>
											<td><input id="garantiaAdicionalPC" name="garantiaAdicionalPC" esMoneda="true"
													size="12"  type="text" style="text-align: right;" readonly="readonly"/>
												<input id="ctaGLAdiID" name="ctaGLAdiID" size="12"  type="hidden" readonly="readonly"/>
											</td>
										</tr>
										<tr>
											<td class="label" id = "tdGrupoCicloCredlabel" style="display: none;">
												<label for="lblciclo">Ciclo: </label>
											</td>
											<td id = "tdGrupoCicloCredinput" style="display: none;"><input id="cicloID" name="cicloID" size="12"
												iniForma="false" type="text" readOnly="true"
												disabled="true" /></td>
											<td class="separador"></td>
											<td id="lblProrrateoPagoCred" style="display: none;">
												<label for="prorrateoPagoCred" >Prorrateo Pago: </label>
											</td>
											<td >
												<select id="prorrateoPagoCred" name="prorrateoPagoCred"  style="display: none;">
														  <option value="S">SI</option>
														  <option value="N">NO</option>
												</select>
											</td>
										</tr>
										<tr>
											<td class="label"  id = "tdGrupoGrupoCredlabel" style="display: none;" ><label for="lblmonedacr">Grupo: </label>
											</td>
											<td id = "tdGrupoGrupoCredinput" style="display: none;">
												<input id="grupoID" name="grupoID" size="12"
												iniForma="false"  type="text" readOnly="true"
												disabled="true" /> <input id="grupoDes" name="grupoDes"
												size="30"  type="text" readOnly="true" iniForma="false"
												disabled="true" />
											</td>
											<td class="separador"></td>

										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblProxFechPago">Prox. Pago: </label>
											</td>
											<td>
												<input type="text" id="fechaProxPago" name="fechaProxPago" size="12"
													iniForma="false"  readOnly="true"
													disabled="true" />
											</td>
											<td class="separador"></td>
											<td class="label"><label for="lblMontopagar">Producto Cr&eacute;dito:</label></td>
											<td>
												<input id="producCreditoID" name="producCreditoID" size="12"  type="text"
													 iniForma="false" disabled="disabled" readonly="readonly"
													style="text-align: right" />
												<input type="text" id="descripcionProd" name="descripcionProd" size="30"
													 iniForma="false" disabled="disabled" readonly="readonly"/>
												<input type="hidden" id="esAhoVoluntario" name="esAhoVoluntario" size="5"
													 iniForma="false"/>
												<input type="hidden" id="montoAhorroVol" name="montoAhorroVol" size="5"
													 iniForma="false"/>
												<input type="hidden" id="prorrateoPago" name="prorrateoPago" size="5"
													 iniForma="false"/>
											</td>
										</tr>
								 		<tr>
									   		<td class="label" nowrap="nowrap">
								        		<label for="lblcalInter">C&aacute;lculo de Inter&eacute;s: </label>
								    		</td>
								    		 <td>
								    		<form:select id="calcInteres" name="calcInteres" path="" tabindex="24" disabled= "true">
												<form:option value="">SELECCIONAR</form:option>
											</form:select>
											</td>
											<td class="separador"></td>
											<td class="label">
												<label for="tasaFija" id="lblTasaFija">Tasa Fija Anualizada: </label>
											</td>
											<td>
												<input type="text" id="tasaFija" name="tasaFija" path="tasaFija" size="12"
											 		tabindex="62" esTasa="true" readOnly="true" style="text-align: right;"/>
											 	<label for="porcentaje">%</label>
											</td>
										</tr>
										<tr name="tasaBase">
											<td class="label">
												<label for="TasaBase">Tasa Base: </label>
											</td>
										   	<td>
												<input type="text" id="tasaBase" name="tasaBase" path="tasaBase" size="12"
													readonly="true" disabled="true" tabindex="60"  />
											 	<input type="text" id="desTasaBase" name="desTasaBase" size="30"
												    readonly="true" disabled="true" tabindex="61"/>
											</td>
											<td class="separador"></td>
											<td class="label">
												<label for="SobreTasa">Valor Tasa Base: </label>
											</td>
										   	<td>
												<input type="text" id="tasaBaseValor" name="tasaBaseValor" path="" size="12"
											 		esTasa="true" tabindex="63" readOnly="true" style="text-align: right;"/>
											 	<label for="porcentaje">%</label>
											</td>
										</tr>
												<td class="label" id="lblAdeudoProfunPC" nowrap="nowrap">
												<label for="adeudoPROFUNPC">Adeudo PROFUN: </label>
												</td>
												<td>
													<input type="text" id="adeudoPROFUNPC"  size="12"
														iniForma="false"  readOnly="true"
														disabled="true" esMoneda="true" style="text-align: right"  />
												</td>
										<tr>
										</tr>
										<tr class="ocultarSeguros">
											<td class="label">
												<label>Cobra Seguro Cuota:</label>
											</td>
											<td>
												<form:select name="cobraSeguroCuota" id="cobraSeguroCuota" disabled="true" path="cobraSeguroCuota">
													<option value="N">NO</option>
													<option value="S">SI</option>
												</form:select>
											</td>
										</tr>
									</table>
									<div id = "gridIntegrantes" style="display: none;"></div>
									<br>
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend>Saldo Cr&eacute;dito</legend>
										<div>
											<table>
												<tr>
													<td class="label"><label for="lblTotcionsulta">Tipo Pago:</label></td>
													<td class="label" nowrap="nowrap">
														<input type="radio" id="totalAde" name="totalAde" value="T" tabindex="30" checked="checked" />
														<label for="siguientetotaladeu"  class="label">Total Adeudo</label>
														<input type="hidden" id="finiquito" name="finiquito" value="S" tabindex="31" iniForma="false"/>
														<input type="hidden" id="permiteFiniquito" name="permiteFiniquito" value="" tabindex="32" iniForma="false"/>
													</td>
													<td class="separador"></td>
													<td class="label">
														<input type="radio" id="exigible" name="exigible"
														value="E" tabindex="33" /> <label for="anteriorexigi">Pago Cuota</label>
													</td>
												</tr>
												<tr>
													<td class="label" colspan="2">
														<label for="lblTotalAd" id="labelTotalAdeudoPC"><b>Total Adeudo :</b></label></td>
													<td><input id="adeudoTotal" name="adeudoTotal" size="15"  type="text" readOnly="true"
															disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td class="label">
														<label id="labelPagoExigiblePC"><b>Total Pagar :</b></label></td>
													<td><input id="pagoExigible" name="pagoExigible"
															size="15"  type="text" readOnly="true"
															disabled="true" esMoneda="true" style="text-align: right" />
													</td>
													<td class="label">
														<label id="lblexigibleAlDia"><b>Exigible al Día:</b></label></td>
													<td><input id="exigibleAlDia" name="exigibleAlDia"
															size="15"  type="text" readOnly="true"
															disabled="true" esMoneda="true" style="text-align: right" />
													</td>
													<td class="label">
														<label id="lblmontoProyectado"><b>Monto Proyectado:</b></label></td>
													<td><input id="montoProyectado" name="montoProyectado"
															size="15"  type="text" readOnly="true"
															disabled="true" esMoneda="true" style="text-align: right" />
													</td>
												</tr>
												<tr>
													<td class="label" colspan="2"><label for="lblTotalAdGrup" id="labelTotalAdeGrupalPC" ><b>Total Adeudo Grupal:</b></label></td>
													<td><input id="montoTotDeudaPC" name="montoTotDeudaPC" size="15" type="text" readOnly="true"
															disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td class="label"><label id = "labelPagoExiGrupoPC"><b>Total Pagar Grupal:</b></label></td>
													<td><input id="montoTotExigiblePC" name="montoTotExigiblePC" size="15"
															type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" />
													</td>
													<td class="label"><label id = "lblExigibleAlDiaG"><b>Exigible al Día:</b></label></td>
													<td><input id="exigibleAlDiaG" name="exigibleAlDiaG" size="15"
															type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" />
													</td>
													<td class="label"><label id = "lblMontoProyectadoG"><b>Monto Proyectado:</b></label></td>
													<td><input id="montoProyectadoG" name=montoProyectadoG size="15"
															type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" />
													</td>
												</tr>
												<tr>
													<td class="separador"/>
													<td class="separador" colspan="2"/>
													<td class="label"  id="lblUltCuotaPagada" style="display: none;" ><label for="ultCuotaPagada"><b>Última Cuota Pagada:</b></label></td>
													<td><input id="ultCuotaPagada" name="ultCuotaPagada" size="15" type="text" readOnly="true"
															disabled="true"  style="text-align: right" />
													</td>
													<td class="label" id="lblFechaUltCuotaPagada" ><label for="fechaUltCuotaPagada"><b>Fecha Última Cuota Pagada: </b></label></td>
													<td><input id="fechaUltCuotaPagada" name="fechaUltCuotaPagada" size="15" type="text" readOnly="true"
															disabled="true"  style="text-align: right; display: none;" />
													</td>
													<td class="label" id="lblCuotasAtraso" style="display:none;"><label for="cuotasAtraso"><b>Cuotas en Atraso: </b></label></td>
													<td><input id="cuotasAtraso" name="cuotasAtraso" size="15"  type="text" readOnly="true"
															disabled="true" style="text-align: right;display:none;" />
													</td>
												</tr>
												<tr>
													<td class="separador" />
													<td class="separador"colspan="2"/>
													<td class="label" id="lblMontoNoCartVencida" style="display:none;"><label for="montoNoCartVencida"><b>Monto para no Pasar a Cartera Vencida: </b></label></td>
													<td><input id="montoNoCartVencida" name="montoNoCartVencida" size="15"  type="text" readOnly="true"
															disabled="true" esMoneda="true" style="text-align: right; display: none;" />
													</td>
												</tr>
											</table>
										</div>
										<br>
										<div id= "saldoCredito">
											<table border="0" cellpadding="0" cellspacing="0" width="900px">
												<tr>
													<td class="label" colspan="2"><label><b>Capital </b></label>
													<td class="label" colspan="2"><label><b>Inter&eacute;s</b></label>
													<td class="label"><label><b>IVA Inter&eacute;s </b></label></td>
													<td><input type="text"  name="saldoIVAInteres" id="saldoIVAInteres"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" /></td>
													<td class="label" colspan="2"><label><b>Comisiones</b></label>
													<td class="label" colspan="2"><label><b>IVA Comisiones</b></label>
												</tr>
												<tr>
													<td><label>Vigente: </label></td>
													<td><input id="saldoCapVigent" name="saldoCapVigent"
														size="8" type="text" readOnly="true"
														disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td><label>Ordinario: </label></td>
													<td><input type="text" name="saldoInterOrdin" id="saldoInterOrdin"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" /></td>
													<td colspan="2"></td>
													<td><label> Falta Pago: </label></td>
													<td><input type="text" name="saldoComFaltPago"
														id="saldoComFaltPago" size="8" readonly="true"
														disabled="true"  esMoneda="true"
														style="text-align: right" /></td>
													<td><label> Falta Pago: </label></td>
													<td><input type="text" name="salIVAComFalPag" id="salIVAComFalPag" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
												</tr>
												<tr>
													<td><label>Atrasado: </label></td>
													<td><input id="saldoCapAtrasad" name="saldoCapAtrasad"
														size="8" type="text" readOnly="true"
														disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td><label>Atrasado: </label></td>
													<td><input type="text" name="saldoInterAtras" id="saldoInterAtras"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" /></td>
													<td class="label"><label><b>Moratorio</b></label></td>
													<td><input type="text"  name="saldoMoratorios" id="saldoMoratorios"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" /></td>
													<td><label>Otras: </label></td>
													<td><input type="text" name="saldoOtrasComis" id="saldoOtrasComis"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" /></td>
													<td><label>Otras: </label></td>
													<td><input type="text" name="saldoIVAComisi" id="saldoIVAComisi"
														size="8" readonly="true" disabled="true"
														esMoneda="true" style="text-align: right" /></td>
												</tr>
												<tr>
													<td><label>Vencido: </label></td>
													<td><input type="text" name="saldoCapVencido" id="saldoCapVencido" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td><label>Vencido: </label></td>
													<td><input type="text" name="saldoInterVenc" id="saldoInterVenc" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" />
													</td>
													<td class="label"><label><b>IVA Moratorio</b></label></td>
													<td><input type="text" name="saldoIVAMorator" id="saldoIVAMorator" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td><label>Admon: </label></td>
													<td><input type="text" name="saldoAdmonComis" id="saldoAdmonComis" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" value="0.00" /></td>
													<td><label>Admon: </label></td>
													<td><input type="text" name="saldoIVAAdmonComisi" id="saldoIVAAdmonComisi" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" value="0.00" /></td>
												</tr>
												<tr>
													<td><label>Vencido no Exigible: </label></td>
													<td><input type="text" name="saldCapVenNoExi" id="saldCapVenNoExi" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td><label>Provisi&oacute;n:</label></td>
													<td><input type="text" name="saldoInterProvi" id="saldoInterProvi" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td></td>
													<td></td>
													<td class="label ocultaSeguro"><label>Seguro:</label></td>
													<td class="ocultaSeguro"><input id="saldoSeguroCuota" name="saldoSeguroCuota" type="text" esMoneda="true" size="8" readonly="true" disabled="true" style="text-align: right"></td>
													<td class="label ocultaSeguro"><label>Seguro:</label></td>
													<td class="ocultaSeguro"><input id="saldoIVASeguroCuota" name="saldoIVASeguroCuota" type="text" esMoneda="true" size="8" readonly="true" disabled="true" style="text-align: right"></td>

												</tr>
												<tr>
													<td><label><b>Total: </b></label></td>
													<td><input name="totalCapital" id="totalCapital" type="text" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td><label>Cal.No Cont.: </label></td>
													<td><input type="text" name="saldoIntNoConta" id="saldoIntNoConta" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td></td>
													<td></td>
													<td class="label"><label>Anual:</label></td>
													<td><input id="saldoComAnual" name="saldoComAnual" type="text" esMoneda="true" size="8" readonly="true" disabled="true" style="text-align: right"></td>
													<td class="label"><label>Anual:</label></td>
													<td><input id="saldoComAnualIVA" name="saldoComAnualIVA" type="text" esMoneda="true" size="8" readonly="true" disabled="true" style="text-align: right"></td>
												</tr>
												<tr>
													<td class="separador" colspan="2"></td>
													<td>
														<label><b>Total: </b></label>
													</td>
													<td>
														<input type="text" name="totalInteres" id="totalInteres" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" />
													</td>
													<td></td>
													<td></td>
													<td>
														<label><b>Total: </b></label>
													</td>
													<td>
														<input type="text" name="totalComisi" id="totalComisi" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" />
													</td>
													<td>
														<label><b>Total: </b></label>
													</td>
													<td>
														<input type="text" name="totalIVACom" id="totalIVACom" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" />
													</td>
												</tr>
											</table>
										</div>
										</fieldset>

								</fieldset>
							</div>
						</td>
					</tr>
						<!-- --------------------------- DEVOLUCION DE GARANTIA LIQUIDA-------------------------- -->
					<tr>
						<td colspan="5">
							<div id="devolucionGL" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Devoluci&oacute;n Garant&iacute;a L&iacute;quida</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
										<td class="label">
												<label for="lblVreditoDGL">Crédito:</label>
											</td>
											<td>
												<input id="creditoDGL" name="creditoDGL" iniForma="false" size="13" tabindex="2" type="text" />
											</td>
											<td class="separador"></td>
											<td class="label"><label for="lblProductoCredDGL">Producto Crédito: </label></td>
											<td><input id="productoCreditoDGL" name="productoCreditoDGL" size="12" tabindex="3" type="text"
													readOnly="true"	iniForma="false" disabled="true" />
											<input id="desProducCreditoDGL" name="desProducCreditoDGL" size="50" tabindex="3" type="text"
												readOnly="true"	iniForma="false" disabled="true" /></td>
										</tr>
										<tr>
										<td class="label">
												<label for="lblEstatusCreditoDGL">Estatus Crédito:</label>
											</td>
											<td>
												<input id="estatusCredDGL" name="estatusCredDGL" iniForma="false" size="13"
												 tabindex="2" type="text" readOnly="true" />
											</td>
											<td class="separador"></td>
											<td class="label"><label for="lblMontoCredDGL">Monto Crédito:</label></td>
											<td><input id="montoCreditoDGL" name="montoCreditoDGL" size="25" tabindex="3" type="text"
													readOnly="true"	iniForma="false" disabled="true" /></td>
										</tr>

											<td class="label">
												<label for="lblCuentaAhoIDDG">Cuenta:</label>
											</td>
											<td>
												<input id="cuentaAhoIDDG" name="cuentaAhoIDDG"
													iniForma="false" size="13" tabindex="2" type="text" readOnly="true" />
											</td>
											<td class="separador"></td>
											<td class="label"><label for="lblCuentaAhoIDDG">Tipo
													Cuenta: </label></td>
											<td><input id="tipoCuentaDG" name="tipoCuentaDG"
												size="25" tabindex="3" type="text" readOnly="true"
												iniForma="false" disabled="true" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblMoneda">Moneda:
											</label></td>
											<td><input id="monedaIDDG" name="monedaIDDG" size="4"
												type="text" readOnly="true" disabled="true" tabindex="7" />
												<input id="monedaDG" name="monedaDG" size="32" type="text" iniForma="false"
												readOnly="true" disabled="true" tabindex="8" /></td>
											<td class="separador"></td>
											<td class="label"><label for="lblNombreClienteDG"><s:message code="safilocale.cliente"/>:
											</label></td>
											<td colspan="4">
												<input id="numClienteDG" name="numClienteDG" size="11" type="text" readOnly="true"
													iniForma="false" disabled="true" tabindex="4" />
												<input id="nombreClienteDG" name="nombreClienteDG" size="60"
													type="text" readOnly="true" iniForma="false" disabled="true"
													tabindex="5" />
											</td>
										</tr>
										<tr id="trGrupoDGL" style="display: none;" >
											<td class="label"  id="tdGrupoCreditoDGL" >
												<label for="lnlGrupoDGL">Grupo:</label></td>
											<td id="tdGrupoCreditoSInputDGL">
												<input id="grupoIDDGL" name="grupoIDDGL" readOnly="true" disabled="true" iniForma="false"
														 size="1"	tabindex="16" type="text" style="text-align: right"/>
												<input id="grupoDesDGL" name="grupoDesDGL"  iniForma="false" size="30" tabindex="17"
														type="text" readOnly="true"	disabled="true" /></td>
											<td class="separador"></td>

											<td class="label" id ="tdGrupoCicloDGL" >
												<label for="lblGrupoCicloDGL">Ciclo:</label></td>
											<td id ="tdGrupoCicloSinputDGL">
												<input id="cicloIDDGL" name="cicloIDDGL" readOnly="true" disabled="true" iniForma="false" size="12"
													tabindex="18" type="text" /></td>
										</tr>
										<tr>
										<td class="label">
												<label for="lblMontoGL">Monto Garantía Liquída: </label>
											</td>
											<td><input id="montoTotalGLD" name="montoTotalGLD" size="12"
												type="text" esMoneda="true" style="text-align: right"
												iniForma="false"  disabled="true"/></td>
											<td class="separador"></td>
										<td id="tdsaldoDisponDG" class="label"><label for="lblSaldo">Saldo
													Disponible: </label></td>
											<td><input id="saldoDisponDG" name="saldoDisponDG"
												size="25" type="text" readOnly="true" disabled="true"
												tabindex="6" /></td>
										</tr>
										<tr>
											<td class="label">
												<label for="lblMontoRetirarGL">Monto: </label>
											</td>
											<td><input id="montoDevGL" name="montoDevGL" size="12"
												type="text" esMoneda="true" style="text-align: right"
												iniForma="false" tabindex="8" disabled="true"/></td>
											<td class="separador"></td>


										</tr>


									</table>
								</fieldset>
							</div>
						</td>
					</tr>
					<tr>
					<!------------------------------ COBRO DEL SEGURO DE VIDA ----------------------------------------->
						<td colspan="5">
							<div id="cobroSeguroVida" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Cobro Póliza Cobertura de Riesgo</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label"><label for="lblCreditoIDSC">Cr&eacute;dito:</label></td>
											<td><input id="creditoIDSC" name="creditoIDSC" size="12" iniForma="false" type="text"
														tabindex="1" /></td>

											<td class="separador"></td>
											<td class="label"><label for="lblclienteSC"><s:message code="safilocale.cliente"/>:</label></td>
											<td><input id="clienteIDSC" name="clienteIDSC" size="12"	tabindex="2" type="text"
											 		readOnly="true" disabled="true" iniForma="false" style="text-align: right" />
												<input id="nombreClienteSC" name="nombreClienteSC" size="50" tabindex="4" type="text"
													readOnly="true" disabled="true" iniForma="false" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblMontoCreditoSC">Monto Cr&eacute;dito:	</label></td>
											<td><input type="text" id="montoCreditoSC" name="montoCreditoSC"	readOnly="true" disabled="true"
													size="12" tabindex="5"  esMoneda="true"	iniForma="false"
													style="text-align: right" /></td>
											<td class="separador"></td>

											<td class="label"><label for="lblProdCreditoSC">Producto Cr&eacute;dito:</label></td>
											<td><input id="productoCreditoSC"	name="productoCreditoSC" size="12" tabindex="6"
													type="text" readOnly="true" disabled="true" iniForma="false" style="text-align: right" />
												<input id="desProdCreditoSC" name="desProdCreditoSC" size="50" tabindex="7" type="text"
														readOnly="true"	disabled="true" iniForma="false" /></td>
										</tr>

										<tr>
											<td class="label"><label for="lblEstatusCreditoC">Estatus Cr&eacute;dito:	</label></td>
											<td><input type="text" id="estatusCreditoSeguroC" name="estatusCreditoSeguroC"	readOnly="true" disabled="true"
													size="12" tabindex="8"  esMoneda="true"	iniForma="false" style="text-align: right" /></td>
											<td class="separador"></td>

											<td class="label"><label for="lblCuentaC">Cuenta:	</label></td>
											<td><input type="text" id="cuentaClienteSC" name="cuentaClienteSC"	readOnly="true" disabled="true"
													size="12" tabindex="10"  iniForma="false" style="text-align: right" />
												<input id="descCuentaSeguroC"	name="descCuentaSeguroC" size="30" iniForma="false" tabindex="11" type="text"
														readOnly="true" disabled="true" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblmonedaSC">Moneda:	</label></td>
											<td><input id="monedaSC" name="monedaSC" size="12" iniForma="false" tabindex="12" type="text"
														readOnly="true"	disabled="true" style="text-align: right" />
												<input id="monedaDesSC"	name="monedaDesSC" size="30" iniForma="false" tabindex="13" type="text"
														readOnly="true" disabled="true" /></td>

											<td class="separador"></td>
											<td class="label" id="tdGrupoCreditoS">
												<label for="lnlGrupoS" id="lblCreditoid">Grupo:</label></td>
											<td id="tdGrupoCreditoSInput" >
												<input id="grupoIDSC" name="grupoIDSC" readOnly="true" disabled="true" iniForma="false"
														 size="12"	tabindex="16" type="text" style="text-align: right"/>
												<input id="grupoDesSC" name="grupoDesSC"  iniForma="false" size="30" tabindex="17"
														type="text" readOnly="true"	disabled="true" /></td>
										</tr>

										<tr>
											<td class="label" id ="tdGrupoCicloSC" >
												<label for="lblGrupoCicloSC">Ciclo:</label></td>
											<td id ="tdGrupoCicloSinputC"  >
												<input id="cicloIDSC" name="cicloIDSC" readOnly="true" disabled="true" iniForma="false" size="12"
													tabindex="18" type="text" /></td>

										</tr>

								</table>

									<br>

									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend>Cobertura de Riesgo</legend>
										<br>
										<div>
											<table>
												<tr>
													<td class="label"><label for="lblNumPolizaSC">No. P&oacute;liza:</label></td>
													<td><input id="numeroPolizaSC" name="numeroPolizaSC" size="17" tabindex="19" type="text"
														readOnly="true" disabled="true" iniForma="false" /></td>
													<td class="separador"></td>
													<td class="label"><label for="lblEstatusSC">Estatus:</label></td>
													<td><input id="estatusSeguroC" name="estatusSeguroC" size="15"
														tabindex="20" type="text" readOnly="true" disabled="true" iniForma="false" /></td>
												</tr>
												<tr>
													<td class="label"><label for="lblFechaInicioC">Fecha Inicio:</label></td>
													<td><input id="fechaInicioSeguroC" name="fechaInicioSeguroC" size="17" tabindex="21" type="text"
														readOnly="true" disabled="true" iniForma="false" /></td>
													<td class="separador"></td>
													<td class="label"><label for="lblFechaVenSeguroC">Fecha Vencimiento:</label></td>
													<td><input id="fechaVencimientoC" name="fechaVencimientoC" size="17"
														tabindex="22" type="text" readOnly="true" disabled="true" iniForma="false" /></td>
												</tr>
												<tr>

													<td class="label"><label for="lblFormaPagoSC">Forma Pago:</label></td>

													<td class="label">
													<input type="radio" id="pagoAnticipadoSC" name="pagoAnticipadoSC" value="A" tabindex="23" disabled="true" />
														<label for="lblPAgoanticipadoC">Anticipado</label>&nbsp;
														<input type="radio" id="pagoDeduccionSC" name="pagoDeduccionSC" value="D" tabindex="24" disabled="true" />
														<label for="lblPagoDeduccionC">Deducci&oacute;n</label>
														<input type="radio" id="pagoFinanciadoSC" name="pagoFinanciadoSC" value="F" tabindex="25" disabled="true" />
														<label for="lblpagoFinanciadoSC">Financiado</label>	</td>

													<td class="separador"></td>
														<td class="label"><label for="lblBeneficiarioSeguroC">Beneficiario:</label></td>
													<td><input id="beneficiarioSeguroC" name="beneficiarioSeguroC" size="50"
														iniForma="false" type="text" tabindex="26" disabled="true"/></td>
												</tr>
												<tr>
													<td class="label"><label for="lblRelacionBeneficiarioC">Relaci&oacute;n:</label></td>
													<td nowrap="nowrap"><input id="relacionBeneficiarioC" name="relacionBeneficiarioC" size="6"
														iniForma="false" type="text" tabindex="28"  disabled="true" />
														<input id="desRelacionBeneficiarioC" name="desRelacionBeneficiarioC" size="50"
														tabindex="29" type="text" readOnly="true" disabled="true" iniForma="false" />	</td>
													<td class="separador">
													<td class="label"><label for="lblDireccionBeneficiarioC">Direcci&oacute;n:</label></td>
													<td><input id="direccionBeneficiarioC" name="direccionBeneficiarioC" size="50"
														tabindex="27" type="text" readOnly="true" disabled="true" iniForma="false" /></td>
												</tr>
												<tr>

													<td class="label"><label for="lblMontoPolizaC">Monto P&oacute;liza:</label></td>
													<td><input id="montoPolizaC" name="montoPolizaC" size="17" tabindex="30" type="text"
														readOnly="true" disabled="true" iniForma="false" esMoneda="true"	 /></td>
													<td class="separador">
													<td class="label" nowrap="nowrap"><label for="lblMontoSeguroVidaC">Monto Seguro Vida:</label></td>
													<td><input id="montoSeguroVidaC" name="montoSeguroVidaC" size="17" tabindex="30" type="text"
														readOnly="true" disabled="true" iniForma="false" esMoneda="true"/></td>
												</tr>
												<tr>
													<td class="label" nowrap="nowrap"><label for="lblMontoPAgoSeguroVidaC">Monto Cobrado:	</label></td>
													<td><input type="text" id="montoPagoSegurVidaC" name="montoPagoSegurVidaC"	readOnly="true" disabled="true"
													size="12" tabindex="5" esMoneda="true"	iniForma="false"
													style="text-align: right" /></td>
													<td class="separador"></td>
													<td class="label" nowrap="nowrap"><label for="lblMontoPendientePagoSeguroC">Monto Pendiente de Cobro:</label></td>
													<td><input id="montoPendienteCobro" name="montoPendienteCobro" size="17" tabindex="30" type="text"
														readOnly="true" disabled="true" iniForma="false" esMoneda="true"	 /></td>
												</tr>
												<tr>
													<td class="label" nowrap="nowrap"><label for="lblMontoSeguroPagarC">Monto a Cobrar:</label></td>
													<td><input id="montoSeguroCobro" name="montoSeguroCobro" size="17" tabindex="30" type="text"
														 iniForma="false" esMoneda="true"	 /></td>
												</tr>
											</table>
											</div>
									</fieldset>


								</fieldset>
							</div>
						</td>
					</tr>

					<tr>
						<td colspan="5">
							<div id="pagoSeguroVida" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Pago Póliza Cobertura de Riesgo</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label" nowrap="nowrap"><label for="lblCreditoIDS">Cr&eacute;dito:</label></td>
											<td><input id="creditoIDS" name="creditoIDS" size="12" iniForma="false" type="text"
														tabindex="1" /></td>

											<td class="separador"></td>
											<td class="label" nowrap="nowrap"><label for="lblclienteS"><s:message code="safilocale.cliente"/>:</label></td>
											<td><input id="clienteIDS" name="clienteIDS" size="12"	tabindex="2" type="text"
											 		readOnly="true" disabled="true" iniForma="false" style="text-align: right" />
												<input id="nombreClienteS" name="nombreClienteS" size="50" tabindex="4" type="text"
													readOnly="true" disabled="true" iniForma="false" /></td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap"><label for="lblMontoCreditoS">Monto Cr&eacute;dito:	</label></td>
											<td><input type="text" id="montoCreditoS" name="montoCreditoS"	readOnly="true" disabled="true"
													size="12" tabindex="5" esMoneda="true"	iniForma="false"
													style="text-align: right" /></td>
											<td class="separador"></td>

											<td class="label" nowrap="nowrap"><label for="lblProdCreditoS">Producto Cr&eacute;dito:</label></td>
											<td><input id="productoCreditoS"	name="productoCreditoS" size="12" tabindex="6"
													type="text" readOnly="true" disabled="true" iniForma="false" style="text-align: right" />
												<input id="desProdCreditoS" name="desProdCreditoS" size="50" tabindex="7" type="text"
														readOnly="true"	disabled="true" iniForma="false" /></td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap"><label for="lblEstatusCredito">Estatus Cr&eacute;dito:	</label></td>
											<td><input type="text" id="estatusCreditoSeguro" name="estatusCreditoSeguro"	readOnly="true" disabled="true"
													size="12" tabindex="8" esMoneda="true"	iniForma="false" style="text-align: right" /></td>
											<td class="separador"></td>

												<td class="label"><label for="lblDiasAtraso">D&iacute;as Atraso:</label></td>
											<td><input id="diasAtrasoCredito" name="diasAtrasoCredito" size="6" tabindex="9"
													type="text" readOnly="true" disabled="true" iniForma="false" style="text-align: right"/>
												</td>

										</tr>
										<tr>
											<td class="label"><label for="lblCuenta">Cuenta:	</label></td>
											<td><input type="text" id="cuentaClienteS" name="cuentaClienteS"	readOnly="true" disabled="true"
													size="12" tabindex="10" iniForma="false" style="text-align: right" />
												<input id="descCuentaSeguro"	name="descCuentaSeguro" size="30" iniForma="false" tabindex="11" type="text"
														readOnly="true" disabled="true" /></td>
											<td class="separador"></td>
											<td class="label" ><label for="lblmonedaS">Moneda:	</label></td>
											<td><input id="monedaS" name="monedaS" size="12" iniForma="false" tabindex="12" type="text"
														readOnly="true"	disabled="true" style="text-align: right" />
												<input id="monedaDesS"	name="monedaDesS" size="30" iniForma="false" tabindex="13" type="text"
														readOnly="true" disabled="true" /></td>
										</tr>

										<tr id="trGrupo" style="display: none;" >
											<td class="label"  id="tdGrupoCreditoS" >
												<label for="lnlGrupoS">Grupo:</label></td>
											<td id="tdGrupoCreditoSInput">
												<input id="grupoIDS" name="grupoIDS" readOnly="true" disabled="true" iniForma="false"
														 size="1"	tabindex="16" type="text" style="text-align: right"/>
												<input id="grupoDesS" name="grupoDesS"  iniForma="false" size="30" tabindex="17"
														type="text" readOnly="true"	disabled="true" /></td>
											<td class="separador"></td>

											<td class="label" id ="tdGrupoCicloS" >
												<label for="lblGrupoCicloS">Ciclo:</label></td>
											<td id ="tdGrupoCicloSinput">
												<input id="cicloIDS" name="cicloIDS" readOnly="true" disabled="true" iniForma="false" size="12"
													tabindex="18" type="text" /></td>
										</tr>
								</table>
									<br>
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend>Cobertura de Riesgo</legend>
										<br>
										<div>
											<table>
												<tr>
													<td class="label"><label for="lblNumPolizaS">No. P&oacute;liza:</label></td>
													<td><input id="numeroPolizaS" name="numeroPolizaS" size="17" tabindex="19" type="text"
														readOnly="true" disabled="true" iniForma="false" /></td>
													<td class="separador"></td>
													<td class="label"><label for="lblEstatusS">Estatus:</label></td>
													<td><input id="estatusSeguro" name="estatusSeguro" size="15"
														tabindex="20" type="text" readOnly="true" disabled="true" iniForma="false" /></td>
												</tr>
												<tr>
													<td class="label"><label for="lblFechaInicio">Fecha Inicio:</label></td>
													<td><input id="fechaInicioSeguro" name="fechaInicioSeguro" size="17" tabindex="21" type="text"
														readOnly="true" disabled="true" iniForma="false" /></td>
													<td class="separador"></td>
													<td class="label"><label for="lblFechaVenSeguro">Fecha Vencimiento:</label></td>
													<td><input id="fechaVencimiento" name="fechaVencimiento" size="17"
														tabindex="22" type="text" readOnly="true" disabled="true" iniForma="false" /></td>
												</tr>
												<tr>

													<td class="label"><label for="lblFormaPagoS">Forma Pago:</label></td>

													<td class="label">
													<input type="radio" id="pagoAnticipadoS" name="pagoAnticipadoS" value="A" tabindex="23" disabled="true" />
														<label for="lblPAgoanticipado">Anticipado</label>&nbsp;
														<input type="radio" id="pagoDeduccionS" name="pagoDeduccionS" value="D" tabindex="24" disabled="true" />
														<label for="lblPagoDeduccion">Deducci&oacute;n</label>
														<input type="radio" id="pagoFinanciadoS" name="pagoFinanciadoS" value="F" tabindex="25" disabled="true" />
														<label for="lblpagoFinanciadoS">Financiado</label>	</td>

													<td class="separador"></td>
														<td class="label"><label for="lblBeneficiarioSeguro">Beneficiario:</label></td>
													<td><input id="beneficiarioSeguro" name="beneficiarioSeguro" size="50"
														iniForma="false" type="text" tabindex="26" disabled="true"/></td>
												</tr>
												<tr>
													<td class="label"><label for="lblRelacionBeneficiario">Relaci&oacute;n:</label></td>
													<td><input id="relacionBeneficiario" name="relacionBeneficiario" size="6"
														iniForma="false" type="text" tabindex="28"  disabled="true" />
														<input id="desRelacionBeneficiario" name="desRelacionBeneficiario" size="50"
														tabindex="29" type="text" readOnly="true" disabled="true" iniForma="false" />	</td>
													<td class="separador"></td>
													<td class="label"><label for="lblDireccionBeneficiario">Direcci&oacute;n:</label></td>
													<td><input id="direccionBeneficiario" name="direccionBeneficiario" size="50"
														tabindex="27" type="text" readOnly="true" disabled="true" iniForma="false" /></td>
												</tr>
												<tr>

													<td class="label"><label for="lblMontoPoliza">Monto P&oacute;liza:</label></td>
													<td><input id="montoPoliza" name="montoPoliza" size="17" tabindex="30" type="text"
														readOnly="true" disabled="true" iniForma="false" esMoneda="true"	 /></td>
												</tr>
											</table>
											</div>
									</fieldset>


								</fieldset>
							</div>
						</td>
					</tr>

					<!-- ---------------------------------- TRANSFERENCIA ENTRE CUENTAS ----------------------------- -->
					<tr>
						<td colspan="2" >
							<div id="transfiereACuenta" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Transferencia</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label"><label for="lblCuentaAhoIDT">Cuenta:</label>
											</td>
											<td><input id="cuentaAhoIDT" name="cuentaAhoIDT"
												iniForma="false" size="13" tabindex="2" type="text" /></td>
											<td class="separador"></td>
											<td class="label" nowrap="nowrap"><label for="lblCuentaAhoIDT">Tipo
													Cuenta: </label></td>
											<td><input id="tipoCuentaT" name="tipoCuentaT"
												size="25" tabindex="3" type="text" readOnly="true"
												iniForma="false" disabled="true" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblNombreClienteT"><s:message code="safilocale.cliente"/>:
											</label></td>
											<td colspan="4"><input id="numClienteT"
												name="numClienteT" size="11" type="text" readOnly="true"
												iniForma="false" disabled="true" tabindex="4" /> <input
												id="nombreClienteT" name="nombreClienteT" size="60"
												type="text" readOnly="true" iniForma="false" disabled="true"
												tabindex="5" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblMoneda">Moneda:
											</label></td>
											<td><input id="monedaIDT" name="monedaIDT" size="4"
												type="text" readOnly="true" disabled="true" tabindex="7" />
												<input id="monedaT" name="monedaT" size="32" type="text" iniForma="false"
												readOnly="true" disabled="true" tabindex="8" /></td>
											<td class="separador"></td>
											<td id="tdsaldoDisponT" class="label"><label for="lblSaldo">Saldo
													Disponible: </label></td>
											<td><input id="saldoDisponT" name="saldoDisponT"
												size="25" type="text" readOnly="true" disabled="true"
												tabindex="6" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblMontoCargar">Monto
													a Cargar : </label></td>
											<td><input id="montoCargarT" name="montoCargarT" size="12"
												type="text" esMoneda="true" style="text-align: right"
												iniForma="false" tabindex="8" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblReferenciaT">Referencia:
											</label></td>
											<td><textarea id="referenciaT" name="referenciaT"
													iniForma="false" cols="30" rows="2" tabindex="9"
													onblur="ponerMayusculas(this); limpiarCajaTexto(this.id);" maxlength="50"></textarea></td>
											<td class="separador"></td>
											<td class="separador"></td>

										</tr>
										<input type="hidden" id="etiquetaCuentaCargo" name="etiquetaCuentaCargo"  />
										<input type="hidden"  id="etiquetaCuentaAbono" name="etiquetaCuentaAbono"  />
										<input type="hidden" id="numClienteTCtaRecep" name="numClienteTCtaRecep"  />

									</table>

									<br>

									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend>Cuenta Abono</legend>
										<br>
										<div>
											<table>
												<tr>

														<td class="label"><label for="lblCuentaAhoIDTC">Cuenta:
																						</label></td>
													<td >
														  <select id="cuentaAhoIDTC" name="cuentaAhoIDTC"  path="cuentaAhoIDTC" tabindex="10" >
														  <option value="">SELECCIONAR</option>
														  </select>
												   	  </td>

												</tr>
											</table>
											</div>
									</fieldset>
								</fieldset>
							</div>
						</td>
					</tr>
					<!-- ---------------------------------- APORTACION SOCIAL ----------------------------- -->
					<tr>
						<td colspan="5">
							<div id="aportacionSocial" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Aportación Social</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label"><label for="lblClienteIDAS"><s:message code="safilocale.cliente"/>:</label></td>
											<td><input id="clienteIDAS" name="clienteIDAS" iniForma="false" size="14"
												tabindex="1" type="text" />
											<input id="nombreClienteAS" name="nombreClienteAS" iniForma="false" size="50" type="text" readOnly="true" disabled="true" /></td>
											<td></td>
											<td nowrap="nowrap">
												<input type ="button" id="buscarMiSucA" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/>
												<input type ="button" id="buscarGeneralA" name="buscarGeneral" value="B&uacute;squeda General" class="submit"/>
											</td>

										</tr>

										<tr>
											<td class="label"><label for="lblRFCAS">RFC:</label></td>
											<td><input id="RFCAS" name="RFCAS" iniForma="false" size="20"  type="text"  readOnly="true"/>	</td>
										</tr>
										<tr>
											<td class="label"><label for="lblTipoPersona">Tipo Persona:</label></td>
											<td><input id="tipoPersonaAS" name="tipoPersonaAS" iniForma="false" size="53"
												type="text"  readOnly="true"/>	</td>
											<td class="separador"></td>
												<td class="label"><label for="lblMontoPagado">Monto Pagado: </label></td>
											<td><input id="montoPagadoAS" name="montoPagadoAS" size="12" type="text" esMoneda="true"
												style="text-align: right" iniForma="false" tabindex="2" readOnly="true"/></td>

										</tr>
										<tr>
											<td class="label"><label for="lblMontoPendPAgo">Monto Pendiente Pago:</label></td>
											<td><input id="montoPendientePagoAS" name="montoPendientePagoAS" iniForma="false" size="12"
												type="text"  readOnly="true"  esMoneda="true" />	</td>
											<td class="separador"></td>
												<td class="label"><label for="lblmontoAS">Monto: </label></td>
											<td><input id="montoAS" name="montoAS" size="12" type="text" esMoneda="true"
												style="text-align: right" iniForma="false" tabindex="2" /></td>
										</tr>

									</table>
								</fieldset>
							</div>
						</td>
					</tr>
					<!-- ----------------------DEVOLUCION DE APORTACION SOCIAL-------------- -->
					<tr>
						<td colspan="5">
							<div id="devAportacionSocial" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Devolución Aportación Social</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label"><label for="lblClienteIDDAS"><s:message code="safilocale.cliente"/>:</label></td>
											<td><input id="clienteIDDAS" name="clienteIDDAS" iniForma="false" size="14" tabindex="1" type="text" />
											<input id="nombreClienteDAS" name="nombreClienteDAS" iniForma="false" size="50"
													 type="text" readOnly="true" disabled="true" /></td>
													 <td></td>
											 <td nowrap="nowrap">
												<input type ="button" id="buscarMiSucD" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/>
												<input type ="button" id="buscarGeneralD" name="buscarGeneral" value="B&uacute;squeda General" class="submit"/>
											</td>
										</tr>

										<tr>
											<td class="label"><label for="lblRFCDAS">RFC:</label></td>
											<td><input id="RFCDAS" name="RFCDAS" iniForma="false" size="20"
												 type="text"  readOnly="true"/>	</td>
										</tr>
										<tr>
											<td class="label"><label for="lblTipoPersonaDAS">Tipo Persona:</label></td>
											<td><input id="tipoPersonaDAS" name="tipoPersonaDAS" iniForma="false" size="53"
												type="text"  readOnly="true"/>	</td>
											<td class="separador"></td>
												<td class="label"><label for="lblmontoDAS">Monto: </label>
											<input id="montoDAS" name="montoDAS" size="12" type="text" esMoneda="true"
												style="text-align: right" iniForma="false" tabindex="2" readOnly="true"/></td>
										</tr>

									</table>
								</fieldset>
							</div>
						</td>
					</tr>
					<!-- ---------------------- SEGURO VIDA AYUDA CAJA DE AHORRO -------------->
					<tr>
						<td colspan="5">
							<div id="cobroSegVidaAyuda" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Cobro Seguro Vida Ayuda</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label"><label for="lblClienteIDCSVA"><s:message code="safilocale.cliente"/>:</label></td>
											<td><input id="clienteIDCSVA" name="clienteIDCSVA" iniForma="false" size="14"
												tabindex="1" type="text" />
											<input id="nombreClienteCSVA" name="nombreClienteCSVA" iniForma="false" size="40"
													 type="text" readOnly="true" disabled="true" /></td>
													 <td></td>
										<td nowrap="nowrap">
												<input type ="button" id="buscarMiSucSe" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/>
												</td>
												<td>
												<input type ="button" id="buscarGeneralSe" name="buscarGeneral" value="B&uacute;squeda General" class="submit"/>
											</td>
										</tr>

										<tr>
											<td class="label"><label for="lblRFCSVA">RFC:</label></td>
											<td><input id="RFCCSVA" name="RFCCSVA" iniForma="false" size="20"
												 type="text"  readOnly="true"/>	</td>

										</tr>
										<tr>
											<td class="label"><label for="lblTipoPersonaDAS">Tipo Persona:</label></td>
											<td><input id="tipoPersonaCSVA" name="tipoPersonaCSVA" iniForma="false" size="60"
												type="text"  readOnly="true"/>	</td>
											<td class="separador"></td>
											<td class="label"><label for="lblMontoPoliza">Monto P&oacute;liza:</label></td>
													<td><input id="montoPolizaSegAyudaCobro" name="montoPolizaSegAyudaCobro" size="17" tabindex="30" type="text"
														readOnly="true" disabled="true" iniForma="false" esMoneda="true" />
											</td>
										</tr>
										<tr>
											<td class="label"><label for="lblMontoPolizaSVA">Monto a Cobrar :</label></td>
											<td><input id="montoCobrarSeg" name="montoCobrarSeg" size="17" tabindex="30" type="text"
												  iniForma="false" esMoneda="true"	readOnly="true" /></td>
										</tr>
								</table>
								</fieldset>
						</div>
						</td>
					</tr>
					<!-- --------------------------------------PAGO DEL SEGURO DE VIDA----------------------- -->
					<tr>
						<td colspan="5">
							<div id="pagoSeguroAyuda" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Pago  Seguro Ayuda</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label"><label for="lblClienteIDASVA"><s:message code="safilocale.cliente"/>:</label></td>
											<td><input id="clienteIDASVA" name="clienteIDASVA" iniForma="false" size="14"
												tabindex="1" type="text" />
											<input id="nombreClienteASVA" name="nombreClienteASVA" iniForma="false" size="40"
													 type="text" readOnly="true" disabled="true" /></td>

									 	<td nowrap="nowrap">
											<input type ="button" id="buscarMiSucPa" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/></td>
											<td>
											<input type ="button" id="buscarGeneralPa" name="buscarGeneral" value="B&uacute;squeda General" class="submit"/>
										</td>

										</tr>

										<tr>
											<td class="label"><label for="lblRFASVA">RFC:</label></td>
											<td><input id="RFCASVA" name="RFCASVA" iniForma="false" size="20"
												 type="text"  readOnly="true"/>	</td>
											<td class="label"><label for="lblTipoPersonaADAS">Tipo Persona:</label></td>
											<td><input id="tipoPersonaASVA" name="tipoPersonaASVA" iniForma="false" size="53"
												type="text"  readOnly="true"/>	</td>
											<td class="separador"></td>
										</tr>
								</table>
									<br>
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend>Seguro</legend>
										<br>
										<div>
											<table>
												<tr>
													<td class="label"><label for="lblTipoOperacion">Seguro: </label></td>
													<td align="left">
															<select id="seguroClienteID"	name="seguroClienteID"  tabindex="1"></select>
													</td>
													<td class="separador"></td>
												</tr>
												<tr>
													<td class="label"><label for="lblnumeroPolizaSVAA">No. P&oacute;liza:</label></td>
													<td><input id="numeroPolizaSVAA" name="numeroPolizaSVAA" size="17" tabindex="19" type="text"
														readOnly="true" disabled="true" iniForma="false" /></td>
													<td class="separador"></td>
													<td class="label"><label for="lblEstatusSVAA">Estatus:</label></td>
													<td><input id="estatusSeguroVAA" name="estatusSeguroVAA" size="15"
														tabindex="20" type="text" readOnly="true" disabled="true" iniForma="false" /></td>
												</tr>
												<tr>
													<td class="label"><label for="lblFechaInicioSegA">Fecha Inicio:</label></td>
													<td><input id="fechaInicioSA" name="fechaInicioSA" size="17" tabindex="19" type="text"
														readOnly="true" disabled="true" iniForma="false" /></td>
													<td class="separador"></td>
													<td class="label"><label for="lblFechaFinSA">Fecha Vencimiento:</label></td>
													<td><input id="fechaVencimientoSA" name="fechaVencimientoSA" size="15"
														tabindex="20" type="text" readOnly="true" disabled="true" iniForma="false" /></td>
												</tr>
												<tr>
													<td class="label"><label for="lblMontoCobradoA">Monto Cobrado:</label></td>
													<td><input id="montoCobradoSegAyudaA" name="montoCobradoSegAyudaA" size="17" tabindex="30" type="text"
														readOnly="true" disabled="true" iniForma="false" esMoneda="true" /></td>
													<td class="separador"></td>
														<td class="label"><label for="lblMontoPolizaA">Monto P&oacute;liza:</label></td>
													<td><input id="montoPolizaSegAyudaCobroA" name="montoPolizaSegAyudaCobroA" size="17" tabindex="30" type="text"
														readOnly="true" disabled="true" iniForma="false" esMoneda="true" /></td>
												</tr>

											</table>
											</div>
									</fieldset>
								</fieldset>
							</div>
						</td>
					</tr>
					<!-- ------------------PAGO REMESAS -------------------- -->
					<tr>
						<td colspan="5">
							<div id="pagoRemesas" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all" id="fielsetRemesaOport">Pago de Remesas</legend>
									<table width="100%">
										<tr>
											<td>
												<label for="numTarjetaRemesas" id="numerTarjetaRemesas" >N&uacute;mero Tarjeta:</label>
												<input id="numeroTarjetaRemesas" name="numeroTarjetaRemesas" size="20" tabindex="4" type="text" />
											</td>
										</tr>
										<tr id="comboRemesadoras">
											<td class="label">
												<label for="referenciaServicio">Referencia:</label>											
											</td>
											<td>
												<input id="referenciaServicio" name="referenciaServicio" size="20" type="text" iniForma="false" tabindex="3" maxlength="45"/>
											</td>
											<td class="separador"></td>
											<td class="label">
												<label for=clabeCobroRemesa>Clave Cobro:</label>											
											</td>
											<td>
												<input type="text" id="clabeCobroRemesa" name="clabeCobroRemesa" size="20" tabindex="4" maxlength="45"/>
											</td>
										</tr>

										<tr>
											<td class="label">
												<label for="lblMontoServicio">Monto:</label>
											</td>
											<td>
												<input id="montoServicio" name="montoServicio" size="20" tabindex="5" type="text"  iniForma="false" esMoneda="true" style="text-align: right;"/>
											</td>
											<td class="separador"></td>
											<td nowrap="nowrap" class="label">
												<label id="lblComboRemesadora">Remesadora:</label>												
											</td>
											<td>
												<select id="remesaCatalogoID" name="remesaCatalogoID"  tabindex="6"></select>												
											</td>

										</tr>

										<tr>
											<td class="label">
												<label for="lblClienteServicio"><s:message code="safilocale.cliente"/>:</label>
											</td>
											<td>
												<input id="clienteIDServicio" name="clienteIDServicio" iniForma="false" size="20" tabindex="7" type="text" />
												<input id="nombreClienteServicio" name="nombreClienteServicio" iniForma="false" size="40"
													 type="text" onblur="ponerMayusculas(this)"  readOnly="true"/>
											</td>
											<td class="separador"></td>
											<td>
												<label for="lblDireccionServicio">Dirección:</label>
											</td>
											<td>
												<textarea id="direccionClienteServicio" name="direccionClienteServicio" cols="55" rows="2" maxlength="500" onblur="ponerMayusculas(this)" tabindex="8"/></textarea>
											</td>
											<td nowrap="nowrap" style="display: none;">
												<input type ="button" id="buscarMiSucP" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit" tabindex="9"/>
												<input type ="button" id="buscarGeneralP" name="buscarGeneral" value="B&uacute;squeda General" class="submit" tabindex="10"/>
											</td>

										</tr>

										<tr>
											<td class="label">
												<label for="usuarioRem">Usuario:</label>
											</td>
											<td nowrap="nowrap">
												<input id="usuarioRem" name="usuarioRem" iniForma="false" size="20" tabindex="11" type="text" />
												<input id="nombreUsuarioRem" name="nombreUsuarioRem" iniForma="false" size="40" type="text"onblur="ponerMayusculas(this)"  readOnly="true"/>
											</td>
											<td class="separador"></td>
											<td>
												<label for="lblTelefonoCliServicio">Teléfono:</label>
											</td>
											<td>
												<input id="telefonoClienteServicio" name="telefonoClienteServicio" iniForma="false" size="20" type="text" tabindex="12"/>
											</td>
											<td nowrap="nowrap">
												<a id="opcionUsuario" href="javascript: " onclick="$('#Contenedor').load('usuarioServiciosCatalogo.htm');consultaSesion();">
													<input type ="button" id="altaUsuario" name="altaUsuario" value="Registrar Usuario" class="submit" tabindex="13"/>
												</a>
											</td>
										</tr>
										<tr>
											<td nowrap="nowrap" class="label">
												<label for="lblIndetificacionServicio">Identificación:</label>
											</td>
											<td nowrap="nowrap">
												<select id="indentiClienteServicio" name="indentiClienteServicio" tabindex="14"></select>
												<input id="folioIdentiClienteServicio" name="folioIdentiClienteServicio" iniForma="false" size="30" type="text" tabindex="15" maxlength="45"/>
											</td>
											<td class="separador"></td>
											<td>
												<input type ="button" id="adjuntarIdentificacion" name="adjuntarIdentificacion" value="Adjuntar Identificación" class="submit" tabindex="16"/>
											</td>
											<td>
											</td>
										</tr>

										<tr>
											<td class="label" nowrap="nowrap">
												<label class="label" for="lblFormaPagoServicio" >Forma Pago:</label>
											</td>
											<td>
												<input id="pagoServicioRetiro" name="formaPagoServicio"  type="radio" value="R" tabindex="17" checked="checked"/>
												<label for="lblpagoRemesaRetiro">Retiro Efectivo</label>
												<input id="pagoServicioDeposito" name="formaPagoServicio" type="radio" value="D" tabindex="18"/>
												<label for="lblpagoServicioDeposito">Deposito a Cuenta</label>
												<input id="pagoServicioCheque" name="formaPagoServicio" type="radio" value="C" tabindex ="19"/>
												<label for="lblpagoServicioCheque">Cheque</label>
												<input type="hidden" id="tipoPagoServicio" name="tipoPagoServicio"/>
											</td>

											<td class="separador" id="tdSeparadorNumCtaServicio"></td>
											<td class="label" id="tdlblNumCuentaServicio" nowrap="nowrap">
												<label for="lblNumCuentaServicio">Número Cuenta:</label>
												<input id="numeroCuentaServicio" name="numeroCuentaServicio" size="17" tabindex="20" type="text" iniForma="false" maxlength="12" />
											</td>
										</tr>

									</table>
								</fieldset>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all" id="fielsetRemesaOport">Remitente</legend>
									<table width="100%">
										<tr>
											<td>
												<label for="nombreEmisor">Nombre:</label>
											</td>
											<td>
												<input type="text" id="nombreEmisor" name="nombreEmisor" size="35" readOnly="true" />
											</td>
											<td class="separador"></td>
											<td>
												<label for="paisRemitente">País:</label>
											</td>
											<td>
												<input type="text" id="paisRemitente" name="paisRemitente" size="35" readOnly="true" />											
											</td>											
										</tr>
										<tr>
											<td>
												<label for="estadoRemitente">Estado:</label>
											</td>
											<td>
												<input type="text" id="estadoRemitente" name="estadoRemitente" size="35" readOnly="true" />
											</td>
											<td class="separador"></td>
											<td>
												<label for="ciudadRemitente">Ciudad:</label>
											</td>
											<td>
												<input type="text" id="ciudadRemitente" name="ciudadRemitente" size="35" readOnly="true" />
											</td>											
										</tr>
										<tr>
											<td>
												<label for="coloniaRemitente">Colonia:</label>
											</td>
											<td>
												<input type="text" id="coloniaRemitente" name="coloniaRemitente" size="35" readOnly="true" />
											</td>
											<td class="separador"></td>
											<td>
												<label for="cpRemitente">C. P.:</label>
											</td>
											<td>
												<input type="text" id="cpRemitente" name="cpRemitente" size="35" readOnly="true" />
											</td>											
										</tr>
										<tr>
											<td>
												<label for="domicilioRemitente">Domicilio:</label>
											</td>
											<td>
												<textarea id="domicilioRemitente" name="domicilioRemitente" cols="55" rows="2"/></textarea>
											</td>
											<td class="separador"></td>
											<td>
											</td>
											<td>
											</td>											
										</tr>
									</table>
								</fieldset>
								<br>
						</div>
						</td>
					</tr>
					<!-- ------------------RECEPCION CHEQUE SBC -------------------- -->
					<tr>
						<td colspan="5">
							<div id="recepcionChequeSBC" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Recepción Documentos SBC</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label" ><label for="lblCtaInterna">Tipo Cuenta Cheque:</label></td>
											<td>
												<select id="tipoCtaCheque" name="tipoCtaCheque" tabindex="3" >
													<option value="">SELECCIONAR</option>
													<option value="I">Interna- </option>
													<option value="E">Externa - Otros</option>
												</select>
											</td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>

										</tr>
										<tr id="idTrFormaCobro" style="display:none;">
											<td class="label"><label for="lblFormaCobro">Forma de Cobro:</label></td>
											<td colspan="1">
												<input id=formaCobro1 name="formaCobro"  type="radio" value="D" tabindex="4" />
												<label for="lblDepositoCuenta">Depósito a Cuenta</label>
												<input id="formaCobro2" name="formaCobro" type="radio" value="E" tabindex="5"/>
												<label for="lblEfectivo">Efectivo</label>

											</td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											</tr>
										</table>

										<div id="idCuentaAhoCte" style="display:none;">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend>Depósito a Cuenta</legend>
											<table>
												<tr>
													<td class="label"><label for="lblCuentaRecSBC">Cuenta:</label></td>
													<td><input id="numeroCuentaRec" name="numeroCuentaRec" iniForma="false" size="14"
														 type="text" tabindex="6"/>
													</td>
													<td class="separador"></td>
													<td class="label"><label for="lblTipoCuenta">Tipo Cuenta:</label></td>
													<td><input id="tipoCuentaSBC" name="tipoCuentaSBC" iniForma="false" size="50"
													 type="text" readOnly="true" />
													</td>
												</tr>
												<tr id="trSalDispYSbc">
													<td id="tdsaldoDisponibleSBC" class="label" nowrap="nowrap" ><label for="lblSaldoDisponibleSBC">Saldo Disponible:</label></td>
													<td><input id="saldoDisponibleSBC" name="saldoDisponibleSBC" iniForma="false" size="20"
														type="text"  readOnly="true" />	</td>
													<td class="separador"></td>

													<td id="tdsaldoBloqueadoSBC" class="label"><label for="lblSaldobloqueado">Saldo SBC:</label></td>
													<td><input id="saldoBloqueadoSBC" name="saldoBloqueadoSBC" iniForma="false" size="20"
														type="text" readOnly="true"/>
													</td>
												</tr>
												<tr>
												<td class="label"><label for="lblClienteSBC"><s:message code="safilocale.cliente"/>:</label></td>
													<td><input id="clienteIDSBC" name="clienteIDSBC" iniForma="false" size="14"
														type="text"  readOnly="true" />
														<input id="nombreClienteSBC" name="nombreClienteSBC" iniForma="false" size="50"
														type="text"  readOnly="true" />
													</td>

													<td class="separador"></td>

												</tr>

										 </table>
										 </fieldset>
										</div>

										<div id="idDivCheque" style="display:none;">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend>Cheque</legend>
											<table>
												<tr id="trBancoEmisor">

													<td class="label"><label class="label" for="lblBancoEmisorSBC">Banco Emisor:</label></td>
													<td><input id="bancoEmisorSBC" name="bancoEmisorSBC" size="6" tabindex="13" type="text"
															 iniForma="false" />
													<input id="nombreBancoEmisorSBC" name="nombreBancoEmisorSBC" size="35"  type="text"
														 iniForma="false" onblur="ponerMayusculas(this)" readOnly="true" />

													</td>
													<td class="separador"></td>
													<td class="label"><label for="lblNumCuentaSBC">Número Cuenta Emisor:</label></td>
													<td><input id="numeroCuentaEmisorSBC" name="numeroCuentaEmisorSBC" size="20" tabindex="14" type="text"
															 iniForma="false" maxlength="12" />
													</td>

												</tr>
												<tr  id="idTrtipoChequeraRecep" style="display:none;">
													<td  class="label">
														<label for="tipoChequeraRecep">Tipo Chequera:</label>
													</td>
													<td colspan="3">
														<select id="tipoChequeraRecep" name="tipoChequeraRecep" tabindex="15">
															<option value="">SELECCIONAR</option>
														</select>
													</td>
												</tr>
												<tr id="trTitularCta">
													<td class="label"><label for="lblNumeroChequeSBC">Número Cheque:</label></td>
													<td><input id="numeroChequeSBC" name="numeroChequeSBC" size="17" type="text"
															 iniForma="false" tabindex="16" maxlength="10" /></td>
													<td class="separador"></td>
													<td class="label" nowrap="nowrap" id="lblTitularCta" style="display:none">
														<label for="lblNombreEmisor">Titular Cuenta:</label></td>
													<td id="inputTitularCta" style="display:none">
														<input id="nombreEmisorSBC" name="nombreEmisorSBC" size="50" type="text"
															 iniForma="false"  maxlength="150" onblur="ponerMayusculas(this)" tabindex="16" /></td>

													<td class="label" nowrap="nowrap" id="lblBeneficiario" style="display:none">
														<label for="lblBeneficiario">Beneficiario:</label></td>
													<td id="inputBeneficiario" style="display:none" >
														<input id="beneficiarioSBC" name="beneficiarioSBC" size="50" type="text"
															 iniForma="false"  maxlength="150" readOnly="true"/></td>
												</tr>
												<tr id="trMonto">
													<td class="label"><label for="lblMontoSBC">Monto:</label></td>
													<td><input id="montoSBC" name="montoSBC" size="17" tabindex="18" type="text"
														  iniForma="false" esMoneda="true"  />
													</td>
												</tr>
											</table>
										</fieldset>
										</div>
									</fieldset>
							</div>
						</td>
					</tr>
					<!-- ------------------APLICACION DE CHEQUE SBC -------------------- -->
					<tr>
						<td colspan="5">
							<div id="aplicaChequeSBC" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all" id="fielsetRemesaOport">Aplicación Documentos SBC</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label"><label for="lblCuentaRecSBCAplic">Cuenta:</label></td>
											<td><input id="numeroCuentaSBC" name="numeroCuentaSBC" iniForma="false" size="14"
												tabindex="3" type="text"  />
											</td>
											<td class="separador"></td>
											<td class="label"><label for="lblTipoCuentaAplic">Tipo Cuenta:</label></td>
											<td><input id="tipoCuentaSBCAplic" name="tipoCuentaSBCAplic" iniForma="false" size="50"
												tabindex="3" type="text" readOnly="true" />
											</td>
										</tr>
										<tr>
											<td class="label"><label for="lblClienteSBCAplic"><s:message code="safilocale.cliente"/>:</label></td>
											<td><input id="clienteIDSBCAplic" name="clienteIDSBCAplic" iniForma="false" size="14"
												type="text" tabindex="4" readOnly="true"/>
												<input id="nombreClienteSBCAplic" name="nombreClienteSBCAplic" iniForma="false" size="50"
												type="text" tabindex="5" readOnly="true"/>
											</td>
											<td class="separador"></td>
											<td class="label"><label for="lblChequeAplic">Cheque:</label></td>
											<td><select id="clientechequeSBCAplic" name="clientechequeSBCAplic"  tabindex="8"></select>
											</td>
										</tr>
										<tr id="trSaldosDispYSbc">
											<td id="tdsaldoDisponibleSBCAplic" class="label" nowrap="nowrap"><label for="lblSaldoDisponibleSBCAplic">Saldo Disponible:</label></td>
											<td><input id="saldoDisponibleSBCAplic" name="saldoDisponibleSBCAplic" iniForma="false" size="20"
												type="text" tabindex="6" readOnly="true" />	</td>
											<td class="separador"></td>
											<td id="tdsaldoBloqueadoSBCAplic" class="label"><label for="lblSaldobloqueadoAplic">Saldo SBC:</label></td>
											<td><input id="saldoBloqueadoSBCAplic" name="saldoBloqueadoSBCAplic" iniForma="false" size="20"
												type="text" tabindex="7" readOnly="true"/>
										</tr>
										<tr>
											<td class="label"><label for="lblFechaRecep">Fecha Recepción:</label></td>
											<td><input id="fechaRecepcionSBC" name="fechaRecepcionSBC" iniForma="false" size="20"
												type="text" tabindex="7" readOnly="true"/></td>
											<td class="separador"></td>
											<td class="label"><label class="label" for="lblBancoEmisorSBCAplic">Banco Emisor:</label></td>
											<td><input id="bancoEmisorSBCAplic" name="bancoEmisorSBCAplic" size="6" tabindex="9" type="text"
													 iniForma="false" readOnly="true"/>
												 <input id="nombreBancoEmisorSBCAplic" name="nombreBancoEmisorSBCAplic" size="35" tabindex="10" type="text"
												 iniForma="false"  readOnly="true" />
											</td>
										</tr>
										<tr>
											<td class="label"><label for="lblNumCuentaSBCAplic">Número Cuenta Emisor:</label></td>
											<td><input id="numeroCuentaEmisorSBCAplic" name="numeroCuentaEmisorSBCAplic" size="20" tabindex="11" type="text"
													 iniForma="false" maxlength="12" readOnly="true" />
											</td>
											<td class="separador"></td>
											<td class="label" nowrap="nowrap"><label for="lblNombreEmisorAplic">Nombre Emisor:</label></td>
											<td><input id="nombreEmisorSBCAplic" name="nombreEmisorSBCAplic" size="50" type="text"
													 iniForma="false" tabindex="12" maxlength="150" onblur="ponerMayusculas(this)"
													 readOnly="true"/></td>
										</tr>
										<tr>
											<td class="label"><label for="lblNumeroChequeSBCAplic">Número Cheque:</label></td>
											<td><input id="numeroChequeSBCAplic" name="numeroChequeSBCAplic" size="20" type="text"
													 iniForma="false" tabindex="13" maxlength="10" readOnly="true" maxlength="9"/></td>
											<td class="separador"></td>
											<td class="label"><label for="lblMontoSBCAplic">Monto:</label></td>
											<td><input id="montoSBCAplic" name="montoSBCAplic" size="17" tabindex="14" type="text"
												  iniForma="false" esMoneda="true" readOnly="true" maxlength="12" />
											</td>

										</tr>
									</table>
								</fieldset>
							</div>
						</td>
					</tr>
					<!-- ----------------------PREPAGO DE CREDITO  --------------------->
					<tr>
						<td colspan="5">
							<div id="prepagoCredito" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Prepago de Cr&eacute;dito</legend>
									<table cellpadding="0" cellspacing="0" width="100%" border="0">
										<tr>
											<td class="label"><label for="lblcreditoIDPre">Cr&eacute;dito:</label></td>
											<td><input type="text" id="creditoIDPre" name="creditoIDPre" size="12" iniForma="false" tabindex="2" /> <input type="hidden" id="saldoCapitalInso" name="saldoCapitalInso" /> <input type="hidden" id="saldoCapitalPre" name="saldoCapitalPre" /></td>
											<td class="separador"></td>
											<td class="label"><label for="lblclienteIDPRe"><s:message code="safilocale.cliente" />:</label></td>
											<td><input id="clienteIDPre" name="clienteIDPre" size="12" type="text" readOnly="true" disabled="true" /> <input id="nombreClientePre" name="nombreClientePre" size="40" type="text" readOnly="true" disabled="true" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblPagaIVAPre">Paga IVA: </label></td>
											<td><select id="pagaIVAPre" name="pagaIVAPre" disabled="true">
													<option value="">--</option>
													<option value="S">SI</option>
													<option value="N">NO</option>
											</select></td>
											<td class="separador"></td>
											<td class="label"><label for="lblcuentaIDcrePre">Cuenta Cargo: </label></td>
											<td><input type="text" id="cuentaIDPre" name="cuentaIDPre" readOnly="true" disabled="true" size="12" /> <input id="nomCuentaPre" name="nomCuentaPre" size="30" type="text" readOnly="true" disabled="true" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblmonedacrPre">Moneda: </label></td>
											<td><input id="monedaIDPre" name="monedaIDPre" size="12" type="text" readOnly="true" disabled="true" /> <input id="monedaDesPre" name="monedaDesPre" size="30" iniForma="false" type="text" readOnly="true" disabled="true" /></td>
											<td class="separador"></td>
											<td id="tdsaldoCtaPre" class="label" nowrap="nowrap"><label for="lblsaldocta1Pre">Saldo Disponible:</label></td>
											<td><input id="saldoCtaPre" name="saldoCtaPre" size="12" type="text" readOnly="true" disabled="true" style="text-align: right" /></td>
										</tr>
										<tr>
											<td class="label"><label for="lblestatusPre">Estatus:</label></td>
											<td><input id="estatusPre" name="estatusPre" size="12" type="text" readOnly="true" disabled="true" /></td>
											<td class="separador"></td>
											<td class="label"><label for="lblMontopagarPre">Monto a Pagar :</label></td>
											<td><input id="montoPagarPre" name="montoPagarPre" size="12" type="text" esMoneda="true" iniForma="false" tabindex="2" style="text-align: right" /> <input type="hidden" id="montoPagadoCreditoPre" name="montoPagadoCreditoPre" size="12" type="text" esMoneda="true" iniForma="false" style="text-align: right" /></td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap"><label for="lbldiasFaltaPagoPre">D&iacute;as Falta Pago:</label></td>
											<td><input id="diasFaltaPagoPre" name="diasFaltaPagoPre" size="12" type="text" readOnly="true" disabled="true" /></td>
											<td class="separador"></td>
											<td class="label"><label for="lblMontopagarPre">Producto Cr&eacute;dito:</label></td>
											<td><input id="producCreditoIDPre" name="producCreditoIDPre" size="12" type="text" iniForma="false" disabled="disabled" readonly="readonly" style="text-align: right" /> <input type="text" id="descripcionProdPre" name="descripcionProdPre" size="30" iniForma="false" disabled="disabled" readonly="readonly" /></td>
										</tr>
										<tr>
											<td class="label" id="tdGrupoCicloCredlabelPre" style="display: none;"><label for="lblciclo">Ciclo: </label></td>
											<td id="tdGrupoCicloCredinputPre" style="display: none;"><input id="cicloIDPre" name="cicloIDPre" size="12" iniForma="false" type="text" readOnly="true" disabled="true" /></td>
											<td class="separador"></td>
											<td class="label" id="tdGrupoGrupoCredlabelPre" style="display: none;"><label for="lblmonedacrPre">Grupo: </label></td>
											<td id="tdGrupoGrupoCredinputPre" style="display: none;"><input id="grupoIDPre" name="grupoIDPre" size="12" iniForma="false" type="text" readOnly="true" disabled="true" /> <input id="grupoDesPre" name="grupoDesPre" size="30" type="text" readOnly="true" iniForma="false" disabled="true" /></td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap"><label for="lblProxFechPagoPre">Prox. Pago: </label></td>
											<td><input type="text" id="fechaProxPagoPre" name="fechaProxPagoPre" size="12" iniForma="false" readOnly="true" disabled="true" /></td>
											<td class="separador"></td>
											<td class="label" id="tdlblProrrateoPagoPre" style="display: none;"><label for="lblProrroteoPagoPre">Prorrateo Pago: </label></td>
											<td id="tdProrrateoPagoPre" style="display: none;"><select id="prorrateoPagoPrepago" name="prorrateoPagoPrepago" disabled="true">
													<option value="">--</option>
													<option value="S">SI</option>
													<option value="N">NO</option>
											</select></td>
										</tr>
										<tr class="ocultarSeguros">
											<td class="label"><label>Cobra Seguro Cuota:</label></td>
											<td><form:select name="cobraSeguroCuotaPre" id="cobraSeguroCuotaPre" disabled="true" path="cobraSeguroCuota">
													<option value="N">NO</option>
													<option value="S">SI</option>
												</form:select></td>
										</tr>
										<tr>
											<td class="label" id="lblAdeudoProfunPREC" nowrap="nowrap"><label for="lblAdeudoProfunPREC">Adeudo PROFUN: </label></td>
											<td><input type="text" id="adeudoPROFUNPREC" size="12" iniForma="false" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
										</tr>
										<tr id="prepagos">
											<td><label for="lblTipoPrepago">Tipo Prepago Capital:</label></td>
											<td><select id="tipoPrepago" name="tipoPrepago" path="tipoPrepago">
													<option value="">SELECCIONAR</option>
													<option value="U">últimas Cuotas</option>
													<option value="I">Cuotas Siguientes Inmediatas</option>
													<option value="V">Prorrateo Cuotas Vigentes</option>
													<option value="P">Cuotas Completas Proyectadas</option>
											</select></td>
										</tr>
									</table> <br>
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend>Saldo Cr&eacute;dito</legend>
										<table>
											<tr>
												<td class="label"><label for="lblTotalAd" id="labelTotalAdeudoPrepagoPre"><b>Total Adeudo :</b></label></td>
												<td><input id="adeudoTotalPrepagoPre" name="adeudoTotalPrepagoPre" size="15" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
												<td class="label"><label id="lblexigibleAlDiaPre"><b>Exigible al Día:</b></label></td>
												<td><input id="exigibleAlDiaPre" name="exigibleAlDiaPre" size="15" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
											</tr>
											<tr>
												<td class="label"><label id="lblmontoTotGrupalDeudaPrepagoPre"><b>Total Adeudo Grupal :</b></label></td>
												<td><input id="montoTotGrupalDeudaPrepagoPre" name="montoTotGrupalDeudaPrepagoPre" size="15" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
												<td class="label"><label id="lblExigibleAlDiaGPre"><b>Exigible al Día:</b></label></td>
												<td><input id="exigibleAlDiaGPre" name="exigibleAlDiaGPre" size="15" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
											</tr>
											<tr>
												<td class="label"><label for="lblCuotaProyec" id="labelCuotaProyec"><b>Cuotas a Pagar/Adelantar:</b></label></td>
												<td><input id="cuotasProyectadasPrepago" name="cuotasProyectadasPrepago" size="15" type="text" style="text-align: right" /></td>
											</tr>
										</table> <br>
										<div>
											<table border="0" cellpadding="0" cellspacing="0" width="900px">
												<tr>
													<td class="label" colspan="2"><label><b>Capital </b></label>
													<td class="label" colspan="2"><label><b>Inter&eacute;s</b></label>
													<td class="label"><label><b>IVA Inter&eacute;s </b></label></td>
													<td><input type="text" name="saldoIVAInteresPre" id="saldoIVAInteresPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td class="label" colspan="2"><label><b>Comisiones</b></label>
													<td class="label" colspan="2"><label><b>IVA Comisiones</b></label>
												</tr>
												<tr>
													<td><label>Vigente: </label></td>
													<td><input id="saldoCapVigentPre" name="saldoCapVigentPre" size="8" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td><label>Ordinario: </label></td>
													<td><input type="text" name="saldoInterOrdinPre" id="saldoInterOrdinPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td colspan="2"></td>
													<td><label> Falta Pago: </label></td>
													<td><input type="text" name="saldoComFaltPagoPre" id="saldoComFaltPagoPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td><label> Falta Pago: </label></td>
													<td><input type="text" name="salIVAComFalPagPre" id="salIVAComFalPagPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
												</tr>
												<tr>
													<td><label>Atrasado: </label></td>
													<td><input id="saldoCapAtrasadPre" name="saldoCapAtrasadPre" size="8" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td><label>Atrasado: </label></td>
													<td><input type="text" name="saldoInterAtrasPre" id="saldoInterAtrasPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td class="label"><label><b>Moratorio</b></label></td>
													<td><input type="text" name="saldoMoratoriosPre" id="saldoMoratoriosPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td><label>Otras: </label></td>
													<td><input type="text" name="saldoOtrasComisPre" id="saldoOtrasComisPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td><label>Otras: </label></td>
													<td><input type="text" name="saldoIVAComisiPre" id="saldoIVAComisiPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
												</tr>
												<tr>
													<td><label>Vencido: </label></td>
													<td><input type="text" name="saldoCapVencidoPre" id="saldoCapVencidoPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td><label>Vencido: </label></td>
													<td><input type="text" name="saldoInterVencPre" id="saldoInterVencPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td class="label"><label><b>IVA Moratorio</b></label></td>
													<td><input type="text" name="saldoIVAMoratorPre" id="saldoIVAMoratorPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td><label>Admon: </label></td>
													<td><input type="text" name="saldoAdmonComisPre" id="saldoAdmonComisPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" value="0.00" /></td>
													<td><label>Admon: </label></td>
													<td><input type="text" name="saldoIVAAdmonComisiPre" id="saldoIVAAdmonComisiPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" value="0.00" /></td>
												</tr>
												<tr>
													<td><label>Vencido no Exigible: </label></td>
													<td><input type="text" name="saldCapVenNoExiPre" id="saldCapVenNoExiPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td><label>Provisi&oacute;n:</label></td>
													<td><input type="text" name="saldoInterProviPre" id="saldoInterProviPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td></td>
													<td></td>
													<td class="label ocultaSeguro"><label>Seguro</label></td>
													<td class="ocultaSeguro"><input type="text" name="saldoSeguroCuotaPre" id="saldoSeguroCuotaPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td class="label ocultaSeguro"><label>Seguro</label></td>
													<td class="ocultaSeguro"><input type="text" name="saldoIVASeguroCuotaPre" id="saldoIVASeguroCuotaPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
												</tr>
												<tr>
													<td><label for="totalCapitalPre"><b>Total: </b></label></td>
													<td><input name="totalCapitalPre" id="totalCapitalPre" type="text" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td><label for="saldoIntNoContaPre">Cal.No Cont.: </label></td>
													<td><input type="text" name="saldoIntNoContaPre" id="saldoIntNoContaPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td></td>
													<td></td>
													<td class="label"><label for="saldoComAnualPre">Anual:</label></td>
													<td><input id="saldoComAnualPre" name="saldoComAnualPre" type="text" esMoneda="true" size="8" readonly="true" disabled="true" style="text-align: right"></td>
													<td class="label"><label for="saldoComAnualIVAPre">Anual:</label></td>
													<td><input id="saldoComAnualIVAPre" name="saldoComAnualIVAPre" type="text" esMoneda="true" size="8" readonly="true" disabled="true" style="text-align: right"></td>
												</tr>
												<tr>
													<td class="separador" colspan="2"></td>
													<td><label><b>Total: </b></label></td>
													<td><input type="text" name="totalInteresPre" id="totalInteresPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td></td>
													<td></td>
													<td><label><b>Total: </b></label></td>
													<td><input type="text" name="totalComisiPre" id="totalComisiPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
													<td><label><b>Total: </b></label></td>
													<td><input type="text" name="totalIVAComPre" id="totalIVAComPre" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
												</tr>
											</table>
										</div>
									</fieldset>
								</fieldset>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<div id="pagoServicios" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Cobro de Servicios</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label"><label for=lblTipoServicio>Tipo de Servicio: </label></td>
											<td align="left"><select id="catalogoServID" name="catalogoServID" path="catalogoServID" tabindex="2">
															</select>

												<label for="IdentificaSocioser" id="lblNumTarjetaSer" >N&uacute;mero Tarjeta:</label>
												<input id="numeroTarjetaServicio" name="numeroTarjetaServicio" size="30" tabindex="3" type="text" />


											</td>
											<td class="separador"></td>


										</tr>
										<tr  id="trRequiereCliente">
											<td class="label"><label for="lblClienteID"><s:message code="safilocale.cliente"/>:</label></td>
											<td nowrap="nowrap">
											<input id="clienteIDCobroServ" name="clienteIDCobroServ" iniForma="false" size="15" tabindex="3" type="text" />
											<input id="nombreClientePagoServ" name="nombreClientePagoServ" size="60" type="text" readOnly="true" iniForma="false" />
											<input type ="button" id="buscarMiSucC" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/>
											<input type ="button" id="buscarGeneralC" name="buscarGeneral" value="B&uacute;squeda General" class="submit"/>

												</td>
										</tr>
										<tr id="trRequiereProspecto">
											<td class="label"><label for="lblNombrePropecto">Prospecto:</label></td>
											<td><input id="prospectoIDServicio" name="prospectoIDServicio" iniForma="false" size="15" tabindex="4" type="text" />
											<input id="nombreProspectoServicio" name="nombreProspectoServicio" size="60"  type="text" readOnly="true"
												iniForma="false" /></td>
										</tr>
										<tr id="trRequiereCredito">
											<td class="label"><label for="lblCredito">Crédito:</label></td>
											<td><input id="creditoIDServicio" name="creditoIDServicio" iniForma="false" size="15" tabindex="5" type="text" />
												<input id="prodCredCobroServ" name="prodCredCobroServ" iniForma="false" size="10" type="text" readOnly="true" />
												<input id="desProdCreditoPagServ" name="desProdCreditoPagServ" iniForma="false" size="50" type="text" readOnly="true" />
											</td>
										</tr>
										<tr id="trCredGrupalPagoServ" style="display: none;">
											<td class="label"><label for="lblClicloGrupo">Grupo:</label></td>
											<td><input id="grupoIDCobroSer" name="grupoIDCobroSer" iniForma="false" size="15" tabindex="2" type="text" readOnly="true"  />
												 <input id="cicloGrupoCredCobroServ" name="cicloGrupoCredCobroServ" iniForma="false" size="10" type="hidden" readOnly="true" />
												<input id="nombreGrupoCobroServ" name="nombreGrupoCobroServ" iniForma="false" size="70"  type="text" readOnly="true" />
											</td>

										</tr>
									</table>
									<br>
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend>Cobro</legend>
										<div>
											<table>
												<tr id="trComision">
													<td class="label"><label for="lblComicion">Comisión:</label></td>
													<td><input id="montoComision" name="montoComision" iniForma="false" size="15"
																 type="text"	readOnly="true" esMoneda="true" style="text-align: right"/></td>
													<td class="separador"></td>
													<td class="label"><label for="lblIVAComision"> IVA Comisión:</label></td>
													<td><input id="ivaComision" name="ivaComision" size="15" type="text"
																readOnly="true"	iniForma="false" esMoneda="true" style="text-align: right"/></td>
												</tr>
												<tr id="trServicio">
													<td class="label" id="trMontoPagoServicio"><label for="lblMonto">Monto:</label></td>
													<td><input id="montoPagoServicio" name="montoPagoServicio" iniForma="false" size="15"
															tabindex="6" type="text" esMoneda="true" style="text-align: right"/></td>
													<td class="separador"></td>
													<td class="label" id="tdlabelMontoIVAPagoServicio"><label for="lblIVAMonto"> IVA Monto:</label></td>
													<td id="tdinputIVAPagoServicio"><input id="IvaServicio" name="IvaServicio" size="15"
															 type="text" readOnly="true" iniForma="false" esMoneda="true"
															style="text-align: right"/></td>
												</tr>
												<tr>
													<td class="label"><label for="lblTotalPagar">Total Pagar:</label></td>
													<td><input id="totalPagar" name="totalPagar" iniForma="false" size="15"
														type="text" readOnly="true" esMoneda="true" style="text-align: right"/></td>
												</tr>
												<tr>
													<td class="label"><label for="lblReferencia1">Referencia:</label></td>
													<td><input id="referenciaPagoServicio" name="referenciaPagoServicio" iniForma="false" size="50"
															   onBlur="ponerMayusculas(this)" tabindex="9"	type="text" />
													</td>
												</tr>
												<tr>
													<td class="label"><label for="lblReferencia1">Segunda Referencia:</label></td>
													<td><input id="segundaRefeServicio" name="segundaRefeServicio" iniForma="false" size="50" tabindex="10" type="text"
															   onBlur=" ponerMayusculas(this)"  />
													</td>
												</tr>
												<tr>
													<td><input type="hidden"  id="origenServicio" name="origenServicio" />
														<input type="hidden"  id="cobroComisionPagoServicio" name="cobroComisionPagoServicio" />
														<input type="hidden"  id="requiereClienteServicio" name="requiereClienteServicio" />
														<input type="hidden"  id="requiereCreditoServicio" name="requiereCreditoServicio"  />
													</td>
												</tr>

											</table>
											</div>
									</fieldset>


								</fieldset>
							</div>
						</td>
					</tr>
					<tr>

					<!-- ====================== RECUPERACION DE CARTERA CASTIGADA ===================== -->
						<td colspan="5">
							<div id="carteraCastigada" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Recuperación de Cartera Castigada</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label"><label for=lblCredito>Crédito: </label></td>
											<td><input id="creditoVencido" name="creditoVencido" iniForma="false"
														size="15" tabindex="1" type="text" /></td>
											<td class="separador"></td>
											<td class="label"><label for="lblProductoCreditoVencido">Producto:</label></td>
											<td><input id="productoCreditoVencido" name="productoCreditoVencido" iniForma="false"
													size="10"  type="text" readOnly="true"/>
												<input id="desProducVencido" name="desProducVencido" size="50"
													type="text" readOnly="true"	iniForma="false" ></td>

										</tr>
										<tr>
											<td class="label"><label for="lblClienteID"><s:message code="safilocale.cliente"/>:</label></td>
											<td><input id="clienteIDVencido" name="clienteIDVencido" iniForma="false" size="15"
													 type="text" readOnly="true"/>
												<input id="nombreClienteVencido" name="nombreClienteVencido" size="60"
													type="text" readOnly="true"	iniForma="false" /></td>
											<td class="separador"></td>
											<td class="label"><label for="lblEstatusVencido">Estatus:</label></td>
											<td><input id="estatusCredVencido" name="estatusCredVencido" iniForma="false" size="15"
												 type="text" readOnly="true"/>
												</td>
										</tr>
										<tr>
											<td class="label"><label for="lblMonedaVencido">Moneda:</label></td>
											<td><input id="monedaCartVencida" name="monedaCartVencida" iniForma="false" size="15"
													 type="text" readOnly="true" />
												<input id="desMonedaCartVencida" name="desMonedaCartVencida" size="30" type="text"
													 readOnly="true" iniForma="false" />
												</td>
											<td class="separador"></td>
											<td class="label"><label for="lblMontoCredito">Monto Credito:</label></td>
											<td><input id="montoCreditoCast" name="montoCreditoCast" iniForma="false"
													 size="15" type="text" readOnly="true" />
												</td>

										<tr id="trGrupoCredCast" style="display: none;">
										<td class="label"  >
												<label for="lblGrupoCast">Grupo:	</label></td>
											<td id = "tdinputCreCast">
												<input id="grupoIDCast" name="grupoIDCast" size="12"
												iniForma="false" tabindex="17" type="text" readOnly="true"
												disabled="true" /> <input id="grupoDesCast" name="grupoDesCast"
												size="30" tabindex="18" type="text" readOnly="true" iniForma="false"
												disabled="true" /></td>

										<td class="separador"></td>
										<td class="label"><label for="lblCicloGrupCast">Ciclo:	</label></td>
										<td><input id="cicloIDCast" name="cicloIDCast" size="12"
											iniForma="false" tabindex="17" type="text" readOnly="true"
											disabled="true" /> </td>

										</tr>

									</table>
									<br>
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend>Castigo</legend>
										<div>
											<table>
											<tr>
												<td class="label"><label for="lblClicloGrupo">Fecha Castigo:</label></td>
												<td><input id="fechaCastigo" name="fechaCastigo" iniForma="false" size="18"
													 type="text" readOnly="true"  /></td>
												<td class="separador"></td>
												<td class="label"><label for="lblCapitalCastigado">Capital Castigado:</label></td>
												<td><input id="capitalCastigado" name="capitalCastigado" iniForma="false" size="18"
													  type="text" readOnly="true" esMoneda="true" style="text-align: right"/>
												</td>

											</tr>

											<tr>
												<td class="label"><label for="lblInteresCastigado">Interés Castigado:</label></td>
												<td><input id="interesCastigado" name="interesCastigado" iniForma="false" size="18"
													 type="text" readOnly="true"  esMoneda="true" style="text-align: right"/></td>
												<td class="separador"></td>
												<td class="label">
													<label for="lblmoratoriosCast">Moratorios Cast.: </label>
													&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												</td>
												<td>
												 <input id="saldoMoratoriosCast" name="saldoMoratoriosCast" size="18" type="text" readOnly="true"
												  style="text-align: right" esMoneda="true"/>
												</td>

											</tr>

											<tr>
											   <td class="label">
											   <label for="SaldoComFaltaPa">Comisiones Cast.: </label>
													&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td>
												 <input type="text" id="SaldoComFaltaPa" name="SaldoComFaltaPa" size="18"  readOnly="true"
												  style="text-align: right" esMoneda="true"/>
												</td>
											    <td class="separador"></td>
											     <td class="label">
												 		<label for="iva">IVA:</label>
												 </td>
												<td>
														<input id="iva" name="iva" iniForma="false" size="18"
															 type="text" readOnly="true" esMoneda="true" style="text-align: right" />
												</td>
											</tr>
											 <tr>
											 	<td class="label">
											 		<label for="lblTotalCastigado">Total Castigado:</label>
											 	</td>
												<td>
													<input id="totalCastigado" name="totalCastigado" iniForma="false" size="18"
													  type="text" readOnly="true" esMoneda="true" style="text-align: right"/>
												</td>
												<td class="separador"></td>
												<td class="label">
														<label for="lblMonRecuperado">Monto Recuperado:</label>
												</td>
												<td>
														<input id="monRecuperado" name="monRecuperado" iniForma="false" size="18"
															 type="text" readOnly="true" esMoneda="true" style="text-align: right" />
												</td>
											</tr>
											<tr>
												<td class="label">
														<label for="lblmontoPorRecuperar">Monto por Recuperar:</label>
												</td>
												<td>
														<input id="montoPorRecuperar" name="montoPorRecuperar" iniForma="false" size="18"
														 	type="text" readOnly="true" esMoneda="true" style="text-align: right" />
												</td>
												<td class="separador"></td>
												<td class="label">
														<label for="lblMotivoCastigo">Motivo:</label>
												</td>
												<td>
														<select id="motivoCastigo"	name="motivoCastigo" readOnly="true" disabled="true">
															</select>
												</td>
											</tr>
											<tr>
												<td class="label">
														<label for="lblMonto">Monto:</label>
												</td>
												<td>
														<input id="montoRecuperar" name="montoRecuperar" iniForma="false" size="15" tabindex="22"
															 type="text" esMoneda="true" />
														 <input id="montoRecuperadoTotal" name="montoRecuperadoTotal" iniForma="false" size="15" tabindex="22"
														 	type="hidden" esMoneda="true" />
														  <input id="montoPorRecuperarTotal" name="montoPorRecuperarTotal" iniForma="false" size="15" tabindex="22"
														 	type="hidden" esMoneda="true" />
												</td>
												<td class="separador"></td>
												<td class="label">
														<label for="lblObservacionesCastigo">Observaciones:</label>
												</td>
												<td>
														<textarea id="observacionesCastigo" name="observacionesCastigo" iniForma="false" size="21"
														 	type="text" readOnly="true" cols="35" rows="2"/>
														</textarea>
												</td>
											</tr>
									</table>
									</div>
								</fieldset>
								</fieldset>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<div id="pagoServifun" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Entrega Beneficios SERVIFUN</legend>
									<table border="0" cellpadding="0" cellspacing="0" >
										<tr>
											<td class="label" ><label for=lblFolioServifun>Folio: </label></td>
											<td><input id="serviFunFolioID" name="serviFunFolioID" iniForma="false"
														size="20" tabindex="2" type="text" />
											</td>
											<td class="separador"></td>
											<td class="label" ><label for=lblFolioServifun>Estatus: </label></td>
											<td>
												<select id="estatusServifun" name="estatusServifun"   disabled="true" tabindex="3" >
													<option value=""></option>
													<option value="C">CAPTURADO</option>
												    <option value="R">RECHAZADO</option>
												    <option value="A">AUTORIZADO</option>
												    <option value="P">PAGADO</option>
											    </select>
											</td>

										</tr>
										<tr>
									     	<td class="label" > <label for="lblMontoCargar">Monto a Entregar: </label> </td>
									     	<td>
									        	<input  type="text" id="montoEntregarServifun" name="montoEntregarServifun" tabindex="4"
									        			size="20"  readOnly="true" disabled="true" style="text-align: right;" />
									     	</td>
									     	<td class="separador"></td>
									     	<td class="separador"></td>
									     	<td class="separador"></td>
										</tr>
									</table>
									<div id="divSocio"  width="100%">
									 	<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend><s:message code="safilocale.cliente"/></legend>
											<table border="0" cellpadding="0" cellspacing="0" width="100%">
												<tr>
													<td class="label"><label for="lblSocio"><s:message code="safilocale.cliente"/>:</label></td>
													<td><input type="text" id="clienteServifunID" name="clienteServifunID" size="15"  tabindex="5" readonly="readonly" disabled="disabled"/>
														<input type="text" id="nombreCteServifun" name="nombreCteServifun" size="55"   readOnly="true" disabled="true" tabindex="6"/></td>
												</tr>
												<tr>
													<td class="label"><label for="lblFechaNacimiento">Fecha Nacimiento:</label></td>
													<td><input  type="text" id="fechaNacimientoServifun" name="fechaNacimientoServifun" size="15" readOnly="true" disabled="true" tabindex="7" />
													</td>
														<td class="separador"></td>
													<td class="label"><label for="lblefc">RFC:</label></td>
													<td><input type="text" id="rfcServifun" name="rfcServifun"	size="30" readOnly="true" disabled="true" tabindex="8"/></td>
												</tr>
												<tr>
											     	<td class="label" > <label for="lblTipoPersona">Tipo de Persona: </label> </td>
											     	<td>
											        	<input  type="text" id="tipoPersonaServifun" name="tipoPersonaServifun" size="40" readOnly="true" disabled="true" tabindex="9" />
											     	</td>
													<td class="separador"></td>
													<td class="label" > <label for="lblEstadoCivil">CURP:</label> </td>
											     	<td>
											        	<input  type="text" id="curpServifun" name="curpServifun" size="30"    readOnly="true" disabled="true" tabindex="10"/>
											     	</td>

												</tr>
												<tr>
											     	<td class="label"><label id="lblEstadoCivil">Estado Civil:</label>
													</td>
													<td>
														<select id="estadoCivilServifun" name="estadoCivilServifun"   tabindex="11" disabled="true">
															<option value="">SELECCIONAR</option>
															<option value="S">SOLTERO</option>
													     	<option value="CS">CASADO BIENES SEPARADOS</option>
													     	<option value="CM">CASADO BIENES MANCOMUNADOS</option>
													     	<option value="CC">CASADO BIENES MANCOMUNADOS CON CAPITULACION</option>
													     	<option value="V">VIUDO</option>
													     	<option value="D">DIVORCIADO</option>
													     	<option value="SE">SEPARADO</option>
													     	<option value="U">UNION LIBRE</option>

														</select>
													</td>
												</tr>
												<tr>
											     	<td class="label" > <label for="lblFechaIngreso">Fecha Ingreso: </label> </td>
											     	<td>
											        	<input  type="text" id="fechaIngresoServifun" name="fechaIngresoServifun" size="20"  readOnly="true" disabled="true" tabindex="12" />
											     	</td>
											     	<td class="separador"></td>
											     		<td class="label" > <label for="lblFechaIngreso">Edad al Ingreso: </label> </td>
											     	<td>
											        	<input  type="text" id="edadIngresoServifun" name="edadIngresoServifun" size="13"  readOnly="true" disabled="true"   tabindex="13" />
											     	</td>
												</tr>
											</table>
										 </fieldset>
										</div>
								</fieldset>

								<div id="gridServifun" style="display: none;">	</div>
								<input  type="hidden" id="cantidadServifun" name="cantidadServifun" size="8"    />
								<input  type="hidden" id="listaGridServifun" name="listaGridServifun" size="8"   readOnly="true" />
								<input  type="hidden" id="folioentregadoID" name="folioentregadoID" size="8"  />
								<input  type="hidden" id="tipoServivioServifun" name="tipoServivioServifun" size="30"   readOnly="true" />
								<input  type="hidden" id="nombreRecibeBeneficio" name="nombreRecibeBeneficio" size="30"   readOnly="true" />
								<input  type="hidden" id="nombreCteServifunID" name="nombreCteServifunID" size="30"   readOnly="true" />
								<input  type="hidden" id="curpCteServifun" name="curpCteServifun" size="30"   readOnly="true" />
								<input  type="hidden" id="tipoPersonaCteServifun" name="tipoPersonaCteServifun" size="30"   readOnly="true" />
								<input  type="hidden" id="difuntoServifunID" name="difuntoServifunID" size="30"   readOnly="true" />
								<input  type="hidden" id="difuntoServifunNomComp" name="difuntoServifunNomComp" size="30"   readOnly="true" />

								<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fielsetIndeitificacion" style="display: none;">
									<legend>Identificación</legend>
									<br>
									<div>
										<table>
											<tr>
												<td class="label"><label for="lblTipoIdentificacion">Tipo:</label></td>
												 <td><select id="tipoIdentificacion"	name="tipoIdentificacion" readOnly="true" tabindex="14">
														</select></td>
											</tr>
											<tr>
													<td class="label"><label for="lblFolio">Folio:</label></td>
												<td><input id="folioIdentificacion" name="folioIdentificacion" iniForma="false" size="21"
													  type="text" tabindex="15" maxlength="30"/>
												</td>
											</tr>
										</table>
									</div>
								</fieldset>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<div id="apoyoEscolar" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Apoyo Escolar</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label" ><label for=lblSocioAESC><s:message code="safilocale.cliente"/>: </label></td>
											<td><input id="clienteIDApoyoEsc" name="clienteIDApoyoEsc"
														size="14" tabindex="3" type="text" />
												<input  type="text" id="nombreCteApoyoEsc" name="nombreCteApoyoEsc" size="45"
												 readOnly="true" />
											</td>
											<td nowrap="nowrap">
												<input type ="button" id="buscarMiSucApo" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/>
												<input type ="button" id="buscarGeneralApo" name="buscarGeneral" value="B&uacute;squeda General" class="submit"/>
											</td>
											<td class="separador"></td>
											<td class="separador"></td>

										</tr>
										<tr>
									     	<td class="label" > <label for="lblSolicitud">Solicitud: </label> </td>
									     	<td>
									   			<select id="apoyoEscSolID" name="apoyoEscSolID" tabindex="4"></select>
									     	</td>
									     	<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
										</tr>
										<tr>
											<td class="label" ><label for=lblRecibePagoAEsc>Persona Recibe: </label></td>
											<td><input  type="text" id="recibeApoyoEscolar" name="recibeApoyoEscolar" size="45"
											 onblur="ponerMayusculas(this)"  tabindex="5"/>
											</td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>


										</tr>

									</table>
								</fieldset>

								<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fielsetSocioApoyoEscolar" style="display: none;">
									<legend>Socio</legend>
									<div>
										<table>
											<tr>
												<td class="label"><label for="lblSucursalApoyo">Sucursal:</label></td>
												 <td>
													<input id="sucursalSocioAEsc" name="sucursalSocioAEsc" size="15"
													  type="text"  readOnly="true" />
													  <input id="descSucursalAEsc" name="descSucursalAEsc" size="40"
													  type="text" readOnly="true" />


												</td>
												<td class="separador"></td>
												<td class="label"><label for="lblFechaNacimiento">Fecha Nacimiento:</label></td>
												 <td>
													<input id="fechaNacimientoAEsc" name="fechaNacimientoAEsc"  size="15"
													  type="text" readOnly="true" />

												</td>
											</tr>
											<tr>
												<td class="label"><label for="lblRFCcliente">RFC:</label></td>
												<td><input id="RFCClienteAEsc" name="RFCClienteAEsc"  size="40"
													  type="text" readOnly="true" />
												</td>
												<td class="separador"></td>
												<td class="label"><label for="lblEdad">Edad:</label></td>
												 <td>
													<input id="edadClienteAEsc" name="edadClienteAEsc"  size="15"
													  type="text" readOnly="true" /><label for="lblaños"> Años</label>

												</td>
											</tr>
												<tr>
												<td class="label"><label for="lblTipoPersona">Tipo Persona:</label></td>
												<td><input id="tipoPersonaAEsc" name="tipoPersonaAEsc"  size="40"
													  type="text" readOnly="true" />
												</td>
												<td class="separador"></td>
												<td class="label"><label for="lblFEchaIngreso">Fecha Ingreso:</label></td>
												 <td>
													<input id="fechaIngresoAEsc" name="fechaIngresoAEsc" size="15"
													  type="text" readOnly="true" />

												</td>
											</tr>
										</table>
									</div>
								</fieldset>
								<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fielsetDatosTutor" style="display: none;">
									<legend>Datos de Tutor</legend>
									<div>
										<table>
											<tr>
												<td class="label"><label for="lblClienteTutor">Socio:</label></td>
												 <td>
													<input id="clienteIDTutor" name="clienteIDTutor"  size="15"
													  type="text"  readOnly="true" />
													  <input id="nombreTutor" name="nombreTutor"  size="40"
													  type="text" readOnly="true" />
												</td>
												<td class="separador"></td>
												<td class="separador"></td>
												<td class="separador"></td>
												<td class="separador"></td>

											</tr>
											<tr>
												<td class="label"><label for="lblParentesco">Parentesco:</label></td>
												<td><input id="parentescoCliente" name="parentescoCliente"  size="15"
													  type="text"  readOnly="true" />
													 <input id="descParentesco" name="descParentesco"  size="40"
													  type="text"  readOnly="true" />
												</td>
												<td class="separador"></td>
												<td class="separador"></td>
												<td class="separador"></td>
												<td class="separador"></td>

											</tr>

										</table>
									</div>
								</fieldset>

								<br>
								<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fielsetApoyoEscolar" style="display: none;">
									<legend>Apoyo Escolar</legend>
									<div>
										<table>
											<tr>
												<td class="label"><label for="lblGradoEscolar">Grado Escolar</label></td>
												<td class="label"><label for="lblNoGrado">No. Grado</label></td>
												<td class="label"><label for="lblCicloEscolar">Ciclo Escolar</label></td>
												<td class="label"><label for="lblPromedio">Promedio</label></td>
												<td class="label"><label for="lblEdad">Edad</label></td>
												<td class="label"><label for="lblMonto">Monto</label></td>
												<td class="label"><label for="lblFecha">Fecha</label></td>
												<td class="label"><label for="lblEstatus">Estatus</label></td>
												<td class="label"><label for="lblUsuarioRegistro">Usuario Registro</label></td>


											</tr>
											<tr>
												 <td>
													<input id="descripcionGradoEsc" name="descripcionGradoEsc"  size="30"
													  type="text" tabindex="30" readOnly="true" />

												</td>
												<td>
													<input id="gradoEscolar" name="gradoEscolar"  size="10"
													  type="text" tabindex="30" readOnly="true" />

												</td>
												 <td>
													<input id="cicloEscolar" name="cicloEscolar"  size="15"
													  type="text" tabindex="30" readOnly="true" />

												</td>
												 <td>
													<input id="promedioEscolar" name="promedioEscolar" size="10"
													  type="text" tabindex="30" readOnly="true" />

												</td>
												 <td>
													<input id="edadCliente" name="edadCliente"  size="5"
													  type="text" tabindex="30" readOnly="true" />

												</td>
												<td>
													<input id="monto" name="monto"  size="15"
													  type="text" tabindex="30" readOnly="true" esMoneda="true" />

												</td>
												<td>
													<input id="fechaRegistro" name="fechaRegistro" size="13"
													  type="text" tabindex="30" readOnly="true" />

												</td>
												<td>
													<input id="estatusApoyoEscolar" name="estatusApoyoEscolar"  size="15"
													  type="text" tabindex="30" readOnly="true" />
												</td>
												<td>
													<input id="usuarioRegistra" name="usuarioRegistra"  size="40"
													  type="text" tabindex="30" readOnly="true" />
												</td>

											</tr>

										</table>
									</div>
								</fieldset>

								<br>
								</div>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<div id="ajusteSobrante" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Ajuste por Sobrante</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label" ><label for=lblMontoSobrante>Monto: </label></td>
											<td><input id="montoSobrante" name="montoSobrante" iniForma="false"
														size="20" tabindex="2" type="text" esMoneda="true" style="text-align: right"/>
											</td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>

										</tr>

									</table>
								</fieldset>
							</div>
						</td>
					</tr>

					<tr>
						<td colspan="5">
							<div id="pagoClientesCancela" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend class="ui-widget ui-widget-header ui-corner-all">Pago Cancelaci&oacute;n <s:message code="safilocale.cliente"/></legend>
									<table  style="border: 0px;"  cellpadding="0" cellspacing="0" >
										<tr>
											<td class="label" ><label for=clienteCancelaIDPCC>Folio: </label></td>
											<td><input id="clienteCancelaIDPCC" name="clienteCancelaIDPCC" iniForma="false" size="20" tabindex="2" type="text" />
											</td>
											<td class="separador"></td>
											<td class="label" ><label for=estatusPCC>Estatus: </label></td>
											<td>
												<select id="estatusPCC" name="estatusPCC"   disabled="disabled" tabindex="3" >
													<option value=""></option>
													<option value="R">REGISTRADO</option>
												    <option value="A">AUTORIZADO</option>
												    <option value="P">PAGADO</option>
											    </select>
											</td>
										</tr>
										<tr>
									     	<td class="label" > <label for="clienteIDPCC"><s:message code="safilocale.cliente"/>: </label> </td>
									     	<td colspan="4">
									        	<input  type="text" id="clienteIDPCC" name="clienteIDPCC" tabindex="4" size="20"  readonly="readonly" disabled="disabled"/>
									        	<input  type="text" id="nombreClientePCC" name="nombreClientePCC" tabindex="5" size="60"  readonly="readonly" disabled="disabled"/>
									     	</td>
										</tr>
										<tr>
											<td class="label"><label for="fechaNacimientoPCC">Fecha Nacimiento:</label></td>
											<td><input  type="text" id="fechaNacimientoPCC" name="fechaNacimientoPCC" size="15" readonly="readonly" disabled="disabled" tabindex="6" />
											</td>
												<td class="separador"></td>
											<td class="label"><label for="rfcPCC">RFC:</label></td>
											<td><input type="text" id="rfcPCC" name="rfcPCC"	size="30" readonly="readonly" disabled="disabled" tabindex="7"/></td>
										</tr>
										<tr>
									     	<td class="label" > <label for="tipoPersonaPCC">Tipo de Persona: </label> </td>
									     	<td>
									        	<input  type="text" id="tipoPersonaPCC" name="tipoPersonaPCC" size="40" readonly="readonly" disabled="disabled" tabindex="8" />
									     	</td>
											<td class="separador"></td>
											<td class="label" > <label for="curpPCC">CURP:</label> </td>
									     	<td>
									        	<input  type="text" id="curpPCC" name="curpPCC" size="30" readonly="readonly" disabled="disabled" tabindex="9"/>
									     	</td>
										</tr>
										<tr>
									     	<td class="label" > <label for="sucursalOrigenPCC">Sucursal <s:message code="safilocale.cliente"/>: </label> </td>
									     	<td>
									        	<input  type="text" id="sucursalOrigenPCC" name="sucursalOrigenPCC" size="4" readonly="readonly" disabled="disabled" tabindex="10" />
									     		<input  type="text" id="sucursalOrigenDesPCC" name="sucursalOrigenDesPCC" size="40" readonly="readonly" disabled="disabled" tabindex="11" />
									     	</td>
											<td class="separador"></td>
											<td>
									        	<input  type="hidden" id="numeroMonedaBasePCC" name="numeroMonedaBasePCC" size="4" readonly="readonly" disabled="disabled"/>
											</td>
										</tr>
										<tr>
											<td colspan="5">
												<div id="divBeneficiariosPCC">
											 	</div>
											</td>
										</tr>

									</table>
								</fieldset>
							</div>
						</td>
					</tr>

					<tr>
						<td colspan="5">
							<div id="ajusteFaltante" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Ajuste por Faltante</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label" ><label for=lblMontoFaltante>Monto: </label></td>
											<td><input id="montoFaltante" name="montoFaltante" iniForma="false"
														size="20" tabindex="2" type="text" esMoneda="true" style="text-align: right"/>
											</td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
											<td class="separador"></td>
										</tr>
									</table>
								</fieldset>
							</div>
						</td>
					</tr>
					<!-- TARJETA -->
					<tr>
						<td colspan="5">
							<div id="cobroAnualidadTarjeta" style="display: none;" >
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Cobro Anualidad Tarjeta de Debito</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label" ><label for=lblNumTarjetaDeb>No. Tarjeta: </label></td>
											<td><input id="tarjetaDebID" name="tarjetaDebID" iniForma="false" maxlength="16"
														size="20" tabindex="2" type="text" />
											</td>
											<td class="separador"></td>
											<td class="label" ><label for=lblEstatusTarjeta>Estatus: </label></td>
											<td><input id="estatusTarjetaDeb" name="estatusTarjetaDeb" iniForma="false"
														size="40" tabindex="2" type="text"readOnly="true" />
											</td>

										</tr>
										<tr>
											<td class="label" ><label for=lblNumTarjetaDeb>No. Cuenta: </label></td>
											<td><input id="numCtaTarjetaDeb" name="numCtaTarjetaDeb" iniForma="false"
														size="20" tabindex="2" type="text" readOnly="true" />
											</td>
											<td class="separador"></td>
											<td class="label" ><label for=lblMontocomision>Monto Comisión: </label></td>
											<td><input id="montoComisionTarjeta" name="montoComisionTarjeta" iniForma="false"
														size="20" tabindex="2" type="text" esMoneda="true" readOnly="true"
														style="text-align: right"/>

											</td>

										</tr>
										<tr>
											<td class="label" ><label for=lblIva>I.V.A.: </label></td>
											<td><input  type="text"  id="ivaComisionTarjeta" name="ivaComisionTarjeta" iniForma="false"
														size="20" tabindex="2" readOnly="true"  type="text"
														 esMoneda="true" style="text-align: right"/>
											</td>
											<td class="separador"></td>
											<td class="label" ><label for=lbltotal>Total: </label></td>
											<td><input id="totalComisionTD" name="totalComisionTD" iniForma="false"
														size="20" tabindex="2" type="text" esMoneda="true" readOnly="true"
														style="text-align: right"/>
											</td>

										</tr>

									</table>
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend>Datos Tarjeta</legend>
									<div>
										<table>
											<tr>
												<td class="label"><label for="lblCteTarjeta">Cliente:</label></td>
												<td><input id="clienteIDTarjeta" name="clienteIDTarjeta" iniForma="false" size="15"
													 type="text" readOnly="true"  />
													 <input id="nombreCteTarjeta" name="nombreCteTarjeta" iniForma="false" size="50"
													 type="text" readOnly="true"  />
												</td>

											</tr>
											<tr id="cteCorpTr">
												<td class="label"><label for="lblCteCorporativo">Cliente Corporativo:</label></td>
												<td><input id="clienteIDCorporativo" name="clienteIDCorporativo" iniForma="false" size="15"
													  type="text" readOnly="true" />
													   <input id="nombreCteCorpoTarjeta" name="nombreCteCorpoTarjeta" iniForma="false" size="50"
													 type="text" readOnly="true"  />
												</td>
											</tr>
											<tr>
												<td class="label"><label for="lblCteTarjeta">Tipo Tarjeta:</label></td>
												<td><input id="tipoTarjeta" name="tipoTarjeta" iniForma="false" size="15"
													 type="text" readOnly="true"  />
													 <input id="descTipoTarjeta" name="descTipoTarjeta" iniForma="false" size="40"
													 type="text" readOnly="true"  />
												</td>
												<td class="separador"></td>
											</tr>
										</table>
									</div>
								</fieldset>

								</fieldset>
							</div>
						</td>
					</tr>

					<%-----------------------------------------------	ANTICIPOS Y GASTOS 	----------------------------------------------%>
					<tr>
						<td colspan="5">
							<div id="gastosAnticipos" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Gastos y Anticipos</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label"><label for="lbOperaGastosAnt">Operaci&oacute;n:</label>
											</td>
											<td>
											<select id="tipoAntGastoID" name="tipoAntGastoID" tabindex="2">
														<option value="">Seleccionar</option>
											</select>
											</td>
										</tr>
										<tr>
											<td class="label" id="laber"><label for="lblEmpleado">Empleado:</label></td>
											<td colspan="4" id="empGas">
											<input type="text" id="empleadoID"name="empleadoID" size="11" type="text"
													  tabindex="4" />
											<input id="nombreEmpleadoGA" name="nombreEmpleadoGA" size="60"
												type="text" readOnly="true"  />
											</td>
											<td class="separador" id="separa"></td>

											<td class="label"><label for="lblMontoGasto">Monto: </label></td>
											<td><input id="montoGastoAnt" name="montoGastoAnt" size="12"
												type="text" esMoneda="true" style="text-align: right"
												 tabindex="8" />
												<input type="hidden" id="montoMAXEfect" name="montoMAXEfect" />
												<input type="hidden" id="montoMAXTrans" name="montoMAXTrans" />
												<input type="hidden" id="naturaleza" name="naturaleza" />
												<input type="hidden" id="instrumento" name="instrumento" />
												<input type="hidden" id="reqEmp" name="reqEmp" />

											</td>
										</tr>

									</table>
								</fieldset>
							</div>
						</td>
					</tr>

					<%-----------------------------------------------DEVOLUCIONES DE ANTICIPOS Y GASTOS 	----------------------------------------------%>
					<tr>
						<td colspan="5">
							<div id="DevGastosAnticipos" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Devoluciones de Gastos o Anticipos</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label"><label for="lbOperaDevGastosAnt">Operaci&oacute;n:</label>
											</td>
											<td>
											<select id="tipoDevAntGastoID" name="tipoDevAntGastoID" tabindex="2">
														<option value="">Seleccionar</option>
											</select>
											</td>
										</tr>
										<tr>
											<td class="label" id="label"><label for="lblEmpleadoDev">Empleado:</label></td>
											<td colspan="4" id="empDev">
											<input type="text" id="empleadoIDDev"name="empleadoIDDev" size="11" type="text"
													  tabindex="4" />
											<input id="nombreEmpleadoDev" name="nombreEmpleadoDev" size="60"
												type="text" readOnly="true"  />
											</td>
											<td class="separador" id="separaDev"></td>
											<td class="label"><label for="lblMontoGastoDev">Monto: </label></td>
											<td>
												<input id="montoGastoDev" name="montoGastoDev" size="12" type="text" esMoneda="true" style="text-align: right" tabindex="8" />
											</td>
										</tr>

									</table>
								</fieldset>
							</div>
						</td>
					</tr>



					<%-----------------------------------------------Reclamo de Haberes Menor 	----------------------------------------------%>
					<tr>
						<td colspan="5">
							<div id="recHaberesMenor" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all"><s:message code="safilocale.cliente"/> Menor</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label"><label for="lbClienteMenor"><s:message code="safilocale.cliente"/>:</label>
											</td>
											<td colspan="4">
											<input id="clienteIDMenor"name="clienteIDMenor" size="11" type="text"
													  tabindex="8" />
											<input id="nombreClienteMenor" name="nombreClienteMenor" size="60"
												type="text" readOnly="true"  />
											</td>
											<td></td>
											<td nowrap="nowrap">
												<input type ="button" id="buscarMiSucRe" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/>
												</td>
												<td>
												<input type ="button" id="buscarGeneralRe" name="buscarGeneral" value="B&uacute;squeda General" class="submit"/>
											</td>

										</tr>
										<tr>
											<td class="label"><label for="lblFecha">Fecha Nacimiento: </label></td>
											<td><input id="fechaNacMenor" name="fechaNacMenor" size="12"readOnly="true"
												type="text"  />
										</tr>

										<tr>
											<td class="label"><label for="lblSucursal">Sucursal:</label></td>
											<td colspan="4">
											<input id="sucursalMenor"name="sucursalMenor" size="11" type="text"
													   readOnly="true"  />
											<input id="nombreSucMenor" name="nombreSucMenor" size="60"
												type="text" readOnly="true"  />
											</td>

											<td class="separador"></td>
											<td class="label"><label for="lblEdadMenor">Edad: </label></td>
											<td><input id="edadMenor" name="edadMenor" size="12"
												type="text"	 readOnly="true" />
											</td>
										</tr>
										<tr>
											<td class="label"><label for="lblCURPMenor">CURP:</label></td>
											<td colspan="4">
											<input id="curpMenor"name="curpMenor" size="25" type="text" readOnly="true"/>
											</td>
											<td class="separador"></td>
											<td class="label"><label for="lblestatusMenor">Estatus: </label></td>
											<td><input id="estatusMenor" name="estatusMenor" size="12" readOnly="true"
												type="text"	  />
											</td>
										</tr>
										<tr>
											<td class="label"><label for="lblidentiMenor">Identificación:</label></td>
											<td colspan="4">
												<form:select id="identiMenor" name="identiMenor"  path="" tabindex="9">
													<form:option value="-1">Seleccionar</form:option>
												</form:select>
												<input id="descIdentiMenor"name="descIdentiMenor" onblur=" ponerMayusculas(this)"  size="25" type="text"
												tabindex="10" />
											</td>
											<td class="separador"></td>
											<td class="label"><label for="lbltotal">Total a Entregar: </label></td>
											<td><input id="totalHaberes" name="totalHaberes" size="12" readOnly="true" esMoneda="true"
														style="text-align: right" type="text"	 />
														<input type="hidden" id="numCaracteresMaxMin" name="numCaracteresMaxMin" />
											</td>
										</tr>
									</table>
								</fieldset>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<div id="divFormaPago" style="display: none;">
								<br>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>Forma de Pago</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="50%" >
										<tr>
											<td class="label">
												<label for="lblformaPago">Forma de Pago:</label>
											</td>
											 <%-- td class="separador"></td>--%>
											<td>
												<input type="radio" id="formaPagoOpera1" name="formaPagoOpera" value="E" tabindex ="15" checked="true"/>
												<label for="lblformaPagoEfe">Efectivo</label>
											</td>
											<%--<td class="separador"></td>--%>
											<td >
												<input type="radio" id="formaPagoOpera2" name="formaPagoOpera" value="C" tabindex ="16"/>
												<label for="lblformaPagoCheque">Cheque</label>
											</td>
										</tr>
									</table>
								</fieldset>
								<br>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<div id="divCuentaCheques" style="display: none;">
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend>Datos Chequera</legend>
										<table border="0" cellpadding="0" cellspacing="0" width="810px" >
											<tr>
												<td class="label" >
													<label for="lblCuentaDeCheques">Cuenta de Cheques:</label>
												</td>
												<td colspan="3">
													<select id="cuentaChequePago" name="cuentaChequePago" tabindex="19">
														<option value="">SELECCIONAR</option>
													</select>
												</td>
												<td class="separador" colspan="2">
											</tr>
											<tr>
												<td class="label" >
													<label for="lblTipoChequera">Tipo Chequera:</label>
												</td>
												<td colspan="3">
													<select id="tipoChequera" name="tipoChequera" tabindex="20">
														<option value="">SELECCIONAR</option>
													</select>
												</td>
												<td class="separador" colspan="2">
											</tr>
											<tr>
												<td class="label">
													<label for="lblult">Último Cheque Utilizado en esta Cuenta:</label>
												</td>
												<td>
													<input id="folioUtilizar" name="folioUtilizar" size="10"
														readonly=true type="text" />
												</td>
												<td class="separador" colspan="2">
											</tr>
											<tr>
												<td class="label">
													<label for="lblult">Introduzca Número de Cheque:</label>
												</td>
												<td>
													<input id="numeroCheque" name="numeroCheque" size="10"
														type="text" tabindex="21" maxlength="14" />
												</td>
												<td class="separador" colspan="2">
											</tr>
											<tr>
												<td class="label">
													<label for="lblult">Confirme Número de Cheque:</label>
												</td>
												<td>
													<input id="confirmeCheque" name="confirmeCheque" size="10"
														type="text" tabindex="22" maxlength="14" />
												</td>
												<td class="separador" colspan="2">
											</tr>
												<tr>
												<td class="label">
													<label for="lblult">Nombre de Beneficiario Cheque:</label>
												</td>
												<td>
													<input id="beneCheque" name="beneCheque" size="50"
														type="text" tabindex="23" maxlength="50"
														 onBlur="ponerMayusculas(this)"/>
												</td>
												<td class="separador" colspan="2">
											</tr>
											<tr>
												<td>
													<input type="hidden" id="ctaChequeLista" name="ctaChequeLista" value="" />
													<input type="hidden" id="institucionID" name="institucionID" />
													<input type="hidden" id="numCtaInstit" name="numCtaInstit" />
													<input type="hidden" id="rutaChequeInstit" name="rutaChequeInstit" />
												</td>
											</tr>
										</table>
									</fieldset>	<br>
								</div>
					</tr>
					<%----------------------------------------------- PAGO DE SERVICIOS EN LINEA	----------------------------------------------%>
					<tr>
						<td colspan="5" >
							<div id="pagoServiciosEnLinea" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Cobro de Servicios en Linea</legend>
									<table>
										<tr>
											<td><label for="productoID">Servicio:</label></td>
											<td>
												<select id='productoID' name='productoID' tabindex="2">
													<option value="-1">SELECCIONE</option>
												</select>
											</td>
											<td>
												<label><s:message code="safilocale.cliente"/>/Usuario:</label>
												<input type="radio" id="tipoUsuarioC" name="tipoUsuario" tabindex="3" value="S"/> <label><s:message code="safilocale.cliente"/></label>
												<input type="radio" id="tipoUsuarioU" name="tipoUsuario" tabindex="4" value="U"/> <label>Usuario</label>
											</td>
										</tr>
										<tr>
											<td><label id="lblnumeroTarjetaPSL" for="numeroTarjetaPSL">Numero tarjeta:</label></td>
											<td>
												<input type="text" id="numeroTarjetaPSL" name="numeroTarjetaPSL" size="40" tabindex="5" autocomplete="off"/>
											</td>
											<td></td>
										</tr>
										<tr id="filaClientePSL" style="display: none;">
											<td><label for="clienteIDPSL"><s:message code="safilocale.cliente"/>:</label></td>
											<td colspan="2">
												<input type="text" id="clienteIDPSL" name="clienteIDPSL" size="10" tabindex="6" autocomplete="off"/>
												<input type="text" id="nombreClientePSL" name="nombreClientePSL" disabled="disable" size="40" tabindex="7"/>
												<input type="button" class="submit" id="buscarMiSucPSL" name="buscarMiSuc" value="Buscar Mi Sucursal" tabindex="8"/>
												<input type="button" class="submit" id="buscarGeneralPSL" name="buscarGeneral" value="Busqueda General" tabindex="9"/>
											</td>
										</tr>
										<tr>
											<td colspan="3">
												<fieldset class="ui-widget ui-widget-content ui-corner-all">
													<legend ><label>Cobro</label></legend>
													<table>
														<tr>
															<td><label>Forma de pago:</label></td>
															<td colspan="2">
																<input type="radio" id="formaPagoE" name="formaPagoPSL" tabindex="10" value="E" disabled="disable"/> <label id="descFormaPagoE">Efectivo</label>
																<input type="radio" id="formaPagoC" name="formaPagoPSL" tabindex="11" value="C" disabled="disable"/><label id="descFormaPagoC">Cargo a Cuenta de Ahorro</label>
															</td>
														</tr>
														<tr id="filaCuentaAhorroPSL" style="display: none;">
															<td><label for="cuentaAhorroPSL" maxlength="25">Cuenta Ahorro</label></td>
															<td><input type="text" id="cuentaAhorroPSL" name="cuentaAhorroPSL" tabindex="12" autocomplete="off"/></td>
															<td colspan="2">
																<input type="text" size="45" disabled="disabled" id="nomCuentaAhoPSL" tabindex="13"/>
																<label id="lblDescSaldoDispon"></label>
															</td>
														</tr>
														<tr>
															<td><label class="lblCorrecto" for="precio">Monto del Servicio:</label></td>
															<td><input type="text" id="precio" name="precio" esMoneda="true" style="text-align: right" autocomplete="off" disabled="disable" tabindex="14" maxlength="10"/></td>
															<td><label>Comisión Proveedor de Serv:</label></td>
															<td><input type="text" id="comisiProveedor" name="comisiProveedor" esMoneda="true" style="text-align: right" disabled="disable" tabindex="15"/></td>
														</tr>
														<tr>
															<td></td>
															<td></td>
															<td><label>Comisión Institución:</label></td>
															<td><input type="text" id="comisiInstitucion" name="comisiInstitucion" esMoneda="true" style="text-align: right" disabled="disable" tabindex="16"/></td>
														</tr>
														<tr>
															<td><label>Total Comisiones:</label></td>
															<td><input type="text" id="totalComisiones" name="totalComisiones" esMoneda="true" style="text-align: right" disabled="disable" tabindex="17"/></td>
															<td><label>IVA de Comisión Institución:</label></td>
															<td><input type="text" id="ivaComisiInstitucion" name="ivaComisiInstitucion" esMoneda="true" style="text-align: right" disabled="disable" tabindex="18" /></td>
														</tr>
														<tr>
															<td><label>Total a pagar:</label></td>
															<td>
																<input type="text" id="totalPagarPSL" name="totalPagarPSL" esMoneda="true" style="text-align: right" disabled="disable" tabindex="19"/>
															</td>
															<td>
																<input type="hidden" id="totalServicioPSL" value="0.0"/>
																<!-- Saldo disponible en la cuenta del cliente -->
																<input type="hidden" id="saldoDisponPSL" value="0.0"/>
																<input type="hidden" id="canalPSL" name="canalPSL" value="V"/>
																<input type="hidden" id="nombreProductoPSL" name="nombreProductoPSL"/>
																<input type="hidden" id="servicioIDPSL" name="servicioIDPSL"/>
																<input type="hidden" id="clasificacionServPSL" name="clasificacionServPSL" />
																<input type="hidden" id="tipoReferencia" name="tipoReferencia"/>
																<input type="hidden" id="tipoFront" name="tipoFront" value=""/>
																<!-- Total de entradas por Cargo a Cuenta -->
																<input type="hidden" id="totalEntradaPSL" name="totalEntradaPSL" value="0.0"/>
															</td>
															<td></td>
														</tr>
													</table>
												</fieldset>
											</td>
										</tr>
										<tr>
											<td colspan="3">
												<fieldset class="ui-widget ui-widget-content ui-corner-all">
													<legend><label>Datos del Servicio</label></legend>
													<table>
														<tr>
															<td><label id="lbltelefonoPSL" for="telefonoPSL">Número de Teléfono:</label></td>
															<td><input type="text" id="telefonoPSL" name="telefonoPSL" tabindex="20" name="telefonoPSL" maxlength="10" autocomplete="off" disabled="disabled"/></td>
															<td><label id="lblconfirmTelefonoPSL" for="confirmTelefonoPSL">Confirmar Número de Teléfono:</label></td>
															<td><input type="text" id="confirmTelefonoPSL" tabindex="21" name="confirmTelefonoPSL" maxlength="10" autocomplete="off" disabled="disabled"/></td>
														</tr>
														<tr>
															<td><label id="lblreferenciaPSL" for="referenciaPSL">Número de Referencia:</label></td>
															<td><input type="text" id="referenciaPSL" tabindex="22" name="referenciaPSL" maxlength="30" autocomplete="off" disabled="disabled"/></td>
															<td><label id="lblconfirmReferenciaPSL" for="confirmReferenciaPSL">Confirmar Número de Referencia:</label></td>
															<td><input type="text" id="confirmReferenciaPSL" tabindex="23" name="confirmReferenciaPSL" maxlength="30" autocomplete="off" disabled="disabled"/></td>
														</tr>
													</table>
												</fieldset>
											</td>
										</tr>
									</table>
								</fieldset>
							</div>
						</td>
					</tr>
					<!-- -------------------  COBRO ACCESORIOS CREDITO ------------------------->
					<tr>
						<td colspan="5">
							<div id="cobroAccesoriosCre" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Cobro de Accesorios Cr&eacute;dito</legend>
									<table>
										<tr>
											<td class="label"><label for="lblcreditoIDCA">Cr&eacute;dito:</label></td>
											<td><input id="creditoIDCA" name="creditoIDCA" size="17"
												iniForma="false" type="text" tabindex="2" />
											</td>
											<td class="separador"></td>
											<td class="label" nowrap="nowrap">
												<label for="accesorioID">Accesorio: </label>
											</td>
											<td>
												<select id="accesorioID" name="accesorioID" path="accesorioID" tabindex="3">
													<option value="">SELECCIONAR</option>
												</select>
											</td>
										</tr>
										<tr>
											<td class="label"><label for="lblclienteIDCA"><s:message code="safilocale.cliente"/>:</label></td>
											<td><input id="clienteIDCA" name="clienteIDCA" size="17"
												tabindex="3" type="text" readOnly="true" disabled="true"
												iniForma="false" /> <input id="nombreClienteCA"
												name="nombreClienteCA" size="60" tabindex="4" type="text"
												readOnly="true" disabled="true" iniForma="false" />
											</td>
											<td class="separador"></td>
											<td class="label"><label for="lblMontoCreCA">Monto:</label></td>
											<td><input type="text" id="montoCreCA" name="montoCreCA"
												readOnly="true" disabled="true" size="17" tabindex="5"
												esMoneda="true" iniForma="false" />
											</td>
										</tr>
										<tr>
											<td class="label"><label for="lblProdCred">Producto	Cr&eacute;dito:</label></td>
											<td><input id="productoCreditoIDCA"
												name="productoCreditoIDCA" size="17" tabindex="6"
												type="text" readOnly="true" disabled="true" iniForma="false" />
												<input id="desProdCreditoCA" name="desProdCreditoCA"
												size="30" tabindex="7" type="text" readOnly="true"
												disabled="true" iniForma="false" />
											</td>
											<td class="separador"></td>
											<td class="label"><label for="lblcuentaIDcreCA">Cuenta Cargo: </label></td>
											<td nowrap="nowrap"><input type="text" id="cuentaAhoIDCAc"
												name="cuentaAhoIDCAc" readOnly="true" disabled="true"
												size="17" tabindex="8" iniForma="false" /> <input
												id="nomCuentaCA" name="nomCuentaCA" size="30" tabindex="9"
												type="text" readOnly="true" disabled="true" iniForma="false" />
											</td>
										</tr>
										<tr>
											<td class="label"><label for="lblmonedaCA">Moneda:</label></td>
											<td><input id="monedaIDCAc" name="monedaIDCAc" size="17"
												iniForma="false" tabindex="10" type="text" readOnly="true"
												disabled="true" /> <input id="monedaDesCA"
												name="monedaDesCA" size="30" iniForma="false" tabindex="11"
												type="text" readOnly="true" disabled="true" />
											</td>
											<td class="separador"></td>
											<td class="label" nowrap="nowrap"><label for="lblTipoComisionCA">Tipo Comisi&oacute;n:</label></td>
											<td><input id="tipoComisionCA" name="tipoComisionCA"
													readOnly="true" disabled="true" iniForma="false" size="17"
													tabindex="14" type="text" />
													<input id="formaCobCA" name="formaCobCA"
													readOnly="true" disabled="true" iniForma="false" size="17"
													tabindex="14" type="hidden" />
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap"><label for="lblMontoComisionCA">Monto Comisi&oacute;n:</label></td>
											<td><input type="text" id="montoComisionCA" name="montoComisionCA"
												readOnly="true" disabled="true" size="17" tabindex="12"
												iniForma="false" esMoneda="true"  style="text-align: right" />
												<label for="lblivaMontoRealCA">IVA:</label>
												<input id="ivaMontoRealCA" name="ivaMontoRealCA" size="17"
												iniForma="false" tabindex="15" type="text" readOnly="true"
												disabled="true" esMoneda="true"  style="text-align: right" />
											</td>
											<td class="separador"></td>
											<td class="label" nowrap="nowrap"><label for="lbltotalComPAgadoCA"> Comisi&oacute;n Pagada:</label></td>
											<td><input id="totalPagadoDepCA" name="totalPagadoDepCA" iniForma="false" size="17"
												tabindex="15" type="text" esMoneda="true"  style="text-align: right" readOnly="true"
												disabled="true"/>
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap"><label for="lblComisionPendienteCA">Pendiente Pago:</label></td>
											<td><input type="text" id="comisionPendienteCA" name="comisionPendienteCA"
												readOnly="true" disabled="true" size="17" tabindex="12"
												iniForma="false" esMoneda="true"  style="text-align: right" />
												<label for="lblivaPendienteCA">IVA:</label>
												<input id="ivaPendienteCA" name="ivaPendienteCA" size="17"
												iniForma="false" tabindex="15" type="text" readOnly="true"
												disabled="true" esMoneda="true"  style="text-align: right" />
											</td>
											<td class="separador"></td>
											<td class="label"><label for="lbltotalDepCA">Total:</label></td>
											<td><input id="totalDepCA" name="totalDepCA" iniForma="false" size="17"
												tabindex="15" type="text" esMoneda="true"  style="text-align: right"/>
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap"><label for="lblComisionCA">Comisi&oacute;n a Pagar:</label></td>
											<td><input type="text" id="comisionCA" name="comisionCA"
												readOnly="true" disabled="true" size="17" tabindex="12"
												type="text" iniForma="false" esMoneda="true"  style="text-align: right" />
												<label for="lblivaCA">IVA:</label>
												<input id="ivaCA" name="ivaCA" size="17"
												iniForma="false" tabindex="15" type="text" readOnly="true"
												disabled="true" esMoneda="true"  style="text-align: right" />
											</td>
											<td class="separador"></td>
											<td class="label" id="tdGrupoCAlabel"><label for="lblGrupo">Grupo:</label></td>
											<td id="tdGrupoCAinput" nowrap="nowrap"><input id="grupoIDCA" name="grupoIDCA"
												readOnly="true" disabled="true" iniForma="false" size="12"
												tabindex="14" type="text" />
												<input id="grupoDesCA" name="grupoDesCA"  iniForma="false"
												size="30" tabindex="10" type="text" readOnly="true"
												disabled="true" />
											</td>
										</tr>
										<tr>
											<td class="label" id = "tdGrupoCicloCAlabel" style="display: none;"><label for="lblGrupoCicloDCA">Ciclo:</label></td>
											<td id = "tdGrupoCicloCAinput" style="display: none;">
												<input id="cicloIDCA" name="cicloIDCA"
													readOnly="true" disabled="true" iniForma="false" size="17"
													tabindex="16" type="text" />
											</td>
										</tr>
									</table>
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
											<td><input id="claveUsuarioAut" name="claveUsuarioAut" size="25" iniForma="false" type="password"
														tabindex="3"/></td>


											<td class="label" nowrap="nowrap"><label for="lblContrasenia">Contraseña:</label></td>
											<td><input id="contraseniaAut" name="contraseniaAut" size="50"	 type="password"
											 		iniForma="false" tabindex="4"/>
												</td>
										</tr>
									</table>
								 </fieldset>
							</div>
						</td>
					</tr>
					<!-- ---------------------------------------- INICIO DEPOSITO ACTIVACION CUENTA --------------------------------- -->					
					<tr>
						<td colspan="5">
							<div id="divDepositoActivaCta" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Depósito Activación Cuenta</legend>
									<table width="100%">
										<tr>
											<td nowrap="nowrap" class="label">
												<label for="cuentaAhoIDdepAct">Cuenta: </label>
											</td>
											<td nowrap="nowrap">
												<input type="text" id="cuentaAhoIDdepAct" name="cuentaAhoIDdepAct" iniForma="false" size="18" tabindex="2" />
												<input type="hidden" id="refCuentaTicketdepAct" name="refCuentaTicketdepAct" iniForma="false" />
											</td>
											<td class="separador"></td>
											<td class="label">
												<label for="clienteIDdepAct">
													<s:message code="safilocale.cliente" />:
												</label>
											</td>
											<td>
												<input type="text" id="clienteIDdepAct" name="clienteIDdepAct" size="18" readOnly="true" disabled="true" />
												<input type="text" id="nombreClientedepAct" name="nombreClientedepAct" size="40" readOnly="true" disabled="true" />
											</td>
										</tr>
										<tr>
											<td nowrap="nowrap">
												<label for="lblCuentaAhoID">Tipo Cuenta: </label>
											</td>
											<td nowrap="nowrap" >
												<input type="text" id="tipoCuentaIDdepAct" name="tipoCuentaIDdepAct" size="18" readOnly="true" disabled="true" />
												<input type="text" id="descTipoCuentaIDdepAct" name="descTipoCuentaIDdepAct" size="40" readOnly="true" disabled="true" />
											</td>
											<td class="separador"></td>
											<td nowrap="nowrap" class="label">
												<label for="monedaIDdepAct">Moneda: </label>
											</td>
											<td nowrap="nowrap">
												<input type="text" id="monedaIDdepAct" name="monedaIDdepAct" size="18" readOnly="true" disabled="true" />
												<input type="text" id="descMonedaIDdepAct" name="descMonedaIDdepAct" size="40" readOnly="true" disabled="true" />
											</td>
										</tr>
										<tr>
											<td nowrap="nowrap" class="label">
												<label for="montoDepositoActiva">Depósito Requerido:</label>
											</td>
											<td>
												<input type="text" id="montoDepositoActiva" name="montoDepositoActiva" size="18" readOnly="true" disabled="true"/>
											</td>
											<td class="separador"></td>
											<td class="label">
												<label for="montoDepositoActivaCta">Monto:</label>
											</td>
											<td>
												<input type="text" id="montoDepositoActivaCta" name="montoDepositoActivaCta" size="18" esMoneda="true" style="text-align: right" iniForma="false" tabindex="3" />
											</td>
										</tr>
									</table>
								</fieldset>
							</div>
						</td>
					</tr>
					<!-- ---------------------------------------- FIN DEPOSITO ACTIVACION CUENTA --------------------------------- -->					
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
															style="text-align: right" value="1"/> <input
															id="denoEntraMil" name="denomiEntrada" size="8"
															type="text" readOnly="true" iniForma="false"
															disabled="true" style="text-align: right"
															value="1000"/></td>
														<td class="separador"></td>
														<td align="right"><input id="cantEntraMil"  onfocus="validaFocoInputMonedaGrid(this.id);" onkeypress="return validaSoloNumero(event,this);"
															name="cantEntrada" size="6" type="text" value="0"
															iniForma="false" style="text-align: right" maxlength = "10"/></td>
														<td class="separador"></td>
														<td align="right"><input id="montoEntraMil"
															name="montoEntrada" size="10" type="text" readOnly="true"
															iniForma="false" disabled="true" esMoneda="true"
															style="text-align: right"/></td>
													</tr>
													<tr>
														<td align="right"><input id="denoEntraQuiID"
															name="denomiEntradaID" size="4" type="hidden"
															readOnly="true" iniForma="false" disabled="true"
															style="text-align: right" value="2"/> <input
															id="denoEntraQui" name="denomiEntrada" size="8"
															type="text" readOnly="true" iniForma="false"
															disabled="true" style="text-align: right"
															value="500"/></td>
														<td class="separador"></td>
														<td align="right"><input id="cantEntraQui" onfocus="validaFocoInputMonedaGrid(this.id);"  onkeypress="return validaSoloNumero(event,this);"
															name="cantEntrada" size="6" type="text" value="0"
															iniForma="false" style="text-align: right" maxlength = "10"/></td>
														<td class="separador"></td>
														<td align="right"><input id="montoEntraQui"
															name="montoEntrada" size="10" type="text" readOnly="true"
															iniForma="false" disabled="true" esMoneda="true"
															style="text-align: right"/></td>
													</tr>
													<tr>
														<td align="right"><input id="denoEntraDosID"
															name="denomiEntradaID" size="4" type="hidden"
															readOnly="true" iniForma="false" disabled="true"
															style="text-align: right" value="3"/> <input
															id="denoEntraDos" name="denomiEntrada" size="8"
															type="text" readOnly="true" iniForma="false"
															disabled="true" style="text-align: right"
															value="200"/></td>
														<td class="separador"></td>
														<td align="right"><input id="cantEntraDos" onfocus="validaFocoInputMonedaGrid(this.id);" onkeypress="return validaSoloNumero(event,this);"
															name="cantEntrada" size="6" type="text" value="0"
															iniForma="false" style="text-align: right" maxlength = "10"/></td>
														<td class="separador"></td>
														<td class="label" align="right"><input
															id="montoEntraDos" name="montoEntrada" size="10"
															type="text" readOnly="true" disabled="true"
															iniForma="false" esMoneda="true"
															style="text-align: right"/></td>
													</tr>
													<tr>
														<td align="right"><input id="denoEntraCienID"
															name="denomiEntradaID" size="4" type="hidden"
															readOnly="true" iniForma="false" disabled="true"
															style="text-align: right" value="4"/> <input
															id="denoEntraCien" iniForma="false" name="denomiEntrada"
															size="8" type="text" readOnly="true" disabled="true"
															style="text-align: right" value="100"/></td>
														<td class="separador"></td>
														<td align="right"><input id="cantEntraCien" onfocus="validaFocoInputMonedaGrid(this.id);" onkeypress="return validaSoloNumero(event,this);"
															name="cantEntrada" size="6" type="text" value="0"
															iniForma="false" style="text-align: right" maxlength = "10"/></td>
														<td class="separador"></td>
														<td class="label" align="right"><input
															id="montoEntraCien" name="montoEntrada" size="10"
															type="text" readOnly="true" disabled="true"
															iniForma="false" esMoneda="true"
															style="text-align: right"/></td>
													</tr>
													<tr>
														<td align="right"><input id="denoEntraCinID"
															name="denomiEntradaID" size="4" type="hidden"
															readOnly="true" iniForma="false" disabled="true"
															style="text-align: right" value="5"/> <input
															id="denoEntraCin" iniForma="false" name="denomiEntrada"
															size="8" type="text" readOnly="true" disabled="true"
															style="text-align: right" value="50"/></td>
														<td class="separador"></td>
														<td align="right"><input id="cantEntraCin" onfocus="validaFocoInputMonedaGrid(this.id);" onkeypress="return validaSoloNumero(event,this);"
															name="cantEntrada" size="6" type="text" value="0"
															iniForma="false" style="text-align: right" maxlength = "10"/></td>
														<td class="separador"></td>
														<td class="label" align="right"><input
															id="montoEntraCin" name="montoEntrada" size="10"
															type="text" readOnly="true" disabled="true"
															iniForma="false" esMoneda="true"
															style="text-align: right"/></td>
													</tr>
													<tr>
														<td align="right"><input id="denoEntraVeiID"
															name="denomiEntradaID" size="4" type="hidden"
															readOnly="true" iniForma="false" disabled="true"
															style="text-align: right" value="6"/> <input
															id="denoEntraVei" iniForma="false" name="denomiEntrada"
															size="8" type="text" readOnly="true" disabled="true"
															style="text-align: right" value="20"/></td>
														<td class="separador"></td>
														<td align="right"><input id="cantEntraVei" onfocus="validaFocoInputMonedaGrid(this.id);" onkeypress="return validaSoloNumero(event,this);"
															name="cantEntrada" size="6" type="text" value="0"
															iniForma="false" style="text-align: right" maxlength = "10"/></td>
														<td class="separador"></td>
														<td align="right"><input id="montoEntraVei"
															name="montoEntrada" size="10" type="text" readOnly="true"
															iniForma="false" disabled="true" esMoneda="true"
															style="text-align: right"/></td>
													</tr>
													<tr>
														<td align="right"><input id="denoEntraMonID"
															name="denomiEntradaID" size="4" type="hidden"
															readOnly="true" iniForma="false" disabled="true"
															style="text-align: right" value="7"/> <input
															id="denoEntraMon" iniForma="false" name="denomiEntrada"
															size="8" type="text" readOnly="true" disabled="true"
															style="text-align: right" value="Monedas"/></td>
														<td class="separador"></td>
														<td align="right"><input id="cantEntraMon" onfocus="validaFocoInputMonedaGrid(this.id);"
															name="cantEntrada" size="6" type="text" value="0"
															iniForma="false" style="text-align: right" maxlength = "10"/></td>
														<td class="separador"></td>
														<td align="right"><input id="montoEntraMon"
															name="montoEntrada" size="10" type="text" readOnly="true"
															iniForma="false" disabled="true" esMoneda="true"
															style="text-align: right"/></td>
													</tr>
													<tr align="right">
														<td class="separador"></td>
														<td class="separador"></td>
														<td align="right"><label for="lblTotal">Total</label>
														</td>
														<td class="separador"></td>
														<td align="right"><input id="sumTotalEnt"
															name="sumTotalEnt" size="10" type="text" value="0"
															readOnly="true" esMoneda="true"
															iniForma="false" style="text-align: right"/></td>
													</tr>
													<tr>
														<td align="center" colspan="5"><input type="button"
															id="agregarEntEfec" name="agregarEntEfec" class="submit"
															value="Agregar" /></td>
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
															style="text-align: right" value="1"/> <input
															id="denoSalMil" iniForma="false" name="denomiSalida"
															size="8" type="text" readOnly="true" disabled="true"
															style="text-align: right" value="1000"/></td>
														<td class="separador"></td>
														<td align="right"><input id="disponSalMil"
															name="disponSalida" size="7" type="text" value="0"
															iniForma="false" readOnly="true" disabled="true"
															style="text-align: right"/></td>
														<td class="separador"></td>
														<td align="right"><input id="cantSalMil" onfocus="validaFocoInputMonedaGrid(this.id);"  onkeypress="return validaSoloNumero(event,this);"
															name="cantSalida" size="6" type="text" value="0"
															iniForma="false" style="text-align: right" maxlength="10"/></td>
														<td class="separador"></td>
														<td class="label" align="right"><input
															id="montoSalMil" name="montoSalida" size="10" type="text"
															readOnly="true" disabled="true" esMoneda="true"
															iniForma="false" style="text-align: right"/></td>
													</tr>
													<tr>
														<td align="right"><input id="denoSalQuiID"
															iniForma="false" name="denomiSalidaID" size="8"
															type="hidden" readOnly="true" disabled="true"
															style="text-align: right" value="2"/> <input
															id="denoSalQui" iniForma="false" name="denomiSalida"
															size="8" type="text" readOnly="true" disabled="true"
															style="text-align: right" value="500"/></td>
														<td class="separador"></td>
														<td align="right"><input id="disponSalQui"
															name="disponSalida" size="7" type="text" value="0"
															iniForma="false" readOnly="true" disabled="true"
															style="text-align: right"/></td>
														<td class="separador"></td>
														<td align="right"><input id="cantSalQui" onfocus="validaFocoInputMonedaGrid(this.id);"  onkeypress="return validaSoloNumero(event,this);"
															name="cantSalida" size="6" type="text" value="0"
															iniForma="false" style="text-align: right" maxlength="10"/></td>
														<td class="separador"></td>
														<td class="label" align="right"><input
															id="montoSalQui" name="montoSalida" size="10" type="text"
															readOnly="true" disabled="true" esMoneda="true"
															iniForma="false" style="text-align: right"/></td>
													</tr>
													<tr>
														<td align="right"><input id="denoSalDosID"
															iniForma="false" name="denomiSalidaID" size="8"
															type="hidden" readOnly="true" disabled="true"
															style="text-align: right" value="3"/> <input
															id="denoSalDos" iniForma="false" name="denomiSalida"
															size="8" type="text" readOnly="true" disabled="true"
															style="text-align: right" value="200"/></td>
														<td class="separador"></td>
														<td align="right"><input id="disponSalDos"
															name="disponSalida" size="7" type="text" value="0"
															iniForma="false" readOnly="true" disabled="true"
															style="text-align: right"/></td>
														<td class="separador"></td>
														<td align="right"><input id="cantSalDos" onfocus="validaFocoInputMonedaGrid(this.id);"onkeypress="return validaSoloNumero(event,this);"
															name="cantSalida" size="6" type="text" value="0"
															iniForma="false" style="text-align: right" maxlength="10"/></td>
														<td class="separador"></td>
														<td class="label" align="right"><input
															id="montoSalDos" name="montoSalida" size="10" type="text"
															readOnly="true" disabled="true" esMoneda="true"
															iniForma="false" style="text-align: right"/></td>
													</tr>
													<tr>
														<td align="right"><input id="denoSalCienID"
															iniForma="false" name="denomiSalidaID" size="8"
															type="hidden" readOnly="true" disabled="true"
															style="text-align: right" value="4"/> <input
															id="denoSalCien" iniForma="false" name="denomiSalida"
															size="8" type="text" readOnly="true" disabled="true"
															style="text-align: right" value="100"/></td>
														<td class="separador"></td>
														<td align="right"><input id="disponSalCien"
															name="disponSalida" size="7" type="text" value="0"
															iniForma="false" readOnly="true" disabled="true"
															style="text-align: right"/></td>
														<td class="separador"></td>
														<td align="right"><input id="cantSalCien" onfocus="validaFocoInputMonedaGrid(this.id);"  onkeypress="return validaSoloNumero(event,this);"
															name="cantSalida" size="6" type="text" value="0"
															iniForma="false" style="text-align: right" maxlength="10"/></td>
														<td class="separador"></td>
														<td class="label" align="right"><input
															id="montoSalCien" name="montoSalida" size="10"
															type="text" readOnly="true" disabled="true"
															iniForma="false" esMoneda="true"
															style="text-align: right"/></td>
													</tr>
													<tr>
														<td align="right"><input id="denoSalCinID"
															iniForma="false" name="denomiSalidaID" size="8"
															type="hidden" readOnly="true" disabled="true"
															style="text-align: right" value="5"/> <input
															id="denoSalCin" iniForma="false" name="denomiSalida"
															size="8" type="text" readOnly="true" disabled="true"
															style="text-align: right" value="50"/></td>
														<td class="separador"></td>
														<td align="right"><input id="disponSalCin"
															name="disponSalida" size="7" type="text" value="0"
															iniForma="false" readOnly="true" disabled="true"
															style="text-align: right"/></td>
														<td class="separador"></td>
														<td align="right"><input id="cantSalCin" onfocus="validaFocoInputMonedaGrid(this.id);"  onkeypress="return validaSoloNumero(event,this);"
															name="cantSalida" size="6" type="text" value="0"
															iniForma="false" style="text-align: right" maxlength="10"/></td>
														<td class="separador"></td>
														<td class="label" align="right"><input
															id="montoSalCin" name="montoSalida" size="10" type="text"
															readOnly="true" disabled="true" esMoneda="true"
															iniForma="false" style="text-align: right"/></td>
													</tr>
													<tr>
														<td align="right"><input id="denoSalVeiID"
															iniForma="false" name="denomiSalidaID" size="8"
															type="hidden" readOnly="true" disabled="true"
															style="text-align: right" value="6"/> <input
															id="denoSalVei" iniForma="false" name="denomiSalida"
															size="8" type="text" readOnly="true" disabled="true"
															style="text-align: right" value="20"/></td>
														<td class="separador"></td>
														<td align="right"><input id="disponSalVei"
															name="disponSalida" size="7" type="text" value="0"
															iniForma="false" readOnly="true" disabled="true"
															style="text-align: right"/></td>
														<td class="separador"></td>
														<td align="right"><input id="cantSalVei" onfocus="validaFocoInputMonedaGrid(this.id);"  onkeypress="return validaSoloNumero(event,this);"
															name="cantSalida" size="6" type="text" value="0"
															iniForma="false" style="text-align: right" maxlength="10"/></td>
														<td class="separador"></td>
														<td class="label" align="right"><input
															id="montoSalVei" name="montoSalida" size="10" type="text"
															readOnly="true" disabled="true" esMoneda="true"
															iniForma="false" style="text-align: right"/></td>
													</tr>
													<tr>
														<td align="right"><input id="denoSalMonID"
															iniForma="false" name="denomiSalidaID" size="8"
															type="hidden" readOnly="true" disabled="true"
															style="text-align: right" value="7"/> <input
															id="denoSalMon" iniForma="false" name="denomiSalida"
															size="8" type="text" readOnly="true" disabled="true"
															style="text-align: right" value="Monedas"/></td>
														<td class="separador"></td>
														<td align="right"><input id="disponSalMon"
															name="disponSalida" size="7" type="text" value="0"
															iniForma="false" readOnly="true" disabled="true"
															style="text-align: right"/></td>
														<td class="separador"></td>
														<td align="right"><input id="cantSalMon" onfocus="validaFocoInputMonedaGrid(this.id);"
															name="cantSalida" size="6" type="text" value="0"
															iniForma="false" style="text-align: right" maxlength="10"/></td>
														<td class="separador"></td>
														<td class="label" align="right"><input
															id="montoSalMon" name="montoSalida" size="10" type="text"
															readOnly="true" disabled="true" esMoneda="true"
															iniForma="false" style="text-align: right"/></td>
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
															readOnly="true"  esMoneda="true"
															iniForma="false" style="text-align: right"/></td>
													</tr>
													<tr>
														<td align="center" colspan="7"><input type="button"
															id="agregarSalEfec" name="agregarSalEfec" class="submit"
															value="Agregar" /></td>
													</tr>
												</table>
											</fieldset>
										</td>
									</tr>
								</table>
							</div>
						</td>
					</tr>
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
												iniForma="false" value="0"/></td>
										</tr>
										<tr>
											<td class="label"><label for="lblTotalSalidas">Total
													Salidas: </label></td>
											<td align="left" colspan="12"><input id="totalSalidas"
												name="totalSalidas" size="14" type="text" readOnly="true"
												disabled="true" esMoneda="true" style="text-align: right"
												iniForma="false" value="0"/></td>
										</tr>
										<tr>
											<td class="label"><label for="lblDiferencia">Diferencia:
											</label></td>
											<td align="left" colspan="12"><input id="diferencia"
												name="diferencia" size="14" type="text" readOnly="true"
												disabled="true" esMoneda="true" style="text-align: right"
												iniForma="false" value="0"/></td>
										</tr>
										<tr>
											<td class="label"><label for="lblNumImpr">Número
													de Impresiones: </label></td>
											<td align="left" colspan="12"><select id="numCopias"
												name="numCopias" iniForma="false">
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
						<td colspan="3" align="right" id="transVent">
						<input type="submit" id="graba"	name="graba" class="submit" value="Graba Transacción" />
						<span id="statusSrvHuella" style="
														    float: left;
														    margin-top: 3px;
														">o</span>
						</td>

						<td align="right">
							<a id="enlaceCheque" target="_blank">
								<button  type="button" id="impCheque" name="impCheque" class="submit"
									value="Imp. Cheque">Imp. Cheque</button>
							</a>
						</td>
						<td align="right">
							<a id="enlaceResumen" target="_blank">
								<button  type="button" id="imprimirResumen" name="imprimirResumen" class="submit" value="Imp. Resumen">Imp. Resumen</button>
							</a>
						</td>
						<td align="right">
							<a id="enlaceTicket" target="_blank">
								<button  type="button" id="impTicket" name="impTicket" class="submit"
									value="Imp. Ticket">Imp. Ticket</button>
							</a>
							<button  type="button" id="impPoliza" name="impPoliza" class="submit">Imp. Póliza</button>
						</td>
						<td><input type="hidden" id="tipoTransaccion" name="tipoTransaccion" iniForma="false" /></td>
					</tr>
					<tr>
						<td>
							<div id="imagenCte" style="overflow: scroll; width: 950px; height: 500px;display: none;">
								<img id="imgCliente" src="images/user.jpg"  border="0"  />
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
							<input type="hidden" id="listaClientesPagoProfun" name="listaClientesPagoProfun"  />
							<input type="hidden" id="monedaCamEfectivoID" name="monedaCamEfectivoID"  />
							<input type="hidden" id="numeroUsuarios" name="numeroUsuarios" />
							<input type="hidden" id="huellaRequiere" name="huellaRequiere" />
							<input type="hidden" id="requiereHuella" name="requiereHuella" />
							<input type="hidden" id="cajaRequiereHuella" name="cajaRequiereHuella"/>
							<input type="hidden" id="requiereFirmante" name="requiereFirmante"/>
							<input type="hidden" id="afectacionContable" name="afectacionContable"/>
							<input type="hidden" id="idCtePorTarjeta" name="idCtePorTarjeta"/>
							<input type="hidden" id="nomTarjetaHabiente" name="nomTarjetaHabiente"/>
							<input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>"/>
							<input type="hidden" id="usuarioLogueado" name="usuarioLogueado"/>
							<input type="hidden" id="fechProximoPago" name="fechProximoPago"/>
							<input type="hidden" id="fechSistema" name="fechSistema"/>


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
	<div id="cajaListaCte" style="display: none;overflow-y: scroll;height=150px;">
	<div id="elementoListaCte"></div>
</div>
</body>

<div id="mensaje" style="display: none;"></div>
</html>
</html>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/arrendamientoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/arrendaAmortiServicio.js"></script>
		<script type="text/javascript" src="js/arrendamiento/pagareArrendamiento.js"></script>		
	</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="arrendamientosBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend class="ui-widget ui-widget-header ui-corner-all">Pagaré de Arrendamiento</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td>
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td class="label">
										<label for="lblArrendaID">N&uacute;mero: </label>
									</td> 
									<td>
										<input type="text" id="arrendaID" name="arrendaID" size="12" tabindex="1" maxlength="12"/>
										<input type="hidden" id="tipoListaAmorti" name="tipoListaAmorti"/>
									</td>
									<td class="separador">&nbsp;</td>
									<td class="separador">&nbsp;</td>
									<td class="separador">&nbsp;</td>
								</tr>
								
								<tr>
									<td class="label">
										<label for="lblCliente" id="lblCliente"><s:message code="safilocale.cliente"/>: </label>
									</td> 
									<td>
										<input id="clienteID" name="clienteID" type="text" size="12" readOnly="true" disabled="true"/>
										<input id="nombreCliente" name="nombreCliente" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
									</td>
									<td class="separador">&nbsp;</td>
									<td class="separador">&nbsp;</td>
									<td class="separador">&nbsp;</td>
								</tr>
								
								<tr>
									<td class="label">
										<label for="lblProductoArrenda" id="lblProductoArrenda">Producto de Arrendamiento: </label>
									</td>
									<td>
										<input id="productoArrendaID" name="productoArrendaID" type="text" size="12" readOnly="true" disabled="true"/>
										<input id="productoArrenda" name="productoArrenda" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
									</td>
									<td class="separador">&nbsp;</td>
									<td class="separador">&nbsp;</td>
									<td class="separador">&nbsp;</td>
								</tr>
								
								<tr>
									<td class="label">
										<label for="lblEstatus" id="lblEstatus">Estatus: </label>
									</td>
									<td>
										<input id="estatus" name="estatus" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
									</td>	
									<td class="separador">&nbsp;</td>
									<td class="separador">&nbsp;</td>
									<td class="separador">&nbsp;</td>
								</tr>
								
								<tr>
									<td class="label">
										<label for="lblTipoArrenda" id="lblTipoArrenda">Tipo de Arrendamiento: </label>
									</td>
									<td>
										<input id="tipoArrenda" name="tipoArrenda" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
									</td>
									<td class="separador">&nbsp;</td>
									<td class="separador">&nbsp;</td>
									<td class="separador">&nbsp;</td>
								</tr>
							</table>
							<br>
						</td>
					</tr>					
					
					<tr>
						<td>
							<!-- CONDICIONES -->
							<fieldset class="ui-widget ui-widget-content ui-corner-all" id="condiciones">                
								<legend class="ui-widget ui-widget-header ui-corner-all">Condiciones</legend>
								<table border="0" cellpadding="1" cellspacing="0" width="100%">
									<tr>
										<td class="label">
											<label for="lblMonto">Monto de la Factura sin IVA:</label>
										</td> 
										<td>
											<input id="montoArrenda" name="montoArrenda" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right" />
										</td>
										
										<td class="label">
											<label for="lblPorcEnganche">% Enganche:</label>
										</td> 
										<td >
											<input id="porcEnganche" name="porcEnganche" type="text" readOnly="true" disabled="true" size="15" style="text-align: right"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblMontoEnganche">Enganche:</label>
										</td> 
										<td >
											<input id="montoEnganche" name="montoEnganche" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right" />
										</td>
										
										<td class="label">
											<label for="lblSeguroAnual">Seguro Anual:</label>
										</td> 
										<td >
											<input id="seguroArrendaID" name="seguroArrendaID" type="text" readOnly="true" disabled="true" size="30" onBlur="ponerMayusculas(this)"/>
										</td>
									</tr>
							
									<tr>
										<td class="label">
											<label for="lblMontoSeguroAnual">Monto del Seguro Anual:</label>
										</td> 
										<td >
											<input id="montoSeguroAnual" name="montoSeguroAnual" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right"/>
										</td>
										
										<td class="label">
											<label for="lblTipoPagoSeguro">Tipo de Pago del Seguro:</label>
										</td> 
										<td >
											<input id="tipoPagoSeguro" name="tipoPagoSeguro" type="text" readOnly="true" disabled="true" size="15" onBlur="ponerMayusculas(this)"/>
										</td>
									</tr>
							
									<tr>
										<td class="label">
											<label for="lblSeguroVidaAnual">Tipo de Seguro de Vida:</label>
										</td> 
										<td >
											<input id="tipoPagoSeguroVida" name="tipoPagoSeguroVida" type="text" readOnly="true" disabled="true" size="15" onBlur="ponerMayusculas(this)"/>
										</td>
										
										<td class="label">
											<label for="lblmontoSeguroVidaAnual">Monto del Seguro de Vida Anual:</label>
										</td> 
										<td >
											<input id="montoSeguroVidaAnual" name="montoSeguroVidaAnual" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right" />
										</td>
									</tr>
							
									<tr>
										<td class="label">
											<label for="lblMontoFinanciado">Monto a Financiar Total: </label>
										</td> 
										<td >
											<input id="montoFinanciado" name="montoFinanciado" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right"/>
										</td>
										
										<td class="label">
											<label for="lblDiaPagoProd">D&iacute;as de Pago: </label>
										</td> 
										<td >
											<input id="diaPagoProd" name="diaPagoProd" type="text" readOnly="true" disabled="true" size="15" onBlur="ponerMayusculas(this)"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblMontoResidual">Valor Residual: </label>
										</td> 
										<td >
											<input id="montoResidual" name="montoResidual" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right"/>
										</td>
										
										<td class="label">
											<label for="lblFechaApertura">Fecha de Apertura: </label>
										</td> 
										<td >
											<input id="fechaApertura" name="fechaApertura" type="text" readOnly="true" disabled="true" size="15"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblFechaPrimerVen">Primer Vencimiento: </label>
										</td> 
										<td >
											<input id="fechaPrimerVen" name="fechaPrimerVen" type="text" readOnly="true" disabled="true" size="15"/>
										</td>
										
										<td class="label">
											<label for="lblFechaUltimoVen">&Uacute;ltimo Vencimiento: </label>
										</td> 
										<td >
											<input id="fechaUltimoVen" name="fechaUltimoVen" type="text" readOnly="true" disabled="true" size="15"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblFrecuenciaPlazo">Periodicidad: </label>
										</td> 
										<td >
											<input id="frecuenciaPlazo" name="frecuenciaPlazo" type="text" readOnly="true" disabled="true" size="15" onBlur="ponerMayusculas(this)"/>
										</td>
										
										<td class="label">
											<label for="lblPlazo">Plazo: </label>
										</td> 
										<td >
											<input id="plazo" name="plazo" type="text" readOnly="true" disabled="true" size="15"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblTasaFijaAnual">Tasa de Interes Anual: </label>
										</td> 
										<td >
											<input id="tasaFijaAnual" name="tasaFijaAnual" type="text" readOnly="true" disabled="true" size="15" esTasa="true" style="text-align: right"/>
										</td>			
										
										<td class="label">
											<label for="lblMontoCuota">Monto Cuota: </label>
										</td> 
										<td >
											<input id="montoCuota" name="montoCuota" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right" />
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblFechaInhabil">Fecha Inh&aacute;bil: </label>
										</td> 
										<td >
											<input type="radio" id="fechaInhabilS" name="fechaInhabilS" value="S" readOnly="true" disabled="true"/>
											<label for="siguiente">D&iacute;a H&aacute;bil Siguiente</label>&nbsp;
											
											<input type="radio" id="fechaInhabilA" name="fechaInhabilA" value="A" readOnly="true" disabled="true"/>
											<label for="anterior">D&iacute;a H&aacute;bil Anterior</label>
										</td>
									</tr>
								</table>
							</fieldset>
							<br>						
						</td>
					</tr>
					
					<tr>
						<td>
							<!-- Pago Inicial -->
							<fieldset class="ui-widget ui-widget-content ui-corner-all" id="pagoInicial">                
								<legend class="ui-widget ui-widget-header ui-corner-all">Pago Inicial</legend>
								<table border="0" cellpadding="1" cellspacing="0" width="100%">
									<tr>
										<td class="label">
											<label for="lblMontoEnganchePagoI">Enganche: </label>
										</td> 
										<td>
											<input id="montoEnganchePagoI" name="montoEnganchePagoI" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right" />
										</td>
										<td class="label">
											<label for="lblIvaEnganche">IVA del Enganche: </label>
										</td> 
										<td >
											<input id="ivaEnganche" name="ivaEnganche" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblMontoComApe">Monto Comisi&oacute;n de Apertura: </label>
										</td> 
										<td >
											<input id="montoComApe" name="montoComApe" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right" />
										</td>
										<td class="label">
											<label for="lblIvaComApe">IVA Comisi&oacute;n de Apertura: </label>
										</td> 
										<td >
											<input id="ivaComApe" name="ivaComApe" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblCantRentaDepo">N&uacute;mero de Rentas en Dep&oacute;sito: </label>
										</td> 
										<td >
											<input id="cantRentaDepo" name="cantRentaDepo" type="text" readOnly="true" disabled="true" size="15" style="text-align: right" />
										</td>
										<td class="label">
											<label for="lblMontoDeposito">Renta en Dep&oacute;sito: </label>
										</td> 
										<td >
											<input id="montoDeposito" name="montoDeposito" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblIvaDeposito">IVA de la Renta en Dep&oacute;sito: </label>
										</td> 
										<td >
											<input id="ivaDeposito" name="ivaDeposito" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right"/>
										</td>
										<td class="label">
											<label for="lblOtroGastos">Placas y Tenencia: </label>
										</td> 
										<td >
											<input id="otroGastos" name="otroGastos" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblSeguro">Seguro: </label>
										</td> 
										<td >
											<input id="montoSeguro" name="montoSeguro" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right"/>
										</td>
										<td class="label">
											<label for="lblSeguroVida">Seguro de Vida: </label>
										</td> 
										<td >
											<input id="montoSeguroVida" name="montoSeguroVida" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="concRentaAnticipada">Renta anticipada: </label>
										</td> 
										<td >
											<input id="concRentaAnticipada" name="concRentaAnticipada" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right"/>
										</td>
										<td class="label">
											<label for="concIvaRentaAnticipada">IVA Renta anticipada: </label>
										</td> 
										<td >
											<input id="concIvaRentaAnticipada" name="concIvaRentaAnticipada" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="concRentasAdelantadas">Cuotas adelantadas: </label>
										</td> 
										<td >
											<input id="concRentasAdelantadas" name="concRentasAdelantadas" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right"/>
										</td>
										<td class="label">
											<label for="concIvaRentasAdelantadas">IVA Cuotas adelantadas: </label>
										</td> 
										<td >
											<input id="concIvaRentasAdelantadas" name="concIvaRentasAdelantadas" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblTotalPagoInicial">Total Pago Inicial: </label>
										</td> 
										<td>
											<input id="totalPagoInicial" name="totalPagoInicial" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right"/>
										</td>
									</tr>
								</table>
							</fieldset>
							<br>
						</td>
					</tr>
					<tr>
						<!-- Tabla de Amortizaciones-->
						<td>
							<div id="contenedorAmortizaciones" style="display: none;"></div>
						</td>
					</tr>
					<tr>
						<td align="right">
							<div id="contenedorBotonesImp" style="display: none;">
								<input type="submit" id="imprimirPagare" name="imprimirPagare" class="submit" value="Imprimir Pagaré" tabindex="2"/>
								<input type="button" id="imprimirContrato" name="imprimirContrato" class="submit" value="Imprimir Contrato" tabindex="3"/>
								<input type="button" id="imprimirAnexo" name="imprimirAnexo" class="submit" value="Imprimir Anexos" tabindex="4"/>
								<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
							</div>
						</td> 
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;">
	</div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
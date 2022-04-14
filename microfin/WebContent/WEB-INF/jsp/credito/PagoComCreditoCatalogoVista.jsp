<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/amortizacionCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/creditosMovsServicio.js"></script>
<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/esquemaOtrosAccesoriosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/calculosyOperacionesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="js/credito/pagoComCredito.js"></script>
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Pago de Comisiones</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label" width="70px"><label for="fechInhabil">Tipo Cobro: </label></td>
						<td class="separador"></td>
						<td class="label"><input type="radio" id="tipoCobro" name="tipoCobro" path="tipoCobro" value="I" tabindex="75" checked="checked" /><label for="Individual">Individual</label>&nbsp; <input type="radio" id="tipoCobro2" name="tipoCobro" path="tipoCobro" value="M" tabindex="76" /><label for="Masivo">Masivo</label></td>
					</tr>
				</table> <br>
		<%-----------------------------------------------	PAGO DE COMISIONES INDIVIDUAL (CARGO A CUENTA) 	----------------------------------------------%>	
		<tr>
			<td>
				<div id="pagoIndividual">
					<table border="0" cellpadding="0" width="100%">
						<tr>
							<td class="label">
								<label for="creditoID" id="lblCreditoID">Cr&eacute;dito: </label>
							</td>
							<td >
								<form:input id="creditoID" name="creditoID" path="creditoID" size="12"  
									        iniForma = 'false'  tabindex="1" />
							</td>					
							<td class="separador"></td>				
							<td class="label">
								<label for="clienteID" id="lblClienteID"><s:message code="safilocale.cliente"/>: </label>
							</td>
							<td >
								<form:input id="clienteID" name="clienteID" path="clienteID" size="12" 	 type="text" readOnly="true" />
						        <input id="nombreCliente" name="nombreCliente" size="50"  type="text" readOnly="true" />							
							</td>	
						</tr>
						<tr>
							<td class="label">
								<label for="lblPagaIVA" id="lblPagaIVA">Paga IVA: </label>
							</td>
							<td>
								<select id="pagaIVA" name="pagaIVA" path="pagaIVA"  tabindex="2" disabled="true">
									<option value="">--</option>
							     	<option value="S">SI</option>
							     	<option value="N">NO</option>
								</select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="cuentaID" id="lblCuentaID">Cuenta Cargo:</label>
							</td>
							<td >
								<form:input type="text" id="cuentaID" name="cuentaID" size="12"   readOnly="true" path="cuentaID" />
								<input id="nomCuenta" name="nomCuenta"  size="50"  type="text" readOnly="true" />							
							</td>	
						</tr>
						<tr>
							<td class="label">
								<label  for="saldo" id="lblSaldo">Saldo:</label>
							</td>
						   <td >
								<input id="saldoCta" name="saldoCta" size="12" 	  type="text" readOnly="true"  style="text-align: right"/> 
							</td>		
							<td class="separador"></td>
							<td class="label">
								<label for="lbltipoComision" id="lblTipoComision">Tipo Comisi&oacute;n: </label>
							</td>
							<td>
								<select id="tipoComision" name="tipoComision" path="tipoComision"  tabindex="2" >
									<option value="">SELECCIONAR</option>							     	
								</select>
								<input type="hidden" id="accesorioID" name="accesorioID"/>
							</td>	
						</tr>
						<tr>
							<td>
								<form:input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="12" tabindex="39" type="hidden" readOnly="true" disabled="true" /> 
								<input id="descripProducto" name="descripProducto" size="45" tabindex="40" type="hidden" readOnly="true" disabled="true" /></td>
							<td>
								<form:input id="monedaID" name="monedaID" path="monedaID" size="12" tabindex="8" type="hidden" readOnly="true" disabled="true" />
							 	<input id="monedaDes" name="monedaDes" size="12" tabindex="10" type="hidden" readOnly="true" disabled="true" /></td>
							<td id="tdGrupoCicloCredinput" style="display: none;">
								<input id="cicloID" name="cicloID" size="12" tabindex="8" type="hidden" readOnly="true" disabled="true" /></td>
						</tr>
						<tr>			
							<td class="label"> 
								<label for="lblestatus" id="lblEstatus">Estatus:</label>				      	 
							</td> 
							<td> 
								<form:input id="estatus" name="estatus" path="estatus" size="12"  type="text" readOnly="true" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblMonto" id="lblMontoPagar">Monto a Pagar:</label>
							</td> 
						    <td> 
						    	<form:input id="montoPagar" name="montoPagar" path="montoPagar" size="12" 	tabindex="3" type="text" esMoneda="true" style="text-align: right" />
						     </td>
						</tr>
					</table>						
				</div>
				<%-----------------------------------------------	PAGO DE COMISIONES MASIVO (CARGO A CUENTA) 	----------------------------------------------%>	

				<div id="pagoMasivo" style="display: none;">
					<table border="0" cellpadding="0" width="100%">			
						<tr>					   
							<td class="label">
								<label for="lbltipoComision" id="lblTipoComision">Tipo Comisi&oacute;n: </label>
							</td>
							<td class="separador"></td>
							<td>
								<select id="tipoComisionM" name="tipoComisionM" path="tipoComisionM"  tabindex="2" >
									<option value="">SELECCIONAR</option>
							     	<option value="CA">COMISI&Oacute;N POR APERTURA</option>
							     	<option value="FP">COMISI&Oacute;N POR FALTA DE PAGO</option>
							     	<option value="PS">COMISI&Oacute;N SEGURO POR CUOTA</option>
							     	<option value="AN">COMISI&Oacute;N POR ANUALIDAD</option>
							     	<option value="CL">COMISI&Oacute;N ANUAL L&Iacute;NEA CR&Eacute;DITO</option>
								</select>
							</td>	
						</tr>						
					</table>						
				</div>
			</td>
		</tr>

	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all" id = "detalleCredito">                
	<legend >Saldo Cr&eacute;dito</legend>
	<br>
	<div>
		<table>
			<tr>
				<td class="label">
					<label for="adeudoTotal"><b>Total Adeudo:</b></label>
				</td>
				<td>
					<input id="adeudoTotal" name="adeudoTotal" size="15" tabindex="16" type="text" disabled="true" esMoneda="true" style="text-align: right" />
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="pagoExigible"><b>Total Adeudo Comisiones:</b></label></td>
				<td>
					<input id="pagoExigible" name="pagoExigible" size="15" tabindex="17" type="text" disabled="true" esMoneda="true" style="text-align: right" />
				</td>
			</tr>
			<tr class="ocultarSeguros">
				<td class="label"><label>Cobra Seguro Cuota:</label></td>
				<td><form:select name="cobraSeguroCuota" id="cobraSeguroCuota" disabled="true" path="cobraSeguroCuota">
					<option value="N">NO</option>
					<option value="S">SI</option>
				</form:select></td>
			</tr>
		</table>
	<br>
	</div>
	<br>
	<div >
		<table border="0" width="900px">
			<tr>
				<td class="label" colspan="2"><label><b>Capital </b></label>
				<td class="label" colspan="2"><label><b>Inter&eacute;s</b></label>
				<td class="label"><label><b>IVA Inter&eacute;s </b></label></td>
				<td><input type="text" name="saldoIVAInteres" id="saldoIVAInteres" size="8" readonly="true" disabled="true" tabIndex="29" esMoneda="true" style="text-align: right" /></td>
				<td class="label" colspan="2"><label><b>Comisiones</b></label>
				<td class="label" colspan="2"><label><b>IVA Comisiones</b></label>
			</tr>
			<tr>
				<td><label>Vigente: </label></td>
				<td><input id="saldoCapVigent" name="saldoCapVigent" size="8" tabindex="18" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
				<td><label>Ordinario: </label></td>
				<td><input type="text" name="saldoInterOrdin" id="saldoInterOrdin" size="8" readonly="true" disabled="true" tabIndex="23" esMoneda="true" style="text-align: right" /></td>
				<td colspan="2"></td>
				<td><label> Falta Pago: </label></td>
				<td><input type="text" name="saldoComFaltPago" id="saldoComFaltPago" size="8" readonly="true" disabled="true" tabIndex="32" esMoneda="true" style="text-align: right" /></td>
				<td><label> Falta Pago: </label></td>
				<td><input type="text" name="salIVAComFalPag" id="salIVAComFalPag" size="8" readonly="true" disabled="true" tabIndex="35" esMoneda="true" style="text-align: right" /></td>
			</tr>
			<tr>
				<td><label>Atrasado: </label></td>
				<td><input id="saldoCapAtrasad" name="saldoCapAtrasad" size="8" tabindex="19" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
				<td><label>Atrasado: </label></td>
				<td><input type="text" name="saldoInterAtras" id="saldoInterAtras" size="8" readonly="true" disabled="true" tabIndex="24" esMoneda="true" style="text-align: right" /></td>
				<td class="label"><label><b>Moratorio</b></label></td>
				<td><input type="text" name="saldoMoratorios" id="saldoMoratorios" size="8" readonly="true" disabled="true" tabIndex="30" esMoneda="true" style="text-align: right" /></td>
				<td><label>Otras: </label></td>
				<td><input type="text" name="saldoOtrasComis" id="saldoOtrasComis" size="8" readonly="true" disabled="true" tabIndex="33" esMoneda="true" style="text-align: right" /></td>
				<td><label>Otras: </label></td>
				<td><input type="text" name="saldoIVAComisi" id="saldoIVAComisi" size="8" readonly="true" disabled="true" tabIndex="36" esMoneda="true" style="text-align: right" /></td>
			</tr>
			<tr>
				<td><label>Vencido: </label></td>
				<td><input type="text" name="saldoCapVencido" id="saldoCapVencido" size="8" readonly="true" disabled="true" tabIndex="20" esMoneda="true" style="text-align: right" /></td>
				<td><label>Vencido: </label></td>
				<td><input type="text" name="saldoInterVenc" id="saldoInterVenc" size="8" readonly="true" disabled="true" tabIndex="25" esMoneda="true" style="text-align: right" /></td>
				<td class="label"><label><b>IVA Moratorio</b></label></td>
				<td><input type="text" name="saldoIVAMorator" id="saldoIVAMorator" size="8" readonly="true" disabled="true" tabIndex="31" esMoneda="true" style="text-align: right" /></td>
				<td><label>Adm&oacute;n: </label></td>
				<td><input type="text" name="saldoAdmonComis" id="saldoAdmonComis" size="8" readonly="true" disabled="true" tabIndex="33" esMoneda="true" style="text-align: right" /></td>
				<td><label>Adm&oacute;n: </label></td>
				<td><input type="text" name="saldoIVAAdmonComisi" id="saldoIVAAdmonComisi" size="8" readonly="true" disabled="true" tabIndex="36" esMoneda="true" style="text-align: right" /></td>
			</tr>
			<tr>
				<td><label>Vencido no Exigible: </label></td>
				<td><input type="text" name="saldCapVenNoExi" id="saldCapVenNoExi" size="8" readonly="true" disabled="true" tabIndex="21" esMoneda="true" style="text-align: right" /></td>
				<td><label>Provisi&oacute;n:</label></td>
				<td><input type="text" name="saldoInterProvi" id="saldoInterProvi" size="8" readonly="true" disabled="true" tabIndex="26" esMoneda="true" style="text-align: right" /></td>
				<td></td>
				<td></td>
				<td class="label ocultaSeguro"><label>Seguro</label></td>
				<td class="ocultaSeguro"><input type="text" name="saldoSeguroCuota" id="saldoSeguroCuota" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
				<td class="label ocultaSeguro"><label>Seguro</label></td>
				<td class="ocultaSeguro"><input type="text" name="saldoIVASeguroCuota" id="saldoIVASeguroCuota" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
			</tr>
			<tr>
				<td><label><b>Total: </b></label></td>
				<td><input name="totalCapital" id="totalCapital" type="text" size="8" readonly="true" disabled="true" tabIndex="22" esMoneda="true" style="text-align: right" /></td>
				<td><label>Cal.No Cont.: </label></td>
				<td><input type="text" name="saldoIntNoConta" id="saldoIntNoConta" size="8" readonly="true" disabled="true" tabIndex="27" esMoneda="true" style="text-align: right" /></td>
				<td></td>
				<td></td>
				<td class="label"><label>Anual:</label></td>
				<td><input id="saldoComAnual" name="saldoComAnual" type="text" esMoneda="true" size="8"  disabled="true" readonly="true" style="text-align: right"></td>
				<td class="label"><label>Anual:</label></td>
				<td><input id="saldoComAnualIVA" name="saldoComAnualIVA" type="text" esMoneda="true" size="8" disabled="true" readonly="true" style="text-align: right"></td>
			</tr>
			<tr>
				<td class="separador" colspan="2"></td>
				<td><label><b>Total: </b></label></td>
				<td><input type="text" name="totalInteres" id="totalInteres" size="8" readonly="true" disabled="true" tabIndex="28" esMoneda="true" style="text-align: right" /></td>
				<td></td>
				<td></td>
				<td><label><b>Total: </b></label></td>
				<td><input type="text" name="totalComisi" id="totalComisi" size="8" readonly="true" disabled="true" tabIndex="34" esMoneda="true" style="text-align: right" /></td>
				<td><label><b>Total: </b></label></td>
				<td><input type="text" name="totalIVACom" id="totalIVACom" size="8" readonly="true" disabled="true" tabIndex="37" esMoneda="true" style="text-align: right" /></td>
			</tr>
		</table>
	</div>
	</fieldset>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all" id="comisionesAnticipadas">                
	<legend >Comisiones Anticipadas</legend>
		<table border="0" width="900px">
			<tr>
				<td class="label">
					<label for="montoComApertura">Comisi&oacute;n por Apertura: </label>
				</td>
				<td >
					<form:input id="montoComApertura" name="montoComApertura" path="montoComApertura" size="12" tabindex="38" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right"/>
				</td>					
				<td class="separador"></td>				
				<td class="label">
					<label for="IVAComisionApert">IVA Com Apertura: </label>
				</td>
				<td >	
				<form:input id="IVAComisionApert" name="IVAComisionApert" path="IVAComisionApert" size="12" tabindex="38" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right"/>				
		         								
				</td>	
			</tr>
			<tr>
				<td class="label">
					<label for="otrasComAnt">Otras Com. Ant.: </label>
				</td>
				<td >
					<input id="otrasComAnt" name="otrasComAnt" size="12" path="otrasComAnt" tabindex="41" type="text" readOnly="true" disabled="true" esMoneda="true"  style="text-align: right"/>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label  for="otrasComAntIVA">IVA Otras Com. Ant.: </label>
				</td>
				<td >
					<input id="otrasComAntIVA" name="otrasComAntIVA" size="12" path="otrasComAntIVA" tabindex="42" type="text" readOnly="true" disabled="true" esMoneda="true"  style="text-align: right"/>					 	
				</td>
			</tr>			
		</table>
		<input id="fechaSistema" name="fechaSistema"  size="12"  tabindex="45" type="hidden"/>
	</fieldset>
	
	<fieldset class="ui-widget ui-widget-content ui-corner-all" id="comisionAnualLinea">
		<legend>Comisiones L&iacute;nea de Cr&eacute;dito</legend>
		<table border="0" width="900px">
			<tr>
				<td class="label"><label for="lblcomAnualLin">Comisi&oacute;n Anual: </label></td>
				<td><input type="text" name="comAnualLin" id="comAnualLin" size="12" esMoneda="true" readonly="true" disabled="true" style="text-align: right;" /></td>
				<td class="separador"></td>
				<td class="label"><label for="lblIVAComAnualLin">IVA Com. Anual: </label></td>
				<td><input type="text" name="IVAComAnualLin" id="IVAComAnualLin" size="12" esMoneda="true" readonly="true" disabled="true" style="text-align: right;" /></td>
			</tr>
		</table>
	</fieldset>

	<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
		<tr>
			<td align="right">
				<input type="button" id="amortiza" name="amortiza" class="submit" tabIndex = "46" value="Consultar Amortizaciones" />
				<input type="button" id="movimientos" name="movimientos" class="submit" value="Consultar Movimientos" tabIndex = "47" />
				<input type="submit" id="pagar" name="pagar" class="submit"	 value="Pagar" tabIndex = "48" />											 
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<a id="enlaceTicket" target="_blank"> 
					<button  type="button" id="impTicket" name="impTicket" class="submit" value="Imp. Ticket">Imprimir</button>	
				</a>
			</td>
			
		</tr>
	</table>
	<input id="numeroTransaccion" name="numeroTransaccion"  size="12" type="hidden" readOnly="true" disabled="true"/>	
	<input id="exigibleDiaPago" name="exigibleDiaPago"  size="12" type="hidden" readOnly="true" disabled="true"/>	
</fieldset>
<input type="hidden" id="listaGridCreditos" name="listaGridCreditos" size="100" />
	<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldsetLisCred" style="display: none;" >
	<table align="right">
		<tr>
			<div id="divListaCreditos" style="display: none;" ></div>		
		</tr>
	</table>												
	</fieldset>
</form:form>
</div>

<div id="gridAmortizacion"></div>
<div id="gridMovimientos"></div>

<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
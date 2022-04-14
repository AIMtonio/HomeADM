<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>  
	<script type="text/javascript" src="dwr/interface/lineaFonServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/creditoFondeoServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/divisasServicio.js"></script>
	<script type="text/javascript" src="js/fondeador/pagoCreditoFondeoVista.js"></script>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="post" commandName="creditoFondeoBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Pago Cr&eacute;dito Pasivo</legend>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label">
				<label for="institucionFondeo">Instituci&oacute;n : </label>
			</td> 
			<td nowrap="nowrap">
				<input type="text" id="institutFondID" name="institutFondID"  size="15" tabindex="1" iniForma="false" />
				<input type="text" id="nombreInstitFondeo" name="nombreInstitFondeo" tabindex="2" size="30" readonly="true" disabled="true" iniForma="false" /> 	 	
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="lbllineaFondeo">L&iacute;nea Fondeo: </label>
			</td> 
			<td nowrap="nowrap">
				<input id="lineaFondeoID" name="lineaFondeoID"  size="15" tabindex="3"  iniForma="false" />
		        <textarea id="descripLinea" name="descripLinea" rows="2" cols="45" tabindex="4" 
	        		onblur="ponerMayusculas(this)" readonly="true" disabled="true"></textarea>
			</td>
		</tr>
		<tr>
			<td class="label" nowrap="nowrap">
				<label for="lblBanco">Banco:</label> 
			</td>
			<td nowrap="nowrap" >
		 		<form:input type="text" id="institucionID" name="institucionID" path="institucionID" size="15" tabindex="5"/>
		 		<input type="text" id="descripcionInstitucion" name="descripcionInstitucion"  size="35" tabindex="6" disabled="disabled"/>
			</td>
			<td class="separador"></td>	
			<td class="label" nowrap="nowrap">
				<label for="lblBanco">N&uacute;mero de Cuenta Bancaria:</label> 
			</td>
			<td nowrap="nowrap" >
		 		<form:input type="text" id="numCtaInstit" name="numCtaInstit" path="numCtaInstit" size="20" tabindex="7" maxlength="20"/>
			</td>	
		</tr>
		<tr>		
			<td class="label" nowrap="nowrap">
				<label for="lblCtaClabe">Cuenta Clabe: </label> 
			</td>
	   		<td nowrap="nowrap">
	   			<form:input type="text" id="cuentaClabe" name="cuentaClabe" path="cuentaClabe" onkeypress="return IsNumber(event)" size="24" 
	   				disabled="true" readonly="true" tabindex="8" maxlength="18"/>	
			</td>
			<td class="separador"></td>	
			<td class="label" nowrap="nowrap">
				<label for="lblCreditoFond">Cr&eacute;dito Fondeo: </label>
			</td> 
			<td>	
				<input id="creditoFondeoID" name="creditoFondeoID" size="15" tabindex="9"  />
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="lblpagaIVA">Paga IVA:</label>
			</td>
			<td>
				<input id="pagaIVA" name="pagaIVA" size="15" type="text" tabindex="10" readonly="true" disabled="true" />
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="lblcobraISR">Paga ISR:</label>
			</td>
			<td>
				<input id="cobraISR" name="cobraISR" size="15" type="text" tabindex="10" readonly="true" disabled="true" />
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="lblmonedacr">Moneda:</label>
			</td>
			<td  nowrap="nowrap">
				<input id="monedaID" name="monedaID" size="15" tabindex="12" type="text" readonly="true" disabled="true" />
				<input id="monedaDes" name="monedaDes" size="30" iniForma="false" tabindex="13" type="text" readonly="true" disabled="true" />
			</td>
			<td class="separador"></td>
			
            <td class="label">
				<label for="lblestatus">Estatus:</label>
			</td>
			<td>
				<input id="estatus" name="estatus" size="15" tabindex="11" type="text" readonly="true" disabled="true" />
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="lblpagosParciales">Pagos Parciales: </label>
			</td> 
			<td >  
				<form:select id="pagosParciales" name="pagosParciales" path="pagosParciales" tabindex="12" >
				<form:option value="S">SI</form:option>
				<form:option value="N">NO</form:option>
				</form:select> 
			</td>			
	    	<td class="separador"></td>	
			<td class="label">
				<label for="lblMonto">Monto a Pagar :</label>
			</td> 
		    <td> 
		    	<form:input type="text" id="montoPagar" name="montoPagar" path="montoPagar" size="15" 
	         			tabindex="13"  esMoneda="true" style="text-align: right" />
		    </td>
		</tr>
		<tr id = "creditoActivo" style="display: none;">
			<td class="label">
				<label for="creditoID">Pago Cr&eacute;dito Activo:</label>
			</td>
			<td  nowrap="nowrap">
				<form:input id="creditoID" name="creditoID" path="creditoID" size="12" tabindex="14"  />
			</td>
			<td class="separador"></td>
				<td class="label"><label for="clienteID"><s:message code="safilocale.cliente" />: </label></td>
				<td nowrap="nowrap">
					<form:input id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="2" type="text" readOnly="true" disabled="true" />
					<input id="nombreCliente" name="nombreCliente" size="30" tabindex="3" type="text" readOnly="true" disabled="true" />
				</td>	
		</tr>
		
	</table>
	</fieldset>
	<br>
	<fieldset id="tiposDivisa" class="ui-widget ui-widget-content ui-corner-all">
	<legend>Tipo de Cambio</legend>
		<table>
			<tr>  
				<td class="label" style="width: 50px"> 
					<label for="tipCamFixCom">Compra:</label> 
				</td>
				<td >
					<form:input id="tipCamFixCom" name="tipCamFixCom" path="tipCamFixCom" size="15" tabindex="13" maxlength="18" seisDecimales="true" disabled="true" style="text-align: right"/>
				</td> 
				<td class="separador"></td>
				<td class="label"> 
					<label for="tipCamFixVen">Venta:</label> 
				</td>
				<td >
					<form:input id="tipCamFixVen" name="tipCamFixVen" path="tipCamFixVen" size="15" tabindex="14" maxlength="18" seisDecimales="true" disabled="true" style="text-align: right"/>
				</td>
				<td class="separador"></td>
				<td class="label"> 
					<label for="tipCamFixVen">Monto pago MNX:</label> 
				</td>
				<td >
					<input type="hidden" id="tipCambioDof" name="tipCambioDof" tabindex="16" iniForma="false"/>
					<form:input id="montoPagoMNX" name="montoPagoMNX" path="montoPagoMNX" size="15" tabindex="14" maxlength="18" esmoneda="true" disabled="true"  style="text-align: right"/>
				</td>	           	
			</tr>									
		</table>
	</fieldset>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Saldo Cr&eacute;dito</legend>
		<table border="0">
			<tr>
				<td class="label" nowrap="nowrap"><label for="lbltippago">Tipo Pago:</label></td>
				<td class="label" nowrap="nowrap">
					<input type="radio" id="totalAde" name="totalAde" value="T" tabindex="15" checked="checked" />
					<label for="totalAde"  class="label">Total Adeudo</label>
					<input type="hidden" id="finiquito" name="finiquito" value="S" tabindex="16" iniForma="false"/>
				</td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<input type="radio" id="exigible" name="exigible" value="E" tabindex="17" />
					<label for="exigible">Pago Cuota</label>
				</td>
				<td class="label" id="tdPrepagoCredito">
					<input type="radio" id="prepagoCredito" name="prepagoCredito" value="P" tabindex="18" />
					<label for="prepagoCredito">Prepago</label></td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<div id="divTipoPrepago">
						<label for="tipoPrepago">Tipo Prepago Capital: </label>
					</div>
				</td>
				<td colspan="11">
					<div id="divTipoPrepago1">
						<form:select id="tipoPrepago" name="tipoPrepago" path="" tabindex="18">
							<form:option value="I">Cuotas Siguientes Inmediatas</form:option>
						</form:select>
					</div>
				</td>
			</tr>
			<tr>
				<td class="label" nowrap="nowrap"><label for="lblTotalAd"><b>Total Adeudo :</b></label></td>
				<td ><input id="adeudoTotal" name="adeudoTotal" size="15" tabindex="19" type="text" readonly="true"
							disabled="true" esMoneda="true" style="text-align: right" /></td>
				<td class="separador"></td>			
				<td class="label" nowrap="nowrap"><label for="lblTotalExi"><b>Total Exigible:</b></label></td>
				<td colspan="13"><input id="pagoExigible" name="pagoExigible" size="15" tabindex="18" type="text" readonly="true"
							disabled="true" esMoneda="true" style="text-align: right" /></td>
				
			</tr>
			<tr>
				<td colspan="17"><br></td>
			</tr>
			<tr>
				<td class="label" colspan="2" nowrap="nowrap"><label><b>Capital </b></label></td>	
				<td class="separador"></td>
				<td class="label" colspan="2" nowrap="nowrap"><label><b>Inter&eacute;s</b></label>	
				<td class="separador"></td>
				<td class="label" nowrap="nowrap"><label><b>IVA Inter&eacute;s </b></label></td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap"><label><b>Moratorio</b></label></td>
				<td class="separador"></td>
				<td class="label" colspan="2" nowrap="nowrap"><label><b>Comisiones</b></label>
				<td class="separador"></td>
				<td class="label" colspan="2" nowrap="nowrap"><label><b>IVA Comisiones</b></label>
			</tr>
			<tr>
				<td><label>Vigente: </label></td>
				<td><input id="saldoCapVigent" name="saldoCapVigent" size="15" tabindex="20" type="text" readonly="true"
					disabled="true" esMoneda="true" style="text-align: right" /></td>
				<td class="separador"></td>
				<td><label>Ordinario: </label></td>	
				<td><input type="text" name="saldoInterOrdin" id="saldoInterOrdin" size="15" readonly="true" disabled="true" tabIndex="23"
					esMoneda="true" style="text-align: right" /></td>
				<td class="separador"></td>
				<td><input type="text" name="saldoIVAInteres" id="saldoIVAInteres" size="15" readonly="true" disabled="true" tabIndex="26"
					esMoneda="true" style="text-align: right" /></td>
				<td class="separador"></td>
				<td><input type="text" name="saldoMoratorios" id="saldoMoratorios" size="15" readonly="true" disabled="true" tabIndex="27"
					esMoneda="true" style="text-align: right" /></td>
				<td class="separador"></td>
				<td nowrap="nowrap"><label> Falta Pago: </label></td>
				<td><input type="text" name="saldoComFaltPago" id="saldoComFaltPago" size="15" readonly="true"
					disabled="true" tabIndex="29" esMoneda="true" style="text-align: right" /></td>
				<td class="separador"></td>	
				<td nowrap="nowrap"><label>Falta Pago: </label></td>
				<td><input type="text" name="salIVAComFalPag" id="salIVAComFalPag" size="15" readonly="true" disabled="true" tabIndex="32"
					esMoneda="true" style="text-align: right" /></td>
			</tr>
			<tr>
				<td><label>Atrasado: </label></td>	
				<td><input id="saldoCapAtrasad" name="saldoCapAtrasad" size="15" tabindex="21" type="text" readonly="true"
					disabled="true" esMoneda="true" style="text-align: right" /></td>	
				<td class="separador"></td>
				<td><label>Atrasado: </label></td>	
				<td><input type="text" name="saldoInterAtras" id="saldoInterAtras" size="15" readonly="true" disabled="true" tabIndex="24"
					esMoneda="true" style="text-align: right" /></td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap"><label><b>Retención: </b></label></td>	
				<td class="separador"></td>
				<td class="label" nowrap="nowrap"><label><b>IVA Moratorio</b></label></td>
				<td class="separador"></td>
				<td><label>Otras: </label></td>
				<td><input type="text" name="saldoOtrasComis" id="saldoOtrasComis" size="15" readonly="true" disabled="true" tabIndex="30"
					esMoneda="true" style="text-align: right" /></td>
				<td class="separador"></td>	
				<td><label>Otras: </label></td>		
				<td><input type="text" name="saldoIVAComisi" id="saldoIVAComisi" size="15" readonly="true" disabled="true" tabIndex="33"
					esMoneda="true" style="text-align: right" /></td>		
			</tr>
			<tr>
				<td><label><b>Total: </b></label></td>	
				<td><input name="totalCapital" id="totalCapital" type="text" size="15" readonly="true" disabled="true"
					tabIndex="22" esMoneda="true" style="text-align: right" /></td>	
				<td class="separador"></td>
				<td><label><b>Total: </b></label></td>	
				<td><input type="text" name="totalInteres" id="totalInteres" size="15" readonly="true" disabled="true" tabIndex="25"
					esMoneda="true" style="text-align: right" /></td>	
				<td class="separador"></td>
				<td class="separador"><input type="text" name="saldoRetencion" id="saldoRetencion" size="15" readonly="true" disabled="true" tabIndex="30"
					esMoneda="true" style="text-align: right" /></td>
				<td class="separador"></td>
				<td><input type="text" name="saldoIVAMorator" id="saldoIVAMorator" size="15" readonly="true" disabled="true" tabIndex="28"
					esMoneda="true" style="text-align: right" /></td>
				<td class="separador"></td>	
				<td><label><b>Total: </b></label></td>		
				<td><input type="text" name="totalComisi" id="totalComisi" size="15" readonly="true" disabled="true" tabIndex="31"
					esMoneda="true" style="text-align: right" /></td>
				<td class="separador"></td>		
				<td><label><b>Total: </b></label></td>
				<td><input type="text" name="totalIVACom" id="totalIVACom" size="15" readonly="true" disabled="true" tabIndex="34"
					esMoneda="true" style="text-align: right" /></td>
			</tr>
	</table>
	</fieldset>
	<br>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td align="right">
				<button id=amortiza name="amortiza" class="submit" tabindex="35" type="button">Consultar Amortizaciones</button>
				<button id=movimientos name="movimientos" class="submit" tabindex="36" type="button">Consultar Movimientos</button>
				<input type="submit" id="pagar" name="pagar" class="submit" value="Pagar" tabindex="37"/>
				<a id="enlace" href="poliza.htm" target="_blank">
                	<button type="button" class="submit" id="impPoliza" style="display:none">Ver P&oacute;liza</button>
                </a>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" iniForma="false" />
				<input type="hidden" id="folioPagoActivo" name="folioPagoActivo" iniForma="false" />
				
			</td>
		</tr>
	</table>
</fieldset>
</form:form>
</div>

<div id="gridAmortiCredFonMovs" style="overflow: scroll; width: 1000px; height: 300px;display: none;"></div>
<div align="right">
	<button id="exportarExcel" name="exportarExcel" class="submit" tabindex="38" type="button">Exportar Excel</button>
</div>

<div id="cargando" style="display: none;"></div>

<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
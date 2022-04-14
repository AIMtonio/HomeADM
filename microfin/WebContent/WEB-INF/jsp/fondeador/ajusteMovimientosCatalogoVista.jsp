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
	<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/creQuitasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/creLimiteQuitasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/puestosServicio.js"></script>
	
	<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>  
	<script type="text/javascript" src="dwr/interface/lineaFonServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/ajusteMovsServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/creditoFondeoServicio.js"></script>
	
	<script type="text/javascript" src="js/fondeador/ajusteMovimientosVista.js"></script>

<body>

<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="ajusteMovimientosBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Movimientos Cr&eacute;dito Fondeo</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="90%">
			<tr>
				<td class="label">
					<label for="institucionFondeo">Instituci&oacute;n : </label>
				</td> 
			   	<td nowrap="nowrap">
					<input id="institutFondID" name="institutFondID"  size="7" tabindex="1"/>
				 	<input type="text" id="nombreInstitFondeo" name="nombreInstitFondeo" tabindex="2" size="30" readOnly="true" disabled="true" /> 	 	
				</td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<label for="lbllineaFondeo">L&iacute;nea Fondeo: </label>
				</td> 
				<td nowrap="nowrap">
					<input id="lineaFondeoID" name="lineaFondeoID"  size="7" tabindex="3"  />
			        <textarea id="descripLinea" name="descripLinea" rows="2" cols="45" tabindex="4" 
		        		onblur="ponerMayusculas(this)" readOnly="true" disabled="true"></textarea>
				</td>
			</tr>
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="lblCreditoFond">Cr&eacute;dito Fondeo: </label>
				</td> 
				<td>
					<input id="creditoFondeoID" name="creditoFondeoID" size="15" tabindex="10"  />
				</td>
				<td class="separador"></td>
	            <td class="label">
					<label for="lblpagaIVA">Paga IVA:</label>
				</td>
				<td>
					<input id="pagaIVA" name="pagaIVA" size="12" type="text" tabindex="6" readOnly="true" disabled="true" />
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="lblestatus">Estatus:</label>
				</td>
				<td>
					<input id="estatus" name="estatus" size="12" tabindex="11" type="text" readOnly="true" disabled="true" />
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="lblmonedacr">Moneda:</label>
				</td>
				<td  nowrap="nowrap">
					<input id="monedaID" name="monedaID" size="12" tabindex="8" type="text" readOnly="true" disabled="true" />
					<input id="monedaDes" name="monedaDes" size="30" iniForma="false" tabindex="10" type="text" readOnly="true" disabled="true" />
				</td>
			</tr>
		</table>
		<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Saldo Cr&eacute;dito</legend>
			<table border="0">
				<tr>
					<td class="label" nowrap="nowrap"><label for="lblTotalExi"><b>Total Exigible:</b></label></td>
					<td><input id="pagoExigible" name="pagoExigible" size="15" tabindex="18" type="text" readonly="true"
								disabled="true" esMoneda="true" style="text-align: right" /></td>
					<td class="separador"></td>
					<td class="label" nowrap="nowrap"><label for="lblTotalAd"><b>Total Adeudo :</b></label></td>
					<td colspan="13"><input id="adeudoTotal" name="adeudoTotal" size="15" tabindex="19" type="text" readonly="true"
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
					<td class="label" nowrap="nowrap"><label><b>IVA Moratorio</b></label></td>
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
					<td><input type="text" name="saldoIVAMorator" id="saldoIVAMorator" size="15" readonly="true" disabled="true" tabIndex="28"
						esMoneda="true" style="text-align: right" /></td>
					<td class="separador"></td>	
					<td  nowrap="nowrap"><label> Falta Pago: </label></td>
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
					<td class="separador"></td>	
					<td class="separador"></td>
					<td class="separador"></td>	
					<td class="separador"></td>
					<td class="separador"></td>	
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
					<td class="separador"></td>
					<td class="separador"></td>
					<td class="separador"></td>	
					<td class="separador"></td>
					<td class="separador"></td>	
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
		<div>
			<table border="0" cellpadding="0" cellspacing="0" width="75%">
			<tr>
			<td  colspan="8">
			<div id="gridAmortiCredFonMovs" style="overflow: scroll; width: 1000px; height: 100%;display: none;"></div>
			</td>
				</tr>
				<tr>
				<td>
				</td>
				</tr>	
			</table>		
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td align="right">
					<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="19"/>
					<input type="hidden" id="detalleAjuste" name="detalleAjuste" iniForma="false" />
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" iniForma="false" />
					<input type="hidden" id="usuarioID" name="usuarioID" iniForma="false" />
				</td>
			</tr>
		</table>
		</div>	
	</fieldset>
	</form:form>
</div>

<div id="cargando" style="display: none;"></div>

<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
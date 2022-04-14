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

<script type="text/javascript" src="js/credito/creQuitasVista.js"></script>

<body>

<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creQuitas">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Quitas y Condonaciones</legend>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<table border="0" cellpadding="0" cellspacing="0" width="90%">
			<tr>
				<td class="label" colspan="2"><label for="lblcreditoID">Cr&eacute;dito:</label></td>
				<td colspan="2"><input id="creditoID" name="creditoID" size="12" iniForma="false" type="text" tabindex="1" maxlength="12" /></td>
				<td class="separador"></td>
				<td class="label"><label for="lblclienteID"><s:message code="safilocale.cliente"/>:</label></td>
				<td><input id="clienteID" name="clienteID" size="12" tabindex="2" type="text" readOnly="true" disabled="disabled"/></td>
				<td colspan="3"><input id="nombreCliente" name="nombreCliente" size="35" tabindex="3" type="text" readOnly="true" disabled="disabled" /></td>
				
			</tr>
			<tr>
				<td class="label" colspan="2"><label for="lblPagaIVA">Paga IVA:</label></td>
				<td colspan="2"><input id="pagaIVA" name="pagaIVA" size="12" tabindex="4" type="text" readOnly="true" disabled="disabled" /></td>
				<td class="separador"></td>
				<td class="label"><label for="lblcuentaIDcre">Cuenta:</label></td>
				<td><input type="text" id="cuentaID" name="cuentaID" readOnly="true" size="12" tabindex="5" type="text" disabled="disabled" /></td> 
				<td colspan="3"><input id="nomCuenta" name="nomCuenta" size="35" tabindex="6" type="text" readOnly="true" disabled="disabled" /></td>
			</tr>
			<tr>
				<td class="label" colspan="2"><label for="lblsaldocta1">Saldo:</label></td>
				<td colspan="2"><input id="saldoCta" name="saldoCta" size="12" tabindex="7" type="text" readOnly="true" style="text-align: right" disabled="disabled" /></td>
				<td class="separador"></td>
				<td class="label"><label for="lblmonedacr">Moneda:</label></td>
				<td><input id="monedaID" name="monedaID" size="12" tabindex="8" type="text" readOnly="true" disabled="disabled" /></td>
				<td colspan="3"><input id="monedaDes" name="monedaDes" size="35" tabindex="10" type="text" readOnly="true" disabled="disabled" /></td>
			</tr>
			<tr>
				<td class="label" colspan="2"><label for="lblestatus">Estatus:</label></td>
				<td colspan="2"><input id="estatus" name="estatus" size="12" tabindex="11" type="text" readOnly="true" disabled="disabled" /></td>
				<td class="separador"></td>
				<td class="label"><label for="lbldiasFaltaPago">D&iacute;as Falta Pago:</label></td>
				<td colspan="4"><input id="diasFaltaPago" name="diasFaltaPago" size="12" tabindex="13" type="text" readOnly="true" disabled="disabled" /></td>
			</tr>
			<tr>
				<td class="label" colspan="2"><label for="lblProducCre">Producto Cr&eacute;dito:</label></td>
				<td><input id="producCreditoID" name="producCreditoID" size="12" tabindex="4" type="text" readOnly="true" disabled="disabled" /></td>
				<td><input id="productoCredDes" name="productoCredDes" size="30" tabindex="10" type="text" readOnly="true"  disabled="disabled" /></td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap"><label for="lblnoquitas">No. Quitas Previas:</label></td>
				<td colspan="4"><input id="noQuitasPrevias" name="noQuitasPrevias" size="12" tabindex="14" type="text" readOnly="true" disabled="disabled" /></td> 
			</tr>
			<tr>
				<td class="label" id="tdGrupoCicloCredlabel" style="display: none;" colspan="2"><label for="lblciclo">Ciclo: </label></td>
				<td id="tdGrupoCicloCredinput" style="display: none;" colspan="2"><input id="cicloID" name="cicloID" size="12" tabindex="8" type="text" readOnly="true" disabled="disabled" /></td>
				<td class="separador"></td>
				<td class="label" id="tdGrupoGrupoCredlabel" style="display: none;"><label for="lblgrupo">Grupo:</label></td>
				<td id="tdGrupoGrupoCredinput" style="display: none;"><input id="grupoID" name="grupoID" size="12"  tabindex="8" type="text" readOnly="true" disabled="disabled"  /></td>
				<td id="tdGrupoGrupoCredDesinput" style="display: none;" colspan="3"><input id="grupoDes" name="grupoDes" size="30" tabindex="10" type="text" readOnly="true"  disabled="disabled" /></td>
			</tr>
			<tr>
				<td class="label" colspan="2"><label for="lblSucursal">Sucursal Cr&eacute;dito:</label></td>
				<td><input id="sucursal" name="sucursal" size="12" tabindex="4" type="text" readOnly="true" disabled="disabled"  /></td>
				<td><input id="nombreSucursal" name="nombreSucursal" size="30" tabindex="10" type="text" readOnly="true" disabled="disabled" /></td>
				<td class="separador"></td>
				<td class="separador"></td>
				<td class="separador"></td>
				<td class="separador"></td>
				<td class="separador"></td> 
			</tr>
			<tr>
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
		<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Saldo Cr&eacute;dito</legend>
		<br>
		<div>
			<table>
				<tr>
					<td class="label" nowrap="nowrap"><label for="lblTotalExi"><b>Total Exigible:</b></label></td>
					<td><input id="pagoExigible" name="pagoExigible" size="15" tabindex="17" type="text" readOnly="true" esMoneda="true" style="text-align: right" disabled="true" /></td>
					<td class="separador"></td>
					<td class="label" nowrap="nowrap"><label for="lblAdeudoTotal"><b>Total Adeudo:</b></label></td>
					<td><input id="adeudoTotal" name="adeudoTotal" size="15" tabindex="17" type="text" readOnly="true" esMoneda="true" style="text-align: right" disabled="true" /></td>
				</tr>
				<tr>
					<td class="label" id="tdLabelExiGrup" style="display: none;"><label for="lblTotalExGrup"><b>Total Exigible Grupal:</b></label></td>
					<td id="tdInputExiGrup" style="display: none;"><input id="montoTotExigible" name="montoTotExigible" size="15" tabindex="17" type="text" readOnly="true" esMoneda="true" style="text-align: right" disabled="true"/></td>
					<td class="separador"></td>
				</tr>
			</table>
		</div> 
		<br>
		<div style="float: left;">
			<table>
				<tr>
					<td class="label"><label><b>Capital </b></label>
				</tr>
				<tr>
					<td><label>Vigente: </label></td>
					<td><input id="saldoCapVigent" name="saldoCapVigent" size="8" tabindex="18" type="text" readOnly="true" esMoneda="true" style="text-align: right" disabled="true" /></td>
				</tr>
				<tr>
					<td><label>Atrasado: </label></td>
					<td><input id="saldoCapAtrasad" name="saldoCapAtrasad" size="8" tabindex="19" type="text" readOnly="true" esMoneda="true" style="text-align: right" disabled="true" /></td>
				</tr>
				<tr>
					<td><label>Vencido: </label></td>
					<td><input name="saldoCapVencido" id="saldoCapVencido" size="8" readonly="true" tabIndex="20" esMoneda="true" style="text-align: right" disabled="true" /></td>
				</tr>
				<tr>
					<td><label>Vencido no Exigible: </label></td>
					<td><input name="saldCapVenNoExi" id="saldCapVenNoExi" size="8" readonly="true" tabIndex="21" esMoneda="true" style="text-align: right" disabled="true" /></td>
				</tr>
				<tr>
					<td><label><b>Total: </b></label></td>
					<td><input name="totalCapital" id="totalCapital" type="text" size="8" readonly="true" disabled="true" tabIndex="22" esMoneda="true" style="text-align: right" disabled="true" /></td>
				</tr>
			</table>
		</div>
		<div style="float: left; padding-left: 10px;">
			<table>
				<tr>
					<td class="label"><label><b>Inter&eacute;s</b></label>
				</tr>
				<tr>
					<td><label>Ordinario: </label></td>
					<td><input name="saldoInterOrdin" id="saldoInterOrdin" size="8" readonly="true" tabIndex="23" esMoneda="true" style="text-align: right" disabled="true" /></td>
				</tr>
				<tr>
					<td><label>Atrasado: </label></td>
					<td><input name="saldoInterAtras" id="saldoInterAtras" size="8" readonly="true" tabIndex="24" esMoneda="true" style="text-align: right" disabled="true" /></td>
				</tr>
				<tr>
					<td><label>Vencido: </label></td>
					<td><input name="saldoInterVenc" id="saldoInterVenc" size="8" readonly="true" tabIndex="25" esMoneda="true" style="text-align: right" disabled="true" /></td>
				</tr>
				<tr>
					<td><label>Provisi&oacute;n:</label></td>
					<td><input name="saldoInterProvi" id="saldoInterProvi" size="8" readonly="true" tabIndex="26" esMoneda="true" style="text-align: right" disabled="true" /></td>
				</tr>
				<tr>
					<td><label>Cal.No Cont.: </label></td>
					<td><input name="saldoIntNoConta" id="saldoIntNoConta" size="8" readonly="true" tabIndex="27" esMoneda="true" style="text-align: right" disabled="true" /></td>
				</tr>
				<tr>
					<td><label><b>Total: </b></label></td>
					<td><input name="totalInteres" id="totalInteres" size="8" readonly="true" tabIndex="28" esMoneda="true" style="text-align: right" disabled="true" /></td>
				</tr>
			</table>
		</div>
		<div style="float: left; padding-left: 10px;">
			<table>
				<tr>
					<td class="label"><label><b>IVA Inter&eacute;s </b></label></td>
				</tr>
				<tr>
					<td><input name="saldoIVAInteres" id="saldoIVAInteres" size="15" readonly="true" tabIndex="29" esMoneda="true" style="text-align: right" disabled="true" /></td>
				</tr>
			</table>
		</div>
		<div style="float: left; padding-left: 10px;">
			<table>
				<tr>
					<td class="label"><label><b>Moratorio</b></label></td>
				</tr>
				<tr>
					<td><input name="saldoMoratorios" id="saldoMoratorios" size="15" readonly="true" tabIndex="30" esMoneda="true" style="text-align: right" disabled="true" /></td>
				</tr>
			</table>
		</div>
		<div style="float: left; padding-left: 10px;">
			<table>
				<tr>
					<td class="label"><label><b>IVA Moratorio</b></label></td>
				</tr>
				<tr>
					<td><input name="saldoIVAMorator" id="saldoIVAMorator" size="15" readonly="true" tabIndex="31" esMoneda="true" style="text-align: right" disabled="true" /></td>
				</tr>
			</table>
		</div>
		<div style="float: left; padding-left: 15px;">
			<table>
				<tr>
					<td class="label"><label><b>Comisiones</b></label>
				</tr>
				<tr>
					<td><label> Falta Pago: </label></td>
					<td><input name="saldoComFaltPago" id="saldoComFaltPago" size="8" readonly="true" tabIndex="32" esMoneda="true" style="text-align: right" disabled="true" /></td>
				</tr>
				<tr>
					<td><label>Otras: </label></td>
					<td><input name="saldoOtrasComis" id="saldoOtrasComis" size="8" readonly="true" tabIndex="33" esMoneda="true" style="text-align: right" disabled="true" /></td>
				</tr>
				<tr>
					<td class="label"><label>Anual:</label></td>
					<td><input id="saldoComAnual" name="saldoComAnual" type="text" esMoneda="true" size="8" readonly="true" style="text-align: right" disabled="true" ></td>
				</tr>
				<tr>
					<td><label><b>Total: </b></label></td>
					<td><input name="totalComisi" id="totalComisi" size="8" readonly="true" tabIndex="34" esMoneda="true" style="text-align: right"  disabled="true" /></td>
				</tr>
				<tr class="ocultaSeguro">
					<td class="label ocultaSeguro"><label>Seguro</label></td>
					<td class="ocultaSeguro"><input type="text" name="saldoSeguroCuota" id="saldoSeguroCuota" size="8" readonly="true" esMoneda="true" style="text-align: right" disabled="true" /> &nbsp; <a href="javaScript:" onClick="ayudaSeguroCuota();"> <img src="images/help-icon.gif">
					</a></td>
				</tr>
			</table>
		</div>
		<div style="float: left; padding-left: 10px;">
			<table>
				<tr>
					<td class="label"><label><b>IVA Comisiones</b></label>
				</tr>
				<tr>
					<td><label>Falta Pago: </label></td>
					<td><input name="salIVAComFalPag" id="salIVAComFalPag" size="8" readonly="true" tabIndex="35" esMoneda="true" style="text-align: right" disabled="true" /></td>
				</tr>
				<tr>
					<td><label>Otras: </label></td>
					<td><input name="saldoIVAComisi" id="saldoIVAComisi" size="8" readonly="true" tabIndex="36" esMoneda="true" style="text-align: right" disabled="true" /></td>
				</tr>
				<tr>
					<td class="label"><label>Anual:</label></td>
					<td><input id="saldoComAnualIVA" name="saldoComAnualIVA" type="text" esMoneda="true" size="8" readonly="true" style="text-align: right" disabled="true" ></td>
				</tr>
				<tr>
					<td><label><b>Total: </b></label></td>
					<td><input name="totalIVACom" id="totalIVACom" size="8" readonly="true" tabIndex="37" esMoneda="true" style="text-align: right" disabled="true"  /></td>
				</tr>
				<tr class="ocultaSeguro">
					<td class="label ocultaSeguro"><label>Seguro</label></td>
					<td class="ocultaSeguro"><input type="text" name="saldoIVASeguroCuota" id="saldoIVASeguroCuota" size="8" readonly="true" esMoneda="true" style="text-align: right" disabled="true" /></td>
				</tr>
			</table>
		</div>
		
		</fieldset>
		<br>
		
		<div>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend >Montos a Condonar</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="75%">
				<tr>
					<td class="separador"></td>
					<td class="separador"></td>
					<td class="separador"></td>
					<td class="label" align="center"><label for="lblmontos">Montos</label></td>
					<td class="separador"></td>
					<td class="label" align="center"><label for="lblPorcentaje">%</label></td>
					<td class="separador"></td>
					<td class="label" align="center" nowrap="nowrap"><label for="lblmontosPermitidos">Montos Permitidos</label></td>
					<td class="separador"></td>
					<td class="label" align="center"><label for="lblPorcentajePer">%</label></td>
					<td class="separador"></td>
				</tr>
				<tr>
					<td class="label" colspan="3"><label for="lblComisionesAcc">Comisiones y Accesorios</label></td>
					<td align="center" nowrap="nowrap"><form:input id="montoComisiones" name="montoComisiones" path="montoComisiones" size="12" type="text" esMoneda="true" style="text-align: right" tabindex="1" onfocus="validaFocoInputMoneda(this.id);" maxlength="20" /></td>
					<td class="separador"></td>
					<td align="center" nowrap="nowrap"><form:input id="porceComisiones" name="porceComisiones" path="porceComisiones" size="6" readonly="true" type="text" style="text-align: right" tabindex="1" disabled="true"  /></td>
					<td class="separador"></td>
					<td align="center"><input id="montoComisionesPer" name="montoComisionesPer" size="12" type="text" esMoneda="true" style="text-align: right" tabindex="1" disabled="disabled" readonly="readonly" /></td>
					<td class="separador"></td>
					<td align="center"><input id="porceComisionesPer" name="porceComisionesPer" size="8" type="text" style="text-align: right" tabindex="1" disabled="disabled" readonly="readonly" /></td>
					<td class="separador"></td>
				</tr>

				<tr>
					<td class="label" colspan="3">
						<label for="lblComisionesAcc">Notas de Cargos</label>
					</td>
					<td align="center" nowrap="nowrap">
						<input id="montoNotasCargo" name="montoNotasCargo" path="montoNotasCargo" size="12" type="text" esMoneda="true" style="text-align: right" tabindex="1" onfocus="validaFocoInputMoneda(this.id);" maxlength="20" />
					</td>
					<td class="separador"></td>
					<td align="center" nowrap="nowrap">
						<input id="porceNotasCargos" name="porceNotasCargos" path="porceNotasCargos" size="6" readonly="true" type="text" style="text-align: right" tabindex="1" disabled="true"  />
					</td>
					<td class="separador"></td>
					<td align="center">
						<input id="montoNotaCargoPer" name="montoNotaCargoPer" size="12" type="text" esMoneda="true" style="text-align: right" tabindex="1" disabled="disabled" readonly="readonly" />
					</td>
					<td class="separador"></td>
					<td align="center">
						<input id="porceNotasCargoPer" name="porceNotasCargoPer" size="8" type="text" style="text-align: right" tabindex="1" disabled="disabled" readonly="readonly" />
					</td>
					<td class="separador"></td>

				</tr>

				<tr>
					<td class="label" colspan="3"><label for="lblMoratorio">Moratorio</label></td>
					<td align="center" nowrap="nowrap"><form:input id="montoMoratorios" name="montoMoratorios" path="montoMoratorios" size="12" type="text" esMoneda="true" style="text-align: right" tabindex="1" onfocus="validaFocoInputMoneda(this.id);" maxlength="20" /></td>
					<td class="separador"></td>
					<td align="center" nowrap="nowrap"><form:input id="porceMoratorios" name="porceMoratorios" path="porceMoratorios" size="6" type="text" style="text-align: right" tabindex="1" readonly="true" disabled="true"  /></td>
					<td class="separador"></td>
					<td align="center"><input id="montoMoratoriosPer" name="montoMoratoriosPer" size="12" type="text" esMoneda="true" style="text-align: right" tabindex="1" disabled="disabled" readonly="readonly" /></td>
					<td class="separador"></td>
					<td align="center"><input id="porceMoratoriosPer" name="porceMoratoriosPer" size="8" type="text" style="text-align: right" tabindex="1" disabled="disabled" readonly="readonly" /></td>
					<td class="separador"></td>
				</tr>
				<tr>
					<td class="label" colspan="3"><label for="lblInteres">Int&eacute;res</label></td>
					<td align="center" nowrap="nowrap"><form:input id="montoInteres" name="montoInteres" path="montoInteres" size="12" type="text" esMoneda="true" style="text-align: right" tabindex="1" onfocus="validaFocoInputMoneda(this.id);" maxlength="20" /></td>
					<td class="separador"></td>
					<td align="center" nowrap="nowrap"><form:input id="porceInteres" name="porceInteres" path="porceInteres" size="6" type="text" style="text-align: right" tabindex="1" readonly="true" disabled="true" /></td>
					<td class="separador"></td>
					<td align="center"><input id="montoInteresPer" name="montoInteresPer" size="12" type="text" esMoneda="true" style="text-align: right" tabindex="1" disabled="disabled" readonly="readonly" /></td>
					<td class="separador"></td>
					<td align="center"><input id="porceInteresPer" name="porceInteresPer" size="8" type="text" style="text-align: right" tabindex="1" disabled="disabled" readonly="readonly" /></td>
					<td class="separador"></td>
				</tr>
				<tr>
					<td class="label" colspan="3"><label for="lblCapital">Capital</label></td>
					<td align="center" nowrap="nowrap"><form:input id="montoCapital" name="montoCapital" path="montoCapital" size="12" type="text" esMoneda="true" style="text-align: right" tabindex="1" onfocus="validaFocoInputMoneda(this.id);" maxlength="20" /></td>
					<td class="separador"></td>
					<td align="center" nowrap="nowrap"><form:input id="porceCapital" name="porceCapital" path="porceCapital" size="6" type="text" style="text-align: right" tabindex="1" readonly="true" disabled="true"  /></td>
					<td class="separador"></td>
					<td align="center"><input id="montoCapitalPer" name="montoCapitalPer" size="12" type="text" esMoneda="true" style="text-align: right" tabindex="1" disabled="disabled" readonly="readonly" /></td>
					<td class="separador"></td>
					<td align="center"><input id="porceCapitalPer" name="porceCapitalPer" size="8" type="text" style="text-align: right" tabindex="1" disabled="disabled" readonly="readonly" /></td>
					<td class="separador"></td>
				</tr>	
				<tr>
					<td class="label" colspan="3" nowrap="nowrap"><label for="lblmontos">Núm. M&aacute;ximo Condonaciones</label></td>
					<td align="center"><input id="numMaxCondona" name="numMaxCondona" size="12" type="text" style="text-align: right" tabindex="1" disabled="disabled" readonly="readonly" /></td>
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
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td align="right">
					<input type="submit" id="condonar" name="condonar" class="submit" value="Condonar" tabindex="1"/>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" iniForma="false" />
					<input type="hidden" id="usuarioID" name="usuarioID" iniForma="false" />
					<input type="hidden" id="puestoID" name="puestoID" iniForma="false" />
					<input type="hidden" name="totalNotaCargo" id="totalNotaCargo" size="8" readonly="true" tabIndex="28" esMoneda="true" style="text-align: right" disabled="true" />
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
<div id="ContenedorAyuda" style="display: none;">
	<div id="elementoLista"></div>
</div>
</html>

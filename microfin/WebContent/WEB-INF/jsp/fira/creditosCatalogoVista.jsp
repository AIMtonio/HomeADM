<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/lineaFonServicio.js"></script>
<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clasificCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clasifrepregServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/calendarioProdServicio.js"></script>
<script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script>
<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/lineaFonServicio.js"></script>
<script type="text/javascript" src="dwr/interface/parentescosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/seguroVidaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/destinosCredServicio.js"></script>
<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/operacionesFechasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/calculosyOperacionesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/esquemaGarantiaLiqServicio.js"></script>
<script type="text/javascript" src="dwr/interface/esquemaSeguroVidaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/formTipoCalIntServicio.js"></script>
<script type="text/javascript" src="dwr/interface/esquemaSeguroServicio.js"></script>
<script type="text/javascript" src="dwr/interface/catTipoGarantiaFIRAServicio.js"></script>
<script type="text/javascript" src="dwr/interface/catCadenaProductivaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/relCadenaRamaFIRAServicio.js"></script>
<script type="text/javascript" src="dwr/interface/relSubRamaFIRAServicio.js"></script>
<script type="text/javascript" src="dwr/interface/relActividadFIRAServicio.js"></script>
<script type="text/javascript" src="dwr/interface/catFIRAProgEspServicio.js"></script>
<script type="text/javascript" src="dwr/interface/ministraCredAgroServicio.js"></script>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/consolidacionesServicio.js"></script>

<script type="text/javascript" src="dwr/interface/tiposLineasAgroServicio.js"></script>
<script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>

<script type="text/javascript" src="js/utileria.js"></script>
<script type="text/javascript" src="js/fira/creditoAgro.js"></script>
</head>
<script language="javascript">
	$(document).ready(function() {
	    // Este codigo evita que al presionar la tecla enter haga el post
	    $('form').keypress(function(e) {
		    if (e == 13) {
			    return false;
		    }
	    });

	    $('input').keypress(function(e) {
		    if (e.which == 13) {
			    return false;
		    }
	    });
    });
</script>
<body>
	<div id="contenedorForma">
		<input type="hidden" id="transaccionGeneral" name="transaccionGeneral" />
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditos">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Registro de Cr&eacute;dito Agropecuario</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label">
							<label for="credito">N&uacute;mero: </label>
						</td>
						<td>
							<form:input type="text" id="creditoID" name="creditoID" path="creditoID" size="15" tabindex="1" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="tipo">Solicitud: </label>
						</td>
						<td>
							<form:input type="text" id="solicitudCreditoID" name="solicitudCreditoID" path="solicitudCreditoID" size="15" tabindex="2" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="Cliente"><s:message code="safilocale.cliente" />: </label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="15" tabindex="3" />
							<input type="text" id="nombreCliente" name="nombreCliente"  disabled="true" size="50" />
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="deudorOriginal">Deudor Original: </label>
						</td>
						<td>
							<input type="text" id="deudorOriginalID" name="deudorOriginalID" size="15"  disabled="true" />
							<input type="text" id="nombreDeudorOriginal" name="nombreDeudorOriginal" size="50" readonly="true" disabled="true" />
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lineaCred">Producto de Cr&eacute;dito: </label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="producCreditoID" name="producCreditoID" path="producCreditoID" size="15" tabindex="6" disabled="true" />
							<input type="text" id="nombreProd" name="nombreProd" tabindex="7" disabled="true" size="50" />
						</td>
					</tr>
					<tr>
						<td class="label" style="display: none;">
							<label for="lineaCred" type="">Clasificaci&oacute;n: </label>
						</td>
						<td style="display: none;">
							<input type="hidden" id="clasificacion" name="clasificacion" size="15" tabindex="8" disabled="true" /> <input type="hidden" id="DescripClasific" name="DescripClasific" size="35" tabindex="9" disabled="true" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="Cuenta">Cuenta: </label>
						</td>
						<td>
							<form:input type="text" id="cuentaID" name="cuentaID" path="cuentaID" size="15" tabindex="10" disabled="true" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="Relacionado">Relacionado: </label>
						</td>
						<td>
							<form:input type="text" id="relacionado" name="relacionado" path="relacionado" size="15" tabindex="12" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="lblDestino">Destino: </label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="destinoCreID" name="destinoCreID" path="destinoCreID" size="15" tabindex="14" />
							<input type="text" id="descripDestino" name="descripDestino" disabled="true" size="50" tabindex="15" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="lblClasificacion">Clasificaci&oacute;n: </label>
						</td>
						<td>
							<input type="radio" id="clasificacionDestin1" name="clasiDestinCred" value="C" disabled="true" readonly="true" tabindex="20" /> <label for="lblcomercial">Comercial</label> <input type="radio" id="clasificacionDestin2" name="clasiDestinCred" value="O" disabled="true" readonly="true" tabindex="21" /> <label for="lblConsumo">Consumo</label> <input type="radio" id="clasificacionDestin3" name="clasiDestinCred" value="H" disabled="true" readonly="true" tabindex="22" /> <label for="lblHipotecario">Vivienda</label> <input type="hidden" id="clasiDestinCred" name="clasiDestinCred" size="60" readonly="true" tabindex="23" />
						</td>
					</tr>
					<tr style="display: none">
						<td class="label">
							<label for="saldo">Saldo de L&iacute;nea: </label>
						</td>
						<td>
							<input type="text" id="saldoLineaCred" name="saldoLineaCred" size="15" tabindex="11" disabled="true" />
						</td>
					</tr>
					<tr style="display:none">
						<td class="label">
							<label for="lblDestinCredFR">Destino Cr&eacute;dito FR: </label>
						</td>
						<td nowrap="nowrap">
							<input type="text" id="destinCredFRID" name="destinCredFRID" size="15" disabled="true" tabindex="16" /> <input type="text" id="descripDestinoFR" name="descripcionoDestinFR" size="50" tabindex="17" readonly="true" disabled="true" />
						</td>
						<td class="label">
							<label for="lblDestinCredFOMURID">Destino de Cr&eacute;dito FOMUR: </label>
						</td>
						<td nowrap="nowrap">
							<input type="text" id="destinCredFOMURID" name="destinCredFOMURID" size="15" tabindex="18" readonly="true" disabled="true" /> <input type="text" id="descripDestinoFOMUR" name="descripDestinoFOMUR" size="50" tabindex="19" readonly="true" disabled="true" />
						</td>
						<td class="separador"></td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="cadenaProductivaID">Cadena Productiva:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="cadenaProductivaID" name="cadenaProductivaID" path="cadenaProductivaID" maxlength="11" size="15" tabindex="9" />
							<input type="text" id="descipcionCadenaProductiva" name="descipcionCadenaProductiva" size="50" readonly="true" disabled="disabled" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="ramaFIRAID">Rama FIRA:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="ramaFIRAID" name="ramaFIRAID" path="ramaFIRAID" maxlength="11" size="15" tabindex="10" />
							<input type="text" id="descripcionRamaFIRA" size="50" readonly="true" disabled="disabled" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="subramaFIRAID">Subrama FIRA:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="subramaFIRAID" name="subramaFIRAID" path="subramaFIRAID" maxlength="11" size="15" tabindex="11" />
							<input type="text" id="descipcionsubramaFIRA" size="50" readonly="true" disabled="disabled" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="actividadFIRAID">Actividad FIRA:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="actividadFIRAID" name="actividadFIRAID" path="actividadFIRAID" maxlength="11" size="15" tabindex="12" />
							<input type="text" id="descripcionactividadFIRA" size="50" readonly="true" disabled="disabled" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="tipoGarantiaFIRAID">Tipo de Garant&iacute;a:</label>
						</td>
						<td nowrap="nowrap">
							<form:select id="tipoGarantiaFIRAID" name="tipoGarantiaFIRAID" path="tipoGarantiaFIRAID" tabindex="13">
								<form:option value="0">SELECCIONAR</form:option>
							</form:select>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="progEspecialFIRAID">Programa Especial:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="progEspecialFIRAID" name="progEspecialFIRAID" path="progEspecialFIRAID" maxlength="11" size="15" tabindex="14" />
							<input type="text" id="progEspecialFIRADes" size="50" readonly="true" disabled="disabled" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="Estatus">Estatus:</label>
						</td>
						<td>
							<form:select id="estatus" name="estatus" path="estatus" tabindex="13" disabled="true">
								<form:option value="I">INACTIVO</form:option>
								<form:option value="V">VIGENTE</form:option>
								<form:option value="P">PAGADO</form:option>
								<form:option value="C">CANCELADO</form:option>
								<form:option value="A">AUTORIZADO</form:option>
								<form:option value="B">VENCIDO</form:option>
								<form:option value="K">CASTIGADO</form:option>
							</form:select>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="calificaCredito">Calificaci&oacute;n: </label>
						</td>
						<td>
							<input type="text" id="calificaCredito" name="calificaCredito" size="15" disabled="true" tabindex="24" />
						</td>
						<td class="separador"></td>
						<td id="prepagoslbl" class="label">
							<label for="tipoPrepago">Tipo Prepago Capital: </label>
						</td>
						<td id="prepagos">
							<form:select id="tipoPrepago" name="tipoPrepago" path="tipoPrepago" tabindex="25">
								<form:option value="">SELECCIONAR</form:option>
								<form:option value="U">&Uacute;ltimas Cuotas</form:option>
								<form:option value="I">Cuotas Siguientes Inmediatas</form:option>
								<form:option value="V">Prorrateo Cuotas Vigentes</form:option>
							</form:select>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="calificaCredito">Tipo Cr&eacute;dito: </label>
						</td>
						<td>
							<input type="text" id="tipoCreditoDes" size="15" value="NUEVO" disabled="true" /> <input type="hidden" id="tipoCredito" name="tipoCredito" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="lblTipoConsultaSIC">Tipo Consulta SIC: </label>
						</td>
						<td>
							<input type="radio" id="tipoConsultaSICBuro" name="tipoConSIC" value="B" tabindex="24" /> <label for="lblcomercial">Buró Crédito</label> <input type="radio" id="tipoConsultaSICCirculo" name="tipoConSIC" value="C" tabindex="25" /> <label for="lblConsumo">Círculo Crédito</label> <input type="hidden" id="tipoConsultaSIC" name="tipoConsultaSIC" size="20" />
						</td>
					</tr>
					<tr id="consultaBuro">
						<td>
							<label for="lbconsultaSICB">Folio Consulta Buró:</label>
						</td>
						<td>
							<input type="text" id="folioConsultaBC" name="folioConsultaBC" path="folioConsultaBC" size="15" tabindex="26" maxlength="30" />
						</td>
						<td class="separador"></td>
					</tr>
					<tr id="consultaCirculo">
						<td>
							<label for="lbconsultaSICC">Folio Consulta Círculo:</label>
						</td>
						<td>
							<input type="text" id="folioConsultaCC" name="folioConsultaCC" path="folioConsultaCC" size="15" tabindex="27" maxlength="30" />
						</td>
						<td class="separador"></td>
					</tr>
				</table>
				<br>
				<div id="divCreditosConsolidados">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Detalle Consolidaci&oacute;n</legend>
						<input type="hidden" id="folioConsolidaID" name="folioConsolidaID" path="folioConsolidaID" />
						<input type="hidden" id="numTransaccion" name="numTransaccion" path="numTransaccion" />
						<div id="creditosConsolidadosGrid"></div>
					</fieldset>
				</div>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Condiciones</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label">
								<label for="montoCredito">Monto: </label>
							</td>
							<td>
								<form:input type="text" id="montoCredito" name="montoCredito" path="montoCredito" size="18" esMoneda="true" tabindex="26" style="text-align: right" onfocus="validaFocoInputMoneda(this.id);" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="Moneda">Moneda: </label>
							</td>
							<td>
								<form:select id="monedaID" name="monedaID" path="monedaID" tabindex="27" disabled="true">
									<form:option value="">SELECCIONAR</form:option>
								</form:select>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="fechaInicioCredito">Fecha de Inicio: </label>
							</td>
							<td>
								<form:input type="text" id="fechaInicio" name="fechaInicio" size="18" path="fechaInicio" readOnly="true" tabindex="29" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="fechaInicio">Fecha Inicio de Primer Amortizaci&oacute;n: </label>
							</td>
							<td>
								<form:input type="text" id="fechaInicioAmor" name="fechaInicioAmor" size="18" readOnly="true" disabled="disabled" path="fechaInicioAmor" tabindex="30" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblPlazo">Plazo: </label>
							</td>
							<td>
								<form:select id="plazoID" name="plazoID" path="plazoID" tabindex="31">
									<form:option value="0">SELECCIONAR</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblAutorizado">Fecha de Vencimiento: </label>
							</td>
							<td>
								<form:input type="text" id="fechaVencimien" name="fechaVencimien" size="18" path="fechaVencimien" readOnly="true" disabled="disabled" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="fechaDesembolso">Fecha Desembolso </label>
							</td>
							<td>
								<input type="text" id="fechaDesembolso" name="fechaDesembolso" size="18" readOnly="true" path="fechaDesembolso" disabled="disabled" tabindex="33" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="FactorMora">Factor Mora: </label>
							</td>
							<td>
								<input type="text" id="factorMora" name="factorMora" path="factorMora" size="15" readOnly="true" disabled="disabled" esTasa="true" />
								<label id="lblveces" for="lblveces">veces la tasa de inter&eacute;s ordinaria</label>
								<label id="lblTasaFija" for="lblTasaFija">Tasa Fija Anualizada</label>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="comision">Tipo de Dispersi&oacute;n </label>
							</td>
							<td>
								<select id="tipoDispersion" name="tipoDispersion" path="tipoDispersion" tabindex="32">
									<option value="">SELECCIONAR</option>
								</select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="cuentaCLABE">Cuenta CLABE: </label>
							</td>
							<td>
								<form:input id="cuentaCLABE" name="cuentaCLABE" path="cuentaCLABE" nummax="18" type="text" disabled="disabled" value="" tabindex="33" size="24" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="comision">Forma de Cobro x Apertura: </label>
							</td>
							<td>
								<form:input id="formaComApertura" name="formaComApertura" path="formaComApertura" tabindex="34" disabled="true" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="comision">Comisi&oacute;n por Apertura: </label>
							</td>
							<td>
								<form:input type="text" id="montoComision" name="montoComision" path="montoComision" size="15" esMoneda="true" tabindex="35" disabled="true" style="text-align: right" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="Moneda">IVA Comisi&oacute;n: </label>
							</td>
							<td>
								<form:input type="text" id="IVAComApertura" name="IVAComApertura" path="IVAComApertura" tabindex="36" esMoneda="true" disabled="true" size="12" style="text-align: right" />
								<input type="hidden" id="pagaIVACte" name="pagaIVACte" tabindex="37" disabled="true" size="5" /> <input type="hidden" id="sucursalCte" name="sucursalCte" tabindex="38" disabled="true" size="5" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="comision">Garant&iacute;a Liquida: </label>
							</td>
							<td>
								<form:input type="text" id="porcGarLiq" name="porcGarLiq" path="porcGarLiq" size="6" tabindex="39" disabled="true" style="text-align: right" />
								<label for="lblAporte">% &nbsp;</label>
								<form:input type="text" id="aporteCliente" name="aporteCliente" path="aporteCliente" tabindex="40" esMoneda="true" disabled="true" size="12" style="text-align: right" />
							</td>
						</tr>
					</table>
				</fieldset>
				<br>
				<div style="display: none">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Seguro de Vida</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="seguroVid">Seguro de Vida</label>
							</td>
							<td>
								<form:radiobutton id="reqSeguroVidaSi" name="reqSeguroVidaSi" path="reqSeguroVida" disabled="true" value="S" tabindex="41" />
								<label for="si">Si</label>
								<form:radiobutton id="reqSeguroVidaNo" name="reqSeguroVidaNo" path="reqSeguroVida" disabled="true" value="N" tabindex="42" />
								<label for="si">No</label>
								<form:input type="hidden" id="reqSeguroVida" name="reqSeguroVida" path="reqSeguroVida" size="10" tabindex="43" />
								<input type="hidden" id="seguroVidaID" name="seguroVidaID" size="10" tabindex="44" />
							</td>
						</tr>
						<tr id="trMontoSeguroVida">
							<td class="label">
								<label for="montoSeguroVida">Monto Seguro Vida</label>
							</td>
							<td>
								<form:input type="text" id="montoSeguroVida" name="montoSeguroVida" path="montoSeguroVida" esMoneda="true" disabled="true" size="12" style="text-align: right" tabindex="48" />
								<form:input type="hidden" id="factorRiesgoSeguro" name="factorRiesgoSeguro" path="factorRiesgoSeguro" seisDecimales="true" size="12" tabindex="49" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label id="ltipoPago" for="Moneda">Tipo de Pago:</label>
							</td>
							<td>
								<input type="text" id="tipoPagoSeguro" name="tipoPagoSeguro" tabindex="50" disabled="true">
								<form:input type="hidden" id="forCobroSegVida" name="forCobroSegVida" path="forCobroSegVida" />
								<form:input type="hidden" id="montoPolSegVida" name="montoPolSegVida" path="montoPolSegVida" />
								<form:input type="hidden" id="descuentoSeguro" name="descuentoSeguro" path="descuentoSeguro" />
								<input type="hidden" id="noDias" name="noDias" path="noDias" /> <input type="hidden" id="montoSegOriginal" name="montoSegOriginal" path="montoSegOriginal" esMoneda="true" /> <input type="hidden" id="esquemaSeguroID" name="esquemaSeguroID" />
							</td>
						</tr>
						<tr id="tipoPagoSelect">
							<td></td>
							<td></td>
							<td class="separador"></td>
							<td class="label">
								<label for="Moneda">Tipo de Pago:</label>
							</td>
							<td>
								<select id="tipPago" name="tipPago" tabindex="50">
									<option value="">SELECCIONAR</option>
								</select>
							</td>
						</tr>
						<tr id="trBeneficiario">
							<td class="label">
								<label for="beneficiar">Beneficiario:</label>
							</td>
							<td>
								<form:input type="text" id="beneficiario" name="beneficiario" path="beneficiario" size="42" tabindex="55" onblur=" ponerMayusculas(this)" />
							</td>
							<td class="separador"></td>
							<td>
								<label for="beneficiar">Parentesco:</label>
							</td>
							<td>
								<form:input type="text" id="parentescoID" name="parentescoID" path="parentescoID" size="5" tabindex="57" />
								<input id="parentesco" name="parentesco" size="30" type="text" readonly="true" disabled="true" tabindex="58" />
							</td>
						</tr>
						<tr id="trParentesco">
							<td class="label">
								<label for="direccBen">Direcci&oacute;n:</label>
							</td>
							<td>
								<textarea id="direccionBen" name="direccionBen" size="45" tabindex="59" COLS="38" ROWS="2" onblur=" ponerMayusculas(this)"></textarea>
							</td>
						</tr>
					</table>
				</fieldset>
				<br>
			    </div>

			    <br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>L&iacute;nea Cr&eacute;dito</legend>
					<table>
	                <tr>
							<td class="label">
								<label for="lbllineaCreditoID">L&iacute;nea Cr&eacute;dito: </label>
							</td>
							<td nowrap="nowrap">
								<input type="text" id="lineaCreditoID" name="lineaCreditoID" path="lineaCreditoID" size="15" tabindex="48" numMax ="12" disabled="true" />
								<input type="text" id="tipoLineaAgroID" name="tipoLineaAgroID" size="40" onBlur=" ponerMayusculas(this);" disabled="true" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblSaldoActual">Saldo Actual: </label>
							</td>
							<td nowrap="nowrap">
								<input type="text" id="saldoDisponible" name="saldoDisponible" size="15" tabindex="49" esMoneda="true" style="text-align: right" onkeypress="return ingresaSoloNumeros(event,2,this.id);" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblManejaComAdmon">Comisi&oacute;n por Administraci&oacute;n: </label>
							</td>
							<td nowrap="nowrap">
								<select id="manejaComAdmon" name="manejaComAdmon" path="manejaComAdmon" tabindex="50">
									<option value="">SELECCIONAR</option>
									<option value="S">SI</option>
									<option value="N">NO</option>
								</select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label  for="lblComAdmonLinPrevLiq">Prev. Liquidada</label>
							</td>
							<td nowrap="nowrap">
								<input class="check" type="checkbox" id="comAdmonLinPrevLiq" name="comAdmonLinPrevLiq" path="comAdmonLinPrevLiq" tabindex="51"/>
							</td>
						</tr>
						<tr id ="cobroComAdmon">
							<td class="label">
								<label for="lblForPagComAdmon">Tipo de Cobro: </label>
							</td>
							<td>
								<select id="forPagComAdmon" name="forPagComAdmon" path="forPagComAdmon" tabindex="52">
									<option value="">SELECCIONAR</option>
									<option value="D">DEDUCCI&Oacute;N</option>
									<option value="F">FINANCIADO</option>
								</select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label>Monto: </label>
							</td>
							<td>
								<input type="text" id="montoPagComAdmon" name="montoPagComAdmon" path="montoPagComAdmon" size="15" tabindex="53" esMoneda="true" style="text-align: right" onkeypress="return ingresaSoloNumeros(event,2,this.id);"/>
								<label id="lblMontoIvaPagComAdmon">IVA: </label>
								<input type="text" id="montoIvaPagComAdmon" name="montoIvaPagComAdmon" size="15" tabindex="53" esMoneda="true" style="text-align: right" onkeypress="return ingresaSoloNumeros(event,2,this.id);"/>
								<form:input type="hidden" id="porcentajeComAdmon" name="porcentajeComAdmon" path="porcentajeComAdmon" size="15" tabindex="54" esMoneda="true" style="text-align: right" onkeypress="return ingresaSoloNumeros(event,2,this.id);"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblManejaComGarantia">Comisi&oacute;n por Serv. de Garant&iacute;a: </label>
							</td>
							<td nowrap="nowrap">
								<select id="manejaComGarantia" name="manejaComGarantia" path="manejaComGarantia" tabindex="55">
									<option value="">SELECCIONAR</option>
									<option value="S">SI</option>
									<option value="N">NO</option>
								</select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label id="lblComGar" for="lblComGarLinPrevLiq">Prev. Liquidada</label>
							</td>
							<td nowrap="nowrap">
								<input class="check" type="checkbox" id="comGarLinPrevLiq" name="comGarLinPrevLiq" path="comGarLinPrevLiq" tabindex="56"/>
							</td>
						</tr>
						<tr id ="cobroComGarantia">
							<td class="label">
								<label for="lblForPagComGarantia">Tipo de Cobro: </label>
							</td>
							<td>
								<select id="forPagComGarantia" name="forPagComGarantia" path="forPagComGarantia" tabindex="57">
									<option value="">SELECCIONAR</option>
									<option value="D">DEDUCCI&Oacute;N</option>
									<option value="F">FINANCIADO</option>
								</select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label>Monto: </label>
							</td>
							<td>
								<input type="text" id="montoComGarantia" name="montoComGarantia" path="montoComGarantia" size="15" tabindex="58" esMoneda="true" style="text-align: right" onkeypress="return ingresaSoloNumeros(event,2,this.id);"/>
								<label id="lblMontoIvaComGarantia">IVA: </label>
								<input type="text" id="montoIvaComGarantia" name="montoIvaComGarantia" size="15" tabindex="53" esMoneda="true" style="text-align: right" onkeypress="return ingresaSoloNumeros(event,2,this.id);"/>
								<form:input type="hidden" id="porcentajeComGarantia" name="porcentajeComGarantia" path="porcentajeComGarantia" size="15" tabindex="59" esMoneda="true" style="text-align: right" onkeypress="return ingresaSoloNumeros(event,2,this.id);"/>
							</td>
						</tr>
					</table>
				</fieldset>

				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Inter&eacute;s</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="calcInter"> Ciclo <s:message code="safilocale.cliente" />:
								</label>
							</td>
							<td>
								<input type="text" id="cicloCliente" name="cicloCliente" disabled="true" size="6" tabindex="60">
							</td>
							<td class="separador"></td>
							<td class="label" style="display: none;" id="lbciclos">
								<label for="calcInter"> Ciclo Grupal</label>
							</td>
							<td style="display: none;" id="lbcicloscaja">
								<input type="text" id="cicloClienteGrupal" name="cicloClienteGrupal" disabled="true" size="6" tabindex="61">
								<form:input type="hidden" id="esGrupal" name="esGrupal" path="esGrupal" size="6" tabindex="62" />
								<form:input type="hidden" id="tasaPonderaGru" name="tasaPonderaGru" path="tasaPonderaGru" size="6" tabindex="63" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="calcInter">Tipo Cal. Inter&eacute;s : </label>
							</td>
							<td>
								<form:select id="tipoCalInteres" name="tipoCalInteres" path="tipoCalInteres" tabindex="64" disabled="true">
									<form:option value="">SELECCIONAR</form:option>
									<form:option value="1">SALDOS INSOLUTOS</form:option>
									<form:option value="2">MONTO ORIGINAL</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="calcInter">C&aacute;lculo de Inter&eacute;s : </label>
							</td>
							<td>
								<form:select id="calcInteresID" name="calcInteresID" path="calcInteresID" tabindex="65" disabled="true">
									<form:option value="">SELECCIONAR</form:option>
								</form:select>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="TasaBase">Tasa Base: </label>
							</td>
							<td>
								<form:input type="text" id="tasaBase" name="tasaBase" path="tasaBase" size="5" tabindex="66" disabled="true" />
								<input type="text" id="desTasaBase" name="desTasaBase" size="25" readonly="true" disabled="true" tabindex="67" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="tasaFija">Tasa Fija Anualizada: </label>
							</td>
							<td>
								<form:input type="text" id="tasaFija" name="tasaFija" path="tasaFija" size="8" tabindex="68" esTasa="true" disabled="true" style="text-align: right" />
								<label for="porcentaje">%</label>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="SobreTasa">Sobre Tasa: </label>
							</td>
							<td>
								<form:input type="text" id="sobreTasa" name="sobreTasa" path="sobreTasa" size="8" esTasa="true" tabindex="69" disabled="true" style="text-align: right;" />
								<label for="porcentaje">%</label>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="PisoTasa">Piso Tasa: </label>
							</td>
							<td>
								<form:input type="text" id="pisoTasa" name="pisoTasa" path="pisoTasa" size="8" style="text-align: right;" esTasa="true" tabindex="70" disabled="true" />
								<label for="porcentaje">%</label>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="TechoTasa">Techo Tasa: </label>
							</td>
							<td>
								<form:input type="text" id="techoTasa" name="techoTasa" path="techoTasa" size="8" style="text-align: right;" esTasa="true" tabindex="71" disabled="true" />
								<label for="porcentaje">%</label>
							</td>
							<td class="separador"></td>
						</tr>
					</table>
				</fieldset>
				<br>
				<div id='gridMinistraCredAgro'></div>
				<div style="display: none">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Calendario de Pagos</legend>
						<div style="display: none">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<table border="0" cellpadding="0" cellspacing="0" width="100%">
									<tr>
										<td class="label">
											<label for="fechInhabil">En Fecha Inh&aacute;bil Tomar: </label>
										</td>
										<td class="label">
											<input type="radio" id="fechaInhabil1" name="fechaInhabil1" value="S" tabindex="72" /> <label for="siguiente">D&iacute;a H&aacute;bil Siguiente</label>&nbsp; <input type="radio" id="fechaInhabil2" name="fechaInhabil2" value="A" tabindex="73" /> <label for="anterior">D&iacute;a H&aacute;bil Anterior</label>
											<form:input type="hidden" id="fechaInhabil" name="fechaInhabil" path="fechaInhabil" size="15" tabindex="74" readonly="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="fechInhabil">Ajustar Fecha Exig&iacute;ble a la de Vencimiento: </label>
										</td>
										<td class="label">
											<input type="radio" id="ajusFecExiVen1" name="ajusFecExiVen1" value="S" tabindex="75" /><label for="Si">Si</label>&nbsp; <input type="radio" id="ajusFecExiVen2" name="ajusFecExiVen2" value="N" tabindex="76" /><label for="No">No</label>
											<form:input type="hidden" id="ajusFecExiVen" name="ajusFecExiVen" path="ajusFecExiVen" size="15" tabindex="77" readonly="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<input type="checkbox" id="calendIrregularCheck" name="calendIrregularCheck" tabindex="78" value="S" />
											<form:input type="hidden" id="calendIrregular" name="calendIrregular" path="calendIrregular" readonly="true" value="N" tabindex="79" />
											<label for="calendarioIrreg">Calendario Irregular </label>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="ajusFecUlVenAmo">Ajustar Fecha de Vencimiento de &Uacute;ltima Amortizaci&oacute;n a Vencimiento de Cr&eacute;dito: </label>
										</td>
										<td class="label">
											<input type="radio" id="ajusFecUlVenAmo1" name="ajusFecUlVenAmo1" value="S" tabindex="80" /><label for="lblajFecUlAmoVen">Si</label>&nbsp; <input type="radio" id="ajusFecUlVenAmo2" name="ajusFecUlVenAmo2" value="N" tabindex="81" /><label for="no">No</label>
											<form:input type="hidden" id="ajusFecUlVenAmo" name="ajusFecUlVenAmo" path="ajusFecUlVenAmo" size="15" tabindex="82" readonly="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="TipoPagCap">Tipo de Pago de Capital: </label>
										</td>
										<td>
											<select id="tipoPagoCapital" name="tipoPagoCapital" path="tipoPagoCapital" tabindex="83">
												<option value="">SELECCIONAR</option>
											</select> <input type="hidden" id="perIgual" name="perIgual" size="5" />
										</td>
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
									<tr class="ocultarSeguros">
										<td class="label">
											<label>Cobra IVA Seguro Cuota:</label>
										</td>
										<td>
											<form:select name="cobraIVASeguroCuota" id="cobraIVASeguroCuota" disabled="true" path="cobraIVASeguroCuota">
												<option value="N">NO</option>
												<option value="S">SI</option>
											</form:select>
										</td>
									</tr>
								</table>
							</fieldset>
						</div>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<table>
								<tr>
									<td class="label">Inter&eacute;s</td>
									<td class="separador"></td>
									<td class="separador"></td>
									<td class="label">Capital</td>
									<td class="separador"></td>
								</tr>
								<tr>
									<td class="label">
										<label for="FrecuenciaInter">Frecuencia: </label>
									</td>
									<td>
										<select id="frecuenciaInt" name="frecuenciaInt" path="frecuenciaInt" tabindex="84">
											<option value="">SELECCIONAR</option>
										</select>
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="FrecuenciaCap">Frecuencia: </label>
									</td>
									<td>
										<select id="frecuenciaCap" name="frecuenciaCap" path="frecuenciaCap" tabindex="85">
											<option value="">SELECCIONAR</option>
										</select>
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="PeriodicidadInter">Periodicidad de Inter&eacute;s:</label>
									</td>
									<td>
										<form:input type="text" id="periodicidadInt" name="periodicidadInt" path="periodicidadInt" size="8" tabindex="86" disabled="true" />
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="PeriodicidadCap">Periodicidad de Capital:</label>
									</td>
									<td>
										<form:input type="text" id="periodicidadCap" name="periodicidadCap" path="periodicidadCap" size="8" tabindex="87" disabled="true" />
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="DiaPago">D&iacute;a Pago: </label>
									</td>
									<td nowrap="nowrap">
										<input type="radio" id="diaPagoInteres1" name="diaPagoInteres1" value="F" tabindex="88" /> <label for="diaPagoInteres1">&Uacute;ltimo d&iacute;a del mes</label> <input type="radio" id="diaPagoInteres2" name="diaPagoInteres2" value="A" tabindex="89" /> <label for="diaPagoInteres2" id="lblDiaPagoCap">D&iacute;a del mes</label>
										<form:input type="hidden" id="diaPagoInteres" name="diaPagoInteres" path="diaPagoInteres" size="8" tabindex="90" value="F" />
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="DiaPago">D&iacute;a Pago: </label>
									</td>
									<td nowrap="nowrap">
										<input type="radio" id="diaPagoCapital1" name="diaPagoCapital1" value="F" tabindex="91" /> <label for="diaPagoCapital1">&Uacute;ltimo d&iacute;a del mes</label>&nbsp; <input type="radio" id="diaPagoCapital2" name="diaPagoCapital2" path="diaPagoCapital" value="A" tabindex="92" /> <label for="diaPagoCapital2" id="lblDiaPagoCap">D&iacute;a del mes</label>
										<form:input type="hidden" id="diaPagoCapital" name="diaPagoCapital" path="diaPagoCapital" size="8" tabindex="93" />
										<input type="hidden" id="diaPagoProd" name="diaPagoProd" size="8" />
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="DiaMes">D&iacute;a del mes: </label>
									</td>
									<td>
										<form:input type="text" id="diaMesInteres" name="diaMesInteres" path="diaMesInteres" size="8" tabindex="94" disabled="true" />
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="DiaMes">D&iacute;a del mes: </label>
									</td>
									<td>
										<form:input type="text" id="diaMesCapital" name="diaMesCapital" path="diaMesCapital" size="8" tabindex="95" disabled="true" />
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="numAmort">N&uacute;mero de Cuotas:</label>
									</td>
									<td>
										<form:input type="text" id="numAmortInteres" name="numAmortInteres" path="numAmortInteres" size="8" tabindex="96" disabled="true" />
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="numAmort">N&uacute;mero de Cuotas:</label>
									</td>
									<td>
										<form:input type="text" id="numAmortizacion" name="numAmortizacion" path="numAmortizacion" size="8" tabindex="97" disabled="true" />
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="lblMontoCuota">Monto Cuota:</label>
									</td>
									<td>
										<form:input id="montoCuota" name="montoCuota" path="montoCuota" size="18" disabled="true" esMoneda="true" style="text-align: right" />
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="CAT">CAT:</label>
									</td>
									<td>
										<form:input id="cat" name="cat" path="cat" size="8" disabled="true" />
										<label for="lblPorc"> %</label>
									</td>
								</tr>
								<tr class="ocultarSeguros">
									<td></td>
									<td></td>
									<td></td>
									<td class="label">
										<label>Monto Seguro Cuota:</label>
									</td>
									<td>
										<form:input type="text" name="montoSeguroCuota" id="montoSeguroCuota" path="montoSeguroCuota" size="8" disabled="true" />
									</td>
								</tr>
								<tr>
									<td colspan="5">
										<input type="hidden" id="montosCapital" name="montosCapital" size="100" />
										<form:input type="hidden" id="numTransacSim" name="numTransacSim" path="numTransacSim" size="5" disabled="true" value="0" />
									</td>
								</tr>
							</table>
						</fieldset>
					</fieldset>
				</div>
				<table style="width: 100%">
					<tr>
						<td colspan="5" align="right">
							<input type="button" id="simular" name="simular" class="submit" value="Simular" tabindex="98" />
						</td>
					</tr>
				</table>
				<div id="contenedorSimulador" style="display: none;"></div>
				<div id="contenedorSimuladorLibre" style="overflow: scroll; width: 100%; height: 300px; display: none;"></div>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Origen Recursos</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="FactorMora">Tipo de Fondeo: </label>
							</td>
							<td>
								<input type="radio" id="tipoFondeo" name="tipoFondeo" path="tipoFondeo" value="P" tabindex="99" checked="checked" /> <label for="recProp">Recursos Propios</label> <input type="radio" id="tipoFondeo2" name="tipoFondeo" path="tipoFondeo" value="F" tabindex="100" /> <label for="insFondeo">Inst. Fondeo</label>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblInstitucion">Inst. Fondeo: </label>
							</td>
							<td>
								<form:input id="institFondeoID" name="institFondeoID" path="institFondeoID" size="12" tabindex="101" disabled="true" />
								<input type="text" id="descripFondeo" name="descripFondeo" size="45" disabled="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblLineaFondeo">L&iacute;nea de Fondeo: </label>
							</td>
							<td>
								<form:input id="lineaFondeo" name="lineaFondeo" path="lineaFondeo" size="12" tabindex="102" disabled="true" />
								<input type="text" id="descripLineaFon" name="descripLineaFon" size="45" disabled="true" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblSaldoLinea">Saldo de la L&iacute;nea: </label>
							</td>
							<td>
								<input type="text" id="saldoLineaFon" name="saldoLineaFon" size="12" tabindex="103" disabled="true" esMoneda="true" style="text-align: right" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblTasaPasiva">Tasa Pasiva: </label>
							</td>
							<td>
								<input type="text" id="tasaPasiva" name="tasaPasiva" size="12" tabindex="104" disabled="true" esTasa="true" style="text-align: right" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblTasaPasiva">Folio Fondeo: </label>
							</td>
							<td>
								<input type="text" id="folioFondeo" name="folioFondeo" size="30" readOnly="true" disabled="disabled" />
							</td>
						</tr>
					</table>
				</fieldset>
				<br> <br>
				<div id="divComentarios" style="display: none;">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Comentarios</legend>
						<table>
							<tr>
								<td class="label">
									<label for="lblComentario">Comentarios: </label>
								</td>
								<td>
									<form:textarea id="comentarioAlt" name="comentarioAlt" path="comentarioAlt" tabindex="105" COLS="50" ROWS="4" onBlur=" ponerMayusculas(this); limpiarCajaTexto(this.id);" disabled="false" maxlength="500" />
								</td>
							</tr>
						</table>
					</fieldset>
				</div>
				<table style="text-align: right; width: 100%">
					<tr>
						<td align="right">
							<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="105" />
							<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="106" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
							<input type="hidden" id="calificaCliente" name="calificaCliente" path="calificaCliente" />
							<input type="hidden" id="pantalla" name="pantalla" />
							<input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>" />
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
	<div id="cajaListaCte" style="display: none; overflow-y: scroll; height: 200px;">
		<div id="elementoListaCte"></div>
	</div>
	<div id="mensaje" style="display: none;"></div>
</body>
<html>
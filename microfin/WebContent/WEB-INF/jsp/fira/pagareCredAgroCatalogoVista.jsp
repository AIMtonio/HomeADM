<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script>
<script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/formTipoCalIntServicio.js"></script>
<script type="text/javascript" src="dwr/interface/esquemaSeguroServicio.js"></script>
<script type="text/javascript" src="dwr/interface/lineaFonServicio.js"></script>
<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/ministraCredAgroServicio.js"></script>
<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/destinosCredServicio.js"></script>
<script type="text/javascript" src="js/utileria.js"></script>
<script type="text/javascript" src="js/fira/pagareCreditos.js"></script>
<script type="text/javascript" src="js/fira/simuladorPagosLibresPagare.js"></script>
<script type="text/javascript" src="dwr/interface/edoCtaParamsServicio.js"></script>
<script type="text/javascript" src="dwr/interface/conceptosInversionAgroServicio.js"></script>
<script type="text/javascript" src="dwr/interface/contratoCreditoIndivServicio.js"></script>
<script type="text/javascript" src="dwr/interface/contratoCreditoAgroServicio.js"></script>
<script type="text/javascript" src="js/contratos/contratoAvioPFConsol.js"></script>
<script type="text/javascript" src="js/contratos/contratoRefaccionarioPFConsol.js"></script>
<script type="text/javascript" src="js/contratos/contratoRefaccionarioPMAGUConsol.js"></script>
<script type="text/javascript" src="js/contratos/contratoRefaccionarioPMCAConsol.js"></script>
<script type="text/javascript" src="js/contratos/contratoAvioPMAGUConsol.js"></script>
<script type="text/javascript" src="js/contratos/contratoAvioPMCAConsol.js"></script>
<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<input type="hidden" id="transaccionGeneral" name="transaccionGeneral" />
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditos">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Pagar&eacute; de Cr&eacute;dito</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label"><label for="credito">N&uacute;mero: </label></td>
						<td><form:input id="creditoID" name="creditoID" path="creditoID" size="12" tabindex="1" /></td>
						<td class="separador"></td>
						<td class="label"><label for="Cliente"><s:message code="safilocale.cliente" />: </label></td>
						<td><form:input id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="2" readonly="true" disabled="true" /> <input type="text" id="nombreCliente" name="nombreCliente" tabindex="3" readonly="true" disabled="true" size="40" /></td>
					</tr>
					<tr style="display: none">
						<td class="label"><label for="lineaCred">L&iacute;nea de Cr&eacute;dito: </label></td>
						<td><form:input id="lineaCreditoID" name="lineaCreditoID" path="lineaCreditoID" size="10" tabindex="4" readonly="true" disabled="true" /></td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap"><label for="lineaCred">Producto de Cr&eacute;dito: </label></td>
						<td><form:input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="5" tabindex="5" disabled="true" /> <input type="text" id="nombreProd" name="nombreProd" tabindex="6" disabled="true" size="45" /></td>
					</tr>
					<tr>
						<td class="label"><label for="Cuenta">Cuenta: </label></td>
						<td><form:input id="cuentaID" name="cuentaID" path="cuentaID" size="10" tabindex="7" readonly="true" disabled="true" /></td>
						<td class="separador"></td>
						<td class="label"><label for="fechaDesembolso">Fecha de Desembolso: </label></td>
						<td><form:input type="text" id="fechaMinistrado" name="fechaMinistrado" path="fechaMinistrado" size="15" esCalendario="true" tabindex="8" /> <input type="hidden" id="fechaMinistradoOriginal" name="fechaMinistradoOriginal" size="15" /></td>
					</tr>
					<tr id="pregagos">
						<td class="label"><label for="lblTipoPrepago">Tipo Prepago Capital: </label></td>
						<td><form:select id="tipoPrepago" name="tipoPrepago" path="tipoPrepago" tabindex="29">
								<form:option value="">SELECCIONAR</form:option>
								<form:option value="U">&Uacute;LTIMAS CUOTAS</form:option>
								<form:option value="I">CUOTAS SIGUIENTES INMEDIATAS</form:option>
								<form:option value="V">PRORRATEO CUOTAS VIVAS</form:option>
							</form:select></td>
						<td class="separador"></td>
						<td class="label"><label for="Estatus">Estatus:</label></td>
						<td><form:select id="estatus" name="estatus" path="estatus" tabindex="9" readonly="true" disabled="true">
								<form:option value="I">INACTIVO</form:option>
								<form:option value="V">VIGENTE</form:option>
								<form:option value="P">PAGADO</form:option>
								<form:option value="C">CANCELADO</form:option>
								<form:option value="A">AUTORIZADO</form:option>
								<form:option value="B">VENCIDO</form:option>
								<form:option value="K">CASTIGADO</form:option>
								<form:option value="M">PROCESADO</form:option>
							</form:select></td>
					</tr>
					<tr>
						<td class="label"><label>Tipo Cr&eacute;dito: </label></td>
						<td><input type="text" id="tipoCreditoDes" size="20" readonly="true" /></td>
						<td class="separador"></td>
					</tr>
				</table>
				<br>
				<div style="display: none">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Saldos de la L&iacute;nea de Cr&eacute;dito</legend>
						<table border="0" cellpadding="0" cellspacing="0" width="950px">
							<tr>
								<td class="label"><label for="SaldoDisponible">Saldo disponible: </label></td>
								<td><input type="text" id="saldoDisponible" name="saldoDisponible" size="15" tabindex="10" readonly="true" disabled="true" tabindex="11" esMoneda="true" style="text-align: right;" /></td>
								<td class="separador"></td>
								<td class="label"><label for="Moneda">Saldo Deudor: </label></td>
								<td><input type="text" id="saldoDeudor" name="saldoDeudor" size="15" tabindex="12" readonly="true" disabled="true" esMoneda="true" style="text-align: right;" /></td>
							</tr>
						</table>
					</fieldset>
				</div>
				<div id="grupoDiv" style="display:none">
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Grupos </legend>
						<table table border="0" width="100%">
							<tr>
								<td class="label"><label for="lblGrupo">Grupo: </label></td>
								<td><input type="text" id="grupoID" name="grupoID" path="grupoID" size="10" tabindex="28" iniForma="false" readonly="true" disabled="disabled" /> <input type="text" id="nombreGr" name="nombreGr" size="40" tabindex="29" disabled="true" /></td>
								<td class="separador"></td>
								<td class="label"><label for="lbl">Tipo Integrante: </label></td>
								<td><select id="tipoIntegrante" name="tipoIntegrante" path="tipoIntegrante" tabindex="30">
										<option value="" selected="true">SELECCIONA</option>
										<option value="1">PRESIDENTE </option>
										<option value="2">TESORERO</option>
										<option value="3">SECRETARIO </option>
										<option value="4">INTEGRANTE</option>
									</select></td>
							</tr>
						</table>
					</fieldset>
				</div>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Condiciones</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="950px">
						<tr>
							<td class="label"><label for="Monto">Monto: </label></td>
							<td><form:input id="montoCredito" name="montoCredito" path="montoCredito" size="15" style="text-align: right;" readonly="true" disabled="true" esMoneda="true" tabindex="13" /></td>
							<td class="separador"></td>
							<td class="label"><label for="lblPlazo">Plazo: </label></td>
							<td><select id="plazoID" name="plazoID" path="plazoID" tabindex="17" readonly="true" disabled="true">
									<option value="">SELECCIONAR</option>
							</select></td>
						</tr>
						<tr>
							<td class="label"><label for="FechaInic">Fecha de Inicio : </label></td>
							<td><form:input type="text" id="fechaInicio" name="fechaInicioCred" path="fechaInicio" size="15" readonly="true" disabled="true" tabindex="16" /></td>
							<td class="separador"></td>
							<td class="label"><label for="fechaInicio">Fecha Inicio de Primer Amortizaci&oacute;n: </label></td>
							<td><form:input type="text" id="fechaInicioAmor" name="fechaInicioAmor" size="15" readOnly="true" path="fechaInicioAmor" tabindex="30" /></td>
						</tr>
						<tr>
							<td class="label"><label for="FechaVencimiento">Fecha de Vencimiento: </label></td>
							<td><form:input type="text" id="fechaVencimien" name="fechaVencimien" path="fechaVencimien" size="15" tabindex="17" readonly="true" disabled="true" /></td>
							<td class="separador"></td>
							<td class="label"><label for="comision">Monto Seguro Vida: </label></td>
							<td><form:input type="text" id="montoSeguroVida" name="montoSeguroVida" path="montoSeguroVida" size="15" style="text-align: right" esmoneda="true" disabled="true" /></td>
						</tr>
						<tr>
							<td class="label"><label for="comision">Comisi&oacute;n por apertura: </label></td>
							<td><form:input type="text" id="montoComision" name="montoComision" path="montoComision" size="15" esMoneda="true" tabindex="22" disabled="true" style="text-align: right;" /></td>
							<td class="separador"></td>
							<td class="label"><label for="Moneda">IVA Comisi&oacute;n: </label></td>
							<td><form:input type="text" id="IVAComApertura" name="IVAComApertura" path="montoComision" tabindex="23" esMoneda="true" disabled="true" size="15" style="text-align: right;" /></td>
						</tr>
						<tr>
							<td class="label"><label for="Moneda">Moneda: </label></td>
							<td><form:input type="text" id="monedaID" name="monedaID" path="monedaID" size="3" tabindex="14" readonly="true" disabled="true" /> <input type="text" id="monedaDes" name="monedaDes" size="30" readonly="true" disabled="true" tabindex="15" /></td>
						</tr>
					</table>
				</fieldset>
				<br>
				<input type="hidden" id="esConsolidacionAgro" name="esConsolidacionAgro" size="1"  />
				<div id='gridMinistraCredAgro'></div>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Inter&eacute;s</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="950px">
						<tr>
							<td class="label"><label for="calcInter">C&aacute;lculo de Inter&eacute;s : </label></td>
							<td><form:select id="calcInteresID" name="calcInteresID" path="calcInteresID" readonly="readonly" disabled="disabled">
									<form:option value="-1">SELECCIONAR</form:option>
								</form:select></td>
							<td class="separador"></td>
							<td class="label"><label for="TasaBase">Tasa Base: </label></td>
							<td><form:input type="text" id="tasaBase" name="tasaBase" path="tasaBase" size="8" tabindex="19" readonly="true" disabled="true" /> <input type="text" id="desTasaBase" name="desTasaBase" size="25" readonly="true" disabled="true" tabindex="20" /></td>
						</tr>
						<tr>
							<td class="label"><label for="tasaFija">Tasa Fija Anualizada: </label></td>
							<td><form:input type="text" id="tasaFija" disabled="true" name="tasaFija" path="tasaFija" size="8" tabindex="20" esTasa="true" readonly="true" style="text-align: right;" /> <label for="porcentaje">%</label></td>
							<td class="separador"></td>
							<td class="label"><label for="SobreTasa">SobreTasa: </label></td>
							<td><form:input type="text" id="sobreTasa" name="sobreTasa" path="sobreTasa" size="8" esTasa="true" tabindex="21" readonly="true" disabled="true" style="text-align: right;" /> <label for="porcentaje">%</label></td>
						</tr>
						<tr>
							<td class="label"><label for="PisoTasa">Piso Tasa: </label></td>
							<td><form:input type="text" id="pisoTasa" name="pisoTasa" path="pisoTasa" size="8" esTasa="true" tabindex="22" readonly="true" disabled="true" style="text-align: right;" /> <label for="porcentaje">%</label></td>
							<td class="separador"></td>
							<td class="label"><label for="TechoTasa">Techo Tasa: </label></td>
							<td><form:input type="text" id="techoTasa" name="techoTasa" path="techoTasa" size="8" esTasa="true" tabindex="23" readonly="true" disabled="true" style="text-align: right;" /> <label for="porcentaje">%</label></td>
						</tr>
					</table>
				</fieldset>
				<br>
				<div style="display: none">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Calendario de Pagos</legend>
						<table border="0" cellpadding="0" cellspacing="0" width="950px">
							<tr style="display: none">
								<td class="label"><label for="fechInhabil">En Fecha Inh&aacute;bil Tomar: </label></td>
								<td class="label"><input type="radio" id="fechaInhabil1" name="fechaInhabil1" value="S" disabled="disabled" readonly="readonly" tabindex="24" /> <label for="siguiente">D&iacute;a H&aacute;bil Siguiente</label>&nbsp; <input type="radio" id="fechaInhabil2" name="fechaInhabil2" value="A" disabled="disabled" readonly="readonly" tabindex="25" /> <label for="anterior">D&iacute;a H&aacute;bil Anterior</label> <form:input type="hidden" id="fechaInhabil" name="fechaInhabil"
										path="fechaInhabil" size="15" readonly="true" /></td>
							</tr>
							<tr style="display: none">
								<td class="label"><label for="fechInhabil">Ajustar Fecha Exig&iacute;ble a la de Vencimiento: </label></td>
								<td class="label"><input type="radio" id="ajusFecExiVen1" name="ajusFecExiVen1" value="S" disabled="disabled" readonly="readonly" tabindex="69" /> <label for="Si">Si</label>&nbsp; <input type="radio" id="ajusFecExiVen2" name="ajusFecExiVen2" value="N" disabled="disabled" readonly="readonly" tabindex="70" /> <label for="No">No</label> <form:input type="hidden" id="ajusFecExiVen" name="ajusFecExiVen" path="ajusFecExiVen" size="15" tabindex="71" readonly="true" /></td>
							</tr>
							<tr style="display: none">
								<td class="label"><input type="checkbox" id="calendIrregularCheck" name="calendIrregularCheck" disabled="disabled" readonly="readonly" tabindex="72" value="S" /> <form:input type="hidden" id="calendIrregular" name="calendIrregular" path="calendIrregular" readonly="true" value="N" tabindex="73" /> <label for="calendarioIrreg">Calendario Irregular </label></td>
							</tr>
							<tr style="display: none">
								<td class="label"><label for="ajusFecUlVenAmo">Ajustar Fecha de Vencimiento de &Uacute;ltima Amortizaci&oacute;n a Vencimiento de Cr&eacute;dito: </label></td>
								<td class="label"><input type="radio" id="ajusFecUlVenAmo1" name="ajusFecUlVenAmo1" value="S" disabled="disabled" readonly="readonly" tabindex="74" /> <label for="lblajFecUlAmoVen">Si</label>&nbsp; <input type="radio" id="ajusFecUlVenAmo2" name="ajusFecUlVenAmo2" value="N" disabled="disabled" readonly="readonly" tabindex="75" /> <label for="no">No</label> <form:input type="hidden" id="ajusFecUlVenAmo" name="ajusFecUlVenAmo" path="ajusFecUlVenAmo" size="15" tabindex="76"
										readonly="true" /></td>
							</tr>
							<tr style="display: none">
								<td class="label"><label for="TipoPagCap">Tipo de Pago de Capital: </label></td>
								<td class="label"><select id="tipoPagoCapital" name="tipoPagoCapital" path="tipoPagoCapital" tabindex="46" disabled="disabled" readonly="readonly" style="display: none">
										<option value="">SELECCIONAR</option>
										<option value="C">CRECIENTES</option>
										<option value="I">IGUALES</option>
										<option value="L">LIBRES</option>
								</select></td>
							</tr>
							<tr style="display: none">
								<td class="label"><label>Cobra Seguro Cuota:</label></td>
								<td><form:select name="cobraSeguroCuota" id="cobraSeguroCuota" disabled="true" path="cobraSeguroCuota">
										<option value="N">NO</option>
										<option value="S">SI</option>
									</form:select></td>
							</tr>
							<tr class="ocultarSeguros">
								<td class="label"><label>Cobra IVA Seguro Cuota:</label></td>
								<td><form:select name="cobraIVASeguroCuota" id="cobraIVASeguroCuota" disabled="true" path="cobraIVASeguroCuota">
										<option value="N">NO</option>
										<option value="S">SI</option>
									</form:select></td>
							</tr>
						</table>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<table border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td class="label"><label for="interes">Inter&eacute;s </label></td>
									<td class="separador"></td>
									<td class="separador"></td>
									<td class="label"><label for="capital">Capital </label></td>
									<td class="separador"></td>
								</tr>
								<tr>
									<td class="label"><label for="FrecuenciaInter">Frecuencia: </label></td>
									<td><form:select id="frecuenciaInt" name="frecuenciaInt" path="frecuenciaInt" tabindex="35" readonly="true" disabled="true">
											<form:option value="">SELECCIONAR</form:option>
											<form:option value="S">SEMANAL</form:option>
											<form:option value="D">DECENAL</form:option>
											<form:option value="C">CATORCENAL</form:option>
											<form:option value="Q">QUINCENAL</form:option>
											<form:option value="M">MENSUAL</form:option>
											<form:option value="P">PERIODO</form:option>
											<form:option value="B">BIMESTRAL</form:option>
											<form:option value="T">TRIMESTRAL</form:option>
											<form:option value="R">TETRAMESTRAL</form:option>
											<form:option value="E">SEMESTRAL</form:option>
											<form:option value="A">ANUAL</form:option>
											<form:option value="U">PAGO &Uacute;NICO</form:option>
											<form:option value="L">LIBRE</form:option>
										</form:select></td>
									<td class="separador"></td>
									<td class="label"><label for="FrecuenciaCap">Frecuencia: </label></td>
									<td><form:select id="frecuenciaCap" name="frecuenciaCap" path="frecuenciaCap" tabindex="36" readonly="true" disabled="true">
											<form:option value="">SELECCIONAR</form:option>
											<form:option value="S">SEMANAL</form:option>
											<form:option value="D">DECENAL</form:option>
											<form:option value="C">CATORCENAL</form:option>
											<form:option value="Q">QUINCENAL</form:option>
											<form:option value="M">MENSUAL</form:option>
											<form:option value="P">PERIODO</form:option>
											<form:option value="B">BIMESTRAL</form:option>
											<form:option value="T">TRIMESTRAL</form:option>
											<form:option value="R">TETRAMESTRAL</form:option>
											<form:option value="E">SEMESTRAL</form:option>
											<form:option value="A">ANUAL</form:option>
											<form:option value="U">PAGO &Uacute;NICO</form:option>
											<form:option value="L">LIBRE</form:option>
										</form:select></td>
								</tr>
								<tr>
									<td class="label"><label for="PeriodicidadInter">Periodicidad de Inter&eacute;s:</label></td>
									<td><form:input id="periodicidadInt" name="periodicidadInt" path="periodicidadInt" size="5" tabindex="37" readonly="true" disabled="true" /></td>
									<td class="separador"></td>
									<td class="label"><label for="PeriodicidadCap">Periodicidad de Capital:</label></td>
									<td><form:input id="periodicidadCap" name="periodicidadCap" path="periodicidadCap" size="5" tabindex="38" readonly="true" disabled="true" /></td>
								</tr>
								<tr>
									<td class="label"><label for="DiaPago">D&iacute;a Pago: </label></td>
									<td class="separador"></td>
									<td class="separador"></td>
									<td class="label"><label for="DiaPago">D&iacute;a Pago: </label></td>
									<td class="separador"></td>
								</tr>
								<tr>
									<td><input type="radio" id="diaPagoInteres1" name="diaPagoInteres1" value="F" tabindex="83" disabled="disabled" readonly="readonly" /> <label for="ultimo">&Uacute;ltimo d&iacute;a del mes</label> <input type="radio" id="diaPagoInteres2" name="diaPagoInteres2" value="A" tabindex="84" disabled="disabled" readonly="readonly" /> <label for="diaMes">D&iacute;a del mes</label> <form:input type="hidden" id="diaPagoInteres" name="diaPagoInteres" path="diaPagoInteres" size="8"
											tabindex="85" value="F" /></td>
									<td class="separador"></td>
									<td class="separador"></td>
									<td><input type="radio" id="diaPagoCapital1" name="diaPagoCapital1" value="F" tabindex="86" disabled="disabled" readonly="readonly" /> <label for="ultimoDPC">&Uacute;ltimo d&iacute;a del mes</label>&nbsp; <input type="radio" id="diaPagoCapital2" name="diaPagoCapital2" value="A" tabindex="87" disabled="disabled" readonly="readonly" /> <label for="diaMesDPC">D&iacute;a del mes</label> <form:input type="hidden" id="diaPagoCapital" name="diaPagoCapital" path="diaPagoCapital" size="8"
											tabindex="88" /></td>
									<td class="separador"></td>
								</tr>
								<tr>
									<td class="label"><label for="DiaMes">D&iacute;a del mes: </label></td>
									<td><form:input id="diaMesInteres" name="diaMesInteres" path="diaMesInteres" size="6" tabindex="43" readonly="true" disabled="true" /></td>
									<td class="separador"></td>
									<td class="label"><label for="DiaMes">D&iacute;a del mes: </label></td>
									<td><form:input id="diaMesCapital" name="diaMesCapital" path="diaMesCapital" size="6" tabindex="44" readonly="true" disabled="true" /></td>
								</tr>
								<tr>
									<td class="label"><label for="numAmort">N&uacute;mero de Cuotas:</label></td>
									<td><form:input id="numAmortInteres" name="numAmortInteres" path="numAmortInteres" size="8" tabindex="49" disabled="true" /></td>
									<td class="separador"></td>
									<td class="label"><label for="numAmort">N&uacute;mero de Cuotas:</label></td>
									<td><form:input id="numAmortizacion" name="numAmortizacion" path="numAmortizacion" size="8" tabindex="50" disabled="true" /></td>
								</tr>
								<tr class="ocultarSeguros">
									<td></td>
									<td></td>
									<td></td>
									<td class="label"><label>Monto Seguro Cuota:</label></td>
									<td><form:input type="text" name="montoSeguroCuota" id="montoSeguroCuota" path="montoSeguroCuota" size="8" disabled="true" /></td>
								</tr>
								<tr>
									<td><input type="hidden" id="montosCapital" name="montosCapital" size="100" readonly="true" disabled="true" /></td>
								</tr>
							</table>
						</fieldset>
						<table>
							<tr>
								<td class="label"><label for="lblMontoCuota">Monto Cuota:</label></td>
								<td><form:input id="montoCuota" name="montoCuota" path="montoCuota" size="18" tabindex="59" disabled="true" esMoneda="true" style="text-align: right;" /></td>
								<td class="separador"></td>
								<td class="label"><label for="CAT">CAT:</label></td>
								<td><form:input id="cat" name="cat" path="cat" size="8" tabindex="51" disabled="true" style="text-align: right;" /> <label for="lblPorc"> %</label></td>
							</tr>
						</table>
					</fieldset>
				</div>
				<div>
				<table style="width: 100%">
				<tr>
				<td style="text-align: right;"><button type="button" class="submit" id="simular" style="display: none;">Simular</button></td>
				</tr>
				</table>
				</div>
				<div id="gridAmortizacion" style="display: none;"></div>
				<div id="contenedorSimuladorLibre" style="overflow: scroll; width: 100%; height: 300px; display: none;"></div>
				<br> <br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Origen Recursos</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label"><label for="FactorMora">Tipo de Fondeo: </label></td>
							<td><input type="radio" id="tipoFondeo" name="tipoFondeo" path="tipoFondeo" value="P" tabindex="99" checked="checked" /> <label for="recProp">Recursos Propios</label> <input type="radio" id="tipoFondeo2" name="tipoFondeo" path="tipoFondeo" value="F" tabindex="100" /> <label for="insFondeo">Inst. Fondeo</label></td>
							<td class="separador"></td>
							<td class="label"><label for="lblInstitucion">Inst. Fondeo: </label></td>
							<td><form:input id="institFondeoID" name="institFondeoID" path="institFondeoID" size="12" tabindex="101" disabled="true" /> <input type="text" id="descripFondeo" name="descripFondeo" size="45" disabled="true" /></td>
						</tr>
						<tr>
							<td class="label"><label for="lblLineaFondeo">L&iacute;nea de Fondeo: </label></td>
							<td><form:input id="lineaFondeo" name="lineaFondeo" path="lineaFondeo" size="12" tabindex="102" disabled="true" /> <input type="text" id="descripLineaFon" name="descripLineaFon" size="45" disabled="true" /></td>
							<td class="separador"></td>
							<td class="label"><label for="lblSaldoLinea">Saldo de la L&iacute;nea: </label></td>
							<td><input type="text" id="saldoLineaFon" name="saldoLineaFon" size="12" tabindex="103" disabled="true" esMoneda="true" style="text-align: right" /></td>
						</tr>
						<tr>
							<td class="label"><label for="lblTasaPasiva">Tasa Pasiva: </label></td>
							<td><input type="text" id="tasaPasiva" name="tasaPasiva" size="12" tabindex="104" disabled="true" esTasa="true" style="text-align: right" /></td>
							<td class="separador"></td>
							<td class="label"><label for="lblTasaPasiva">Folio Fondeo: </label></td>
							<td><input type="text" id="folioFondeo" name="folioFondeo" size="30" readOnly="true" disabled="disabled" /></td>
						</tr>
					</table>
				</fieldset>
				<br>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td colspan="4" style="text-align: right;" border='0'><input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabIndex="44" />
							<button type="button" class="submit" id="exportarPDF" style="">Imprimir Pagar&eacute;</button>
							<button type="button" class="submit" id="ExptablaAmorti" style="">Tabla de Amortizaci&oacute;n</button>
							<button type="button" class="submit" id="caratula" style="">Car&aacute;tula</button>
							<input type="hidden" id="tipoActualizacion" name="tipoActualizacion" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
							<input type="hidden" id="reca" name="reca" />
							<input type="hidden" id="simuladoNuevamente" name="simuladoNuevamente" value="N" />
							<input type="hidden" id="solicitudCreditoID" name="solicitudCreditoID" />
							<input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>" />
							<form:input id="numTransacSim" name="numTransacSim" path="numTransacSim" size="5" disabled="true" type="hidden" value="0" />
							<form:input id="detalleMinistraAgro" name="detalleMinistraAgro" path="detalleMinistraAgro" type="hidden" value="" />
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
	<div id="mensaje" style="display: none;" />
</body>
</html>
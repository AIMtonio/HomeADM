<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/destinosCredServicio.js"></script>
<script type="text/javascript" src="dwr/interface/calendarioProdServicio.js"></script>
<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
<script type="text/javascript" src="dwr/interface/lineaFonServicio.js"></script>
<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/integraGruposServicio.js"></script>
<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/parentescosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/seguroVidaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/operacionesFechasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/calculosyOperacionesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/esquemaGarantiaLiqServicio.js"></script>
<script type="text/javascript" src="dwr/interface/relacionClienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>
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
<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tiposLineasAgroServicio.js"></script>
<script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>

<script type="text/javascript" src="js/utileria.js"></script>
<script type="text/javascript" src="js/fira/simuladorPagosLibres.js"></script>
<script type="text/javascript" src="js/fira/solicitudCreditoAgro.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="SolicitudCreditoBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Solicitud de Cr&eacute;dito Agropecuario</legend>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<table border="0" style="width: 100%">
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="solicitudCreditoID">Solicitud de Cr&eacute;dito: </label>
							</td>
							<td>
								<form:input type="text" id="solicitudCreditoID" name="solicitudCreditoID" path="solicitudCreditoID" size="12" tabindex="1" autocomplete="false" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="prospectoID">Prospecto: </label>
							</td>
							<td>
								<form:input type="text" id="prospectoID" name="prospectoID" path="prospectoID" size="12" tabindex="2" />
								<input type="text" id="nombreProspecto" name="nombreProspecto" size="50" readonly="true" disabled="disabled" />
							</td>
						</tr>
						<tr>
							<td>
								<label for="clienteID"><s:message code="safilocale.cliente" />: </label>
							</td>
							<td nowrap="nowrap">
								<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="3" />
								<input type="text" id="nombreCte" name="nombreCte" size="50" readonly="true" disabled="disabled" />
							</td>
							<td></td>
							<td class="label" nowrap="nowrap">
								<label for="productoCreditoID">Producto de Cr&eacute;dito: </label>
							</td>
							<td>
								<form:input type="text" id="productoCreditoID" name="productoCreditoID" path="productoCreditoID" size="12" tabindex="4" />
								<input type="text" id="descripProducto" name="descripProducto" size="50" readonly="true" disabled="disabled" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="fechaRegistro">Fecha de Registro: </label>
							</td>
							<td>
								<form:input type="text" id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="12" readOnly="true" disabled="disabled" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="promotorID">Promotor: </label>
							</td>
							<td>
								<form:input type="text" id="promotorID" name="promotorID" path="promotorID" size="12" tabindex="5" />
								<input type="text" id="nombrePromotor" name="nombrePromotor" size="50" readonly="true" disabled="disabled" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="monedaID">Moneda: </label>
							</td>
							<td>
								<form:select id="monedaID" name="monedaID" path="monedaID" tabindex="6" disabled="true" iniForma="false">
									<form:option value="">SELECCIONAR</form:option>
									<form:option value="1">PESOS</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td>
								<label for="estatus">Estatus: </label>
							</td>
							<td>
								<form:select id="estatus" name="estatus" path="estatus" tabindex="7" disabled="true">
									<form:option value="I">INACTIVO</form:option>
									<form:option value="A">AUTORIZADO</form:option>
									<form:option value="C">CANCELADO</form:option>
									<form:option value="R">RECHAZADO</form:option>
									<form:option value="D">DESEMBOLSADO</form:option>
									<form:option value="L">LIBERADA</form:option>
								</form:select>
							</td>
						</tr>
						<tr>
							<td>
								<label for="sucursalCte">Sucursal: </label>
							</td>
							<td>
								<input type="text" id="sucursalCte" name="sucursalCte" size="12" readOnly="true" disabled="disabled" />
								<input type="text" id="nombreSucursal" name="nombreSucursal" size="50" readonly="true" disabled="disabled" />
							</td>
							<td class="separador"></td>
							<td>
								<label for="destinoCreID">Destino Cr&eacute;dito: </label>
							</td>
							<td nowrap="nowrap">
								<form:input type="text" id="destinoCreID" name="destinoCreID" path="destinoCreID" size="12" tabindex="8" />
								<input type="text" id="descripDestino" name="descripDestino" size="50" readonly="true" disabled="disabled" />
							</td>
						</tr>
						<tr>
							<td>
								<label for="destinCredFRID">Destino Cr&eacute;dito FR: </label>
							</td>
							<td nowrap="nowrap">
								<input type="text" id="destinCredFRID" name="destinCredFRID" size="12" readOnly="true" disabled="disabled" />
								<input type="text" id="descripDestinoFR" name="descripcionoDestinFR" size="50" readonly="true" disabled="disabled" />
							</td>
							<td class="separador"></td>
							<td nowrap="nowrap">
								<label for="destinCredFOMURID">Destino Cr&eacute;dito FOMUR: </label>
							</td>
							<td>
								<input type="text" id="destinCredFOMURID" name="destinCredFOMURID" size="12" readonly="true" disabled="disabled" />
								<input type="text" id="descripDestinoFOMUR" name="descripDestinoFOMUR" size="50" readonly="true" disabled="disabled" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="cadenaProductivaID">Cadena Productiva:</label>
							</td>
							<td nowrap="nowrap">
								<form:input type="text" id="cadenaProductivaID" name="cadenaProductivaID" path="cadenaProductivaID" maxlength="11" size="12" tabindex="9" />
								<input type="text" id="descipcionCadenaProductiva" name="descipcionCadenaProductiva" size="50" readonly="true" disabled="disabled" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="ramaFIRAID">Rama FIRA:</label>
							</td>
							<td nowrap="nowrap">
								<form:input type="text" id="ramaFIRAID" name="ramaFIRAID" path="ramaFIRAID" maxlength="11" size="12" tabindex="10" />
								<input type="text" id="descripcionRamaFIRA" size="50" readonly="true" disabled="disabled" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="subramaFIRAID">Subrama FIRA:</label>
							</td>
							<td nowrap="nowrap">
								<form:input type="text" id="subramaFIRAID" name="subramaFIRAID" path="subramaFIRAID" maxlength="11" size="12" tabindex="11" />
								<input type="text" id="descipcionsubramaFIRA" size="50" readonly="true" disabled="disabled" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="actividadFIRAID">Actividad FIRA:</label>
							</td>
							<td nowrap="nowrap">
								<form:input type="text" id="actividadFIRAID" name="actividadFIRAID" path="actividadFIRAID" maxlength="11" size="12" tabindex="12" />
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
								<form:input type="text" id="progEspecialFIRAID" name="progEspecialFIRAID" path="progEspecialFIRAID" maxlength="11" size="12" tabindex="14" />
								<input type="text" id="progEspecialFIRADes" size="50" readonly="true" disabled="disabled" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="clasificacionDestin1">Clasificaci&oacute;n: </label>
							</td>
							<td>
								<input type="radio" id="clasificacionDestin1" name="clasifiDestinCred1" value="C" readonly="true" disabled="true" />
								<label for="lblcomercial">Comercial</label>
								<input type="radio" id="clasificacionDestin2" name="clasifiDestinCred1" value="O" readonly="true" disabled="true" />
								<label for="lblConsumo">Consumo</label>
								<input type="radio" id="clasificacionDestin3" name="clasifiDestinCred1" value="H" readonly="true" disabled="true" />
								<label for="lblHipotecario">Vivienda</label>
								<input type="hidden" id="clasifiDestinCred" name="clasifiDestinCred" size="50" tabindex="15" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="proyecto">Proyecto: </label>
							</td>
							<td>
								<textarea id="proyecto" name="proyecto" path="proyecto" tabindex="16" cols="60" rows="4" onBlur=" ponerMayusculas(this);" maxlength="500"></textarea>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="calcInter"> Ciclo <s:message code="safilocale.cliente" />:
								</label>
							</td>
							<td>
								<form:input type="text" id="numCreditos" name="numCreditos" path="numCreditos" size="15" readOnly="true" disabled="disabled" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="calificaCredito">Calificaci&oacute;n: </label>
							</td>
							<td>
								<input type="text" id="calificaCredito" name="calificaCredito" size="15" readOnly="true" disabled="disabled" />
							</td>
						</tr>
						<tr>
							<td class="label" id="lbciclos"><label for="calcInter">Ciclo Promedio Grupal:</label></td>
							<td id="lbcicloscaja">
								<input type="text" id="cicloClienteGrupal" name="cicloClienteGrupal" readOnly="true" disabled="disabled" size="15">
								<form:input type="hidden" id="esGrupal" name="esGrupal" path="esGrupal" size="6" />
								<form:input type="hidden" id="tasaPonderaGru" name="tasaPonderaGru" path="tasaPonderaGru" size="6" />
							</td>
						</tr>
						<tr>
							<td>
								<label for="horarioVeri">Horario Verificaci&oacute;n:</label>
							</td>
							<td>
								<form:input type="text" id="horarioVeri" name="horarioVeri" path="horarioVeri" maxlength="20" size="15" tabindex="17" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="tipoSolCredito">Tipo Cr&eacute;dito:</label>
							</td>
							<td>
								<input type="text" id="tipoSolCredito" name="tipoSolCredito" size="15" value="NUEVO" iniForma="false" disabled="true" />
								<input type="hidden" id="tipoCredito" name="tipoCredito" value="N" iniForma="false" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblTipoConsultaSIC">Tipo Consulta SIC: </label>
							</td>
							<td>
								<input type="radio" id="tipoConsultaSICBuro" name="tipoConSIC" value="B" tabindex="18" />
								<label for="lblcomercial">Buró Crédito</label>
								<input type="radio" id="tipoConsultaSICCirculo" name="tipoConSIC" value="C" tabindex="19" />
								<label for="lblConsumo">Círculo Crédito</label>
								<input type="hidden" id="tipoConsultaSIC" name="tipoConsultaSIC" size="20" />
							</td>
						</tr>
						<tr id="consultaBuro">
							<td>
								<label for="lbconsultaSICB">Folio Consulta Buró:</label>
							</td>
							<td>
								<input type="text" id="folioConsultaBC" name="folioConsultaBC" path="folioConsultaBC" size="15" tabindex="20" maxlength="30" />
							</td>
							<td class="separador"></td>
						</tr>
						<tr id="consultaCirculo">
							<td>
								<label for="lbconsultaSICC">Folio Consulta Círculo:</label>
							</td>
							<td>
								<input type="text" id="folioConsultaCC" name="folioConsultaCC" path="folioConsultaCC" size="15" tabindex="21" maxlength="30" />
							</td>
							<td class="separador"></td>
						</tr>
					</table>
				</fieldset>
				<div id="grupoDiv">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Grupos </legend>
						<table table border="0" width="100%">
							<tr>
								<td class="label"><label for="lblGrupo">Grupo: </label></td>
								<td><form:input type="text" id="grupoID" name="grupoID" path="grupoID" size="10" tabindex="22" iniForma="false" readonly="true" disabled="disabled" /> <input type="text" id="nombreGr" name="nombreGr" size="40" tabindex="23" disabled="true" /></td>
								<td class="separador"></td>
								<td class="label"><label for="lbl">Tipo Integrante: </label></td>
								<td><form:select id="tipoIntegrante" name="tipoIntegrante" path="tipoIntegrante" tabindex="24">
										<form:option value="" selected="true">SELECCIONA</form:option>
										<form:option value="1">PRESIDENTE </form:option>
										<form:option value="2">TESORERO</form:option>
										<form:option value="3">SECRETARIO </form:option>
										<form:option value="4">INTEGRANTE</form:option>
									</form:select></td>
							</tr>
						</table>
					</fieldset>
				</div>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Condiciones</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label">
								<label for="montoSolici">Monto Solicitado: </label>
							</td>
							<td>
								<form:input type="text" id="montoSolici" name="montoSolici" path="montoSolici" size="18" tabindex="25" esMoneda="true" style="text-align: right;" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="montoAutorizado">Monto Autorizado: </label>
							</td>
							<td>
								<form:input type="text" id="montoAutorizado" name="montoAutorizado" path="montoAutorizado" size="18" esMoneda="true" readOnly="true" disabled="disabled" style="text-align: right;" tabindex="26" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="fechaInicio">Fecha de Inicio: </label>
							</td>
							<td>
								<form:input type="text" id="fechaInicio" name="fechaInicio" size="18" path="fechaInicio" readOnly="true" tabindex="27" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="fechaInicioAmor">Fecha Inicio de Primer Amortizaci&oacute;n: </label>
							</td>
							<td>
								<form:input type="text" id="fechaInicioAmor" name="fechaInicioAmor" size="18" readOnly="true" path="fechaInicioAmor" tabindex="28" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="plazoID">Plazo: </label>
							</td>
							<td>
								<form:select id="plazoID" name="plazoID" path="plazoID" tabindex="29">
									<form:option value="0">SELECCIONAR</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="fechaVencimiento">Fecha de Vencimiento: </label>
							</td>
							<td>
								<form:input type="text" id="fechaVencimiento" name="fechaVencimiento" size="18" path="fechaVencimiento" readOnly="true" disabled="disabled" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="factorMora">Factor Mora: </label>
							</td>
							<td>
								<input type="text" id="factorMora" name="factorMora" path="factorMora" size="18" readOnly="true" disabled="disabled" esTasa="true" />
								<label id="lblveces" for="lblveces">veces la tasa de inter&eacute;s ordinaria</label> <label id="lblTasaFija" for="lblTasaFija">Tasa Fija Anualizada</label>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="formaComApertura">Forma Cobro Com. por Apertura: </label>
							</td>
							<td nowrap="nowrap">
								<input type="text" id="formaComApertura" name="formaComApertura" readOnly="true" disabled="disabled" size="18" />
								<form:input type="hidden" id="forCobroComAper" name="forCobroComAper" path="forCobroComAper" readonly="true" disabled="disabled" size="18" tabindex="30" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="montoComApert">Comisi&oacute;n por apertura: </label>
							</td>
							<td>
								<form:input type="text" id="montoComApert" name="montoComApert" path="montoComApert" size="18" esMoneda="true" readOnly="true" disabled="disabled" style="text-align: right;" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="ivaComApert">IVA Comisi&oacute;n: </label>
							</td>
							<td>
								<form:input type="text" id="ivaComApert" name="ivaComApert" path="ivaComApert" esMoneda="true" readOnly="true" disabled="disabled" size="18" style="text-align: right;" />
								<input type="hidden" id="pagaIVACte" name="pagaIVACte" tabindex="31" disabled="true" size="5" />
								<input type="hidden" id="sucursalID" name="sucursalID" tabindex="32" disabled="true" size="5" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="tipoDispersion">Tipo de Dispersi&oacute;n: </label>
							</td>
							<td>
								<select id="tipoDispersion" name="tipoDispersion" path="tipoDispersion" tabindex="33">
									<option value="">SELECCIONAR</option>
								</select>
							</td>
						</tr>
						<tr>
							<td>
								<label for="cuentaCLABE">Cuenta CLABE: </label>
							</td>
							<td>
								<form:input type="text" id="cuentaCLABE" name="cuentaCLABE" path="cuentaCLABE" size="18" tabindex="34" disabled="true" numMax="18" maxlength="18" />
							</td>
							<td class="separador"></td>
							<td>
								<label for="porcGarLiq">Garant&iacute;a L&iacute;quida: </label>
							</td>
							<td>
								<form:input type="text" id="porcGarLiq" name="porcGarLiq" path="porcGarLiq" size="18" style="text-align: right;" readOnly="true" disabled="disabled"  tabindex="35"/>
								<label for="lblAporte">% &nbsp;</label>
								<form:input type="text" id="aporteCliente" name="aporteCliente" path="aporteCliente" esMoneda="true" size="18" readOnly="true" disabled="disabled" style="text-align: right;"  tabindex="36" />
								<input type="hidden" id="porcentaje" name="porcentaje" size="10" tabindex="37" />
								<form:input type="hidden" id="seguroVidaID" name="seguroVidaID" size="10" path="seguroVidaID" />
							</td>
						</tr>
					</table>
				</fieldset>
				<div id="seguroVidaDiv" style="display: none">
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Seguro de Vida</legend>
						<table border="0" width="100%">
							<tr>
								<td class="label">
									<label for="reqSeguroVidaSi">Seguro de Vida:</label>
								</td>
								<td nowrap="nowrap">
									<input type="radio" id="reqSeguroVidaSi" name="reqSeguroVidaSi" disabled="true" value="S" tabindex="38" />
									<label for="si">Si</label>
									<input type="radio" id="reqSeguroVidaNo" name="reqSeguroVidaNo" disabled="true" value="N" tabindex="39" />
									<label for="si">No</label>
									<form:input type="hidden" id="reqSeguroVida" name="reqSeguroVida" path="reqSeguroVida" size="10" tabindex="40" />
								</td>
								<td class="separador"></td>
								<td class="label" id="tipPago">
									<label for="Moneda">Tipo de Pago:</label>
								</td>
								<td id="tipoPagoSelect2">
									<select id="tipPago" name="tipPago" tabindex="41">
										<option value="">SELECCIONAR</option>
									</select>
								</td>
							</tr>
							<tr id="trMontoSeguroVida">
								<td class="label">
									<label for="montoSeguroVida">Monto Seguro Vida:</label>
								</td>
								<td>
									<form:input type="text" id="montoSeguroVida" name="montoSeguroVida" path="montoSeguroVida" esMoneda="true" disabled="true" size="18" style="text-align: right;" tabindex="42" />
									<form:input type="hidden" id="factorRiesgoSeguro" name="factorRiesgoSeguro" path="factorRiesgoSeguro" seisDecimales="true" size="12" tabindex="43" />
								</td>
								<td class="separador"></td>
								<td class="label">
									<label id="ltipoPago" for="Moneda">Tipo de Pago:</label>
								</td>
								<td>
									<input type="text" id="tipoPagoSeguro" name="tipoPagoSeguro" tabindex="44" disabled="true">
									<form:input type="hidden" id="forCobroSegVida" name="forCobroSegVida" path="forCobroSegVida"/>
									<form:input type="hidden" id="montoPolSegVida" name="montoPolSegVida" path="montoPolSegVida"/>
									<form:input type="hidden" id="descuentoSeguro" name="descuentoSeguro" path="descuentoSeguro"/>
									<input type="hidden" id="noDias" name="noDias" path="noDias">
									<input type="hidden" id="montoSegOriginal" name="montoSegOriginal" path="montoSegOriginal" esMoneda="true">
									<input type="hidden" id="esquemaSeguroID" name="esquemaSeguroID">
									<input type="hidden" id="auxTipPago" name="auxTipPago">
								</td>
							</tr>
							<tr id="trBeneficiario">
								<td class="label">
									<label for="beneficiario">Beneficiario:</label>
								</td>
								<td>
									<form:input type="text" id="beneficiario" name="beneficiario" path="beneficiario" size="42" tabindex="45" onblur=" ponerMayusculas(this)" maxlength="200" />
								</td>
								<td class="separador"></td>
								<td>
									<label for="parentescoID">Parentesco:</label>
								</td>
								<td>
									<form:input type="text" id="parentescoID" name="parentescoID" path="parentescoID" size="18" tabindex="46" />
									<input type="text" id="parentesco" name="parentesco" size="30" readonly="true" disabled="true"/>
								</td>
							</tr>
							<tr id="trParentesco">
								<td class="label">
									<label for="direccionBen">Direcci&oacute;n:</label>
								</td>
								<td>
									<form:textarea id="direccionBen" name="direccionBen" path="direccionBen" size="45" tabindex="47" COLS="38" ROWS="2" onblur=" ponerMayusculas(this)" maxlength="300" />
								</td>
							</tr>
						</table>
					</fieldset>
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
								<form:input type="text" id="lineaCreditoID" name="lineaCreditoID" path="lineaCreditoID" size="15" tabindex="48" numMax ="12" />
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
								<form:select id="manejaComAdmon" name="manejaComAdmon" path="manejaComAdmon" tabindex="50">
									<form:option value="">SELECCIONAR</form:option>
									<form:option value="S">SI</form:option>
									<form:option value="N">NO</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label  for="lblComAdmonLinPrevLiq">Prev. Liquidada</label>
							</td>
							<td nowrap="nowrap">
								<form:input class="check" type="checkbox" id="comAdmonLinPrevLiq" name="comAdmonLinPrevLiq" path="comAdmonLinPrevLiq" tabindex="51"/>
							</td>
						</tr>
						<tr id ="cobroComAdmon">
							<td class="label">
								<label for="lblForPagComAdmon">Tipo de Cobro: </label>
							</td>
							<td>
								<form:select id="forPagComAdmon" name="forPagComAdmon" path="forPagComAdmon" tabindex="52">
									<form:option value="">SELECCIONAR</form:option>
									<form:option value="D">DEDUCCI&Oacute;N</form:option>
									<form:option value="F">FINANCIADO</form:option>
								</form:select>
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
								<form:select id="manejaComGarantia" name="manejaComGarantia" path="manejaComGarantia" tabindex="55">
									<form:option value="">SELECCIONAR</form:option>
									<form:option value="S">SI</form:option>
									<form:option value="N">NO</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label  for="lblComGarLinPrevLiq">Prev. Liquidada</label>
							</td>
							<td nowrap="nowrap">
								<form:input class="check" type="checkbox" id="comGarLinPrevLiq" name="comGarLinPrevLiq" path="comGarLinPrevLiq" tabindex="56"/>
							</td>
						</tr>
						<tr id ="cobroComGarantia">
							<td class="label">
								<label for="lblForPagComGarantia">Tipo de Cobro: </label>
							</td>
							<td>
								<form:select id="forPagComGarantia" name="forPagComGarantia" path="forPagComGarantia" tabindex="57">
									<form:option value="">SELECCIONAR</form:option>
									<form:option value="D">DEDUCCI&Oacute;N</form:option>
								</form:select>
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
					<table border="0" width="100%">
						<tr>
							<td class="label">
								<label for="tipoCalInteres">Tipo Cal. Inter&eacute;s : </label>
							</td>
							<td>
								<form:select id="tipoCalInteres" name="tipoCalInteres" path="tipoCalInteres" tabindex="60" disabled="true">
									<form:option value="">SELECCIONAR</form:option>
									<form:option value="1">SALDOS INSOLUTOS</form:option>
									<form:option value="2">MONTO ORIGINAL</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="calcInteresID">C&aacute;lculo de Inter&eacute;s : </label>
							</td>
							<td>
								<form:select id="calcInteresID" name="calcInteresID" path="calcInteresID" tabindex="61" disabled="true">
									<form:option value="">SELECCIONAR</form:option>
								</form:select>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="tasaBase">Tasa Base: </label>
							</td>
							<td>
								<input type="text" id="tasaBase" name="tasaBase" path="tasaBase" size="18" tabindex="62" />
								<input type="text" id="desTasaBase" name="desTasaBase" size="25" readonly="true" disabled="true"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="tasaFija">Tasa Fija Anualizada</label>
							</td>
							<td>
								<input type="text" id="tasaFija" name="tasaFija" path="tasaFija" size="18" tabindex="63" esTasa="true" disabled="true" style="text-align: right;" />
								<label for="porcentaje">%</label>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="sobreTasa">SobreTasa: </label>
							</td>
							<td>
								<input type="text" id="sobreTasa" name="sobreTasa" path="sobreTasa" size="18" esTasa="true" tabindex="64" style="text-align: right;" />
								<label for="porcentaje">%</label>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="pisoTasa">Piso Tasa: </label>
							</td>
							<td>
								<input type="text" id="pisoTasa" name="pisoTasa" path="pisoTasa" size="18" style="text-align: right;" esTasa="true" tabindex="65" />
								<label for="porcentaje">%</label>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="techoTasa">Techo Tasa: </label>
							</td>
							<td>
								<input type="text" id="techoTasa" name="techoTasa" path="techoTasa" size="18" style="text-align: right;" esTasa="true" tabindex="66" />
								<label for="porcentaje">%</label>
							</td>
							<td class="separador"></td>
						</tr>
					</table>
				</fieldset>
				<br>
				<div id='gridMinistraCredAgro'></div>
				<br>
				<div style="display: none">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Calendario de Pagos</legend>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<table border="0" width="100%" style="display: none;">
								<tr>
									<td class="label" colspan="3">
										<label for="fechInhabil1">En Fecha Inh&aacute;bil Tomar: </label>
									</td>
									<td class="label" colspan="2">
										<input type="radio" id="fechInhabil1" name="fechInhabil1" value="S" tabindex="67" checked="checked" />
										<label for="siguiente">D&iacute;a H&aacute;bil Siguiente</label>&nbsp;
										<input type="radio" id="fechInhabil2" name="fechInhabil2" value="A" tabindex="67" />
										<label for="anterior">D&iacute;a H&aacute;bil Anterior</label>
										<form:input type="hidden" id="fechInhabil" name="fechInhabil" path="fechInhabil" size="15" tabindex="266" readonly="true" disabled="disabled" />
									</td>
								</tr>
								<tr>
									<td class="label" colspan="5">
										<form:input type="hidden" id="ajusFecExiVen" name="ajusFecExiVen" path="ajusFecExiVen" size="15" readonly="true" disabled="disabled" value="N" />
										<form:input type="hidden" id="ajFecUlAmoVen" name="ajFecUlAmoVen" path="ajFecUlAmoVen" size="15" readonly="true" disabled="disabled" />
										<input type="checkbox" id="calendIrregularCheck" name="calendIrregularCheck" value="S" disabled="disabled" />
										<form:input type="hidden" id="calendIrregular" name="calendIrregular" path="calendIrregular" readonly="true" disabled="disabled" value="S" tabindex="73" />
										<label for="calendarioIrreg">Calendario Irregular </label>
									</td>
								</tr>
								<tr style="display: none">
									<td class="label" colspan="3">
										<label for="tipoPagoCapital">Tipo de Pago de Capital: </label>
									</td>
									<td>
										<select id="tipoPagoCapital" name="tipoPagoCapital" path="tipoPagoCapital" tabindex="268">
											<option value="">SELECCIONAR</option>
											<option value="L">LIBRES</option>
										</select>
										<input type="hidden" id="perIgual" name="perIgual" size="5" tabindex="269" />
									</td>
								</tr>
								<tr style="display: none">
									<td class="label" colspan="3">
										<label for="mostrarSeguroCuota">Cobra Seguro Cuota:</label>
									</td>
									<td>
										<input type="hidden" id="mostrarSeguroCuota" name="mostrarSeguroCuota" />
										<form:select name="cobraSeguroCuota" id="cobraSeguroCuota" disabled="true" path="cobraSeguroCuota">
											<option value="N">NO</option>
											<option value="S">SI</option>
										</form:select>
									</td>
								</tr>
								<tr style="display: none">
									<td class="label" colspan="3">
										<label for="cobraIVASeguroCuota">Cobra IVA Seguro Cuota:</label>
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
						<br>
						<fieldset class="ui-widget ui-widget-content ui-corner-all" style="display: none">
							<table border="0" width="100%">
								<tr style="display: none">
									<td class="label" colspan="2">Inter&eacute;s</td>
									<td class="separador"></td>
									<td class="label" colspan="2">Capital</td>
								</tr>
								<tr style="display: none">
									<td class="label">
										<label for="frecuenciaInt">Frecuencia: </label>
									</td>
									<td>
										<select id="frecuenciaInt" name="frecuenciaInt" path="frecuenciaInt" tabindex="270">
											<option value="L" selected="selected">LIBRE</option>
										</select>
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="frecuenciaCap">Frecuencia: </label>
									</td>
									<td>
										<select id="frecuenciaCap" name="frecuenciaCap" path="frecuenciaCap" tabindex="271">
											<option value="L">LIBRE</option>
										</select>
									</td>
								</tr>
								<tr style="display: none">
									<td class="label">
										<label for="periodicidadInt">Periodicidad de Inter&eacute;s:</label>
									</td>
									<td>
										<form:input type="text" id="periodicidadInt" name="periodicidadInt" path="periodicidadInt" size="18" readonly="true" disabled="disabled" />
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="periodicidadCap">Periodicidad de Capital:</label>
									</td>
									<td>
										<form:input type="text" id="periodicidadCap" name="periodicidadCap" path="periodicidadCap" size="18" readonly="true" disabled="disabled" />
									</td>
								</tr>
								<tr style="display: none">
									<td class="label">
										<label for="diaPagoInteres1">D&iacute;a Pago: </label>
									</td>
									<td nowrap="nowrap">
										<input type="radio" id="diaPagoInteres1" name="diaPagoInteres1" value="F" tabindex="273" />
										<label for="diaPagoInteres1">&Uacute;ltimo d&iacute;a del mes</label>
										<input type="radio" id="diaPagoInteres2" name="diaPagoInteres2" value="A" tabindex="274" />
										<label for="diaPagoInteres2" id="lblDiaPagoCap">D&iacute;a del mes</label>
										<form:input type="hidden" id="diaPagoInteres" name="diaPagoInteres" path="diaPagoInteres" size="18" tabindex="275" value="F" />
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="diaPagoCapital1">D&iacute;a Pago: </label>
									</td>
									<td nowrap="nowrap">
										<input type="radio" id="diaPagoCapital1" name="diaPagoCapital1" value="F" tabindex="276" />
										<label for="diaPagoCapital1">&Uacute;ltimo d&iacute;a del mes</label>&nbsp;
										<input type="radio" id="diaPagoCapital2" name="diaPagoCapital2" path="diaPagoCapital" value="A" tabindex="277" />
										<label for="diaPagoCapital2" id="lblDiaPagoCap">D&iacute;a del mes</label>
										<form:input type="hidden" id="diaPagoCapital" name="diaPagoCapital" path="diaPagoCapital" size="18" tabindex="278" />
										<input type="hidden" id="diaPagoProd" name="diaPagoProd" size="8" />
									</td>
								</tr>
								<tr style="display: none">
									<td class="label">
										<label for="diaMesInteres">D&iacute;a del mes: </label>
									</td>
									<td>
										<form:input type="text" id="diaMesInteres" name="diaMesInteres" path="diaMesInteres" size="18" tabindex="279" disabled="true" readonly="true" />
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="diaMesCapital">D&iacute;a del mes: </label>
									</td>
									<td>
										<form:input type="text" id="diaMesCapital" name="diaMesCapital" path="diaMesCapital" size="18" tabindex="280" />
									</td>
								</tr>
								<tr style="display: none">
									<td class="label">
										<label for="numAmortInteres">N&uacute;mero de Cuotas:</label>
									</td>
									<td>
										<form:input type="text" id="numAmortInteres" name="numAmortInteres" path="numAmortInteres" size="18" tabindex="281" />
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="numAmortizacion">N&uacute;mero de Cuotas:</label>
									</td>
									<td>
										<form:input type="text" id="numAmortizacion" name="numAmortizacion" path="numAmortizacion" size="18" tabindex="282" />
										<input id="montosCapital" name="montosCapital" size="100" type="hidden"/>
									</td>
								</tr>
								<tr style="display: none">
									<td class="label">
										<label for="montoCuota">Monto Cuota:</label>
									</td>
									<td>
										<form:input type="text" id="montoCuota" name="montoCuota" path="montoCuota" size="18" esMoneda="true" style="text-align: right;" readonly="true" disabled="disabled" />
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="CAT">CAT:</label>
									</td>
									<td>
										<input type="text" id="CAT" name="CAT" path="CAT" size="18" readonly="readonly" disabled="disabled" esTasa="true" style="text-align: right;" />
										<label for="lblPorc"> %</label>
										<input id="numTransacSim" name="numTransacSim" path="numTransacSim" size="5" tabindex="283" disabled="true" type="hidden" value="0" readonly="true" disabled="disabled" />
									</td>
								</tr>
								<tr style="display: none">
									<td></td>
									<td></td>
									<td></td>
									<td class="label">
										<label for="montoSeguroCuota">Monto Seguro Cuota:</label>
									</td>
									<td>
										<form:input type="text" name="montoSeguroCuota" id="montoSeguroCuota" path="montoSeguroCuota" size="18" disabled="true" style="text-align: right;" />
									</td>
								</tr>
							</table>
						</fieldset>
					</fieldset>
				</div>
				<table border="0" width="100%">
					<tr>
						<td colspan="5" align="right">
							<input type="button" id="simular" name="simular" class="submit" value="Simular" tabindex="284" />
						</td>
					</tr>
				</table>
				<div id="contenedorSimulador" style="display: none;"></div>
				<div id="contenedorSimuladorLibre" style="overflow: scroll; width: 100%; height: 300px; display: none;"></div>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Origen Recursos</legend>
					<table border="0" width="100%">
						<tr>
							<td nowrap="nowrap" colspan="2">
								<input type="radio" id="tipoFondeo" name="tipoFondeo" path="tipoFondeo" value="P" tabindex="300" checked="checked" />
								<label for="recProp">Rec Propios</label>
								<input type="radio" id="tipoFondeo2" name="tipoFondeo" path="tipoFondeo" value="F" tabindex="301" />
								<label for="insFondeo">Inst. Fondeo</label>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="institutFondID">Inst. Fondeo: </label>
							</td>
							<td>
								<form:input type="text" id="institutFondID" name="institutFondID" path="institutFondID" size="18" readOnly="true" disabled="disabled" />
								<input type="text" id="descripFondeo" name="descripFondeo" size="45" readOnly="true" disabled="disabled" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lineaFondeoID">L&iacute;nea de Fondeo: </label>
							</td>
							<td>
								<form:input type="text" id="lineaFondeoID" name="lineaFondeoID" path="lineaFondeoID" size="18" tabindex="302" disabled="true" />
								<input type="text" id="descripLineaFon" name="descripLineaFon" size="45" readOnly="true" disabled="disabled" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="saldoLineaFon">Saldo L&iacute;nea: </label>
							</td>
							<td>
								<input type="text" id="saldoLineaFon" name="saldoLineaFon" size="18" readOnly="true" disabled="disabled" esMoneda="true" style="text-align: right;" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="tasaPasiva">Tasa Pasiva: </label>
							</td>
							<td>
								<input type="text" id="tasaPasiva" name="tasaPasiva" size="18" readOnly="true" disabled="disabled" esTasa="true" style="text-align: right;" tabindex="305"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="folioFondeo">Folio Fondeo: </label>
							</td>
							<td>
								<input type="text" id="folioFondeo" name="folioFondeo" size="18" readOnly="true" disabled="disabled" tabindex="306"/>
							</td>
						</tr>
						<tr class="mostrarAcredFIRA" style="display: none">
							<td class="label mostrarAcred">
								<label for="acreditadoIDFIRA">ID de Acreditado: </label>
							</td>
							<td class="mostrarAcred" style="display: none">
								<input type="text" id="acreditadoIDFIRA" name="acreditadoIDFIRA" size="18" maxlength="20" tabindex="307" onkeypress="return ingresaSoloNumeros(event,1,this.id);"/>
							</td>
							<td class="separador mostrarCredS" style="display: none"></td>
							<td class="label mostrarCred" style="display: none">
								<label for="creditoIDFIRA">ID de Cr&eacute;dito: </label>
							</td>
							<td class="mostrarCred" style="display: none">
								<input type="text" id="creditoIDFIRA" name="creditoIDFIRA" size="18" maxlength="20" tabindex="308" onkeypress="return ingresaSoloNumeros(event,1,this.id);"/>
							</td>
						</tr>
					</table>
				</fieldset>
				<table>
					<tr>
						<td>
							<div id="comentariosEjecutivo" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all" style="color: #F00101">
									<legend style="color: #F00101">Historial de Comentarios</legend>
									<table border="0">
										<tr>
											<td>
												<form:textarea id="comentarioEjecutivo" name="comentarioEjecutivo" path="comentarioEjecutivo" tabindex="330" COLS="60" ROWS="4" onBlur=" ponerMayusculas(this);" disabled="true" />
											</td>
										</tr>
									</table>
								</fieldset>
							</div>
						</td>
						<td class="separador" id="separa"></td>
						<td>
							<div id="comentarios" style="display: none;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend>Comentarios</legend>
									<table border="0">
										<tr>
											<td>
												<textarea id="comentario" name="comentario" COLS="60" ROWS="4" onBlur=" ponerMayusculas(this);" maxlength="500" tabindex="331"></textarea>
											</td>
										</tr>
									</table>
								</fieldset>
							</div>
						</td>
					</tr>
				</table>
				<br>
				<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="agregar" name="agregar" class="submit" value="Agregar" tabindex="350" />
							<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="351" />
							<input type="submit" id="liberar" name="liberar" class="submit" value="Liberar" tabindex="352" />
							<input type="hidden" id="tipoActualizacion" name="tipoActualizacion" value="tipoActualizacion" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
							<input type="hidden" id="calificaCliente" name="calificaCliente" path="calificaCliente" />
							<input type="hidden" id="sucursalPromotor" name="sucursalPromotor" />
							<input type="hidden" id="promAtiendeSuc" name="promAtiendeSuc" />
							<input type="hidden" id="pantalla" name="pantalla" />
							<input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>" />
							<form:input id="detalleMinistraAgro" name="detalleMinistraAgro" path="detalleMinistraAgro" type="hidden" value="" />
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<!-- contenedorForma -->
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
	<div id="cajaListaCte" style="display: none; overflow-y: scroll; height: 200px;">
		<div id="elementoListaCte"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
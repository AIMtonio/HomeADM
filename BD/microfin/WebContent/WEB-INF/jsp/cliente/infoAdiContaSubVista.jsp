<?xml version="1.0" encoding="UTF-8"?>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<c:set var="tipoSub" value="${listaResultado[0]}" />
<c:choose>
	<c:when test="${tipoSub == '1'}">
		<div>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Informaci&oacute;n General</legend>
				<table>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="PasivoLargoPlazo">Pasivo a largo plazo:</label>
						</td>
						<td>
							<input id="PasivoLargoPlazo" name="pasivoLargoPlazo" path="pasivoLargoPlazo" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="10" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="PasivoExigible">Pasivo exigible:</label>
						</td>
						<td>
							<input id="PasivoExigible" name="pasivoExigible" path="pasivoExigible" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="11" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="CarteraCredito">Cartera de cr&eacute;dito:</label>
						</td>
						<td>
							<input id="CarteraCredito" name="carteraCredito" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="12" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="utilidaNeta">Utilidad neta:</label>
						</td>
						<td>
							<input id="utilidaNeta" name="utilidaNeta" onblur="calculaROE();" type="text" size="10" esMoneda="true" style="text-align: right;" maxlength="20" value="" tabindex="13" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="ROE">ROE:</label>
						</td>
						<td>
							<input id="ROE" name="ROE" type="text" size="10" maxlength="20"  style="text-align: right;" disabled="disabled" value="" tabindex="14" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="ActivoSujetosRiesgo">Activos sujetos a riesgos:</label>
						</td>
						<td>
							<input id="ActivoSujetosRiesgo" name="activoSujetosRiesgo" path="activoSujetosRiesgo" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="15" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="GastosAdmin">Gastos de admin.:</label>
						</td>
						<td>
							<input id="GastosAdmin" name="gastosAdmin" path="gastosAdmin" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="16" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="IngresosTotales">Ingresos totales:</label>
						</td>
						<td>
							<input id="IngresosTotales" name="ingresosTotales" onblur="calculaMargenFin();" path="ingresosTotales" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="17" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="CarteraVencida">Cartera vencida:</label>
						</td>
						<td>
							<input id="CarteraVencida" name="carteraVencida" path="carteraVencida" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="18" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="MargenFinan">Margen financiero:</label>
						</td>
						<td>
							<input id="margenFinan" name="margenFinan" path="margenFinan" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" disabled="true" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="ActivoProductivos">Activos productivos:</label>
						</td>
						<td>
							<input id="ActivoProductivos" name="activoProductivos" path="activoProductivos" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="19" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="fechaEdoFinan">Fecha estados financieros:</label>
						</td>
						<td>
							<input id="fechaEdoFinan" name="fechaEdoFinan" path="fechaEdoFinan" type="text" size="10" maxlength="6" value="" tabindex="20" onkeypress="return ingresaSoloNumeros(event,1,this.id);" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="CumpleContaGuberna">Cumple conta gubernamental:</label>
						</td>
						<td>
							<select id="CumpleContaGuberna" name="cumpleContaGuberna" tabindex="21">
								<option value="0">SELECCIONAR</option>
								<option value="1">Si cumple</option>
								<option value="2">No cumple</option>
							</select>
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="EmisionTitulos">Emisi&oacute;n de t&iacute;tulos:</label>
						</td>
						<td>
							<select id="EmisionTitulos" name="emisionTitulos" path="emisionTitulos" tabindex="22">
								<option value="0">SELECCIONAR</option>
								<option value="1">Emite t&iacute;tulos y se reconocen en contabilidad</option>
								<option value="2">Emite t&iacute;tulos y se reconocen como transacciones fuera de balance</option>
								<option value="3">No tiene emisiones</option>
							</select>
						</td>
					</tr>
					<tr class="mostrarSi">
						<td nowrap="nowrap" class="label">
							<label for="NumeroLineasNeg">N&uacute;mero de l&iacute;neas de negocio:</label>
						</td>
						<td>
							<input id="NumeroLineasNeg" name="numeroLineasNeg" path="numeroLineasNeg" type="text" size="10" maxlength="20" value="" tabindex="23" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="ProcesoAuditoria">Proceso auditor&iacute;a:</label>
						</td>
						<td>
							<select id="ProcesoAuditoria" name="procesoAuditoria" path="procesoAuditoria" tabindex="24">
								<option value="0">SELECCIONAR</option>
								<option value="1">Auditor&iacute;a interna formalizada</option>
								<option value="2">Auditor&iacute;a interna no formalizada</option>
								<option value="3">No cuenta con proceso de auditor&iacute;a</option>
								<option value="4">No es posible obtener la informaci&oacute;n</option>
							</select>
						</td>
					</tr>
					<tr class="mostrarSi">
						<td nowrap="nowrap" class="label">
							<label for="NivelPoliticas">Nivel de pol&iacute;ticas:</label>
						</td>
						<td>
							<select id="NivelPoliticas" name="nivelPoliticas" path="nivelPoliticas" tabindex="25">
								<option value="0">SELECCIONAR</option>
								<option value="1">Implementa difunde y aplica manuales de pol&iacute;ticas</option>
								<option value="2">Cuenta con manuales de pol&iacute;ticas pero no est&aacute;n implementados.</option>
								<option value="3">No cuenta con manuales de pol&iacute;ticas.</option>
								<option value="4">No es posible obtener la informaci&oacute;n.</option>
							</select>
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="PeriodoAudEdos">Periodo Aud. Edos. Fin:</label>
						</td>
						<td>
							<select id="PeriodosAudEdoFin" name="periodosAudEdoFin" path="periodosAudEdoFin" tabindex="26">
								<option value="0">SELECCIONAR</option>
								<option value="1">Durante m&aacute;s de 2 años consecutivos</option>
								<option value="2">Durante el &uacute;ltimo año</option>
								<option value="3">Nunca han sido auditados</option>
								<option value="4">No es posible obtener la informaci&oacute;n</option>
							</select>
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="eprc">EPRC:</label>
						</td>
						<td>
							<input id="eprc" name="eprc" path="eprc" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="27" />
						</td>
						<td class="separador"></td>
					</tr>
					<tr class="mostrarSi">
						<td nowrap="nowrap" class="label">
							<label for="numFuentes">N&uacute;mero de Fuentes:</label>
						</td>
						<td>
							<select id="numFuentes" name="numFuentes" tabindex="29">
								<option value="0">SELECCIONAR</option>
								<option value="1">Cuenta con financiamiento burs&aacute;til</option>
								<option value="2">Cuenta con fondeo de instituciones financieras y de otros organismos</option>
								<option value="3">Cuenta con ambos: financiamiento  burs&aacute;til y fondeo de	instituciones financieras</option>
								<option value="4">No Cuenta con financiamiento burs&aacute;til ni con fondeo de instituciones financieras</option>
							</select>
						</td>
					</tr>
					<tr class="mostrarSi">
						<td nowrap="nowrap" class="label">
							<label for="saldoAcreditados">Saldo 3 principales acreditados:</label>
						</td>
						<td>
							<input id="saldoAcreditados" name="saldoAcreditados" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="31" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="numConsejerosInd">N&uacute;mero de Consejeros Independientes:</label>
						</td>
						<td>
							<input id="numConsejerosInd" name="numConsejerosInd" type="text" style="text-align: right;" size="10" maxlength="20" value="" onkeypress="return ingresaSoloNumeros(event,1,this.id);" tabindex="32" />
						</td>
					</tr>
					<tr class="mostrarSi">
						<td nowrap="nowrap" class="label">
							<label for="numConsejerosTot">N&uacute;mero de Consejeros Totales:</label>
						</td>
						<td>
							<input id="numConsejerosTot" name="numConsejerosTot" type="text" style="text-align: right;" size="10" maxlength="20" value="" onkeypress="return ingresaSoloNumeros(event,1,this.id);" tabindex="33" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="porcParticipacionAcc">Porcentaje de Participaci&oacute;n del Accionista Mayoritario:</label>
						</td>
						<td>
							<input id="porcParticipacionAcc" name="porcParticipacionAcc" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="34" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="expLaboral">Experiencia Laboral :</label>
						</td>
						<td>
							<input id="expLaboral" name="expLaboral" type="text" style="text-align: right;" size="10" maxlength="20" value="" tabindex="35" onkeypress="return ingresaSoloNumeros(event,1,this.id);" />
						</td>
					</tr>
				</table>
			</fieldset>
		</div>
	</c:when>
	<c:when test="${tipoSub == '2'}">
		<div>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Informaci&oacute;n General</legend>
				<table>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="CarteraCredito">Cartera de cr&eacute;dito:</label>
						</td>
						<td>
							<input id="CarteraCredito" name="carteraCredito" type="text" size="10" maxlength="20" value="" tabindex="27" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="DepositoDeBienes">Dep&oacute;sito de bienes:</label>
						</td>
						<td>
							<input id="DepositoDeBienes" name="depositoDeBienes" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="28" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="FondeoTotal">Fondeo total:</label>
						</td>
						<td>
							<input id="FondeoTotal" name="fondeoTotal" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="30" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="CarteraNeta">Cartera neta:</label>
						</td>
						<td>
							<input id="CarteraNeta" name="carteraNeta" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="31" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="GastosAdmin">Gastos de admin.:</label>
						</td>
						<td>
							<input id="GastosAdmin" name="gastosAdmin" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="32" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="IngresosTotales">Ingresos totales:</label>
						</td>
						<td>
							<input id="IngresosTotales" name="ingresosTotales" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="33" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="utilidaNeta">Utilidad neta:</label>
						</td>
						<td>
							<input id="utilidaNeta" name="utilidaNeta" onblur="calculaROE();" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="34" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="fechaEdoFinan">Fecha estados financieros:</label>
						</td>
						<td>
							<input id="fechaEdoFinan" name="fechaEdoFinan" type="text" size="10" maxlength="6" value="" onkeypress="return ingresaSoloNumeros(event,1,this.id);" tabindex="35" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="ROE">ROE:</label>
						</td>
						<td>
							<input id="ROE" name="ROE" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" disabled="disabled" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="EntidadRegulada">Entidad regulada:</label>
						</td>
						<td>
							<select id="EntidadRegulada" name="entidadRegulada" tabindex="36">
								<option value="0" tabindex="20">SELECCIONAR</option>
								<option value="1">Entidad financiera no bancaria regulada</option>
								<option value="2">Entidad financiera no bancaria no regulada</option>
							</select>
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="EmisionTitulos">Emisi&oacute;n de t&iacute;tulos:</label>
						</td>
						<td>
							<select id="EmisionTitulos" name="emisionTitulos" tabindex="37">
								<option value="0">SELECCIONAR</option>
								<option value="1">Emite t&iacute;tulos y se reconocen en contabilidad:</option>
								<option value="2">Emite t&iacute;tulos y se reconocen como transacciones fuera de balance:</option>
								<option value="3">No tiene emisiones</option>
							</select>
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="numeroEmpleados">N&uacute;mero de empleados:</label>
						</td>
						<td>
							<input id="numeroEmpleados" name="numeroEmpleados" type="text" size="10" maxlength="20" value="" tabindex="38" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="tasaRetLaboral1">Tasa de retenci&oacute;n laboral 1:</label>
						</td>
						<td>
							<input id="tasaRetLaboral1" name="tasaRetLaboral1" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="39" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="tasaRetLaboral2">Tasa de retenci&oacute;n laboral 2:</label>
						</td>
						<td>
							<input id="tasaRetLaboral2" name="tasaRetLaboral2" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="40" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="tasaRetLaboral3">Tasa de retenci&oacute;n laboral 3:</label>
						</td>
						<td>
							<input id="tasaRetLaboral3" name="tasaRetLaboral3" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="41" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="fechaEdoFinanVentasNetas">Fecha estados finan. ventas netas:</label>
						</td>
						<td>
							<input id="fechaEdoFinanVentasNetas" name="fechaEdoFinanVentasNetas" type="text" size="10" maxlength="6" value=""  onkeypress="return ingresaSoloNumeros(event,1,this.id);" tabindex="42" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="ingresosBrutos">Ingresos brutos:</label>
						</td>
						<td>
							<input id="ingresosBrutos" name="ingresosBrutos" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="43" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="anioIngresosBruto">Año ingresos bruto:</label>
						</td>
						<td>
							<input id="anioIngresosBruto" name="anioIngresosBruto" type="text" size="10" maxlength="4" value="" onkeypress="return ingresaSoloNumeros(event,1,this.id);"  tabindex="44" />
						</td>
					</tr>
					<tr class="mostrarSi">
						<td nowrap="nowrap" class="label">
							<label for="NumeroLineasNeg">N&uacute;mero de l&iacute;neas de negocio:</label>
						</td>
						<td>
							<input id="NumeroLineasNeg" name="numeroLineasNeg" path="numeroLineasNeg" type="text" size="10" maxlength="20" value="" tabindex="45" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="numFuentes">N&uacute;mero de Fuentes:</label>
						</td>
						<td>
							<select id="numFuentes" name="numFuentes" tabindex="46">
								<option value="0">SELECCIONAR</option>
								<option value="1">Cuenta con financiamiento burs&aacute;til</option>
								<option value="2">Cuenta con fondeo de instituciones financieras y de otros organismos</option>
								<option value="3">Cuenta con ambos: financiamiento  burs&aacute;til y fondeo de	instituciones financieras</option>
								<option value="4">No Cuenta con financiamiento burs&aacute;til ni con fondeo de instituciones financieras</option>
							</select>
						</td>
					</tr>
					<tr class="mostrarSi">
						<td nowrap="nowrap" class="label">
							<label for="saldoAcreditados">Saldo Principal:</label>
						</td>
						<td>
							<input id="saldoAcreditados" name="saldoAcreditados" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="47" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="numConsejerosInd">N&uacute;mero de Consejeros Independientes:</label>
						</td>
						<td>
							<input id="numConsejerosInd" name="numConsejerosInd" type="text" style="text-align: right;" size="10" maxlength="20" value="" onkeypress="return ingresaSoloNumeros(event,1,this.id);" tabindex="48" />
						</td>
					</tr>
					<tr class="mostrarSi">
						<td nowrap="nowrap" class="label">
							<label for="numConsejerosTot">N&uacute;mero de Consejeros Totales:</label>
						</td>
						<td>
							<input id="numConsejerosTot" name="numConsejerosTot" type="text" style="text-align: right;" size="10" maxlength="20" value="" onkeypress="return ingresaSoloNumeros(event,1,this.id);" tabindex="49" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="porcParticipacionAcc">Porcentaje de Participaci&oacute;n del Consejo de Administraci&oacute;n:</label>
						</td>
						<td>
							<input id="porcParticipacionAcc" name="porcParticipacionAcc" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="50" />
						</td>
					</tr>
					<tr class="mostrarSi">
						<td nowrap="nowrap" class="label">
							<label for="ProcesoAuditoria">Proceso auditor&iacute;a:</label>
						</td>
						<td>
							<select id="ProcesoAuditoria" name="procesoAuditoria" path="procesoAuditoria" tabindex="51">
								<option value="0">SELECCIONAR</option>
								<option value="1">Auditor&iacute;a interna formalizada</option>
								<option value="2">Auditor&iacute;a interna no formalizada</option>
								<option value="3">No cuenta con proceso de auditor&iacute;a</option>
								<option value="4">No es posible obtener la informaci&oacute;n</option>
							</select>
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="expLaboral">Experiencia Laboral :</label>
						</td>
						<td>
							<input id="expLaboral" name="expLaboral" type="text" style="text-align: right;" size="10" maxlength="20" value="" tabindex="52" />
						</td>
					</tr>
					<tr class="mostrarSi">
						<td nowrap="nowrap" class="label">
							<label for="NivelPoliticas">Nivel de pol&iacute;ticas:</label>
						</td>
						<td>
							<select id="NivelPoliticas" name="nivelPoliticas" path="nivelPoliticas" tabindex="53">
								<option value="0">SELECCIONAR</option>
								<option value="1">Implementa difunde y aplica manuales de pol&iacute;ticas</option>
								<option value="2">Cuenta con manuales de pol&iacute;ticas pero no est&aacute;n implementados.</option>
								<option value="3">No cuenta con manuales de pol&iacute;ticas.</option>
								<option value="4">No es posible obtener la informaci&oacute;n.</option>
							</select>
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="PeriodoAudEdos">Periodo Aud. Edos. Fin:</label>
						</td>
						<td>
							<select id="PeriodosAudEdoFin" name="periodosAudEdoFin" path="periodosAudEdoFin" tabindex="54">
								<option value="0">SELECCIONAR</option>
								<option value="1">Durante m&aacute;s de 2 años consecutivos</option>
								<option value="2">Durante el &uacute;ltimo año</option>
								<option value="3">Nunca han sido auditados</option>
								<option value="4">No es posible obtener la informaci&oacute;n</option>
							</select>
						</td>
					</tr>
				</table>
			</fieldset>
		</div>
	</c:when>
	<c:when test="${tipoSub == '3'}">
		<div>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Informaci&oacute;n General</legend>
				<table>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="numeroEmpleados">N&uacute;mero de empleados:</label>
						</td>
						<td>
							<input id="numeroEmpleados" name="numeroEmpleados" type="text" style="text-align: right;" size="10" maxlength="20" value="" tabindex="44" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="tasaRetLaboral1">Tasa de retenci&oacute;n laboral 1:</label>
						</td>
						<td>
							<input id="tasaRetLaboral1" name="tasaRetLaboral1" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="45" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="tasaRetLaboral2">Tasa de retenci&oacute;n laboral 2:</label>
						</td>
						<td>
							<input id="tasaRetLaboral2" name="tasaRetLaboral2" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="46" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="tasaRetLaboral3">Tasa de retenci&oacute;n laboral 3:</label>
						</td>
						<td>
							<input id="tasaRetLaboral3" name="tasaRetLaboral3" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="47" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="ActivoCirculante">Activo circulante</label>
						</td>
						<td>
							<input id="ActivoCirculante" name="activoCirculante" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="48" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="PasivoCirculante">Pasivo circulante:</label>
						</td>
						<td>
							<input id="PasivoCirculante" name="pasivoCirculante" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="49" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="utilidaNeta">Utilidad neta:</label>
						</td>
						<td>
							<input id="utilidaNeta" name="utilidaNeta" onblur="calculaROE();" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="50" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="ROE">ROE:</label>
						</td>
						<td>
							<input id="ROE" name="ROE" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" disabled="disabled" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="fechaEdoFinan">Fecha estados financieros:</label>
						</td>
						<td>
							<input id="fechaEdoFinan" name="fechaEdoFinan" type="text" size="10" maxlength="6" value="" onkeypress="return ingresaSoloNumeros(event,1,this.id);" tabindex="51" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="ingresosBrutos">Ingresos brutos</label>
						</td>
						<td>
							<input id="ingresosBrutos" name="ingresosBrutos" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="52" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="AnioIngresosBruto">Año ingresos bruto:</label>
						</td>
						<td>
							<input id="AnioIngresosBruto" name="anioIngresosBruto" type="text" size="10" maxlength="4" onkeypress="return ingresaSoloNumeros(event,1,this.id);"  value="" tabindex="53" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label" colspan="5">
							<label for="Competencia1">Competencia:</label>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap" colspan="2">
							<input type="radio" id="Competencia1" name="competencia" value="1" checked="checked" tabindex="54" /> <label for="Competencia1">Las caracter&iacute;sticas de la industr&iacute;a reflejan debilidades importantes.</label>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap" colspan="2">
							<input type="radio" id="Competencia2" name="competencia" value="2" tabindex="55" /> <label for="Competencia2">Las caracter&iacute;sticas de la industr&iacute;a reflejan tendencias mixtas en crecimiento.</label>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap" colspan="2">
							<input type="radio" id="Competencia3" name="competencia" value="3" tabindex="56" /> <label for="Competencia3">Las caracter&iacute;sticas de la industr&iacute;a reflejan crecimiento y desempeño sobresaliente.</label>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap" colspan="2">
							<input type="radio" id="Competencia4" name="competencia" value="4" tabindex="57" /> <label for="Competencia4">No cuenta con an&aacute;lisis de la industr&iacute;a con menos de un año de antigüedad.</label>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap" colspan="2">
							<input type="radio" id="Competencia5" name="competencia" value="5" tabindex="58" /> <label for="Competencia5">No fue posible obtener la informaci&oacute;n.</label>
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label" colspan="5">
							<label for="Proveedores1">Porcentaje de las compras totales anuales a los tres principales proveedores:</label>
						</td>
					</tr>
					<tr>
						<td class="label" colspan="5">
							<input type="radio" id="Proveedores1" name="proveedores" path="proveedores" value="1" checked="checked" tabindex="59" />
							 <label for="Proveedores1">Menos del 15%</label> &nbsp;&nbsp;&nbsp;&nbsp;
							 	<input type="radio" id="Proveedores2" name="proveedores" path="proveedores" value="2" tabindex="60" />
							 <label for="Proveedores2">Entre el 15% y el 35%</label> &nbsp;&nbsp;&nbsp;&nbsp;
								  <input type="radio" id="Proveedores3" name="proveedores" path="proveedores" value="3" tabindex="61" />
							<label for="Proveedores3">M&aacute;s del 35%</label> &nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" id="Proveedores4" name="proveedores" path="proveedores" value="4" tabindex="62" />
							<label for="Proveedores4">No fue posible obtenet la informaci&oacute;n</label>
						</td>
					</tr>
					<tr>
						<td class="label" colspan="5">
							<label for="Clientes1">Porcentaje de las ventas totales anuales de la empresa a los tres principales clientes:</label>
						</td>
					</tr>
					<tr>
						<td class="label" colspan="5">
							<input type="radio" id="Clientes1" name="clientes" value="1" tabindex="63" checked="checked" />
								 <label for="Clientes1">Menos del 15%</label> &nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" id="Clientes2" name="clientes" value="2" tabindex="64" />
								<label for="Clientes2">Entre el 15% y el 35%</label> &nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" id="Clientes3" name="clientes" value="3" tabindex="65" />
								<label for="Clientes3">M&aacute;s del 35%</label> &nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" id="Clientes4" name="clientes" value="4" tabindex="66" />
								<label for="Clientes4">No fue posible obtenet la informaci&oacute;n</label>
						</td>
					</tr>
					<tr>
						<td class="label" colspan="5">
							<label for="CalificacionExterna1">Calificaci&oacute;n externa de agencias calificadoras renocidas por la CNBV:</label>
						</td>
					</tr>
					<tr>
						<td class="label" colspan="2">
							<input type="radio" id="CalificacionExterna1" name="calificacionExterna" value="1" tabindex="67" checked="checked" /> <label for="CalificacionExterna1">Cuenta con la calificaci&oacute;n de dos o m&aacute;s agencias calificadoras</label>
						</td>
						<td class="separador"></td>
						<td class="label" colspan="2">
							<input type="radio" id="CalificacionExterna2" name="calificacionExterna" value="2" tabindex="68" /> <label for="CalificacionExterna2">Cuenta con la calificaci&oacute;n de una agencia calificadora</label>
						</td>
					</tr>
					<tr>
						<td class="label">
							<input type="radio" id="CalificacionExterna3" name="calificacionExterna" value="3" tabindex="69" /> <label for="CalificacionExterna3">No cuenta con ninguna calificaci&oacute;n.</label>
						</td>
					</tr>
					<tr>
						<td class="label" colspan="5">
							<label for="ConsejoAdmin1">Porcentaje de participaci&oacute;n del consejo de administraci&oacute;n:</label>
						</td>
					</tr>
					<tr>
						<td class="label" colspan="5">
							<input type="radio" id="ConsejoAdmin1" name="consejoAdmin" value="1" tabindex="70" checked="checked" />
								<label for="ConsejoAdmin1">Menos del 12%</label> &nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" id="ConsejoAdmin2" name="consejoAdmin" value="2" tabindex="71" />
								<label for="ConsejoAdmin2">Entre el 12% y el 15%</label> &nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" id="ConsejoAdmin3" name="consejoAdmin" value="3" tabindex="72" />
								<label for="ConsejoAdmin3">M&aacute;s del 25%</label>&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" id="ConsejoAdmin4" name="consejoAdmin" value="4" tabindex="73" />
								<label for="ConsejoAdmin4">No existen consejeros independientes.</label> &nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" id="ConsejoAdmin5" name="consejoAdmin" value="5" tabindex="74" />
								<label for="ConsejoAdmin5">No fue posible obtener informaci&oacute;n.</label>
						</td>
					</tr>
					<tr>
						<td class="label" colspan="5">
							<label for="EstructOrgan">Estructura organizacional:</label>
						</td>
					</tr>
					<tr>
						<td class="label" colspan="2">
							<input type="radio" id="EstructOrgan1" name="estructOrgan" value="1" tabindex="74" checked="checked" /> <label for="EstructOrgan1">Est&aacute; alineada con los objetivos del negocio y el entorno de control interno es s&oacute;lido</label>
						</td>
						<td class="separador"></td>
						<td class="label" colspan="2">
							<input type="radio" id="EstructOrgan2" name="estructOrgan" value="2" tabindex="75" /> <label for="EstructOrgan2">Se encuentra de alguna manera inconsistente con respecto a los actuales objetivos del negocio</label>
						</td>
					</tr>
					<tr>
						<td class="label" colspan="2">
							<input type="radio" id="EstructOrgan3" name="estructOrgan" value="3" tabindex="76" /> <label for="EstructOrgan3">Existen claras debilidades que ponen en alto riesgo la capacidad de generar flujos de efectivo sostenible</label>
						</td>
						<td class="separador"></td>
						<td class="label" colspan="2">
							<input type="radio" id="EstructOrgan4" name="estructOrgan" value="4" tabindex="77" /> <label for="EstructOrgan4">No fue posible obtener informaci&oacute;n</label>
						</td>
					</tr>
					<tr>
						<td class="label" colspan="5">
							<label for="ComposicionAccionaria1">Respecto a la composici&oacute;n accionar&iacute;a, indica si:</label>
						</td>
					</tr>
					<tr>
						<td class="label" colspan="2">
							<input type="radio" id="ComposicionAccionaria1" name="composicionAccionaria" value="1" tabindex="78" checked="checked" /> <label for="ComposicionAccionaria1">Un solo grupo o persona tiene m&aacute;s del 33% de la tenencia accionaria</label>
						</td>
						<td class="separador"></td>
						<td class="label" colspan="2">
							<input type="radio" id="ComposicionAccionaria2" name="composicionAccionaria" value="2" tabindex="79" /> <label for="ComposicionAccionaria2">Un solo grupo o persona tiene entre el 10% y el 33% de la tenencia accionaria</label>
						</td>
					</tr>
					<tr>
						<td class="label" colspan="2">
							<input type="radio" id="ComposicionAccionaria3" name="composicionAccionaria" value="3" tabindex="80" /> <label for="ComposicionAccionaria3">Un solo grupo o persona tiene menos del 10% de la tenencia accionaria</label>
						</td>
						<td class="separador"></td>
						<td class="label" colspan="2">
							<input type="radio" id="ComposicionAccionaria4" name="composicionAccionaria" value="4" tabindex="81" /> <label for="ComposicionAccionaria4">No fue posible obtener la informaci&oacute;n</label>
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="UtilidaAntesGastosImpues1">Utilidad antes de gastos e impuestos</label>
						</td>
						<td>
							<input id="UtilidaAntesGastosImpues1" name="utilidaAntesGastosImpues" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="82" />
						</td>
						<td class="separador"></td>
						<td nowrap="nowrap" class="label">
							<label for="GastosFinan1">Gastos financieros</label>
						</td>
						<td>
							<input id="GastosFinan1" name="gastosFinan" type="text" esMoneda="true" style="text-align: right;" size="10" maxlength="20" value="" tabindex="83" />
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="PeriodosAudEdoFin1">Periodo Aud. Edos. Fin:</label>
						</td>
						<td>
							<select id="PeriodosAudEdoFin1" name="periodosAudEdoFin" tabindex="84">
								<option value="0" selected="selected">SELECCIONAR</option>
								<option value="1">Durante m&aacute;s de 2 años consecutivos</option>
								<option value="2">Durante el &uacute;ltimo año</option>
								<option value="3">Nunca han sido auditados</option>
								<option value="4">No es posible obtener la informaci&oacute;n</option>
							</select>
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="fechaEdoFinanVentasNetas">Fecha estados finan. ventas netas:</label>
						</td>
						<td>
							<input id="fechaEdoFinanVentasNetas" name="fechaEdoFinanVentasNetas" type="text" size="10" maxlength="6" value="" onkeypress="return ingresaSoloNumeros(event,1,this.id);" tabindex="85" />
						</td>
					</tr>
				</table>
			</fieldset>
		</div>
	</c:when>
</c:choose>
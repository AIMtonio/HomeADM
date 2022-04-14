<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="mensaje" value="${listaResultado[1]}" />
<c:set var="numErr2">${listaResultado[3]}</c:set>
<c:set var="mesErr" value="${listaResultado[4]}" />
<c:set var="var_cobraSeguroCuota" value="${listaResultado[5]}" />
<c:set var="listaResultado" value="${listaResultado[2]}" />
<%!int numFilas = 0;%>
<%!int numTab = 98;%>
<input type="hidden" id="numeroErrorList" name="numeroErrorList" value="${numErr2}" />
<input type="hidden" id="mensajeErrorList" name="mensajeErrorList" value="<c:out value="${mesErr}"/>" />
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Simulador de Amortizaciones</legend>
	<table id="TablaAmortizaLibres" border="0" cellpadding="0" cellspacing="0" width="100%">
		<thead>
			<tr>
				<td class="label" align="center">
					<label>N&uacute;mero</label>
				</td>
				<td class="label" align="center">
					<label>Fecha Inicio</label>
				</td>
				<td class="label" align="center">
					<label>Fecha Vencimiento</label>
				</td>
				<td class="label" align="center">
					<label>Fecha Pago</label>
				</td>
				<td class="label" align="center">
					<label>Capital</label>
				</td>
				<td class="label" align="center">
					<label>Inter&eacute;s</label>
				</td>
				<td class="label" align="center">
					<label>IVA Inter&eacute;s</label>
				</td>
				<c:if test="${var_cobraSeguroCuota == 'S'}">
					<td class="label" align="center">
						<label>Seguro</label>
					</td>
					<td class="label" align="center">
						<label>IVA Seguro</label>
					</td>
				</c:if>
				<td class="label" align="center">
					<label>Total Pago</label>
				</td>
				<td class="label" align="center">
					<label>Saldo Capital</label>
				</td>
				<td class="label" align="center"></td>
			</tr>
		</thead>
		<tbody id="TablaAmortizaLibresBody">
			<c:choose>
				<c:when test="${mensaje.numero == '0'}">
					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
						<tr id="tramor${status.count}">
							<td align="center">
								<input type="text" maxlength="5" size="8" disabled="disabled" id="consecutivoID${status.count}" name="consecutivoID" value="${status.count}" style="text-align: center;">
							</td>
							<td align="center">
								<input type="text" maxlength="10" size="15" disabled="disabled" id="fechaInicio${status.count}" name="fechaInicio" value="${amortizacion.fechaInicio}">
							</td>
							<td align="center" nowrap="nowrap">
								<input type="text" maxlength="10" size="15" escalendario="true" id="fechaVencim${status.count}" name="fechaVencim" value="${amortizacion.fechaVencim}" tabindex="<%=numTab++%>" onchange="cambiarFechaInicioAmor(this.id);validarFechas(false);">
							</td>
							<td align="center">
								<input type="text" maxlength="10" size="15" disabled="disabled" id="fechaExigible${status.count}" name="fechaExigible" value="${amortizacion.fechaExigible}">
							</td>
							<td align="center">
								<input type="text" maxlength="18" size="18" esmoneda="true" id="capital${status.count}" name="capital" tabindex="<%=numTab++%>" style="text-align: right;" value="${amortizacion.capital}" onchange="validaCapital();" onblur="sumaCapitalesAmor()">
							</td>
							<td align="center">
								<input type="text" maxlength="18" size="18" esmoneda="true" disabled="disabled" style="text-align: right;"  id="interes${status.count}" name="interes" value="${amortizacion.interes}">
							</td>
							<td align="center">
								<input type="text" maxlength="18" size="18" esmoneda="true" disabled="disabled" style="text-align: right;"  id="ivaInteres${status.count}" name="ivaInteres" value="${amortizacion.ivaInteres}">
							</td>
							<c:if test="${var_cobraSeguroCuota == 'S'}">
								<td align="center">
									<input type="text" maxlength="18" size="18" esmoneda="true" disabled="disabled" style="text-align: right;"  id="montoSeguro${status.count}" name="montoSeguro" value="${amortizacion.montoSeguroCuota}">
								</td>
								<td align="center">
									<input type="text" maxlength="18" size="18" esmoneda="true" disabled="disabled" style="text-align: right;"  id="montoSeguroIVA${status.count}" name="montoSeguroIVA" value="${amortizacion.iVASeguroCuota}">
								</td>
							</c:if>
							<td align="center">
								<input type="text" maxlength="18" size="18" esmoneda="true" disabled="disabled" style="text-align: right;"  id="totalPago${status.count}" name="totalPago" value="${amortizacion.totalPago}">
							</td>
							<td align="center">
								<input type="text" maxlength="18" size="18" esmoneda="true" disabled="disabled" style="text-align: right;"  id="saldoInsoluto${status.count}" name="saldoInsoluto" value="${amortizacion.saldoInsoluto}">
							</td>
							<td align="center" nowrap="nowrap">
								<input type="button" id="eliminarAmor" name="eliminarAmor" class="btnElimina" tabindex="<%=numTab++%>" onclick="eliminarAmortizacion('tramor${status.count}');">
								<input type="button" id="agregaMinistra" name="agregaAmor" class="btnAgrega" onclick="agregaAmortizacion();" tabindex="<%=numTab++%>">
							</td>
						</tr>
						<c:set var="cuotas7" value="${status.count}" />
						<c:set var="fechaVenc7" value="${amortizacion.fechaVencim}" />
						<c:set var="numTransaccion7" value="${amortizacion.numTransaccion}" />
						<c:set var="valorCat3" value="${amortizacion.cat}" />
						<c:set var="valorFecUltAmor3" value="${amortizacion.fecUltAmor}" />
						<c:set var="valorfecInicioAmor3" value="${amortizacion.fecInicioAmor}" />
						<c:set var="valorCuotasCap" value="${amortizacion.cuotasCapital}" />
						<c:set var="valorCuotasInt" value="${amortizacion.cuotasInteres}" />
						<c:set var="varTotalSeguroCuota7" value="${amortizacion.totalSeguroCuota}" />
						<c:set var="varTotalIVASeguroCuota7" value="${amortizacion.totalIVASeguroCuota}" />
						<% numFilas=numFilas+1; %>
					</c:forEach>
				</c:when>
			</c:choose>
		</tbody>
		<tfoot>
			<tr>
				<td colspan="10" align="right">
					<input type="hidden" value="${cuotas7}" name="numeroDetalle" id="numeroDetalle" />
					<input id="transaccion" name="transaccion" size="18" type="hidden" value="${numTransaccion7}" readonly="readonly" disabled="true" />
					<input id="valorCat" name="valorCat" size="18" type="hidden" value="${valorCat3}" readonly="readonly" disabled="true" />
					<input id="valorFecUltAmor" name="valorFecUltAmor" size="18" type="hidden" value="${valorFecUltAmor3}" readonly="readonly" disabled="true" />
					<input id="valorfecInicioAmor" name="valorfecInicioAmor" size="18" type="hidden" value="${valorfecInicioAmor3}" readonly="readonly" disabled="true" />
					<input id="valorCuotasCapital" name="valorCuotasCapital" size="18" type="hidden" value="${valorCuotasCap}" readonly="readonly" disabled="true" />
					<input id="valorCuotasInteres" name="valorCuotasInteres" size="18" type="hidden" value="${valorCuotasInt}" readonly="readonly" disabled="true" />
				</td>
			</tr>
			<tr>
				<td colspan="4" align="right" class="label">
					<label>Totales: </label>
				</td>
				<td align="center">
					<input type="text" size="18" readonly="true" style="text-align: right;" esmoneda="true" disabled="disabled" id="totalCap" name="totalCap" value="">
				</td>
				<td align="center">
					<input id="totalInt" name="totalInt" size="18" disabled="disabled" style="text-align: right;" esMoneda="true" value=""/>
				</td>
				<td align="center">
					<input id="totalIva" name="totalIva" size="18" disabled="disabled" style="text-align: right;" esMoneda="true" value=""/>
				</td>
				<c:if test="${var_cobraSeguroCuota == 'S'}">
					<td align="center">
						<input id="totalSeguroCuota" value="${varTotalSeguroCuota7}" name="totalSeguroCuota" size="18" disabled="disabled" style="text-align: right;" esMoneda="true" />
					</td>
					<td align="center">
						<input id="iVATotalSeguroCuota" value="${varTotalIVASeguroCuota7}" name="iVATotalSeguroCuota" size="18" disabled="disabled" style="text-align: right;" esMoneda="true" />
					</td>
				</c:if>
			</tr>
			<tr>
				<td colspan="4" align="right">
					<label>Diferencia: </label>
				</td>
				<td align="center">
					<input type="text" size="18" readonly="true" style="text-align: right;" esmoneda="true" disabled="true" id="diferenciaCapital" name="diferenciaCapital" value="0.00">
				</td>
			</tr>
			<tr>
				<td colspan="12" align="right">
					<input type="button" class="submit" id="calcular" tabindex="<%=numTab++%>" value="Calcular" onclick="simuladorLibresCapFec();">
					<input type="hidden" id="numTabSimulador" value="<%=numTab%>">
					<input type="hidden" id="numTabMinSimulador" value="98">
					<input type="hidden" id="numFila" value="<%=numFilas %>">
				</td>
				<td>
					<input type="button" id="imprimirRep" class="submit" style="display: none;" value="Imprimir" onclick="generaReporte();">
				</td>
			</tr>
		</tfoot>
	</table>
	<script type="text/javascript">
		$('#numFila').val($('#TablaAmortizaLibresBody tr').size()+1);
	</script>
</fieldset>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="fechaVencimiento" value="${listaResultado[1]}" />
<c:set var="numErr2" value="${listaResultado[3]}" />
<c:set var="mesErr" value="${listaResultado[4]}" />
<c:set var="var_cobraSeguroCuota" value="${listaResultado[5]}" />
<c:set var="cobraAccesorios" value="${listaResultado[6]}"/>
<c:set var="listaResultado" value="${listaResultado[2]}" />

<input type="hidden" id="numeroErrorList" name="numeroErrorList" value="${numErr2}" />
<input type="hidden" id="mensajeErrorList" name="mensajeErrorList" value="<c:out value="${mesErr}"/>" />
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Simulador de Amortizaciones</legend>
	<c:if test="${numErr2 == 0}">
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '3'}">
					<tr>
						<td class="label" align="center"><label for="lblNumero">N&uacute;mero</label></td>
						<td class="label" align="center"><label for="lblFecIni">Fecha Inicio</label></td>
						<td class="label" align="center"><label for="lblFecFin">Fecha Vencimiento</label></td>
						<td class="label" align="center"><label for="lblFecPag">Fecha Pago</label></td>
						<td class="label" align="center"><label for="lblCapital">Capital</label></td>
						<td class="label" align="center"><label for="lblDescripcion">Inter&eacute;s</label></td>
						<c:if test="${var_cobraSeguroCuota == 'S'}">
							<td class="label" align="center"><label for="lblCargos">Seguro</label></td>
							<td class="label" align="center"><label for="lblCargos">IVA Seguro</label></td>
						</c:if>
						<c:if test="${cobraAccesorios == 'S'}">
							<td class="label" align="center"><label for="lblOtrasComisiones">Otras Comisiones</label></td>
							<td class="label" align="center"><label for="lblIVAOtrasComisiones">IVA Otras Comisiones</label></td>
						</c:if>
						<td class="label" align="center"><label for="lblCargos">IVA Seguro</label></td>
						<td class="label" align="center"><label for="lblTotalPag">Total Pago</label></td>
						<td class="label" align="center"><label for="lblSaldoCap">Saldo Capital</label></td>
					</tr>

					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td><input id="amortizacionID${status.count}" name="amortizacionID" size="4" type="text" value="${amortizacion.amortizacionID}" readonly="readonly" disabled="disabled" /></td>
							<td><input id="fechaInicio${status.count}" name="fechaInicioGrid" size="15" type="text" value="${amortizacion.fechaInicio}" readonly="readonly" disabled="disabled" /></td>
							<td><input id="fechaVencim${status.count}" name="fechaVencim" size="15" type="text" value="${amortizacion.fechaVencim}" readonly="readonly" disabled="disabled" /></td>
							<td><input id="fechaExigible${status.count}" name="fechaExigible" size="15" type="text" value="${amortizacion.fechaExigible}" readonly="readonly" disabled="disabled" /></td>
							<td><c:choose>
									<c:when test="${amortizacion.capitalInteres == 'I'}">
										<input id="capital${status.count}" name="capital" size="18" style="text-align: right;" type="text" value="0.00" readonly="readonly" disabled="disabled" esMoneda="true" />
									</c:when>

									<c:when test="${amortizacion.capitalInteres == 'C'}">
										<input id="capital${status.count}" name="capital" size="18" style="text-align: right;" type="text" value="" onblur="agregaFormatoMonedaGrid(this.id);calculaDiferenciaSimuladorLibre();calculoTotalCapital();" esMoneda="true" />
									</c:when>

									<c:when test="${amortizacion.capitalInteres == 'G'}">
										<input id="capital${status.count}" name="capital" size="18" style="text-align: right;" type="text" value="" onblur="agregaFormatoMonedaGrid(this.id);calculaDiferenciaSimuladorLibre();calculoTotalCapital();" esMoneda="true" />
									</c:when>
								</c:choose></td>
							<td><input id="interes${status.count}" name="interes" size="18" style="text-align: right;" type="text" onblur="calculoTotalInteres();" value=" " readonly="readonly" disabled="disabled" esMoneda="true" /></td>
							<td><input id="ivaInteres${status.count}" name="ivaInteres" size="18" style="text-align: right;" type="text" value=" " readonly="readonly" disabled="disabled" esMoneda="true" /></td>
							<c:if test="${var_cobraSeguroCuota == 'S'}">
								<td><input id="montoSeguroCuota${status.count}" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoSeguroCuota}" readonly="readonly" disabled="disabled" esMoneda="true" /></td>
								<td><input id="iVASeguroCuota${status.count}" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.iVASeguroCuota}" readonly="readonly" disabled="disabled" esMoneda="true" /></td>
							</c:if>
							<c:if test="${cobraAccesorios == 'S'}">
								<td><input id="otrasComisiones${status.count}" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
								<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoIVAOtrasCom}" readonly="readonly" esMoneda="true" /></td>
							</c:if>
							<td><input id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" type="text" value=" " readonly="readonly" disabled="disabled" esMoneda="true" /></td>
							<td><input id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;" type="text" value=" " readonly="readonly" disabled="disabled" esMoneda="true" /></td>
						</tr>

						<c:set var="cuotas3" value="${amortizacion.cuotasCapital}" />
						<c:set var="cuotasInteres3" value="${amortizacion.cuotasInteres}" />
						<c:set var="fechaVenc3" value="${amortizacion.fechaVencim}" />
						<c:set var="numTransaccion3" value="${amortizacion.numTransaccion}" />
						<c:set var="valorFecUltAmor3" value="${amortizacion.fecUltAmor}" />
						<c:set var="valorfecInicioAmor3" value="${amortizacion.fecInicioAmor}" />
						<c:set var="valorMontoCuota3" value="${amortizacion.montoCuota}" />
						<c:set var="varTotalSeguroCuota" value="${amortizacion.totalSeguroCuota}" />
						<c:set var="varTotalIVASeguroCuota" value="${amortizacion.totalIVASeguroCuota}" />
						<c:set var="varTotalOtrasComisiones" value="${amortizacion.totalOtrasComisiones}" />
						<c:set var="varTotalIVAOtrasComisiones" value="${amortizacion.totalIVAOtrasComisiones}" />
					</c:forEach>
					<tr>
						<td colspan="10" align="right"><input id="transaccion" name="transaccion" size="18" align="right" type="hidden" value="${numTransaccion3}" readonly="readonly" disabled="disabled" /> <input id="cuotas" name="cuotas" size="18" type="hidden" value="${cuotas3}" readonly="readonly"
							disabled="disabled" /> <input id="valorCuotasInt" name="valorCuotasInt" size="18" type="hidden" value="${cuotasInteres3}" readonly="readonly" disabled="disabled" /> <input id="valorFecUltAmor" name="valorFecUltAmor" size="18" align="right" type="hidden" value="${valorFecUltAmor3}"
							readonly="readonly" disabled="disabled" /> <input id="valorfecInicioAmor" name="valorfecInicioAmor" size="18" align="right" type="hidden" value="${valorfecInicioAmor3}" readonly="readonly" disabled="disabled" /> <input id="valorMontoCuota" name="valorMontoCuota" size="18" align="right"
							type="hidden" value="${valorMontoCuota3}" readonly="readonly" disabled="disabled" /></td>
					</tr>
					<tr id="filaTotales">
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="label"><label for="lblTotales">Totales: </label></td>
						<td><input id="totalCap" name="totalCap" size="18" readOnly="true" style="text-align: right;" esMoneda="true" /></td>
						<td><input id="totalInt" name="totalInt" size="18" readOnly="true" style="text-align: right;" esMoneda="true" /></td>
						<td><input id="totalIva" name="totalIva" size="18" readOnly="true" style="text-align: right;" esMoneda="true" /></td>
						<c:if test="${var_cobraSeguroCuota == 'S'}">
							<td><input id="totalSeguroCuota" value="${varTotalSeguroCuota3}" name="totalSeguroCuota" size="18" readOnly="true" style="text-align: right;" esMoneda="true" /></td>
							<td><input id="iVATotalSeguroCuota" value="${varTotalIVASeguroCuota3}" name="iVATotalSeguroCuota" size="18" readOnly="true" style="text-align: right;" esMoneda="true"/></td>
						</c:if>
						<c:if test="${cobraAccesorios == 'S'}">
							<td><input id="otrasComisiones" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${varTotalOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${varTotalIVAOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
						</c:if>
					</tr>
					<tr id="trDiferenciaCapital">
						<td colspan="4" align="right"><label for="Diferencia">Diferencia: </label></td>
						<td id="inputDiferenciaCap"><input type="text" id="diferenciaCapital" name="diferenciaCapital" size="18" style="text-align: right;" value="0.00" disabled="disabled" readonly="readonly" esMoneda="true" /></td>
						<td colspan="5"></td>
					</tr>
					<tr id="trBtnCalcular">
						<td id="btnCalcularLibre" colspan="10" align="right"><input type="button" class="submit" id="calcular" tabindex="37" value="Calcular" onclick="simuladorPagosLibres(${numTransaccion3});" /></td>
						<td align="right"><input type="button" id="imprimirRep" class="submit" style="display: none;" value="Imprimir" onclick="generaReporte();" /></td>
					</tr>
				</c:when>
				<c:when test="${tipoLista == '5'}">
					<tr>
						<td class="label" align="center"><label for="lblNumero">N&uacute;mero</label></td>
						<td class="label" align="center"><label for="lblFecIni">Fecha Inicio</label></td>
						<td class="label" align="center"><label for="lblFecFin">Fecha Vencimiento</label></td>
						<td class="label" align="center"><label for="lblFecPag">Fecha Pago</label></td>
						<td class="label" align="center"><label for="lblCapital">Capital</label></td>
						<td class="label" align="center"><label for="lblDescripcion">Inter&eacute;s</label></td>
						<td class="label" align="center"><label for="lblCargos">IVA Inter&eacute;s</label></td>
						<c:if test="${var_cobraSeguroCuota == 'S'}">
							<td class="label" align="center"><label for="lblCargos">Seguro</label></td>
							<td class="label" align="center"><label for="lblCargos">IVA Seguro</label></td>
						</c:if>
						<c:if test="${cobraAccesorios == 'S'}">
							<td class="label" align="center"><label for="lblOtrasComisiones">Otras Comisiones</label></td>
							<td class="label" align="center"><label for="lblIVAOtrasComisiones">IVA Otras Comisiones</label></td>
						</c:if>
						<td class="label" align="center"><label for="lblTotalPag">Total Pago</label></td>
						<td class="label" align="center"><label for="lblSaldoCap">Saldo Capital</label></td>
					</tr>

					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td><input id="amortizacionID${status.count}" name="amortizacionID" size="4" type="text" value="${amortizacion.amortizacionID}" readonly="readonly" disabled="disabled" /></td>
							<td><input id="fechaInicio${status.count}" name="fechaInicioGrid" size="15" type="text" value="${amortizacion.fechaInicio}" readonly="readonly" disabled="disabled" /></td>
							<td><input id="fechaVencim${status.count}" name="fechaVencim" size="15" type="text" value="${amortizacion.fechaVencim}" readonly="readonly" disabled="disabled" /></td>
							<td><input id="fechaExigible${status.count}" name="fechaExigible" size="15" type="text" value="${amortizacion.fechaExigible}" readonly="readonly" disabled="disabled" /></td>
							<td><c:choose>
									<c:when test="${amortizacion.capitalInteres == 'I'}">
										<input id="capital${status.count}" name="capital" size="18" style="text-align: right;" type="text" value="0" readonly="readonly" disabled="disabled" esMoneda="true" />
									</c:when>

									<c:when test="${amortizacion.capitalInteres == 'C'}">
										<input id="capital${status.count}" name="capital" size="18" style="text-align: right;" type="text" value="" onblur="agregaFormatoMonedaGrid(this.id);" esMoneda="true" />
									</c:when>

									<c:when test="${amortizacion.capitalInteres == 'G'}">
										<input id="capital${status.count}" name="capital" size="18" style="text-align: right;" type="text" value="" onblur="agregaFormatoMonedaGrid(this.id);" esMoneda="true" />
									</c:when>
								</c:choose></td>
							<td><input id="interes${status.count}" name="interes" size="18" style="text-align: right;" type="text" onblur="calculoTotalInteres();" value=" " readonly="readonly" disabled="disabled" esMoneda="true" /></td>
							<td><input id="ivaInteres${status.count}" name="ivaInteres" size="18" style="text-align: right;" type="text" value=" " readonly="readonly" disabled="disabled" esMoneda="true" /></td>
							<c:if test="${var_cobraSeguroCuota == 'S'}">
								<td><input id="montoSeguroCuota${status.count}" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoSeguroCuota}" readonly="readonly" esMoneda="true" /></td>
								<td><input id="iVASeguroCuota${status.count}" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.iVASeguroCuota}" readonly="readonly" esMoneda="true" /></td>
							</c:if>
							<c:if test="${cobraAccesorios == 'S'}">
								<td><input id="otrasComisiones${status.count}" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
								<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoIVAOtrasCom}" readonly="readonly" esMoneda="true" /></td>
							</c:if>
							<td><input id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" type="text" value=" " readonly="readonly" disabled="disabled" esMoneda="true" /></td>
							<td><input id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;" type="text" value=" " readonly="readonly" disabled="disabled" esMoneda="true" /></td>
						</tr>

						<c:set var="cuotas5" value="${amortizacion.cuotasCapital}" />
						<c:set var="fechaVenc5" value="${amortizacion.fechaVencim}" />
						<c:set var="numTransaccion5" value="${amortizacion.numTransaccion}" />
						<c:set var="valorFecUltAmor5" value="${amortizacion.fecUltAmor}" />
						<c:set var="valorfecInicioAmor5" value="${amortizacion.fecInicioAmor}" />
						<c:set var="valorMontoCuota5" value="${amortizacion.montoCuota}" />
						<c:set var="varTotalSeguroCuota5" value="${amortizacion.totalSeguroCuota}" />
						<c:set var="varTotalIVASeguroCuota5" value="${amortizacion.totalIVASeguroCuota}" />
						<c:set var="varTotalOtrasComisiones" value="${amortizacion.totalOtrasComisiones}" />
						<c:set var="varTotalIVAOtrasComisiones" value="${amortizacion.totalIVAOtrasComisiones}" />
					</c:forEach>
					<tr id="filaTotales">
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="label"><label for="lblTotales">Totales: </label></td>
						<td><input id="totalCap" name="totalCap" size="18" readOnly="true" style="text-align: right;" esMoneda="true" /></td>
						<td><input id="totalInt" name="totalInt" size="18" readOnly="true" style="text-align: right;" esMoneda="true" /></td>
						<td><input id="totalIva" name="totalIva" size="18" readOnly="true" style="text-align: right;" esMoneda="true" /></td>
						<c:if test="${var_cobraSeguroCuota == 'S'}">
							<td><input id="totalSeguroCuota" value="${varTotalSeguroCuota5}" name="totalSeguroCuota" size="18" readOnly="true" style="text-align: right;" esMoneda="true" /></td>
							<td><input id="iVATotalSeguroCuota" value="${varTotalIVASeguroCuota5}" name="iVATotalSeguroCuota" size="18" readOnly="true" style="text-align: right;" esMoneda="true"/></td>
						</c:if>
						<c:if test="${cobraAccesorios == 'S'}">
							<td><input id="otrasComisiones" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${varTotalOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${varTotalIVAOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
						</c:if>
					</tr>
					<tr>
						<td colspan="8" align="right"><input id="transaccion" name="transaccion" size="18" align="right" type="hidden" value="${numTransaccion5}" readonly="readonly" disabled="disabled" /> <input id="cuotas" name="cuotas" size="18" align="right" type="hidden" value="${cuotas5}"
							readonly="readonly" disabled="disabled" /> <input id="valorFecUltAmor" name="valorFecUltAmor" size="18" align="right" type="hidden" value="${valorFecUltAmor5}" readonly="readonly" disabled="disabled" /> <input id="valorfecInicioAmor" name="valorfecInicioAmor" size="18" align="right"
							type="hidden" value="${valorfecInicioAmor5}" readonly="readonly" disabled="disabled" /> <input id="valorMontoCuota" name="valorMontoCuota" size="18" align="right" type="hidden" value="${valorMontoCuota5}" readonly="readonly" disabled="disabled" /></td>

						<td align="right"><input type="button" class="submit" id="recalculo" value="Guardar" onclick="simuladorPagosLibresTasaVar(${numTransaccion5},${cuotas5});" /></td>

					</tr>
				</c:when>



				<c:when test="${tipoLista == '12'}">
					<tr>
						<td class="label" align="center"><label for="lblNumero">N&uacute;mero</label></td>
						<td class="label" align="center"><label for="lblFecIni">Fecha Inicio</label></td>
						<td class="label" align="center"><label for="lblFecFin">Fecha Vencimiento</label></td>
						<td class="label" align="center"><label for="lblFecPag">Fecha Pago</label></td>
						<td class="label" align="center"><label for="lblCapital">Capital</label></td>
						<td class="label" align="center"><label for="lblDescripcion">Inter&eacute;s</label></td>
						<td class="label" align="center"><label for="lblCargos">IVA Inter&eacute;s</label></td>
						<c:if test="${var_cobraSeguroCuota == 'S'}">
							<td class="label" align="center"><label for="lblCargos">Seguro</label></td>
							<td class="label" align="center"><label for="lblCargos">IVA Seguro</label></td>
						</c:if>
						<c:if test="${cobraAccesorios == 'S'}">
							<td class="label" align="center"><label for="lblOtrasComisiones">Otras Comisiones</label></td>
							<td class="label" align="center"><label for="lblIVAOtrasComisiones">IVA Otras Comisiones</label></td>
						</c:if>
						<td class="label" align="center"><label for="lblTotalPag">Total Pago</label></td>
						<td class="label" align="center"><label for="lblSaldoCap">Saldo Capital</label></td>
						<td class="label" align="center"><label for="lblAgregaElimina"></label></td>
					</tr>

					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td><input id="consecutivoID${status.count}" name="amortizacionID" size="4" type="text" value="${amortizacion.amortizacionID}" readonly="readonly" /></td>
							<td><input id="fechaInicio${status.count}" name="fechaInicioGrid" size="15" type="text" value="${amortizacion.fechaInicio}" readonly="readonly" /></td>
							<td><input id="fechaVencim${status.count}" name="fechaVencim" size="15" type="text" value="${amortizacion.fechaVencim}" onblur="comparaFechas(this.id)" /></td>
							<td><input id="fechaExigible${status.count}" name="fechaExigible" size="15" type="text" value="${amortizacion.fechaExigible}" readonly="readonly" /></td>
							<td><input id="capital${status.count}" name="capital" size="18" style="text-align: right;" type="text" value="${amortizacion.capital}" onblur="agregaFormatoMonedaGrid(this.id);calculaDiferenciaSimuladorLibre();calculoTotalCapital();" esMoneda="true" /></td>
							<td><input id="interes${status.count}" name="interes" size="18" style="text-align: right;" type="text" value="${amortizacion.interes}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="ivaInteres${status.count}" name="ivaInteres" size="18" style="text-align: right;" type="text" value="${amortizacion.ivaInteres}" readonly="readonly" esMoneda="true" /></td>
							<c:if test="${var_cobraSeguroCuota == 'S'}">
								<td><input id="montoSeguroCuota${status.count}" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoSeguroCuota}" readonly="readonly" esMoneda="true" /></td>
								<td><input id="iVASeguroCuota${status.count}" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.iVASeguroCuota}" readonly="readonly" esMoneda="true" /></td>
							</c:if>
							<c:if test="${cobraAccesorios == 'S'}">
								<td><input id="otrasComisiones${status.count}" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
								<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoIVAOtrasCom}" readonly="readonly" esMoneda="true" /></td>
							</c:if>
							<td><input id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" type="text" value="${amortizacion.totalPago}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoInsoluto}" readonly="readonly" esMoneda="true" /></td>
							<td nowrap="nowrap"><input type="button" name="elimina" id="${status.count}" value="" class="btnElimina" onclick="eliminarAmortizacion(this)" /> <input type="button" name="agrega" id="agrega${status.count}" value="" class="btnAgrega" onclick="agregarNuevaAmortizacion()" /></td>
						</tr>

						<c:set var="cuotas3" value="${amortizacion.cuotasCapital}" />
						<c:set var="cuotasInteres3" value="${amortizacion.cuotasInteres}" />
						<c:set var="fechaVenc3" value="${amortizacion.fechaVencim}" />
						<c:set var="numTransaccion3" value="${amortizacion.numTransaccion}" />
						<c:set var="valorFecUltAmor3" value="${amortizacion.fecUltAmor}" />
						<c:set var="valorfecInicioAmor3" value="${amortizacion.fecInicioAmor}" />
						<c:set var="valorMontoCuota3" value="${amortizacion.montoCuota}" />
						<c:set var="varTotalSeguroCuota12" value="${amortizacion.totalSeguroCuota}" />
						<c:set var="varTotalIVASeguroCuota12" value="${amortizacion.totalIVASeguroCuota}" />
						<c:set var="varTotalOtrasComisiones" value="${amortizacion.totalOtrasComisiones}" />
						<c:set var="varTotalIVAOtrasComisiones" value="${amortizacion.totalIVAOtrasComisiones}" />
					</c:forEach>
					<tr>
						<td colspan="10" align="right"><input id="transaccion" name="transaccion" size="18" align="right" type="hidden" value="${numTransaccion3}" /> <input id="cuotas" name="cuotas" type="hidden" value="${cuotas3}" /> <input id="valorCuotasInt" name="valorCuotasInt" type="hidden"
							value="${cuotasInteres3}" /> <input id="valorFecUltAmor" name="valorFecUltAmor" type="hidden" value="${valorFecUltAmor3}" /> <input id="valorfecInicioAmor" name="valorfecInicioAmor" type="hidden" value="${valorfecInicioAmor3}" /> <input id="valorMontoCuota" name="valorMontoCuota"
							type="hidden" value="${valorMontoCuota3}" /></td>
					</tr>
					<tr id="filaTotales">
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="label"><label for="lblTotales">Totales: </label></td>
						<td><input id="totalCap" name="totalCap" size="18" readonly="readonly" style="text-align: right;" esMoneda="true" /></td>
						<td><input id="totalInt" name="totalInt" size="18" readonly="readonly" style="text-align: right;" esMoneda="true" /></td>
						<td><input id="totalIva" name="totalIva" size="18" readonly="readonly" style="text-align: right;" esMoneda="true" /></td>
						<c:if test="${var_cobraSeguroCuota == 'S'}">
							<td><input id="totalSeguroCuota" value="${varTotalSeguroCuota12}" name="totalSeguroCuota" size="18" readOnly="true" style="text-align: right;" esMoneda="true" /></td>
							<td><input id="iVATotalSeguroCuota" value="${varTotalIVASeguroCuota12}" name="iVATotalSeguroCuota" size="18" readOnly="true" style="text-align: right;" esMoneda="true"/></td>
						</c:if>
						<c:if test="${cobraAccesorios == 'S'}">
							<td><input id="otrasComisiones" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${varTotalOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${varTotalIVAOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
						</c:if>
					</tr>
					<tr id="trDiferenciaCapital">
						<td colspan="4" align="right"><label for="Diferencia">Diferencia: </label></td>
						<td id="inputDiferenciaCap"><input type="text" id="diferenciaCapital" name="diferenciaCapital" size="18" style="text-align: right;" value="0.00" readonly="readonly" esMoneda="true" /></td>
						<td colspan="5"></td>
					</tr>
					<tr id="trBtnCalcular">
						<td id="btnCalcularLibre" colspan="10" align="right"><input type="button" class="submit" id="calcular" tabindex="37" value="Calcular" onclick="simuladorLibresCapFec();" /></td>
						<td align="right"><input type="button" id="imprimirRep" class="submit" style="display: none;" value="Imprimir" onclick="generaReporte();" /></td>
					</tr>
				</c:when>
			</c:choose>
		</table>
	</c:if>
	<input id="fech" type="hidden" value="${fechaVencimiento.fechaVencim}" />
</fieldset>
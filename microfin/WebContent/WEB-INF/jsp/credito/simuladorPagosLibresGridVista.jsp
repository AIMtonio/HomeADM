<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="mensaje" value="${listaResultado[1]}" />
<c:set var="numErr2">${listaResultado[3]}</c:set>
<c:set var="mesErr" value="${listaResultado[4]}" />
<c:set var="var_cobraSeguroCuota" value="${listaResultado[5]}" />
<c:set var="cobraAccesorios" value="${listaResultado[6]}" />
<c:set var="listaResultado" value="${listaResultado[2]}" />

<input type="hidden" id="numeroErrorList" name="numeroErrorList" value="${numErr2}" />
<input type="hidden" id="mensajeErrorList" name="mensajeErrorList" value="<c:out value="${mesErr}"/>" />
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Simulador de Amortizaciones</legend>
	<form id="gridDetalle" name="gridDetalle">
		<c:if test="${numErr2 == 0}">
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<c:choose>
					<c:when test="${mensaje.numero == '0'}">
						<c:choose>
							<c:when test="${tipoLista == '3'}">
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
										<td><input type="text" id="consecutivoID${status.count}" name="consecutivoID" size="4" value="${status.count}" readonly="readonly" /></td>
										<td><input type="text" id="fechaInicio${status.count}" name="fechaInicioGrid" size="15" value="${amortizacion.fechaInicio}" readonly="readonly" /></td>
										<td><input type="text" id="fechaVencim${status.count}" name="fechaVencim" size="15" value="${amortizacion.fechaVencim}" readonly="readonly" /></td>
										<td><input type="text" id="fechaExigible${status.count}" name="fechaExigible" size="15" value="${amortizacion.fechaExigible}" readonly="readonly" /></td>
										<td><c:choose>
												<c:when test="${amortizacion.capitalInteres == 'I'}">
													<input type="text" id="capital${status.count}" name="capital" size="18" style="text-align: right;" value="${amortizacion.capital}" readonly="readonly" esMoneda="true" />
												</c:when>
												<c:when test="${amortizacion.capitalInteres == 'C'}">
													<input type="text" id="capital${status.count}" name="capital" size="18" style="text-align: right;" value="${amortizacion.capital}" esMoneda="true" onblur="agregaFormatoMonedaGrid(this.id);calculaDiferenciaSimuladorLibre();" />
												</c:when>
												<c:when test="${amortizacion.capitalInteres == 'G'}">
													<input type="text" id="capital${status.count}" name="capital" size="18" style="text-align: right;" value="${amortizacion.capital}" esMoneda="true" onblur="agregaFormatoMonedaGrid(this.id);calculaDiferenciaSimuladorLibre();" />
												</c:when>
											</c:choose></td>
										<td><input type="text" id="interes${status.count}" name="interes" size="18" style="text-align: right;" value="${amortizacion.interes}" readonly="readonly" esMoneda="true" /></td>
										<td><input type="text" id="ivaInteres${status.count}" name="ivaInteres" size="18" style="text-align: right;" value="${amortizacion.ivaInteres}" readonly="readonly" esMoneda="true" /></td>
										<c:if test="${var_cobraSeguroCuota == 'S'}">
											<td><input id="montoSeguroCuota${status.count}" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoSeguroCuota}" readonly="readonly" disabled="disabled" esMoneda="true" /></td>
											<td><input id="iVASeguroCuota${status.count}" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.iVASeguroCuota}" readonly="readonly" disabled="disabled" esMoneda="true" /></td>
										</c:if>
										<c:if test="${cobraAccesorios == 'S'}">
											<td><input id="otrasComisiones${status.count}" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
											<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoIVAOtrasCom}" readonly="readonly" esMoneda="true" /></td>
										</c:if>
										<td><input type="text" id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" value="${amortizacion.totalPago}" readonly="readonly" esMoneda="true" /></td>
										<td><input type="text" id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;" value="${amortizacion.saldoInsoluto}" readonly="readonly" esMoneda="true" /></td>
									</tr>

									<c:set var="cuotas3" value="${amortizacion.cuotasCapital}" />
									<c:set var="numTransaccion" value="${amortizacion.numTransaccion}" />
									<c:set var="capInt" value="${amortizacion.capitalInteres}" />
									<c:set var="valorCat" value="${amortizacion.cat}" />
									<c:set var="valorFecUltAmor" value="${amortizacion.fecUltAmor}" />
									<c:set var="valorfecInicioAmor" value="${amortizacion.fecInicioAmor}" />
									<c:set var="valorCuotasCap" value="${amortizacion.cuotasCapital}" />
									<c:set var="valorCuotasInt" value="${amortizacion.cuotasInteres}" />
									<c:set var="varTotalSeguroCuota" value="${amortizacion.totalSeguroCuota}" />
									<c:set var="varTotalIVASeguroCuota" value="${amortizacion.totalIVASeguroCuota}" />
									<c:set var="varTotalOtrasComisiones" value="${amortizacion.totalOtrasComisiones}" />
									<c:set var="varTotalIVAOtrasComisiones" value="${amortizacion.totalIVAOtrasComisiones}" />
								</c:forEach>
								<tr>
									<td colspan="9" align="right"><input id="transaccion" name="transaccion" size="18" type="hidden" value="${numTransaccion}" readonly="readonly" /> <input id="valorCat" name="valorCat" size="18" type="hidden" value="${valorCat}" readonly="readonly" disabled="true" /> <input
										id="valorFecUltAmor" name="valorFecUltAmor" size="18" type="hidden" value="${valorFecUltAmor}" readonly="readonly" disabled="true" /> <input id="valorfecInicioAmor" name="valorfecInicioAmor" size="18" type="hidden" value="${valorfecInicioAmor}" readonly="readonly" disabled="true" /> <input
										id=valorCuotasCapital name="valorCuotasCapital" size="18" type="hidden" value="${valorCuotasCap}" readonly="readonly" disabled="true" /> <input id="valorCuotasInteres" name="valorCuotasInteres" size="18" type="hidden" value="${valorCuotasInt}" readonly="readonly" disabled="true" /></td>
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
										<td><input id="totalSeguroCuota" name="totalSeguroCuota" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalSeguroCuota}" /></td>
										<td><input id="iVATotalSeguroCuota" name="iVATotalSeguroCuota" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalIVASeguroCuota}" /></td>
									</c:if>
									<c:if test="${cobraAccesorios == 'S'}">
										<td><input id="otrasComisiones" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${varTotalOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
										<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${varTotalIVAOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
									</c:if>
								</tr>
								<tr id="trDiferenciaCapital">
									<td colspan="4" align="right"><label for="Diferencia">Diferencia: </label></td>
									<td id="inputDiferenciaCap"><input type="text" id="diferenciaCapital" name="diferenciaCapital" size="18" style="text-align: right;" value="0.00" esMoneda="true" readonly="readonly" /></td>
									<td colspan="5"></td>
								</tr>
								<tr id="trBtnCalcular">
									<td id="btnCalcularLibre" colspan="10" align="right"><input type="button" class="submit" id="calcular" tabindex="37" value="Calcular" onclick="simuladorPagosLibres(${numTransaccion});" /></td>
									<td><input type="button" id="imprimirRep" class="submit" style="display: none;" value="Imprimir" onclick="generaReporte();" /></td>
								</tr>
							</c:when>

							<c:when test="${tipoLista == '5'}">
								<tr>
									<td class="label"><label for="lblNumero">Numero</label></td>
									<td class="label"><label for="lblNumero">Fecha Inicio</label></td>
									<td class="label"><label for="lblCR">Fecha Vencimiento</label></td>
									<td class="label"><label for="lblCuenta">Fecha Pago</label></td>
									<td class="label"><label for="lblReferencia">Capital</label></td>
									<td class="label"><label for="lblDescripcion">Interes</label></td>
									<td class="label"><label for="lblCargos">IVA Interes</label></td>
									<c:if test="${var_cobraSeguroCuota == 'S'}">
										<td class="label" align="center"><label for="lblCargos">Seguro</label></td>
										<td class="label" align="center"><label for="lblCargos">IVA Seguro</label></td>
									</c:if>
									<c:if test="${cobraAccesorios == 'S'}">
										<td class="label" align="center"><label for="lblOtrasComisiones">Otras Comisiones</label></td>
										<td class="label" align="center"><label for="lblIVAOtrasComisiones">IVA Otras Comisiones</label></td>
									</c:if>
									<td class="label"><label for="lblTotalPag">Total Pago</label></td>
									<td class="label"><label for="lblSaldoCap">Saldo Capital</label></td>
								</tr>

								<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
									<tr id="renglon${status.count}" name="renglon">
										<td><input type="text" id="consecutivoID${status.count}" name="consecutivoID" size="4" value="${status.count}" readonly="readonly" /></td>
										<td><input type="text" id="fechaInicio${status.count}" name="fechaInicioGrid" size="15" value="${amortizacion.fechaInicio}" readonly="readonly" /></td>
										<td><input type="text" id="fechaVencim${status.count}" name="fechaVencim" size="15" value="${amortizacion.fechaVencim}" readonly="readonly" /></td>
										<td><input type="text" id="fechaExigible${status.count}" name="fechaExigible" size="15" value="${amortizacion.fechaExigible}" readonly="readonly" /></td>
										<td><c:choose>
												<c:when test="${amortizacion.capitalInteres == 'I'}">
													<input type="text" id="capital${status.count}" name="capital" size="18" style="text-align: right;" value="${amortizacion.capital}" readonly="readonly" esMoneda="true" />
												</c:when>

												<c:when test="${amortizacion.capitalInteres == 'C'}">
													<input type="text" id="capital${status.count}" name="capital" size="18" style="text-align: right;" value="${amortizacion.capital}" esMoneda="true" />
												</c:when>

												<c:when test="${amortizacion.capitalInteres == 'G'}">
													<input type="text" id="capital${status.count}" name="capital" size="18" style="text-align: right;" value="${amortizacion.capital}" esMoneda="true" />
												</c:when>
											</c:choose></td>
										<td><input type="text" id="interes${status.count}" name="interes" size="18" style="text-align: right;" value="${amortizacion.interes}" readonly="readonly" esMoneda="true" /></td>
										<td><input type="text" id="ivaInteres${status.count}" name="ivaInteres" size="18" style="text-align: right;" value="${amortizacion.ivaInteres}" readonly="readonly" esMoneda="true" /></td>
										<c:if test="${var_cobraSeguroCuota == 'S'}">
											<td><input id="montoSeguroCuota${status.count}" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoSeguroCuota}" readonly="readonly" disabled="disabled" esMoneda="true" /></td>
											<td><input id="iVASeguroCuota${status.count}" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.iVASeguroCuota}" readonly="readonly" disabled="disabled" esMoneda="true" /></td>
										</c:if>
										<c:if test="${cobraAccesorios == 'S'}">
											<td><input id="otrasComisiones${status.count}" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
											<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoIVAOtrasCom}" readonly="readonly" esMoneda="true" /></td>
										</c:if>
										<td><input type="text" id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" value="${amortizacion.totalPago}" readonly="readonly" esMoneda="true" /></td>
										<td><input type="text" id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;" value="${amortizacion.saldoInsoluto}" readonly="readonly" esMoneda="true" /></td>
									</tr>

									<c:set var="cuotas5" value="${amortizacion.cuotasCapital}" />
									<c:set var="fechaVenc5" value="${amortizacion.fechaVencim}" />
									<c:set var="numTransaccion5" value="${amortizacion.numTransaccion}" />
									<c:set var="valorCat2" value="${amortizacion.cat}" />
									<c:set var="valorFecUltAmor2" value="${amortizacion.fecUltAmor}" />
									<c:set var="valorfecInicioAmor2" value="${amortizacion.fecInicioAmor}" />
									<c:set var="varTotalSeguroCuota5" value="${amortizacion.totalSeguroCuota}"/>
									<c:set var="varTotalIVASeguroCuota5" value="${amortizacion.totalIVASeguroCuota}"/>
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
										<td><input id="otrasComisiones" name="otrasComisiones" size="18" style="text-align: right" type="text" value="${varTotalOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
										<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${varTotalIVAOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
									</c:if>
								</tr>
								<tr>
									<td colspan="8" align="right"><input id="transaccion" name="transaccion" size="18" type="hidden" value="${numTransaccion5}" readonly="readonly" disabled="true" /> <input id="valorCat" name="valorCat" size="18" type="hidden" value="${valorCat2}" readonly="readonly" disabled="true" />
										<input id="valorFecUltAmor" name="valorFecUltAmor" size="18" type="hidden" value="${valorFecUltAmor2}" readonly="readonly" disabled="true" /> <input id="valorfecInicioAmor" name="valorfecInicioAmor" size="18" type="hidden" value="${valorfecInicioAmor2}" readonly="readonly" disabled="true" /></td>
									<td align="right"><input type="button" class="submit" id="RecalcularTV" value="Modificar" onclick="simuladorPagosLibresTasaVar(${numTransaccion5},${cuotas5});" /></td>
								</tr>
							</c:when>
							<c:when test="${tipoLista == '7'}">
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
									<td class="label" align="center"></td>
								</tr>

								<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
									<tr id="renglon${status.count}" name="renglon">
										<td><input type="text" id="consecutivoID${status.count}" name="consecutivoID" size="4" value="${status.count}" readonly="readonly" /></td>
										<td align="center"><input type="text" id="fechaInicio${status.count}" name="fechaInicioGrid" size="15" value="${amortizacion.fechaInicio}" readonly="readonly" /></td>
										<td align="center"><input type="text" id="fechaVencim${status.count}" name="fechaVencim" size="15" value="${amortizacion.fechaVencim}" onblur="comparaFechas(this.id);" /></td>
										<td align="center"><input type="text" id="fechaExigible${status.count}" name="fechaExigible" size="15" value="${amortizacion.fechaExigible}" readonly="readonly" /></td>
										<td><input type="text" id="capital${status.count}" name="capital" size="18" style="text-align: right;" value="${amortizacion.capital}" esMoneda="true" onblur="calculaDiferenciaSimuladorLibre();" /></td>
										<td><input type="text" id="interes${status.count}" name="interes" size="18" style="text-align: right;" value="${amortizacion.interes}" readonly="readonly" esMoneda="true" /></td>
										<td><input type="text" id="ivaInteres${status.count}" name="ivaInteres" size="18" style="text-align: right;" value="${amortizacion.ivaInteres}" readonly="readonly" esMoneda="true" /></td>
										<c:if test="${var_cobraSeguroCuota == 'S'}">
											<td><input id="montoSeguroCuota${status.count}" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoSeguroCuota}" readonly="readonly" disabled="disabled" esMoneda="true" /></td>
											<td><input id="iVASeguroCuota${status.count}" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.iVASeguroCuota}" readonly="readonly" disabled="disabled" esMoneda="true" /></td>
										</c:if>
										<c:if test="${cobraAccesorios == 'S'}">
											<td><input id="otrasComisiones${status.count}" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
											<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoIVAOtrasCom}" readonly="readonly" esMoneda="true" /></td>
										</c:if>
										<td><input type="text" id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" value="${amortizacion.totalPago}" readonly="readonly" esMoneda="true" /></td>
										<td><input type="text" id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;" value="${amortizacion.saldoInsoluto}" readonly="readonly" esMoneda="true" /></td>
										<td nowrap="nowrap"><input type="button" name="elimina" id="${status.count}" value="" class="btnElimina" onclick="eliminaAmort(this)" /> <input type="button" name="agrega" id="agrega${status.count}" value="" class="btnAgrega" onclick="agregaNuevaAmort()" /></td>
									</tr>

									<c:set var="cuotas7" value="${status.count}" />
									<c:set var="fechaVenc7" value="${amortizacion.fechaVencim}" />
									<c:set var="numTransaccion7" value="${amortizacion.numTransaccion}" />
									<c:set var="valorCat3" value="${amortizacion.cat}" />
									<c:set var="valorFecUltAmor3" value="${amortizacion.fecUltAmor}" />
									<c:set var="valorfecInicioAmor3" value="${amortizacion.fecInicioAmor}" />
									<c:set var="valorCuotasCap" value="${amortizacion.cuotasCapital}" />
									<c:set var="valorCuotasInt" value="${amortizacion.cuotasInteres}" />
									<c:set var="varTotalSeguroCuota7" value="${amortizacion.totalSeguroCuota}"/>
									<c:set var="varTotalIVASeguroCuota7" value="${amortizacion.totalIVASeguroCuota}"/>
									<c:set var="varTotalOtrasComisiones" value="${amortizacion.totalOtrasComisiones}" />
									<c:set var="varTotalIVAOtrasComisiones" value="${amortizacion.totalIVAOtrasComisiones}" />
								</c:forEach>
								<tr>
									<td colspan="10" align="right"><input type="hidden" value="${cuotas7}" name="numeroDetalle" id="numeroDetalle" /> <input id="transaccion" name="transaccion" size="18" type="hidden" value="${numTransaccion7}" readonly="readonly" disabled="true" /> <input id="valorCat" name="valorCat"
										size="18" type="hidden" value="${valorCat3}" readonly="readonly" disabled="true" /> <input id="valorFecUltAmor" name="valorFecUltAmor" size="18" type="hidden" value="${valorFecUltAmor3}" readonly="readonly" disabled="true" /> <input id="valorfecInicioAmor" name="valorfecInicioAmor"
										size="18" type="hidden" value="${valorfecInicioAmor3}" readonly="readonly" disabled="true" /> <input id=valorCuotasCapital name="valorCuotasCapital" size="18" type="hidden" value="${valorCuotasCap}" readonly="readonly" disabled="true" /> <input id="valorCuotasInteres"
										name="valorCuotasInteres" size="18" type="hidden" value="${valorCuotasInt}" readonly="readonly" disabled="true" /></td>
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
										<td><input id="totalSeguroCuota" value="${varTotalSeguroCuota7}" name="totalSeguroCuota" size="18" readOnly="true" style="text-align: right;" esMoneda="true" /></td>
										<td><input id="iVATotalSeguroCuota" value="${varTotalIVASeguroCuota7}" name="iVATotalSeguroCuota" size="18" readOnly="true" style="text-align: right;" esMoneda="true"/></td>
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
									<td><input type="button" id="imprimirRep" class="submit" style="display: none;" value="Imprimir" onclick="generaReporte();" /></td>
									<td><input type="button" id="ExportarExcel" class="submit" style="display: none;" value="Exportar" onclick="exportarExcel();" /></td>
								</tr>
							</c:when>

							<c:when test="${tipoLista == '8'}">
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
										<td><input type="text" id="consecutivoID${status.count}" name="consecutivoID" size="4" value="${status.count}" readonly="readonly" /></td>
										<td><input type="text" id="fechaInicio${status.count}" name="fechaInicioGrid" size="15" value="${amortizacion.fechaInicio}" readonly="readonly" /></td>
										<td><input type="text" id="fechaVencim${status.count}" name="fechaVencim" size="15" value="${amortizacion.fechaVencim}" onblur="comparaFechas(this.id);" /></td>
										<td><input type="text" id="fechaExigible${status.count}" name="fechaExigible" size="15" value="${amortizacion.fechaExigible}" readonly="readonly" /></td>
										<td><input type="text" id="capital${status.count}" name="capital" size="18" style="text-align: right;" value="${amortizacion.capital}" esMoneda="true" /></td>
										<td><input type="text" id="interes${status.count}" name="interes" size="18" style="text-align: right;" value="${amortizacion.interes}" readonly="readonly" esMoneda="true" /></td>
										<td><input type="text" id="ivaInteres${status.count}" name="ivaInteres" size="18" style="text-align: right;" value="${amortizacion.ivaInteres}" readonly="readonly" esMoneda="true" /></td>
										<c:if test="${var_cobraSeguroCuota == 'S'}">
											<td><input id="montoSeguroCuota${status.count}" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoSeguroCuota}" readonly="readonly" disabled="disabled" esMoneda="true" /></td>
											<td><input id="iVASeguroCuota${status.count}" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.iVASeguroCuota}" readonly="readonly" disabled="disabled" esMoneda="true" /></td>
										</c:if>
										<c:if test="${cobraAccesorios == 'S'}">
											<td><input id="otrasComisiones${status.count}" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
											<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoIVAOtrasCom}" readonly="readonly" esMoneda="true" /></td>
										</c:if>
										<td><input type="text" id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" value="${amortizacion.totalPago}" readonly="readonly" esMoneda="true" /></td>
										<td><input type="text" id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;" value="${amortizacion.saldoInsoluto}" readonly="readonly" esMoneda="true" /></td>
									</tr>

									<c:set var="cuotas8" value="${status.count}" />
									<c:set var="fechaVenc8" value="${amortizacion.fechaVencim}" />
									<c:set var="numTransaccion8" value="${amortizacion.numTransaccion}" />
									<c:set var="valorCat4" value="${amortizacion.cat}" />
									<c:set var="valorFecUltAmor4" value="${amortizacion.fecUltAmor}" />
									<c:set var="valorfecInicioAmor4" value="${amortizacion.fecInicioAmor}" />
									<c:set var="varTotalSeguroCuota8" value="${amortizacion.totalSeguroCuota}"/>
									<c:set var="varTotalIVASeguroCuota8" value="${amortizacion.totalIVASeguroCuota}"/>
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
										<td><input id="totalSeguroCuota" value="${varTotalSeguroCuota8}" name="totalSeguroCuota" size="18" readOnly="true" style="text-align: right;" esMoneda="true" /></td>
										<td><input id="iVATotalSeguroCuota" value="${varTotalIVASeguroCuota8}" name="iVATotalSeguroCuota" size="18" readOnly="true" style="text-align: right;" esMoneda="true"/></td>
									</c:if>
									<c:if test="${cobraAccesorios == 'S'}">
										<td><input id="otrasComisiones" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${varTotalOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
										<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${varTotalIVAOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
									</c:if>
								</tr>
								<tr>
									<td colspan="8" align="right"><input id="transaccion" name="transaccion" size="18" type="hidden" value="${numTransaccion8}" readonly="readonly" disabled="true" /> <input id="valorCat" name="valorCat" size="18" type="hidden" value="${valorCat4}" readonly="readonly" disabled="true" />
										<input id="valorFecUltAmor" name="valorFecUltAmor" size="18" type="hidden" value="${valorFecUltAmor4}" readonly="readonly" disabled="true" /> <input id="valorfecInicioAmor" name="valorfecInicioAmor" size="18" type="hidden" value="${valorfecInicioAmor4}" readonly="readonly" disabled="true" /></td>
									<td align="right"><input type="button" class="submit" id="continuarTV" value="Recalcular" onclick="simuladorLibresCapFec();" /></td>
								</tr>
							</c:when>
							<c:when test="${tipoLista == '9'}">
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
									<td class="label" align="center"></td>
								</tr>

								<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
									<tr id="renglon${status.count}" name="renglon">
										<td><input type="text" id="consecutivoID${status.count}" name="consecutivoID" size="4" value="${status.count}" readonly="readonly" /></td>
										<td align="center"><input type="text" id="fechaInicio${status.count}" name="fechaInicioGrid" size="15" value="${amortizacion.fechaInicio}" readonly="readonly" /></td>
										<td align="center"><input type="text" id="fechaVencim${status.count}" name="fechaVencim" size="15" value="${amortizacion.fechaVencim}" onblur="comparaFechas(this.id);" /></td>
										<td align="center"><input type="text" id="fechaExigible${status.count}" name="fechaExigible" size="15" value="${amortizacion.fechaExigible}" readonly="readonly" /></td>
										<td><input type="text" id="capital${status.count}" name="capital" size="18" style="text-align: right;" value="${amortizacion.capital}" esMoneda="true" onblur="calculaDiferenciaSimuladorLibre();" /></td>
										<td><input type="text" id="interes${status.count}" name="interes" size="18" style="text-align: right;" value="${amortizacion.interes}" readonly="readonly" esMoneda="true" /></td>
										<td><input type="text" id="ivaInteres${status.count}" name="ivaInteres" size="18" style="text-align: right;" value="${amortizacion.ivaInteres}" readonly="readonly" esMoneda="true" /></td>
										<c:if test="${var_cobraSeguroCuota == 'S'}">
											<td><input id="montoSeguroCuota${status.count}" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoSeguroCuota}" readonly="readonly" disabled="disabled" esMoneda="true" /></td>
											<td><input id="iVASeguroCuota${status.count}" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.iVASeguroCuota}" readonly="readonly" disabled="disabled" esMoneda="true" /></td>
										</c:if>
										<c:if test="${cobraAccesorios == 'S'}">
											<td><input id="otrasComisiones${status.count}" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
											<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoIVAOtrasCom}" readonly="readonly" esMoneda="true" /></td>
										</c:if>
										<td><input type="text" id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" value="${amortizacion.totalPago}" readonly="readonly" esMoneda="true" /></td>
										<td><input type="text" id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;" value="${amortizacion.saldoInsoluto}" readonly="readonly" esMoneda="true" /></td>

									</tr>

									<c:set var="cuotas7" value="${status.count}" />
									<c:set var="fechaVenc7" value="${amortizacion.fechaVencim}" />
									<c:set var="numTransaccion7" value="${amortizacion.numTransaccion}" />
									<c:set var="valorCat3" value="${amortizacion.cat}" />
									<c:set var="valorFecUltAmor3" value="${amortizacion.fecUltAmor}" />
									<c:set var="valorfecInicioAmor3" value="${amortizacion.fecInicioAmor}" />
									<c:set var="valorCuotasCap" value="${amortizacion.cuotasCapital}" />
									<c:set var="valorCuotasInt" value="${amortizacion.cuotasInteres}" />
									<c:set var="varTotalSeguroCuota9" value="${amortizacion.totalSeguroCuota}"/>
									<c:set var="varTotalIVASeguroCuota9" value="${amortizacion.totalIVASeguroCuota}"/>
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
										<td><input id="totalSeguroCuota" value="${varTotalSeguroCuota9}" name="totalSeguroCuota" size="18" readOnly="true" style="text-align: right;" esMoneda="true" /></td>
										<td><input id="iVATotalSeguroCuota" value="${varTotalIVASeguroCuota9}" name="iVATotalSeguroCuota" size="18" readOnly="true" style="text-align: right;" esMoneda="true"/></td>
									</c:if>
									<c:if test="${cobraAccesorios == 'S'}">
										<td><input id="otrasComisiones" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${varTotalOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
										<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${varTotalIVAOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
									</c:if>
								</tr>
								<tr>
									<td colspan="10" align="right"><input type="hidden" value="${cuotas7}" name="numeroDetalle" id="numeroDetalle" /> <input id="transaccion" name="transaccion" size="18" type="hidden" value="${numTransaccion7}" readonly="readonly" disabled="true" /> <input id="valorCat" name="valorCat"
										size="18" type="hidden" value="${valorCat3}" readonly="readonly" disabled="true" /> <input id="valorFecUltAmor" name="valorFecUltAmor" size="18" type="hidden" value="${valorFecUltAmor3}" readonly="readonly" disabled="true" /> <input id="valorfecInicioAmor" name="valorfecInicioAmor"
										size="18" type="hidden" value="${valorfecInicioAmor3}" readonly="readonly" disabled="true" /> <input id=valorCuotasCapital name="valorCuotasCapital" size="18" type="hidden" value="${valorCuotasCap}" readonly="readonly" disabled="true" /> <input id="valorCuotasInteres"
										name="valorCuotasInteres" size="18" type="hidden" value="${valorCuotasInt}" readonly="readonly" disabled="true" /></td>
								</tr>
								<tr id="trDiferenciaCapital">
									<td colspan="4" align="right"><label for="Diferencia">Diferencia: </label></td>
									<td id="inputDiferenciaCap"><input type="text" id="diferenciaCapital" name="diferenciaCapital" size="18" style="text-align: right;" value="0.00" readonly="readonly" esMoneda="true" /></td>
									<td colspan="5"></td>
								</tr>
							</c:when>
						</c:choose>
					</c:when>
				</c:choose>
			</table>
		</c:if>
	</form>
</fieldset>

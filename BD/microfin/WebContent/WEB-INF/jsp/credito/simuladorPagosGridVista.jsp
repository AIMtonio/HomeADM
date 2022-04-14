<!-- PARA CRECIENTES, IGUALES,GLOBALES,LIBRES(Después de haber calculado)
	USADO EN LAS PANTALLAS DE SOLICITUD DE CREDITO, ALTA DE CREDITO Y REESTRUCTURAS -->
<?xml version="1.0" encoding="UTF-8"?>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="fechaVencimiento" value="${listaResultado[1]}" />
<c:set var="listaPaginada" value="${listaResultado[2]}" />
<c:set var="numErr2">${listaResultado[3]}</c:set>
<c:set var="mesErr" value="${listaResultado[4]}" />
<c:set var="var_cobraSeguroCuota" value="${listaResultado[5]}" />
<c:set var="cobraAccesorios" value="${listaResultado[6]}" />
<c:set var="listaResultado" value="${listaPaginada.pageList}" />

<input type="hidden" id="numeroErrorList" name="numeroErrorList" value="${numErr2}" />
<input type="hidden" id="mensajeErrorList" name="mensajeErrorList" value="<c:out value="${mesErr}"/>" />
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Simulador de Amortizaciones</legend>
	<c:if test="${numErr2 == 0}">
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '1'}">
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
						<td class="label" align="center"><label for="lblSaldoCapital">Saldo Capital</label></td>
					</tr>

					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td><input id="amortizacionID${status.count}" name="amortizacionID" size="8" type="text" value="${amortizacion.amortizacionID}" readonly="readonly" /></td>
							<td><input id="fechaInicio${status.count}" name="fechaInicioGrid" size="11" type="text" value="${amortizacion.fechaInicio}" readonly="readonly" /></td>
							<td><input id="fechaVencim${status.count}" name="fechaVencim" size="11" type="text" value="${amortizacion.fechaVencim}" readonly="readonly" /></td>
							<td><input id="fechaExigible${status.count}" name="fechaExigible" size="11" type="text" value="${amortizacion.fechaExigible}" readonly="readonly" /></td>
							<td id="capital"><input id="capital${status.count}" name="capital" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.capital}" readonly="readonly" esMoneda="true" /></td>
							<td id="interes"><input id="interes${status.count}" name="interes" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.interes}" readonly="readonly" esMoneda="true" /></td>
							<td id="IvaInteres"><input id="ivaInteres${status.count}" name="ivaInteres" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.ivaInteres}" readonly="readonly" esMoneda="true" /></td>
							<c:if test="${var_cobraSeguroCuota == 'S'}">
								<td><input id="montoSeguroCuota${status.count}" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoSeguroCuota}" readonly="readonly" esMoneda="true" /></td>
								<td><input id="iVASeguroCuota${status.count}" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.iVASeguroCuota}" readonly="readonly" esMoneda="true" /></td>
							</c:if>
							<c:if test="${cobraAccesorios == 'S'}">
								<td><input id="otrasComisiones${status.count}" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
								<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoIVAOtrasCom}" readonly="readonly" esMoneda="true" /></td>
							</c:if>
							<td><input id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.totalPago}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.saldoInsoluto}" readonly="readonly" esMoneda="true" /></td>
						</tr>

						<c:set var="cuotas" value="${amortizacion.cuotasCapital}" />
						<c:set var="numTransaccion" value="${amortizacion.numTransaccion}" />
						<c:set var="valorCat" value="${amortizacion.cat}" />
						<c:set var="valorFecUltAmor" value="${amortizacion.fecUltAmor}" />
						<c:set var="valorfecInicioAmor" value="${amortizacion.fecInicioAmor}" />
						<c:set var="valorMontoCuota" value="${amortizacion.montoCuota}" />
						<c:set var="varTotalCapital" value="${amortizacion.totalCap}" />
						<c:set var="varTotalInteres" value="${amortizacion.totalInteres}" />
						<c:set var="varTotalIva" value="${amortizacion.totalIva}" />
						<c:set var="varTotalSeguroCuota" value="${amortizacion.totalSeguroCuota}" />
						<c:set var="varTotalIVASeguroCuota" value="${amortizacion.totalIVASeguroCuota}" />
						<c:set var="varTotalOtrasComisiones" value="${amortizacion.totalOtrasComisiones}" />
						<c:set var="varTotalIVAOtrasComisiones" value="${amortizacion.totalIVAOtrasComisiones}" />
						
					</c:forEach>
					<tr>
						<td colspan="9" align="right"><input id="transaccion" name="transaccion" size="18" style="text-align: right;" type="hidden" value="${numTransaccion}" readonly="readonly" disabled="disabled" esMoneda="true" /> <input id="cuotas" name="cuotas" size="18" style="text-align: right;"
							type="hidden" value="${cuotas}" readonly="readonly" disabled="disabled" /> <input id="valorCuotasInt" name="valorCuotasInt" size="18" style="text-align: right;" type="hidden" value="${cuotas}" readonly="readonly" disabled="disabled" /> <input id="valorCat" name="valorCat" size="18"
							style="text-align: right;" type="hidden" value="${valorCat}" readonly="readonly" disabled="disabled" /> <input id="valorFecUltAmor" name="valorFecUltAmor" size="18" style="text-align: right;" type="hidden" value="${valorFecUltAmor}" readonly="readonly" disabled="disabled" /> <input
							id="valorfecInicioAmor" name="valorfecInicioAmor" size="18" style="text-align: right;" type="hidden" value="${valorfecInicioAmor}" readonly="readonly" disabled="disabled" /> <input id="valorMontoCuota" name="valorMontoCuota" size="18" style="text-align: right;" type="hidden"
							value="${valorMontoCuota}" readonly="readonly" disabled="disabled" /></td>
					</tr>
					<tr id="filaTotales" style="display: none;">
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="label"><label for="lblTotales">Totales: </label></td>
						<td><input id="totalCap" name="totalCap" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalCapital}" /></td>
						<td><input id="totalInt" name="totalInt" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalInteres}" /></td>
						<td><input id="totalIva" name="totalIva" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalIva}" /></td>
						<c:if test="${var_cobraSeguroCuota == 'S'}">
							<td><input id="totalSeguroCuota" name="totalSeguroCuota" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalSeguroCuota}" /></td>
							<td><input id="iVATotalSeguroCuota" name="iVATotalSeguroCuota" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalIVASeguroCuota}" /></td>
						</c:if>
						<c:if test="${cobraAccesorios == 'S'}">
							<td><input id="otrasComisiones" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${varTotalOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${varTotalIVAOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
						</c:if>
					</tr>
				</c:when>

				<c:when test="${tipoLista == '2'}">
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
						<td class="label" align="center" id="labelTotalPago"><label for="lblTotalPag">Total Pago</label></td>
						<td class="label" align="center"><label for="lblSaldoCapital">Saldo Capital</label></td>
					</tr>

					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td><input id="amortizacionID${status.count}" name="amortizacionID" size="4" type="text" value="${amortizacion.amortizacionID}" readonly="readonly" /></td>
							<td><input id="fechaInicio${status.count}" name="fechaInicioGrid" size="15" type="text" value="${amortizacion.fechaInicio}" readonly="readonly" /></td>
							<td><input id="fechaVencim${status.count}" name="fechaVencim" size="15" type="text" value="${amortizacion.fechaVencim}" readonly="readonly" /></td>
							<td><input id="fechaExigible${status.count}" name="fechaExigible" size="15" type="text" value="${amortizacion.fechaExigible}" readonly="readonly" /></td>
							<td><input id="capital${status.count}" name="capital" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.capital}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="interes${status.count}" name="interes" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.interes}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="ivaInteres${status.count}" name="ivaInteres" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.ivaInteres}" readonly="readonly" esMoneda="true" /></td>
							<c:if test="${var_cobraSeguroCuota == 'S'}">
								<td><input id="montoSeguroCuota${status.count}" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoSeguroCuota}" readonly="readonly" esMoneda="true" /></td>
								<td><input id="iVASeguroCuota${status.count}" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.iVASeguroCuota}" readonly="readonly" esMoneda="true" /></td>
							</c:if>
							<c:if test="${cobraAccesorios == 'S'}">
								<td><input id="otrasComisiones${status.count}" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
								<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoIVAOtrasCom}" readonly="readonly" esMoneda="true" /></td>
							</c:if>
							<td><input id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.totalPago}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.saldoInsoluto}" readonly="readonly" esMoneda="true" /></td>
						</tr>

						<c:set var="cuotas2" value="${amortizacion.cuotasCapital}" />
						<c:set var="numTransaccion2" value="${amortizacion.numTransaccion}" />
						<c:set var="valorCat2" value="${amortizacion.cat}" />
						<c:set var="valorFecUltAmor" value="${amortizacion.fecUltAmor}" />
						<c:set var="valorfecInicioAmor2" value="${amortizacion.fecInicioAmor}" />
						<c:set var="valorCuotasInt" value="${amortizacion.cuotasInteres}" />
						<c:set var="valorMontoCuota2" value="${amortizacion.montoCuota}" />
						<c:set var="varTotalCapital" value="${amortizacion.totalCap}" />
						<c:set var="varTotalInteres" value="${amortizacion.totalInteres}" />
						<c:set var="varTotalIva" value="${amortizacion.totalIva}" />
						<c:set var="varTotalSeguroCuota2" value="${amortizacion.totalSeguroCuota}" />
						<c:set var="varTotalIVASeguroCuota2" value="${amortizacion.totalIVASeguroCuota}" />
						<c:set var="varTotalOtrasComisiones" value="${amortizacion.totalOtrasComisiones}" />
						<c:set var="varTotalIVAOtrasComisiones" value="${amortizacion.totalIVAOtrasComisiones}" />

					</c:forEach>
					<tr>
						<td colspan="9" align="right"><input id="transaccion" name="transaccion" size="18" style="text-align: right;" type="hidden" value="${numTransaccion2}" readonly="readonly" disabled="disabled" esMoneda="true" /> <input id="cuotas" name="cuotas" size="18" style="text-align: right;"
							type="hidden" value="${cuotas2}" readonly="readonly" disabled="disabled" esMoneda="true" /> <input id="valorCat" name="valorCat" size="18" style="text-align: right;" type="hidden" value="${valorCat2}" readonly="readonly" disabled="disabled" /> <input id="valorFecUltAmor"
							name="valorFecUltAmor" size="18" style="text-align: right;" type="hidden" value="${valorFecUltAmor}" readonly="readonly" disabled="disabled" /> <input id="valorfecInicioAmor" name="valorfecInicioAmor" size="18" style="text-align: right;" type="hidden" value="${valorfecInicioAmor2}"
							readonly="readonly" disabled="disabled" /> <input id="valorCuotasInt" name="valorCuotasInt" size="18" style="text-align: right;" type="hidden" value="${valorCuotasInt}" readonly="readonly" disabled="disabled" /> <input id="valorMontoCuota" name="valorMontoCuota" size="18"
							style="text-align: right;" type="hidden" value="${valorMontoCuota2}" readonly="readonly" disabled="disabled" /></td>
					</tr>
					<tr id="filaTotales" style="display: none;">
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="label"><label for="lblTotales">Totales: </label></td>
						<td><input id="totalCap" name="totalCap" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalCapital}" /></td>
						<td><input id="totalInt" name="totalInt" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalInteres}" /></td>
						<td><input id="totalIva" name="totalIva" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalIva}" /></td>
						<c:if test="${var_cobraSeguroCuota == 'S'}">
							<td><input id="totalSeguroCuota" value="${varTotalSeguroCuota2}" name="totalSeguroCuota" size="18" readOnly="true" style="text-align: right;" esMoneda="true" /></td>
							<td><input id="iVATotalSeguroCuota" value="${varTotalIVASeguroCuota2}" name="iVATotalSeguroCuota" size="18" readOnly="true" style="text-align: right;" esMoneda="true" /></td>
						</c:if>
						<c:if test="${cobraAccesorios == 'S'}">
							<td><input id="otrasComisiones" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${varTotalOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${varTotalIVAOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
						</c:if>
					</tr>
				</c:when>
				<c:when test="${tipoLista == '4'}">
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
						<td class="label" align="center"><label for="lblSaldoCapital">Saldo Capital</label></td>
					</tr>

					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td><input id="amortizacionID${status.count}" name="amortizacionID" size="4" type="text" value="${amortizacion.amortizacionID}" readonly="readonly" /></td>
							<td><input id="fechaInicio${status.count}" name="fechaInicioGrid" size="15" type="text" value="${amortizacion.fechaInicio}" readonly="readonly" /></td>
							<td><input id="fechaVencim${status.count}" name="fechaVencim" size="15" type="text" value="${amortizacion.fechaVencim}" readonly="readonly" /></td>
							<td><input id="fechaExigible${status.count}" name="fechaExigible" size="15" type="text" value="${amortizacion.fechaExigible}" readonly="readonly" /></td>
							<td><input id="capital${status.count}" name="capital" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.capital}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="interes${status.count}" name="interes" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.interes}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="ivaInteres${status.count}" name="ivaInteres" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.ivaInteres}" readonly="readonly" esMoneda="true" /></td>
							<c:if test="${var_cobraSeguroCuota == 'S'}">
								<td><input id="montoSeguroCuota${status.count}" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoSeguroCuota}" readonly="readonly" esMoneda="true" /></td>
								<td><input id="iVASeguroCuota${status.count}" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.iVASeguroCuota}" readonly="readonly" esMoneda="true" /></td>
							</c:if>
							<c:if test="${cobraAccesorios == 'S'}">
								<td><input id="otrasComisiones${status.count}" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
								<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoIVAOtrasCom}" readonly="readonly" esMoneda="true" /></td>
							</c:if>
							<td><input id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.totalPago}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.saldoInsoluto}" readonly="readonly" esMoneda="true" /></td>
						</tr>

						<c:set var="cuotas4" value="${amortizacion.cuotasCapital}" />
						<c:set var="numTransaccion4" value="${amortizacion.numTransaccion}" />
						<c:set var="valorCat4" value="${amortizacion.cat}" />
						<c:set var="valorFecUltAmor" value="${amortizacion.fecUltAmor}" />
						<c:set var="valorfecInicioAmor4" value="${amortizacion.fecInicioAmor}" />
						<c:set var="valorCuotasInt2" value="${amortizacion.cuotasInteres}" />
						<c:set var="valorMontoCuota4" value="${amortizacion.montoCuota}" />
						<c:set var="varTotalSeguroCuota4" value="${amortizacion.totalSeguroCuota}" />
						<c:set var="varTotalIVASeguroCuota4" value="${amortizacion.totalIVASeguroCuota}" />
						<c:set var="varTotalOtrasComisiones" value="${amortizacion.totalOtrasComisiones}" />
						<c:set var="varTotalIVAOtrasComisiones" value="${amortizacion.totalIVAOtrasComisiones}" />

					</c:forEach>
					<tr>
						<td colspan="9" align="right"><input id="transaccion" name="transaccion" size="18" style="text-align: right;" type="hidden" value="${numTransaccion4}" readonly="readonly" disabled="disabled" esMoneda="true" /> <input id="cuotas" name="cuotas" size="18" style="text-align: right;"
							type="hidden" value="${cuotas4}" readonly="readonly" disabled="disabled" esMoneda="true" /> <input id="valorCat" name="valorCat" size="18" style="text-align: right;" type="hidden" value="${valorCat4}" readonly="readonly" disabled="disabled" /> <input id="valorFecUltAmor"
							name="valorFecUltAmor" size="18" style="text-align: right;" type="hidden" value="${valorFecUltAmor}" readonly="readonly" disabled="disabled" /> <input id="valorfecInicioAmor" name="valorfecInicioAmor" size="18" style="text-align: right;" type="hidden" value="${valorfecInicioAmor4}"
							readonly="readonly" disabled="disabled" /> <input id="valorCuotasInt" name="valorCuotasInt" size="18" style="text-align: right;" type="hidden" value="${valorCuotasInt2}" readonly="readonly" disabled="disabled" /> <input id="valorMontoCuota" name="valorMontoCuota" size="18"
							style="text-align: right;" type="hidden" value="${valorMontoCuota4}" readonly="readonly" disabled="disabled" /></td>
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
						<td class="label" align="center"><label for="lblSaldoCapital">Saldo Capital</label></td>
					</tr>

					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td><input id="amortizacionID${status.count}" name="amortizacionID" size="4" type="text" value="${amortizacion.amortizacionID}" readonly="readonly" /></td>
							<td><input id="fechaInicio${status.count}" name="fechaInicioGrid" size="15" type="text" value="${amortizacion.fechaInicio}" readonly="readonly" /></td>
							<td><input id="fechaVencim${status.count}" name="fechaVencim" size="15" type="text" value="${amortizacion.fechaVencim}" readonly="readonly" /></td>
							<td><input id="fechaExigible${status.count}" name="fechaExigible" size="15" type="text" value="${amortizacion.fechaExigible}" readonly="readonly" /></td>
							<td><c:choose>
									<c:when test="${amortizacion.capitalInteres == 'I'}">
										<input type="text" id="capital${status.count}" name="capital" size="18" style="text-align: right;" value="0" readonly="readonly" esMoneda="true" />
									</c:when>

									<c:when test="${amortizacion.capitalInteres == 'C'}">
										<input type="text" id="capital${status.count}" name="capital" size="18" style="text-align: right;" value=" " esMoneda="true" />
									</c:when>

									<c:when test="${amortizacion.capitalInteres == 'G'}">
										<input type="text" id="capital${status.count}" name="capital" size="18" style="text-align: right;" value=" " esMoneda="true" />
									</c:when>
								</c:choose></td>
							<td><input type="text" id="interes${status.count}" name="interes" size="18" style="text-align: right;" value="" readonly="readonly" disabled="true" esMoneda="true" /></td>
							<td><input type="text" id="ivaInteres${status.count}" name="ivaInteres" size="18" style="text-align: right;" value="" readonly="readonly" disabled="true" esMoneda="true" /></td>
							<c:if test="${var_cobraSeguroCuota == 'S'}">
								<td><input id="montoSeguroCuota${status.count}" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoSeguroCuota}" readonly="readonly" esMoneda="true" /></td>
								<td><input id="iVASeguroCuota${status.count}" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.iVASeguroCuota}" readonly="readonly" esMoneda="true" /></td>
							</c:if>
							<c:if test="${cobraAccesorios == 'S'}">
								<td><input id="otrasComisiones${status.count}" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
								<td><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoIVAOtrasCom}" readonly="readonly" esMoneda="true" /></td>
							</c:if>
							<td><input type="text" id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" value="" readonly="readonly" disabled="true" esMoneda="true" /></td>
							<td><input type="text" id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;" value="" readonly="readonly" disabled="true" esMoneda="true" /></td>
						</tr>

						<c:set var="cuotas5" value="${amortizacion.cuotasCapital}" />
						<c:set var="fechaVenc5" value="${amortizacion.fechaVencim}" />
						<c:set var="numTransaccion5" value="${amortizacion.numTransaccion}" />
						<c:set var="valorCat5" value="${amortizacion.cat}" />
						<c:set var="valorFecUltAmor" value="${amortizacion.fecUltAmor}" />
						<c:set var="valorfecInicioAmor5" value="${amortizacion.fecInicioAmor}" />
						<c:set var="valorMontoCuota5" value="${amortizacion.montoCuota}" />
						<c:set var="varTotalSeguroCuota5" value="${amortizacion.totalSeguroCuota}" />
						<c:set var="varTotalIVASeguroCuota5" value="${amortizacion.totalIVASeguroCuota}" />
						<c:set var="varTotalOtrasComisiones" value="${amortizacion.totalOtrasComisiones}" />
						<c:set var="varTotalIVAOtrasComisiones" value="${amortizacion.totalIVAOtrasComisiones}" />

					</c:forEach>
					<tr>
						<td colspan="9" align="right"><input id="transaccion" name="transaccion" size="18" style="text-align: right;" type="hidden" value="${numTransaccion5}" readonly="readonly" disabled="disabled" esMoneda="true" /> <input id="cuotas" name="cuotas" size="18" style="text-align: right;"
							type="hidden" value="${cuotas5}" readonly="readonly" disabled="disabled" esMoneda="true" /> <input id="valorCuotasInt" name="valorCuotasInt" size="18" style="text-align: right;" type="hidden" value="${cuotas5}" readonly="readonly" disabled="disabled" /> <input id="valorCat" name="valorCat"
							size="18" style="text-align: right;" type="hidden" value="${valorCat5}" readonly="readonly" disabled="disabled" /> <input id="valorFecUltAmor" name="valorFecUltAmor" size="18" style="text-align: right;" type="hidden" value="${valorFecUltAmor}" readonly="readonly" disabled="disabled" /> <input
							id="valorfecInicioAmor" name="valorfecInicioAmor" size="18" style="text-align: right;" type="hidden" value="${valorfecInicioAmor5}" readonly="readonly" disabled="disabled" /> <input id="valorMontoCuota" name="valorMontoCuota" size="18" style="text-align: right;" type="hidden"
							value="${valorMontoCuota5}" readonly="readonly" disabled="disabled" /></td>
					</tr>

				</c:when>

				<c:when test="${tipoLista == '11'}">
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
							<td id="tdLabelOtrasComis" class="label" align="center"><label for="lblOtrasComisiones">Otras Comisiones</label></td>
							<td id="tdLabelIvaOtrasComis" class="label" align="center"><label for="lblIVAOtrasComisiones">IVA Otras Comisiones</label></td>
							<input type="hidden" id="tdEncabezadoAccesorios" value="" />
						</c:if>
						<td class="label" align="center"><label for="lblTotalPag">Total Pago</label></td>
						<td class="label" align="center"><label for="lblSaldoCapital">Saldo Capital</label></td>
					</tr>

					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td><input id="amortizacionID${status.count}" name="amortizacionID" size="4" type="text" value="${amortizacion.amortizacionID}" readonly="readonly" /></td>
							<td><input id="fechaInicio${status.count}" name="fechaInicioGrid" size="15" type="text" value="${amortizacion.fechaInicio}" readonly="readonly" /></td>
							<td><input id="fechaVencim${status.count}" name="fechaVencim" size="15" type="text" value="${amortizacion.fechaVencim}" readonly="readonly" /></td>
							<td><input id="fechaExigible${status.count}" name="fechaExigible" size="15" type="text" value="${amortizacion.fechaExigible}" readonly="readonly" /></td>
							<td><input id="capital${status.count}" name="capital" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.capital}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="interes${status.count}" name="interes" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.interes}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="ivaInteres${status.count}" name="ivaInteres" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.ivaInteres}" readonly="readonly" esMoneda="true" /></td>
							<c:if test="${var_cobraSeguroCuota == 'S'}">
								<td><input id="montoSeguroCuota${status.count}" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoSeguroCuota}" readonly="readonly" esMoneda="true" /></td>
								<td><input id="iVASeguroCuota${status.count}" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.iVASeguroCuota}" readonly="readonly" esMoneda="true" /></td>
							</c:if>
							<c:if test="${cobraAccesorios == 'S'}">
								<td id="tdOtrasComisiones${status.count}"><input id="otrasComisiones${status.count}" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
								<td id="tdIvaOtrasComisiones${status.count}"><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${amortizacion.saldoIVAOtrasCom}" readonly="readonly" esMoneda="true" /></td>
								<input type="hidden" id="tdMontosAccesorios${status.count}" value="" />
							</c:if>
							<td><input id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.totalPago}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.saldoInsoluto}" readonly="readonly" esMoneda="true" /></td>
						</tr>

						<c:set var="cuotas2" value="${amortizacion.cuotasCapital}" />
						<c:set var="numTransaccion2" value="${amortizacion.numTransaccion}" />
						<c:set var="valorCat2" value="${amortizacion.cat}" />
						<c:set var="valorFecUltAmor" value="${amortizacion.fecUltAmor}" />
						<c:set var="valorfecInicioAmor2" value="${amortizacion.fecInicioAmor}" />
						<c:set var="valorMontoCuota" value="${amortizacion.montoCuota}" />
						<c:set var="varTotalCapital" value="${amortizacion.totalCap}" />
						<c:set var="varTotalInteres" value="${amortizacion.totalInteres}" />
						<c:set var="varTotalIva" value="${amortizacion.totalIva}" />
						<c:set var="varTotalSeguroCuota11" value="${amortizacion.totalSeguroCuota}" />
						<c:set var="varTotalIVASeguroCuota11" value="${amortizacion.totalIVASeguroCuota}" />
						<c:set var="varTotalOtrasComisiones" value="${amortizacion.totalOtrasComisiones}" />
						<c:set var="varTotalIVAOtrasComisiones" value="${amortizacion.totalIVAOtrasComisiones}" />

					</c:forEach>
					<tr>
						<td colspan="9" align="right"><input id="transaccion" name="transaccion" size="18" style="text-align: right;" type="hidden" value="${numTransaccion2}" readonly="readonly" disabled="disabled" esMoneda="true" /> <input id="cuotas" name="cuotas" size="18" style="text-align: right;"
							type="hidden" value="${cuotas2}" readonly="readonly" disabled="disabled" esMoneda="true" /> <input id="valorCuotasInt" name="valorCuotasInt" size="18" style="text-align: right;" type="hidden" value="${cuotas2}" readonly="readonly" disabled="disabled" /> <input id="valorCat" name="valorCat"
							size="18" style="text-align: right;" type="hidden" value="${valorCat2}" readonly="readonly" disabled="disabled" /> <input id="valorFecUltAmor" name="valorFecUltAmor" size="18" style="text-align: right;" type="hidden" value="${valorFecUltAmor}" readonly="readonly" disabled="disabled" /> <input
							id="valorfecInicioAmor" name="valorfecInicioAmor" size="18" style="text-align: right;" type="hidden" value="${valorfecInicioAmor2}" readonly="readonly" disabled="disabled" /> <input id="valorMontoCuota" name="valorMontoCuota" size="18" style="text-align: right;" type="hidden"
							value="${valorMontoCuota}" readonly="readonly" disabled="disabled" /></td>
					</tr>
					<tr id="filaTotales" style="display: none;">
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="label"><label for="lblTotales">Totales: </label></td>
						<td><input id="totalCap" name="totalCap" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalCapital}" /></td>
						<td><input id="totalInt" name="totalInt" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalInteres}" /></td>
						<td><input id="totalIva" name="totalIva" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalIva}" /></td>
						<c:if test="${var_cobraSeguroCuota == 'S'}">
							<td><input id="totalSeguroCuota" value="${varTotalSeguroCuota11}" name="totalSeguroCuota" size="18" readOnly="true" style="text-align: right;" esMoneda="true" /></td>
							<td><input id="iVATotalSeguroCuota" value="${varTotalIVASeguroCuota11}" name="iVATotalSeguroCuota" size="18" readOnly="true" style="text-align: right;" esMoneda="true" /></td>
						</c:if>
						<c:if test="${cobraAccesorios == 'S'}">
							<td id=tdTotalOtrasComis><input id="otrasComisiones" name="otrasComisiones" size="18" style="text-align: right;" type="text" value="${varTotalOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
							<td id=tdTotalIvaOtrasComis><input id="IVAotrasComisiones${status.count}" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" value="${varTotalIVAOtrasComisiones}" readonly="readonly" esMoneda="true" /></td>
							<input type="hidden" id="tdTotalVacio" value="" />
						</c:if>
					</tr>

				</c:when>

			</c:choose>
		</table>
	</c:if>


	<c:if test="${!listaPaginada.firstPage}">
		<input onclick="simulador('previous')" type="button" value="" id="anterior" class="btnAnterior" />
	</c:if>
	<c:if test="${!listaPaginada.lastPage}">
		<input onclick="simulador('next')" type="button" id="siguiente" value="" class="btnSiguiente" />
	</c:if>
	<input id="fech" type="hidden" value="${valorFecUltAmor}" />
	<script type="text/javascript">
	function simulador(pageValor){
		var pagoFinAni=""; 
		var pagoFinAniInt="";
		var diaHabilSig="";
		var ajustaFecAmo=""; 
		var ajusFecExiVen="";   
		var tipoLista =0; 
		var AltaCredito='C';
		var SolicitudCredito ='S';
		var Reestructuras	= 'R';
		
		var params = {};
		var valDiaPago=false;
		if($('#calendIrregular').is(':checked')){ 
			mostrarGridLibres();
		}else{
			if($('#calcInteresID').val()==1 ) {
				switch($('#tipoPagoCapital').val()){
					case "C": // si el tipo de pago es CRECIENTES
						tipoLista = 1;
						valDiaPago =true;
					break;
					case "I" :// si el tipo de pago es IGUALES
						tipoLista = 2;
						valDiaPago =true;
					break;
					case  "L": // si el tipo de pago es LIBRES
						tipoLista = 3;
						valDiaPago =true;
					break;
					default:		
						tipoLista = 1;
						valDiaPago =true;
				}
			}else{
				switch($('#tipoPagoCapital').val()){
					case "C": // si el tipo de pago es CRECIENTES
						alert("No se permiten pagos de capital Crecientes");
					break;
					case "I" :// si el tipo de pago es IGUALES
						tipoLista = 4;
						valDiaPago =true;
					break;
					case  "L": // si el tipo de pago es LIBRES
						tipoLista = 5;
						valDiaPago =true;
					break;
					default:		
						tipoLista = 4;
						valDiaPago =true;
				}
			}		
			//si el tipo de calculo de interes es MontoOriginal se valida tipo de Lista
			var tipoCalIn = $('#tipoCalInteres').val();
			if(tipoCalIn == '2'){
				tipoLista=11;
				valDiaPago =true;
			}			
						
			params['tipoLista'] = tipoLista; 
			
			if(valDiaPago){
				if($('#diaPagoCapital2').is(':checked')){				 
					pagoFinAni= $('#diaPagoCapital2').val();
				}else{
					pagoFinAni= $('#diaPagoCapital').val();
				}
				if($('#diaPagoInteres2').is(':checked')){				 
					pagoFinAniInt= $('#diaPagoInteres2').val();
				}else{
					pagoFinAniInt= $('#diaPagoInteres').val();
				}
				if($('#fechInhabil2').is(':checked')){ 
					diaHabilSig= $('#fechInhabil2').val();
				}else{
					diaHabilSig= $('#fechInhabil').val();
				}
				if($('#ajusFecExiVen2').is(':checked')){  	 
					ajusFecExiVen= $('#ajusFecExiVen2').val();
				}else{
					ajusFecExiVen= $('#ajusFecExiVen').val();
				}
				if($('#ajusFecUlVenAmo2').is(':checked')){  	 
					ajustaFecAmo= $('#ajusFecUlVenAmo2').val();
				}else{
					ajustaFecAmo= $('#ajusFecUlVenAmo').val();
				}
				
				params['montoCredito'] 	= $('#montoSolici').asNumber();
				params['tasaFija']		=  $('#tasaFija').asNumber();
				params['frecuenciaCap'] = $('#frecuenciaCap').val();
				params['frecuenciaInt'] = $('#frecuenciaInt').val();
				params['periodicidadCap'] = $('#periodicidadCap').val(); 
				params['periodicidadInt'] = $('#periodicidadInt').val();
				params['diaPagoCapital'] = pagoFinAni;
				params['diaPagoInteres'] = pagoFinAniInt;
				params['diaMesCapital'] = $('#diaMesCapital').val(); 
				params['diaMesInteres'] = $('#diaMesInteres').val(); 
				params['fechaInicio'] = $('#fechaInicio').val();
				params['fechaVencimien'] = $('#fechaVencimien').val();
				params['producCreditoID'] = $('#productoCreditoID').val();
				params['clienteID'] = $('#clienteID').val();
				params['fechaInhabil'] = diaHabilSig;
				params['ajusFecUlVenAmo'] = ajustaFecAmo; 
				params['ajusFecExiVen'] = ajusFecExiVen;
				params['numTransacSim'] = '0';
				params['montoComision'] = $('#montoComApert').val();
				params['montoGarLiq'] 	= $('#aporteCliente').val();
					 		
				params['empresaID'] = parametroBean.empresaID;
				params['usuario'] = parametroBean.numeroUsuario;
				params['fecha'] = parametroBean.fechaSucursal;
				params['direccionIP'] = parametroBean.IPsesion;
				params['sucursal'] = parametroBean.sucursal;
				params['page'] = pageValor ;
				params['fechaV'] = $('#fechaVencimien').val();
				//SEGUROS
				params['cobraSeguroCuota'] 	= $('#cobraSeguroCuota option:selected').val();
				params['cobraIVASeguroCuota'] 	= $('#cobraIVASeguroCuota option:selected').val();
				params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
				//FIN SEGUROS
				params['cobraAccesorios'] = cobraAccesorios;
				
				if($('#frecuenciaCap').val()== 1){
					alert("Debe Seleccionar la Frecuencia.");
				}
				$.post("simPagCredito.htm", params, function(data){
					if(data.length >0 || data != null) { 
						$('#contenedorSimulador').html(data); 
						$('#contenedorSimulador').show();
						 if($('#anterior').is(':visible') &&  $('#siguiente').is(':visible') == false ){
								$('#filaTotales').show();
						 }else{
								$('#filaTotales').hide();
						 }	
						 if($('#pantalla').val() == SolicitudCredito){
							 $('#imprimirRep').show();
							 $('#ExportExcel').show();
						 }else{
							 $('#ExportExcel').hide();
							 $('#imprimirRep').hide();
						 }
						 
						 muestraDescTasaVar('calcInteresID');
					}else{
						$('#contenedorSimulador').html("");
						$('#contenedorSimulador').show();
					}
					$('#contenedorForma').unblock();
				});  
			}
		}
	} //fin funcion simulador()
	</script>

	<table align="right">
		<tr>
			<td name="tdTasaVariable"><label id="lblTasaVariable">* Los montos est&aacute;n sujetos a la variaci&oacute;n de la tasa.</label></td>
			<td><input type="button" id="imprimirRep" class="submit" value="Imprimir" onclick="generaReporte();" />
			<input type="button" id="ExportExcel" class="submit" value="Exportar" onclick="exportarExcel();" /></td>
		</tr>
	</table>
</fieldset>
<script type="text/javascript">
	muestraDescTasaVar('calcInteresID');
	$('#ExportExcel').hide();
</script>
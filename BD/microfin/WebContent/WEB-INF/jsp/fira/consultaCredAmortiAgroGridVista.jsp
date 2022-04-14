<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
</head>
<body>
	<br></br>
	<c:set var="tipoLista" value="${listaResultado[0]}" />
	<c:set var="listaPaginada" value="${listaResultado[1]}" />
	<c:set var="var_cobraSeguroCuota" value="${listaResultado[2]}" />
	<c:set var="listaResultado" value="${listaPaginada.pageList}" />
	<div id="formaGenerica2" class="formaGenerica2">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Amortizaciones</legend>
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="950px" style="display: block; overflow-y: auto;">
				<c:choose>
					<c:when test="${tipoLista == '2'}">
						<thead>
							<tr>
								<td class="label">
									<label for="lblNumero">Num.</label>
								</td>
								<td class="label">
									<label for="lblFecIni">Fec.Inicio</label>
								</td>
								<td class="label">
									<label for="lblFecVen">Fec.Vencim</label>
								</td>
								<td class="label">
									<label for="lblFecExi">Fec.Exigible</label>
								</td>
								<td class="label">
									<label for="lblEstatus">Estatus</label>
								</td>
								<td class="label">
									<label for="lblCapital">Capital</label>
								</td>
								<td class="label">
									<label for="lblInteres">Interés</label>
								</td>
								<td class="label">
									<label for="lblIVAInt">IVA Interés</label>
								</td>
								<c:if test="${var_cobraSeguroCuota == 'S'}">
									<td class="label">
										<label for="lblCargos">Seguro</label>
									</td>
									<td class="label">
										<label for="lblCargos">IVA Seguro</label>
									</td>
								</c:if>
								<td class="label">
									<label for="lblIVAInt">Mon.Cuota</label>
								</td>
								<td class="label">
									<label for="lblSaldos">Saldos&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
								</td>
								<td class="label">
									<label for="lblCapVig">Cap.Vigente&nbsp;&nbsp;</label>
								</td>
								<td class="label">
									<label for="lblCapAtr">Cap.Atrasado&nbsp;&nbsp;</label>
								</td>
								<td class="label">
									<label for="lblCapVig">Cap.Vencido&nbsp;&nbsp;</label>
								</td>
								<td class="label">
									<label for="lblCapVNE">Cap.VenNoExi&nbsp;&nbsp;</label>
								</td>
								<td class="label">
									<label for="lblIVAInt">Int.Provisión&nbsp;</label>
								</td>
								<td class="label">
									<label for="lblCapVig">Int.Atrasado&nbsp;&nbsp;</label>
								</td>
								<td class="label">
									<label for="lblCapAtr">Int.Vencido&nbsp;&nbsp;</label>
								</td>
								<td class="label">
									<label for="lblCapVig">Int.NoCont&nbsp;&nbsp;</label>
								</td>
								<td class="label">
									<label for="lblIVAInt">IVA Int&nbsp;&nbsp;</label>
								</td>
								<td class="label">
									<label for="lblCapVig">Moratorio&nbsp;&nbsp;</label>
								</td>
								<td class="label">
									<label for="lblIVAInt">IVA Mora&nbsp;&nbsp;</label>
								</td>
								<td class="label" nowrap="nowrap">
									<label for="lblCapVig">Falta Pago&nbsp;&nbsp;</label>
								</td>
								<td class="label">
									<label for="lblIVAInt">IVA&nbsp;&nbsp;</label>
								</td>
								<td class="label">
									<label for="lblCapVig">OtrasCom&nbsp;&nbsp;</label>
								</td>
								<td class="label">
									<label for="lblIVAInt">IVA&nbsp;&nbsp;</label>
								</td>
								<c:if test="${var_cobraSeguroCuota == 'S'}">
									<td class="label">
										<label>Seguro</label>
									</td>
									<td class="label">
										<label>IVA Seguro</label>
									</td>
								</c:if>
								<td class="label">
									<label for="lblCapVig">Tot.Cuota</label>
								</td>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
								<tr id="renglon${status.count}" name="renglon">
									<td>
										<input id="amortizacionID${status.count}" name="amortizacionID" size="4" value="${amortizacion.amortizacionID}" readOnly="true" />
									</td>
									<td>
										<input id="fechaInicio${status.count}" name="fechaInicio" size="12" value="${amortizacion.fechaInicio}" readOnly="true" />
									</td>
									<td>
										<input id="fechaVencim${status.count}" name="fechaVencim" size="12" value="${amortizacion.fechaVencim}" readOnly="true" />
									</td>
									<td>
										<input id="fechaExigible${status.count}" name="fechaExigible" size="12" value="${amortizacion.fechaExigible}" readOnly="true" />
									</td>
									<c:if test="${amortizacion.estatus == 'I'}">
										<td>
											<input id="estatus${status.count}" name="estatus" size="12" value="INACTIVO" readOnly="true" />
										</td>
									</c:if>
									<c:if test="${amortizacion.estatus == 'V'}">
										<td>
											<input id="estatus${status.count}" name="estatus" size="12" value="VIGENTE" readOnly="true" />
										</td>
									</c:if>
									<c:if test="${amortizacion.estatus == 'A'}">
										<td>
											<input id="estatus${status.count}" name="estatus" size="12" value="ATRASADA" readOnly="true" />
										</td>
									</c:if>
									<c:if test="${amortizacion.estatus == 'P'}">
										<td>
											<input id="estatus${status.count}" name="estatus" size="12" value="PAGADA" readOnly="true" />
										</td>
									</c:if>
									<c:if test="${amortizacion.estatus == 'B'}">
										<td>
											<input id="estatus${status.count}" name="estatus" size="12" value="VENCIDA" readOnly="true" />
										</td>
									</c:if>
									<c:if test="${amortizacion.estatus == 'C'}">
										<td>
											<input id="estatus${status.count}" name="estatus" size="12" value="CANCELADA" readOnly="true" />
										</td>
									</c:if>
									<td>
										<input style="text-align: right" id="capital${status.count}" name="capital" size="11" align="right" value="${amortizacion.capital}" readOnly="true" esMoneda="true" />
									</td>
									<td>
										<input style="text-align: right" id="interes${status.count}" name="interes" size="10" value="${amortizacion.interes}" readOnly="true" esMoneda="true" />
									</td>
									<td>
										<input style="text-align: right" id="ivaInteres${status.count}" name="ivaInteres" size="10" align="right" value="${amortizacion.ivaInteres}" readOnly="true" esMoneda="true" />
									</td>
									<c:if test="${var_cobraSeguroCuota == 'S'}">
										<td>
											<input id="montoSeguroCuota${status.count}" name="montoSeguroCuotaSim" size="10" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoSeguroCuota}" readonly="readonly" esMoneda="true" />
										</td>
										<td>
											<input id="iVASeguroCuota${status.count}" name="iVASeguroCuotaSim" size="10" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.iVASeguroCuota}" readonly="readonly" esMoneda="true" />
										</td>
									</c:if>
									<td>
										<input style="text-align: right" id="montoCuota${status.count}" name="montoCuota" size="11" align="right" value="${amortizacion.montoCuota}" readOnly="true" esMoneda="true" />
									</td>
									<td>&nbsp;</td>
									<td>
										<input style="text-align: right" id="saldoCapVigente${status.count}" name="saldoCapVigente" size="11" align="right" value="${amortizacion.saldoCapVigente}" readOnly="true" esMoneda="true" />
									</td>
									<td>
										<input style="text-align: right" id="saldoCapAtrasado${status.count}" name="saldoCapAtrasado" size="11" align="right" value="${amortizacion.saldoCapAtrasado}" readOnly="true" esMoneda="true" />
									</td>
									<td>
										<input style="text-align: right" id="saldoCapVencido${status.count}" name="saldoCapVencido" size="11" align="right" value="${amortizacion.saldoCapVencido}" readOnly="true" esMoneda="true" />
									</td>
									<td>
										<input style="text-align: right" id="saldoCapVNE${status.count}" name="saldoCapVNE" size="11" align="right" value="${amortizacion.saldoCapVNE}" readOnly="true" esMoneda="true" />
									</td>
									<td>
										<input style="text-align: right" id="saldoIntProvisionado${status.count}" name="saldoIntProvisionado" size="10" align="right" value="${amortizacion.saldoIntProvisionado}" readOnly="true" esMoneda="true" />
									</td>
									<td>
										<input style="text-align: right" id="saldoIntAtrasado${status.count}" name="saldoIntAtrasado" size="10" align="right" value="${amortizacion.saldoIntAtrasado}" readOnly="true" esMoneda="true" />
									</td>
									<td>
										<input style="text-align: right" id="saldoIntVencido${status.count}" name="saldoIntVencido" size="10" align="right" value="${amortizacion.saldoIntVencido}" readOnly="true" esMoneda="true" />
									</td>
									<td>
										<input style="text-align: right" id="saldoIntCalNoCont${status.count}" name="saldoIntCalNoCont" size="10" align="right" value="${amortizacion.saldoIntCalNoCont}" readOnly="true" esMoneda="true" />
									</td>
									<td>
										<input style="text-align: right" id="saldoIVAInteres${status.count}" name="saldoIVAInteres" size="8" align="right" value="${amortizacion.saldoIVAInteres}" readOnly="true" esMoneda="true" />
									</td>
									<td>
										<input style="text-align: right" id="saldoMoratorios${status.count}" name="saldoMoratorios" size="8" align="right" value="${amortizacion.saldoMoratorios}" readOnly="true" esMoneda="true" />
									</td>
									<td>
										<input style="text-align: right" id="saldoIVAMora${status.count}" name="saldoIVAMora" size="8" align="right" value="${amortizacion.saldoIVAMora}" readOnly="true" esMoneda="true" />
									</td>
									<td>
										<input style="text-align: right" id="saldoComFaltaPago${status.count}" name="saldoComFaltaPago" size="8" align="right" value="${amortizacion.saldoComFaltaPago}" readOnly="true" esMoneda="true" />
									</td>
									<td>
										<input style="text-align: right" id="saldoIVAComFaltaPago${status.count}" name="saldoIVAComFaltaPago" size="8" align="right" value="${amortizacion.saldoIVAComFaltaPago}" readOnly="true" esMoneda="true" />
									</td>
									<td>
										<input style="text-align: right" id="saldoOtrasComisiones${status.count}" name="saldoOtrasComisiones" size="8" align="right" value="${amortizacion.saldoOtrasComisiones}" readOnly="true" esMoneda="true" />
									</td>
									<td>
										<input style="text-align: right" id="saldoIVAOtrasCom${status.count}" name="saldoIVAOtrasCom" size="8" align="right" value="${amortizacion.saldoIVAOtrasCom}" readOnly="true" esMoneda="true" />
									</td>
									<c:if test="${var_cobraSeguroCuota == 'S'}">
										<td>
											<input style="text-align: right" id="saldoSeguroCuota${status.count}" name="saldoSeguroCuotaSim" size="8" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.saldoSeguroCuota}" readonly="readonly" esMoneda="true" />
										</td>
										<td>
											<input style="text-align: right" id="saldoIVASeguroCuota${status.count}" name="saldoIVASeguroCuotaSim" size="8" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.saldoIVASeguroCuota}" readonly="readonly" esMoneda="true" />
										</td>
									</c:if>
									<td>
										<input style="text-align: right" id="totalPago${status.count}" name="totalPago" size="11" align="right" value="${amortizacion.totalPago}" readOnly="true" esMoneda="true" />
									</td>
								</tr>
								<c:set var="varTotalCapital" value="${amortizacion.totalCap}" />
								<c:set var="varTotalInteres" value="${amortizacion.totalInteres}" />
								<c:set var="varTotalIva" value="${amortizacion.totalIva}" />
								<c:set var="varTotalSeguroCuota" value="${amortizacion.totalSeguroCuota}" />
								<c:set var="varTotalIVASeguroCuota" value="${amortizacion.totalIVASeguroCuota}" />
							</c:forEach>
							<tr id="filaTotales" style="display: none;">
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="label">
									<label for="lblTotales">Totales: </label>
								</td>
								<td>
									<input id="totalCap" name="totalCap" size="11" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalCapital}" />
								</td>
								<td>
									<input id="totalInt" name="totalInt" size="10" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalInteres}" />
								</td>
								<td>
									<input id="totalIva" name="totalIva" size="10" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalIva}" />
								</td>
								<c:if test="${var_cobraSeguroCuota == 'S'}">
									<td>
										<input id="totalSeguroCuota" name="totalSeguroCuota" size="10" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalSeguroCuota}" />
									</td>
									<td>
										<input id="iVATotalSeguroCuota" name="iVATotalSeguroCuota" size="10" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalIVASeguroCuota}" />
									</td>
								</c:if>
							</tr>
						</tbody>
					</c:when>
					<c:when test="${tipoLista == '3'}">
						<thead>
							<tr>
								<td class="label">
									<label for="lblNumero">Número</label>
								</td>
								<td class="label">
									<label for="lblNumero">Fecha Inicio</label>
								</td>
								<td class="label">
									<label for="lblCR">Fecha Vencimiento</label>
								</td>
								<td class="label">
									<label for="lblCuenta">Fecha Exigible</label>
								</td>
								<td class="label">
									<label for="lblReferencia">Estatus</label>
								</td>
								<td class="label">
									<label for="lblReferencia">Capital</label>
								</td>
								<td class="label">
									<label for="lblDescripcion">Interes</label>
								</td>
								<td class="label">
									<label for="lblCargos">IVA Interes</label>
								</td>
								<c:if test="${var_cobraSeguroCuota == 'S'}">
									<td class="label" align="center">
										<label for="lblCargos">Seguro</label>
									</td>
									<td class="label" align="center">
										<label for="lblCargos">IVA Seguro</label>
									</td>
								</c:if>
								<td class="label">
									<label for="lblTotalPag">Total Pago</label>
								</td>
								<td class="label">
									<label for="lblSaldoCap">Saldo Capital</label>
								</td>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
								<tr id="renglon${status.count}" name="renglon">
									<td>
										<input id="amortizacionID${status.count}" name="amortizacionID" size="4" value="${amortizacion.amortizacionID}" readOnly="true" />
									</td>
									<td>
										<input id="fechaInicio${status.count}" name="fechaInicio" size="12" value="${amortizacion.fechaInicio}" readOnly="true" />
									</td>
									<td>
										<input id="fechaVencim${status.count}" name="fechaVencim" size="12" value="${amortizacion.fechaVencim}" readOnly="true" />
									</td>
									<td>
										<input id="fechaExigible${status.count}" name="fechaExigible" size="12" value="${amortizacion.fechaExigible}" readOnly="true" />
									</td>
									<c:if test="${amortizacion.estatus == 'I'}">
										<td>
											<input id="estatus${status.count}" name="estatus" size="12" value="INACTIVO" readOnly="true" />
										</td>
									</c:if>
									<c:if test="${amortizacion.estatus == 'V'}">
										<td>
											<input id="estatus${status.count}" name="estatus" size="12" value="VIGENTE" readOnly="true" />
										</td>
									</c:if>
									<c:if test="${amortizacion.estatus == 'A'}">
										<td>
											<input id="estatus${status.count}" name="estatus" size="12" value="ATRASADA" readOnly="true" />
										</td>
									</c:if>
									<c:if test="${amortizacion.estatus == 'P'}">
										<td>
											<input id="estatus${status.count}" name="estatus" size="12" value="PAGADA" readOnly="true" />
										</td>
									</c:if>
									<c:if test="${amortizacion.estatus == 'B'}">
										<td>
											<input id="estatus${status.count}" name="estatus" size="12" value="VENCIDA" readOnly="true" />
										</td>
									</c:if>
									<c:if test="${amortizacion.estatus == 'C'}">
										<td>
											<input id="estatus${status.count}" name="estatus" size="12" value="CANCELADA" readOnly="true" />
										</td>
									</c:if>
									<td>
										<input style="text-align: right" id="capital${status.count}" name="capital" size="10" value="${amortizacion.capital}" readOnly="true" esMoneda="true" />
									</td>
									<td>
										<input style="text-align: right" id="interes${status.count}" name="interes" size="10" value="${amortizacion.interes}" readOnly="true" esMoneda="true" />
									</td>
									<td>
										<input style="text-align: right" id="ivaInteres${status.count}" name="ivaInteres" size="10" align="right" value="${amortizacion.ivaInteres}" readOnly="true" esMoneda="true" />
									</td>
									<c:if test="${var_cobraSeguroCuota == 'S'}">
										<td>
											<input id="montoSeguroCuota${status.count}" name="montoSeguroCuotaSim" size="10" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoSeguroCuota}" readonly="readonly" esMoneda="true" />
										</td>
										<td>
											<input id="iVASeguroCuota${status.count}" name="iVASeguroCuotaSim" size="10" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.iVASeguroCuota}" readonly="readonly" esMoneda="true" />
										</td>
									</c:if>
									<td>
										<input style="text-align: right" id="totalPago${status.count}" name="totalPago" size="10" align="right" value="${amortizacion.totalPago}" readOnly="true" esMoneda="true" />
									</td>
									<td>
										<input style="text-align: right" id="saldoCapital${status.count}" name="saldoCapital" size="10" align="right" value="${amortizacion.saldoCapital}" readOnly="true" esMoneda="true" />
									</td>
								</tr>
								<c:set var="varTotalCapital" value="${amortizacion.totalCap}" />
								<c:set var="varTotalInteres" value="${amortizacion.totalInteres}" />
								<c:set var="varTotalIva" value="${amortizacion.totalIva}" />
								<c:set var="varTotalSeguroCuota" value="${amortizacion.totalSeguroCuota}" />
								<c:set var="varTotalIVASeguroCuota" value="${amortizacion.totalIVASeguroCuota}" />
							</c:forEach>
							<tr id="filaTotales" style="display: none;">
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="label">
									<label for="lblTotales">Totales: </label>
								</td>
								<td>
									<input id="totalCap" name="totalCap" size="10" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalCapital}" />
								</td>
								<td>
									<input id="totalInt" name="totalInt" size="10" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalInteres}" />
								</td>
								<td>
									<input id="totalIva" name="totalIva" size="10" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalIva}" />
								</td>
								<c:if test="${var_cobraSeguroCuota == 'S'}">
									<td>
										<input id="totalSeguroCuota" name="totalSeguroCuota" size="10" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalSeguroCuota}" />
									</td>
									<td>
										<input id="iVATotalSeguroCuota" name="iVATotalSeguroCuota" size="10" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalIVASeguroCuota}" />
									</td>
								</c:if>
							</tr>
						</tbody>
					</c:when>
				</c:choose>
			</table>
			<c:if test="${!listaPaginada.firstPage}">
				<input onclick="consultaGridAmortizaciones('previous')" type="button" id="anterior" value="" class="btnAnterior" />
			</c:if>
			<c:if test="${!listaPaginada.lastPage}">
				<input onclick="consultaGridAmortizaciones('next')" type="button" id="siguiente" value="" class="btnSiguiente" />
			</c:if>
			<table align="right">
				<tr>
					<td name="tdTasaVariable">
						<label id="lblTasaVariable">* Los montos est&aacute;n sujetos a la variaci&oacute;n de la tasa.</label>
					</td>
				</tr>
			</table>
		</fieldset>
	</div>
	<script type="text/javascript">
		var GlobalID_CalculoInteres;
		function consultaGridAmortizaciones(pageValor) {
			var lista = ${tipoLista};

			var params = {};
			params['creditoID'] = $('#creditoID').val();
			params['tipoLista'] = lista;
			params['page'] = pageValor;

			$('#gridMovimientos').hide();
			$.post("consultaCredAmortiGridVista.htm", params, function(data) {
				if (data.length > 0) {
					$('#gridAmortizacion').html(data);
					$('#gridAmortizacion').show();
					$('#contenedorConAmortizaciones').hide();
					agregaFormatoControles('formaGenerica2');
					if ($('#anterior').is(':visible') && $('#siguiente').is(':visible') == false) {
						$('#filaTotales').show();
					} else if ($('#anterior').is(':visible') == false && $('#siguiente').is(':visible') == false) {
						$('#filaTotales').show();
					} else {
						$('#filaTotales').hide();
					}
					muestraDescTasaVar(GlobalID_CalculoInteres);
				} else {
					$('#gridAmortizacion').html("");
					$('#gridAmortizacion').show();
				}
			});
			agregaFormatoControles('gridAmortizacion');
		}

		function muestraDescTasaVar(idCalculoInteres) {
			
			if(idCalculoInteres!="" && $( "#"+idCalculoInteres).length ){
				GlobalID_CalculoInteres = idCalculoInteres;
				var leyendaTasaVariable = "* Los montos están sujetos a la variación de la tasa.";
				// Si se trata de un calculo de intereses por tasa fija se oculta la descripcion
				if ($('#' + idCalculoInteres).val() == TasaFijaID) {
					$('td[name=tdTasaVariable]').hide();
				} else { // En cualquier otro caso se muestra
					if ($('#' + idCalculoInteres).val() == TasaBasePisoTecho) {
						leyendaTasaVariable = leyendaTasaVariable + " Con piso del " + $('#pisoTasa').val().trim() + "% y techo del " + $('#techoTasa').val().trim() + "%.";
					}
					$('#lblTasaVariable').text(leyendaTasaVariable);
					$('td[name=tdTasaVariable]').show();
				}
			}
		}
	</script>
</body>
</html>
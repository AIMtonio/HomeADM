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
<c:set var="listaResultado" value="${listaPaginada.pageList}" />

<input type="hidden" id="numeroErrorList" name="numeroErrorList" value="${numErr2}" />
<input type="hidden" id="mensajeErrorList" name="mensajeErrorList" value="<c:out value="${mesErr}"/>" />
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Simulador de Amortizaciones</legend>
	<c:if test="${numErr2 == 0}">
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="975px" style="display:block; overflow-y: auto;">
			<c:choose>
				<c:when test="${tipoLista == '1'}">
					<tr>
						<td class="label" align="center"><label for="lblNumero">N&uacute;mero</label></td>
						<td class="label" align="center"><label for="lblFecIni">Fecha Inicio</label></td>
						<td class="label" align="center"><label for="lblFecFin">Fecha Vencim.</label></td>
						<td class="label" align="center"><label for="lblFecPag">Fecha Pago</label></td>
						<td class="label" align="center"><label for="lblCapital">Capital</label></td>
						<td class="label" align="center"><label for="lblDescripcion">Inter&eacute;s</label></td>
						<td class="label" align="center"><label for="lblRenta">Renta</label></td>
						<td class="label" align="center"><label for="lblCargos">IVA Renta</label></td>
						<td class="label" align="center"><label for="lblSaldoCapital">Saldo Capital</label></td>
						<td class="label" align="center"><label for="lblSeguro">Seguro</label></td>
						<td class="label" align="center"><label for="lblSeguroIva">IVA Seguro</label></td>
						<td class="label" align="center"><label for="lblSeguroVida">Seguro Vida</label></td>
						<td class="label" align="center"><label for="lblSeguroVidaIva">IVA Seguro Vida</label></td>
						<td class="label" align="center"><label for="lblTotalPag">Total Pago</label></td>
					</tr>
					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td align="center"><input id="arrendaAmortiID${status.count}" name="arrendaAmortiID" style="text-align: center;" size="8" type="text" value="${amortizacion.arrendaAmortiID}" readonly="readonly" /></td>
							<td align="center"><input id="fechaInicio${status.count}" name="fechaInicioGrid" style="text-align: center;" size="11" type="text" value="${amortizacion.fechaInicio}" readonly="readonly" /></td>
							<td align="center"><input id="fechaVencim${status.count}" name="fechaVencim" style="text-align: center;" size="11" type="text" value="${amortizacion.fechaVencim}" readonly="readonly" /></td>
							<td align="center"><input id="fechaExigible${status.count}" name="fechaExigible" style="text-align: center;" size="11" type="text" value="${amortizacion.fechaExigible}" readonly="readonly" /></td>
							<td id="capitalRenta"><input id="capitalRenta${status.count}" name="capitalRenta" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.capitalRenta}" readonly="readonly" esMoneda="true" /></td>
							<td id="interesRenta"><input id="interesRenta${status.count}" name="interesRenta" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.interesRenta}" readonly="readonly" esMoneda="true" /></td>
							<td id="renta"><input id="renta${status.count}" name="renta" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.renta}" readonly="readonly" esMoneda="true" /></td>
							<td id="IvaRenta"><input id="ivaRenta${status.count}" name="ivaRenta" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.ivaRenta}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="saldoCapital${status.count}" name="saldoCapital" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.saldoCapital}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="seguro${status.count}" name="seguro" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.seguro}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="montoIVASeguro${status.count}" name="montoIVASeguro" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoIVASeguro}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="seguroVida${status.count}" name="seguroVida" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.seguroVida}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="montoIVASeguroVida${status.count}" name="montoIVASeguroVida" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoIVASeguroVida}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="pagoTotal${status.count}" name="pagoTotal" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.pagoTotal}" readonly="readonly" esMoneda="true" /></td>
						</tr>

						<c:set var="cuotas" value="${amortizacion.numeroCuotas}" />
						<c:set var="numTransaccion" value="${amortizacion.numTransaccion}" />
						<c:set var="valorPrimerVencimiento" value="${amortizacion.fechaPrimerVen}" />
						<c:set var="valorUltimoVencimiento" value="${amortizacion.fechaUltimoVen}" />
						<c:set var="valorMontoCuota" value="${amortizacion.montoCuota}" />
						<c:set var="varTotalCapital" value="${amortizacion.totalCapital}" />
						<c:set var="varTotalInteres" value="${amortizacion.totalInteres}" />
						<c:set var="varTotalIva" value="${amortizacion.totalIva}" />
						<c:set var="varTotalRenta" value="${amortizacion.totalRenta}" />
						<c:set var="varTotalPago" value="${amortizacion.totalPago}" />

					</c:forEach>
					<tr>
						<td colspan="9" align="right">
							<input id="transaccion" name="transaccion" 	size="18" style="text-align: right;" type="hidden" value="${numTransaccion}" 	readonly="readonly" disabled="disabled"/> 
							<input id="cuotas" 		name="cuotas" 		size="18" style="text-align: right;" type="hidden" value="${cuotas}" 			readonly="readonly" disabled="disabled" /> 
							<input id="valorPrimerVencimiento" 		name="valorPrimerVencimiento" 		size="18" type="hidden" value="${valorPrimerVencimiento}" 			readonly="readonly" disabled="disabled" /> 
							<input id="valorUltimoVencimiento" 		name="valorUltimoVencimiento" 		size="18" type="hidden" value="${valorUltimoVencimiento}" 			readonly="readonly" disabled="disabled" /> 
							<input id="valorMontoCuota" 		name="valorMontoCuota" 		size="18" style="text-align: right;" type="hidden" value="${valorMontoCuota}" 	readonly="readonly" disabled="disabled" /> 
							<input id="varTotalCapital" 		name="varTotalCapital" 		size="18" style="text-align: right;" type="hidden" value="${varTotalCapital}" 	readonly="readonly" disabled="disabled" /> 
							<input id="varTotalInteres" 		name="varTotalInteres" 		size="18" style="text-align: right;" type="hidden" value="${varTotalInteres}" 	readonly="readonly" disabled="disabled" /> 
							<input id="varTotalIva" 			name="varTotalIva" 		size="18" style="text-align: right;" type="hidden" value="${varTotalIva}" 			readonly="readonly" disabled="disabled" /> 
							<input id="varTotalRenta" 			name="varTotalRenta" 		size="18" style="text-align: right;" type="hidden" value="${varTotalRenta}" 	readonly="readonly" disabled="disabled" /> 
							<input id="varTotalPago" 			name="varTotalPago" 		size="18" style="text-align: right;" type="hidden" value="${varTotalPago}" 		readonly="readonly" disabled="disabled" /> 

					</tr>
					<tr id="filaTotales" style="display: none;">
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="label"><label for="lblTotales">Totales: </label></td>
						<td><input id="totalCap" name="totalCap" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalCapital}" /></td>
						<td><input id="totalInt" name="totalInt" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalInteres}" /></td>
						<td><input id="totalRenta" name="totalRenta" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalRenta}" /></td>
						<td><input id="totalIva" name="totalIva" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalIva}" /></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td><input id="totalPago" name="totalPago" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${varTotalPago}" /></td>	
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
	var GlobalID_CalculoInteres;
	function simulador(pageValor){
		var params = {};
		params['tipoLista'] 			= 1; 
		params['montoFinanciado']		= $('#montoFinanciado').asNumber();
		params['diaPagoProd'] 			= $('#diaPagoProd').val();
		params['montoResidual']			= $('#montoResidual').asNumber();
		params['fechaApertura'] 		= $('#fechaApertura').val();
		params['frecuenciaPlazo'] 		= $('#frecuenciaPlazo').val();
		params['plazo'] 				= $('#plazo').val();
		params['tasaFijaAnual'] 		= $('#tasaFijaAnual').asNumber();
		params['montoComApe']			= $('#montoComApe').asNumber();
		params['fechaInhabil'] 			= $('#fechaInhabil').val();
		params['clienteID'] 			= $('#clienteID').val();

		params['empresaID'] 			= parametroBean.empresaID;
		params['usuario'] 				= parametroBean.numeroUsuario;
		params['fecha'] 				= parametroBean.fechaSucursal;
		params['direccionIP'] 			= parametroBean.IPsesion;
		params['sucursal'] 				= parametroBean.sucursal;
		params['page'] 		= pageValor ;
		
		// SE VALIDA SI EL PAGO DEL SEGURO SERA DE CONTADO 
		if($('#tipoPagoSeguroVida').val() == '1'){
			params['montoSeguroVidaAnual']	= 0;
		}else{
			params['montoSeguroVidaAnual']	= $('#montoSeguroVidaAnual').asNumber();
		}
		// SE VALIDA SI EL PAGO DEL SEGURO SERA DE CONTADO S
		if($('#tipoPagoSeguro').val() == '1'){
			params['montoSeguroAnual']		= 0;
		}else{
			params['montoSeguroAnual']		= $('#montoSeguroAnual').asNumber();
		}
		
		$.post("simPagArrenda.htm",params,function(data) {
			if(data.length >0 || data != null) { 

				estatusSimulacion = true;
				if ($('#arrendaID').asNumber() == '0') {
					habilitaBoton('agrega', 'submit');
					deshabilitaBoton('modifica', 'submit');
				}else{
					if ($('#estatus').val() == 'G') {
						deshabilitaBoton('agrega', 'submit');
						habilitaBoton('modifica', 'submit');
					}else{
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('modifica', 'submit');
					}
				}
				$('#contenedorSimulador').html(data); 
				$('#contenedorSimulador').show();
				if($('#anterior').is(':visible') &&  $('#siguiente').is(':visible') == false ){
					$('#filaTotales').show();
				}else{
					$('#filaTotales').hide();
				}	
				//$('#imprimirRep').show();
				$('#contenedorForma').unblock();
			}
		});  
	} //fin funcion simulador()

	</script>

</fieldset>

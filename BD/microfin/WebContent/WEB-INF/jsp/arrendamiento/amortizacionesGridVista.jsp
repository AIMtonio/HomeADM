<?xml version="1.0" encoding="UTF-8"?>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="listaPaginada" value="${listaResultado[1]}" />
<c:set var="numErr2">${listaResultado[2]}</c:set>
<c:set var="mesErr" value="${listaResultado[3]}" />
<c:set var="listaResultado" value="${listaPaginada.pageList}" />

<input type="hidden" id="numeroErrorList" name="numeroErrorList" value="${numErr2}" />
<input type="hidden" id="mensajeErrorList" name="mensajeErrorList" value="<c:out value="${mesErr}"/>" />
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Tabla de Amortizaciones</legend>
	<c:if test="${numErr2 == 0}">
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="825px" style="display:block; overflow-y: auto;">
			<c:choose>
				<c:when test="${tipoLista == '1'}">
					<tr>
						<td class="label" align="center"><label for="lblNumero">N&uacute;mero</label></td>
						<td class="label" align="center"><label for="lblFecIni">Fecha Inicio</label></td>
						<td class="label" align="center"><label for="lblFecFin">Fecha Vencimiento</label></td>
						<td class="label" align="center"><label for="lblFecExigible">Fecha Exigible</label></td>
						<td class="label" align="center"><label for="lblEstatus">Estatus</label></td>
						<td class="label" align="center"><label for="lblCapital">Capital</label></td>
						<td class="label" align="center"><label for="lblInteres">Inter&eacute;s</label></td>
						<td class="label" align="center"><label for="lblRenta">Renta</label></td>
						<td class="label" align="center"><label for="lblCargos">IVA Renta</label></td>
						<td class="label" align="center"><label for="lblSaldoCapital">Saldo Capital</label></td>
						<td class="label" align="center"><label for="lblSeguro">Seguro</label></td>
						<td class="label" align="center"><label for="lblIVASeguro">IVA del Seguro</label></td>
						<td class="label" align="center"><label for="lblSeguroVida">Seguro Vida</label></td>
						<td class="label" align="center"><label for="lblIVASeguroVida">IVA del Seguro de Vida</label></td>
						<td class="label" align="center"><label for="lblTotalPag">Total Pago</label></td>
					</tr>
					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td><input id="arrendaAmortiID${status.count}" name="arrendaAmortiID" size="8" type="text" value="${amortizacion.arrendaAmortiID}" readonly="readonly" style="text-align: center;"/></td>
							<td><input id="fechaInicio${status.count}" name="fechaInicio" size="18" type="text" value="${amortizacion.fechaInicio}" readonly="readonly" style="text-align: center;"/></td>
							<td><input id="fechaVencim${status.count}" name="fechaVencim" size="18" type="text" value="${amortizacion.fechaVencim}" readonly="readonly" style="text-align: center;"/></td>
							<td><input id="fechaExigible${status.count}" name="fechaExigible" size="18" type="text" value="${amortizacion.fechaExigible}" readonly="readonly" style="text-align: center;"/></td>
							<td><input id="estatus${status.count}" name="estatus" size="18" type="text" value="${amortizacion.estatus}" readonly="readonly" style="text-align: center;"/></td>
							<td><input id="capitalRenta${status.count}" name="capitalRenta" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.capitalRenta}" readonly="readonly" esMoneda="true"/></td>
							<td><input id="interesRenta${status.count}" name="interesRenta" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.interesRenta}" readonly="readonly" esMoneda="true"/></td>
							<td><input id="renta${status.count}" name="renta" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.renta}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="ivaRenta${status.count}" name="ivaRenta" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.ivaRenta}" readonly="readonly" esMoneda="true"/></td>
							<td><input id="saldoCapital${status.count}" name="saldoCapital" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.saldoCapital}" readonly="readonly" esMoneda="true" /></td>														
							<td><input id="seguro${status.count}" name="seguro" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.seguro}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="ivaSeguro${status.count}" name="ivaSeguro" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.ivaSeguro}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="seguroVida${status.count}" name="seguroVida" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.seguroVida}" readonly="readonly" esMoneda="true"/></td>
							<td><input id="ivaSeguroVida${status.count}" name="ivaSeguroVida" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.ivaSeguroVida}" readonly="readonly" esMoneda="true"/></td>
							<td><input id="pagoTotal${status.count}" name="pagoTotal" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.pagoTotal}" readonly="readonly" esMoneda="true"/></td>
						</tr>
						
						<c:set var="totalCapital" value="${amortizacion.totalCapital}"/>						
						<c:set var="totalInteres" value="${amortizacion.totalInteres}"/>
						<c:set var="totalIVA" value="${amortizacion.totalIva}"/>
						<c:set var="totalRenta" value="${amortizacion.totalRenta}"/>
						<c:set var="totalPago" value="${amortizacion.totalPago}"/>
					</c:forEach>
					
					<tr id="filaTotales" style="display: none;">
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="label"><label for="lblTotales">Totales: </label></td>
						<td><input id="totalCapital" name="totalCapital" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${totalCapital}"/></td>
						<td><input id="totalInteres" name="totalInteres" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${totalInteres}"/></td>
						<td><input id="totalRenta" name="totalRenta" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${totalRenta}"/></td>
						<td><input id="totalIva" name="totalIva" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${totalIVA}"/></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td><input id="totalPago" name="totalPago" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${totalPago}"/></td>
					</tr>
				</c:when>
				
				<c:when test="${tipoLista == '3'}">
					<tr>
						<td class="label" align="center"><label for="lblNumero">N&uacute;mero</label></td>
						<td class="label" align="center"><label for="lblFecIni">Fecha Inicio</label></td>
						<td class="label" align="center"><label for="lblFecFin">Fecha Vencimiento</label></td>
						<td class="label" align="center"><label for="lblFecExigible">Fecha Exigible</label></td>
						<td class="label" align="center"><label for="lblEstatus">Estatus</label></td>
						<td class="label" align="center"><label for="lblCapital">Capital</label></td>
						<td class="label" align="center"><label for="lblInteres">Inter&eacute;s</label></td>
						<td class="label" align="center"><label for="lblRenta">Renta</label></td>
						<td class="label" align="center"><label for="lblCargos">IVA Renta</label></td>
						<td class="label" align="center"><label for="lblSaldoCapital">Saldo Capital</label></td>
						<td class="label" align="center"><label for="lblSeguro">Saldo Seguro</label></td>
						<td class="label" align="center"><label for="lblIVASeguro">Monto IVA del Seguro </label></td>
						<td class="label" align="center"><label for="lblSeguroVida">Saldo Seguro Vida</label></td>
						<td class="label" align="center"><label for="lblIVASeguroVida">Monto IVA del Seguro Vida</label></td>
						<td class="label" align="center"><label for="lblSeguroVida">Saldo de Otras Comisiones</label></td>
						<td class="label" align="center"><label for="lblIVASeguroVida">Monto IVA de Otras Comisiones</label></td>					
						
						<td class="label" align="center"><label for="lblTotalPag">Total Pago</label></td>
					</tr>
					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td><input id="arrendaAmortiID${status.count}" name="arrendaAmortiID" size="8" type="text" value="${amortizacion.arrendaAmortiID}" readonly="readonly" style="text-align: center;"/></td>
							<td><input id="fechaInicio${status.count}" name="fechaInicio" size="18" type="text" value="${amortizacion.fechaInicio}" readonly="readonly" style="text-align: center;"/></td>
							<td><input id="fechaVencim${status.count}" name="fechaVencim" size="18" type="text" value="${amortizacion.fechaVencim}" readonly="readonly" style="text-align: center;"/></td>
							<td><input id="fechaExigible${status.count}" name="fechaExigible" size="18" type="text" value="${amortizacion.fechaExigible}" readonly="readonly" style="text-align: center;"/></td>
							<td><input id="estatus${status.count}" name="estatus" size="18" type="text" value="${amortizacion.estatus}" readonly="readonly" style="text-align: center;"/></td>
							<td><input id="capitalRenta${status.count}" name="capitalRenta" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.capitalRenta}" readonly="readonly" esMoneda="true"/></td>
							<td><input id="interesRenta${status.count}" name="interesRenta" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.interesRenta}" readonly="readonly" esMoneda="true"/></td>
							<td><input id="renta${status.count}" name="renta" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.renta}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="ivaRenta${status.count}" name="ivaRenta" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.ivaRenta}" readonly="readonly" esMoneda="true"/></td>
							<td><input id="saldoCapital${status.count}" name="saldoCapital" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.saldoCapital}" readonly="readonly" esMoneda="true" /></td>														
							<td><input id="seguro${status.count}" name="seguro" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.saldoSeguro}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="ivaSeguro${status.count}" name="ivaSeguro" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoIVASeguro}" readonly="readonly" esMoneda="true" /></td>
							<td><input id="seguroVida${status.count}" name="seguroVida" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.saldoSeguroVida}" readonly="readonly" esMoneda="true"/></td>
							<td><input id="ivaSeguroVida${status.count}" name="ivaSeguroVida" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoIVASeguroVida}" readonly="readonly" esMoneda="true"/></td>
							<td><input id="otrasComis${status.count}" name="otrasComis" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.saldoOtrasComis}" readonly="readonly" esMoneda="true"/></td>
							<td><input id="ivaOtrasComis${status.count}" name="ivaOtrasComis" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoIVAComisi}" readonly="readonly" esMoneda="true"/></td>
							<td><input id="pagoTotal${status.count}" name="pagoTotal" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.pagoTotal}" readonly="readonly" esMoneda="true"/></td>
						</tr>
						
						<c:set var="totalCapital" value="${amortizacion.totalCapital}"/>						
						<c:set var="totalInteres" value="${amortizacion.totalInteres}"/>
						<c:set var="totalIVA" value="${amortizacion.totalIva}"/>
						<c:set var="totalRenta" value="${amortizacion.totalRenta}"/>
						<c:set var="totalPago" value="${amortizacion.totalPago}"/>
					</c:forEach>
					
					<tr id="filaTotales" style="display: none;">
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="label"><label for="lblTotales">Totales: </label></td>
						<td><input id="totalCapital" name="totalCapital" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${totalCapital}"/></td>
						<td><input id="totalInteres" name="totalInteres" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${totalInteres}"/></td>
						<td><input id="totalRenta" name="totalRenta" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${totalRenta}"/></td>
						<td><input id="totalIva" name="totalIva" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${totalIVA}"/></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td><input id="totalPago" name="totalPago" size="18" readOnly="true" style="text-align: right;" esMoneda="true" value="${totalPago}"/></td>
					</tr>
				</c:when>
				
				
			</c:choose>
		</table>
	</c:if>
	<c:if test="${!listaPaginada.firstPage}">
		<input onclick="amortizaciones('previous')" type="button" value="" id="anterior" class="btnAnterior" />
	</c:if>
	<c:if test="${!listaPaginada.lastPage}">
		<input onclick="amortizaciones('next')" type="button" id="siguiente" value="" class="btnSiguiente" />
	</c:if>
	<script type="text/javascript">
	
	/**
	* Metodo para las amortizaciones
	*/
	function amortizaciones(pageValor){
		var params = {};
		params['tipoLista'] = $('#tipoListaAmorti').val();
		params['arrendaID'] = $('#arrendaID').val();
		params['page'] 		= pageValor ;
				
		$.post("amortizacionesGrid.htm",params,function(data) {
			if(data.length >0 || data != null) { 
				$('#contenedorAmortizaciones').html(data); 
				agregaFormatoControles('formaGenerica');
				$('#contenedorAmortizaciones').show();
				$('#contenedorBotonesImp').show();
				if($('#anterior').is(':visible') &&  $('#siguiente').is(':visible') == false ){
					$('#filaTotales').show();
				}else{
					$('#filaTotales').hide();
				}
			}
		}); 
	} //fin metodo: amortizaciones 
	</script>
</fieldset>
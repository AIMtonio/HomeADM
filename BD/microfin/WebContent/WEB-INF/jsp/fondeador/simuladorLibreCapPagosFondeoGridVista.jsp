<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  		value="${listaResultado[0]}"/>
<c:set var="fechaVencimiento"	value="${listaResultado[1]}"/>
<c:set var="listaResultado" 	value="${listaResultado[2]}"/>

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend>Simulador de Amortizaciones</legend>	
	<form id="gridDetalle" name="gridDetalle">
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '3'}">
					<tr>
						<td class="label" align="center"><label for="lblNumero">N&uacute;mero</label></td>
						<td class="label" align="center"><label for="lblFecIni">Fecha Inicio</label></td>
						<td class="label" align="center"><label for="lblFecFin">Fecha Vencimiento</label> </td>	
						<td class="label" align="center"><label for="lblFecPag">Fecha Pago</label></td>
				  		<td class="label" align="center"><label for="lblCapital">Capital</label></td> 
			     		<td class="label" align="center"><label for="lblDescripcion">Inter&eacute;s</label></td> 
			     		<td class="label" align="center"><label for="lblCargos">Iva Inter&eacute;s</label></td> 
			     		<td class="label" align="center"><label for="lblTotalPag">Total Pago</label></td> 
			     		<td class="label" align="center"><label for="lblSaldoCap">Saldo Capital</label></td> 
					</tr>
					
					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td> 
								<input id="amortizacionID${status.count}"  name="amortizacionID" size="4" type="text"  
										value="${amortizacion.amortizacionID}" readonly="readonly" disabled="disabled"/> 
						  	</td> 
							<td> 
								<input id="fechaInicio${status.count}"  name="fechaInicio" size="15" type="text"  
										value="${amortizacion.fechaInicio}" readonly="readonly" disabled="disabled"/> 
						  	</td> 
						  	<td> 
								<input id="fechaVencim${status.count}" name="fechaVencim" size="15" type="text" 
										value="${amortizacion.fechaVencim}" readonly="readonly" disabled="disabled"/> 
						  	</td> 
						  	<td> 
								<input id="fechaExigible${status.count}" name="fechaExigible" size="15" type="text" 
										value="${amortizacion.fechaExigible}" readonly="readonly" disabled="disabled"/> 
						  	</td> 
						  	<td> 
						  		<c:choose>
			     					<c:when test="${amortizacion.capitalInteres == 'I'}">
			     						<input id="capital${status.count}" name="capital" size="18"  style="text-align: right;" type="text"
												value="0" readonly="readonly" disabled="disabled" esMoneda="true"/> 
					     			</c:when>
					     		
			     					<c:when test="${amortizacion.capitalInteres == 'C'}">
			     						<input id="capital${status.count}" name="capital" size="18"  style="text-align: right;" type="text"
												value="" onblur="agregaFormatoMonedaGrid(this.id);" esMoneda="true"/> 
					     			</c:when>
					     			
					     			<c:when test="${amortizacion.capitalInteres == 'G'}">
			     						<input id="capital${status.count}" name="capital" size="18"  style="text-align: right;" type="text"
												value="" onblur="agregaFormatoMonedaGrid(this.id);" esMoneda="true" /> 
					     			</c:when>
						     	</c:choose>
								
						  	</td> 
				     		<td> 
				         	<input id="interes${status.count}" name="interes" size="18" style="text-align: right;" type="text"
				         			value=" " readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
							<td> 
				         	<input id="ivaInteres${status.count}" name="ivaInteres" size="18"  style="text-align: right;" type="text"
				         			value=" " readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
				     		<td> 
				         	<input id="totalPago${status.count}" name="totalPago" size="18"  style="text-align: right;" type="text"
				         			value=" " readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
				     		<td> 
				         	<input id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18"  style="text-align: right;" type="text"
				         			value=" " readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
						</tr>
						
						<c:set var="cuotas3" value="${amortizacion.cuotasCapital}"/>
						<c:set var="fechaVenc3" value="${amortizacion.fechaVencim}"/>
						<c:set var="numTransaccion3" value="${amortizacion.numTransaccion}"/>
						<c:set var="valorFecUltAmor3" value="${amortizacion.fecUltAmor}"/>
						<c:set var="valorfecInicioAmor3" value="${amortizacion.fecInicioAmor}"/>
						<c:set var="valorMontoCuota3" value="${amortizacion.montoCuota}"/>
						
					</c:forEach>
					<tr>
					<td colspan="9">
						<table align="right" >
							<tr>
								<td align="right">
									<input id="transaccion" name="transaccion" size="18" align="right"  type = "hidden"
						         			value="${numTransaccion3}" readonly="readonly" disabled="disabled" />													 
									<input id="cuotas" name="cuotas" size="18" align="right"  type = "hidden"
						         			value="${cuotas3}" readonly="readonly" disabled="disabled" />
						         	<input id="valorFecUltAmor" name="valorFecUltAmor" size="18" align="right"  type = "hidden"
						         			value="${valorFecUltAmor3}" readonly="readonly" disabled="disabled"/>
						         	<input id="valorfecInicioAmor" name="valorfecInicioAmor" size="18" align="right"  type = "hidden"
						         			value="${valorfecInicioAmor3}" readonly="readonly" disabled="disabled"/>	
						         	<input id="valorMontoCuota" name="valorMontoCuota" size="18" align="right"  type = "hidden"
						         			value="${valorMontoCuota3}" readonly="readonly" disabled="disabled"/>			
								</td>
								<td align="right">
									<button type="button" class="submit" id="recalculo" onclick="simuladorPagosLibres(${numTransaccion3});">Recalcular</button> 		
								</td>
							</tr>
							
						</table>
						</td> 
					</tr>
				</c:when>
				<c:when test="${tipoLista == '5'}">
					<tr>
						<td class="label" align="center"><label for="lblNumero">N&uacute;mero</label></td>
						<td class="label" align="center"><label for="lblFecIni">Fecha Inicio</label></td>
						<td class="label" align="center"><label for="lblFecFin">Fecha Vencimiento</label> </td>	
						<td class="label" align="center"><label for="lblFecPag">Fecha Pago</label></td>
				  		<td class="label" align="center"><label for="lblCapital">Capital</label></td> 
			     		<td class="label" align="center"><label for="lblDescripcion">Inter&eacute;s</label></td> 
			     		<td class="label" align="center"><label for="lblCargos">Iva Inter&eacute;s</label></td> 
			     		<td class="label" align="center"><label for="lblTotalPag">Total Pago</label></td> 
			     		<td class="label" align="center"><label for="lblSaldoCap">Saldo Capital</label></td> 
					</tr>
					
					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td> 
								<input id="amortizacionID${status.count}"  name="amortizacionID" size="4" type="text"  
										value="${amortizacion.amortizacionID}" readonly="readonly" disabled="disabled"/> 
						  	</td> 
							<td> 
								<input id="fechaInicio${status.count}"  name="fechaInicio" size="15" type="text"  
										value="${amortizacion.fechaInicio}" readonly="readonly" disabled="disabled"/> 
						  	</td> 
						  	<td> 
								<input id="fechaVencim${status.count}" name="fechaVencim" size="15" type="text" 
										value="${amortizacion.fechaVencim}" readonly="readonly" disabled="disabled"/> 
						  	</td> 
						  	<td> 
								<input id="fechaExigible${status.count}" name="fechaExigible" size="15" type="text" 
										value="${amortizacion.fechaExigible}" readonly="readonly" disabled="disabled"/> 
						  	</td> 
						  	<td> 
						  		<c:choose>
			     					<c:when test="${amortizacion.capitalInteres == 'I'}">
			     						<input id="capital${status.count}" name="capital" size="18"  style="text-align: right;" type="text"
												value="0" readonly="readonly" disabled="disabled" esMoneda="true"/> 
					     			</c:when>
					     		
			     					<c:when test="${amortizacion.capitalInteres == 'C'}">
			     						<input id="capital${status.count}" name="capital" size="18"  style="text-align: right;" type="text"
												value="" onblur="agregaFormatoMonedaGrid(this.id);"  esMoneda="true"/> 
					     			</c:when>
					     			
					     			<c:when test="${amortizacion.capitalInteres == 'G'}">
			     						<input id="capital${status.count}" name="capital" size="18"  style="text-align: right;" type="text"
												value=""  onblur="agregaFormatoMonedaGrid(this.id);" esMoneda="true" /> 
					     			</c:when>
						     	</c:choose>
								
						  	</td> 
				     		<td> 
				         	<input id="interes${status.count}" name="interes" size="18" style="text-align: right;" type="text"
				         			value=" " readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
							<td> 
				         	<input id="ivaInteres${status.count}" name="ivaInteres" size="18"  style="text-align: right;" type="text"
				         			value=" " readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
				     		<td> 
				         	<input id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" type="text"
				         			value=" " readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
				     		<td> 
				         	<input id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18"  style="text-align: right;" type="text"
				         			value=" " readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
						</tr>
						
						<c:set var="cuotas5" value="${amortizacion.cuotasCapital}"/>
						<c:set var="fechaVenc5" value="${amortizacion.fechaVencim}"/>
						<c:set var="numTransaccion5" value="${amortizacion.numTransaccion}"/>
						<c:set var="valorFecUltAmor5" value="${amortizacion.fecUltAmor}"/>
						<c:set var="valorfecInicioAmor5" value="${amortizacion.fecInicioAmor}"/>
						<c:set var="valorMontoCuota5" value="${amortizacion.montoCuota}"/>
					</c:forEach>
					<tr>
						
					<td colspan="9">
						<table align="right" >
							<tr>
								<td align="right">
									<input id="transaccion" name="transaccion" size="18" align="right"  type = "hidden"
						         			value="${numTransaccion5}" readonly="readonly" disabled="disabled" />													 
									<input id="cuotas" name="cuotas" size="18" align="right"  type = "hidden"
						         			value="${cuotas5}" readonly="readonly" disabled="disabled" />	
						         	<input id="valorFecUltAmor" name="valorFecUltAmor" size="18" align="right"  type = "hidden"
						         			value="${valorFecUltAmor5}" readonly="readonly" disabled="disabled"/>		
						         	<input id="valorfecInicioAmor" name="valorfecInicioAmor" size="18" align="right"  type = "hidden"
						         			value="${valorfecInicioAmor5}" readonly="readonly" disabled="disabled"/>	
						         	<input id="valorMontoCuota" name="valorMontoCuota" size="18" align="right"  type = "hidden"
						         			value="${valorMontoCuota5}" readonly="readonly" disabled="disabled"/>

								</td>
								<td align="right">
									<button type="button" class="submit" id="recalculo" onclick="simuladorPagosLibresTasaVar(${numTransaccion5},${cuotas5});">Guardar</button> 		
								</td>
							</tr>
							
						</table>
						</td> 
					</tr> 
				</c:when>				
			</c:choose>
		</table>
		<input id ="fech" type="hidden" value="${fechaVencimiento.fechaVencim}" />  	
	</form>
</fieldset>
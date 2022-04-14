<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>	
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="mensaje" value="${listaResultado[1]}"/>
<c:set var="listaResultado" value="${listaResultado[2]}"/>

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend>Simulador de Amortizaciones</legend>	
	<form id="gridDetalle" name="gridDetalle">
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
			<c:choose>
				<c:when test="${mensaje.numero == '0'}">
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
										<input type="text" id="consecutivoID${status.count}"  name="consecutivoID" size="4"  
												value="${status.count}" readonly="readonly" disabled="disabled"/> 
								  	</td> 
									<td> 
										<input type="text" id="fechaInicio${status.count}"  name="fechaInicio" size="15"  
												value="${amortizacion.fechaInicio}" readonly="readonly" disabled="disabled"/> 
								  	</td> 
								  	<td align="center"> 
										<input type="text" id="fechaVencim${status.count}" name="fechaVencim" size="15" 
												value="${amortizacion.fechaVencim}" readonly="readonly" disabled="disabled"/> 
								  	</td> 
								  	<td> 
										<input  type="text" id="fechaExigible${status.count}" name="fechaExigible" size="15" 
												value="${amortizacion.fechaExigible}" readonly="readonly" disabled="disabled"/> 
								  	</td> 
								  	<td> 
								  		<c:choose>
					     					<c:when test="${amortizacion.capitalInteres == 'I'}">
					     						<input  type="text" id="capital${status.count}" name="capital" size="18" style="text-align: right;" 
														value="${amortizacion.capital}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
							     			</c:when>
					     					<c:when test="${amortizacion.capitalInteres == 'C'}">
					     						<input  type="text" id="capital${status.count}" name="capital" size="18" style="text-align: right;" 
														value="${amortizacion.capital}" onblur="agregaFormatoMonedaGrid(this.id);" esMoneda="true" /> 
							     			</c:when>
							     			<c:when test="${amortizacion.capitalInteres == 'G'}">
					     						<input  type="text" id="capital${status.count}" name="capital" size="18" style="text-align: right;" 
														value="${amortizacion.capital}" onblur="agregaFormatoMonedaGrid(this.id);" esMoneda="true"/> 
							     			</c:when>
								     	</c:choose>
								  	</td> 
						     		<td> 
						         		<input  type="text" id="interes${status.count}" name="interes" size="18" style="text-align: right;"
						         			value="${amortizacion.interes}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
						     		</td> 
									<td> 
						         		<input  type="text" id="ivaInteres${status.count}" name="ivaInteres" size="18" style="text-align: right;" 
						         			value="${amortizacion.ivaInteres}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
						     		</td> 
						     		<td> 
						         		<input  type="text" id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" 
						         			value="${amortizacion.totalPago}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
						     		</td> 
						     		<td> 
						         		<input  type="text" id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;" 
						         			value="${amortizacion.saldoInsoluto}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
						     		</td> 
								</tr>
								<c:set var="cuotas3" value="${amortizacion.cuotasCapital}"/>
								<c:set var="numTransaccion" value="${amortizacion.numTransaccion}"/>
								<c:set var="capInt" value="${amortizacion.capitalInteres}"/>
								<c:set var="valorFecUltAmor3" value="${amortizacion.fechaVencim}"/>  <%--SE agrego esta linea  --%>
							</c:forEach>
							<tr>
								<td colspan="9" align="right">
									<input id="transaccion" name="transaccion" size="18" style="text-align: right;" type = "hidden"
				         				value="${numTransaccion}" readonly = "readonly" disabled="disabled" esMoneda="true"/>

				         			<input id="valorFecUltAmor" name="valorFecUltAmor" size="18" style="text-align: right;" type = "hidden"
				         				value="${valorFecUltAmor3}" readonly="readonly" disabled="disabled"/> <%-- se agrego esta linea--%>	
				         				
									<button type="button" class="submit" id="recalculo" onclick="simuladorPagosLibres(${numTransaccion});">Recalcular</button> 		
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
										<input  type="text" id="consecutivoID${status.count}"  name="consecutivoID" size="4"  
												value="${status.count}" readonly="readonly" disabled="disabled"/> 
								  	</td> 
									<td> 
										<input  type="text" id="fechaInicio${status.count}"  name="fechaInicio" size="15"  
												value="${amortizacion.fechaInicio}" readonly="readonly" disabled="disabled"/> 
								  	</td> 
								  	<td align="center">
										<input  type="text" id="fechaVencim${status.count}" name="fechaVencim" size="15" 
												value="${amortizacion.fechaVencim}" readonly="readonly" disabled="disabled"/> 
								  	</td> 
								  	<td> 
										<input  type="text" id="fechaExigible${status.count}" name="fechaExigible" size="15" 
												value="${amortizacion.fechaExigible}" readonly="readonly" disabled="disabled"/> 
								  	</td> 
								  	<td> 
								  		<c:choose>
					     					<c:when test="${amortizacion.capitalInteres == 'I'}">
					     						<input type="text" id="capital${status.count}" name="capital" size="18" style="text-align: right;" 
														value="${amortizacion.capital}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
							     			</c:when>
							     		
					     					<c:when test="${amortizacion.capitalInteres == 'C'}">
					     						<input type="text"  id="capital${status.count}" name="capital" size="18" style="text-align: right;" 
														value="${amortizacion.capital}" onblur="agregaFormatoMonedaGrid(this.id);" esMoneda="true" /> 
							     			</c:when>
							     			
							     			<c:when test="${amortizacion.capitalInteres == 'G'}">
					     						<input type="text"  id="capital${status.count}" name="capital" size="18" style="text-align: right;" 
														value="${amortizacion.capital}" onblur="agregaFormatoMonedaGrid(this.id);" esMoneda="true"/> 
							     			</c:when>
								     	</c:choose>
								  	</td> 
						     		<td> 
						         	<input  type="text" id="interes${status.count}" name="interes" size="18" style="text-align: right;"
						         			value="${amortizacion.interes}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
						     		</td> 
									<td> 
						         	<input  type="text" id="ivaInteres${status.count}" name="ivaInteres" size="18" style="text-align: right;"
						         			value="${amortizacion.ivaInteres}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
						     		</td> 
						     		<td> 
						         	<input  type="text" id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" 
						         			value="${amortizacion.totalPago}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
						     		</td> 
						     		<td> 
						         	<input  type="text" id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;"
						         			value="${amortizacion.saldoInsoluto}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
						     		</td> 
								</tr>
								<c:set var="cuotas5" value="${amortizacion.cuotasCapital}"/>
								<c:set var="fechaVenc5" value="${amortizacion.fechaVencim}"/>
								<c:set var="numTransaccion5" value="${amortizacion.numTransaccion}"/>
							</c:forEach>
							<tr>
								<td colspan="9" align="right">
									<input id="transaccion" name="transaccion" size="18" style="text-align: right;" type = "hidden"
				         				value="${numTransaccion5}" readonly="readonly" disabled="disabled" esMoneda="true"/>
									<button type="button" class="submit" id="RecalcularTV" onclick="simuladorPagosLibresTasaVar(${numTransaccion5},${cuotas5});">Modificar</button> 		
								</td>
							</tr>
						</c:when>	
						<c:when test="${tipoLista == '7'}">
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
										<input  type="text" id="consecutivoID${status.count}"  name="consecutivoID" size="4"  
												value="${status.count}" readonly="readonly" disabled="disabled"/> 
								  	</td> 
									<td> 
										<input  type="text" id="fechaInicio${status.count}"  name="fechaInicio" size="15"  
												value="${amortizacion.fechaInicio}" readonly="readonly" disabled="disabled"/> 
								  	</td> 
								  	<td align="center">
										<input  type="text" id="fechaVencim${status.count}" name="fechaVencim" size="15" 
												value="${amortizacion.fechaVencim}" /> 
								  	</td> 
								  	<td> 
										<input type="text"  id="fechaExigible${status.count}" name="fechaExigible" size="15" 
												value="${amortizacion.fechaExigible}" readonly="readonly" disabled="disabled"/> 
								  	</td> 
								  	<td> 
								  		<input  type="text" id="capital${status.count}" name="capital" size="18" style="text-align: right;" 
														value="${amortizacion.capital}"  esMoneda="true"/> 
								  	</td> 
						     		<td> 
						         	<input type="text"  id="interes${status.count}" name="interes" size="18" style="text-align: right;"
						         			value="${amortizacion.interes}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
						     		</td> 
									<td> 
						         	<input  type="text" id="ivaInteres${status.count}" name="ivaInteres" size="18" style="text-align: right;" 
						         			value="${amortizacion.ivaInteres}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
						     		</td> 
						     		<td> 
						         	<input  type="text" id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" 
						         			value="${amortizacion.totalPago}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
						     		</td> 
						     		<td> 
						         	<input  type="text" id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;"
						         			value="${amortizacion.saldoInsoluto}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
						     		</td>
						     		<td><input type="hidden" id="numCuotasInt" value="${amortizacion.cuotasCapital}"></input></td>
						     		<td><input type="hidden" id="numCuotasCap" value="${amortizacion.cuotasInteres}"></input></td>
						     		<td><input type="hidden" id="fechaVenciCalIrre" value="${amortizacion.fechaVencimiento}"></input></td>   
								</tr>
								<c:set var="cuotas7" value="${status.count}" />  
								<c:set var="fechaVenc7" value="${amortizacion.fechaVencim}"/>
								<c:set var="numTransaccion7" value="${amortizacion.numTransaccion}"/>
								<c:set var="valorFecUltAmor3" value="${amortizacion.fecUltAmor}"/>
								<c:set var="valorfecInicioAmor3" value="${amortizacion.fecInicioAmor}"/>
							</c:forEach>
							<tr>
								<td colspan="9" align="right">
									<input id="transaccion" name="transaccion" size="18" style="text-align: right;" type = "hidden"
				         			value="${numTransaccion7}" readonly="readonly" disabled="disabled" esMoneda="true"/>	  
				         			<input id="valorFecUltAmor" name="valorFecUltAmor" size="18" style="text-align: right;" type = "hidden"
				         				value="${valorFecUltAmor3}" readonly="readonly" disabled="disabled"/>	
				         			<input id="valorfecInicioAmor" name="valorfecInicioAmor" size="18" style="text-align: right;" type = "hidden"
				         				value="${valorfecInicioAmor3}" readonly="readonly" disabled="disabled"/>	
								</td>
								<td align="right">
									<button type="button" class="submit" id="continuarTV" onclick="simuladorLibresCapFec();">Recalcular</button> 		
								</td>
							</tr>
						</c:when>	
						<c:when test="${tipoLista == '8'}">
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
										<input  type="text" id="consecutivoID${status.count}"  name="consecutivoID" size="4"  
												value="${status.count}" readonly="readonly" disabled="disabled"/> 
								  	</td> 
									<td> 
										<input  type="text" id="fechaInicio${status.count}"  name="fechaInicio" size="15"  
												value="${amortizacion.fechaInicio}" readonly="readonly" disabled="disabled"/> 
								  	</td> 
								  	<td align="center">
										<input  type="text" id="fechaVencim${status.count}" name="fechaVencim" size="15" 
												value="${amortizacion.fechaVencim}" /> 
								  	</td> 
								  	<td> 
										<input  type="text" id="fechaExigible${status.count}" name="fechaExigible" size="15" 
												value="${amortizacion.fechaExigible}" readonly="readonly" disabled="disabled"/> 
								  	</td> 
								  	<td> 
								  		<input type="text"  id="capital${status.count}" name="capital" size="18" style="text-align: right;" 
														value="${amortizacion.capital}"  esMoneda="true"/> 
								  	</td> 
						     		<td> 
						         	<input  type="text" id="interes${status.count}" name="interes" size="18" style="text-align: right;" 
						         			value="${amortizacion.interes}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
						     		</td> 
									<td> 
						         	<input type="text"  id="ivaInteres${status.count}" name="ivaInteres" size="18" style="text-align: right;" 
						         			value="${amortizacion.ivaInteres}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
						     		</td> 
						     		<td> 
						         	<input  type="text" id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" 
						         			value="${amortizacion.totalPago}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
						     		</td> 
						     		<td> 
						         	<input  type="text" id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;" 
						         			value="${amortizacion.saldoInsoluto}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
						     		</td> 
								</tr>
								<c:set var="cuotas8" value="${status.count}" /> 
								<c:set var="fechaVenc8" value="${amortizacion.fechaVencim}"/>
								<c:set var="numTransaccion8" value="${amortizacion.numTransaccion}"/>
								<c:set var="valorFecUltAmor4" value="${amortizacion.fecUltAmor}"/>
								<c:set var="valorfecInicioAmor4" value="${amortizacion.fecInicioAmor}"/>
							</c:forEach>
							<tr>
								<td align="right" colspan="9" align="right">		
									<input id="transaccion" name="transaccion" size="18" style="text-align: right;" type = "hidden"
				         				value="${numTransaccion8}" readonly="readonly" disabled="disabled" esMoneda="true"/>		
				         			<input id="valorFecUltAmor" name="valorFecUltAmor" size="18" style="text-align: right;" type = "hidden"
				         				value="${valorFecUltAmor4}" readonly="readonly" disabled="disabled"/>		 
				         			<input id="valorfecInicioAmor" name="valorfecInicioAmor" size="18" style="text-align: right;" type = "hidden"
				         				value="${valorfecInicioAmor4}" readonly="readonly" disabled="disabled"/>			
									<button type="button" class="submit" id="continuarTV" onclick="simuladorLibresCapFec();">Recalcular</button> 		
								</td>
							</tr>
						</c:when>	
					</c:choose>
				</c:when>
			</c:choose>
		</table>
	</form>
</fieldset>
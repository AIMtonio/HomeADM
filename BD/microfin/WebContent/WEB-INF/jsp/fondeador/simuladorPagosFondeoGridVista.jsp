<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  		value="${listaResultado[0]}"/>
<c:set var="fechaVencimiento"	value="${listaResultado[1]}"/>
<c:set var="listaPaginada" 		value="${listaResultado[2]}"/>
<c:set var="listaResultado" 	value="${listaPaginada.pageList}"/>


<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend>Simulador de Amortizaciones</legend>	
	<form id="gridDetalle" name="gridDetalle">
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '1'}">
					<tr>
						<td class="label" align="center"><label for="lblNumero">N&uacute;mero</label></td>
						<td class="label" align="center"><label for="lblFecIni">Fecha Inicio</label></td>
						<td class="label" align="center"><label for="lblFecFin">Fecha Vencimiento</label> </td>	
						<td class="label" align="center"><label for="lblFecPag">Fecha Pago</label></td>
				  		<td class="label" align="center"><label for="lblCapital">Capital</label></td> 
			     		<td class="label" align="center"><label for="lblDescripcion">Inter&eacute;s</label></td> 
			     		<td class="label" align="center"><label for="lblCargos">Iva Inter&eacute;s</label></td> 
			     		<td class="label" align="center"><label for="lblCargos">Retenci&oacute;n</label></td> 
			     		<td class="label" align="center"><label for="lblTotalPag">Total Pago</label></td> 
			     		<td class="label" align="center"><label for="lblSaldoCap">Saldo Capital</label></td> 
					</tr>
					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td> 
								<c:choose>
									<c:when test="${amortizacion.fechaInicio == '1900-01-01'}">
										<input id="amortizacionID${status.count}"  name="amortizacionID" size="4" type="text"  
										value="" readonly="readonly" disabled="disabled" style="border: none;"/> 
									</c:when>
									<c:otherwise>
										<input id="amortizacionID${status.count}"  name="amortizacionID" size="4" type="text"  
											value="${amortizacion.amortizacionID}" readonly="readonly" disabled="disabled"/> 
									</c:otherwise>
								</c:choose> 
						  	</td> 
						  	<td>
								<c:choose>
									<c:when test="${amortizacion.fechaInicio == '1900-01-01'}"> 
										<input id="fechaInicio${status.count}"  name="fechaInicio" size="15" type="text"  
												value="" readonly="readonly" disabled="disabled" style="border: none;"/>
									</c:when>
									<c:otherwise>
										<input id="fechaInicio${status.count}"  name="fechaInicio" size="15" type="text"  
												value="${amortizacion.fechaInicio}" readonly="readonly" disabled="disabled"/>
									</c:otherwise>
								</c:choose> 
						  	</td> 
						  	<td> 
						  		<c:choose>
									<c:when test="${amortizacion.fechaInicio == '1900-01-01'}">
										<input id="fechaVencim${status.count}"  name="fechaVencim" size="15" type="text"  
												value="" readonly="readonly" disabled="disabled" style="border: none;"/>
									</c:when>
									<c:otherwise>
										<input id="fechaVencim${status.count}" name="fechaVencim" size="15" type="text" 
											value="${amortizacion.fechaVencim}" readonly="readonly" disabled="disabled"/> 
									</c:otherwise>
								</c:choose> 
						  	</td> 
						  	<td> 
						  		<c:choose>
									<c:when test="${amortizacion.fechaInicio == '1900-01-01'}">
										<input id="fechaExigible${status.count}" name="fechaExigible" size="15" type="text" 
												value="" readonly="readonly" disabled="disabled" style="border: none;"/>
									</c:when>
									<c:otherwise>
										<input id="fechaExigible${status.count}" name="fechaExigible" size="15" type="text" 
												value="${amortizacion.fechaExigible}" readonly="readonly" disabled="disabled"/> 
									</c:otherwise>
								</c:choose> 
						  	</td> 
						  	<td> 
								<input id="capital${status.count}" name="capital" size="18"  style="text-align: right;" type="text"
										value="${amortizacion.capital}" readonly="readonly" disabled="disabled"  esMoneda="true" /> 
						  	</td> 
				     		<td> 
				         	<input id="interes${status.count}" name="interes" size="18"  style="text-align: right;" type="text"
				         			value="${amortizacion.interes}" readonly="readonly" disabled="disabled"  esMoneda="true"/> 
				     		</td> 
							<td> 
				         	<input id="ivaInteres${status.count}" name="ivaInteres" size="18" style="text-align: right;" type="text"
				         			value="${amortizacion.ivaInteres}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
							<td> 
				         		<input id="retencion${status.count}" name="retencion" size="18" style="text-align: right;" type="text"
				         			value="${amortizacion.retencion}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
				     		<td> 
				     			<c:choose>
									<c:when test="${amortizacion.fechaInicio == '1900-01-01'}">
										<input id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;border: none;" type="text"
				         					value="" readonly="readonly" disabled="disabled" esMoneda="true" />
									</c:when>
									<c:otherwise>
										<input id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" type="text"
				         					value="${amortizacion.totalPago}" readonly="readonly" disabled="disabled" esMoneda="true"/>  
									</c:otherwise>
								</c:choose> 
				     		</td> 
				     		<td> 
				         		<c:choose>
									<c:when test="${amortizacion.fechaInicio == '1900-01-01'}">
										<input id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;border: none;" type="text"
				         					value="" readonly="readonly" disabled="disabled" esMoneda="true"/> 
									</c:when>
									<c:otherwise>
				         				<input id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;" type="text"
				         					value="${amortizacion.saldoInsoluto}" readonly="readonly" disabled="disabled" esMoneda="true"/>  
									</c:otherwise>
								</c:choose> 
				     		</td> 
						</tr>
						<c:set var="cuotas" value="${amortizacion.cuotasCapital}"/>
						<c:set var="numTransaccion" value="${amortizacion.numTransaccion}"/>
						<c:set var="valorFecUltAmor" value="${amortizacion.fecUltAmor}"/>
						<c:set var="valorfecInicioAmor" value="${amortizacion.fecInicioAmor}"/>
						<c:set var="valorMontoCuota" value="${amortizacion.montoCuota}"/>
					</c:forEach>
					<tr>
						<td colspan="9">
							<table align="right">
								<tr>
									<td align="right"  colspan="5">
										<input id="transaccion" name="transaccion" size="18" align="right"  type = "hidden"
							         			value="${numTransaccion}" readonly="readonly" disabled="disabled" />													 
										<input id="cuotas" name="cuotas" size="18" align="right"  type = "hidden"
							         			value="${cuotas}" readonly="readonly" disabled="disabled" />
						         		<input id="valorCuotasInt" name="valorCuotasInt" size="18" align="right"  type = "hidden"
						         			value="${cuotas}" readonly="readonly" disabled="disabled" />	
							         	<input id="valorFecUltAmor" name="valorFecUltAmor" size="18" align="right"  type = "hidden"
							         			value="${valorFecUltAmor}" readonly="readonly" disabled="disabled"/>	
							         	<input id="valorfecInicioAmor" name="valorfecInicioAmor" size="18" align="right"  type = "hidden"
							         			value="${valorfecInicioAmor}" readonly="readonly" disabled="disabled"/>
							         	<input id="valorMontoCuota" name="valorMontoCuota" size="18" align="right"  type = "hidden"
							         			value="${valorMontoCuota}" readonly="readonly" disabled="disabled"/>
									</td>
								</tr> 		
							</table> 
						</td>	
					</tr>
				</c:when>
				<c:when test="${tipoLista == '2'}">
					<tr>
						<td class="label" align="center"><label for="lblNumero">N&uacute;mero</label></td>
						<td class="label" align="center"><label for="lblFecIni">Fecha Inicio</label></td>
						<td class="label" align="center"><label for="lblFecFin">Fecha Vencimiento</label> </td>	
						<td class="label" align="center"><label for="lblFecPag">Fecha Pago</label></td>
				  		<td class="label" align="center"><label for="lblCapital">Capital</label></td> 
			     		<td class="label" align="center"><label for="lblDescripcion">Inter&eacute;s</label></td> 
			     		<td class="label" align="center"><label for="lblCargos">Iva Inter&eacute;s</label></td> 
			     		<td class="label" align="center"><label for="lblCargos">Retenci&oacute;n</label></td> 
			     		<td class="label" align="center"><label for="lblTotalPag">Total Pago</label></td> 
			     		<td class="label" align="center"><label for="lblSaldoCap">Saldo Capital</label></td> 
					</tr>
					
					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">  
							<td> 
								<c:choose>
									<c:when test="${amortizacion.fechaInicio == '1900-01-01'}">
										<input id="amortizacionID${status.count}"  name="amortizacionID" size="4" type="text"  
										value="" readonly="readonly" disabled="disabled" style="border: none;"/> 
									</c:when>
									<c:otherwise>
										<input id="amortizacionID${status.count}"  name="amortizacionID" size="4" type="text"  
											value="${amortizacion.amortizacionID}" readonly="readonly" disabled="disabled"/> 
									</c:otherwise>
								</c:choose> 
						  	</td> 
						  	<td>
								<c:choose>
									<c:when test="${amortizacion.fechaInicio == '1900-01-01'}"> 
										<input id="fechaInicio${status.count}"  name="fechaInicio" size="15" type="text"  
												value="" readonly="readonly" disabled="disabled" style="border: none;"/>
									</c:when>
									<c:otherwise>
										<input id="fechaInicio${status.count}"  name="fechaInicio" size="15" type="text"  
												value="${amortizacion.fechaInicio}" readonly="readonly" disabled="disabled"/>
									</c:otherwise>
								</c:choose> 
						  	</td> 
						  	<td> 
						  		<c:choose>
									<c:when test="${amortizacion.fechaInicio == '1900-01-01'}">
										<input id="fechaVencim${status.count}"  name="fechaVencim" size="15" type="text"  
												value="" readonly="readonly" disabled="disabled" style="border: none;"/>
									</c:when>
									<c:otherwise>
										<input id="fechaVencim${status.count}" name="fechaVencim" size="15" type="text" 
											value="${amortizacion.fechaVencim}" readonly="readonly" disabled="disabled"/> 
									</c:otherwise>
								</c:choose> 
						  	</td> 
						  	<td> 
						  		<c:choose>
									<c:when test="${amortizacion.fechaInicio == '1900-01-01'}">
										<input id="fechaExigible${status.count}" name="fechaExigible" size="15" type="text" 
												value="" readonly="readonly" disabled="disabled" style="border: none;"/>
									</c:when>
									<c:otherwise>
										<input id="fechaExigible${status.count}" name="fechaExigible" size="15" type="text" 
												value="${amortizacion.fechaExigible}" readonly="readonly" disabled="disabled"/> 
									</c:otherwise>
								</c:choose> 
						  	</td> 
						  	<td> 
								<input id="capital${status.count}" name="capital" size="18"  style="text-align: right;" type="text"
										value="${amortizacion.capital}" readonly="readonly" disabled="disabled"  esMoneda="true" /> 
						  	</td> 
				     		<td> 
				         	<input id="interes${status.count}" name="interes" size="18"  style="text-align: right;" type="text"
				         			value="${amortizacion.interes}" readonly="readonly" disabled="disabled"  esMoneda="true"/> 
				     		</td> 
							<td> 
				         	<input id="ivaInteres${status.count}" name="ivaInteres" size="18" style="text-align: right;" type="text"
				         			value="${amortizacion.ivaInteres}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
							<td> 
				         		<input id="retencion${status.count}" name="retencion" size="18" style="text-align: right;" type="text"
				         			value="${amortizacion.retencion}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
				     		<td> 
				     			<c:choose>
									<c:when test="${amortizacion.fechaInicio == '1900-01-01'}">
										<input id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;border: none;" type="text"
				         					value="" readonly="readonly" disabled="disabled" esMoneda="true" />
									</c:when>
									<c:otherwise>
										<input id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" type="text"
				         					value="${amortizacion.totalPago}" readonly="readonly" disabled="disabled" esMoneda="true"/>  
									</c:otherwise>
								</c:choose> 
				     		</td> 
				     		<td> 
				         		<c:choose>
									<c:when test="${amortizacion.fechaInicio == '1900-01-01'}">
										<input id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;border: none;" type="text"
				         					value="" readonly="readonly" disabled="disabled" esMoneda="true"/> 
									</c:when>
									<c:otherwise>
				         				<input id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;" type="text"
				         					value="${amortizacion.saldoInsoluto}" readonly="readonly" disabled="disabled" esMoneda="true"/>  
									</c:otherwise>
								</c:choose> 
				     		</td> 
						</tr>
						
						<c:set var="cuotas2" value="${amortizacion.cuotasCapital}"/>
						<c:set var="numTransaccion2" value="${amortizacion.numTransaccion}"/>
						<c:set var="valorFecUltAmor2" value="${amortizacion.fecUltAmor}"/>
						<c:set var="valorfecInicioAmor2" value="${amortizacion.fecInicioAmor}"/>
						<c:set var="valorCuotasInt" value="${amortizacion.cuotasInteres}"/>
						<c:set var="valorMontoCuota2" value="${amortizacion.montoCuota}"/>
					</c:forEach>
					<tr>
					<td colspan="9">
						<table align="right" >
							<tr>
								<td align="right" colspan="5">
									<input id="transaccion" name="transaccion" size="18" align="right"  type = "hidden"
						         			value="${numTransaccion2}" readonly="readonly" disabled="disabled" />													 
									<input id="cuotas" name="cuotas" size="18" align="right"  type = "hidden"
						         			value="${cuotas2}" readonly="readonly" disabled="disabled" />
						         	<input id="valorFecUltAmor" name="valorFecUltAmor" size="18" align="right"  type = "hidden"
						         			value="${valorFecUltAmor2}" readonly="readonly" disabled="disabled"/>	
						         	<input id="valorfecInicioAmor" name="valorfecInicioAmor" size="18" align="right"  type = "hidden"
						         			value="${valorfecInicioAmor2}" readonly="readonly" disabled="disabled"/>	
						         	<input id="valorCuotasInt" name="valorCuotasInt" size="18" align="right"  type = "hidden"
						         			value="${valorCuotasInt}" readonly="readonly" disabled="disabled" />
						         	<input id="valorMontoCuota" name="valorMontoCuota" size="18" align="right"  type = "hidden"
						         			value="${valorMontoCuota2}" readonly="readonly" disabled="disabled"/>
								</td>
							</tr>
							
						</table>
						</td> 
					</tr>
				</c:when>
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
												value=" "  esMoneda="true"/> 
					     			</c:when>
					     			
					     			<c:when test="${amortizacion.capitalInteres == 'G'}">
			     						<input id="capital${status.count}" name="capital" size="18"  style="text-align: right;" type="text"
												value=" " esMoneda="true" /> 
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
				<c:when test="${tipoLista == '4'}">
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
								<input id="capital${status.count}" name="capital" size="18" style="text-align: right;" type="text"
										value="${amortizacion.capital}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
						  	</td> 
				     		<td> 
				         	<input id="interes${status.count}" name="interes" size="18" style="text-align: right;" type="text"
				         			value="${amortizacion.interes}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
							<td> 
				         	<input id="ivaInteres${status.count}" name="ivaInteres" size="18"  style="text-align: right;" type="text"
				         			value="${amortizacion.ivaInteres}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
				     		<td> 
				         	<input id="totalPago${status.count}" name="totalPago" size="18"  style="text-align: right;" type="text"
				         			value="${amortizacion.totalPago}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
				     		<td> 
				         	<input id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18"  style="text-align: right;" type="text"
				         			value="${amortizacion.saldoInsoluto}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
						</tr>
						
						<c:set var="cuotas4" value="${amortizacion.cuotasCapital}"/>
						<c:set var="numTransaccion4" value="${amortizacion.numTransaccion}"/>
						<c:set var="valorFecUltAmor4" value="${amortizacion.fecUltAmor}"/>
						<c:set var="valorfecInicioAmor4" value="${amortizacion.fecInicioAmor}"/>
						<c:set var="valorCuotasInt2" value="${amortizacion.cuotasInteres}"/>
						<c:set var="valorMontoCuota4" value="${amortizacion.montoCuota}"/>
					</c:forEach>
					<tr>
					<td colspan="9">
						<table align="right" >
							<tr>
								<td align="right">
									<input id="transaccion" name="transaccion" size="18" align="right"  type = "hidden"
						         			value="${numTransaccion4}" readonly="readonly" disabled="disabled" />													 
									<input id="cuotas" name="cuotas" size="18" align="right"  type = "hidden"
						         			value="${cuotas4}" readonly="readonly" disabled="disabled" />		
						         	<input id="valorFecUltAmor" name="valorFecUltAmor" size="18" align="right"  type = "hidden"
						         			value="${valorFecUltAmor4}" readonly="readonly" disabled="disabled"/>	
						         	<input id="valorfecInicioAmor" name="valorfecInicioAmor" size="18" align="right"  type = "hidden"
						         			value="${valorfecInicioAmor4}" readonly="readonly" disabled="disabled"/>
						         	<input id="valorCuotasInt" name="valorCuotasInt" size="18" align="right"  type = "hidden"
						         			value="${valorCuotasInt2}" readonly="readonly" disabled="disabled" />			
						         	<input id="valorMontoCuota" name="valorMontoCuota" size="18" align="right"  type = "hidden"
						         			value="${valorMontoCuota4}" readonly="readonly" disabled="disabled"/>
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
												value=" "  esMoneda="true"/> 
					     			</c:when>
					     			
					     			<c:when test="${amortizacion.capitalInteres == 'G'}">
			     						<input id="capital${status.count}" name="capital" size="18"  style="text-align: right;" type="text"
												value=" " esMoneda="true" /> 
					     			</c:when>
						     	</c:choose>
								
						  	</td> 
				     		<td> 
				         	<input id="interes${status.count}" name="interes" size="18" style="text-align: right;" type="text"
				         			value="0.00" readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
							<td> 
				         	<input id="ivaInteres${status.count}" name="ivaInteres" size="18"  style="text-align: right;" type="text"
				         			value="0.00" readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
				     		<td> 
				         	<input id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" type="text"
				         			value="" readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
				     		<td> 
				         	<input id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18"  style="text-align: right;" type="text"
				         			value="" readonly="readonly" disabled="disabled" esMoneda="true"/> 
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
				<c:when test="${tipoLista == '11'}">
					<tr>
						<td class="label" align="center"><label for="lblNumero">N&uacute;mero</label></td>
						<td class="label" align="center"><label for="lblFecIni">Fecha Inicio</label></td>
						<td class="label" align="center"><label for="lblFecFin">Fecha Vencimiento</label> </td>	
						<td class="label" align="center"><label for="lblFecPag">Fecha Pago</label></td>
				  		<td class="label" align="center"><label for="lblCapital">Capital</label></td> 
			     		<td class="label" align="center"><label for="lblDescripcion">Inter&eacute;s</label></td> 
			     		<td class="label" align="center"><label for="lblCargos">Iva Inter&eacute;s</label></td> 
			     		<td class="label" align="center"><label for="lblCargos">Retenci&oacute;n</label></td> 
			     		<td class="label" align="center"><label for="lblTotalPag">Total Pago</label></td> 
			     		<td class="label" align="center"><label for="lblSaldoCap">Saldo Capital</label></td> 
					</tr>
					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td> 
								<c:choose>
									<c:when test="${amortizacion.fechaInicio == '1900-01-01'}">
										<input id="amortizacionID${status.count}"  name="amortizacionID" size="4" type="text"  
										value="" readonly="readonly" disabled="disabled" style="border: none;"/> 
									</c:when>
									<c:otherwise>
										<input id="amortizacionID${status.count}"  name="amortizacionID" size="4" type="text"  
											value="${amortizacion.amortizacionID}" readonly="readonly" disabled="disabled"/> 
									</c:otherwise>
								</c:choose> 
						  	</td> 
						  	<td>
								<c:choose>
									<c:when test="${amortizacion.fechaInicio == '1900-01-01'}"> 
										<input id="fechaInicio${status.count}"  name="fechaInicio" size="15" type="text"  
												value="" readonly="readonly" disabled="disabled" style="border: none;"/>
									</c:when>
									<c:otherwise>
										<input id="fechaInicio${status.count}"  name="fechaInicio" size="15" type="text"  
												value="${amortizacion.fechaInicio}" readonly="readonly" disabled="disabled"/>
									</c:otherwise>
								</c:choose> 
						  	</td> 
						  	<td> 
						  		<c:choose>
									<c:when test="${amortizacion.fechaInicio == '1900-01-01'}">
										<input id="fechaVencim${status.count}"  name="fechaVencim" size="15" type="text"  
												value="" readonly="readonly" disabled="disabled" style="border: none;"/>
									</c:when>
									<c:otherwise>
										<input id="fechaVencim${status.count}" name="fechaVencim" size="15" type="text" 
											value="${amortizacion.fechaVencim}" readonly="readonly" disabled="disabled"/> 
									</c:otherwise>
								</c:choose> 
						  	</td> 
						  	<td> 
						  		<c:choose>
									<c:when test="${amortizacion.fechaInicio == '1900-01-01'}">
										<input id="fechaExigible${status.count}" name="fechaExigible" size="15" type="text" 
												value="" readonly="readonly" disabled="disabled" style="border: none;"/>
									</c:when>
									<c:otherwise>
										<input id="fechaExigible${status.count}" name="fechaExigible" size="15" type="text" 
												value="${amortizacion.fechaExigible}" readonly="readonly" disabled="disabled"/> 
									</c:otherwise>
								</c:choose> 
						  	</td> 
						  	<td> 
								<input id="capital${status.count}" name="capital" size="18"  style="text-align: right;" type="text"
										value="${amortizacion.capital}" readonly="readonly" disabled="disabled"  esMoneda="true" /> 
						  	</td> 
				     		<td> 
				         	<input id="interes${status.count}" name="interes" size="18"  style="text-align: right;" type="text"
				         			value="${amortizacion.interes}" readonly="readonly" disabled="disabled"  esMoneda="true"/> 
				     		</td> 
							<td> 
				         	<input id="ivaInteres${status.count}" name="ivaInteres" size="18" style="text-align: right;" type="text"
				         			value="${amortizacion.ivaInteres}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
							<td> 
				         		<input id="retencion${status.count}" name="retencion" size="18" style="text-align: right;" type="text"
				         			value="${amortizacion.retencion}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     		</td> 
				     		<td> 
				     			<c:choose>
									<c:when test="${amortizacion.fechaInicio == '1900-01-01'}">
										<input id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;border: none;" type="text"
				         					value="" readonly="readonly" disabled="disabled" esMoneda="true" />
									</c:when>
									<c:otherwise>
										<input id="totalPago${status.count}" name="totalPago" size="18" style="text-align: right;" type="text"
				         					value="${amortizacion.totalPago}" readonly="readonly" disabled="disabled" esMoneda="true"/>  
									</c:otherwise>
								</c:choose> 
				     		</td> 
				     		<td> 
				         		<c:choose>
									<c:when test="${amortizacion.fechaInicio == '1900-01-01'}">
										<input id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;border: none;" type="text"
				         					value="" readonly="readonly" disabled="disabled" esMoneda="true"/> 
									</c:when>
									<c:otherwise>
				         				<input id="saldoInsoluto${status.count}" name="saldoInsoluto" size="18" style="text-align: right;" type="text"
				         					value="${amortizacion.saldoInsoluto}" readonly="readonly" disabled="disabled" esMoneda="true"/>  
									</c:otherwise>
								</c:choose> 
				     		</td> 
						</tr>
						<c:set var="cuotas" value="${amortizacion.cuotasCapital}"/>
						<c:set var="numTransaccion" value="${amortizacion.numTransaccion}"/>
						<c:set var="valorFecUltAmor" value="${amortizacion.fecUltAmor}"/>
						<c:set var="valorfecInicioAmor" value="${amortizacion.fecInicioAmor}"/>
						<c:set var="valorMontoCuota" value="${amortizacion.montoCuota}"/>
						<c:set var="valorCuotasInt" value="${amortizacion.cuotasInteres}"/>
					</c:forEach>
					<tr>
						<td colspan="9">
							<table align="right">
								<tr>
									<td align="right"  colspan="5">
										<input id="transaccion" name="transaccion" size="18" align="right"  type = "hidden"
							         			value="${numTransaccion}" readonly="readonly" disabled="disabled" />													 
										<input id="cuotas" name="cuotas" size="18" align="right"  type = "hidden"
							         			value="${cuotas}" readonly="readonly" disabled="disabled" />
						         		<input id="valorCuotasInt" name="valorCuotasInt" size="18" align="right"  type = "hidden"
						         			value="${valorCuotasInt}" readonly="readonly" disabled="disabled" />	
							         	<input id="valorFecUltAmor" name="valorFecUltAmor" size="18" align="right"  type = "hidden"
							         			value="${valorFecUltAmor}" readonly="readonly" disabled="disabled"/>	
							         	<input id="valorfecInicioAmor" name="valorfecInicioAmor" size="18" align="right"  type = "hidden"
							         			value="${valorfecInicioAmor}" readonly="readonly" disabled="disabled"/>
							         	<input id="valorMontoCuota" name="valorMontoCuota" size="18" align="right"  type = "hidden"
							         			value="${valorMontoCuota}" readonly="readonly" disabled="disabled"/>
									</td>
								</tr> 		
							</table> 
						</td>	
					</tr>
				</c:when>			
			</c:choose>
			
		</table>
					<c:if test="${!listaPaginada.firstPage}">
						 <input onclick="simulador('previous')" type="button" value="" class="btnAnterior" />
					</c:if>
					<c:if test="${!listaPaginada.lastPage}">
						 <input onclick="simulador('next')" type="button" value="" class="btnSiguiente" />
					</c:if>	

					<input id ="fech" type="hidden" value="${fechaVencimiento.fechaVencim}" />  	
	</form>
</fieldset>
	
<script type="text/javascript">
	function simulador(pageValor){
		var pagoFinAni=""; 
		var pagoFinAniInt="";
		var diaHabilSig="";
		var ajustaFecAmo=""; 
		var ajusFecExiVen="";   
		var tipoLista =0; 
		
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
					 		
				params['empresaID'] = parametroBean.empresaID;
				params['usuario'] = parametroBean.numeroUsuario;
				params['fecha'] = parametroBean.fechaSucursal;
				params['direccionIP'] = parametroBean.IPsesion;
				params['sucursal'] = parametroBean.sucursal;
				params['page'] = pageValor ;
				params['fechaV'] = $('#fechaVencimien').val(); 
				if($('#frecuenciaCap').val()== 1){
					alert("Debe Seleccionar la Frecuencia.");
				}
				$.post("simPagCreditoFondeo.htm", params, function(data){
					if(data.length >0 || data != null) { 
						$('#contenedorSimulador').html(data); 
						$('#contenedorSimulador').show(); 
						$('#contenedorSimuladorLibre').html("");
						$('#contenedorSimuladorLibre').hide();
					}else{
						$('#contenedorSimulador').html("");
						$('#contenedorSimulador').hide();
						$('#contenedorSimuladorLibre').html("");
						$('#contenedorSimuladorLibre').hide();
					}
					$('#contenedorForma').unblock();
				});  
			}
		}
	}//fin funcion simulador()
</script>


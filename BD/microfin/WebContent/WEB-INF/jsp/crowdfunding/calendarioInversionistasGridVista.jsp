<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="listaResultado"  value="${listaResultado[0]}"/>
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend>Calendario Inversionistas</legend>
	<form id="gridDetalleCalen" name="gridDetalleCalen">
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
			<tbody>
				<tr>
					<td class="label">
			        	<label for="lblNumero">N&uacute;mero</label>
			     	</td>
			     	<td class="label">
					  	<label for="lblFecIni">Inicio</label>
					</td>
					<td class="label">
			         	<label for="lblFecVencim">Vencimiento</label>
			     	</td>
			     	<td class="label">
			         	<label for="lblFecExi">Exigible</label>
			     	</td>
					<td class="label">
			         	<label for="lblFecTermi">Terminaci&oacute;n</label>
			     	</td>
			     	<td class="label">
			         	<label for="lblCapital">Capital</label>
			     	</td>
			     	<td class="label">
			        	<label for="lblInteres">Inter&eacute;s</label>
			     	</td>
			     	<td class="label">
			         	<label for="lblInteres">Retenci&oacute;n</label>
			     	</td>
			     	<td class="label">
			        	<label for="lblEstatus">Estatus</label>
			     	</td>
			     	<td class="label">
			        	<label for="lblSaldosCapital">Saldo <br> </>Capital</label>
			     	</td>
					<td class="label">
			        	<label for="lblSaldoInter">Saldo <br>  Inter&eacute;s</label>
			     	</td>
			     	<td class="label">
			        	<label for="lblSaldoInter">Saldo <br> Int. Mora.</label>
			     	</td>
			     	<td class="label">
			        	<label for="lblSaldoInter">Saldo <br>Cap.C.O</label>
			     	</td>
			     	<td class="label">
			        	<label for="lblSaldoInter">Saldo<br>Int.C.O.</label>
			     	</td>
				</tr>
				<c:forEach items="${listaResultado}" var="calendario" varStatus="status">
				<tr id="renglon${status.count}" name="renglon">
					<td>
						<input id="amortizacionID${status.count}" name="amortizacionID" size="6"
							value="${calendario.amortizacionID}" readOnly="true" disabled="true"/>
					</td>
			 	  	<td>
						<input id="fechaInicio${status.count}"  name="fechaInicio" size="11"
							value="${calendario.fechaInicio}" readOnly="true" disabled="true"/>
					</td>
					<td>
				    	<input id="fechaVencimiento${status.count}" name="fechaVencimiento" size="11" align="right"
				        	value="${calendario.fechaVencimiento}" readOnly="true" disabled="true" />
				 	</td>
					<td>
				     	<input id="fechaExigible${status.count}" name="fechaExigible" size="11"
				        	value="${calendario.fechaExigible}" readOnly="true" disabled="true"/>
				  	</td>
				    <td>
				    	<input id="fechaLiquida${status.count}" name="fechaLiquida" size="11"
				        	value="${calendario.fechaLiquida}" readOnly="true" disabled="true"/>
				   	</td>
				    <td>
				    	<input style="text-align:right" id="capital${status.count}" name="capital" size="10" align="right"
				        	value="${calendario.capital}" readOnly="true" disabled="true" esMoneda="true"/>
				   	</td>
				   	<td>
				    	<input style="text-align:right" id="interesGenerado${status.count}" name="interesGenerado" size="10" align="right"
				        	value="${calendario.interesGenerado}" readOnly="true" disabled="true" esMoneda="true"/>
				    </td>
				    <td>
				    	<input style="text-align:right" id="interesRetener${status.count}" name="interesRetener" size="10" align="right"
				        	value="${calendario.interesRetener}" readOnly="true" disabled="true" esMoneda="true"/>
				   	</td>
					<c:if test="${calendario.estatus == 'N'}">
				    <td>
				    	<input id="estatus${status.count}" name="estatus" size="10" align="right"
				        	value="VIGENTE" readOnly="true" disabled="true" />
				    </td>
					</c:if>
					<c:if test="${calendario.estatus == 'P'}">
				    <td>
				      	<input id="estatus${status.count}" name="estatus" size="10" align="right"
				    		value="PAGADA" readOnly="true" disabled="true" />
				    </td>
					</c:if>
					<c:if test="${calendario.estatus != 'N' && calendario.estatus != 'P'}">
					<td>
				       	<input id="estatus${status.count}" name="estatus" size="10" align="right"
				    		value="${calendario.estatus}" readOnly="true" disabled="true" />
				    </td>
				    </c:if>
				    <td>
				      	<input style="text-align:right" id="saldoCapVigente${status.count}" name="saldoCapVigente" size="10" align="right"
				    		value="${calendario.saldoCapVigente}" readOnly="true" disabled="true" esMoneda="true"/>
				 	</td>
				    <td>
				    	<input style="text-align:right" id="saldoInteres${status.count}" name="saldoInteres" size="10" align="right"
				        	value="${calendario.saldoInteres}" readOnly="true" disabled="true" esMoneda="true"/>
				    </td>
				    <td>
				    	<input style="text-align:right" id="saldoMoratorios${status.count}" name="saldoMoratorios" size="10" align="right"
				        	value="${calendario.saldoMoratorios}" readOnly="true" disabled="true" esMoneda="true"/>
				    </td>
				     <td>
				    	<input style="text-align:right" id="saldoCapCtaOrden${status.count}" name="saldoCapCtaOrden" size="10" align="right"
				        	value="${calendario.saldoCapCtaOrden}" readOnly="true" disabled="true" esMoneda="true"/>
				    </td>
				    <td>
				    	<input style="text-align:right" id="saldoIntCtaInt${status.count}" name="saldoIntCtaInt" size="10" align="right"
				        	value="${calendario.saldoIntCtaInt}" readOnly="true" disabled="true" esMoneda="true"/>
				    </td>
				</tr>

					<c:set var="totalCap" value="${calendario.totalSalCapital}"/>
					<c:set var="totalInt" value="${calendario.totalSalInteres}"/>
					<c:set var="totalIntMora" value="${calendario.totalIntMora}"/>
					<c:set var="totalCapCO" value="${calendario.totalCapCO}"/>
					<c:set var="totalIntCO" value="${calendario.totalIntCO}"/>
				</c:forEach>
				<tr><td colspan=8></td>
					<td><label for="lblTotal">Total</label></td>
					<td>
				    	<input style="text-align:right" id="totalCap" name="totalCap" size="10" align="right"
				         	 		value="${totalCap}" readOnly="true" disabled="true" esMoneda="true"/>
				  	</td>
					<td>
				    	<input style="text-align:right" id="totalInt" name="totalInt" size="10" align="right"
				         	 		value="${totalInt}" readOnly="true" disabled="true" esMoneda="true" />
				  	</td>
				  	<td>
				    	<input style="text-align:right" id="totalIntMora" name="totalIntMora" size="10" align="right"
				         	 		value="${totalIntMora}" readOnly="true" disabled="true" esMoneda="true" />
				  	</td>
				  	<td>
				    	<input style="text-align:right" id="totalCapCO" name="totalCapCO" size="10" align="right"
				         	 		value="${totalCapCO}" readOnly="true" disabled="true" esMoneda="true" />
				  	</td>
				  	<td>
				    	<input style="text-align:right" id="totalIntCO" name="totalIntCO" size="10" align="right"
				         	 		value="${totalIntCO}" readOnly="true" disabled="true" esMoneda="true" />
				  	</td>
				</tr>
			</tbody>
			</table>
</form>
</fieldset>
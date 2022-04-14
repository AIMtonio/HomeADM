<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<br></br>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<c:choose>
	<c:when test="${tipoLista == '1'}">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Amortizaciones</legend>
		<table border="0" cellpadding="0" cellspacing="0" align=center >
			<tr>
				<td style="vertical-align:top">
					<table id="encabezados" border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label" nowrap="nowrap"><input type="text" value="N&uacute;m." readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;text-align: center;" size="4"/></td>
							<td class="label" nowrap="nowrap"><input type="text" value="Fec.Inicio." readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td>
							<td class="label" nowrap="nowrap"><input type="text" value="Fec.Vencim." readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td>	
							<td class="label" nowrap="nowrap"><input type="text" value="Fec.Exigible" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td>
					  		<td class="label" nowrap="nowrap"><input type="text" value="Estatus" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td>
					  		 
				     		<td class="label" nowrap="nowrap"><input type="text" value="Capital" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td> 
				     		<td class="label" nowrap="nowrap"><input type="text" value="Inter&eacute;s" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td> 
				     		<td class="label" nowrap="nowrap"><input type="text" value="IVA Inter&eacute;s" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td>
				     		<td class="label" nowrap="nowrap"><input type="text" value="Retenci&oacute;n" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td> 
				     		<td class="label" nowrap="nowrap"><input type="text" value="Mon. Cuota" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td> 					
							<td class="label" nowrap="nowrap"><input type="text" value="Saldos" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td>
										     		
				     		<td class="label" nowrap="nowrap"><input type="text" value="Cap. Vigente" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td>			     		
				     		<td class="label" nowrap="nowrap"><input type="text" value="Cap. Atrasado" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td>
				     		<td class="label" nowrap="nowrap"><input type="text" value="Int.Provisi&oacute;n" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td>
				     		<td class="label" nowrap="nowrap"><input type="text" value="Int.Atrasado" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td>			     		
				     		<td class="label" nowrap="nowrap"><input type="text" value="IVA Inter&eacute;s" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td> 
				     		
				     		<td class="label" nowrap="nowrap"><input type="text" value="Moratorio" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td>
				     		<td class="label" nowrap="nowrap"><input type="text" value="IVA Mora" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td> 
				     		<td class="label" nowrap="nowrap"><input type="text" value="Comisiones" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td>			     		
				     		<td class="label" nowrap="nowrap"><input type="text" value="IVA" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td> 
				     		<td class="label" nowrap="nowrap"><input type="text" value="Otras Com" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td>
				     					     		
				     		<td class="label" nowrap="nowrap"><input type="text" value="IVA" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td>
				     		<td class="label" nowrap="nowrap"><input type="text" value="Retenci&oacute;n" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td> 
				     		<td class="label" nowrap="nowrap"><input type="text" value="Tot. Cuota" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="15"/></td>			     		     		
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td style="vertical-align:top">
					<table id="renglonesAmor" border="0" cellpadding="0" cellspacing="0" width="100%" >
					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td> 
								<input type="text" id="amortizacionID${status.count}"  name="amortizacionID" size="4"  
										value="${amortizacion.amortizacionID}" readonly="true" disabled="true"/> 
							</td>  
							<td> 
								<input type="text" id="fechaInicio${status.count}"  name="fechaInicio" size="12"  
										value="${amortizacion.fechaInicio}" readonly="true" disabled="true"/> 
						  	</td> 
						  	<td> 
								<input type="text" id="fechaVencim${status.count}" name="fechaVencim" size="12" 
										value="${amortizacion.fechaVencim}" readonly="true" disabled="true"/> 
						  	</td> 
						  	<td> 
								<input type="text" id="fechaExigible${status.count}" name="fechaExigible" size="12" 
										value="${amortizacion.fechaExigible}" readonly="true" disabled="true"/> 
						  	</td>
						  	<td> 
						  		<input type="text" id="estatus${status.count}" name="estatus" size="12" value="${amortizacion.estatus}" readonly="true" disabled="true"/>
						  	</td>
						  		
						  	<td>   
				         		<input type="text" style="text-align:right" id="capital${status.count}" name="capital" size="12" align="right"
				         			value="${amortizacion.capital}" readonly="true" disabled="true" esMoneda="true"/> 
				     		</td> 
				     		<td> 
				         		<input type="text" style="text-align:right" id="interes${status.count}" name="interes" size="12"
				         			value="${amortizacion.interes}" readonly="true" disabled="true" esMoneda="true"/> 
				     		</td> 
							<td> 
				         		<input type="text" style="text-align:right" id="ivaInteres${status.count}" name="ivaInteres" size="12" align="right"
				         			value="${amortizacion.ivaInteres}" readonly="true" disabled="true" esMoneda="true"/> 
				     		</td> 
							<td> 
				         		<input type="text" style="text-align:right" id="retencion${status.count}" name="retencion" size="12" align="right"
				         			value="${amortizacion.retencion}" readonly="true" disabled="true" esMoneda="true"/> 
				     		</td>
							<td> 
				         		<input type="text" style="text-align:right" id="montoCuota${status.count}" name="montoCuota" size="12" align="right"
				         			value="${amortizacion.montoCuota}" readonly="true" disabled="true" esMoneda="true"/> 
				     		</td>						
							<td  nowrap="nowrap"><input type="text" value="" readonly="true" disabled="true" style="border: none;background-color: transparent;resize:none;text-align: center;" size="12"/></td> 				     		
							
							<td> 
								<input type="text" style="text-align:right;" id="saldoCapVigente${status.count}" name="saldoCapVigente" size="12" align="right"
									value="${amortizacion.saldoCapVigente}" readonly="true" disabled="true" esMoneda="true"/> 
							</td>
							<td> 
								<input type="text" style="text-align:right" id="saldoCapAtrasado${status.count}" name="saldoCapAtrasado" size="12" align="right"
									value="${amortizacion.saldoCapAtrasa}" readonly="true" disabled="true" esMoneda="true"/> 
							</td> 
							<td> 
								<input type="text" style="text-align:right" id="saldoIntProvisionado${status.count}" name="saldoIntProvisionado" size="12" align="right"
									value="${amortizacion.saldoInteresPro}" readonly="true" disabled="true" esMoneda="true"/> 
							</td> 
							<td>
								<input type="text" style="text-align:right" id="saldoIntAtrasado${status.count}" name="saldoIntAtrasado" size="12" align="right"
									value="${amortizacion.saldoInteresAtra}" readonly="true" disabled="true" esMoneda="true"/> 
							</td> 
							<td> 
								<input type="text" style="text-align:right" id="saldoIVAInteres${status.count}" name="saldoIVAInteres" size="12" align="right"
									value="${amortizacion.saldoIVAInteres}" readonly="true" disabled="true" esMoneda="true"/> 
							</td>
							
							<td> 
								<input type="text" style="text-align:right" id="saldoMoratorios${status.count}" name="saldoMoratorios" size="12" align="right"
									value="${amortizacion.saldoMoratorios}" readonly="true" disabled="true" esMoneda="true"/> 
							</td> 
							<td>
								<input  type="text" style="text-align:right" id="saldoIVAMora${status.count}" name="saldoIVAMora" size="12" align="right"
									value="${amortizacion.saldoIVAMora}" readonly="true" disabled="true" esMoneda="true"/> 
							</td>
							<td>
								<input type="text" style="text-align:right" id="saldoComFaltaPago${status.count}" name="saldoComFaltaPago" size="12" align="right"
									value="${amortizacion.saldoComFaltaPago}" readonly="true" disabled="true" esMoneda="true"/> 
							</td>
							<td> 
								<input type="text" style="text-align:right" id="saldoIVAComFaltaPago${status.count}" name="saldoIVAComFaltaPago" size="12" align="right"
									value="${amortizacion.saldoIVAComFalP}" readonly="true" disabled="true" esMoneda="true"/> 
							</td> 
							<td> 
								<input type="text" style="text-align:right" id="saldoOtrasComisiones${status.count}" name="saldoOtrasComisiones" size="12" align="right"
									value="${amortizacion.saldoOtrasComis}" readonly="true" disabled="true" esMoneda="true"/> 
							</td> 	
							<td>
								<input type="text" style="text-align:right" id="saldoIVAOtrasCom${status.count}" name="saldoIVAOtrasCom" size="12" align="right"
									value="${amortizacion.saldoIVAOtrCom}" readonly="true" disabled="true" esMoneda="true"/> 
							</td>
							<td>
								<input type="text" style="text-align:right" id="saldoRetencion${status.count}" name="saldoRetencion" size="12" align="right"
									value="${amortizacion.saldoRetencion}" readonly="true" disabled="true" esMoneda="true"/> 
							</td>
							<td> 
								<input type="text" style="text-align:right" id="totalPago${status.count}" name="totalPago" size="12" align="right"
									value="${amortizacion.totalCuota}" readonly="true" disabled="true" esMoneda="true"/> 
							</td>			     		
						</tr>
					</c:forEach>
					</table>
				</td>
			</tr>
		</table>
		</fieldset>
	</c:when>
	
	
	<c:when test="${tipoLista == '2'}">
    	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Amortizaciones</legend>	
			<table  border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label"><label for="lblNumero">N&uacute;m.</label></td>
						<td class="label"><label for="lblfechaIn">Fecha Inicio</label></td>
						<td class="label"> 
							<label for="lblfechaVen">Fecha Vencimiento</label> 
					  	</td>	
						<td class="label"> 
							<label for="lblestatus">Estatus</label> 
					  	</td>
					  	<td class="label"> 
				         	<label for="lblcapital">Capital</label> 
				     	</td> 
				     	<td class="label"> 
				         	<label for="lblinteres">Inter&eacute;s</label> 
				     	</td> 
				     	<td class="label"> 
				         	<label for="lblmoratorio">Moratorio</label> 
				     	</td> 
				     	<td class="label"> 
				        	<label for="lblcomfaltpago">Com. Falta Pago</label> 
				     	</td> 
				     	<td class="label"> 
				        	<label for="lblotrascomis">Otras Comisiones</label> 
				     	</td> 
					</tr>
					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td> 
							<input  type="text" id="amortizacionID${status.count}"  name="amortizacionID" size="6"   
										value="${amortizacion.amortizacionID}" readonly="true" disabled="true"/> 
					  	</td> 
						<td> 
							<input type="text"  id="fechaInicio${status.count}"  name="fechaInicio" size="9"  
									value="${amortizacion.fechaInicio}" readonly="true" disabled="true"/> 
					  	</td> 
					  	<td> 
							<input type="text"  id="fechaVencim${status.count}" name="fechaVencim" size="9" 
									value="${amortizacion.fechaVencim}" readonly="true" disabled="true"/> 
					  	</td> 
					  	<td> 
							<input type="text"  id="estatus${status.count}" name="estatus" size="13" 
									value="${amortizacion.estatus}" readonly="true" disabled="true"/> 
					  	</td> 
					  	<td> 
							<input type="text"  id="capital${status.count}" name="capital" size="12" 
									value="${amortizacion.capital}" readonly="true" onchange="validaCapital(this.id);" "esMoneda="true" disabled="true" style="text-align: right"/> 
					  	</td> 
			     		<td> 
			        	 	<input type="text"  id="interes${status.count}" name="interes" size="12"
			         			value="${amortizacion.interes}" readonly="true" onchange="validaInteres(this.id);" esMoneda="true" disabled="true" style="text-align: right"/> 
			     		</td> 
						<td> 
			         		<input type="text"  id="saldoMoratorios${status.count}" name="saldoMoratorios" size="12" align="right"
			         			value="${amortizacion.saldoMoratorios}" readonly="true" onchange="validaSaldoMora(this.id);" esMoneda="true" disabled="true" esMoneda="true" style="text-align: right"/> 
			     		</td> 
			     		<td> 
			         		<input type="text"  id="saldoComFaltaPago${status.count}" name="saldoComFaltaPago" size="12" align="right"
				         			value="${amortizacion.saldoComFaltaPago}" readonly="true"  onchange="validaSaldoComFaltPag(this.id);" esMoneda="true" disabled="true" esMoneda="true" style="text-align: right"/> 
				     	</td> 
				     	<td> 
				        	<input type="text"  id="saldoOtrasComisiones${status.count}" name="saldoOtrasComisiones" size="12" align="right"
				        			value="${amortizacion.saldoOtrasComisiones}" readonly="true" onchange="validaSaldoOtrasCom(this.id);" esMoneda="true" disabled="true" esMoneda="true" style="text-align: right"/> 
				     	</td> 
				     	<td> 
				        	<input type="hidden" id="campoModificado${status.count}" value="N" name="campoModificado" size="5" /> 
				     		<input type="hidden" id="estatusAmortiza${status.count}" value="${amortizacion.estatusAmortiza}" name="estatusAmortiza" size="5" />
				     		<input type="hidden" id="altaEncPoliza${status.count}" name="altaEncPoliza" value="N" size="5"/>
				 		</td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		</fieldset>
	</c:when>
</c:choose>

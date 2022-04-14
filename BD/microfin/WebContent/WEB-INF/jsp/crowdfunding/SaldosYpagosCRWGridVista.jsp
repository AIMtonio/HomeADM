<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="listaResultado"  value="${listaResultado[0]}"/>
<fieldset class="ui-widget ui-widget-content ui-corner-all">             
	<legend>Saldos y Pagos</legend>	
		<form id="gridDetalleSaldos" name="gridDetalleSaldos">
			
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
			<c:forEach items="${listaResultado}" var="saldos" varStatus="status">
		
				<tr>
					<td> <label for="lblDias">D&iacute;as Atraso</label></td>
					<td>   
						<input style="text-align:right" id="diasAtraso" name="diasAtraso" size="15" 
						value="${saldos.diasAtraso}" readOnly="true" disabled="true"/> 
			 		</td> 
				</tr> 

				<tr> 
			     	<td class="label"> 
					  	<label for="lblSaldos"><b>Saldos</b></label> 
					</td>
					<td></td>
					<td class="label"> 
			        	<label for="lblPagRecib"><b>Pagos Recibidos</b></label> 
			     	</td> 
					<td></td>   
			     	<td class="label"> 
			        	<label for="lblRetencion"><b>Retenciones (ISR)</b></label> 
			     	</td> 
				</tr> 			
			
			<tr id="renglon${status.count}" name="renglon">	
				<td> <label for="lblDias">Cap. Vigente</label> </td>
					<td>
					<input style="text-align:right" id="saldoCapVigente${status.count}" name="saldoCapVigente" size="15" 
					value="${saldos.saldoCapVigente}" readOnly="true" disabled="true" esMoneda="true"/> 
				</td> 
			 	<td>  <label for="lblDias">Capital</label> </td>
					<td>
					<input style="text-align:right" id="capitalRecibido"  name="capitalRecibido" size="15"  
					value="${saldos.capitalRecibido}" readOnly="true" disabled="true" esMoneda="true" /> 
				</td> 
				
				</tr>
				<tr>
					<td>  <label for="lblDias">Cap.Exigible</label> </td>
					<td>
						<input style="text-align:right" id="saldoCapExigible${status.count}" name="saldoCapExigible" size="15" 
						value="${saldos.saldoCapExigible}" readOnly="true" disabled="true" esMoneda="true"/> 
					</td> 
				 	<td>   <label for="lblDias">Inter&eacute;s</label> </td>
					<td>
						<input style="text-align:right" input id="interesRecibido${status.count}" name="interesRecibido" size="15"  
						value="${saldos.interesRecibido}" readOnly="true" disabled="true" esMoneda="true"/> 
					</td> 
					<td>  <label for="lblDias">Inter&eacute;s</label> </td>
					<td>  
					   <input style="text-align:right" input id="intOrdRetenido${status.count}" name="intOrdRetenido" size="15" align="right"
					    value="${saldos.intOrdRetenido}" readOnly="true" disabled="true" esMoneda="true"/> 
					</td>  
				</tr>
				
				<tr>
					<td>  <label for="lblDias">Cap. Cta. Orden</label> </td>
					<td>
						<input style="text-align:right" id="capCtaOrden${status.count}" name="capCtaOrden" size="15" 
						value="${saldos.capCtaOrden}" readOnly="true" disabled="true" esMoneda="true"/> 
					</td> 
					
				 	<td>   <label for="lblDias">Moratorios</label> </td>
					<td>
						<input style="text-align:right" id="moraRecibido${status.count}" name="moraRecibido" size="15"  
						value="${saldos.moraRecibido}" readOnly="true" disabled="true" esMoneda="true"/> 
					</td>  
					<td>    <label for="lblDias">Moratorios</label> </td>
					<td>
					   <input style="text-align:right" id="intMorRetenido${status.count}" name="intMorRetenido" size="15" align="right"
					    value="${saldos.intMorRetenido}" readOnly="true" disabled="true" esMoneda="true"/> 
					</td> 
					
				</tr>
				<tr>
					<td>  <label for="lblDias">Inter&eacute;s</label> </td>
					<td>
						<input style="text-align:right" id="saldoInteres${status.count}" name="saldoInteres" size="15" 
						value="${saldos.saldoInteres}" readOnly="true" disabled="true" esMoneda="true"/> 
					</td>  
				
				 	<td>   <label for="lblDias">Comisiones</label> </td>
					<td>
						<input style="text-align:right" id="comisionRecibido${status.count}" name="comisionRecibido" size="15"  
						value="${saldos.comisionRecibido}" readOnly="true" disabled="true" esMoneda="true"/> 
					</td> 
					<td>    <label for="lblDias">Comisiones</label> </td>
					<td>
					   <input style="text-align:right" id="comFalPagRetenido${status.count}" name="comFalPagRetenido" size="15" align="right"
					    value="${saldos.comFalPagRetenido}" readOnly="true" disabled="true" esMoneda="true"/> 
					</td> 
					
				</tr>
				<tr>
					<td>   <label for="lblDias">Inter&eacute;s Moratorio</label> </td>
					<td>
						<input style="text-align:right" id="saldoIntMora${status.count}" name="saldoIntMora" size="15"  
						value="${saldos.saldoInteresMoratorio}" readOnly="true" disabled="disabled" esMoneda="true"/> 
					</td> 										
				</tr>
				<tr>
								
					<td>   <label for="lblIntCtaOrden">Inter&eacute;s Cta. Orden</label> </td>
					<td>
						<input style="text-align:right" id="${status.count}" name="intCtaOrden" size="15"  
						value="${saldos.intCtaOrden}" readOnly="true" disabled="disabled" esMoneda="true"/> 
					</td> 							
				</tr>
				
						 <c:set var="totalSaldo" value="${saldos.totalSaldo}"/> 
						 <c:set var="totalPagRec" value="${saldos.totalrecibido}"/> 
						 <c:set var="totalPagRet" value="${saldos.totalRetenido}"/> 
 
					</c:forEach> 
							<td><label for="lblTotal">Total Saldo </label></td>
							<td> 
				         	<input style="text-align:right" id="totalSaldo" name="totalSaldo" size="15" align="right"
				         	 		value="${totalSaldo}" readOnly="true" disabled="true" esMoneda="true"/> 		
				  			 </td> 
							<td><label for="lblTotal">Total Recibido </label></td> 					
							<td> 
				         	<input style="text-align:right" id="totalPagRec" name="totalPagRec" size="15" align="right"
				         	 		value="${totalPagRec}" readOnly="true" disabled="true" esMoneda="true"/> 		
				  			</td> 
							<td><label for="lblTotal">Total Retenido </label></td> 
				  			<td><input style="text-align:right" id="totalPagRet" name="totalPagRet" size="15" align="right"
				         	 		value="${totalPagRet}" readOnly="true" disabled="true" esMoneda="true"/> 		
				  			</td>
  

				</tbody>
				 
			</table>
	 
</form>

</fieldset> 
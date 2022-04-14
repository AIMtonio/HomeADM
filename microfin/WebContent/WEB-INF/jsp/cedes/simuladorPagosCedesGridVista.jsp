<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<form id="gridDetalle" name="gridDetalle">
	<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="90%"> 
		<c:choose> 
				<c:when test="${tipoLista == '2'}">
			 		<tr>
					<td class="label" ><label for="lblNumero">No.</label></td>					
					<td class="label" ><label for="lblFechaPago">Fecha C&aacute;lculo</label></td>
					<td class="label" ><label for="lblFechaPagoBien">Fecha Pago</label></td> 
					<td class="label" ><label for="lblCapital">Capital</label></td>	
					<td class="label"><label for="lblInteres">Inter&eacute;s</label></td>
			  		<td class="label" ><label for="lblIsr">ISR</label></td> 
		     		<td class="label" ><label for="lblTotal">Total a Recibir</label></td>   	
					</tr>
									
				 <c:forEach items="${listaResultado}" var="pagoCede" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td> 
						<input type="text" id="consecutivoID${status.count}" value="${pagoCede.consecutivo}" size="5" readonly="readonly" disabled="disabled"/>	
					  	</td>
						<td> 
							<input type="text" id="fecha${status.count}"  name="fecha" size="12" value="${pagoCede.fecha}" readonly="readonly" disabled="disabled"/> 
					  	</td> 
					   <td> 
							<input type="text" id="fechaPago${status.count}"  name="fechaPago" size="12" value="${pagoCede.fechaPago}" readonly="readonly" disabled="disabled"/> 
					  	</td>  
					  	<td> 
							<input type="text" style="text-align:right" id="capital${status.count}" name="capital" size="20" 
									value="${pagoCede.capital}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
					  	</td> 
					  	<td> 
							<input type="text" style="text-align:right"  id="interes${status.count}" name="interes" size="20" 
									value="${pagoCede.interes}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
					  	</td>
						<td>   
				         	<input type="text" style="text-align:right" id="isr${status.count}" name="isr" size="20" align="right"
				         			value="${pagoCede.isr}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
				     	</td> 
					  	<td> 
							<input type="text"  style="text-align:right" id="total${status.count}" name="total" size="20" 
									value="${pagoCede.total}" readonly="readonly" disabled="disabled" esMoneda="true"/> 
					  	</td>
					  	
						<c:set var="varTotalCapital" value="${pagoCede.totalCapital}"/>
						<c:set var="varTotalInteres" value="${pagoCede.totalInteres}"/>
						<c:set var="varTotalISR" value="${pagoCede.totalISR}"/>
						<c:set var="varTotalFinal" value="${pagoCede.totalFinal}"/>						
					</tr>
						 <c:set var="cont" value="${status.count}"/>
				</c:forEach>
					<tr id="renglonTotales">
					  	<td width="1%"> 
					  	</td>
					  	<td width="1%"> 
					  	</td>
						<td width="1%" > 
							<b><label >TOTALES</label></b>
					  	</td> 
					  	<td width="1%" style="text-align:right"> 
							<b><label id="varTotalCapital">${varTotalCapital}</label></b> 
					  	</td> 
					  	<td width="1%" style="text-align:right">
							<b><label id="varTotalInteres">${varTotalInteres}</label></b>
					  	</td>
						<td width="1%" style="text-align:right">
				         	<b><label id="varTotalISR">${varTotalISR}</label></b>
				     	</td> 
					  	<td width="1%" style="text-align:right">
							<b><label id="varTotalFinal">${varTotalFinal}</label></b> 
					  	</td>					
					  	<td style="text-align:right"></td>
					</tr>
				</c:when>
			</c:choose>			 		
	</table> 
</form>



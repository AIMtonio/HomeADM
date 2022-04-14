<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<html>
<head>
</head>

<body>
	<c:set var="tipoLista"  value="${listaResultado[0]}"/>
	<c:set var="listaResultado" value="${listaResultado[1]}"/>
	
	<table id="miTabla" border="0" >
		<c:choose>
			<c:when test="${tipoLista == '1'}">
				<tbody>	
						<tr align="center">
							<td class="label"> 
						   		<label>No. <s:message code="safilocale.cliente"/></label> 
							</td>
							<td class="label" > 
						   		<label>Nombre <s:message code="safilocale.cliente"/></label> 
							</td>
							<td class="label"> 
						   		<label>Sucursal <s:message code="safilocale.cliente"/></label> 
							</td>
							<td class="label"> 
								<label>Localidad</label> 
					  		</td>
							<td class="label"> 
								<label>No. Crédito</label> 
					  		</td>
							<td class="label"> 
								<label>Producto</br>Crédito</label> 
					  		</td>
							<td class="label"> 
								<label>Saldo Total</br>Capital</label> 
					  		</td>	
							<td class="label"> 
								<label>Días de</br>Atraso</label> 
					  		</td>	
							<td class="label"> 
								<label>Estatus</br>Crédito</label> 
					  		</td>	
							<td class="label"> 
								<label>Frecuencia<br>Pago Capital</label> 
					  		</td>	
							<td class="label"> 
								<label>Fecha</br>Cita</label> 
					  		</td>	
							<td class="label" > 
								<label>Hora</br>Cita</label> 
					  		</td>	
							<td class="label"> 
								<label>Etiqueta</br>Etapa</label> 
					  		</td>		
							<td class="label"> 
								<label>Formato</br>Notificación</label> 
					  		</td>	
							<td class="label"> 
								<label></label> 
					  		</td>		  			
						</tr>
						<tr>
							<td colspan="14" style="text-align:right;">	
								<label>Seleccionar Todos</label> 										 														  				
							</td>
							<td align="center">	
								<input type="checkbox" id="selecTodos" name="selecTodos" value="N" onclick="seleccionaTodos(this.id)"/> 	
							</td>
						</tr>
						
						
						<c:forEach items="${listaResultado}" var="creditosLis" varStatus="status">	
							<tr id="renglons${status.count}" name="renglons">
								<td>
									<input type="hidden" id="consecutivo${status.count}" name="consecutivo" value="${status.count}" />
									
									<input type="text" id="clienteID${status.count}" name="clienteID" size="8"  value="${creditosLis.clienteID}" readOnly="true" disabled="true" />   								
							  	</td> 					 
							  	<td> 
									<input  type="text" id="nombreCompleto${status.count}" name="nombreCompleto" size="33" value="${creditosLis.nombreCompleto}" readOnly="true" disabled="true"  /> 							 							
							  	</td>				 
							  	<td> 
									<input type="hidden" id="sucursalID${status.count}" name="sucursalID"  value="${creditosLis.sucursalID}" />
									<input type="text" id="nombreSucursal${status.count}" name="nombreSucursal" size="25" value="${creditosLis.nombreSucursal}" readOnly="true" disabled="true" /> 							 							
							  	</td>			 
							  	<td> 
									<input type="text" id="nombreLocalidad${status.count}" name="nombreLocalidad" size="20" value="${creditosLis.nombreLocalidad}" readOnly="true" disabled="true"  /> 							 							
							  	</td>						 
							  	<td align="center">
									<input type="hidden" id="solicitudCreditoID${status.count}" name="lisSoliCredito"  value="${creditosLis.solicitudCreditoID}" />
							  		<input type="text" id="creditoID${status.count}" name="lisCreditoID" size="12" value="${creditosLis.creditoID}" readOnly="true"/> 							 							
							  	</td>				 
							  	<td> 
									<input  type="text" id="productoCred${status.count}" name="productoCred" size="17" value="${creditosLis.productoCred}" readOnly="true" disabled="true"  /> 							 							
							  	</td>					 
							  	<td> 
									<input  type="text" id="saldoTotalCap${status.count}" name="saldoTotalCap" size="12" value="${creditosLis.saldoTotalCap}" esMoneda="true" readOnly="true" disabled="true" style="text-align:right;"  /> 							 							
							  	</td>					 
							  	<td> 
									<input  type="text" id="diasAtraso${status.count}" name="diasAtraso" size="5" value="${creditosLis.diasAtraso}" readOnly="true" disabled="true" style="text-align:right;"  /> 							 							
							  	</td>			 
							  	<td> 
									<input  type="text" id="estatusCredito${status.count}" name="estatusCredito" size="9" value="${creditosLis.estatusCredito}" readOnly="true" disabled="true"  /> 							 							
							  	</td>					 
							  	<td> 
									<input  type="text" id="frecuenPagoCap${status.count}" name="frecuenPagoCap" size="12" value="${creditosLis.frecuenPagoCap}" readOnly="true" disabled="true" /> 							 							
							  	</td>					 
							  	<td nowrap="nowrap"> 
									<input  type="text" id="fechaCita${status.count}" name="lisFechaCita" size="11" value="${creditosLis.fechaCita}" tabindex="${status.count+10}" maxlength = "10" autocomplete="off" esCalendario="true" onChange="validaFecha(this.id)"/> 							 							
							  	</td>					 
							  	<td> 
									<input  type="text" id="horaCita${status.count}" name="lisHoraCita" size="6" value="${creditosLis.horaCita}" tabindex="${status.count+10}" maxlength = "5" autocomplete="off"/> 							 							
							  	</td>					 
							  	<td> 
									<input  type="text" id="etiquetaEtapa${status.count}" name="lisEtiquetaEtapa" size="10" value="${creditosLis.etiquetaEtapa}" readOnly="true" /> 							 							
							  	</td>						 
							  	<td> 
									<input type="hidden" id="formatoID${status.count}" name="lisFormatoID" value="${creditosLis.formatoID}" />
									<input  type="text" id="nombreFormato${status.count}" name="nombreFormato" size="20" value="${creditosLis.nombreFormato}" readOnly="true" disabled="true"/> 							 							
							  	</td>				
							  	<td align="center">			
									<input type="hidden" id="emitirNotiCob${status.count}" name="lisEmitirCheck" value="${creditosLis.emitirCheck}" />
									<input type="checkbox" id="emitirCheck${status.count}" name="emitirCheck" value="${creditosLis.emitirCheck}" onclick="realiza(this.id)" tabindex="${status.count+10}"/>
							  	</td> 					
							</tr>					
						</c:forEach>
					</tbody>
			</c:when>
		</c:choose>
	</table>
	
	
</body>
</html>
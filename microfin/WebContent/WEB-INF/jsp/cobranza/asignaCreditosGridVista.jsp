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
	<br/>
	<c:set var="tipoLista"  value="${listaResultado[0]}"/>
	<c:set var="listaResultado" value="${listaResultado[1]}"/>
	
	<table id="miTabla" border="0" >
		<c:choose>
			<c:when test="${tipoLista == '1' || tipoLista == '2'}">
				<tbody>	
						<tr align="center">
							<td class="label"> 
						   		<label for=""><s:message code="safilocale.cliente"/></label> 
							</td>
							<td class="label" > 
						   		<label for="">Nombre Completo</label> 
							</td>
							<td class="label"> 
						   		<label for="">Sucursal <s:message code="safilocale.cliente"/></label> 
							</td>
							<td class="label"> 
								<label for="">Crédito</label> 
					  		</td>
							<td class="label"> 
								<label for="">Crédito</br>Estatus</label> 
					  		</td>	
							<td class="label"> 
								<label for="">Días</br>Atraso</label> 
					  		</td>	
							<td class="label"> 
								<label for="">Monto Otorgado</label> 
					  		</td>	
							<td class="label" align="center"> 
								<label for="">Fecha</br>Desembolso</label> 
					  		</td>	
							<td class="label" align="center"> 
								<label for="">Fecha</br>Vencimiento</label> 
					  		</td>	
							<td class="label" align="center" > 
								<label for="">Fecha Prox.</br>Vencimiento</label> 
					  		</td>	
							<td class="label"> 
								<label for="">Saldo</br>Capital</label> 
					  		</td>	
							<td class="label"> 
								<label for="">Saldo</br>Interés</label> 
					  		</td>	
							<td class="label"> 
								<label for="">Saldo</br>Moratorios</label> 
					  		</td>	
							<td class="label"> 
								<label for="">Asignar</label> 
					  		</td>		  			
						</tr>
						<tr>
							<td colspan="13" style="text-align:right;">	
								<label>Seleccionar Todos</label> 										 														  				
							</td>
							<td align="center">	
								<input type="checkbox" id="selecTodos" name="selecTodos" value="N" onclick="seleccionaTodos(this.id)"/> 	
							</td>
						</tr>
						
						<c:forEach items="${listaResultado}" var="creditosLis" varStatus="estado">	
							<tr id="renglons${estado.count}" name="renglons">
								<td>
									<input type="hidden" id="consecutivo${estado.count}" name="consecutivo" size="6" value="${estado.count}" />
									
									<input type="text" id="clienteID${estado.count}" name="clienteID" size="8"  value="${creditosLis.clienteID}" readOnly="true" disabled="true"/>   								
							  	</td> 					 
							  	<td> 
									<input  type="text" id="nombreCompleto${estado.count}" name="nombreCompleto" size="35" value="${creditosLis.nombreCompleto}" readOnly="true" disabled="true"  /> 							 							
							  	</td>				 
							  	<td> 
									<input type="hidden" id="sucursalGridID${estado.count}" name="sucursalGridID" size="6" value="${creditosLis.sucursalID}" />
									<input  type="text" id="nombreSucursal${estado.count}" name="nombreSucursal" size="25" value="${creditosLis.nombreSucursal}" readOnly="true" disabled="true"  /> 							 							
							  	</td>					 
							  	<td>
							  		<input type="text" id="creditoID${estado.count}" name="creditoID" size="12" value="${creditosLis.creditoID}" readOnly="true" disabled="true"/> 							 							
							  	</td>				 
							  	<td> 
									<input  type="text" id="estatusCred${estado.count}" name="estatusCred" size="10" value="${creditosLis.estatusCred}" readOnly="true" disabled="true"  /> 							 							
							  	</td>					 
							  	<td> 
									<input  type="text" id="diasAtraso${estado.count}" name="diasAtraso" size="5" value="${creditosLis.diasAtraso}" readOnly="true" disabled="true" style="text-align:right;"  /> 							 							
							  	</td>					 
							  	<td> 
									<input  type="text" id="montoCredito${estado.count}" name="montoCredito" size="12" value="${creditosLis.montoCredito}" esMoneda="true" readOnly="true" disabled="true" style="text-align:right;"  /> 							 							
							  	</td>					 
							  	<td> 
									<input  type="text" id="fechaDesembolso${estado.count}" name="fechaDesembolso" size="10" value="${creditosLis.fechaDesembolso}" readOnly="true" disabled="true" style="text-align:center;"  /> 							 							
							  	</td>					 
							  	<td> 
									<input  type="text" id="fechaVencimien${estado.count}" name="fechaVencimien" size="10" value="${creditosLis.fechaVencimien}" readOnly="true" disabled="true" style="text-align:center;" /> 							 							
							  	</td>					 
							  	<td> 
									<input  type="text" id="fechaProxVencim${estado.count}" name="fechaProxVencim" size="10" value="${creditosLis.fechaProxVencim}" readOnly="true" disabled="true"  style="text-align:center;"/> 							 							
							  	</td>					 
							  	<td> 
									<input  type="text" id="saldoCapital${estado.count}" name="saldoCapital" size="12" value="${creditosLis.saldoCapital}" esMoneda="true" readOnly="true" disabled="true" style="text-align:right;"  /> 							 							
							  	</td>						 
							  	<td> 
									<input  type="text" id="saldoInteres${estado.count}" name="saldoInteres" size="12" value="${creditosLis.saldoInteres}" esMoneda="true" readOnly="true" disabled="true" style="text-align:right;"  /> 							 							
							  	</td>						 
							  	<td> 
									<input  type="text" id="saldoMoratorio${estado.count}" name="saldoMoratorio" size="10" value="${creditosLis.saldoMoratorio}" esMoneda="true" readOnly="true" disabled="true" style="text-align:right;" /> 							 							
							  	</td>				
							  	<td align="center">			
									<input type="hidden" id="esAsignado${estado.count}" name="esAsignado" size="8" value="${creditosLis.asignado}"  />  
									<input type="checkbox"id="esAsignadocheck${estado.count}" name="esAsignadocheck" value="${creditosLis.asignado}" onclick="realiza(this.id)"/>		    													 							
							  	</td> 					
							</tr>					
						</c:forEach>
					</tbody>
			</c:when>
		</c:choose>
	</table>
	
	
</body>
</html>
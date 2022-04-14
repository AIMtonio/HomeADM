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
			<c:when test="${tipoLista == '1'}">
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
								<label for="">Estatus</br>Asignación</label> 
					  		</td>	
							<td class="label"> 
								<label for="">Días Atraso</br>Asignación</label> 
					  		</td>	
							<td class="label"> 
								<label for="">Monto</br>Otorgado</label> 
					  		</td>	
							<td class="label" align="center"> 
								<label for="">Fecha</br>Desembolso</label> 
					  		</td>	
							<td class="label" align="center"> 
								<label for="">Fecha</br>Vencimiento</label> 
					  		</td>	
							<td class="label"> 
								<label for="">Saldo Capital</br>Asignación</label> 
					  		</td>	
							<td class="label"> 
								<label for="">Saldo Interés</br>Asignación</label> 
					  		</td>	
							<td class="label"> 
								<label for="">Saldo</br> Moratorios</br>Asignación</label> 
					  		</td>	
							<td class="label"> 
								<label for="">Estatus</label> 
					  		</td>	
							<td class="label"> 
								<label for="">Días</br>Atraso</label> 
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
								<label for="">Motivo Liberación</label> 
					  		</td>
							<td class="label"> 
								<label for="">Liberar</label> 
					  		</td>		  			
						</tr>
						<tr>
							<td colspan="18" style="text-align:right;">	
								<label f>Seleccionar Todos</label> 										 														  				
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
									<input  type="text" id="nombreCompleto${estado.count}" name="nombreCompleto" size="25" value="${creditosLis.nombreCompleto}" readOnly="true" disabled="true"  /> 							 							
							  	</td>				 
							  	<td> 
									<input  type="text" id="nombreSucursal${estado.count}" name="nombreSucursal" size="20" value="${creditosLis.nombreSucursal}" readOnly="true" disabled="true"  /> 							 							
							  	</td>					 
							  	<td> 
									<input  type="text" id="creditoID${estado.count}" name="creditoID" size="12" value="${creditosLis.creditoID}" readOnly="true" disabled="true"  /> 							 							
							  	</td>				 
							  	<td> 
									<input  type="text" id="estatusCred${estado.count}" name="estatusCred" size="10" value="${creditosLis.estatusCred}" readOnly="true" disabled="true"  /> 							 							
							  	</td>						 
							  	<td> 
									<input  type="text" id="diasAtraso${estado.count}" name="diasAtraso" size="8" value="${creditosLis.diasAtraso}" readOnly="true" disabled="true" style="text-align:right;"  /> 							 							
							  	</td>					 
							  	<td> 
									<input  type="text" id="montoCredito${estado.count}" name="montoCredito" size="10" value="${creditosLis.montoCredito}" readOnly="true" disabled="true" style="text-align:right;"  /> 							 							
							  	</td>					 
							  	<td> 
									<input  type="text" id="fechaDesembolso${estado.count}" name="fechaDesembolso" size="10" value="${creditosLis.fechaDesembolso}" readOnly="true" disabled="true" style="text-align:center;"  /> 							 							
							  	</td>					 
							  	<td> 
									<input  type="text" id="fechaVencimien${estado.count}" name="fechaVencimien" size="10" value="${creditosLis.fechaVencimien}" readOnly="true" disabled="true" style="text-align:center;" /> 							 							
							  	</td>					 
							  	<td> 
									<input  type="text" id="saldoCapital${estado.count}" name="saldoCapital" size="11" value="${creditosLis.saldoCapital}" readOnly="true" disabled="true" style="text-align:right;"  /> 							 							
							  	</td>						 
							  	<td> 
									<input  type="text" id="saldoInteres${estado.count}" name="saldoInteres" size="10" value="${creditosLis.saldoInteres}" readOnly="true" disabled="true" style="text-align:right;"  /> 							 							
							  	</td>						 
							  	<td> 
									<input  type="text" id="saldoMoratorio${estado.count}" name="saldoMoratorio" size="10" value="${creditosLis.saldoMoratorio}" readOnly="true" disabled="true" style="text-align:right;" /> 							 							
							  	</td>						 
							  	<td> 
									<input  type="text" id="estatusCredLib${estado.count}" name="estatusCredLib" size="10" value="${creditosLis.estatusCredLib}" readOnly="true" disabled="true"  /> 							 							
							  	</td>						 
							  	<td> 
									<input  type="text" id="diasAtrasoLib${estado.count}" name="diasAtrasoLib" size="5" value="${creditosLis.diasAtrasoLib}" readOnly="true" disabled="true" style="text-align:right;"  /> 							 							
							  	</td>					 
							  	<td> 
									<input  type="text" id="saldoCapitalLib${estado.count}" name="saldoCapitalLib" size="10" value="${creditosLis.saldoCapitalLib}" readOnly="true" disabled="true" style="text-align:right;"  /> 							 							
							  	</td>						 
							  	<td> 
									<input  type="text" id="saldoInteresLib${estado.count}" name="saldoInteresLib" size="10" value="${creditosLis.saldoInteresLib}" readOnly="true" disabled="true" style="text-align:right;"  /> 							 							
							  	</td>					 
							  	<td> 
									<input  type="text" id="saldoMoratorioLib${estado.count}" name="saldoMoratorioLib" size="10" value="${creditosLis.saldoMoratorioLib}" readOnly="true" disabled="true" style="text-align:right;" /> 							 							
							  	</td>						 
							  	<td> 
									<input  type="text" id="motivoLiberacion${estado.count}" name="motivoLiberacion" size="25" value="${creditosLis.motivoLiberacion}"  maxlength = "100" onBlur=" ponerMayusculas(this)" autocomplete="off"/> 							 							
							  	</td>		
							  	<td align="center">			
									<input type="hidden" id="esLiberado${estado.count}" name="esLiberado" size="8" value="${creditosLis.asignado}"  />  
									<input type="checkbox"id="esLiberadocheck${estado.count}" name="esLiberadocheck" value="${creditosLis.asignado}" onclick="realiza(this.id)"/>		    													 							
							  	</td> 					
							</tr>					
						</c:forEach>
					</tbody>
			</c:when>
		</c:choose>
	</table>
	
	
</body>
</html>
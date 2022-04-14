<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="fondeoSolicitudLis" value="${listaResultado[2]}"/>

<c:choose>
	<c:when test="${tipoLista == '4'}">
		
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                			
		<table border="0" cellpadding="0" cellspacing="0" width="100%"> 	
			<tr>
				<td class="label"> 
				   	<label for="lblFondeo">Fondeo</label> 
				</td> 	
				<td class="label"> 
				   	<label for="lblInversionista">Inversionista</label> 
				</td> 
				<td class="label"> 
				   	<label for="lblnumero">NombreCompleto</label> 
				</td> 
				<td class="label"> 
				   	<label for="lblrfc">RFC</label> 
				</td> 
				<td class="label"> 
				   	<label for="lblfecha">Fecha Registro</label> 
				</td> 
				<td class="label"> 
				   	<label for="lblmonto">Monto</label> 
				</td> 
				<td class="label"> 
				   	<label for="lblporcentaje">Porcentaje</label> 
				</td> 
				<td class="label"> 
				   	<label for="lblnivlriesgo">Nivel Riesgo</label> 
				</td> 
			</tr>
			<c:forEach items="${fondeoSolicitudLis}" var="fondeoSol" varStatus="status">
				<tr>
					<td> 
						<input id="solFondeoID${status.count}"  name="solFondeoID" size="3"  
							value="${fondeoSol.solFondeoID}" readOnly="true" disabled="true"/> 
					</td> 
					<td> 
						<input id="clienteID${status.count}"  name="clienteID" size="10"  
							value="${fondeoSol.clienteID}" readOnly="true" disabled="true"/> 
					</td> 
					<td> 
						<input id="nombreCompleto${status.count}"  name="nombreCompleto" size="35"  
							value="${fondeoSol.nombreCompleto}" readOnly="true" disabled="true"/> 
					</td> 
					<td> 
						<input id="rfcCliente${status.count}"  name="rfcCliente" size="20"  
							value="${fondeoSol.rfcCliente}" readOnly="true" disabled="true"/> 
					</td> 
					<td> 
						<input id="fechaRegistro${status.count}"  name="fechaRegistro" size="15"  
							value="${fondeoSol.fechaRegistro}" readOnly="true" disabled="true"/> 
					</td> 
					<td> 
						<input id="montoFondeo${status.count}"  name="montoFondeo" size="10"  
							value="${fondeoSol.montoFondeo}" readOnly="true" disabled="true"/> 
					</td> 
					<td> 
						<input id="porcentajeFondeo${status.count}"  name="porcentajeFondeo" size="5"  
							value="${fondeoSol.porcentajeFondeo}" readOnly="true" disabled="true"/> 
					</td> 
					<td> 
						<c:choose>
							<c:when test="${fondeoSol.nivelRiesgoCliente == 'A'}">
				     			<input id="nivelRiesgoCliente${status.count}"  name="nivelRiesgoCliente" size="8"  
								value="ALTO" readOnly="true" disabled="true"/>
			     			</c:when>
			     			<c:otherwise>
			     				<input id="nivelRiesgoCliente${status.count}"  name="nivelRiesgoCliente" size="8"  
										value="${fondeoSol.nivelRiesgoCliente}" readOnly="true" disabled="true"/>
			     			</c:otherwise>
			     		</c:choose>
			     		<input id="solFon" name="solFon" size="10" align="right"  type = "hidden" 
			     		  			value="${fondeoSol.solFondeoID}" readOnly="true" disabled="true" />		
					</td> 
					
				</tr>
			</c:forEach>
	

		</table>
		</fieldset>

	</c:when>
	</c:choose>

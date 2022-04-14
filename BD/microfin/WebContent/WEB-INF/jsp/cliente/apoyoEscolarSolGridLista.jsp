<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<form id="gridSolicitudApoyoEsc" name="gridSolicitudApoyoEsc">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<table id="tablaGridApoyo" border="0" cellpadding="0" cellspacing="0" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '1'}">
					<tr>
						<td class="label" align="center"><label for="solicitudID">Solicitud</label></td>
						<td class="label" align="center"><label for="nivelEscolar">Grado Escolar</label></td>
						<td class="label" align="center"><label for="gradoEscolar">No. Grado</label></td>
						<td class="label" align="center"><label for="cicloEscolar">Ciclo Escolar</label></td>
						<td class="label" align="center"><label for="promedioEscolar">Promedio</label></td>
						<td class="label" align="center"><label for="edadCliente">Edad</label></td>
						<td class="label" align="center"><label for="monto">Monto</label></td>
						<td class="label" align="center"><label for="fechaRegistro">Fecha Registro</label></td>
						<td class="label" align="center"><label for="fechaRegistro">Fecha Autorizaci&oacute;n/Rechazo</label></td>
						<td class="label" align="center"><label for="fechaRegistro">Fecha Pago</label></td>
						<td class="label" align="center"><label for="estatus">Estatus</label></td>
						<td class="label" align="center"><label for="usuarioRegistro">Usuario Registro</label></td>
				  	</tr>
					<c:forEach items="${listaResultado}" var="solicitud" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td  align="center"> 
							<input type="text" id="solicitudID${status.count}"  name="solicitudID" size="15"  
										 value="${solicitud.apoyoEscSolID}"  disabled="true"  readOnly="true" style='text-align:left;' />					
						</td> 
						<td  align="center"> 						
							<input type="text" id="nivelEscolar${status.count}" name="nivelEscolar" size="40" 
										 value="${solicitud.apoyoEscCicloID}" disabled="true" readOnly="true" style="text-align:left;"/> 
						</td>
						<td  align="center">  
							<input type="text" id="gradoEscolar${status.count}"  name="gradoEscolar" size="5"  
										  value="${solicitud.gradoEscolar}" disabled="true" readOnly="true"  style='text-align:left;' /> 
						</td>  
						<td  align="center"> 
						 	<input type="text" id="cicloEscolar${status.count}" name="cicloEscolar" size="20" 
										value="${solicitud.cicloEscolar}" disabled="true" readOnly="true" style='text-align:left;'/> 
						</td> 
						<td  align="center"> 
						 	<input type="text" id="promedioEscolar${status.count}" name="promedioEscolar" size="8" 
										value="${solicitud.promedioEscolar}" disabled="true" readOnly="true" style='text-align:left;'/> 
						</td> 
						<td  align="center"> 
						 	<input type="text" id="edadCliente${status.count}" name="edadCliente" size="5" 
										value="${solicitud.edadCliente}" disabled="true" readOnly="true" style='text-align:left;'/> 
						</td> 
						<td  align="center"> 
						 	<input type="text" id="monto${status.count}" name="monto" size="17" 
										value="${solicitud.monto}" disabled="true" readOnly="true" style='text-align:right;' esMoneda="true"/> 
						</td> 
						<c:if test = "${solicitud.fechaRegistro == '1900-01-01' }">	
							<td  align="center"> 
							 	<input type="text" id="fechaRegistro${status.count}" name="fechaRegistro" size="17" 
											value="" disabled="true" readOnly="true" style='text-align:left;'/> 
							</td>
						</c:if> 
						<c:if test = "${solicitud.fechaRegistro != '1900-01-01' }">	
							<td  align="center"> 
							 	<input type="text" id="fechaRegistro${status.count}" name="fechaRegistro" size="17" 
											value="${solicitud.fechaRegistro}" disabled="true" readOnly="true" style='text-align:left;'/> 
							</td>
						</c:if> 
						<c:if test = "${solicitud.fechaAutoriza == '1900-01-01' }">	
							<td  align="center"> 
							 	<input type="text" id="fechaAutoriza${status.count}" name="fechaAutoriza" size="17" 
											value="" disabled="true" readOnly="true" style='text-align:left;'/> 
							</td> 
						</c:if> 
							<c:if test = "${solicitud.fechaAutoriza != '1900-01-01' }">	
							<td  align="center"> 
							 	<input type="text" id="fechaAutoriza${status.count}" name="fechaAutoriza" size="17" 
											value="${solicitud.fechaAutoriza}" disabled="true" readOnly="true" style='text-align:left;'/> 
							</td> 
						</c:if> 
						<td  align="center"> 
								<c:if test = "${solicitud.estatus != 'P'}">								  		
						 			<input type="text" id="fechaPago${status.count}" name="fechaPago" size="17" 
										value=" " disabled="true" readOnly="true" style='text-align:left;'/> 						
				    			</c:if>	
						 		<c:if test = "${solicitud.estatus == 'P'}">								  		
						 			<input type="text" id="fechaPago${status.count}" name="fechaPago" size="17" 
										value="${solicitud.fechaPago}" disabled="true" readOnly="true" style='text-align:left;'/> 						
				    			</c:if>	
						</td> 
						<td  align="center"> 
								<c:if test = "${solicitud.estatus == 'A' }">								  		
						 			<input type="text" id="estatus${status.count}" name="estatus" size="20" 
										value="AUTORIZADO" disabled="true" readOnly="true" style='text-align:left;'/>						
				    			</c:if>	 
				    			<c:if test = "${solicitud.estatus == 'X' }">		
							  		<input type="text" id="estatus${status.count}" name="estatus" size="20" 
										value="RECHAZADO" disabled="true" readOnly="true" style='text-align:left;'/>					    			
				    			</c:if>	
				    			<c:if test = "${solicitud.estatus == 'P' }">		
							  		<input type="text" id="estatus${status.count}" name="estatus" size="20" 
										value="PAGADO" disabled="true" readOnly="true" style='text-align:left;'/>					    			
				    			</c:if>	
						</td> 
						<td  align="center"> 
						 	<input type="text" id="usuarioRegistro${status.count}" name="usuarioRegistro" size="50" 
										value="${solicitud.usuarioRegistra}" disabled="true" readOnly="true" style='text-align:left;'/> 
						</td> 						 
				 	</tr>
			
					</c:forEach>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>
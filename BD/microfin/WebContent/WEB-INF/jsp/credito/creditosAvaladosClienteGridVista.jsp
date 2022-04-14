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
	<legend>Cr&eacute;ditos Avalados</legend>            
		<table width="100%">
			<c:choose>
				<c:when test="${tipoLista == '27'}">
					<tr id="encabezadoLista">
						<td class="label" align="center">No. <s:message code="safilocale.cliente"/></td>
						<td class="label" align="center">Nombre <s:message code="safilocale.cliente"/></td>
						<td class="label" align="center">No. Cr&eacute;dito</td>
						<td class="label" align="center">Producto Cr&eacute;dito</td>
						<td class="label" align="center">Monto Original Cr&eacute;dito</td>
						<td class="label" align="center">Saldo Capital al D&iacute;a</td>
						<td class="label" align="center">Estatus</td>
						<td class="label" align="center">D&iacute;as Atraso</td>
					</tr>
						
					<c:forEach items="${listaResultado}" var="solicitud" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td  align="left"> 
								<label>${solicitud.clienteID}</label>					
							</td> 
							<td  align="left"> 						
								<label>${solicitud.nombreCliente}</label>
							</td>
							<td  align="left"> 
								<label>${solicitud.creditoID}</label>				
							</td> 
							<td  align="left"> 						
								<label>${solicitud.producCreditoID}</label>
							</td>
							<td  align="right"> 						
								<label>${solicitud.montoCredito}</label>
							</td>
							<td  align="right"> 						
								<label>${solicitud.saldoCapVigent}</label> 
							</td>
							<td  align="center"> 						
								<label>${solicitud.estatus}</label>
							</td>
							<td  align="center"> 						
								<label>${solicitud.diasAtraso}</label> 
							</td>
						</tr>			
					</c:forEach>
				</c:when>
					<c:when test="${tipoLista == '34'}">
					<tr id="encabezadoLista">
						<td class="label" align="center">Cr&eacute;dito</td>
						<td class="label" align="center">Estatus</td>
						<td class="label" align="center"><s:message code="safilocale.cliente"/></td>
						<td class="label" align="center">D&iacute;as Atraso</td>
					</tr>
						
					<c:forEach items="${listaResultado}" var="solicitud" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
						
							<td> 
								<input type="hidden" id="creditoIDAv${status.count}" name="creditoIDAv" value="${solicitud.creditoID}"/>
							</td> 
							<td > 	
								<input type="hidden" id="estatusAv${status.count}" name="estatusAv" value="${solicitud.estatus}"/>					
							</td>
							<td > 
								<input type="hidden" id="clienteAv${status.count}" name="clienteAv" value="${solicitud.clienteID}"/>				
							</td> 
							<td >
								<input type="hidden" id="diasAtrasoAv${status.count}" name="diasAtrasoAv" value="${solicitud.diasAtraso}"/>		 						
							</td>
						</tr>			
					</c:forEach>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>
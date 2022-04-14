<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<script type="text/javascript" src="js/soporte/mascara.js"></script>

<c:set var="tipoLista"  value="3"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<form id="gridClienteAvales" name="gridClienteAvales">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">    
	<legend>Mis Avales</legend>            
		<table width="100%">
			<c:choose>
				<c:when test="${tipoLista == '3'}">
					<tr id="encabezadoLista">
						
						<td class="label" align="center">No. <s:message code="safilocale.cliente"/></td>
						<td class="label" align="center" width="20%">Nombre</td>
						<td class="label" align="center">Sucursal</td>
						<td class="label" align="center">Teléfonos</td>
						<td class="label" align="center" width="30%">Dirección</td>
						<td class="label" align="center">No. Crédito</td>
						<td class="label" align="center">Estatus</td>
					</tr>
						
					<c:forEach items="${listaResultado}" var="solicitud" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							
							<td  align="center"> 
								<label>${solicitud.clienteID}</label>				
							</td> 
							<td  align="left"> 						
								<label>${solicitud.nombreCompleto}</label>
							</td>
							<td  align="center"> 						
								<label>${solicitud.sucursal}</label>
							</td>
							<td  align="left"> 					
								<label>${solicitud.telefono}
								<c:if test="${solicitud.telefono != null && solicitud.telefono != '' && solicitud.telefonoCel != null && solicitud.telefonoCel != ''}"> ,</c:if> 
								${solicitud.telefonoCel}</label>
							</td>
							<td  align="left"> 						
								<label>${solicitud.direccionCompleta}</label> 
							</td>
							<td  align="center"> 
								<label>${solicitud.creditoID}</label>				
							</td> 
							<td  align="center"> 
								<label>${solicitud.estatus}</label>				
							</td> 
						</tr>			
					</c:forEach>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>
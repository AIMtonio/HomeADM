
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>


<br>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

	<fieldset class="ui-widget ui-widget-content ui-corner-all">  
	<legend>Integrantes Activos Actuales</legend>              
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '11'}">  	
					<tr>
						<td class="label"> <label for="consecutivo"></label> </td>
						<td class="label"> <label for="creditoID">Crédito</label> </td>
						<td class="label"> <label for="solicitudCreditoID">Sol. Cr&eacute;dito</label> </td>
				  		<td class="label"> <label for="clienteID"><s:message code="safilocale.cliente"/></label> </td>
				  		<td class="label"> <label for="nombreCliente">Nombre</label> </td>
						<td class="label"> <label for="monto">Monto</label> </td>
				  		<td class="label"> <label for="fechaInicio">Fecha Inicio</label> </td>
				  		<td class="label"> <label for="fechaVencimiento">Fecha Ven.</label> </td>
						<td class="label"> <label for="estatusCredito">Estatus Cred.</label> </td>
						<td class="label" id="desintegrar"> <label for="desintegrar">Seleccionar</label> </td>
					</tr>					
					<c:forEach items="${listaResultado}" var="integrante" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
						
							<td> 									
								<input type="hidden" id="consecutivoID${status.count}" value="${status.count}" /> 
						  	</td> 
						  	<td> 
								<input type="text" id="creditoID${status.count}" size="12" value="${integrante.creditoID}"readOnly="true"/> 
							</td>  
						  	<td> 
								<input type="text"  id="solicitudCreditoID${status.count}" size="12" value="${integrante.solicitudCreditoID}" readOnly="true"/> 
						  	</td>
						  	<td> 
								<input type="text" id="clienteID${status.count}" size="12" value="${integrante.clienteID}"readOnly="true"/> 
							</td> 
							<td> 
								<input type="text" id="nombreCliente${status.count}" size="40" value="${integrante.nombreCliente}"readOnly="true"/> 
							</td>
							<td> 
								<input type="text" id="monto${status.count}" size="12" value="${integrante.monto}"readOnly="true"  style='text-align:right;' esMoneda="true"/> 
							</td> 
							<td> 
								<input type="text" id="fechaInicio${status.count}" size="12" value="${integrante.fechaInicio}"readOnly="true"/> 
							</td>   
							<td> 
								<input type="text" id="fechaVencimiento${status.count}" size="12" value="${integrante.fechaVencimiento}" readOnly="true"/> 
							</td> 
							<td> 
								<input type="text" id="estatusCredito${status.count}" size="12" value="${integrante.estatusCredito}"readOnly="true"/> 
							</td> 
							<td> 
								<input type="radio" id="integrante${status.count}" value="${status.count}"  name="integrante"  unchecked="true" onclick="desintegrarGrupo(this.value)"/>
							</td> 	
				     	</tr>
					</c:forEach>
				</c:when>  			
				
			</c:choose>
		</table>
	</fieldset>
	
	<br>
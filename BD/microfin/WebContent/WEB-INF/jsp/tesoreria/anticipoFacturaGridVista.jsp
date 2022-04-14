<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<form id="gridAnticipoFactura" name="gridAnticipoFactura">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '2'}">
					<tr>
						<td class="label" align="center">
					   		<label for="lblconsecutivo"></label> 
						</td>
					<td class="label" align="center">
					   		<label for="lblFechaAnticipo">Fecha Anticipo</label> 
						</td>
						<td class="label" align="center">
							<label for="lblEstatus">Estatus</label> 
				  		</td>
				  		<td class="label" align="center">
							<label for="lblFormaPago">Forma de Pago</label> 
				  		</td>
				  		<td class="label" align="center">
							<label for="lblFecha">Fecha Pago o</label> 
							<br>
							<label for="lblFecha">Cancelación</label> 
				  		</td>
				  		<td class="label" align="center">
							<label for="lblMonto">Monto</label> 
				  		</td>
				  		<td class="label" align="center"> 
							<label for="lblCancela">Cancelar</label> 
				  		</td>
					
				  	</tr>
					<c:forEach items="${listaResultado}" var="anticipo" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td> 
							<input id="consecutivoID${status.count}"  name="consecutivoID" size="3"  
										value="${status.count}" readOnly="true" disabled="true" type="hidden" style='text-align:left;' /> 										
						</td> 
						<td> 
						<input type="hidden" id="anticipoFactID${status.count}" name="anticipoFactID" 
										 value="${anticipo.anticipoFactID}" />
							<input type="text" id="fechaAnticipo${status.count}" name="fechaAnticipo" size="18" 
										 value="${anticipo.fechaAnticipo}" readOnly="true" disabled="true" style='text-align:left;' /> 
						</td>
						<td>  
							<input type="text" id="estatusAnticipo${status.count}"  name="estatusAnticipo" size="12"  
										  value="${anticipo.estatusAnticipo}"readOnly="true" disabled="true" style='text-align:left;' /> 
						</td>  
						<td> 
						 	<input type="text" id="formaPago${status.count}" name="formaPago" size="20" 
										value="${anticipo.formaPago}" readOnly="true" disabled="true" style='text-align:left;' /> 
						</td> 
						<td> 
							<input type="text" id="fechaCancela${status.count}"  name="fechaCancela" size="18"  
									  value="${anticipo.fechaCancela}" readOnly="true" disabled="true" style='text-align:left;' /> 
						</td>
						<td> 
							<input type="text" id="montoAnticipo${status.count}"  name="montoAnticipoGrid" size="15" esMoneda="true"
									  value="${anticipo.montoAnticipo}" readOnly="true" style='text-align:right;' /> 
						</td>
						
						<c:if test="${anticipo.estatusAnticipo == 'Registrado'}">
							<td align="center"><input type="checkbox" id="estatus${status.count}" name="listaAnticipo"  value="${anticipo.anticipoFactID}"  onclick="habilitaBotonCancelaAnticipo();"/>
							</td>
	     				</c:if>
						 
				 	</tr>
			
					</c:forEach>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>

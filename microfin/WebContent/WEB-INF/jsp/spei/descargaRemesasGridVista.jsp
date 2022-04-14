<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<form id="descargaRemesasBean" name="descargaRemesasBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '2'}">			  	
				  	<tr id="encabezadoLista">
				  	
				  		<th style="visibility: hidden;"></th>					  		
						<th>Solicitud</th>
						<th>Hora</th>
						<th>Descarga de INCORPORATE</th>
						<th>Por Autorizar</th>
						<th>Enviados</th>
								</tr>
					<c:forEach items="${listaResultado}" var="pago" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td> 
							<input id="consecutivoID${status.count}"  name="consecutivoID" size="3"  
										value="${status.count}" readOnly="true" disabled="true" type="hidden" style='text-align:left;' /> 										
						</td> 
						<td> 
							<input type="text" id="speiSolDesID${status.count}" name="speiSolDesID" size="16" 
										 value="${pago.speiSolDesID}" readOnly="true" disabled="true" style='text-align:left;' /> 
						</td>
						<td>  
							<input type="text" id="hora${status.count}"  name="hora" size="16"  
										  value="${pago.hora}"readOnly="true" disabled="true" style='text-align:left;' /> 
						</td>  
						<td> 
						 	<input type="text" id="descargas${status.count}" name="descargas" size="36" 
										value="${pago.descargas}" readOnly="true" disabled="true" style='text-align:left;' /> 
						</td> 
						<td> 
							<input type="text" id="autorizar${status.count}"  name="autorizar" size="19"  
									  value="${pago.pendientes}" readOnly="true" disabled="true" style='text-align:left;' /> 
						</td>
						<td> 
							<input type="text" id="enviado${status.count}"  name="enviado" size="20"  
									  value="${pago.enviados}" readOnly="true" disabled="true" style='text-align:left;' /> 
						</td>
				 	</tr>
		
			
					</c:forEach>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>
		
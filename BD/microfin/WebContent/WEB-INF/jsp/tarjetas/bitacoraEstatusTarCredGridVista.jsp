<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<form id="gridBitEstatusTarDeb" name="gridBitEstatusTarDeb">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend>Movimientos</legend>	
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '1'}">
					<tr>
						<td class="label"> 
					   		<label for="lblconsecutivo"></label> 
						</td>
						<td class="label"> 
					   		<label for="lblTarjetaDebitoID">Fecha</label> 
						</td>
						<td class="label"> 
							<label for="lblTipoEvento">Tipo de Evento</label> 
				  		</td>
				  		<td class="label"> 
							<label for="lblMotivo">Motivo</label> 
				  		</td>
				  		<td class="label"> 
							<label for="lblDescripcion">Descripción</label> 
				  		</td>
					
				  	</tr>
					<c:forEach items="${listaResultado}" var="movimien" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td> 
							<input id="consecutivoID${status.count}"  name="consecutivoID" size="3"  
										value="${status.count}" readOnly="true" disabled="true" type="hidden"/> 
						</td> 
						<td> 
							<input type="text" id="fecha${status.count}" name="fecha" size="11" 
										 value="${movimien.fecha}" readOnly="true" disabled="true" /> 
						</td>
						<td> 
							<input type="text" id="TipoEvento${status.count}"  name="TipoEvento" size="30"  
										  value="${movimien.tipoEvento}"readOnly="true" disabled="true" /> 
						</td>  
						<td> 
						 	<input type="text" id="Motivo${status.count}" name="Motivo" size="40" 
										value="${movimien.motivo}" readOnly="true" disabled="true"/> 
						</td> 
						<td> 
							<input type="text" id="Descripcion${status.count}"  name="Descripcion" size="80"  
									  value="${movimien.descripcion}" readOnly="true" disabled="true" style='text-align:left;' /> 
						</td>
						 
				 	</tr>
			
					</c:forEach>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>

<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="aportaSocioMov"  value="${listaPaginada.pageList}"/>

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend>Movimientos</legend>	
	<table border="0"  width="100%"> 		
		<tr id="encabezadoLista">
			<td>Fecha</td> 	
			<td>Descripción</td>
			<td>Tipo</td> 
			<td align="center">Monto</td> 
			<td align="center">Saldo</td> 
		</tr>
		<c:forEach items="${aportaSocioMov}" var="aportacionSocioMov" varStatus="status">
		<tr>
			<td> 
				<label for="fecha" id="fecha${status.count}"  name="fecha" size="20" >${aportacionSocioMov.fecha}</label>  
			</td> 
			<td> 				
				<label for="descripcionMov${status.count}" id="descripcionMov${status.count}" name="descripcionMov" size="40">
					<c:set var="string" value="${aportacionSocioMov.descripcionMov}"/>${fn:substring(string,0,30)}</label>
			</td> 
			<td> 
				<c:choose>
			    	<c:when test="${aportacionSocioMov.natMovimiento == 'A'}">
			    		<c:set var="naturaleza" value="APORTACION"/>
					    </c:when>
			     		<c:when test="${aportacionSocioMov.natMovimiento == 'D'}">
			    		<c:set var="naturaleza" value="DEVOLUCION"/>
				   	</c:when>
				</c:choose>
    			<label for="natMovimiento" id="natMovimiento${status.count}" name="natMovimiento" size="8">	${naturaleza}</label>
     		</td> 

  			<td align="right"> 
      			<label for="cantidadMov" id="cantidadMov${status.count}" name="cantidadMov" size="15" >${aportacionSocioMov.cantidadMov}</label>
  			</td> 
  			<td align="right"> 	
  				<label for="saldo"  id="saldo${status.count}" name="saldo" size="15" >${aportacionSocioMov.saldo}</label>
  			</td> 
		</tr>
		</c:forEach>
	</table>
		<c:if test="${!listaPaginada.firstPage}">
			 <input onclick="consultaMovimientos('previous')" type="button" value="" class="btnAnterior" />
		</c:if>
		<c:if test="${!listaPaginada.lastPage}">
			 <input onclick="consultaMovimientos('next')" type="button" value="" class="btnSiguiente" />
		</c:if>	
</fieldset>
	
<div id="desMovimiento" style="display: none;">
	<div id="elementoListaDes"/>		
</div>	
	

		
		


        

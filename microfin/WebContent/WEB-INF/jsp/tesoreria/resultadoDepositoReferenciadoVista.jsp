<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>    	 
<table id="detalle" border="0" width="100%">
	<c:choose>
	<c:when test="${tipoLista == '1'}">	
		<tr id="encabezadoLista">
			<td class="label" align="center">
		   		<label style="color: #ffffff;">No.</label> 
			</td>
			<td class="label" align="center">
				<label style="color: #ffffff;">Fecha</label> 
	  		</td>
			<td class="label" align="center">
				<label style="color: #ffffff;">Referencia</label> 
	  		</td>
	  		<td class="label" align="center">
				<label style="color: #ffffff;">Monto</label> 
	  		</td>
	  		<td class="label" align="center">
				<label style="color: #ffffff;">Validaci&oacute;n</label> 
	  		</td>
			<td class="label" align="center">
   				<label style="color: #ffffff;">Seleccionar</label> 
			</td>
	  	</tr>
	<c:forEach items="${listaResultado}" var="listaDepositos" varStatus="status">
		<tr id="renglon${status.count}" name="renglon">			
			<td> 
				<input type="text" id="consecutivo${status.count}"  name="consecutivo" size="4" value="${status.count}" readOnly="true" style='text-align:left;' />
			</td> 
			<td>  
				<input type="text" id="fecha${status.count}"  name="fecha" size="10" value= "${listaDepositos.fechaOperacion}" readOnly="true" style='text-align:center;' /> 
			</td> 
			<td> 
				<input  type="text" id="referencia${status.count}"  name="referencia" size="20" value="${listaDepositos.referenciaMov}" readOnly="true" style='text-align:left;' />  
			</td> 
			<td> 
				<input type="text"  id="monto${status.count}" name="monto" size="20" esMoneda="true"value= "${listaDepositos.montoMov}" readOnly="true" style='text-align:right;' /> 
			</td> 
			<td  nowrap="nowrap"> 
				<input type="text" id="validacion${status.count}"  name="validacion" size="60" value="${listaDepositos.validacion}" readOnly="true" style='text-align:left;' />  
			</td> 
			<td align="center"> 
				<input type="checkbox" id="seleccionaCheck${status.count}" name="seleccionaCheck" onclick="seleccionarDeposito();"/>
				<input type="hidden" id="seleccionado${status.count}" name="seleccionado" value="N"/> 
				<input type="hidden" id="numCtaInstit${status.count}" name="numCtaInstit" size="12" value= "${listaDepositos.numCtaInstit}"/> 
				<input type="hidden" id="naturaleza${status.count}" name="naturaleza" size="5" value= "${listaDepositos.natMovimiento}"/> 
				<input type="hidden" id="descripcion${status.count}" name="descripcion" size="5" value= "${listaDepositos.descripcionMov}"/>	
				<input type="hidden" id="tipoMov${status.count}" name="tipoMov" size="5" value= "${listaDepositos.tipoMov}"/> 
				<input type="hidden" id="deposito${status.count}" name="deposito" size="5" value= "${listaDepositos.tipoDeposito}"/> 	
				<input type="hidden" id="moneda${status.count}" name="moneda" size="5" value= "${listaDepositos.tipoMoneda}"/>
				<input type="hidden" id="canal${status.count}" name="canal" size="5" value= "${listaDepositos.tipoCanal}"/> 	
				<input type="hidden" id="transaccion${status.count}" name="transaccion" size="5" value= "${listaDepositos.numTransaccion}"/> 	
				<input type="hidden" id="numVal${status.count}" name="numVal" size="5" value= "${listaDepositos.numVal}"/>
				<input type="hidden" id="numIdenArchivo${status.count}" name="numIdenArchivo" value= "${listaDepositos.numIdenArchivo}"/> 	 	 	
				<input type="hidden" id="numTran${status.count}" name="numTran" value= "${listaDepositos.numTran}"/> 	 	 	
				<input type="hidden" id="folioCargaID${status.count}" name="folioCargaID" value= "${listaDepositos.folioCargaID}"/> 	 	 	
			</td> 
		</tr>
	</c:forEach>
	</c:when>
</c:choose>
</table>
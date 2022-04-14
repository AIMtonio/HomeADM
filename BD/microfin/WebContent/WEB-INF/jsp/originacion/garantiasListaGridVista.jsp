<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%> 

<c:set var="listaResultado" value="${listaResultado}"/>
<form id="listaGarantias" name="listaGarantias">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Garantías</legend>			
<div id="tableCon">	
	<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%"> 
		 		<tr>
					<td> </td>
		     		<td class="label"> 
		         		<label for="lblgarantia">Garantía </label> 
		     		</td> 
		     			<td class="label"> &nbsp;
		         		<label for="lblIdentifi">Identificación </label> 
		     		</td> 
		     			<td class="label"> &nbsp;
		         		<label for="lblNumSerie">Num. Serie </label> 
		     		</td> 
		     		<td class="label"> &nbsp;
		         		<label for="lblgarantia">Garante Nombre </label> 
		     		</td> 
		     		<td class="label"> 
		         		<label for="lblgarantia">Valor Comercial </label> 
		     		</td> 	
		     		<td class="label"> &nbsp;
		         		<label for="lblgarantia">Observaciones </label> 
		     		</td> 
		     		     						   		     
		     	</tr>						
						<c:forEach items="${listaResultado}" var="garantia" varStatus="status">
							<tr id="fila${status.count}" name="fila">
								
								<td>
									<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID" size="3" value="${status.count}"  />
								</td>
								<td>
									<input type="text" id="garantiaID${status.count}"  value="${garantia.garantiaID}" name="garantiaID" size="6"  disabled="true" />			
								</td>
								<td>
									<input type="text" id="noIdentificacion${status.count}"  value="${garantia.noIdentificacion}" name="noIdentificacion" size="20"  disabled="true" />			
								</td>
								<td>
									<input type="text" id="serieFactura${status.count}"  value="${garantia.serieFactura}" name="serieFactura" size="20"  disabled="true" />			
								</td>
								<td>
									<input type="text" id="garanteNombre${status.count}"  value="${garantia.garanteNombre}" name="garanteNombre" size="40" disabled="true" />			
									 <!-- <input type="hidden" id="nombrePropUno${status.count}"  value="${garantia.nombrePropUno}" name="nombrePropUno" size="40" disabled="true" />-->
									
								</td>
								<td>
									<input type="text" id="valorComercial${status.count}"  value="${garantia.valorComercial}" name="valorComercial" size="15" style="text-align:right;" esMoneda="true" esTasa="true" disabled="true"/>
								</td>
								<td>
									<textarea  id="obserbaciones${status.count}" name="obserbaciones"   cols="50" rows="1"  disabled="true">${garantia.observaciones} </textarea>
								</td>
																
							</tr>
						 <c:set var="cont" value="${status.count}"/>
   	
						</c:forEach>
								
</table> 
     <input type="hidden" value="${cont}" name="numeroDetalle" id="numeroDetalle" />
     
</div>
 </fieldset>
 </form>
   

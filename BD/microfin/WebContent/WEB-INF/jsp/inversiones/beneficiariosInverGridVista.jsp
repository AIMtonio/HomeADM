<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<html>
<head>

</head>
<body>
<br/>

<c:set var="listaResultado"  value="${listaResultado}"/>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Beneficiarios</legend>
					
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label"> &nbsp;
					   	<label for="lblNumero">Número</label> 
						</td>
						<td class="label"> &nbsp;
					   	<label for="lblCliente"><s:message code="safilocale.cliente"/></label> 
						</td>
						<td class="label" > &nbsp;
							<label for="lblNombreCompleto" align="center" >Nombre Completo</label> 
				  		</td>
				  		<td class="label"> &nbsp;
							<label for="lblParentesco">Parentesco</label> 
				  		</td>
				  		<td class="label"> &nbsp;
							<label for="lblPorcentaje">Porcentaje</label> 
				  		</td>
				  			
					</tr>					
					<c:forEach items="${listaResultado}" var="beneficiario" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td>
								<input type="hidden" id="consecutivo${status.count}" name="consecutivo" size="6" value="${status.count}" />																												
								<input  type="hidden" id="inversionID${status.count}" name="inversionID" size="6" value="${beneficiario.inversionID}" />						
 								<input type="text" id="benefInverID${status.count}" name="benefInverID" size="10"
 									 value="${beneficiario.beneInverID}" readOnly="true"  onclick="consultaInversion(this.id)"/>   								
						  	</td> 
						 
						  	<td> 
								<input  type="text" id="clienteID${status.count}" name="clienteID" size="11" 
										value="${beneficiario.clienteID}" readOnly="true" disabled="true" /> 							 							
						  	</td> 
						  	
						  	<td> 
								<input  type="text" id="nombreCompleto${status.count}" name="nombreCompleto" size="50" 
										value="${beneficiario.nombreCompleto}" readOnly="true" disabled="true" /> 							 							
						  	</td> 	
						  	<td> 
								<input type="text" id="parentescoID${status.count}" name="parentescoID" size="8" 
									value="${beneficiario.parentescoID}" readOnly="true" disabled="true" />  														
								 							 													  	
								<input type="text" id="descripParentesco${status.count}" name="descripParentesco" size="35" 
									value="${beneficiario.descripParentesco}" readOnly="true" disabled="true" />  																						 							 						
						  	</td> 						  	
						  	<td> 
								<input type="text" id="porcentaje${status.count}" name="porcentaje" size="10" 
										value="${beneficiario.porcentaje}" readOnly="true" disabled="true" style="text-align: right"/>  
										<label for="lbl%">%</label>																						 							 						
						  	</td> 					
						</tr>
						
						
					</c:forEach>
				</tbody>
				<tr align="right">
					<td class="label" colspan="5"> 
				   	<br>
			     	</td>
				</tr>
			</table>
		</fieldset>																
			 <input type="hidden" value="0" name="numeroDocumento" id="numeroDocumento" />
	
	

</body>
</html>

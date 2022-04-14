<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="cuentasPersona"  value="${cuentasPersona}"/>

<div id="gridFirmantes" >
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Personas Autorizadas Para Firmar</legend>	
			<table border="0" cellpadding="0" cellspacing="0" width="100%"> 		
					<tr>
						<td class="label"> 
					   	<label for="lblPersonaID">N&uacute;mero</label> 
						</td> 	
						<td class="label"> 
							<label for="lblNombreCompleto">Nombre Completo</label> 
				  		</td>
				  		<td class="label"> 
			         	<label for="lblTipo">Tipo: </label> 
			     		</td> 
			     		<td class="label"> 
			         	<label for="lblInstrucEspecial">Instrucci&oacute;n Especial</label> 
			     		</td> 
					</tr>
					
					<c:forEach items="${cuentasPersona}" var="cuentasPersonaF" varStatus="status">
				
						<tr>
							<td> 
								<input id="personaID${status.count}"  name="personaID" size="7"  
										value="${cuentasPersonaF.personaID}" readOnly="true" disabled="true" iniForma = "false"/> 
						  	</td> 
						  	<td> 
								<input id="nombreCompleto${status.count}" name="nombreCompleto" size="60" 
										value="${cuentasPersonaF.nombreCompleto}" readOnly="true" disabled="true" iniForma = "false"/> 
						  	</td> 
				     		<td> 
				     			<select id="tipo${status.count}" name="tipo" iniForma = "false">			     			
				     					
						     				<option value="A" ${cuentasPersonaF.esFirmante == 'A' ? 'selected' : ''}>Individual</option>
						     				<option value="B" ${cuentasPersonaF.esFirmante == 'B' ? 'selected' : ''}>Mancomunada</option>
						     				<option value="C" ${cuentasPersonaF.esFirmante == 'C' ? 'selected' : ''}>Especial</option>
						     			
								</select>
							</td> 
				     		<td> 
			         			<input id="instrucEspecial${status.count}" name="instrucEspecial" size="100"
			         				value="${cuentasPersonaF.tercerNombre}" iniForma = "false" onkeyPress="return validador(event);" onBlur=" ponerMayusculas(this)"/> 
			     			</td>
			     			<c:set var="contador"  value="${status.count}"/>
			     			<c:set var="instruccionVar"  value="${cuentasPersonaF.tercerNombre}"/>
						</tr>
					</c:forEach>
					<tr>
						<td>
							<input type="hidden" id="numeroPersonasRegistradas"  name="numeroPersonasRegistradas" size="7"  
										value="${contador}" />	
							<input type="hidden" id="varInstruccion"  name="varInstruccion" size="7"  
										value="${instruccionVar}" />	
						</td>
					</tr>
			</table>
		</fieldset>
	</div>


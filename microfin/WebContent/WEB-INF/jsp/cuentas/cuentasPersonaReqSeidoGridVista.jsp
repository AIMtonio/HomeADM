<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

			<table width="100%">
			<tr id="encabezadoLista">
				<td class="label" align="center">No. <s:message code="safilocale.cliente"/></td>
				<td class="label" align="center">Nombre <s:message code="safilocale.cliente"/></td>
				<td class="label" align="center">No. Cuenta</td>
				<td class="label" align="center">Tipo Persona</td>
				<td class="label" align="center">Lugar de Nacimiento </td>	
				<td class="label" align="center">Fecha de Nacimiento </td>
				<td class="label" align="center">CURP </td>	
				<td class="label" align="center">RFC</td>
				<td class="label" align="center">Ocupaci&oacute;n </td>		
			</tr>
			     		
			<c:forEach items="${cuentasPersona}" var="personaRel" varStatus="status"> 
			<tr>
				<td  align="center"> 
					<label>${personaRel.clienteID}</label>					
				</td> 
				<td  align="left"> 
					<label>${personaRel.nombreCompleto}</label>					
				</td> 
				<td  align="left"> 
					<label>${personaRel.cuentaAhoID}</label>				
				</td> 
				<td  align="left"> 
					<label>${personaRel.tipoPersona}</label>					
				</td> 
				<td  align="left"> 
					<label>${personaRel.paisNacimiento}</label>					
				</td>
				<td  align="center"> 
					<label>${personaRel.fechaNacimiento}</label>					
				</td>	
				<td  align="left"> 
					<label>${personaRel.CURP}</label>					
				</td>
				<td  align="left"> 
					<label>${personaRel.RFC}</label>					
				</td>	
				<td  align="left"> 
					<label>${personaRel.desOcupacion}</label>					
				</td>							
			</tr>
		</c:forEach>
		</table>

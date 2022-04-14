<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

			<table width="100%">
			<tr id="encabezadoLista">
				<td class="label" align="center">No. <s:message code="safilocale.cliente"/></td>
				<td class="label" align="center">Nombre <s:message code="safilocale.cliente"/></td>
				<td class="label" align="center">No. Cr&eacute;dito</td>
				<td class="label" align="center">Monto de el Cr&eacute;dito</td>
				<td class="label" align="center">Fecha Nacimiento (Aval)</td>
				<td class="label" align="center">RFC (Aval)</td>			
				<td class="label" align="center">Direcci&oacute;n (Aval)</td>						
			</tr>
			     		
			<c:forEach items="${listaResultado}" var="credito" varStatus="status"> 
			<tr>
				<td  align="center"> 
					<label>${credito.clienteID}</label>					
				</td> 
				<td  align="left"> 
					<label>${credito.nombreCompleto}</label>					
				</td> 
				<td  align="center"> 
					<label>${credito.creditoID}</label>				
				</td> 
				<td  align="right"> 
					<label>${credito.montoCredito}</label>					
				</td> 
				<td  align="center"> 
					<label>${credito.fechaNac}</label>					
				</td>
				<td  align="left"> 
					<label>${credito.rFC}</label>					
				</td>
				<td  align="left"> 
					<label>${credito.direccionCompleta}</label>					
				</td>								
			</tr>
		</c:forEach>
		</table>

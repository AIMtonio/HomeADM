<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

			<table width="100%" border="0" style="table-layout:fixed">
			<tr id="encabezadoLista">
				<td class="label" align="center" width="80" >No. <s:message code="safilocale.cliente"/></td>
				<td class="label" align="center" width="170">Nombre <s:message code="safilocale.cliente"/></td>
				<td class="label" align="center" width="170" >Sucursal</td>				
				<td class="label" align="center" width="80">Estatus <s:message code="safilocale.cliente"/> </td>	
				<td class="label" align="center" width="80">Fecha Ingreso</td>
				<td class="label" align="center" width="90">Fecha Cancelaci&oacute;n</td>	
				<td class="label" align="center" width="200">Domicilio</td>
				<td class="label" align="center" width="120">Lugar de Nacimiento</td>
				<td class="label" align="center" width="80">Fecha de Nacimiento</td>
				<td class="label" align="center" width="150">CURP</td>
				<td class="label" align="center" width="120" >RFC</td>
				<td class="label" align="center" width="200">Ocupaci&oacute;n </td>		
			</tr>
			     		
			<c:forEach items="${clientePersona}" var="personaRel" varStatus="status"> 
			<tr>
				<td  align="center" > 
					<label>${personaRel.numero}</label>					
				</td> 
				<td  align="left" > 
					<label>${personaRel.nombreCompleto}</label>					
				</td> 
				<td  align="left" > 
					<label>${personaRel.sucursal}</label>				
				</td> 
				<td  align="left" > 
					<label>${personaRel.estatus}</label>					
				</td> 
				<td  align="center"> 
					<label>${personaRel.fechaAlta}</label>					
				</td>
				<td  align="center" > 
					<label>${personaRel.fechaCorte}</label>					
				</td>	
				<td  style="text-align:left;" > 
					<label>${personaRel.direccion}</label>					
				</td>
				<td  align="left" > 
					<label>${personaRel.lugarNacimiento}</label>					
				</td>	
				<td  align="center" > 
					<label>${personaRel.fechaNacimiento}</label>					
				</td>		
				<td  align="left"> 
					<label>${personaRel.CURP}</label>					
				</td>
				<td  align="left" > 
					<label>${personaRel.RFC}</label>					
				</td>	
				<td style="text-align:left;"> 
					<label>${personaRel.ocupacionID}</label>					
				</td>							
			</tr>
		</c:forEach>
		</table>


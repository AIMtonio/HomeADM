<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

			<table width="100%">
			<tr id="encabezadoLista">
				<td class="label" align="center">No. <s:message code="safilocale.cliente"/></td>
				<td class="label" align="center">Nombre <s:message code="safilocale.cliente"/></td>
				<td class="label" align="center">No. Inversi&oacute;n</td>
				<td class="label" align="center">Monto Inversi&oacute;n</td>
				<td class="label" align="center">Porcentaje </td>					
			</tr>
			     		
			<c:forEach items="${befeficiariosInv}" var="inver" varStatus="status"> 
			<tr>
				<td  align="center"> 
					<label>${inver.clienteID}</label>					
				</td> 
				<td  align="left"> 
					<label>${inver.nombreCompleto}</label>					
				</td> 
				<td  align="center"> 
					<label>${inver.inversionID}</label>				
				</td> 
				<td  align="right"> 
					<label>${inver.monto}</label>					
				</td> 
				<td  align="right"> 
					<label>${inver.porcentaje} %</label>					
				</td>				
			</tr>
		</c:forEach>
		</table>

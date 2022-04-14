<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>

</head>
<body>
<br />

<c:set var="frecTimbrarProduc"  value="${listaResultado}" />
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Productos</legend>
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="80%">
			<tbody>	
				<tr>
					<td class="label" align="center"> 
				   		<label for="lbProductoCred">Producto de Crédito</label> 
					</td>
					<td class="label" align="center"> 
				   		<label for="lblDescripcion">Enero</label> 
					</td>
					<td class="label" align="center"> 
				   		<label for="lblDescripcion">Febrero</label> 
					</td>
					<td class="label" align="center"> 
				   		<label for="lblDescripcion">Marzo</label> 
					</td>
					<td class="label" align="center"> 
				   		<label for="lblDescripcion">Abril</label> 
					</td>
					<td class="label" align="center"> 
				   		<label for="lblDescripcion">Mayo</label> 
					</td>
					<td class="label" align="center"> 
				   		<label for="lblDescripcion">Junio</label> 
					</td>
					<td class="label" align="center"> 
				   		<label for="lblDescripcion">Julio</label> 
					</td>
					<td class="label" align="center"> 
				   		<label for="lblDescripcion">Agosto</label> 
					</td>
					<td class="label" align="center"> 
				   		<label for="lblDescripcion">Septiembre</label> 
					</td>
					<td class="label" align="center"> 
				   		<label for="lblDescripcion">Octubre</label> 
					</td>
					<td class="label" align="center"> 
				   		<label for="lblDescripcion">Noviembre</label> 
					</td>
					<td class="label" align="center"> 
				   		<label for="lblDescripcion">Diciembre</label> 
					</td>
					
					<td class="label"> 
				   		<label for="lbl"></label> 
					</td>
				</tr>					
				<c:forEach items="${frecTimbrarProduc}" var="frecTimbrar" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td>
							<input type="text" id="producto${status.count}" name="productoCredito" size="60" value="${frecTimbrar.nombreProducto}" disabled="true"/>	
						</td> 
						<td style="text-align:center;">
							<input type="text" id="mes${status.count}" size="8" value="${frecTimbrar.enero}"  style="text-align:center;" disabled="true"/>	
						</td>
						<td style="text-align:center;">
							<input type="text" id="mes${status.count}" size="8" value="${frecTimbrar.febrero}" style="text-align:center;" disabled="true"/>	
						</td>
						<td style="text-align:center;">
							<input type="text" id="mes${status.count}" size="8" value="${frecTimbrar.marzo}" style="text-align:center;" disabled="true"/>	
						</td>
						<td style="text-align:center;">
							<input type="text" id="mes${status.count}" size="8" value="${frecTimbrar.abril}" style="text-align:center;" disabled="true"/>	
						</td>
						<td style="text-align:center;">
							<input type="text" id="mes${status.count}" size="8" value="${frecTimbrar.mayo}" style="text-align:center;" disabled="true"/>	
						</td>
						<td style="text-align:center;">
							<input type="text" id="mes${status.count}" size="8" value="${frecTimbrar.junio}" style="text-align:center;" disabled="true"/>	
						</td>
						<td style="text-align:center;">
							<input type="text" id="mes${status.count}" size="8" value="${frecTimbrar.julio}" style="text-align:center;" disabled="true"/>	
						</td>
						<td style="text-align:center;">
							<input type="text" id="mes${status.count}" size="8" value="${frecTimbrar.agosto}" style="text-align:center;" disabled="true"/>	
						</td>
						<td style="text-align:center;">
							<input type="text" id="mes${status.count}" size="8" value="${frecTimbrar.septiembre}" style="text-align:center;" disabled="true"/>	
						</td>
						<td style="text-align:center;">
							<input type="text" id="mes${status.count}" size="8" value="${frecTimbrar.octubre}" style="text-align:center;" disabled="true"/>	
						</td>
						<td style="text-align:center;">
							<input type="text" id="mes${status.count}" size="10" value="${frecTimbrar.noviembre}" style="text-align:center;" disabled="true"/>	
						</td>
						<td style="text-align:center;">
							<input type="text" id="mes${status.count}" size="10" value="${frecTimbrar.diciembre}" style="text-align:center;" disabled="true"/>	
						</td>						
					</tr>
					
					
				</c:forEach>
			
			</tbody>

		</table>
</fieldset>

 <input type="hidden" value="0" name="numero" id="numero"  />


</body>
</html>
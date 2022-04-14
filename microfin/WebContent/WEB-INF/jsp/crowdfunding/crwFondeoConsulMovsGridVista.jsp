<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>

</head>
<body>
</br>

<c:set var="listaResultado"  value="${listaResultado}"/>

<form id="gridDetalle" name="gridDetalle">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Movimientos</legend>	
	
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="60%">
				<tbody>	
					<tr>	
						<td class="label"> 
					   	<label for="lblFecha">No. Amortizaci&oacute;n</label> 
						</td>					
						<td class="label"> 
					   	<label for="lblFecha">Fecha</label> 
						</td>
						<td class="label"> 
							<label for="lblCR">Descripci&oacute;n</label> 
				  		</td>	
						<td class="label"> 
							<label for="lblCuenta">Tipo</label> 
				  		</td>
				  		<td class="label"> 
			         	<label for="lblReferencia">Naturaleza</label> 
			     		</td> 
			     		<td class="label"> 
			         	<label for="lblDescripcion">Cantidad</label> 
			     		</td> 
			     		  
					</tr>
					
					<c:forEach items="${listaResultado}" var="amortiFondeo" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							 
							 <td> 
								<input id="amortizacionID${status.count}"  name="amortizacionID" size="12"  
										value="${amortiFondeo.amortizacionID}" readOnly="true" disabled="true"/> 
						  	</td> 
							<td> 
								<input id="fechaOperacion${status.count}"  name="fechaOperacion" size="12"  
										value="${amortiFondeo.fechaOperacion}" readOnly="true" disabled="true"/> 
						  	</td> 
						  	<td> 
								<input id1="descripcion${status.count}" name="descripcion" size="50" 
										value="${amortiFondeo.descripcion}" readOnly="true" disabled="true"/> 
						  	</td> 
						  	<td> 
								<input id="tipoMovKuboID${status.count}" name="tipoMovKuboID" size="38" 
										value="${amortiFondeo.tipoMovKuboID}" readOnly="true" disabled="true"/> 
						  	</td>
							<c:if test="${amortiFondeo.natMovimiento == 'C'}">
						  	<td>   
				         	<input id="natMovimiento${status.count}" name="natMovimiento" size="8" align="right"
				         			value="CARGO" readOnly="true" disabled="true" /> 
				     		</td>
						  	</c:if> 
						  	<c:if test="${amortiFondeo.natMovimiento == 'A'}">
						  	<td>   
				         	<input id="natMovimiento${status.count}" name="natMovimiento" size="8" align="right"
				         			value="ABONO" readOnly="true" disabled="true" /> 
				     		</td>
						  	</c:if> 
						  	<td> 
								<input style="text-align:right" id="cantidad${status.count}" name="cantidad" size="15" 
										value="${amortiFondeo.cantidad}" readOnly="true" disabled="true" esMoneda="true"/> 
						  	</td> 
				     						         	 
						</tr>
					</c:forEach>
				</tbody>
				
			</table>
		</fieldset>
	
</form>

</body>
</html>

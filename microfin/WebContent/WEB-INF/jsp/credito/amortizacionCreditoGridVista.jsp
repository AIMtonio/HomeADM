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
		<legend>Amortizaciones</legend>	
	
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label"> 
					   	<label for="lblNumero">Numero</label> 
						</td>
						<td class="label"> 
					   	<label for="lblNumero">Fecha Incio</label> 
						</td>
						<td class="label"> 
							<label for="lblCR">fecha Vencimiento</label> 
				  		</td>	
						<td class="label"> 
							<label for="lblCuenta">fecha pago</label> 
				  		</td>
				  		<td class="label"> 
			         	<label for="lblReferencia">Capital</label> 
			     		</td> 
			     		<td class="label"> 
			         	<label for="lblDescripcion">Interes</label> 
			     		</td> 
			     		<td class="label"> 
			         	<label for="lblCargos">iva Interes</label> 
			     		</td> 
			     		<td class="label"> 
			         	<label for="lblAbonos">total Pago</label> 
			     		</td> 
			     		<td class="label"> 
			         	<label for="lblAbonos">saldo Insoluto</label> 
			     		</td> 
					</tr>
					
					<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td> 
								<input id="consecutivoID${status.count}"  name="consecutivoID" size="6"  
										value="${status.count}" readOnly="true" disabled="true"/> 
						  	</td> 
							<td> 
								<input id="fechaInicio${status.count}"  name="fechaInicio" size="6"  
										value="${amortizacion.fechaInicio}" readOnly="true" disabled="true"/> 
						  	</td> 
						  	<td> 
								<input id1="fechaVencim${status.count}" name="fechaVencim" size="6" 
										value="${amortizacion.fechaVencim}" readOnly="true" disabled="true"/> 
						  	</td> 
						  	<td> 
								<input id="fechaExigible${status.count}" name="fechaExigible" size="20" 
										value="${amortizacion.fechaExigible}" readOnly="true" disabled="true"/> 
						  	</td> 
						  	<td> 
								<input id="capital${status.count}" name="capital" size="7" 
										value="${amortizacion.capital}" readOnly="true" disabled="true"/> 
						  	</td> 
				     		<td> 
				         	<input id="interes${status.count}" name="interes" size="60"
				         			value="${amortizacion.interes}" readOnly="true" disabled="true"/> 
				     		</td> 
							<td> 
				         	<input id="ivaInteres${status.count}" name="ivaInteres" size="11" align="right"
				         			value="${amortizacion.ivaInteres}" readOnly="true" disabled="true" esMoneda="true"/> 
				     		</td> 
				     		<td> 
				         	<input id="totalPago${status.count}" name="totalPago" size="11" align="right"
				         			value="${amortizacion.totalPago}" readOnly="true" disabled="true" esMoneda="true"/> 
				     		</td> 
				     		<td> 
				         	<input id="saldoInsoluto${status.count}" name="saldoInsoluto" size="11" align="right"
				         			value="${amortizacion.saldoInsoluto}" readOnly="true" disabled="true" esMoneda="true"/> 
				     		</td> 
						</tr>
					</c:forEach>
				</tbody>
				
			</table>
		</fieldset>
	
</form>

</body>
</html>

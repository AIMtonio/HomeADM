<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>

</head>
<body>

<c:set var="listaMovil"  value="${listaMovil}"/>
<c:set var="listaSafi"  value="${listaSafi}"/>

<tr id="gridConcialiadoPagos">
	<td>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend><label>Pagos APP</label></legend>
	 			<table width="100%">
					<tr id="encabezadoLista">
						<td class="label" align="center">Credito</td>
						<td class="label" align="center">Transaccion</td>
						<td class="label" align="center">Monto</td>
						<td class="label" align="center">Fecha Operacion</td>
						<td class="label" align="center">Asesor</td>							
						<td class="label" align="center">Conciliado</td>
					</tr>
					<c:forEach items="${listaMovil}" var="pagos" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td> 
								<input id="creditoID_M${status.count}"  name="creditoID" size="12" value="${pagos.creditoID}" readOnly="true" disabled="true"/> 
						  	</td>
						  	<td> 
								<input id="transaccion_M${status.count}"  name="transaccion" size="12" value="${pagos.transaccion}" readOnly="true" disabled="true"/> 
						  	</td>
						  	<td> 
								<input id="monto_M${status.count}"  name="monto" size="12" value="${pagos.monto}" readOnly="true" disabled="true"/> 
						  	</td>
						  	<td> 
								<input id="fecha_M${status.count}"  name="fecha" size="20" value="${pagos.fechaOperacion}" readOnly="true" disabled="true"/> 
						  	</td>
						  	<td> 
								<input id="asesor_M${status.count}"  name="asesor" size="17" value="${pagos.claveProm}" readOnly="true" disabled="true"/> 
						  	</td>
						  	<td align="center"> 
						  									
								<c:if test = "${pagos.conciliado == 'S' }">
									<input type="checkbox" id="conciliado_M" checked="checked" disabled="disabled" />
						  		</c:if>	
						  		<c:if test = "${pagos.conciliado == 'N' }">	
						  			<input type="checkbox" id="conciliado_M" disabled="disabled" />
						  		</c:if>
								
						  	</td> 
						</tr>
					</c:forEach>
					
				</table>
		</fieldset>
	</td>
	<td>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend><label>Pagos SAFI</label></legend>
			 <table width="100%">
				<tr id="encabezadoLista">
					<td class="label" align="center">Credito</td>
					<td class="label" align="center">Transaccion</td>
					<td class="label" align="center">Monto</td>
					<td class="label" align="center">Fecha Operacion</td>
					<td class="label" align="center">Asesor</td>							
				</tr>
				<c:forEach items="${listaSafi}" var="pagos" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td> 
								<input id="creditoID_S${status.count}"  name="creditoID" size="12" value="${pagos.creditoID}" readOnly="true" disabled="true"/> 
						  	</td>
						  	<td> 
								<input id="transaccion_S${status.count}"  name="transaccion" size="12" value="${pagos.transaccion}" readOnly="true" disabled="true"/> 
						  	</td>
						  	<td> 
								<input id="monto_S${status.count}"  name="monto" size="12" value="${pagos.monto}" readOnly="true" disabled="true"/> 
						  	</td>
						  	<td> 
								<input id="fecha_S${status.count}"  name="fecha" size="20" value="${pagos.fechaOperacion}" readOnly="true" disabled="true"/> 
						  	</td>
						  	<td> 
								<input id="asesor_S${status.count}"  name="asesor" size="17" value="${pagos.claveProm}" readOnly="true" disabled="true"/> 
						  	</td>
						</tr>
					</c:forEach>
			</table>
	</fieldset>
	</td>	
</tr>

</body>
</html>

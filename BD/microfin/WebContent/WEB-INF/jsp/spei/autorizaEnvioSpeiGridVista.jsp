<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<form id="autorizaEnvioSpeiBean" name="autorizaEnvioSpeiBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '3'}">			  	
				  	<tr id="encabezadoLista">
						<td></td>
						<td></td>
						<td>Folio</td>
						<td>Cuenta Origen</td>
						<td>Cuenta Destino</td>
						<td>Nombre Beneficiario</td>
						<td align="center">Monto</td>
						<td><input type="checkbox" id="seleccionaTodos" name="seleccionaTod" onclick="selecTodoCheckout(this.id), checkTodosSumaMonto();"></td>
					</tr>
					<c:forEach items="${listaResultado}" var="pago" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td> 
							<input id="consecutivoID${status.count}"  name="consecutivoID" size="3"  
										value="${status.count}" readOnly="true" disabled="true" type="hidden" style='text-align:left;' /> 										
						</td> 
						<td> 
							<input type="hidden" id="claveRastreo${status.count}" name="claveRastreo" size="10" 
										 value="${pago.claveRastreo}" readOnly="true" disabled="true" style='text-align:left;' /> 
						</td>
						<td> 
							<input type="text" id="folioSpeiID${status.count}" name="folioSpeiID" size="10" 
										 value="${pago.folioSpeiID}" readOnly="true" disabled="true" style='text-align:left;' /> 
						</td>
						<td>  
							<input type="text" id="cuentaOrd${status.count}"  name="cuentaOrd" size="25"  
										  value="${pago.cuentaOrd}"readOnly="true" disabled="true" style='text-align:left;' /> 
						</td>  
						<td> 
						 	<input type="text" id="cuentaBeneficiario${status.count}" name="cuentaBeneficiario" size="25" 
										value="${pago.cuentaBeneficiario}" readOnly="true" disabled="true" style='text-align:left;' /> 
						</td> 
						<td> 
							<input type="text" id="nombreBeneficiario${status.count}"  name="nombreBeneficiario" size="46"  
									  value="${pago.nombreBeneficiario}" readOnly="true" disabled="true" style='text-align:left;' /> 
						</td>
						<td> 
							<input type="text" id="monto${status.count}"  name="monto" size="15" esMoneda="true"
									  value="${pago.monto}" readOnly="true" style='text-align:right;' /> 
						</td>
					
						<td align="center"><input type="checkbox" id="enviar${status.count}" name="enviar" onclick="habilitaLimpiar(this.id), sumaMonto();" style='text-align:center;'/> 
						</td>
					
						
						 
				 	</tr>
			
					</c:forEach>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>
		
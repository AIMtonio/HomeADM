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
<br/>

<c:set var="giroNegocio"  value="${listaResultado}"/>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Giros</legend>
		<input type="button" id="agregaGiro" name="agregaGiro" value="Agregar" class="botonGral" tabindex="3"  onClick="agregarGiroNegocio()"/>
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label" align="center"> 
					   		<label for="lblNumGiro">Giro</label> 
						</td>
						<td class="label" align="center"> 
					   		<label for="lblDescripGiro">Descripción</label> 
						</td>
						
						<td class="label"> 
					   		<label for="lbl"></label> 
						</td>
					</tr>					
					<c:forEach items="${giroNegocio}" var="giro" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td>
								<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID" size="6" 
										value="${status.count}" />	
								</td> 
								<td>											
						  		<input  type="text" id="giroID${status.count}" name="lnumGiro" size="6" value="${giro.giroID}" onkeypress="listaGiros(this.id)" onblur="validaGiroTarjeta(this.id);"  /> 
								
						  	</td> 
						  	<td> 
								<input  type="text" id="descripcion${status.count}" name="ldescripGiro" size="60" readOnly="true"	value="${giro.descripcion}"/> 							 							
						  	</td> 	
						  	<td>
						  		<input type="button" name="eliminar" id="${status.count}"  value="" class="btnElimina" onclick="eliminarGiroNegocio(this.id)" /></td>
						  		<td> <input type="button" name="agrega" id="agrega${status.count}"  value="" class="btnAgrega" onclick="agregarGiroNegocio()"/>
						  	</td>
						  	<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID" size="6" value="${status.count}" />	
						  	<input type="hidden" id="giros${status.count}" name="lgiros" value="${giros.giroID}" />	
						  						
						</tr>
						
						
					</c:forEach>
				
				</tbody>

			</table>
			</fieldset>
			
			 <input type="hidden" value="0" name="numero" id="numero" />


</body>
</html>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
	<body>
	<c:set var="girosTarjeta"  value="${listaResultado}"/>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">   
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label" align="center">
					   		<label for="lblGiros">Giro</label> 
						</td>
						<td class="label" align="center">
					   		<label for="lblDescripcion">Descripción</label> 
						</td>
						
					</tr>
				<c:forEach items="${girosTarjeta}" var="giros" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td> 
								<input type="text" id="giroID${status.count}" name="lgiroID" size="5" value="${giros.giroID}" onkeypress="listaGiros(this.id)" onblur="validaGiroTarjeta(this.id)" />   
						  	</td> 
						  	<td> 
								<input  type="text" id="descripcion${status.count}" name="ldescripcion" size="62" value="${giros.descripcion}" readOnly="true" /> 							 							
						  	</td> 	
						  	<td>
						  		<input type="button" name="eliminar" id="${status.count}"  value="" class="btnElimina" onclick="eliminarGirosAceptados(this.id)" />
						  		 <input type="button" name="agrega" id="agrega${status.count}"  value="" class="btnAgrega" onclick="agregarGirosAceptados()"/>
						  	</td>
						  		<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID" size="6" value="${status.count}" />	
						  		<input type="hidden" id="giros${status.count}" name="lgiros" value="${giros.giroID}" />			  						
						</tr>								
					</c:forEach>			
			</table>
		</fieldset>
			 <input type="hidden" value="0" name="numero" id="numero" />
	</body>
</html>	
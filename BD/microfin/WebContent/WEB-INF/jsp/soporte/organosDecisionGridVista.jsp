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

<c:set var="listaResultado"  value="${listaResultado}"/>	
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Facultados</legend>			
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label"> 
					   	<label for="organoID">Número</label> 
						</td>
						<td class="label"> 
					   	<label for="descripcion">Descripción</label> 
						</td>									  			
					</tr>					
					<c:forEach items="${listaResultado}" var="organoDecision" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td>
								<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID" size="6" value="${status.count}" />								
 								<input type="text" id="organoID${status.count}" name="organo" size="6" value="${organoDecision.organoID}" readOnly="true" disabled="true" />   								
						  	</td> 
						 
						  	<td> 
								<input  type="text" id="descripcion${status.count}" name="des" size="50" 
										value="${organoDecision.descripcion}" onBlur=" ponerMayusculas(this)" readOnly="true" disabled="true" /> 							 							
						  	</td> 	
						  					
						</tr>
						
						
					</c:forEach>
				</tbody>
				<tr align="right">
					<td class="label" colspan="5"> 
				   	<br>
			     	</td>
				</tr>
			</table>
			</fieldset>																				
			 <input type="hidden" value="0" name="numeroOrgano" id="numeroOrgano" />
	
	

</body>
</html>

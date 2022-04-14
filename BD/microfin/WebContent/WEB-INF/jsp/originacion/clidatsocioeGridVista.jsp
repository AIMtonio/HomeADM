<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>
<br>
<div id="gridDatosSocioeco" >
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Económicos Mensuales</legend>	
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '2'}">
				
					<tr>
					<table id="ingresos" border="0" cellpadding="0" cellspacing="0" width="50%" align="left">
					<tr>
						<td class="label"> 
					   	<center><label for="lblSolicitudCre">Ingresos</label> </center>
						</td>
				  	</tr>
					
					<c:forEach items="${listaResultado}" var="socioeconomicos" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<c:if test="${socioeconomicos.tipo == 'I'}">
						  	<td class="label">
								<input id="socioEID${status.count}" name="LSocioEID" size="12" value="${socioeconomicos.socioEID}"  type="hidden" /> 		
								<input id="consecutivoID${status.count}"  name="consecutivoID" size="6"  
										value="${status.count}" readOnly="true" disabled="true" type="hidden" /> 
						  		<input id="catSocioEID${status.count}" name="LcatSocioEID" size="12" value="${socioeconomicos.catSocioEID}"  type="hidden" /> 
						  		<input id="tipo${status.count}" name="tipo" size="12" value="${socioeconomicos.tipo}"  type="hidden" /> 
						  		<label for="lblSolicitudCre">${socioeconomicos.descripcion}:</label>
						  	</td>
						  	<td class="label">
								<input id="monto${status.count}" name="Lmonto" size="12" value="${socioeconomicos.monto}" tabindex="7"  esMoneda="true"  style='text-align:right;'
								 onblur="calculaTotalesIngEgre()";    /> 
						  	</td>	
						  	 </c:if> 		
				     	</tr>
				   
					</c:forEach>
						<tr >
							
						  	<td class="label">
						  		 <label for="lblTotalIngresos">Total:</label>
						  	</td>
						  	<td class="label">
								<input id="totalIngresos" name="totalIngresos" size="12"  esMoneda="true" disabled = "true" style='text-align:right;' /> 
						  	</td>	
						  			
				     	</tr>
				   
				 </table>
				</tr>
				<tr>
					<table id="egresos" border="0" cellpadding="0" cellspacing="0" width="50%" align="left">
					<tr>
					
						<td class="label"> 
						<center>	<label for="lblClienteID">Egresos</label> </center> 
				  		</td>
				  		
				  	</tr>
					
					<c:forEach items="${listaResultado}" var="socioeconomicos" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">	
							<c:if test="${socioeconomicos.tipo == 'E'}">
						  	<td class="label">
							<input id="socioEID${status.count}" name="LSocioEID" size="12" value="${socioeconomicos.socioEID}"  type="hidden" /> 
						  	<input id="consecutivoID${status.count}"  name="consecutivoID" size="6"  
										value="${status.count}" readOnly="true" disabled="true" type="hidden" /> 
						  	<input id="catSocioEID${status.count}" name="LcatSocioEID" size="12" value="${socioeconomicos.catSocioEID}" type="hidden" />
							<input id="tipo${status.count}" name="tipo" size="12" value="${socioeconomicos.tipo}"  type="hidden" />  
						  		 <label for="lblSolicitudCre">${socioeconomicos.descripcion}:</label>
						  </td>
						  <td class="label">
								<input id="monto${status.count}" name="Lmonto" size="12" value="${socioeconomicos.monto}" tabindex="7"  esMoneda="true"   style='text-align:right;' 
								onblur="calculaTotalesIngEgre()"  /> 
						  	</td>	
						  	 </c:if> 	
				     	</tr>
				   
					</c:forEach>
						<tr >
							
						  	<td class="label">
						  		 <label for="lblTotalEgresos">Total:</label>
						  	</td>
						  	<td class="label">
								<input id="totalEgresos" name="totalEgresos" size="12"  esMoneda="true" disabled = "true" style='text-align:right;' /> 
						  	</td>	
						  			
				     	</tr>
				 </table>
				</tr>
				
			</table>
				</c:when>
			</c:choose>
		</fieldset>
	
 </div>

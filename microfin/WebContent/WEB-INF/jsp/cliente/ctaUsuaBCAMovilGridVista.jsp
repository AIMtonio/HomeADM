<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<form id="cuentasBCAMovilBean" name="cuentasBCAMovilBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '2' || tipoLista == '5'}">			  	
				  	<tr id="encabezadoLista">					  					  				
						<th>Núm</th>						
						<th>Cuenta Principal</th>
						<th>Usuario PDM</th>
						<th>Teléfono</th>
						<th>Fecha Registro</th>
						<th>Estatus</th>
					</tr>
					<c:forEach items="${listaResultado}" var="result" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">										
						<td> 
							<input id="consecutivoID${status.count}"  name="consecutivoID" size="6"  
										value="${status.count}" readOnly="true" disabled="true" type="text" style="text-align:left;" /> 										
						</td> 	
						<td> 
							<input type="text" id="cuentaAhoIDG${status.count}"  name="cuentaAhoIDG" size="26"  
									  value="${result.cuentaAhoID}" readOnly="true" disabled="true" style="text-align:left;" /> 
						</td>					
						<td> 
							<input type="text" id="usuarioPDMID${status.count}"  name="usuarioPDMID" size="16"  
									  value="${result.usuarioPDMID}" readOnly="true" disabled="true" style="text-align:left;" /> 
						</td>
						<td> 
							<input type="text" id="telefonoBD${status.count}"  name="telefonoBD" size="16"
									  value="${result.telefono}" readOnly="true" disabled="true"  style="text-align:left;" /> 
						</td>					
						<td>
							 <input type="text" id="fechaRegistro${status.count}"  name="fechaRegistro" size="21"
									  value="${result.fechaRegistro}" readOnly="true" disabled="true" style="text-align:left;" /> 
						</td>	
						<c:if test="${result.estatus == 'A'}">
						<td>
							 <input type="text" id="estatus${status.count}"  name="estatus" size="10"
									  value="ACTIVA" readOnly="true" disabled="true" style="text-align:center;" /> 
						</td>
						</c:if> 
						<c:if test="${result.estatus == 'I'}">
						<td>
							 <input type="text" id="estatus${status.count}"  name="estatus" size="10"
									  value="INACTIVA" readOnly="true" disabled="true" style="text-align:center;" /> 
						</td>  
						</c:if>		
														 
				 	</tr>			
					</c:forEach>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>
		
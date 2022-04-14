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
<legend>Documentos de la Póliza</legend>		
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label"> 
					   	<label for="lblPoliza">Póliza </label> 
						</td>
						<td class="label"> 
					   	<label for="lblArchivoPoliza">Archivo</label> 
						</td>
					
				  		<td class="label"> 
							<label for="lblObservacion">Observación</label>
				  		</td>
				  		<td class="label"> 
							<label for="lblRecurso">Recurso</label>  
				  		</td>
				  			
					</tr>					
					<c:forEach items="${listaResultado}" var="polizaArchivo" varStatus="status">
						<tr id="renglon${status.count}" name="renglonP">
							<td>
								<input type="hidden" id="consecutivo${status.count}" name="consecutivo" size="6" value="${status.count}" />								
								<input  type="text" id="poliza${status.count}" name="poliza" size="6" value="${polizaArchivo.polizaID}" readOnly="true" disabled="true" />																	   						
						  	</td> 
						 
						  	<td> 
								<input  type="text" id="archivoPolizas${status.count}" name="archivoPolizas" size="6" 	value="${polizaArchivo.archivoPolID}" readOnly="true"  disabled="true" /> 							 							
						  	</td> 	
						  
						  	<td> 
								<input type="text" id="observaciones${status.count}" name="observaciones" size="50" value="${polizaArchivo.observacion}" readOnly="true"disabled="true" disabled="true"/>  																									 						
						  	</td> 
						  	<td> 
								<input type="text" id="recursos${status.count}" name="recursos" size="50" value="${polizaArchivo.recurso}" readOnly="true" disabled="true"/>
								  																									 						
						  	</td>
						  	<td>
						  		<c:set var="varRecursoPoliza"  value="${polizaArchivo.recurso}"/>
							 	<input id="recursoPolizaInput${status.count}"  name="recursoPolizaInput" size="7" tabindex="1" value="${varRecursoPoliza}" readOnly="true" type="hidden"/> 	
								<input type="button" name="verArchivoPoliza" id="verArchivoPoliza${status.count}" class="submit" value="Ver" onclick="verArchivo(${status.count},'${polizaArchivo.recurso}')"/>
						  	</td> 
						  	<td> 
						  		<input  type="button" name="elimina" id="elimina${status.count}" class="btnElimina" value="" onclick="eliminaArchivo(${polizaArchivo.polizaArchivosID})"/>
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
</body>
</html>


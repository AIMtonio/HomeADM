<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="clienteArchivo" value="${listaResultado[1]}"/>
	
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend>Documentos del <s:message code="safilocale.cliente"/></legend>	
<table border="0" cellpadding="0" cellspacing="0" width="100%"> 
	<c:choose>
		<c:when test="${tipoLista == '1'}">		
			<tr>
				<td class="label"> 
					<label for="lblNo">Número</label> 
				</td> 	
				<td class="label"> 
					<label for="lblObservacion"> Observaci&oacute;n</label> 
			  	</td>
			  	<td class="label"> 
		        	<label for="lblDocumento">Ver</label> 
		     	</td> 
		     	<td class="separador"></td> 
		 	</tr>
		    
		    <c:forEach items="${clienteArchivo}" var="clienteArchi" varStatus="status"> 
			<tr>
				<td> 
					<input id="clienteArchivosID${status.count}"  name="clienteArchivosID" size="7" tabindex="1" 
									value="${clienteArchi.clienteArchivosID}" readOnly="true"/> 
				</td> 
				<td> 
					<textarea id="observacion${status.count}" name="observacion" cols="35" rows="2"
									tabindex="2"  readOnly="true">${clienteArchi.observacion}</textarea> 
				</td>   
				<td>
					<c:set var="varRecursoCte"  value="${clienteArchi.recurso}"/>
					<input id="recursoCteInput${status.count}"  name="recursoCteInput" size="7" tabindex="3" 
								value="${varRecursoCte}" readOnly="true" type="hidden"/>
					<input type="button" name="verArchivoCte" id="verArchivoCte${status.count}" class="submit" value="Ver" onclick="verArchivosCliente(${status.count},${clienteArchi.tipoDocumento},${clienteArchi.clienteArchivosID},'${clienteArchi.recurso}')"/>
				</td> 
				<td> 
					<input type="button" name="elimina" id="elimina${status.count}" class="btnElimina" value="" onclick="eliminaArchivo(${clienteArchi.clienteArchivosID})"/>
		    				
				</td> 
				
				
		    </tr>
			</c:forEach>	
		</c:when>

		<c:when test="${tipoLista == '2'}">	
			<tr>
				<td class="label"> 
					<label for="lblNo">Número</label> 
				</td> 	
				<td class="label"> 
					<label for="lblObservacion"> Observaci&oacute;n</label> 
			  	</td>
		     	<td class="label"> 
		        	<label for="lbl">Ver</label> 
		     	</td> 
		 	</tr>
		    
		    <c:forEach items="${clienteArchivo}" var="clienteArchi" varStatus="status"> 
			<tr>
				<td> 
					<input id="clienteArchivosID"  name="clienteArchivosID" size="7" tabindex="1" 
									value="${clienteArchi.clienteArchivosID}" readOnly="true"/> 
				</td> 
				<td> 
					<textarea id="observacion${status.count}" name="observacion" cols="35" rows="2"
									tabindex="2"  readOnly="true">${clienteArchi.observacion}</textarea> 
				</td> 
				<td>
					<c:set var="varRecursoCte"  value="${clienteArchi.recurso}"/>
					<input id="recursoCteInput${status.count}"  name="recursoCteInput" size="7" tabindex="1" 
								value="${varRecursoCte}" readOnly="true" type="hidden"/> 	
					<input type="button" name="verArchivoCte" id="verArchivoCte${status.count}" class="submit" value="Ver" onclick="verArchivosCliente(${status.count},${clienteArchi.tipoDocumento},${clienteArchi.clienteArchivosID},'${clienteArchi.recurso}')"/>
				</td> 
		    </tr>
			</c:forEach>
		</c:when>
		</c:choose>
</table>
</fieldset>


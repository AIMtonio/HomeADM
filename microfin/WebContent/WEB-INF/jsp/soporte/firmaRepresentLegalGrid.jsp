<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<c:set var="firmaArchivo"  value="${firmaArchivo}"/>

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend>Firmas del Representante Legal</legend>	
	<table border="0" cellpadding="0" cellspacing="0" width="100%"> 		
		<tr>
			<td class="label"> 
				<label for="lblNo">Número</label> 
			</td> 	
			<td class="label"> 
				<label for="lblObservacion"> Observación</label> 
			</td>
			<td class="label"> 
				<label for="lblDocumento">Ver</label> 
			</td> 
			<td class="separador"></td> 
		</tr>
		<c:forEach items="${firmaArchivo}" var="firmaArch" varStatus="status"> 
		<tr>
			<td> 
				<input id="consecutivo${status.count}"  name="consecutivo" size="7" tabindex="1" 
					value="${firmaArch.consecutivo}" readOnly="true"/> 
			</td> 
			<td> 
				<textarea id="observacion${status.count}" name="nameobservacion" cols="35" rows="2"
					tabindex="2"  readOnly="true">${firmaArch.observacion}</textarea> 
			</td>
			<td>
				<c:set var="varRecurso"  value="${firmaArch.recurso}"/>
				<input id="recursoInput${status.count}"  name="recursoInput" size="7" tabindex="1" 
									value="${varRecurso}" readOnly="true" type="hidden"/> 	
				<input type="button" name="verArchivo" id="verArchivo${status.count}" class="submit" value="Ver" onclick="verArchivoFirma('${status.count}')"/>
			</td> 
			<td> 
				<input  type="button" name="elimina" id="elimina${status.count}" class="btnElimina" value="" onclick="eliminaArchivo(${status.count})"/>					
			</td> 
		</tr>
		</c:forEach>	
		<tr>
			<td>
			</td>
		</tr>
	</table>
</fieldset>
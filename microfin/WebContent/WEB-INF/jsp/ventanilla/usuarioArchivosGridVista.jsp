<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<c:set var="usuarioArchivo"  value="${usuarioArchivo}"/>

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend>Documentos del Usuario de Servicios</legend>	
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
		<c:forEach items="${usuarioArchivo}" var="usuarioArchi" varStatus="status"> 
		<tr>
			<td> 
				<input id="usuarioArchivoID${status.count}"  name="clienteArchivoID" size="7" tabindex="82" 
					value="${usuarioArchi.usuarioArchivoID}" readOnly="true"/> 
			</td> 
			<td> 
				<textarea id="observacion${status.count}" name="observacion" cols="35" rows="2"
					tabindex="82"  readOnly="true">${usuarioArchi.observacion}</textarea> 
			</td>
			<td>
				<c:set var="varRecursoUsr"  value="${usuarioArchi.recurso}"/>
				<input id="recursoUsrInput${status.count}"  name="recursoUsrInput" size="7" tabindex="83" 
					value="${varRecursoUsr}" readOnly="true" type="hidden"/> 	
				<input type="button" name="verArchivoUsr" id="verArchivoUsr${status.count}" class="submit" value="Ver" onclick="verArchivosUsuario(${status.count},${usuarioArchi.tipoDocumento},${usuarioArchi.usuarioArchivoID},'${usuarioArchi.recurso}')"/>
			</td> 
			<td> 
				<input  type="button" name="elimina" id="elimina${status.count}" class="btnElimina" value="" onclick="eliminaArchivo(${usuarioArchi.usuarioArchivoID})"/>					
			</td> 
		</tr>
		</c:forEach>	
		<tr>
			<td>
			</td>
		</tr>
	</table>
</fieldset>
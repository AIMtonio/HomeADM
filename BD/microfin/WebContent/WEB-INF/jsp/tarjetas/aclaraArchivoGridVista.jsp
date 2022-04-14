<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
	<body>
		<c:set var="aclaraArchivo"  value="${aclaraArchivo}"/>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<table id="tablaArchivos">
					<tr> 
						<td class="label" nowrap="nowrap" align="center">
							<label for="folio">Folio</label>
						</td>
						<td class="label" nowrap="nowrap" align="center">
							<label for="comentarios">Comentarios </label>
						</td>
						<td class="label" nowrap="nowrap" align="center">
							<label for="visualizar">Visualizar </label>
						</td>
						<td class="label" nowrap="nowrap" align="center">
							<label for="registro">Registro </label>
						</td>
						<td class="label" nowrap="nowrap" align="center">
						<label for="eliminar">Eliminar </label>
						</td>
					</tr>
		    		<c:forEach items="${aclaraArchivo}" var="aclaraArchi" varStatus="status"> 
					<tr id = "registro${status.count}" name="registro">
						<td> 
							<input id="folioID${status.count}"  name="folioID" size="10" value="${aclaraArchi.folioID}" readOnly="true"/> 
						</td> 
						<td>
							<input id="tipoArchivo${status.count}" name="tipoArchivo" size="60" value="${aclaraArchi.tipoArchivo}"readOnly="true"/> 
						</td> 
						<td> 
							<a id="enlaceAclara${status.count}" href="aclaraVerArchivos.htm" target="_blank">
								<input type="button" id="ver${status.count}" name="ver" class="submit" value="Ver" autocomplete="off" onclick="verArchivosAclara(this.id)"/> 
							</a> 
						</td>
						<td>							
							<input id="fechaRegistro${status.count}" name="fechaRegistro"  size="10" value="${aclaraArchi.fechaRegistro}"readOnly="true"/>
						</td>  
			  			<td align="center"> 
							<input type="button" id="${status.count}" name="eliminar" class="btnElimina" onclick="eliminaArchivo(this)"/>
						</td>
						<input type="hidden" id="ruta${status.count}" name="ruta"  value="${aclaraArchi.ruta}"readOnly="true"/>
						<input type="hidden" id="nombreArchivo${status.count}" name="nombreArchivo"  value="${aclaraArchi.nombreArchivo}"readOnly="true"/>
					</tr>
				</c:forEach>	
			</table>
		</fieldset>
	</body>
</html>
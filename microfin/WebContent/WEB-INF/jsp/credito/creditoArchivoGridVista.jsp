<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
 <script type="text/javascript" src="js/jquery.lightbox-0.5.pack.js"></script>
    <link rel="stylesheet" type="text/css" href="css/jquery.lightbox-0.5.css" media="screen" />
<c:set var="listaResultado"  value="${listaResultado}" />
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Documentos del Crédito</legend>	
			<table border="0" cellpadding="0" cellspacing="0" width="100%"> 		
				<tr>
					<td class="label"> 
						<label for="lblNo">N&uacute;mero</label> 
					</td> 	
					<td class="label"> 
						<label for="lblComentario"> Observación</label> 
				  	</td>
				  	<td class="label"> 
			        	<label for="lblFecha">Ver</label> 
			     	</td> 
				 
			     	<td class="separador"></td> 
			 	</tr>
			    
			    <c:forEach items="${listaResultado}" var="listaResultado" varStatus="status"> 
				<tr>
					<td> 
						<input id="digCreaID${status.count}"  name="digCreaID" size="7" tabindex="1" 
										value="${listaResultado.digCreaID}" readOnly="true"/> 
					</td> 
					<td> 
						<textarea id="comentario${status.count}" name="comentario" cols="35" rows="2"
										tabindex="2"  readOnly="true">${listaResultado.comentario}</textarea> 
					</td>
				
					<td>
					<c:set var="varRecursoCred"  value="${listaResultado.recurso}"/>
						<input id="recursoCreInput${status.count}"  name="recursoCreInput" size="7" tabindex="1" 
										value="${varRecursoCred}" readOnly="true" type="hidden"/> 	
						<input type="button" name="verArchivoCre" id="verArchivoCre${status.count}" class="submit" value="Ver" onclick="verArchivosCredito(${status.count},${listaResultado.tipoDocumentoID},${listaResultado.digCreaID},'${listaResultado.recurso}')"/>
					</td> 
					<td> 
						<input type="button" name="elimina" id="elimina${status.count}" class="btnElimina" value="" onclick="eliminaArchivo(${listaResultado.digCreaID},'${listaResultado.descTipoDoc}')"/>	
					</td> 
			    </tr>
				</c:forEach>	
				<tr>
					<td>
						
					</td>
				</tr>
				
			</table>
		</fieldset>
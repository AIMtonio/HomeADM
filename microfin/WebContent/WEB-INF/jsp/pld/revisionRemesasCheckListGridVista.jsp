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
		<legend>Check List</legend>
			<input type="button" id="agregar" name="agregar" value="Nuevo" class="submit" onClick="agregarDocumentos()" tabindex="5" />	
			<table id="miTabla"> 		
				<tr>
					<td nowrap="nowrap" class="label" align="left">
						<label for="lblNo">N&uacute;m.</label> 
					</td> 
					<td nowrap="nowrap" class="label" align="left">
						<label for="lblTipoDocumento">Tipo Documento</label> 
					</td> 	
					<td nowrap="nowrap" class="label" align="left">
						<label for="lblComentario">Descripci&oacute;n Documento</label> 
				  	</td>
				  	<td nowrap="nowrap" class="label" align="left">
						<label for="lblComentario"> Descripci&oacute;n</label> 
				  	</td>
				  	<td class="label" nowrap="nowrap"> 
			        	<label for="lblVer"></label> 
			     	</td> 
			     	<td class="label" nowrap="nowrap"> 
			        	<label for="lblAdjuntar"></label> 
			     	</td> 
			 	</tr>
			    
			    <c:forEach items="${listaResultado}" var="documentos" varStatus="status"> 
				<tr id="renglon${status.count}" name="renglon">
					<td nowrap="nowrap"> 
						<input type="text" id="checkListRemWSID${status.count}"  name="checkListRemWSID" size="10" tabindex="90" value="${documentos.checkListRemWSID}" readOnly="true" disabled="true" autocomplete="off"/> 
					</td>
					<td nowrap="nowrap">
						<input type="text" id="tipoDocumentoID${status.count}" name="tipoDocumentoID" size="10" value="${documentos.tipoDocumentoID}" readOnly="true" autocomplete="off"/>
					</td>
					<td nowrap="nowrap">
						<input type="text" id="descripcion${status.count}" name="descripcion" size="60" maxlength="60" value="${documentos.descripcion}" readOnly="true" disabled="true" autocomplete="off"/>
					</td>
					<td nowrap="nowrap">
						<textarea id="descripcionDoc${status.count}" name="descripcionDoc" cols="35" rows="2" maxlength="200" readOnly="true" disabled="true" autocomplete="off">${documentos.descripcionDoc}</textarea> 
					</td>
					<td nowrap="nowrap">
						<c:set var="varRecursoRemesas"  value="${documentos.recurso}"/>
						<input id="recursoRemesasInput${status.count}"  name="recursoRemesasInput" size="7" value="${varRecursoRemesas}" readOnly="true" type="hidden"/> 	
						<input type="button" id="ver${status.count}" name="ver" class="submit" value="Ver" onclick="verDocumentoRemesa(${status.count},${documentos.checkListRemWSID},'${documentos.recurso}')"/>
					</td> 
					<td nowrap="nowrap">
						<input type="button" id="adjuntar${status.count}" name="adjuntar" class="submit" value="Adjuntar" onclick="adjuntarDocumentoRemesa(${status.count},${documentos.checkListRemWSID},${documentos.tipoDocumentoID},'${documentos.descripcion}')"/>
					</td> 
			    </tr>
				</c:forEach>
			</table>
		</fieldset>
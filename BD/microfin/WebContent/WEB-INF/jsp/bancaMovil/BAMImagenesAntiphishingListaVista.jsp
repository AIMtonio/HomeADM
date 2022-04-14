<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<script type="text/javascript" src="dwr/interface/imagenAntiphishingServicio.js"></script>  

  <script type="text/javascript">
	$(function() {
        $('#gridArchivosCta a').lightBox();
    });

    	$(function() {
           	$("#nuevaImagen").focus();
    });


</script>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="imagenes" value="${listaResultado[1]}"/>
<c:set var="identificador" value="${listaResultado[2]}"/>

<c:if test="${identificador == '1'}">
	
	<table id="tablaLista" border="0" cellpadding="0" cellspacing="0" width="100%">
		<c:choose>
		
	 	<c:when test="${tipoLista == '1'}"> 
				<td align="left">
				<input type="button" id="nuevaImagen" name="nuevaImagen" onclick="subirArchivos()" class="submit" value="Nueva Imagen" tabindex="4"/>		
				</td>
				<tr>
					<td class="label" align="center">Descripci&oacute;n</td>
					<td class="label" align="center">Ver</td>
			    </tr>
			    
				<c:forEach items="${imagenes}" var="imagen" >
						<tr>
						<!-- <td><input id="numero${imagen.imagenAntiphishingID}" size="7" readonly="true" value= "${imagen.imagenAntiphishingID}"/></td> -->
						<td><input id="descripcion" readonly="true" size="40" maxlength="100" value="${imagen.descripcion}"/></td>
						<td><input id="ver${imagen.imagenAntiphishingID}" class="submit" value="Ver" size="8px"
											onclick="verImagen(${imagen.imagenAntiphishingID})"/></td>
						<td><input type="button" name="elimina"
											id="elimina${status.count}" class="btnElimina"
											onclick="eliminaImagen(${imagen.imagenAntiphishingID})" /></td>
						</tr>	
				</c:forEach>
				<div id="imagenCte" style="display: none;">
					<img id="imgCliente" src="images/user.jpg"  border="2"  />
				</div>  
			</c:when>
		
		  	</c:choose>
		  	
	</table>
	
</c:if>
<c:if test="${identificador == '2'}">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Selecciona una Imágen</legend>
		<c:set var="fila"  value="0"/>
		<c:set var="columna" value="0"/>
		<table id="tabla1" width="100%">
			<tr id="${fila}tr"></tr>
			<c:forEach items="${imagenes}" var="imagen">
				<td><img id="${imagen.imagenAntiphishingID}" src="data:image/jpg;base64,${imagen.imagenBinaria}" width="300px" height="300px" onclick="cambiarImagen('${imagen.imagenBinaria}')"></img></td>
			</c:forEach>
		</table>
	</fieldset>
</c:if>


		
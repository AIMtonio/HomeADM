<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%> 

<c:set var="listaResultado" value="${listaResultado}"/>

<form id="formaGenerica1" name="formaGenerica1">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                

<div id="tableCon">	
	<table id="miTabla" border="0" > 
   		<tr id="filaSeleccionarTodos" name="filaSeleccionarTodos">
			<td  style="text-align: right;" colspan="5">
				<label for="lblSeleccionarTodos">Seleccionar Todos</label> 
			</td>
			<td style="text-align: center;">
				<input type="checkbox"  id="seleccionarTodos" name="seleccionarTodos" value="N"  tabindex="2" onclick="funcionSeleccionarTodosCheck(this.id)"/>
			</td>
   		</tr>
		<tr  id="encabezadoLista">
     		<td  style="text-align: center;">N&uacute;mero</td> 
    		<td class="label" style="text-align: center;">Destino</td> 
     		<td class="label" style="text-align: center;">Clasificaci&oacute;n</td> 
    		<td class="label" style="text-align: center;">Subclasificaci&oacute;n</td> 
     		<td class="label" style="text-align: center;">Descripci&oacute;n de  Subclasificaci&oacute;n</td> 
    		<td class="label" style="text-align: center;">Asignar</td> 
    	</tr>								
		<c:forEach items="${listaResultado}" var="listaDestinosProd" varStatus="status">
			<tr id="numero${status.count}" name="numero">
				<td  style="text-align: center;">
					<input type="text" id="consecutivoID${status.count}" name="consecutivoID" size="3" value="${status.count}" disabled="true"  />
				</td>
				<td style="text-align: center;">
					<input type="text" id="destinoCreID${status.count}"  value="${listaDestinosProd.destinoCreID}" name="listaDestinoCreID" size="6"  disabled="true" />			
				</td>
				<td>
					<textarea  id="descripcion${status.count}"  name="listaDescripcion" disabled="true"   rows="2" cols="45" style="overflow:auto;resize:none">${listaDestinosProd.descripcion}</textarea>			
				</td>
				<td style="text-align: center;">
					<input type="text" id="subClasifID${status.count}"  value="${listaDestinosProd.subClasifID}" name="listaSubClasifID" size="6" disabled="true"  />			
				</td>
				<td>
					<textarea id="descripClasifica${status.count}"  name="listaDescripClasifica" disabled="true"   rows="2" cols="45" style="overflow:auto;resize:none">${listaDestinosProd.descripClasifica}</textarea>			
				</td>
				<td style="text-align: center;">
					<c:choose>
						<c:when test="${listaDestinosProd.productoCreditoID == '0'}">
							<input type="checkbox"  id="asignar${status.count}" name="listaAsignar" value="0" onclick="funcionAsignaValorCheckAsignar(this.id,${status.count})" />
						</c:when>		
						<c:otherwise>
							<input type="checkbox"  id="asignar${status.count}" name="listaAsignar" value="${listaDestinosProd.destinoCreID}" checked="checked"  onclick="funcionAsignaValorCheckAsignar(this.id,${status.count})" />
						</c:otherwise>
					</c:choose>		
				</td>
     		</tr>		
		</c:forEach>							
	</table>  
</div>
</fieldset>
</form>
   

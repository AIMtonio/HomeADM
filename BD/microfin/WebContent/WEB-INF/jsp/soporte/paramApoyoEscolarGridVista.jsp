<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<form id="gridApoyoEscolar" name="gridApoyoEscolar">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<table id="tablaGridApoyo" border="0" cellpadding="0" cellspacing="0" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '1'}">
					<tr>
						<td class="label" align="center"><label for="descripcion">Grado Escolar</label></td>
						<td class="label" align="center"><label for="promedioMinimo">Promedio M&iacute;nimo</label></td>
						<td class="label" align="center"><label for="tipoCalculo">Tipo de C&aacute;lculo</label></td>
						<td class="label" align="center"><label for="cantidad">Cantidad</label></td>
						<td class="label" align="center"><label for="mesesAhorroCons">Meses de Ahorro Const. &nbsp;&nbsp;&nbsp;</label></td>
						<td class="label" align="center"><label for="paramApoyoEscID">Eliminar</label></td>
				  	</tr>
					<c:forEach items="${listaResultado}" var="apoyo" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td  align="center"> 
							<input type="text" id="descripcion${status.count}"  name="descripcion" size="40"  
										 value="${apoyo.descripcion}"  disabled="true"  readOnly="true" style='text-align:left;' />					
						</td> 
						<td  align="center"> 						
							<input type="text" id="promedioMinimo${status.count}" name="promedioMinimo" size="10" 
										 value="${apoyo.promedioMinimo}" disabled="true" readOnly="true" style="text-align:left;"/> 
						</td>
						<td  align="center">  
							<input type="text" id="tipoCalculo${status.count}"  name="tipoCalculo" size="35"  
										  value="${apoyo.tipoCalculo}" disabled="true" readOnly="true"  style='text-align:left;' /> 
						</td>  
						<td  align="center"> 
						 	<input type="text" id="cantidad${status.count}" name="cantidad" size="20" 
										value="${apoyo.cantidad}" disabled="true" readOnly="true" style='text-align:right;' esMoneda="true"/> 
						</td> 
						<td  align="center"> 
						 	<input type="text" id="mesesAhorroCons${status.count}" name="mesesAhorroCons" size="10" 
										value="${apoyo.mesesAhorroCons}" disabled="true" readOnly="true" style='text-align:left;'/> 
						</td> 
						<td  align="center">
							<input type="button" id="elimina" class="btnElimina" value="" onclick="eliminar(${apoyo.paramApoyoEscID})" />
						</td>						 
				 	</tr>
			
					</c:forEach>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>
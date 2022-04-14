<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

 
<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

	<fieldset class="ui-widget ui-widget-content ui-corner-all">   
	<legend>Sucursales</legend>             
		<table id="tablaGridSucursales" border="0" cellpadding="0" cellspacing="0" width="100%">
			<c:choose>
				<c:when test="${tipoLista >= '1'}">
					<tr>
						<td class="label" align="center"><label for="sucursalID">No. Sucursal</label></td>
						<td class="label" align="center"><label for="nombreSucursal">Nombre Sucursal</label></td>
						<td class="label" align="center"><label for="nombreEstado">Estado</label></td>
						<td class="label" align="center"><label for="seleccionar">Seleccionar</label></td>
					</tr>
					<c:forEach items="${listaResultado}" var="sucursal" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td  align="center"> 
								<input type="text" id="sucursalID${status.count}" name="lSucursalID" size="10" value="${sucursal.sucursalID}" readOnly="true" style='text-align:left;' />					
							</td>
							<td  align="center"> 
								<input type="text" id="nombreSucursal${status.count}" size="30" value="${sucursal.nombreSucursal}" readOnly="true" style='text-align:left;' />					
							</td> 
							<td  align="center"> 
								<input type="text" id="nombreEstado${status.count}" size="30" value="${sucursal.nombreEstado}" readOnly="true" style='text-align:left;' />
								<input type="hidden" id="estadoID${status.count}" name="lEstadoID" value="${sucursal.estadoID}" />					
							</td> 
							<td  align="center">
								<input type="checkbox" id="estatuscheck${status.count}" checked onclick="validaEstatus(this)"/> 
								<input type="hidden" id="estatus${status.count}" name="lEstatus" value="${sucursal.estatus}" />	
							</td>						 
					 	</tr>
			
					</c:forEach>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
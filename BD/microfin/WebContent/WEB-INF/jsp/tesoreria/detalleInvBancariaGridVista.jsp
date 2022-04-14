<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="listaResultado"  value="${listaResultado}"/>
<form id="gridDetalle" name="gridDetalle">
<fieldset class="ui-widget ui-widget-content ui-corner-all">           
	<legend>Distribución por CC</legend>
	<table  width="100%"  border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td><input class="botonDeshabilitado" id="agregarDCC" type="button" name="agregar" class="submit" value="Agregar" onclick="agregarDistribucionCC()" disabled="true" tabIndex="23"/></td>
		</tr>
		<tr>
			<td>
				<table id="distribucionCC"  border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td  class="label"><label>Centro de Costos</label></td>
						<td  class="label" width="250px"><label>Nombre de Centro de Costos</label></td>
						<td  class="label" ><label>Monto</label></td>
						<td  class="label" ><label>Interés a Generar</label></td>
						<td  class="label" ><label>ISR</label></td>
						<td  class="label" ><label>Total a Recibir</label></td>	
						<td  class="label" ></td>
			 		</tr>
			 		<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
			 		<tr id="tr${status.count}">
			 			<td>
			 				<input id="ccD${status.count}" name="ccD" type="text" value="${detalle.centroCosto}"  size="12" disabled="true"/>
			 			</td>
			 			<td>
			 				<input id="ccnameD${status.count}" name="ccnameD" type="text" value="${detalle.nombre_centroCosto}" size="60" disabled="true"/>
			 			</td>
						<td>
							<input id="montoD${status.count}" name="montoD" type="text"  value="${detalle.monto}"  esMoneda="true" disabled="true" style="text-align: right"/>
						</td>
						<td>
							<input id="interesGD${status.count}" name="interesGD" type="text" value="${detalle.interesGenerado}" disabled="true" esTasa="true" style="text-align: right"/></td>
						<td nowrap="nowrap">
							<input id="impuestoRetenerD${status.count}" name="impuestoRetenerD" 	type="text" value="${detalle.iSR}" disabled="true" esTasa="true" style="text-align: right"/></td>
						<td>
							<input id="totalRecibir${status.count}" name="totalRecibirD" type="text" value="${detalle.totalRecibir}" disabled="true" esMoneda="true" style="text-align: right"/></td>
						<td nowrap="nowrap">
							<!-- <input type="button" name="elimina" value="" class="btnElimina" onclick="eliminarDistribucionCC('tr${status.count}')" disabled="true"/>
							<input type="button" name="agrega" value="" class="btnAgrega" onclick="agregarDistribucionCC()" disabled="true"/>-->
						</td>
					</tr>
			 		</c:forEach>
				</table>
			</td>
		</tr>
	</table>
</fieldset>
</form>

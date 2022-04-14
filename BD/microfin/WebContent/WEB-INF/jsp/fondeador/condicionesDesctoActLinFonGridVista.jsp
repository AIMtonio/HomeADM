<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<table border="0" cellpadding="0" cellspacing="0" id="tablaActividades">			
	<tr>
		<td class="label">
			<label for="lblActividadBMX">Actividad BMX</label>
		</td> 
		<td></td>
		<td></td>
	</tr>
	<tr>
		<td></td>
		<td></td>
	</tr>		
	<c:forEach items="${listaResultado}" var="actividadBean"   varStatus="status">
	<tr id="renglonAct${status.count}" name= "renglonAct">
		<td nowrap="nowrap">
			<input type="text" id="actividadBMXID${status.count}" name="listaActividadBMXID" size="15"  value="${actividadBean.actividadBMXID}" 
				 onkeypress="listaActividadesBMXGrid(this.id);" onblur="validaActividad(this.id);consultaActividadDescripcionGrid(this.id);" />
			<input type="text" id="descripcionBMX${status.count}" name="descripcionBMX" size="65" disabled="disabled" readonly="readonly"/>
		</td> 
		<td>
			<input type="button" name="eliminaAct" id="eliminaAct${status.count}" value="" class="btnElimina" onclick="eliminaFilaAct(this.id)"/>
		</td>  
		<td>
			<input type="button" name="agregaAct" id="agregaAct${status.count}" value="" class="btnAgrega" onclick="agregaNuevaFilaAct()"/>
		</td>
		<c:set var="numeroDetalleAct"  value="${status.count}"/>
	</tr>
	</c:forEach>
	<tr>
		<td>
			<input type="hidden" id="numeroDetalleAct" name="numeroDetalleAct" value = "${numeroDetalleAct}" size="10"/>
		</td>
	</tr>
</table>
<br></br>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<c:set var="clavesAcceso"  value="${clavesAcceso}"/>

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend>Claves Mensuales</legend>
	<table id="tablaClaves" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<input type="button" id="agregaMes" value="Agrega" class="botonGral" onclick="agregaElemento()" />
			</td>
		</tr>
		<tr>
			<td class="label"> 
				<label for="lblNo">Mes</label> 
			</td> 	
			<td class="label"> 
				<label for="lblObservacion">Clave</label>
			</td>
		</tr>
		<c:forEach items="${clavesAcceso}" var="clavesAcceso" varStatus="status"> 
		<tr id="registro${status.count}" name="registro">
			<td>
				<input type="hidden" id="mes${status.count}" name="lisMes" value="${clavesAcceso.mes}" readonly="true" />
				<input type="text" id="descMes${status.count}" name="descMes" value="${clavesAcceso.descMes}" readonly="true" />
			</td> 
			<td>
				<input type="text" id="claveKey${clavesAcceso.mes}" name="lisClaveKey" size="60" value="${clavesAcceso.claveKey}" />
			</td>
			<td>
				<input type="button" name="agrega" id="${clavesAcceso.mes}" class="btnAgrega" onclick="agregaElemento()" />
			</td>
		</tr>
		</c:forEach>
	</table>
</fieldset>
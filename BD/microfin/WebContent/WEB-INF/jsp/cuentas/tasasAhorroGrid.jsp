<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tasaAhorroLista" value="${tasaAhorroLista}"/>
<div id="tasasAhorroGrid">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Detalle</legend>
	<table id="miTabla"  border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label"> 
					   	<label for="lblconsecutivo">No</label> 
				</td>
			  	<td class="label"> 
					<label for="lbllimInf">Límite Inferior</label> 
				</td>
				<td class="label"> 
					<label for="lbllimSup">Límite Superior</label> 
		     	</td>		     	
				<td class="label"> 
					<label for="lbltasa">Tasa</label> 
				</td>				
	 		</tr>
	 		<c:forEach items="${tasaAhorroLista}" var="tasaAhorroLista" varStatus="status">
	 		<tr id="renglon${status.count}" name="renglon">
	 			<td> 
					<input id="tasaAhorroID2${status.count}"  name="tasaAhorroID2" size="3" value="${tasaAhorroLista.tasaAhorroID}" readOnly="true"  type="text"/> 
			  	</td> 
				<td> 
					<input type="" id="montoInferior2${status.count}" name="montoInferior2" size="15" value="${tasaAhorroLista.montoInferior}" readOnly="true" type="text"/> 
				</td> 
				<td> 
					<input type="text" id="montoSuperior2${status.count}" name="montoSuperior2" size="15" value="${tasaAhorroLista.montoSuperior}" readOnly="true" type="text"/> 
				</td> 
				<td> 
					<input type="text" id="tasa2${status.count}" name="tasa2" size="8" value="${tasaAhorroLista.tasa}" readOnly="true" type="text"/> 
				</td> 					 
	 		</tr>
	 		</c:forEach>
	 	</table>
	<input type="hidden" value="${numeroFilas}" name="numeroEsquema" id="numeroEsquema" />
</fieldset>	
</div>
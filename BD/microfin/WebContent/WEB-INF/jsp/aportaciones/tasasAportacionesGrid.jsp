<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="tasaFV"  value="${tasasLista[0]}"/>
<c:set var="tasaInv" value="${tasasLista[1]}"/>
<c:set var="tasaAportacionesLista" value="${tasasLista[2]}"/>

<div id="tasasAhorroGrid">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Detalle</legend>
	<table id="miTabla"  border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label">
					   	<label for="lblconsecutivo">N&uacute;m.</label>
				</td>
			  	<td class="label">
					<label for="lbllimInf">Plazos</label>
				</td>
				<td class="label">
					<label for="lbllimSup">Montos</label>
		     	</td>
		     	<c:if test="${tasaFV == 'F'}">
					<td class="label">
						<label for="lbltasa">Tasa</label>
					</td>
				</c:if>
		     	<c:if test="${tasaFV == 'V'}">
					<td class="label">
						<label for="lblTasaBase">Tasa Base</label>
					</td>
				</c:if>
		     	<c:if test="${tasaFV == 'V'}">
					<td class="label">
						<label for="lblSobreTasa">Sobre Tasa</label>
					</td>
				</c:if>
		     	<c:if test="${tasaFV == 'V'}">
					<td class="label">
						<label for="lblPisoTasa">Piso Tasa</label>
					</td>
				</c:if>
		     	<c:if test="${tasaFV == 'V'}">
					<td class="label">
						<label for="lblTechoTasa">Techo Tasa</label>
					</td>
				</c:if>
				<td class="label">
					<label for="lblCal">Calificaci&oacute;n</label>
		     	</td>
	 		</tr>
	 		<c:forEach items="${tasaAportacionesLista}" var="tasas" varStatus="status">
	 		<tr id="renglon${status.count}" name="renglon">
	 			<td>
					<input id="tasaAportacionID${status.count}"  name="tasaAportacionGridID" size="3" value="${tasas.tasaAportacionID}" readOnly="true"  type="text"/>
			  	</td>

				<td>
					<input id="plazoID${status.count}"  name="plazoGridID" size="15" value="${tasas.plazoID}" readOnly="true"  type="text"/>
				</td>
				<td>
					<input id="montoID${status.count}"  name="montoGridID" size="35" value="${tasas.montoID}" readOnly="true"  type="text"/>
				</td>

				<c:if test="${tasaFV == 'F'}">
					<td>
						<input type="text" id="tasa${status.count}" name="tasa" size="8" value="${tasas.tasaFija}" readOnly="true" type="text"/>
					</td>
				</c:if>
				<c:if test="${tasaFV == 'V'}">
					<td>
						<input type="text" id="tasaBase2${status.count}" name="tasaBase2" size="8" value="${tasas.tasaBase}" readOnly="true" type="text"/>
					</td>
					<td>
						<input type="text" id="sobreTasa2${status.count}" name="sobreTasa2" size="8" value="${tasas.sobreTasa}" readOnly="true" type="text"/>
					</td>
					<td>
						<input type="text" id="pisoTasa2${status.count}" name="pisoTasa2" size="8" value="${tasas.pisoTasa}" readOnly="true" type="text"/>
					</td>
					<td>
						<input type="text" id="techoTasa2${status.count}" name="techoTasa2" size="8" value="${tasas.techoTasa}" readOnly="true" type="text"/>
					</td>
				</c:if>
				<td>
					<input type="text" id="calificacion${status.count}" name="calificacionGrid" size="25" value="${tasas.calificacion}" readOnly="true" type="text"/>
			  	</td>
	 		</tr>
	 		</c:forEach>
	 	</table>
	<input type="hidden" value="${numeroFilas}" name="numeroEsquema" id="numeroEsquema" />
</fieldset>
</div>
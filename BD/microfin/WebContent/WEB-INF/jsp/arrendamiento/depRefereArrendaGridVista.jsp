<?xml version="1.0" encoding="UTF-8"?>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="listaResultado" value="${listaResultado[1]}" />

<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Dep&oacute;sitos</legend>
	<table id="miTabla" border="0" width="100%">
		<c:choose>
			<c:when test="${tipoLista >= '2'}">
				<tr>
					<td class="label" align="center"><label for="lblFechaCarga">Fecha Carga</label></td>
					<td class="label" align="center"><label for="lblArrendamiento">Arrendamiento</label></td>
					<td class="label" align="center"><label for="lblCliente"><s:message code="safilocale.cliente"/></label></td>
					<td class="label" align="center"><label for="lblMonto">Monto</label></td>
					<td class="label" align="center"><label for="lblSeleccionar">Seleccionar</label></td>
				</tr>
				<c:forEach items="${listaResultado}" var="amortizacion" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td align="center">
							<input id="depRefereID${status.count}" name="lDepRefereID" style="text-align: center;" size="8" type="hidden" value="${amortizacion.depRefereID}" readonly="readonly" />
							<input id="folioCargaID${status.count}" name="lFolioCargaID" style="text-align: center;" size="8" type="hidden" value="${amortizacion.folioCargaID}" readonly="readonly" />
							<input id="fechaCarga${status.count}" name="lFechaCarga" style="text-align: center;" size="18" type="text" value="${amortizacion.fechaCarga}" readonly="readonly" />
						</td>
						<td align="center"><input id="referenciaMov${status.count}" name="lReferenciaMov" style="text-align: center;" size="11" type="text" value="${amortizacion.referenciaMov}" readonly="readonly" /></td>
						<td><input id="cliente${status.count}" name="lCliente" style="text-align: center;" size="40" type="text" value="${amortizacion.clienteID}" readonly="readonly" /></td>
						<td><input id="montoMov${status.count}" name="lMontoMov" size="18" style="text-align: right;" type="text" style="text-align: right;" value="${amortizacion.montoMov}" readonly="readonly" esMoneda="true" /></td>
						<td class="label"> 
		                	<input type="checkbox" id="seleccionado${status.count}" name="seleccionadoCheck" checked="checked" onclick="cambiaSeleccionado('seleccionado${status.count}', 'seleccionadoHidden${status.count}')" /> 
							<input type="hidden" id="seleccionadoHidden${status.count}" name="lSeleccionado" value="S" />							  
						</td>
					</tr>
				</c:forEach>
			</c:when>
		</c:choose>
	</table>

</fieldset>

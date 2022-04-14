<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>


<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="listaResultado" value="${listaResultado[1]}" />

<form id="consultaSpeiBean" name="consultaSpeiBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0"
			width="80%">
			
			<c:choose>
				<c:when test="${tipoLista == '2'}">

					<tr id="encabezadoLista">
						<td></td>
						<td>Fecha</td>
						<td>Monto</td>
						<td align="lefth">Cantidad</td>
						<td align="lefth">Estatus</td>

					</tr>


					<c:forEach items="${listaResultado}" var="pago" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td><input id="consecutivoID${status.count}"
								name="consecutivoID" size="3" value="${status.count}"
								readOnly="true" disabled="true" type="hidden"
								style='text-align: left;' /></td>
							<td><input id="fecha${status.count}" name="fecha" size="18"
								value="${pago.fecha}" readOnly="true" disabled="true"
								type="text" style='text-align: left;' /></td>

							<td><input type="text" id="monto${status.count}"
								name="monto" size="20" value="${pago.montoSpei}" readOnly="true"
								disabled="true" esMoneda="true" style='text-align: right;' /></td>

							<td><input type="text" id="procesado${status.count}"
								name="procesado" size="18" value="${pago.procesado}"
								readOnly="true" disabled="true" style='text-align: center;' /></td>

							<td><input type="text" id="estatus${status.count}"
								name="estatus" size="30" value="${pago.estatus}" readOnly="true"
								disabled="true" style='text-align: lefth;' /></td>



						</tr>

					</c:forEach>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>

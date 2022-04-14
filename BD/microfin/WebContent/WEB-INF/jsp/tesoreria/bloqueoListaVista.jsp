<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="bloqueo" value="${listaResultado[0]}" />
<c:set var="auxbloqueo" value="${listaResultado[1]}" />

<div id="contenedorForma">
	<form id="formaGenerica" name="formaGenerica">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Bloqueos</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr id="encabezadoLista">
				<td>Naturaleza del Movimiento</td>
				<td>Fecha de Movimiento</td>
				<td>Descripción</td>
				<td>Bloqueo</td>
				<td>Desbloqueo</td>
			</tr>
			<c:forEach items="${bloqueo}" var="bloqueoT" varStatus="status">
				<c:set var="saldoBloqueado" />
				<c:set var="saldoDesbloqueado" />
				<c:set var="saldTotal" />
			<tr>
				<td align="left">
					<c:choose>
					<c:when test="${bloqueoT.natMovimiento == 'B'}">
						<c:set var="naturaleza" value="BLOQUEADO" />
					</c:when>
					<c:when test="${bloqueoT.natMovimiento == 'D'}">
						<c:set var="naturaleza" value="DESBLOQUEADO" />
					</c:when>
					<c:otherwise>
						<c:set var="naturaleza" value="" />
					</c:otherwise>
					</c:choose> 
					<label for="natMovimiento" id="natMovimiento${status.count}" name="natMovimiento" size="20"> ${naturaleza}</label></td>
				<td><label for="fechaMov" id="fechaMov${status.count}"
					name="fechaMov" size="8"> ${bloqueoT.fechaMov}</label></td>
				<td align="left">
					<label for="descripcion" id="descripcion${status.count}" name="descripcion" size="15"> ${bloqueoT.descripcion}</label></td>
				<td align="right">
					<c:set var="saldoBloqueado" value="saldoBloqueado+${bloqueoT.montoBloq}" /> 
					<c:choose>
						<c:when test="${bloqueoT.natMovimiento == 'B'}">
							<c:set var="naturaleza2" value="${bloqueoT.montoBloq}" />
							<input type="hidden" id="bloqueos${status.count}" name="bloqueos" value="${naturaleza2}" />
						</c:when>
						<c:otherwise>
							<c:set var="naturaleza2" value="" />
						</c:otherwise>
					</c:choose> 
					<label for="bloqueo" id="bloqueo${status.count}" name="bloqueo"
							size="15" esMoneda="true"> ${naturaleza2}</label>
				</td>
				<td align="right">
					<c:set var="saldoDesbloqeado" value="saldoDesbloqueado + ${bloqueoT.montoBloq}" /> 
					<c:choose>
						<c:when test="${bloqueoT.natMovimiento == 'D'}">
							<c:set var="naturaleza3" value="${bloqueoT.montoBloq}" />
							<input type="hidden" id="desbloqueos${status.count}" name="desbloqueos" value="${naturaleza3}" />
						</c:when>
						<c:otherwise>
							<c:set var="naturaleza3" value="" />
						</c:otherwise>
					</c:choose> 
					<label for="desbloqueo" id="desbloqueo${status.count}"
							name="desbloqueo" size="15"> ${naturaleza3}</label></td>
			</tr>
				<c:set var="saldTotal" value="${bloqueoT.saldoActual}"/>
			</c:forEach>
			<tr>
				<td class="label"><label for="aux"> </label></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td class="label" align="right"><label for="saldoTotal">Saldo Bloqueado a la Fecha:</label></td>
				<td class="label" align="right">
					<label for="saldoActual" id="saldoActual" name="saldoActual" size="15">${saldTotal}</label>
				</td>
			</tr>
			</table>
		</fieldset>
	</form>
</div>










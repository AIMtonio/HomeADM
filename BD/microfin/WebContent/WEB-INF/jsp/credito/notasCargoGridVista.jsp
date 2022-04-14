<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="amortizaciones" value="${listaResultado[1]}"/>

<fieldset id="fieldset" class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget">Pagos Realizados</legend>
	<table id="tablaLista">
		<c:choose>
			<c:when test="${tipoLista >= '1'}">
				<tr id="encabezadoLista">
					<td>Amortizaci&oacute;n</td>
					<td>Fecha Pago</td>
					<td>Capital</td>
					<td>Inter&eacute;s Ord.</td>
					<td>IVA Inter&eacute;s</td>
					<td>Moratorio</td>
					<td>IVA Moratorio</td>
					<td>Otras Com.</td>
					<td>IVA Comisiones</td>
					<td>Nota de Cargo</td>
					<td>IVA Nota de Cargo</td>
					<td>Total Pago</td>
					<td>Selecci&oacute;n</td>
					<td></td>
				</tr>
				<c:forEach items="${amortizaciones}" var="amortizacion" varStatus="status" >
					<tr id="renglon${status.count}" name="renglon">
						<td>${amortizacion.amortizacionID}</td>
						<td>${amortizacion.fechaExigible}</td>
						<td>${amortizacion.capital}</td>
						<td>${amortizacion.interesOrd}</td>
						<td>${amortizacion.ivaInteres}</td>
						<td>${amortizacion.moratorio}</td>
						<td>${amortizacion.ivaMoratorio}</td>
						<td>${amortizacion.otrasComisiones}</td>
						<td>${amortizacion.ivaComisiones}</td>
						<td>${amortizacion.notasCargo}</td>
						<td>${amortizacion.ivaNotasCargo}</td>
						<td>${amortizacion.totalPago}</td>
						<td>
							<input type="radio" name="seleccion" id="seleccion${status.count}" value="N" onChange="colocaValorCheck('${status.count}')" onClick="funcionNota('${amortizacion.amortizacionID}','${amortizacion.totalPago}')"
								<c:if test="${amortizacion.tieneNotas ne '0'}"> disabled=disabled </c:if>
							/>
						</td>
					</tr>
					<c:if test="${amortizacion.tieneNotas eq '0'}"> <input type="hidden" name="listaAmortizacionID" value="${amortizacion.amortizacionID}"/> </c:if>
					<c:if test="${amortizacion.tieneNotas eq '0'}"> <input type="hidden" name="listaCapital" value="${amortizacion.capital}"/> </c:if>
					<c:if test="${amortizacion.tieneNotas eq '0'}"> <input type="hidden" name="listaInteresOrd" value="${amortizacion.interesOrd}"/> </c:if>
					<c:if test="${amortizacion.tieneNotas eq '0'}"> <input type="hidden" name="listaIvaInteres" value="${amortizacion.ivaInteres}"/> </c:if>
					<c:if test="${amortizacion.tieneNotas eq '0'}"> <input type="hidden" name="listaMoratorio" value="${amortizacion.moratorio}"/> </c:if>
					<c:if test="${amortizacion.tieneNotas eq '0'}"> <input type="hidden" name="listaIvaMoratorio" value="${amortizacion.ivaMoratorio}"/> </c:if>
					<c:if test="${amortizacion.tieneNotas eq '0'}"> <input type="hidden" name="listaOtrasComisiones" value="${amortizacion.otrasComisiones}"/> </c:if>
					<c:if test="${amortizacion.tieneNotas eq '0'}"> <input type="hidden" name="listaIvaComisiones" value="${amortizacion.ivaComisiones}"/> </c:if>
					<c:if test="${amortizacion.tieneNotas eq '0'}"> <input type="hidden" name="listaTotalPago" value="${amortizacion.totalPago}"/> </c:if>
					<c:if test="${amortizacion.tieneNotas eq '0'}"> <input type="hidden" name="listaTranPagoCredito" value="${amortizacion.tranPagoCredito}"/> </c:if>
					<c:if test="${amortizacion.tieneNotas eq '0'}"> <input type="hidden" name="listaCheck" id="check${status.count}" value="N"/> </c:if>
				</c:forEach>
			</c:when>
		</c:choose>
	</table>
</fieldset>
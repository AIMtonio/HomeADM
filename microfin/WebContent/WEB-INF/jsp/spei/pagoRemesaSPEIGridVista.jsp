<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<form id="pagoRemesaSPEIBean" name="pagoRemesaSPEIBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<table id="tablaGrid" cellpadding="0" cellspacing="0" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '1'  || tipoLista == '2'}">

					<thead>
						<tr id="encabezadoLista">
							<th></th>
							<th></th>
							<th>Folio</th>
							<th>Cuenta Origen</th>
							<th>Cuenta Destino</th>
							<th>Nombre Beneficiario</th>
							<th style="text-align: center;">Monto</th>
							<th>
								<input type="checkbox" id="seleccionaTodos" name="seleccionaTod" onchange="seleccionarTodos(this)">
							</th>
						</tr>
					</thead>

					<tbody id="tbodyRemesas">
						<c:forEach items="${listaResultado}" var="pago" varStatus="status">
							<tr id="renglon${status.count}" name="renglon">
								<td>
									<input id="consecutivoID${status.count}" name="consecutivoID" value="${status.count}" type="hidden" />
								</td>
								<td>
									<input type="hidden" id="claveRastreo${status.count}" name="claveRastreo"
										value="${pago.claveRastreo}" />
								</td>
								<td>
									<input type="text" id="speiRemID${status.count}" name="speiRemID" size="10" value="${pago.speiRemID}"
										readOnly="true" disabled="true" style='text-align:left;' />
								</td>
								<td>
									<input type="text" id="cuentaOrd${status.count}" name="cuentaOrd" size="25" value="${pago.cuentaOrd}"
										readOnly="true" disabled="true" style='text-align:left;' />
								</td>
								<td>
									<input type="text" id="cuentaBeneficiario${status.count}" name="cuentaBeneficiario" size="25"
										value="${pago.cuentaBeneficiario}" readOnly="true" disabled="true" style='text-align:left;' />
								</td>
								<td>
									<input type="text" id="nombreBeneficiario${status.count}" name="nombreBeneficiario" size="46"
										value="${pago.nombreBeneficiario}" readOnly="true" disabled="true" style='text-align:left;' />
								</td>
								<td>
									<input type="text" id="monto${status.count}" name="monto" size="15" esMoneda="true" class="montoRemesa"
										value="${pago.monto}" readOnly="true" disabled="true" style='text-align:right;' />
								</td>

								<td style="text-align: center;">
									<input type="checkbox" id="enviar${status.count}" class="checkRemesa" name="enviar"
										onclick="sumarRemesas()" style='text-align:center;' />
								</td>

								<input type="hidden" id="claveRastreo${status.count}" name="claveRastreo" value="${pago.claveRastreo}" />
							</tr>
						</c:forEach>
					</tbody>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>
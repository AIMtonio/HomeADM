<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="listaResultado" value="${listaResultado[0]}" />
<table id="miTabla">
	<tr>
		<td>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Movimientos Batch</legend>
				<table>
					<tr>
						<td class="label">
							<label for="lblNumOpera">Mov. Concilia.</label>
						</td>
						<td class="label">
							<label for="lblFecha">Fecha Ope.</label>
						</td>
						<td class="label">
							<label for="lblTipoOpe">Operaci&oacute;n</label>
						</td>
						<td class="label">
							<label for="lblNumTarjeta">N&uacute;m Tarjeta</label>
						</td>
						<td class="label" align="center">
							<label for="lblMonto">Monto</label>
						</td>
						<td class="label">
							<label for="lblMovConcilia">Procesar</label>
						</td>
					</tr>
					<c:forEach items="${listaResultado}" var="movsExter" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td>
								<input id="numAutorizacion${status.count}" name="lisNumAutorizacion" size="15" value="${movsExter.numAutorizacion}" readOnly="true" />
							</td>
							<td>
								<input id="fechaConsumo${status.count}" name="lisFechaConsumo" size="11" value="${movsExter.fechaConsumo}" readOnly="true" /> 
								<input type="hidden" id="conciliaID${status.count}" name="lisConciliaID" size="12" value="${movsExter.conciliaID}" /> 
								<input type="hidden" id="detalleID${status.count}" name="lisDetalleID" size="12" value="${movsExter.detalleID}" />
							</td>
							<td>
								<input type="text" id="descTipoOperacion${status.count}" name="lisDescTipoOperacion" size="25" value="${movsExter.descTipoOperacion}" readOnly="true" />
								 <input type="hidden" id="tipoOperacion${status.count}" name="lisTipoOperacion" size="11" value="${movsExter.tipoOperacion}" />
							</td>
							<td>
								<input id="numCuenta${status.count}" name="lisNumCuenta" size="20" value="${movsExter.numCuenta}" readOnly="true" />
							</td>
							<td>
								<input id="monto${status.count}" name="lisMonto" size="12" value="${movsExter.monto}" " esMoneda="true" style="text-align: right" readOnly="true" />
							</td>
							<td nowrap="nowrap" align="center">
								<input type="checkbox" id="checkProc${status.count}" name="checkProc" onclick="verificaProcesado(this.id)" />
								 <input type="hidden" id="estatusConci${status.count}" name="lisEstatusConci" value="N" size="10" />
							</td>
						</tr>
					</c:forEach>
				</table>
			</fieldset>
		</td>
	</tr>
</table>
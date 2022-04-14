<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="listaResultado"  value="${listaResultado}"/>
	<table>
		<tr>
			<td class="label"><label>Movimiento</label></td>
			<td class="label"><label>No. Movs</label></td>
			<td class="label"><label>Monto Total</label></td>

			<td class="label"><label>Imp</label></td>
			<td class="label" nowrap="nowrap"></td>
			<td class="label"><label>Pdf</label></td>
		</tr>
	
		<c:forEach items="${listaResultado}" var="movimientos" varStatus="status">
			<tr id="renglon${status.count}" name="renglon">
				<td class="label" nowrap="nowrap">
					<label "generaDetalle(${movimientos.numeroNat});">${movimientos.movimiento}</label>
				</td>
				<td>
					<input id="noMovimiento${status.count}" name="noMovimiento" size="5" 
							value="${movimientos.noMovimiento}" readOnly="true" disabled="true"/>
				</td>
				<td>
					<input id="monto${status.count}" name="monto" size="15" style="text-align:right" 
							value="${movimientos.montoTotal}" readOnly="true" disabled="true"/> 
				</td>
			 	<c:if test="${!status.last}">
		        <td onclick="EscojeTicketHis(${movimientos.numeroNat});">   	
				<input type="button" name="iconoImp" id="iconoImp" value="" class="icoImp"/>
		        </td>
		        <td class="label" nowrap="nowrap"></td>
		     	<td onclick="EscogeDetalle(${movimientos.numeroNat});">
			       	<input type="button" name="iconoPDF" id="iconoPDF" value="" class="iconoPDF"/>
			       	
					</c:if>
				</td>   				 
			</tr>
		</c:forEach>
	</table>
	
<script type="text/javascript">
	$('#gridDetalleMovsSalida').hide();
	$('#gridDetalleMovsEntrada').hide();
	$("input[name='monto']").formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2
	});
</script>
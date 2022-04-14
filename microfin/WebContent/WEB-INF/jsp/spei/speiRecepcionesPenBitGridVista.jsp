<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>


<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="lista" value="${listaResultado[1]}" />

<form id="speiRecepcionesPenBitBean" name="speiRecepcionesPenBitBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<table id="miTabla" border="0px" cellpadding="0" cellspacing="0px" width="1000px">
			<c:choose>
				<c:when test="${tipoLista == '1'}">
					<tr id="encabezadoLista">
						<td width="90px">Fecha Captura</td>
						<td width="90px">Fecha Operación</td>
						<td width="140px">Cuenta Ordenante</td>
						<td width="140px">Cuenta Beneficiario</td>
						<td width="90px">Monto</td>
						<td width="90px">Código Error</td>
						<td width="300px">Descripción Error</td>
					</tr>
					<c:forEach items="${lista}" var="speiRecepcionPenBit" varStatus="status">
						<tr id="renglon${status.count}" name="renglon" style="font-size: 0.9em">
							<td>
								${speiRecepcionPenBit.fechaCaptura}
							</td>
							<td>
								${speiRecepcionPenBit.fechaProceso}
							</td>
							<td>
								${speiRecepcionPenBit.cuentaOrd}
							</td>
							<td>
								${speiRecepcionPenBit.cuentaBeneficiario}
							</td>
							<td style="text-align:right; padding: 5px;">
								${speiRecepcionPenBit.montoTransferir}
							</td>
							<td>
								${speiRecepcionPenBit.codigoError}
							</td>
							<td>
								${speiRecepcionPenBit.mensajeError}
							</td>
						</tr>

					</c:forEach>
					${status.count}
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>

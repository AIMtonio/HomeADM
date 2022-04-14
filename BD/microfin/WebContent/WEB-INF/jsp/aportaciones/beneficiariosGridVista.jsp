<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<c:set var="listaResultado"  value="${listaResultado}"/>
<%! int numFilas = 0; %>
<%! int counter = 4; %>
<table border="0" width="100%">
	<tr>
		<td>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<table id="tbBenef" border="0" width="100%">
					<tbody>
					<% numFilas=numFilas+1; %>
					<% counter++; %>
					<tr>
						<td class="label" style="text-align: center;" nowrap="nowrap">
							<label>Cuenta Destino</label>
						</td>
						<td class="label" style="text-align: center;" nowrap="nowrap">
							<label>Instituci&oacute;n</label>
						</td>
						<td class="label" style="" nowrap="nowrap">
							<label>Descripci&oacute;n</label>
						</td>
						<td class="label" style="" nowrap="nowrap">
							<label>Tipo de Cuenta</label>
						</td>
						<td class="label" nowrap="nowrap">
							<label>Cuenta</label>
						</td>
						<td class="label" nowrap="nowrap">
							<label>Beneficiario</label>
						</td>
						<td class="label" nowrap="nowrap">
							<label>Monto</label>
						</td>
						<td class="label" style="text-align: center;" nowrap="nowrap">
							<label></label>
						</td>
					</tr>
					<c:forEach items="${listaResultado}" var="detalle" varStatus="status">

						<c:choose>
							<c:when test="${detalle.tieneBen == 'S'}">
								<tr id="trBen${detalle.aportacionID}${detalle.amortizacionID}${status.count}" name="trBen${detalle.aportacionID}${detalle.amortizacionID}" >
									<c:set var="aportID" value="${detalle.aportacionID}" />
									<c:set var="amortID" value="${detalle.amortizacionID}" />
									<td>
										<input type="hidden" id="aportacionID${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="-1" name="aportacionID" size="15" value="${detalle.aportacionID}" disabled="disabled"/>
										<input type="hidden" id="amortizacionID${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="-1" name="amortizacionID" size="15" value="${detalle.amortizacionID}" disabled="disabled"/>
										<input type="hidden" id="esPrincipal${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="-1" name="esPrincipal" size="2" value="${detalle.esPrincipal}" disabled="disabled"/>
										<input type="hidden" id="total${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="-1" name="total" size="20" value="${detalle.total}" disabled="disabled"/>
										<input type="text" id="cuentaTranID${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="-1" name="cuentaTranID" size="15" value="${detalle.cuentaTranID}" disabled="disabled"/>
									</td>
									<td>
										<input type="text" id="institucionID${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="-1" name="institucionID" size="10" value="${detalle.institucionID}" disabled="disabled"/>
									</td>
									<td>
										<input type="text" id="nombre${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="-1" name="nombre" size="50" value="${detalle.nombre}" disabled="disabled"/>
									</td>
									<td>
										<select id="tipoCuentaID${detalle.aportacionID}${detalle.amortizacionID}${status.count}" name="tipoCuentaID" tabindex="-1" style="width: 120px" disabled="disabled">
											<option value="${detalle.tipoCuentaID}">${detalle.tipoCuentaDesc}</option>
										</select>
									</td>
									<td>
										<input type="text" id="clabe${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="-1" name="clabe" size="29" value="${detalle.clabe}" disabled="disabled"/>
									</td>
									<td>
										<input type="text" id="beneficiario${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="-1" name="beneficiario" size="37" value="${detalle.beneficiario}" disabled="disabled"/>
									</td>
									<td>
										<input type="text" id="monto${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="<%=counter %>" name="monto" size="20" value="${detalle.monto}" style="text-align: right;" esMoneda="true"/>
									</td>
									<td>
										<input type="button" id="eliminar${detalle.aportacionID}${detalle.amortizacionID}${status.count}" name="eliminar" value="" class="btnElimina" onclick="eliminarParam('trBen${detalle.aportacionID}${detalle.amortizacionID}${status.count}')" tabindex="<%=counter %>"/>
									</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:set var="aportID" value="${detalle.aportacionID}" />
								<c:set var="amortID" value="${detalle.amortizacionID}" />
							</c:otherwise>
						</c:choose>
					</c:forEach>
					<tr>
						<td class="separador" colspan="6">
						</td>
						<td style="text-align: right;">
							<input type="button" class="submit" value="Grabar" name="grabarBenef<c:out value="${aportID}"/><c:out value="${amortID}"/>" id="grabarBenef<c:out value="${aportID}"/><c:out value="${amortID}"/>" tabindex="601" onclick="grabarBeneficiarios(event,'trBen<c:out value="${aportID}"/><c:out value="${amortID}"/>','<c:out value="${aportID}"/><c:out value="${amortID}"/>');" />
						</td>
					</tr>
					</tbody>
				</table>
			</fieldset>
			<br>
		</td>
	</tr>
</table>
<script type="text/javascript" >
	if(Number(getRenglones('trBen')) == 0){
		deshabilitaBoton('grabar');
	} else {
		habilitaBoton('grabar');
	}
	agregaFormatoControles('formaGenerica');
</script>
<input type="hidden" id="numTab" value="<%=counter %>"/>
<input type="hidden" id="numeroFila" value="<%=numFilas %>"/>
<% numFilas=0; %>
<% counter=4; %>
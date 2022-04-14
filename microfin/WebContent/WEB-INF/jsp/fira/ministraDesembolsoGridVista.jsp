<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="listaResultado"  value="${listaResultado}"/>
<c:set var="esLineaCreditoAgro" value="${listaResultado[3]}"/>
<%! int numFilas = 0; %>
<%! int counter = 4; %>
<table border="0" width="70%">
	<tr>
		<td>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Tabla de Ministraciones</legend>
				<table id="tbMinistraciones" border="0" width="100%">
					<tbody>
					<tr>
						<td class="label" nowrap="nowrap" style="text-align: center;">
							<label>N&uacute;mero</label>
						</td>
						<td class="label" nowrap="nowrap" style="text-align: center;">
							<label>Fecha Ministra</label>
						</td>
						<td class="label" nowrap="nowrap" style="text-align: center;">
							<label>Capital</label>
						</td>
						<td class="label" nowrap="nowrap" style="text-align: center;">
							<label>Estatus</label>
						</td>
						<td class="label" nowrap="nowrap" style="text-align: center;">
							<label>Fecha Ministrado</label>
						</td>
						<td class="label" nowrap="nowrap" style="text-align: center;">
							<label>Seleccionar</label>
						</td>
						<c:if test="${esLineaCreditoAgro == 'S'}">
							<td class="label" nowrap="nowrap" style="text-align: center;">
								<label>Com. Servicio de Garant&iacute;a</label>
							</td>
						</c:if>
						<td class="label">
							<label></label>
						</td>
					</tr>
					<c:forEach items="${listaResultado[0]}" var="detalle" varStatus="status">
						<% numFilas=numFilas+1; %>
						<% counter++; %>
						<tr id="tr${status.count}" name="tr">
							<td style="text-align: center; align-content: center;">
								<input type="text" id="numero${status.count}" name="numero" size="5" value="${detalle.numero}" maxlength="10" onblur="" onkeypress="" onchange="" readonly="readonly" style="width: 95%"/>
							</td>
							<td style="text-align: center; align-content: center;">
								<input type="text" id="fechaPagoMinis${status.count}" name="fechaPagoMinis" size="12" value="${detalle.fechaPagoMinis}" readonly="readonly" style="text-align: center; width: 95%"/>
							</td>
							<td style="text-align: center; align-content: center;">
								<input type="text" id="capital${status.count}" name="capital" size="14" value="${detalle.capital}" maxlength="45" onblur="" readonly="readonly" style="text-align: right; width: 95%"/>
							</td>
							<td style="text-align: center; align-content: center;">
								<input type="text" id="estatus${status.count}" name="estatus" size="15" value="${detalle.estatus}" maxlength="45" onblur="" readonly="readonly" style="text-align: center; width: 95%"/>
							</td>
							<td style="text-align: center; align-content: center;">
								<input type="text" id="fechaMinistracion${status.count}" name="fechaMinistracion" size="12" value="${detalle.fechaMinistracion}" onblur="" readonly="readonly" style="text-align: center; width: 95%"/>
							</td>
							<td style="text-align: center; align-content: center;">
								<input type="checkbox" id="seleccionado${status.count}" tabindex="<%=counter %>" name="seleccionado" value="${detalle.seleccionado}" maxlength="45" onchange="validaFechaMinistracion(this.id,'fechaPagoMinis${status.count}'); eligeMinistracion('numero${status.count}');" disabled="disabled"/>
							</td>
							<c:if test="${esLineaCreditoAgro == 'S'}">
								<td style="text-align: center; align-content: center;">
									<c:if test="${detalle.numero != 1}">
										<c:choose>
											<c:when test="${detalle.forPagComGarantia == ''}">
												<select id="listaForPagComGarantia${status.count}" name="listaForPagComGarantia" value="${detalle.forPagComGarantia}" tabindex="<%=counter %>" style="text-align: center; width: 95%" disabled="disabled" required>
													<option value="">SELECCIONAR</option>
													<option value="A">ANTICIPADA</option>
													<option value="D">DEDUCIDA</option>
													<option value="V">AL VENCIMIENTO</option>
												</select>
											</c:when>
											<c:when test="${detalle.forPagComGarantia == 'A'}">
												<select id="listaForPagComGarantia${status.count}" name="listaForPagComGarantia" value="${detalle.forPagComGarantia}" tabindex="<%=counter %>" style="text-align: center; width: 95%" disabled="disabled" required>
													<option value="A">ANTICIPADA</option>
												</select>
											</c:when>
											<c:when test="${detalle.forPagComGarantia == 'D'}">
												<select id="listaForPagComGarantia${status.count}" name="listaForPagComGarantia" value="${detalle.forPagComGarantia}" tabindex="<%=counter %>" style="text-align: center; width: 95%" disabled="disabled" required>
													<option value="D">DEDUCIDA</option>
												</select>
											</c:when>
											<c:when test="${detalle.forPagComGarantia == 'V'}">
												<select id="listaForPagComGarantia${status.count}" name="listaForPagComGarantia" value="${detalle.forPagComGarantia}" tabindex="<%=counter %>" style="text-align: center; width: 95%" disabled="disabled" required>
													<option value="V">AL VENCIMIENTO</option>
												</select>
											</c:when>
										</c:choose>
									</c:if>
								</td>
							</c:if>
							<td style="text-align: center; align-content: center;">
								<input type="button" id="estatusBloq${status.count}" tabindex="<%=counter %>" name="estatusBloq" size="45" onclick="accionCandado(this.id,'seleccionado${status.count}');" maxlength="45" onblur="" style="cursor: auto; color: transparent;"/>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
			</fieldset>
		</td>
	</tr>
</table>
<script type="text/javascript" >
	marcaEstatus();
</script>
<input type="hidden" id="numTab" value="<%=counter %>"/>
<input type="hidden" id="numeroFila" value="<%=numFilas %>"/>
<% numFilas=0; %>
<% counter=4; %>
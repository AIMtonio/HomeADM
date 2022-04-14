<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="fechaInicio" value="${listaResultado[1]}" />
<c:set var="tipoLista" value="${listaResultado[2]}" />
<c:set var="listaResultado" value="${listaResultado[0]}" />
<%!int		numFilas		= 0;%>
<%!int		counter			= 65;%>
<%!double	montoDiferencia	= 0;%>
<%!double	montoTotal		= 0;%>

<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Tabla de Ministraciones</legend>
	<table style="border: 0;">
		<tr>
			<td colspan="5">
				<table id="pagoMinistraciones">
					<thead>
						<tr>
							<td class="label" nowrap="nowrap" align="center">
								<label>N&uacute;mero</label>
							</td>
							<td class="label" nowrap="nowrap" align="center">
								<label>Fecha Pago</label>
							</td>
							<td class="label" nowrap="nowrap" align="center">
								<label>Capital</label>
							</td>
						</tr>
					</thead>
					<tbody id="ministraciones">
						<c:choose>
							<c:when test="${not empty listaResultado}">
								<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
									<%numFilas = numFilas + 1;%>
									<%counter++;%>
									<c:choose>
										<c:when test="${tipoLista == '1' }">
											<tr id="pagoMinistra${status.count}" name="tr">
												<td>
													<input id="numeroMinis${status.count}" name="numeroMinis" type="text" maxlength="10" size="11" readonly="true" disabled="disabled" value="${detalle.numero}">
												</td>
												<td>
													<input id="fechaPagoMinis${status.count}" name="fechaPagoMinis" type="text" maxlength="10" size="16" esCalendario="true" onblur="guardaValorTemporal(this.id);validaTablaMinistraciones(false,this.id,true,false);" onchange="validaTablaMinistraciones(true,this.id,true,false)" tabindex="66" value="${detalle.fechaPagoMinis}" tabindex="<%=counter %>">
												</td>
												<td>
													<input id="capitalMinis${status.count}" name="capitalMinis" type="text" maxlength="20" size="20" esMoneda="true" onblur="validaTablaMinistraciones(false,this.id,false, true)" onchange="validaTablaMinistraciones(false,this.id,false, true)" style="text-align: right;" value="${detalle.capital}" tabindex="<%=counter %>">
												</td>
												<td nowrap="nowrap">
													<input type="button" id="eliminarMinistra${status.count}" name="eliminarMinistra" value="" class="btnElimina" onclick="eliminarMinistracion('${status.count}')" <c:if test="${numFilas==1}"> disabled="disabled"</c:if> tabindex="<%=counter %>" /> <input type="button" id="agregaMinistra${status.count}" name="agregaMinistra" value="" class="btnAgrega" onclick="agregarMinistracion(this.id)" tabindex="<%=counter %>" />
												</td>
											</tr>
										</c:when>
										<c:when test="${tipoLista == '5' }">
											<tr id="pagoMinistra${status.count}" name="tr">
												<td>
													<input id="numeroMinis${status.count}" name="numeroMinis" type="text" maxlength="10" size="11" readonly="true" disabled="disabled" value="${detalle.numero}">
												</td>
												<td>
													<input id="fechaPagoMinis${status.count}" name="fechaPagoMinis" type="text" maxlength="10" size="16" readonly="true" disabled="disabled" tabindex="66" value="${detalle.fechaPagoMinis}" tabindex="<%=counter %>">
												</td>
												<td>
													<input id="capitalMinis${status.count}" name="capitalMinis" type="text" maxlength="20" size="20" esMoneda="true" onblur="validaTablaMinistraciones(false,this.id,false, true)" onchange="validaTablaMinistraciones(false,this.id,false, true)" style="text-align: right;" value="${detalle.capital}" tabindex="<%=counter %>">
												</td>
												<td nowrap="nowrap">
												</td>
											</tr>
										</c:when>
										<c:otherwise>
											<c:choose>
											<c:when test="${tipoLista != '4' }">
												<tr id="pagoMinistra${status.count}" name="tr">
													<td>
														<input id="numeroMinis${status.count}" name="numeroMinis" type="text" maxlength="10" size="11" readonly="true" disabled="disabled" value="${detalle.numero}">
													</td>
													<td>
														<input id="fechaPagoMinis${status.count}" name="fechaPagoMinis" type="text" maxlength="10" size="16" tabindex="66" value="${detalle.fechaPagoMinis}" tabindex="<%=counter %>" readonly="readonly" disabled="disabled">
													</td>
													<td>
														<input id="capitalMinis${status.count}" name="capitalMinis" type="text" maxlength="20" size="20" esMoneda="true" style="text-align: right;" value="${detalle.capital}" tabindex="<%=counter %>" readonly="readonly" disabled="disabled">
													</td>
												</tr>
											</c:when>
											</c:choose>
										</c:otherwise>
									</c:choose>
									<c:set var="montoDiferencia" value="${detalle.diferencia}" />
									<c:set var="montoTotal" value="${detalle.total}" />
								</c:forEach>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${tipoLista == '1' }">
										<tr id="pagoMinistra1" name="tr">
											<td>
												<input id="numeroMinis1" name="numeroMinis" type="text" maxlength="10" size="11" readonly="true" disabled="disabled" value="1">
											</td>
											<td>
												<input id="fechaPagoMinis1" name="fechaPagoMinis" type="text" maxlength="10" size="16" onblur="validaTablaMinistraciones()" tabindex="66" value="${fechaInicio}" disabled="disabled">
											</td>
											<td>
												<input id="capitalMinis1" name="capitalMinis" type="text" maxlength="20" size="20" esMoneda="true" onblur="validaTablaMinistraciones()" style="text-align: right;" tabindex="66">
											</td>
											<td nowrap="nowrap">
												<input type="button" id="eliminarMinistra1" name="eliminarMinistra" value="" class="btnElimina" onclick="eliminarMinistracion('${status.count}')" disabled="disabled" /> <input type="button" id="agregaMinistra1" name="agregaMinistra" value="" class="btnAgrega" onclick="agregarMinistracion(this.id)" tabindex="66" />
											</td>
										</tr>
									</c:when>
									<c:otherwise>
										<tr id="pagoMinistra1" name="tr">
											<td>
												<input id="numeroMinis1" name="numeroMinis" type="text" maxlength="10" size="11" readonly="true" disabled="disabled" value="1">
											</td>
											<td>
												<input id="fechaPagoMinis1" name="fechaPagoMinis" type="text" maxlength="10" size="16" tabindex="66" value="${fechaInicio}" disabled="disabled">
											</td>
											<td>
												<input id="capitalMinis1" name="capitalMinis" type="text" maxlength="20" size="20" esMoneda="true" style="text-align: right;" tabindex="66">
											</td>
										</tr>
									</c:otherwise>
								</c:choose>
							</c:otherwise>
						</c:choose>
					


						<c:choose>
							<c:when test="${not empty listaResultado}">
								<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
									<%numFilas = numFilas + 1;%>
									<%counter++;%>
									<c:choose>
										<c:when test="${tipoLista == '4' }">
											<tr id="pagoMinistra${status.count}" name="tr">
												<td>
													<input id="numeroMinis${status.count}" name="numeroMinis" type="text" maxlength="10" size="11" readonly="true" disabled="disabled" value="${detalle.numero}">
												</td>
												<td>
													<input id="fechaPagoMinis${status.count}" name="fechaPagoMinis" type="text" maxlength="10" size="16" tabindex="66" value="${detalle.fechaPagoMinis}" tabindex="<%=counter %>" readonly="readonly" disabled="disabled">
												</td>
												<td>
													<input id="capitalMinis${status.count}" name="capitalMinis" type="text" maxlength="20" size="20" esMoneda="true" onblur="validaTablaMinistraciones(false,this.id,false, true)" onchange="validaTablaMinistraciones(false,this.id,false, true)" style="text-align: right;" tabindex="<%=counter %>">
												</td>
										
											</tr>
										</c:when>
								
									</c:choose>
									<c:set var="montoDiferencia" value="${detalle.diferencia}" />
									<c:set var="montoTotal" value="${detalle.total}" />
								</c:forEach>
							</c:when>
						</c:choose>
					</tbody>
					<tfoot>
						<tr>
							<td class="separador"></td>
							<td class="label" align="right">
								<label for="totalMinistra">Totales:</label>
							</td>
							<td>
								<input type="text" id="totalMinistra" name="totalMinistra" esMoneda="true" style="text-align: right;" disabled="disabled" value="${montoTotal}" />
							</td>
						</tr>
						<tr>
							<td class="separador"></td>
							<td class="label" align="right">
								<label for="diferenciaMinistra">Diferencia:</label>
							</td>
							<td>
								<input type="text" id="diferenciaMinistra" name="diferenciaMinistra" esMoneda="true" style="text-align: right;" disabled="disabled" value="${montoDiferencia}" />
							</td>
						</tr>
					</tfoot>
				</table>
				<input id="numTab" type="hidden" value="${counter}">
				<input id="numTabMin" type="hidden" value="66">
				<input id="numTabMax" type="hidden" value="264">
			</td>
		</tr>
	</table>
</fieldset>
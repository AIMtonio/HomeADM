<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="listaResultado"  value="${listaResultado}"/>
<%! int numFilas = 0; %>
<%! int counter = 4; %>
<fieldset  class="ui-widget ui-widget-content ui-corner-all">
	<legend >Aportaciones a Consolidar</legend>
	<table border="0" width="100%">
		<tr>
			<td>
				<table id="tbParametrizacion" border="0" width="90%">
					<tbody>
					<tr>
						<td class="label">
							<label for="aportConsolID">Aportaci&oacute;n: </label>
						</td>
						<td style="width: 10px" colspan="12" nowrap="nowrap">
							<input type="text" name="aportConsolID" id="aportConsolID" size="11" autocomplete="off" tabindex="1" onkeypress="listaConsolida(this.id);" />
							<input type="button" class="submit" value="Agregar" id="btnAgregar" tabindex="1" onclick="agregarDetalle(this.id)"/>
						</td>
					</tr>
					<tr>
						<td class="label" style="text-align: center;" width="05%">
							<label>N&uacute;m. Aportaci&oacute;n</label>
						</td>
						<td class="label" style="text-align: center;" width="10%">
							<label>Fecha de Vencimiento</label>
						</td>
						<td class="label" style="text-align: center;" width="15%">
							<label>Capital</label>
						</td>
						<td class="label" style="text-align: center;" width="10%">
							<label>Inter&eacute;s</label>
						</td>
						<td class="label" style="text-align: center;" width="10%">
							<label>ISR</label>
						</td>
						<td class="label" style="text-align: center;" width="15%">
							<label>Total</label>
						</td>
						<td class="label" width="01%">
						</td>
						<td class="label" style="text-align: center;" width="0%">
							<label>Cap.</label>
						</td>
						<td class="label" style="text-align: center;" width="0%">
							<label>Cap. + Int.</label>
						</td>
						<td class="label" width="01%">
						</td>
						<td class="label" style="text-align: center;" width="15%">
							<label>Monto Renovar</label>
						</td>
						<td class="label">
						</td>
					</tr>
					<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
					<% numFilas=numFilas+1; %>
					<% counter++; %>
					<tr id="tr${status.count}" name="tr">
						<td nowrap="nowrap" style="width:05%;">
							<input type="text" id="aportID${detalle.aportConsolID}${status.count}" tabindex="<%=counter %>" name="aportID" value="${detalle.aportConsolID}" maxlength="5" readonly="true" style="width:99%;"/>
						</td>
						<td nowrap="nowrap" style="width:10%;">
							<input type="text" id="fechaVencimiento${status.count}" name="fechaVencimiento" size="10" value="${detalle.fechaVencimiento}" readonly="true" style="width:99%;"/>
						</td>
						<td nowrap="nowrap" style="width:15%;">
							<input type="text" id="monto${status.count}" name="monto" size="8" value="${detalle.monto}" maxlength="150" esMoneda="true" style="text-align: right; width:99%;" tabindex="<%=counter %>" readonly="true"/>
						</td>
						<td nowrap="nowrap" style="width:10%;">
							<input type="text" id="interesGenerado${status.count}" name="interesGenerado" size="8" value="${detalle.interesGenerado}" maxlength="150" esMoneda="true" style="text-align: right; width:99%;" tabindex="<%=counter %>" readonly="true"/>
						</td>
						<td nowrap="nowrap" style="width:10%;">
							<input type="text" id="interesRetener${status.count}" name="interesRetener" size="8" value="${detalle.interesRetener}" maxlength="150" esMoneda="true" style="text-align: right; width:99%;" tabindex="<%=counter %>" readonly="true"/>
						</td>
						<td nowrap="nowrap" style="width:15%;">
							<input type="text" id="total${status.count}" name="total" size="8" value="${detalle.total}" maxlength="150" esMoneda="true" style="text-align: right; width:99%;" tabindex="<%=counter %>" readonly="true"/>
						</td>
						<td class="label" width="01%">
						</td>
						<td style="text-align: center;" nowrap="nowrap" >
							<c:choose>
								<c:when test="${detalle.reinvertirC == 'C'}">
									<input type="radio" id="reinvertirC${status.count}" name="reinvertirC${status.count}" tabindex="<%=counter %>" checked="checked" value="C" onclick="cambiaReinvertir('totalFinal${status.count}','C',${detalle.monto},0.00);" readonly="true"/>
								</c:when>
								<c:otherwise>
									<input type="radio" id="reinvertirC${status.count}" name="reinvertirC${status.count}" tabindex="<%=counter %>" value="C" onclick="cambiaReinvertir('totalFinal${status.count}','C',${detalle.monto},0.00);" readonly="true"/>
								</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: center;" nowrap="nowrap" >
							<c:choose>
								<c:when test="${detalle.reinvertirCI == 'CI'}">
									<input type="radio" id="reinvertirCI${status.count}" name="reinvertirC${status.count}" tabindex="<%=counter %>" checked="checked" value="CI" onclick="cambiaReinvertir('totalFinal${status.count}','CI',${detalle.total},0.00);" readonly="true"/>
								</c:when>
								<c:otherwise>
									<input type="radio" id="reinvertirCI${status.count}" name="reinvertirC${status.count}" tabindex="<%=counter %>" value="CI" onclick="cambiaReinvertir('totalFinal${status.count}','CI',${detalle.total},0.00);" readonly="true"/>
								</c:otherwise>
							</c:choose>
						</td>
						<td class="label" width="01%">
						</td>
						<td nowrap="nowrap" width="15%">
							<input type="text" id="totalFinal${status.count}" name="totalFinal" size="8" value="${detalle.totalFinal}" maxlength="150" esMoneda="true" style="text-align: right; width:99%;" tabindex="<%=counter %>" readonly="true"/>
						</td>
						<td nowrap="nowrap">
							<input type="button" id="eliminar${status.count}" name="eliminar" value="" class="btnElimina" onclick="eliminarParam('tr${status.count}')" tabindex="<%=counter %>"/>
						</td>
					</tr>
					</c:forEach>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table id="tbTotales" border="0" width="90%" cellpadding="0" cellspacing="0">
					<tbody>
					<tr>
						<td class="label" style="text-align: center;" width="05%">
							<label style="color: white;">Aportacion:</label>
						</td>
						<td class="label" style="text-align: right;" width="10%">
							<label style="color: black; ">Totales:</label>
						</td>
						<td class="label" style="text-align: right;" width="15%">
							<label style="color: black;" id="totalCapCons">0.00</label>
						</td>
						<td class="label" style="text-align: right;" width="10%">
							<label style="color: black;" id="totalIntCons">0.00</label>
						</td>
						<td class="label" style="text-align: right;" width="10%">
							<label style="color: black;" id="totalISRCons">0.00</label>
						</td>
						<td class="label" style="text-align: right;" width="15%">
							<label style="color: black;" id="totalCons">0.00</label>
						</td>
						<td class="label" width="01%">
						</td>
						<td class="label" style="text-align: center;" width="0%">
							<label style="color: white;">Cap.</label>
						</td>
						<td class="label" style="text-align: center;" width="0%">
							<label style="color: white;">Cap. + Int.</label>
						</td>
						<td class="label" width="01%">
						</td>
						<td class="label" style="text-align: right;" width="15%">
							<label style="color: black;" id="totalRenCons">0.00</label>
						</td>
						<td class="label" width="3.2%">
						</td>
					</tr>
					<tr>
						<td colspan="12"  align="right">
							<button id="guardar" name="guardar" class="submit" tabIndex = "42" onclick="grabarConsolida(event);" >Guardar</button>
						</td>
					</tr>
				</tbody>
			</table>
		</tr>
	</table>
</fieldset>
<script type="text/javascript" >
	sumaTotalesCons(false);
	$('#aportConsolID').focus();

	function grabarConsolida(event){
		$('#tipoTransaccion').val(5);
		grabaDetalles(event);
	}
</script>
<input type="hidden" id="numTab" value="<%=counter %>"/>
<input type="hidden" id="numeroFila" value="<%=numFilas %>"/>
<% numFilas=0; %>
<% counter=4; %>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="lista" value="${listaResultado[1]}" />
<c:set var="total" value="${listaResultado[2]}" />
<%!int counter = 2;%>
<c:choose>
	<c:when test="${tipoLista == '1'}">
		<table width="100%" border="1" cellpadding="0" cellspacing="0" class="tabla_round">
			<thead>
				<tr id="encabezadoLista">
					<th width="25px" class="td_borderInfIzq"></th>
					<th width="250px" class="td_sinborder">Conceptos</th>
					<th class="td_borderInfDer">Porcentaje</th>
				</tr>
			</thead>
			<tbody id="tablaxConcepto">
				<c:forEach items="${lista}" var="detalle" varStatus="status">
					<tr>
						<td class="td_sinborder">
							<input id="ratiosCatalogoID${tipoLista}${status.count}" <c:if test="${detalle.nRegistroCat<=0}">style="display:none"</c:if> type="radio" name="ratiosCatalogoID${tipoLista}" value="${detalle.ratiosCatalogoID}" onclick="mostrarXClasificacion(this.id)" tabindex="-1"> </input>
						</td>
						<td class="td_sinborder">
							<label>${detalle.descripcion}</label>
						</td>
						<td class="td_sinborder label" align="right" nowrap="nowrap">
							<input maxlength="12" esTasa="true" onkeypress="return ingresaSoloNumeros(event,2,this.id)" id="porcentaje${tipoLista}${status.count}" type="text" name="porcentaje${tipoLista}" style="text-align: right;" onblur="onBlur(this.id,${tipoLista});" tabindex="<%=counter %>"
								value="${detalle.porcentaje}"
							readonly="readonly" disabled="disabled"></input><label>%</label>
							<%
								counter++;
							%>
						</td>
					</tr>
				</c:forEach>
				<tr>
					<td colspan="5" class="td_sinborder separador"></td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<td class="td_sinborder label" align="right"></td>
					<td class="td_sinborder label" align="right"></td>
					<td class="td_sinborder label" align="right" nowrap="nowrap">
						<label>Total:</label> <input id="totalXConcepto" esTasa="true" type="text" disabled="disabled" readonly="readonly" value="${total}" style="text-align: right;" /><label>%</label>
					</td>
				</tr>
				<tr>
					<td class="td_sinborder label" align="right"></td>
					<td class="td_sinborder label" align="right"></td>
					<td class="td_sinborder label" align="right" nowrap="nowrap">
						<input id="grabaConcepto" style="display:none" type="button" class="submit" value="Grabar" onclick="grabar(${tipoLista});" tabindex="<%=counter%>" />
					</td>
				</tr>
			</tfoot>
		</table>
	</c:when>
	<c:when test="${tipoLista == '2'}">
		<c:if test="${fn:length(lista) gt 0}">
			<table width="100%" border="1" cellpadding="0" cellspacing="0" class="tabla_round">
				<thead>
					<tr id="encabezadoLista">
						<th width="25px" class="td_borderInfIzq"></th>
						<th width="250px" class="td_sinborder">Clasificaci&oacute;n</th>
						<th class="td_borderInfDer">Porcentaje</th>
					</tr>
				</thead>
				<tbody id="tablaXClasificacion">
					<c:forEach items="${lista}" var="detalle" varStatus="status">
						<tr>
							<td class="td_sinborder">
								<input id="ratiosCatalogoID${tipoLista}${status.count}"  type="radio" name="ratiosCatalogoID${tipoLista}" value="${detalle.ratiosCatalogoID}" onclick="mostrarXSubClasificacion(this.id)" tabindex="-1"> </input>
							</td>
							<td class="td_sinborder">
								<label>${detalle.descripcion}</label>
							</td>
							<td class="td_sinborder label" align="right" nowrap="nowrap">
								<input maxlength="12" esTasa="true" onkeypress="return ingresaSoloNumeros(event,2,this.id)" id="porcentaje${tipoLista}${status.count}" type="text" name="porcentaje${tipoLista}" value="${detalle.porcentaje}" style="text-align: right;" onblur="onBlur(this.id,${tipoLista});" tabindex="<%=counter %>" /><label>%</label>
								<%
									counter++;
								%>
							</td>
						</tr>
					</c:forEach>
					<tr>
						<td colspan="5" class="td_sinborder separador"></td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td class="td_sinborder label" align="right"></td>
						<td class="td_sinborder label" align="right"></td>
						<td class="td_sinborder label" align="right" nowrap="nowrap">
							<label>Total:</label> <input id="totalXClasificacion" esTasa="true" type="text" disabled="disabled" readonly="readonly" value="${total}" style="text-align: right;" /><label>%</label>
						</td>
					</tr>
					<tr>
						<td class="td_sinborder label" align="right"></td>
						<td class="td_sinborder label" align="right"></td>
						<td class="td_sinborder label" align="right" nowrap="nowrap">
							<input id="grabaClasificacion" type="button" class="submit" value="Grabar" onclick="grabar(${tipoLista});" tabindex="<%=counter%>" />
						</td>
					</tr>
				</tfoot>
			</table>
		</c:if>
	</c:when>
	<c:when test="${tipoLista == '3'}">
		<table width="100%" border="1" cellpadding="0" cellspacing="0" class="tabla_round">
			<thead>
				<tr id="encabezadoLista">
					<th width="25px" class="td_borderInfIzq"></th>
					<th width="250px" class="td_sinborder">Sub-Clasificaci&oacute;n</th>
					<th class="td_borderInfDer">Porcentaje</th>
				</tr>
			</thead>
			<tbody id="tablaXSubClasificacion">
				<c:forEach items="${lista}" var="detalle" varStatus="status">
					<tr>
						<td class="td_sinborder">
							<input id="ratiosCatalogoID${tipoLista}${status.count}" style="display: none" type="radio" name="ratiosCatalogoID${tipoLista}" value="${detalle.ratiosCatalogoID}" onclick="mostrarXPuntos(this.id)" tabindex="-1"> </input>
						</td>
						<td class="td_sinborder">
							<label>${detalle.descripcion}</label>
						</td>
						<td class="td_sinborder label" align="right" nowrap="nowrap">
							<input maxlength="12" esTasa="true" onkeypress="return ingresaSoloNumeros(event,2,this.id)" id="porcentaje${tipoLista}${status.count}" type="text" name="porcentaje${tipoLista}" value="${detalle.porcentaje}" style="text-align: right;" onblur="onBlur(this.id,${tipoLista});" tabindex="<%=counter %>" /><label>%</label>
							<%
									counter++;
								%>
						</td>
					</tr>
				</c:forEach>
				<tr>
					<td colspan="5" class="td_sinborder separador"></td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<td class="td_sinborder label" align="right"></td>
					<td class="td_sinborder label" align="right"></td>
					<td class="td_sinborder label" align="right" nowrap="nowrap">
						<label>Total:</label> <input esTasa="true" id="totalXSubClasificacion" type="text" disabled="disabled" readonly="readonly" value="${total}" style="text-align: right;" /><label>%</label>
					</td>
				</tr>
				<tr>
					<td class="td_sinborder label" align="right"></td>
					<td class="td_sinborder label" align="right"></td>
					<td class="td_sinborder label" align="right" nowrap="nowrap">
						<input id="grabaSubClasificacion" type="button" class="submit" value="Grabar" onclick="grabar(${tipoLista});" tabindex="<%=counter%>" />
					</td>
				</tr>
			</tfoot>
		</table>
	</c:when>
	<c:when test="${tipoLista == '4'}">
		<table id="tablaxPuntos" width="100%" border="1" cellpadding="0" cellspacing="0" class="tabla_2">
			<thead>
				<tr class="tabla_2_enc">
					<th width="25px" class="td_sinborder"></th>
					<th width="250px" class="td_sinborder">Descripci&oacute;</th>
					<th width="" class="td_sinborder">L&iacute;mite Inferior</th>
					<th width="" class="td_sinborder">L&iacute;mite Superior</th>
					<th class="td_sinborder">Puntos</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
					<tr>
						<td class="td_sinborder">
							<input id="ratiosCatalogoIDPuntos${status.count}" type="radio" name="ratiosCatalogoID" value="${detalle.ratiosCatalogoID}"> </input>
						</td>
						<td class="td_sinborder">
							<label>${detalle.descripcion}</label>
						</td>
						<td class="td_sinborder label" align="right" nowrap="nowrap">
							<input type="text" name="limiteInferior" value="${detalle.limiteInferior}" />
						</td>
						<td class="td_sinborder label">
							<input type="text" name="limiteSuperior" value="${detalle.limiteSuperior}" />
						</td>
						<td class="td_sinborder label" id="grabaPuntos" align="right">
							<input type="text" name="puntos" value="${detalle.puntos}" /><label>%</label>
						</td>
					</tr>
				</c:forEach>
				<tr>
					<td colspan="5" class="td_sinborder separador"></td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<td class="td_sinborder label" align="right"></td>
					<td class="td_sinborder label" align="right"></td>
					<td class="td_sinborder label" align="right"></td>
					<td class="td_sinborder label" align="right"></td>
					<td class="td_sinborder label" align="right" nowrap="nowrap">
						<label>Total:</label> <input type="text" /><label>%</label>
					</td>
				</tr>
				<tr>
					<td class="td_sinborder label" align="right"></td>
					<td class="td_sinborder label" align="right"></td>
					<td class="td_sinborder label" align="right" nowrap="nowrap">
						<input type="button" class="submit" value="Grabar" />
					</td>
				</tr>
			</tfoot>
		</table>
	</c:when>
</c:choose>
<script type="text/javascript">
	if($('#estatusProducCredito').val() == 'I'){
		deshabilitaBoton('grabaConcepto','submit');
		deshabilitaBoton('grabaClasificacion','submit');
		deshabilitaBoton('grabaSubClasificacion','submit');
		deshabilitaBoton('grabaPuntos','submit');
		mensajeSis("El Producto "+$('#descripProducto').val()+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
		$('#producCreditoID').focus();
	}else{
		habilitaBoton('grabaConcepto','submit');
		habilitaBoton('grabaClasificacion','submit');
		habilitaBoton('grabaSubClasificacion','submit');
		habilitaBoton('grabaPuntos','submit');
	}
</script>

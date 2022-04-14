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
<c:set var="descripcioConcepto" value="${listaResultado[3]}" />
<c:set var="tipoPersona" value="${listaResultado[4]}" />
<c:set var="totalFisica" value="0" />
<c:set var="totalMoral" value="0" />
<%!int	counter			= 2;%>
<%!int	counterMorales	= 0;%>
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
							<input id="matrizCatalogoID${tipoLista}${status.count}" type="radio" name="matrizCatalogoID${tipoLista}" value="${detalle.matrizCatalogoID}" onclick="mostrarXClasificacion(this.id)" tabindex="-1" <c:if test="${detalle.mostrarSub=='N'}">style="display:none"</c:if>> </input>
						</td>
						<td class="td_sinborder">
							<label>${detalle.descripcion}</label>
						</td>
						<td class="td_sinborder label" align="right" nowrap="nowrap">
							<input maxlength="12" esTasa="true" onkeypress="return ingresaSoloNumeros(event,2,this.id)" id="porcentaje${tipoLista}${status.count}" type="text" name="porcentaje${tipoLista}" style="text-align: right;" onblur="onBlur(this.id,${tipoLista});" tabindex="<%=counter %>" value="${detalle.porcentaje}"></input><label>%</label>
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
						<input id="grabaConcepto" type="button" class="submit" value="Grabar" onclick="grabar(${tipoLista});" tabindex="<%=counter%>" />
					</td>
				</tr>
			</tfoot>
		</table>
	</c:when>
	<c:when test="${tipoLista == '2'}">
		<c:if test="${fn:length(lista) gt 0}">
			<c:choose>
				<c:when test="${tipoPersona == 'F'}">
					<table width="100%" border="1" cellpadding="0" cellspacing="0" class="tabla_round">
						<thead>
							<tr id="encabezadoLista">
								<th width="25px" class="td_borderInfIzq"></th>
								<th width="250px" class="td_sinborder">${descripcioConcepto} Persona Fisica</th>
								<th class="td_borderInfDer">Porcentaje</th>
							</tr>
						</thead>
						<tbody id="tablaXClasificacionFisica">
							<c:forEach items="${lista}" var="detalle" varStatus="status">
								<c:if test="${detalle.tipoPersona=='F'}">
									<tr>
										<td class="td_sinborder">
											<input id="matrizCatalogoID${tipoLista}1${status.count}" type="radio" name="matrizCatalogoID${tipoLista}1" value="${detalle.matrizCatalogoID}" onclick="mostrarXSubClasificacion(this.id)" tabindex="-1" <c:if test="${detalle.mostrarSub=='N'}">style="display:none"</c:if>> </input>
										</td>
										<td class="td_sinborder">
											<label for="matrizCatalogoID${tipoLista}1${status.count}">${detalle.descripcion}</label>
										</td>
										<td class="td_sinborder label" align="right" nowrap="nowrap">
											<input maxlength="12" esTasa="true" onkeypress="return ingresaSoloNumeros(event,2,this.id)" id="porcentaje${tipoLista}1${status.count}" type="text" name="porcentaje${tipoLista}1" value="${detalle.porcentaje}" style="text-align: right;" onblur="onBlur(this.id,${tipoLista}1);" tabindex="<%=counter %>" /><label>%</label>
											<%
												counter++;
											%>
											<c:set var="totalFisica" value="${totalFisica + detalle.porcentaje}" />
										</td>
									</tr>
								</c:if>
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
									<label>Total:</label> <input id="totalXClasificacionFisica" esTasa="true" type="text" disabled="disabled" readonly="readonly" value="${totalFisica}" style="text-align: right;" /><label>%</label>
								</td>
							</tr>
							<tr>
								<td class="td_sinborder label" align="right"></td>
								<td class="td_sinborder label" align="right"></td>
								<td class="td_sinborder label" align="right" nowrap="nowrap">
									<input id="grabaConcepto" type="button" class="submit" value="Grabar" onclick="grabar(${tipoLista}1);" tabindex="<%=counter%>" />
								</td>
							</tr>
						</tfoot>
					</table>
					<br></br>
					<br></br>
					<table width="100%" border="1" cellpadding="0" cellspacing="0" class="tabla_round">
						<thead>
							<tr id="encabezadoLista">
								<th width="25px" class="td_borderInfIzq"></th>
								<th width="250px" class="td_sinborder">${descripcioConcepto} Persona Moral</th>
								<th class="td_borderInfDer">Porcentaje</th>
							</tr>
						</thead>
						<tbody id="tablaXClasificacionMoral">
							<c:forEach items="${lista}" var="detalle" varStatus="status">
								<c:if test="${detalle.tipoPersona=='M'}">
									<tr>
										<td class="td_sinborder">
											<input id="matrizCatalogoID${tipoLista}2${status.count}" type="radio" name="matrizCatalogoID${tipoLista}2" value="${detalle.matrizCatalogoID}" onclick="mostrarXSubClasificacion(this.id)" tabindex="-1" <c:if test="${detalle.mostrarSub=='N'}">style="display:none"</c:if>> </input>
										</td>
										<td class="td_sinborder">
											<label>${detalle.descripcion}</label>
										</td>
										<td class="td_sinborder label" align="right" nowrap="nowrap">
											<input maxlength="12" esTasa="true" onkeypress="return ingresaSoloNumeros(event,2,this.id)" id="porcentaje${tipoLista}2${status.count}" type="text" name="porcentaje${tipoLista}2" value="${detalle.porcentaje}" style="text-align: right;" onblur="onBlur(this.id,${tipoLista}2);" tabindex="<%=counter %>" /><label>%</label>
											<%
												counter++;
											%>
											<c:set var="totalMoral" value="${totalMoral + detalle.porcentaje}" />
										</td>
									</tr>
								</c:if>
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
									<label>Total:</label> <input id="totalXClasificacionMoral" esTasa="true" type="text" disabled="disabled" readonly="readonly" value="${totalMoral}" style="text-align: right;" /><label>%</label>
								</td>
							</tr>
							<tr>
								<td class="td_sinborder label" align="right"></td>
								<td class="td_sinborder label" align="right"></td>
								<td class="td_sinborder label" align="right" nowrap="nowrap">
									<input id="grabaConcepto" type="button" class="submit" value="Grabar" onclick="grabar(${tipoLista}2);" tabindex="<%=counter%>" />
								</td>
							</tr>
						</tfoot>
					</table>
				</c:when>
				<c:when test="${tipoPersona == 'T'}">
					<table width="100%" border="1" cellpadding="0" cellspacing="0" class="tabla_round">
						<thead>
							<tr id="encabezadoLista">
								<th width="25px" class="td_borderInfIzq"></th>
								<th width="250px" class="td_sinborder">${descripcioConcepto}</th>
								<th class="td_borderInfDer">Porcentaje</th>
							</tr>
						</thead>
						<tbody id="tablaXClasificacion">
							<c:forEach items="${lista}" var="detalle" varStatus="status">
								<tr>
									<td class="td_sinborder">
										<input id="matrizCatalogoID${tipoLista}${status.count}" type="radio" name="matrizCatalogoID${tipoLista}" value="${detalle.matrizCatalogoID}" onclick="mostrarXSubClasificacion(this.id)" tabindex="-1" <c:if test="${detalle.mostrarSub=='N'}">style="display:none"</c:if>> </input>
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
									<input id="grabaConcepto" type="button" class="submit" value="Grabar" onclick="grabar(${tipoLista});" tabindex="<%=counter%>" />
								</td>
							</tr>
						</tfoot>
					</table>
				</c:when>
			</c:choose>
		</c:if>
	</c:when>
	<c:when test="${tipoLista == '3'}">
		<c:choose>
			<c:when test="${tipoPersona == 'T'}">
				<table width="100%" border="1" cellpadding="0" cellspacing="0" class="tabla_round">
					<thead>
						<tr id="encabezadoLista">
							<th width="25px" class="td_borderInfIzq"></th>
							<th width="250px" class="td_sinborder">${descripcioConcepto}</th>
							<th class="td_borderInfDer">Porcentaje</th>
						</tr>
					</thead>
					<tbody id="tablaXSubClasificacion">
						<c:forEach items="${lista}" var="detalle" varStatus="status">
							<tr>
								<td class="td_sinborder">
									<input id="matrizCatalogoID${tipoLista}${status.count}" style="display: none" type="radio" name="matrizCatalogoID${tipoLista}" value="${detalle.matrizCatalogoID}" onclick="mostrarXPuntos(this.id)" tabindex="-1"> </input>
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
								<input id="grabaConcepto" type="button" class="submit" value="Grabar" onclick="grabar(${tipoLista});" tabindex="<%=counter%>" />
							</td>
						</tr>
					</tfoot>
				</table>
			</c:when>
			<c:when test="${tipoPersona == 'M'}">
				<table width="100%" border="1" cellpadding="0" cellspacing="0" class="tabla_round">
					<thead>
						<tr id="encabezadoLista">
							<th width="25px" class="td_borderInfIzq"></th>
							<th width="250px" class="td_sinborder">${descripcioConcepto}Moral</th>
							<th class="td_borderInfDer">Porcentaje</th>
						</tr>
					</thead>
					<tbody id="tablaXSubClasificacionMoral">
						<c:forEach items="${lista}" var="detalle" varStatus="status">
							<c:if test="${detalle.tipoPersona=='M'}">
								<tr>
									<td class="td_sinborder">
										<input id="matrizCatalogoID${tipoLista}2${status.count}" style="display: none" type="radio" name="matrizCatalogoID${tipoLista}2" value="${detalle.matrizCatalogoID}" onclick="mostrarXPuntos(this.id)" tabindex="-1"> </input>
									</td>
									<td class="td_sinborder">
										<label>${detalle.descripcion}</label>
									</td>
									<td class="td_sinborder label" align="right" nowrap="nowrap">
										<input maxlength="12" esTasa="true" onkeypress="return ingresaSoloNumeros(event,2,this.id)" id="porcentaje${tipoLista}2${status.count}" type="text" name="porcentaje${tipoLista}2" value="${detalle.porcentaje}" style="text-align: right;" onblur="onBlur(this.id,${tipoLista}2);" tabindex="<%=counter %>" /><label>%</label>
										<%
											counter++;
										%>
										<c:set var="totalMoral" value="${totalMoral + detalle.porcentaje}" />
									</td>
								</tr>
							</c:if>
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
								<label>Total:</label> <input esTasa="true" id="totalXSubClasificacionMoral" type="text" disabled="disabled" readonly="readonly" value="${totalMoral}" style="text-align: right;" /><label>%</label>
							</td>
						</tr>
						<tr>
							<td class="td_sinborder label" align="right"></td>
							<td class="td_sinborder label" align="right"></td>
							<td class="td_sinborder label" align="right" nowrap="nowrap">
								<input id="grabaConcepto" type="button" class="submit" value="Grabar" onclick="grabar(${tipoLista}2);" tabindex="<%=counter%>" />
							</td>
						</tr>
					</tfoot>
				</table>
			</c:when>
			<c:when test="${tipoPersona == 'F'}">
				<table width="100%" border="1" cellpadding="0" cellspacing="0" class="tabla_round">
					<thead>
						<tr id="encabezadoLista">
							<th width="25px" class="td_borderInfIzq"></th>
							<th width="250px" class="td_sinborder">${descripcioConcepto} Persona Fisica</th>
							<th class="td_borderInfDer">Porcentaje</th>
						</tr>
					</thead>
					<tbody id="tablaXSubClasificacionFisica">
						<c:forEach items="${lista}" var="detalle" varStatus="status">
							<c:if test="${detalle.tipoPersona=='F'}">
								<tr>
									<td class="td_sinborder">
										<input id="matrizCatalogoID${tipoLista}1${status.count}" style="display: none" type="radio" name="matrizCatalogoID${tipoLista}1" value="${detalle.matrizCatalogoID}" onclick="mostrarXPuntos(this.id)" tabindex="-1"> </input>
									</td>
									<td class="td_sinborder">
										<label>${detalle.descripcion}</label>
									</td>
									<td class="td_sinborder label" align="right" nowrap="nowrap">
										<input maxlength="12" esTasa="true" onkeypress="return ingresaSoloNumeros(event,2,this.id)" id="porcentaje${tipoLista}1${status.count}" type="text" name="porcentaje${tipoLista}1" value="${detalle.porcentaje}" style="text-align: right;" onblur="onBlur(this.id,${tipoLista}1);" tabindex="<%=counter %>" /><label>%</label>
										<%
											counter++;
										%>
										<c:set var="totalFisica" value="${totalFisica + detalle.porcentaje}" />
									</td>
								</tr>
							</c:if>
							<c:if test="${detalle.tipoPersona=='F'}">
								<%
									counterMorales++;
								%>
							</c:if>
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
								<label>Total:</label> <input esTasa="true" id="totalXSubClasificacionFisica" type="text" disabled="disabled" readonly="readonly" value="${totalFisica}" style="text-align: right;" /><label>%</label>
							</td>
						</tr>
						<tr>
							<td class="td_sinborder label" align="right"></td>
							<td class="td_sinborder label" align="right"></td>
							<td class="td_sinborder label" align="right" nowrap="nowrap">
								<input id="grabaConcepto" type="button" class="submit" value="Grabar" onclick="grabar(${tipoLista}1);" tabindex="<%=counter%>" />
							</td>
						</tr>
					</tfoot>
				</table>
				<c:if test="${counterMorales>0}">
					<br></br>
					<br></br>
					<table width="100%" border="1" cellpadding="0" cellspacing="0" class="tabla_round">
						<thead>
							<tr id="encabezadoLista">
								<th width="25px" class="td_borderInfIzq"></th>
								<th width="250px" class="td_sinborder">${descripcioConcepto} Persona Moral</th>
								<th class="td_borderInfDer">Porcentaje</th>
							</tr>
						</thead>
						<tbody id="tablaXSubClasificacionMoral">
							<c:forEach items="${lista}" var="detalle" varStatus="status">
								<c:if test="${detalle.tipoPersona=='M'}">
									<tr>
										<td class="td_sinborder">
											<input id="matrizCatalogoID${tipoLista}2${status.count}" style="display: none" type="radio" name="matrizCatalogoID${tipoLista}2" value="${detalle.matrizCatalogoID}" onclick="mostrarXPuntos(this.id)" tabindex="-1"> </input>
										</td>
										<td class="td_sinborder">
											<label>${detalle.descripcion}</label>
										</td>
										<td class="td_sinborder label" align="right" nowrap="nowrap">
											<input maxlength="12" esTasa="true" onkeypress="return ingresaSoloNumeros(event,2,this.id)" id="porcentaje${tipoLista}2${status.count}" type="text" name="porcentaje${tipoLista}2" value="${detalle.porcentaje}" style="text-align: right;" onblur="onBlur(this.id,${tipoLista}2);" tabindex="<%=counter %>" /><label>%</label>
											<%
												counter++;
											%>
											<c:set var="totalMoral" value="${totalMoral + detalle.porcentaje}" />
										</td>
									</tr>
								</c:if>
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
									<label>Total:</label> <input esTasa="true" id="totalXSubClasificacionFisica" type="text" disabled="disabled" readonly="readonly" value="${totalMoral}" style="text-align: right;" /><label>%</label>
								</td>
							</tr>
							<tr>
								<td class="td_sinborder label" align="right"></td>
								<td class="td_sinborder label" align="right"></td>
								<td class="td_sinborder label" align="right" nowrap="nowrap">
									<input id="grabaConcepto" type="button" class="submit" value="Grabar" onclick="grabar(${tipoLista}2);" tabindex="<%=counter%>" />
								</td>
							</tr>
						</tfoot>
					</table>
				</c:if>
			</c:when>
		</c:choose>
	</c:when>
</c:choose>
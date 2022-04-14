<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="listaPaginada" value="${listaResultado[1]}" />
<c:set var="lista" value="${listaPaginada.pageList}"/>
<%! int numFilas = 0; %>
<table id="tablaLista" style="width: 100%;">
	<thead>
		<tr id="encabezadoLista">
			<td>
				<center>Fecha</center>
			</td>
			<td nowrap="nowrap">
				<center>Sucursal</center>
			</td>
			<td nowrap="nowrap">
				<center>
					<s:message code="safilocale.cliente" />
				</center>
			</td>
			<td nowrap="nowrap">
				<center>Nombre Completo</center>
			</td>
			<td>
				<center>Aceptar</center>
			</td>
			<td>
				<center>Rechazar</center>
			</td>
		</tr>
	</thead>
	<tbody id="detalleTbody">
		<c:forEach items="${lista}" var="bean" varStatus="status">
			<tr onclick="mostrarDetalle('detalle${status.count}')" id="perfil${status.count}">
				<td nowrap="nowrap" style="text-align: center;">
					<label>${bean.fecha}</label>
					<input type="hidden" id="fecha${status.count}" name="fecha" value="${bean.fecha}" />
				</td>
				<td>
					<label>${bean.nombreSucursal}</label>
				</td>
				<td>
					<label>${bean.clienteID}</label> <input type="hidden" id="clienteID${status.count}" name="clienteIDTabla" value="${bean.clienteID}" />
				</td>
				<td>
					<label>${bean.nombreCompleto}</label>
				</td>
				<td>
					<center>
						<input id="aceptar${status.count}" name="estatusAceptado" type="checkbox" value="S" onclick="marcar('aceptar${status.count}','rechazar${status.count}')" />
					</center>
				</td>
				<td>
					<center>
						<input id="rechazar${status.count}" name="estatusRechazado" type="checkbox" value="S" onclick="marcar('rechazar${status.count}','aceptar${status.count}')" />
					</center>
				</td>
			</tr>
			<tr id="detalle${status.count}" class="detalle" name="detalle" style="display: none">
				<td colspan="6">
					<table id="detalleGrid">
						<tr>
							<td>
								<label>Monto M&aacute;ximo Dep&oacute;sitos:&nbsp;</label>
							</td>
							<td nowrap="nowrap">
								<input type="text" id="depositosMax" name="depositosMax" size="20" esMoneda="true" tabindex="2" style="text-align: right;" maxlength="18" value="${bean.depositosMax}" disabled="disabled" />
							</td>
							<td class="separador"></td>
							<td>
								<label for="retirosMax">Monto M&aacute;ximo Retiros:&nbsp;</label>
							</td>
							<td nowrap="nowrap">
								<input type="text" id="retirosMax" name="retirosMax" size="20" esMoneda="true" tabindex="3" style="text-align: right;" maxlength="18" value="${bean.retirosMax}" disabled="disabled" />
							</td>
						</tr>
						<tr>
							<td>
								<label for="numDepositos">N&uacute;mero de Dep&oacute;sitos:&nbsp;</label>
							</td>
							<td nowrap="nowrap">
								<input type="text" id="numDepositos" name="numDepositos" size="10" maxlength="18" value="${bean.numDepositos}" disabled="disabled" />
							</td>
							<td class="separador"></td>
							<td nowrap="nowrap">
								<label for="numRetiros">N&uacute;mero de Retiros:&nbsp;</label>
							</td>
							<td nowrap="nowrap">
								<input type="text" id="numRetiros" name="numRetiros" size="10" maxlength="18" value="${bean.numRetiros}" disabled="disabled" />
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<% numFilas=numFilas+1; %>
		</c:forEach>
	</tbody>
	<tfoot>
		<tr>
			<td>
				<b><label>Número</br>Registros:
				</label></b>
			</td>
			<td class="label">
				<label><%=numFilas %></label>
			</td>
		</tr>
	</tfoot>
</table>
<table align="center">
	<tr>
		<td >
			<c:if test="${!listaPaginada.firstPage}">
				<input onclick="consultaGrid('anterior')" type="button" id="anterior" value="" class="btnAnterior" />
			</c:if>
		</td>
		<td>
			<c:if test="${!listaPaginada.lastPage}">
				<input onclick="consultaGrid('siguiente')" type="button" id="siguiente" value="" class="btnSiguiente" />
			</c:if>	
		</td>
	</tr>
</table>
<% numFilas=0; %>
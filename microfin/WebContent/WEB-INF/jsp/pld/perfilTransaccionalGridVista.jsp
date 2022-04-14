<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="lista" value="${listaResultado[1]}" />
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Hist&oacute;rico</legend>
	<table id="tablaLista">
		<thead>
			<tr id="encabezadoLista">
				<td>
					<center>Fecha</center>
				</td>
				<td nowrap="nowrap">
					<center>
						Monto M&aacute;ximo<br>Dep&oacute;sitos</br>
					</center>
				</td>
				<td nowrap="nowrap">
					<center>
						Monto M&aacute;ximo<br>Retiros</br>
					</center>
				</td>
				<td nowrap="nowrap">
					<center>
						N&uacute;mero de<br>Dep&oacute;sitos</br>
					</center>
				</td>
				<td nowrap="nowrap">
					<center>
						N&uacute;mero de<br>Retiros</br>
					</center>
				</td>
				<td nowrap="nowrap">
					<center>Origen Recursos</center>
				</td>
				<td nowrap="nowrap">
					<center>Comentario Origen<br/>Recursos</center>
				</td>
				<td nowrap="nowrap">
					<center>Destino Recursos</center>
				</td>
				<td nowrap="nowrap">
					<center>Comentario Destino<br/>Recursos</center>
				</td>
				<td nowrap="nowrap">
					<center>Tipo Proceso</center>
				</td>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${lista}" var="bean" varStatus="status">
				<tr>
					<td nowrap="nowrap">
						<label>${bean.fecha} ${bean.hora}</label>
					</td>
					<td style="text-align: right;">
						<label>${bean.depositosMax}</label>
					</td>
					<td style="text-align: right;">
						<label>${bean.retirosMax}</label>
					</td>
					<td style="text-align: right;">
						<label> ${bean.numDepositos}</label>
					</td>
					<td style="text-align: right;">
						<label>${bean.numRetiros}</label>
					</td>
					<td>
						<label>${bean.descripcionOrigen}</label>
					</td>
					<td>
						<label style="word-break: break-all">${bean.comentarioOrigenRec}</label>
					</td>
					<td>
						<label>${bean.descripcionDestino}</label>
					</td>
					<td>
						<label style="word-break: break-all">${bean.comentarioDestRec}</label>
					</td>
					<td>
						<label>${bean.tipoProceso}</label>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</fieldset>
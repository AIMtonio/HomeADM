<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="lista" value="${listaResultado[1]}" />
<%! int numFilas = 0; %>
<%! int counter = 3; %>

<table id="tablaLista" style="width: 100%;">
	<thead>
		<tr id="encabezadoLista">
			<td>
				<center>N&uacute;mero Solicitud</center>
			</td>
			<td nowrap="nowrap">
				<center>
					N&uacute;mero Cr&eacute;dito
				</center>
			</td>
			<td nowrap="nowrap">
				<center>
					N&uacute;mero Empleado
				</center>
			</td>
			<td nowrap="nowrap">
				<center>Dependencia</center>
			</td>
			<td nowrap="nowrap">
				<center>Nombre Completo</center>
			</td>
			<td nowrap="nowrap">
				<center>RFC</center>
			</td>
			<td nowrap="nowrap">
				<center>CURP</center>
			</td>
			<td nowrap="nowrap">
				<center>Monto Otorgado</center>
			</td>
			<td nowrap="nowrap">
				<center>Monto Pagare</center>
			</td>
			<td nowrap="nowrap">
				<center>Tasa Anual</center>
			</td>
			<td nowrap="nowrap">
				<center>Tasa Mensual</center>
			</td>
			<td nowrap="nowrap">
				<center>Plazo</center>
			</td>
			<td nowrap="nowrap">
				<center>N&uacute;mero de Pagos</center>
			</td>
			<td nowrap="nowrap">
				<center>Descuento Peri&oacute;dico</center>
			</td>
			<td nowrap="nowrap">
				<center>Per&iacute;odo Inicio</center>
			</td>
			<td nowrap="nowrap">
				<center>Per&oacute;odo Fin</center>
			</td>
		</tr>
	</thead>
	<tbody id="detalleTbody">
		<c:forEach items="${lista}" var="bean" varStatus="status">
			<tr id="trArchivoInstal${status.count}">
				<td nowrap="nowrap" style="text-align: center;"><input type="text" id="solicitudCreditoID${status.count}" name="solicitudCreditoID" value="${bean.solicitudCreditoID}" disabled="disabled"/></td>
				<td nowrap="nowrap" style="text-align: center;"><input type="text" id="creditoID${status.count}" name="creditoID" value="${bean.creditoID}" disabled="disabled"/></td>
				<td nowrap="nowrap" style="text-align: center;"><input type="text" id="numeroEmpleado${status.count}" name="numeroEmpleado" value="${bean.numeroEmpleado}" disabled="disabled"/></td>
				<td><input type="text" id="nombreInstNomina${status.count}" name="nombreInstNomina" value="${bean.nombreInstNomina}" disabled="disabled"/></td>
				<td><input type="text" id="nombreCompleto${status.count}" name="nombreCompleto" value="${bean.nombreCompleto}" disabled="disabled"/></td>
				<td><input type="text" id="RFC${status.count}" name="RFC" value="${bean.RFC}" disabled="disabled" /></td>
				<td><input type="text" id="CURP${status.count}" name="CURP" value="${bean.CURP}" disabled="disabled" /></td>
				<td nowrap="nowrap" style="text-align: right;"><input type="text" id="montoCredito${status.count}" esMoneda="true" name="montoCredito" value="${bean.montoCredito}" disabled="disabled"/></td>
				<td nowrap="nowrap" style="text-align: right;"><input type="text" id="montoPagare${status.count}" esMoneda="true" name="montoPagare" value="${bean.montoPagare}" disabled="disabled"/></td>
				<td><input type="text" id="tasaAnual${status.count}" name="tasaAnual" value="${bean.tasaAnual}" esMoneda="true" disabled="disabled" /></td>
				<td><input type="text" id="tasaMensual${status.count}" name="tasaMensual" value="${bean.tasaMensual}" esMoneda="true" disabled="disabled" /></td>
				<td><input type="text" id="plazo${status.count}" name="plazo" value="${bean.plazo}" disabled="disabled" /></td>
				<td><input type="text" id="numAmortizacion${status.count}" name="numAmortizacion" value="${bean.numAmortizacion}" disabled="disabled" /></td>
				<td><input type="text" id="descuentoPeriodico${status.count}" name="descuentoPeriodico" value="${bean.descuentoPeriodico}" disabled="disabled" /></td>
				<td><input type="text" id="fechaInicioAmor${status.count}" name="fechaInicioAmor" value="${bean.fechaInicioAmor}" disabled="disabled" /></td>
				<td><input type="text" id="fechaVencimiento${status.count}" name="fechaVencimiento" value="${bean.fechaVencimiento}" disabled="disabled" /></td>
			</tr>
			<% numFilas=numFilas+1; %>
			<% counter++; %>
		</c:forEach>
	</tbody>
</table>

<input type="hidden" id="numeroFila" value="<%=numFilas %>"/>
<input type="hidden" id="numTab" value="<%=counter %>"/>

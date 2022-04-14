<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<script type="text/javascript" src="js/nomina/relacionClientesEmpresaNominaGrid.js"></script>

<c:set var="listaResultado" value="${listaPaginada.pageList}"/>

<br>

<input type="hidden" id="numeroRegistros" name="numeroRegistros" value="${listaPaginada.nrOfElements}"/>

<div id="formaTabla">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Detalle</legend>
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="60%">
			<tr>
				<td><label>N&uacute;mero</label></td>
				<td><label>Empresa N&oacute;mina</label></td>
				<td><label>No. Convenio</label></td>
				<td><label>Tipo Empleado</label></td>
				<td><label>No. Empleado</label></td>
				<td><label>Puesto</label></td>
				<td><label>Estatus</label></td>
			</tr>

			<c:forEach items="${listaResultado}" var="registro" varStatus="status">
				<tr id="renglon${status.count}" name="renglon">
					<td>
						<input id="nominaEmpleadoID${status.count}" size="10" type="text" value="${registro.nominaEmpleadoID}" readonly="readonly" disabled="disabled" />
					</td>
					<td>
						<input id="nombreInstNomina${status.count}" size="70" type="text" value="${registro.nombreInstNomina}" readonly="readonly" disabled="disabled" />
					</td>
					<td>
						<input id="convenioNominaID${status.count}" size="10" type="text" value="${registro.convenioNominaID}" readonly="readonly" disabled="disabled" />
					</td>
					<td>
						<input id="descripcionTipoEmpleado${status.count}" size="25" type="text" value="${registro.descripcionTipoEmpleado}" readonly="readonly" disabled="disabled" />
					</td>
					<td>
						<input id="noEmpleado${status.count}" size="15" type="text" value="${registro.noEmpleado}" readonly="readonly" disabled="disabled" />
					</td>
					<td>
						<input id="descripcionTipoPuesto${status.count}" size="40" type="text" value="${registro.descripcionTipoPuesto}" readonly="readonly" disabled="disabled" />
					</td>
					<td>
						<input id="estatusEmp${status.count}" size="15" type="text" value="${registro.estatusEmp}" readonly="readonly" disabled="disabled" />
					</td>
				</tr>
			</c:forEach>
		</table>
		<c:if test="${!listaPaginada.firstPage}">
			<input type="button" id="btnAnterior" onclick="cambioPaginaGrid('previous')" value="" tabindex="12" class="btnAnterior" />
		</c:if>
		<c:if test="${!listaPaginada.lastPage}">
			<input type="button" id="btnSiguiente" onclick="cambioPaginaGrid('next')" value="" tabindex="13" class="btnSiguiente" />
		</c:if>
	</fieldset>
</div>
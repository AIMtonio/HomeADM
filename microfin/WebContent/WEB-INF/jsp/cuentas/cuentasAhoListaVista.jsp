<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="cuentasAhoBean" value="${listaResultado[2]}"/>


<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '2' || tipoLista=='14'|| tipoLista=='19' || tipoLista=='22'}">
			<tr id="encabezadoLista">
				<td>No. Cuenta</td>
				<td>Cuenta Ahorro</td>
			</tr>
			<c:forEach items="${cuentasAhoBean}" var="filacuentasAho" >
				<tr onclick="cargaValorLista('${campoLista}', '${filacuentasAho.cuentaAhoID}');">
					<td>${filacuentasAho.cuentaAhoID}</td>
					<td>${filacuentasAho.etiqueta}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '3'}">
			<tr id="encabezadoLista">
				<td nowrap="nowrap">No. Cuenta</td>
				<td nowrap="nowrap"><s:message code="safilocale.cliente"/></td>
				<td nowrap="nowrap">Cuenta Ahorro</td>
			</tr>
			<c:forEach items="${cuentasAhoBean}" var="filacuentasAho" >
				<tr onclick="cargaValorLista('${campoLista}', '${filacuentasAho.cuentaAhoID}');">
					<td nowrap="nowrap">${filacuentasAho.cuentaAhoID}</td>
					<td nowrap="nowrap">${filacuentasAho.clienteID}</td>
					<td nowrap="nowrap">${filacuentasAho.etiqueta}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '9'}">
			<tr id="encabezadoLista">
				<td>No. Cuenta</td>
				<td>Cuenta Ahorro</td>
			</tr>
			<c:forEach items="${cuentasAhoBean}" var="filacuentasAho" >
				<tr onclick="cargaValorLista('${campoLista}', '${filacuentasAho.cuentaAhoID}');">
					<td>${filacuentasAho.cuentaAhoID}</td>
					<td>${filacuentasAho.etiqueta}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '12'}">
			<tr id="encabezadoLista">
				<td>No. Cuenta</td>
				<td><s:message code="safilocale.cliente"/></td>
				<td>Cuenta Ahorro</td>
			</tr>
			<c:forEach items="${cuentasAhoBean}" var="filacuentasAho" >
				<tr onclick="cargaValorLista('${campoLista}', '${filacuentasAho.cuentaAhoID}');">
					<td>${filacuentasAho.cuentaAhoID}</td>
					<td>${filacuentasAho.clienteID}</td>
					<td>${filacuentasAho.etiqueta}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '13' || tipoLista == '16' || tipoLista == '17'}">
			<tr id="encabezadoLista">
				<td>No. Cuenta</td>
				<td>No. <s:message code="safilocale.cliente"/></td>
				<td><s:message code="safilocale.cliente"/></td>
				<td>Cuenta Ahorro</td>
				<td>Sucursal</td>
				<td>Fecha Nacimiento</td>
			</tr>
			<c:forEach items="${cuentasAhoBean}" var="filacuentasAho" >
				<tr onclick="cargaValorListaCte('${campoLista}', '${filacuentasAho.cuentaAhoID}');">
					<td>${filacuentasAho.cuentaAhoID}</td>
					<td>${filacuentasAho.clienteID}</td>
					<td>${filacuentasAho.nombreCompleto}</td>
					<td>${filacuentasAho.etiqueta}</td>
					<td>${filacuentasAho.nombreSucursal}</td>
					<td>${filacuentasAho.fechaNacimiento}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '15'}">
			<tr id="encabezadoLista">
				<td>No. Cuenta</td>
				<td>No. <s:message code="safilocale.cliente"/></td>
				<td><s:message code="safilocale.cliente"/></td>
				<td>Cuenta Ahorro</td>
				<td>Fecha Nacimiento</td>
			</tr>
			<c:forEach items="${cuentasAhoBean}" var="filacuentasAho" >
				<tr onclick="cargaValorListaCte('${campoLista}', '${filacuentasAho.cuentaAhoID}');">
					<td>${filacuentasAho.cuentaAhoID}</td>
					<td>${filacuentasAho.clienteID}</td>
					<td>${filacuentasAho.nombreCompleto}</td>
					<td>${filacuentasAho.etiqueta}</td>
					<td>${filacuentasAho.fechaNacimiento}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '20'}">
			<tr id="encabezadoLista">
				<td>No. Cuenta</td>
				<td>Descripci&oacute;n</td>
				<td>Saldo</td>
			</tr>
			<c:forEach items="${cuentasAhoBean}" var="filacuentasAho" >
				<tr onclick="cargaValorListaCte('${campoLista}', '${filacuentasAho.cuentaAhoID}');">
					<td>${filacuentasAho.cuentaAhoID}</td>
					<td>${filacuentasAho.descripcionTipoCta}</td>
					<td>${filacuentasAho.saldo}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '21'}">
			<tr id="encabezadoLista">
				<td>No. Cuenta</td>
				<td><s:message code="safilocale.cliente"/></td>
				<td>Descripci&oacute;n</td>
			</tr>
			<c:forEach items="${cuentasAhoBean}" var="filacuentasAho" >
				<tr onclick="cargaValorLista('${campoLista}', '${filacuentasAho.cuentaAhoID}');">
					<td>${filacuentasAho.cuentaAhoID}</td>
					<td>${filacuentasAho.nombreCompleto}</td>
					<td>${filacuentasAho.etiqueta}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '24'}">
			<tr id="encabezadoLista">
				<td>No. Cuenta</td>
				<td><s:message code="safilocale.cliente"/></td>
			</tr>
			<c:forEach items="${cuentasAhoBean}" var="filacuentasAho" >
				<tr onclick="cargaValorLista('${campoLista}', '${filacuentasAho.cuentaAhoID}');">
					<td>${filacuentasAho.cuentaAhoID}</td>
					<td>${filacuentasAho.nombreCompleto}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '25'}">
			<tr id="encabezadoLista">
				<td>No. Cuenta</td>
				<td><s:message code="safilocale.cliente"/></td>
				<td>Monto</td>
			</tr>
			<c:forEach items="${cuentasAhoBean}" var="filacuentasAho" >
				<tr onclick="cargaValorLista('${campoLista}', '${filacuentasAho.cuentaAhoID}');">
					<td>${filacuentasAho.cuentaAhoID}</td>
					<td>${filacuentasAho.nombreCompleto}</td>
					<td>${filacuentasAho.etiqueta}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
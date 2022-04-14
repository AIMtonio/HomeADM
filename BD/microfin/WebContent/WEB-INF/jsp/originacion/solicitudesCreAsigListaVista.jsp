<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="solicitudesCreAsig" value="${listaResultado[2]}"/>


<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista	>= '1'}">
			<tr id="encabezadoLista">
				<td>No</td>
				<td>Cliente</td>
				<td>Estatus</td>
				<td>MontoAutorizado</td>
				<td>FechaRegistro</td>
				<td>Analista Asignado</td>
			</tr>
			<c:forEach items="${solicitudesCreAsig}" var="solicitudCreAsig" >
				<tr onClick="cargaValorLista('${campoLista}', '${solicitudCreAsig.solicitudCreditoID}');">
					<td>${solicitudCreAsig.solicitudCreditoID}</td>
					<td>${solicitudCreAsig.nombreCompletoC}</td>
					<c:if test="${solicitudCreAsig.estatusSolicitud == 'I'}">
						<td>INACTIVA</td>   
						</c:if> 
						<c:if test="${solicitudCreAsig.estatusSolicitud== 'A'}">
						<td>AUTORIZADA</td>   
						</c:if> 
						<c:if test="${solicitudCreAsig.estatusSolicitud == 'R'}">
						<td>RECHAZADA</td>   
						</c:if>
						<c:if test="${solicitudCreAsig.estatusSolicitud == 'C'}">
						<td>CANCELADA </td>   
						</c:if> 
						<c:if test="${solicitudCreAsig.estatusSolicitud == 'D'}">
						<td>DESEMBOLSADA </td>   
						</c:if> 
						<c:if test="${solicitudCreAsig.estatusSolicitud == 'L'}">
						<td>LIBERADA </td>   
					</c:if> 
					<td>${solicitudCreAsig.montoAutorizadoSolicitud}</td>
					<td>${solicitudCreAsig.fechaRegistroSolicitud}</td>
					<td>${solicitudCreAsig.nombreAnalista}</td>
				</tr>
			</c:forEach>
		</c:when>		
	</c:choose>
</table>


<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="solicitudCredito" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista != '8' && tipoLista != '15'&& tipoLista != '17'}">
			<tr id="encabezadoLista">
				<td>Num.</td>
				<td>Nombre</td>
				<td>Estatus</td>
				<td>MontoAutor.</td>
				<td>FechaRegistro</td>
			</tr>
			 <c:forEach items="${solicitudCredito}" var="solCred" >
				<tr onclick="cargaValorLista('${campoLista}', '${solCred.solicitudCreditoID}');">
					<td>${solCred.solicitudCreditoID}</td>		
					<td>${solCred.clienteID}</td> 			
					<c:if test="${solCred.estatus == 'I'}">
					<td>INACTIVA</td>   
					</c:if> 
					<c:if test="${solCred.estatus == 'A'}">
					<td>AUTORIZADA</td>   
					</c:if> 
					<c:if test="${solCred.estatus == 'R'}">
					<td>RECHAZADA</td>   
					</c:if>
					<c:if test="${solCred.estatus == 'C'}">
					<td>CANCELADA </td>   
					</c:if> 
					<c:if test="${solCred.estatus == 'D'}">
					<td>DESEMBOLSADA </td>   
					</c:if> 
					<c:if test="${solCred.estatus == 'L'}">
					<td>LIBERADA </td>   
					</c:if> 
					<td>${solCred.montoAutorizado}</td> 
					<td>${solCred.fechaRegistro}</td>
				</tr>
			</c:forEach> 
		</c:when>
		<c:when test="${tipoLista == '8'}">
			<tr id="encabezadoLista">
				<td>Num.</td>
				<td>Nombre</td>
				<td>Estatus</td>
				<td>MontoAutor.</td>
				<td>FechaRegistro</td>
			</tr>
			 <c:forEach items="${solicitudCredito}" var="solCred" >
				<tr onclick="cargaValorLista('${campoLista}', '${solCred.solicitudCreditoID}');">
					<td>${solCred.solicitudCreditoID}</td>
					<td>${solCred.nombreCompletoCliente}</td>	
					<c:if test="${solCred.estatus == 'I'}">
					<td>INACTIVA</td>   
					</c:if> 
					<c:if test="${solCred.estatus == 'A'}">
					<td>AUTORIZADA</td>   
					</c:if> 
					<c:if test="${solCred.estatus == 'R'}">
					<td>RECHAZADA</td>   
					</c:if>
					<c:if test="${solCred.estatus == 'C'}">
					<td>CANCELADA </td>   
					</c:if> 
					<c:if test="${solCred.estatus == 'D'}">
					<td>DESEMBOLSADA </td>   
					</c:if> 
					<td>${solCred.montoAutorizado}</td> 
					<td>${solCred.fechaRegistro}</td>
				</tr>
			</c:forEach> 
		</c:when>
		<c:when test="${tipoLista == '15'}">
			<tr id="encabezadoLista">
				<td>Num.</td>
				<td>Nombre</td>
				<td>Estatus</td>
				<td>MontoAutor.</td>
				<td>FechaRegistro</td>
			</tr>
			 <c:forEach items="${solicitudCredito}" var="solCred" >
				<tr onclick="cargaValorLista('${campoLista}', '${solCred.solicitudCreditoID}');">
					<td>${solCred.solicitudCreditoID}</td>
  					<c:if test="${solCred.clienteID != 0}">
						<td>${solCred.nombreCompletoCliente}</td>   
					</c:if> 
					<c:if test="${solCred.clienteID == 0}">
						<td>${solCred.nombreCompletoProspecto}</td>   
					</c:if> 
					<c:if test="${solCred.estatus == 'I'}">
					<td>INACTIVA</td>   
					</c:if> 
					<c:if test="${solCred.estatus == 'L'}">
					<td>LIBERADA</td>   
					</c:if> 
					<c:if test="${solCred.estatus == 'A'}">
					<td>AUTORIZADA</td>   
					</c:if> 
					<c:if test="${solCred.estatus == 'R'}">
					<td>RECHAZADA</td>   
					</c:if>
					<c:if test="${solCred.estatus == 'C'}">
					<td>CANCELADA </td>   
					</c:if> 
					<c:if test="${solCred.estatus == 'D'}">
					<td>DESEMBOLSADA </td>   
					</c:if> 
					<td>${solCred.montoAutorizado}</td> 
					<td>${solCred.fechaRegistro}</td>
				</tr>
			</c:forEach> 
		</c:when>
		<c:when test="${tipoLista == '17'}">
			<tr id="encabezadoLista">
				<td>Num.</td>
				<td>Nombre</td>
				<td>Tipo</td>
				<td>Monto Autorizado.</td>
				<td>Fecha Registro</td>
			</tr>
			 <c:forEach items="${solicitudCredito}" var="solCred" >
				<tr onclick="cargaValorLista('${campoLista}', '${solCred.solicitudCreditoID}');">
					<td>${solCred.solicitudCreditoID}</td>
					<td>${solCred.clienteID}</td> 
					<td>${solCred.tipoCredito}</td>
					<td>${solCred.montoAutorizado}</td> 
					<td>${solCred.fechaRegistro}</td>
				</tr>
			</c:forEach> 
		</c:when>
  	</c:choose>	
</table>

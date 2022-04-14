<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="cuentasBCAMovilBean" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1' || tipoLista== '3' || tipoLista== '4'}">
			<tr id="encabezadoLista">
				<td>Número</td>
				<c:if test="${tipoLista == '4'}">
					<td>Teléfono</td>   
				</c:if> 
				<c:if test="${tipoLista == '1' || tipoLista == '4'}">
					<td>UsuarioPDM</td>
				</c:if> 
				<td>Nombre</td>
				<c:if test="${tipoLista == '1'}">
					<td>Estatus</td> 
				</c:if> 				
			</tr>
			<c:forEach items="${cuentasBCAMovilBean}" var="usuariopdm" >
					<c:if test="${tipoLista == '1'}">
						<tr onclick="cargaValorLista('${campoLista}', '${usuariopdm.cuentasBcaMovID}');">
					</c:if>  
					<c:if test="${tipoLista == '3' || tipoLista == '4'}">
						<tr onclick="cargaValorLista('${campoLista}', '${usuariopdm.clienteID}');">
					</c:if>  					
 					<c:if test="${tipoLista == '3' || tipoLista == '4'}">
						<td>${usuariopdm.clienteID}</td>   
					</c:if> 
					<c:if test="${tipoLista == '1'}">
						<td>${usuariopdm.cuentasBcaMovID}</td>
					</c:if>  					
 					<c:if test="${tipoLista == '4'}">
						<td>${usuariopdm.telefono}</td>   
					</c:if> 
					<c:if test="${tipoLista == '1' || tipoLista == '4'}">
						<td>${usuariopdm.usuarioPDMID}</td> 
					</c:if>  					
					<td>${usuariopdm.nombreCompleto}</td>	
					<c:if test="${tipoLista == '1'}">
						<c:if test="${usuariopdm.estatus == 'A'}">
						<td>ACTIVA</td>   
						</c:if> 
						<c:if test="${usuariopdm.estatus == 'I'}">
						<td>INACTIVA</td>   
						</c:if>		
					</c:if>				
								
				</tr>
			</c:forEach>
		</c:when>

	</c:choose>
</table>
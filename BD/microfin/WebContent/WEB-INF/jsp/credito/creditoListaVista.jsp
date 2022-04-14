<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="creditosBean" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista >= '1' && tipoLista <= '20' || tipoLista=='41' || tipoLista=='42' || tipoLista=='44' || tipoLista=='47' || tipoLista=='48' || tipoLista=='49' || tipoLista=='50' || tipoLista=='51' || tipoLista=='53' || tipoLista=='54'
						|| tipoLista =='60' || tipoLista =='61' || tipoLista =='52' || tipoLista =='57'}">
			<tr id="encabezadoLista">
				<td>No. Cr&eacute;dito</td>
				<td nowrap="nowrap"><s:message code="safilocale.cliente"/></td>
				<td>Estatus</td>
				<td>Nombre Producto</td>	
				<td>Fecha Inicio</td>
				<td>Fecha Fin</td>	
			</tr>
			<c:forEach items="${creditosBean}" var="creditos" >
				<tr onclick="cargaValorLista('${campoLista}', '${creditos.creditoID}');">
					<td>${creditos.creditoID}</td>
					<td nowrap="nowrap">${creditos.clienteID}</td>
					<c:if test="${creditos.estatus == 'V'}">
					<td>VIGENTE</td>   
					</c:if> 
					<c:if test="${creditos.estatus == 'A'}">
					<td>AUTORIZADO</td> 
					</c:if>
					<c:if test="${creditos.estatus == 'I'}">
					<td>INACTIVO</td>
					</c:if> 
					<c:if test="${creditos.estatus == 'P'}">
					<td>PAGADO</td>
					</c:if> 
					<c:if test="${creditos.estatus == 'C'}">
					<td>CANCELADO</td>
					</c:if>
					<c:if test="${creditos.estatus == 'B'}">
					<td>VENCIDO</td>
					</c:if>
					<c:if test="${creditos.estatus == 'K'}">
					<td>CASTIGADO</td>
					</c:if>
					<c:if test="${creditos.estatus == 'S'}">
					<td>SUSPENDIDO</td>
					</c:if> 
					<td nowrap="nowrap">${creditos.nombreProducto}</td>
					<td nowrap="nowrap">${creditos.fechaInicio}</td>
					<td nowrap="nowrap">${creditos.fechaVencimien}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '24'   ||  tipoLista == '28' || tipoLista == 21 }">
			<tr id="encabezadoLista">
				<td>No. Cr&eacute;dito</td>
				<td nowrap="nowrap">No. <s:message code="safilocale.cliente"/></td>
				<td><s:message code="safilocale.cliente"/></td>
				<td nowrap="nowrap">Fec.Nacimiento</td>
				<td>Estatus</td>
				<td>Nombre Producto</td>	
				<td>Sucursal</td>
				<td>Fecha Inicio</td>
				<td>Fecha Fin</td>	
			</tr>
			<c:forEach items="${creditosBean}" var="creditos" >
				<tr onclick="cargaValorLista('${campoLista}', '${creditos.creditoID}');">
					<td>${creditos.creditoID}</td>
					<td nowrap="nowrap">${creditos.clienteID}</td>
					<td nowrap="nowrap">${creditos.nombreCliente}</td>
					<td nowrap="nowrap">${creditos.fecha}</td>
					
					<c:if test="${creditos.estatus == 'V'}">
						<td>VIGENTE</td>   
					</c:if> 
					<c:if test="${creditos.estatus == 'A'}">
						<td>AUTORIZADO</td> 
					</c:if>
					<c:if test="${creditos.estatus == 'I'}">
						<td>INACTIVO</td>
					</c:if> 
					<c:if test="${creditos.estatus == 'P'}">
						<td>PAGADO</td>
					</c:if> 
					<c:if test="${creditos.estatus == 'C'}">
						<td>CANCELADO</td>
					</c:if>
					<c:if test="${creditos.estatus == 'B'}">
						<td>VENCIDO</td>
					</c:if>
					<c:if test="${creditos.estatus == 'K'}">
						<td>CASTIGADO</td>
					</c:if>
					<c:if test="${creditos.estatus == 'S'}">
						<td>SUSPENDIDO</td>
					</c:if> 
					<td nowrap="nowrap">${creditos.nombreProducto}</td>
					<td nowrap="nowrap">${creditos.nombreSucursal}</td>
					<td nowrap="nowrap">${creditos.fechaInicio}</td>
					<td nowrap="nowrap">${creditos.fechaVencimien}</td>
				</tr>
			</c:forEach>
		</c:when>
		
		<c:when test="${tipoLista == '23' || tipoLista=='31' || tipoLista=='32' || tipoLista == '38'}">
			<tr id="encabezadoLista">
				<td>No. Cr&eacute;dito</td>
				<td><s:message code="safilocale.cliente"/></td>
				<td nowrap="nowrap">Fec.Nacimiento</td>
				<td>Estatus</td>
				<td>Nombre Producto</td>	
				<td>Fecha Inicio</td>
				<td>Fecha Fin</td>	
			</tr>
			<c:forEach items="${creditosBean}" var="creditos" >
				<tr onclick="cargaValorLista('${campoLista}', '${creditos.creditoID}');">
					<td>${creditos.creditoID}</td>
					<td nowrap="nowrap">${creditos.nombreCliente}</td>
					<td nowrap="nowrap">${creditos.fecha}</td>
					
					<c:if test="${creditos.estatus == 'V'}">
						<td>VIGENTE</td>   
					</c:if> 
					<c:if test="${creditos.estatus == 'A'}">
						<td>AUTORIZADO</td> 
					</c:if>
					<c:if test="${creditos.estatus == 'I'}">
						<td>INACTIVO</td>
					</c:if> 
					<c:if test="${creditos.estatus == 'P'}">
						<td>PAGADO</td>
					</c:if> 
					<c:if test="${creditos.estatus == 'C'}">
						<td>CANCELADO</td>
					</c:if>
					<c:if test="${creditos.estatus == 'B'}">
						<td>VENCIDO</td>
					</c:if>
					<c:if test="${creditos.estatus == 'K'}">
						<td>CASTIGADO</td>
					</c:if>
					<c:if test="${creditos.estatus == 'S'}">
						<td>SUSPENDIDO</td>
					</c:if> 
					<td nowrap="nowrap">${creditos.nombreProducto}</td>
					<td nowrap="nowrap">${creditos.fechaInicio}</td>
					<td nowrap="nowrap">${creditos.fechaVencimien}</td>
				</tr>
			</c:forEach>
		</c:when>
		
		<c:when test="${ tipoLista == '22' || tipoLista == '25' ||tipoLista == '36' || tipoLista == '37' || tipoLista == '33'|| tipoLista == '39'}">
			<tr id="encabezadoLista">
				<td>No. Cr&eacute;dito</td>
				<td nowrap="nowrap">No. <s:message code="safilocale.cliente"/></td>
				<td><s:message code="safilocale.cliente"/></td>
				<td>Estatus</td>
				<td>Nombre Producto</td>	
				<td>Sucursal</td>
				<td>Fecha Inicio</td>	
				<td>Fecha Fin</td>	
			</tr>
			<c:forEach items="${creditosBean}" var="creditos" >
				<tr onclick="cargaValorLista('${campoLista}', '${creditos.creditoID}');">
					<td>${creditos.creditoID}</td>
					<td nowrap="nowrap">${creditos.clienteID}</td>
					<td nowrap="nowrap">${creditos.nombreCliente}</td>
					
					<c:if test="${creditos.estatus == 'V'}">
						<td>VIGENTE</td>   
					</c:if> 
					<c:if test="${creditos.estatus == 'A'}">
						<td>AUTORIZADO</td> 
					</c:if>
					<c:if test="${creditos.estatus == 'I'}">
						<td>INACTIVO</td>
					</c:if> 
					<c:if test="${creditos.estatus == 'P'}">
						<td>PAGADO</td>
					</c:if> 
					<c:if test="${creditos.estatus == 'C'}">
						<td>CANCELADO</td>
					</c:if>
					<c:if test="${creditos.estatus == 'B'}">
						<td>VENCIDO</td>
					</c:if>
					<c:if test="${creditos.estatus == 'K'}">
						<td>CASTIGADO</td>
					</c:if>
					<c:if test="${creditos.estatus == 'S'}">
						<td>SUSPENDIDO</td>
					</c:if>
					<td nowrap="nowrap">${creditos.nombreProducto}</td>
					<td nowrap="nowrap">${creditos.nombreSucursal}</td>
					<td nowrap="nowrap">${creditos.fechaInicio}</td>
					<td nowrap="nowrap">${creditos.fechaVencimien}</td>
				</tr>
			</c:forEach>
		</c:when>
		
				<c:when test="${ tipoLista == '29' || tipoLista == '30' }">
			<tr id="encabezadoLista">
				<td>No. Cr&eacute;dito</td>
				<td nowrap="nowrap">No. <s:message code="safilocale.cliente"/></td>
				<td><s:message code="safilocale.cliente"/></td>
				<td>Estatus</td>
				<td>Nombre Producto</td>
				<td>Fecha Inicio</td>	
				<td>Fecha Fin</td>
			</tr>
			<c:forEach items="${creditosBean}" var="creditos" >
				<tr onclick="cargaValorLista('${campoLista}', '${creditos.creditoID}');">
					<td>${creditos.creditoID}</td>
					<td nowrap="nowrap">${creditos.clienteID}</td>
					<td nowrap="nowrap">${creditos.nombreCliente}</td>
					
					<c:if test="${creditos.estatus == 'V'}">
						<td>VIGENTE</td>   
					</c:if> 
					<c:if test="${creditos.estatus == 'A'}">
						<td>AUTORIZADO</td> 
					</c:if>
					<c:if test="${creditos.estatus == 'I'}">
						<td>INACTIVO</td>
					</c:if> 
					<c:if test="${creditos.estatus == 'P'}">
						<td>PAGADO</td>
					</c:if> 
					<c:if test="${creditos.estatus == 'C'}">
						<td>CANCELADO</td>
					</c:if>
					<c:if test="${creditos.estatus == 'B'}">
						<td>VENCIDO</td>
					</c:if>
					<c:if test="${creditos.estatus == 'K'}">
						<td>CASTIGADO</td>
					</c:if>
					<c:if test="${creditos.estatus == 'S'}">
						<td>SUSPENDIDO</td>
					</c:if>
					<td nowrap="nowrap">${creditos.nombreProducto}</td>
					<td nowrap="nowrap">${creditos.fechaInicio}</td>
					<td nowrap="nowrap">${creditos.fechaVencimien}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '35'}">
			<tr id="encabezadoLista">
				<td>No. Cr&eacute;dito</td>
				<td nowrap="nowrap"><s:message code="safilocale.cliente"/></td>
				<td>Estatus</td>
				<td>Nombre Producto</td>	
				<td>Fecha Inicio</td>
				<td>Fecha Fin</td>	
			</tr>
			<c:forEach items="${creditosBean}" var="creditos" >
				<tr onclick="cargaValorLista('${campoLista}', '${creditos.creditoID}');">
					<td>${creditos.creditoID}</td>
					<td nowrap="nowrap">${creditos.clienteID}</td>
					<c:if test="${creditos.estatus == 'I'}">
					<td>INACTIVO</td>
					</c:if> 
					<td nowrap="nowrap">${creditos.nombreProducto}</td>
					<td nowrap="nowrap">${creditos.fechaInicio}</td>
					<td nowrap="nowrap">${creditos.fechaVencimien}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '43'}">
			<tr id="encabezadoLista">
				<td>No. Cr&eacute;dito</td>
				<td nowrap="nowrap"><s:message code="safilocale.cliente"/></td>
				<td>Estatus</td>
				<td>Nombre Producto</td>	
				<td>Fecha Inicio</td>
				<td>Fecha Fin</td>	
			</tr>
			<c:forEach items="${creditosBean}" var="creditos" >
				<tr onclick="cargaValorLista('${campoLista}', '${creditos.creditoID}');">
					<td>${creditos.creditoID}</td>
					<td nowrap="nowrap">${creditos.clienteID}</td>
					<c:if test="${creditos.estatus == 'V'}">
					<td>VIGENTE</td>   
					</c:if> 
					<c:if test="${creditos.estatus == 'A'}">
					<td>AUTORIZADO</td> 
					</c:if>
					<c:if test="${creditos.estatus == 'I'}">
					<td>INACTIVO</td>
					</c:if> 
					<c:if test="${creditos.estatus == 'P'}">
					<td>PAGADO</td>
					</c:if> 
					<c:if test="${creditos.estatus == 'C'}">
					<td>CANCELADO</td>
					</c:if>
					<c:if test="${creditos.estatus == 'B'}">
					<td>VENCIDO</td>
					</c:if>
					<c:if test="${creditos.estatus == 'K'}">
					<td>CASTIGADO</td>
					</c:if> 
					<c:if test="${creditos.estatus == 'M'}">
					<td>PROCESADO</td>
					</c:if>
					<c:if test="${creditos.estatus == 'S'}">
					<td>SUSPENDIDO</td>
					</c:if> 
					<td nowrap="nowrap">${creditos.nombreProducto}</td>
					<td nowrap="nowrap">${creditos.fechaInicio}</td>
					<td nowrap="nowrap">${creditos.fechaVencimien}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '56'}">
			<tr id="encabezadoLista">
				<td>No. Cr&eacute;dito</td>
				<td nowrap="nowrap"><s:message code="safilocale.cliente"/></td>
				<td>Tipo</td>
				<td>Monto</td>
				<td>Fecha</td>	
			</tr>
			<c:forEach items="${creditosBean}" var="creditos" >
				<tr onclick="cargaValorLista('${campoLista}', '${creditos.creditoID}');">
					<td>${creditos.creditoID}</td>
					<td nowrap="nowrap">${creditos.nombreCliente}</td>
					<td nowrap="nowrap">${creditos.tipoCredito}</td>
					<td nowrap="nowrap">${creditos.montoCredito}</td>
					<td nowrap="nowrap">${creditos.fechaMinistrado}</td>					
				</tr>
			</c:forEach>
		</c:when>
		
		<c:when test="${tipoLista == '59'}">
			<tr id="encabezadoLista">
				<td>No. Cr&eacute;dito</td>
				<td nowrap="nowrap"><s:message code="safilocale.cliente"/></td>
				<td>Estatus</td>
			</tr>
			<c:forEach items="${creditosBean}" var="creditos" >
				<tr onclick="cargaValorLista('${campoLista}', '${creditos.creditoID}');">
					<td>${creditos.creditoID}</td>
					<td nowrap="nowrap">${creditos.nombreCliente}</td>
					<td nowrap="nowrap">${creditos.estatus}</td>			
				</tr>
			</c:forEach>
		</c:when>	
	</c:choose>
</table>
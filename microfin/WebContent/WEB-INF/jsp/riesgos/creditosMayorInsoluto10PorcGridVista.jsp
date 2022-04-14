<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

	<table id="miTabla" border="0" width="100%">
		<c:choose>
			<c:when test="${tipoLista == '1'}">
				<tr>
					<td class="label" align="center">
					   	<label for="consecutivo"></label> 
					</td>
					<td class="label" align="center" nowrap="nowrap">
						<label for="clienteID">N&uacute;mero <s:message code="safilocale.cliente"/></label> 
			  		</td>
					<td class="label" align="center" nowrap="nowrap">
						<label for="creditoID">N&uacute;mero Cr&eacute;dito</label> 
			  		</td>
			  		<td class="label" align="center">
						<label for="saldoInsoluto">Saldo Insoluto</label> 
			  		</td>
			  		<td class="label" align="center">
						<label for="sucursalID">Sucursal</label> 
			  		</td>
			 	</tr>
				<c:forEach items="${listaResultado}" var="listaSaldo" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td> 
							<input id="consecutivo${status.count}"  name="consecutivo" size="3" value="${status.count}" readOnly="true" type="text" style='text-align:left;'/> 
					  	</td> 
					  	<td> 
							<input type="text" id="clienteID${status.count}"  name="clienteID" size="12" value="${listaSaldo.clienteID}" readOnly="true" style='text-align:left;' /> 
						</td>
						<td> 
							<input type="text" id="creditoID${status.count}"  name="creditoID" size="12" value="${listaSaldo.creditoID}" readOnly="true" style='text-align:left;' /> 
						</td> 
						<td> 
							<input type="text" id="saldoInsoluto${status.count}"  name="saldoInsoluto" size="20" value="${listaSaldo.saldoInsoluto}" readOnly="true"  esMoneda="true" style='text-align:right;' /> 
						</td> 
					  	<td> 
					  		<input type="text" id="sucursalID${status.count}" name="sucursalID" size="12" value="${listaSaldo.sucursalID}" readOnly="true" style='text-align:right;'/> 
					  	</td> 
					</tr>
				</c:forEach>
			</c:when>
		</c:choose>
	</table>


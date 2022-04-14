<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

	<table id="miTabla" border="0"  width="100%">
		<c:choose>
			<c:when test="${tipoLista == '2'}">
				<tr>
					<td class="label" align="center">
					   	<label for="consecutivo"></label> 
					</td>
					<td class="label" align="center">
						<label for="clienteID">Num. Socio</label> 
			  		</td>
			  		<td class="label" align="center">
						<label for="ahorro">Ahorro Ordinario</label> 
			  		</td>
			  		<td class="label" align="center">
						<label for="ahorro">Ahorro Vista</label> 
			  		</td>
			  		<td class="label" align="center">
						<label for="inversion">Inversiones</label> 
			  		</td>
			 	</tr>
				<c:forEach items="${listaResultado}" var="listaTipoAhorro" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td> 
							<input id="consecutivo${status.count}"  name="consecutivo" size="3" value="${status.count}" readOnly="true" type="text" style='text-align:left;'/> 
					  	</td> 
						<td> 
							<input type="text" id="clienteID${status.count}"  name="clienteID" size="12" value="${listaTipoAhorro.clienteID}" readOnly="true" style='text-align:left;' /> 
						</td> 
						<td> 
							<input type="text" id="ordinario${status.count}"  name="ordinario" size="20" value="${listaTipoAhorro.sumAhorroOrdin}" readOnly="true" style='text-align:right;' /> 
						</td> 
						<td> 
							<input type="text" id="vista${status.count}"  name="vista" size="20" value="${listaTipoAhorro.sumAhorroVista}" readOnly="true" style='text-align:right;' /> 
						</td> 
					  	<td> 
					  		<input type="text" id="inversion${status.count}" name="inversion" size="20" value="${listaTipoAhorro.sumInversion}" readOnly="true" style='text-align:right;'/> 
					  	</td> 
					</tr>
				</c:forEach>
			</c:when>
		</c:choose>
	</table>



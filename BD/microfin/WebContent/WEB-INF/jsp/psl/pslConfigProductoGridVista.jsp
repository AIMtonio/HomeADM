<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<html> 
<head>
</head>

<body>
	<c:set var="tipoLista"  value="${listaResultado[0]}"/>
	<c:set var="listaPaginada" value="${listaResultado[1]}" />
	<c:set var="listaResultado" value="${listaPaginada.pageList}"/>
	<c:set var="indiceTab" value="18"/>
	
	<table id="tblConfigProductos" border="0" cellpadding="0" cellspacing="0" width="100%">
		<c:choose>
			<c:when test="${tipoLista == '2'}">
				<thead>	
					<tr id="encabezadoLista">							
						<td class="label" align="center">Producto</td>	
						<td class="label" align="center">DigVerificador</td>
						<td class="label" align="center">TipoReferencia</td>
						<td class="label" align="center">Precio</td>
						<td class="label" align="center">Activo</td>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${listaResultado}" var="configProducto" varStatus="status">	
						<tr id="renglons${status.count}" name="renglons">	
							<td nowrap="nowrap" width="60%"> 
								<c:set var="indiceTab" value="${indiceTab + 1}"/>
								<input type="text" id="productos${status.count}" tabindex="${indiceTab}" name="productos" maxlength="200" size="100%" value="${configProducto.producto}"/>
								<input type="hidden" name="productosID" value="${configProducto.productoID}" />
							</td>
						  	<td> 
								<label>${configProducto.digVerificador}</label>
						  	</td>
						  	<td >
								<label>${configProducto.tipoReferencia}</label>
							</td>
							<td> 
								<label>${configProducto.precio}</label>
						  	</td>
						  	<td> 
								<c:set var="indiceTab" value="${indiceTab + 1}"/>
						  		<input type="hidden" id="hHabilitado${status.count}" value="${configProducto.habilitado}" name="habilitados" />
								<label><input type="checkbox" tabindex="${indiceTab}" id="cbHabilitado${status.count}" ${configProducto.habilitado=='S'?"checked='checked'":""} onclick='$("#hHabilitado${status.count}").val($(this).attr("checked")?"S":"N")'/></label>
						  	</td>		  				
						</tr>
					</c:forEach>
				</tbody>
			</c:when>			
		</c:choose>
	</table>
	<c:set var="indiceTab" value="${indiceTab + 1}"/>
	<input type="hidden" id="indiceTab" name="indiceTab" value="${indiceTab}"/>
</body>
</html>
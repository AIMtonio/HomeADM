<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="listaResultado"  value="${listaResultado}"/>
<%! int numFilas = 0; %>
<%! int counter = 4; %>

<table border="0" width="100%">
	<tr>

		<td>
			<table id="tbParametrizacion" border="0" width="50px">
			<tr >
			    <td class="ui-widget ui-widget-header ui-corner-all" >
			    	No Solicitud  
			    </td>  
			    <td class="ui-widget ui-widget-header ui-corner-all" >
			    	 Producto 
			    </td>
			    <td class="ui-widget ui-widget-header ui-corner-all" >
			    	No Cliente
			    </td>  
			    <td class="ui-widget ui-widget-header ui-corner-all" >
			    	 Nombre del Cliente 
			    </td>
			   
			 </tr>   
				<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
				<% numFilas=numFilas+1; %>
				<% counter++; %>

				<tr id="tr${detalle.tipoAsignacionID}${status.count}" name="tr${detalle.tipoAsignacionID}">
					<td nowrap="nowrap">
						<input type="text" id="solicitudCreditoID${detalle.tipoAsignacionID}${status.count}" tabindex="<%=counter %>" name="solicitudCreditoID${detalle.tipoAsignacionID}" size=15 value="${detalle.solicitudCreditoID}"  readonly="readonly" disabled="true" />
					</td>
					<td>
						<input type="text" id="descripcionProducto${detalle.tipoAsignacionID}${status.count}" name="descripcionProducto${detalle.tipoAsignacionID}" size="45" value="${detalle.descripcionProducto}" readonly="readonly" disabled="true"/>
					</td>
					<td>
						<input type="text" id="clienteID${detalle.tipoAsignacionID}${status.count}" name="clienteID${detalle.tipoAsignacionID}" size="15" value="${detalle.clienteID}"  readonly="readonly" disabled="true"/>
					</td>
					<td>	
						<input type="text" id="nombreCompletoC${detalle.tipoAsignacionID}${status.count}" name="nombreCompletoC${detalle.tipoAsignacionID}" size="45" value="${detalle.nombreCompletoC}"  readonly="readonly" disabled="true"/>
					</td>

					<td nowrap="nowrap">
						<input type="hidden" id="tipoAsignacionID${detalle.tipoAsignacionID}${status.count}" tabindex="<%=counter %>" name="tipoAsignacionID${detalle.tipoAsignacionID}" size=40 value="${detalle.tipoAsignacionID}"  readonly="readonly" disabled="true" />
					</td>
					
					<td nowrap="nowrap">
						<input type="hidden" id="productoID${detalle.tipoAsignacionID}${status.count}" tabindex="<%=counter %>" name="productoID${detalle.tipoAsignacionID}" size=40 value="${detalle.productoID}"  readonly="readonly" disabled="true" />
					</td>
					<td nowrap="nowrap">
						<input type="hidden" id="usuarioID${detalle.tipoAsignacionID}${status.count}" tabindex="<%=counter %>" name="usuarioID${detalle.tipoAsignacionID}" size=40 value="${detalle.usuarioID}"  readonly="readonly" disabled="true" />
					</td>
				
				</tr>
				</c:forEach>
			</table>
		</td>
	</tr>
</table>
<script type="text/javascript" >

</script>
<input type="hidden" id="numTab" value="<%=counter %>"/>
<input type="hidden" id="numeroFila" value="<%=numFilas %>"/>
<% numFilas=0; %>
<% counter=4; %>
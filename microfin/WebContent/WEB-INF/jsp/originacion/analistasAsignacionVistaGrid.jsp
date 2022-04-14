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
			    	Clave Usuario 
			    </td>  
			    <td colspan="2" align="center" class="ui-widget ui-widget-header ui-corner-all">
			    	 Nombre 
			    </td>
			   
			 </tr>   
				<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
				<% numFilas=numFilas+1; %>
				<% counter++; %>

				<tr id="tr${detalle.tipoAsignacionID}${status.count}" name="tr${detalle.tipoAsignacionID}">
						<td nowrap="nowrap">
						
						<input type="text" id="clave${detalle.tipoAsignacionID}${status.count}" tabindex="<%=counter %>" name="clave${detalle.tipoAsignacionID}" size=20 value="${detalle.clave}" maxlength="5"  readonly="readonly" disabled="true" />
					</td>
					<td>
						<input type="text" id="nombreCompleto${detalle.tipoAsignacionID}${status.count}" name="nombreCompleto${detalle.tipoAsignacionID}" size="65" value="${detalle.nombreCompleto}" maxlength="150" readonly="readonly" disabled="true"/>
					</td>
					<td nowrap="nowrap">
						<input type="button" id="eliminar${detalle.tipoAsignacionID}${status.count}" name="eliminar${detalle.tipoAsignacionID}" value="" class="btnElimina" onclick="eliminarParam('tr${detalle.tipoAsignacionID}${status.count}')" tabindex="<%=counter %>"/>
					
					</td>
					<td nowrap="nowrap">
						
						<input type="hidden" id="usuarioID${detalle.tipoAsignacionID}${status.count}" tabindex="<%=counter %>" name="usuarioID${detalle.tipoAsignacionID}" size=15 value="${detalle.usuarioID}" maxlength="5" readonly="readonly" disabled="true" />
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
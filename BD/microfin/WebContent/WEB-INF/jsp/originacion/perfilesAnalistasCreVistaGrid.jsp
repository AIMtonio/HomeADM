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
			<table id="tbParametrizacion" border="0" width="350px">
			
			    <td>	<label>ID: </label>  </td>   <td><label> Perfil: </label></td>
				<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
				<% numFilas=numFilas+1; %>
				<% counter++; %>

				<tr id="tr${detalle.tipoPerfil}${status.count}" name="tr${detalle.tipoPerfil}">
						<td nowrap="nowrap">
						
						<input type="text" id="rolID${detalle.tipoPerfil}${status.count}" tabindex="<%=counter %>" name="rolID${detalle.tipoPerfil}" size=5 value="${detalle.rolID}" maxlength="5" onblur="consultaRoles(this.id,'nombreRol${detalle.tipoPerfil}${status.count}')" onkeypress="listaRoles(this.id)" readonly="readonly" disabled="true" />
					</td>
					<td>
						<input type="text" id="nombreRol${detalle.tipoPerfil}${status.count}" name="nombreRol${detalle.tipoPerfil}" size="32" value="${detalle.nombreRol}" maxlength="150" readonly="readonly" disabled="true"/>
					</td>
					<td nowrap="nowrap">
						<input type="button" id="eliminar${detalle.tipoPerfil}${status.count}" name="eliminar${detalle.tipoPerfil}" value="" class="btnElimina" onclick="eliminarParam('tr${detalle.tipoPerfil}${status.count}')" tabindex="<%=counter %>"/>
					
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
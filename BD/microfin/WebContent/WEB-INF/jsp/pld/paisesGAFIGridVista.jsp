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
				<tr>
					<td style="width: 10px">
						<input type="button" class="submit" value="Agregar" id="btnAgregar" tabindex="1" onclick="agregarDetalle(this.id)"/>
					</td>
				</tr>
				<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
				<% numFilas=numFilas+1; %>
				<% counter++; %>
				<tr id="tr${detalle.tipoPais}${status.count}" name="tr${detalle.tipoPais}">
					<td nowrap="nowrap">
						<label>Pa&iacute;s: </label>
						<input type="text" id="paisID${detalle.tipoPais}${status.count}" tabindex="<%=counter %>" name="paisID${detalle.tipoPais}" size="5" value="${detalle.paisID}" maxlength="5" onblur="consultaPais(this.id,'nombre${detalle.tipoPais}${status.count}')" onkeypress="listaPaises(this.id)" onchange="verificaSeleccionado(this.id)" />
					</td>
					<td>
						<input type="text" id="nombre${detalle.tipoPais}${status.count}" name="nombre${detalle.tipoPais}" size="32" value="${detalle.nombre}" maxlength="150" readonly="readonly" disabled="true"/>
					</td>
					<td nowrap="nowrap">
						<input type="button" id="eliminar${detalle.tipoPais}${status.count}" name="eliminar${detalle.tipoPais}" value="" class="btnElimina" onclick="eliminarParam('tr${detalle.tipoPais}${status.count}')" tabindex="<%=counter %>"/>
						<input type="button" id="agrega${detalle.tipoPais}${status.count}" name="agrega${detalle.tipoPais}" value="" class="btnAgrega" onclick="agregarDetalle(this.id)" tabindex="<%=counter %>"/>
					</td>
				</tr>
				</c:forEach>
			</table>
		</td>
	</tr>
</table>
<script type="text/javascript" >
	habilitaGrabar();
</script>
<input type="hidden" id="numTab" value="<%=counter %>"/>
<input type="hidden" id="numeroFila" value="<%=numFilas %>"/>
<% numFilas=0; %>
<% counter=4; %>
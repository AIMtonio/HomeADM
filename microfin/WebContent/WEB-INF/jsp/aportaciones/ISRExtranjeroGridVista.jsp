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
				<tbody>
				<tr>
					<td style="width: 10px" colspan="4">
						<input type="button" class="submit" value="Agregar" id="btnAgregar" tabindex="1" onclick="agregarDetalle(this.id)"/>
					</td>
				</tr>
				<tr>
					<td class="label">
						<label>Pa&iacute;s</label>
					</td>
					<td class="label">
						<label></label>
					</td>
					<td class="label" style="text-align: center;">
						<label>Tasa</label>
					</td>
					<td class="label">
					</td>
				</tr>
				<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
				<% numFilas=numFilas+1; %>
				<% counter++; %>
				<tr id="tr${status.count}" name="tr">
					<td nowrap="nowrap">
						<input type="text" id="paisID${status.count}" tabindex="<%=counter %>" name="paisID" size="5" value="${detalle.paisID}" maxlength="5" onblur="consultaPais(this.id,'nombre${status.count}')" onkeypress="listaPaises(this.id)" onchange="verificaSeleccionado(this.id)" />
					</td>
					<td nowrap="nowrap">
						<input type="text" id="nombre${status.count}" name="nombre" size="32" value="${detalle.nombre}" maxlength="150" readonly="readonly" disabled="true"/>
					</td>
					<td nowrap="nowrap">
						<input type="text" id="tasaISR${status.count}" name="tasaISR" size="8" value="${detalle.tasaISR}" maxlength="150" esMoneda="true" style="text-align: right;" tabindex="<%=counter %>" onchange="validaTasaISR(this.id)"/>
						<label></label>
					</td>
					<td nowrap="nowrap">
						<input type="button" id="eliminar${status.count}" name="eliminar" value="" class="btnElimina" onclick="eliminarParam('tr${status.count}')" tabindex="<%=counter %>"/>
						<input type="button" id="agrega${status.count}" name="agrega" value="" class="btnAgrega" onclick="agregarDetalle(this.id)" tabindex="<%=counter %>"/>
					</td>
				</tr>
				</c:forEach>
				</tbody>
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
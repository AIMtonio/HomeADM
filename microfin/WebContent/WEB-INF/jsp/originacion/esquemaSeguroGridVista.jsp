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
<table border="0" width="100%" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<input type="button" class="submit" value="Agregar" id="btnAgregar" tabindex="2" onclick="agregarDetalle()"/>
		</td>
	</tr>
	<tr>
		<td>
			<table id="tbParametrizacion" border="0" width="300px">
				<tr>
					<td class="label"><label>Frecuencia</label></td>
					<td class="label"><label>Monto</label></td>
					<td nowrap="nowrap"></td>
				</tr>
				<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
				<% numFilas=numFilas+1; %>
				<% counter++; %>
				<tr id="tr${status.count}">
					<td>
						<select id="frecuencia${status.count}" name="frecuencia" onblur="verificaSeleccionado(this.id)" tabindex="<%=counter %>" >
						</select>
						<input type="hidden" id="auxfrecuencia${status.count}" tabindex="<%=counter %>" name="auxfrecuencia" size="5" value="${detalle.frecuencia}" />
					</td>
					<td>
						<input type="text" id="monto${status.count}" tabindex="<%=counter %>" name="monto" esmoneda="true" size="16" value="${detalle.monto}"  maxlength="15" style="text-align: right;"/>
					</td>
					<td nowrap="nowrap">
						<input type="button" name="eliminar" value="" class="btnElimina" onclick="eliminarParam('tr${status.count}')" tabindex="<%=counter %>"/>
						<input type="button" name="agrega" value="" class="btnAgrega" onclick="agregarDetalle()" tabindex="<%=counter %>"/>
					</td>
				</tr>
				</c:forEach>
			</table>
		</td>
	</tr>
	
</table>
<input type="hidden" id="numTab" value="<%=counter %>"/>
<input type="hidden" id="numeroFila" value="<%=numFilas %>"/>
<% numFilas=0; %>
<% counter=4; %>
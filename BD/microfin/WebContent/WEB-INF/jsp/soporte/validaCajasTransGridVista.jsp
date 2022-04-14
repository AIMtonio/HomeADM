<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="listaResultado" value="${listaResultado[0]}"/>
<%! int numFilas = 0; %>
<%! int counter = 2; %>
<table id="tbParametrizacion" width="100">
	<tr>
		<td>
			<input type="button" class="submit" value="Agregar" id="btnAgregar" tabindex="1" onclick="agregarDetalle(this.id)"/>
		</td>
	</tr>
	<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
		<% numFilas=numFilas+1; %>
		<% counter++; %>
		<tr id="tr${status.count}" name="trDestinatario">
			<td nowrap="nowrap">
				<input type="text" id="destinatarioID${status.count}" tabindex="<%=counter%>" name="destinatarioID" size="5" value="${detalle.destinatarioID}" onblur="consultaUsuario(this.id, ${status.count}, 1)" onkeypress="funcionListaUsuario(this.id)"/>
				<input type="text" id="destinatarioNombre${status.count}" name="destinatarioNombre" size="40" value="${detalle.destinatarioNombre}" readonly/>
				<input type="hidden" id="tipo${status.count}" name="tipo" value="${detalle.tipo}"/>
			</td>
			<td nowrap="nowrap">
				<input type="button" id="eliminar${status.count}" name="eliminar" value="" class="btnElimina" onclick="eliminarParam('tr${status.count}')" tabindex="<%=counter %>"/>
				<input type="button" id="agrega${status.count}" name="agrega" value="" class="btnAgrega" onclick="agregarDetalle(this.id)" tabindex="<%=counter %>"/>
			</td>
		</tr>
	</c:forEach>
</table>
<input type="hidden" id="numTab" value="<%=counter %>"/>
<input type="hidden" id="numeroFila" value="<%=numFilas %>"/>
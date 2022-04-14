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
<table id="tbParametrizacion2" width="100">
	<tr>
		<td>
			<input type="button" class="submit" value="Agregar" id="btnAgregarCC" tabindex="1" onclick="agregarConCopia(this.id)"/>
		</td>
	</tr>
	<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
		<% numFilas=numFilas+1; %>
		<% counter++; %>
		<tr id="trCC${status.count}" name="trConCopia">
			<td nowrap="nowrap">
				<input type="text" id="conCopiaID${status.count}" tabindex="<%=counter%>" name="conCopiaID" size="5" value="${detalle.conCopiaID}" onblur="consultaUsuario(this.id, ${status.count}, 2)" onkeypress="funcionListaUsuario(this.id)"/>
				<input type="text" id="conCopiaNombre${status.count}" name="conCopiaNombre" size="40" value="${detalle.destinatarioNombre}" readonly/>
				<input type="hidden" id="tipo${status.count}" name="tipo" value="${detalle.tipo}"/>
			</td>
			<td nowrap="nowrap">
				<input type="button" id="eliminarCC${status.count}" name="eliminarCC" value="" class="btnElimina" onclick="eliminarParamCC('trCC${status.count}')" tabindex="<%=counter %>"/>
				<input type="button" id="agregaCC${status.count}" name="agregaCC" value="" class="btnAgrega" onclick="agregarConCopia(this.id)" tabindex="<%=counter %>"/>
			</td>
		</tr>
	</c:forEach>
</table>
<input type="hidden" id="numTab" value="<%=counter %>"/>
<input type="hidden" id="numeroFila" value="<%=numFilas %>"/>
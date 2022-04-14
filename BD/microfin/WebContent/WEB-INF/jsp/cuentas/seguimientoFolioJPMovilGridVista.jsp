<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="listaCometarios" 	value="${listaResultado}"/>

<table border="0" width="100%">
	<c:forEach items="${listaCometarios}" var="comentario" varStatus="status">
	<c:choose>
		<c:when test="${comentario.comentarioUsuario != ''&&comentario.comentarioCliente != ''}">
			<tr>
				<td class="label" align="left">
					<textarea  id="cometarioUsuario${status.count}" cols="35" rows="4" style="resize:none;" disabled="disabled" readonly="readonly">${comentario.comentarioUsuario}</textarea>
				</td>
				<td class="separador"/>
				<td>
				</td>
			</tr>
			<tr>
				<td>

				</td>
				<td class="separador"/>
				<td class="label" align="right">
					<textarea id="cometarioCliente${status.count}" cols="35" rows="4" style="resize:none; text-align:right;" disabled="disabled" readonly="readonly">${comentario.comentarioCliente}</textarea>
				</td>
			</tr>
		</c:when>
		<c:when test="${comentario.comentarioUsuario != ''}">
			<tr>
				<td class="label" align="left">
					<textarea id="comentarioUsuario${status.count}" cols="35" rows="4" style="resize:none;" disabled="disabled" readonly="readonly">${comentario.comentarioUsuario}</textarea>
				</td>
				<td class="separador"/>
				<td>
				</td>
			</tr>
		</c:when>
		<c:when test="${comentario.comentarioCliente != ''}">
			<tr>
				<td>

				</td>
				<td class="separador"/>
				<td  align="right">
					<textarea id="comentarioCliente${status.count}" cols="35" rows="4" style="resize:none; text-align:right;" disabled="disabled" readonly="readonly">${comentario.comentarioCliente}</textarea>
				</td>
			</tr>
		</c:when>
	</c:choose>
	</c:forEach>
</table>
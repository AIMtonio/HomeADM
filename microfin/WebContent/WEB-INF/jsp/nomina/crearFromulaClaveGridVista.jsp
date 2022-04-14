<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="listaClave" value="${listaResultado[1]}" />

<c:choose>
	<c:when test="${tipoLista == '2'}">
		<table id="miTabla">
			<tbody>
				<c:forEach items="${listaClave}" var="clave" varStatus="status">
					<tr id="renglon${status.count}" name="renglon" align="center">
						<td>
							<input type="hidden" id="claveID${status.count}" name="claveID" size="6"  value="${clave.nomClasifClavPresupID}"></input>
							<input type="button" class="submit cambioColor"  id="desClave${status.count}" name="desClave"  value="${clave.descripcion}" onclick="creaFormulaCap('renglon${status.count}')"></input>
						</td>
					</tr>
					<c:set var="numeroClave" value="${status.count}" />
				</c:forEach>
				<input type="hidden" value="${numeroClave}" name="numero" id="numero" />
			</tbody>
		</table>
	</c:when>
</c:choose>
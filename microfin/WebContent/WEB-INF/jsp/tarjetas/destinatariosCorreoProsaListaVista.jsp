<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
  

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<!--<c:set var="campoLista" value="${listaResultado[1]}"/>-->
<c:set var="items" value="${listaResultado[1]}"/>
<c:set var="tamanioLista" value="${listaResultado[2]}"/>
<c:set var="indexRenglon" value='0'/>


<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<c:if test="${tamanioLista gt 0}">		
				<c:forEach items="${items}" var="datos" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td>
							<input id="usuarioDest${status.count}" name="usuarioDest" value=${datos.usuario} size="10" type="text" onkeyup="listaDestina(this.value, 'usuarioDest${status.count}');" onblur="blurDestinatario('usuarioDest${status.count}', 'correo${status.count}');" />
						</td>
						
						<td>
							<input id="correo${status.count}" name="correoSalida" value=${datos.correoSalida} size="50" type="text"/>
							<td align="center">	<input type="button" name="elimina" id="${status.count}" class="btnElimina" onclick="eliminaDestinatario('renglon${status.count}')"/> </td>
							<td align="center">	<input type="button" name="agrega" id="${status.count}" class="btnAgrega" onclick="agregaDestinatario('${tamanioLista}')"/> </td>
						</td>
					</tr>
				</c:forEach>
			</c:if>
			<c:if test="${tamanioLista lt 1}">			
				<tr id="renglon${indexRenglon}" name="renglon">
						<td>
							<input id="usuarioDest${indexRenglon}" name="usuarioDest" size="10" type="text" onkeyup="listaDestina(this.value, 'usuarioDest${indexRenglon}');" onblur="blurDestinatario('usuarioDest${indexRenglon}', 'correo${indexRenglon}');" />
						</td>
						
						<td>
							<input id="correo${indexRenglon}" name="correoSalida" value='' size="50" type="text"/>
							<td align="center">	<input type="button" name="elimina" id="'+${indexRenglon} +'" class="btnElimina" onclick="eliminaDestinatario('renglon${indexRenglon}')"/> </td>
							<td align="center">	<input type="button" name="agrega" id="'+${indexRenglon} +'" class="btnAgrega" onclick="agregaDestinatario('${indexRenglon}')"/> </td>
						</td>
				</tr>
			</c:if>
		</c:when>
  	</c:choose>
</table>
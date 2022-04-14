<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
</head>

<body>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaPaginada" value="${listaResultado[1]}" />
<c:set var="listaResultado" value="${listaPaginada.pageList}"/>


		<table id="miTabla" >
			<c:choose>
			<c:when test="${tipoLista == '1'}">
				<tbody>	
					<tr align="center" id="encabezadoLista">
						<td class="label">
							Cr&eacute;dito
						</td>
						<td class="label">
							Cliente
						</td>
						<td class="label">
							Nombre
						</td>
						<td class="label">
							Motivo
						</td>
						<td class="label">
							Riesgo Com&uacute;n
						</td>
						<td class="label">
							Comentarios
						</td>
						<td class="label">
							Añadir Comentario
						</td>
					</tr>
					
					<c:forEach items="${listaResultado}" var="riesgoComunLis" varStatus="status">
					<tr id="renglons${status.count}" name="renglons">
						<td>
							<input type="text" id="creditoID${status.count}" name="lisCreditoID" size="10" value="${riesgoComunLis.creditoID}" readOnly="true"  />							
						</td>												
						<td>
							<input type="text" id="clienteID${status.count}" name="lisClienteID" size="10" value="${riesgoComunLis.clienteID}" readOnly="true" " />	
						
						</td>	
						<td>
							<input type="text" id="nombreCliente${status.count}" name="lisNombreCliente" size="45" value="${riesgoComunLis.nombreCliente}" readOnly="true"  " />	

						</td>	
						<td>
							<input type="text" id="motivo${status.count}" name="lisMotivo" size="25" value="${riesgoComunLis.motivo}" readOnly="true" " />	

						</td>					
						<td>
							<input type="hidden" id="esRiesgo${status.count}" name="lisEsRiesgo" size="3" value="${riesgoComunLis.esRiesgo	}"  />							
			    			<input type="radio"  id="riesgoSI${status.count}"  name="opcRadio${status.count}" value = "S" tabindex="2" onclick="seleccionaSI(this.id)" >
							<label for="nueva">Si </label>&nbsp;&nbsp;
							<input type="radio" id="riesgoNO${status.count}" name="opcRadio${status.count}" value = "N"  onclick="seleccionaNO(this.id)" tabindex="3">
							<label for="reposicion">No</label>							
						</td>
						<td>
							<textarea id="comentarios${status.count}" name="hisComentario" COLS="28" ROWS="2" readOnly="true">${riesgoComunLis.comentarios}</textarea>
						</td>
						<td>
							<textarea id="comentarios${status.count}" name="lisComentarios" COLS="28" ROWS="2"  onBlur="ponerMayusculas(this)" maxlength = "200"  autocomplete="off"></textarea>
						</td>
						<td>
							<input type="hidden" id="consecutivoID${status.count}" name="lisConsecutivoID" size="500" value="${riesgoComunLis.consecutivoID}"  />							
						</td>							
					</tr>
					</c:forEach>
				</tbody>
				</c:when>
		</c:choose>
	</table>
	
	<c:if test="${!listaPaginada.firstPage}">
		<input onclick="generaSeccion('previous')" type="button" id="anterior" value="" class="btnAnterior" />
	</c:if>
	<c:if test="${!listaPaginada.lastPage}">
		<input onclick="generaSeccion('next')" type="button" id="siguient" value="" class="btnSiguiente" />
	</c:if>
	
</body>
</html>	
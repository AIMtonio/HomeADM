<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="listaTiposNotasCargo" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">	
			<tr id="encabezadoLista">
				<td>N&uacute;mero</td>
				<td>Nombre Corto</td>
			</tr>
			 <c:forEach items="${listaTiposNotasCargo}" var="tipoNotaCargo" >
		 		<tr onClick="cargaValorLista('${campoLista}', '${tipoNotaCargo.tipoNotaCargoID}');">
					<td>${tipoNotaCargo.tipoNotaCargoID}</td>		
					<td>${tipoNotaCargo.nombreCorto}</td> 			
				</tr>
			</c:forEach> 
		</c:when>
	</c:choose>	
</table>
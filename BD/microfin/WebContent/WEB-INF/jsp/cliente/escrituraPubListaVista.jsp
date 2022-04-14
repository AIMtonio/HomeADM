<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="escrituras" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td>Consecutivo</td>
				<td>No.Escritura</td> 
				<td>Tipo de Esc.</td>
				<td>Nombre del Apoderado</td>  
			</tr> 
			<c:forEach items="${escrituras}" var="escritura" >
				<tr onclick="cargaValorLista('${campoLista}', '${escritura.consecutivo}');">
					<td>${escritura.consecutivo}</td>
					<td>${escritura.escrituraPub}</td> 
					<td>${escritura.esc_Tipo}</td> 
					<td>${escritura.nomApoderado}</td>  
				</tr>
			</c:forEach>
		</c:when>
  	</c:choose>
  	
  	<c:choose>
		<c:when test="${tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td>No.Escritura</td> 
				<td>Nombre del Apoderado</td>  
			</tr> 
			<c:forEach items="${escrituras}" var="escritura" >
				<tr onclick="valoresListaEscPub('${escritura.escrituraPub}','${escritura.fechaEsc}');">
					<td>${escritura.escrituraPub}</td> 
					<td>${escritura.nomApoderado}</td>  
				</tr>
			</c:forEach>
		</c:when>
  	</c:choose>		
  	  <c:choose>
		<c:when test="${tipoLista == '3'}">
			<tr id="encabezadoLista">
				<td>No.Escritura</td> 
				<td>Fecha</td>
				<td>Estado</td>  
			</tr> 
			<c:forEach items="${escrituras}" var="escritura" >
				<tr onclick="cargaValorLista('${campoLista}','${escritura.escrituraPub}');">
					<td>${escritura.escrituraPub}</td> 
					<td>${escritura.fechaEsc}</td>
					<td>${escritura.estadoIDEsc}</td>   
				</tr>
			</c:forEach>
		</c:when>
  	</c:choose>	
  	
</table>


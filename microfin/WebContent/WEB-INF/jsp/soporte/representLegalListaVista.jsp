<!-- <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="representante" value="${listaResultado[2]}"/>

<table id="tablaLista">
	<c:choose>
		<c:when test="${tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td>Representante Legal</td>
				<td>Institución</td>
			</tr>
			<c:forEach items="${representante}" var="representante" >
				<tr onclick="cargaValorLista('${campoLista}', '${representante.nombreRepresentante}');">
					<td>${representante.nombreRepresentante}</td>
					<td>${representante.nombreInstitucion}</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>
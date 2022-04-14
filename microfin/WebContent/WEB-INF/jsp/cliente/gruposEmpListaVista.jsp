<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<head>

</head>

<body>
<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="empresas" value="${listaResultado[2]}"/>

<table id="tablaLista" border='0'>
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr id="encabezadoLista">
				<td>Grupos de Empresa</td>
			</tr>
			<c:forEach items="${empresas}" var="filaEmpresas" >
				<tr onclick="cargaValorLista('${campoLista}', '${filaEmpresas.grupoEmpID}');
						document.getElementById('NombreGrupo').value='${filaEmpresas.nombreGrupo}';
						document.getElementById('Observacion').value='${filaEmpresas.observacion}';">
					<td>${filaEmpresas.nombreGrupo}</td>
				</tr>
			</c:forEach>
		</c:when>
  	</c:choose>
</table>
</body>



	

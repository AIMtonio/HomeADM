<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%! int numFilas = 0; %>
<%! int counter = 15; %>


<html>
<head>
</head>

<body>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend >Documentos por Clasificaci&oacute;n</legend>
		<c:set var="numLista"  value="${listaResultadoDoc[0]}"/>
		<c:set var="listaPaginadaDoc" value="${listaResultadoDoc[1]}" />
		<c:set var="listaResultadoDoc" value="${listaPaginadaDoc.pageList}"/>
		
		<tr>
			<td style="width: 10px">
				<input type="button" class="botonGral" value="Agregar" id="btnAgregar" tabindex="15" onclick="agregarDetalle(this.id)"/>
			</td>
		</tr>
		
		<c:choose>
			<c:when test="${numLista == '1'}">
			<table  id="gvMainDocumentos">
					<thead>
						<tr>
							<td nowrap="nowrap">
								<label>N&uacute;mero </label>
							</td>
							<td nowrap="nowrap">
								<label>Descripci&oacute;n </label>
							</td>
						</tr>
					</thead>
						
					<tbody>
						<c:forEach items="${listaResultadoDoc}" var="docPorClas" varStatus="status">
						<% numFilas=numFilas+1; %>
						<% counter++; %>

							<tr id="tr${status.count}" name="trdocPorClas">
								<td>
									<input type="hidden" id="clasDocID${status.count}" tabindex="<%=counter %>" name="clasDocID" size="10" value="${docPorClas.clasDocID}"/>
									<input type="text" id="tipoDocID${status.count}" tabindex="<%=counter %>" name="tipoDocID" size="10" value="${docPorClas.tipoDocID}" onkeyup="listaDocumentos(this.id)" onblur="consultaDocumento(this.id)" maxlength="10" />
								</td>								
								<td>
									<input type="text" id="descDocumento${status.count}"  name="descDocumento" size="50" value="${docPorClas.descDocumento}" onblur="ponerMayusculas(this)" maxlength="100" disabled="disabled" />
								</td>				
								<td nowrap="nowrap">
									<input type="button" id="eliminar${status.count}" name="eliminar" value="" class="btnElimina" onclick="eliminarParam('tr${status.count}')" tabindex="<%=counter %>"/>
									<input type="button" id="agrega${status.count}" name="agrega" value="" class="btnAgrega" onclick="agregarDetalle(this.id)" tabindex="<%=counter %>"/>
								</td>
							</tr>															
						</c:forEach>						
					</tbody>
					<tr>
			<td style="width: 10px">
				<input type="button" class="botonGral" value="Guardar" id="btnGrabar" tabindex="25"  onclick="grabaGrid()"/>
			</td>
			</tr>
			</table>
			<input type="hidden" id="numTab" value="<%=counter %>"/>
			<input type="hidden" id="numeroFila" value="<%=numFilas %>"/>
			</c:when>
		</c:choose>		
		
	</fieldset>
</body>
<% numFilas=0; %>
<% counter=15; %>
</html>	
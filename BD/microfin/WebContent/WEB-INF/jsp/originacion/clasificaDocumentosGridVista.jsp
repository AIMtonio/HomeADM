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
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend >Clasificaci&oacute;n de Documentos	</legend>
		<c:set var="tipoLista"  value="${listaResultado[0]}"/>
		<c:set var="listaPaginada" value="${listaResultado[1]}" />
		<c:set var="listaResultado" value="${listaPaginada.pageList}"/>
		
		<c:choose>
			<c:when test="${tipoLista == '2'}">
			<table  id="gvMain">
					<thead>
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="lblClasificación">N&uacute;mero</label> 
							</td>
							<td class="label" nowrap="nowrap">
								<label for="lblDescripcion">Descripci&oacute;n </label> 
							</td>
							<td class="label" nowrap="nowrap">
								<label for="lblAplica">Aplica para:</label> 
							</td>	
							<td class="label" nowrap="nowrap">
								<label for="lblRequerido">Requerido</br> en:</label>
							</td>
							<td class="label" nowrap="nowrap">
								<label for="lblGarantias">Aplica para</br> Integrante &nbsp;&nbsp;</label>
							</td>
							<td class="label" nowrap="nowrap">
								<label for="lblIntegrante">Solicitado s&oacute;lo si </br> Existen Garant&iacute;as: &nbsp;&nbsp;</label>
							</td>	
							<td class="label" nowrap="nowrap">
								<label for="lblRadio">Seleccionar</label> 
							</td>
						</tr>
						
					</thead>
					<c:forEach items="${listaResultado}" var="clasificacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon" class="GridViewScrollItem">
							<td> 
							
								<input id="consecutivoID${status.count}"  name="consecutivoID" size="3"  value="${status.count}" readOnly="true" disabled="true" type="hidden"/> 

								<input type="text"  id="clasificaTipDoc${status.count}" name="clasificaTipDoc"  size="6" value="${clasificacion.clasificaTipDocID}" readOnly="true" disabled="true"/>
								
						  	</td> 
						  	<td> 
								<input type="text" id="clasificaD${status.count}" name="clasificaD" size="60"  value="${clasificacion.clasificaDesc}" readOnly="true" disabled="true" /> 
						  	</td>
						  	<td> 
								<input  type="text" id="clasificaT${status.count}"  name="clasificaT" size="12"  
										  value="${clasificacion.clasificaTipo}"readOnly="true" disabled="true" /> 
							</td>  
						  	<td> 
						  	<input  type="text" id="tipoGrupI${status.count}" name="tipoGrupI" size="12" 
										value="${clasificacion.tipoGrupInd}" readOnly="true" disabled="true"/> 
								
						  	</td> 
							<td> 
								<input type="text" id="grupoA${status.count}"  name="grupoA" size="12"  
										  value="${clasificacion.grupoAplica}" readOnly="true" disabled="true" esTasa="true" /> 
							</td>
							<td> 
								<input type="text" id="esGaran${status.count}"  name="esGaran" size="12"  
										  value="${clasificacion.esGarantia}" readOnly="true" disabled="true" /> 
							</td>
							<td nowrap="nowrap" align="center" id="CheckSelecTodasEnc">
									<input type="radio" id="checkProc${status.count}" name="checkProc" onclick="consultaCheck(this.id)"/>

							</td>
						</tr>
					</c:forEach>
			</table>
			</c:when>
		</c:choose>
		
		<c:if test="${!listaPaginada.firstPage}">
			<input onclick="generaSeccionClasificaciones('previous')" type="button" id="anterior" name="anterior" value="" class="btnAnterior" />
		</c:if>
		<c:if test="${!listaPaginada.lastPage}">
			<input onclick="generaSeccionClasificaciones('next')" type="button" id="siguiente" name="siguiente" value="" class="btnSiguiente" />
		</c:if>
		
	</fieldset>
</body>
</html>	

<script type="text/javascript">
	var gridViewScroll = null;
</script>
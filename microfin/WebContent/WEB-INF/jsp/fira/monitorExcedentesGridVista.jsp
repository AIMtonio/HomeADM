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
		<c:set var="tipoLista"  value="${listaResultado[0]}"/>
		<c:set var="listaPaginada" value="${listaResultado[1]}" />
		<c:set var="listaResultado" value="${listaPaginada.pageList}"/>

		<c:choose>
			<c:when test="${tipoLista == '1'}">
			<table  id="gvMain">
					<thead>
						<tr class="GridViewScrollHeader">
							<td nowrap="nowrap">
								GrupoID
							</td>
							<td nowrap="nowrap">
								ID SIIOF
							</td>
							<td nowrap="nowrap">
								Nombre de Personas Integrantes
							</td>	
							<td nowrap="nowrap">
								Tipo de Persona
							</td>
							<td nowrap="nowrap">
								RFC
							</td>
							<td nowrap="nowrap">
								CURP
							</td>
							<td nowrap="nowrap">
								ID acreditado
							</td>	
							<td nowrap="nowrap">
								Saldo Insoluto por Integrante de Grupo
							</td>	
							<td nowrap="nowrap">
								Saldo Insoluto por Grupo
							</td>	
													
						</tr>
						
					</thead>
					<c:forEach items="${listaResultado}" var="riesgoLis" varStatus="status">
						<tr id="renglons${status.count}" name="renglons" class="GridViewScrollItem">
							<td nowrap="nowrap">
								<input type="text" id="grupoID${status.count}" name="lisGrupoID" width="150px" size="10" value="${riesgoLis.grupoID}" readOnly="true" style="text-align: center;" disabled="true" />							
							</td>							
							<td nowrap="nowrap">
								<input type="text" id="riesgoID${status.count}" name="lisRiesgoID" size="23" value="${riesgoLis.riesgoID}"  maxlength="200" style="text-align: right;" />	
	
							</td>
							<td nowrap="nowrap">								
								<input type="text" id="nombreIntegrante${status.count}" name="lisNombreIntegrante" size="38" value="${riesgoLis.nombreIntegrante}"  readOnly="true" style="text-align: left;"  disabled="true"/>							
							</td>				
							<td nowrap="nowrap">
								<input type="text" id="tipoPersona${status.count}" name="lisTipoPersona" size="18" value="${riesgoLis.tipoPersona}" readOnly="true" style="text-align: center;" disabled="true" />	
							</td>	
							<td nowrap="nowrap">
								<input type="text" id="rfc${status.count}" name="lisRFC" size="20" value="${riesgoLis.rfc}" readOnly="true" disabled="true" />	
	
							</td>
							<td nowrap="nowrap">
								<input id="curp${status.count}" name="lisCURP" size="25" type="text" value="${riesgoLis.curp}" readOnly="true" disabled="true"/>
							</td>
							<td nowrap="nowrap">
								<input type="text" id="clienteID${status.count}" name="lisClienteID" size="15" value="${riesgoLis.clienteID}"  readOnly="true" disabled="true" />
							</td>
							<td nowrap="nowrap">
								<input id="saldoIntegrante${status.count}" name="lisSaldoIntegrante" size="42" type="text"  value="${riesgoLis.saldoIntegrante}" esMoneda="true"  readOnly="true" style="text-align: right;" disabled="true"/>
							</td>	
							<td nowrap="nowrap">
								<input id="saldoGrupal${status.count}" name="lisSaldoGrupal" size="30" type="text"  esMoneda="true" value="${riesgoLis.saldoGrupal}" readOnly="true" style="text-align: right;" disabled="true"/>
							</td>																			
						</tr>
					</c:forEach>				
			</table>
			</c:when>
		</c:choose>
		
		<c:if test="${!listaPaginada.firstPage}">
			<input onclick="generaSeccionExcedentes('previous')" type="button" id="anterior" name="anterior" value="" class="btnAnterior" />
		</c:if>
		<c:if test="${!listaPaginada.lastPage}">
			<input onclick="generaSeccionExcedentes('next')" type="button" id="siguiente" name="siguiente" value="" class="btnSiguiente" />
		</c:if>
		
	</fieldset>
</body>
</html>	

<script type="text/javascript">
	var gridViewScroll = null;
</script>
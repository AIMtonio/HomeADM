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
		<c:set var="tipoLista"  value="${listaResultado[1]}"/>
		<c:set var="listaPaginada" value="${listaResultado[2]}" />
		<c:set var="listaResultado" value="${listaPaginada.pageList}"/>

		<c:choose>
			<c:when test="${tipoLista == '1'}">
			<table  id="gvMain">
					<thead>
						<tr class="GridViewScrollHeader">
							<td nowrap="nowrap">
								Indice
							</td>
							<td nowrap="nowrap">
								Mes
							</td>
							<td nowrap="nowrap">
								Saldo Cartera Total	
							</td>	
							<td nowrap="nowrap">
								Saldo Cartera Fira
							</td>
							<td nowrap="nowrap">
								Gastos Administraci&oacute;n
							</td>
							<td nowrap="nowrap">
								Capital Contable
							</td>	
							<td nowrap="nowrap">
								Utilidad Neta Acumulada
							</td>	
							<td nowrap="nowrap">
								Activo Total
							</td>	
							<td nowrap="nowrap">
								Saldo Cartera Vencida Total
							</td>	
							
						</tr>
						
					</thead>
						<%! int counter = 0; %>
	
					<c:forEach items="${listaResultado}" var="proyeccionLis" varStatus="status">
						<% counter++; %>
						<tr id="renglons${status.count}" name="renglons" class="GridViewScrollItem">
							<td nowrap="nowrap">
								<input type="text" id="consecutivoID${status.count}" name="lisConsecutivoID" width="150px" size="8" value="${proyeccionLis.consecutivoID}" readOnly="true"  />							
							</td>
							<td nowrap="nowrap">
								<input type="hidden" id="anio${status.count}" name="lisAnio" size="12" value="${proyeccionLis.anio}" readOnly="true" />
								<input type="text" id="mes${status.count}" name="lisMes" size="12" value="${proyeccionLis.mes}" readOnly="true" />	
	
							</td >	
							<td nowrap="nowrap">
								<input type="text" id="saldoTotal${status.count}" name="lisSaldoTotal" size="22" value="${proyeccionLis.saldoTotal}"  esMoneda="true" maxlength="21" style="text-align: right;" readOnly="true" onblur = "agregaFormatoMonedaGrid('saldoTotal${status.count}')"/>	
	
							</td>
							<td nowrap="nowrap">
								<input type="text" id="saldoFira${status.count}" name="lisSaldoFira" size="20" value="${proyeccionLis.saldoFira}" esMoneda="true" maxlength="21" style="text-align: right;" readOnly="true" onblur = "agregaFormatoMonedaGrid('saldoFira${status.count}')"/>							
							</td>				
							<td nowrap="nowrap">
								<input type="text" id="gastosAdmin${status.count}" name="lisGastosAdmin" size="26" align="center" value="${proyeccionLis.gastosAdmin}" esMoneda="true" style="text-align: right;" maxlength="21" readOnly="true" onblur = "agregaFormatoMonedaGrid('gastosAdmin${status.count}')" />	
							</td>	
							<td nowrap="nowrap">
								<input type="text" id="capitalConta${status.count}" name="lisCapitalConta" size="20" value="${proyeccionLis.capitalConta}" esMoneda="true" style="text-align: right;" maxlength="21" readOnly="true" onblur = "agregaFormatoMonedaGrid('capitalConta${status.count}')"/>	
	
							</td>
							<td nowrap="nowrap">
								<input id="utilidadNeta${status.count}" name="lisUtilidadNeta" size="28" type="text"  esMoneda="true" style="text-align: right;"  value="${proyeccionLis.utilidadNeta}"  maxlength="21"readOnly="true" onblur = "agregaFormatoMonedaGrid('utilidadNeta${status.count}')" />
							</td>
							<td nowrap="nowrap">
								<input id="activoTotal${status.count}" name="lisActivoTotal" size="15" type="text"  value="${proyeccionLis.activoTotal}" esMoneda="true" style="text-align: right;"  maxlength="21" readOnly="true" onblur = "agregaFormatoMonedaGrid('activoTotal${status.count}')"/>
							</td>	
							<td nowrap="nowrap">
								<input id="saldoVencido${status.count}" name="lisSaldoVencido" size="31" type="text"  esMoneda="true" style="text-align: right;"  value="${proyeccionLis.saldoVencido}" maxlength="21" readOnly="true" onblur = "agregaFormatoMonedaGrid('saldoVencido${status.count}')"/>
							</td>																			
						</tr>
						<input id="flag${status.count}" name="lisFlag" size="5" type="hidden"  value="${proyeccionLis.flag}"/>										
					</c:forEach>
				
			</table>
			</c:when>
		</c:choose>
		
		<c:if test="${!listaPaginada.firstPage}">
			<input onclick="generaSeccion('previous')" type="button" id="anterior" name="anterior" value="" class="btnAnterior" />
		</c:if>
		<c:if test="${!listaPaginada.lastPage}">
			<input onclick="generaSeccion('next')" type="button" id="siguient" name value="siguient" class="btnSiguiente" />
		</c:if>
		
		<input type="hidden" id="numTab" name="numTab" value="<%=counter%>"/>
	</fieldset>
</body>
</html>	

<script type="text/javascript">
	var gridViewScroll = null;
</script>
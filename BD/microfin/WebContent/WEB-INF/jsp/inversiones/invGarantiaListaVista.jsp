<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="invsGarantia" value="${listaResultado[2]}"/>

<c:choose>
	<c:when test="${tipoLista == '1'}">
		<table id="tablaLista">
			<tr id="encabezadoLista">
				<td>Inversi&oacute;n</td>
				<td>Etiqueta</td>
				<td>Monto</td>
				<td>Fecha Vencim.</td>
			</tr>
			<c:forEach items="${invsGarantia}" var="invGarantia" >
				<tr onclick="cargaValorLista('${campoLista}', '${invGarantia.inversionID}');">
					<td>${invGarantia.inversionID}</td>	
					<td>${invGarantia.etiqueta}</td>				
					<td style="text-align: right;">${invGarantia.montoInversion}</td>
					<td>${invGarantia.fechaVencimiento}</td>
				</tr>
			</c:forEach>			
		</table>
	</c:when>
	
	<c:when test="${tipoLista == '2' || tipoLista == '6'}">
		<br></br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all"><legend>Inversiones</legend>
			<table id="tablaCreditoInvGarantiaGrid">
				<tr id="encabezadoGridInvGar">
					<td class="label"> 
				   		<label>Inversi&oacute;n</label> 
					</td>
					<td class="separador"></td>
					<td class="label"> 
				   		<label>Etiqueta</label> 
					</td>
					<td class="separador"></td>
					<td class="label"> 
				   		<label>Monto</label> 
					</td>
					<td class="separador"></td>
					<td class="label"> 
				   		<label>Monto Cubierto</label> 
					</td>
					<td class="separador"></td>
					<td class="label"> 
				   		<label>Fecha Vencim.</label> 
					</td>
					<td class="separador"></td>
					<td class="label"> 
				   		<label>Seleccionar</label> 
					</td>
				</tr>
				<c:forEach items="${invsGarantia}" var="invGarantiaBean"  varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td> 
							<input id="listaInversionID${status.count}"  name="listaInversionID" size="15"  value="${invGarantiaBean.inversionID}" readonly="readonly" disabled="disabled" type="text"/>
							<input id="gridCreditoInvGarID${status.count}"  name="gridCreditoInvGarID" size="15"  value="${invGarantiaBean.creditoInvGarID}" readonly="readonly" type="hidden"/>
							<input id="listaCreditoInvGarID${status.count}"  name="listaCreditoInvGarID" size="15"  value="0" readonly="readonly" type="hidden"/>
						</td> 
						<td class="separador"></td>
						<td nowrap="nowrap">
							<input id="etiqueta${status.count}"  name="etiqueta" size="40"  value="${invGarantiaBean.etiqueta}" readonly="readonly" disabled="disabled" type="text"/>
						</td>
						<td class="separador"></td>	
						<td nowrap="nowrap" class="label"> 
							<input id="montoInversion${status.count}"  name="montoInversion" size="18"  value="${invGarantiaBean.montoInversion}" readonly="readonly" disabled="disabled" type="text"
								style="text-align: right;"/> 
						</td> 	
						<td class="separador"></td>	
						<td nowrap="nowrap" class="label"> 
							<input id="montoEnGar${status.count}"  name="montoEnGar" size="18"  value="${invGarantiaBean.montoEnGar}" readonly="readonly" disabled="disabled" type="text"
								style="text-align: right;"/> 
						</td> 		
						<td class="separador"></td>	
						<td align="right"> 
							<input id="fechaVencimiento{status.count}"  name="fechaVencimiento" size="15"  value="${invGarantiaBean.fechaVencimiento}" readonly="readonly" disabled="disabled" type="text"/>
						</td> 	
						<td class="separador"></td>	
						<td align="center">
							<c:choose>
								<c:when test="${tipoLista == '2'}">
									<input id="radioEliminar${status.count}" name="radioEliminar"  type="radio" value="N" onchange="funcionValidaSeleccionEliminarInvCre();"/>
								</c:when>
								<c:when test="${tipoLista == '6'}">
									<input id="listaCheckLiberar${status.count}" name="listaCheckLiberar"  type="checkbox" value="N" onchange="funcionValidaSeleccionLiberarInvCre();"/>
								</c:when>
							</c:choose>
						</td> 	
					</tr>
				</c:forEach>
			</table>
		</fieldset>
	</c:when>
	
	<c:when test="${tipoLista == '3'}">
		<fieldset class="ui-widget ui-widget-content ui-corner-all"><legend>Cr&eacute;ditos</legend>
			<table id="tablaCreditoInvGarantiaGrid" border="0">
				<tr id="encabezadoGridInvGar">
					<td class="label"> 
				   		<label>Cr&eacute;dito</label> 
					</td>
					<td class="separador"></td>
					<td class="label"> 
				   		<label>Monto Otorgado</label> 
					</td>
					<td class="separador"></td>
					<td class="label" align="center"> 
				   		<label>% Gar.Liq. Requerido</label> 
					</td>
					<td class="separador"></td>
					<td class="label"> 
				   		<label>Estatus</label> 
					</td>
					<td class="separador"></td>
					<td class="label"> 
				   		<label>D&iacute;as Atraso</label> 
					</td>
					<td class="separador"></td>
					<td class="label"> 
				   		<label>Monto Cubierto</label> 
					</td>
					<td class="separador"></td>
					<td class="label" align="center"> 
				   		<label>Fecha Vencim. Cred.</label> 
					</td>
					<td class="separador"></td>
					<td class="label"> 
				   		<label>Seleccionar</label> 
					</td>
				</tr>
				<c:forEach items="${invsGarantia}" var="invGarantiaBean"  varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td> 
							
							<input id="gridCreditoInvGarID${status.count}"  name="gridCreditoInvGarID" size="15"  value="${invGarantiaBean.creditoInvGarID}" readonly="readonly" type="hidden"/>
							<input id="listaCreditoInvGarID${status.count}"  name="listaCreditoInvGarID" size="15"  value="0" readonly="readonly" type="hidden"/>
							<input id="creditoID${status.count}"  name="creditoID" size="18"  value="${invGarantiaBean.creditoID}" readonly="readonly" disabled="disabled" type="text"/>
						</td> 
						<td class="separador"></td>
						<td nowrap="nowrap">
							<input id="montoCredito${status.count}"  name="montoCredito" size="18"  value="${invGarantiaBean.montoCredito}" readonly="readonly" disabled="disabled" type="text"
								style="text-align: right;"/> 
						</td>
						<td class="separador"></td>	
						<td nowrap="nowrap" class="label"> 
							<input id="porcGarLiq${status.count}"  name="porcGarLiq" size="18"  value="${invGarantiaBean.porcGarLiq}" readonly="readonly" disabled="disabled" type="text"
								style="text-align: right;"/> 
						</td> 	
						<td class="separador"></td>	
						<td align="right"> 
							<input id="estatus{status.count}"  name="estatus" size="15"  value="${invGarantiaBean.estatusDes}" readonly="readonly" disabled="disabled" type="text"/>
						</td> 
						<td class="separador"></td>	
						<td align="right"> 
							<input id="diasAtraso{status.count}"  name="diasAtraso" size="15"  value="${invGarantiaBean.diasAtraso}" readonly="readonly" disabled="disabled" type="text"
								style="text-align: right;"/>
						</td> 		
						<td class="separador"></td>	
						<td nowrap="nowrap" class="label"> 
							<input id="montoEnGar${status.count}"  name="montoEnGar" size="18"  value="${invGarantiaBean.montoEnGar}" readonly="readonly" disabled="disabled" type="text"
								style="text-align: right;"/> 
						</td> 		
						<td class="separador"></td>	
						<td align="right" style="text-align: center;"> 
							<input id="fechaVencimiento{status.count}"  name="fechaVencimiento" size="15"  value="${invGarantiaBean.fechaVencimiento}" readonly="readonly" disabled="disabled" type="text"/>
						</td> 	
						<td class="separador"></td>	
						<td align="center">
							<input id="listaCheckLiberar${status.count}" name="listaCheckLiberar"  type="checkbox" value="N" onchange="funcionValidaSeleccionLiberarInvCre();"/>
						</td> 	
					</tr>
				</c:forEach>				
			</table>
		</fieldset>
	</c:when>
	
	<c:when test="${tipoLista == '4'}">
		<table id="tablaLista">
			<tr id="encabezadoLista">
				<td>Cr&eacute;dito</td>
				<td><s:message code="safilocale.cliente"/></td>
				<td nowrap="nowrap">Estatus</td>
				<td nowrap="nowrap">Nombre Producto</td>
				<td nowrap="nowrap">Fec. Inicio</td>
				<td nowrap="nowrap">Fec. Vencim</td>
			</tr>
			<c:forEach items="${invsGarantia}" var="invGarantia" >
				<tr onclick="cargaValorLista('${campoLista}', '${invGarantia.creditoID}');">
					<td>${invGarantia.creditoID}</td>	
					<td nowrap="nowrap">${invGarantia.nombreCliente}</td>				
					<td nowrap="nowrap">${invGarantia.estatusDes}</td>
					<td nowrap="nowrap">${invGarantia.productoCreditoDes}</td>
					<td nowrap="nowrap">${invGarantia.fechaInicio}</td>
					<td nowrap="nowrap">${invGarantia.fechaVencimiento}</td>
				</tr>
			</c:forEach>			
		</table>
	</c:when>
	
	
	<c:when test="${tipoLista == '5'}">
		<table id="tablaLista">
			<tr id="encabezadoLista">
				<td nowrap="nowrap">Inversi&oacute;n</td>
				<td nowrap="nowrap"><s:message code="safilocale.cliente"/></td>
				<td nowrap="nowrap">Etiqueta</td>
				<td nowrap="nowrap">Monto Inversi&oacute;n</td>
			</tr>
			<c:forEach items="${invsGarantia}" var="invGarantia" >
				<tr onclick="cargaValorLista('${campoLista}', '${invGarantia.inversionID}');">
					<td>${invGarantia.inversionID}</td>	
					<td nowrap="nowrap">${invGarantia.nombreCliente}</td>
					<td nowrap="nowrap">${invGarantia.etiqueta}</td>
					<td nowrap="nowrap" style="text-align: right;">${invGarantia.montoInversion}</td>
				</tr>
			</c:forEach>			
		</table>
	</c:when>
</c:choose>

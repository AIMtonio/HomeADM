<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<script type="text/javascript" src="js/soporte/consultaEdoCtaGridVista.js"></script>

<c:set var="listaResultado" value="${listaPaginada.pageList}"/>
<c:set var="clienteCorreo" value="0"/>
<c:set var="clienteCorreoTodos" value="0"/>
<c:set var="indiceTab" value="7"/>

<br>

<input type="hidden" id="numeroRegistros" name="numeroRegistros" value="${listaPaginada.nrOfElements}"/>
<c:if test="${listaPaginada.nrOfElements > 0}">
	<div id="formaTabla">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
				
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="60%">
				<tr>
					<td class="ui-widget ui-widget-header ui-corner-all" align="center"><label style="color: #ffffff">No. Periodo</label></td>
					<td class="ui-widget ui-widget-header ui-corner-all" align="center"><label style="color: #ffffff">No. Cliente</label></td>
					<td class="ui-widget ui-widget-header ui-corner-all" align="center"><label style="color: #ffffff">Nombre Cliente</label></td>
					<td class="ui-widget ui-widget-header ui-corner-all" align="center"><label style="color: #ffffff">&nbsp;&nbsp;PDF&nbsp;&nbsp;</label></td>
					<td class="ui-widget ui-widget-header ui-corner-all" align="center"><label style="color: #ffffff">&nbsp;&nbsp;XML&nbsp;&nbsp;</label></td>
				</tr>
				
				<c:forEach items="${listaResultado}" var="edoCtaEnvioCorreo" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td>
							<input id="anioMes${status.count}" size="10" type="text" value="${edoCtaEnvioCorreo.anioMes}" readonly="readonly" style="text-align: center; font-size: smaller; border: none;"/>
						</td>
						<td>
							<input id="sucursalID${status.count}" size="8" type="hidden" value="${edoCtaEnvioCorreo.sucursalID}" readonly="readonly" style="text-align: center; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all"/>
							<input id="correo${status.count}" size="8" type="hidden" value="${edoCtaEnvioCorreo.correo}" readonly="readonly" style="text-align: center; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all"/>
							<input id="rutaPDF${status.count}" size="8" type="hidden" value="${edoCtaEnvioCorreo.rutaPDF}" readonly="readonly" style="text-align: center; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all"/>
							<input id="rutaXML${status.count}" size="8" type="hidden" value="${edoCtaEnvioCorreo.rutaXML}" readonly="readonly" style="text-align: center; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all"/>
							<input id="clienteID${status.count}" size="20" type="text" value="${edoCtaEnvioCorreo.clienteID}" readonly="readonly" style="text-align: center; font-size: smaller; border: none;" />
						</td>
						<td>
							<input id="nombreCliente${status.count}" size="80" type="text" value="${edoCtaEnvioCorreo.nombreCliente}" readonly="readonly" style="font-size: smaller; border: none;" />
						</td>
						<td align="center">
							<c:set var="indiceTab" value="${indiceTab + 1}"/>
							<input id="botonPDF${status.count}" size="10" type="button" title="${edoCtaEnvioCorreo.rutaPDF}" value="" tabindex="${indiceTab}" readonly="readonly" class="iconoPDF"/>
						</td>
						<td align="center">
							<c:set var="indiceTab" value="${indiceTab + 1}"/>
							<input id="botonXML${status.count}" size="10" type="button" title="${edoCtaEnvioCorreo.rutaXML}" value="" tabindex="${indiceTab}" readonly="readonly" class="iconoXML"/>
						</td>
					</tr>
				</c:forEach>
			</table>
			<c:if test="${!listaPaginada.firstPage}">
				<input type="button" id="btnAnterior" onclick="cambioPaginaGridEdoCtaEnvioCorreo('previous')" value="" tabindex="58" class="btnAnterior" />
			</c:if>
			<c:if test="${!listaPaginada.lastPage}">
				<input type="button" id="btnSiguiente" onclick="cambioPaginaGridEdoCtaEnvioCorreo('next')" value="" tabindex="59" class="btnSiguiente" />
			</c:if>
			<input type="hidden" id="clienteCorreo" name="clienteCorreo" value="${clienteCorreo}"/>
		</fieldset>
	</div>
</c:if>
<c:if test="${listaPaginada.nrOfElements <= 0}">
	<div id="formaTabla"></div>
</c:if>
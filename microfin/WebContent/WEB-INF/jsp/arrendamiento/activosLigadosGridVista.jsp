<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script type="text/javascript" src="js/arrendamiento/activosLigadosGrid.js"></script>

<c:set var="listaResultado"  value="${listaResultado}"/>
<%! int numFilas = 0; %>
<%! int counter = 4; %>
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Activos ligados al arrendamiento</legend>
		<table id="tablaActivosLigados" border="0" cellpadding="2" cellspacing="1" width="965px" style="display:block; overflow-y: auto;">
			<tr>
                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblNumero" style="color: #ffffff">N&uacute;mero</label></td>
                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblTipoActivo" style="color: #ffffff">Tipo de Activo</label></td>
                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblActivo" style="color: #ffffff">Activo</label></td>
                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblClasificacion" style="color: #ffffff">Clasificaci&oacute;n</label></td>
                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblMarca" style="color: #ffffff">Marca</label></td>
                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblModelo" style="color: #ffffff">Modelo</label></td>
                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblNumSerie" style="color: #ffffff">Num. Serie</label></td>
                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblNumFactura" style="color: #ffffff">Num. Factura</label></td>
                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblValorfactura" style="color: #ffffff">Valor Factura</label></td>
                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblFechaAdquisicion" style="color: #ffffff">Fecha Adquisici&oacute;n</label></td>
                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblPlazoMaximo" style="color: #ffffff">Plazo M&aacute;ximo</label></td>
                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblResidualMaximo" style="color: #ffffff">Residual M&aacute;ximo</label></td>
            </tr>
            
            <c:forEach items="${listaResultado}" var="activos" varStatus="status">
           		<% numFilas=numFilas+1; %>
				<% counter++; %>
				<tr id="renglon${status.count}" name="renglon${status.count}">
		            <td><input id="activoIDVin${status.count}" name="activoIDVin" size="8" type="text" value="${activos.activoID}" readonly="readonly" style="text-align: center; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all"/></td>
		            <td><input id="tipoActivoVin${status.count}" name="tipoActivoVin" size="8" type="text" value="${activos.tipoActivo}" readonly="readonly" style="text-align: left; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all"/></td>
		            <td><input id="activoDescri${status.count}" name="activoDescri" size="30" type="text" value="${activos.descripcion}" readonly="readonly" style="text-align: left; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all"/></td>
		            <td><input id="clasificacion${status.count}" name="clasificacion" size="30" type="text" value="${activos.subtipoActivo}" readonly="readonly" style="text-align: left; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all"/></td>
		            <td><input id="marcaActivo${status.count}" name="marcaActivo" size="30" type="text" value="${activos.marca}" readonly="readonly" style="text-align: left; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all"/></td>
		            <td><input id="modeloActivo${status.count}" name="modeloActivo" size="30" type="text" value="${activos.modelo}" readonly="readonly" style="text-align: left; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all"/></td>
		            <td><input id="numSerieActivo${status.count}" name="numSerieActivo" size="30" type="text" value="${activos.numeroSerie}" readonly="readonly" style="text-align: left; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all"/></td>
		            <td><input id="numFacturaActivo${status.count}" name="numFacturaActivo" size="10" type="text" value="${activos.numeroFactura}" readonly="readonly" style="text-align: left; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all"/></td>
		            <td><input id="valorFacturaActivo${status.count}" name="valorFacturaActivo" size="10" type="text" value="${activos.valorFactura}" readonly="readonly" style="text-align: right; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all" esMoneda="true"/></td>
		            <td><input id="fechaAdqActivo${status.count}" name="fechaAdqActivo" size="12" type="text" value="${activos.fechaAdquisicion}" readonly="readonly" style="text-align: center; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all"/></td>
		            <td><input id="plazoMaximo${status.count}" name="plazoMaximo" size="10" type="text" value="${activos.plazoMaximo}" readonly="readonly" style="text-align: left; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all"/></td>
		            <td><input id="residualMaximo${status.count}" name="residualMaximo" size="10" type="text" value="${activos.porcentResidMax}" readonly="readonly" style="text-align: right; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all" esTasa="true"/></td>
		            <td nowrap="nowrap">
						<input type="button" id="eliminar${status.count}" name="eliminar${status.count}" value="" class="btnElimina" onclick="eliminarParam('renglon${status.count}')" tabindex="<%=counter %>"/>
					</td>
				</tr>
			</c:forEach>
		</table>
		<% counter++; %>
		<table border="0" width="100%"> 
			<tr>
				<td align="right">
					<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="<%=counter %>"/>
				</td>
			</tr>
		</table>
	<input type="hidden" id="numTab" value="<%=counter %>"/>
	<input type="hidden" id="numeroFila" value="<%=numFilas %>"/>
</fieldset>
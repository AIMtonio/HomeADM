<?xml version="1.0" encoding="UTF-8"?>
<script type="text/javascript" src="js/forma.js"></script>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="listaResultado" value="${listaResultado[0]}"/>
<%! int numFilas = 0; %>
<%! int counter = 2; %>
<table border="0" width="100%">
	<tr>
		<td>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">		
				<legend>Asignaci&oacute;n de Cartas de Liquidaci&oacute;n Internas</legend>
				<input type="hidden" id="solicitudID" name="solicitudID" value=""/>
				<input type="hidden" id="consolidaID" name="consolidaID" value=""/>
				<input type="hidden" id="rutaArchivosInt" name="rutaArchivosInt" value=""/>
				
				<table id="tbParametrizacion2" border="0" width="350px"> 
					<thead>
						<tr>
							<td style="width: 10px">
								<input type="button" class="submit" value="Agregar" id="btnAgregarI" tabindex="1" onclick="agregarDetalleInterna()"/>
							</td>
						</tr>
						<tr>
							<td nowrap="nowrap">
								<label>Cr&eacute;dito</label>
							</td>
							<td></td>
							<td nowrap="nowrap">
								<label>Vigencia</label>
							</td>
							<td></td>
							<td nowrap="nowrap">
								<label>Monto</label>
							</td>
						</tr>
					</thead>
					
					<tbody>
					<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
					<tr id="trInt${status.count}">
						<td>
							<input type="text" id="creditoIDInt${status.count}" tabindex="<%=counter %>" name="creditoID" size="20" value="${detalle.creditoID}" maxlength="10" 
							onblur="funcionConsultaCartaInt(${status.count},event)" 
							onkeypress="funcionListaCredito(this.id)" 
							onkeypress="return validaNumero(event)" 
							onkeydown="funcionValidaTab(event)"/>
						</td>
						<td></td>
						<td nowrap="nowrap">
							<input type="text" id="fechaVigenciaInt${status.count}" readonly="true" tabindex="<%=counter %>" name="fechaVigencia" size="15" value="${detalle.fechaVigencia}" autocomplete="off"  onchange="validaFecha(this.id)"/>
						</td>
						<td></td>
						<td>
							<input type="text" id="montoInt${status.count}" readonly = "true" tabindex="<%=counter %>" name="monto" path="monto" size="15" value="${detalle.monto}" style="text-align: right;" onblur="validaMontoAsignado(this.id,<%=numFilas %>)" esMoneda="true"/>
						</td>
						<td nowrap="nowrap">
							<img src="images/continuar.png" id="descargar${status.count}" name="descargar" value="" onclick="funcionVisualizaCarta(${status.count})" tabindex="<%=counter %>"/>
							<input type="hidden" id="recursoInt${status.count}" name="recurso" value="${detalle.recurso}"/>
							<script type="text/javascript">
							var id = ${status.count};
							funcionSetRecursoPath(id);
							</script> 	
							<input type="hidden" id="recursoPathInt${status.count}" name="recursoPath" value=""/>
							<input type="hidden" id="archivoCredIDInt${status.count}" name="archivoIDCarta" value="${detalle.archivoIDCarta}"/>
							<input type="hidden" id="cartaLiquidaIDInt${status.count}" name="cartaLiquidaID" value="${detalle.cartaLiquidaID}"/>
							<input type="button" id="eliminar${status.count}" name="eliminarInt" value="" class="btnElimina" onclick="eliminarParamInt('trInt${status.count}')" tabindex="<%=counter %>"/>
							<input type="button" id="agrega${status.count}" name="agregaInt" value="" class="btnAgrega" onclick="agregarDetalleInterna()" tabindex="<%=counter %>"/>
						</td>
					</tr>
					</c:forEach>					
				</tbody>
				</table>
				<table align="right">
					<tr>
						<td align="right">
							<input type="button" id="grabarInt" name="grabarInt" class="submit" value="Guardar" tabindex="5" onclick="funcionOnSubmit()"/>
							<input id="datosGridInt" type="hidden" name="datosGridInt" />
							<input type="hidden" id="tipoTransaccionInt" name="tipoTransaccionInt"/>
							<input type="hidden" id="registroAdjuntoInt" name="registroAdjuntoInt"/>
						</td>
					</tr>
				</table>
			</fieldset>
		</td>
	</tr>
</table>
<script type="text/javascript" >
</script>
<input type="hidden" id="numTab" value="<%=counter %>"/>
<input type="hidden" id="numeroFila" value="<%=numFilas %>"/>
<% numFilas=0; %>
<% counter=3; %>
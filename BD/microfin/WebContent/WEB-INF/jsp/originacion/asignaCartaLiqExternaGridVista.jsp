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
				<legend >Asignaci&oacute;n de Cartas de Liquidaci&oacute;n Externas</legend>
					<table id="tbParametrizacion" border="0" width="350px">
					<thead>
					<tr>
						<td style="width: 10px">
							<input type="button" class="submit" value="Agregar" id="btnAgregarE" tabindex="1" onclick="agregarDetalle(this.id)"/>
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap">
								<label>Casa Comercial </label>
						</td>
						<td></td>
						<td nowrap="nowrap">
								<label>Monto </label>
						</td>
						<td></td>
						<td nowrap="nowrap">
								<label>Vigencia </label>
						</td>
						<td nowrap="nowrap">
								<label>Adjuntar Carta de Liquidaci&oacute;n </label>
						</td>
						<td nowrap="nowrap">
								<label>Adjuntar Comprobante de Pago </label>
						</td>
					</tr>
					</thead>
					<tbody>
						<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
						<% numFilas=numFilas+1; %>
						<% counter++; %>
	
						<tr id="tr${status.count}" name="trCartas">
							<td nowrap="nowrap">
								<input type="hidden" id="asignacionCartaID${status.count}" tabindex="<%=counter %>" name="asignacionCartaID" size="5" value="${detalle.asignacionCartaID}"  disabled="disabled"/>
								<input type="text" id="casaComercialID${status.count}" tabindex="<%=counter %>" name="casaComercialID" size="5" value="${detalle.casaComercialID}" maxlength="10" onblur="consultaCasa(this.id)" onkeypress="listaCasa(this.id)" onkeypress="return validaNumero(event)" />
								<input type="text" id="nombreCasa${status.count}" name="nombreCasa" size="22" value="${detalle.nombreCasa}" maxlength="100" readonly="readonly" disabled="true"/>
								<input type="hidden" id="estatus${status.count}" tabindex="<%=counter %>" name="estatus" size="5" value="${detalle.estatus}"  disabled="disabled"/>
							</td>
							<td></td>
							<td>
								<input type="text" id="monto${status.count}" tabindex="<%=counter %>" name="monto" path="monto" size="15" value="${detalle.monto}" style="text-align: right;" onblur="validaMontoAsignado(this.id,<%=numFilas %>)" esMoneda="true"/>
								<input type="hidden" id="montoAnterior${status.count}" tabindex="<%=counter %>" name=montoAnterior path="montoAnterior" value="${detalle.montoAnterior}"  readonly="readonly" disabled="true" esMoneda="true"/>
							</td>
							<td></td>
							<td nowrap="nowrap">
								<input type="text" id="fechaVigencia${status.count}" tabindex="<%=counter %>" name="fechaVigencia" size="15" value="${detalle.fechaVigencia}" autocomplete="off"  onchange="validaFecha(this.id)" esCalendario="true" />
							</td>
							<td nowrap="nowrap">
								<input type="button" id="cartaLiq${status.count}" class="submit" tabindex="<%=counter %>" name="cartaLiq" size="15" value="Adjuntar" onclick="subirArchivos('cartaLiq',<%=numFilas %>,'1')" />
								<input type="text" 	 id="nombreCartaLiq${status.count}" name="nombreCartaLiq" size="30" value="${detalle.nombreCartaLiq}" readonly="readonly" disabled="true"/>
								<input type="hidden" id="recurso${status.count}" name="recurso" value='${detalle.recurso}' readonly="readonly" disabled="true"/>
								<input type="hidden" id="extension${status.count}" name="extension" value="${detalle.extension}" readonly="readonly" disabled="true"/>
								<input type="hidden" id="comentario${status.count}" name="comentario" value="${detalle.comentario}" readonly="readonly" disabled="true"/>
								<input type="hidden" id="archivoIDCarta${status.count}" name="archivoIDCarta"  value="${detalle.archivoIDCarta}" readonly="readonly" disabled="true"/>
								<input type="hidden" id="modificaArchCarta${status.count}" name="modificaArchCarta"  value="N" readonly="readonly" disabled="true"/>
								<input type="hidden" id="recursoFinal${status.count}" name="recursoFinal"  value="N" readonly="readonly" disabled="true"/>
								
								<input type="hidden" id="recursoPath${status.count}" name="recursoPath" value='${detalle.recursoPath}' readonly="readonly" disabled="true"/>
								
							</td>
							<td nowrap="nowrap">
								<input type="button" id="comproPago${status.count}" class="submit" tabindex="<%=counter %>" name="comproPago" size="15" value="Adjuntar" onclick="subirArchivos('comproPago',<%=numFilas %>,'2')" />
								<input type="text" id="nombreComproPago${status.count}" name="nombreComproPago" size="22" value="${detalle.nombreComproPago}" readonly="readonly" disabled="true"/>
								<input type="hidden" id="recursoPago${status.count}" name="recursoPago" size="22" value='${detalle.recursoPago}' readonly="readonly" disabled="true"/>
								<input type="hidden" id="extensionPago${status.count}" name="extensionPago" size="22" value="${detalle.extensionPago}" readonly="readonly" disabled="true"/>
								<input type="hidden" id="comentarioPago${status.count}" name="comentarioPago" size="22" value="${detalle.comentarioPago}" maxlength="100" readonly="readonly" disabled="true"/>
								<input type="hidden" id="archivoIDPago${status.count}" name="archivoIDPago"  value="${detalle.archivoIDPago}" readonly="readonly" disabled="true"/>
								<input type="hidden" id="modificaArchPago${status.count}" name="modificaArchPago"  value="N" readonly="readonly" disabled="true"/>
								<input type="hidden" id="recursoFinalPago${status.count}" name="recursoFinalPago"  value="N" readonly="readonly" disabled="true"/>
							</td>
							<td nowrap="nowrap">
								<input type="button" id="eliminar${status.count}" name="eliminar" value="" class="btnElimina" onclick="eliminarParam('tr${status.count}')" tabindex="<%=counter %>"/>
								<input type="button" id="agrega${status.count}" name="agrega" value="" class="btnAgrega" onclick="agregarDetalle(this.id)" tabindex="<%=counter %>"/>
							</td>
						</tr>
						</c:forEach>
					</tbody>
				</table>
					<table align="right">
						<tr>
							<td align="right">
								<input type="button" id="grabarE" name="grabarE" class="submit"  value="Guardar" onclick="grabaDetalleCartas(this.id, event)"//>
								<input id="detalleCartas" type="hidden" name="detalleCartas" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
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
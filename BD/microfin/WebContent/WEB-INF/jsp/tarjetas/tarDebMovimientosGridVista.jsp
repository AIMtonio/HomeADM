<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend>Movimientos</legend>	
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
			
					<tr>
						<td class="label" align="center">
					   		<label for="lblconsecutivo"></label> 
						</td>
						<td class="label" align="center">
					   		<label for="lblFecha">Fecha</label> 
						</td>
						<td class="label" align="center">
							<label for="lblOperacion">Operaci&oacute;n</label> 
				  		</td>
				  		<td class="label" align="center">
							<label for="lblTransaccion">Num.</label> 
							<br>
							<label for="lblTransaccion">Transacci&oacute;n</label> 
				  		</td>
				  		<td class="label" align="center">
							<label for="lblMonto">Monto</label> 
				  		</td>
				  		<td class="label" align="center">
							<label for="lblTerminal">Terminal</label>
				  		</td>
						<td class="label" align="center">
							<label for="lblUbicacion">Ubicaci&oacute;n Terminal</label>
				  		</td>
				  		<td class="label" align="center">
							<label for="lblTpoAire">Datos Tiempo Aire</label> 
				  		</td>
				  	</tr>
					<c:forEach items="${listaResultado}" var="movimiento" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td>
							<input id="consecutivoID${status.count}"  name="consecutivoID" size="3"
										value="${status.count}" readOnly="true" disabled="true" type="hidden"/>
						</td>
						<td>
							<input type="text" id="fecha${status.count}" name="fecha" size="11"
										 value="${movimiento.fecha}" readOnly="true" disabled="true" style='text-align:left;' />
						</td>
						<td>
							<input type="text" id="operacion${status.count}"  name="operacion" size="32"
										  value="${movimiento.operacion}"readOnly="true" disabled="true" style='text-align:left;'/>
						</td>
						<td>
						 	<input type="text" id="transaccion${status.count}" name="transaccion" size="10" 
										value="${movimiento.transaccion}" readOnly="true" disabled="true" style='text-align:right;'/>
						</td>
						<td>
							<input type="text" id="monto${status.count}"  name="montoGrid" size="10"
									  value="${movimiento.monto}" readOnly="true" disabled="true" esMoneda="true" style='text-align:right;' />
						</td>
						<td>
							<input type="text" id="terminalID${status.count}"  name="terminalID" size="12"
									  value="${movimiento.terminalID}" readOnly="true" disabled="true" esMoneda="true" style='text-align:right;' />
						</td>
						<td>
							<input type="text" id="ubicacionTerm${status.count}"  name="ubicacionTerm" size="50"
									  value="${movimiento.nomUbicacionTer}" readOnly="true" disabled="true" esMoneda="true" style='text-align:left;' />
						</td>
						<td>
							<input type="text" id="datTpoAire${status.count}"  name="datTpoAire" size="20"
									  value="${movimiento.datosTpoAire}" readOnly="true" disabled="true" esMoneda="true" style='text-align:right;' />
						</td>
				 	</tr>
					</c:forEach>
		</table>
	</fieldset>
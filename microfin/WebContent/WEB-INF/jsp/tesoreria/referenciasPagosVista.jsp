<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/referenciasPagosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tarjetaDebitoServicio.js"></script>
	
	<script type="text/javascript" src="js/tesoreria/referenciasPagosTipInst.js"></script>	
	<script type="text/javascript" src="js/utileria.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="referenciasPagosBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Referencia de Pago por Instrumento</legend>
				<table border="0" width="100%">
					<tr>
						<td nowrap="nowrap">
							<label for="tipoCanalID">Tipo Canal: </label>
						</td>
						<td>
							<form:select id="tipoCanalID" name="tipoCanalID" path="tipoCanalID" tabindex="1">
								<form:option value="">SELECCIONAR</form:option>
								<form:option value="1">CR&Eacute;DITO</form:option> 
							    <form:option value="2">CUENTA</form:option>
							    <form:option value="3">TARJETA</form:option>
							</form:select>
						</td>
						<td class ="separador"></td>
						<td nowrap="nowrap">
							<label for="instrumentoID">No. Instrumento: </label>
						</td>
						<td>
							<form:input id="instrumentoID" name="instrumentoID" path="instrumentoID" maxlength="50" tabindex="2"/>
							<input id="idCtePorTarjeta" name="idCtePorTarjeta" size="20" type="hidden" />
							<input id="nomTarjetaHabiente" name="nomTarjetaHabiente" size="20" type="hidden" />								
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="clienteID"><s:message code="safilocale.cliente"/>:</label>
						</td>
						<td>
							<form:input type='text' id="clienteID" name="clienteID" path="" size="15" tabindex="3" readonly="true"/>
							<input type='text' id="clienteIDDes" name="clienteIDDes" size="45" readonly="readonly"/>
						</td>
						<td class ="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="tipoReferencia">Tipo Referencia:</label>
						</td>
						<td>
							<form:select id="tipoReferencia" name="tipoReferencia" path="tipoReferencia" tabindex="3">
								<form:option value="M">MANUAL</form:option> 
							    <form:option value="A">AUTOMATICA</form:option>
							</form:select>
						</td>
					</tr>
					<tr>
						<td colspan="5" valign="top">
							</br>
							<div id="gridReferencias"></div>
							<table style="margin-left:auto;margin-right:0px">
								<tr>
									<td nowrap="nowrap">
										<input type="button" class="submit" value="Generar" id="generar" tabindex="600" style="display: none;"/>
										<input type="button" class="submit" value="Grabar" id="grabar" tabindex="601" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<input id="detalleReferencias" type="hidden" name="detalleReferencias" />
							<input id="tipoTransaccion" type="hidden" name="tipoTransaccion" />
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;overflow:">
		<div id="elementoLista"></div>
	</div>
	<div id="cajaListaCte" style="display: none;overflow-y: scroll;height=150px;"></div>
	<div id="elementoListaCte"></div>
	<div id="mensaje" style="display: none;"></div>
</body>
</html>
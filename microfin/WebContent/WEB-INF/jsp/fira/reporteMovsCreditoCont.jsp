<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="js/fira/reporteMovsCreditoCont.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean" target="_blank">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Movimientos de Cr&eacute;dito Contingente</legend>
				<table border="0" width="100%">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>
									<label>Par&aacute;metros: </label>
								</legend>
								<table border="0" width="100%">
									<tr>
										<td class="label">
											<label for="creditoID">No Cr&eacute;dito: </label>
										</td>
										<td>
											<form:input id="creditoID" name="creditoID" path="creditoID" size="12" tabindex="1" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="Cliente"><s:message code="safilocale.cliente" />: </label>
										</td>
										<td>
											<form:input id="clienteID" name="clienteID" path="clienteID" size="12" readOnly="true" disabled="true" />
											<input type="text" id="nombreCliente" name="nombreCliente" tabindex="3" readOnly="true" disabled="true" size="50" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="lineaCred">Producto de Cr&eacute;dito: </label>
										</td>
										<td>
											<form:input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="12" disabled="true" />
											<input type="text" id="nombreProd" name="nombreProd" tabindex="4" disabled="true" size="50" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="lblEstatus">Estatus: </label>
										</td>
										<td>
											<input id="estatus" name="estatus" path="estatus" size="12" type="text" readOnly="true" disabled="true"/>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="Cuenta">Monto: </label>
										</td>
										<td>
											<form:input id="montoCredito" name="montoCredito" path="montoCredito" size="12" esMoneda="true" readonly="true"  style="text-align: right;" />
										</td>
									<tr>
									<tr>
										<td class="label">
											<label for="fechaDesembolso">Fecha de Desembolso: </label>
										</td>
										<td>
											<form:input id="fechaMinistrado" name="fechaMinistrado" path="fechaMinistrado" size="12" tabindex="7" disabled="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="Moneda">Moneda: </label>
										</td>
										<td>
											<form:select id="monedaID" name="monedaID" path="monedaID" esMoneda="true" disabled="true">
												<form:option value="-1"></form:option>
											</form:select>
										</td>
									<tr>
									<tr>
										<td class="label">
											<label for="Cuenta">Total Adeudo: </label>
										</td>
										<td>
											<form:input id="adeudoTotal" name="adeudoTotal" path="adeudoTotal" size="12" esMoneda="true" readonly="true"  style="text-align: right;" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="FechaInic">Fecha de Inicio: </label>
										</td>
										<td>
											<input id="fechaInicio" name="fechaInicio" size="12" tabindex="2" type="text" esCalendario="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="FechaFin">Fecha de Fin: </label>
										</td>
										<td>
											<input type="text" id="fechaFin" name="fechaFin" size="12" tabindex="3" esCalendario="true" /> <input type="hidden" id="fechaSistema" name="fechaSistema" size="12" />
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
						<td style="vertical-align: top;">
							<table>
								<tr>
									<td class="label">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend>
												<label>Presentaci&oacute;n</label>
											</legend>
											<input type="radio" id="pdf" name="presentacion" tabindex="4" value="pdf" checked="checked" /> <label> PDF </label>
											<br> <input type="radio" id="excel" name="presentacion" tabindex="5" value="excel" /> <label> Excel </label>
										</fieldset>
									</td>
								</tr>
							</table>
							<br>
							<table>
								<tr>
									<td class="label">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend>
												<label>Nivel de Detalle</label>
											</legend>
											<input type="radio" id="detallado" name="detallado" tabindex="6" value="detallado" checked="checked" /> <label>Detallado</label>
											<br> <input type="radio" id="sumarizado" name="detallado" tabindex="7" value="sumarizado" /> <label>Sumarizado(Pagos)</label>
										</fieldset>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<table border="0" width="100%">
								<tr>
									<td colspan="5">
										<table align="right" border='0'>
											<tr>
												<td>
													<input type="button" id="generar" name="generar" class="submit" tabIndex="8" value="Generar" />
													<input type="hidden" id="tipoReporte" name="tipoReporte" value="" />
													<input type="hidden" id="nivelDetalle" name="nivelDetalle" value=""/>
													<input type="hidden" id="tipoLista" name="tipoLista" value=""/>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
	<div id="mensaje" style="display: none;"></div>
</body>
</html>
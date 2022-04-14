<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%!int	consecutivoID	= 01;%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="js/credito/repCancelacionCredito.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Cr&eacute;ditos Cancelados</legend>
				<table style="width: 100%">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend><label>Par&aacute;metros</label></legend>
								<table style="width: 100%">
									<tr>
										<td class="label">
											<label for="fechaInicio">Fecha Inicio: </label>
										</td>
										<td>
											<input type="text" name="fechaInicio" id="fechaInicio" autocomplete="off" size="12" tabindex="<%=consecutivoID++%>" esCalendario="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="fechaFinal">Fecha Final: </label>
										</td>
										<td>
											<input type="text" name="fechaFinal" id="fechaFinal" autocomplete="off" size="12" tabindex="<%=consecutivoID++%>" esCalendario="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="sucursal">Sucursal:</label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="sucursalID" name="sucursalID" size="12" tabindex="<%=consecutivoID++%>" autocomplete="off" value="" style="width: 97px;" /> <input type="text" id="nombreSucursal" name="nombreSucursal" disabled="disabled" size="40" value="" />
										</td>
									</tr>
									<tr>
										<td>
											<label for="producCreditoID">Producto de Cr&eacute;dito:</label>
										</td>
										<td colspan="4">
											<input type="text" id="producCreditoID" name="producCreditoID" size="12" tabindex="<%=consecutivoID++%>" style="width: 96px;" /> <input type="text" id="nombreProducto" name="nombreProducto" disabled="disabled" size="40" />
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td colspan="3">
							<table width="70px">
								<tr>
									<td class="label" style="width: 70px;">
										<fieldset class="ui-widget ui-widget-content ui-corner-all" style="width: 70px;">
											<legend>
												<label>Presentaci&oacute;n</label>
											</legend>
											<table style="width: 50%">
												<tr>
													<td>
														<input type="radio" id="excel" name="tipoReporte" value="1" tabindex="<%=consecutivoID++%>" checked="checked" />
													</td>
													<td>
														<label for="excel"> Excel </label>
													</td>
												</tr>
											</table>
										</fieldset>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="5" style="text-align: right;">
							<input id="generar" type="button" class="submit" value="Generar" tabindex="<%=consecutivoID++%>" /> <input id="tipoTransaccion" name="tipoTransaccion" type="hidden" value="" /> <input id="tipoActualizacion" name="tipoActualizacion" type="hidden" value="" />
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
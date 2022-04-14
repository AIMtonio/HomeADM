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
<script type="text/javascript" src="js/credito/repPagosReferencia.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean" target="_blank">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Pagos por Referencia</legend>
				<table border="0" width="100%">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>
									<label>Par&aacute;metros</label>
								</legend>
								<table border="0" width="100%">
									<tr>
										<td class="label">
											<label for="fecha">Fecha Inicio: </label>
										</td>
										<td>
											<input type="text" id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12" tabindex="1" esCalendario="true"/>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="fechaFinal">Fecha Fin: </label>
										</td>
										<td>
											<input type="text" id="fechaFinal" name="fechaFinal" path="fechaFinal" size="12" tabindex="2" esCalendario="true"/>
										</td>
									</tr>
									<tr>
										<td>
											<label for="sucursal">Sucursal:</label>
										</td>
										<td colspan="4" nowrap="nowrap">
											<input type="text" id="sucursalID" name="sucursalID" size="12" maxlength="3" tabindex="3" autocomplete="off" value="" />
											<input type="text" id="nombreSucursal" name="nombreSucursal" disabled="disabled" size="50" value="" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="producCreditoID">Producto de Cr&eacute;dito: </label>
										</td>
										<td>
											<form:input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="12" tabindex="4" value=""/>
											<input type="text" id="nombreProd" name="nombreProd" tabindex="4" disabled="true" size="50" />
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td class="label" >
						<div style="width:150px">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>
									<label>Presentaci&oacute;n</label>
								</legend>
								<input type="radio" id="excel" name="tipoReporte" tabindex="5" checked="checked" value="1"/>
								<label for="excel"> Excel </label>
							</fieldset>
							</div>
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
													<input type="button" id="generar" name="generar" class="submit" tabIndex="6" value="Generar" />
													<input type="hidden" id="tipoReporte" name="tipoReporte" value="" />
													<input type="hidden" id="tipoLista" name="tipoLista" value="" />
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
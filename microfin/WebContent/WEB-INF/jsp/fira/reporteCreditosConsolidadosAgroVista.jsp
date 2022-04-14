<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="js/fira/repCreditosConsolidadosAgro.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Consolidaciones</legend>
				<table border="0" width="600px">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>
									<label>P&aacute;rametros</label>
								</legend>
								<table border="0" width="560px">
									<tr>
										<td class="label">
											<label for="fechaInicio">Fecha Inicial: </label>
										</td>
										<td colspan="4">
											<input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12" tabindex="1" type="text" esCalendario="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="fechaFin">Fecha Final: </label>
										</td>
										<td colspan="4">
											<input id="fechaFin" name="fechaFin" path="fechaFin" size="12" tabindex="2" type="text" esCalendario="true" />
										</td>
									</tr>
									<tr>
										<td>
											<label for="producCreditoID">Producto de Cr&eacute;dito:</label>
										</td>
										<td colspan="4">
											<form:input type="text" id="producCreditoID" name="producCreditoID" path="producCreditoID" size="11" tabindex="3"/>
				 							<input type="text" id="nombreProd" name="nombreProd" disabled="disabled" size="40" />
										</td>
									</tr>
									<tr>
										<td class="label"><label>Estatus: </label></td>
										<td>
											<form:select id="estatus" name="estatus" path="estatus" tabindex="4">
											<form:option value="T">TODOS</form:option>
											<form:option value="I">INACTIVO</form:option>
											<form:option value="A">AUTORIZADO</form:option>
											<form:option value="V">VIGENTE</form:option>
											<form:option value="P">PAGADO</form:option>
											<form:option value="C">CANCELADO</form:option>
											<form:option value="B">VENCIDO</form:option>
											<form:option value="K">CASTIGADO</form:option>
											<form:option value="S">SUSPENDIDO</form:option>
											</form:select>
										</td>
									</tr>
									<tr>
										<td>
											<label for="sucursal">Sucursal:</label>
										</td>
										<td colspan="4" nowrap="nowrap">
											<input type="text" id="sucursal" name="sucursal" size="11" maxlength="3" tabindex="5" autocomplete="off" value="" />
											<input type="text" id="nombreSucursal" name="nombreSucursal" disabled="disabled" size="40" value="" />
										</td>
									</tr>

								</table>
							</fieldset>
						</td>
						<td>
							<table width="200px">
								<tr>
									<td class="label" style="position: absolute; top: 9%;">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend>
												<label>Presentaci&oacute;n</label>
											</legend>
											<input type="radio" id="pdf" name="generaRpt" value="pdf" tabindex="6"> <label> PDF </label>
										</fieldset>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" /> <input type="hidden" id="tipoLista" name="tipoLista" />
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td colspan="4" align="right" border='0'>
							<a id="ligaGenerar" href="RepCreditoConsolidadoAgro.htm" target="_blank"> <input type="button" id="generar" name="generar" class="submit" tabIndex="7" value="Generar" />
							</a>
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
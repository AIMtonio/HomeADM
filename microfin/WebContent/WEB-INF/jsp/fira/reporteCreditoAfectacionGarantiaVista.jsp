<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/catTipoGarantiaFIRAServicio.js"></script>
		<script type="text/javascript" src="js/fira/reporteCreditoAfectacionGarantiaVista.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form id="formaGenerica" name="formaGenerica" method="POST" commandName="garantiaFiraBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Cr&eacute;ditos con afectaci&oacute;n Garant&iacute;a - Peri&oacute;dico.</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="600px">
						<tr>
							<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>
									<label>P&aacute;rametros</label>
								</legend>
								<table border="0" width="560px">
									<tr>
										<td class="label">
											<label for="fechaInicio">Fecha Inicio: </label>
										</td>
										<td colspan="4">
											<input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12" tabindex="1" type="text" esCalendario="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="fechaFin">Fecha Fin: </label>
										</td>
										<td colspan="4">
											<input id="fechaFin" name="fechaFin" path="fechaFin" size="12" tabindex="2" type="text" esCalendario="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="sucursalID">Sucursal:</label>
										</td>
										<td colspan="4">
											<select id="sucursalID" name="sucursalID" path="sucursalID"  tabindex="4">
												<option value="0">TODAS</option>
											</select>
										</td>
									</tr>
									<tr>
										<td>
											<label for="productoCreditoID">Producto de Cr&eacute;dito:</label>
										</td>
										<td colspan="4">
											<select id="productoCreditoID" name="productoCreditoID" path="productoCreditoID"  tabindex="4">
												<option value="0">TODOS</option>
											</select>
										</td>
									</tr>
									<tr>
										<td>
											<label for="tipoGarantiaID">Tipo de Garant&iacute;a:</label>
										</td>
										<td colspan="4">
											<select id="tipoGarantiaID" name="tipoGarantiaID" path="tipoGarantiaID" tabindex="5">
											</select>
										</td>
									</tr>
								</table>
							</fieldset>
							</td>
							<td>
								<table width="100px">
									<tr>
										<td class="label" style="position: absolute; top: 12%;">
											<fieldset class="ui-widget ui-widget-content ui-corner-all">
												<legend><label>Presentaci&oacute;n</label></legend>
												<input type="radio" id="excel" name="excel" value="1" tabindex="6">
												<label> Excel </label>
											</fieldset>
										</td>
									</tr>
									<br>
								</table>
							</td>
						</tr>
					</table>
					<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
					<input type="hidden" id="tipoLista" name="tipoLista" />
					<table border="0" cellpadding="0" cellspacing="0" width="700px">
						<tr>
							<td colspan="4">
								<table align="right" border='0'>
									<tr>
										<td align="right">
											<a id="ligaGenerar" href="/reporteCreditoAfectacionGarantia.htm" target="_blank" >
												 <input type="button" id="generar" name="generar" class="submit" tabIndex="7" value="Generar" />
											</a>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</fieldset>
			</form>
		</div>

		<div id="cargando" style="display: none;">
		</div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
		</div>
	</body>
	<div id="mensaje" style="display: none;"/>
</html>
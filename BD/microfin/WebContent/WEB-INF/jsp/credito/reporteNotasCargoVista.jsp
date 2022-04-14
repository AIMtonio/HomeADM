<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/conveniosNominaServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
	<script type="text/javascript" src="js/credito/reporteNotasCargo.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="notasCargoBean" target="_blank">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de notas de cargo</legend>
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
											<input type="text" id="fechaFin" name="fechaFin" path="fechaFin" size="12" tabindex="2" esCalendario="true"/>
										</td>
									</tr>
									<tr>
										<td>
											<label>Producto de cr&eacute;dito:</label>
										</td>
										<td colspan="4">
											<input id="productoCreditoID" name="productoCreditoID" tabindex="3" type="text" value="" size="6">
											<input type="text" id="descripcion" name="descripcion" size="39" disabled="true" readonly="true">
										</td>
									</tr>
									<tr class="datosNominaI" >
										<td>
											<label>Instituci&oacute;n de N&oacute;mina:</label>
										</td>
										<td colspan="4">
										<input id="institucionNominaID" name="institucionNominaID" tabindex="4" type="text" value="" size="6">
										<input type="text" id="nombreInstitucion" name="nombreInstitucion" size="39" disabled="true" readonly="true">
										</td>
									</tr>
									<tr class="datosNominaC">
										<td>
											<label>Convenio de N&oacute;mina:</label>
										</td>
										<td colspan="4">
										<input id="convenioNominaID" name="convenioNominaID" path="convenioNominaID" tabindex="4" type="text" value="" size="6">
										<input type="text" id="nombreConvenio" name="nombreConvenio" size="39" disabled="true" readonly="true">
										</td>
									</tr>
								</table>
							</fieldset>
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
													<input type="hidden" id="excel" name="generaRpt" value="excel">
													<input type="hidden" id="esNomina" name="esNomina" value="N"/>
													<input type="hidden" id="manejaConvenio" name="manejaConvenio" />
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
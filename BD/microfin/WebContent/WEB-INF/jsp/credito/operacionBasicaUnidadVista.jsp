<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
	<script type="text/javascript" src="js/credito/operacionBasicaUnidad.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="operacionBasicaUnidadBean" target="_blank">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte B&aacute;sico de Unidad</legend>
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
											<input type="text" id="fechaFinal" name="fechaFin" path="fechaFinal" size="12" tabindex="2" esCalendario="true"/>
										</td>
									</tr>
									<tr>
										<td class="label"><label for="lblsucursalID">Sucursal: </label></td>
										<td>
											<select id="sucursalID" name="sucursalID" path="sucursalID" tabindex="3">
												<option value="0">SELECCIONAR</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="lblCoordinador">Coordinador: </label>
										</td>
										<td>
											<input type="text" id="coordinadorID" name="coordinadorID" size="10" tabindex="4" maxlength="11" autocomplete="off"/>
											<input type="text" id="nombreCoordinador" name="nombreCoordinador" readOnly="true" size="40" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label>Promotor: </label>
										</td>
										<td>
											<input type="text" id="promotorID" name="promotorID" size="10" tabindex="5" maxlength="11" autocomplete="off"/>
											<input type="text" id="nombrePromotor" name="nombrePromotor" size="40" readOnly="true"/>
										 </td>
									</tr>
								</table>
							</fieldset>
						</td>
						<td>
							<table width="150px">
								<tr>
									<td class="label" style="position: absolute; top: 9%;">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend>
												<label>Presentación</label>
											</legend>
											<input type="radio" id="excel" name="tipoReporte" tabindex="6" checked="checked" value="1"/>
											<label for="excel"> Excel </label>
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
													<input type="button" id="generar" name="generar" class="submit" tabIndex="6" value="Generar" />
													<input type="hidden" id="tipoReporte" name="tipoReporte" value="" />
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
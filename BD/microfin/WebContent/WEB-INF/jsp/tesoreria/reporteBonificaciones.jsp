<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="js/tesoreria/reporteBonificaciones.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form id="formaGenerica" name="formaGenerica" method="POST" commandName="bonificacionesBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Bonificaciones</legend>
					<table>
						<tr>
							<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>
									<label>P&aacute;rametros</label>
								</legend>
								<table>
									<tr>
										<td class="label">
											<label for="fechaInicio">Fecha Inicio: </label>
										</td>
										<td>
											<input id="fechaInicio" name="fechaInicio" size="12" tabindex="1" type="text" esCalendario="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="fechaFin">Fecha Fin: </label>
										</td>
										<td>
											<input id="fechaFin" name="fechaFin" size="12" tabindex="2" type="text" esCalendario="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="estatus">Estatus Bonificaci&oacute;n:</label>
										</td>
										<td>
											<select id="estatus" name="estatus" tabindex="3" >
												<option value="">TODOS</option>
												<option value="I">PENDIENTE</option>
												<option value="A">DISPERSADA</option>
											</select>
										</td>
									</tr>
								</table>
							</fieldset>
							</td>
							<td>
							</td>
						</tr>
						<tr>
							<td>
								<table style="width: 25%">
									<tr>
										<td>
											<fieldset class="ui-widget ui-widget-content ui-corner-all">
												<legend>
													<label>Presentaci&oacute;n</label>
												</legend>
												<table style="width: 100%">
													<tr>
														<td>
															<input type="radio" id="excel" name="excel" value="1" tabindex="4" checked="checked" />
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
							<td >
								<table align="right" border='0'>
									<tr>
										<td align="right">
											<a id="ligaGenerar" href="repBonificaciones.htm" target="_blank" >
												<input type="button" id="generar" name="generar" class="submit" tabIndex="5" value="Generar" />
											</a>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
					<input type="hidden" id="tipoLista" name="tipoLista" />
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
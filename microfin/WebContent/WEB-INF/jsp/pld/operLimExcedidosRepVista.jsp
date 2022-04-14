<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/paramPLDOpeEfecServicio.js"></script>
<script type="text/javascript" src="js/pld/operLimExcedidosRep.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="operLimExcedidosRepBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Operaciones con Límites Excedidos</legend>
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
											<label for="anio">Año: </label>
										</td>
										<td>
											<select id="anio" name="anio" tabindex="1">
												<option value=''>SELECCIONAR</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="lbPeriodo">Periodo: </label>
										</td>
										<td>
											<select id="periodo" name="periodo" tabindex="2">
												<option value=''>SELECCIONAR</option>
												<option value='01'>ENERO</option>
												<option value='02'>FEBRERO</option>
												<option value='03'>MARZO</option>
												<option value='04'>ABRIL</option>
												<option value='05'>MAYO</option>
												<option value='06'>JUNIO</option>
												<option value='07'>JULIO</option>
												<option value='08'>AGOSTO</option>
												<option value='09'>SEPTIEMBRE</option>
												<option value='10'>OCTUBRE</option>
												<option value='11'>NOVIEMBRE</option>
												<option value='12'>DICIEMBRE</option>
											</select>
										</td>
										<td class="separador"></td>
									</tr>
									<tr>
										<td class="label">
											<label for="fechaInicio">Fecha Inicio: </label>
										</td>
										<td>
											<input type="text" id="fechaInicio" name="fechaInicio" size="12" autocomplete="off" disabled="true" readOnly="true" />
										</td>
										<td class="separador"></td>
									</tr>
									<tr>
										<td class="label">
											<label for="fechaFin">Fecha Final: </label>
										</td>
										<td>
											<input type="text" id="fechaFin" name="fechaFin" autocomplete="off" size="12" disabled="true" readOnly="true" />
										</td>
										<td class="separador"></td>
									</tr>
									<tr>
										<td class="label">
											<label for="monto">Monto Limite: </label>
										</td>
										<td nowrap="nowrap">
											<select id="monto" name="monto" tabindex="3">
												<option value="">SELECCIONAR</option>
											</select>
										</td>
										<td class="separador"></td>
									</tr>
								</table>
							</fieldset>
							<table align="left">
								<tr>
									<td class="label">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend>
												<label>Presentaci&oacute;n</label>
											</legend>
											<input type="radio" id="pdf" name="tipoReporte" value="1" tabindex="4" /> <label> PDF </label> <br> <input type="radio" id="excel" name="tipoReporte" value="2" tabindex="5" /> <label> Excel </label>
										</fieldset>
									</td>
								</tr>
							</table>
							<br> <br>
							<table align="right">
								<tr>
									<td>
										<input type="button" id="generar" name="generar" class="submit" tabIndex="6" value="Generar" />
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
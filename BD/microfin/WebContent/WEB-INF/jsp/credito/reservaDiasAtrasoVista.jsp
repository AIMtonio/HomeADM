<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/paramsCalificaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="js/credito/reservaDiasAtraso.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reserva por D&iacute;as de Atraso</legend>
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="porReservaPeriodoBean">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label nowrap="nowrap" for="tipoInstitucion">Tipo Instituci&oacute;n:</label>
							</td>
							<td>
								<form:select id="tipoInstitucion" name="tipoInstitucion" path="tipoInstitucion" readonly="true">
									<form:option value=""></form:option>
								</form:select>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblTipoRango">Clasificaci&oacute;n:</label>
							</td>
							<td class="label">
								<label>Comercial</label><input type="radio" id="clasificacion" name="clasificacion" path="clasificacion" value="C"/>
								<label>Com. Microcrédito</label><input type="radio" id="clasificacion" name="clasificacion" path="clasificacion" value="M"/>
								<label>Consumo</label><input type="radio" id="clasificacion" name="clasificacion" path="clasificacion" value="O"/>
								<label>Vivienda</label><input type="radio" id="clasificacion" name="clasificacion" path="clasificacion" value="H"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblInstitucion">Instituci&oacute;n:</label>
							</td>
							<td>
								<form:select id="tipoInst" name="tipoInst" path="tipoInst" disabled="true">
									<form:option value="1">BANCA COMERCIAL</form:option>
									<form:option value="2">BANCA DESARROLLO</form:option>
									<form:option value="3">SOFIPO</form:option>
									<form:option value="4">SOFOM</form:option>
									<form:option value="5">SOFOL</form:option>
									<form:option value="6">SOCAP</form:option>
									<form:option value="7">FONDEADOR</form:option>
								</form:select>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<div id="gridReservas" style="display: none;"/>
							</td>
						</tr>
					</table>
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="4"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
							</td>
						</tr>
					</table>
					<input type="hidden" size="500" name="limInferiores" id="limInferiores"/>
					<input type="hidden" size="500" name="limSuperiores" id="limSuperiores"/>
					<input type="hidden" size="500" name="cartSReest" id="cartSReest"/>
					<input type="hidden" size="500" name="cartReest" id="cartReest"/>
				</form:form>
			</fieldset>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
		</div>
		<div id="mensaje" style="display: none;"/>
		<div id="ContenedorAyuda" style="display: none;"></div>
	</body>
</html>
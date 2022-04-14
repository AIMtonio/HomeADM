<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head>
<script type="text/javascript"
	src="dwr/interface/repPagoRemesaSPEIServicio.js"></script>
<script type="text/javascript" src="js/spei/repPagoRemesaSPEI.js"></script>

</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST"
			commandName="repPagoRemesaSPEIBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte
					de Remesas</legend>


				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Par&aacute;metros</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label"><label for="lblFechaInicio">Fecha
									Inicio:</label></td>
							<td><input type="text" id="fechaInicio" name="fechaInicio"
								size="12" esCalendario="true" tabindex="1" /></td>
							<td class="separador"></td>
							<td class="label"><label for="lblFechaFin">Fecha
									Fin: </label></td>
							<td><input type="text" id="fechaFin" name="fechaFin"
								size="12" esCalendario="true" tabindex="2" /></td>
						</tr>
						
						<tr>

							<td class="label"><label for="lblNivelReporte">Nivel
									Reporte: </label></td>
							<td><label> Resumen </label> <input type="radio"
								id="resumen" name="nivelReporte" tabindex="3" /></td>

							<td colspan="2"><label> Detallado </label> <input
								type="radio" id="detallado" name="nivelReporte" tabindex="4" /></td>
						</tr>

						<tr>
							<td class="label"><label for="lblTipoOperacion">Tipo
									Operaci&oacute;n: </label></td>
							<td><select id="tipoOperacion" name="tipoOperacion"
								tabindex="5">
									<option value="">SELECCIONAR</option>
									<option value="1">TODOS</option>
									<option value="2">TRANSFERENCIAS INTERNAS</option>
									<option value="3">ENV&IACUTE;OS SPEI</option>

							</select></td>
						</tr>

						<tr>
							<td class="label"><label for="lblPorEstado">Estatus:
							</label></td>
							<td><select id="estado" name="estado" tabindex="6">
									<option value="">SELECCIONAR</option>
									<option value="1">TODOS</option>
							</select></td>
						</tr>

					</table>
				</fieldset>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td align="right"><input type="button" class="submit"
							id="generar" value="Generar" tabindex="7" /> 
							<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
							<input type="hidden" id="tipoLista" name="tipoLista" /> 
							<input type="hidden" id="tipoRep" name="tipoRep" /> 
							<input type="hidden" id="formaRep" name="formaRep" /></td>
					</tr>
				</table>
			</fieldset>

		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
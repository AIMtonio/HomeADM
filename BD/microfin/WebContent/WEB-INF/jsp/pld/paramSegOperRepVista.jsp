<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="js/pld/paramSegOperRepVista.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Seguimiento de Operaciones </legend>
			<form id="formaGenerica" name="formaGenerica" method="POST"
				commandName="parametrosegoperBean" target="_blank">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
					<tr>
						<td><label>Fecha Inicio:</label></td>
						<td><input type="text" name="fechaInicio" id="fechaInicio"
							autocomplete="off" esCalendario="true" size="12" tabindex="1" />
						</td>
						<td colspan="3"></td>
					</tr>
					<tr>
						<td><label>Fecha Final:</label></td>
						<td><input type="text" name="fechaFin" id="fechaFin"
							autocomplete="off" esCalendario="true" size="12" tabindex="2" />
						</td>
						<td colspan="3"></td>
					</tr>
					<tr>
						<td colspan="5" align="right">
							<button type="button" class="submit" id="imprimir" style="">Imprimir</button> 
							<input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>"/>
						</td>
					</tr>
				</table>
			</form>
		</fieldset>

	</div>

	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>

</body>
</html>
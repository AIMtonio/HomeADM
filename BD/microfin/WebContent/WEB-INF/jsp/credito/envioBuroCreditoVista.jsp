<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
	<head>
		<script type="text/javascript" src="js/credito/repEnvioBuro.js"></script>
	</head>

<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Env&iacute;o Bur&oacute; de Cr&eacute;dito </legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend><label>Par&aacute;metros</label></legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label">
									<label for="creditoID">Fecha: </label>
								</td>
								<td >
									<input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12"
										tabindex="1" type="text"  esCalendario="true" />
								</td>
							</tr>
						</table>
						<table border="0" cellpadding="0" cellspacing="0" width="250px">
							<tr>
								<td class="label">
								<br>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend><label>Tipo de Persona</label></legend>
										<input type="radio" id="fisica" name="fisica" value="1" tabindex="2" checked>
										<label for="fisica"> Persona F&iacute;sica </label>	<br>
										<input type="radio" id="moral" name="moral" tabindex="3" value="2">
										<label for="moral"> Persona Moral </label>
								</fieldset>
								<br>
								</td>
								<td class="separador"/>
							</tr>
							<tr>
								<td class="label">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend><label>Tipo de Reporte</label></legend>
									<input type="radio" id="diario" name="tiempoReporte" value="D" tabindex="4" checked>
									<label for="diario" id="ldiario"> Diario </label><br>
									<input type="radio" id="semanal" name="tiempoReporte" value="S" tabindex="5">
									<label for="semanal" id="lsemanal"> Semanal (Liq. Ant.) </label><br>
									<input type="radio" id="mensual" name="tiempoReporte" value="M" tabindex="6">
									<label for="mensual"> Mensual </label><br>
									<input type="radio" id="mensualVtaCartera" name="tiempoReporte" value="V" tabindex="7">
									<label for="mensualVtaCartera"> Mensual Vta Cartera </label>
								</fieldset>
								<br>
								</td>
								<td class="separador"/>
							</tr>
						</table>
					</fieldset>
				</td>
			</tr>
		</table>
		<br>
		<table border="0" cellpadding="0" cellspacing="0" width="117%">
			<tr>
				<td class="label">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend><label>Presentaci&oacute;n</label></legend>
						<input type="radio" id="ext" name="ext" value="ext" tabindex="9">
						<label id="lblExt"> EXT </label>
						<input type="radio" id="txt" name="excel" value="txt" tabindex="8">
						<label id="lblTxt"> CSV </label>
						<input type="radio" id="intl" name="intl" value="intl" tabindex="9">
						<label id="lblIntl"> INTL </label>
				</fieldset>
				</td>
				<td class="separador"/>
			</tr>
		</table>
		<br>
		<table border="0" cellpadding="0" cellspacing="0" width="300px">
				<tr>
					<td >
						<table align="right" border='0'>
							<tr>
								<td align="right">
									<a id="ligaGenerar" href="reporteEnvBuroCredito.htm" target="_blank">
										<input type="button" id="generar" name="generar" class="submit"
											 tabindex="10" value="Generar" />
									</a>
								</td>
							</tr>
							<tr>
								<td>
								<input type="hidden" id="tipoReporte" name="tipoReporte">
								<input type="hidden" id="tipoPersona" name="tipoPersona">
								<input type="hidden" id="tipoFormatoCinta" name="tipoFormatoCinta">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;">
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>

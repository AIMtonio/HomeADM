<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/lineaFonServicio.js"></script>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/creditoFondeoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
<script type="text/javascript" src="js/fondeador/repAnaliticoCarteraPas.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Analítico Cartera Pasiva</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="600px">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>
									<label>Par&aacute;metros</label>
								</legend>
								<table border="0" width="560px">
									<tr>
										<td class="label">
											<label for="lblfechaACP">Fecha: </label>
										</td>
										<td>
											<input id="fechaACP" name="fechaACP" size="12" tabindex="1" type="text" esCalendario="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="institucionFondeo">Instituci&oacute;n : </label>
										</td>
										<td>
											<input id="institutFondID" name="institutFondID" size="3" value="0" tabindex="2" /> <input type="text" id="nombreInstitFondeo" name="nombreInstitFondeo" tabindex="3" size="30" value="TODOS" disabled="disabled" />
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
						<td>
							<table width="200px">
								<tr>
									<td class="label" style="position: absolute; top: 8%;">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend>
												<label>Presentaci&oacute;n</label>
											</legend>
											<input type="radio" id="excel" name="generaRpt" value="excel"> <label> Excel </label>
										</fieldset>
									</td>
								</tr>
								<tr>
									<td class="separador">
										<br>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td colspan="4" align="right">
							<a id="ligaGenerar" href="repAnaliticoCarteraPas.htm" target="_blank"> <input type="button" id="generar" name="generar" class="submit" tabIndex="48" value="Generar" />
							</a> <input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" /> <input type="hidden" id="tipoLista" name="tipoLista" />
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
	<div id="mensaje" style="display: none;" />
</body>
</html>
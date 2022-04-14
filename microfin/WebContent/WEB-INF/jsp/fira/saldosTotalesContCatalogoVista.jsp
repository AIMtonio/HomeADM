<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="js/fira/repSaldosTotalesCont.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Anal&iacute;tico Cartera Contingente</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>
									<label>P&aacute;rametros</label>
								</legend>
								<table border="0" width="100%">
									<tr>
										<td class="label">
											<label for="fechaInicio">Fecha: </label>
										</td>
										<td>
											<input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12" tabindex="1" type="text" esCalendario="true" />
										</td>
									</tr>
									<tr>
										<td colspan="2">
											<table width="100%">
												<tr>
													<td class="label">
														<fieldset class="ui-widget ui-widget-content ui-corner-all">
															<legend>
																<label>Presentaci&oacute;n</label>
															</legend>
															<input type="radio" id="excel" name="generaRpt" value="excel"> <label> Excel </label>
														</fieldset>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" /> <input type="hidden" id="tipoLista" name="tipoLista" />
											<table border="0" width="100%">
												<tr>
													<td style="text-align: right;">
														<a id="ligaGenerar" href="RepSaldosTotalesCredito.htm" target="_blank">
														<input type="button" id="generar" name="generar" class="submit" tabIndex="48" value="Generar" />
														</a>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</fieldset>
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
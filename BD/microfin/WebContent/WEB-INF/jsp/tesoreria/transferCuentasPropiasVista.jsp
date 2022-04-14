<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>
		<script type="text/javascript" src="js/tesoreria/cuentasPropias.js"></script>
	</head>
	<body>
 		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentasPropiasBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Transferencias Cuentas Propias</legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td width="100%" border="0" cellpadding="0" cellspacing="0">
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend>Envío</legend>
										<table>
										<tr>
											<td><label>Institución :</label></td>
											<td>
												<form:input type="text" name="institucionEnvioID" id="institucionEnvioID" size="4" tabindex="1" path="institucionEnvioID" />
												<input type="text" name="nombreinstitucionEnvioID" id="nombreinstitucionEnvioID" size="50" readOnly="true"  />
											</td>
										</tr>
										<tr>
											<td><label>Cuenta Bancaria:</label></td>
											<td>
												<form:input id="numCtaInstitEnvio" name="numCtaInstitEnvio" path="numCtaInstitEnvio" size="30"  tabIndex="2" />
												</td>
												<td>
													<label>Saldo:</label>
												</td>
												<td>
													<input id="saldo" name="saldo" size="16"  readonly="readonly" style="text-align:right" esMoneda="true"/>
												</td>
										</tr>
										<tr>
											<td class="label"><label>Monto:</label></td>
											<td><form:input id="monto" name="monto" path="monto" size="15" esMoneda="true" tabIndex="3" style="text-align:right" onkeypress="return IsNumber(event);" />
											</td>
											<td class="label">
												<label for="ccostos">C. Costos:</labe>
											</td>
											<td>
													<form:input id="cCostosEnvio" name="cCostosEnvio" path="cCostosEnvio" size="10" maxlength="10" tabindex="3"/>
													<input type="text" id="nombCCostosEnvio" name="nombCCostosEnvio" size="40"  readonly="readonly">
											</td>
										</tr>
										<tr>
											<td class="label"><label>Referencia:</label></td>
											<td><form:input id="referencia" name="referencia" path="referencia" size="35" tabIndex="4" maxlength="150" onblur=" ponerMayusculas(this)"/></td>
										</tr>
									</table>
								</fieldset>
							</td>
						</tr>
						<tr>
							<td>&nbsp;
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend>Recepción</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td><label>Institución :</label></td>
											<td>
												<form:input type="text" name="institucionRecibeID" id="institucionRecibeID" size="4" tabindex="5" path="institucionRecibeID" />
												<input type="text" name="nombreinstitucionRecibeID" id="nombreinstitucionRecibeID" size="50" readOnly="true"  />
											</td>
										</tr>
										<tr>
											<td><label>Cuenta Bancaria:</label></td>
											<td>
												<form:input id="numCtaInstitRecibe" name="numCtaInstitRecibe" path="numCtaInstitRecibe" size="30" tabIndex="6" />
											</td>
											<td class="label">
												<label for="lblCostos">C. Costos:</label>
											</td>
											<td>
												<form:input id="cCostosRecibe" name="cCostosRecibe" path="cCostosRecibe" size="10" maxlength="10"  tabindex="6"/>
												<input type="text" id="nombCCostosRecibe" name="nombCCostosRecibe" size="40" readonly="readonly" >
											</td>

										</tr>
									</table>
								</fieldset>
							</td>
						</tr>
					</table>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td colspan="2">
								<table align="right" border='0'>
									<tr>
										<td align="right">
											<input type="submit" id="grabar" name="grabar" class="submit" tabIndex="7" value="Grabar" />
											<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
											<button type="button" class="submit" tabIndex="8" id="impPoliza" style="display:none">Ver Póliza</button>
											<input type="hidden" id="polizaID" name="polizaID" iniForma="false"/>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</form:form>
			</fieldset>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
		<div id="elementoLista"/>
		</div>
		<div id="mensaje" style="display: none;"/>
	</body>
</html>
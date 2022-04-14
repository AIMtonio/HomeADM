<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosDepRefServicio.js"></script>
		<script type="text/javascript" src="js/tesoreria/parametrosDepRef.js"></script>
	</head>

	<body>
		<br>
		<div id="contenedorForma">
			<fieldset class="ui-widget ui-widget-content ui-corner-all" >
				<legend class="ui-widget ui-widget-header ui-corner-all">Par&aacute;metros  de Recursos</legend>
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="parametrosDepRef"  target="_blank">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td>
								<label>Tipo Archivo:</label>
							</td>
							<td>
								<form:select id="tipoArchivo" name="tipoArchivo" path="tipoArchivo" tabindex="1" onchange="consultaParametros()">
									<form:option value="">SELECCIONAR</form:option>
									<form:option value="1">ARCHIVO ESTANDAR</form:option>
									<form:option value="2">BANORTE</form:option>
									<form:option value="3">BANAMEX</form:option>
									<form:option value="4">BBVA BANCOMER</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
						</tr>
					</table>

					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Referencia Cr&eacute;dito</legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label">
									<label>Aplica en autom&aacute;tico el pago de crédito: </label>
								</td>
								<td class="separador"></td>
								<td class="label">
									<form:radiobutton id="pagoCredAutomSI" name="pagoCredAutomSI" path="pagoCredAutom" value="S" tabindex="2" />
									<label for="pagoCredAutomSI">Si</label>
									<form:radiobutton id="pagoCredAutomNO" name="pagoCredAutomNO" path="pagoCredAutom" value="N"  tabindex="3" />
									<label for="pagoCredAutomNO">No</label>
								</td>
							</tr>
							<tr></tr>
							<tr>
								<td class="label">
									<label>En caso de no tener exigible: </label>
								</td>
								<td class="separador"></td>
								<td class="label">
									<form:radiobutton id="abonoCta" name="abonoCta" path="exigible" value="A" tabindex="4"/>
									<label for="abonoCta">Abono a Cuenta</label>
									<form:radiobutton id="prepagoCred" name="prepagoCred" path="exigible" value="P"  tabindex="5" />
									<label for="prepagoCred">Prepago de Cr&eacute;dito</label>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label>En caso de sobrante: </label>
								</td>
								<td class="separador"></td>
								<td class="label">
									<form:radiobutton id="sobranteprepagoCred" name="sobranteprepagoCred" path="sobrante" value="P" tabindex="6"/>
									<label for="sobranteprepagoCred">Prepago de Cr&eacute;dito</label>
									<form:radiobutton id="ahorro" name="ahorro" path="sobrante" value="A"  tabindex="7" />
									<label for="ahorro">Ahorro</label>
								</td>
							</tr>
							<tr>
								<td>
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="1"/>
									<input type="hidden" id="consecutivoID" name="consecutivoID"/>
									<input type="hidden" id="descripcionArch" name="descripcionArch"/>
								</td>
							</tr>
						</table>
					</fieldset>

					<div id="aplicDepAutom" style="">
						<br>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend>Aplicaci&oacute;n de dep&oacute;sitos autom&aacute;ticos</legend>
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td class="label">
										<label>Habilitar lectura autom&aacute;tica: </label>
									</td>
									<td>
										<form:radiobutton id="lecturaAutomSI" name="lecturaAutomSI" path="lecturaAutom" value="S" tabindex="8" />
										<label for="lecturaAutomSI">Si</label>
										<form:radiobutton id="lecturaAutomNO" name="lecturaAutomSI" path="lecturaAutom" value="N"  tabindex="9" />
										<label for="lecturaAutomNO">No</label>
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="rutaArchivos">Ruta de Archivos: </label>
									</td>
									<td>
										<form:input type="text" id="rutaArchivos" name="rutaArchivos" path="rutaArchivos" size="50" maxlength="150" tabindex="10"/>
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="tiempoLectura">Periodicidad de lectura (Minutos): </label>
									</td>
									<td>
										<form:input type="text" id="tiempoLectura" name="tiempoLectura" path="tiempoLectura" size="10" maxlengt="6" tabindex="11"/>
									</td>
								</tr>
							</table>
						</fieldset>
					</div>

					<div id="aplicCobranRef" >
						<br>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend>Cobranza Referenciada</legend>
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td class="label">
										<label>Aplica Cobranza Referenciada: </label>
									</td>
									<td>
										<input type="hidden" id="cobranzaRef" name="cobranzaRef"/>
										<input type="radio" id="cobranzaRefSI" name="cobranzaRefSI" value="S" tabindex="15"/>
										<label for="lbCobranzaRefSI">Si</label>
										<input type="radio" id="cobranzaRefNO" name="cobranzaRefNO" value="N" tabindex="16"/>
										<label for="lbCobranzaRefNO">No</label>
									</td>
								</tr>

								<tr>
									<td class="label">
										<label for="lbProductoCredito">Producto de Crédito: </label>
									</td>
									<td>
										<select id="productoCreditoID" name="productoCreditoID" tabindex="17">
										</select>
									</td>
								</tr>
							</table>
						</fieldset>
					</div>

					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="grabar" name="grabar" class="submit" value="Guardar" tabindex="12" />
							</td>
						</tr>
					</table>
			</form:form>
		</fieldset>
	</div>
	<div id="cargando" style="display: none;">
		</div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
		</body>
		<div id="mensaje" style="display: none;"></div>
</body>
</html>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/pagoRemesaSPEIServicio.js"></script>
<script type="text/javascript" src="js/spei/cartaAutorizacionPagoRemesas.js"></script>
<script type="text/javascript" src="js/spei/pagoRemesaSPEI.js"></script>
<title>Pago de Remesas SPEI</title>
</head>
<body>
	<div id="contenedorForma">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Pago de Remesas SPEI</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="pagoRemesaSPEIBean">
				<table width="100%">
					<tr>
						<td>
							<table width="100%">
								<tr>
									<td><label for="tipoBusqueda">Tipo de B&uacute;squeda:</label>
										<form:select id="tipoBusqueda" name="tipoBusqueda" path="tipoBusqueda" tabindex="1">
											<form:option value="">SELECCIONAR</form:option>
											<form:option value="1">REMESAS SPEI</form:option>
											<form:option value="2">AGENTES SPEI</form:option>
										</form:select>
										<input type="button" id="buscar" name="buscar" value="Buscar" class="submit" tabindex="2" style="display: none;">
									</td>

									<td class="label" style="text-align: right;"><label for="fecha">Fecha: </label>
										<form:input type="text" id="fecha" name="fecha" path="fecha" size="12" iniForma="false"
											disabled="true" readonly="true" style="text-align: right;" />
									</td>

									<td>
										<form:input type="hidden" id="usuarioAutoriza" name="usuarioAutoriza" path="usuarioAutoriza" size="12"
											iniForma="false" disabled="true" readonly="true" />
									</td>
								</tr>
							</table>

							<table id="agenteSpei" width="100%" style="display: none;">
								<tr>
									<td class="label"> <label for="cuentaAhoID">Cuenta:</label> </td>
									<td><input id="cuentaAhoID" name="cuentaAhoID" iniForma="false" size="13" tabindex="3" type="text" /></td>

									<td class="separador">

									<td class="label" style="text-align: right;"><label for="clienteID">Cliente:</label>
										<input id="clienteID" name="clienteID" readOnly="true" iniForma="false" size="13" type="text"
											disabled="true">
										<input id="nombreOrd" name="nombreOrd" size="45" type="text" readOnly="true" iniForma="false"
											disabled="true" />
									</td>
								</tr>

								<tr>
									<td class="label" nowrap="nowrap"><label for="saldoDisp">Saldo Disponible: </label></td>
									<td><input id="saldoDisp" name="saldoDisp" size="25" type="text" readOnly="true" iniForma="false"
											disabled="true" esMoneda="true" style='text-align:right;' /></td>
								</tr>

								<tr>
									<td class="separador"></td>
									<td class="separador"></td>
									<td class="separador"></td>
									<td style="text-align:right">
										<input type="button" id="buscarAge" name="buscarAge" value="Buscar" class="submit" tabindex="4">
									</td>
								</tr>
							</table>
					<table>
						<tr>
							<td><input type="hidden" id="datosGrid" name="datosGrid"
								size="100" />
								<div id="gridPagoRemesaSPEI"
									style="width: 775px; height: 380px; overflow-y: scroll; display: none; min-width: max-content;"></div>
							</td>
						</tr>
					</table>
						</td>
					</tr>

				</table>



				<div id=""></div>


				<table align="right">
					<tr style="text-align: right;">
						<td></td>
						<td><label>Cant.</label></td>
						<td><label>Monto</label></td>
					</tr>

					<tr style="text-align: right;">
						<td><label>Por Autorizar:</label></td>
						<td>
							<input type="text" id="cantAurotizar" name="cantAurotizar" size="5" style="text-align: right;"
							readOnly="true" disabled="true"/>
						</td>
						<td>
							<input type="text" id="montoAurotizar" name="montoAurotizar" size="15" style="text-align: right;" esMoneda="true"
							readOnly="true" disabled="true"/>
						</td>
					</tr>
				</table>

				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td colspan="4">
							<table align="right" border='0'>
								<tr>
									<td align="right">
										<input type="button" id="cartaAutorizacion" name="cartaAutorizacion" class="submit" value="Carta Autorizaci&oacute;n" tabindex="5" />
										<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="6" />
										<input type="submit" id="cancelar" name="cancelar" class="submit" value="Cancelar" tabindex="7" />
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
										<input type="hidden" name="ctrlCuentaAhoID" id="ctrlCuentaAhoID">
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
		<div id="elementoLista" />
	</div>
	<div id="mensaje" style="display: none;" />
</body>
</html>
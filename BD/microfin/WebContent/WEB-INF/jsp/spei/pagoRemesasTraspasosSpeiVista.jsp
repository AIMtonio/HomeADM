<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head>
	<script type="text/javascript" src="js/spei/cartaAutorizacionPagoRemesas.js"></script>
	<script type="text/javascript" src="js/spei/pagoRemesasTraspasosSpei.js"></script>
</head>
<body>

<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Pago de Remesas Cuentas Internas</legend>

		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="pagoRemesasTraspasosSpeiBean" target="_blank">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label" style="text-align: right;">
									<label for="lblFecha">Fecha: </label>
									<input type="text"
											id="fecha" name="fecha" size="12" tabindex="1"
											iniForma="false" disabled="true" readonly="true"
											style="text-align: right;" />
								</td>
								<td><form:input type="hidden"
											id="usuarioAutoriza" name="usuarioAutoriza" path="usuarioAutoriza"
											size="12"  iniForma="false" disabled="true"
											readonly="true" /></td>

								</tr>
						</table>

						<table style="width: max-content;">
							<tr>
								<td><input type="hidden" id="datosGrid" name="datosGrid" size="100" />
									<div id="gridPagoRemesasTraspasosSPEI"
										style="width: min-content; height: 300px;  overflow-y: scroll; display: none;"></div>
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
					<td><input type="text" id="cantAurotizar" name="cantAurotizar" size="5" style="text-align: right;" tabindex="2" />
					</td>
					<td>
						<input type="text" id="montoAurotizar" name="montoAurotizar" size="15" style="text-align: right;"
							tabindex="3" esMoneda="true"/>
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
										<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="5" />
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>

		</form:form>
	</fieldset>
</div>
<div id="cargando" style="display: none;">
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>
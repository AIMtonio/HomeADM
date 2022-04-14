<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/autorizaEnvioSpeiServicio.js"></script>
<script type="text/javascript" src="dwr/interface/origenesSpeiServicio.js"></script>
<script type="text/javascript" src="js/spei/autorizaEnvioSpei.js"></script>
</head>
<body>
	<div id="contenedorForma">

		<form:form id="formaGenerica" name="formaGenerica" method="POST"
			commandName="autorizaEnvioSpeiBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Autorizaci&oacute;n
					Env&iacute;o SPEI</legend>


				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>

						<td><label>Tipo de B&uacute;squeda:</label>
						<form:select id="tipoBusqueda" name="tipoBusqueda" 
								path="tipoBusqueda" tabindex="1" readonly="true" >
								<form:option value="">SELECCIONAR</form:option>
							</form:select>
						<input type="button" id="buscar" name="buscar" value="Buscar" class="submit"></td>

						<td class="label" style="text-align: right;"><label for="lblFecha">Fecha: </label><form:input
								type="text" id="fecha" name="fecha" path="fecha" size="12"
								tabindex="2" iniForma="false" disabled="true" readonly="true" style="text-align: right;"/>
							<form:input type="hidden" id="usuarioEnvio" name="usuarioEnvio"
								path="usuarioEnvio" size="12" tabindex="3" iniForma="false"
								disabled="true" readonly="true" /></td>
						<td><form:input type="hidden" id="usuarioVerifica" name="usuarioVerifica" path="usuarioVerifica" size="12" tabindex="4" iniForma="false" disabled="true" readonly="true"/><td>

					</tr>
				</table>
				<table>
					<tr>
						<td><input type="hidden" id="datosGrid" name="datosGrid" size="100" />
							<div id="gridAutorizaEnvioSPEI" style=" width: 880px; height: 380px; overflow-y: scroll;  display: none; "></div>



						</td>
					</tr>
				</table>

			<table align="right">
					<tr style="text-align: right;">
						<td></td>
						<td><label>Cant.</label></td>
						<td><label>Monto</label></td>
					</tr>

					<tr style="text-align: right;">
						<td><label>Por Autorizar:</label></td>
						<td><input type="text" id="cantAurotizar"
							name="cantAurotizar" size="5" style="text-align: right;" tabindex="5"/></td>
						<td><input type="text" id="montoAurotizar"
							name="montoAurotizar" size="15" style="text-align: right;" esMoneda="true" tabindex="6"/></td>
					</tr>
				</table>

				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td colspan="5">
							<table align="right">

								<tr>
									<td align="right"><input type="submit" id="procesar"
										name="procesar" class="submit" value="Procesar" tabindex="7"/> 
										<input type="hidden" id="tipoTransaccion"
										name="tipoTransaccion" /> <input type="hidden"
										id="tipoActualizacion" name="tipoActualizacion" tabindex="8" /></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista" />
	</div>
</body>
<div id="mensaje" style="display: none;" />
</html>

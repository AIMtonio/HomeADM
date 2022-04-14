<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tiposDocumentosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/paramGuardaValoresServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/puestosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
	<script type="text/javascript" src="js/guardaValores/paramGuardaValoresVista.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="paramGuardaValoresBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Par&aacute;metros Guarda Valores</legend>
				<br>
					<table width="100%">
						<tr>
							<td class="label">
								<label for="paramGuardaValoresID">N&uacute;mero: </label>
							</td>
							<td >
								<form:input type="text" id="paramGuardaValoresID" name="paramGuardaValoresID" path="paramGuardaValoresID" size="4" maxlength="11" tabindex="1" autocomplete="off" />
								<input type="text" id="nombreEmpresa" name="nombreEmpresa" path="nombreEmpresa" size="45" maxlength="100" readOnly="true" disabled="true" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="usuarioAdmon">Usuario Admon: </label>
							</td>
							<td >
								<form:input type="text" id="usuarioAdmon" name="usuarioAdmon" path="usuarioAdmon" size="10" maxlength="25" tabindex="2" autocomplete="off" />
								<form:input type="text" id="nombreUsuarioAdmon" name="nombreUsuarioAdmon" path="nombreUsuarioAdmon" size="50" maxlength="100" readOnly="true" disabled="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="correoRemitente">Correo Remitente:</label>
							</td>
							<td >
								<form:input type="text" id="correoRemitente" name="correoRemitente" path="correoRemitente" size="50" maxlength="50" tabindex="4" autocomplete="off" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="servidorCorreo">Servidor Correo:</label>
							</td>
							<td >
								<form:input type="text" id="servidorCorreo" name="servidorCorreo" path="servidorCorreo" size="50" maxlength="50" tabindex="5" autocomplete="off" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="usuarioServidor">Usuario Servidor:</label>
							</td>
							<td >
								<form:input type="text" id="usuarioServidor" name="usuarioServidor" path="usuarioServidor" size="50" maxlength="50" tabindex="6" autocomplete="off" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="contrasenia">Contrase&ntilde;a:</label>
							</td>
							<td >
								<form:input type="password" id="contrasenia" name="contrasenia" path="contrasenia" size="50" maxlength="50" tabindex="7" autocomplete="off" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="puerto">Puerto:</label>
							</td>
							<td >
								<form:input type="text" id="puerto" name="puerto" path="puerto" size="10" maxlength="10" tabindex="8" autocomplete="off" />
							</td>
						</tr>
					</table>
					<input type="hidden" id="numeroDetalle" name="numeroDetalle" value="1"/>
					<input type="hidden" id="numeroDetalleDoc" name="numeroDetalleDoc" value="1"/>
					<input type="hidden" id="datosGrid" name="datosGrid"/>
					<div id="paramGuardaValoresGrid"></div>
					<br>
					<div id="paramGuardaValoresDocGrid"></div>
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="30" />
							</td>
						</tr>
					</table>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
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
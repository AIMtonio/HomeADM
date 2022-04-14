<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/descargaRemesasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
	<script type="text/javascript" src="js/spei/descargaRemesas.js"></script>
</head>

<body>
<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Descarga Remesas</legend>

		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="descargaRemesasBean" target="_blank">
			<table width="100%">
				<tr>
					<td style='text-align:right;'>
						<label for="lblFecha">Fecha:</label>
						<input type="text" id="fecha" name="fecha" size="12" tabindex="1" iniForma="false" disabled="true"
							readonly="true" />
					</td>
				</tr>
			</table>

			<table width="100%">

				<tr>
					<td class="label">
						<label for="lblSpeiSolDesID">Solicitud:</label>
					</td>

					<td>
						<input type="text" id="speiSolDesID" name="speiSolDesID" iniForma="false" size="13" tabindex="2" />
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="lblUsuario">Usuario:</label>
					</td>
					<td>
						<input type="text" id="nombreUsuario" name="nombreUsuario" iniForma="false" size="40" readonly="true"
							tabindex="3" />

						<input type="hidden" id="usuario" name="usuario" iniForma="false" size="40" readonly="true"
							tabindex="4" />

					</td>
				</tr>

				<tr>
					<td class="label">
						<label for="fechaRegistro">Fecha Registro:</label>
					</td>
					<td>
						<input type="text" id="fechaRegistro" name="fechaRegistro" size="20" readonly="true" tabindex="5" />
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="fechaDescarga">Fecha Descarga:</label>
					</td>
					<td>
						<input id="fechaProceso" name="fechaProceso" iniForma="false" size="20" type="text" readonly="true"
							tabindex="6" />
					</td>
				</tr>

				<tr>
					<td class="label">
						<label for="estatus">Estatus:</label>
					</td>
					<td>
						<input type="text" id="muestraEstatus" name="muestraEstatus" size="20" readonly="true" />
						<input type="hidden" id="estatus" name="estatus" size="20" readonly="true" tabindex="7" />
					</td>
				</tr>
			</table>

			<table width="100%">
				<tr>
					<td colspan="5">
						<table align="right" border='0'>
							<tr align="right">
								<td align="right">
									<a target="_blank">
										<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar"
											tabindex="8" />
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
									</a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>

			<table>
				<tr>
					<td>
						<input type="hidden" id="datosGrid" name="datosGrid" size="100" />
						<div id="gridSolDescargas" style="width: max-content; height: 300px;  overflow-y: scroll; display: none;"></div>
					</td>
				</tr>
			</table>

			<table border=" 0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td colspan="5">
						<table align="right" border='0'>
							<tr align="right">
								<td align="right">
									<input type="button" id="actualizar" name="actualizar" value="Actualizar" class="submit"
										tabindex="9">
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
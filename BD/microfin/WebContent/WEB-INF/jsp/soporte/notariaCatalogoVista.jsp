<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/notariaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>
		<script type="text/javascript" src="js/forma.js"></script>
		<script type="text/javascript" src="js/soporte/mascara.js"></script>
		<script type="text/javascript" src="js/soporte/notariaCatalogo.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="notaria">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Notarias</legend>
					<table border="0"  width="950px">
						<tr>
							<td class="label">
								<label for="estadoID">Estado: </label>
							</td>
							<td >
								<form:input id="estadoID" name="estadoID" path="estadoID" size="3" tabindex="1"   iniForma = 'false'/>
								<input type="text" id="nombreEstado" name="nombreEstado" size="20" tabindex="2" disabled="true" readOnly="true"  iniForma = 'false'/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="municipioID">Municipio: </label>
							</td>
							<td>
								<form:input id="municipioID" name="municipioID" path="municipioID" size="3" tabindex="3" iniForma = 'false'/>
								<input id="nombreMunicipio" name="nombreMunicipio" size="25" tabindex="4" disabled="true" readOnly="true"  iniForma = 'false'/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="notariaID">No. Notaria: </label>
							</td>
							<td >
								<form:input id="notariaID" name="notariaID" path="notariaID" size="3" tabindex="5" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="titular">Titular: </label>
							</td>
							<td >
								<form:input id="titular" name="titular" path="titular" size="50"  maxlength="200"  tabindex="6" onBlur=" ponerMayusculas(this); limpiarCajaTexto(this.id);" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="direccion">Direcci&oacute;n: </label>
							</td>
							<td >
								<form:input id="direccion" name="direccion" path="direccion" size="50"  maxlength="240"  tabindex="7" onBlur=" ponerMayusculas(this); limpiarCajaTexto(this.id);" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="telefono">Tel&eacute;fono: </label>
							</td>
							<td >
								<form:input id="telefono" name="telefono" path="telefono" size="15" tabindex="8" maxlength="10"/>
								<a href="javaScript:" onClick="ayudaTelefono();">
									<img src="images/help-icon.gif" >
								</a>
								<label for="lblExt">Ext.:</label>
								<form:input id="extTelefonoPart" name="extTelefonoPart" path="extTelefonoPart" size="10" maxlength="6" tabindex="9"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="correo">Correo Electr&oacute;nico: </label>
							</td>
							<td>
								<form:input id="correo" name="correo" path="correo" size="35"  maxlength="50"  tabindex="10"/>
							</td>
						</tr>
					</table>
					<table align="right">
						<tr>
							<td colspan="5">
								<table align="right">
									<tr>
										<td align="right">
											<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="11"/>
											<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="12"/>
											<input type="submit" id="elimina" name="elimina" class="submit" value="Eliminar" tabindex="13"/>
											<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
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
		<div id="mensaje" style="display: none;"/>
		<div id="ContenedorAyuda" style="display: none;">
			<div id="elementoLista"/>
		</div>
	</body>
	<div id="mensaje" style="display: none;"/>
<html>

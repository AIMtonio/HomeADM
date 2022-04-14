<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/puestosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/empleadosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>  
<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>

<script type="text/javascript" src="js/gestionComercial/empleados.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="empleados">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Empleados</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label">
							<label for="empleadoID">Numero: </label>
						</td>
						<td>
							<form:input type="text" id="empleadoID" name="empleadoID" path="empleadoID" size="5" tabindex="1" iniforma="false" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="primerNombre">Primer Nombre:</label>
						</td>
						<td>
							<form:input id="primerNombre" name="primerNombre" path="primerNombre" tabindex="2" size="25" onBlur=" ponerMayusculas(this)" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="segundoNombre">Segundo Nombre: </label>
						</td>
						<td>
							<form:input id="segundoNombre" name="segundoNombre" path="segundoNombre" size="25" tabindex="3" onBlur=" ponerMayusculas(this)" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="apellidoPaterno">Apellido Paterno:</label>
						</td>
						<td>
							<form:input id="apellidoPat" name="apellidoPat" path="apellidoPat" size="25" tabindex="4" onBlur=" ponerMayusculas(this)" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="apellidoMaterno">Apellido Materno:</label>
						</td>
						<td>
							<form:input id="apellidoMat" name="apellidoMat" path="apellidoMat" size="25" tabindex="5" onBlur=" ponerMayusculas(this)" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="fechaNacimiento"> Fecha de Nacimiento:</label>
						</td>
						<td>
							<form:input id="fechaNac" name="fechaNac" path="fechaNac" size="15" tabindex="6" esCalendario="true" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="nacion">Nacionalidad:</label>
						</td>
						<td>
							<form:select id="nacion" name="nacion" path="nacion" tabindex="7">
								<form:option value="">SELECCIONAR</form:option>
								<form:option value="N">MEXICANA</form:option>
								<form:option value="E">EXTRANJERA</form:option>
							</form:select>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="lugarNacimiento">Pa&iacute;s de Nacimiento:</label>
						</td>
						<td>
							<form:input id="lugarNacimiento" name="lugarNacimiento" path="lugarNacimiento" size="5" tabindex="8" maxlength="9" />
							<input type="text" id="paisNac" name="paisNac" size="30" tabindex="9" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)" />
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="entidadFederativa">Entidad Federativa:</label>
						</td>
						<td nowrap="nowrap">
							<form:input id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="10" maxlength="3" />
							<input type="text" id="nombreEstado" name="nombreEstado" size="35" tabindex="11" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="sexo">G&eacute;nero:</label>
						</td>
						<td>
							<form:select id="sexo" name="sexo" path="sexo" tabindex="12">
								<form:option value="">SELECCIONAR</form:option>
								<form:option value="M">MASCULINO</form:option>
								<form:option value="F">FEMENINO</form:option>
							</form:select>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="CURP">CURP:</label>
						</td>
						<td>
							<form:input id="CURP" name="CURP" path="CURP" tabindex="13" size="25" onBlur=" ponerMayusculas(this)" maxlength="18" />
							<input type="button" id="generarc" name="generarc" value="Calcular" class="submit" style="display: none;" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label id="rFC" for="rFC"> RFC:</label>
						</td>
						<td>
							<form:input id="RFC" name="RFC" path="RFC" tabindex="14" size="25" onBlur=" ponerMayusculas(this)" maxlength="13" />
							<input type="button" id="generar" name="generar" value="Generar" class="submit" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="clavePuestoID">Puesto: </label>
						</td>
						<td>
							<form:input id="clavePuestoID" name="clavePuestoID" path="clavePuestoID" size="15" tabindex="15" onBlur=" ponerMayusculas(this)" />
							<input type="text" id="puesto" name="puesto" size="60" tabindex="16" disabled="true" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="atiendeSuc">Atiende sucursal: </label>
						</td>
						<td class="label">
							<input id="atiende" type="radio" name="atiende" value="S" disabled="true" iniforma="false" /> <label for="si">Si</label> <input id="atiende2" type="radio" name="atiende2" value="N" disabled="true" iniforma="false" /> <label for="no">No</label>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="sucursalID" id="sucursal2">Sucursal: </label>
						</td>
						<td>
							<form:input id="sucursalID" name="sucursalID" path="sucursalID" size="5" tabindex="17" />
							<input type="text" id="sucursal" name="sucursal" size="30" tabindex="18" disabled="true" />
						</td>
						<td class="separador"></td>
						<td>
							<label class="label">Estatus:</label>
						</td>
						<td>
							<input type="text" id="estatus" name="estatus" size="11" tabindex="19" disabled="true" />
						</td>
					</tr>
				</table>
				<div align="right">
					<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="20" /> <input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="16" /> <input type="submit" id="elimina" name="elimina" class="submit" value="Baja" tabindex="21" /> <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
				</div>
			</fieldset>
			<table align="right">
			</table>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista" />
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>

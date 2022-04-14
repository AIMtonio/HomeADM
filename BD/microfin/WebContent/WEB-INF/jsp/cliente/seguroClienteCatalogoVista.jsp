<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
      <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
      <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>                                                                                                                                                
 	  <script type="text/javascript" src="dwr/interface/motivActivacionServicio.js"></script>
 	  <script type="text/javascript" src="dwr/interface/seguroCliente.js"></script>
 	  <script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>	
	  <script type="text/javascript" src="js/soporte/ServerHuella.js"></script>
      <script type="text/javascript" src="js/cliente/seguroCliente.js"></script>      
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="seguroClienteBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Cancela Seguro de Vida</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label">
				<label for="Número de Póliza de Seguro:">Número de Póliza de Seguro: </label>
			</td>
			<td>
				<form:input id="seguroClienteID" name="seguroClienteID" path="seguroClienteID" size="12" tabindex="1"  />
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="lsucursalOrigen">Sucursal Alta Seguro: </label>
			</td>
		  	<td nowrap="nowrap">
				<input type="text" id="sucursalOrigen" name="sucursalOrigen" size="12"  disabled/>
				<input type="text" id="sucursalO" name="sucursalO" size="20" disabled/>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="lfechaAlta">Fecha de Alta de Seguro: </label>
			</td>
		  	<td nowrap="nowrap">
				<input type="text" id="fechaAlta" name="fechaAlta" size="12" disabled/>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="lblestatus">Estatus: </label>
			</td>
		  	<td nowrap="nowrap">
				<input type="text" id="desEstatus" name="desEstatus" size="20"  disabled/>
			</td>
		</tr>
		<tr><td><br></td></tr>
		<tr>
			<td colspan="5">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="ltipoPersona">Tipo Persona: </label>
							</td>
							<td>
								<input type="text" id="tipoPersona" name="tipoPersona" disabled/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="ltitulo">Título: </label>
							</td>
							<td>
								<input type="text" id="titulo" name="titulo" disabled/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lprimerNombre">Primer Nombre:</label>
							</td>
							<td>
								<input type="text" id="primerNombre" name="primerNombre" disabled/>
							</td>		
							<td class="separador"></td>
							<td class="label">
								<label for="lsegundoNombre">Segundo Nombre: </label>
							</td>
							<td >
								<input type="text" id="segundoNombre" name="segundoNombre"  disabled/>
							</td>
							<td class="separador"></td>
						</tr>
						<tr>
							<td class="label">
								<label for="ltercerNombre">Tercer Nombre:</label>
							</td>
							<td>
								<input type="text" id="tercerNombre" name="tercerNombre"  disabled/>
							</td>				
							<td class="separador"></td>
							<td class="label">
								<label for="lapellidoPaterno">Apellido Paterno:</label>
							</td>
							<td>
								<input type="text" id="apellidoPaterno" name="apellidoPaterno" disabled/>
							</td>		
						</tr>
						<tr>
							<td class="label">
								<label for="lapellidoMaterno">Apellido Materno:</label>
							</td>
							<td>
								<input type="text" id="apellidoMaterno" name="apellidoMaterno" disabled/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lfechaNacimiento">Fecha de Nacimiento:</label>
							</td>
							<td>
								<input type="text" id="fechaNacimiento" name="fechaNacimiento" disabled/>
							</td>		
						</tr>
						
					</table>
				</fieldset>
			</td>
		</tr>
		<tr><td><br></td></tr>
		<tr>
			<td colspan="5">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Motivo</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="lmotivoCancela">Motivo Cancelación: </label>
							</td>
							<td>
								<form:select id="motivoCambioEstatus" name="motivoCambioEstatus" path="motivoCambioEstatus" tabindex="2">
									<form:option value="0">TODOS</form:option> 
							    </form:select>
							</td>	
						</tr>
						<tr>
							<td class="label">
								<label for="lobservaciones">Observaciones:</label>
							</td>
							<td>
								<form:textarea id="observacion" name="observacion" path="observacion" COLS="35" ROWS="4" tabindex="3" maxlength="200" onBlur=" ponerMayusculas(this)"/>
							</td>		
						</tr>
						<tr><td><br></td></tr>
						<tr>
							<td colspan="5">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">		
								<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Usuario Autoriza</legend>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label">
												<label for="lusuario">Usuario:</label>
											</td>
											<td>
												<form:input id="claveUsuarioAutoriza" name="claveUsuarioAutoriza" path="claveUsuarioAutoriza" size="20" tabindex="4" />
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lcontrasenia">Contraseña:</label>
											</td>
											<td>
												<form:input type="password" id="contrasenia" name="contrasenia" path="contrasenia" size="20" tabindex="5" autocomplete="new-password" />
											</td>
										</tr>
										<span id="statusSrvHuella" style="float: right; display: none;"></span>
									</table>
								</fieldset>
							</td>
						</tr>
					</table>
				</fieldset>
			</td>
		</tr>
	</table>
	<br>
</fieldset>
	<table width="100%">
		<tr>
			<td align="right">
				<input type="button" id="cancelar" name="cancelar" class="submit" value="Cancelar"  tabindex="6"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
			</td>
		</tr>
	</table>		
</form:form>
</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>

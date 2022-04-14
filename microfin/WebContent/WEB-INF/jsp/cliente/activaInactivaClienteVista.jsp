<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
 	  	<script type="text/javascript" src="dwr/interface/motivActivacionServicio.js"></script>
 	  	<script type="text/javascript" src="dwr/interface/cobroReactivaCliServicio.js"></script>
 	  	<script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>	
		<script type="text/javascript" src="js/soporte/ServerHuella.js"></script>
 	  	<script type="text/javascript" src="js/soporte/mascara.js"></script>
      	<script type="text/javascript" src="js/cliente/activaInactiva.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cliente">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all"><s:message code="safilocale.cliente"/></legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="numero">N&uacute;mero:</label>
							</td>
							<td>
								<form:input id="numero" name="numero" path="numero" size="12" tabindex="1"  />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="sucursalOrigen">Sucursal: </label>
							</td>
		  					<td nowrap="nowrap">
								<form:input id="sucursalOrigen" name="sucursalOrigen" path="sucursalOrigen" disabled="true" readOnly="true" iniForma="false"
									size="6"  />
								<input type="text" id="sucursalO" name="sucursalO" size="37" disabled="true" readOnly="true" iniForma="false"/>
							</td>
							<td class="label">
								<label for="lblEstatus">Estatus: </label>
							</td>
							<td>
								<input type="text" id="estatus" name="estatus" size="20" disabled="true" readOnly="true" />
							</td>					
						</tr>
<!-- 						<tr> -->
<!-- 							<td><input type ="button" id="buscarMiSuc" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/></td> -->
<!-- 							<td><input type ="button" id="buscarGeneral" name="buscarGeneral" value="Busqueda General" class="submit"/></td> -->
<!-- 						</tr> -->
						
						<tr>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
						</tr>
					</table>
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">	
						<legend >Datos Del <s:message code="safilocale.cliente"/> o Representante Legal</legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label"> 
									<label for="tipoPersona">Tipo Persona: </label> 
								</td>
								<td class="label"> 
									<form:radiobutton id="tipoPersona" name="tipoPersona" path="tipoPersona" value="F"  checked="checked" disabled="true"/>
									<label for="fisica">F&iacute;sica</label>&nbsp;&nbsp;
									<form:radiobutton id="tipoPersona3" name="tipoPersona3" path="tipoPersona" value="A" disabled="true"/>
									<label for="fisica">F&iacute;sica Act Emp</label>
									<form:radiobutton id="tipoPersona2" name="tipoPersona2" path="tipoPersona" value="M"  disabled="true"/>
									<label for="fisica">Moral</label>
								</td>		
								<td class="separador"></td>
								<td class="label">
									<label for="titulo">T&iacute;tulo:</label>
								</td>
								<td>
									<form:select id="titulo" name="titulo" path="titulo" disabled="true">
										<form:option value="SR."></form:option> 
				     					<form:option value="SRA."></form:option> 
				     					<form:option value="SRITA."></form:option> 
					   					<form:option value="LIC."></form:option> 
					  					<form:option value="DR."></form:option> 
										<form:option value="ING."></form:option> 
										<form:option value="PROF."></form:option> 
										<form:option value="C. P."></form:option> 
									</form:select>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="primerNombre">Primer Nombre:</label>
								</td>
								<td>
									<form:input id="primerNombre" name="primerNombre" path="primerNombre" onBlur=" ponerMayusculas(this)" readonly="true"/>
								</td>		
								<td class="separador"></td>
								<td class="label">
									<label for="segundoNombre">Segundo Nombre: </label>
								</td>
								<td>
									<form:input id="segundoNombre" name="segundoNombre" path="segundoNombre" onBlur=" ponerMayusculas(this)" readonly="true"/>
								</td>
								<td class="separador"></td>
							</tr>
							<tr>
								<td class="label">
									<label for="tercerNombre">Tercer Nombre:</label>
								</td>
								<td>
									<form:input id="tercerNombre" name="tercerNombre" path="tercerNombre" onBlur=" ponerMayusculas(this)" readonly="true"/>
								</td>				
								<td class="separador"></td>
								<td class="label">
									<label for="apellidoPaterno">Apellido Paterno:</label>
								</td>
								<td>
									<form:input id="apellidoPaterno" name="apellidoPaterno" path="apellidoPaterno" onBlur=" ponerMayusculas(this)" readonly="true"/>
								</td>		
							</tr>
							<tr>
								<td class="label">
									<label for="apellidoMaterno">Apellido Materno:</label>
								</td>
								<td>
									<form:input id="apellidoMaterno" name="apellidoMaterno" path="apellidoMaterno" onBlur=" ponerMayusculas(this)" readonly="true"/>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="fechaNacimiento">Fecha de Nacimiento:</label>
								</td>
								<td>
									<form:input id="fechaNacimiento" name="fechaNacimiento" path="fechaNacimiento" size="20" readonly="true"/>
								</td>		
							</tr>
							<tr>
								<td class="label">
									<label for="nacion">Nacionalidad:</label>
								</td>
								<td>
									<form:select id="nacion" name="nacion" path="nacion" disabled="true">
										<form:option value="N">MEXICANA</form:option> 
				    					<form:option value="E">EXTRANJERA</form:option>
									</form:select>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="lugarNacimiento">País de Nacimiento:</label>
								</td>
								<td>
									<form:input id="lugarNacimiento" name="lugarNacimiento" path="lugarNacimiento" size="5" readonly="true"/>
									<input type="text" id="paisNac" name="paisNac" size="30" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)"/>
								</td>
							</tr>
							<tr>				
								<td class="label">
									<label for="entidadFederativa">Entidad Federativa:</label>
								</td>
								<td>
									<form:input id="estadoID" name="estadoID" path="estadoID" size="6" readonly="true" />
		         						<input type="text" id="nombreEstado" name="nombreEstado" size="35" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)"/>   
								</td>	
								<td class="separador"></td>
								<td class="label">
									<label for="paisResidencia">País de Residencia: </label>
								</td>
								<td>
									<form:input id="paisResidencia" name="paisResidencia" path="paisResidencia" size="5" readonly="true"/>
									<input type="text" id="paisR" name="paisR" size="30" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)"/>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="sexo">Género:</label>
								</td>
								<td>
									<form:select id="sexo" name="sexo" path="sexo" disabled="true">
										<form:option value="M">MASCULINO</form:option>
			     						<form:option value="F">FEMENINO</form:option>
									</form:select>
								</td>		
								<td class="separador"></td>
								<td class="label">
									<label for="CURP">CURP:</label>
								</td>
								<td>
									<form:input id="CURP" name="CURP" path="CURP" size="25" onBlur=" ponerMayusculas(this)" maxlength="18" readonly="true"/>
								</td>		
							</tr>	
							<tr>
								<td class="label">
									<label for="RFCl"> RFC:</label>
								</td>
								<td>
									<form:input id="RFC" name="RFC" path="RFC" maxlength="13" onBlur=" ponerMayusculas(this)" readonly="true"/>
								</td>	
								<td class="separador"></td>
								<td class="label">
									<label for="estadoCivil">Estado Civil:</label>
								</td>
								<td>
									<form:select id="estadoCivil" name="estadoCivil" path="estadoCivil" disabled="true">
										<form:option value="S">SOLTERO</form:option>
			     						<form:option value="CS">CASADO BIENES SEPARADOS</form:option>
			     						<form:option value="CM">CASADO BIENES MANCOMUNADOS</form:option>
			     						<form:option value="CC">CASADO BIENES MANCOMUNADOS CON CAPITULACION</form:option>
			     						<form:option value="V">VIUDO</form:option>
			     						<form:option value="D">DIVORCIADO</form:option>
			     						<form:option value="SE">SEPARADO</form:option>
			     						<form:option value="U">UNION LIBRE</form:option>
									</form:select>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="telefonoCelular">Teléfono Celular: </label>
								</td>
								<td>
									<form:input id="telefonoCelular" name="telefonoCelular" maxlength="10" size="15" path="telefonoCelular" readonly="true"/>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="telefonoCasa">Teléfono Particular:</label>
								</td>
								<td>
									<form:input id="telefonoCasa" name="telefonoCasa" maxlength="10" path="telefonoCasa" size="15" readonly="true"/>
								</td>	
							</tr>
							<tr>
								<td class="label">
									<label for="correo"> Correo Electr&oacute;nico:</label>
								</td>
								<td>
									<form:input id="correo" name="correo" path="correo" size="30" readonly="true"/>
								</td>	
								<td class="separador"></td>
								<td class="label">
									<label for="fax">Número Fax:</label>
								</td>
								<td>
									<form:input id="fax" name="fax" path="fax" readonly="true"/>
								</td>	
							</tr>
							<tr>
								<td>
									<label for="Motivo">Motivo Activa/Inactiva: </label>
								</td>
								<td>
									<textarea id="motivo" name="motivo" rows="3" cols="40" onblur="ponerMayusculas(this);" readonly="true" disabled="true"></textarea>
								</td>
							</tr>
						</table>
					</fieldset>
					<br>
					<fieldset id="nuevoMotivo" class="ui-widget ui-widget-content ui-corner-all">
						<legend >Motivo de Activación / Inactivación</legend>
						<table>
							<tr>
								<td class="label">
									<label for="motivo">Motivo:</label>
								</td>
								<td>
									<form:select id="tipoInactiva" name="tipoInactiva" path="tipoInactiva"  tabindex="2">										
									</form:select>
								</td>
							</tr>
							<tr>
								<td>
									<label for="observaciones">Observaciones:</label>
								</td>
								<td>
									<textarea id="motivoInactiva" name="motivoInactiva" path="motivoInactiva" rows="3" cols="40" tabindex="3" onblur="ponerMayusculas(this);" maxlength="150">
									</textarea>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<div id="usuarioContrasenia">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend class="ui-widget ui-widget-header ui-corner-all">Usuario  Autoriza</legend>
											<table border="0" cellpadding="0" cellspacing="0" width="100%">
												<tr>
													<td class="label" nowrap="nowrap">
														<label for="lblUsuario">Usuario:</label>
													</td>
													<td>
														<input id="claveUsuarioAut" name="claveUsuarioAut" size="20" type="password" tabindex="4" autocomplete="new-password"/>
													</td>
												</tr>
												<tr>
													<td class="label" nowrap="nowrap">
														<label for="lblContrasenia">Contrase&ntilde;a:</label>
													</td>
													<td>
														<input id="contraseniaAut" name="contraseniaAut" size="20" type="password" iniForma="false" tabindex="5" autocomplete="new-password"/>
													</td>
												</tr>
												<input type="hidden" id="descripcionOper" name="descripcionOper" size="50" tabindex="2" iniForma="false"/>
												<input type="hidden" id="usuarioAutID" name="usuarioAutID" size="50" tabindex="2" iniForma="false"/>
												<span id="statusSrvHuella" style="float: right; display: none;"></span>
											</table>
										</fieldset>
									</div>								
								</td>
							</tr>
						</table>
					</fieldset>
				
				<table width="100%">
					<tr>
						<td align="right">
							<input type="button" id="activa" name="activa" class="submit" value="Activar"  tabindex="6"/>
							<input type="button" id="inactiva" name="inactiva" class="submit" value="Inactivar"  tabindex="7"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
							<input type="hidden" id="permiteReactReqCosto" name="permiteReactReqCosto"/>
						</td>
					</tr>
				</table>
			</fieldset>
			</form:form>
		</div>
		
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
		
		<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
			<div id="elementoListaCte"></div>
		</div>
		
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>
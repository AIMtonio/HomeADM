<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>

<head>
	<script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>  
   	<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script> 
   	<script type="text/javascript" src="dwr/interface/coloniaRepubServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/tipoSociedadServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/notariaServicio.js"></script>

	<script type="text/javascript" src="dwr/interface/gruposEmpServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tipoSociedadServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tiposIdentiServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/identifiClienteServicio.js"></script>	
	<script type="text/javascript" src="dwr/interface/garantesServicio.js"></script>

	<script type="text/javascript" src="js/soporte/mascara.js"></script>
	<script type="text/javascript" src="js/originacion/garantesCatalogo.js"></script>
</head>

<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="garantesBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Alta de Garantes</legend>
				<table>
					<tr>
						<td class="label">
							<label for="numero">N&uacute;mero: </label>
						</td>
						<td>
							<form:input id="numero" name="numero" path="numero" size="12" tabindex="1" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="tipoPersona">Tipo Persona: </label>
						</td>
						<td class="label">
							<form:radiobutton id="tipoPersona1" name="tipoPersona1" path="tipoPersona" value="F" tabindex="6" checked="checked" />
							<label for="fisica">F&iacute;sica</label>&nbsp;&nbsp;
							<form:radiobutton id="tipoPersona3" name="tipoPersona3" path="tipoPersona" value="A" tabindex="7" />
							<label for="fisica">F&iacute;sica Act Emp</label>
							<form:radiobutton id="tipoPersona2" name="tipoPersona2" path="tipoPersona" value="M" tabindex="8" />
							<label for="fisica">Moral</label>
						</td>
					</tr>

				</table>
				<br>
				<div id="datosPersonaFisica" >
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Datos del Garante</legend>

						<table style="display:block;" border="0" width="100%">
							<tr>
								<td></td>
								<td></td>
								<td class="separador"></td>
								<td class="label">
									<label for="titulo">T&iacute;tulo:</label>
								</td>
								<td>
									<form:select id="titulo" name="titulo" path="titulo" tabindex="9">
										<form:option value="">SELECCIONAR</form:option>
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
									<form:input id="primerNombre" name="primerNombre" path="primerNombre" tabindex="10" onBlur=" ponerMayusculas(this)" maxlength="50" />
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="segundoNombre">Segundo Nombre: </label>
								</td>
								<td>
									<form:input id="segundoNombre" name="segundoNombre" path="segundoNombre" tabindex="11" onBlur=" ponerMayusculas(this)" maxlength="50" />
								</td>
								<td class="separador"></td>
							</tr>
							<tr>
								<td class="label">
									<label for="tercerNombre">Tercer Nombre:</label>
								</td>
								<td>
									<form:input id="tercerNombre" name="tercerNombre" path="tercerNombre" tabindex="12" onBlur=" ponerMayusculas(this)" maxlength="50" />
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="apellidoPaterno">Apellido Paterno:</label>
								</td>
								<td>
									<form:input id="apellidoPaterno" name="apellidoPaterno" path="apellidoPaterno" tabindex="13" onBlur=" ponerMayusculas(this)" maxlength="50" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="apellidoMaterno">Apellido Materno:</label>
								</td>
								<td>
									<form:input id="apellidoMaterno" name="apellidoMaterno" path="apellidoMaterno" tabindex="14" onBlur=" ponerMayusculas(this)" maxlength="50" />
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
									<label for="fechaNacimiento">Fecha de Nacimiento:</label>
								</td>
								<td nowrap="nowrap">
									<form:input id="fechaNacimiento" name="fechaNacimiento" path="fechaNacimiento" size="20" tabindex="15" esCalendario="true" maxlength="10" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="nacionalidad">Nacionalidad:</label>
								</td>
								<td>
									<form:select id="nacionalidad" name="nacionalidad" path="nacionalidad" tabindex="16">
										<form:option value="">SELECCIONAR</form:option>
										<form:option value="N">MEXICANA</form:option>
										<form:option value="E">EXTRANJERA</form:option>
									</form:select>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="lugarNacimiento">Pa&iacute;s de Nacimiento:</label>
								</td>
								<td>
									<form:input id="lugarNacimiento" name="lugarNacimiento" path="lugarNacimiento" size="5" tabindex="17" maxlength="9" />
									<input type="text" id="paisNac" name="paisNac" size="30" tabindex="18" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)" />
								</td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="entidadFederativa">Entidad Federativa:</label>
								</td>
								<td nowrap="nowrap">
									<form:input id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="19" maxlength="3" />
									<input type="text" id="nombreEstado" name="nombreEstado" size="35" tabindex="20" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)" />
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="paisResidencia">Pa&iacute;s de Residencia: </label>
								</td>
								<td>
									<form:input id="paisResidencia" name="paisResidencia" path="paisResidencia" size="5" tabindex="21" maxlength="9" />
									<input type="text" id="paisR" name="paisR" size="30" tabindex="22" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="sexo">G&eacute;nero:</label>
								</td>
								<td>
									<form:select id="sexo" name="sexo" path="sexo" tabindex="23">
										<form:option value="">SELECCIONAR</form:option>
										<form:option value="M">MASCULINO</form:option>
										<form:option value="F">FEMENINO</form:option>
									</form:select>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="curp">CURP:</label>
								</td>
								<td>
									<form:input id="curp" name="curp" path="curp" tabindex="24" size="25" onBlur=" ponerMayusculas(this)" maxlength="18" />
									<input type="button" id="generarc" name="generarc" value="Calcular" class="submit" style="display: none;" />
								</td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="registroAltaHacienda">Registro de Alta en Hacienda: </label>
								</td>
								<td class="label" nowrap="nowrap">
									<form:radiobutton id="registroHaciendaSi" name="registroHacienda" path="registroHacienda" value="S" tabindex="25" />
									<label for="si">Si</label>&nbsp;&nbsp;
									<form:radiobutton id="registroHaciendaNo" name="registroHacienda" path="registroHacienda" value="N" tabindex="26" checked="checked" />
									<label for="no">No</label>

								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="rfc"> RFC:</label>
								</td>
								<td>
									<form:input id="rfc" name="rfc" path="rfc" maxlength="13" tabindex="27" onBlur=" ponerMayusculas(this)" />
									<input type="button" id="generar" name="generar" value="Calcular" class="submit" style="display: none;" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="fechaConstitucion">Fecha de Constituci&oacute;n RFC:&nbsp;</label>
								</td>
								<td>
									<form:input id="fechaConstitucion" name="fechaConstitucion" path="fechaConstitucion" size="20" tabindex="31" esCalendario="true" maxlength="10" />
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="estadoCivil">Estado Civil:</label>
								</td>
								<td>
									<form:select id="estadoCivil" name="estadoCivil" path="estadoCivil" tabindex="32">
										<form:option value="">SELECCIONAR</form:option>
										<form:option value="S">SOLTERO</form:option>
										<form:option value="CS">CASADO BIENES SEPARADOS</form:option>
										<form:option value="CM">CASADO BIENES MANCOMUNADOS</form:option>
										<form:option value="CC">CASADO BIENES MANCOMUNADOS CON CAPITULACION</form:option>
										<form:option value="V">VIUDO</form:option>
										<form:option value="D">DIVORCIADO</form:option>
										<form:option value="U">UNION LIBRE</form:option>
									</form:select>
								</td>

							</tr>
							<tr>
								<td class="label">
									<label for="telefonoCelular">Tel&eacute;fono Celular: </label>
								</td>
								<td>
									<form:input id="telefonoCelular" name="telefonoCelular" maxlength="20" size="15" path="telefonoCelular" tabindex="33" />
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="telefono">Tel&eacute;fono Particular:</label>
								</td>
								<td>
									<form:input id="telefono" name="telefono" maxlength="20" path="telefono" size="15" tabindex="34" />
									<label for="ext">Ext.:</label>
									<form:input path="extTelefonoPart" id="extTelefonoPart" name="extTelefonoPart" maxlength="7" tabindex="35" size="10" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="correo"> Correo Electr&oacute;nico:</label>
								</td>
								<td>
									<form:input id="correo" name="correo" path="correo" tabindex="36" size="30" maxlength="50" />
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="fax">N&uacute;mero Fax:</label>
								</td>
								<td>
									<form:input id="fax" name="fax" path="fax" tabindex="37" size="30" maxlength="30" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="observaciones">Observaciones:</label>
								</td>
								<td>
									<textarea id="observaciones" name="observaciones" path="observaciones" cols="30" rows="4" onblur=" ponerMayusculas(this)" tabindex="38" maxlength="800"></textarea>
								</td>
							</tr>
							<tr>
								<td class="label"> 
									<label for="tIdentiID">Tipo: </label> 
								</td> 
								<td> 
									<form:select id="tipoIdentiID" name="tipoIdentiID" path="tipoIdentiID" tabindex="39">
										<form:option value="">SELECCIONAR</form:option>
									</form:select>
								</td>
								<td class="separador"></td>
								<td class="label"> 
									<label for="nIdentific">Folio: </label> 
								</td> 
								<td> 
									<form:input id="numIdentific" name="numIdentific" path="numIdentific" size="25" tabindex="40" onBlur=" ponerMayusculas(this)"/> 
								</td> 
							</tr>
							<tr>
								<td class="label"> 
									<label for="lblFecExIden">Fecha Expedici&oacute;n: </label> 
								</td> 
								<td> 
									<form:input id="fecExIden" name="fecExIden" path="fecExIden" size="14" tabindex="41" esCalendario="true" /> 
								</td> 
								<td class="separador"></td>
								<td class="label"> 
									<label for="lblFecVenIden">Fecha Vencimiento:</label> 
								</td> 
								<td> 
									<form:input id="fecVenIden" name="fecVenIden" path="fecVenIden" size="14" tabindex="42" esCalendario="true"/> 
								</td> 
							</tr>
							<tr>
								<td class="label" nowrap="nowrap"> 
									<label for="estado">Entidad Federativa: </label> 
								</td> 
								<td nowrap="nowrap"> 
									<form:input id="estadoIDDir" name="estadoIDDir" path="estadoIDDir" size="6" tabindex="43" /> 
									<input type="text" id="nombreEstadoDir" name="nombreEstadoDir" size="35" tabindex="44" disabled ="true" readonly="true"/>   
								</td> 
								<td class="separador"></td>
								<td class="label"> 
									<label for="municipio">Municipio: </label> 
								</td> 
								<td nowrap="nowrap"> 
									<form:input id="municipioID" name="municipioID" path="municipioID" size="6" tabindex="45" /> 
									<input type="text" id="nombreMuni" name="nombreMuni" size="35" tabindex="46" disabled="true" readonly="true"/>   
								</td> 
							</tr>
							<tr>
								<td class="label"> 
									<label for="calle">Localidad: </label> 
								</td> 
								<td nowrap="nowrap"> 
									<form:input id="localidadID" name="localidadID" path="localidadID" size="6" tabindex="47"  autocomplete="off" /> 
									<input type="text" id="nombrelocalidad" name="nombrelocalidad" size="35" tabindex="48" disabled="true" onBlur=" ponerMayusculas(this)" readonly="true"/>   
								</td>  
								<td class="separador"></td>
								<td class="label"> 
									<label for="calle">Colonia: </label> 
								</td> 
								<td nowrap="nowrap"> 
									<form:input id="coloniaID" name="coloniaID" path="coloniaID" size="6" tabindex="49" /> 
									<input type="text" id="nombreColonia" name="nombreColonia" size="35" tabindex="50" disabled="true"  onBlur=" ponerMayusculas(this)" maxlength = "200" readonly="true"/>   
								</td> 
							</tr>
							<tr> 
								<td class="label"> 
									<label for="calle">Calle: </label> 
								</td> 
								<td nowrap="nowrap"> 
									<form:input id="calle" name="calle" path="calle" size="45" tabindex="51"  onBlur=" ponerMayusculas(this)" maxlength = "50"/> 
								</td> 
								<td class="separador"></td>
								<td class="label"> 
									<label for="numero">N&uacute;mero Exterior: </label> 
								</td> 
								<td nowrap="nowrap"> 
									<form:input id="numeroCasa" name="numeroCasa" path="numeroCasa" size="5" tabindex="52"  onBlur=" ponerMayusculas(this)" />
								</td> 
							</tr>
							<tr>
								<td class="label"> 
									<label for="numero">N&uacute;mero Interior: </label> 
								</td> 
								<td nowrap="nowrap"> 
									<form:input id="numInterior" name="numInterior" path="numInterior" size="5" tabindex="53"  onBlur=" ponerMayusculas(this)"/>
								</td>
								<td class="separador"></td>
								<td class="label"> 
									<label for="CP">C&oacute;digo Postal: </label> 
								</td> 
								<td nowrap="nowrap"> 
									<form:input id="CP" name="CP" path="CP" size="15" maxlength="5" tabindex="54" /> 
								</td>
							</tr>
							<tr> 
								<td class="label"> 
									<label for="Lote">Lote: </label> 
								</td> 
								<td nowrap="nowrap"> 
									<form:input id="lote" name="lote" path="lote" size="20" tabindex="55" onBlur=" ponerMayusculas(this)"/> 
								</td> 
								<td class="separador"></td> 
								<td class="label"> 
									<label for="Manzana">Manzana: </label> 
								</td> 
								<td nowrap="nowrap"> 
									<form:input id="manzana" name="manzana" path="manzana" size="20" tabindex="56"  onBlur=" ponerMayusculas(this)"/> 
								</td> 
						</tr>
						</table>
					</fieldset>
				</div>
				<br>
				<div id="personaMoral" style="display:none">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Datos Generales de la Empresa</legend>
						<table border="0" width="100%">
							<tr>
								<td class="label">
									<label for="razonSocial">Raz&oacute;n Social:</label>
								</td>
								<td>
									<form:input id="razonSocial" name="razonSocial" path="razonSocial" size="50" tabindex="39" onBlur=" ponerMayusculas(this)" maxlength="150" />
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="rfcPM">RFC:</label>
								</td>
								<td>
									<form:input id="rfcPM" name="rfcPM" path="rfcPM" tabindex="40" maxlength="13" onBlur=" ponerMayusculas(this)" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="nacionalidadPM">Nacionalidad:</label>
								</td>
								<td>
									<form:select id="nacionalidadPM" name="nacionalidadPM" path="nacionalidadPM" tabindex="41">
										<form:option value="">SELECCIONAR</form:option>
										<form:option value="N">MEXICANA</form:option>
										<form:option value="E">EXTRANJERA</form:option>
									</form:select>
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
									<label for="paisConstitucionID">Pa&iacute;s de Constituci&oacute;n:</label>
								</td>
								<td>
									<form:input id="paisConstitucionID" name="paisConstitucionID" path="paisConstitucionID" size="7" tabindex="42" maxlength="9" />
									<input type="text" id="descPaisConst" name="descPaisConst" size="40" tabindex="43" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)" />
								</td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="correoPM">Correo Electr&oacute;nico:</label>
								</td>
								<td nowrap="nowrap">
									<form:input id="correoPM" name="correoPM" path="correoPM" size="50" tabindex="44" maxlength="50" />
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
									<label for="correoAlternativo">Correo Alternativo:</label>
								</td>
								<td nowrap="nowrap">
									<form:input id="correoAlternativo" name="correoAlternativo" path="correoAlternativo" size="48" tabindex="45" maxlength="50" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="telefonoPM">Tel&eacute;fono:</label>
								</td>
								<td>
									<form:input id="telefonoPM" name="telefonoPM" maxlength="20" path="telefonoPM" size="15" tabindex="46" />
									<label for="ext">Ext.:</label>
									<form:input path="extTelefonoPartPM" id="extTelefonoPartPM" name="extTelefonoPartPM" maxlength="7" tabindex="47" size="10" />
								</td>

								<td class="separador"></td>
								<td class="label">
									<label for="sociedad">Tipo de Sociedad: </label>
								</td>
								<td>
									<form:input id="tipoSociedad" name="tipoSociedad" path="tipoSociedad" size="7" tabindex="48" maxlength="5" />
									<input type="text" id="descripSociedad" name="descripSociedad" size="40" tabindex="49" disabled="true" readOnly="true" onBlur="ponerMayusculas(this)" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="grupoEmpresarial">Grupo Empresarial:</label>
								</td>
								<td>
									<form:input id="grupoEmpresarial" name="grupoEmpresarial" path="grupoEmpresarial" size="6" tabindex="50" maxlength="9" />
									<input type="text" id="NombreGrupo" name="NombreGrupo" size="30" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)" />
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="fechaConstitucionPM">Fecha de Registro:</label>
								</td>
								<td>
									<form:input id="fechaConstitucionPM" name="fechaConstitucionPM" path="fechaConstitucionPM" size="20" tabindex="51" esCalendario="true" maxlength="12" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="fea" id="feaLbl">Registro de FEA:&nbsp;</label>
								</td>
								<td>
									<form:input id="fea" name="fea" path="fea" tabindex="56" size="30" maxlength="250" onblur=" ponerMayusculas(this)" />
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="paisFEA" >Pa&iacute;s que Asigna FEA: </label>
								</td>
								<td>
									<form:input id="paisFEA" name="paisFEA" path="paisFEA" size="5" tabindex="57" maxlength="9" />
									<input type="text" id="paisFPM" name="paisFPM" size="30" tabindex="58" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)" />
								</td>
							</tr>
						</table>
					</fieldset>
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">		
						<legend>Escritura P&uacute;blica</legend>	
						<table border="0" width="100%">
							<tr> 
									<td class="label"> 
										<label for="tipo escritura">Tipo de Acta: </label> 
									</td> 
									<td> 
									<form:select id="esc_Tipo" name="esc_Tipo" path="esc_Tipo" tabindex="58">
										<form:option value="">SELECCIONAR</form:option>
										<form:option value="C">CONSTITUTIVA</form:option>
										<form:option value="P">DE PODERES</form:option> 
									</form:select>
									</td> 
									<td class="separador"></td> 
									<td class="label"> 
										<label for="EscrituraPub">Escritura P&uacute;blica: </label> 
									</td> 
									<td> 
										<form:input id="escrituraPub" name="escrituraPub" path="escrituraPub" size="15" tabindex="59" maxlength="50" onBlur=" ponerMayusculas(this)" /> 
									</td> 
							</tr>   
							<tr> 
								<td class="label"> 
									<label for="LibroEscritura">Libro: </label> 
								</td> 
								<td> 
									<form:input id="libroEscritura" name="libroEscritura" path="libroEscritura" size="15" tabindex="60" maxlength="50" onBlur=" ponerMayusculas(this)" /> 
								</td> 
								<td class="separador"></td> 
								<td class="label"> 
									<label for="volumenEsc">Volumen: </label> 
								</td> 
								<td> 
									<form:input id="volumenEsc" name="volumenEsc" path="volumenEsc" size="15" tabindex="61" maxlength="10" onBlur=" ponerMayusculas(this)"/> 
								</td> 
							</tr> 
							<tr> 
								<td class="label"> 
									<label for="FechaEsc">Fecha: </label> 
								</td> 
								<td> 
									<form:input id="fechaEsc" name="fechaEsc" path="fechaEsc" size="15" tabindex="62" esCalendario="true"/> 
								</td> 
								<td class="separador"></td> 
								<td class="label" nowrap="nowrap"> 
									<label for="estado">Entidad Federativa: </label> 
								</td> 
								<td> 
									<form:input id="estadoIDEsc" name="estadoIDEsc" path="estadoIDEsc" size="7" tabindex="63" /> 
									<input type="text" id="nombreEstadoEsc" name="nombreEstadoEsc" size="35"  disabled="true" readOnly="true"/>   
								</td>  
							</tr> 
							<tr>
								<td class="label"> 
									<label for="municipioEsc">Municipio: </label> 
								</td> 
								<td> 
									<form:input id="municipioEsc" name="municipioEsc" path="municipioEsc" size="6" tabindex="64" /> 
									<input type="text" id="nombreMuniEsc" name="nombreMuniEsc" size="35"  disabled="true" readOnly="true"/>   
								</td>  
								<td class="separador"></td> 
								<td class="label"> 
									<label for="Notaria">Notar&iacute;a: </label> 
								</td> 
								<td> 
									<form:input id="notaria" name="notaria" path="notaria" size="7" tabindex="65" /> 
								</td> 
							</tr> 
							<tr> 
								<td class="label" nowrap="nowrap"> 
									<label for="DirecNotaria">Direcci&oacute;n de Notar&iacute;a: </label> 
								</td> 
								<td> 
									<form:input id="direcNotaria" name="direcNotaria" path="direcNotaria" size="90" readOnly="true" disabled="true" /> 
								</td> 
								<td class="separador"></td>
								<td class="label" nowrap="nowrap" 	> 
									<label for="NomNotario">Nombre del Notario: </label> 
								</td> 
								<td> 
									<form:input id="nomNotario" name="nomNotario" path="nomNotario" size="45" readOnly="true" disabled="true" /> 
								</td> 
							</tr>  
						 </table>
					</fieldset>
					<div id= "apoderados" style="display: none;"> 
						<br>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">		
							<legend>Información Apoderados</legend>	
							<table border="0" width="100%"> 		
								<tr> 
									<td class="label"> 
										<label for="nomApoderado">Nombre del Apoderado: </label> 
									</td> 
									<td> 
										<form:input id="nomApoderado" name="nomApoderado" path="nomApoderado" size="55" maxlength="150" tabindex="66" onBlur=" ponerMayusculas(this)" /> 
									</td> 
									<td class="separador"></td> 
									<td class="label"> 
										<label for="RFCApoderado">RFC del Apoderado: </label> 
									</td> 
									<td> 
										<form:input id="RFC_Apoderado" name="RFC_Apoderado" path="RFC_Apoderado" size="15" tabindex="67" maxlength="13" onBlur=" ponerMayusculas(this)"/> 
									</td> 
								</tr>  
							</table>
						</fieldset>
						<br>
					</div>
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Registro P&uacute;blico</legend>	
						<table border="0" width="100%"> 		
							<tr> 
								<td class="label"> 
									<label for="RegistroPub">Registro P&uacute;blico: </label> 
								</td> 
								<td> 
									<form:input id="registroPub" name="registroPub" path="registroPub" size="15" tabindex="68" onBlur=" ponerMayusculas(this)" maxlength="10"/> 
								</td> 
								<td class="separador"></td> 
								<td class="label"> 
									<label for="FolioRegPub">Folio: </label> 
									</td> 
									<td> 
										<form:input id="folioRegPub" name="folioRegPub" path="folioRegPub" size="15" tabindex="69" maxlength="10" onBlur=" ponerMayusculas(this)"/> 
								</td> 
							</tr>  
							<tr> 
								<td class="label"> 
									<label for="VolumenRegPub">Volumen: </label> 
								</td> 
								<td> 
									<form:input id="volumenRegPub" name="volumenRegPub" path="volumenRegPub" size="15" tabindex="70" maxlength="10" onBlur=" ponerMayusculas(this)"/> 
								</td> 
								<td class="separador"></td>
								<td class="label"> 
									<label for="LibroRegPub">Libro: </label> 
								</td> 
								<td>  
									<form:input id="libroRegPub" name="libroRegPub" path="libroRegPub" size="15" tabindex="71" maxlength="10" onBlur=" ponerMayusculas(this)"/> 
								</td> 
							</tr> 
							<tr> 
								<td class="label"> 
									<label for="AuxiliarRegPub">Auxiliar: </label> 
								</td> 
								<td>  
								<form:input id="auxiliarRegPub" name="auxiliarRegPub" path="auxiliarRegPub" size="15" tabindex="72" maxlength="20" onBlur=" ponerMayusculas(this)" /> 
								</td>
								<td class="separador"></td> 
								<td class="label"> 
									<label for="FechaRegPub">Fecha: </label> 
								</td>  
								<td> 
									<form:input id="fechaRegPub" name="fechaRegPub" path="fechaRegPub" size="15" tabindex="73" esCalendario="true"/> 
								</td>      
							</tr> 
							<tr>
								<td class="label"> 
									<label for="LocalidadEsc">Entidad Federativa: </label> 
								</td> 
								<td> 
									<form:input id="estadoIDReg" name="estadoIDReg" path="estadoIDReg" size="7" tabindex="74" /> 
									<input type="text" id="nombreEstadoReg" name="nombreEstadoReg" size="35" disabled="true" readOnly="true"/>   
								</td>  	
								<td class="separador"></td>	
								<td class="label"> 
									<label for="municipioRegPub">Municipio: </label> 
								</td> 
								<td>
									<form:input id="municipioRegPub" name="municipioRegPub" path="municipioRegPub" size="7" tabindex="75" /> 
									<input type="text" id="nombreMuniReg" name="nombreMuniReg" size="40" disabled="true" readOnly="true"/>   
								 </td>  
							</tr> 
						</table>
	  
					</fieldset>
				</div>						


			</fieldset>
			<table width="100%">
				<tr>
					<td align="right">
						<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="99" />
						<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar"
							tabindex="100" />
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
						<input type="hidden" id="numeroCaracteres" name="numeroCaracteres"/>
						<input type="hidden" id="Observacion" name="Observacion"/>	
					</td>
				</tr>
			</table>
		</form:form>
	</div>

	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;overflow:">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>

</html>

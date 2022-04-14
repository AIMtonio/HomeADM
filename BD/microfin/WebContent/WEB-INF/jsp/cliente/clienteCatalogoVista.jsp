<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	  <script type="text/javascript" src="dwr/interface/actividadesFRServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/actividadesFomurServicio.js"></script> 
      <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
      <script type="text/javascript" src="dwr/interface/actividadesServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/ocupacionesServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>                                                                                                                                                
      <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>  
      <script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>  
      <script type="text/javascript" src="dwr/interface/gruposEmpServicio.js"></script>                                                                                                                                                                                                                                                                                           
      <script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/sectoresServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/tipoSociedadServicio.js"></script>
 	  <script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>        	  
 	  <script type="text/javascript" src="dwr/interface/institucionNominaServicio.js"></script>  	  
 	  <script type="text/javascript" src="dwr/interface/negocioAfiliadoServicio.js"></script>  	   	   
 	  <script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script>
 	  <script type="text/javascript" src="dwr/interface/tiposPuestosServicio.js"></script> 
 	  <script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
 	  <script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
 	  <script type="text/javascript" src="dwr/interface/catUbicaNegocioServicio.js"></script>
 	  
 	  <script type="text/javascript" src="js/soporte/mascara.js"></script>
      <script type="text/javascript" src="js/cliente/clienteCatalogo.js"></script>
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cliente">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all"><s:message code="safilocale.cliente"/></legend>
	<table>
		<tr>
			<td class="label">
				<label for="numero">N&uacute;mero: </label>
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
					size="6"  tabindex="2"/>
				<input type="text" id="sucursalO" name="sucursalO" size="37" tabindex="3" disabled="true" readOnly="true" iniForma="false"/>
			</td>
		</tr>
		<tr>
			<td class="label" id="lblProspecto" style="display: none;">
				<label for="forProspecto">Prospecto: </label>
			</td>
		  	<td id="inputProspectoID" style="display: none;">
				<form:input id="prospectoID" name="prospectoID" path="prospectoID"  size="12"  tabindex="4" iniForma="false"/>
				<input type="text" id="nombreProspecto" name="nombreProspecto" size="45" tabindex="5"  disabled="true" readOnly="true" iniForma="false"/>
			</td>
			<td class="separador"></td>
			<td class="separador"></td>
			<td class="separador"></td>
		</tr>
	</table>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">	
		<legend >Datos Del <s:message code="safilocale.cliente"/> o Representante Legal</legend>
		<table border="0"  width="73%">
			<tr>
				<td class="label"> 
					<label for="tipoPersona">Tipo Persona: </label> 
				</td>
				<td class="label"> 
					<form:radiobutton id="tipoPersona1" name="tipoPersona1"  path="tipoPersona"
				 		value="F" tabindex="6" checked="checked" />
					<label for="fisica">F&iacute;sica</label>&nbsp;&nbsp;
					<form:radiobutton id="tipoPersona3" name="tipoPersona3"  path="tipoPersona"
						value="A" tabindex="7"/>
					<label for="fisica">F&iacute;sica Act Emp</label>
					<form:radiobutton id="tipoPersona2" name="tipoPersona2"   path="tipoPersona" 
						value="M" tabindex="8"/>
					<label for="fisica">Moral</label>
				</td>
				<td class="separador"></td>
				<td></td>
				<td></td>	
			</tr>
		</table>
		<table id="datosPersonaFisica" style="display:block;" border="0"  width="100%">			
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
					<form:input id="primerNombre" name="primerNombre" path="primerNombre" tabindex="10" 
					onBlur=" ponerMayusculas(this)" maxlength="20" />
				</td>		
				<td class="separador"></td>
				<td class="label">
					<label for="segundoNombre">Segundo Nombre: </label>
				</td>
				<td >
					<form:input id="segundoNombre" name="segundoNombre" path="segundoNombre" 
					 tabindex="11" onBlur=" ponerMayusculas(this)" maxlength="20"/>
				</td>
				<td class="separador"></td>
			</tr>
			<tr>
				<td class="label">
					<label for="tercerNombre">Tercer Nombre:</label>
				</td>
				<td>
					<form:input id="tercerNombre" name="tercerNombre" path="tercerNombre" tabindex="12" 
					onBlur=" ponerMayusculas(this)" maxlength="20"/>
				</td>				
				<td class="separador"></td>
				<td class="label">
					<label for="apellidoPaterno">Apellido Paterno:</label>
				</td>
				<td>
					<form:input id="apellidoPaterno" name="apellidoPaterno" path="apellidoPaterno" 
					tabindex="13" onBlur=" ponerMayusculas(this)" maxlength="30"/>
				</td>		
			</tr>
			<tr>
				<td class="label">
					<label for="apellidoMaterno">Apellido Materno:</label>
				</td>
				<td>
					<form:input id="apellidoMaterno" name="apellidoMaterno" path="apellidoMaterno" 
					tabindex="14" onBlur=" ponerMayusculas(this)" maxlength="30"/>
				</td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<label for="fechaNacimiento">Fecha de Nacimiento:</label>
				</td>
				<td nowrap="nowrap">
					<form:input id="fechaNacimiento" name="fechaNacimiento" path="fechaNacimiento" size="20" tabindex="15" esCalendario="true" maxlength="10"/>
				</td>		
			</tr>
			<tr>
				<td class="label">
					<label for="nacion">Nacionalidad:</label>
				</td>
				<td>
					<form:select id="nacion" name="nacion" path="nacion" tabindex="16">
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
					<form:input id="lugarNacimiento" name="lugarNacimiento" path="lugarNacimiento" 
					 	size="5" tabindex="17" maxlength="9"/>
					<input type="text" id="paisNac" name="paisNac" size="30" tabindex="18" disabled="true" readOnly="true"
						onBlur=" ponerMayusculas(this)"/>
				</td>
			</tr>
			<tr>				
				<td class="label" nowrap="nowrap">
					<label for="entidadFederativa">Entidad Federativa:</label>
				</td>
				<td nowrap="nowrap">
					<form:input id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="19" maxlength="3"/>
	         		<input type="text" id="nombreEstado" name="nombreEstado" size="35" tabindex="20" disabled="true" 
	          			readOnly="true" onBlur=" ponerMayusculas(this)"/>   
				</td>	
				<td class="separador"></td>
				<td class="label">
					<label for="paisResidencia">Pa&iacute;s de Residencia: </label>
				</td>
				<td>
					<form:input id="paisResidencia" name="paisResidencia" path="paisResidencia" 
						size="5" tabindex="21" maxlength="9"/>
					<input type="text" id="paisR" name="paisR" size="30" tabindex="22" disabled="true" readOnly="true"
						onBlur=" ponerMayusculas(this)"/>
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
					<label for="CURP">CURP:</label>
				</td>
				<td>
					<form:input id="CURP" name="CURP" path="CURP" tabindex="24" size="25" 
						onBlur=" ponerMayusculas(this)" maxlength="18"/>
					<input type ="button" id="generarc" name="generarc" value="Calcular" class="submit" style="display: none;"/>
				</td>		
			</tr>
			<tr>
				<td>
				</td>
				<td>
				</td>
				<td class="separador"/>
				<td class="label" nowrap="nowrap">
					<label for="paisNacionalidad">Pa&iacute;s de Nacionalidad: </label>
				</td>
				<td nowrap="nowrap">
					<form:input id="paisNacionalidad" name="paisNacionalidad" path="paisNacionalidad" 
						size="5" tabindex="24" maxlength="9"/>
					<input type="text" id="paisN" name="paisN" size="30" disabled="true" readOnly="true"
						onBlur=" ponerMayusculas(this)"/>
				</td>
			</tr>
			<tr>
				<td class="label" nowrap="nowrap"> 
					<label for="registroAltaHacienda">Registro de Alta en Hacienda: </label> 
				</td>
				<td class="label" nowrap="nowrap"> 
					<form:radiobutton id="registroHaciendaSi" name="registroHacienda" path="registroHacienda"
				 		value="S" tabindex="25" />
					<label for="si">Si</label>&nbsp;&nbsp;
					<form:radiobutton id="registroHaciendaNo" name="registroHacienda" path="registroHacienda"
						value="N" tabindex="26" checked="checked"/>
					<label for="no">No</label>
					
				</td>		
				<td class="separador"></td>
				<td class="label">
					<label for="RFCl"> RFC:</label>
				</td>
				<td>
					<form:input id="RFC" name="RFC" path="RFC" maxlength="13" tabindex="27"
				 		onBlur=" ponerMayusculas(this)"/>
					<input type ="button" id="generar" name="generar" value="Calcular" class="submit"  style="display: none;"/>
				</td>	
			</tr>			
			<tr id="registroFEA">				
				<td class="label"> 
					<label for="cuentaConFEA" id="cuentaConFEA" >Registro de FEA:&nbsp;</label> 
				</td>
				<td>
					<form:input id="fea" name="fea" path="fea" tabindex="28" size="30" maxlength="100" onblur=" ponerMayusculas(this)"/>
				</td>	
				<td class="separador"></td>
				<td class="label">
					<label for="paisFeal" id="paisFeal">Pa&iacute;s que Asigna FEA: </label>
				</td>
				<td>
					<form:input id="paisFea" name="paisFea" path="paisFea" 
						size="5" tabindex="29"  maxlength="9"/>
					<input type="text" id="paisF" name="paisF"  size="30" tabindex="30" disabled="true" readOnly="true"
						onBlur=" ponerMayusculas(this)"/>
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="fechaConstitucion">Fecha de Constituci&oacute;n RFC:&nbsp;</label> 
				</td>
				<td>
					<form:input id="fechaConstitucion" name="fechaConstitucion" path="fechaConstitucion" size="20" tabindex="31" esCalendario="true" maxlength="10"/>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="estadoCivil">Estado Civil:</label>
				</td>
				<td>
					<form:select id="estadoCivil" name="estadoCivil" path="estadoCivil"  tabindex="32">
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
					<form:input id="telefonoCelular" name="telefonoCelular" maxlength="15" size="15" path="telefonoCelular"
						 tabindex="33"/>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="telefonoCasa">Tel&eacute;fono Particular:</label>
				</td>
				<td>
					<form:input id="telefonoCasa" name="telefonoCasa" maxlength="15" path="telefonoCasa" size="15" 
					tabindex="34" />
					<label for="ext">Ext.:</label>
					<form:input path="extTelefonoPart" id="extTelefonoPart" name="extTelefonoPart" maxlength="6" tabindex="35" size="10"/>
				</td>	
			</tr>
			<tr>
				<td class="label">
					<label for="correo"> Correo Electr&oacute;nico:</label>
				</td>
				<td>
					<form:input id="correo" name="correo" path="correo" tabindex="36" size="30" maxlength="50"/>
				</td>
				<td class="separador"></td>	
				<td class="label">
						<label for="fax">N&uacute;mero Fax:</label>
				</td>
				<td>
					<form:input id="fax" name="fax" path="fax" tabindex="37" size="30" maxlength="30"/>
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="obser">Observaciones:</label>
				</td>
				<td>
					<textarea id="observaciones" name="observaciones" path="observaciones" cols="30" rows="4"  
							  onblur=" ponerMayusculas(this)" tabindex="38" maxlength = "500"></textarea>
				</td>		
				<input type="hidden" id="esMenorEdad" name="esMenorEdad" path="esMenorEdad" value="N" /> 
				<td class="separador"></td>
			</tr>
		</table>
	</fieldset>
	<br>
	<div id="personaMoral"  style="display:none">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend>Datos Generales de la Empresa</legend>
		<table border="0"  width="100%">
			<tr>
				<td class="label">
					<label for="razonSocial">Raz&oacute;n Social:</label>
				</td>
				<td>
					<form:input id="razonSocial" name="razonSocial" path="razonSocial" size="50"
				 	tabindex="39" onBlur=" ponerMayusculas(this)" maxlength="150"/>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="RFCpm">RFC:</label>
				</td>
				<td>
					<form:input id="RFCpm" name="RFCpm" path="RFCpm" tabindex="40" maxlength ="12" 
				 		onBlur=" ponerMayusculas(this)"/>
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
					<form:input id="paisConstitucionID" name="paisConstitucionID" path="paisConstitucionID" size="7" tabindex="42" maxlength="9"/>
					<input type="text" id="descPaisConst" name="descPaisConst" size="40" tabindex="43" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)"/>
				</td>
			</tr>
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="correoPM">Correo Electr&oacute;nico:</label>
				</td>
				<td nowrap="nowrap">
					<form:input id="correoPM" name="correoPM" path="correoPM" size="50" tabindex="44" maxlength="50"/>
				</td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<label for="correoAlterPM">Correo Alternativo:</label>
				</td>
				<td nowrap="nowrap">
					<form:input id="correoAlterPM" name="correoAlterPM" path="correoAlterPM" size="48" tabindex="45" maxlength="50"/>
				</td>
			</tr>						
			<tr>
			<td class="label">
				<label for="telefonoPM">Tel&eacute;fono:</label>
			</td>
			<td>
				<form:input id="telefonoPM" name="telefonoPM" maxlength="15" path="telefonoPM" size="15" tabindex="46" />
				<label for="ext">Ext.:</label>
				<form:input path="extTelefonoPM" id="extTelefonoPM" name="extTelefonoPM" maxlength="6" tabindex="47" size="10" />
			</td>
			
				<td class="separador"></td>
				<td class="label">
					<label for="sociedad">Tipo de Sociedad: </label>
				</td>
				<td>
					<form:input id="tipoSociedadID" name="tipoSociedadID" path="tipoSociedadID" size="7" tabindex="48" maxlength="5"/>
					<input type="text" id="descripSociedad" name="descripSociedad" size="40" tabindex="49" disabled="true" readOnly="true" onBlur="ponerMayusculas(this)"/>
				</td>
			</tr>
			<tr>					
				<td class="label">
					<label for="grupoEmpresarial">Grupo Empresarial:</label>
				</td>
				<td>
					<form:input id="grupoEmpresarial" name="grupoEmpresarial" path="grupoEmpresarial"
					size="6" tabindex="50" maxlength="9"/>
					<input type="text" id="descripcionGE" name="descripcionGE" size="30" disabled="true" 
					  readOnly="true" onBlur=" ponerMayusculas(this)"/>
				</td>	
				<td class="separador"></td>
				<td class="label">
					<label for="fechaRegistroPM">Fecha de Registro:</label>
				</td>
				<td>
					<form:input id="fechaRegistroPM" name="fechaRegistroPM" path="fechaRegistroPM" size="20" tabindex="51" esCalendario="true" maxlength="12"/>
				</td>	
			</tr>
			<tr>
				<td class="label">
					<label for="nombreNotario">Nombre Notario:</label>
				</td>
				<td>
					<form:input id="nombreNotario" name="nombreNotario" path="nombreNotario" size="52" tabindex="52" onBlur=" ponerMayusculas(this)" maxlength="150"
						autocomplete="off"/>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="numNotario">No. Notario:</label>
				</td>
				<td>
					<form:input id="numNotario" name="numNotario" path="numNotario" size="20" tabindex="53" maxlength="9" autocomplete="off"/>
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="inscripcionReg">Inscripci&oacute;n Reg.:</label>
				</td>
				<td>
					<form:input id="inscripcionReg" name="inscripcionReg" path="inscripcionReg" size="50" tabindex="54" onBlur=" ponerMayusculas(this)" maxlength="50"
						autocomplete="off"/>
				</td>		
				<td class="separador"></td>
				<td class="label">
					<label for="escrituraPubPM">Escritura P&uacute;blica:</label>
				</td>
				<td>
					<form:input type="text" id="escrituraPubPM" name="escrituraPubPM" path="escrituraPubPM" size="20" tabindex="55" maxlength="20" onBlur="ponerMayusculas(this)"	autocomplete="off"/>
				</td>				
			</tr>
			<tr>				
				<td class="label"> 
					<label for="cuentaConFEA" id="cuentaConFEA" >Registro de FEA:&nbsp;</label> 
				</td>
				<td>
					<form:input id="feaPM" name="feaPM" path="feaPM" tabindex="56" size="30" maxlength="100" onblur=" ponerMayusculas(this)"/>
				</td>	
				<td class="separador"></td>
				<td class="label">
					<label for="paisFealM" id="paisFealM">Pa&iacute;s que Asigna FEA: </label>
				</td>
				<td>
					<form:input id="paisFeaPM" name="paisFeaPM" path="paisFeaPM" 
						size="5" tabindex="57"  maxlength="9"/>
					<input type="text" id="paisFPM" name="paisFPM"  size="30" tabindex="58" disabled="true" readOnly="true"
						onBlur=" ponerMayusculas(this)"/>
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="observacionesPM">Observaciones:</label>
				</td>
				<td>
					<textarea id="observacionesPM" name="observacionesPM" path="observacionesPM" cols="30" rows="4"  
							  onblur=" ponerMayusculas(this)" tabindex="59" maxlength = "499"></textarea>
				</td>		
				<td class="separador"></td>
			</tr>
			
		</table>
	</fieldset>
	</div>
	<div id="personaFisica">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend>Persona F&iacute;sica</legend>
		<table border="0" width="100%">Datos Laborales
		</br>
			<tr>
				<td class="label">
					<label for="ocupacion">Ocupaci&oacute;n:</label>
				</td>
				<td>
					<form:input id="ocupacionID" name="ocupacionID" path="ocupacionID" size="5" tabindex="59" />
					<input type="text" id="ocupacionC" name="ocupacionC" size="35"  readOnly="true" onBlur=" ponerMayusculas(this)"/>
				</td>			
				<td class="separador"></td>
				<td class="label">
					<label for="puesto">Puesto:</label>
				</td>
				<td>
					<form:input id="puesto" name="puesto" path="puesto" tabindex="60" onBlur=" ponerMayusculas(this)" maxlength="100"/>
				</td>
			</tr>
			<tr id="fila1">				
			</tr> 
			<tr id="fila2">
			</tr> 
			<tr>
				<td class="label">
					<label for="domicilioTrabajo">Direcci&oacute;n:</label>
				</td>

				<td>
					<form:input id="domicilioTrabajo" name="domicilioTrabajo" path="domicilioTrabajo" size="45" tabindex="66" onBlur="ponerMayusculas(this)" maxlength="500"/>
				</td>

				<td class="separador"></td>

				<td class="label">
					<label for="telefonoTrabajo">Tel&eacute;fono:</label>
				</td>
				<td>
					<form:input id="telTrabajo" name="telTrabajo" maxlength="15" path="telTrabajo" size="15" tabindex="67"/>
					<label class="label">Ext.:</label>
					<form:input path="extTelefonoTrab" name="extTelefonoTrab" id="extTelefonoTrab" maxlength="6" size="10" tabindex="68"/>
				</td>
			</tr>
		</table>
		</fieldset>
	</div>
	
	</br>	
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend>Datos Adicionales</legend>
	</br>	
	<table border="0"  width="100%">
		<tr>
			<td class="label">
				<label for=" ">Clasificación:</label>
			</td>
			<td nowrap="nowrap" colspan="7">
				<form:select id="clasificacion" name="clasificacion" path="clasificacion" tabindex="69">
					<form:option value="">SELECCIONAR</form:option> 
					<form:option value="I"><s:message code="safilocale.clienteM"/> INDEPENDIENTE</form:option>
	   				<form:option value="E"><s:message code="safilocale.clienteM"/> EMPLEADO</form:option>
			  		<form:option value="C"><s:message code="safilocale.clienteM"/> CORPORATIVO</form:option>
			  		<form:option value="R"><s:message code="safilocale.clienteM"/> RELACIONADO A CORPORATIVO</form:option>
			  		<form:option value="N"> CORPORATIVO DE NOMINA</form:option>
			  		<form:option value="F"><s:message code="safilocale.clienteM"/> NEGOCIO AFILIADO</form:option>
					<form:option value="M">EMPLEADO DE NOMINA</form:option>
					<form:option value="O"><s:message code="safilocale.clienteM"/> FUNCIONARIO</form:option>
				</form:select>
					
			</td>
		</tr>
		<tr id="datosNomina" style="display: none;">
			
			<td class="label">	
			 	<label for="lblnoEmp">N&uacute;mero Empleado:</label></td>
			 	
			<td>
			 	<form:input id="noEmpleado" name="noEmpleado" path="noEmpleado"  maxlength = "20" tabindex="70" />
			 	
			</td>
			<td class="separador"></td>
			<td class="label">	
				<label for="lblnoEmp">Tipo Empleado:</label></td>
			<td nowrap="nowrap">
				<form:select id="tipoEmpleado" name="tipoEmpleado" path="tipoEmpleado" tabindex="71">
				<form:option value="">SELECCIONAR</form:option>
				<form:option value="T">TEMPORAL</form:option>
				<form:option value="C">CONFIANZA</form:option>
				<form:option value="S">SINDICALIZADO</form:option>
				<form:option value="E">BASE</form:option>
				<form:option value="B">BASE-SINDICALIZADO</form:option>
				<form:option value="P">PENSIONADO-JUBILADO</form:option>
				
				</form:select> 
				</td>
				<td class="separador"></td>
			<td class="label">	
				<label for="lblnoEmp">Tipo Puesto:</label></td>
			<td nowrap="nowrap">
				<select id="tipoPuestoID" name="tipoPuestoID" path="tipoPuestoID" tabindex="72" iniforma="false">
				<option value="0">SELECCIONAR</option>				
				</select>	
				</td>
						
			
		</tr>
		<tr>
			<td class="label">
				<div id = "cteCorpInst">
					<label for="institNom">Emp. N&oacute;mina:</label>
				</div>
			</td>
			<td colspan="7">
				<div id = "cteCorpNom">
						<form:input type="text" id="institNominaID" name="institNominaID" path="institNominaID" size="15" tabindex="73" maxlength = "9"/>
						<input type="text" id="nombreInstit" name="nombreInstit" size="120" readOnly="true" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="label">
				<div id = "negAfilia">
					<label for="negAfilia">Negocio Afiliado:</label>
				</div>
			</td>
			<td colspan="7">
				<div id = "negAfiliaNom">
						<form:input type="text" id="negocioAfiliadoID" name="negocioAfiliadoID" path="negocioAfiliadoID" size="15" tabindex="74" maxlength = "9"/>
						<input type="text" id="razonSocialNegAfi" name="razonSocialNegAfi" size="120" readOnly="true" />
				</div>
			</td>
		</tr>
		
		<tr>
			<td class="label">
				<div id = "campoCorpRellbl">
					<label for="clasificacion">Corporativo:</label>
				</div>
			</td>
			<td colspan="7">
				<div id = "campoCorpRel">
						<form:input type="text" id="corpRelacionado" name="corpRelacionado" path="corpRelacionado" size="15" tabindex="75" maxlength = "11"/>
						<input type="text" id="nomRelCorp" name="nomRelCorp" size="120" disabled />
				</div>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="motivoApertura">Motivo Apertura:</label>
			</td>
			<td  colspan="7">
				<form:select id="motivoApertura" name="motivoApertura" path="motivoApertura" tabindex="76">
					<form:option value="">SELECCIONAR</form:option> 
					<form:option value="1">CREDITO</form:option>
			     	<form:option value="2">RECOMENDADO</form:option>
				  	<form:option value="3">PUBLICIDAD / CAMPAÑA PROMOCION</form:option>
				  	<form:option value="4">NECESIDAD / PROVEEDOR</form:option>
				  	<form:option value="5">CERCANIA DE SUCURSAL</form:option>
				  	<form:option value="6">CUENTA DE CAPTACION</form:option>
				</form:select>
			</td>	
		</tr>
		<tr>
			<td class="label"> 
				<label for="secGeneral">Sector General:</label>
			</td>
			<td  colspan="7">
				<form:input id="sectorGeneral" name="sectorGeneral" path="sectorGeneral" size="15" tabindex="77" maxlength = "9"/>
				<input type="text" id="descripcionSG" name="descripcionSG" size="120" tabindex="78" disabled= "true" readOnly="true" />
			</td>	
		</tr>
		<tr>
			<td class="label">
				<label for="actividad">Actividad BMX:</label>
			</td>
			<td  colspan="7">
				<form:input id="actividadBancoMX" name="actividadBancoMX" path="actividadBancoMX" size="15" tabindex="79" maxlength = "15"/>
				 <input type="text" id="descripcionBMX" name="descripcionBMX" size="120" tabindex="80" disabled="true" readOnly="true" />	
			</td>
		</tr>
		<tr>
			<td class="label" nowrap="nowrap">
				<label for="actividadINEGI">Actividad INEGI:</label>
			</td>
			<td  colspan="7" nowrap="nowrap">
				<form:input id="actividadINEGI" name="actividadINEGI" path="actividadINEGI"
					 size="15" tabindex="81" readOnly="true" maxlength = "15"/>
				<input type="text" id="descripcionINEGI" name="descripcionINEGI" size="120" tabindex="82" disabled= "true"
				 readOnly="true" />
			</td>
		</tr>
		<tr>	
			<td class="label">
				<label for="actFR">Actividad FR:</label>
			</td>
			<td  colspan="7" nowrap="nowrap">
				<input type="hidden" id="descripcionActFR" name="descripcionActFR" size="15" tabindex="83" disabled= "true"	readOnly="true" onBlur=" ponerMayusculas(this)" />	
				<form:select id="descripcionActFR2" name="descripcionActFR2"  path="actividadFR" tabindex="84" readOnly="true"  style="width:704px"></form:select>   
			</td>	
		</tr> 
		<tr>
			<td class="label" nowrap="nowrap">
				<label for="actFR">Actividad FOMMUR:</label>
			</td>
			<td  colspan="7">
				<input type="hidden" id="desActFomur" name="desActFomur" size="15" tabindex="85" disabled= "true"	readOnly="true" onBlur=" ponerMayusculas(this)"/>
				<form:select id="desActFomur2" name="desActFomur2"  path="actividadFOMUR" tabindex="86" readOnly="true"  style="width:704px"></form:select>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="sector">Sector Econ&oacute;mico:</label>
			</td>
			<td  colspan="7">
				<form:input id="sectorEconomico" name="sectorEconomico" path="sectorEconomico" size="15" tabindex="87" readOnly="true" maxlength = "15"/>
				<input type="text" id="descripcionSE" name="descripcionSE" size="120" tabindex="88" disabled= "true"	readOnly="true" onBlur=" ponerMayusculas(this)" />		
			</td>
		</tr>
	</table>
	<table>
		<tr>
			<td class="label">
				<label for="pagaIVA">Paga IVA:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												&nbsp;&nbsp;&nbsp;&nbsp;</label>
			</td>
			<td>
				<form:select id="pagaIVA" name="pagaIVA" path="pagaIVA" tabindex="89" disabled="true" readOnly="true">		
					<form:option value="S">SI</form:option>
			  		<form:option value="N">NO</form:option>
				</form:select>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="pagaISR">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Paga ISR:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
			</td>
			<td>
				<form:select id="pagaISR" name="pagaISR" path="pagaISR" tabindex="90" disabled ="true" readOnly="true">
					<form:option value="S">SI</form:option>
			   		<form:option value="N">NO</form:option>
				</form:select>
			</td>	
		</tr>
	</table>
	</fieldset>
	 </br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend>Promoci&oacute;n</legend>	
	<table>
		<tr>
			<td class="label" nowrap="nowrap">
				<label for="promotorInicial">Promotor Inicial:</label>
			</td>
			<td nowrap="nowrap">
				<form:input id="promotorInicial" name="promotorInicial" path="promotorInicial" size="6" tabindex="91" maxlength = "9"/>
				<input type="text" id="nombrePromotorI" name="nombrePromotorI" size="55" tabindex="92" disabled= "true" readOnly="true" />
			</td>
			<td class="separador"></td>
			<td class="label" nowrap="nowrap">
				<label for="promotorActual">Promotor Actual:</label>
			</td>
			<td nowrap="nowrap">
				<form:input id="promotorActual" name="promotorActual" path="promotorActual" size="6" tabindex="93" maxlength = "9" />
				<input type="text" id="nombrePromotorA" name="nombrePromotorA" size="55" tabindex="94" disabled="true" readOnly="true"/>
			</td>		
		</tr> 
			<tr id="promotorcap" style="display:none">
				<td class="label">
					<label for="ejecutivoCap">Ejecutivo de Captación:</label>
				</td>
				<td>
					<input type="text"  id="ejecutivoCap" name="ejecutivoCap" size="6"  tabindex="95" maxlength = "9"/>
					<input type="text" id="nomEjecutivoCap" name="nomEjecutivoCap"  size="30" tabindex="96" disabled= "true" readOnly="true" />
				</td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<label for="promotorExtInv">Promotor Externo de Inversión:</label>	
				</td>
				<td>
					<input type="text"  id="promotorExtInv" name="promotorExtInv"  size="6"   tabindex="97" />
					<input type="text" id="nomPromotorExtInv" name="nomPromotorExtInv" size="30" tabindex="98" disabled="true" readOnly="true"/>
				</td>
				<input type="hidden" id="muestraEjec" name="muestraEjec" readonly="true" />
			</tr>
	</table>
	
	</fieldset>
	</fieldset>
	<table width="100%">
		<tr>
			<td align="right">
				<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar"  tabindex="99"/>
				<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar"  tabindex="100"/>
				<input type="hidden" id="nivelRiesgo" name="nivelRiesgo" value="B"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="empresa" name="empresa"/>
				<input type="hidden" id="ocupaTab" name="ocupaTab"/>
				<input type="hidden" id="pagaIDE" name="pagaIDE" value="S" />
			</td>
		</tr>
	</table>
	</form:form>
</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;overflow:">
	<div id="elementoLista"></div>
</div>
<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
	<div id="elementoListaCte"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>

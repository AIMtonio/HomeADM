<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	  <script type="text/javascript" src="dwr/interface/actividadesFRServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/actividadesFomurServicio.js"></script> 
      <script type="text/javascript" src="dwr/interface/socioMenorServicio.js"></script> 
      <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/actividadesServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/ocupacionesServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>                                                                                                                                                
      <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>  
      <script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>  
      <script type="text/javascript" src="dwr/interface/gruposEmpServicio.js"></script>                                                                                                                                                                                    <script type="text/javascript" src="dwr/interface/parentescosServicio.js"></script>                                                                                                        
      <script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/sectoresServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/tipoSociedadServicio.js"></script>
 	  <script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script> 
 	  <script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
 	  <script type="text/javascript" src="js/soporte/mascara.js"></script>       
      <script type="text/javascript" src="js/cliente/socioMenorCatalogo.js"></script>   
      
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="socioMenor">

<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all"><s:message code="safilocale.cliente"/> Menor</legend>
	<table border="0" width="100%">
		<tr>
			<td class="label">
				<label for="numero">Número: </label>
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
				<input type="text" id="nombreProspecto" name="nombreProspecto" size="45" tabindex="5" disabled="true" readOnly="true" iniForma="false"/>
			</td>
			<td class="separador"></td>
			<td class="separador"></td>
			<td class="separador"></td>
		</tr>
	</table>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend >Datos Del <s:message code="safilocale.cliente"/> Menor</legend>
		<table border="0" width="100%">
			<tr>
				<td class="label">
					<input type="hidden" id="tipoPersona" name="tipoPersona" path="tipoPersona" value="F" checked="checked" />
				</td>
				<td>
					<input type="hidden" id="titulo" name="titulo" path="titulo" tabindex="9" value="C">
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="primerNombre">Primer Nombre:</label>
				</td>
				<td>
					<form:input id="primerNombre" name="primerNombre" path="primerNombre" tabindex="10" maxlength="40"
					onBlur=" ponerMayusculas(this)"/>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="segundoNombre">Segundo Nombre: </label>
				</td>
				<td >
					<form:input id="segundoNombre" name="segundoNombre" path="segundoNombre" maxlength="40"
					 tabindex="11" onBlur=" ponerMayusculas(this)"/>
				</td>
				<td class="separador"></td>
			</tr>
			<tr>
				<td class="label">
					<label for="tercerNombre">Tercer Nombre:</label>
				</td>
				<td>
					<form:input id="tercerNombre" name="tercerNombre" path="tercerNombre" tabindex="12" maxlength="35"
					onBlur=" ponerMayusculas(this)"/>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="apellidoPaterno">Apellido Paterno:</label>
				</td>
				<td>
					<form:input id="apellidoPaterno" name="apellidoPaterno" path="apellidoPaterno" maxlength="40"
					tabindex="13" onBlur=" ponerMayusculas(this)"/>
				</td>		
			</tr>
			<tr>
				<td class="label">
					<label for="apellidoMaterno">Apellido Materno:</label>
				</td>
				<td>
					<form:input id="apellidoMaterno" name="apellidoMaterno" path="apellidoMaterno" maxlength="40"
					tabindex="14" onBlur=" ponerMayusculas(this)"/>
				</td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<label for="fechaNacimiento">Fecha de Nacimiento:</label>
				</td>
				<td>
					<form:input id="fechaNacimiento" name="fechaNacimiento" path="fechaNacimiento" size="20" tabindex="15" esCalendario="true" maxlength="50"/>
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
				<td nowrap="nowrap">
					<form:input id="lugarNacimiento" name="lugarNacimiento" path="lugarNacimiento" 
					 	size="5" tabindex="16"/>
					<input type="text" id="paisNac" name="paisNac" size="30" tabindex="17" disabled="true" readOnly="true"
						onBlur=" ponerMayusculas(this)"/>
				</td>
			</tr>
			<tr>				
				<td class="label"  nowrap="nowrap">
					<label for="entidadFederativa">Entidad Federativa:</label>
				</td>
				<td  nowrap="nowrap">
					<form:input id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="18"/>
	         		<input type="text" id="nombreEstado" name="nombreEstado" size="35" tabindex="19" disabled="true" 
	          			readOnly="true" onBlur=" ponerMayusculas(this)"/>   
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="paisResidencia">Pa&iacute;s de Residencia: </label>
				</td>
				<td>
					<form:input id="paisResidencia" name="paisResidencia" path="paisResidencia" size="5" tabindex="21" />
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
				<td nowrap>
					<form:input id="CURP" name="CURP" path="CURP" tabindex="24" size="25" 
						onBlur=" ponerMayusculas(this)" maxlength="18"/>
					<input type ="button" id="generarc" name="generarc" value="Calcular" class="submit"  style="display: none;"/>
				</td>		
			</tr>	
			<tr style="display:none">
					<form:input type="hidden" id="RFC" name="RFC" path="RFC" value="" iniForma="false"/>
					<form:input type="hidden" id="estadoCivil" name="estadoCivil" path="estadoCivil" value="S" iniForma="false"/>
					<form:input type="hidden" id="clasificacion" name="clasificacion" path="clasificacion" value="I" iniForma="false"/>
					<form:input type="hidden" id="motivoApertura" name="motivoApertura" path="motivoApertura" value="1" iniForma="false"/>
					<form:input type="hidden" id="pagaISR" name="pagaISR" path="pagaISR" value="N" iniForma="false"/>
					<form:input type="hidden" id="pagaIVA" name="pagaIVA" path="pagaIVA" value="N" iniForma="false"/>
					<form:input type="hidden" id="pagaIDE" name="pagaIDE" path="pagaIDE" value="S" iniForma="false"/>
					<form:input type="hidden" id="nivelRiesgo" name="nivelRiesgo" path="nivelRiesgo" value="B" iniForma="false"/>
					<form:input type="hidden" id="sectorGeneral" name="sectorGeneral" path="sectorGeneral" value="999" iniForma="false"/>
					<form:input type="hidden" id="actividadBancoMX" name="actividadBancoMX" path="actividadBancoMX" value="9999999999" iniForma="false"/>
					<form:input type="hidden" id="actividadINEGI" name="actividadINEGI" path="actividadINEGI" value="99999" iniForma="false"/>
					<form:input type="hidden" id="sectorEconomico" name="sectorEconomico" path="sectorEconomico" value="0" iniForma="false"/>
					<form:input type="hidden" id="actividadFR" name="actividadFR" path="actividadFR" value="999999999999" iniForma="false"/>
					<form:input type="hidden" id="actividadFOMUR" name="actividadFOMUR" path="actividadFOMUR" value="99999999" iniForma="false"/>
					<form:input type="hidden" id="esMenorEdad" name="esMenorEdad" path="esMenorEdad" value="S" iniForma="false"/>
					<form:input type="hidden" id="fax" name="fax" path="fax" value="" iniForma="false"/>
			</tr>
			<tr>
				<td class="label">
					<label for="telefonoCelular">Tel&eacute;fono Celular: </label>
				</td>
				<td>
					<form:input id="telefonoCelular" name="telefonoCelular" maxlength="10" size="15" path="telefonoCelular"
						 tabindex="27"/>						 
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="telefonoCasa">Tel&eacute;fono Particular:</label>
				</td>
				<td>
					<form:input id="telefonoCasa" name="telefonoCasa" maxlength="10" path="telefonoCasa" size="15" 
					tabindex="28" />
					<label for="lblExtTelCasa">Ext.:</label>
					<form:input path="extTelefonoPart" id="extTelefonoPart" name="extTelefonoPart" size="10" tabindex="28" maxlength="6"/>
				</td>	
			</tr>
			<tr>
				<td class="label">
					<label for="correo"> Correo Electr&oacute;nico:</label>
				</td>
				<td>
					<form:input id="correo" name="correo" path="correo" tabindex="29" size="30" maxlength="50"/>
				</td>		
			</tr>
		</table>
	</fieldset>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
			<legend>Datos del Subscriptor</legend>
			<table border="0" width="100%">
				<tr>
					<td class="label">
						<label>Es <s:message code="safilocale.cliente"/>:</label>
						<input type="radio" id="esSocioSi" name="esSocio" value="S" onclick="validaTutor(this.value)" tabindex="30"/><label>Si</label>
						<input type="radio" id="esSocioNO" name="esSocio" value="N" onclick="validaTutor(this.value);" tabindex="31"/><label>No</label>
					</td>
				</tr>
				<tr id="Socio" >
					<td class="label">
						<label><s:message code="safilocale.cliente"/>:</label>
	         			<form:input type="text" id="clienteID" name="clienteID" path="clienteTutorID" size="11" tabindex="32" />
				      	<input type="text" id="nombreCte" name="nombreCte" size="70" tabindex=""	readOnly="true" disabled="true" />
					</td>
				</tr>
				<tr id="Tutor" style="display:none">
					<td class="label">
						<label>Nombre del Tutor:</label>
				      <input type="text" id="nombreTutor" name="nombreTutor" path="nombreTutor" size="70" tabindex="33" onBlur="ponerMayusculas(this)" maxlength="150"/>
					</td>
				</tr>
				<tr id="ParentescoSocio"  >
					<td class="label">
						<label>Parentesco del Subscriptor con el Menor:</label>
	         			<form:input type="text" id="parentescoID" name="parentescoID" path="parentescoID" size="11" tabindex="34" />
				      	<input type="text" id="tipoParentesco" name="tipoParentesco" size="70" tabindex=""	readOnly="true" disabled="true" />
					</td>
				</tr>
			
			</table>
	</fieldset>
	<br>	
	<div id="personaMoral"  style="display:none">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
			<legend>Persona Moral</legend>
			<table border="0" width="100%">Datos Generales de la Empresa
				<tr>
					<td class="label">
						<label for="razonSocial">Razón Social:</label>
					</td>
					<td>
						<form:input id="razonSocial" name="razonSocial" path="razonSocial" size="50"
					 	tabindex="31" onBlur=" ponerMayusculas(this)"/>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="sociedad">Tipo de Sociedad: </label>
					</td>
					<td>
						<form:input id="tipoSociedadID" name="tipoSociedadID" path="tipoSociedadID" size="7"
						 tabindex="32" />
						<input type="text" id="descripSociedad" name="descripSociedad" size="40" tabindex="33" disabled="true" 
						  readOnly="true" onBlur="ponerMayusculas(this)"/>
					</td>	
				</tr>			
				<tr>
					<td class="label">
						<label for="RFCpm">RFC:</label>
					</td>
					<td>
						<form:input id="RFCpm" name="RFCpm" path="RFCpm" tabindex="34"
					 		onBlur=" ponerMayusculas(this)"/>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="grupoEmpresarial">Grupo Empresarial:</label>
					</td>
					<td>
						<form:input id="grupoEmpresarial" name="grupoEmpresarial" path="grupoEmpresarial"
						size="6" tabindex="35"/>
						<input type="text" id="descripcionGE" name="descripcionGE" size="30" tabindex="36" disabled="true" 
						  readOnly="true" onBlur=" ponerMayusculas(this)"/>
					</td>	
				</tr>
			</table>
		</fieldset>
	</div>
	<div id="personaFisica" style="display:none">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend>Persona F&iacute;sica</legend>
		<table border="0" width="650px">Datos Laborales
		</br>
			<tr>
				<td class="label">
					<label for="ocupacion">Ocupaci&oacute;n:</label>
				</td>
				<td>
					<form:input id="ocupacionID" name="ocupacionID" path="ocupacionID" size="5" tabindex="37" value="42"/>
					<input type="text" id="ocupacionC" name="ocupacionC" size="35" tabindex="38" disabled="true" readOnly="true"
					onBlur=" ponerMayusculas(this)"/>
				</td>			
			</tr>
		</table>
		</fieldset>
	</div>
	
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend>Promoci&oacute;n</legend>	
	<table>
		<tr>
			<td class="label" nowrap="nowrap">
				<label for="promotorInicial">Promotor Inicial:</label>
			</td>
			<td nowrap="nowrap">
				<form:input id="promotorInicial" name="promotorInicial" path="promotorInicial" size="6" tabindex="58"/>
				<input type="text" id="nombrePromotorI" name="nombrePromotorI" size="30" tabindex="59" disabled= "true" readOnly="true" />
			</td>
			<td class="separador"></td>
			<td class="label" nowrap="nowrap">
				<label for="promotorActual">Promotor Actual:</label>
			</td>
			
			<td nowrap="nowrap">
				<form:input id="promotorActual" name="promotorActual" path="promotorActual" size="6" tabindex="60" />
				<input type="text" id="nombrePromotorA" name="nombrePromotorA" size="30" tabindex="61" disabled="true" readOnly="true"/>
			</td>
			</tr>
			
			<tr id="promotorcap" style="display:none">
				<td class="label">
					<label for="ejecutivoCap">Ejecutivo de Captación:</label>
				</td>
				<td>
					<input type="text"  id="ejecutivoCap" name="ejecutivoCap" size="6"  tabindex="62"/>
					<input type="text" id="nomEjecutivoCap" name="nomEjecutivoCap" size="30" tabindex="63" disabled= "true" readOnly="true" />
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="promotorExtInv">Promotor Externo de Inversión:</label>	
				</td>
				<td>
					<input type="text"  id="promotorExtInv" name="promotorExtInv" size="6"   tabindex="64" />
					<input type="text" id="nomPromotorExtInv" name="nomPromotorExtInv" size="30" tabindex="65" disabled="true" readOnly="true"/>
				</td>
				
			</tr>		
		
	</table>
	</fieldset>
	<table width="100%">
		<tr>
			<td align="right">
				<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar"  tabindex="66"/>
				<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar"  tabindex="67"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
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

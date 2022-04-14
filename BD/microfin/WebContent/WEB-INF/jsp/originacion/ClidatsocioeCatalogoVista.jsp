<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
    	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
     	<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/lineaNegocioServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clidatsocioeServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/datSocDemogServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/gruposEmpServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/ocupacionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/socDemoViviendaServicio.js"></script>	
		<script type="text/javascript" src="dwr/interface/tiposIdentiServicio.js"></script>	
		<script type="text/javascript" src="dwr/interface/socDemoConyugServicio.js"></script>	
		<script type="text/javascript" src="dwr/interface/socDemoViviendaServicio.js"></script>	
		<script type="text/javascript" src="dwr/interface/parentescosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/coloniaRepubServicio.js"></script>	
		<script type="text/javascript" src="dwr/interface/identifiClienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
		
		<script type="text/javascript" src="js/soporte/mascara.js"></script>
		<script type="text/javascript" src="js/originacion/clidatsocioe.js"></script> 
        <script type="text/javascript" src="js/originacion/socDemograficos.js"></script>
 		<script type="text/javascript" src="js/originacion/datSosConyugue.js"></script> 
 		<script type="text/javascript" src="js/originacion/datSocVivienda.js"></script>
 		    
 	</head>
   	<script type="text/javascript">
		$(document).ready(function() {
			 $('form').keypress(function(e){   
		    if(e == 13){
		      return false;
		    }
		  });
		
		  $('input').keypress(function(e){
		    if(e.which == 13){
		      return false;
		    }
		  });
		
		});
	</script>
<body>
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="clidatsocioeBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Alta de Datos Socioeconómicos</legend>
		<table border="0" width="100%">
			<tr>
				<td>
					<label for="lblClienteID">Línea Negocio: </label> 
		     	</td> 
		     	<td> 
		        	<form:select  type= "text" id="linNegID" name="linNegID" path="linNegID" tabindex="1"  >
						<form:option value="-1">SELECCIONAR</form:option>
					</form:select> 
		     	</td> 
			</tr>
			<tr>
				<td>
					<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label> 
	     		</td> 
	     		<td> 
	         		<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="2" />
	         		<input id="nombreCte" name="nombreCte"size="50" type="text" tabindex="3" readOnly="true" disabled = "true" />
	     		</td> 
			  	<td class="separador"></td> 
			   	<td class="label"> 
	         		<label for="lblfecRegistro">Fecha de Registro: </label> 
	     		</td> 
	     		<td> 
	         		 <form:input type="text" id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="15" tabindex="4"  disabled = "true"/>  
	     		</td>
			</tr>
			<tr > 
	     		<td class="label"> 
	         		<label for="lblProspecto">Prospecto: </label> 
	     		</td> 
	     		<td> 
	         		<form:input type="text" id="prospectoID" name="prospectoID" path="prospectoID" size="12" tabindex="5" />
	         		<input type="text" id="nombreProspecto" name="nombreProspecto"size="50"
	         			readOnly="true" disabled = "true" />
	     		</td> 	
				<td class="separador"></td>
				<td>
				 	<label id="labelMontoExecente" for="lblExedente" ><h3>Monto Solicitado:</h3>  </label> 
     			</td>  
     			<td  id="tdMotoExecente"> 
     		 		<h3 > 
     					<input type="text" id="montSoliciDeGrupal"  style="text-align:right;" name="montSoliciDeGrupal" size="15" disabled = "true" esMoneda="true" /> 
     				</h3>  
     			</td> 
	     	</tr>
	 		<tr id="trExedente"> 
	     		<td class="label"> 
	         	</td> 
	     		<td> 
	         	</td> 	
				<td class="separador"></td>
				<td class="label"> 
	         		<label for="lblExedente"><h3>Excedente:</h3>  </label> 
	     		</td> 
	     		<td> 
	     			<h3>
	         			<input type= "text" id="excedente"  style="text-align:right;" name="excedente" size="15"  disabled = "true" esMoneda="true" />
	         		</h3>
	     		</td> 
	 		</tr>
	 	</table>
		<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend >Información General del <s:message code="safilocale.cliente"/> o Prospecto</legend>
			<table border="0" width="100%">
		 		<tr>
		 			<td>
		 				<label for="primerNombre">Primer Nombre:</label>
					</td>
					<td>
						<input type="text" id="primerNombre" name="primerNombre"
							onBlur=" ponerMayusculas(this)" readOnly="true" disabled = "true" />
					</td>	
					<td class="separador"></td> 	
					<td class="label">
						<label for="segundoNombre">Segundo Nombre: </label>
					</td>
					<td >
						<input type="text" id="segundoNombre" name="segundoNombre"
						   onBlur=" ponerMayusculas(this)" readOnly="true" disabled = "true" />
					</td>
				</tr>
				<tr>  
		     		<td class="label">
						<label for="tercerNombre">Tercer Nombre:</label>
					</td>
					<td>
						<input type="text" id="tercerNombre" name="tercerNombre"  
						onBlur=" ponerMayusculas(this)" readOnly="true" disabled = "true" />
					</td>	
		     		<td class="separador"></td> 
		     		<td class="label">
						<label for="apellidoPaterno">Apellido Paterno:</label>
					</td>
					<td>
						<input type="text" id="apellidoPaterno" name="apellidoPaterno" 
						  onBlur=" ponerMayusculas(this)" readOnly="true" disabled = "true" />
					</td>	
		 		</tr>
		 		<tr> 
		     		<td class="label">
						<label for="apellidoMaterno">Apellido Materno:</label>
					</td>
					<td >
						<input type="text" id="apellidoMaterno" name="apellidoMaterno" 
						  onBlur=" ponerMayusculas(this)" readOnly="true" disabled = "true" />
					</td>
		     		<td class="separador"></td> 
					<td class="label">
						<label for="fechaNacimiento"> Fecha de Nacimiento:</label>
					</td>
					<td>
						<input type="text" id="fechaNacimiento" name="fechaNacimiento" size="20"  disabled = "true" />
					</td>				     		
		 		</tr>  
		 		<tr> 
		 			<td class="label"> 
						<label for="tipoPersona">Tipo Persona: </label> 
					</td>
					<td class="label"> 
						<select id="tipoPersona" name="tipoPersona"   disabled="true" >
							<option value="-1">SELECCIONAR</option>
							<option value="F">FÍSICA</option>
							<option value="A">FÍSICA ACT. EMP.</option>
							<option value="M">MORAL</option>
						</select> 
					</td>		
		     		<td class="separador"></td>  
		     		<td class="label">
						<label for="RFClbl"> RFC:</label>
					</td>
					<td>
						<input type="text" id="RFC" name="RFC"    onBlur=" ponerMayusculas(this)" readOnly="true" disabled = "true"/>
					</td>	
		 		</tr>
				<tr> 
		 			<td class="label"> 
						<label for="edocivil">Estado Civil: </label> 
					</td>
					<td class="label"> 
						<select id="estadoCivil" name="estadoCivil" path="estadoCivil" disabled="true"  >
							<option value="-1">SELECCIONAR</option>
							<option value="S">SOLTERO</option>
					     	<option value="CS">CASADO BIENES SEPARADOS</option>
					     	<option value="CM">CASADO BIENES MANCOMUNADOS</option>
					     	<option value="CC">CASADO BIENES MANCOMUNADOS CON CAPITULACION</option>
					     	<option value="V">VIUDO</option>
					     	<option value="D">DIVORCIADO</option>
					     	<option value="SE">SEPARADO</option>
					     	<option value="U">UNION LIBRE</option>
						</select>
					</td>		
		     		<td class="separador"></td>  
		     		<td class="label" id="etOcupacion">
						<label for="ocupacion">Ocupaci&oacute;n:</label>
					</td>
					<td id="CampoOcupacion">
						<input id="ocupacionCID" name="ocupacionCID"  size="5"  disabled="true" readOnly="true" />
						<input type="text" id="ocupacionC" name="ocupacionC" size="35" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)"/>
					</td>			
					<td>
					</td>	
		 		</tr>		 		
		 	</table> 
		</fieldset>
		<table border="0" width="100%"> 
			<tr> 
				<td>
					<div id="gridDatosSocioeco" style="display: none;"></div>
		 			<input type="hidden" id="detalleSocioeconomicos" name="detalleSocioeconomicos" size="100" />
				</td>	
		 	</tr>	
			<tr>
				<td colspan="5" align="right">
					<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar"  tabindex="8"   />
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>	
				</td>
			</tr>	
		</table>  
	</fieldset>
</form:form>

<br>
 
<form:form id="formaGenerica2" name="formaGenerica2" method="POST" action="/microfin/altaDatosSocioDemograficos.htm" commandName="datSocDemogBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all"  >                
	<legend class="ui-widget ui-widget-header ui-corner-all"  >Socio Demogr&aacute;ficos  </legend>
		<div id="tablaSocioDemo">
			<table  border="0" width="100%">
				<tr>
					<td class="label" id="lblFechaIniTrabajo" style="display:none;">
						<label for="lblantiguedad">Fecha Inicio Trabajo Actual:</label>
					</td>
					<td id="tdFechaIniTrabajo" style="display:none;">
						<input type="text"  id="fechaIniTra" name="fechaIniTra" path="fechaIniTra"  tabindex="9" size="12" esCalendario="true" 
						onchange="calculaAntiguedadLaboral(this); this.focus();" onblur="calculaAntiguedadLaboral(this);"/>
					</td>
					<td class="separador" id="separador" style="display:none;"></td>     
					<td class="label">
						<label for="lblantiguedad">Antiguedad Laboral:</label>
					</td>
					<td>
						<input type="text"  id="antiguedadLab" name="antiguedadLab" path="antiguedadLab" maxlength="5"  tabindex="9" size="3"  />
						<font size="2"></font><label for="lblmes">&nbsp;Mes(es)</label> </font>
					</td>					
				</tr>
				<tr>
					<td class="label">
						<label for="RFClbl">No. Dependientes Económicos:</label>
					</td>
					<td>
						<input id="numDepenEconomi" name="numDepenEconomi" path="numDepenEconomi"  value="0" size="5" disabled="true"   />
						<input type="hidden" id="cliID" name="cliID" path="cliID" size="12"  />
						<input type="hidden"  id="ProspID" name="ProspID" path="ProspID" size="12"  />
						<input type="button" name="agreNumDepEc" id="agreNumDepEc" class="btnAgrega" tabindex="10" />
					</td>	
						<td class="separador"></td>  
					<td class="label">
						<label for="RFClbl">Grado Escolaridad:</label>
					</td>
					<td>
						<select id="gradoEscolarID" name="gradoEscolarID" path="gradoEscolarID"   tabindex="11"  >
						</select> 
					</td>	
				</tr>
			</table>
			<br>
			<div id="gridDependientes">
				<table id="miTablaSD" border="0" width="100%">
					<tr>
						<td class="label">	<label for="RFClbl">Tipo Relación:</label></td>
						<td class="label"><label for="RFClbl">Primer Nombre:</label></td>
						<td class="label"><label for="RFClbl">Segundo Nombre:</label>	</td>
						<td class="label"><label for="RFClbl">Tercer Nombre:</label>	</td>
						<td class="label"><label for="RFClbl">Apellido Paterno:</label></td>
						<td class="label"><label for="RFClbl">Apellido Materno:</label></td>
						<td class="label"><label for="RFClbl">Edad:</label></td>
						<td class="label"><label for="RFClbl">Ocupación:</label></td>
					</tr>	
				</table>
			</div>
			<input type="hidden" id="numeroDetalle" name="numeroDetalle" value="0" />
			<table border="0"  width="100%">
				<tr><!-- Boton sumbit graba transaccion -->
					<td colspan="5" align="right">
						<input type="submit" id="grabarDSE" name="grabarDSE" class="submit" value="Grabar"  tabindex="13" />
						<input type="hidden" id="tipoTransaccionDSE" name="tipoTransaccionDSE"/>	
					</td>
				</tr>	
			</table>
		</div>
	</fieldset>
</form:form>	


<br>
</br>

<form:form id="formaGenerica3" name="formaGenerica3" method="POST" action="/microfin/datosSocioDemConyugue.htm" commandName="socDemConyugBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Datos de Cónyuge</legend>
		<table border="0" width="100%">
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="RFClbl">Buscar por <s:message code="safilocale.cliente"/>:</label>
				</td>
				<td>
					<input id="buscClienteID" name="buscClienteID" path="buscClienteID" tabindex="14" />
					<input type="hidden" id="forma3ClienteID" name="forma3ClienteID" path="forma3ClienteID"  />
					<input type="hidden"  id="forma3ProspectoID" name="forma3ProspectoID" path="forma3ProspectoID"/>					
				</td>	
				<td class="separador"></td>  
				<td class="label" nowrap="nowrap">
					<label for="RFClbl">Ocupación:</label>
				</td>
				<td>
					<input id="ocupacionID" name="ocupacionID" path="ocupacionID" size="6"  tabindex="32" maxlength="11"/>
 					<input id="nombreOcupacion" name="nombreOcupacion" path="nombreOcupacion" readOnly="true" size="46" />
				</td>	
			</tr>
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="RFClbl">Primer Nombre:</label>
				</td>
				<td>
					<input id="pNombre" name="pNombre" path="pNombre" tabindex="15" onBlur=" ponerMayusculas(this)" size="50" maxlength="25"/>
				</td>	
				<td class="separador" ></td>  
				<td class="label" nowrap="nowrap">
					<label for="RFClbl">Nombre Empresa <br> donde Labora:</label>
				</td>
				<td>
					 <input id="empresaLabora" name="empresaLabora" path="empresaLabora" size="53"  tabindex="33" onBlur=" ponerMayusculas(this)" />
				</td>	
			</tr>
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="RFClbl">Segundo Nombre:</label>
				</td>
				<td>
					<input id="sNombre" name="sNombre" path="sNombre" tabindex="16" onBlur=" ponerMayusculas(this)" size="50" maxlength="25"/>
				</td>	
				<td class="separador"></td>  
				<td class="label" nowrap="nowrap">
					<label for="RFClbl">Entidad<br>Federativa:</label>
				</td>
				<td>
 					<input id="entFedID" name="entFedID" path="entFedID" size="6" tabindex="34" maxlength="11"/>
					<input id="entidadFedNombre" name="entidadFedNombre" path="entidadFedNombre" size="46" readOnly="true"    />
 				</td>	
			</tr>
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="RFClbl">Tercer Nombre:</label>
				</td>
				<td>
					<input id="tNombre" name="tNombre" path="tNombre" tabindex="17"  onBlur=" ponerMayusculas(this)" size="50"/>
				</td>	
				<td class="separador"></td>  
				<td class="label" nowrap="nowrap">
					<label for="RFClbl">Municipio:</label>
				</td>
				<td>
					<input id="municipioID" name="municipioID" path="municipioID" size="6"  tabindex="35" maxlength="11"/>
 					<input id="nombMunicipio" name="nombMunicipio" path="nombMunicipio" size="46" readOnly="true" />
 				</td>	
			</tr>
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="RFClbl">Apellido Paterno:</label>
				</td>
				<td>
					<input id="aPaterno" name="aPaterno" path="aPaterno" tabindex="18" onBlur=" ponerMayusculas(this)" size="50" maxlength="30"/>
				</td>	
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<label for="lblLocalidad">Localidad:</label>
				</td>
				<td>
					<input id="localidadID" name="localidadID" path="localidadID" size="6" tabindex="36" maxlength="11"/> 
	     			<input type="text" id="nombrelocalidad" name="nombrelocalidad" size="46"  readOnly="true"  onBlur=" ponerMayusculas(this)" readOnly="true"/>   
 				</td>  
			</tr>
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="RFClbl">Apellido Materno:</label>
				</td>
				<td>
					<input id="aMaterno" name="aMaterno" path="aMaterno" tabindex="19" onBlur=" ponerMayusculas(this)" size="50" maxlength="30"/>
				</td>	
				<td class="separador"></td>  
				<td class="label" nowrap="nowrap">
					<label for="RFClbl">Colonia:</label>
				</td>
				<td>
					<input id="coloniaID" name="coloniaID" path="coloniaID" size="6" tabindex="37" maxlength="11"/>
	    			<input type="text" id="nombreColonia" name="nombreColonia" path="colonia" size="46" readOnly="true"    onBlur=" ponerMayusculas(this)" readOnly="true"/>   
 				</td>	
			</tr>
			<tr>
				<td class="separador"></td>  
				<td class="separador"></td>
				<td></td>
				<td class="label" nowrap="nowrap">
					<label for="RFClbl">Calle:</label>
				</td>
				<td>
					<input id="calle" name="calle" path="calle" size="53" onBlur=" ponerMayusculas(this)" tabindex="38" maxlength="100"/>
 				</td>		
			</tr>
			<tr>
				<td class="label"></td>
				<td></td>	
				<td class="separador"></td>  
				<td class="label" nowrap="nowrap"></td>	
				<td>
					<label for="RFClbl">Número:</label>
	 				<input id="numero" name="numero" path="numero" size="5" tabindex="39" maxlength="5"/>
					<label for="RFClbl">Interior:</label>
	 				<input id="interior" name="interior" path="interior" size="5" tabindex="40" onBlur=" ponerMayusculas(this)" maxlength="5"/>
 					<label for="RFClbl">Piso:</label>
	 				<input id="piso" name="piso" path="piso" size="5"  tabindex="41" maxlength="5"/>
 				</td>	
			</tr>			
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="RFClbl">Nacionalidad:</label>
				</td>
				<td>
					<select id="nacionaID" name="nacionaID" path="nacionaID" tabindex="20">
						<option value="N">MEXICANA </option>
						<option value="E">EXTRANJERA</option>
					</select>
				</td>	
				<td class="separador"></td>  
				<td class="label"></td>
				<td></td>	
			</tr>
			<tr id="fila1"></tr>
	 		<tr id="fila2"></tr>
			<tr id="fila3"></tr>
			<tr id="fila4"></tr>
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="RFClbl">Tipo Identificación:</label>
				</td>
				<td>
					<select id="tipoIdentiID" name="tipoIdentiID" path="tipoIdentiID" tabindex="26">							
					</select> 
				</td>					
				<td class="separador"></td>  
				<td class="label"></td>
				<td></td>		
			</tr>
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="RFClblFolio">Folio Identificación:</label>
				</td>
				<td>
					 <input type="text" id="folioIdentificacion" name="folioIdentificacion" path="folioIdentificacion" tabindex="27" onBlur=" ponerMayusculas(this)"/>
				</td>					
				<td class="separador"></td>  
				<td class="label"></td>
				<td></td>		
			</tr>
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="RFClbl">Fecha Expedicion:</label>
				</td>
				<td>
					<input id="fechaExpedicion" name="fechaExpedicion" path="fechaExpedicion" esCalendario="true" size="20"   tabindex="28"  />
				</td>					
				<td class="separador"></td>  
				<td class="label"></td>
				<td>	</td>	
			</tr>
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="RFClbl">Fecha Vencimiento:</label>
				</td>
				<td>
					<input id="fechaVencimiento" name="fechaVencimiento" path="fechaVencimiento" esCalendario="true" size="20"   tabindex="29"  />
				</td>					
				<td class="separador"></td>  
				<td class="label"></td>
				<td>	</td>	
			</tr>
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="RFClbl">Tel. Celular:</label>
				</td>
				<td>
					<input id="telCelular" name="telCelular" maxlength="15" path="telCelular"  size="17"  maxlength="15" tabindex="30"  />
				</td>					
				<td class="separador"></td>  
				<td class="label"></td>
				<td>	</td>	
			</tr>
		</table>
		<br>
		
		<table border="0" width="100%">
			<tr><!-- Boton sumbit graba transaccion -->
				<td colspan="5" align="right">
					<input type="submit" id="grabarCony" name="grabarCony" class="submit" value="Grabar" tabindex="48"  />
					<input type="hidden" id="tipoTransaccionCony" name="tipoTransaccionCony"/>	
					<input type="hidden" id="numeroCaracteres" name="numeroCaracteres"/>
					
				</td>
			</tr>	
		</table>
	</fieldset>
</form:form>	


<br>

<form:form id="formaGenerica4" name="formaGenerica4" method="POST" action="/microfin/datosSocioDemVivienda.htm" commandName="socDemogViviendaBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Datos de Vivienda</legend>
		<table border="0" width="100%">
			<tr>
				<td class="label">
					<label for="RFClbl">Tipo Domicilio:</label>
				</td>
				<td>
					<select id="tipoViviendaID" name="tipoViviendaID" path="tipoViviendaID" tabindex="49"   >
					</select> 
					<input type="hidden" id="forma4ClienteID" name="forma4ClienteID"  />
					<input  type="hidden"  id="forma4ProspectoID" name="forma4ProspectoID"  />
				</td>	
				<td class="separador"></td>  
				<td class="label">
					<label for="RFClbl">Valor Vivienda:</label>
				</td>
				<td>
					<input id="valorVivienda" name="valorVivienda"  style="text-align:right;" path="valorVivienda" esMoneda="true" tabindex="50" />
 			 	</td>	
			</tr>
			<tr>
				<td class="label">
					<label for="RFClbl">Cuenta con Drenaje:</label>
				</td>
				<td>
					<label for="RFClbl">Si </label>
					<input type="radio" id="drenajeSi" checked="true" name="drenaje" path="drenaje" tabindex="51" />
					<label for="RFClbl">No </label>		
					<input type="radio" id="drenajeNo" name="drenaje" path="drenaje" tabindex="52"/>
					<input type="hidden" value="S" id="conDrenaje" name="conDrenaje" path="conDrenaje"/>
				</td>	
				<td class="separador"></td>  
				<td class="label">
					<label for="RFClbl">Material de <br>Vivienda:</label>
				</td>
				<td>
					<select id="tipoMaterialID" name="tipoMaterialID" path="tipoMaterialID" tabindex="53" >
					</select> 
 				</td>	
			</tr>
			<tr>
				<td class="label">
					<label for="RFClbl">Cuenta con <br> Pavimento:</label>
				</td>
				<td>
					<label for="RFClbl">Si </label>
					<input type="radio" id="pavimentoSi" checked="true" name="pavimento" path="pavimento" tabindex="54" />
					<label for="RFClbl">No </label>
					<input type="radio" id="pavimentoNo" name="pavimento" path="pavimento" tabindex="55" />
					<input type="hidden" value="S" id="conPavimento" name="conPavimento" path="conPavimento"/>
				</td>	
				<td class="separador"></td>  
				<td class="label">
					<label for="RFClbl">Cuenta con<br>Electricidad:</label>
				</td>
				<td>
					<label for="RFClbl">Si </label>
					<input type="radio" id="electricidadSi" checked="true" name="electricidad" path="electricidad" tabindex="56" />
					<label for="RFClbl">No </label>
					<input type="radio" id="electricidadNo" name="electricidad" path="electricidad" tabindex="57" />
 					<input type="hidden" value="S" id="conElectricidad" name="conElectricidad" path="conElectricidad"/>
				</td>	
			</tr>
			<tr>
				<td class="label">
					<label for="RFClbl">Cuenta con Gas:</label>
				</td>
				<td>
					<label for="RFClbl">Si </label>
					<input type="radio" id="gasSi" checked="true" name="cuentaConGas" path="cuentaConGas" tabindex="58" />
					<label for="RFClbl">No </label>
					<input type="radio" id="gasNo" name="cuentaConGas" path="cuentaConGas" tabindex="59" />
					<input type="hidden" value="S" id="conGas" name="conGas" path="conGas"/>
				</td>	
				<td class="separador"></td>  
				<td class="label">
					<label for="RFClbl">Cuenta Con<br>Agua:</label>
				</td>
				<td>
					<label for="RFClbl">Si </label>
					<input type="radio" id="aguaSi" checked="true" name="cuentaConAgua" path="cuentaConAgua" tabindex="60" />
					<label for="RFClbl">No </label>
					<input type="radio" id="aguaNo" name="cuentaConAgua" path="cuentaConAgua" tabindex="61" />
 					<input type="hidden" value="S" id="conAgua" name="conAgua" path="conAgua"/>
				</td>	
			</tr>
			<tr>
				<td>
					<label for="lblTiempoHabitar">Tiempo de Habitar el Domicilio:</label>
				</td>
				<td>
					<input type="text" id="tiempoHabitarDom" name="tiempoHabitarDom" path="tiempoHabitarDom" maxlength="5" size="3" tabindex="62" /><label for="meses">&nbsp;Meses</label>
				</td>
			</tr>
		</table>
		<table>
			<tr>
				<td class="label" valign="TOP">
					<label for="RFClbl">Descripción Vivienda:</label>
				</td>
				<td>
					<textarea id="descripcion" name="descripcion" path="descripcion" onBlur=" ponerMayusculas(this)" 
						tabindex="63" style="margin: 2px; width: 589px; height: 52px;" ></textarea>
				</td>	
				<td class="separador"></td>  
				<td class="label"></td>
				<td></td>	
			</tr>
		</table>
		<br>
		<table border="0" width="100%">
			<tr><!-- Boton sumbit graba transaccion -->
				<td colspan="5" align="right">
					<input type="submit" id="grabarViv" name="grabarViv" class="submit" value="Grabar" tabindex="64"  />
					<input type="hidden" id="tipoTransaccionViv" name="tipoTransaccionViv"/>	
				</td>
			</tr>	
		</table>
	</fieldset>
</form:form>	

</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista" ></div>
</div>
</body>
<div id="mensaje" style="display: none;" ></div>
</html>
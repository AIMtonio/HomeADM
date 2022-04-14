<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
		<script type="text/javascript" src="dwr/interface/solBuroCredServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/coloniaRepubServicio.js"></script>  
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/circuloCreTipConServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
 		<script type="text/javascript" src="js/buroCredito/solBuroCredito.js"></script>
 		
	</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="solBuroCreditoBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all" id="legendtext">Consulta Bur&oacute; Cr&eacute;dito</legend>			
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend >Tipo de Consulta: </legend>			
		<table border="0" cellpadding="0" cellspacing="0">
			<tr>
		 		<td class="label">
		 			<label for="consultaBC">Consulta a Bur&oacute; de Crédito</label>
		 		</td>
		 		<td>
		 			<input type="radio" id="consultaBC" tabindex="1" name="consulta">
		 		</td>
		 		<td class="separador"></td>
		 		
		 		<td class="label">
		 			<label for="consultaCC">Consulta a Círculo de Crédito</label>
		 		</td>
		 		<td>
		 			<input type="radio" id="consultaCC" tabindex="2" name="consulta">
		 		</td>
			</tr>
		</table>
	</fieldset>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend >Datos Persona: </legend>			
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
	 		<td class="label">
				<label for="Cliente"><s:message code="safilocale.cliente"/>: </label>
			</td> 
			<td >
				<input type="text" id="clienteID" name="clienteID" tabindex="3" size="15"/> 
			</td>	
			<td class="separador"></td> 
			<td class="label"> 
				<label for="lblProspecto">Prospecto: </label> 
			</td> 
			<td> 
				<form:input type="text" id="prospectoID" name="prospectoID" path="prospectoID" size="12" tabindex="4" />
			</td> 	
	 	</tr>
		<tr>
			<td class="label">
				<label for="primerNombre">Primer Nombre:</label>
			</td>
			<td>
				<form:input  type="text" id="primerNombre" name="primerNombre" path="primerNombre" tabindex="5" onBlur=" ponerMayusculas(this)" />
			</td>		
			<td class="separador"></td>
			<td class="label">
				<label for="segundoNombre">Segundo Nombre: </label>
			</td>
			<td >
				<form:input  type="text" id="segundoNombre" name="segundoNombre" path="segundoNombre" 
				 tabindex="6" onBlur=" ponerMayusculas(this)" />
			</td>
		</tr>
		<tr>
			<td class="label">
					<label for="tercerNombre">Tercer Nombre:</label>
			</td>
			<td>
				<form:input type="text" id="tercerNombre" name="tercerNombre" path="tercerNombre" tabindex="7" 
					onBlur=" ponerMayusculas(this)"  />
			</td>				
				<td class="separador"></td>
				<td class="label">
					<label for="apellidoPaterno">Apellido Paterno:</label>
				</td>
				<td>
					<form:input type="text" id="apellidoPaterno" name="apellidoPaterno" path="apellidoPaterno" 
					tabindex="8" onBlur=" ponerMayusculas(this)"  />
				</td>		
		</tr>
		<tr>
			<td class="label">
					<label for="apellidoMaterno">Apellido Materno:</label>
				</td>
				<td >
					<form:input type="text" id="apellidoMaterno" name="apellidoMaterno" path="apellidoMaterno" 
					tabindex="9" onBlur=" ponerMayusculas(this)" />
				</td>
				<td class="separador"></td>
				<td  class="label"> 
		         <label for="lblfecha">Fecha de Nacimiento: </label> 
		     	</td> 
		     	<td nowrap="nowrap"> 
		          <form:input type="text" id="fechaNacimiento" name="fechaNacimiento" path="fechaNacimiento" size="12" 
		         	 tabindex="10" esCalendario="true" />  
		     	</td>
	 	</tr> 
	 	<tr>
	    	<td class="label"> 
	         <label for=lblRFC>RFC: </label> 
	     	</td>
	     	<td nowrap="nowrap">
	         <form:input type="text" id="RFC" name="RFC" path="RFC" size="17" tabindex="11"  maxlength="13"/>   
				<input type ="button" id="generar" name="generar" value="Calcular" class="submit" tabindex="12"  style="display: none;"/>
			</td>	
			<td class="separador"></td> 
			<td class="label"> 
	         <label for=lblFolio>Folio de Consulta: </label> 
	     	</td>
	     	<td>
	         <form:input type="text" id="folioConsulta" name="folioConsulta" path="folioConsulta" size="12" tabindex="13" disabled="true"  />   
			</td>
		</tr> 
	   	<tr>
	   		<td class="label" nowrap="nowrap"> 
	         <label for=lblFolio>Fecha de Consulta: </label> 
		    </td>
		    <td nowrap="nowrap" >
		         <form:input id="fechaConsulta" name="fechaConsulta" path="fechaConsulta" size="19" disabled="true"  tabindex="14" />   
		      </td>
		   <td class="separador"></td>
		      <td class="label" nowrap="nowrap"> 
		         <label for=diasVigenciaBC>Días Restantes de Vigencia Consulta: </label> 
		      </td>
		      <td> 
		         <input type="text" id="diasVigenciaBC" name="diasVigenciaBC" size="4" disabled ="true" readOnly="true"  tabindex="15"/>
		      </td>
		</tr> 
	   	<tr>
	   		<td class="label"> 
	        	<label for=sexo>G&eacute;nero: </label> 
		    </td>
		    <td>
		        <select id="sexo" name="sexo"  tabindex="16" >
		        	<option value="">SELECCIONAR</option>
		         	<option value="M">MASCULINO</option>
		         	<option value="F">FEMENINO</option>
				</select>   
		    </td>
		   	<td class="separador"></td>
		    <td class="label">
				<label for="estadoCivil">Estado Civil:</label>
			</td>
			<td>
				<select id="estadoCivil" name="estadoCivil" path="estadoCivil"  tabindex="17">
					<option value="">SELECCIONAR</option>
					<option value="S">SOLTERO</option>
			     	<option value="CS">CASADO BIENES SEPARADOS</option>
			     	<option value="CM">CASADO BIENES MANCOMUNADOS</option>
			     	<option value="CC">CASADO BIENES MANCOMUNADOS CON CAPITULACION</option>
			     	<option value="V">VIUDO</option>
			     	<option value="D">DIVORCIADO</option>
			     	<option value="SE">SEPARADO</option>
			     	<option value="U">UNION LIBRE</option>
			     	<option value="C">CASADO</option>
				</select>
			</td>	
		</tr>
	    <tr id = "circuloItems">
			<td><label for=lblFolio>Número de firma: </label></td>
			<td><form:input  type="text" id="numeroFirma" name="numeroFirma" path="numeroFirma" size="38" disabled ="true" readOnly="true" tabindex="18" /></td>
			<td class="separador"></td>
			<td><label for=lblFolio>Monto Solicitado: </label></td>
			<td><form:input id="importe" name="importe" path="importe" size="20" esMoneda="true" style="text-align: right;" tabindex="19"/></td>
		</tr>
		<tr>
			<td class="label"> 
         		<label id="lblTipoCuenta" for="tipoCuenta">Contrato C&iacute;rculo de Cr&eacute;dito: </label> 
     		</td> 
     		<td nowrap="nowrap">
     			<input type="text" id="tipoCuenta" name="tipoCuenta" path="tipoCuenta" size="3" tabindex="20"  onBlur=" ponerMayusculas(this)"  />
	     		<input type="text" id="tipoContratoCCIDDes" name="tipoContratoCCIDDes" size="40" tabindex="21" disabled="true"/>
	     		<input type="hidden" id="claveUsuario" name="claveUsuario" />
				<input type="hidden" id="claveUsuariob" name="claveUsuariob" />         	
     		</td>
		   	<td class="separador"></td>
		   	<td class="separador"></td>
		   	<td class="separador"></td>
		</tr>	
	    <tr>
	    	<td><br></td>
	    </tr>
	</table>
	</fieldset>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">	
		<legend >Datos Del <s:message code="safilocale.cliente"/> o Representante Legal</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label"> 
					<label for="tipoPersona">Tipo Persona: </label> 
				</td>
				<td class="label"> 
					<form:radiobutton id="tipoPersona1" name="tipoPersona"  path="tipoPersona"
				 		value="F" checked="checked" />
					<label for="tipoPersona1">F&iacute;sica</label>&nbsp;&nbsp;
					<form:radiobutton id="tipoPersona3" name="tipoPersona"  path="tipoPersona"
						value="A" />
					<label for="tipoPersona3">F&iacute;sica Act Emp</label>
					<form:radiobutton id="tipoPersona2" name="tipoPersona"   path="tipoPersona" 
						value="M" />
					<label for="tipoPersona2">Moral</label>
				</td>		
			</tr>
		</table>
	</fieldset>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend >Teléfonos</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label"> 
          			<label for="telefono">Teléfono Casa: </label>
          		</td>
    			<td> 
         			<form:input id="telefono" name="telefono" path="telefono"  size="45" tabindex="22" /> 
    			</td>
    			<td class="separador"></td>
    			<td class="label"> 
          			<label for="telefonoCelular">Teléfono Celular: </label>
          		</td>
    			<td> 
         			<form:input id="telefonoCelular" name="telefonoCelular" path="telefonoCelular"  size="45" tabindex="23" /> 
    			</td>   
			</tr>
			<tr>
				<td class="label"> 
          			<label for="telTrabajo" id="labeltelTrabajo">Teléfono Oficina: </label>
          		</td>
    			<td> 
         			<form:input id="telTrabajo" name="telTrabajo" path="telTrabajo" size="45" tabindex="24" /> 
    			</td>
    		</tr>
		</table>
	</fieldset>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend >Dirección</legend>	
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
		 		<td class="label"> 
          			<label for="calle">Calle: </label> 
    			</td> 
    			<td> 
         			<form:input id="calle" name="calle" path="calle" size="45" tabindex="25" onBlur=" ponerMayusculas(this)"/> 
    			</td> 
    			<td class="separador"></td> 
				<td class="label"> 
         			<label for="numero">No. Exterior: </label> 
    			</td> 
     			<td> 
         			<form:input id="numeroExterior" name="numeroExterior" path="numeroExterior" size="5" tabindex="26"  />
    				<label for="interior">Interior: </label>
          			<form:input id="numeroInterior" name="numeroInterior" path="numeroInterior" size="5" tabindex="27" />
          			<label for="piso">Piso: </label>
          			<form:input id="piso" name="piso" path="piso" size="5" tabindex="28" />
     			</td> 
     		</tr>
     		
     		<tr> 
     			<td class="label"> 
         			<label for="Lote">Lote: </label> 
     			</td> 
    			<td> 
         			<form:input id="lote" name="lote" path="lote" size="20" tabindex="29" /> 
     			</td> 
    			<td class="separador"></td> 
     			<td class="label"> 
         			<label for="Manzana">Manzana: </label> 
     			</td> 
     			<td> 
         			<form:input id="manzana" name="manzana" path="manzana" size="20" tabindex="30" /> 
     			</td> 
     		</tr>
     		<tr>
     			<td class="label"> 
         			<label for="estado">Entidad Federativa: </label> 
     			</td> 
    			<td> 
         			<form:input  type="text" id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="31"  /> 
         			<input type="text" id="nombreEstado" name="nombreEstado" size="35" tabindex="32" disabled ="true" readOnly="true"/>
         			<form:input type="hidden" id="claveEstado" path="claveEstado" name="claveEstado"/>    
     			</td> 
     			<td class="separador"></td> 
     			<td class="label"> 
         			<label for="municipio">Municipio: </label> 
     			</td> 
    			<td> 
         			<form:input  type="text" id="municipioID" name="municipioID" path="municipioID" size="6" tabindex="33" /> 
         			<form:input type="text" id="nombreMuni" name="nombreMuni" path="nombreMuni"  size="35" tabindex="34" disabled="true" readOnly="true"/>    
     			</td> 
     		</tr>
     		<tr>  
				<td class="label"><label for="calle">Localidad: </label></td> 
	     		<td nowrap="nowrap"> 
	         		<form:input  type="text" id="localidadID" name="localidadID" path="localidadID" size="6" tabindex="35"  /> 
	     			<input type="text" id="nombreLocalidad" name="nombreLocalidad" size="35" tabindex="36" disabled="true" onBlur=" ponerMayusculas(this)" readonly="true"/>   
	     		</td>  
     			<td class="separador"></td> 
     			<td class="label"><label for="calle">Colonia: </label></td> 
	     		<td nowrap="nowrap"> 
	         		<form:input  type="text" id="coloniaID" name="coloniaID" path="coloniaID" size="6" tabindex="37" /> 
	    			<input type="text" id="nombreColonia" name="nombreColonia" size="35" tabindex="38" disabled="true"  onBlur=" ponerMayusculas(this)"  readonly="true"/>   
	     		</td> 
   		</tr> 
   		<tr>
 			<td class="label"><label for="CP">C.P.: </label></td> 
     		<td> 
         		<form:input type="text" id="CP" name="CP" path="CP" size="15" tabindex="39" readonly="true"  /> 
     		</td> 
   		</tr>
			
  </table> 
  </fieldset>
		<table align="right">
		<tr>
				<td align="right">
				 	<input type="submit" id="generarRepAutCred" name="generarRepAutCred" class="submit" value="Autorizaci&oacute;n de Consulta" tabindex="37"/>
					<input type="hidden" id="horaPDF" name="horaPDF" size="20" /> 
				</td> 
				<td>									
				 	<input type="submit" id="autorizaSolCredito" name="autorizaSolCredito" class="submit" value="Formato  Aut. Consulta" tabindex="37"/>
				</td>
				<td align="right">
					<input type="submit" id="consulta" name="consulta" class="submit" value="Consultar en BC" tabindex="38"/>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					<input type="hidden" id="usuarioCirculo" name="usuarioCirculo"/>
					<input type="hidden" id="contrasenaCirculo" name="contrasenaCirculo"/>
					<input type="hidden" id="realizaConsultasCC" name="realizaConsultasCC"/>
					<input type="hidden" id="folioConsultaOtorgante" name="folioConsultaOtorgante" value="0"/>
					<input type="hidden" id="abreviaturaCirculo" name="abreviaturaCirculo" value=""/>			
					<input type="hidden" id="socioCliente" name="socioCliente" value="<s:message code="safilocale.cliente"/>"  />
					<input type="hidden" id="claveUsuario" name="claveUsuario" />
					<input type="hidden" id="claveUsuariob" name="claveUsuariob" />
					<input type="hidden" id="origenDatos" name="origenDatos" />
					<input type="hidden" id="realizaConsultasBC" name="realizaConsultasBC"/>
					<input type="hidden" id="usuarioBuroCredito" name="usuarioBuroCredito" />
					<input type="hidden" id="contraseniaBuroCredito" name="contraseniaBuroCredito" />
				</td>
				<td align="right">
				 	<input type="submit" id="generarRep" name="generarRep" class="submit" value="Ver Reporte" tabindex="39"/>
					<input type="hidden" id="hora" name="hora" size="20"  /> 
				</td>
			</tr>
		</table>	
</fieldset> 
</form:form> 

</div> 
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>

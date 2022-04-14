<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>     
		<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>   
		<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/tiposDireccionServicio.js"></script>  
		<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/coloniaRepubServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/ocupacionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paisesServicio.js"></script> 
 	    <script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="js/soporte/mascara.js"></script>            
		<script type="text/javascript" src="js/credito/prospectos.js"></script>      
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="prospectosBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend class="ui-widget ui-widget-header ui-corner-all">Alta de Prospecto</legend>
	<table border="0"  width="15%">
		<tr>
			<td class="label"> 
	        	<label for="lbllineaCreditoID">Número: </label> 
		   	</td>
		   	<td> 
		    	<form:input id="prospectoID" name="prospectoID" path="prospectoID" size="12" 
		      		tabindex="1" />  
		   	</td>
	   </tr>
	 </table>
	 <br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend >Datos Del Prospecto o Representante Legal</legend>
	<table border="0"  width="100%">
	  <tr>
            <td class="label">
				<label for="primerNombre">Primer Nombre:</label>
			</td>
			<td>
				<form:input id="primerNombre" name="primerNombre" path="primerNombre" tabindex="2" 
					maxlength="50" onBlur=" ponerMayusculas(this)"/>
			</td>
			 	<td class="separador"></td> 
	    
			<td class="label">
				<label for="segundoNombre">Segundo Nombre: </label>
			</td>
			<td >
				<form:input id="segundoNombre" name="segundoNombre" path="segundoNombre" 		maxlength="50"
					tabindex="3" onBlur=" ponerMayusculas(this)"/>
			</td>
	    </tr>
		<tr>  
	    	<td class="label">
				<label for="tercerNombre">Tercer Nombre:</label>
			</td>
			<td>
				<form:input id="tercerNombre" name="tercerNombre" path="tercerNombre" tabindex="4" 	maxlength="50"
					onBlur=" ponerMayusculas(this)"/>
			</td>
			<td class="separador"></td> 
	    	<td class="label">
				<label for="apellidoPaterno">Apellido Paterno:</label>
			</td>
			<td>
				<form:input id="apellidoPaterno" name="apellidoPaterno" path="apellidoPaterno" 	maxlength="50"
					tabindex="5" onBlur=" ponerMayusculas(this)"/>
			</td>
	    </tr>
		<tr> 
	    
	    		<td class="label">
				<label for="apellidoMaterno">Apellido Materno:</label>
			</td>
			<td >
				<form:input id="apellidoMaterno" name="apellidoMaterno" path="apellidoMaterno" 	maxlength="50"
				tabindex="6" onBlur=" ponerMayusculas(this)"/>
			</td>
		<td class="separador"></td> 
				<td class="label"> 
				<label for="tipoPersona">Tipo Persona: </label> 
			</td>
			<td class="label"> 
				<form:radiobutton id="tipoPersona" name="tipoPersona" path="tipoPersona"
		 			value="F" tabindex="7" checked="checked" />
				<label for="fisica">F&iacute;sica</label>&nbsp&nbsp;
				<form:radiobutton id="tipoPersona3" name="tipoPersona3" path="tipoPersona" 
					value="A" tabindex="8"/>
				<label for="fisica">F&iacute;sica Act Emp</label>
				<form:radiobutton id="tipoPersona2" name="tipoPersona2" path="tipoPersona" 
					value="M" tabindex="9"/>
				<label for="fisica">Moral</label>
			</td>
	    
			</tr>
			<tr>
				<td class="label">
					<label for="nacion">Nacionalidad:</label>
				</td>
				<td>
					<form:select id="nacion" name="nacion" path="nacion" tabindex="10">
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
					 	size="5" tabindex="11"/>
					<input type="text" id="paisNac" name="paisNac" size="30" tabindex="12" disabled="true" readOnly="true"
						onBlur=" ponerMayusculas(this)"/>
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="fechaNacimiento"> Fecha de Nacimiento:</label>
				</td>
				<td>
					<form:input id="fechaNacimiento" name="fechaNacimiento" path="fechaNacimiento" esCalendario="true" size="20" tabindex="13" />
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="paisResidenciaID">País de Residencia:</label>
				</td>
				<td>
					<form:input id="paisResidenciaID" name="paisResidenciaID" path="paisResidenciaID" size="5" tabindex="14"/>
					<form:input type="text" id="paisResidencia" name="paisResidencia" path="paisResidencia" size="35" disabled="true" readOnly="true" onBlur="ponerMayusculas(this)"/>
				</td>
			</tr>
			<tr>
				<td class="label">
				</td>
				<td>
				</td>
				<td class="separador"></td>  
				<td class="label">
					<label for="RFClbl"> RFC:</label>
				</td>
				<td>
					<form:input id="RFC" name="RFC" path="RFC" tabindex="16" maxlength="13" onBlur=" ponerMayusculas(this)"/>
					<input type ="button" id="generar" name="generar" value="Calcular" class="submit"  style="display: none;"/>
				</td>
			</tr>
		<tr>
			<td class	="label">
			<label for="estadoCivil">Género:</label>
			</td>
			<td>
				<form:select id="sexo" name="sexo" path="sexo"  tabindex="17">
					<form:option value="">SELECCIONAR</form:option> 
					<form:option value="F">FEMENINO</form:option>
			     	<form:option value="M">MASCULINO</form:option>
			     
				</form:select>
			</td>

			<td class="separador"></td>  
			<td class	="label">
			<label for="estadoCivil">Estado Civil:</label>
			</td>
			<td>
				<form:select id="estadoCivil" name="estadoCivil" path="estadoCivil"  tabindex="18">
					<form:option value="">SELECCIONAR</form:option> 
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
				<label for="telefonoCelular">Teléfono: </label>
			</td>
			<td>
				<form:input id="telefono" name="telefono" size="15" path="telefono"  tabindex="19" maxlength="10"/>
				<label for="lblExt">Ext.:</label>
				<form:input path="extTelefonoPart" id="extTelefonoPart" name="extTelefonoPart" size="10" maxlength="6" tabindex="20"/>
			</td>
	    	<td class="separador"></td> 
	    	<td class="label"> 
		    	<label for="estado">Entidad Federativa: </label> 
		    </td> 
		    <td> 
		       <form:input id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="21" /> 
		       <input type="text" id="nombreEstado" name="nombreEstado" size="35" tabindex="22" disabled ="true"
		        	readOnly="true"/>   
		    </td>
	 </tr>
	 <tr> 
	    	<td class="label"> 
				<label for="municipio">Municipio: </label> 
			</td> 
		    <td> 
		    	<form:input id="municipioID" name="municipioID" path="municipioID" size="6" tabindex="23" /> 
		        <input type="text" id="nombreMuni" name="nombreMuni" size="35" tabindex="24" disabled="true"
		        	readOnly="true"/>   
		   	</td> 
			 <td class="separador"></td> 
			<td class="label">
				<label for="ciudad">Ciudad:</label>
			</td>
			<td>
				<input type="text" id="ciudad" name="ciudad" size="40" disabled ="true" readOnly="true"/>
			</td>
	</tr>
	<tr>
		<td class="label"> 
		</td>
		<td>
		</td>
		<td class="separador"></td>
		<td class="label">
			<label for="lbllocalidad">Localidad: </label>
		</td>
		<td>
			<form:input id="localidadID" name="localidadID" path="localidadID" size="6" tabindex="26" />
			<input type="text" id="nombreLocalidad" name="nombrelocalidad" size="35" tabindex="27" disabled ="true" readOnly="true"/>
		</td>
	</tr>
	<tr>

	    	<td class="label"> 
				<label for="lblcolonia">Colonia: </label> 
			</td> 
		    <td> 
		    	<form:input id="coloniaID" name="coloniaID" path="coloniaID" size="6" tabindex="28" /> 
		        <input type="text" id="colonia" name="colonia" path="colonia" size="35" tabindex="29" disabled="true"
		        	readOnly="true"/>   
		   	</td> 
	  		<td class="separador"></td> 
	     	<td class="label"> 
		    	<label for="calle">Calle: </label> 
			</td> 
			<td> 
				 <form:input id="calle" name="calle" path="calle" size="45" tabindex="30"
	 				maxlength="50" onBlur=" ponerMayusculas(this)" /> 
			</td>
   </tr>
   <tr> 

		    <td class="label"> 
				<label for="numero">No. Exterior: </label> 
			</td> 
			<td> 
				<form:input id="numExterior" name="numExterior" path="numExterior" size="5" tabindex="31" maxlength="10" />
			</td> 
			<td class="separador"></td>
	    	<td class="label"> 
	       		<label for="exterior">No. Interior: </label>
	       	</td>
	       	<td>
		    	<form:input id="numInterior" name="numInterior" path="numInterior" size="5" tabindex="32" maxlength="10"/>
	  		</td>
	</tr>   
	<tr>
			<td class="label"> 
		    	<label for="CP">Código Postal: </label> 
		    </td> 
		    <td> 
		    	<form:input id="CP" name="CP" path="CP" maxlength="5" size="15" tabindex="33" /> 
		    </td>
		    <td class="separador"></td> 	     
	       <td class="label"> 
	     		<label for="Manzana">Manzana: </label> 
	  		</td> 
	 		<td> 
	      		<form:input id="manzana" name="manzana" path="manzana" size="20" tabindex="34" maxlength="20"
	      			onBlur=" ponerMayusculas(this)"/> 
	 		</td>
  </tr>
   <tr>
	     	<td class="label"> 
		    	<label for="Lote">Lote: </label> 
			</td> 
			<td> 
	     	 	<form:input id="lote" name="lote" path="lote" size="20" tabindex="35" maxlength="20" /> 
	    	</td> 
	    	 <td class="separador"></td>
	    	<td class="label"> 
		    	<label for="Latitud">Latitud: </label> 
		  	</td> 
		  	<td> 
		    	<form:input id="latitud" name="latitud" path="latitud" size="20" tabindex="36" maxlength="45"/> 
		  	</td> 
	</tr> 
	<tr> 
	   
			<td class="label"> 
				<label for="Longitud">Longitud: </label> 
			</td> 
			<td> 
				<form:input id="longitud" name="longitud" path="longitud" size="20" tabindex="37" maxlength="45" /> 
			</td> 
			  <td class="separador"></td>
			<td class="label"> 
		    	<label for="tipoDireccionID">Tipo de Direcci&oacute;n: </label> 
		 	</td> 
			<td  nowrap="nowrap"> 
				<form:select id="tipoDireccionID" name="tipoDireccionID" path="tipoDireccionID" tabindex="38">
					<form:option value="">Seleccionar</form:option>
				</form:select>

			</td> 
		</tr>

		</table>

	</fieldset>
	<div id="personaFisica">
		<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Persona F&iacute;sica</legend>
			<table border="0"  width="950px">
				<legend>Datos Laborales</legend>
				<tr>
					<td class="label">
						<label for="ocupacion">Ocupaci&oacute;n:</label>
					</td>
					<td>
						<form:input id="ocupacionID" name="ocupacionID" path="ocupacionID" size="5"
						tabindex="39" />
						<input type="text" id="ocupacionC" name="ocupacionC" size="35" tabindex="40" disabled="true" readOnly="true" 
						onBlur=" ponerMayusculas(this)"/>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="puesto">Puesto:</label>
					</td>
					<td>
						<form:input id="puesto" name="puesto" path="puesto"  tabindex="41" onBlur=" ponerMayusculas(this)"/>
					</td>
				</tr>
				<tr>
					<td class="label">
						<label for="lugarTrabajo">Nombre del Centro de Trabajo:</label>
					</td>
					<td>
						<form:input id="lugarTrabajo" name="lugarTrabajo" path="lugarTrabajo" size="33"	tabindex="42" onBlur=" ponerMayusculas(this)"/>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="antiguedadTra">Antiguedad Lugar de Trabajo:</label>
					</td>
					<td>
						<form:input id="antiguedadTra" name="antiguedadTra" path="antiguedadTra" size="6" tabindex="43"/>
						<font size="2"><label for="antiguedadTra">A&ntilde;os:</label></font>
					</td>
				</tr> 
				<tr>
					<td class="label">
						<label for="telefonoTrabajo">Tel&eacute;fono:</label>
					</td>
					<td>
						<form:input id="telTrabajo" name="telTrabajo" maxlength="10" path="telTrabajo" size="15" tabindex="44"/>
						<label for="lblExtTrabajo">Ext.:</label>
						<form:input path="extTelefonoTrab" id="extTelefonoTrab" name="extTelefonoTrab" size="10" maxlength="6" tabindex="45"/>
					</td>
				</tr>
			</table>
	    </fieldset>
	</div>
		<div id="personaMoral">
		<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Persona Moral</legend>
			<table border="0" width="950px">
			<tr>
				<td class="label">
					<label for="RazonSoc">Razón Social: </label>
				</td>
				<td >
					<form:input id="razonSocial" name="razonSocial" path="razonSocial" size= "35" tabindex="46" onBlur=" ponerMayusculas(this)" 
					maxlength="50"/>
				</td>
				<td class="label">
					<label for="RazonSoc">RFC: </label>
				</td>
				<td >
					<form:input id="RFCpm" name="RFCpm" path="RFCpm" size= "35" tabindex="47" onBlur="ponerMayusculas(this)" 
					maxlength="12"/>
				</td>
			</tr>
			</table>
	    </fieldset>
	</div>
		<div id="datosFiscales">
		<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Datos Fiscales</legend>
		<table border="0"  width="950px">

			<tr>
				<td class="label">
				<label for="clasificacion">Clasificación:</label>
				</td>
				<td nowrap="nowrap">
				<form:select id="clasificacion" name="clasificacion" path="clasificacion" tabindex="48">
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
			 		<label for="lblnoEmp">N&uacute;mero Empleado:</label>
				</td>
				<td>
				<form:input id="noEmpleado" name="noEmpleado" path="noEmpleado"  maxlength = "20" tabindex="49" />
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label for="lblnoEmp">Tipo Empleado:</label>
				<form:select id="tipoEmpleado" name="tipoEmpleado" path="tipoEmpleado" tabindex="50">
				<form:option value="">SELECCIONAR</form:option> 
				<form:option value="T">TEMPORAL</form:option>
				<form:option value="C">CONFIANZA</form:option>
				<form:option value="B">BASE</form:option>
				</form:select>
				</td>
			</tr>
		</table>
		</fieldset>
	</div>
	<br>
	<table border="0"  width="100%">
	<tr>
			<td align="right" colspan="5">
				<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="51"/>
				<input type="submit" id="modifica" name="modifica" class="submit"  value="Modificar" tabindex="52"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="alertCliente" name="alertCliente" value="<s:message code="safilocale.cliente"/>" />
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
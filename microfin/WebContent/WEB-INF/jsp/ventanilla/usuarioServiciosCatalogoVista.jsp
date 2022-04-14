<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>

	<script type="text/javascript" src="dwr/interface/tiposDireccionServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/tiposIdentiServicio.js"></script>   
	<script type="text/javascript" src="dwr/interface/tipoSociedadServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/identifiClienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/paisesServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/coloniaRepubServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/ocupacionesServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
	
	<script type="text/javascript" src="dwr/interface/usuarioServicios.js"></script>
	<script type="text/javascript" src="dwr/interface/usuarioArchivosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>	
	<script type="text/javascript" src="dwr/interface/sectoresServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/actividadesServicio.js"></script>		
 	
	<script type="text/javascript" src="js/soporte/mascara.js"></script>
	<script type="text/javascript" src="js/ventanilla/usuarioServicios.js"></script> 
</head>
<body>
	<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="usuarioServiciosBean">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend class="ui-widget ui-widget-header ui-corner-all">Alta de Usuario de Servicios</legend>
		<table border="0" width="100%">
			<tr>
				<td class="label"> 
		        	<label for="lbllineaCreditoID">N&uacute;mero: </label> 
			   	</td>
			   	<td> 
			    	<form:input id="usuarioID" name="usuarioID" path="usuarioID" size="12" tabindex="1" maxlength="11"  autocomplete="off"/>  
			   	</td>
			   	<td class="label">
					<label for="sucursalOrigen">Sucursal: </label>
				</td>
			  	<td >
					<form:input id="sucursalOrigen" name="sucursalOrigen" path="sucursalOrigen" readOnly="true" iniForma="false" size="6"  tabindex="2"/>
					<input type="text" id="sucursalO" name="sucursalO" size="37" disabled ="true" readOnly="true" iniForma="false"/>
				</td>
			</tr>
		</table>
		<br>
		 
		<fieldset class="ui-widget ui-widget-content ui-corner-all">	
			<legend >Datos del Usuario de Servicios o Representante Legal</legend>
			<table border="0" width="100%">
				<tr>
					<td class="label"> 
						<label for="tipoPersona">Tipo Persona: </label> 
					</td>
					<td class="label"> 
						<form:radiobutton id="tipoPersona1" name="tipoPersona" path="tipoPersona"
				 			value="F" tabindex="3" checked="checked" />
						<label for="fisica">F&iacute;sica</label>&nbsp&nbsp;
						<form:radiobutton id="tipoPersona3" name="tipoPersona3" path="tipoPersona" 
							value="A" tabindex="4"/>
						<label for="fisica">F&iacute;sica Act Emp</label>
						<form:radiobutton id="tipoPersona2" name="tipoPersona2" path="tipoPersona" 
							value="M" tabindex="5"/>
						<label for="fisica">Moral</label>
					</td>		
				</tr>
				<tr>
		            <td class="label">
						<label for="primerNombre">Primer Nombre:</label>
					</td>
					<td>
						<form:input id="primerNombre" name="primerNombre" path="primerNombre" tabindex="6" 
							maxlength="50" onBlur=" ponerMayusculas(this)"/>
					</td>
				 	<td class="separador"></td> 
					<td class="label">
						<label for="segundoNombre">Segundo Nombre: </label>
					</td>
					<td >
						<form:input id="segundoNombre" name="segundoNombre" path="segundoNombre" maxlength="50"
							tabindex="6" onBlur=" ponerMayusculas(this)"/>
					</td>
				</tr>
				
				<tr>  
			    	<td class="label">
						<label for="tercerNombre">Tercer Nombre:</label>
					</td>
					<td>
						<form:input id="tercerNombre" name="tercerNombre" path="tercerNombre" tabindex="7" 	maxlength="50"
							onBlur=" ponerMayusculas(this)"/>
					</td>	
					<td class="separador"></td> 
			    	<td class="label">
						<label for="apellidoPaterno">Apellido Paterno:</label>
					</td>
					<td>
						<form:input id="apellidoPaterno" name="apellidoPaterno" path="apellidoPaterno" 	maxlength="50"
							tabindex="8" onBlur=" ponerMayusculas(this)"/>
					</td>	
			    </tr>
			    
				<tr> 		
			    	<td class="label">
						<label for="apellidoMaterno">Apellido Materno:</label>
					</td>
					<td >
						<form:input id="apellidoMaterno" name="apellidoMaterno" path="apellidoMaterno" 	maxlength="50"
						tabindex="9" onBlur=" ponerMayusculas(this)"/>
					</td>
					<td class="separador"></td> 
					
					<td class="label">
						<label for="fechaNacimiento"> Fecha de Nacimiento:</label>
					</td>
					<td>
						<form:input id="fechaNacimiento" name="fechaNacimiento" path="fechaNacimiento" esCalendario="true" size="20" tabindex="10" />
					</td>	
				</tr>  
				
				<tr>
					<td class="label">
						<label for="paisNacimiento">Pa&iacute;s de Nacimiento:</label>
					</td>
					<td>
						<form:input id="paisNacimiento" name="paisNacimiento" path="paisNacimiento" size="6" tabindex="11" maxlength="20"/>
						<input type="text" id="paisNac" name="paisNac" size="35" disabled="true" readOnly="true"
							onBlur=" ponerMayusculas(this)"/>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="nacion">Nacionalidad:</label>
					</td>
					<td>
						<form:select id="nacion" name="nacion" path="nacion" tabindex="12">
							<form:option value="">SELECCIONAR</form:option>
							<form:option value="N">MEXICANA</form:option> 
						    <form:option value="E">EXTRANJERA</form:option>
						</form:select>
					</td>
				</tr> 

				<tr>
					<td class="label"> 
				    	<label for="estadoNac">Entidad Federativa:</label> 
				    </td> 
				    <td> 
				       <form:input id="estadoNac" name="estadoNac" path="estadoNac" size="6" tabindex="13" maxlength="20"/> 
				       <input type="text" id="nombreEstado" name="nombreEstado" size="35" disabled ="true" readOnly="true"/> 
				    </td>
				    <td class="separador"></td>
					<td class="label">
						<label for="paisResidencia">Pa&iacute;s de Residencia: </label>
					</td>
					<td>
						<form:input id="paisResidencia" name="paisResidencia" path="paisResidencia" size="5" tabindex="14" maxlength="20"/>
						<input type="text" id="paisR" name="paisR" size="30" tabindex="22" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)"/>
					</td>
				</tr>
				
				<tr>
					<td class="label">
					<label for="estadoCivil">Sexo:</label>
					</td>
					<td>
						<form:select id="sexo" name="sexo" path="sexo"  tabindex="15">
							<form:option value="">SELECCIONAR</form:option>
							<form:option value="F">FEMENINO</form:option>
					     	<form:option value="M">MASCULINO</form:option>
						</form:select>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="telefonoCelular">Tel&eacute;fono Celular: </label>
					</td>
					<td>
						<form:input id="telefonoCelular" name="telefonoCelular" maxlength="15" size="16" path="telefonoCelular" tabindex="16"/>
					</td>
				</tr>
				<tr>  
			    	<td class="label">
						<label for="telefonoCasa">Tel&eacute;fono:</label>
					</td>
					<td>
						<form:input id="telefonoCasa" name="telefonoCasa" size="17" path="telefonoCasa"  tabindex="17" maxlength="10"/>
						<label for="lblExt">Ext.:</label>
						<form:input path="extTelefonoPart" id="extTelefonoPart" name="extTelefonoPart" size="10" maxlength="6" tabindex="18" />
					</td>
			    	<td class="separador"></td> 
			    	<td class="label">
						<label for="correo"> Correo Electr&oacute;nico:</label>
					</td>
					<td>
						<form:input id="correo" name="correo" path="correo" tabindex="19" size="30" maxlength="50"/>
					</td>		
			 	</tr>
			 	<tr>
			 		<td class="label">
						<label for="CURP">CURP:</label>
					</td>
					<td>
						<form:input id="CURP" name="CURP" path="CURP" tabindex="20" size="25" 
							onBlur=" ponerMayusculas(this)" maxlength="18"/>
						<input type ="button" id="generarc" name="generarc" value="Calcular" class="submit" style="display: none;"/>
					</td>	
					<td class="separador"></td> 
			    	<td class="label">
						<label for="RFC"> RFC:</label>
					</td>
					<td>
						<form:input id="RFC" name="RFC" path="RFC" tabindex="21" maxlength="13" onBlur=" ponerMayusculas(this)"/>
				 		<input type ="button" id="generar" name="generar" value="Calcular" class="submit"  style="display: none;"/>
					</td>
				</tr>
				<tr>
					<td class="label">
						<label for="FEA">Registro FEA:</label>
					</td>
					<td >
						<form:input id="FEA" name="FEA" path="FEA" 	maxlength="50" tabindex="22" onBlur=" ponerMayusculas(this)"/>
					</td>
					<td class="separador"></td> 
					
					<td class="label">
						<label for="fechaConstitucion"> Fecha de Constituci&oacute;n:</label>
					</td>
					<td>
						<form:input id="fechaConstitucion" name="fechaConstitucion" path="fechaConstitucion" esCalendario="true" size="20" tabindex="23" />
					</td>	
				</tr>
				<tr>
					<td class="label" nowrap="nowrap">
						<label for="nivelRiesgo">Nivel de Riesgo:</label>
					</td>
					<td nowrap="nowrap">
						<form:select id="nivelRiesgo" name="nivelRiesgo" path="nivelRiesgo"  tabindex="24">
							<form:option value="">SELECCIONAR</form:option>
							<form:option value="B">BAJO</form:option>
					     	<form:option value="M">MEDIO</form:option>
					     	<form:option value="A">ALTO</form:option>
						</form:select>
					</td>
				</tr>
			</table>
		</fieldset>

		<div id="personaFisica">
			<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">		
				<legend>Persona F&iacute;sica</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label">
							<label for="ocupacion">Ocupaci&oacute;n:</label>
						</td>
						<td>
							<form:input id="ocupacionID" name="ocupacionID" path="ocupacionID" size="5" tabindex="30" maxlength="25"/>
							<input type="text" id="ocupacionC" name="ocupacionC" size="35" disabled="true" readOnly="true" 
							onBlur=" ponerMayusculas(this)"/>
						</td>	
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
					</tr>
				</table>
		    </fieldset>
		</div>
		
		<div id="personaMoral" style="display:none">
			<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">		
			<legend>Persona Moral</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label">
							<label for="razonSocial">Razón Social: </label>
						</td>
						<td>
							<form:input id="razonSocial" name="razonSocial" path="razonSocial" size= "35" tabindex="40" onBlur="ponerMayusculas(this)" 
							maxlength="50"/>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="tipoSociedadID">Tipo de Sociedad: </label>
						</td>
						<td>
							<form:input id="tipoSociedadID" name="tipoSociedadID" path="tipoSociedadID" size="7" tabindex="41" maxlength="25" />
							<input type="text" id="descripSociedad" name="descripSociedad" size="40" disabled="true" readOnly="true" onBlur="ponerMayusculas(this)"/>
						</td>	
					</tr>
					<tr>
						<td class="label">
							<label for="RFCpm">RFC: </label>
						</td>
						<td>
							<form:input id="RFCpm" name="RFCpm" path="RFCpm" size= "35" onBlur="ponerMayusculas(this)" maxlength="13" tabindex="42"/>
						</td>
					</tr>
				</table>
		    </fieldset>
		</div>

		<div id="domicilio">
			<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">		
			<legend>Domicilio</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr> 
						<td class="label"> 
					    	<label for="tipoDireccionID">Tipo de Direcci&oacute;n: </label> 
					 	</td> 
						<td> 
							<form:select id="tipoDireccionID" name="tipoDireccionID" path="tipoDireccionID" tabindex="50">
								<form:option value="">SELECCIONAR</form:option>
							</form:select>
						</td> 
						<td class="separador"></td> 
						<td class="label"> 
					         <label for="estadoID">Entidad Federativa: </label> 
					    </td> 
					    <td> 
					         <form:input id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="51" maxlength="20"/>
					         <input type="text" id="nomEstado" name="nomEstado" size="35" disabled ="true" readonly="true"/>   
						</td> 
					</tr>

					<tr> 
				    	<td class="label"> 
							<label for="municipioID">Municipio: </label> 
						</td> 
					    <td> 
					    	<form:input id="municipioID" name="municipioID" path="municipioID" size="6" tabindex="52" maxlength="20"/> 
					        <input type="text" id="nombreMuni" name="nombreMuni" size="35" tabindex="51" disabled="true"
					        	readOnly="true"/>   
					   	</td> 		
						<td class="separador"></td> 
				    	<td class="label"> 
					    	<label for="localidadID">Localidad: </label> 
					    </td> 
					    <td> 
					       <form:input id="localidadID" name="localidadID" path="localidadID" size="6" tabindex="53" maxlength="20"/> 
					       <input type="text" id="nombreLocalidad" name="nombrelocalidad" size="35" tabindex="52" disabled ="true"
					        	readOnly="true"/>   
					    </td> 
					</tr>
					
					<tr>
				    	<td class="label"> 
							<label for="coloniaID">Colonia: </label> 
						</td> 
					    <td> 
					    	<form:input id="coloniaID" name="coloniaID" path="coloniaID" size="6" tabindex="54" maxlength="20"/> 
					        <input type="text" id="nombreColonia" name="nombreColonia" path="nombreColonia" size="35" tabindex="53" disabled="true" readOnly="true"/>   
					   	</td> 		
				  		<td class="separador"></td> 
				     	<td class="label"> 
					    	<label for="calle">Calle: </label> 
						</td> 
						<td> 
							 <form:input id="calle" name="calle" path="calle" size="45" tabindex="55" maxlength="50" onBlur=" ponerMayusculas(this)" /> 
						</td>
			   		</tr>

		   			<tr> 
					    <td class="label"> 
							<label for="numExterior">No. Exterior: </label> 
						</td> 
						<td> 
							<form:input id="numExterior" name="numExterior" path="numExterior" size="5" tabindex="55" maxlength="10" />
							<label for="numInterior">No. Interior: </label>
							<form:input id="numInterior" name="numInterior" path="numInterior" size="5" tabindex="56" maxlength="10"/>
							<label for="piso">Piso: </label>
	          				<form:input id="piso" name="piso" path="piso" size="5" tabindex="57"  onBlur=" ponerMayusculas(this)"/>
						</td> 			
						<td class="separador"></td>	
				    	<td class="label"> 
					    	<label for="CP">Código Postal: </label> 
					    </td> 
					    <td> 
					    	<form:input id="CP" name="CP" path="CP" maxlength="5" size="15" tabindex="58" /> 
					    </td>
					</tr> 

					<tr>
						<td class="label"> 
					    	<label for="lote">Lote: </label> 
						</td> 
						<td> 
				     	 	<form:input id="lote" name="lote" path="lote" size="20" tabindex="59" maxlength="20" /> 
				    	</td> 	
				    	<td class="separador"></td>
				       	<td class="label"> 
				     		<label for="manzana">Manzana: </label> 
				  		</td> 
				 		<td> 
				      		<form:input id="manzana" name="manzana" path="manzana" size="20" tabindex="60" maxlength="20"
				      			onBlur=" ponerMayusculas(this)"/> 
				 		</td>
					</tr> 
				</table>
			</fieldset>
		</div>

		<div id="identificacion">
			<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">		
			<legend>Identificaci&oacute;n</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr> 
					<td class="label"> 
				   		<label for="tipoIdentiID">Tipo: </label> 
				   	</td> 
				   	<td> 
				   		<form:select id="tipoIdentiID" name="tipoIdentiID" path="tipoIdentiID" tabindex="61">
							<form:option value="">SELECCIONAR</form:option>
						</form:select>
					</td>
					<td class="separador"></td>
					<td class="label"> 
				   		<label for="numIdentific">Folio: </label> 
				   	</td> 
				   	<td> 
				   		<form:input id="numIdentific" name="numIdentific" path="numIdentific" size="25" tabindex="62" onBlur=" ponerMayusculas(this)"/> 
				   	</td> 
				</tr> 
				<tr> 
					<td class="label"> 
						<label for="fecExIden">Fecha Expedici&oacute;n: </label> 
					</td> 
				   	<td> 
				     	<form:input id="fecExIden" name="fecExIden" path="fecExIden" size="20" tabindex="63" esCalendario="true" /> 
				   	</td> 
				   	<td class="separador"></td>
				   	<td class="label"> 
				    	<label for="fecVenIden">Fecha Vencimiento:</label> 
				   	</td> 
				   	<td> 
				    	<form:input id="fecVenIden" name="fecVenIden" path="fecVenIden" size="20" tabindex="64" esCalendario="true" /> 
				   	</td>
				</tr> 
			</table>
			</fieldset>
		</div>

		<div id="extranjero" style="display: none;">
			<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">		
				<legend>Extranjero</legend>
				<table border="0" cellpadding="0" cellspacing="0"  width="100%"> 
					<tr> 
					 	<td class="label"> 
					   		<label for="lblDocEstanciaLegal">Documento Estancia Legal: </label> 
					   	</td> 
					   	<td class="label"> 
					   		<label for="lblMoneda">FM2 </label> 
							<form:radiobutton id="docEstanciaLegal" name="docEstanciaLegal" path="docEstanciaLegal" maxlength="3"
							 value="FM2" tabindex="70" checked="checked" />&nbsp;&nbsp;
							<label for="lblMoneda">FM3 </label>
							<form:radiobutton id="docEstanciaLegal"  name="docEstanciaLegal" path="docEstanciaLegal" maxlength="3"
							 value="FM3" tabindex="71" /> 
					   	</td> 
					   	<td class="separador"></td> 
					   	<td class="label"> 
					    	<label for="lblDocExisLegal">Documento Existencia Legal: </label> 
					   	</td> 
					   	<td> 
					    	<form:input id="docExisLegal" name="docExisLegal" path="docExisLegal" size="40" maxlength="30" tabindex="72" /> 
					   	</td> 
					</tr> 
		
					<tr> 
					 	<td class="label"> 
					    	<label for="lblFechaVenEst">Fecha Vencimiento Estancia: </label> 
					   	</td> 
					   	<td> 
					   		<form:input id="fechaVenEst" name="fechaVenEst" path="fechaVenEst" size="14"  tabindex="73" esCalendario="true" /> 
					   	</td> 
					   	<td class="separador"></td>
					   	<td class="label">
							<label for="paisRFC"> País que Asigna RFC: </label>
				        </td>
				        <td>
				        	<form:input type="text" id="paisRFC" name="paisRFC" path="paisRFC" size="4" maxlength="11" tabindex="74" />
				        	<input type="text" id="NomPaisRFC" name="NomPaisRFC" size="35" readOnly="true"/>
				        </td> 
					</tr>
				</table>
			</fieldset>
		</div>
		<br>
		<!-- INICIO SECCIÓN DE REMITENTES -->
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Remitentes</legend>
				 <table border="0" width="10%">
					 <tr>
                         <td class="label" nowrap="nowrap">
                             <label for="lblRemitenteID">Remitente: </label>
                         </td>
                        <td nowrap="nowrap">
                             <form:input type="text" id="remitenteID" name="remitenteID" path="remitenteID" size="12" tabindex="75"  autocomplete="off"/>
                         </td>
                     </tr>
				</table>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Datos Generales del Remitente</legend>
						<table border="0" width="100%">
							<tr>
	                            <td class="label" nowrap="nowrap">
	                                <label for="lblTituloRem">T&iacute;tulo: </label>
	                            </td>
	                            <td nowrap="nowrap">
	                                <form:select id="tituloRem" name="tituloRem" path="tituloRem" tabindex="76">
	                                    <form:option value="">SELECCIONAR</form:option>
	                                    <form:option value="SR." />
	                                    <form:option value="SRA." />
	                                    <form:option value="SRITA." />
	                                    <form:option value="LIC." />
	                                    <form:option value="DR." />
	                                    <form:option value="ING." />
	                                    <form:option value="PROF." />
	                                    <form:option value="C. P." />
	                                </form:select>
	                            </td>
	                            <td class="separador"></td>
	                            <td class="label" nowrap="nowrap">
	                                <label for="lblTipoPersonaRem">Tipo Persona: </label>
	                            </td>
	                            <td nowrap="nowrap">
	                                <form:select id="tipoPersonaRem" name="tipoPersonaRem" path="tipoPersonaRem" tabindex="77">
	                                    <form:option value="">SELECCIONAR</form:option>
	                                </form:select>
	                            </td>
							</tr>
							<tr>
	                           <td class="label" nowrap="nowrap">
	                                <label for="lblNombreCompletoRem">Nombre Completo: </label>
	                            </td>
	                            <td nowrap="nowrap">
	                                <form:input  type="text" id="nombreCompletoRem" name="nombreCompletoRem" path="nombreCompletoRem" size="50" maxlength="200" tabindex="78" onBlur="ponerMayusculas(this);" autocomplete="off" />
	                            </td>
	                           	<td class="separador"></td>
	                            <td class="label" nowrap="nowrap">
									<label for="lblFechaNacimientoRem"> Fecha de Nacimiento:</label>
								</td>
								<td nowrap="nowrap">
									<form:input id="fechaNacimientoRem" name="fechaNacimientoRem" path="fechaNacimientoRem" esCalendario="true" size="20" tabindex="79" autocomplete="off" />
								</td>	
                            </tr>
                            <tr>
								<td class="label" nowrap="nowrap">
									<label for="lblpaisNacimientoRem">Pa&iacute;s de Nacimiento:</label>
								</td>
								<td nowrap="nowrap">
									<form:input id="paisNacimientoRem" name="paisNacimientoRem" path="paisNacimientoRem" size="7" maxlength="20" tabindex="80" autocomplete="off" />
									<input type="text" id="paisNacRem" name="paisNacRem" size="35" disabled="true" readOnly="true" />
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
							    	<label for="lblEstadoNacRem">Entidad Federativa:</label> 
							    </td> 
							   	<td nowrap="nowrap">
							       <form:input id="estadoNacRem" name="estadoNacRem" path="estadoNacRem" size="7" maxlength="20" tabindex="81" autocomplete="off" /> 
							       <input type="text" id="nombreEstadoRem" name="nombreEstadoRem" size="35" disabled ="true" readOnly="true"/> 
							    </td>
							 </tr>
							 <tr>
	                            <td class="label" nowrap="nowrap">
	                                 <label for="lblEstadoCivilRem">Estado Civil: </label>
	                             </td>
	                             <td>
	                                 <form:select id="estadoCivilRem" name="estadoCivilRem" path="estadoCivilRem" tabindex="82">
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
	                             <td class="separador"></td>
	                             <td class="label" nowrap="nowrap">
	                                 <label for="lblSexoRem">G&eacute;nero: </label>
	                             </td>
	                            <td nowrap="nowrap">
	                                 <form:select id="sexoRem" name="sexoRem" path="sexoRem" tabindex="83">
	                                     <form:option value="">SELECCIONAR</form:option>
	                                     <form:option value="M">MASCULINO</form:option>
	                                     <form:option value="F">FEMENINO</form:option>
	                                 </form:select>
	                             </td>
	                         </tr>
	                         <tr>
						 		<td class="label" nowrap="nowrap">
									<label for="lblCURPRem">CURP:</label>
								</td>
								<td nowrap="nowrap">
									<form:input id="CURPRem" name="CURPRem" path="CURPRem" size="25" onBlur=" ponerMayusculas(this)" maxlength="18" tabindex="84" autocomplete="off" />
									<input type ="button" id="generarc1" name="generarc1" value="Calcular" class="submit" style="display: none;"/>
								</td>	
								<td class="separador"></td> 
						    	<td class="label" nowrap="nowrap">
									<label for="lblRFCRem"> RFC:</label>
								</td>
								<td nowrap="nowrap">
									<form:input id="RFCRem" name="RFCRem" path="RFCRem" maxlength="13" onBlur=" ponerMayusculas(this)" tabindex="85" autocomplete="off" />
							 		<input type ="button" id="generar1" name="generar1" value="Calcular" class="submit"  style="display: none;"/>
								</td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lblFEARem">Registro de FEA:</label>
								</td>
								<td nowrap="nowrap">
									<form:input id="FEARem" name="FEARem" path="FEARem" maxlength="50" onBlur=" ponerMayusculas(this)" tabindex="86" autocomplete="off" />
								</td>
								<td class="separador"></td> 
								<td class="label" nowrap="nowrap">
									<label for="lblPaisFEA">Pa&iacute;s que Asigna FEA: </label>
                                </td>
                                <td nowrap="nowrap">
                                    <form:input id="paisFEARem" name="paisFEARem" path="paisFEARem" size="7" tabindex="87" autocomplete="off"/>
                                    <input type="text" id="descPaisFEARem" name="descPaisFEARem" size="30" disabled="true" readOnly="true" tabindex="87" onBlur=" ponerMayusculas(this)" />
                                </td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
								    <label for="lblOcupacionRem">Ocupaci&oacute;n: </label>
								</td>
								<td nowrap="nowrap">
								    <form:input id="ocupacionRem" name="ocupacionRem" path="ocupacionRem" size="7" maxlength="5" tabindex="88" autocomplete="off"/>
								    <input type="text" id="descOcupacionRem" name="descOcupacionRem" size="35" readOnly="true" disabled="true" />
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
								    <label for="lblPuestoRem">Puesto: </label>
								</td>
								<td nowrap="nowrap">
								    <form:input id="puestoRem" name="puestoRem" path="puestoRem" size="40" onBlur="ponerMayusculas(this);" maxlength="100" tabindex="89" autocomplete="off"/>
								</td>
							</tr>
						</table>
				</fieldset>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Actividad</legend>
						<table border="0" width="100%">
							<tr>
                               <td class="label" nowrap="nowrap">
                                    <label for="lblSectorGeneralRem">Sector General: </label>
                               </td>
                               <td nowrap="nowrap">
                                    <form:input id="sectorGeneralRem" name="sectorGeneralRem" path="sectorGeneralRem" size="7" tabindex="90" autocomplete="off"/>
                                    <input type="text" id="descSectorGralRem" name="descSectorGralRem" size="45" readOnly="true" disabled="true" />
                                </td>
                                <td class="separador"></td>
                                <td class="label" nowrap="nowrap">
                                    <label for="lblActividadBancoMXRem">Actividad BancoMX: </label>
                                </td>
                               	<td nowrap="nowrap">
                                    <form:input id="actividadBancoMXRem" name="actividadBancoMXRem" path="actividadBancoMXRem" size="15" tabindex="91" autocomplete="off"/>
                                    <input type="text" id="descripcionBMXRem" name="descripcionBMXRem" size="45" readOnly="true" disabled="true" />
                                </td>
                            </tr>
                            <tr>
								<td class="label" nowrap="nowrap">
								     <label for="lblActividadINEGIRem">Actividad INEGI: </label>
								</td>
								<td nowrap="nowrap">
								     <form:input id="actividadINEGIRem" name="actividadINEGIRem" path="actividadINEGIRem" size="7" readOnly="true" disabled="true" />
								    <input id="descripcionINEGIRem" name="descripcionINEGIRem" size="45" type="text" readOnly="true" disabled="true"  />
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
								    <label for="lblSectorEconomicoRem">Sector Econ&oacute;mico: </label>
								</td>
								<td nowrap="nowrap">
								    <form:input id="sectorEconomicoRem" name="sectorEconomicoRem" path="sectorEconomicoRem" size="15" readOnly="true" disabled="true" />
								    <input id="descripcionSERem" name="descripcionSERem" size="45" type="text" readOnly="true" disabled="true"  />
								</td>
                            </tr>
						</table>
				</fieldset>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Identificaci&oacute;n</legend>
						<table border="0" width="100%">
						    <tr>
						        <td class="label" nowrap="nowrap">
						            <label for="lblTipoIdentiIDRem">Tipo de Identificaci&oacute;n: </label>
						        </td>
						        <td nowrap="nowrap">
						            <form:select id="tipoIdentiIDRem" name="tipoIdentiIDRem" path="tipoIdentiIDRem" tabindex="92">
										<form:option value="">SELECCIONAR</form:option>
									</form:select>
								</td>
							</tr>
							<tr>
							    <td class="label" nowrap="nowrap">
							        <label for="lblNumIdentificRem">No. de Identificaci&oacute;n: </label>
							    </td>
							     <td nowrap="nowrap">
							        <form:input id="numIdentificRem" name="numIdentificRem" path="numIdentificRem" size="25" maxlength="18" tabindex="93" />
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
								    <label for="lblFecExIdenRem">Fecha Expedici&oacute;n Identificaci&oacute;n: </label>
								</td>
								<td nowrap="nowrap">
							    	<form:input id="fecExIdenRem" name="fecExIdenRem" path="fecExIdenRem" size="14" esCalendario="true" tabindex="94" />
							    </td>
							</tr>
							<tr>
							    <td class="label" nowrap="nowrap">
							        <label for="lblFecVenIdenRem">Fecha Vencimiento Identificaci&oacute;n:</label>
							    </td>
							    <td>
							        <form:input id="fecVenIdenRem" name="fecVenIdenRem" path="fecVenIdenRem" size="14" esCalendario="true" tabindex="95" />
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
								    <label for="lblTelefonoCasaRem">Tel&eacute;fono Casa: </label>
								</td>
								<td nowrap="nowrap">
								    <form:input id="telefonoCasaRem" name="telefonoCasaRem" path="telefonoCasaRem" size="15" maxlength="20" tabindex="96" />
								<label for="lblExtTelefonoRem">Ext.:</label>
									<form:input path="extTelefonoPartRem" id="extTelefonoPartRem" name="extTelefonoPartRem" size="10" maxlength="6" tabindex="97" />
							    </td>
							</tr>
							<tr>
							   <td class="label" nowrap="nowrap">
							        <label for="lblTelefonoCelularRem">Tel&eacute;fono Celular: </label>
							    </td>
							    <td>
							        <form:input id="telefonoCelularRem" name="telefonoCelularRem" path="telefonoCelularRem" size="14" maxlength="20" tabindex="98" />
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
								    <label for="lblCorreoRem">Correo: </label>
								</td>
								<td nowrap="nowrap">
							    	<form:input id="correoRem" name="correoRem" path="correoRem" size="35" maxlength="50" tabindex="99" />
							    </td>
							</tr>
							<tr>
							    <td class="label" nowrap="nowrap">
							        <label for="lblDomicilioRem">Domicilio: </label>
							     <td colspan="4">
							        <form:textarea id="domicilioRem" name="domicilioRem" path="domicilioRem" minlength="15" maxlength="200" cols="60" onBlur="ponerMayusculas(this);" tabindex="100" />
							   	</td>
						    </tr>
						</table>
				</fieldset>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Nacionalidad</legend>
                        <table border="0" width="100%">
                            <tr>
                                <td class="label">
                                    <label for="lblNacionalidadRem">Nacionalidad: </label>
                                </td>
                                <td>
                                    <form:select id="nacionRem" name="nacionRem" path="nacionRem" tabindex="101">
                                        <form:option value="">SELECCIONAR</form:option>
                                        <form:option value="N">NACIONAL</form:option>
                                        <form:option value="E">EXTRANJERO</form:option>
                                    </form:select>
                                </td>
                                <td class="separador"></td>
                                <td class="label" nowrap="nowrap">
                                    <label for="lblPaisResidenciaRem">Pa&iacute;s Residencia: </label>
                                </td>
                                <td>
                                    <form:input id="paisResidenciaRem" name="paisResidenciaRem" path="paisResidenciaRem" size="7" maxlength="5" tabindex="102" />
                                    <input type="text" id="descpaisR" name="descpaisR" size="50" readOnly="true" disabled="true" tabindex="82" />
                                </td>
                            </tr>
                        </table>
				</fieldset>
		</fieldset>
		<!-- FIN SECCIÓN DE REMITENTES -->
		<br>
		<table border="0" width="100%">
			<tr>
				<td align="right" colspan="5">
					<input type="submit" id="inactivar" name="inactivar" class="submit" value="Inactivar Usuario" tabindex="103"/>
					<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="104"/>
					<input type="submit" id="modifica" name="modifica" class="submit"  value="Modificar" tabindex="105"/>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>
					<input type="hidden" id="numeroCaracteres" name="numeroCaracteres"/>	
								
				</td>
			</tr>
		</table>
	</form:form>
	<br>
		<div id ="identiUsuario" style="display: none;">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Digitalizaci&oacute;n de Identificaci&oacute;n</legend>
				<br>
				<div id="gridArchivosUsuario" style="display: none;">	</div> 
				<table align="right">
					<tr>
				    	<td class="label">
							<input type="button" id="adjuntar" name="adjuntar" class="submit" tabindex="106" value="Adjuntar"   />
				  		</td> 
					</tr>
					<tr>
						<td>
							<div id="imagenCte" style="display: none;">
							 	<img id= "imgCliente" SRC="images/user.jpg" WIDTH="100%" HEIGHT="100%" border ="0" alt="Foto cliente"/> 
							</div> 
				       </td> 
					</tr>
				</table>
			</fieldset>
		</div>
		
	

		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td align="right" colspan="5">
					<a id="opcionUsuario" href="javascript: " onclick="$('#Contenedor').load('ingresosOperaciones.htm');consultaSesion();">
						<input type ="button" id="altaUsuario" name="altaUsuario" value="Ir a Ingreso Operaciones" class="submit" tabindex="107"/>
					</a>
				</td>
			</tr>
		</table>
	
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;overflow:auto">
		<div id="elementoLista"></div>
	</div>
	<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
		<div id="elementoListaCte"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
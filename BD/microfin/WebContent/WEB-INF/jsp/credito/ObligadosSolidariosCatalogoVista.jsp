<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="css/sweet-alert.css">
		<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>     
	   	<script type="text/javascript" src="dwr/interface/obligadosSolidariosServicio.js"></script>   
	   	<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/coloniaRepubServicio.js"></script>  
      	<script type="text/javascript" src="dwr/interface/notariaServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/ocupacionesServicio.js"></script>
      	<script type="text/javascript" src="js/soporte/mascara.js"></script>             
		<script type="text/javascript" src="js/credito/ObligadosSolidarios.js"></script>  
		<script src="js/sweet-alert.js"></script>
		

		    

	</head>
    <body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="obligadosSolidarios">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">	                
					<legend class="ui-widget ui-widget-header ui-corner-all">Alta de Obligados Solidarios</legend>
					<table border="0" width="100%">
						<tbody>
							<tr>
								<td class="label"> 
			         				<label for="oblSolidarioID">N&uacute;mero: </label> 
					   			</td>
					  			<td> 
					      			<form:input id="oblSolidarioID" name="oblSolidarioID" path="oblSolidarioID" size="12" tabindex="1" />  
					      			<td class="separador"></td>
					      			<td class="separador"></td>
					      			<td class="separador"></td>
					      			<td class="separador"></td>
					      			<td class="separador"></td>
					      			<td class="separador"></td>
					      			<td class="separador"></td>
					      			<td class="separador"></td>
					      			<td class="separador"></td>
					      			<td class="separador"></td>
					      			<td class="separador"></td>
					      			<td class="separador"></td>
					      			<td class="separador"></td>
					      			<td class="separador"></td>
					      			<td class="separador"></td>
					      			<td class="separador"></td>
					      			
					   			</td>
					   			
					   		</tr>					   		
						</tbody>						
					</table><br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Datos del Obligado Solidario</legend>
						<table border="0" width="100%">
							<tbody>
								<tr>	
				     				<td class="label">
										<label for="primerNombre">Primer Nombre:</label>
									</td>
									<td>
										<form:input id="primerNombre" name="primerNombre" path="primerNombre" maxlength="50" tabindex="4" onBlur=" ponerMayusculas(this)"/>
									</td>						   				
									<td class="separador"></td> 
					     			<td class="label">
										<label for="segundoNombre">Segundo Nombre: </label>
									</td>
									<td>
										<form:input id="segundoNombre" name="segundoNombre" path="segundoNombre"  maxlength="50" tabindex="5" onBlur=" ponerMayusculas(this)"/>
									</td>
								</tr>
								<tr>  
					     			<td class="label">
										<label for="tercerNombre">Tercer Nombre:</label>
									</td>
									<td>
										<form:input id="tercerNombre" name="tercerNombre" path="tercerNombre" maxlength="50" tabindex="6" onBlur=" ponerMayusculas(this)"/>
									</td>
									<td class="separador"></td> 
									<td class="label">
										<label for="apellidoPaterno">Apellido Paterno:</label>
									</td>
									<td>
										<form:input id="apellidoPaterno" name="apellidoPaterno" path="apellidoPaterno" maxlength="50" tabindex="7" onBlur=" ponerMayusculas(this)"/>
									</td>		
					 			</tr>
					 			<tr> 
					     			<td class="label">
										<label for="apellidoMaterno">Apellido Materno:</label>
									</td>
									<td>
										<form:input id="apellidoMaterno" name="apellidoMaterno" path="apellidoMaterno" maxlength="50" tabindex="8" onBlur=" ponerMayusculas(this)"/>
									</td>
									<td class="separador"></td> 
					     			<td class="label"> 
										<label for="tipoPersona">Tipo Persona: </label> 
									</td>
									<td class="label"> 
										<form:radiobutton id="tipoPersona" name="tipoPersona" path="tipoPersona" value="F" tabindex="9" checked="checked" />
										<label for="fisica">F&iacute;sica</label>&nbsp;&nbsp;
										<form:radiobutton id="tipoPersona3" name="tipoPersona3" path="tipoPersona" value="A" tabindex="10"/>
										<label for="fisica">F&iacute;sica Act Emp</label>
										<form:radiobutton id="tipoPersona2" name="tipoPersona2" path="tipoPersona" value="M" tabindex="11"/>
										<label for="fisica">Moral</label>
									</td>
								</tr>
								<tr>
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
									<td class="separador"></td>
									<td class="label">
										<label for="lugarNacimiento">Pa&iacute;s de Nacimiento:</label>
									</td>
									<td>
										<form:input id="lugarNacimiento" name="lugarNacimiento" path="lugarNacimiento" 
										 	size="5" tabindex="13"/>
										<input type="text" id="paisNac" name="paisNac" size="30" tabindex="13" disabled="true" readOnly="true"
											onBlur=" ponerMayusculas(this)"/>
									</td>
								</tr>
								<tr> 
									<td class="label">
										<label for="fechaNac"> Fecha de Nacimiento:</label>
									</td>
									<td>
										<form:input id="fechaNac" name="fechaNac" path="fechaNac" size="20" tabindex="14"  esCalendario="true" onBlur="calculaEdad(this.value)"/>
									</td>
									<td class="separador"></td>
					     			<td class="label">
										<label for="RFC"> RFC:</label>
									</td>
									<td>
										<form:input id="RFC" name="RFC" path="rFC" maxlength="13" tabindex="15" onBlur=" ponerMayusculas(this)"/>
										<input type ="button" id="generar" name="generar" value="Calcular" class="submit" style="display: none;"/>
									</td>
								</tr>
								<tr>
									<td class	="label">
										<label for="sexo">Sexo:</label>
									</td>
									<td>
										<form:select id="sexo" name="sexo" path="sexo"  tabindex="16">
											<form:option value="">SELECCIONAR</form:option> 
										    <form:option value="M">MASCULINO</form:option>
											<form:option value="F">FEMENINO</form:option>
										</form:select>
									</td>
									<td class="separador"></td>  
									<td class	="label">
										<label for="estadoCivil">Estado Civil:</label>
									</td>
									<td>
										<form:select id="estadoCivil" name="estadoCivil" path="estadoCivil"  tabindex="17">
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
										<label for="telefono">Tel&eacute;fono: </label>
									</td>
									<td >
										<form:input id="telefono" name="telefono" path="telefono" size="15" maxlength="13" tabindex="18"/>
										<label for="lblExt">Ext.:</label>
										<form:input type="text" id="extTelefonoPart" name="extTelefonoPart" path="extTelefonoPart" size="10" maxlength="6" tabindex="19" />
									</td>	
					 				<td class="separador"></td>
					 				<td class="label">
										<label id="lblRFCpm" for="rFCpm" style="display: none"> RFC Per. Moral:</label>
									</td>
									<td>
										<form:input id="rFCpm" name="rFCpm" path="rFCpm" maxlength="13" tabindex="20" onBlur=" ponerMayusculas(this)" style="display: none"/>
									</td>
								</tr>
					 			<tr>  
					     			<td class="label">
										<label for="telefonoCel">Tel&eacute;fono Celular: </label>
									</td>
									<td >
										<form:input id="telefonoCel" name="telefonoCel" path="telefonoCel" size="15" maxlength="13" tabindex="21"/>
									</td>
					     			<td class="separador"></td> 
					     			<td class="label">
										<label id="lblRazonSocial"  for="razonSocial">Raz&oacute;n Social: </label>
									</td>
									<td >
										<form:input id="razonSocial" name="razonSocial" path="razonSocial" maxlength="50" size= "35" tabindex="22" onBlur=" ponerMayusculas(this)"/>
									</td>
					     		</tr>
					     			<tr>
					     			<td class="label"> 
							      			<label for="estadoID">Entidad Federativa: </label> 
							   		</td> 
							    	<td> 
							      		<form:input type="text" id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="23" /> 
							      		<input type="text" id="nombreEstado" name="nombreEstado" size="35" tabindex="24" disabled ="true" readOnly="true"/>   
							    	</td> 
					 				<td class="separador"></td> 
					     			<td class="label"> 
			        					<label for="municipioID">Municipio: </label> 
			     					</td> 
							    	<td> 
							        	<form:input type="text" id="municipioID" name="municipioID" path="municipioID" size="6" tabindex="25" /> 
							        	<input type="text" id="nombreMuni" name="nombreMuni" size="35" tabindex="26" disabled="true" readOnly="true"/>   
							    	</td> 		
					     		</tr>
					     		<tr>
								   	<td class="label"> 
								    	<label for="localidadID">Localidad: </label> 
								    </td> 
								    <td> 
								       <form:input type="text" id="localidadID" name="localidadID" path="localidadID" size="6" tabindex="27" /> 
								       <input type="text" id="nombreLocalidad" name="nombrelocalidad" size="35" tabindex="28" disabled ="true"
								        	readOnly="true"/>   
								    </td> 
									<td class="separador"></td> 
								   	<td class="label"> 
										<label for="coloniaID">Colonia: </label> 
									</td> 
								    <td> 
								    	<form:input type="text" id="coloniaID" name="coloniaID" path="coloniaID" size="6" tabindex="29" /> 
								        <input type="text" id="colonia" name="colonia" path="colonia" size="35" tabindex="30" disabled="true"
								        	readOnly="true"/>   
								   	</td> 		
								</tr>
					     		<tr>
					     			<td class="label"> 
			          					<label for="calle">Calle: </label> 
			     					</td> 
			     					<td> 
			        					<form:input id="calle" name="calle" path="calle" maxlength="50" size="45" tabindex="31" onBlur=" ponerMayusculas(this)"/> 
			     					</td>
			     					<td class="separador"></td>
			     					<td class="label"> 
			        					<label for="numExterior">No. Exterior: </label> 
			     					</td> 
			     					<td> 
			        					<form:input id="numExterior" name="numExterior" path="numExterior" maxlength="10" size="5" tabindex="32" />
			        				</td> 		 
					     		</tr>	
			     				<tr>
			     					<td class="label"> 
			          					<label for="numInterior">No. Interior: </label>
			          				</td>
			          				<td>
							       		<form:input id="numInterior" name="numInterior" path="numInterior" maxlength="10" size="5" tabindex="33" />
			     					</td>
			     					<td class="separador"></td>
			     					<td class="label"> 
							       		<label for="CP">C.P: </label> 
							    	</td> 
							    	<td> 
							       		<form:input id="CP" name="CP" path="cP" maxlength="5" size="15" tabindex="34" /> 
							    	</td>
								</tr>  	   
					 			<tr>
					     			<td class="label"> 
										<label for="lote">Lote: </label> 
									</td> 
									<td> 
						     			<form:input id="lote" name="lote" path="lote" size="20" maxlength="20" tabindex="35" onBlur=" ponerMayusculas(this)"/> 
						    		</td>
						 			<td class="separador"></td>	
					     			<td class="label"> 
			        					<label for="manzana">Manzana: </label> 
			     					</td> 
			    					<td> 
			         					<form:input id="manzana" name="manzana" path="manzana" size="20" maxlength="20" tabindex="36" onBlur=" ponerMayusculas(this)"/> 
			    			 		</td>
								</tr>
								<tr>
								    <td class="label"> 
								    	<label for="latitud">Latitud: </label> 
								  		</td> 
								  		<td> 
								    		<form:input id="latitud" name="latitud" path="latitud" maxlength="45" size="20" tabindex="37" /> 
								  		</td> 
						     			<td class="separador"></td> 
						     			<td class="label"> 
									 		<label for="longitud">Longitud: </label> 
								  		</td> 
								  		<td> 
								  			<form:input id="longitud" name="longitud" path="longitud" maxlength="45" size="20" tabindex="38" /> 
								  	</td> 
								</tr>
								
							</tbody>
						</table>
					</fieldset> 
					<br>
					<div id="personaFisica">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">		
						<legend>Persona F&iacute;sica</legend>
						<table border="0" width="100%">Datos Laborales
						</br>
							<tbody>
							<tr>
									<td class="label">
										<label for="ocupacionID">Ocupación:</label>
									</td>

									<td>
										<form:input type="text" id="ocupacionID" name="ocupacionID" path="ocupacionID" autocomplete="off" size="6" tabindex="39" />
										<form:input type="text" id="ocupacion" name="ocupacion" path="ocupacion" size="35" tabindex="24" disabled="true" readOnly="true" />
									</td>

									<td class="separador"></td>

									<td class="label">
										<label for="puesto">Puesto:</label>
									</td>

									<td>
										<form:input id="puesto" name="puesto" path="puesto" maxlength="100" size="45" onBlur="ponerMayusculas(this)" tabindex="40" />
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="domicilioTrabajo">Dirección:</label>
									</td>

									<td>
										<form:input id="domicilioTrabajo" name="domicilioTrabajo" path="domicilioTrabajo" maxlength="500" size="45" onBlur="ponerMayusculas(this)" tabindex="41" />
									</td>

									<td class="separador"></td>

									<td class="label">
										<label for="telefonoTrabajo">Teléfono:</label>
									</td>

									<td>
										<form:input id="telefonoTrabajo" name="telefonoTrabajo" path="telefonoTrabajo" maxlength="13" size="15" tabindex="42" />
										<label for="extTelTrabajo">Extensión:</label>
										<form:input id="extTelTrabajo" name="extTelTrabajo" path="extTelTrabajo" maxlength="4" size="10" tabindex="43" />
									</td>
								</tr>
							</tbody>
						</table>
						</fieldset>
					</div>
					<div id="personaMoral"  style="display:none">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend>Escritura P&uacute;blica</legend>
							<table border="0" width="100%">
								<tbody>									
							     	<tr> 
							      		<td class="label"> 
							         		<label for="esc_Tipo">Tipo de Acta: </label> 
							     		</td> 
							     		<td> 
							        		<form:select id="esc_Tipo" name="esc_Tipo" path="esc_Tipo" tabindex="44" >
												<form:option value="-1">SELECCIONAR</form:option>
												<form:option value="C">CONSTITUTIVA</form:option>
												<form:option value="P">DE PODERES</form:option> 
											</form:select>
							     		</td> 
							          	<td class="separador"></td> 
							          	<td class="label"> 
							         		<label for="escrituraPub">Escritura P&uacute;blica: </label> 
							     		</td> 
							     		<td> 
							         		<form:input id="escrituraPub" name="escrituraPub" path="escrituraPub" size="15" tabindex="45" maxlength="50" onkeyPress="soloLetrasYNum(this.id, this.value)" onBlur=" ponerMayusculas(this)" /> 											
							     		</td> 
						       		 </tr>   
							        <tr> 
								     	<td class="label"> 
								        	<label for="libroEscritura">Libro: </label> 
								     	</td> 
								     	<td> 
								        	<form:input id="libroEscritura" name="libroEscritura" path="libroEscritura" size="15" tabindex="46" maxlength="50" onkeyPress="soloLetrasYNum(this.id, this.value)" onBlur=" ponerMayusculas(this)" /> 
								     	</td> 
								        <td class="separador"></td> 
										<td class="label"> 
								        	<label for="volumenEsc">Volumen: </label> 
								     	</td> 
								     	<td> 
								        	<form:input id="volumenEsc" name="volumenEsc" path="volumenEsc" size="15" tabindex="47" maxlength="20" onkeyPress="soloLetrasYNum(this.id, this.value)" onBlur=" ponerMayusculas(this)"/> 
								     	</td> 
							 		</tr> 
							 		<tr> 
							    		<td class="label"> 
							       			<label for="fechaEsc">Fecha: </label> 
							     		</td> 
							     		<td> 
							         		<form:input id="fechaEsc" name="fechaEsc" path="fechaEsc" size="15" tabindex="48" esCalendario="true"/> 
							    		 </td> 
							          	<td class="separador"></td> 
										<td class="label" nowrap="nowrap"> 
							         		<label for="estadoIDEsc">Entidad Federativa: </label> 
							     		</td> 
							     		<td> 
							         		<form:input id="estadoIDEsc" name="estadoIDEsc" path="estadoIDEsc" size="7" tabindex="49" /> 
							         		<input type="text" id="nombreEstadoEsc" name="nombreEstadoEsc" size="35"  disabled="true" readOnly="true"/>   
							     		</td>  
							 		</tr> 
									<tr>
										<td class="label"> 
							         		<label for="localidadEsc">Localidad: </label> 
							     		</td> 
							     		<td> 
									        <form:input id="localidadEsc" name="localidadEsc" path="localidadEsc" size="6" tabindex="50" /> 
									        <input type="text" id="nombreMuniEsc" name="nombreMuniEsc" size="35"  disabled="true"
									          readOnly="true"/>   
							     		</td>  
							     		<td class="separador"></td> 
									    <td class="label"> 
									        <label for="notaria">Notaria: </label> 
									    </td> 
									    <td> 
									        <form:input id="notaria" name="notaria" path="notaria" size="7" tabindex="51" /> 
									    </td> 
								 	</tr> 
									<tr> 
								    	<td class="label" nowrap="nowrap"> 
								       		<label for="direcNotaria">Direcci&oacute;n de Notaria: </label> 
								    	</td> 
								    	<td> 
								       		<form:input id="direcNotaria" name="direcNotaria" path="direcNotaria" size="60" 
								       			readOnly="true" /> 
								    	</td> 
									     <td class="separador"></td>
									     <td class="label" nowrap="nowrap" 	> 
									         <label for="nomNotario">Nombre del Notario: </label> 
									     </td> 
									     <td> 
									         <form:input id="nomNotario" name="nomNotario" path="nomNotario" size="45" readOnly="true" /> 
									     </td> 
									</tr>  
							 	</tbody>
							 </table>
						</fieldset>
						<br>

						<div id= "apoderados" style="display:none"> 
							<fieldset class="ui-widget ui-widget-content ui-corner-all">		
							<legend>Información Apoderados</legend>	
								<table border="0" width="100%"> 		
							 		<tr> 
							      		<td class="label"> 
							        		<label for="nomApoderado">Nombre del Apoderado: </label> 
							     		</td> 
							    		<td> 
							         		<form:input id="nomApoderado" name="nomApoderado" path="nomApoderado" size="55" maxlength="150"
								          		tabindex="52" onBlur=" ponerMayusculas(this)" /> 
							    	 	</td> 
										<td class="separador"></td> 
							     		<td class="label"> 
							         		<label for="RFC_Apoderado">RFC del Apoderado: </label> 
							     		</td> 
									    <td> 
									         <form:input id="RFC_Apoderado" name="RFC_Apoderado" path="RFC_Apoderado" size="15" tabindex="53" maxlength="12"
									         onBlur=" ponerMayusculas(this)"/> 
									    </td> 
							 		</tr> 							 		
							 	</table>
							</fieldset>
						</div>	
						<fieldset class="ui-widget ui-widget-content ui-corner-all">	
							<legend>Registro P&uacute;blico</legend>	
							<table border="0" width="100%"> 		
								<tr> 
									<td class="label"> 
							        	<label for="registroPub">Registro P&uacute;blico: </label> 
							     	</td> 
							     	<td> 
							         	<form:input id="registroPub" name="registroPub" path="registroPub" size="15" tabindex="54" onkeyPress="soloLetrasYNum(this.id, this.value)" onBlur=" ponerMayusculas(this)" maxlength="10"/> 
							     	</td> 
									<td class="separador"></td> 
							     	<td class="label"> 
										<label for="folioRegPub">Folio: </label> 
							     	</td> 
							     	<td> 
							         	<form:input id="folioRegPub" name="folioRegPub" path="folioRegPub" size="15" tabindex="55" maxlength="10" onBlur=" ponerMayusculas(this)"/> 
							     	</td> 
							    </tr>  
							    <tr> 
									<td class="label"> 
							       		<label for="volumenRegPub">Volumen: </label> 
							     	</td> 
							     	<td> 
							        	<form:input id="volumenRegPub" name="volumenRegPub" path="volumenRegPub" size="15" tabindex="56" maxlength="20" onkeyPress="soloLetrasYNum(this.id, this.value)" onBlur=" ponerMayusculas(this)"/> 
							     	</td> 
									<td class="separador"></td>
							     	<td class="label"> 
							        	<label for="libroRegPub">Libro: </label> 
							     	</td> 
							     	<td>  
							        	<form:input id="libroRegPub" name="libroRegPub" path="libroRegPub" size="15" tabindex="57" maxlength="10" onkeyPress="soloLetrasYNum(this.id, this.value)" onBlur=" ponerMayusculas(this)"/> 
							     	</td> 
							   	</tr> 
								<tr> 
									<td class="label"> 
							         	<label for="auxiliarRegPub">Auxiliar: </label> 
							     	</td> 
							     	<td>  
							        	<form:input id="auxiliarRegPub" name="auxiliarRegPub" path="auxiliarRegPub" size="15" tabindex="58" maxlength="20" onkeyPress="soloLetrasYNum(this.id, this.value)" onBlur=" ponerMayusculas(this)" /> 
							     	</td>
									<td class="separador"></td> 
							     	<td class="label"> 
								        <label for="fechaRegPub">Fecha: </label> 
							     	</td>  
								    <td> 
								        <form:input id="fechaRegPub" name="fechaRegPub" path="fechaRegPub" size="15" tabindex="59" 
								        	esCalendario="true"/> 
								    </td>      
								</tr> 
								<tr>
										<td class="label"> 
								         <label for="estadoIDReg">Entidad Federativa: </label> 
								     </td> 
								     <td> 
								         <form:input id="estadoIDReg" name="estadoIDReg" path="estadoIDReg" size="7" tabindex="60" /> 
								         <input type="text" id="nombreEstadoReg" name="nombreEstadoReg" size="35" disabled="true"
								          readOnly="true"/>   
								     </td>  	
									<td class="separador"></td>	
									<td class="label"> 
								        <label for="localidadRegPub">Localidad: </label> 
								     </td> 
								     <td>
								     	<form:input id="localidadRegPub" name="localidadRegPub" path="localidadRegPub" size="7" tabindex="61" /> 
								     	<input type="text" id="nombreMuniReg" name="nombreMuniReg" size="40" disabled="true"
								          readOnly="true"/>   
								    </td>  
								</tr> 
							</table>
						</fieldset>
					</div>						
					<table width="100%">
						<tbody>
		     				<tr>
								<td colspan="5" align="right"> 
									<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="62"/>
									<input type="submit" id="modifica" name="modifica" class="submit"  value="Modificar" tabindex="63"/>
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
									<input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>"/>
								</td>
							</tr>
						</tbody>
					</table>
					</fieldset>
			</form:form>
		</div>	
		
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>
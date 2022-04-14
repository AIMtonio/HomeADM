<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/seguimientoPersonaListaServicio.js"></script>
		<script type="text/javascript" src="js/pld/seguimientoPersonaLista.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="seguimientoPersonaListaBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Seguimiento de Personas en Listas</legend>
					<table border="0">
					<tr>
						<td class="label">
							<label for="opeInusualID">Folio: </label>
						</td>
						<td>
							<input type="text" id="opeInusualID" name="opeInusualID" size="15" tabindex="1"/>
							<input type="hidden" id="copyOpeInusualID" name="copyOpeInusualID" size="15"/>
						</td>
						<td class="separador"></td>
			
						<td class="label">
							
						</td>
					  	<td nowrap="nowrap">
							
						</td>
						<td nowrap="nowrap">
							
						</td>
					</tr>
					</table>
					<br/>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend><label>Datos Generales</label></legend>         
          				<table>							
							<tr>		
								<td class="label" nowrap= "nowrap"> 
						        	<label for="tipoPersona">Tipo de Persona: </label> 
						    	</td> 
						    	<td nowrap= "nowrap">  
						    		<input type="text" id="tipoPersona" name="tipoPersona" size="30" tabindex="2" readonly="readonly" disabled="disabled"/>  
						 		</td>	
						    	<td class="separador"></td>
						   		<td nowrap= "nowrap">    
						 		 </td>
						 		 <td nowrap= "nowrap">    
						 		 </td>		
							<tr>
							<tr>
								<td class="label" nowrap= "nowrap"> 
						        	<label for="numRegistro">N&uacute;mero de registro: </label> 
						    	</td> 
						    	<td nowrap= "nowrap">  
						    		<input type="text" id="numRegistro" name="numRegistro" size="30" tabindex="3" readonly="readonly" disabled="disabled"/>  
						 		</td>
								<td class="separador"></td>
						   		<td nowrap= "nowrap">
						   			<label for="nombre">Nombre:</label>  
						 		</td>
						 		 <td nowrap= "nowrap">  
						 		 	<input type="text" id="nombre" name="nombre" size="30" tabindex="4" readonly="readonly" disabled="disabled"/>  
						 		 </td>
							</tr>
							<tr>
								<td class="label" nowrap= "nowrap">
									<label for="fechaDeteccion">Fecha Detecci&oacute;n</label>
								</td>
								<td nowrap= "nowrap">
									<input type="text" id="fechaDeteccion" name="fechaDeteccion" size="30" tabindex="5" readonly="readonly" disabled="disabled"/>
								</td>
								<td class="separador"></td>
								<td class="label" nowrap= "nowrap">
									<label for="listaDeteccion">Lista Detecci&oacute;n</label>
								</td>
								<td nowrap= "nowrap">
									<input type="text" id="listaDeteccion" name="listaDeteccion" size="30" tabindex="6" readonly="readonly" disabled="disabled"/>
								</td>
							</tr>
						</table>
						
					</fieldset>
					<br/>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend><label>Datos Detecci&oacute;n</label></legend>         
          				<table>							
							<tr>		
								<td class="label" nowrap= "nowrap"> 
						        	<label for="nombreDet">Nombres: </label> 
						    	</td> 
						    	<td nowrap= "nowrap">  
						    		<input type="text" id="nombreDet" name="nombreDet" size="30" tabindex="7" readonly="readonly" disabled="disabled"/>  
						 		</td>	
						    	<td class="separador"></td>
						   		<td class="label" nowrap= "nowrap"> 
						        	<label for="apellidoDet">Apellidos: </label> 
						    	</td>
						 		 <td nowrap= "nowrap"> 
						 		 	<input type="text" id="apellidoDet" name="apellidoDet" size="30" tabindex="8" readonly="readonly" disabled="disabled"/>   
						 		 </td>		
							<tr>
							<tr>
								<td class="label" nowrap= "nowrap"> 
						        	<label for="fechaNacimientoDet">Fecha de Nac.: </label> 
						    	</td> 
						    	<td nowrap= "nowrap">  
						    		<input type="text" id="fechaNacimientoDet" name="fechaNacimientoDet" size="30" tabindex="9" readonly="readonly" disabled="disabled"/>  
						 		</td>
								<td class="separador"></td>
						   		<td nowrap= "nowrap">
						   			<label for="rfcDet">RFC:</label>  
						 		</td>
						 		 <td nowrap= "nowrap">  
						 		 	<input type="text" id="rfcDet" name="rfcDet" size="30" tabindex="10" readonly="readonly" disabled="disabled"/>  
						 		 </td>
							</tr>
							<tr>
								<td class="label" nowrap= "nowrap">
									<label for="paisDetID">Pa&iacute;s de Nac.:</label>
								</td>
								<td nowrap= "nowrap">
									<input type="text" id="paisDetID" name="paisID" size="5" tabindex="11" readonly="readonly" disabled="disabled"/>
									<input type="text" id="nombrePaisDet" name="nombrePaisDet" size="30" readonly="readonly" disabled="disabled"/>
								</td>
								<td class="separador"></td>
								<td class="label" nowrap= "nowrap">
									
								</td>
								<td nowrap= "nowrap">
									
								</td>
							</tr>
							<tr>
								<td class="label" nowrap= "nowrap">
									<label >Permite Operaci&oacute;n:</label>
								</td>
								<td nowrap= "nowrap">
									<input type="radio" id="permiteSI" name="permiteOperacion" value="S" tabindex="12" />
									<label for="permiteSI">SI</label>&nbsp;&nbsp;
									<input type="radio" id="permiteNO" name="permiteOperacion" value="N" tabindex="12" checked="checked" />
									<label for="permiteNO">NO</label>
								</td>
								<td class="separador"></td>
								<td class="label" nowrap= "nowrap">
									
								</td>
								<td nowrap= "nowrap">
									
								</td>
							</tr>
							<tr>
								<td class="label" nowrap= "nowrap">
									<label for="comentario">Comentarios:</label>
								</td>
								<td nowrap= "nowrap">
									<textarea id="comentario" name="comentario" rows="3" cols="35" tabindex="13" maxlength="400" onblur="ponerMayusculas(this); limpiarCajaTexto(this.id)"></textarea>
								</td>
								<td class="separador"></td>
								<td class="label" nowrap= "nowrap">
									
								</td>
								<td nowrap= "nowrap">
									
								</td>
							</tr>
						</table>
					</fieldset>
					<br/>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend><label>Informaci&oacute;n de Coincidencia</label></legend>         
          				<table>	
          					<tr>
								<td class="label" nowrap= "nowrap">
									<label for="listaID">ID:</label>
								</td>
								<td nowrap= "nowrap">
									<input type="text" id="listaID" name="listaID" size="30" tabindex="14" readonly="readonly" disabled="disabled"/>
								</td>
								<td class="separador"></td>
								<td class="label" nowrap= "nowrap">
									<label for="tipoLista">Tipo de Lista:</label>
								</td>
								<td nowrap= "nowrap">
									<input type="text" id="tipoLista" name="tipoLista" size="30" tabindex="15" readonly="readonly" disabled="disabled"/>
								</td>
							</tr>
							<tr>
								<td class="label" nowrap= "nowrap">
									<label for="nombreCompleto">Nombre Completo:</label>
								</td>
								<td nowrap= "nowrap">
									<input type="text" id="nombreCompleto" name="nombreCompleto" size="30" tabindex="16" readonly="readonly" disabled="disabled"/>
								</td>
								<td class="separador"></td>
								<td class="label" nowrap= "nowrap"> 
						        	<label for="fechaNacimientoCon">Fecha de Nac.: </label> 
						    	</td> 
						    	<td nowrap= "nowrap">  
						    		<input type="text" id="fechaNacimientoCon" name="fechaNacimientoCon" size="30" tabindex="17" readonly="readonly" disabled="disabled"/>  
						 		</td>
							</tr>
							<tr>
								<td class="label" nowrap= "nowrap">
									<label for="paisConID">Pa&iacute;s de Nac.:</label>
								</td>
								<td nowrap= "nowrap">
									<input type="text" id="paisConID" name="paisID" size="5" tabindex="18" readonly="readonly" disabled="disabled"/>
									<input type="text" id="nombrePaisCon" name="nombrePaisCon" size="30" readonly="readonly" disabled="disabled"/>
								</td>
								<td class="separador"></td>
								<td class="label" nowrap= "nowrap"> 
						        	<label id="lblEstado" for="estadoConID">Estado de Nac.: </label> 
						    	</td> 
						    	<td nowrap= "nowrap">  
						    		<input type="text" id="estadoConID" name="estadoConID" size="5" tabindex="19" readonly="readonly" disabled="disabled"/>
									<input type="text" id="nombreEstadoCon" name="nombreEstadoCon" size="30" readonly="readonly" disabled="disabled"/>  
						 		</td>
							</tr>
							<tr>
								<td class="label" nowrap= "nowrap">
									<label for="razonSocial">Raz&oacute;n Social:</label>
								</td>
								<td nowrap= "nowrap">
									<input type="text" id="razonSocial" name="razonSocial" size="30" tabindex="20" readonly="readonly" disabled="disabled"/>
								</td>
								<td class="separador"></td>
								<td class="label" nowrap= "nowrap"> 
						        	<label for="rfcCon">RFC:</label> 
						    	</td> 
						    	<td nowrap= "nowrap">  
						    		<input type="text" id="rfcCon" name="rfcCon" size="30" tabindex="21" readonly="readonly" disabled="disabled"/>
						 		</td>
							</tr>
          				</table>
          			</fieldset>
          			<table width="100%">
						<tr>
							<td align="right">
								<input type="submit" id="agrega" name="agrega" class="submit" value="Grabar"  tabindex="22"/>
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
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>
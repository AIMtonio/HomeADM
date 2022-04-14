<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
     <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>  
     <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>       
     <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>    
     <script type="text/javascript" src="dwr/interface/protectAhoCredServicio.js"></script>  
     <script type="text/javascript" src="dwr/interface/clienteArchivosServicio.js"></script>
     <script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
     <script type="text/javascript" src="dwr/interface/parametrosCajaServicio.js"></script>      
	 <script type="text/javascript" src="dwr/interface/clientesCancelaServicio.js"></script>
	 <script type="text/javascript" src="dwr/interface/parametrosCajaServicio.js"></script>
              
     <script type="text/javascript" src="js/cliente/proteccionAhoCred.js"></script>     
</head>
<body>
<input type="hidden" id="tipoCliente" value="<s:message code="safilocale.cliente"/>" />
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cliAProtecCuenBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Protecci&oacute;n Ahorro y Cr&eacute;dito</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>			   
	     	<td class="label" > <label for="clienteID"><s:message code="safilocale.cliente"/>: </label> </td>			
	     	<td> 
	        	<input  type="text" id="clienteID" name="clienteID" size="12"  tabindex="1" autocomplete="off" />
	        	<input  type="text"  id="nombreCliente" name="nombreCliente"size="50"  readonly="readonly" disabled="disabled" tabindex="2"/>
	     	</td> 		
	     	<td class="separador"></td>	     	
	     	<td class="label" > <label for="fechaNacimiento">Fecha Nacimiento: </label> </td>			
	     	<td> 
	        	<input  type="text" id="fechaNacimiento" name="fechaNacimiento" size="30"  readonly="readonly" disabled="disabled" tabindex="3"/>	        	
	     	</td>
		</tr>
<!-- 		<tr> -->
<!-- 			<td><input type ="button" id="buscarMiSuc" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/></td> -->
<!-- 			<td><input type ="button" id="buscarGeneral" name="buscarGeneral" value="Busqueda General" class="submit"/></td>		 -->
<!-- 		</tr> -->
		<tr>	
			<td class="label" > <label for="fechaIngreso">Fecha Ingreso: </label> </td>			
	     	<td> 
	        	<input  type="text" id="fechaIngreso" name="fechaIngreso" size="12"  readonly="readonly" disabled="disabled" tabindex="4"/>	        	
	     	</td> 		
	     		<td class="separador"></td>	   
	     	<td class="label" > <label for="edad">Edad: </label> </td>			
	     	<td> 
	        	<input  type="text" id="edad" name="edad" size="12"  readonly="readonly" disabled="disabled"/>
	        	 <label for="edadCliente">Año(s)</label> 	        	
	     	</td> 		
	     		      		     	
		</tr>
		<tr>			   
	     	<td class="label" > <label for="promotorID">Promotor: </label> </td>			
	     	<td> 
	        	<input  type="text" id="promotorID" name="promotorID" size="12" readonly="readonly" disabled="disabled" tabindex="6" />	        	
	        	<input type="text" id="nombrePromotor" name="nombrePromotor"size="50"   readonly="readonly"  disabled="disabled" tabindex="7"/>
	     	</td> 	
	     	<td class="separador"></td>	
	     	<td class="label" > <label for="tipoPersona">Tipo de Persona: </label> </td>			
	     	<td> 
	        	<input  type="text" id="tipoPersona" name="tipoPersona" size="30"    readonly="readonly" disabled="disabled" tabindex="5"/>	        	
	     	</td> 		     		     		     	
		</tr>
		<tr>
	     	<td class="label" > <label for="sucursalOrigen">Sucursal: </label> </td>			
	     	<td> 
	        	<input  type="text" id="sucursalOrigen" name="sucursalOrigen" size="12"   readonly="readonly" disabled="disabled" tabindex="8"/>	        	
	        	<input type="text" id="nombreSucursal" name="nombreSucursal"size="50"   readonly="readonly" disabled="disabled" tabindex="9"/>
	     	</td> 	     				   
	     	<td> </td>			
	     	<td> </td> 	
	     	<td class="separador"></td>			     		     		     	
		</tr>			
	</table>
	<br>
	<div id="divProteccion">
	 	<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Solicitud</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>								   
			     	<td class="label" > <label for="actaDefuncion">Acta Defunción: </label> </td>			
			     	<td> 
			        	<input  type="text" id="actaDefuncion" name="actaDefuncion" size="40"  onblur="ponerMayusculas(this)" disabled="disabled" readonly="readonly"
			        		tabindex="10"   maxlength="100"/>	        						        	
			     	</td> 	
			     	<td class="separador"></td>	
			     	<td class="label" > <label for="fechaDefuncion">Fecha Defunción: </label> </td>			
			     	<td> 
			        	<input  type="text" id="fechaDefuncion" name="fechaDefuncion" size="15" disabled="disabled" readonly="readonly" tabindex="11"  />	        		        	
			     	</td> 		     		     		     	
				</tr>
				<tr>								   
			     	<td class="label" > <label for="montoMaximoProtec">Monto Máximo Protección: </label> </td>			
			     	<td> 
			        	<input  type="text" id="montoMaximoProtec" name="montoMaximoProtec" size="15"  style="text-align: right" esMoneda="true"
			        		tabindex="12" readonly="readonly" disabled="disabled" />	        						        	
			     	</td> 	
			     	<td class="separador"></td>					     	
				</tr>
				
				<tr id="trProteccion" style="display:none">								   
			     	<td class="label" > <label for="usuarioReg">Usuario Registro: </label> </td>			
			     	<td> 
			        	<input  type="text" id="usuarioReg" name="usuarioReg" size="12"  readonly="readonly" disabled="disabled" tabindex="13"/>	        	
			        	<input type="text" id="nombreUsuarioReg" name="nombreUsuarioReg"size="50"    readonly="readonly" disabled="disabled" tabindex="14"/>
			     	</td> 	
			     	<td class="separador"></td>	
			     	<td class="label" > <label for="fechaRegistro">Fecha Registro: </label> </td>			
			     	<td> 
			        	<input  type="text" id="fechaRegistro" name="fechaRegistro" size="15"   readonly="readonly" disabled="disabled" tabindex="15" />	        		        	
			     	</td> 		     		     		     	
				</tr>
				<tr id="estatusProteccion" style="display:none">			   
			     	<td class="label" > <label for="estatus">Estatus Protección: </label> </td>			
			     	<td> 	
			        	<select id="estatus" name="estatus" path="estatus"  tabindex="16" disabled="true">
							<option value="R">REGISTRADA</option>
					     	<option value="C">RECHAZADA</option>
					     	<option value="P">PAGADA</option>
					     	<option value="A">AUTORIZADA</option>
			        	</select>
			     	</td> 	
			     	<td class="separador"></td>					     		     		     		     
				</tr>
																									
			</table>						
		 </fieldset>
	</div>
	<div id="gridCredCte" style="display: none;"></div>
	<div id="gridAhoCte"  style="display: none;"></div>	
	<br>
	<div id="divAutoriza" style="display:none">
	 	<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Autorizar</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label" nowrap="nowrap">
						<input  type="radio" id="autorizar" name="proceso"  value="A"  checked="checked" tabindex="17"/>
						<label for="autorizar">Autorizar</label>																		
					</td>
					<td class="label" nowrap="nowrap">
						<input type="radio"  id="rechazar" name="proceso" value="C" tabindex="18"/>
						<label for="rechazar">Rechazar</label>																								
					</td>							
				</tr>
				<tr>
					<td class="label" nowrap="nowrap"><label for="comentario">Comentario:</label></td>
					<td>
						<textarea   id="comentario" name="comentario" onblur="ponerMayusculas(this)" rows="3" cols="50"   tabindex="21" 
							maxlength="300"/></textarea>
					</td>
				</tr>															
				<tr>
					<td align="right" colspan="10">													
					<input type="submit" id="guardarAutorizaRechaza" name="guardarAutorizaRechaza" class="submit" value="Guardar"  tabindex="22"/>																			
					</td>
			</tr>
			</table>						
		 </fieldset>
	</div>
	<div id="divArchivosCli">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fielSetArchivosCliente" style="display: none;">
		<legend>Archivos <s:message code="safilocale.cliente"/></legend>								
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>
						<div id="gridArchivosCliente" style="display: none;"></div>
					</td>
				</tr>
				<tr>
					<td style="text-align: right;">
						<input type="button" style='height:30px;' id="adjuntar" name="adjuntar" class="submit" value="Adjuntar"  tabindex="23"/>
					</td>
				</tr>
			</table>	
	 </fieldset>		 
	 <table style="text-align: right;">
		<tr>
			<td>
				 <div id="imagenCte" style="display: none;">
				 	<img id= "imgCliente" SRC="images/user.jpg" WIDTH="100%" HEIGHT="100%" border ="0" alt="Foto cliente"/> 
				</div> 
	       </td> 
		</tr>
	</table>	
	</div>
	<table width="100%">
		<tr>
			<td align="right">
				<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar"  tabindex="24"/>						
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="tipoActualizacion" name="tipoActualizacion" value="0"/>
				<input type="hidden" id="listaCreditos" name="listaCreditos" size="40"  />
				<input type="hidden" id="listaCuentas" name="listaCuentas" size="40"   />			
			 	<input type="hidden" id="usuarioAut" name="usuarioAut" size="40"  />
				<input type="hidden" id="tipoDocumento" name="tipoDocumento" size="40" value = "52" />
				<input type="hidden" id="prospectoID" name="prospectoID" size="40" />		
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
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>  
	<script type="text/javascript" src="dwr/interface/clientesPROFUNServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>   
	<script type="text/javascript" src="dwr/interface/cliAplicaPROFUNServicio.js"></script>  
	<script type="text/javascript" src="dwr/interface/clienteArchivosServicio.js"></script>  
	<script type="text/javascript" src="dwr/interface/tiposDocumentosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>    
	<script type="text/javascript" src="dwr/interface/parametrosCajaServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/clientesCancelaServicio.js"></script>
	<script type="text/javascript" src="js/cliente/cliAplicaPROFUN.js"></script>    
	<script type="text/javascript" src="js/cliente/clientePROFUNArchivosAdjunta.js"></script>
</head>
<body>
<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cliAplicaPROFUN">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">  
		<legend class="ui-widget ui-widget-header ui-corner-all">Solicitud PROFUN (Protecci&oacute;n Funeraria)</legend>
		<table>
			<tr>
				<td class="label">
					<label for="clienteID"><s:message code="safilocale.cliente"/>:</label>
				</td>
				<td>
					<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="1"/>
					<input type="text" id="nombreCliente" name="nombreCliente" size="50" tabindex="2" disabled= "true" readOnly="true" />
				</td>
				<td class="separador"></td>
				  <td class="label">
					<label for="fechaRegistro">Fecha de Registro:</label>
				</td>
				<td>
					<form:input type="text" id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="12" tabindex="3" disabled ="true"/>
				</td>	
			</tr>
<!-- 			<tr> -->
<!-- 				<td><input type ="button" id="buscarMiSuc" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/></td> -->
<!-- 				<td><input type ="button" id="buscarGeneral" name="buscarGeneral" value="Busqueda General" class="submit"/></td>			 -->
<!-- 			</tr> -->
			
			
			<tr>
				<td class="label">
				   <label for="usuarioReg">Usuario:</label>
				</td>
				<td>
					<form:input type="text" id="usuarioReg" name="usuarioReg" path="UsuarioReg" size="12" tabindex="4" disabled ="true"/>
					<input type="text" id="nombreUsuario" name="nombreUsuario" size="50" tabindex="5" disabled="true" readOnly="true"/>
				</td>
				<td class="separador"></td>	
				<td class="label">
					<label for="estatus">Estatus PROFUN:</label>
				</td>
				<td>
					<select id="estatusClientePro" name="estatusClientePro"   tabindex="6" disabled="true">
						<option value="R">REGISTRADO</option>
						<option value="A">AUTORIZADO</option>
				     	<option value="C">CANCELADO</option>
				     	<option value="E">RECHAZADO</option>
				     	<option value="I">INACTIVO</option>
				     	<option value="P">PAGADO</option>
			        </select>
				</td>					
			</tr>	
			<tr>
				<td class="label"> 
	    			<label for="comentario">Comentario: </label> 
				</td>
				<td nowrap="nowrap">
					<form:textarea id="comentario" name="comentario" path="comentario" COLS="48" ROWS="3" tabindex="7"  
						onBlur=" ponerMayusculas(this)" maxlength ="250"/> 
				</td>  	
				<td class="separador"></td>	
		  		<td class="label">
					<label for="lbltipoPersona">Tipo de Persona:</label>
				</td>
				<td>
					<input type="text" id="tipoPersonaID" name="tipoPersonaID"  size="30" tabindex="8" disabled="true"/>
				</td>				
			</tr>	
			<tr>
		 		<td class="label">
			   		<label for="lblfechaIngreso">Fecha de Ingreso:</label>
				</td>
				 <td>
					<input type="text" id="fechaIngresoID" name="fechaIngresoID"  size="12" tabindex="9" disabled ="true" />
				</td>
				<td class="separador"></td>	
				<td class="label">
					<label for="lblfechaNacimiento">Fecha de Nacimiento:</label>
				</td>
				<td>
					<input type="text" id="fechaNacimientoID" name="fechaNacimientoID"  size="12" tabindex="10" disabled="true"/>
				</td>					
			</tr>
			<tr>
		 		<td class="label">
			   		<label for="lblpromotor">Promotor:</label>
				</td>
				<td>
					<input type="text" id="promotorID" name="promotorID" size="12" tabindex="11" disabled ="true" />
					<input type="text" id="nombrePromotorID" name="nombrePromotorID" size="50" tabindex="12" disabled="true" readOnly="true"/>
				</td>
				<td class="separador"></td>	
				<td class="label">
					<label for="lblsucursal">Sucursal:</label>
				</td>
				<td>
					<input type="text" id="sucursalID" name="sucursalID" size="12" tabindex="13" disabled="true"/>
					<input type="text" id="nombreSucursalID" name="nombreSucursalID" size="40" tabindex="14" disabled="true" readOnly="true"/>
				</td>					
			</tr>
			<tr>
				<td class="label">
					<label for="lblActaDefuncionPROFUN">Acta de Defunci&oacute;n</label>
				</td>
				<td>
					<form:input type="text" id="actaDefuncionProfun" name="actaDefuncionProfun" path="actaDefuncionProfun" size="20" tabindex="18" disabled="true" readonly="true"/>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="lblFechaDefuncionProfun">Fecha de Defunci&oacute;n:</label>
				</td>
				<td>
					<form:input type="text" id="fechaDefuncionProfun" name="fechaDefuncionProfun" path="fechaDefuncionProfun" size="12" 
						tabindex="19" disabled="true" readonly="true"/>
				</td>
			</tr>
			<tr>										
				<td class="label">
					<label for="lblMontoAplicaPROFUN">Monto:</label>
				</td>
				<td>
					<form:input type="text" id="monto" name="monto" path="monto" size="20" esMoneda ="true" 
						style="text-align: right" disabled="true" readonly="true" tabindex="15"/>
					<input type="hidden" id="montoParamCaja" name="montoParamCaja" path="montoParamCaja" size="20" type="text"  
						esMoneda ="true" style="text-align: right" tabindex="16"/>
				</td>	
				<td class="separador"></td>	
				 <td class="label">
					<label for="estatus" id="lblEstatus">Estatus Solicitud:</label>
				</td>
				<td>
					<form:select id="estatus" name="estatus" path="estatus"  tabindex="17" disabled="true" >
						<form:option value="R">REGISTRADO</form:option>
				     	<form:option value="C">CANCELADO</form:option>
				     	<form:option value="P">PAGADO</form:option>
				     	<form:option value="A">AUTORIZADO</form:option>
				     	<form:option value="E">RECHAZADO</form:option>
			        </form:select>
				</td>			
			</tr>
		</table>	
		
	<br>
	<div id="archivosAjunta">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend>Digitalización de Documentos del <s:message code="safilocale.cliente"/></legend>			
			 <table border="0" cellpadding="0" cellspacing="0" style="width: 100%" >
				<tr>
					<td class="label"> 
			        	<label for="lbltipoDocumento">Tipo de Documento:</label> 
			     	</td> 
			     	<td nowrap="nowrap"> 
						<select id="tipoDocumento32" name="tipoDocumento32" tabindex="20">
							<option value="">SELECCIONAR</option>			
						</select>     
			     	</td>
			     	<td class="separador"></td>
			    </tr>
			    <tr>
			    	<td colspan="3">
			    		<div id="gridArchivosCliente" style="display: none;">  </div>
			    	</td>
			    </tr>  
			    <tr>
			    	<td colspan="3" style="text-align: right;">
						<input type="button" id="enviar" name="enviar" class="submit" tabindex="21" value="Adjuntar"/>
					</td>  
			     </tr> 
			</table>
		</fieldset>	
	</div>  
	
	<div id="imagenCte" style="display: none;">
		<img id= "imgCliente" SRC="images/user.jpg" WIDTH="100%" HEIGHT="100%" border ="0" alt="Foto cliente"/> 
	</div>
	<p>
	<div id="usuarioAutoriza">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Autorizar / Rechazar </legend>		
		<table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
			<tr>
				<td nowrap="nowrap">
					<input type="radio" id="autorizaProfun" name="autorizaRechaza"  tabindex="22" checked="checked"/><label>Autorizar</label>
				</td>
				<td>
					<input type="radio" id="rechazaProfun" name="autorizaRechaza"  tabindex="23" /><label>Rechazar</label>
				</td>
				<td class="separador"></td>
				<td class="label"> 
		        	<label for="lblmotivoRechazo" id="labelMotivoRechazo" ">Motivo Rechazo:</label> 
		     	</td> 
				<td>
					<form:textarea id="motivoRechazo" name="motivoRechazo" path="motivoRechazo" COLS="48" ROWS="2" tabindex="24"  
						onBlur=" ponerMayusculas(this)" maxlength ="400" /> 
				</td>
			</tr>			
			<tr>
				<td class="label">
					<label for="lblusuario">Usuario:</label>
				</td>
				<td>
					 <form:input type="text" id="usuarioAuto" name="usuarioAuto" path="usuarioAuto" size="30" tabindex="25" 
					 	maxlength ="45" /> 
				</td>
				<td class="separador" colspan="3"></td>
			</tr>
			<tr>
				<td class="label">
					<label for="lblcontrasenia">Contraseña:</label>
				</td>
				<td>
					<form:input type="password" id="contrasenia" name="contrasenia" path="contrasenia" size="30" tabindex="26"
						maxlength ="45" />
				</td>
				<td class="separador" colspan="3"></td>
			</tr>
			<tr>
				<td colspan="5" style="text-align: right;">
					<input type="submit" id="autorizar" name="autorizar" class="submit" value="Grabar" tabindex="27" />
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				</td>
			</tr>		
		</table>
		</fieldset>
	</div>	
	<br>
	<table style="width: 100%">
		<tr>
			<td colspan="5" style="text-align: right;">
				<input type="submit" id="grabar" name="grabar" class="submit" value="Agregar"  tabindex="28"/>
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



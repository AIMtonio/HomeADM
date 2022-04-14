<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
        <script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>  
        <script type="text/javascript" src="js/soporte/cancelaUsuario.js"></script>  
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cancelaUsuario">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
				<legend class="ui-widget ui-widget-header ui-corner-all">Cancelaci&oacute;n/Reactivaci&oacute;n de Usuarios</legend>
			
				<table>
					<tr>
						<td class="label">
							<label for="usuarioID">N&uacute;mero: </label>
						</td>
						<td >
							<form:input type="text" id="usuarioID" name="usuarioID" path="usuarioID" size="7" tabindex="1" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="nombreCompleto">Nombre:</label>
						</td>
						<td>
							<form:input type="text" id="nombreCompleto" name="nombreCompleto" path="nombreCompleto" size="40" 
							onBlur=" ponerMayusculas(this)" readOnly="true"/>
						</td>		
					</tr>			
					<tr>
						<td class="label">
							<label for="clave">Clave: </label>
						</td>
						<td >
							<form:input type="text" id="clave" name="clave" path="clave" readOnly="true"/>		
						</td>
						<td class="separador"></td>	
						<td class="label" nowrap="nowrap">
							<label for="fechUltPass">Fecha del &Uacute;ltimo Password: </label>
						</td>
						<td >
							<form:input type="text" id="fechUltPass" name="fechUltPass" path="fechUltPass" size="20"  
							readOnly="true"/>  
						</td>							
					</tr>		
					<tr>
						<td class="label"  nowrap="nowrap">
							<label for="fechUltAcces">Fecha de &Uacute;ltimo Acceso:</label>
						</td>
						<td>
							<form:input type="text" id="fechUltAcces" name="fechUltAcces" path="fechUltAcces" size="20" 
							readOnly="true"/>
						</td>	
						<td class="separador"></td>	
						<td class="label">
							<label for="fechaBloq">Fecha de Cancelaci&oacute;n: </label>
						</td>
						<td >
							<form:input type="text" id="fechaCancel" name="fechaCancel" path="fechaCancel" size="20" 
							readOnly="true"/>  
						</td>	
					</tr>
					<tr>
						<td class="label">
							<label for="estatus">Estatus:</label>
						</td>
						<td>	
							<form:select id="estatus" name="estatus" path="estatus" disabled="true">
								<form:option value="A">Activo</form:option> 
							   <form:option value="B">Bloqueado</form:option>
								<form:option value="C">Cancelado</form:option>
							</form:select>
						</td>
						<td class="separador"></td>	
						<td id="tdFechaReactiva" class="label">
							<label for="fechaReactiva">Fecha de Reactivaci&oacute;n: </label>
						</td>
						<td id="tdInputFechaReactiva">
							<form:input type="text" id="fechaReactiva" name="fechaReactiva" path="fechaReactiva" size="20" 
							readOnly="true"/>  
						</td>									
					</tr>			
					<tr> 
						<td class="label">
							<label for="motivoCancel">Motivo de Cancelaci&oacute;n: </label>
						</td>
						<td>
							<form:textarea id="motivoCancel" name="motivoCancel" path="motivoCancel" cols="35" rows="3" 
							onblur=" ponerMayusculas(this);" tabindex="2" maxlength="200"/>   							
						</td>	
						<td class="separador"></td>
						<td id="tdUsuResp" class="label" nowrap="nowrap">
							<label for="nombreUsuarioRespon">Nombre del Usuario Responsable:</label>
						</td>
						<td id="tdInputUsuarioRes">
							<form:input type="text" id="nombreUsuarioRespon" name="nombreUsuarioRespon" path="nombreUsuarioRespon" size="40" 
							onBlur=" ponerMayusculas(this)" readOnly="true"/>
						</td>						
					</tr>		
					<tr id="trMotivoClaveUsu"> 
						<td class="label">
							<label for="motivoReactiva">Motivo de Reactivaci&oacute;n: </label>
						</td>
						<td>
							<form:textarea id="motivoReactiva" name="motivoReactiva" path="motivoReactiva" cols="35" rows="3" 
							onblur=" ponerMayusculas(this);" tabindex="3" maxlength="200" />   						
						</td>		
						<td class="separador"></td>
						<td class="label">
							<label for="claveUsuarioRespon">Clave del Usuario Responsable:</label>
						</td>
						<td>
							<form:input type="text" id="claveUsuarioRespon" name="claveUsuarioRespon" path="claveUsuarioRespon" size="40" 
							onBlur=" ponerMayusculas(this)" readOnly="true"/>
						</td>					
					</tr>	
					<tr id="trNuevoMotivo"> 
						<td class="label">
							<label for="motivoNuevo">Nuevo Motivo: </label>
						</td>
						<td>
							<form:textarea id="motivoNuevo" name="motivoNuevo" path="motivoNuevo" cols="35" rows="3" 
							onblur=" ponerMayusculas(this);" tabindex="4"  maxlength="200"/>   							
						</td>						
					</tr>
				</table>
				<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="cancelar" name="cancelar" class="submit" value="Cancelar" tabindex="5"/>
							<input type="submit" id="reactivar" name="reactivar" class="submit" value="Reactivar" tabindex="6"/>
							<input type="hidden" id="usuarioIDRespon" name="usuarioIDRespon"/>
							<input type="hidden" id="esNuevoComenCance" name="esNuevoComenCance"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
						</td>
					</tr>
				</table>	
				</fieldset>
			</form:form>  
		</div>
		<div id="cargando" style="display: none;">	
		</div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
		</div>
	</body>
	<div id="mensaje" style="display: none;"/>
</html>
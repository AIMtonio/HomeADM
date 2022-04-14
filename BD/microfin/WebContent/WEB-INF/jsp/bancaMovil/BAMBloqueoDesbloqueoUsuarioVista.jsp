<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
        <script type="text/javascript" src="dwr/interface/usuariosServicio.js"></script> 
        <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
        <script type="text/javascript" src="js/bancaMovil/bloqDesbloqUsuario.js"></script>          
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="bloDesUsuario">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Bloq/Desbloqueo de Usuario de la Banca M&oacute;vil</legend>
<table  border="0" width="100%">
	<tr>
		<td class="label">
			<label for="clienteID">N&uacute;mero de cliente: </label>
		</td>
		<td >
			<form:input type="text" id="clienteID" name="clienteID" path="clienteID" maxlength="16" size="13" tabindex="1" />
			<input type="text" id="nombreCompleto" name="nombreCompleto" tabindex="2" path="nombreCompleto" size="40"  
			onBlur=" ponerMayusculas(this)" readOnly="true"/>
		</td>	
	</tr>
	<tr>
		<td class="label">
			<label for="email">Email: </label>
		</td>
		<td >
			<form:input  type="text" tabindex="3"  id="email" name="email" path="email" size="50" readOnly="true"/>		
		</td>
		</tr>
		<tr>
		<td class="label">
			<label for="fechaUltimoAcceso">&Uacute;ltimo Acceso:</label>
		</td>
		<td>
			<form:input  type="text"  id="fechaUltimoAcceso" name="fechaUltimoAcceso" path="fechaUltimoAcceso" size="30" 
			disabled="true" readOnly="true"/>
		</td>	
	</tr>
	
		<td class="label">
			<label for="estatusActual">Estatus Actual:</label>
		</td>
		<td>
			<form:select id="estatus" name="estatus" path="estatus" tabindex="4">
				<form:option value="S">SELECCIONAR</form:option>
				<form:option value="A">ACTIVO</form:option> 
			   	<form:option value="B">BLOQUEADO</form:option>
			</form:select>
		</td>	
		
	<tr>	
		<td class="label">
			<label for="estatusFinal">Estatus Final:</label>
		</td>
		<td>	
			<form:select id="estatusFinal" name="estatusFinal" path="estatusFinal" tabindex="5">
				<form:option value="S">SELECCIONAR</form:option>
				<form:option value="A">ACTIVO</form:option> 
			   	<form:option value="B">BLOQUEADO</form:option>
			</form:select>
		</td>
	</tr>
	<tr>	
	<td class="label" id="bloqueoUserM" style="display: none;" nowrap="nowrap">
			<label for="motivo">Motivo de Bloqueo: </label>
		</td>
		<td id="bloqueoUserMotivo"  style="display: none;">
			<form:textarea   type="text"  id="motivoBloqueo" name="motivoBloqueo" path="motivoBloqueo" cols="35" rows="3" 
			tabindex="6" onBlur=" ponerMayusculas(this)" maxlength="200"/>   
			
		</td>					
	</tr>
	
	<tr> 
		<td class="label" id="bloqueolblfe" style="display: none;">
			<label for="fechaBloque">Fecha de Bloqueo: </label>
		</td>
		<td id="bloqueoinfe" style="display: none;">
			<form:input tabindex="7"  type="text"  id="fechaBloqueo" name="fechaBloqueo" path="fechaBloqueo" size="20"
			 readOnly="true"/>  
		</td>
	</tr>  
	<tr>
		<td align="right" colspan="5">
			<input type="submit" id="actualiza" name="actualiza" class="submit" value="Actualizar" tabindex="8" />
			<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
			<input type="hidden" id="idClienteAux"    name="idClienteAux"/>
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
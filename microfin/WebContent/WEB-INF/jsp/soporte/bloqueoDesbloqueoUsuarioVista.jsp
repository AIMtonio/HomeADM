<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
        <script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>  
        <script type="text/javascript" src="js/soporte/bloqDesbloqUsuario.js"></script>                    
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="bloDesUsuario">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Bloqueo/Desbloqueo de Usuarios</legend>
<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<tr>
		<td class="label">
			<label for="usuarioID">N&uacute;mero: </label>
		</td>
		<td >
			<form:input type="text" id="usuarioID" name="usuarioID" path="usuarioID" size="7" tabindex="1" />
		</td>
		<td class="separador"></td>
		<td class="label">
			<label for="nombre">Nombre:</label>
		</td>
		<td>
			<form:input type="text" id="nombreCompleto" name="nombreCompleto" path="nombreCompleto" size="40" tabindex="2" 
			onBlur=" ponerMayusculas(this)" readOnly="true"/>
		</td>		
	</tr>
	<tr>
		<td class="label">
			<label for="clave">Clave: </label>
		</td>
		<td >
			<form:input  type="text"  id="clave" name="clave" path="clave" tabindex="5" readOnly="true"/>		
		</td>
		<td class="separador"></td>
		<td class="label">
			<label for="fechUltAcces">Fecha de &Uacute;ltimo Acceso:</label>
		</td>
		<td>
			<form:input  type="text"  id="fechUltAcces" name="fechUltAcces" path="fechUltAcces" size="20" tabindex="13" 
			disabled="true" readOnly="true"/>
		</td>	
	</tr>
	<tr>	
		<td class="label" nowrap="nowrap">
			<label for="fechUltPass">Fecha del &Uacute;ltimo Password: </label>
		</td>
		<td >
			<form:input  type="text" id="fechUltPass" name="fechUltPass" path="fechUltPass" size="20" tabindex="14" 
			disabled="true" readOnly="true"/>  
		</td>
		<td class="separador"></td>
		<td class="label">
			<label for="estatus">Estatus:</label>
		</td>
		<td>	
			<form:select id="estatus" name="estatus" path="estatus" tabindex="6">
				<form:option value="A">ACTIVO</form:option> 
			   	<form:option value="B">BLOQUEADO</form:option>
			</form:select>
		</td>				
	</tr>
	<tr> 
		<td class="label" id="bloqueolblmo" style="display: none;" nowrap="nowrap">
			<label for="motivo">Motivo de Bloqueo: </label>
		</td>
		<td id="bloqueoinmo"  style="display: none;">
			<form:textarea   type="text"  id="motivoBloqueo" name="motivoBloqueo" path="motivoBloqueo" cols="35" rows="3" 
			tabindex="14" onBlur=" ponerMayusculas(this)" />   
			
		</td>
		<td class="separador"></td>	
		<td class="label" id="bloqueolblfe" style="display: none;">
			<label for="fechaBloq">Fecha de Bloqueo: </label>
		</td>
		<td id="bloqueoinfe" style="display: none;">
			<form:input  type="text"  id="fechaBloq" name="fechaBloqueo" path="fechaBloqueo" size="20" tabindex="15"
			 readOnly="true"/>  
		</td>
	</tr>  
	<tr>
		<td align="right" colspan="5">
			<input type="submit" id="actualiza" name="actualiza" class="submit" value="Actualiza" tabindex="16" />
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
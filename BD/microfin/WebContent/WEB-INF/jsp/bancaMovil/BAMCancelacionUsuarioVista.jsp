<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
        <script type="text/javascript" src="dwr/interface/usuariosServicio.js"></script> 
        <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
        <script type="text/javascript" src="js/bancaMovil/cancelaUsuario.js"></script>                   		
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cancelaUsuario">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Cancelaci&oacute;n/ Reactivaci&oacute;n de Usuario de la Banca M&oacute;vil</legend>
	
<table border="0" width="100%">
	<tr>
		<td class="label">
			<label for="clienteID">N&uacute;mero de cliente: </label>
		</td>
		<td nowrap="nowrap">
			<form:input id="clienteID" name="clienteID" path="clienteID" size="13" tabindex="1" maxlength="16"/>
			<input id="nombreCompleto" name="nombreCompleto" path="nombreCompleto" tabindex="2" size="40" onBlur=" ponerMayusculas(this)" readOnly="true"/>
		</td>		
	</tr>

	<tr>
		<td class="label">
			<label for="email">Email: </label>
		</td>
		<td >
			<form:input id="email" tabindex="3" name="email" path="email" readOnly="true" size="50"/>		
		</td>
				
	</tr>
	

	<tr>
		<td class="label">
			<label for="fechaUltimoAcceso">&Uacute;ltimo Acceso:</label>
		</td>
		<td>
			<form:input id="fechaUltimoAcceso" name="fechaUltimoAcceso" path="fechaUltimoAcceso" size="30" 
			disabled="true" readOnly="true"/>
		</td>
	</tr>
	<tr>
		<td class="label">
			<label for="estatus">Estatus:</label>
		</td>
		<td>	
			<form:select id="estatus" name="estatus" path="estatus" tabindex="4">
				<form:option value="S">SELECCIONAR</form:option>
				<form:option value="A">ACTIVO</form:option> 
				<form:option value="C">CANCELADO</form:option>
			</form:select>
		</td>	
				
	</tr>

	<tr> 
		<td id="motInfo" class="label">
			<label for="motivo">Motivo de Cancelaci&oacute;n: </label>
		</td>
		<td id="textCancelacion">
			<form:textarea id="motivoCancelacion" name="motivoCancelacion" path="motivoCancel" cols="35" rows="3" 
			onblur=" ponerMayusculas(this);" tabindex="5" maxlength="200" />   
			
		</td>		
	</tr>
	<tr>
		<td id="fechInfo" class="label">
			<label for="fechaCancelacion">Fecha de Cancelaci&oacute;n: </label>
		</td>
		<td id="fechancelacion">
			<form:input id="fechaCancelacion" tabindex="6" name="fechaCancelacion" path="fechaCancel" size="20"
			readOnly="true"/>  
		</td>	
	</tr>
	<tr>
		<td align="right" colspan="5">
			<input type="submit" tabindex="100" id="cancelar" name="cancelar" class="submit" value="Actualizar"/>
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
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>
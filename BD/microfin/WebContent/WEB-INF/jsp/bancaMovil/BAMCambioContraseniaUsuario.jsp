<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
	 	<script type="text/javascript" src="dwr/interface/usuariosServicio.js"></script> 
        <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
 		<script type="text/javascript" src="js/bancaMovil/cambioPassUsuario.js"></script>
		
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cambioContraUsuario">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Cambio de Contrase&ntilde;a de Usuario </legend>
	
<table border="0" width="100%" style="text-align: left;">
	<tr>
		<td class="label">
			<label for="clienteID">N&uacute;mero de Cliente: </label>
		</td>
		<td>
			<form:input id="clienteID" name="clienteID" path="clienteID"  size="13" tabindex="1" maxlength="16"/>
			<input id="nombreCompleto" name="nombreCompleto" path="nombreCompleto" size="40" 
			onBlur=" ponerMayusculas(this)" tabindex="2" maxlength="200" readOnly="true"/> 
		</td>
	</tr>
	<tr>
		<td class="label">
			<label for="email">Email: </label>
		</td>
		<td >
			<form:input id="email" tabindex="3" name="email" path="email" size="50" readOnly="true" />		
		</td>
	</tr>
	<tr>
		<td class="label">
			<label for="contrasenia">Nueva Contraseña:</label>
		</td>
		<td>
			<input type="password" id="nuevaContra" name="nuevaContra" size="40"  maxlength=100" tabindex="4" />
		</td>	
		</tr>
		<tr>	
		<td class="label">
			<label for="contrasenia">Confirma Contraseña:</label>
		</td>
		<td>
			<input type="password" id="Confirmacontra" name="Confirmacontra"  size="40" maxlength="100" tabindex="5" />
		</td>	
	</tr>
	<tr>
	<td align="right" colspan="5">
			<input type="submit" tabindex="88" id="actualizar" name="actualizar" class="submit" value="Actualizar"/>
			<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
			<input type="hidden" id="newPassword" name="newPassword"/>
			<input type="hidden" id="contraseniaAnterior" name="contraseniaAnterior"/>
			<input type="hidden" id="idClienteAux"    name="idClienteAux"/>
			<input type="hidden" id="telefono"    name="telefono"/>
		</td>
	</tr>
<br>	
<table id="reglas de pass" style="text-align: left;">
<tr>
	<td class="label" >
		<div class="label">
			<div class="label">
			<label> Reglas para definir un nueva Contraseña: 
				<br> 	1. 6 Caracteres como minimo.
				<br> 	2. No repetir caracteres.
				<br>	3. No tener caracteres consecutivos.
			</label>
		</div>
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
<div id="mensaje" style="display: none;"></div>
</html>
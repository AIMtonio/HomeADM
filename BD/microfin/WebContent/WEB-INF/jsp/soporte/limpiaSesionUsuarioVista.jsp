<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
        <script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>  
        <script type="text/javascript" src="js/soporte/limpiaSesionUsuario.js"></script>                    
       
		
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="limpiaSesion">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Limpiar Sesi&oacute;n de Usuario</legend>
	
<table cellpadding="0" cellspacing="0" border="0" width="950px">
	<tr>
		<td class="label">
			<label for="usuarioID">N&uacute;mero: </label>
		</td>
		<td >
			<form:input id="usuarioID" name="usuarioID" path="usuarioID" size="7" tabindex="1" />
		</td>
		<td class="separador"></td>
		<td class="label">
			<label for="nombre">Nombre:</label>
		</td>
		<td>
			<form:input id="nombreCompleto" name="nombreCompleto" path="nombreCompleto" size="40" tabindex="2" 
			onBlur=" ponerMayusculas(this)" readOnly="true" disabled="true"/>
		</td>		
	</tr>

	<tr>
		<td class="label">
			<label for="clave">Clave: </label>
		</td>
		<td >
			<form:input id="clave" name="clave" path="clave" tabindex="5" readOnly="true" disabled="true"/>		
		</td>
		<td class="separador"></td>	
		<td class="label">
			<label for="fechUltPass">Fecha del &Uacute;ltimo Password: </label>
		</td>
		<td >
			<form:input id="fechUltPass" name="fechUltPass" path="fechUltPass" size="20" tabindex="14" 
			disabled="true" readOnly="true"/>  
		</td>
				
	</tr>
	

	<tr>
		<td class="label">
			<label for="fechUltAcces">Fecha de &Uacute;ltimo Acceso:</label>
		</td>
		<td>
			<form:input id="fechUltAcces" name="fechUltAcces" path="fechUltAcces" size="20" tabindex="13" 
			disabled="true" readOnly="true"/>
		</td>	
		<td class="separador"></td>	
		<td class="label">
			<label for="estatus">Estatus:</label>
		</td>
		<td>	
			<form:select id="estatus" name="estatus" path="estatus" tabindex="6" disabled="true">
				<form:option value="A">Activo</form:option> 
			   <form:option value="B">Bloqueado</form:option>
				<form:option value="C">Cancelado</form:option>
			</form:select>
		</td>	
	</tr>
    <tr>
        <td class="label">
			<label for="estatusSes">Sesi&oacute;n:</label>
		</td>
		<td>	
			<form:select id="estatusSesion" name="estatusSesion" path="estatusSesion" tabindex="6" disabled="true">
				<form:option value="A">Activo</form:option> 
			   <form:option value="I">Inactivo</form:option>
			</form:select>
		</td>
		<td class="separador"></td>	
		<td class="label">
			<label for="logue">Esta Logueado:</label>
		</td>
		<td>	
			<select id="logueado" name="logueado" tabindex="7" disabled="true">
				<option value="S">Si</option> 
			   <option value="N">No</option>
			</select>
		</td>		
	</tr>

</table>
	 <table align="right">
				<tr>
					<td align="right">
						<input type="button" id="limpiar" name="limpiar" class="submit" value="Limpiar"/>
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
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/tipoProvServicio.js"></script> 
	  	<script type="text/javascript" src="js/soporte/mascara.js"></script>
		<script type="text/javascript" src="js/tesoreria/tipoProveedores.js"></script>  
	</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tiposproveedores">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">		
			<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Tipos Proveedores</legend>			
				<table border="0"  width="100%">
					<tr>
						<td class="label">
							<label for="lblTipoProveedorID">N&uacute;mero:</label>
						</td>
						<td>
							<form:input id="tipoProveedorID" name="tipoProveedorID" path="tipoProveedorID" size="5" tabindex="1"  />
						</td>
						</tr>
						<tr>
						<td class="label">
							<label for="lblDescripcion">Descripci&oacute;n:</label>
						</td>
						<td>
							<textarea id="descripcion" name="descripcion" path="descripcion" maxlength="200" cols =70 rows=3 tabindex="2" onBlur=" ponerMayusculas(this);" ></textarea>
						</td>
						</tr>
						<tr>
						<td class="label"> 
							<label for="tipoPersona">Tipo Persona: </label> 
						</td>
						<td class="label"> 
							<form:radiobutton id="tipoPersona" name="tipoPersona" path="tipoPersona"
			 						value="F" tabindex="3" checked="checked" />
							<label for="fisica">F&iacute;sica</label>
							<form:radiobutton id="tipoPersona2" name="tipoPersona2" path="tipoPersona" 
									 value="M" tabindex="4"/>
							<label for="fisica">Moral</label>	
						</td>
					</tr>
				</table>
		<table align="right">
		<tr>
			<td align="right">
				<input type="submit" id="agrega" name="agrega" class="submit" 
					 value="Agregar" tabindex="5" />
				<input type="submit" id="modifica" name="modifica" class="submit" 
					 value="Modificar" tabindex="6" />
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
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
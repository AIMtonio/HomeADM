<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	
    <script type="text/javascript" src="dwr/interface/catPromotoresExtInvServicio.js"></script> 
    <script type="text/javascript" src="js/soporte/mascara.js"></script>
	<script type="text/javascript" src="js/inversiones/catPromotorExterno.js"></script>	       
	

<title>Catálogo de Promotores Externos de Inverciones</title>
</head>
<body>

	<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Catálogo de Promotores Externos de Inversión</legend>
	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="catPromotorExtBean" >
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>
						<label>N&uacute;mero:</label></td>
					<td>
						<form:input type="text" name="numero" id="numero" path="numero" size="11" autocomplete="off" tabIndex="1"/>
					</td>
				</tr>
				<tr>
					<td>
						<label>Nombre del Promotor:</label></td>
					<td>
						<input type="text" name="nombre" id="nombre" size="60" onblur=" ponerMayusculas(this)" tabIndex="2"/>
					</td>
				</tr>
				<tr >
					<td>
						<label>Tel&eacute;fono Particular:</label></td>
					<td>
						<input type="text" name="telefono" id="telefono" maxlength="10" size="15" tabIndex="3" />
						<label>Ext.:</label>
					
						<input type="text" name="extTelefono" id="extTelefono" maxlength="6" size="10" tabIndex="4" />
					
					</td>
					
						
					
			    </tr>
			    	<tr >
					<td>
						<label>Tel&eacute;fono Celular:</label></td>
					<td>
						<input type="text" name="numCelular" id="numCelular" maxlength="10" size="15" tabIndex="5"/>
					</td>
			    </tr>
			        	<tr >
					<td>
						<label>Correo Electr&oacute;nico:</label></td>
					<td>
						<input type="text" name="correo" id="correo" size="40" tabIndex="6"/>
					</td>
			    </tr>
			         	<tr >
					<td>
						<label>Estatus:</label></td>
					<td>
						<select id="estatus" name="estatus" tabIndex="7">
						 	<option value="">SELECCIONA </option>
						 	<option value="A">ACTIVO </option>
						 	<option value="C">CANCELADO </option>  	 					 	
						</select>
					</td>
			    </tr>
			</table>
				<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
				<tr>
					<td align="right">
						<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="8"/>
						<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="9" />
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value=""/>
					</td>
				</tr>
			</table>
		</form:form>
		</fieldset>
	</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
<div id="mensaje" style="display: none;"/>
</body>
</html>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head> 
	<link rel="stylesheet" type="text/css" href="css/mensaje.css" media="all"  >
	<!-- dwr def -->
	<script type="text/javascript" src="dwr/interface/pslParamBrokerServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/pslConfigServicioServicio.js"></script>

	<script type="text/javascript" src="js/psl/pslParamBroker.js"></script>    
	<script type="text/javascript" src="js/general.js"></script>
	
	
<title>Servicios En Linea</title>
</head>
<body>
 <div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Configuración Servicios En Línea</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="pslParamBrokerBean" >
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend >Configuración de Catálogo</legend>
				<table border="0"  width="100%">
					<tr>
						<td class="label">
							<label>Actualización diaria automática de lista de productos:</label>
						</td>
						<td>
							<input type="radio" name="rbActualizacionDiaria" id="rbActualizacionDiariaS" value="S" tabindex="1"><label for="rbActualizacionDiariaS">SI</label>
							<input type="radio" name="rbActualizacionDiaria" id="rbActualizacionDiariaN" value="N" tabindex="2"><label for="rbActualizacionDiariaN">NO</label>
							<a href="javaScript:" onClick="ayudaActualizacionDiaria();"><img src="images/help-icon.gif" ></a>
						</td>
					</tr>	
					
					<tr>
						<td class="label">
							<label for="txtHoraActualizacion">Hora de la actualización (formato 24hrs):</label>
						</td>
						<td>
							<input type="text" value="" name="txtHoraActualizacion" id="txtHoraActualizacion" size="20" tabindex="3"/>
							<a href="javaScript:" onClick="ayudaHoraActualizacion();"><img src="images/help-icon.gif" ></a>  
						</td>
					</tr>
				</table>	
			</fieldset>		
			<br/>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend >Conexión con el Proveedor</legend>
				<table border="0"  width="100%">
					<tr>
						<td class="label">
							<label for="txtUsuario">Usuario:</label>
						</td>
						<td>
							<input type="text" value="" name="txtUsuario" id="txtUsuario" maxlength="20" tabindex="4"/>
							<a href="javaScript:" onClick="ayudaUsuario();"><img src="images/help-icon.gif" ></a>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="txtContrasenia">Contraseña:</label>
						</td>
						<td>
							<input type="password" value="" name="txtContrasenia" id="txtContrasenia" maxlength="20" tabindex="5"/>
							<a href="javaScript:" onClick="ayudaContrasenia();"><img src="images/help-icon.gif" ></a>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="txtURLConexion">URL Conexión:</label>
						</td>
						<td>
							<input type="text" value="" name="txtURLConexion" id="txtURLConexion" size="55" maxlength="200" tabindex="6"/>
							<a href="javaScript:" onClick="ayudaURLConexion();"><img src="images/help-icon.gif" ></a>
						</td>
					</tr>	
				</table>	
			</fieldset>		
			<table align="right">
				<tr>
					<td align="right">
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" iniForma="false"/>						
						<input type="button" class="submit" id="btnActualizarServicios" tabindex="7" value="Probar conexión"/>
						<input type="submit" class="submit" id="btnGuardar" name="btnGuardar" tabindex="8" value="Guardar"/>
					</td>
				</tr>
			</table>
		</form:form>
</fieldset>

</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/></div>
</div>
<div id="ContenedorAyuda" style="display: none;">
	<div id="elemento"/>
</div>
<div id="mensaje" style="display: none;"/></div>

</body>
</html>
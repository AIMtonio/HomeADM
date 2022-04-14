<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head> 
	<link rel="stylesheet" type="text/css" href="css/mensaje.css" media="all"  >
	<!-- dwr def -->
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/edoCtaClavePDFServicio.js"></script> 

	<script type="text/javascript" src="js/soporte/edoCtaClavePDF.js"></script>    
	<script type="text/javascript" src="js/general.js"></script>
	
	<title>Contraseña Estado de Cuenta</title>
</head>
<body>
 <div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Contraseña Estado de Cuenta</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="edoCtaClavePDFBean" >
			<table border="0"  width="100%">
				<tr>
					<td class="label">
						<label for="clienteID">Número de <s:message code="safilocale.cliente"/>:</label>
					</td>
					<td>
						<input type="text" value="" name="clienteID" id="clienteID" size="11" autocomplete="off" tabindex="1"/>
						<input type="text" value="" id="nombreCliente" size="50" tabindex="2" disabled="disabled"/>
					</td>
				</tr>
				<tr>
					<td class="label">
						<label>Cuenta con contraseña actual:</label>
					</td>
					<td>
						<input type="radio" id="siContrasenia" name="tieneContrasenia" disabled="disabled"/> <label>SI</label>
						<input type="radio" id="noContrasenia" name="tieneContrasenia" disabled="disabled"/> <label>NO</label>
					</td>
				</tr>				
				<tr>
					<td colspan="2">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend>Nueva Contraseña</legend>
							<table>
								<tr>
									<td class="label">
										<label for="password">Contraseña:</label>
									</td>
									<td>
										<input type="hidden" name="contrasenia" id="contrasenia" value=""/>
										<input type="password" value="" name="txtContrasenia" id="txtContrasenia" size="50" maxlength="16" tabindex="3" autocomplete="new-password"/>
									</td>
								</tr>
								
								<tr>
									<td colspan="2">
										<label>LA CONTRASEÑA DEBE CUMPLIR CON LAS SIGUIENTES CARACTERÍSTICAS</label><br>
										<label>- Longitud Minima de 8  Caracteres</label><br>
										<label>- Longitud Máxima de 16 Caracteres</label><br>
										<label>- Al menos una letra mayúscula</label><br>
										<label>- Al menos una letra minúscula</label><br>
										<label>- Al menos un dígito</label><br>
										<label>- No espacios en blanco</label><br>
										<label>- No saltos de linea</label><br>
										<label>- No Caracteres especiales</label><br>
									</td>					
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
				
				<tr>
					<td class="label">
					</td>
					<td align="right">
						<input type="hidden" id="tipoUsuario" value="<s:message code='safilocale.cliente'/>"/>
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" iniForma="false"/>	
						<input type="submit" class="botonDeshabilitado" id="btnGuardar" name="btnGuardar" tabindex="4" value="Guardar" disabled="disabled"/>
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

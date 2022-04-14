<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
<head>
			 <script type="text/javascript" src="dwr/interface/edoCtaCertificadoServicio.js"></script>
			 <script type="text/javascript" src="js/soporte/edoCtaCertificado.js"></script>   			 
</head>
<body>				
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="edoCtaCertificadoBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Envío Certificado de Sello Digital (CSD)</legend>
      					      		
		      		<table border="0" cellpadding="0" cellspacing="0" width="100%">						 
						<tr>
							<td class="label">
								<label for="adjuntaKey">Clave Privada (.key):  </label>
							</td>
							 <td>										
									 <input type="text" id="archivoK" name="archivoK" size="45" tabindex="2" readOnly="true" iniForm="false"/>
									 <input type="button" id="adjuntarK" name="adjuntarK" class="submit" tabindex="3" value="Adjuntar" />																																							
							</td>													
						</tr>
						<tr>
							<td>
								<label for="adjuntaCer">Certificado (.cer):  </label>
							</td>
							<td>
								<input type="text" id="archivoC" name="archivoC" size="45" tabindex="4"  readOnly="true" iniForm="false" />
								<input type="button" id="adjuntarC" name="adjuntarC" class="submit" tabindex="5" value="Adjuntar" />								
							</td>
						</tr>
						<tr>						
							<td class="label">
								<label for="contrasena">Contraseña de Clave Privada: </label>
							</td>
							<td>
								<input type="password" id="contrasena" name="contrasena" path="contrasena" size="25" tabindex="6" autocomplete="new-password" />
							</td>							
						</tr>
				</table>
				<br>  
					<table width="100%">
					<tr>
						<td align="right">
								<input type="submit" id="agrega" name="agrega" class="submit" value="Enviar"  tabindex="60"/>																		
								<input type="hidden" id="tipoExt" name="tipoExt"/>
								<input type="hidden" id="rutaCompletaKey" name="rutaCompletaKey" />
								<input type="hidden" id="rutaCompletaCer" name="rutaCompletaCer" />
						</td>
					</tr>
				</table>	      			
			</fieldset>	
		</form:form>	
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>

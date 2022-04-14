<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

	<html>
		<head>	
			<script type="text/javascript" src="dwr/interface/altaTiposSoporteServicio.js"></script>
	      	<script type="text/javascript" src="js/cuentas/altaTiposSoporte.js"></script> 
		</head>
	<body>
	
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="altaTiposSoporteBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">		
				<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Tipos de Soporte</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label" >
							    <label for="lblNumero">N&uacute;mero:</label> 
							</td>		
							<td> 
							    <input type="text" id="tipoSoporteID" name="tipoSoporteID" size="13" maxlength="12" tabindex="1" autocomplete="off" /> 
							</td>
						</tr>
						<tr>
							<td class="label" >
							 <label for="lblDescripcion">Descripci&oacute;n:</label> 
							</td>	
							<td> 
								<textarea id="descripcion" name="descripcion" rows="2" cols="60" tabindex="2" maxlength="200" onBlur="ponerMayusculas(this)" 
											autocomplete="off"  >
								</textarea>
							</td>
						</tr>
					</table>
					<table border="0"  width="100%">
						<tr>
							<td align="right">
								<input type="submit" id="agregar" name="agregar" class="submit" value="Agregar" tabindex="3"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>		
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

  
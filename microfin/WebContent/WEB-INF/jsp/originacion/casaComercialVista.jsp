<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/engine.js"></script>
		<script type="text/javascript" src="dwr/util.js"></script>
		<script type="text/javascript" src="dwr/interface/casasComercialesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script>
		<script type="text/javascript" src="js/forma.js"></script>
		<script type="text/javascript" src="js/originacion/casaComercial.js"></script>
	</head>

	<body>
	<div id="contenedorForma">

		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Registro de Casas Comerciales</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="casaComercial">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label">
			         		<label id="labelCasa" for="labelCasa">N&uacute;mero: </label>
			     		</td>
			     		<td>
							<form:input type="text" id="casaID" name="casaID" path="casaID" size="5" tabindex="1" iniforma="false"/>
	  					</td>
					</tr>
					<tr>
						<td class="label">
			         		<label id="labelNombre" for="lblNombre">Nombre: </label>
			     		</td>
			     		<td>
	  						<form:input type="text" id="nombreCasa" name="nombreCasa" path="nombreCasa" size="40" tabindex="2" onBlur=" ponerMayusculas(this)" />
						</td>
					</tr>
					<tr>
						<td class="label">
					  		<label for="lblTipoDisp">Tipo Dispersi&oacute;n: </label>
					 	</td>
					 	<td>
							<form:select id="tipoDispersion" name="tipoDispersion" path="tipoDispersion"  tabindex="3">
								<form:option value="">SELECCIONAR</form:option>
							  	<form:option value="C">CHEQUE</form:option>
							  	<form:option value="S">SPEI</form:option>
							  	<form:option value="O">ORDEN DE PAGO</form:option>
						  	</form:select>
					  	</td>
				 	</tr>
				 	<tr id="divinstitucionID">
				 		<td class="label" nowrap="nowrap">
							<label for="lblInstitucion">Instituci&oacute;n: </label>
						</td>
						<td nowrap="nowrap">
							<form:input id="institucionID" name="institucionID" path="institucionID" size="12" tabindex="4" iniforma="false" maxlength="11"/>
							<input type= "text" id="descripInst" name="descripInst"size="50" type="text" tabindex="5" readOnly="true" disabled = "true" iniforma="false"/>
						</td>
				 	</tr>
					<tr id="divcuentaClabe">
						<td>
							<label for="lblCuentaClabe">Cuenta CLABE: </label>
			     		</td>
			     		<td>
							<form:input type="text" id="cuentaClabe" name="cuentaClabe" path="cuentaClabe" size="24" tabindex="6"  disabled="true" numMax="18"
								maxlength="18"/>
						</td>
	  				</tr>
	  				<tr>
						<td class="label">
					  		<label for="lblEstatus">Estatus: </label>
					 	</td>
					 	<td>
							<form:select id="estatus" name="estatus" path="estatus"  tabindex="7">
								<form:option value="">SELECCIONAR</form:option>
							  	<form:option value="A">ACTIVO</form:option>
							  	<form:option value="I">INACTIVO</form:option>
						  	</form:select>
					  	</td>
				 	</tr>
				 	<tr id="divRFC">
						<td class="label">
			         		<label id="labelRFC" for="labelRFC">RFC: </label>
			     		</td>
			     		<td>
	  						<form:input type="text" id="rfc" name="rfc" path="rfc" size="40" tabindex="8" maxlength="13" disabled="true" onBlur=" ponerMayusculas(this)" />
						</td>
					</tr>
				</table>
				<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="8" />
							<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="9"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
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
	</body>
	<div id="mensaje" style="display: none;position:absolute; z-index:999;"/>
</html>

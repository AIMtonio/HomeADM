<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
	<head>
	  	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasFirmaServicio.js"></script>
		<script type="text/javascript" src="js/soporte/ServerHuella.js"></script>
		<script type="text/javascript" src="js/soporte/registroHuellaUsuario.js"></script>

	</head>
<body>
<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="huellaDigital">


		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Huella Usuario </legend>

			<table border="0" cellpadding="0" cellspacing="0" width="100%">

				<tr>
					<td class="label">
						<label for="numero">N&uacute;mero: </label>
					</td>
					<td >
						<input type="text" id="usuarioID" name="usuarioID" path="usuarioID"  size="13" tabindex="1" />
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="nombre">Nombre:</label>
					</td>
					<td>
						<input type="text" id="nombre" name="nombre" path="nombre" size="30" tabindex="2"
						onBlur=" ponerMayusculas(this)" readonly="true" />
					</td>
				</tr>
				<tr>
					<td class="label">
						<label for="apPaterno">Apellido Paterno: </label>
					</td>
					<td >
						<input type="text" id="apPaterno" name="apPaterno" path="apPaterno" size="30" tabindex="3"
						onBlur=" ponerMayusculas(this)" readonly="true"/>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="apMaterno">Apellido Materno:</label>
					</td>
					<td>
						<input type="text" id="apMaterno" name="apMaterno" path="apMaterno" size="30" tabindex="4"
						onBlur=" ponerMayusculas(this)" readonly="true"/>
					</td>
				</tr>
				<tr>
					<td class="label">
         				<label for="estatus">Estatus Huellas: </label>
     				</td>
			    	<td class="label" id="Estatus_Registro_Huella">
     				</td>
			    </tr>

			     <tr>
			    	 <td class="label">
         				<label for="lblIzquierdo">Mano Izquierda: </label>
     				</td>
     				<td>
         				<input id="dedoHuellaUno" name="dedoHuellaUno" size="15" value="" readOnly="true" iniForma = "false"/>
         			<td class="separador"></td>
			    	 <td class="label">
         				<label for="lblDerecho">Mano Derecha: </label>
     				</td>
     				<td>
         					<input id="dedoHuellaDos" name="dedoHuellaDos" size="15" value="" readOnly="true" iniForma = "false"/>
			    </tr>

  		</table>
  		<table border="0" cellpadding="0" cellspacing="0" width="100%" >
		<tr>
		<td class="separador">
			<span id="statusSrvHuella"></span>
		</td>
		<td class="separador"></td>
		<td class="separador"></td>
		<td class="separador"></td>
		<td class="separador"></td>
		<td class="separador"></td>
		<td class="separador"></td>
		<td class="separador"></td>
		<td class="separador"></td>
		<td class="separador"></td>
		<td class="separador"></td>
		<td align="right" colspan="3">
						<input type ="button" id="grabar" name="grabar" class="submit" value="Registrar Huella" tabIndex="3"/>


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
<div id="mensaje" style="display:none;"></div>
</html>
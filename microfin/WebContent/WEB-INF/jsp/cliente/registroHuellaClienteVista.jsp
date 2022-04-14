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
		<script type="text/javascript" src="js/cliente/registroHuellaCliente.js"></script>

	</head>
<body>
<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="huellaDigital">


		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Huella <s:message code="safilocale.cliente"/> </legend>

			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label">
			         	<label for="lblclienteID"><s:message code="safilocale.cliente"/>: </label>
			      	</td>
			      	<td class="label">
						<input id="clienteID" name="clienteID"  size="12" tabindex="1"  />
						<input id="nombreCliente" name="nombreCliente"  size="50"  readOnly="true"/>
			    	 </td>
			    	 <td class="separador"></td>
			    	<td class="label">
		         		<label for="tipoPersona">Tipo de Persona: </label>
					</td>
		     		<td>
		         		<input id="tipoPersona" name="tipoPersona" size="25" readOnly="true"/>
		     		</td>
		    	 </tr>

		        <tr>
			    	 <td class="label">
         				<label for="genero">G&eacute;nero: </label>
     				</td>
     				<td>
         				<input id="sexo" name="sexo" size="25"  readOnly="true"/>
      				</td>
      				 <td class="separador"></td>
      				<td class="label">
         				<label for="fechaNac">Fecha de Nacimiento: </label>
     				</td>
     				<td>
         				<input id="fechaNacimiento" name="fechaNacimiento" size="25"   readOnly="true"/>
      				</td>
		   		</tr>
		   		<tr>
			    	<td class="label">
         				<label for="telefono">Tel&eacute;fono: </label>
     				</td>
     				<td>
         				<input id="telefonoCasa" name="telefonoCasa" size="25" readOnly="true" />
         			</td>
         			<td class="separador"></td>
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
		<td class="separador"></td>
		<td class="separador"></td>
		<td class="separador"></td>
		<td class="separador"></td>
		<td align="right" colspan="3">
						<input type ="button" id="grabar" name="grabar" class="submit" value="Registrar Huella" tabIndex="3"/>


			</td>
		</tr>
	</table>
	 <!--  <input type="hidden" name="huellaUno" id="huellaUno"  value="" />
	  <input type="hidden" name="huellaDos" id="huellaDos"  value="" />
	  <input type="hidden" name="dedoHuellaUno" id="dedoHuellaUno"  value="" />
	  <input type="hidden" name="dedoHuellaDos" id="dedoHuellaDos"  value="" />	    -->

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
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 

<html>
	<head>
      	<script type="text/javascript" src="dwr/interface/gestoresCobranzaServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>  
      	<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/coloniaRepubServicio.js"></script> 
        <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
 	  	<script type="text/javascript" src="js/soporte/mascara.js"></script>
 	  	
 	  	<script type="text/javascript" src="js/cobranza/gestoresCobranza.js"></script>
	</head>
	
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="gestoresCobranza" >
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend  class="ui-widget ui-widget-header ui-corner-all">Gestores de Cobranza</legend>
					
					<table border="0" >
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="gestorID">Gestor:</label>
			      			</td>
			 				<td>
		       		 			<form:input type="text" id="gestorID" name="gestorID" path="gestorID" size="15" tabindex="1" maxlength = "9" autocomplete="off"/>
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="externo">Tipo Gestor:</label>
			      			</td>
							<td class="label"> 
								<label for="interno">Interno</label>
								<form:radiobutton id="interno" name="interno"  path="tipoGestor" value="I" tabindex="2" />
								
								<label for="externo">Externo</label>
								<form:radiobutton id="externo" name="externo"  path="tipoGestor" value="E" tabindex="3"/>
							</td>
						</tr>	
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="usuarioID">Usuario:</label>
			      			</td>
			 				<td>
			 					<form:input type="text" id="usuarioID" name="usuarioID" path="usuarioID" size="15" tabindex="4" maxlength = "16"/>
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="nombre">Nombre:</label>
			      			</td>
			 				<td>
		       		 			<form:input type="text" id="nombre" name="nombre" path="nombre" size="30" tabindex="5" maxlength = "45" autocomplete="off" onBlur=" ponerMayusculas(this)"/>
							</td>
						</tr>	
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="apellidoPaterno">Apellido Paterno:</label>
			      			</td>
			 				<td>
		       		 			<form:input type="text" id="apellidoPaterno" name="apellidoPaterno" path="apellidoPaterno" size="30" tabindex="6"  maxlength = "45" autocomplete="off" onBlur=" ponerMayusculas(this)"/>
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="apellidoMaterno">Apellido Materno:</label>
			      			</td>
			 				<td>
		       		 			<form:input type="text" id="apellidoMaterno" name="apellidoMaterno" path="apellidoMaterno" size="30" tabindex="7"  maxlength = "45" autocomplete="off" onBlur=" ponerMayusculas(this)"/>
							</td>
						</tr>		
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="telefonoParticular">Tel&eacute;fono Particular:</label>
			      			</td>
			 				<td>
		       		 			<form:input type="text" id="telefonoParticular" name="telefonoParticular" path="telefonoParticular" size="30" tabindex="8" maxlength = "20" autocomplete="off"/>
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="telefonoCelular">Tel&eacute;fono Celular:</label>
			      			</td>
			 				<td>
		       		 			<form:input type="text" id="telefonoCelular" name="telefonoCelular" path="telefonoCelular" size="30" tabindex="9" maxlength = "20" autocomplete="off"/>
							</td>
						</tr>					
					
					</table>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Direcci&oacute;n</legend>
						<table border="0" >
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="estadoID">Entidad Federativa:</label>
								</td>
								<td nowrap="nowrap" >
									<form:input type="text" id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="10" maxlength = "9" autocomplete="off"/>
									<input type="text" id="nombreEstado" name="nombreEstado" size="35" tabindex="11" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)"/>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="municipioID">Municipio:</label>
								</td>
								<td nowrap="nowrap">
									<form:input type="text" id="municipioID" name="municipioID" path="municipioID" size="6" tabindex="12" maxlength = "9" autocomplete="off"/>
									<input type="text" id="nombreMunicipio" name="nombreMunicipio" size="35" tabindex="13" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)"/>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="localidadID">Localidad:</label>
								</td>
								<td nowrap="nowrap">
									<form:input type="text" id="localidadID" name="localidadID" path="localidadID" size="6" tabindex="14" maxlength = "9" autocomplete="off"/>
									<input type="text" id="nombreLocalidad" name="nombreLocalidad" size="35" tabindex="15" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)"/>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="coloniaID">Colonia:</label>
								</td>
								<td nowrap="nowrap">
									<form:input type="text" id="coloniaID" name="coloniaID" path="coloniaID" size="6" tabindex="16" maxlength = "9" autocomplete="off"/>
									<input type="text" id="nombreColonia" name="nombreColonia" size="35" tabindex="17" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)"/>
								</td>
							</tr>
							<tr>								
								<td class="label" nowrap="nowrap">
									<label for="calle">Calle:</label>
			      				</td>
			 					<td>
		       		 				<form:input type="text" id="calle" name="calle" path="calle" size="45" tabindex="18"  onBlur="ponerMayusculas(this)" maxlength = "50" autocomplete="off"/> 
								</td>
								<td class="separador"></td>
								<td class="label"> 
	         						<label for="numeroCasa">N&uacute;mero:</label> 
	    						</td> 
							    <td nowrap="nowrap"> 
							         <form:input type="text" id="numeroCasa" name="numeroCasa" path="numeroCasa" size="6" tabindex="19"  onBlur=" ponerMayusculas(this)"  maxlength = "10" autocomplete="off"/>
							          <label for="numInterior">Interior: </label>
							          <form:input type="text" id="numInterior" name="numInterior" path="numInterior" size="6" tabindex="20"  onBlur="ponerMayusculas(this)" maxlength = "10" autocomplete="off"/>
							          <label for="piso">Piso: </label>
							          <form:input type="text" id="piso" name="piso" path="piso" size="6" tabindex="21"  onBlur=" ponerMayusculas(this)" maxlength = "50" autocomplete="off"/>
							    </td> 
							</tr>
							<tr>								
								<td class="label"> 
							         <label for="primeraEntreCalle">Primer Entre Calle:</label> 
							    </td> 
							    <td nowrap="nowrap"> 
							         <form:input type="text" id="primeraEntreCalle" name="primeraEntreCalle" path="primeraEntreCalle" size="45" tabindex="22"  onBlur=" ponerMayusculas(this)" maxlength = "50" autocomplete="off"/> 
							    </td> 
							     <td class="separador"></td> 
							     <td class="label" nowrap="nowrap"> 
							         <label for="segundaEntreCalle">Segunda Entre Calle:</label> 
							     </td> 
							     <td nowrap="nowrap"> 
							         <form:input type="text" id="segundaEntreCalle" name="segundaEntreCalle" path="segundaEntreCalle" size="45" tabindex="23"  onBlur=" ponerMayusculas(this)" maxlength = "50" autocomplete="off"/> 
							     </td> 
							</tr>
							<tr>									
							    <td class="label"> 
							        <label for="CP">C&oacute;digo Postal:</label> 
							    </td> 
							    <td nowrap="nowrap"> 
							        <form:input type="text" id="CP" name="CP" path="CP" size="15" tabindex="24" maxlength = "5" autocomplete="off"/> 
							    </td>
							</tr>
						</table>
					
					</fieldset>	
					
					<table border="0" >
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="porcentajeComision">% Comisi&oacute;n:</label>
			      			</td>
			 				<td>
		       		 			<form:input type="text" id="porcentajeComision" name="porcentajeComision" path="porcentajeComision" size="19" tabindex="25" maxlength = "5" autocomplete="off"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="tipoAsigCobranzaID">Tipo Asignaci&oacute;n:</label>
							</td>
							<td>
								<form:select id="tipoAsigCobranzaID" name="tipoAsigCobranzaID" path="tipoAsigCobranzaID" tabindex="26">
								<form:option value="">SELECCIONAR</form:option>
								</form:select>
							</td>
						</tr>
						<tr>								
							<td class="label"> 
								<label for="estatus">Estatus:</label> 
							</td> 
							<td nowrap="nowrap"> 
								<form:input type="text" id="estatus" name="estatus" path="estatus" size="19" maxlength="30" tabindex="27" /> 
							</td>							
						</tr>
					</table>		
					
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="agrega" name="agrega" class="submit" tabindex="28" value="Agregar" />
								<input type="submit" id="modifica" name="modifica" class="submit" tabindex="29" value="Modificar" />
								<input type="submit" id="elimina" name="elimina" class="submit" tabindex="30" value="Eliminar" />
								<input type="submit" id="activa" name="activa" class="submit" tabindex="31" value="Activar" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
								<form:input type="hidden" id="usuarioLogeadoID" name="usuarioLogeadoID" path="usuarioLogeadoID"/>
								<form:input type="hidden" id="fechaSis" name="fechaSis" path="fechaSis"/>
							</td>
						</tr>
					</table>
				</fieldset>		
			</form:form>
		</div>
		
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;overflow:">
		<div id="elementoLista"></div>
	</div>
</body>
	<div id="mensaje" style="display: none;"></div>
</html>
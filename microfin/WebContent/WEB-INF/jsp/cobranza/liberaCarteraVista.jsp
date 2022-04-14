<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 

<html>
	<head>
      	<script type="text/javascript" src="dwr/interface/gestoresCobranzaServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/asignaCarteraServicio.js"></script> 
 	  	<script type="text/javascript" src="js/soporte/mascara.js"></script>
 	  	
		<script type="text/javascript" src="js/cobranza/liberaCartera.js"></script>
		
	</head>

	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="liberaCartera" >
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Liberar Cartera Cobranza</legend>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend >Asignado</legend>
						<table border="0" >
							<tr>								
								<td class="label" nowrap="nowrap">
									<label for="asignadoID">Asignado:</label>
				      			</td>
				 				<td>
			       		 			<form:input type="text" id="asignadoID" name="asignadoID" path="asignadoID" size="15" tabindex="1" maxlength = "11" autocomplete="off"/>
								</td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="gestorID">Gestor:</label>
				      			</td>
				 				<td>
			       		 			<form:input type="text" id="gestorID" name="gestorID" path="gestorID" size="15" tabindex="2" disabled="true" readOnly="true"/>
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
									<label for="externo">Tipo Gestor:</label>
				      			</td>
								<td class="label"> 
									<label for="interno">Interno</label>
									<input type="radio" id="interno" name="tipoGestor"  value="I" tabindex="3" disabled="true" readOnly="true"/>
									
									<label for="externo">Externo</label>
									<input type="radio" id="externo" name="tipoGestor"  value="E" tabindex="4" disabled="true" readOnly="true"/>
								</td>
							</tr>	
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="usuarioID">N&uacute;mero:</label>
				      			</td>
				 				<td>
				 					<input type="text" id="usuarioID" name= "usuarioID" path="usuarioID" size="15" tabindex="5" disabled="true" readOnly="true" />
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
									<label for="nombre">Nombre:</label>
				      			</td>
				 				<td>
			       		 			<input type="text" id="nombre" name="nombre" path="nombre" size="30" tabindex="6" maxlength = "45" disabled="true" readOnly="true"/>
								</td>
							</tr>	
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="apellidoPaterno">Apellido Paterno:</label>
				      			</td>
				 				<td>
			       		 			<input type="text" id="apellidoPaterno" name="apellidoPaterno" path="apellidoPaterno" size="30" tabindex="7"  maxlength = "45" disabled="true" readOnly="true"/>
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
									<label for="apellidoMaterno">Apellido Materno:</label>
				      			</td>
				 				<td>
			       		 			<input type="text" id="apellidoMaterno" name="apellidoMaterno" path="apellidoMaterno" size="30" tabindex="8"  maxlength = "45" disabled="true" readOnly="true"/>
								</td>
							</tr>		
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="telefonoParticular">Tel&eacute;fono Particular:</label>
				      			</td>
				 				<td>
			       		 			<input type="text" id="telefonoParticular" name="telefonoParticular" path="telefonoParticular" size="30" tabindex="9" maxlength = "20" disabled="true" readOnly="true"/>
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
									<label for="telefonoCelular">Tel&eacute;fono Celular:</label>
				      			</td>
				 				<td>
			       		 			<input type="text" id="telefonoCelular" name="telefonoCelular" path="telefonoCelular" size="30" tabindex="10" maxlength = "20" disabled="true" readOnly="true"/>
								</td>
							</tr>					
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="porcentajeComision">% Comisi&oacute;n:</label>
				      			</td>
				 				<td>
			       		 			<input type="text" id="porcentajeComision" name="porcentajeComision" path="porcentajeComision" size="30" tabindex="11" maxlength = "2"  disabled="true" readOnly="true"/>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="tipoAsigCobranzaID">Tipo Asignaci&oacute;n:</label>
								</td>
								<td>
									<select id="tipoAsigCobranzaID" name="tipoAsigCobranzaID" path="tipoAsigCobranzaID" tabindex="12"  disabled="true" readOnly="true">
									<option value="">SELECCIONAR</option>
									</select>
								</td>
							</tr>
							<tr>								
								<td class="label"> 
									<label for="estatus">Estatus:</label> 
								</td> 
								<td nowrap="nowrap"> 
									<input type="text" id="estatus" name="estatus" path="estatus" size="15" maxlength="50" tabindex="13"  disabled="true" readOnly="true"/> 
								</td>							
							</tr>						
						</table>
						<table align="right">
							<tr>
								<td align="right">
									<input type="button" id="buscar" name="buscar" class="submit" tabindex="14" value="Buscar" />
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
								</td>
							</tr>
						</table>
					</fieldset>	
					
		 			<input type="hidden" id="listaGridCredLib" name="listaGridCredLib" size="100" />
					
					<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldsetLisCred" style="display: none;" >
						<legend >Listado de Cr&eacute;ditos	</legend>	
						<table align="right">
							<tr>
								<div id="divListaCreditos" style="overflow: scroll; width: 100%; height: 500px; display: none;" ></div>	
								<td align="right">	
								<input type="submit" id="liberar" name="liberar" class="submit" value="Liberar" tabindex="15" />
								<input type="button" id="generar" name="generar" class="submit" value="Generar Reporte" tabindex="16" />
								<form:input type="hidden" id="usuarioLogeadoID" name="usuarioLogeadoID" path="usuarioLogeadoID"/>
								<form:input type="hidden" id="fechaSis" name="fechaSis" path="fechaSis"/>	
												
								</td>				
							</tr>
						</table>												
					</fieldset>
					
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
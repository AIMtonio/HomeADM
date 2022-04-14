<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 

<html>
	<head>
      	<script type="text/javascript" src="dwr/interface/gestoresCobranzaServicio.js"></script> 
 	  	<script type="text/javascript" src="js/soporte/mascara.js"></script>
        <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>  
      	<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/coloniaRepubServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/asignaCarteraServicio.js"></script> 
      	
		<script type="text/javascript" src="js/cobranza/asignaCartera.js"></script>
	</head>

	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="asignaCarteraBean" >
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Asignaci&oacute;n de Cartera</legend>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend >Asignaci&oacute;n</legend>
						<table border="0">
							<tr>								
								<td class="label" nowrap="nowrap">
									<label for="asignadoID">Asignado:</label>
				      			</td>
				 				<td>
			       		 			<form:input type="text" id="asignadoID" name="asignadoID" path="asignadoID" size="15" tabindex="1" maxlength = "9" autocomplete="off"/>
								</td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="gestorID">Gestor:</label>
				      			</td>
				 				<td>
			       		 			<form:input type="text" id="gestorID" name="gestorID" path="gestorID" size="15" tabindex="2" maxlength = "9" autocomplete="off"/>
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
			       		 			<input type="text" id="porcentajeComision" name="porcentajeComision" path="porcentajeComision" size="15" tabindex="11" maxlength = "5"  disabled="true" readOnly="true"/>
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
					</fieldset>	
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend >B&uacute;squeda de Cr&eacute;ditos	</legend>
						<table border="0" >
							<tr>	
								<td class="label" nowrap="nowrap">
									<label for="diasAtrasoMin">D&iacute;as Atraso M&iacute;nimo:</label>
				      			</td>
				 				<td>
			       		 			<form:input type="text" id="diasAtrasoMin" name="diasAtrasoMin" path="diasAtrasoMin" size="15" tabindex="14" maxlength = "9" autocomplete="off" onkeypress="return validaSoloNumero(event,this);"/>
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
									<label for="diasAtrasoMax">D&iacute;as Atraso M&aacute;ximo:</label>
				      			</td>
				 				<td>
			       		 			<form:input type="text" id="diasAtrasoMax" name="diasAtrasoMax" path="diasAtrasoMax" size="15" tabindex="15" maxlength = "9" autocomplete="off" onkeypress="return validaSoloNumero(event,this);"/>
								</td>
							</tr>
							<tr>	
								<td class="label" nowrap="nowrap">
									<label for="adeudoMin">Adeudo M&iacute;nimo:</label>
				      			</td>
				 				<td>																																	 
			       		 			<form:input type="text" id="adeudoMin" name="adeudoMin" path="adeudoMin" size="15" tabindex="16" maxlength = "18" autocomplete="off" esMoneda="true" style="text-align: right" />
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
									<label for="adeudoMax">Adeudo M&aacute;ximo:</label>
				      			</td>
				 				<td>
			       		 			<form:input type="text" id="adeudoMax" name="adeudoMax" path="adeudoMax" size="15" tabindex="17" maxlength = "18" autocomplete="off" esMoneda="true" style="text-align: right" />
								</td>
							</tr>
							<tr>								
							 	<td class="label">
						 			<label for="estatusCreditos">Estatus Cr&eacute;ditos:</label>
						 		</td>
						 		<td>
						 			<select multiple id="estatusCreditos" name="estatusCreditos" path="estatusCreditos" tabindex="18" size="4">
								     	<option value="V">VIGENTE</option>
								     	<option value="B">VENCIDO</option>
								     	<option value="K">CASTIGADO</option>
						     		</select>
								</td>
								<td class="separador"></td>
							    <td class="label"> 
							    	<label for="sucursalID">Sucursal:</label> 
							    </td>
							    <td  nowrap="nowrap">
							    	<form:input type="text" id="sucursalID" name="sucursalID" path="sucursalID" size="6" tabindex="19" maxlength = "9"/>  
							        <input type="text" id="nombreSucursal" name="nombreSucursal" size="35"  disabled= "true" readOnly="true"/>  
							    </td> 
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="estadoID">Estado:</label>
								</td>
								<td nowrap="nowrap">
									<form:input type="text" id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="20" maxlength = "9" autocomplete="off"/>
									<input type="text" id="nombreEstado" name="nombreEstado" size="35" tabindex="21" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)"/>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="municipioID">Municipio:</label>
								</td>
								<td nowrap="nowrap">
									<form:input type="text" id="municipioID" name="municipioID" path="municipioID" size="6" tabindex="22" maxlength = "9" autocomplete="off"/>
									<input type="text" id="nombreMunicipio" name="nombreMunicipio" size="35" tabindex="23" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)"/>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="localidadID">Localidad:</label>
								</td>
								<td nowrap="nowrap">
									<form:input type="text" id="localidadID" name="localidadID" path="localidadID" size="6" tabindex="24" maxlength = "9" autocomplete="off"/>
									<input type="text" id="nombreLocalidad" name="nombreLocalidad" size="35" tabindex="25" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)"/>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="coloniaID">Colonia:</label>
								</td>
								<td nowrap="nowrap">
									<form:input type="text" id="coloniaID" name="coloniaID" path="coloniaID" size="6" tabindex="26" maxlength = "9" autocomplete="off"/>
									<input type="text" id="nombreColonia" name="nombreColonia" size="35" tabindex="27" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)"/>
								</td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="limiteRenglones">L&iacute;mite renglones:</label>
				      			</td>
				 				<td>
			       		 			<form:input type="text" id="limiteRenglones" name="limiteRenglones" path="limiteRenglones" size="15" tabindex="27" maxlength = "9" autocomplete="off" onkeypress="return validaSoloNumero(event,this);"/>
								</td>								
							</tr>
						</table>
						<table align="right">
						<tr>
							<td align="right">
								<input type="button" id="buscar" name="buscar" class="submit" tabindex="28" value="Buscar" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
							</td>
						</tr>
					</table>
					</fieldset>
					
		 			<input type="hidden" id="listaGridCreditos" name="listaGridCreditos" size="100" />
					
					<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldsetLisCred" style="display: none;" >
						<legend >Listado de Cr&eacute;ditos	</legend>	
						<table align="right">
							<tr>
								<div id="divListaCreditos" style="overflow: scroll; width: 100%; height: 300px; display: none;" ></div>	
								<td align="right">	
									<input type="submit" id="asignar" name="asignar" class="submit" value="Asignar" tabindex="101" />
									<input type="button" id="generar" name="generar" class="submit" value="Generar Reporte" tabindex="102" />
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
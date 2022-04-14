<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 

<html>
	<head>
        <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>  
      	<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/coloniaRepubServicio.js"></script> 
 	  <script type="text/javascript" src="js/soporte/mascara.js"></script>
      	
		<script type="text/javascript" src="js/cobranza/emisionNotiCob.js"></script>
	</head>

	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="emisionNotiCobBean" >
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Emisi&oacute;n de Notificaciones</legend>
						<table>
							<tr>
							    <td class="label"> 
							    	<label for="sucursalID">Sucursal:</label> 
							    </td>
							    <td  nowrap="nowrap">
							    	<form:input type="text" id="sucursalID" name="sucursalID" path="sucursalID" size="6" tabindex="1" maxlength = "9"/>  
							        <input type="text" id="nombreSucursal" name="nombreSucursal" size="35"  disabled= "true" readOnly="true"/>  
							    </td> 
								<td class="separador"></td>								
							 	<td class="label">
						 			<label for="estCredBusq">Estatus Cr&eacute;ditos:</label>
						 		</td>
						 		<td>
						 			<form:select id="estCredBusq" name="estCredBusq" path="estCredBusq" tabindex="2" >
								     	<form:option value="">SELECCIONAR</form:option>
								     	<form:option value="V-B">VIGENTE-VENCIDO</form:option>
								     	<form:option value="V">VIGENTE</form:option>
								     	<form:option value="B">VENCIDO</form:option>
						     		</form:select>
								</td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="estadoID">Estado:</label>
								</td>
								<td nowrap="nowrap">
									<form:input type="text" id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="3" maxlength = "9" autocomplete="off"/>
									<input type="text" id="nombreEstado" name="nombreEstado" size="35" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)"/>
								</td>
								<td class="separador"></td>	
								<td class="label" nowrap="nowrap">
									<label for="diasAtrasoIni">D&iacute;as Atraso Inicial:</label>
				      			</td>
				 				<td>
			       		 			<form:input type="text" id="diasAtrasoIni" name="diasAtrasoIni" path="diasAtrasoIni" size="15" tabindex="4" maxlength = "9" autocomplete="off" onkeypress="validaSoloNumero(event,this)"/>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="municipioID">Municipio:</label>
								</td>
								<td nowrap="nowrap">
									<form:input type="text" id="municipioID" name="municipioID" path="municipioID" size="6" tabindex="5" maxlength = "9" autocomplete="off"/>
									<input type="text" id="nombreMunicipio" name="nombreMunicipio" size="35" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)"/>
								</td>
								<td class="separador"></td>	
							    <td class="label" nowrap="nowrap">
									<label for="diasAtrasoFin">D&iacute;as Atraso Final:</label>
				      			</td>
				 				<td>
			       		 			<form:input type="text" id="diasAtrasoFin" name="diasAtrasoFin" path="diasAtrasoFin" size="15" tabindex="6" maxlength = "9" autocomplete="off" onkeypress="validaSoloNumero(event,this)"/>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="localidadID">Localidad:</label>
								</td>
								<td nowrap="nowrap">
									<form:input type="text" id="localidadID" name="localidadID" path="localidadID" size="6" tabindex="7" maxlength = "9" autocomplete="off"/>
									<input type="text" id="nombreLocalidad" name="nombreLocalidad" size="35" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)"/>
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
									<label for="limiteRenglones">L&iacute;mite de Renglones:</label>
				      			</td>
				 				<td>
			       		 			<form:input type="text" id="limiteRenglones" name="limiteRenglones" path="limiteRenglones" size="15" tabindex="7" maxlength = "9" autocomplete="off" onkeypress="validaSoloNumero(event,this)"/>
								</td>								
							</tr>
							<tr>
								<td class="label">
									<label for="coloniaID">Colonia:</label>
								</td>
								<td nowrap="nowrap">
									<form:input type="text" id="coloniaID" name="coloniaID" path="coloniaID" size="6" tabindex="8" maxlength = "9" autocomplete="off"/>
									<input type="text" id="nombreColonia" name="nombreColonia" size="35" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)"/>
								</td>	
								<td class="separador"></td>													
							</tr> 							    
						</table>
					<table align="right">
						<tr>
							<td align="right">
								<input type="button" id="buscar" name="buscar" class="submit" tabindex="9" value="Consultar" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
							</td>
						</tr>
					</table>
					</br>					
					<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldsetLisCred" style="display: none;" >
						<legend >Listado de Cr&eacute;ditos	</legend>	
						<table align="right">
							<tr>
								<div id="divListaCreditos" style="overflow: scroll; width: 100%; height: 500px; display: none;" ></div>	
								<td align="right">	
									<input type="submit" id="emitir" name="emitir" class="submit" value="Emitir" tabindex="101" />
									<form:input type="hidden" id="usuarioID" name="usuarioID" path="usuarioID"/>
									<form:input type="hidden" id="fechaSis" name="fechaSis" path="fechaSis"/>
									<form:input type="hidden" id="claveUsuario" name="claveUsuario" path="claveUsuario"/>
									<form:input type="hidden" id="sucursalUsuID" name="sucursalUsuID" path="sucursalUsuID"/>	
									<form:input type="hidden" id="nombreInsti" name="nombreInsti" path="nombreInsti"/>							
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
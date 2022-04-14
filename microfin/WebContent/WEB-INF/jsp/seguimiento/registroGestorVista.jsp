<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/catTiposGestionServicio.js"></script>
 	  	<script type="text/javascript" src="dwr/interface/registroGestorServicio.js"></script> 
 	  	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script> 
   		<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
   		<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script> 
   		<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script> 
   		<script type="text/javascript" src="dwr/interface/coloniaRepubServicio.js"></script> 
   		<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script> 
     	<script type="text/javascript" src="js/seguimiento/registroGestor.js"></script>     
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="registroGestorBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">	
	<legend class="ui-widget ui-widget-header ui-corner-all">Administraci&oacute;n de Gestores</legend>		
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label">
				<label for="lblGestor">Gestor: </label>
				</td>
			<td>
				 <input type="text" id="gestorID" name="gestorID" size="11" tabindex="1"   autocomplete="off"/>
				 <input type="text" id="nombreGestor" name="nombreGestor" size="68"  readOnly="true" iniForma="false"/>	 
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="lblTipoGestorID">Tipo Gesti&oacute;n: </label>
			</td>
		  	<td nowrap="nowrap">
				<input type="text" id="tipoGestionID" name="tipoGestionID"  size="11" tabindex="2"  autocomplete="off"/>
				<input type="text" id="nombreTipoGestion" name="nombreTipoGestion" size="68" readOnly="true" iniForma="false"/>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="lblSupervisor">Supervisor: </label>
			</td>
		  	<td nowrap="nowrap">
				<input type="text" id="supervisorID" name="supervisorID"  size="11" tabindex="3"  autocomplete="off"/>
				<input type="text" id="nombreSupervisor" name="nombreSupervisor" size="68" readOnly="true" iniForma="false"/>
			</td>
		</tr>
	</table>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">	
		<legend >&Aacute;mbito</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label"> 
					<form:radiobutton id="tipoAmbito1" name="tipoAmbito1" path="tipoAmbito"
				 		value="1" tabindex="4"  />
					<label for="lblClientes">Sus Clientes</label>&nbsp;&nbsp;
					<form:radiobutton id="tipoAmbito2" name="tipoAmbito2" path="tipoAmbito"
						value="2" tabindex="5"/>
					<label for="lblSucursal">Sucursal</label>
					<form:radiobutton id="tipoAmbito3" name="tipoAmbito3" path="tipoAmbito" 
						value="3" tabindex="6"/>
					<label for="lblZona">Zona Geogr&aacute;fica</label>	
					<form:radiobutton id="tipoAmbito4" name="tipoAmbito4" path="tipoAmbito" 
						value="4" tabindex="7"/>
					<label for="lblPromotor">Cuentas de Otro Promotor</label>	
			</tr>
		</table>
		<br>
	<div id="gridSucursal" >
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">		
					<tr>
						<td>
						<input type="button" id="agregaSucursal" value="Agregar"
							 class="botonGral" onclick="agregarGestorSucursal()" tabindex="8" />
						</td>
					</tr>
				</table>
				<table border="0" cellpadding="0" cellspacing="0" width="70%">
					<tr>
						<td class="label">
							<label>Num.Sucursal</label>									
						</td>
						<td class="label" align="center">
							<label>Descripci&oacute;n</label>
						</td>
					</tr>
				</table>
				<input type="hidden" id="numSucursal" name="numSucursal" />
				<table id="tableGestorSucursal" border="0" cellpadding="0" cellspacing="0" width="100%">
							
				</table>
		</fieldset>
	</div>
	<div id="gridZona">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<table border="0" cellpadding="0" cellspacing="0" width="10%">	
					<tr>
						<td>			
						<input type="button" id="agregaZona" value="Agregar" 
							class="botonGral" onclick="agregarGestorZona()" tabindex="9" />
						</td>
					</tr>
				</table>
			    <table border="0" cellpadding="0" cellspacing="0" width="95%">
					<tr>
						<td>
					   		<label>Estado</label>&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
						<td>
					   		<label>Descripci&oacute;n</label>
						</td>
						<td>
					   		<label>Municipio</label>
						</td>
						<td>
					   		<label>Descripci&oacute;n</label>
						</td>
						<td>
					   		<label>Localidad</label> 
						</td>					
						<td>
					   		<label>Descripci&oacute;n</label> 
						</td>
						<td>
					   		<label>Colonia</label>
						</td>
						<td>
					   		<label>Descripci&oacute;n</label> 
						</td>
					</tr>
				   </table> 
				   <input type="hidden" id="numZona" name="numZona" />
				<table id="tableZonaGeografica" border="0" cellpadding="0" cellspacing="0" width="100%">	
				</table>
		</fieldset>
	</div>
		<div id="gridPromotor" >
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">		
					<tr>
						<td>
						<input type="button" id="agregaPromotor" value="Agregar"
							 class="botonGral" onclick="agregarGestorPromotor()" tabindex="10" />
						</td>
					</tr>
				</table>
				<table border="0" cellpadding="0" cellspacing="0" width="70%">
					<tr>
						<td class="label">
							<label>Num.Promotor</label>									
						</td>
						<td class="label" align="center">
							<label>Descripci&oacute;n</label>
						</td>
					</tr>
				</table>
				<input type="hidden" id="numPromotor" name="numPromotor" />
				<table id="tableGestorPromotor" border="0" cellpadding="0" cellspacing="0" width="100%">	
				</table>
		</fieldset>
	</div>
	</fieldset>
	<table width="100%">
		<tr>
			<td align="right">
				<input type="submit" id="agrega" name="agrega" class="submit" value="Grabar"  tabindex="11"/>
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
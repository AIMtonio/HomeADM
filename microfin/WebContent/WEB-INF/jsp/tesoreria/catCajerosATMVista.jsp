<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>

<head>															
		<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script>
 		<script type="text/javascript" src="dwr/interface/catCajerosATMServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
 		<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/coloniaRepubServicio.js"></script>
		<script type="text/javascript" src="js/tesoreria/catCajeroATM.js"></script>
</head>
<body>


	<div id="contenedorForma">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Cat&aacute;logo ATMs</legend>
      			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="catCajerosATMBean">  
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label">
				<label for="cajeroID">Cajero : </label>
			</td>
			<td>
				<form:input id="cajeroID" name="cajeroID" path="cajeroID" size="12" tabindex="1"  />
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="estatus">Estatus :</label>
			</td>
			<td>
				<form:input id="estatus" name="estatus" path="estatus" size="12" disabled="true" readOnly="true" iniForma="false"/>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label>Núm. Cajero PROSA:</label>
			</td>
			<td>
				<form:input id="numCajeroPROSA" name="numCajeroPROSA" path="" size="12" tabindex="2"/>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="usuarioID">Usuario : </label>
			</td>
		  	<td>
				<form:input id="usuarioID" name="usuarioID" path="usuarioID" size="6"  tabindex="3"/>
				<form:input type="text" id="usuario" name="usuario" path="nombreCompleto" size="35" disabled="true" readOnly="true" iniForma="false"/>
			</td>			
		</tr>
		<tr>
			<td class="label">
				<label for="sucursalID">Sucursal : </label>
			</td>
		  	<td>
				<form:input id="sucursalID" name="sucursalID" path="sucursalID"  size="12"  tabindex="4"/>
				<form:input type="text" id="nombreSucursal" name="nombreSucursal" path="nombreSucursal" size="	34" disabled="true" readOnly="true" iniForma="false"/>
			</td>
			<td class="separador"></td>
			<td class="label">
					<label for="saldoMN">Saldo ATM M.N. :</label>
			</td>
			<td>
				<form:input id="saldoMN" name="saldoMN" esMoneda="true" path="saldoMN" size="12"  disabled="true" readOnly="true" iniForma="false" />
			</td>
		</tr>
		<tr>
			<td class="label"> 
				<label for="saldoMN">Saldo ATM M.E. :</label>
			</td>
			<td>
				<form:input id="saldoME" name="saldoME" path="saldoME" esMoneda="true" size="12" disabled="true" readOnly="true" iniForma="false"/>
			</td>
			<td class="separador"></td>
			<td class="label">
					<label for="tipoCajeroID">Tipo:</label>
			</td>
			<td>
				<select name="tipoCajeroID" id="tipoCajeroID"></select>
			</td>
		</tr>
	</table>
  	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Dirección Cajero</legend>
		<table>
			<tr>
				<td class="label"><label>Estado:</label></td>
				<td><input type="text" id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="5" /></td>
				<td><input type="text" id="nombreEstado" name="nombreEstado"  size="40" readonly="true" disabled="true" /></td>
				<td class="separador"></td>
				<td class="label"><label>Municipio:</label></td>
				<td><input type="text" id="municipioID" name="municipioID" path="municipioID" size="6" tabindex="6" /></td>
				<td><input type="text" id="nombreMuni" name="nombreMuni" size="40" readonly="true" disabled="true" /></td>
			</tr>
			<tr>
				<td class="label"><label>Localidad:</label></td>
				<td><input type="text" id="localidadID" name="localidadID" path="localidadID" size="6" tabindex="7" /></td>
				<td><input type="text" id="nombrelocalidad" name="nombrelocalidad" size="40" readonly="true" disabled="true" /></td>
				<td class="separador"></td>
				<td class="label"><label>Colonia:</label></td>
				<td><input type="text" id="coloniaID" name="coloniaID" path="coloniaID" size="6" tabindex="8" /></td>
				<td><input type="text" id="nombreColonia" name="nombreColonia" size="40" readonly="true" disabled="true" /></td>
			</tr>
			<tr>
				<td class="label"><label>Calle:</label></td>
				<td colspan="2"><input type="text" id="calle" name="calle" path="calle" size="51" tabindex="9" onblur="ponerMayusculas(this)" maxlength="150" /></td>
				<td class="separador"></td>
				<td class="label"><label>Número:</label></td>
				<td><input type="text" id="numero" name="numero" path="numero" size="6" tabindex="10" maxlength="20" onblur="ponerMayusculas(this)" /></td>

				<td class="label"><label>Interior:</label>
				<input type="text" id="numInterior" name="numInterior" path="numInterior" size="6" tabindex="11" maxlength="20" onblur="ponerMayusculas(this)" /></td>
			</tr>
			
			<tr> 
		       	<td class="label"> 
		        	<label for="cp">Código Postal: </label> 
		     	</td> 
		     	<td colspan="2"> 
		        	<form:input type="text" id="cp" name="cp" path="cp" size="6" tabindex="12"  onBlur=" ponerMayusculas(this)" maxlength="5" /> 
		     	</td>  
		       	<td class="separador"></td> 
		     	<td class="label"> 
		       		<label for="latitud">Latitud: </label> 
		   		</td> 
		  	 	<td colspan="2"> 
		       		<form:input type="text" id="latitud" name="latitud" path="latitud" size="13" tabindex="13" maxlength="10" /> 
			   	</td>
			</tr>
			
			<tr> 
		        <td class="label"> 
		       		<label for="longitud">Longitud: </label> 
		   		</td> 
		  	 	<td colspan="2"> 
		       		<form:input type="text" id="longitud" name="longitud" path="longitud" size="13" tabindex="14" maxlength="11" /> 
			   	</td>
			</tr>
		
		
			<tr>
				<td class="label">
					<label for="ubicacion">Dirección Completa:</label>
				</td>
				<td colspan="7">
					<textarea id="ubicacion" name="ubicacion" tabindex="15" rows="3" cols="70" onblur="ponerMayusculas(this)" maxlength="500"></textarea>
				</td>
		</tr>

		</table>
	</fieldset>
      <br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Cuentas Contables</legend>
	</br>		
		<table>
				<tr>					
					<td class="label">
						<label for="ctaContableMN">Efectivo M.N</label>
					</td>
					<td>
						<form:input id="ctaContableMN" name="ctaContableMN" path="ctaContableMN" size="20" tabindex="16"/>
						<input type="text" id="descripcionCtaContaMN" name="descripcionCtaContaMN" size="50" disabled="true"
								readOnly="true" iniForma="false"/>
					</td>
				</tr>
				<tr>				
					<td class="label">
						<label for="ctaContableME">Efectivo M.E.</label>
					</td>
					<td>
						<form:input id="ctaContableME" name="ctaContableME" path="ctaContableME" size="20" tabindex="17" />
						<input type="text" id="descripcionCtaContaME" name="descripcionCtaContaME" size="50" disabled="true"
								readOnly="true" iniForma="false" />
					</td>					
				</tr>
				<tr>				
					<td class="label">
						<label for="ctaContaMNTrans">Efectivo en Tr&aacute;nsito M.N.</label>
					</td>
					<td>
						<form:input id="ctaContaMNTrans" name="ctaContaMNTrans" path="ctaContaMNTrans" size="20" tabindex="18" />
						<input type="text" id="desripcionCtaContableMN" name="desripcionCtaContableMN" size="50" disabled="true"
								readOnly="true" iniForma="false"/>
					</td>						
								
				</tr>
				<tr>			
					<td class="label">
						<label for="ctaContaMETrans">Efectivo en Tr&aacute;nsito M.E.</label>
					</td>
					<td>
						<form:input id="ctaContaMETrans" name="ctaContaMETrans" path="ctaContaMETrans" size="20" tabindex="19"/>
						<input type="text" id="desripcionCtaContableME" name="desripcionCtaContableME" size="50" disabled="true"
								readOnly="true" iniForma="false"/>
					</td>														
				</tr>

				<tr> 
			      <td class="label"> 
			         <label for="lblnomenclaturaCR">Nomenclatura Centro Costo:</label> 
			     	</td>
			     	<td>
			     		<input id="nomenclaturaCR" name="nomenclaturaCR"  size="25" tabindex="20" /> 
						<a href="javaScript:" onClick="ayudaCR();">
						  	<img src="images/help-icon.gif" >
						</a> 
			     	</td>  	
				</tr> 
				<tr>
					<td class="label"> 
				     <label for="lblClaves"><b>Claves de Nomenclatura  Centro Costo: 	
				     <i>
				     <br><a href="javascript:" onClick="concatenaNomenclatura('nomenclaturaCR','&SO');">  &SO = Sucursal Cajero </a>
				     <br><a href="javascript:" onClick="concatenaNomenclatura('nomenclaturaCR','&SC');">  &SC = Sucursal <s:message code="safilocale.cliente"/></a></b> </label> 
				 		</i>	
				 	</td>
				</tr>
		</table>
	</fieldset>
      			 <table width="100%">
					<tr>
						<td align="right">
								<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar"  tabindex="21"/>
								<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar"  tabindex="22"/>	
								<input type="submit" id="cancela" name="cancela" class="submit" value="Cancelar"  tabindex="23"/>						
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
								<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>
						</td>
					</tr>
				</table>		     		
      		</form:form>	
		</fieldset>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
<div id="ContenedorAyuda" style="display: none;">
	<div id="elementoLista"/>
</div>

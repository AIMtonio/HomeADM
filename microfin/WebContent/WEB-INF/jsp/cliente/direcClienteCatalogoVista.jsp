<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
<head>	
		<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/identifiClienteServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>  
      	<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/coloniaRepubServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/tiposDireccionServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>   
      	<script type="text/javascript" src="js/cliente/direcClienteCatalogo.js"></script> 
		<script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyB6-3X95DFPxVjSbonYpOTYUHf3KjepOFs&signed_in=true"></script>
	  
</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="direccionesCliente">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Direcciones del <s:message code="safilocale.cliente"/></legend>			
<table border="0"  width="100%">
	<tr>
		<td class="label"> 
	         <label for="clienteID">No. de <s:message code="safilocale.cliente"/>: </label> 
		</td>
	    <td nowrap="nowrap">
	    	<form:input id="clienteID" name="clienteID" path="clienteID" size="15" tabindex="1" iniforma='false' />  
	        <input type="text" id="nombreCliente" name="nombreCliente" size="50" tabindex="2" disabled= "true" 
	          readonly="true" iniforma='false'/>  
		</td> 
	<td class="separador"></td> 
		<td class="label"> 
	     	<label for="direccionID">N&uacute;mero: </label> 
	    </td> 
	    <td  nowrap="nowrap"> 
	    	<form:input id="direccionID" name="direccionID" path="direccionID" size="6" tabindex="3" iniforma='false' autocomplete="off"/> 
	    </td> 
	</tr> 
	<tr>
		<td class="label"> 
	         <label for="tipoDireccionID">Tipo de Direcci&oacute;n: </label> 
	    </td> 
	    <td  nowrap="nowrap"> 
	    	<form:select id="tipoDireccionID" name="tipoDireccionID" path="tipoDireccionID" tabindex="4">
					<form:option value="">SELECCIONAR</form:option> 
			</form:select>
	    </td>  
	</tr> 
	
	<tr>
		<td class="label"> 
	         <label for="lblPais">Pa&iacute;s: </label> 
	    </td> 
	    <td nowrap="nowrap">
			<form:input type="text" id="paisID" name="paisID" path="paisID" size="6" tabindex="5" maxlength="8" autocomplete="off"/>
			<input type="text" id="nombrePais" name="nombrePais" size="35" readonly="true"/>
		</td> 
		<td class="separador" id="tdSeparador"></td> 
		<td class="label" nowrap="nowrap" id="tdEntidad"> 
	         <label for="estado">Entidad Federativa: </label> 
	    </td> 
	    <td nowrap="nowrap" id="tdEstado"> 
	         <form:input id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="5" /> 
	         <input type="text" id="nombreEstado" name="nombreEstado" size="35" tabindex="6" disabled ="true"
	           readonly="true"/>   
		</td> 
	</tr>
	
	<tr id="trMuniLoc"> 
	     <td class="label"> 
	         <label for="municipio">Municipio: </label> 
	     </td> 
	     <td nowrap="nowrap"> 
	         <form:input id="municipioID" name="municipioID" path="municipioID" size="6" tabindex="7" /> 
	         <input type="text" id="nombreMuni" name="nombreMuni" size="35" tabindex="7" disabled="true"
	          readonly="true"/>   
	     </td> 
	          <td class="separador"></td> 
	          	 <td class="label"> 
	          <label for="calle">Localidad: </label> 
	     </td> 
	     <td nowrap="nowrap"> 
	         <form:input id="localidadID" name="localidadID" path="localidadID" size="6" tabindex="8"  autocomplete="off" /> 
	     <input type="text" id="nombrelocalidad" name="nombrelocalidad" size="35" tabindex="8" disabled="true" onBlur=" ponerMayusculas(this)"
	          readonly="true"/>   
	     </td>  
	     
	</tr> 
	<tr id="trColCiudad">
		<td class="label"> 
			<label for="calle">Colonia: </label> 
		</td> 
		<td nowrap="nowrap"> 
			<form:input id="coloniaID" name="coloniaID" path="coloniaID" size="6" tabindex="9" /> 
			<input type="text" id="nombreColonia" name="nombreColonia" size="35" tabindex="9" disabled="true"  onBlur=" ponerMayusculas(this)"
				maxlength = "200" readonly="true"/>   
		</td> 
		<td class="separador"></td>
		<td class="label"> 
			<label for="calle">Ciudad: </label> 
		</td> 
		<td nowrap="nowrap">
			<input type="text" id="nombreCiudad" name="nombreCiudad" size="45" tabindex="10" disabled="true"  onBlur="ponerMayusculas(this)"
				maxlength = "200" readonly="true"/>
		</td>
	</tr>
	<tr id="trCalleNumero"> 
		<td class="label"> 
			<label for="calle">Calle: </label> 
		</td> 
		<td nowrap="nowrap"> 
			<form:input id="calle" name="calle" path="calle" size="45" tabindex="11"  onBlur=" ponerMayusculas(this)" maxlength = "50"/> 
		</td> 
		<td class="separador"></td>
	    <td class="label"> 
	         <label for="numero">N&uacute;mero: </label> 
	    </td> 
	    <td nowrap="nowrap"> 
	         <form:input id="numeroCasa" name="numeroCasa" path="numeroCasa" size="5" tabindex="12"  onBlur=" ponerMayusculas(this)" />
	          <label for="exterior">Interior: </label>
	          <form:input id="numInterior" name="numInterior" path="numInterior" size="5" tabindex="13"  onBlur=" ponerMayusculas(this)"/>
	          <label for="exterior">Piso: </label>
	          <form:input id="piso" name="piso" path="piso" size="5" tabindex="14"  onBlur=" ponerMayusculas(this)"/>
	    </td> 
	 </tr> 
	<tr id="trPrimerSegundaCalle"> 
		<td class="label"> 
	         <label for="primEntreCalle">Primer Entre Calle: </label> 
	     </td> 
	     <td nowrap="nowrap"> 
	         <form:input id="primEntreCalle" name="primEntreCalle" path="primEntreCalle" size="50" tabindex="15"  onBlur=" ponerMayusculas(this)" maxlength = "50"/> 
	     </td> 
	     <td class="separador"></td> 
	     <td class="label" nowrap="nowrap"> 
	         <label for="segEntreCalle">Segunda Entre Calle: </label> 
	     </td> 
	     <td nowrap="nowrap"> 
	         <form:input id="segEntreCalle" name="segEntreCalle" path="segEntreCalle" size="50" tabindex="16"  onBlur=" ponerMayusculas(this)" maxlength = "50" /> 
	     </td> 	    	  
	 </tr> 	 
	 <tr id="trCodigoLatitud"> 
	 	<td class="label"> 
	         <label for="CP">C&oacute;digo Postal: </label> 
	     </td> 
	     <td nowrap="nowrap"> 
	         <form:input id="CP" name="CP" path="CP" size="15" maxlength="5" tabindex="17" /> 
	     </td>
	    <td class="separador"></td>
	 	<td class="label"> 
	         <label for="Latitud">Latitud: </label> 
	    </td> 
	    <td nowrap="nowrap"> 
	   		<form:input id="latitud" name="latitud" path="latitud" size="20" tabindex="18" maxlength = "45" /> 
	    </td>  
	</tr>
	<tr id="trLongitud">
		<td class="label"> 
	    	<label for="Longitud">Longitud: </label> 
	    </td> 
	    <td nowrap="nowrap"> 
			<form:input id="longitud" name="longitud" path="longitud" size="20" tabindex="19" maxlength = "45"/> 
	    </td>
     	<td class="separador"></td>
     	<td class="label"> 
	    	<label for="aniosRes">A&ntilde;os de Residencia: </label> 
	    </td> 
	    <td nowrap="nowrap"> 
			<form:input id="aniosRes" name="aniosRes" path="aniosRes" size="6" tabindex="20" maxlength="3"/> 
			<label for="aniosRes">Mes(es)</label>			
	    </td>
	</tr>
	<tr>
	    <td class="label" id="lblDescripcion"> 
	    	<label for="Descripcion">Descripci&oacute;n: </label> 
	  	</td> 
	    <td nowrap="nowrap" id="tdDescripcion">
			<form:textarea id="descripcion" name="descripcion" path="descripcion" COLS="35" ROWS="4" tabindex="21"  onBlur=" ponerMayusculas(this)" maxlength = "200"/> 
		</td>   
	    <td class="separador" id="tdSeparadorCheck"></td>
		<td class="label"> 
			<form:input TYPE="checkbox" id="oficial" name="oficial" path="oficial"  tabindex="22" value="S"/>
		   	<label for="ofici">Oficial </label> 
		</td> 
		<td class="label"> 
			<form:input TYPE="checkbox" id="fiscal" name="fiscal" path="fiscal"  tabindex="23" value="S"/>
		   	<label for="fisc">Fiscal </label> 
		</td> 
	</tr>
	<tr id="trLoteManzana"> 
		 <td class="label"> 
	     	<label for="Lote">Lote: </label> 
	     </td> 
	     <td nowrap="nowrap"> 
	         <form:input id="lote" name="lote" path="lote" size="20" tabindex="24" onBlur=" ponerMayusculas(this)"/> 
	     </td> 
	     <td class="separador"></td> 
	     <td class="label"> 
	         <label for="Manzana">Manzana: </label> 
	     </td> 
	     <td nowrap="nowrap"> 
	         <form:input id="manzana" name="manzana" path="manzana" size="20" tabindex="25"  onBlur=" ponerMayusculas(this)"/> 
	     </td> 
	</tr>
	<tr>
		 <td class="label" id="tdDireccion"> 
	     	<label for="direccionCompleta">Direcci&oacute;n Completa: </label> 
	     </td> 
		<td nowrap="nowrap" colspan="3">
			<textarea id="direccionCompleta" name="direccionCompleta" cols="50" rows="6" tabindex="26" 
				disabled ="true" readonly="true"  onBlur=" ponerMayusculas(this)" maxlength = "500"></textarea>
			<input type="button" name="verMapa" value="Ver Mapa" id="verMapa" class="submit">
		</td>
		<td colspan="2" id="tdDireccionMapa">
			<input type="hidden" name="direccionMapa" value="" id="direccionMapa" size="50">
		</td>
	</tr> 
 </table>
  <table width="100%">
		<tr>
			<td align="right">
				<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="27"/>
			<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="28"/>
			<input type="submit" id="elimina" name="elimina" class="submit" value="Eliminar" tabindex="29"/>
			<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
			<input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>" />
			<input type="hidden" id="valorResidentesExt" name="valorResidentesExt"/>
			</td>
		</tr>
	</table>
 </fieldset>
<div id="mapDiv" style="display: none;"></div>
		
</form:form> 

</div> 
<div id="cargando" style="display: none;"></div>	
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
	<div id="elementoListaCte"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
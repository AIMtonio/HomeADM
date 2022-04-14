<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
<head>	
		<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>                                                                                                                                                 	
      	<script type="text/javascript" src="js/cliente/direcClienteCatalogo.js"></script> 
        <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>  
      	<script type="text/javascript" src="js/cliente/actualizaPromotorAct.js"></script> 
      	
</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cliente">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Actualizar Promotor del <s:message code="safilocale.cliente"/></legend>			
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td class="label"> 
	         <label for="clienteID">No. de <s:message code="safilocale.cliente"/>: </label> 
		</td>
	    <td nowrap="nowrap">
	    	<form:input id="numero" name="numero" path="numero" size="15" tabindex="1" iniforma='false' />  
	        <input type="text" id="nombreCliente" name="nombreCliente" size="50" tabindex="2" disabled= "false" 
	          readonly="true" iniforma='false'/>  
		</td> 
	</tr> 

  <tr>
    <td class="label"> 
	         <label for="fechaNacimiento">Fecha de Nacimiento: </label> 
	     </td> 
	     <td nowrap="nowrap"> 
	         <form:input id="fechaNacimiento" name="fechaNacimiento" path="fechaNacimiento" size="15" tabindex="3" readOnly="true"/> 
	     </td> 
   </tr>
   
   
	 <tr>
	  <td class="label"> 
	         <label for="direccionCompleta">Direcci&oacute;n: </label> 
	     </td> 
		<td nowrap="nowrap" colspan="3">
			<textarea id="direccionCompleta" name="direccionCompleta" path="direccionCompleta" cols="50" rows="6" tabindex="4" 
				disabled ="true" readonly="false"  onBlur=" ponerMayusculas(this)"></textarea>
		</td>
	</tr> 
	
   <tr>
		<td class="label"> 
	         <label for="sucursalID">Sucursal <s:message code="safilocale.cliente"/>: </label> 
		</td>
	    <td nowrap="nowrap">
	    	<form:input id="sucursalID" name="sucursalID" path="sucursalID" size="15" tabindex="5" readOnly="true" />  
	        <input type="text" id="nombreSucursal" name="nombreSucursal" size="50" tabindex="6" disabled= "false" 
	          readonly="true" iniforma='false'/>  
		</td> 
	</tr> 
	
	 <tr>
		<td class="label"> 
	         <label for="promotorAct">Promotor Actual: </label> 
		</td>
	    <td nowrap="nowrap">
	    	<form:input id="promotorAct" name="promotorAct" path="promotorAct" size="15" tabindex="7"  readOnly="true"/>  
	        <input type="text" id="nombrePromotor" name="nombrePromotor" size="50" tabindex="8" disabled= "false" 
	          readonly="true" iniforma='false'/>  
		</td> 
	</tr> 
	
	 <tr>
		<td class="label"> 
	         <label for="sucursalCliente">Promotor Nuevo: </label> 
		</td>
	    <td nowrap="nowrap">
	    	<form:input id="promotorNue" name="promotorNue" path="promotorNue" size="15" tabindex="9" />  
	        <input type="text" id="nombPromotorNue" name="nombPromotorNue"  size="50" tabindex="10" disabled= "false" 
	          readonly="true" iniforma='false'/>  
		</td> 
	</tr> 
	
	<tr>
		<td align="right" colspan="5">
			<input type="submit" id="modifica" name="modifica" class="submit" value="Guardar" tabindex="11"/>
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

  

  
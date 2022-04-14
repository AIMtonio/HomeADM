<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
<head>	
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
    <script type="text/javascript" src="js/cliente/reporteDireccionesCliente.js"></script> 
</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cliente">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Direcciones del <s:message code="safilocale.cliente"/></legend>			
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td class="label"> 
	         <label for="clienteID"><s:message code="safilocale.cliente"/>: </label> 
		</td>
	    <td nowrap="nowrap">
	    	<form:input type="text" id="numero" name="numero" path="numero" size="15" tabindex="1" />  
	        <input type="text" id="nombreCliente" name="nombreCliente" size="50" tabindex="2" disabled= "true" 
	          readonly="true" />  
		</td> 
	    <td class="separador"></td> 
		<td class="label"> 
	         <label for="lblGenero">Género: </label> 
		</td>
	    <td nowrap="nowrap">
	        <input type="text" id="sexo" name="sexo" size="20" tabindex="3" disabled= "true" 
	          readonly="true" />  
		</td> 
	</tr>  
	<tr>
		<td class="label"> 
	     	<label for="lbltipoper">Tipo Persona: </label> 
	    </td> 
	    <td  nowrap="nowrap"> 
	    	<input type="text" id="tipoPersona" name="tipoPersona" size="50" tabindex="2"  disabled="disabled"/>
	    </td> 
		
	    <td class="separador"></td> 
		<td class="label"> 
	     	<label for="lblEstadoCivil">Estado Civil: </label> 
	    </td> 
	    <td  nowrap="nowrap"> 
	    	<input type="text" id="estadoCivil" name="estadoCivil" size="50" tabindex="4"  disabled="disabled"/>
	    </td> 
	</tr>  
	<tr>
		<td align="right" colspan="5">
			<input type="button" id="generar" name="generar" class="submit" value="Generar" tabindex="23"/>
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

  

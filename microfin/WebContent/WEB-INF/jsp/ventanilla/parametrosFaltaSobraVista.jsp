<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>		
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>   
		<script type="text/javascript" src="dwr/interface/paramFaltaSobraServicio.js"></script>       	 	
		<script type="text/javascript" src="js/ventanilla/parametrosFaltaSobra.js"></script>   		     
	</head>
   
<body>
<div id="contenedorForma">													  
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="paramFaltaSobraBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Parámetros Faltantes y Sobrantes</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		
		<tr> 
			<td class="label"> 
		    	<label for=lblSucursal>Sucursal:</label> 
			</td> 		     		
			<td> 
	         	<form:input id="sucursalID" name="sucursalID" path="sucursalID" size="15"  maxlength="9" tabindex="2"/>
	         	<input id="nombreSucursal" name="nombreSucursal" size="50"  type="text" readonly="true" />  
	     	</td>					   			   	
		    <td class="separador"></td> 		   
		</tr>		
		<tr> 					   			   		   
		   	<td class="label"> 
		    	<label for="lblMontoMaximoSobra">Monto Máximo Sobrante: </label> 
			</td> 
		    <td> 
		    	<form:input id="montoMaximoSobra" name="montoMaximoSobra" path="montoMaximoSobra" size="15" tabindex="3"
		    		esMoneda="true" style="text-align: right" />
			</td>
			 <td class="separador"></td>
			 <td class="label"> 
		    	<label for="lblMontoMaximoSobra">Monto Máximo Faltante: </label> 
			</td> 
		    <td> 
		    	<form:input id="montoMaximoFalta" name="montoMaximoFalta" path="montoMaximoFalta" size="15" tabindex="4" 
		    		esMoneda="true" style="text-align: right"/>
			</td> 
		</tr>
	</table>

	<table align="right">
		<tr>
			<td align="right">				
				<input type="submit" id="guardar" name="guardar" class="submit" value="Guardar" tabindex="50"/>	
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>						
			</td>
		</tr>
	</table>

</form:form>
</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
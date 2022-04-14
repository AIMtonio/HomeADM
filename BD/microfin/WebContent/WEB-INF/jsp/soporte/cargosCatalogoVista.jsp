 <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
		<script type="text/javascript" src="dwr/interface/cargosServicio.js"></script>   
 	   <script type="text/javascript" src="js/soporte/cargosCatalogo.js"></script>  

</head>
<body>

<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cargos">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
			<legend class="ui-widget ui-widget-header ui-corner-all">Cargos</legend>	
			<table>
				<tr>
			    	<td class="label"> 
			        	<label for="cargoID">Número: </label> 
			     	</td>
		     		<td>
						<form:input id="cargoID" name="cargoID" path="cargoID" size="10" tabindex="1" iniforma="false" /> 
		    		</td> 		
	 			</tr> 
	 			<tr> 
	    			<td class="label"> 
	          			<label for="descripcionCargo">Descripción: </label> 
	     			</td> 
	     			<td> 
	       				<form:input id="descripcionCargo" name="descripcionCargo" size="50" path="descripcionCargo" tabindex="2" maxlength='50' onBlur=" ponerMayusculas(this)"/>
	     			</td> 
	  			</tr>  
	 		</table>
			<table align="right">
				<tr>
					<td align="right">
						<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="3"/>
						<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="4"/>
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					</td>
				</tr>
			</table>	
		</fieldset> 
	</form:form> 

</div> 
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;position:absolute; z-index:999;"/ -->
</html>

  


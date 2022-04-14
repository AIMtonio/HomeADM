<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>

	<head>	
		  
        <script type="text/javascript" src="dwr/interface/permisosContablesServicio.js"></script>  
        <script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>  
		  <script type="text/javascript" src="js/contabilidad/permisosContablesCatalogo.js"></script>
	</head>
   
<body>

<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Permisos Contables</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="permisosContablesBean">  	
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					
				 	<tr>
				    	<td class="label"> 
				         <label for="lblUsuarioID">Usuario:</label> 
				     	</td> 
				     	<td> 
				      	<form:input id="usuarioID" name="usuarioID" path="usuarioID" size="3" 
				         	tabindex="1" />  
			         	<input id="nomUsu" name="nomUsu" path="nomUsu" size="80" 
				         	tabindex="2" disabled="true"/>  
				     	</td>
				 	</tr> 	
				 	<tr> 
						<td class="separador"></td> 
				      <td class="label">
					     	<form:input type="checkbox"  id="afectacionFeVa" name="afectacionFeVa"
					     				path="afectacionFeVa" value="S" tabindex="6" />
					     	<label for="lblafectacionFeVa">Afectaciones Fecha Valor.</label> 
						</td>
					</tr> 
					<tr> 
						<td class="separador"></td> 	     			
		     			<td class="label"> 
				         <form:input type="checkbox" id="cierreEjercicio" name="cierreEjercicio" 
				         			path="cierreEjercicio" value="S" tabindex="7" /> 
				         <label for="lblcierreEjercicio">Cierre del Ejercicio.</label> 
				     	</td> 
				   </tr> 
					<tr> 
						<td class="separador"></td> 
				      <td class="label"> 
				         <form:input type="checkbox" id="cierrePeriodo" name="cierrePeriodo" 
				         		path="cierrePeriodo" value="S" tabindex="8"/> 
				         <label for="lblcierrePeriodo">Cierre del Periodo.</label> 
				     	</td> 
				 	</tr> 
		
					<tr> 
						<td class="separador"></td> 
				     	<td class="label"> 
				         <form:input type="checkbox" id="modificaPolizas" name="modificaPolizas" 
				         		path="modificaPolizas" value="S" tabindex="9" /> 
				         <label for="lblmodificaPolizas">Modificar Polizas.</label> 
				     	</td> 
				   </tr> 
					</table>
					<table border="0" cellpadding="0" cellspacing="0" width="100%"> 
						<tr>
						<td colspan="5">
							<table align="right">
								<tr>
									<td align="right">
										<input type="submit" id="agrega" name="agrega" class="submit" value="Agrega" />
										<input type="submit" id="modifica" name="modifica" class="submit"  value="Modifica"/>
										<input type="submit" id="eliminar" name="eliminar" class="submit"  value="Eliminar"/>
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>				
									</td>
								</tr>
							</table>		
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
<div id="mensaje" style="display: none;"/>
</html>
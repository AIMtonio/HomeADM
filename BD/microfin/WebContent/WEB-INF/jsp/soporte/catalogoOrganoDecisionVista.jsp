<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>		
		 <script type="text/javascript" src="dwr/interface/organoDecisionServicio.js"></script>  		      
	      <script type="text/javascript" src="js/soporte/catalogoOrganoDecision.js"></script>
       
	</head>
   
<body>
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="organosDecision">
																			  
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Facultados</legend>
			
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label">
						<label for="organoID">Facultado: </label>
					</td> 
					<td >
						<form:input type="text" id="organoID" name="organoID" path="organoID" size="6" tabindex="1"  />						
					</td>
					
					<td class="separador"></td>
					
				   <td class="label">
					 <label for="descripcion">Descripción: </label>
					</td> 
				   <td >
					 	<form:input type="text" id="descripcion" name="descripcion" path="descripcion" size="50" tabindex="2" onBlur="ponerMayusculas(this)"/>
					</td>					
				</tr>						
		 </table>	
		 <br>
		<br>
		<table align="right">
				<tr>
					<td align="right">
						<input type="submit" id="grabarOrgDecision" name="grabarOrgDecision" class="submit" value="Grabar" tabindex="3"  />
						<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="4"  />
						<input type="submit" id="eliminar" name="eliminar" class="submit" value="Eliminar" tabindex="5"  />											
						<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>						
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>		
					</td>					
				</tr>
			</table>	
					
				
						 	
				
	<input type="hidden" id="datosOrganosDecision" name="datosOrganosDecision" size="100" />
	<div id="organoDecision" style="display: none;" ></div>	
												
			

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
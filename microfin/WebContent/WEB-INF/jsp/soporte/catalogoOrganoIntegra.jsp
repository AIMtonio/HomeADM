<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
	 	<script type="text/javascript" src="dwr/interface/organoDecisionServicio.js"></script> 	
		<script type="text/javascript" src="dwr/interface/organoIntegraServicio.js"></script>  		      
	    <script type="text/javascript" src="js/soporte/catalogoOrganoIntegra.js"></script>
       
	</head>
   
<body>
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="organoIntegra">
																			  
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Integrantes</legend>
			
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label"> 
						<label for="organoID">Facultado: </label> 
					</td>
					<td> 	
		       			 <select id="organoID" name="organoID"  tabindex="10" type="select" >
							<option value=" ">Seleccionar</option>
						</select>       					        	
					</td>	
					<td align="right">
					<input type="submit" id="guardar" name="guardar" class="submit" value="Guardar"/>	
						<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>						
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>		
					</td>			
				</tr>						
		 	</table>	
		 <br>
		<br>
			
		<input type="hidden" id="datosOrganoIntegra" name="datosOrganoIntegra" size="100" />
		<div id="organoIntegra" style="display: none;" ></div>	
	
					
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
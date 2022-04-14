<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
      
     <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
   	 <script type="text/javascript" src="js/pld/sociosAltoRiesgoRep.js"></script>  
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="sociosAltoRiesgoRepBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all"><s:message code="safilocale.cliente"/>s de Alto Riesgo</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="600px">
			<tr> 
				<td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Parámetros</label></legend>         
          				<table  border="0"  width="560px">							
							<tr>		
								<td class="label"> 
						        	<label for="lblSucursal">Sucursal: </label> 
						    	</td> 	
						   		<td nowrap= "nowrap"> 
							         <form:input id="sucursalID" name="sucursalID"  size="11" tabindex="3" path="sucursalID" maxlength="9" /> 
							         <input type="text" id="nombreSucursal" name="nombreSucursal" size="50"  tabindex="4"
							           readOnly="true"/>   
						 		 </td>		
							<tr>
						</table>
						
					</fieldset>  
					
						<tr>
							<td align="right">
								<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
								<a id="ligaGeneraRep"  target="_blank" >  		 
									 <input type="button" id="generar" name="generar" class="submit" 
											 tabIndex = "48" value="Generar" />
								</a>
							</td>						
						<tr>    			
				
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
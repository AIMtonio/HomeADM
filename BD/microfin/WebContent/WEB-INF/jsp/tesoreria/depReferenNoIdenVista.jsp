<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>	     
       <script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
	   <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	   <script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>
	   <script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script> 
	   <script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
	   <script type="text/javascript" src="js/tesoreria/depReferenciados.js"></script>
	   
	 </head>
   
<body>

 

<div id="contenedorForma">
<!-- Ligth box
    <div id="filter"></div>
<div id="box">
  <span id="boxtitle"></span>
   box -->
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Depositos Referenciados No Identificados</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tesoMovimientos">  	
			<table border="0" cellpadding="0" cellspacing="0" width="100%">     
				<tr>
				   	<td class="label"> 
				         <label for="lblinstitucionID">Instituci&oacute;n:</label> 
				     	</td>
				     	<td> 
		         		<input id="institucionID" name="institucionID" size="11" tabindex="1">
		         	</td> 
		         	<td> 			         	
		         		<input id="nombreInstitucion" name="nombreInstitucion" size="50" tabindex="1" disabled="true" readonly="true">
				   	</td>	
			 	</tr> 						 
				<tr>  
			    	<td class="label"> 
			        	<label for="lblcueNumCtaInstit">Cuenta Bancaria:</label> 
			     	</td>
			     	<td >
			     		<input type="text" id="cuentaAhorroID" name="cuentaAhorroID"  size="18"  tabindex="2" /> 
			     		<input type="hidden" id="numCtaInstit" name="numCtaInstit"  size="18"  value="s" />
			     	</td>  	
			     	<td >
			     		<input id="nombreSucurs" name="nombreSucurs"  size="25"  tabindex="2" disabled="true" readonly="true"/> 
			     	</td> 	
				</tr> 						
			</table>
			
			<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
				<tr>  
			   		<td >
			    		<br>
	       				<div id="contenedorDeps"></div>
			     		<br>
			     	</td>
			     		
				</tr> 	
			</table>	
			
			<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
				<tr>
					<td align="right">
						<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar"  tabindex="4"/>
					<!--  	<input type="submit" id="limpiar" name="limpiar" class="submit" value="Limpiar" tabindex="5"/>
						<input type="submit" id="cancelar" name="cancelar" class="submit" value="Cancelar" tabindex="6"/>
						-->
				      <input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					</td>
				</tr>
			</table>
				
				
		</form:form>
</fieldset>
</div> 

<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="mensaje" style="display: none;"> </div>
<div id="ContenedorAyuda" style="display: none;">
	<div id="elementoLista"></div>
</div>	

</body>
</html>
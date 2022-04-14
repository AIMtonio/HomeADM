<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
	<head>	
	  	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/clienteArchivosServicio.js"></script>  
		<script type="text/javascript" src="dwr/interface/tiposDocumentosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteArchivosServicio.js"></script>
		<script type="text/javascript" src="js/soporte/webcam.js"></script>		
		<script type="text/javascript" src="js/cliente/fotoCliente.js"></script>
		
	
	</head>
<body>
<div id="contenedorForma">


	
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="datosCliente">
	
	
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Foto <s:message code="safilocale.cliente"/> </legend>
						
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label"> 
			         	<label for="lblclienteID"><s:message code="safilocale.cliente"/>: </label> 
			      	</td>
			      	<td class="label"> 			    
						<input id="clienteID" name="clienteID"  size="12" tabindex="1"  />
						<input id="nombreCliente" name="nombreCliente"  size="50" tabindex="2" readonly/>
			    	 </td>	
			    	 <td class="separador"></td>
			    	<td class="label"> 
		         		<label for="tipoPersona">Tipo de Persona: </label> 
					</td>
		     		<td>
		         		<input id="tipoPersona" name="tipoPersona" size="25" tabindex="3" readOnly="true" readonly/>  
		     		</td>			 		   
		    	 </tr>
		    	 
<!-- 		    	 <tr> -->
<!-- 				    <td><input type ="button" id="buscarMiSuc" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/></td> -->
<!-- 					<td><input type ="button" id="buscarGeneral" name="buscarGeneral" value="Busqueda General" class="submit"/></td> -->
<!-- 		    	 </tr> -->
	
		        <tr>			      
			    	 <td class="label"> 
         				<label for="genero">G&eacute;nero: </label>  
     				</td>
     				<td>
         				<input id="sexo" name="sexo" size="25" tabindex="4" readOnly="true" readonly/>  
      				</td>	
      				 <td class="separador"></td>
      				<td class="label"> 
         				<label for="fechaNac">Fecha de Nacimiento: </label> 
     				</td> 
     				<td>
         				<input id="fechaNacimiento" name="fechaNacimiento" size="25"  tabindex="5" readOnly="true"readonly/>          
      				</td>		       
		   		</tr>
		   		 <tr>
			        
			     	
			    	 <td class="label"> 
         				<label for="telefono">Tel&eacute;fono: </label> 
     				</td> 
     				<td>
         				<input id="telefonoCasa" name="telefonoCasa" size="25" readOnly="true"  tabindex="7" readonly/>  
      				</td>   
      				 <td class="separador"></td>
			    	  <td class="label"> 
        				<label for="tipoDocumento">Tipo de Documento:</label> 
     				</td> 
     				<td> 
						<select id="tipoDocumento" name="tipoDocumento" tabindex="5"  tabindex="8" >
							<option value="1">IMAGEN</option>			
						</select>     
     				</td>			    	 	      
		   		</tr>		   			   		
		   		 <tr>
			        
     			
     				<td class="label"> 
			        	<label for="observacion">Observaci&oacute;n: </label> 
			     	</td>
			      	<td colspan = "3">
			      		<textarea id="observacion" name="observacion" cols="35" rows="3" tabindex="6" onBlur=" ponerMayusculas(this)"></textarea>
			      	</td>
			      	<td>
			      		<input type="hidden" name="recurso" id="recurso" readOnly="readonly" value="" />
			      	</td>
			     					       
		   		</tr>
		   		<tr>
					
			      	
			      	<td colspan = "3">
			        	<input type="hidden" name="extension" id="extension" readOnly="readonly" />
			       	</td>
			       	<td>
			        	<input id="archivoClientID" name="archivoClientID" size="10" tabindex="4" 
			        		type="hidden"  readOnly="readonly"/>
			        </td> 
			        
			        
     		   </tr>
  		</table>  		
  		<table border="0" cellpadding="0" cellspacing="0" width="100%" >
		<tr>
			<td style="text-align: left; vertical-align: top;" colspan="5">
	
				<embed id="webcam_movie" src="js/soporte/webcam.swf" loop="false" menu="false"
					   quality="best" bgcolor="#ffffff" width="320" height="240" name="webcam_movie"
					   align="middle" allowScriptAccess="always" allowFullScreen="false"
					   type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer"
					   flashvars="shutter_enabled=0&shutter_url=shutter.mp3&width=320&height=240&server_width=320&server_height=240" />
	
			</td>
		</tr>
		<tr>	
		<td colspan = "3">
			<align="left">
				<input type ="button" id="tomarFoto" name="tomarFoto" value="Tomar Fotografía" class="submit"/>				
			<align="left">
				<input type ="button" id="cancelaToma" name="cancelaToma" value="Tomar de Nuevo" class="submit"/>
		
		
			<align="right" colspan="3">
						<input type ="button" id="grabar" name="grabar" class="submit" value="Grabar"/>
		
			</td>
		</tr>
	</table>  			 	  
		<table align="right">
			<tr>
				<td align="right">					
					<input type="hidden" id="tipoActualizacion" name="tipoActualizacion" value="0"/>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"  value="0" />
				</td>

			</tr>										  										
	  </table>
	  <input type="hidden" name="prospectoID" id="prospectoID" readOnly="readonly" value="" /> 
	  <input type="hidden" name="recursoConsultado" id="recursoConsultado" readOnly="readonly" value="" />
	   <input type="hidden" name="clienteArchivosID" id="clienteArchivosID" readOnly="readonly" value="" />
	   
	</fieldset>
	</form:form>

	

</div>


<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
	<div id="elementoListaCte"></div>
</div>
</body>
<div id="mensaje" style="display:none;"></div> 	
</html>
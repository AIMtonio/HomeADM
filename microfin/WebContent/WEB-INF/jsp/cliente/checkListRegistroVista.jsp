<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
	<head>	
	
	  	<script type="text/javascript" src="dwr/interface/clienteArchivosServicio.js"></script> 
	  	<script type="text/javascript" src="dwr/interface/clasificaGrpDoctosServicio.js"></script> 
	  	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
		<script type="text/javascript" src="js/cliente/checkListRegistroVista.js"></script>
		
		
		
	
	</head>
<body>
<div id="contenedorForma">	
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="check">
	
	
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Check List de Registro</legend>
						
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label"> 
			         	<label for="lblclienteID"><s:message code="safilocale.cliente"/>: </label> 
			      	</td>
			      	<td class="label"> 			    
						<input id="clienteID" name="clienteID"  size="12" tabindex="1"  />
						<input id="nombreCliente" name="nombreCliente"  size="50"  readOnly="true"/>
			    	 </td>	
			    	 <td class="separador"></td>
			    	<td class="label"> 
		         		<label for="tipoPersona">Tipo de Persona: </label> 
					</td>
		     		<td>
		         		<input id="tipoPersona" name="tipoPersona" size="25" readOnly="true"/>  
		     		</td>			 		   
		    	 </tr>
	
		        <tr>			      
			    	 <td class="label"> 
         				<label for="genero">G&eacute;nero: </label>  
     				</td>
     				<td>
         				<input id="sexo" name="sexo" size="25"  readOnly="true"/>  
      				</td>	
      				 <td class="separador"></td>
      				<td class="label"> 
         				<label for="fechaNac">Fecha de Nacimiento: </label> 
     				</td> 
     				<td>
         				<input id="fechaNacimiento" name="fechaNacimiento" size="25"   readOnly="true"/>          
      				</td>		       
		   		</tr>
		   		 <tr>
			    	 <td class="label"> 
         				<label for="telefono">Tel&eacute;fono: </label> 
     				</td> 
     				<td>
         				<input id="telefono" name="telefono" size="25" readOnly="true" />  
      				</td>   
			    </tr> 		 		
		   	
  		</table>  	
  		<br>
		<br>
		 <input type="hidden" id="datosGridDocEnt" name="datosGridDocEnt" size="100" />										
				
			<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldsetDocEnt" style="display: none;">                
				<legend>Documentos</legend>	
				<table align="right">
					<tr>
						<div id="documentosEnt" style="display: none;" ></div>	
						<td class="label">							
				      			<input type="button" class="submit" id="expediente" name="expediente" tabindex="16" value="Expediente" style='height:30px;'/> 
									
			  			</td> 
						<td align="right">	
						<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="17" />		
						<input type="hidden" id="instrumento" name="instrumento"  />	
						<input type="hidden" id="tipoInstrumento" name="tipoInstrumento" />		
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />		
										
						</td>				
					</tr>
				</table>
			 </fieldset>			 	  	 
	</fieldset>
	</form:form>	
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display:none;"></div> 	
</html>

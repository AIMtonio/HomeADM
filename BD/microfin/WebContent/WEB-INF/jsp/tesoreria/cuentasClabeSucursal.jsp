<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>	     
      <script type="text/javascript" src="dwr/engine.js"></script>
      <script type="text/javascript" src="dwr/util.js"></script>   
      <script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
      <script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script> 
       <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
          <script type="text/javascript" src="dwr/interface/reqGastosSucServicio.js"></script>
	
	  <script type="text/javascript" src="js/forma.js"></script>
	  <script type="text/javascript" src="js/tesoreria/cuentasClabeSucursal.js"></script>
      
	</head>
   
<body>

<div id="contenedorForma">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Alta de Cuentas de Sucursal</legend>
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentasAhoSucur"> 	<!-- 	<fieldset class="ui-widget ui-widget-content ui-corner-all">   -->         
  
   


					<table border="0" cellpadding="0" cellspacing="0" width="100%">  
						<tr> 
						      <td> <input type="radio" id="radioAlta" name="branch" value="EC" /> <label for="lblnumCtaClabe">Nueva Cuenta</label>  </td>
							   <td><input type="radio" id="radioModifica" name="branch" value="EC"/> <label for="lblnumCtaClabe">Modificar Cuentas</label>  </td>
							</tr>		   
						 <tr>	
					     	<td class="label"> <br>
					         <label for="lblnumCtaAhorro">Sucursal:</label> 
					         <td>
					         <br>
					     	 <form:input id="sucursalID" name="sucursalID" path="sucursalID" size="11" tabindex="1" /> 		         	
			         		<input id="nombreSucursal" name="nombreSucursal" size="50" tabindex="1" disabled="true" readonly="true"/>
					        	
					      </td>   		 
					     	</td>  	
					     		
						</tr>  	
					
						<tr>
					   	<td class="label"> 
					         <label for="lblinstitucionID">Instituci&oacute;n:</label> 
					     	</td>
					     	<td> 
			         		
			         		 <form:input id="institucionID" name="institucionID" path="institucionID" size="11" tabindex="2" /> 		         	
			         		<input id="nombreInstitucion" name="nombreInstitucion" size="50" tabindex="1" disabled="true" readonly="true"/>
								
					     	</td> 
					     		<!-- <td class="separador"></td> -->
					    				    			     		
					   </tr>
							<tr>
												
							</tr>
 
									
						<tr>
					      <td class="label"> 
					         <label for="lblnumCtaClabe">Cuenta Clabe:</label> 
					     	</td>
					     	<td >
					     		
					           <form:input id="cueClave" name="cueClave" path="cueClave" size="38" tabindex="3" maxlength="18" /> 
					          <input type="button" id="editaCta" name="editaCta" class="submit"  value="Editar"/>
								 <form:input type="hidden" id="cuentaSucurID" name="cuentaSucurID" path="cuentaSucurID" value="0"/>
					      </td>   		 		
					     	 
					    </tr>
                 							
						<tr>
					      <td > 
					   
					     	</td>
					     	<td >
					     		
					           <input id="editaClave" name="editaClave" path="editaClave" size="38"  maxlength="18" /> 	
					           			
					      </td>   		 		
					     	 
					    </tr>
					    <tr>	
					     	<td class="label"> 
					         <label for="lblchequera">Cuenta Principal:</label> 
					     	</td>
					     	<td>
					         <input type="checkbox" id="esPrincipalChk" name="esPrincipalChk" value="N"/> 
					       
					        <input type="hidden" id="cuentaPrincipalID" name="cuentaPrincipalID" value="0" />
 				            <input type="hidden" id="esPrincipal" name="esPrincipal" value="N" />
 				                         	                  	     
					     </td>
						</tr> 
                   <tr>
                     <td class="label">
                      <label for="lblnombreSucursal">Estatus:</label>
                     </td> 
                     <td>
                   
					    <form:select id="estatus" name="estatus" path="estatus"  tabindex="6" >
					    <form:option value="A">Activa</form:option>
					    <form:option value="I">Inactiva</form:option>
					    </form:select> 	
                     </td>
                   </tr>						
											  
					    
					</table>
					
               <br>
					
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
					      <input type="submit" id="agrega" name="agrega" class="submit" value="Agrega"/>
							<input type="submit" id="modifica" name="modifica" class="submit"  value="Modifica"/>
							
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
	                    
							</td>
						</tr>
					</table>
				<!-- </fieldset> -->
				
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
	<div id="elementoLista"/>
</div>	

</body>
</html>
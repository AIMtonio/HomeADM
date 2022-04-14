<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
      <script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>                 
 	   <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
 	   <script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>  
		<script type="text/javascript" src="dwr/interface/creditoDocEntServicio.js"></script>  
		<script type="text/javascript" src="dwr/interface/creditoArchivoServicio.js"></script>  
	    <script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>  
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script> 
		  
      <script type="text/javascript" src="js/fira/creditoAutoriza.js"></script> 
          
	</head>
   
<body>
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditos">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Mesa de Control Crédito Individual</legend>
						
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
			<td class="label">
				<label for="credito">Número: </label>
			</td> 
			<td >
				<form:input type="text" id="creditoID" name="creditoID" path="creditoID" size="12" tabindex="1"  />
				
			</td>
			
			<td class="separador"></td>
			
		   <td class="label">
			 <label for="lineaCred">Línea de Crédito: </label>
			</td> 
		   <td >
			 	<form:input type="text" id="lineaCreditoID" name="lineaCreditoID" path="lineaCreditoID" size="10" 
			 	readOnly= "true" disabled = "true" tabindex="2"/>
			</td>					
		</tr>
		
		<tr>
			<td class="label">
				<label for="Cliente"><s:message code="safilocale.cliente"/>: </label>
			</td> 
			<td >
				<form:input type="text"  id="clienteID" name="clienteID" path="clienteID" size="11" tabindex="3" disabled="true" />
				<input type="text" id="nombreCliente" name="nombreCliente" tabindex="4" disabled="true" size="50"/> 
			</td>
			
			<td class="separador"></td>
			<td class="label">
			 	<label for="lineaCred">Producto de Crédito: </label>
			</td> 
		   <td>
			 	<form:input type="text" id="producCreditoID" name="producCreditoID" path="producCreditoID" size="5" tabindex="5" 
			 	disabled="true"/>
			 	<input type="text" id="nombreProd" name="nombreProd" tabindex="6" disabled="true" size="45" /> 
			</td>  				
		</tr>
		<tr>
 			<td class="label">
				<label for="Cuenta">Cuenta: </label>
			</td> 
		   <td>
		  		<form:input type="text" id="cuentaID" name="cuentaID" path="cuentaID" size="10" tabindex="7" disabled="true"/>
				<input type="text" id="desCuenta" name="desCuenta" tabindex="8" disabled="true" size="30"/> 	
			</td>		
			<td class="separador"></td> 
			<td class="label">
			 	<label for="Cuenta">Monto: </label>
			</td> 
		  	<td>
		   	<form:input type="text" id="montoCredito" name="montoCredito" path="montoCredito" size="10" tabindex="9" disabled="true"/>
			</td>			

		</tr>
		
		<tr>
			<td class="label">
				<label for="FechaInic">Fecha de Inicio : </label> 
			</td>
		   <td >
			 	<form:input type="text" id="fechaInicio" name="fechaInicio" path="fechaInicio" size="16" tabindex="10" disabled="true" />
			</td>	
		   <td class="separador"></td> 
			<td class="label">
			<label for="FechaVencimiento">Fecha de Vencimiento: </label> 
			</td>
		   <td>
			 	<form:input type="text" id="fechaVencimien" name="fechaVencimien" path="fechaVencimien" size="18" tabindex="11" disabled="true"/>
			</td>
		 </tr>   
		 <tr>  
			<td class="label"> 
		   	<label for="lblfechaAutoriza">Fecha de Autorización: </label>  
		   </td> 
		   <td> 
		   <form:input  id="fechaAutoriza" name="fechaAutoriza" path="fechaAutoriza" size="12" type="text"	tabindex="12" readOnly="true" disabled = "true" />  
		   </td>
		 	<td class="separador"></td> 
		 	<td class="label"> 
		     	<label for="lblusuario">Usuario: </label> 
		   </td> 
		   <td> 
		       <form:input type="text" id="usuarioAutoriza" name="usuarioAutoriza" path="usuarioAutoriza" size="12" 
		         	 		tabindex="13" readOnly="true" disabled="true"/>  
         	 <input  type="text" id="nombreUsuario" name="nombreUsuario"size="40" readOnly="true" disabled="true" tabindex="14"/>
		   </td>
		  </tr> 
		  <tr> 
		  		<td class="label"> 
					<label for="lblEstatus">Estatus: </label> 
				</td>   	
				<td> 
		   		<input type="text" id="estatus" name="estatus" path="estatus" size="12" tabindex="15"  readOnly="true" disabled="true"/>
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
				      			<input type="button" class="submit" id="expediente" name="expediente" tabindex="16" value="Expediente Cred" style='height:30px;'/> 
									
							
			  			</td> 
						<td align="right">	
						<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="17" />							
						</td>				
					</tr>
				</table>
			 </fieldset>
			 <br>
			<br>
			 <div id="divComentarios" style="display: none;">
			 <fieldset class="ui-widget ui-widget-content ui-corner-all" >                
				<legend>Comentarios para la Mesa de Control</legend>	
				<table >
					<tr>
						<td class="label" > 
							<label for="lblComentarioEjec" id="Comentariolbl">Comentarios: </label> 
						</td>  	
						<td> 
		      				<form:textarea  id="comentarioMesaControl" name="comentarioMesaControl" path="comentarioMesaControl" tabindex="18" COLS="50" ROWS="4" onBlur=" ponerMayusculas(this);" disabled="true" />
		     			</td> 
		     			<td class="separador" id="separador"></td>
		     			<td class="label" > 
							<label for="lblComentario">Comentarios: </label> 
						</td> 
		     			<td> 
		      				<form:textarea  id="comentarioCond" name="comentarioCond" path="comentarioCond" tabindex="18" COLS="50" ROWS="4" onBlur=" ponerMayusculas(this);  limpiarCajaTexto(this.id);" disabled="false" maxlength="500"  />
		     			</td> 
								
					</tr>
				</table>
			 </fieldset>
			 </div>
			 
		
				
			<table align="right">
				<tr>						
					<td align="right">
						<input type="submit" id="condicionar" name="condicionar" class="submit" value="Condicionar" style="display: none;"  />
						<input type="submit" id="autorizar" name="autorizar" class="submit" value="Autorizar" tabindex="5"  />
						<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>	
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>		
						<input type="hidden" id="tipoOperacion" name="tipoOperacion" value="tipoOperacion"/>
						<input type="hidden" id="estCondicionado" name="estCondicionado" value="estCondicionado"/>
						<input type="hidden" id="solicitudCreditoID" name="solicitudCreditoID" value="solicitudCreditoID"/>						
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